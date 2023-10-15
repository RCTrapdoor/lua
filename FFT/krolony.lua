Krolony = {}

pi = math.pi

---@diagnostic disable:unbalanced-assignments
---@section Fourier 1 FOURIERCLASS
Krolony.Fourier = {
	---@section convolutions 1 CONVOLUTIONCLASS
	convolutions = {
		---@section fftConvolve
		---FFT convolution, quite expensive for low kernel sizes but very efficient for large convolutions
		---@param signalIn table signal to process
		---@param kernelIn table kernel used to process
		---@param fftModule function pass it some FFT function with which it's going to do convolution
		---@return table complex values inside this table are complex, you can either extract the reals or do something else, you're using FFT convolution for a reason
		fftConvolve = function(signalIn, kernelIn, fftModule)
			if UniqueNameFFTConvolveMemoryKrolon == nil then UniqueNameFFTConvolveMemoryKrolon = { signal = {},
					kernel = {} } end
			local typeS, typeK, fallback, mem, sR, sIm, kR, kIm = math.type(signalIn[1]), math.type(kernelIn[1]),
				{ real = 0 }, UniqueNameFFTConvolveMemoryKrolon
			local signal, kernel, N = mem.signal, mem.kernel, #signalIn + (typeS and 0 or 1) + #kernelIn +
				(typeK and 0 or 1) - 1

			for i = 0, N - 1 do
				if signal[i] == nil then signal[i] = {} end
				if kernel[i] == nil then kernel[i] = {} end

				signal[i].real = typeS and (signalIn[i + 1] or 0) or (signalIn[i] or fallback).real
				signal[i].imag = not typeS and (signalIn[i] or fallback).imag or 0

				kernel[i].real = typeK and (kernelIn[i + 1] or 0) or (kernelIn[i] or fallback).real
				kernel[i].imag = not typeK and (kernelIn[i] or fallback).imag or 0
			end

			--converting to frequency domain
			signal = fftModule(signal)
			kernel = fftModule(kernel, false, true)

			--pointwise multiplication
			N = signal.N
			for i = 0, N - 1 do
				sR = signal[i].real
				sIm = signal[i].imag
				kR = kernel[i].real
				kIm = kernel[i].imag

				--times N due to internal fft normalization of both signal in kernel causing way too small output
				signal[i].real = sR * kR - sIm * kIm --real times real minus imaginary times imaginary
				signal[i].imag = sR * kIm + sIm * kR --real times imaginary plus imaginary times real
			end

			signal = fftModule(signal, true)
			signal.f = kernelIn.f

			return signal
		end,
		---@endsection

		---@section createWavelet
		---creates a morlet wavelet, centered at half of the table, has internal normalization so that the total area is around 1
		---@param f number frequency of the wavelet
		---@param N number integer, amount of datapoints, don't leave it too low
		---@param width number defaults to 1, how wide it is, width of 1 is good for up to a second, 2 lasts 2 seconds etc, also affects time/frequency resolution
		---@param tps number how many ticks there are per second, in stormworks it's 60 and so can be left blank, defaults to 60
		---@return table complex wavelet inside is a true morlet wavelet, so it's a complex table
		createWavelet = function(f, N, width, tps)
			local tau, kernel, normal, width, tps, x, r, im, plane = 2 * math.pi, { f = f, N = N }, 1 / 12 / (width or 1),
				0.5 / (width or 1) ^ 2, tps or 60
			for i = 0, N - 1 do
				x = ((i - (N - 1) / 2) * tau) / tps
				--I'm really happy I did it like that because now I can just have fun with X and not touch e again
				plane = normal * math.exp(-width * x ^ 2)
				r = math.cos(x * f) * plane
				im = math.sin(x * f) * plane
				kernel[i] = { real = r, imag = im }
			end
			return kernel
		end,
		---@endsection

		---@section genWaveletKernelSize
		---outputs the size for createWavelet() at which some required accuracy is achieved
		---@param treshold number 0-1 range, drives the math to output N at which the edges have amplitude of this treshold (relative to peak, it has normalization)
		---@param width number same as in createWavelet(), defaults to 1
		---@param tps number same as in createWavelet(), defaults to 60
		---@return number N
		genWaveletKernelSize = function(treshold, width, tps)
			local width, tps = 0.5 / (width or 1) ^ 2, tps or 60
			return 2 * (tps * math.sqrt(math.log(treshold) / (-width * 4 * math.pi ^ 2)) // 1) + 1
		end,
		---@endsection

		---@section pruneEnds
		---prunes the output of convolution at both start and end of the table, used to match with the original signal size
		---@param t table table to prune
		---@param startAt number integer, output table starts at index startAt of old table
		---@param endAt number integer, how many values new table will have
		pruneEnds = function(t, startAt, endAt)
			for i = t[0] and 0 or 1, #t do
				t[i] = i <= endAt and t[i + startAt] or nil
			end
			t.N = endAt + (t[0] and 1 or 0)
		end,
		---@endsection
	},
	---@endsection CONVOLUTIONCLASS

	---@section getAmplitudes
	---gets the amplitudes from a complex table
	---@param fhat table complex table, output of FFT
	---@return table amplitudes amplitudes of input complex table
	---@return number peak peak amplitude
	getAmplitudes = function(fhat)
		--formula for frequency is k/(N*dT), can be done in a loop after using this function to to get amplitudes of frequqncies
		--dT for stormworks is 1/60
		local amp, peak, maths = { N = fhat.N, f = fhat.f }, 0
		for i = 0, fhat.N - 1 do
			maths = (fhat[i].real ^ 2 + fhat[i].imag ^ 2) ^ 0.5
			amp[i] = maths
			peak = math.max(peak, maths)
		end
		return amp, peak
	end,
	---@endsection

	---@section fftUniRadix
	---Around 1200 chars minified.
	---Universal composite Radix FFT, allowed radixes: 2, 3, 5, 7.
	---If you really need higher or different ones, feed customRadiCes.
	---Warning: higher radices in this unoptimized but compact-ish FFT are getting extremely laggy, 7 is already in diminishin returns range, but increases possible N-points density.
	---You will not reverse-engineer it without looking at a flowgraph, if you do then o7.
	---Works on compact, but never truly optimal, universal radix core.
	---Optimized to not produce garbage, thus avoiding garbage collector lag hugely increasing performance.
	---Can take either 1-indexed tables {1,2,3,4} or 0-indexed(!!!) complex values {{real=1,imag=0},{real=2,imag=0},{real=3,imag=0},{real=4,imag=0}}.
	---Will 0-pad to nearest possible N-size when fed with typical table for input.
	---Will only output 0-indexed complex values, even if they represent just the real values
	---@param input table 1-indexed numbers or 0-indexed complex values
	---@param inverse boolean flag for inverse transform
	---@param disableAutoNormalization boolean default false, flag to disable normalization (which happens only on forward transform)
	---@param customRadices table table of numbers to be used as radices, defaults to {2,3,5,7}
	---@return table complex complex table, FFT output
	fftUniRadix = function(input, inverse, disableAutoNormalization, customRadices)
		local fftSize = function(origN, customRadix)
			--imperfect but compact-ish and very fast way of finding (well, not so) closest next possible N size
			local N, possiblefactors, factors, check = origN, { 2, 3, 5, 7 }, {}
			while N > 1 do
				check = true
				for i, factor in pairs(customRadix or possiblefactors) do
					if N % factor == 0 then
						check = false
						N = N / factor
						table.insert(factors, factor)
					end
				end
				if check then N = N + 1 end
			end
			for i, factor in pairs(factors) do
				N = N * factor
			end
			table.sort(factors, function(a, b) return a > b end)
			return N, factors
		end

		--localize shit for user safety
		if UniqueNameFFTCRMemoryKrolon == nil then
			UniqueNameFFTCRMemoryKrolon = {
				space = { {}, {} },
				orders = {},
				[true] = {},
				[false] = {}
			}
		end
		local N, inverse, mem, factors, factor, twiddles, helper1, helper2, oldLayer, newLayer, V, A, B, Ar, Aim, Br, Bim, r, im, permutation, size =
			#input + (input[0] and 1 or 0), inverse or false, UniqueNameFFTCRMemoryKrolon

		N, factors = fftSize(N, customRadices)
		permutation = mem.orders[N]
		oldLayer = mem.space[1]
		newLayer = mem.space[2]

		--check if memory data for N exists, this case just by checking permutation
		--if not, compute
		if permutation == nil then
			permutation = {}
			helper1 = {} --temporary table, is used to shuffle indices around
			V = N
			for k = #factors, 2, -1 do
				factor = factors[k]
				for j = 0, N / V - 1 do
					for i = 0, V - 1 do
						--I have absolutely no clue how to explain it - made with a bit of guesstimate and a lot of trial and error
						A = (factor * i + 1) % V + i // (V / factor) + j * V --reused name, it's just for an index tho
						helper1[i + j * V + 1] = permutation[A] or
							A                              --or A avoid having to initialize the table. If there's no table - use the index as value
					end
				end
				permutation, helper1 = helper1, {}
				V = V / factor
			end
			--save the result
			mem.orders[N] = permutation

			--make sure there's enough allocated space, this thing here avoids garbage collector
			for i = #oldLayer, N - 1 do
				oldLayer[i] = {}
				newLayer[i] = {}
			end
			--add Nth root of unity and all it's powers
			helper1 = 2 * math.pi / N
			for i = -1, 1, 2 do
				for j = 0, N - 1 do
					helper2 = i * j * helper1
					mem[i < 0][j / N] = { real = math.cos(helper2), imag = math.sin(helper2) }
				end
			end
		end

		A = not math.type(input[1]) --another reuse, it's just a bool to specify whether input is normal or complex
		B = (inverse or disableAutoNormalization) and 1 or
			1 /
			N                 --perform a normalization already on inputs when doing forward transform
		factor = {}
		for i = 1, N do
			V = input[(permutation[i] or 2) - 1] or factor --fallback to {r=0,i=0}, 0-padding achieved by "or 0"
			oldLayer[i - 1].real = B * (A and V.real or input[permutation[i]] or 0)
			oldLayer[i - 1].imag = B * (A and V.imag or 0)
		end

		V = 1
		twiddles = mem[inverse]
		for layer = 1, #factors do
			--when looking at a flowgraph, every vertical line of nodes is a layer
			factor = factors[layer]
			size = V
			V = V * factor
			--size is the size of previous layer chunk, V is the current layer chunk size

			--universal radix core, will work for any radix, tho not the most optimized for any
			for chunk = 0, N / V - 1 do
				--using helper1 and helper2 as indices saves some % of performance, especially down in the last for
				helper1 = V * chunk
				--saves precious performance to do it out of multiplication loop, as it gets multiplied by omega^0 which is 1 anyway
				for point = V - 1, 0, -1 do
					helper2 = helper1 + point % size
					B = oldLayer[helper2]
					r = B.real
					im = B.imag
					--this for is pretty expensive, it'd be much better to have every connection written in-line but that's why it's uni radix
					for line = 1, factor - 1 do
						A = twiddles[((point * line) % V) / V]
						B = oldLayer[helper2 + size * line]
						Ar = A.real
						Aim = A.imag
						Br = B.real
						Bim = B.imag
						r = r + Ar * Br - Aim * Bim
						im = im + Ar * Bim + Aim * Br
					end
					inverse = newLayer[chunk * V + point] --just another cursed reuse since it's no longer needed
					inverse.real = r
					inverse.imag = im
				end
			end
			oldLayer, newLayer = newLayer, oldLayer
		end

		--output a clone of a snippet of allocated space, rather than a refference
		newLayer = { N = N }
		for i = 0, N - 1 do
			newLayer[i] = { real = oldLayer[i].real, imag = oldLayer[i].imag }
		end
		return newLayer
	end,
	---@endsection

	---@section fftRadix2
	---~~860 chars.
	---Radix2 FFT.
	---Optimized to not produce garbage, thus avoiding garbage collector lag hugely increasing performance.
	---Can take either 1-indexed tables {1,2,3,4} or 0-indexed(!!!) complex values {{real=1,imag=0},{real=2,imag=0},{real=3,imag=0},{real=4,imag=0}}.
	---Will 0-pad to nearest possible N-size when fed with typical table for input.
	---Will only output 0-indexed complex values, even if they represent just the real values.
	---@param input table 1-indexed numbers or 0-indexed complex values
	---@param inverse boolean flag for inverse transform
	---@param disableAutoNormalization boolean default false, flag to disable normalization (which happens only on forward transform)
	---@return table complex complex table, FFT output
	fftRadix2 = function(input, inverse, disableAutoNormalization)
		--localize shit for user safety
		if UniqueNameFFTMemoryKrolon == nil then
			UniqueNameFFTMemoryKrolon = {
				space = { {}, {} },
				orders = {},
				[true] = {},
				[false] = {},
				safe = {}
			}
		end
		local N, inverse, mem, twiddles, helper1, helper2, oldLayer, newLayer, V, A, B, Ar, Aim, Br, Bim, r, im, permutation, size =
			2 ^ math.ceil(math.log(#input + (input[0] and 1 or 0), 2)), inverse or false, UniqueNameFFTMemoryKrolon

		--check if memory data for N exists, this case just by checking permutation
		--if not, compute
		oldLayer = mem.space[1]
		newLayer = mem.space[2]
		if mem.orders[N] == nil then
			A = math.log(N, 2)
			mem.orders[N] = {}
			for i = 0, N - 1 do
				val = 1
				for j = 1, A do
					--bit magik
					val = val + (i & 2 ^ (j - 1) == 2 ^ (j - 1) and 2 ^ (A - j) or 0)
				end
				mem.orders[N][i + 1] = val
			end

			--make sure there's enough allocated space, this thing here avoids garbage collector
			for i = #oldLayer, N - 1 do
				oldLayer[i] = {}
				newLayer[i] = {}
			end
			--add Nth root of unity and all it's powers
			helper1 = 2 * math.pi / N
			for i = -1, 1, 2 do
				for j = 0, N - 1 do
					helper2 = i * j * helper1
					mem[i < 0][j / N] = { real = math.cos(helper2), imag = math.sin(helper2) }
				end
			end
		end
		permutation = mem.orders[N]

		A = not math.type(input[1]) --another reuse, it's just a bool to specify whether input is normal or complex
		B = (inverse or disableAutoNormalization) and 1 or
			1 /
			N                 --perform a normalization already on inputs when doing forward transform
		factor = {}
		for i = 1, N do
			V = input[(permutation[i] or 2) - 1] or factor --fallback to {r=0,i=0}, 0-padding achieved by "or 0"
			oldLayer[i - 1].real = B * (A and V.real or input[permutation[i]] or 0)
			oldLayer[i - 1].imag = B * (A and V.imag or 0)
		end

		V = 1
		twiddles = mem[inverse]
		for layer = 1, math.log(N, 2) do
			--when looking at a flowgraph, every vertical line of nodes is a layer
			size = V
			V = V * 2
			--size is the size of previous layer chunk, V is the current layer chunk size

			--universal radix core, will work for any radix, tho not the most optimized for any
			for chunk = 0, N / V - 1 do
				--using helper1 and helper2 as indices saves some % of performance, especially down in the last for
				helper1 = V * chunk
				--saves precious performance to do it out of multiplication loop, as it gets multiplied by omega^0 which is 1 anyway
				for point = V - 1, 0, -1 do
					helper2 = helper1 + point % size
					B = oldLayer[helper2]
					r = B.real
					im = B.imag
					A = twiddles[point / V]
					B = oldLayer[helper2 + size]
					Ar = A.real
					Aim = A.imag
					Br = B.real
					Bim = B.imag
					r = r + Ar * Br - Aim * Bim
					im = im + Ar * Bim + Aim * Br
					inverse = newLayer[chunk * V + point] --just another cursed reuse since it's no longer needed
					inverse.real = r
					inverse.imag = im
				end
			end
			oldLayer, newLayer = newLayer, oldLayer
		end

		newLayer = { N = N }
		--output a clone of a snippet of allocated space, rather than a refference
		for i = 0, N - 1 do
			newLayer[i] = { real = oldLayer[i].real, imag = oldLayer[i].imag }
		end
		return newLayer
	end,
	---@endsection

	---@section dft
	---~~550 chars
	---Quite small, but very slow algorithm, may be useful in small N sizes when exact frequencies are required without 0-padding.
	---Can take either 1-indexed tables {1,2,3,4} or 0-indexed complex values {{real=1,imag=0},{real=2,imag=0},{real=3,imag=0},{real=4,imag=0}}.
	---Will only output 0-indexed complex values, even if they represent just the real values.
	---@param input table 1-indexed numbers or 0-indexed complex values
	---@param inverse boolean flag for inverse transform
	---@return table complex complex table, FFT output
	dft = function(input, inverse)
		local Mult = function(A, B, N)
			--a little simplified typical matrix multiplication, it only works on matrix*vector so no need to implement in full
			local c, v, realA, imagA, realB, imagB = { N = N }
			for i = 0, #A do
				c[i] = { real = 0, imag = 0 }
				for k = 0, #A[i] do
					realA = A[i][k].real
					imagA = A[i][k].imag
					realB = B[k].real
					imagB = B[k].imag
					c[i].real = c[i].real + realA * realB - imagA * imagB
					c[i].imag = c[i].imag + realA * imagB + imagA * realB
				end
			end
			return c
		end

		if UniqueNameDFTMemoryKrolon == nil then UniqueNameDFTMemoryKrolon = {} end
		local N, vector, inverse, mem, dft, k = #input + (input[0] ~= nil and 1 or 0), {}, inverse or false,
			UniqueNameDFTMemoryKrolon
		--make sure inputs are safe
		if math.type(input[1]) then
			for i = 1, N do
				vector[i - 1] = { real = input[i], imag = 0 }
			end
		else
			vector = input
		end

		--keep DFT matrices in memory
		if mem[N] == nil then
			mem[N] = {}
			for inversion = -1, 1 do
				dft = {}
				for i = 0, N - 1 do
					dft[i] = {}
					for j = 0, N - 1 do
						k = 2 * pi * i * j * inversion / N
						dft[i][j] = { real = math.cos(k), imag = math.sin(k) }
					end
				end
				mem[N][inversion < 0] = dft
			end
		end

		return Mult(mem[N][inverse], vector, N)
	end,
	---@endsection
}
---@endsection FOURIERCLASS
---@diagnostic enable:unbalanced-assignments

simulator:setScreen(1, "9x5")

data = {}
for i = 1, 2400 do
	data[i] = math.sin(5 * pi * i / 60) + math.sin(10 * pi * i / 60) + math.sin(5 * pi * i / 60) * math.sin(10 * pi * i / 60)
end

result = Krolony.Fourier.fftUniRadix(data)

function lerp(iS, iE, oS, oE, v)
	return oS + ((oE - oS) / (iE - iS)) * (v - iS)
end

min, max = math.huge, -math.huge

for i = 0, #result do
	min = math.min(min, (result[i].real^2 + result[i].imag^2)^0.5)
	max = math.max(max, (result[i].real^2 + result[i].imag^2)^0.5)
end

t = os.clock()
fps = 0
function onTick()
	t = os.clock()
	result = Krolony.Fourier.fftUniRadix(data)
	fps = (1 / (os.clock() - t)) * 0.1 + fps * 0.9
end

function onDraw()
	for i = 0, #result do
		screen.drawLine(i, 160, i, 160 - lerp(min, max, 0, 127, (result[i].real^2 + result[i].imag^2)^0.5))
	end
	screen.drawText(0, 0, "FPS: " .. fps)
end
