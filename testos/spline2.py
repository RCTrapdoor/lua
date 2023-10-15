def getSplinePoint(t, points, looped=False):
    p0, p1, p2, p3 = 0, 0, 0, 0
    if not looped:
        p1 = int(t) + 1
        p2 = p1 + 1
        p3 = p2 + 1
        p0 = p1 - 1
    else:
        p1 = int(t)
        p2 = (p1 + 1) % len(points)
        p3 = (p2 + 1) % len(points)
        # p0 = (p1 - 1) if p1 >= 0 else (len(points) - 1)
        if p1 >= 1:
            p0 = p1 - 1
        else:
            p0 = len(points) - 1

    t = t - int(t)

    tt = t * t
    ttt = tt * t

    q1 = -ttt + 2 * tt - t
    q2 = 3 * ttt - 5 * tt + 2
    q3 = -3 * ttt + 4 * tt + t
    q4 = ttt - tt

    return [
        0.5 * (points[p0][0] * q1 + points[p1][0]*q2 +
               points[p2][0] * q3 + points[p3][0] * q4),
        0.5 * (points[p0][1] * q1 + points[p1][1] * q2 +
               points[p2][1] * q3 + points[p3][1] * q4)
    ]


def getSplinePointGradient(t, points, looped=False):
    p0, p1, p2, p3 = 0, 0, 0, 0
    if not looped:
        p1 = int(t) + 1
        p2 = p1 + 1
        p3 = p2 + 1
        p0 = p1 - 1
    else:
        p1 = int(t)
        p2 = (p1 + 1) % len(points)
        p3 = (p2 + 1) % len(points)
        p0 = p1 - 1 if p1 >= 0 else len(points) - 1

    t = t - int(t)

    tt = t * t
    ttt = tt * t

    q1 = -3*tt + 4*t - 1
    q2 = 9*tt - 10*t
    q3 = -9*tt + 8*t + 1
    q4 = 3*tt - 2*t

    return [
        0.5 * (points[p0][0] * q1 + points[p1][0] * q2 +
               points[p2][0] * q3 + points[p3][0] * q4),
        0.5 * (points[p0][1] * q1 + points[p1][1] * q2 +
               points[p2][1] * q3 + points[p3][1] * q4)
    ]

# def getSplinePoints(points):
#     t = 0
#     while t < 1:
#         yield getSplinePoint(t, points)
#         t += 0.01
