"""Draws the README figures from results/*.csv and arduino/oled_path/path_data.h.

    octave-cli run_all.m   (or run_all in MATLAB), then   python3 docs/figures.py
"""
import csv
import os
import re

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.join(HERE, "..")
IMG = os.path.join(HERE, "img")
INK, GRID, PATH, POLY, OBST, HULL = "#2b2f33", "#d9dde1", "#2e86ab", "#b0b7bf", "#d1495b", "#edae49"
plt.rcParams.update({"font.size": 10, "axes.edgecolor": INK, "axes.labelcolor": INK, "xtick.color": INK,
                     "ytick.color": INK, "axes.grid": True, "grid.color": GRID, "grid.linewidth": 0.6,
                     "axes.spines.top": False, "axes.spines.right": False, "legend.frameon": False,
                     "svg.fonttype": "none"})


def rows(name):
    with open(os.path.join(ROOT, "results", name)) as f:
        return list(csv.DictReader(f))


def save(fig, name):
    fig.tight_layout()
    fig.savefig(os.path.join(IMG, name), facecolor="white")
    if os.environ.get("CHECK_PNG"):
        fig.savefig(os.path.join(os.environ["CHECK_PNG"], name.rsplit(".", 1)[0] + ".png"), dpi=90)
    plt.close(fig)
    print("wrote", name)


path = np.array([[float(r["x_m"]), float(r["y_m"])] for r in rows("path.csv")])
scene = rows("scene.csv")
obst = [(float(r["x_m"]), float(r["y_m"]), float(r["r_m"])) for r in scene if r["kind"] == "obstacle"]
wps = np.array([[float(r["x_m"]), float(r["y_m"])] for r in scene if r["kind"] == "waypoint"])
ctrl = {}
for r in scene:
    if r["kind"] == "control":
        ctrl.setdefault(int(float(r["r_m"])), []).append((float(r["x_m"]), float(r["y_m"])))

# 1. the scene: obstacles with their safety margin, polyline, control polygons, smooth path
fig, ax = plt.subplots(figsize=(7.2, 3.9))
for cx, cy, r in obst:
    ax.add_patch(plt.Circle((cx, cy), r, color=OBST, alpha=0.85, lw=0))
    ax.add_patch(plt.Circle((cx, cy), r + 0.10, fill=False, ls="--", color=OBST, lw=0.8))
ax.plot(wps[:, 0], wps[:, 1], color=POLY, lw=1.2, ls="-", marker="s", ms=4, label="waypoints (straight polyline)")
for i, pts in ctrl.items():
    pts = np.array(pts)
    ax.plot(pts[:, 0], pts[:, 1], color=HULL, lw=0.8, ls=":", marker="o", ms=3,
            label="Bézier control points" if i == 1 else None)
ax.plot(path[:, 0], path[:, 1], color=PATH, lw=2.2, label="smooth path (C1 cubic Bézier arcs)")
ax.plot(*wps[0], "o", color=INK, ms=6); ax.plot(*wps[-1], "*", color=INK, ms=10)
ax.text(wps[0, 0], wps[0, 1] - 0.09, "start", ha="center", fontsize=8)
ax.text(wps[-1, 0], wps[-1, 1] - 0.09, "goal", ha="center", fontsize=8)
ax.set_xlim(0, 2.4); ax.set_ylim(0, 1.2); ax.set_aspect("equal")
ax.set_xlabel("x (m)"); ax.set_ylabel("y (m)")
ax.legend(loc="upper center", bbox_to_anchor=(0.5, -0.18), ncol=3, fontsize=8)
save(fig, "path.svg")

# 2. curvature along the path, against the car's limit
c = rows("curvature.csv")
s = np.array([float(r["s_m"]) for r in c]); k = np.array([float(r["curvature_per_m"]) for r in c])
fig, ax = plt.subplots(figsize=(7.2, 2.6))
ax.plot(s, k, color=PATH, lw=1.8)
ax.axhline(1 / 0.15, color=OBST, lw=1, ls="--")
ax.text(s[-1], 1 / 0.15 + 0.2, "limit: turning radius 15 cm", ha="right", fontsize=8, color=OBST)
ax.set_xlabel("distance along the path (m)"); ax.set_ylabel("curvature (1/m)")
ax.set_ylim(0, 8)
save(fig, "curvature.svg")

