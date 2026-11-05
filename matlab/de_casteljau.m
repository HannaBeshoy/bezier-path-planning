function p = de_casteljau(B, t)
%DE_CASTELJAU  One point of a Bezier curve by repeated linear interpolation.
%   p = de_casteljau(B, t)  -- the geometric construction; it must agree with
%   the Bernstein formula in bezier_eval (checked by the tests).
for k = 1:size(B, 1) - 1
    B = (1 - t) * B(1:end - 1, :) + t * B(2:end, :);
end
p = B;
end
