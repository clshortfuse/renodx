---
name: analysis-graphing
description: "RenoDX workflow for creating readable analysis graphs and plots from shader math, CSVs, EXRs, LUTs, hue sweeps, tone curves, gamut comparisons, energy/scalar maps, and test-pattern statistics. Use when graphing, plotting, visualizing, comparing curves, making dark-theme matplotlib figures, or avoiding repeated one-off plot scripts."
argument-hint: "data source, variables to compare, output path, units/axis scale, and whether the graph is scratch or durable"
---

# RenoDX Analysis Graphing

Use this small skill for **plots and graphs**. Larger skills should call this out instead of embedding graphing rules.

## Boundaries

- Focus on visualizing data, not generating source test images or editing shaders.
- Keep one-off plots and source scripts in a scratch output path unless the graph becomes a durable analysis artifact.
- Promote repeated graph workflows into `tools/analysis/` with the data export beside the image.
- Prefer `matplotlib` for Python analysis unless an existing script in the same workflow already uses another plotting library.
- Use `bt2020-png-generation` for final HDR PQ PNG writing and signaling.
- Use `hdr-test-pattern-generation` for ramps, sweeps, charts, and synthetic image inputs.

## Default style

- Use a dark theme by default: `plt.style.use("dark_background")`.
- Save readable static images: usually PNG at `dpi=150` to `180`.
- Choose figure sizes for labels first, not minimum pixels; common overview plots are `14x9`, `16x11`, or `17x11` inches.
- Close figures after saving to avoid leaking state in batch scripts.
- If the graph will be inspected in an issue or PR, prefer a single self-contained overview image plus any focused split images.

## Plot checklist

For every generated graph, make the output self-describing:

- Title states the experiment and transform/version being compared.
- Axes include units: nits, linear RGB, PQ code value, hue degrees, stops, frame index, etc.
- Legends use stable method names matching CSV column names or shader function names.
- Include reference lines for anchors such as zero, diffuse white, mid-gray, `1.0`, peak nits, or gamut boundary when relevant.
- Do not normalize silently. If data is normalized, show the normalization factor in the title, label, or CSV.
- Use log/stops axes only when the labels make the scale obvious.
- Save the plotted source data as CSV when values are generated rather than loaded from an existing CSV.

## Common RenoDX graph types

| Graph type | Use for | Notes |
|---|---|---|
| Tone/inverse diagnostic curve | Vanilla vs RenoDRT/PsychoV/ACES matching | Mark diffuse white, mid-gray, peak, and shoulder anchors; inverse plots are for fitting/diagnosis, not final-frame inverse-tonemap strategy. |
| Gain/loss or delta plot | Comparing old/new math or fitted curves | Plot absolute output and error/delta, not only one. |
| Hue sweep | Gamut compression, hue preservation, negative-channel checks | Hue degrees on x-axis; include min/max channel or perceptual metric. |
| Gamut scatter / chip grid | BT.709, BT.2020, AP1/AP0 comparisons | State source gamut and adaptation path. |
| LUT/stat overview | LUT pair comparisons, channel summaries, error histograms | Keep CSV summaries beside the graph. |
| Image diagnostic panel | EXR/test-pattern before/after comparisons | Use fixed scales when comparing panels. |

## Existing examples

- [Dark plot template](./templates/dark_plot.py) for a minimal reusable matplotlib setup.
- `tools/analysis/plot_cp2077_*` for readable dark-theme multi-panel graphs.
- `tools/analysis/validate_mb_compress.py` for hue sweep validation and CSV-plus-plot output.
- scratch `zelda_*` curve and derivative plots.

## Common mistakes to avoid

- Do not output light-theme graphs unless the user explicitly requests that style.
- Do not crop legends, tick labels, or colorbars; use `tight_layout()` or explicit layout spacing.
- Do not mix scene-linear, display-linear nits, and encoded PQ values on one axis without clear labels.
- Do not present a graph without preserving the script or source CSV needed to reproduce it.
- Do not keep copying a repeated plotting scaffold across scratch scripts; promote the pattern when it recurs.
