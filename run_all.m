%RUN_ALL  Plan a smooth path for a small robot car around obstacles and export it.
%   Run from the repository root in MATLAB or Octave. Writes results/ and the
%   Arduino header arduino/oled_path/path_data.h.
addpath('matlab');

% the scene: a 2.4 m x 1.2 m floor (it maps onto the 128 x 64 OLED), three round obstacles
world = [2.4 1.2];
start = [0.15 0.60];
goal = [2.25 0.60];
obstacles = [0.60 0.38 0.18;      % cx cy r, metres: a slalom across the room
             1.20 0.82 0.18;
             1.80 0.38 0.18];
margin = 0.10;                    % half the car width (7 cm) + 3 cm safety
r_min = 0.15;                     % smallest turning radius of the small robot car

W = plan_waypoints(start, goal, obstacles, margin, world);
[path, T] = best_path(W, obstacles, margin, r_min);
[L, kmax] = curve_props(path.xy, path.d, path.dd);
poly_len = sum(sqrt(sum(diff(W, 1, 1) .^ 2, 2)));

fprintf('\nWaypoints (m):\n'); fprintf('  (%.3f, %.3f)\n', W');
fprintf('\nHandle length sweep: scale, length m, clearance m, min turn radius m, ok\n');
fprintf('  %.2f  %.3f  %.3f  %.3f  %d\n', T');
fprintf('\nChosen scale %.2f: length %.3f m (polyline %.3f m), clearance %.3f m, min turn radius %.3f m\n', ...
        path.scale, L, poly_len, clearance(path.xy, obstacles), 1 / kmax);

% C1 check at every joint: the end of arc i and the start of arc i+1 share point and tangent
for i = 1:numel(path.B) - 1
    [~, D1] = bezier_eval(path.B{i}, 1); [~, D2] = bezier_eval(path.B{i + 1}, 0);
    fprintf('joint %d: tangent mismatch %.2e\n', i, norm(D1 - D2));
end

% results for the README figures
fid = fopen('results/path.csv', 'w');
fprintf(fid, 'x_m,y_m,dx,dy,arc\n'); fprintf(fid, '%.5f,%.5f,%.5f,%.5f,%d\n', [path.xy, path.d, path.arc]');
fclose(fid);
fid = fopen('results/scene.csv', 'w');
fprintf(fid, 'kind,x_m,y_m,r_m\n');
fprintf(fid, 'obstacle,%.3f,%.3f,%.3f\n', obstacles');
fprintf(fid, 'waypoint,%.3f,%.3f,0\n', W');
for i = 1:numel(path.B), fprintf(fid, 'control,%.4f,%.4f,%d\n', [path.B{i}, i * ones(4, 1)]'); end
fclose(fid);
fid = fopen('results/scale_sweep.csv', 'w');
fprintf(fid, 'scale,length_m,clearance_m,min_turn_radius_m,ok\n'); fprintf(fid, '%.2f,%.4f,%.4f,%.4f,%d\n', T');
fclose(fid);
[~, ~, s] = curve_props(path.xy, path.d, path.dd);
sp = sqrt(sum(path.d .^ 2, 2));
kap = abs(path.d(:, 1) .* path.dd(:, 2) - path.d(:, 2) .* path.dd(:, 1)) ./ sp .^ 3;
fid = fopen('results/curvature.csv', 'w');
fprintf(fid, 's_m,curvature_per_m\n'); fprintf(fid, '%.4f,%.4f\n', [s, kap]');
fclose(fid);

write_oled_header('arduino/oled_path/path_data.h', path, obstacles, world, 120);
R = practice_exercises(); %#ok<NASGU>
fprintf('wrote results/*.csv and arduino/oled_path/path_data.h\n');
