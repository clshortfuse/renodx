---
name: bt2020-png-generation
description: "RenoDX workflow for generating, validating, or debugging BT.2020/BT.2100 HDR PNG artifacts from EXR, linear RGB, nits arrays, scalar maps, or analysis images. Use when creating PQ/ST 2084 16-bit PNGs, injecting or checking PNG cICP chunks, converting AP0/D60 or BT.709 data to BT.2020, producing Discord/Chrome HDR PNG test files, testing HDR/PQ ICC profiles with cicpTag, or avoiding repeated one-off HDR image experiments."
argument-hint: "input image/data, source color space, diffuse white/peak nits, output path, and whether Discord/ICC preview behavior matters"
---

# BT.2020 HDR PNG Generation

Use this skill when generating **BT.2020/BT.2100 HDR PNG** analysis artifacts. The goal is to stop repeating one-off scripts for the same PNG/PQ/cICP plumbing.

## Related smaller skills

- Use `hdr-test-pattern-generation` first when the task is to design ramps, sweeps, charts, banding panels, checkerboards, or other synthetic validation inputs.
- Use `analysis-graphing` when the task is to plot curves, hue sweeps, gamut comparisons, LUT statistics, or readable graph images.
- Use this skill for the final BT.2020/PQ/cICP/ICC PNG output path and validation after the input image or analysis data already exists.

## Boundaries

- Focus on PNG/HDR image generation and validation, not shader changes.
- Keep scratch outputs in a temporary output path unless the user asks for durable analysis artifacts.
- Prefer a reusable script or helper under `tools/analysis/` for repeated workflows; do not keep cloning the same `write_png_rgb16_with_cicp` and `pq_oetf_st2084` code into new one-off experiments.
- Do not embed graphing or synthetic-pattern design rules here; delegate those to `analysis-graphing` and `hdr-test-pattern-generation`.
- If the work becomes shader-side tonemap/LUT math, switch to the SDR tonemap/LUT workflow instead.
- Do not add ICC profiles, AVIF gain maps, JPEG metadata, or platform upload experiments unless the user explicitly asks for that output type. If they ask about Discord, Chrome preview, or Chromium issue 40239687, include the optional HDR ICC path below.

## Canonical output

Generate a **16-bit RGB PNG** whose pixel values are **PQ/ST 2084 encoded absolute nits** and whose PNG contains a native `cICP` chunk:

| Field | Value | Meaning |
|---|---:|---|
| color primaries | `9` / `0x09` | BT.2020 / BT.2100 primaries |
| transfer characteristics | `16` / `0x10` | SMPTE ST 2084 PQ |
| matrix coefficients | `0` / `0x00` | RGB / identity matrix for PNG RGB samples |
| video full range flag | `1` / `0x01` | Full range |

The PNG `cICP` payload bytes are therefore:

```text
09 10 00 01
```

Do not use matrix coefficient `6` for RGB PNG samples. `9/16/6` is useful for YUV BT.2020 NCL encodes such as many AVIF/video paths, not native RGB PNG pixels.

## Optional HDR ICC / Discord preview mode

Use this only when the user asks for **Discord preview**, **Chrome HDR ICC**, **`cicpTag`**, or **Chromium issue 40239687** behavior. Keep the normal analysis output as native PNG `cICP` unless ICC compatibility is the point of the test.

Chromium issue 40239687 tracks Chrome's backwards-compatible HDR image support through a CICP tag embedded in an ICC profile. Chrome uses the ICC `cicpTag` to discover PQ/HLG HDR signaling for image formats such as JPEG, PNG, and WebP. The ICC transform itself should still be a reasonable SDR/tone-mapped fallback for decoders that ignore the `cicpTag`.

For the RenoDX Discord tests, the important behavior is:

