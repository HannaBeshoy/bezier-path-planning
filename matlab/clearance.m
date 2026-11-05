function c = clearance(XY, obstacles)
%CLEARANCE  Smallest distance from the sampled path to any obstacle's edge.
c = inf;
for j = 1:size(obstacles, 1)
    d = sqrt(sum((XY - obstacles(j, 1:2)) .^ 2, 2)) - obstacles(j, 3);
    c = min(c, min(d));
end
end
