function ok = t_convex_hull_box()
rng(3);
ok = true;
for k = 1:20
    B = rand(5, 2) * 10;
    C = bezier_eval(B, linspace(0, 1, 200));
    ok = ok && all(min(C) >= min(B) - 1e-12) && all(max(C) <= max(B) + 1e-12);
end
end
