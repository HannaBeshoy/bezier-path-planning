# Project guide

The mathematics behind each step, in the order of the course (Computer Aided Mathematics and Visualization: vectors, parametric curves, Hermite arcs, Bézier curves, surfaces).

## 1. Parametric curves and tangent vectors

A plane curve is a pair of functions c(t) = (x(t), y(t)). Its derivative c′(t) = (x′(t), y′(t)) is the tangent vector: its direction is the direction of motion, its length the speed at which the parameter moves along the curve. The car's heading on the OLED is exactly this direction, atan2(y′, x′).

## 2. Hermite arcs: conditions become a linear system

A cubic c(t) = a₃t³ + a₂t² + a₁t + a₀ (one for x, one for y) has four unknown coefficients, so four conditions fix it:

- **four points** at four parameter values (`poly_through_points`, the course's first example);
- **two points and two tangents** (`hermite_arc`): c(t₀) = P₀, c(t₁) = P₁, c′(t₀) = V₀, c′(t₁) = V₁;
- **mixed**, like practice task 8: three points and one tangent.

Each condition is linear in the coefficients, so the conditions form a 4 × 4 system A·a = p, solved with `A \ p`. The course scripts write the same equations with `syms` and `solve`; the numeric form gives the same coefficients, runs in Octave, and is the form a microcontroller or an FPGA would use.

## 3. Bézier curves

A Bézier curve of degree n is a weighted average of its n + 1 control points, with the Bernstein polynomials as weights: c(t) = Σ C(n, i) tⁱ (1 − t)ⁿ⁻ⁱ Bᵢ, for t in [0, 1]. Three facts used here, each tested:

- it starts at B₀ and ends at Bₙ, and its end tangents are n(B₁ − B₀) and n(Bₙ − Bₙ₋₁);
- de Casteljau's construction (interpolating the control polygon again and again) gives the same points;
- it stays inside the convex hull of its control points, so the control polygon is a safe envelope.

## 4. Hermite and Bézier are the same cubic

A cubic Bézier curve has c′(0) = 3(B₁ − B₀) and c′(1) = 3(B₃ − B₂). So the Hermite arc (P₀, P₁, V₀, V₁) on [0, 1] is the Bézier curve with control points P₀, P₀ + V₀/3, P₁ − V₁/3, P₁ (`hermite_to_bezier`). The planner thinks in Hermite terms (points and directions) and draws in Bézier terms.

## 5. Continuity

Two arcs meeting at a point are **C0** if they share the point, **C1** if they also share the tangent vector, **G1** if the tangents only point the same way (lengths may differ). The course script `connecting_Hermite_C1_G1.m` builds a C1 join by giving the second arc the first arc's end tangent. The planner does the same at every waypoint, so the whole path is C1, hence also G1: the car's heading never jumps.

## 6. Curvature: can the car drive it?

Curvature κ = |x′y″ − y′x″| / (x′² + y′²)^(3/2) is 1/radius of the circle that best fits the curve at that point (the test checks κ = 1/r on a circle). A car with a smallest turning radius of 15 cm can follow the path only where κ ≤ 1/0.15 m = 6.7 per metre. A polyline has κ = ∞ at every corner; the smooth path's maximum is 5.7 per metre (radius 17.6 cm).

## 7. Choosing the handle length

The tangent length at a waypoint is a free design choice. The sweep (0.10 to 0.60 of the shorter neighbouring segment) shows the trade-off: short handles keep the path close to the polyline but make sharp turns; long ones round the corners but swing the path out toward the obstacles and eventually overshoot. The planner keeps the handle lengths that meet both limits and picks the shortest path among them.

## 8. From metres to pixels

The 2.4 m × 1.2 m floor maps onto 128 × 64 pixels (18.8 mm per pixel), with y flipped because the display's y axis points down. The path is resampled at equal arc-length steps (using the cumulative length of the samples), so the car icon moves at constant speed even where the parameter t speeds up or slows down.

## Notes for the three tracks

- **Embedded systems and edge AI.** A robot's motion planner produces exactly this: a smooth reference path with its heading and curvature, which a controller then follows (curvature tells the steering angle). Evaluating a cubic is three multiply-adds per coordinate, cheap enough for a microcontroller.
- **FPGA to semiconductors.** de Casteljau is only additions and multiplications by t, which parallelise into a small pipeline; graphics hardware draws curves this way. The same Bézier curves describe font outlines and chip layout shapes.
- **Product security.** The planner checks its own output (clearance and turning radius) before the car uses it, and refuses with an error when no handle length is safe, instead of returning a path that hits an obstacle.
