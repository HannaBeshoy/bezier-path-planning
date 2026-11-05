function ok = t_oled_header()
[W, obstacles, margin, world] = scene();
p = best_path(W, obstacles, margin, 0.15);
f = [tempname() '.h'];
write_oled_header(f, p, obstacles, world, 120);
txt = fileread(f); delete(f);
tx = regexp(txt, 'PATH_X\[PATH_N\] PROGMEM = \{([^}]*)\}', 'tokens', 'once');
ty = regexp(txt, 'PATH_Y\[PATH_N\] PROGMEM = \{([^}]*)\}', 'tokens', 'once');
x = str2num(tx{1}); y = str2num(ty{1}); %#ok<ST2NM>
ok = numel(x) == 120 && numel(y) == 120 && all(x >= 0 & x <= 127) && all(y >= 0 & y <= 63);
ok = ok && max(abs(diff(x))) <= 2 && max(abs(diff(y))) <= 2;   % evenly spaced: small steps
end
