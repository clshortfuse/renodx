#include "C:\Users\Musa\Documents\Programming Projects\renodx\src\games\elitedangerous\common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Thu Jan 02 19:08:33 2025
Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture3D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2) {
  float4 cb2[16];
}

// 3Dmigoto declarations
#define cmp -

/// Vanilla tonemapper
/// @param untonemapped linear untonemapped color
/// @return tonemapped color in gamma space
float3 applyVanillaTonemap(float3 untonemapped) {
  float3 r1, r2, r3;
  r1.rgb = untonemapped;

  r2.xyz = r1.xyz * float3(8.46800041, 8.46800041, 8.46800041) + float3(1, 1, 1);
  r2.xyz = r1.xyz * r2.xyz + float3(-0.00295699993, -0.00295699993, -0.00295699993);
  r2.xyz = r1.xyz * r2.xyz + float3(0.000100400001, 0.000100400001, 0.000100400001);
  r2.xyz = r1.xyz * r2.xyz + float3(-1.274e-007, -1.274e-007, -1.274e-007);
  r3.xyz = r1.xyz * float3(8.3604002, 8.3604002, 8.3604002) + float3(1.82270002, 1.82270002, 1.82270002);
  r3.xyz = r1.xyz * r3.xyz + float3(0.218899995, 0.218899995, 0.218899995);
  r3.xyz = r1.xyz * r3.xyz + float3(-0.00211700005, -0.00211700005, -0.00211700005);
  r1.xyz = r1.xyz * r3.xyz + float3(3.67300017e-005, 3.67300017e-005, 3.67300017e-005);
  r1.xyz = saturate(r2.xyz / r1.xyz);
  return r1;
}

