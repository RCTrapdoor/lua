-- Differential drive robot with a microcontroller

tau = math.pi * 2
pi = tau / 2

function wrap(x, min, max)
    return (x + pi) % (tau) - pi
end

last_GPS = {x = 0, y = 0}

-- Differential drive autonomous robot
-- Uses GPS to navigate to a waypoint
-- Calculates dubins path to waypoint
-- Uses PID to control heading and speed
-- Uses a microcontroller to control the motors

function PID(Kp, Ki, Kd, min, max, alpha)
    return {
        Kp = Kp,
        Ki = Ki,
        Kd = Kd,
        min = min,
        max = max,
        alpha = alpha,
        integral = 0,
        last_error = 0,
        filtered_error = 0,
        run = function(self, sp, pv)
            local error = sp - pv
            self.integral = math.max(min, math.min(max, self.integral + error * Ki))
            self.filtered_error = self.alpha * error + (1 - self.alpha) * self.filtered_error
            local derivative = (self.filtered_error - self.last_error)
            self.last_error = self.filtered_error
            return self.Kp * error + self.integral + self.Kd * derivative
        end
    }
end

-- function for calculating the dubins path
-- returns a table with the following fields:
--   - length: length of the path
--   - left: left turn radius
--   - right: right turn radius
--   - start: start point of the path
--   - end: end point of the path
--   - start_angle: angle of the start point
--   - end_angle: angle of the end point
--   - type: type of the path
--   - path: a list of points that make up the path

function 

function onTick()
    target = {x = input.getNumber(1), y = input.getNumber(2)}
    GPS = {x = input.getNumber(5), y = input.getNumber(6)}
    compass = -input.getNumber(7) * tau


    last_GPS = GPS
end

function onDraw()
    screen.drawMap(GPS.x, GPS.y, 1)

    px, py = map.mapToScreen(GPS.x, GPS.y, 1, 96, 96, target.x, target.y)

    screen.setColor(255, 0, 0)
    screen.drawCircle(px, py, 5)

    screen.setColor(255, 255, 255)
    screen.drawText(0, 0, "Angle: " .. math.floor(angle * 180 / pi) .. "°")
    screen.drawText(0, 10, "Distance: " .. math.floor(distance * 100) .. "cm")
    screen.drawText(0, 20, "Speed: " .. math.floor(speed * 100) .. "cm/s")
    screen.drawText(0, 30, "Turn: " .. math.floor(turn * 100) .. "cm/s")
end