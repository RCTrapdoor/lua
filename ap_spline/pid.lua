function PID(Kp, Ki, Kd, min, max, alpha)
    return {
        Kp = Kp,
        Ki = Ki,
        Kd = Kd,
        min = min,
        max = max,
        alpha = alpha or 1,
        integral = 0,
        last_error = 0,
        filtered_error = 0,
        run = function(self, sp, pv)
            local error = sp - pv
            self.integral = math.max(min, math.min(max, self.integral + error * self.Ki))
            self.filtered_error = self.alpha * error + (1 - self.alpha) * self.filtered_error
            local derivative = (self.filtered_error - self.last_error)
            self.last_error = self.filtered_error
            return self.Kp * error + self.integral + self.Kd * derivative
        end
    }
end