#include "../common/ACES.hlsl"
#include "../common/color.hlsl"
#include "./shared.h"

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[204];
}

cbuffer cb13 : register(b13) {
  ShaderInjectData injectedData : packoffset(c0);
}

// 3Dmigoto declarations
#define cmp -

float4 main(float4 v0 : SV_POSITION0, float2 v1 : TEXCOORD0) : SV_Target0 {
  float4 r0, r1, r2, r3, r4, r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  float4 texture0Color = t0.Sample(s0_s, v1.xy).xyzw;
  float4 texture2Color = t2.Sample(s0_s, v1.xy).xyzw;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r1.xyzw = t2.Sample(s0_s, v1.xy).xyzw;
  r0.w = cmp(0 < cb0[191].x);
  if (r0.w != 0) {
    r2.xyz = r1.xyz * r1.www;
    r1.xyz = float3(8, 8, 8) * r2.xyz;
  }
  r1.xyz = cb0[190].xxx * r1.xyz;
  r0.xyz = r1.xyz * cb0[190].yzw + r0.xyz;
  r0.w = cmp(0 < cb0[198].z);
  if (r0.w != 0) {
    r1.xy = -cb0[198].xy + v1.xy;
    r1.yz = cb0[198].zz * abs(r1.xy);
    r1.x = cb0[197].w * r1.y;
    r0.w = dot(r1.xz, r1.xz);
    r0.w = 1 + -r0.w;
    r0.w = max(0, r0.w);
    r0.w = log2(r0.w);
    r0.w = cb0[198].w * r0.w;
    r0.w = exp2(r0.w);
    r1.xyz = float3(1, 1, 1) + -cb0[197].xyz;
    r1.xyz = r0.www * r1.xyz + cb0[197].xyz;
    r0.xyz = r1.xyz * r0.xyz;
  }
  r1.xyz = cb0[188].www * r0.zxy;
  r1.xyz = r1.xyz * float3(5.55555582, 5.55555582, 5.55555582) + float3(0.0479959995, 0.0479959995, 0.0479959995);
  r1.xyz = max(float3(0, 0, 0), r1.xyz);
  r1.xyz = log2(r1.xyz);
  r1.xyz = saturate(r1.xyz * float3(0.0734997839, 0.0734997839, 0.0734997839) + float3(0.386036009, 0.386036009, 0.386036009));
  r1.yzw = cb0[188].zzz * r1.xyz;
  r0.w = floor(r1.y);
  r2.xy = float2(0.5, 0.5) * cb0[188].xy;
  r2.yz = r1.zw * cb0[188].xy + r2.xy;
  r2.x = r0.w * cb0[188].y + r2.y;
  r3.xyzw = t3.SampleLevel(s0_s, r2.xz, 0).xyzw;
  r4.x = cb0[188].y;
  r4.y = 0;
  r1.yz = r4.xy + r2.xz;
  r2.xyzw = t3.SampleLevel(s0_s, r1.yz, 0).xyzw;
  r0.w = r1.x * cb0[188].z + -r0.w;
  r1.xyz = r2.xyz + -r3.xyz;
  r1.xyz = r0.www * r1.xyz + r3.xyz;
  r0.w = cmp(cb0[203].y == 0.000000);
  if (r0.w != 0) {
    r0.w = cmp(0 < cb0[189].w);
    if (r0.w != 0) {
      r1.xyz = saturate(r1.xyz);
      r2.xyz = float3(12.9200001, 12.9200001, 12.9200001) * r1.xyz;
      r3.xyz = log2(r1.xyz);
      r3.xyz = float3(0.416666657, 0.416666657, 0.416666657) * r3.xyz;
      r3.xyz = exp2(r3.xyz);
      r3.xyz = r3.xyz * float3(1.05499995, 1.05499995, 1.05499995) + float3(-0.0549999997, -0.0549999997, -0.0549999997);
      r4.xyz = cmp(float3(0.00313080009, 0.00313080009, 0.00313080009) >= r1.xyz);
      r2.xyz = r4.xyz ? r2.xyz : r3.xyz;
      r3.xyz = cb0[189].zzz * r2.zxy;
      r0.w = floor(r3.x);
      r3.xw = float2(0.5, 0.5) * cb0[189].xy;
      r3.yz = r3.yz * cb0[189].xy + r3.xw;
      r3.x = r0.w * cb0[189].y + r3.y;
      r4.xyzw = t4.SampleLevel(s0_s, r3.xz, 0).xyzw;
      r5.x = cb0[189].y;
      r5.y = 0;
      r3.xy = r5.xy + r3.xz;
      r3.xyzw = t4.SampleLevel(s0_s, r3.xy, 0).xyzw;
      r0.w = r2.z * cb0[189].z + -r0.w;
      r3.xyz = r3.xyz + -r4.xyz;
      r3.xyz = r0.www * r3.xyz + r4.xyz;
      r3.xyz = r3.xyz + -r2.xyz;
      r2.xyz = cb0[189].www * r3.xyz + r2.xyz;
      r3.xyz = float3(0.0773993805, 0.0773993805, 0.0773993805) * r2.xyz;
      r4.xyz = float3(0.0549999997, 0.0549999997, 0.0549999997) + r2.xyz;
      r4.xyz = float3(0.947867334, 0.947867334, 0.947867334) * r4.xyz;
      r4.xyz = log2(abs(r4.xyz));
      r4.xyz = float3(2.4000001, 2.4000001, 2.4000001) * r4.xyz;
      r4.xyz = exp2(r4.xyz);
      r2.xyz = cmp(float3(0.0404499993, 0.0404499993, 0.0404499993) >= r2.xyz);
      r1.xyz = r2.xyz ? r3.xyz : r4.xyz;
    }
  }
  r0.w = cmp(cb0[203].x < 1);
  if (r0.w != 0) {
    r2.xyzw = t1.SampleLevel(s1_s, v1.xy, 0).xyzw;
    r0.w = r2.w * 255 + 0.5;
    r0.w = (uint)r0.w;
    r0.w = (int)r0.w & 3;
    r0.w = cmp((int)r0.w != 1);
    r0.w = r0.w ? 1.000000 : 0;
    r1.w = 1 + -cb0[203].x;
    r0.w = r0.w * r1.w + cb0[203].x;
    r0.xyz = float3(-1.51571655, -1.51571655, -1.51571655) * r0.xyz;
    r0.xyz = exp2(r0.xyz);
    r0.xyz = float3(1, 1, 1) + -r0.xyz;
    r2.xyz = r1.xyz + -r0.xyz;
    r1.xyz = r0.www * r2.xyz + r0.xyz;
  }

  float3 outputColor = r1.xyz;
  switch (injectedData.toneMapperEnum) {
    case 1:
      outputColor = texture0Color.rgb;  // Untonemapped
      outputColor *= injectedData.gamePaperWhite / injectedData.uiPaperWhite;
      break;
    case 2:
      outputColor = aces_rrt_odt(
        texture0Color.rgb * 4.f,
        0.0001f,  // minY
        48.f * (injectedData.gamePeakWhite / injectedData.gamePaperWhite),
        IDENTITY_MAT  // Don't clip gamut
      );
      outputColor = mul(AP1_2_BT709_MAT, outputColor);
      outputColor *= injectedData.gamePeakWhite / injectedData.gamePaperWhite;

      outputColor *= injectedData.gamePaperWhite / injectedData.uiPaperWhite;
      break;
    case 0:
    default:
      break;
  }
  return float4(outputColor.rgb, 1.f);
}