| Path | Practical result |
|---|---|
| Native PNG `cICP` only | Good for local RGB16 HDR PNG analysis, but Discord's WebP preview has no native CICP to carry forward. |
| PNG + HDR/PQ ICC with `cicpTag` | Discord may preserve the ICC into the generated 8-bit WebP preview, allowing Chrome to present the preview as HDR. Expect 8-bit PQ preview banding. |
| JPEG + HDR/PQ ICC with `cicpTag` | Similar signaling mechanism; verify the embedded ICC `cicp` tag matches the intended HDR signaling. |
| AVIF primary ICC | Useful for Discord/Chrome experiments, but current Windows AVIF preview tests misdisplay or reject primary-ICC AVIFs. |
| Gain-map metadata | Discord/Lilliput preview does not preserve gain-map metadata through the transform path; use source ICC if preview HDR signaling is required. |

Reference notes live in:

- `docs/AVIF_HDR_FINDINGS.md`
- Chromium issue `40239687`: "Backwards-compatible HDR images via CICP in ICC profiles"

Rules for ICC mode:

- Only attach a HDR/PQ ICC when the pixels are actually PQ-encoded HDR pixels in the matching gamut.
- Do not tag SDR/gamma pixels with a HDR/PQ ICC.
- For RGB PNG/WebP/JPEG HDR ICC signaling, the embedded ICC `cicpTag` should advertise BT.2020 primaries, PQ transfer, RGB/identity matrix, and full range: `9/16/0/full`.
- If both native PNG `cICP` and ICC are present, keep them semantically aligned. PNG native `cICP` is expected to take precedence, while Discord WebP preview relies on ICC because WebP lacks native CICP.
- Treat Discord preview success as metadata-driven HDR over 8-bit WebP. It does not prove high-bit-depth precision survived the preview path.
- Preserve a no-ICC/native-cICP output when the goal is a clean local analysis artifact rather than a Discord upload experiment.

## Expected agent output

When invoked, produce these sections:

1. **Input assumptions** - file/data source, source gamut, white point, transfer, and whether values are scene-linear, display-linear nits, or already PQ.
2. **Conversion path** - matrices/adaptation used to reach BT.2020 D65 linear RGB.
3. **Nits mapping** - diffuse white nits, peak/clip linear, and explicit clipping policy.
4. **PNG signaling** - bit depth, PQ encode, `cICP` tuple, and whether ICC/profile metadata is intentionally absent or intentionally attached.
5. **Validation** - stats, read-back cICP check, and any viewer/upload caveats.
6. **Reuse plan** - existing utility/helper used, or the reusable helper that should be promoted instead of another one-off clone.

## Step 1: Classify the input

Do not normalize or matrix-convert blindly. Identify the source first:

| Source | Required handling |
|---|---|
| AP0/D60 EXR | AP0 to XYZ, chromatic-adapt D60 to D65, then XYZ to BT.2020. |
| ACEScg/AP1 D60 | AP1 to XYZ, chromatic-adapt D60 to D65, then XYZ to BT.2020. |
| BT.709/sRGB D65 linear | Convert BT.709 to XYZ, then XYZ to BT.2020. Do not apply sRGB unless the input is explicitly nonlinear. |
| BT.2020 D65 linear | Use directly after validating units and range. |
| Absolute display nits | Use directly for PQ encode after gamut/range checks. |
| Scalar/energy map | Replicate to RGB only after choosing the intended nits scale. |
| Already PQ encoded | Do not PQ-encode again; only quantize/write and signal correctly. |

Keep negative and out-of-gamut values long enough to report stats. Clip only at the explicit output boundary.

## Step 2: Convert to BT.2020 D65 linear RGB

Use stable, explicit matrices from existing analysis scripts when available. Existing references include:

- `tools/analysis/build_hdr_png_cicp.py` for AP0/D60 EXR to BT.2020 PQ PNG and cICP read/write helpers.
- `tools/analysis/export_energy_bw_hdr_png.py` and `tools/analysis/export_energy_comparison_hdr.py` for scalar/energy-map HDR PNG patterns.
- `tools/analysis/synthetic_neutwo_energy_reapply_bt2020.py` for synthetic BT.2020 PQ outputs.

If the same helper code is needed in a new durable script, prefer extracting or reusing a shared utility instead of pasting another copy into a scratch script.

## Step 3: Map scene values to absolute nits

Use explicit luminance mapping:

```text
nits = max(bt2020_linear, 0) * diffuse_white_nits
```

Common RenoDX analysis defaults:

