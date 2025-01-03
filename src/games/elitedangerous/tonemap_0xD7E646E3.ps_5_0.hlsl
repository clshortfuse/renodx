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

  float3 hdrColor, sdrColor;
  if (injectedData.toneMapType == 0) {  // vanilla tonemap, tonemaps directly into gamma

    r1.yzw = max(float3(0, 0, 0), r2.yzw);
    r1.xyz = min(r1.yzw, r1.xxx);
    r1.xyz = cb2[6].yyy * r1.xyz;  // autoexposure?
    r1.rgb = applyVanillaTonemap(r1.rgb);

    sdrColor = r1.rgb;
  } else {
    untonemapped *= cb2[6].yyy;
    float3 vanillaColor = pow(applyVanillaTonemap(untonemapped), 2.2f);
    float3 vanillaMidGray = pow(applyVanillaTonemap(float3(0.18, 0.18, 0.18)), 2.2f);
    float vanillaMidGrayRatio = renodx::color::y::from::BT709(vanillaMidGray) / 0.18f;

    r1.xyz = untonemapped;
    r1.xyz *= vanillaMidGrayRatio;
    r1.xyz = renodx::color::grade::UserColorGrading(
        r1.xyz,
        1.f,                                // exposure
        injectedData.colorGradeHighlights,  // highlights, apply before blending
        1.f,                                // shadows
        1.f,                                // contrast
        1.f,                                // saturation
        0.f,                                // dechroma
        0.f);                               // hue correction

    r1.xyz = lerp(vanillaColor, r1.xyz, saturate(vanillaColor));

    r1.xyz = renodx::color::grade::UserColorGrading(
        r1.xyz,
        injectedData.colorGradeExposure,    // exposure
        1.f,                                // highlights
        injectedData.colorGradeShadows,     // shadows
        injectedData.colorGradeContrast,    // contrast
        injectedData.colorGradeSaturation,  // saturation
        injectedData.colorGradeBlowout,     // dechroma
        injectedData.toneMapHueCorrection,  // hue correction
        vanillaColor);                      // hue correction source

    hdrColor = r1.rgb;
    sdrColor = RenoDRTSmoothClamp(r1.rgb);
    r1.rgb = sdrColor;
    r1.xyz = pow(r1.xyz, 1.f / 2.2f);  // output in gamma space
  }

  r1.xyz = log2(r1.xyz);
  r1.xyz = cb2[9].zzz * r1.xyz;  // cb2[9].zzz = 1/2.2
  r1.xyz = float3(2.20000005, 2.20000005, 2.20000005) * r1.xyz;
  r1.xyz = exp2(r1.xyz);

  // center texel
  r1.w = 1 + -cb2[0].x;
  r2.x = 0.5 * cb2[0].x;
  r2.xyz = r1.xyz * r1.www + r2.xxx;
  r2.xyz = t0.Sample(s0_s, r2.xyz).xyz;  // LUT
  r2.xyz = r2.xyz + -r1.xyz;
  r1.xyz = cb2[11].xxx * r2.xyz + r1.xyz;

  if (injectedData.toneMapType == 1) {  // UpgradeToneMap when using Vanilla+
    r1.rgb = renodx::tonemap::UpgradeToneMap(hdrColor, sdrColor, pow(r1.rgb, 2.2f), injectedData.colorGradeLUTStrength);
    r1.rgb = pow(r1.rgb, 1 / 2.2f);
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