void main(
    float3 v0: TEXCOORD1,
    out float4 o0: SV_TARGET0) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t1.Sample(s1_s, v0.xy).xyzw;
  r0.xyzw = cb2[2].xxxx * r0.xyzw;
  r1.x = 64500 * cb2[2].x;
  r0.xyzw = max(float4(0, 0, 0, 0), r0.xyzw);
  r0.xyzw = min(r0.xyzw, r1.xxxx);
  r1.yzw = t2.Sample(s2_s, v0.xy).xyz;
  r1.yzw = cb2[2].xxx * r1.yzw;
  r1.yzw = max(float3(0, 0, 0), r1.yzw);
  r1.yzw = min(r1.yzw, r1.xxx);
  if (cb2[8].z != 0) {
    r2.x = 1.39999998;
  } else {
    r2.x = 0;
  }
  r2.x = cb2[8].x + r2.x;
  r2.y = 8 * v0.z;
  r2.y = log2(r2.y);
  r2.x = r2.y + -r2.x;
  r2.x = -3 + r2.x;
  r2.z = cb2[7].w + cb2[7].w;
  r2.x = cb2[8].y * r2.x;
  r2.x = exp2(r2.x);
  r2.x = 1 + r2.x;
  r2.x = log2(r2.x);
  r2.x = r2.x * 0.30103001 + r2.z;
  r2.x = r2.z / r2.x;
  r2.x = log2(r2.x);
  r2.x = cb2[7].w * r2.x;
  r2.x = exp2(r2.x);
  r2.x = cb2[7].z * 1.02999997 + -r2.x;
  r2.x = r2.x / v0.z;
  r2.x = log2(r2.x);
  r2.x = -cb2[7].y + r2.x;
  r2.x = exp2(r2.x);
  r3.xyz = r2.xxx * r0.xyz;
  if (cb2[8].z != 0) {
    r2.x = 1.39999998;
  } else {
    r2.x = 0;
  }
  r2.x = cb2[8].x + r2.x;
  r2.x = r2.y + -r2.x;
  r2.x = -3 + r2.x;
  r2.x = cb2[8].y * r2.x;
  r2.x = exp2(r2.x);
  r2.x = 1 + r2.x;
  r2.x = log2(r2.x);
  r2.x = r2.x * 0.30103001 + r2.z;
  r2.x = r2.z / r2.x;
  r2.x = log2(r2.x);
  r2.x = cb2[7].w * r2.x;
  r2.x = exp2(r2.x);
  r2.x = cb2[7].z * 1.02999997 + -r2.x;
  r2.x = r2.x / v0.z;
  r2.x = log2(r2.x);
  r2.x = -cb2[7].y + r2.x;
  r2.x = exp2(r2.x);
  r2.y = cmp(cb2[1].w >= 0);
  if (r2.y != 0) {
    r2.yzw = r2.xxx * r1.yzw + -r3.xyz;
    r2.yzw = cb2[1].www * r2.yzw + r3.xyz;
  } else {
    r2.yzw = r2.xxx * r1.yzw + r3.xyz;
  }
  float3 untonemapped = r2.yzw;

  float3 hdrColor, sdrColor, vanillaColor;
  if (injectedData.toneMapType == 0) {  // vanilla tonemap, tonemaps directly into gamma

    r1.yzw = max(float3(0, 0, 0), r2.yzw);
    r1.xyz = min(r1.yzw, r1.xxx);
    r1.xyz = cb2[6].yyy * r1.xyz;  // autoexposure?
    r1.rgb = applyVanillaTonemap(r1.rgb);

    sdrColor = r1.rgb;
  } else {
    untonemapped *= cb2[6].yyy;
    vanillaColor = pow(applyVanillaTonemap(untonemapped), 2.2f);  // linearized
    float vanillaMidGray = renodx::color::y::from::BT709(pow(applyVanillaTonemap(float3(0.18, 0.18, 0.18)), 2.2f));

    r1.xyz = untonemapped;
    if (injectedData.toneMapType == 4.f) {
      r1.xyz = renodx::color::grade::UserColorGrading(
          r1.xyz,
          1.f,                                // exposure
          injectedData.colorGradeHighlights,  // highlights, apply before blending
          1.f,                                // shadows
          1.f,                                // contrast
          1.f,                                // saturation
          injectedData.colorGradeBlowout,     // dechroma
          0.f);                               // hue correction
      r1.xyz *= vanillaMidGray / 0.18f;       // mid gray

      r1.xyz = lerp(vanillaColor, r1.xyz, saturate(vanillaColor));  // combine tonemap

      r1.xyz = renodx::color::grade::UserColorGrading(
          r1.xyz,
          injectedData.colorGradeExposure,    // exposure
          1.f,                                // highlights
          injectedData.colorGradeShadows,     // shadows
          injectedData.colorGradeContrast,    // contrast
          injectedData.colorGradeSaturation,  // saturation
          0.f,                                // blowout
          injectedData.toneMapHueCorrection,  // hue correction
          vanillaColor);                      // hue correction source

      hdrColor = r1.rgb;
      sdrColor = RenoDRTSmoothClamp(r1.rgb);
      r1.rgb = sdrColor;
    } else {
      renodx::tonemap::config::DualToneMap dual_tone_map = ToneMap(r1.rgb, vanillaColor, vanillaMidGray);
      hdrColor = dual_tone_map.color_hdr;
      sdrColor = dual_tone_map.color_sdr;
      r1.rgb = sdrColor;
    }
    r1.xyz = renodx::color::gamma::Encode(max(0, r1.xyz), 2.2f);  // output in gamma space
  }

  r1.xyz = log2(r1.xyz);
  r1.xyz = cb2[9].zzz * r1.xyz;  // cb2[9].zzz = 1/2.2
  r1.xyz = float3(2.20000005, 2.20000005, 2.20000005) * r1.xyz;
  r1.xyz = exp2(r1.xyz);

  float InvLUTSize = cb2[0].x;    // 1 / LUT_SIZE
  float scale = 1 + -InvLUTSize;  // Makes no sense, this should be "(LUTSize - 1.0) / LUTSize;"
  float bias = 0.5 * InvLUTSize;
  r2.rgb = t0.Sample(s0_s, r1.xyz * scale + bias).rgb;  // LUT
  r1.rgb = lerp(r1.xyz, r2.xyz, cb2[11].x);             // Blend in LUT as a percentage

  if (injectedData.toneMapType > 0) {  // UpgradeToneMap when using Vanilla+
    r1.rgb = UpgradeToneMap(hdrColor, sdrColor, renodx::color::gamma::DecodeSafe(r1.rgb, 2.2f), injectedData.colorGradeLUTStrength);
    r1.rgb = renodx::color::correct::Hue(r1.rgb, vanillaColor, injectedData.toneMapHueCorrection);
    r1.rgb = renodx::color::gamma::EncodeSafe(r1.rgb, 2.2f);
  } else {
    float3 lutInputColor = sdrColor;
    r1.rgb = lerp(lutInputColor, r1.rgb, injectedData.colorGradeLUTStrength);
  }

  r1.xyz = (r1.xyz * cb2[10].yyy + cb2[9].yyy);  // r1.xyz = saturate(r1.xyz * cb2[10].yyy + cb2[9].yyy);

  r1.w = dot(max(0, r1.xyz), float3(0.308600008, 0.609399974, 0.0820000023));
  r1.xyz = r1.xyz + -r1.www;
  r1.xyz = cb2[10].zzz * r1.xyz + r1.www;
  r0.xyz = cb2[10].xxx * r1.xyz;
  // r0.xyzw = max(float4(0,0,0,0), r0.xyzw);
  // r0.xyzw = min(float4(64500,64500,64500,64500), r0.xyzw);
  if (cb2[15].y != 0) {
    r0.xyz = float3(0, 0, 0);
  }
  o0.xyzw = r0.xyzw;

  o0.rgb = DisplayMapAndScale(o0.rgb);
  return;
}