| Parameter | Default | Notes |
|---|---:|---|
| diffuse white | `100` nits | Linear `1.0` maps to reference white. |
| peak linear | `8.0` | Often means an `800` nit analysis peak at 100 nit diffuse white. |
| PQ maximum | `10000` nits | ST 2084 encode domain. |
| minimum | `0` or `0.005` nits | Use `0.005` only when the experiment needs display black. |

Do not silently scale image max to 1.0. If normalization is intentionally part of the experiment, name it and record it in stats.

## Step 4: Encode PQ/ST 2084

Use the ST 2084 OETF constants consistently:

```text
m1 = 2610 / 16384
m2 = 2523 / 32
c1 = 3424 / 4096
c2 = 2413 / 128
c3 = 2392 / 128
V = ((c1 + c2 * (L / 10000)^m1) / (1 + c3 * (L / 10000)^m1))^m2
```

Clamp nits to `[0, 10000]` before encoding, then quantize with rounding to `uint16`:

```text
png16 = round(saturate(pq) * 65535)
```

## Step 5: Write the PNG correctly

For a dependency-light path, write RGB16 PNG bytes directly:

- PNG signature: `89 50 4E 47 0D 0A 1A 0A`.
- `IHDR`: bit depth `16`, color type `2` (truecolor RGB), no interlace.
- Store 16-bit samples big-endian.
- Use filter type `0` per row unless testing filters/compression.
- Insert `cICP` before `IDAT` with bytes `09 10 00 01`.
- Write `IDAT` and `IEND` with correct CRCs.

[BT.2020 PQ PNG template](./templates/bt2020_pq_png.py) contains a small reusable Python implementation for ST 2084 encoding and RGB16 PNG `cICP` writing. Prefer adapting it over cloning another scratch writer.

Avoid Pillow unless the current environment is known to preserve 16-bit RGB exactly. Many easy Pillow paths downcast, reorder, or treat RGB16 inconsistently.

## Step 6: Validate every generated PNG

At minimum, report:

| Check | Expected |
|---|---|
| Bit depth/color type | RGB, 16-bit. |
| `cICP` chunk | `(9, 16, 0, 1)`. |
| Optional ICC path | `iCCP` present, ICC contains `cicp` tag `9/16/0/full`, and native `cICP` is not contradictory. |
| Nits mapping | Linear `1.0` maps to the chosen diffuse white. |
| Clip stats | Negative channels clipped, channels above 10000 nits clipped, nonfinite pixels excluded or replaced. |
| Round trip | Decode a sample PQ value and verify the expected nits. |

Useful stats keys:

```text
pixels_total
source_min/source_max
bt2020_min/bt2020_max
negative_bt2020_channels_clipped
over_10000_nits_channels_clipped
diffuse_white_nits
peak_linear
cicp_cp_tc_mc_range
icc_present
icc_cicp_cp_tc_mc_range
```

## Common mistakes to avoid

- Do not write an 8-bit PNG for HDR precision tests unless testing an 8-bit preview path.
- Do not use sRGB or gamma 2.2 encoding for HDR PNG pixels.
- Do not tag SDR/gamma pixels as PQ/BT.2020.
- Do not PQ-encode data that is already PQ.
- Do not use `9/16/6` for native RGB PNG samples.
- Do not assume a native PNG `cICP` chunk will survive Discord's WebP preview path.
- Do not assume a Discord HDR preview means the preview kept more than 8-bit precision.
- Do not attach a primary HDR ICC to AVIF when Windows preview compatibility matters.
- Do not omit cICP and assume a viewer will infer HDR.
- Do not hide clipping by normalizing the image max.
- Do not add a new one-off script when the task is just EXR/linear/scalar to BT.2020 PQ PNG.

## Promotion rule

If an experiment repeats any two of these pieces, make or reuse a common utility instead of a scratch clone:

- ST 2084 PQ encode/decode.
- RGB16 PNG byte writing.
- PNG `cICP` insertion/read-back.
- HDR ICC `cicpTag` insertion/read-back.
- AP0/AP1/BT.709 to BT.2020 conversion.
- clip/stat CSV generation.
