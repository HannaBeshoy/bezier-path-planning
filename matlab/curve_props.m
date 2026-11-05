function [L, kappa_max, s] = curve_props(XY, dXY, ddXY, t)
%CURVE_PROPS  Length and curvature of a sampled parametric curve.
%   [L, kappa_max, s] = curve_props(XY, dXY, ddXY, t)
%   XY, dXY, ddXY: points, first and second derivatives at parameters t.
%   Curvature of a plane curve: kappa = |x' y'' - y' x''| / (x'^2 + y'^2)^(3/2).
%   The car can follow the path only where 1/kappa >= its minimum turning radius.
speed = sqrt(sum(dXY .^ 2, 2));
kappa = abs(dXY(:, 1) .* ddXY(:, 2) - dXY(:, 2) .* ddXY(:, 1)) ./ max(speed, eps) .^ 3;
kappa_max = max(kappa);
s = [0; cumsum(sqrt(sum(diff(XY, 1, 1) .^ 2, 2)))];   % arc length along the samples
L = s(end);
end
