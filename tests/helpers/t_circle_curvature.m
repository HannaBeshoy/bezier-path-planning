function ok = t_circle_curvature()
r = 0.7; t = linspace(0, 2 * pi, 400)';
XY = r * [cos(t), sin(t)]; D = r * [-sin(t), cos(t)]; DD = -r * [cos(t), sin(t)];
[L, kmax] = curve_props(XY, D, DD);
ok = abs(kmax - 1 / r) < 1e-9 && abs(L - 2 * pi * r) < 1e-3;
end
