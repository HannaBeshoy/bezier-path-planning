function path = smooth_path(W, scale, n_per_arc)
%SMOOTH_PATH  C1-continuous chain of cubic Bezier arcs through waypoints.
%   path = smooth_path(W, scale, n_per_arc)
%   W: m x 2 waypoints. At each inner waypoint the tangent points from the previous
%   waypoint to the next one (Catmull-Rom direction); its length is scale times
%   the shorter neighbouring segment, so a short segment never gets a long tangent.
%   The start and goal tangents point along the first and last segment.
%   Each arc i is the Hermite arc (W_i, W_i+1, V_i, V_i+1), turned into Bezier
%   control points. Neighbouring arcs share the point and the tangent vector, so
%   the path is C1 (and therefore G1) continuous.
%
%   path.B{i}: control points of arc i; path.xy, path.d, path.dd: samples,
%   first and second derivative; path.arc: arc index of each sample.
if nargin < 3, n_per_arc = 100; end
m = size(W, 1);
V = zeros(m, 2);
seg = sqrt(sum(diff(W, 1, 1) .^ 2, 2));
for i = 1:m
    if i == 1
        dirv = W(2, :) - W(1, :); len = seg(1);
    elseif i == m
        dirv = W(m, :) - W(m - 1, :); len = seg(m - 1);
    else
        dirv = W(i + 1, :) - W(i - 1, :); len = min(seg(i - 1), seg(i));
    end
    V(i, :) = dirv / norm(dirv) * len * scale * 3;    % x3: Bezier handle = V/3 = len*scale
end
t = linspace(0, 1, n_per_arc)';
path.B = cell(m - 1, 1);
path.xy = []; path.d = []; path.dd = []; path.arc = [];
path.waypoints = W; path.tangents = V; path.scale = scale;
for i = 1:m - 1
    B = hermite_to_bezier(W(i, :), W(i + 1, :), V(i, :), V(i + 1, :));
    path.B{i} = B;
    [C, D] = bezier_eval(B, t);
    [~, DD] = bezier_eval(3 * diff(B, 1, 1), t);      % second derivative
    if i > 1, C = C(2:end, :); D = D(2:end, :); DD = DD(2:end, :); end
    path.xy = [path.xy; C]; path.d = [path.d; D]; path.dd = [path.dd; DD];
    path.arc = [path.arc; i * ones(size(C, 1), 1)];
end
end
