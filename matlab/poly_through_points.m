function C = poly_through_points(t, P)
%POLY_THROUGH_POINTS  Polynomial curve through points at given parameter values.
%   C = poly_through_points(t, P)
%   t: 1 x n parameter values, P: n x 2 points. Returns C, n x 2: the coefficients
%   of x(t) and y(t), highest power first (for polyval), degree n-1.
%   This is the course's Hermite-arc construction (hermite_bezier.m) without the
%   Symbolic Toolbox: the conditions a3*t^3 + a2*t^2 + a1*t + a0 = p are one
%   linear system per coordinate, V * a = p, with V the Vandermonde matrix.
t = t(:);
V = t .^ (numel(t) - 1:-1:0);
C = V \ P;
end
