function ok = t_path_c1()
[W] = scene();
p = smooth_path(W, 0.4);
ok = numel(p.B) == size(W, 1) - 1;
for i = 1:numel(p.B) - 1
    [c1, d1] = bezier_eval(p.B{i}, 1); [c2, d2] = bezier_eval(p.B{i + 1}, 0);
    ok = ok && norm(c1 - c2) < 1e-12 && norm(d1 - d2) < 1e-12;
end
% and the path passes through every waypoint
for i = 1:size(W, 1)
    ok = ok && min(sqrt(sum((p.xy - W(i, :)) .^ 2, 2))) < 1e-12;
end
end
