#version 450
#include "./shared.h"
#include "./shared.slang"

static const float kLumaR = 0.29890000820159912109375;
static const float kNegInvLn2 = -1.44269502162933349609375;

vec2 GetVariantUv()
{
#if defined(SPLATOON2_LUT_VARIANT_5404)
    return _36.xy;
#elif defined(SPLATOON2_LUT_VARIANT_8779)
    return _38.xy;
#elif defined(SPLATOON2_LUT_VARIANT_FA7AFD3A)
    return _31.xy;
#elif defined(SPLATOON2_LUT_VARIANT_A73FFA9E)
    return _40.xy;
#elif defined(SPLATOON2_LUT_VARIANT_E7531945)
    return _42.xy;
#elif defined(SPLATOON2_LUT_VARIANT_96F0A646)
    return _37.xy;
#else
#error Unknown Splatoon 2 LUT shader variant
#endif
}

float GetVariantBlendWeight()
{
#if defined(SPLATOON2_LUT_VARIANT_5404)
    return _38.w;
#elif defined(SPLATOON2_LUT_VARIANT_8779)
    return _40.w;
#elif defined(SPLATOON2_LUT_VARIANT_FA7AFD3A)
    return _33.w;
#elif defined(SPLATOON2_LUT_VARIANT_A73FFA9E)
    return _42.w;
#elif defined(SPLATOON2_LUT_VARIANT_E7531945)
    return _44.w;
#elif defined(SPLATOON2_LUT_VARIANT_96F0A646)
    return _39.w;
#else
#error Unknown Splatoon 2 LUT shader variant
#endif
}

vec3 ProjectVariantPosition(vec2 uv, float depth)
{
    float clipX = fma(uv.x, 2.0, -1.0);
    float clipY = fma(uv.y, 2.0, -1.0);
    float clipZ = fma(depth, 2.0, -1.0);

    float posX = fma(clipY, -fp_c3_1._m0[7].y, clipX * fp_c3_1._m0[7].x);
    float posY = fma(clipY, -fp_c3_1._m0[8].y, clipX * fp_c3_1._m0[8].x);
    float posZ = fma(clipY, -fp_c3_1._m0[9].y, clipX * fp_c3_1._m0[9].x);
    float posW = fma(clipY, -fp_c3_1._m0[10].y, clipX * fp_c3_1._m0[10].x);

    posX = fma(clipZ, fp_c3_1._m0[7].z, posX) + fp_c3_1._m0[7].w;
    posY = fma(clipZ, fp_c3_1._m0[8].z, posY) + fp_c3_1._m0[8].w;
    posZ = fma(clipZ, fp_c3_1._m0[9].z, posZ) + fp_c3_1._m0[9].w;
    posW = fma(clipZ, fp_c3_1._m0[10].z, posW) + fp_c3_1._m0[10].w;

    float invW = 1.0 / posW;
    return vec3(posX, posY, posZ) * invW;
}

