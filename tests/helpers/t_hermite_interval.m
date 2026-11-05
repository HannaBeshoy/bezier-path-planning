function ok = t_hermite_interval()
C = hermite_arc([2 2], [8 1], [1 3], [2 -3], -1, 1);
v = @(t) [polyval(C(:, 1)', t), polyval(C(:, 2)', t)];
d = @(t) [polyval(polyder(C(:, 1)'), t), polyval(polyder(C(:, 2)'), t)];
ok = norm(v(-1) - [2 2]) < 1e-9 && norm(v(1) - [8 1]) < 1e-9 && norm(d(-1) - [1 3]) < 1e-9 && norm(d(1) - [2 -3]) < 1e-9;
end
