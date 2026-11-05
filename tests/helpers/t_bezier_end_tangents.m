function ok = t_bezier_end_tangents()
B = [10 20; 20 40; 40 40; 50 20; 20 10];
[C, D] = bezier_eval(B, [0 1]);
ok = norm(C(1, :) - B(1, :)) < 1e-12 && norm(C(2, :) - B(5, :)) < 1e-12 ...
     && norm(D(1, :) - 4 * (B(2, :) - B(1, :))) < 1e-12 && norm(D(2, :) - 4 * (B(5, :) - B(4, :))) < 1e-12;
% numerical derivative check in the middle
[c1, d] = bezier_eval(B, 0.3); c2 = bezier_eval(B, 0.3 + 1e-6);
ok = ok && norm((c2 - c1) / 1e-6 - d) < 1e-3;
end
