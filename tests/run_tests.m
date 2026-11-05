%RUN_TESTS  Self-checking tests. From the repository root:
%   MATLAB: run('tests/run_tests.m')      Octave: octave-cli --eval "run('tests/run_tests.m')"
here = fileparts(mfilename('fullpath'));
addpath(fullfile(here, '..', 'matlab'));
addpath(fullfile(here, 'helpers'));

tests = {
  'polynomial passes through its points',           @() t_poly_through()
  'Hermite arc meets both points and tangents',      @() t_hermite_conditions()
  'Hermite arc on [-1, 1] (lecture script)',         @() t_hermite_interval()
  'Hermite and Bezier forms are the same cubic',     @() t_hermite_equals_bezier()
  'Bernstein formula equals de Casteljau',           @() t_bernstein_vs_casteljau()
  'Bezier end tangents are n*(B1-B0), n*(Bn-Bn-1)',  @() t_bezier_end_tangents()
  'Bezier curve stays in its control hull box',      @() t_convex_hull_box()
  'curvature of a circle is 1/r',                    @() t_circle_curvature()
  'practice task 6: degree-4 curve',                 @() t_task6()
  'practice task 8: three points and a tangent',     @() t_task8()
  'lecture C1 join: shared point and tangent',       @() t_lecture_c1()
  'waypoints avoid every obstacle',                  @() t_waypoints_clear()
  'smooth path is C1 at every joint',                @() t_path_c1()
  'chosen path keeps clearance and turning radius',  @() t_best_path_limits()
  'OLED header: 120 points inside 128 x 64',         @() t_oled_header()
};

fails = 0;
for i = 1:size(tests, 1)
    try
        ok = tests{i, 2}();
    catch err
        ok = false;
        fprintf('     error: %s\n', err.message);
    end
    if ok, fprintf('PASS  %s\n', tests{i, 1});
    else,  fprintf('FAIL  %s\n', tests{i, 1}); fails = fails + 1; end
end
fprintf('\n%d of %d tests passed\n', size(tests, 1) - fails, size(tests, 1));
if fails > 0, error('%d tests failed', fails); end
