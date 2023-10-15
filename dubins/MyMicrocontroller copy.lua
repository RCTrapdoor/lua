simulator:setScreen(1, "9x5")

r_min = 10

pi = math.pi
tau = 2 * pi

function dist(a, b)
  return math.sqrt((a.x - b.x) ^ 2 + (a.y - b.y) ^ 2)
end

-- Define Dubin's path types
DubinsPathType = {
  LSL = 1,
  LSR = 2,
  RSL = 3,
  RSR = 4,
  LRL = 5,
  RLR = 6
}

start = { x = 20, y = 20, theta = 0 }

goal = { x = 100, y = 100, theta = 0 }

theta = { x = 0, y = 0 }

arrow = { x = 0, y = 0, theta = 0 }

-- Define Dubin's path length calculation function
function DubinsPathLength(q0, q1, pathType)
  local L = 0

  -- Define the turning radius
  local R = r_min

  -- Define the angles and distances
  local dx = q1.x - q0.x
  local dy = q1.y - q0.y
  local d = math.sqrt(dx ^ 2 + dy ^ 2)
  local alpha = math.atan(dy, dx)
  local beta = alpha - q0.theta
  local beta_prime = q1.theta - q0.theta - beta

  -- Calculate the length of each Dubin's path type
  if pathType == DubinsPathType.LSL then
    local t = math.fmod(beta - alpha, tau)
    local arclength = R * t
    local straights = d - R * (math.sin(beta) - math.sin(alpha))
    L = arclength + straights + R * math.fmod(beta_prime + tau, tau)
  elseif pathType == DubinsPathType.LSR then
    local t = math.fmod(beta + alpha, tau)
    local arclength = -R * t
    local straight1 = R * (math.sin(beta) - math.sin(alpha))
    local straight2 = d - R * (math.sin(beta_prime + t) - math.sin(alpha))
    L = arclength + straight1 + straight2
  elseif pathType == DubinsPathType.RSL then
    local t = math.fmod(alpha + beta, tau)
    local arclength = R * t
    local straight1 = R * (math.sin(beta) - math.sin(alpha))
    local straight2 = d - R * (math.sin(beta_prime + t) - math.sin(beta))
    L = arclength + straight1 + straight2
  elseif pathType == DubinsPathType.RSR then
    local t = math.fmod(beta - alpha, tau)
    local arclength = R * t
    local straights = d - R * (math.sin(beta) - math.sin(alpha))
    L = arclength + straights + R * math.fmod(beta_prime - tau, tau)
  elseif pathType == DubinsPathType.LRL then
    local t = math.fmod(beta - alpha, tau)
    local arclength1 = R * t
    local arclength2 = R * math.fmod(beta_prime - tau, tau)
    local straights = d - R * (math.sin(beta) - math.sin(alpha)) +
    R * (math.sin(beta_prime - tau) - math.sin(alpha + tau))
    L = arclength1 + arclength2 + straights
  elseif pathType == DubinsPathType.RLR then
    local t = math.fmod(alpha - beta, tau)
    local arclength1 = -R * t
    local arclength2 = R * math.fmod(beta_prime + tau, tau)
    local straights = d - R * (math.sin(alpha) - math.sin(beta)) +
    R * (math.sin(beta_prime + tau) - math.sin(alpha - tau))
    L = arclength1 + arclength2 + straights
  end

  return L
end

function onTick()
  isClick = input.getBool(1) and not isPressed
  isPressed = input.getBool(1)

  touch = { x = input.getNumber(3), y = input.getNumber(4) }

  -- move the nearest point to the touch point
  if isPressed and dist(touch, last_touch) > 0 then
    if dist(start, touch) < dist(goal, touch) then
      start.x = touch.x
      start.y = touch.y
      start.theta = math.atan(theta.y, theta.x)
    else
      goal.x = touch.x
      goal.y = touch.y
      goal.theta = math.atan(theta.y, theta.x)
    end
    theta.x = 0.25 * (touch.x - last_touch.x) + 0.75 * theta.x
    theta.y = 0.25 * (touch.y - last_touch.y) + 0.75 * theta.y
  end

  last_touch = { x = touch.x, y = touch.y }
end

function onDraw()
  -- draw the start and goal points
  screen.setColor(255, 0, 0)
  screen.drawCircle(start.x, start.y, r_min)
  screen.drawLine(start.x, start.y, start.x + r_min * math.cos(start.theta), start.y + r_min * math.sin(start.theta))

  screen.setColor(0, 255, 0)
  screen.drawCircle(goal.x, goal.y, r_min)
  screen.drawLine(goal.x, goal.y, goal.x + r_min * math.cos(goal.theta), goal.y + r_min * math.sin(goal.theta))

  screen.drawText(1, 1, string.format("theta.x = %f theta.y = %f", theta.x, theta.y))

  -- draw the path
end
