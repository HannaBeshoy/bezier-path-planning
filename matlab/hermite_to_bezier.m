function B = hermite_to_bezier(P0, P1, V0, V1)
%HERMITE_TO_BEZIER  The same cubic in Bezier form (t in [0, 1]).
%   B = hermite_to_bezier(P0, P1, V0, V1) returns the 4 x 2 control points:
%   B0 = P0, B1 = P0 + V0/3, B2 = P1 - V1/3, B3 = P1.
%   (A cubic Bezier curve has c'(0) = 3*(B1 - B0) and c'(1) = 3*(B3 - B2).)
P0 = P0(:)'; P1 = P1(:)'; V0 = V0(:)'; V1 = V1(:)';
B = [P0; P0 + V0 / 3; P1 - V1 / 3; P1];
end
