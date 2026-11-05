function ok = t_lecture_c1()
R = practice_exercises();
a = R.c1.arc1; b = R.c1.arc2;
p = @(c, t) [polyval(c(:, 1)', t), polyval(c(:, 2)', t)];
d = @(c, t) [polyval(polyder(c(:, 1)'), t), polyval(polyder(c(:, 2)'), t)];
ok = norm(p(a, 1) - p(b, -1)) < 1e-9 && norm(d(a, 1) - d(b, -1)) < 1e-9;
end
