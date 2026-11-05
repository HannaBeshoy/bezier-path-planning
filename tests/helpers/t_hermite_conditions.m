function ok = t_hermite_conditions()
P0 = [-2 -2]; P1 = [6 -2]; V0 = [6 -4]; V1 = [4 4];
C = hermite_arc(P0, P1, V0, V1);
v = @(c, t) [polyval(c(:, 1)', t), polyval(c(:, 2)', t)];
d = @(c, t) [polyval(polyder(c(:, 1)'), t), polyval(polyder(c(:, 2)'), t)];
ok = norm(v(C, 0) - P0) < 1e-9 && norm(v(C, 1) - P1) < 1e-9 && norm(d(C, 0) - V0) < 1e-9 && norm(d(C, 1) - V1) < 1e-9;
end
