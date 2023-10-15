text = "sampleRate=Sample Every n-th tick,minMaxNotation=Min/Max Value Notation,currentNotation=Current Value Notation,channels=Number of Channels,numSamples=Number of Samples"

for k, v in text:gmatch("(%w+)=(.+),") do
    print(k, v)
end