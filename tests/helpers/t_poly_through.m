function ok = t_poly_through()
P = [2 2; 4 5; 9 4; 8 1]; t = [-1 0 1 2];            % hermite_bezier.m, first example
C = poly_through_points(t, P);
X = [polyval(C(:, 1)', t)', polyval(C(:, 2)', t)'];
ok = max(abs(X(:) - P(:))) < 1e-9;
end
