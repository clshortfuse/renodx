// RenoDX ToneMapPass injection starting shapes.
// Use only after DevKit/resource analysis proves the shader receives real upstream data.
// Keep nearby vanilla code readable or commented when adapting decompiled shaders.
// This file is a snippet asset, not a standalone shader. Copy/adapt one pattern
// into the proven target shader and replace placeholder signal names there.

#if 0

// Pattern 1: graded path with an engineered neutral/reference baseline.
// Do not set neutral_sdr to saturate(untonemapped). Raw hard clip of the HDR
// source destroys hue/saturation and is not a valid recommendation. Use a
// proven analytic vanilla tonemap, RenoDRT neutral, max-channel/gamut-compressed
// LUT proxy, or selective clip-emulation baseline that matches the grade path.
// All ToneMapPass inputs here are linear; decode sRGB/gamma LUT outputs before
// assigning them to neutral_sdr or graded_sdr.
float3 untonemapped = scene_color;              // Proven scene/pre-SDR signal.
float3 neutral_sdr = engineered_neutral_sdr;    // Proven neutral/reference baseline for UpgradeToneMap.
float3 graded_sdr = vanilla_graded_sdr;         // Vanilla SDR after grade/LUT/masks.
float3 output_color = renodx::draw::ToneMapPass(untonemapped, graded_sdr, neutral_sdr);

// Pattern 2: no grade/LUT preservation is needed.
float3 output_color_no_lut = renodx::draw::ToneMapPass(untonemapped);

// Pattern 3: graded SDR is trustworthy and default RenoDRT neutral is acceptable.
float3 output_color_graded = renodx::draw::ToneMapPass(untonemapped, graded_sdr);

// Pattern 4: intermediate-output shader path. Apply the proven tonemap first,
// then write through RenderIntermediatePass so the later swapchain proxy can
// decode/encode consistently.
float3 tonemapped = renodx::draw::ToneMapPass(untonemapped);
float3 intermediate = renodx::draw::RenderIntermediatePass(tonemapped);

#endif