vec3 ApplyGatherOverlay(vec3 projected, vec3 overlay)
{
#if defined(SPLATOON2_LUT_VARIANT_A73FFA9E) || defined(SPLATOON2_LUT_VARIANT_E7531945) || defined(SPLATOON2_LUT_VARIANT_96F0A646)
    vec3 sphereDelta = fp_c3_1._m0[11].xyz - projected;
    float sphereDistance = length(sphereDelta);
    bool insideSphere = sphereDistance < fp_c3_1._m0[12].z;
    float sphereBlend = clamp(fma(sphereDistance, fp_c3_1._m0[12].x, -fp_c3_1._m0[12].y), 0.0, 1.0);

    if (insideSphere) {
        float gatherBaseX = fma(projected.y, fp_c3_1._m0[13].y, projected.z) * fp_c3_1._m0[13].x;
        float gatherBaseY = fma(projected.y, fp_c3_1._m0[13].y, projected.x) * fp_c3_1._m0[13].x;

        float fracX = (-gatherBaseX - floor(-gatherBaseX)) + fp_c3_1._m0[12].w;
        float fracY = (gatherBaseY - floor(gatherBaseY)) + fp_c3_1._m0[12].w;

        float waveX = sin(fracX * 12.0);
        float waveY = sin(fracY * 12.0);
        float jitterX = fma(waveX, fp_c1_1._m0[0].x, 0.0500000007450580596923828125);
        float jitterY = fma(waveY, fp_c1_1._m0[0].x, 0.0500000007450580596923828125);

        float wrappedXInput = gatherBaseY - jitterX;
        float wrappedYInput = -gatherBaseX - jitterY;
        float wrappedXCell = float(int(trunc(wrappedXInput * 1.111111164093017578125))) * 0.89999997615814208984375;
        float wrappedYCell = float(int(trunc(wrappedYInput * 1.111111164093017578125))) * 0.89999997615814208984375;

        float wrappedX = wrappedXInput - wrappedXCell;
        if (wrappedXInput < wrappedXCell) {
            wrappedX += 0.89999997615814208984375;
        }

        float wrappedY = wrappedYInput - wrappedYCell;
        if (wrappedYInput < wrappedYCell) {
            wrappedY += 0.89999997615814208984375;
        }

        vec2 gatherUv = vec2(jitterX + wrappedX, jitterY + wrappedY);
        vec4 gathered = textureGather(fp_t_tcb_C, gatherUv);
        float gatheredSum = gathered.x + gathered.y + gathered.z + gathered.w;

        vec3 gatherWeights = gatheredSum * fp_c3_1._m0[14].xyz;
        float gatherFade = fma(sphereBlend, -fp_c3_1._m0[14].w, fp_c3_1._m0[14].w);
        float overlayMask = clamp(1.0 - gatherFade, 0.0, 1.0);

        vec3 gatheredOverlay = overlay * gatherWeights;
        vec3 dampedOverlay = fma(gatheredOverlay, vec3(-0.25), overlay);
        vec3 liftedOverlay = gatheredOverlay * 0.25;
        overlay = fma(dampedOverlay, vec3(overlayMask), liftedOverlay);
    }

    return overlay;
#else
    return overlay;
#endif
}

vec3 SampleVanillaColor(vec2 uv, float blendWeight, out vec4 blendSample)
{
#if defined(SPLATOON2_LUT_VARIANT_5404)
    vec3 base = texture(fp_t_tcb_A, uv).xyz;
    blendSample = texture(fp_t_tcb_8, uv);
    return fma(blendSample.xyz * fp_c3_1._m0[4].xyz, blendWeight, base);
#elif defined(SPLATOON2_LUT_VARIANT_8779)
    vec3 lutA = textureLod(fp_t_tcb_C, uv, 0.0).xyz;
    vec3 lutB = textureLod(fp_t_tcb_E, uv, 0.0).xyz;
    blendSample = texture(fp_t_tcb_8, uv);

    vec3 combined = lutA + lutB + blendSample.xyz;
    vec3 weighted = combined * fp_c3_1._m0[4].xyz;
    return weighted * blendWeight;
#elif defined(SPLATOON2_LUT_VARIANT_FA7AFD3A)
    vec3 lutA = textureLod(fp_t_tcb_C, uv, 0.0).xyz;
    vec3 lutB = textureLod(fp_t_tcb_E, uv, 0.0).xyz;
    blendSample = texture(fp_t_tcb_8, uv);

    vec3 combined = lutA + lutB + blendSample.xyz;
    return combined * blendWeight;
#elif defined(SPLATOON2_LUT_VARIANT_A73FFA9E)
    float depth = texture(fp_t_tcb_A, uv).x;
    vec3 base = texture(fp_t_tcb_E, uv).xyz;
    blendSample = texture(fp_t_tcb_8, uv);
    vec3 projected = ProjectVariantPosition(uv, depth);
    vec3 overlay = ApplyGatherOverlay(projected, blendSample.xyz);

    return fma(overlay * fp_c3_1._m0[4].xyz, vec3(blendWeight), base);
#elif defined(SPLATOON2_LUT_VARIANT_E7531945) || defined(SPLATOON2_LUT_VARIANT_96F0A646)
    float depth = texture(fp_t_tcb_A, uv).x;
    blendSample = texture(fp_t_tcb_8, uv);
    vec3 lutA = textureLod(fp_t_tcb_10, uv, 0.0).xyz;
    vec3 lutB = textureLod(fp_t_tcb_12, uv, 0.0).xyz;
    vec3 projected = ProjectVariantPosition(uv, depth);
    vec3 overlay = ApplyGatherOverlay(projected, blendSample.xyz);

    vec3 combined = overlay + lutA + lutB;
    return combined * fp_c3_1._m0[4].xyz * blendWeight;
#else
#error Unknown Splatoon 2 LUT shader variant
#endif
}