# 3. the handle-length trade-off
t = rows("scale_sweep.csv")
sc = np.array([float(r["scale"]) for r in t]); rad = np.array([float(r["min_turn_radius_m"]) for r in t])
cl = np.array([float(r["clearance_m"]) for r in t]); ok = np.array([r["ok"] == "1" for r in t])
fig, ax = plt.subplots(figsize=(7.2, 2.8))
ax.plot(sc, rad * 100, color=PATH, marker="o", ms=4, label="tightest turn radius (cm)")
ax.plot(sc, cl * 100, color=HULL, marker="s", ms=4, label="closest approach to an obstacle (cm)")
ax.axhline(15, color=OBST, lw=1, ls="--"); ax.axhline(10, color=OBST, lw=1, ls=":")
ax.text(0.105, 15.6, "turn radius limit 15 cm", fontsize=8, color=OBST)
ax.text(0.105, 8.0, "clearance limit 10 cm", fontsize=8, color=OBST)
ax.fill_between(sc, 0, 25, where=ok, color=PATH, alpha=0.08, step=None)
ax.set_xlabel("handle length (fraction of the shorter neighbouring segment)"); ax.set_ylim(0, 25)
ax.legend(fontsize=8, loc="lower right")
save(fig, "scale_sweep.svg")

# 4. what the 128 x 64 OLED shows: the sketch's drawing calls, re-done pixel by pixel
h = open(os.path.join(ROOT, "arduino", "oled_path", "path_data.h")).read()
arr = lambda name: [int(v) for v in re.search(name + r"[^{]*\{([^;]*)\};", h).group(1).replace("{", "").replace("}", "").split(",")]
X, Y = arr("PATH_X"), arr("PATH_Y")
O = arr("OBST\\[OBST_N\\]\\[3\\]"); O = [O[i:i + 3] for i in range(0, len(O), 3)]
WP = arr("WAYPOINT\\[WAYPOINT_N\\]\\[2\\]"); WP = [WP[i:i + 2] for i in range(0, len(WP), 2)]
img = np.zeros((64, 128), dtype=np.uint8)
def px(x, y):
    if 0 <= x < 128 and 0 <= y < 64: img[y, x] = 1
for x in range(128): px(x, 0); px(x, 63)
for y in range(64): px(0, y); px(127, y)
for cx, cy, r in O:
    for y in range(cy - r, cy + r + 1):
        for x in range(cx - r, cx + r + 1):
            if (x - cx) ** 2 + (y - cy) ** 2 <= r * r + r: px(x, y)
for x, y in WP:
    for dx, dy in [(0, 0), (-1, -1), (1, 1), (-1, 1), (1, -1)]: px(x + dx, y + dy)
for i in range(0, len(X), 2): px(X[i], Y[i])
upto = 70
for i in range(1, upto + 1):
    n = max(abs(X[i] - X[i - 1]), abs(Y[i] - Y[i - 1]), 1)
    for k in range(n + 1): px(round(X[i - 1] + (X[i] - X[i - 1]) * k / n), round(Y[i - 1] + (Y[i] - Y[i - 1]) * k / n))
H = arr("PATH_HEADING")
a = H[upto] * 2 * np.pi / 256; cx, cy = X[upto], Y[upto]; dx, dy = np.cos(a), -np.sin(a)
tri = np.array([[cx + 5 * dx, cy + 5 * dy], [cx - 3 * dx - 3 * dy, cy - 3 * dy + 3 * dx], [cx - 3 * dx + 3 * dy, cy - 3 * dy - 3 * dx]])
def inside(p, t):
    d = lambda a, b, c: (a[0] - c[0]) * (b[1] - c[1]) - (b[0] - c[0]) * (a[1] - c[1])
    s1, s2, s3 = d(p, t[0], t[1]), d(p, t[1], t[2]), d(p, t[2], t[0])
    return not ((s1 < 0 or s2 < 0 or s3 < 0) and (s1 > 0 or s2 > 0 or s3 > 0))
for y in range(int(tri[:, 1].min()), int(tri[:, 1].max()) + 1):
    for x in range(int(tri[:, 0].min()), int(tri[:, 0].max()) + 1):
        if inside((x, y), tri) and 0 <= x < 128 and 0 <= y < 64: img[y, x] ^= 1   # SSD1306_INVERSE
fig, ax = plt.subplots(figsize=(6.4, 3.4))
ax.imshow(img, cmap=matplotlib.colors.ListedColormap(["#0b1320", "#9fe8ff"]), interpolation="nearest")
ax.set_xticks([]); ax.set_yticks([]); ax.grid(False)
for sp in ax.spines.values(): sp.set_visible(False)
ax.set_title("128 x 64 OLED, rendered from path_data.h (car at point %d of %d)" % (upto, len(X)), fontsize=9, color=INK)
save(fig, "oled_preview.png")
