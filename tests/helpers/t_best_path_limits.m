function ok = t_best_path_limits()
[W, obstacles, margin] = scene();
[p, T] = best_path(W, obstacles, margin, 0.15);
[L, kmax] = curve_props(p.xy, p.d, p.dd);
ok = clearance(p.xy, obstacles) >= margin && 1 / kmax >= 0.15;
ok = ok && abs(L - min(T(T(:, 5) == 1, 2))) < 1e-12;        % the shortest of the allowed ones
ok = ok && any(T(:, 5) == 0);                                % and the limit really rules some out
end
