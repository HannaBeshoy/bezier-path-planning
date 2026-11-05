function R = practice_exercises(show)
%PRACTICE_EXERCISES  The curve exercises of the course practice sheet (2024, sheet 2, tasks 6-10)
%   and the lecture scripts, solved numerically (no Symbolic Toolbox needed).
%   R = practice_exercises()      returns the results in a struct
%   R = practice_exercises(true)  also draws one figure per task
if nargin < 1, show = false; end

% task 6: degree-4 polynomial through 5 points at t = 0..4; tangent at t = 0.5
P6 = [10 20; 20 40; 40 40; 50 20; 20 10];
C = poly_through_points(0:4, P6);
R.t6.coef = C;
R.t6.tangent = [polyval(polyder(C(:, 1)'), 0.5), polyval(polyder(C(:, 2)'), 0.5)];
R.t6.point = [polyval(C(:, 1)', 0.5), polyval(C(:, 2)', 0.5)];

% task 7: Hermite arc through 4 points at t = -1, 0, 2, 3; tangent at t = 2
P7 = [-2 -2; 4 0; 6 -2; 10 2];
C = poly_through_points([-1 0 2 3], P7);
R.t7.coef = C;
R.t7.tangent = [polyval(polyder(C(:, 1)'), 2), polyval(polyder(C(:, 2)'), 2)];

% task 8: through 3 points at t = 0, 1, 1.5, tangent v = (6, -4) at t = 0
P8 = [-2 -2; 6 -2; 10 2]; v = [6 -4]; tt = [0 1 1.5];
A = [tt' .^ 3, tt' .^ 2, tt', ones(3, 1); 0 0 1 0];   % 3 point rows + c'(0) = a1
C = A \ [P8; v];
R.t8.coef = C;

% task 9: two points and two tangents on t in [0, 1]
R.t9.coef = hermite_arc([-2 -2], [6 -2], [6 -4], [4 4]);
R.t9.bezier = hermite_to_bezier([-2 -2], [6 -2], [6 -4], [4 4]);

% task 10: Bezier curve with 5 control points and its end tangents
B10 = [10 20; 20 40; 40 40; 50 20; 20 10];
[~, D] = bezier_eval(B10, [0 1]);
R.t10.B = B10;
R.t10.tangent_start = D(1, :);    % = 4 * (B1 - B0)
R.t10.tangent_end = D(2, :);      % = 4 * (B4 - B3)

% the lecture scripts: two Hermite arcs joined with C1 continuity (connecting_Hermite_C1_G1.m)
R.c1.arc1 = hermite_arc([2 2], [8 1], [1 3], [2 -3], -1, 1);
R.c1.arc2 = hermite_arc([8 1], [12 4], [2 -3], [0 8], -1, 1);

if show
    t = linspace(0, 4, 200)';
    figure; plot(polyval(R.t6.coef(:, 1)', t), polyval(R.t6.coef(:, 2)', t)); hold on
    plot(P6(:, 1), P6(:, 2), '*'); quiver(R.t6.point(1), R.t6.point(2), R.t6.tangent(1), R.t6.tangent(2), 0);
    axis equal; title('Task 6: degree-4 curve and its tangent at t = 0.5');
    t = linspace(0, 1, 200)';
    figure; C = bezier_eval(B10, t); plot(C(:, 1), C(:, 2)); hold on
    plot(B10(:, 1), B10(:, 2), '--o'); quiver(B10([1 5], 1), B10([1 5], 2), D(:, 1) / 4, D(:, 2) / 4, 0);
    axis equal; title('Task 10: Bezier curve and its end tangents (drawn at 1/4 length)');
end
end
