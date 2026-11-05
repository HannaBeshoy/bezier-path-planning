function ok = t_task6()
R = practice_exercises();
P = [10 20; 20 40; 40 40; 50 20; 20 10];
X = [polyval(R.t6.coef(:, 1)', 0:4)', polyval(R.t6.coef(:, 2)', 0:4)'];
ok = max(abs(X(:) - P(:))) < 1e-9 && size(R.t6.coef, 1) == 5;
% the tangent at 0.5 matches a finite difference
h = 1e-6;
p1 = [polyval(R.t6.coef(:, 1)', 0.5 + h), polyval(R.t6.coef(:, 2)', 0.5 + h)];
ok = ok && norm((p1 - R.t6.point) / h - R.t6.tangent) < 1e-3;
end
