function ok = t_bernstein_vs_casteljau()
B = [10 20; 20 40; 40 40; 50 20; 20 10];
ok = true;
for t = linspace(0, 1, 11)
    ok = ok && norm(bezier_eval(B, t) - de_casteljau(B, t)) < 1e-12;
end
end
