function ok = t_waypoints_clear()
[W, obstacles, margin, world] = scene();
ok = all(all(W >= 0)) && all(W(:, 1) <= world(1)) && all(W(:, 2) <= world(2));
% every straight segment keeps the margin
for i = 1:size(W, 1) - 1
    s = linspace(0, 1, 500)';
    P = W(i, :) + s * (W(i + 1, :) - W(i, :));
    ok = ok && clearance(P, obstacles) >= margin - 1e-9;
end
end
