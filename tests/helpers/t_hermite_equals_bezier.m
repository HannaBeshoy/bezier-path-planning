function ok = t_hermite_equals_bezier()
P0 = [0 0]; P1 = [5 1]; V0 = [3 6]; V1 = [4 -2];
C = hermite_arc(P0, P1, V0, V1);
B = hermite_to_bezier(P0, P1, V0, V1);
t = linspace(0, 1, 50)';
H = [polyval(C(:, 1)', t), polyval(C(:, 2)', t)];
ok = max(max(abs(H - bezier_eval(B, t)))) < 1e-12;
end
