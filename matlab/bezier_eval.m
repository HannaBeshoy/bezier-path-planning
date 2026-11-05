function [C, D] = bezier_eval(B, t)
%BEZIER_EVAL  Points (and tangent vectors) of a Bezier curve.
%   C = bezier_eval(B, t)        B: (n+1) x 2 control points, t: vector in [0, 1]
%   [C, D] = bezier_eval(B, t)   D: the tangent vectors c'(t)
%   Uses the Bernstein form of the course, sum nchoosek(n,i) t^i (1-t)^(n-i) B_i.
%   The derivative is the degree n-1 Bezier curve of n*(B_{i+1} - B_i).
t = t(:);
n = size(B, 1) - 1;
C = bernstein(n, t) * B;
if nargout > 1
    if n == 0
        D = zeros(numel(t), 2);
    else
        D = bernstein(n - 1, t) * (n * diff(B, 1, 1));
    end
end
end

function W = bernstein(n, t)
W = zeros(numel(t), n + 1);
for i = 0:n
    W(:, i + 1) = nchoosek(n, i) * t .^ i .* (1 - t) .^ (n - i);
end
end
