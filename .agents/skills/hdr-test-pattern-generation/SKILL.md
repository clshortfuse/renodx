---
name: hdr-test-pattern-generation
description: "RenoDX workflow for generating HDR/SDR test patterns, synthetic charts, ramps, gradients, hue sweeps, color bars, checkerboards, banding panels, gamut stress images, BT.709/BT.2020/AP1 comparisons, and scalar/energy-map validation sources. Use when making test pattern images or datasets for tonemap, gamut, LUT, PsychoV, RenoDRT, HDR, or cICP validation."
argument-hint: "pattern type, source gamut/transfer, nits or linear range, dimensions, output format, and validation target"
---

# HDR Test Pattern Generation

Use this small skill for **creating source patterns and synthetic datasets**. Larger skills should reference it instead of embedding pattern design rules.

## Boundaries

- Focus on generating deterministic test inputs: ramps, sweeps, charts, masks, and diagnostic images.
- Use `analysis-graphing` for plots of pattern statistics or transform curves.
- Use `bt2020-png-generation` when the final deliverable is a BT.2020 PQ RGB16 PNG with `cICP` or HDR ICC metadata.
- Keep one-off experiments in a scratch output path; promote repeated generators or durable fixtures to `tools/analysis/` or the relevant test asset folder.
- Do not silently reuse an existing image if the task needs a controlled source domain; document the source gamut, transfer, white point, and value units.

## First classify the pattern goal

Before generating pixels, state what the pattern is intended to expose:

- Tone-map shape, shoulder, toe, mid-gray, or diffuse-white behavior.
- Gamut mapping, hue preservation, negative-channel clipping, or out-of-gamut handling.
- LUT precision, tetrahedral/trilinear interpolation, or banding.
- PQ/HLG/SDR transfer correctness and viewer metadata behavior.
- Spatial artifacts: edge halos, checkerboard instability, bloom thresholds, sharpening, or temporal reprojection.
- Scalar/energy maps for RenoDRT/PsychoV/N2 reapply experiments.

## Source domain checklist

Every pattern needs explicit metadata in the script, filename, or sidecar stats:

| Field | Examples |
|---|---|
| Gamut / primaries | BT.709, BT.2020, AP1, AP0 |
| White point | D65, D60, adapted D60→D65 |
| Transfer | scene-linear, display-linear nits, sRGB, PQ |
| Value scale | `0..1`, stops around 1.0, absolute nits, diffuse-white-relative |
| Bit depth / format | EXR float, RGB16 PNG, 8-bit preview PNG/WebP |
| Clipping policy | preserve negatives for stats, clip only at output, hard clip to gamut, mask out-of-gamut |

Do not normalize pattern maxima unless normalization is the experiment.

## Useful pattern families

| Pattern | Use for | Notes |
|---|---|---|
| Neutral ramp / step wedge | Tone curves, PQ quantization, banding | Include fine ramp plus labeled stops or nits steps. |
| Hue sweep | Gamut compression and hue preservation | Sweep hue in a known gamut; keep saturation/value and luminance assumptions explicit. |
| Primary/secondary chips | BT.709/BT.2020/AP1 comparison | Include white/gray references and expected out-of-gamut chips. |
| OOG stress chart | Negative channels, over-1 values, matrix/adaptation errors | Preserve unclipped stats before output clipping. |
| Banding panel | 8-bit/10-bit/16-bit path checks | Use smooth ramps plus small-amplitude perturbations when needed. |
| Checker/edge pattern | Spatial filters, bloom, sharpening, TAA artifacts | Include hard edges and subpixel-aligned variants if relevant. |
| Synthetic scene chart | End-to-end tone/gamut validation | Keep source EXR and rendered outputs together. |
| Scalar/energy map | N2/RenoDRT/PsychoV energy diagnostics | Replicate to RGB only at the final visualization/export step. |

## Output guidance

- Prefer EXR float for source fixtures that must preserve scene-linear or out-of-range values.
- Use ordinary SDR PNG only for quick human previews or SDR-specific tests.
- Use BT.2020 PQ RGB16 PNG plus `cICP` only for HDR delivery or viewer-signaling tests.
- Keep stats beside generated outputs: min/max, nonfinite count, negative channels, over-range channels, chosen nits mapping, and source domain.
- Name files with the important domain choices, for example `bt709_linear_hue_sweep`, `bt2020_hdr_pq_100nits`, or `syntheticChart_rec709_finite`.

## Existing references

- [HDR pattern template](./templates/hdr_pattern_template.py) for deterministic ramps, hue sweeps, and sidecar stats.
- `tests/D3D12HDR-test/images/syntheticChart_rec709.01.exr` for a recurring synthetic chart source.
- `tests/D3D12HDR-test/images/RGB_sweep_smooth_31x50.exr` for RGB sweep validation.
- `tools/analysis/synthetic_neutwo_energy_reapply_bt2020.py` for synthetic chart to BT.2020 HDR output workflow.
- `tools/analysis/validate_mb_compress.py` for BT.2020 hue sweep validation patterns.
- `tools/analysis/syntheticChart_rec709_finite/` for generated comparisons and stats.

## Common mistakes to avoid

- Do not mix BT.709, BT.2020, AP1, and AP0 values without naming the conversion path.
- Do not apply sRGB transfer to data that is already linear or PQ.
- Do not PQ-encode twice.
- Do not clip negative or out-of-gamut values before recording diagnostics unless clipping is the behavior being tested.
- Do not rely on screenshots as validation assets when exact pixels or metadata matter.
- Do not create a new pattern generator when an existing source fixture or script already covers the same controlled case.
