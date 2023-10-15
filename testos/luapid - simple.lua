function pid(Kp, Ki, Kd)
    return {
        Kp = Kp,
        Ki = Ki,
        Kd = Kd,
        integral = 0,
        last_error = 0,
        run = function(self, sp, pv)
            local error = sp - pv
            self.integral = self.integral + error
            local derivative = (error - self.last_error)
            self.last_error = error
            return self.Kp * error + self.Ki * self.integral + self.Kd * derivative
        end
    }
end

screen = pid(1, 1, 1)

for i = 1, 10 do
    print(string.format(screen:run(10, i)))
end