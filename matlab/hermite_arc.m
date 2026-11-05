function C = hermite_arc(P0, P1, V0, V1, t0, t1)
%HERMITE_ARC  Cubic arc from two points and two tangent vectors.
%   C = hermite_arc(P0, P1, V0, V1)          on t in [0, 1]
%   C = hermite_arc(P0, P1, V0, V1, t0, t1)  on t in [t0, t1]
%   Returns C, 4 x 2: coefficients of x(t) and y(t), highest power first.
%   Conditions: c(t0) = P0, c(t1) = P1, c'(t0) = V0, c'(t1) = V1.
if nargin < 5, t0 = 0; t1 = 1; end
A = [t0^3, t0^2, t0, 1;
     t1^3, t1^2, t1, 1;
     3*t0^2, 2*t0, 1, 0;
     3*t1^2, 2*t1, 1, 0];
C = A \ [P0(:)'; P1(:)'; V0(:)'; V1(:)'];
end
