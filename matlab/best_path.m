function [path, T] = best_path(W, obstacles, margin, r_min)
%BEST_PATH  Shortest smooth path that keeps the clearance and the turning radius.
%   [path, T] = best_path(W, obstacles, margin, r_min)
%   Tries handle lengths (scale) from 0.10 to 0.60 of the neighbouring segment.
%   Short handles hug the corners (sharp turns), long ones bulge outward (toward
%   the obstacles). Keeps the shortest path with clearance >= margin and
%   maximum curvature <= 1/r_min. T is the table of every try:
%   [scale, length, clearance, minimum turning radius, ok].
scales = 0.10:0.05:0.60;
T = zeros(numel(scales), 5);
path = [];
bestL = inf;
for k = 1:numel(scales)
    p = smooth_path(W, scales(k));
    [L, kmax] = curve_props(p.xy, p.d, p.dd);
    c = clearance(p.xy, obstacles);
    ok = c >= margin && 1 / kmax >= r_min;
    T(k, :) = [scales(k), L, c, 1 / kmax, ok];
    if ok && L < bestL, bestL = L; path = p; end
end
if isempty(path), error('best_path: no handle length meets both limits'); end
end
