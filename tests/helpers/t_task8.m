function ok = t_task8()
R = practice_exercises();
C = R.t8.coef;
v = @(t) [polyval(C(:, 1)', t), polyval(C(:, 2)', t)];
d0 = [polyval(polyder(C(:, 1)'), 0), polyval(polyder(C(:, 2)'), 0)];
ok = norm(v(0) - [-2 -2]) < 1e-9 && norm(v(1) - [6 -2]) < 1e-9 && norm(v(1.5) - [10 2]) < 1e-9 && norm(d0 - [6 -4]) < 1e-9;
end
