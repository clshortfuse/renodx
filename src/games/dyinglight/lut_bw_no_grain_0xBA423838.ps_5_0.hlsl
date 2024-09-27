#include "./shared.h"
#include "./DICE.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Sat May 25 22:39:34 2024
Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[7];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = -abs(v2.xy) * abs(v2.xy) + float2(1,1);
  r0.x = saturate(-r0.x * r0.y + 1);
  r0.x = cb0[2].x * r0.x;
  r0.x = cb0[0].w * r0.x;
  r0.y = t0.SampleLevel(s0_s, v1.xy, 0).x;
  r0.z = t0.SampleLevel(s0_s, v1.zw, 0).z;
  r1.xyzw = t0.SampleLevel(s0_s, v2.zw, 0).xyzw;
  r0.yz = -r1.xz + r0.yz;
  r1.xz = r0.xx * r0.yz + r1.xz;
  o0.w = r1.w;
  r0.x = dot(float3(0.212500006,0.715399981,0.0720999986), r1.xyz);
  r0.yzw = r0.xxx + -r1.xyz;
  r0.x = saturate(r0.x * cb0[0].y + cb0[0].z);
  r0.x = cb0[0].x * r0.x;
  r0.xyz = r0.xxx * r0.yzw + r1.xyz;
  r0.w = dot(r0.xyz, cb0[1].xyz);
  r0.xyz = r0.xyz * cb0[1].www + r0.www;  //  r0.xyz = saturate(r0.xyz * cb0[1].www + r0.www);
  r0.w = saturate(dot(r0.xyz, cb0[3].xyz));
  r1.xyz = cb0[5].xyz * r0.www;
  r2.xyz = r0.xyz * cb0[6].xyz + -r1.xyz;
  r0.w = saturate(dot(r0.xyz, cb0[4].xyz));
  r1.xyz = r0.www * r2.xyz + r1.xyz;  //  r1.xyz = saturate(r0.www * r2.xyz + r1.xyz);
  r0.xyz = r0.xyz * cb0[5].www + r1.xyz;  //  r0.xyz = saturate(r0.xyz * cb0[5].www + r1.xyz);

  float3 outputColor = r0.xyz;
  float3 hdrColor = outputColor;
  float3 sdrColor = outputColor;
  const float vanillaMidGray = 0.178f;
  if (injectedData.toneMapType == 2) {    
    const float paperWhite = injectedData.toneMapGameNits / renodx::color::srgb::REFERENCE_WHITE;
    const float peakWhite = injectedData.toneMapPeakNits / renodx::color::srgb::REFERENCE_WHITE;
    const float highlightsShoulderStart = min(0.5, vanillaMidGray * paperWhite);  // Don't tonemap the blended part of the tonemapper

    DICESettings config = DefaultDICESettings();
    config.Type = 1;
    config.ShoulderStart = highlightsShoulderStart;

    hdrColor = outputColor * paperWhite;  // scale paper white for PQ DICE
    hdrColor = DICETonemap(hdrColor, peakWhite, config);
    sdrColor = DICETonemap(hdrColor, paperWhite, config);

    // back to 80 nits
    hdrColor /= paperWhite;
    sdrColor /= paperWhite;
  }
  r0.xyz = sdrColor;

  // LUT
  r0.xyz = sign(r0.xyz) * pow(abs(r0.xyz), 1.f / 2.2f );
  r0.xyz = r0.xyz * float3(0.99609375,0.99609375,0.99609375) + float3(0.001953125,0.001953125,0.001953125);
  r1.x = t2.Sample(s2_s, r0.xx).x;
  r1.y = t2.Sample(s2_s, r0.yy).y;
  r1.z = t2.Sample(s2_s, r0.zz).z;
  r0.xyz = sign(r1.xyz) * pow(abs(r1.xyz), 2.2f );

  if (injectedData.toneMapType > 1) {
    outputColor = renodx::tonemap::UpgradeToneMap(hdrColor, saturate(sdrColor), r0.xyz, injectedData.colorGradeLUTStrength);
  } else if (injectedData.toneMapType == 0) {
    outputColor = lerp(outputColor, r0.xyz, injectedData.colorGradeLUTStrength);
  }

  r1.xyz = t1.SampleLevel(s1_s, v2.zw, 0).xyz;
  o0.xyz = r1.xyz * outputColor; //  o0.xyz = r1.xyz * r0.xyz;
  return;
}