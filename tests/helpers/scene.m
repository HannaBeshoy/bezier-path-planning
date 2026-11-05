function [W, obstacles, margin, world] = scene()
% the scene of run_all.m
world = [2.4 1.2]; margin = 0.10;
obstacles = [0.60 0.38 0.18; 1.20 0.82 0.18; 1.80 0.38 0.18];
W = plan_waypoints([0.15 0.60], [2.25 0.60], obstacles, margin, world);
end
