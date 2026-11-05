function W = plan_waypoints(start, goal, obstacles, margin, world)
%PLAN_WAYPOINTS  Corner points that lead a straight-line path around circular obstacles.
%   W = plan_waypoints(start, goal, obstacles, margin)
%   obstacles: k x 3 rows [cx cy r]. margin: extra clearance (half the car width
%   plus a safety distance). world (optional): [width height] of the floor; a
%   detour that would leave it goes round the other side. Returns W, m x 2.
%
%   Repeatedly takes the first segment that passes too close to an obstacle and
%   inserts a detour point beside that obstacle, on the side the segment already
%   leans to, at distance (r + margin) * 1.5 from its centre. Simple, and
%   enough for a few obstacles; the curves then smooth the corners.
W = [start(:)'; goal(:)'];
for iter = 1:50
    hit = false;
    for i = 1:size(W, 1) - 1
        [k, q] = first_collision(W(i, :), W(i + 1, :), obstacles, margin);
        if k > 0
            c = obstacles(k, 1:2);
            away = q - c;
            if norm(away) < 1e-9                    % segment through the centre: pick the left side
                d = W(i + 1, :) - W(i, :);
                away = [-d(2), d(1)];
            end
            detour = c + away / norm(away) * (obstacles(k, 3) + margin) * 1.5;
            if nargin >= 5 && ~inside(detour, world, margin)
                detour = c - away / norm(away) * (obstacles(k, 3) + margin) * 1.5;   % other side
            end
            W = [W(1:i, :); detour; W(i + 1:end, :)];
            hit = true;
            break;
        end
    end
    if ~hit, return; end
end
error('plan_waypoints: no path found after 50 detours');
end

function [k, q] = first_collision(a, b, obstacles, margin)
% obstacle index whose circle (r + margin) the segment a-b enters, and the
% closest point of the segment to its centre; k = 0 if none
k = 0; q = [];
best = inf;
for j = 1:size(obstacles, 1)
    c = obstacles(j, 1:2);
    d = b - a;
    u = max(0, min(1, dot(c - a, d) / max(dot(d, d), eps)));
    p = a + u * d;
    if norm(p - c) < obstacles(j, 3) + margin && u < best
        best = u; k = j; q = p;
    end
end
end

function ok = inside(p, world, margin)
ok = all(p >= margin) && all(p <= world - margin);
end