float ComputeVariantLuma(vec3 blended)
{
#if defined(SPLATOON2_LUT_VARIANT_A73FFA9E) || defined(SPLATOON2_LUT_VARIANT_E7531945) || defined(SPLATOON2_LUT_VARIANT_96F0A646)
    return fma(blended.z, fp_c1_1._m0[0].z, fma(blended.y, fp_c1_1._m0[0].y, blended.x * kLumaR));
#else
    return fma(blended.z, fp_c1_1._m0[0].y, fma(blended.y, fp_c1_1._m0[0].x, blended.x * kLumaR));
#endif
}

vec3 ComputeVariantLutCoords(vec3 remapped)
{
#if defined(SPLATOON2_LUT_VARIANT_96F0A646) || defined(SPLATOON2_LUT_VARIANT_FA7AFD3A)
    return remapped;
#else
    return fma(remapped, vec3(fp_c3_1._m0[5].x), vec3(fp_c3_1._m0[5].y));
#endif
}

vec3 SampleVariantLut(vec3 lutCoords)
{
#if defined(SPLATOON2_LUT_VARIANT_A73FFA9E) || defined(SPLATOON2_LUT_VARIANT_E7531945)
    return texture(fp_t_tcb_14, lutCoords).xyz;
#elif defined(SPLATOON2_LUT_VARIANT_96F0A646) || defined(SPLATOON2_LUT_VARIANT_FA7AFD3A)
    return lutCoords;
#else
    return texture(fp_t_tcb_10, lutCoords).xyz;
#endif
}

void main()
{
    vec2 uv = GetVariantUv();
    float blendWeight = GetVariantBlendWeight();

    vec4 blendSample;
    vec3 blended = SampleVanillaColor(uv, blendWeight, blendSample);

    out.xyz = lut(blended, true);
#if defined(SPLATOON2_LUT_VARIANT_FA7AFD3A)
    out.w = blendSample.w;
#else
    out.w = blendSample.w * fp_c3_1._m0[4].w;
#endif

    vec3 sdr = lerp(renodx::tonemap::ExponentialRollOff(blended), lut(blended), LUT_STRENGTH);
    if (RENODX_TONE_MAP_TYPE != 0.f) out.xyz = ColourCorrect(lerp(blended, out.xyz, LUT_STRENGTH), sdr);
    else out.xyz = sdr;
    out.xyz = ApplyColorGrade(out.xyz);
    out.xyz = Tonemap(out.xyz);
    out.xyz = renodx::draw::RenderIntermediatePass(out.xyz);
}

vec3 lut(vec3 input, bool hdr = false) {
  float scale = 1.f;
  if (hdr) scale = renodx::tonemap::neutwo::ComputeMaxChannelScale(input);
  input *= scale;

  float luma = ComputeVariantLuma(input);
  float invLuma = 1.0 / luma;

  float lumaCurve = exp2(luma * kNegInvLn2);
  vec3 channelCurve = exp2(input * kNegInvLn2);
  vec3 normalized = input * invLuma;

  float oneMinusLumaCurve = 1.0 - lumaCurve;
  float oneMinusLumaCurveSq = oneMinusLumaCurve * oneMinusLumaCurve;

  vec3 curveBias = fma(normalized, vec3(-oneMinusLumaCurve), -channelCurve);
  vec3 remapped = fma(normalized, vec3(oneMinusLumaCurve), fma(vec3(oneMinusLumaCurveSq), curveBias, vec3(oneMinusLumaCurveSq)));
  vec3 lutCoords = ComputeVariantLutCoords(remapped);
  return SampleVariantLut(lutCoords) / scale;
}