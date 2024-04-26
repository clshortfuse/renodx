// Final output + FXAA

#include "../../shaders/color.hlsl"
#include "./shared.h"

cbuffer cbGlobalsShared : register(b1) {
  uint g_Booleans : packoffset(c0);
  uint g_Flags : packoffset(c0.y);
  float g_AlphaThreshold : packoffset(c0.z);
}

SamplerState TextureInput_s_s : register(s0);
Texture2D<float4> TextureInput : register(t0);

// 3Dmigoto declarations
#define cmp -

void main(float4 v0 : SV_Position0, float4 v1 : TEXCOORD0, float4 v2 : TEXCOORD1, float4 v3 : TEXCOORD2, float4 v4 : TEXCOORD3, float4 v5 : TEXCOORD4, float4 v6 : TEXCOORD5, float4 v7 : TEXCOORD6, float4 v8 : TEXCOORD7, float4 v9 : TEXCOORD8, float4 v10 : TEXCOORD9, float4 v11 : TEXCOORD10, float4 v12 : TEXCOORD11, float4 v13 : TEXCOORD12, float4 v14 : TEXCOORD13, float4 v15 : TEXCOORD14, float4 v16 : TEXCOORD15, float4 v17 : COLOR0, float4 v18 : COLOR1, out float4 o0 : SV_Target0, out float4 o1 : SV_Target1, out float4 o2 : SV_Target2, out float4 o3 : SV_Target3) {
  float4 r0, r1, r2, r3, r4, r5, r6, r7, r8;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = v1.zwzw * float4(0, -1, -1, 0) + v1.xyxy;
  r1.xyz = TextureInput.SampleLevel(TextureInput_s_s, r0.xy, 0).xyz;
  r0.xyz = TextureInput.SampleLevel(TextureInput_s_s, r0.zw, 0).xyz;
  r2.xy = v1.xy;
  r2.xyz = TextureInput.SampleLevel(TextureInput_s_s, r2.xy, 0).xyz;
  r3.xyzw = v1.zwzw * float4(1, 0, 0, 1) + v1.xyxy;
  r4.xyz = TextureInput.SampleLevel(TextureInput_s_s, r3.xy, 0).xyz;
  r3.xyz = TextureInput.SampleLevel(TextureInput_s_s, r3.zw, 0).xyz;
  r0.w = r1.y * 1.9632107 + r1.x;
  r1.w = r0.y * 1.9632107 + r0.x;
  r2.w = r2.y * 1.9632107 + r2.x;
  r3.w = r4.y * 1.9632107 + r4.x;
  r4.w = r3.y * 1.9632107 + r3.x;
  r5.x = min(r1.w, r0.w);
  r5.y = min(r4.w, r3.w);
  r5.x = min(r5.y, r5.x);
  r5.x = min(r5.x, r2.w);
  r5.y = max(r1.w, r0.w);
  r5.z = max(r4.w, r3.w);
  r5.y = max(r5.y, r5.z);
  r5.y = max(r5.y, r2.w);
  r5.x = -r5.x + r5.y;
  r5.y = 0.125 * r5.y;
  r5.y = min(-0.0416666679, -r5.y);
  r5.y = cmp(r5.x < -r5.y);
  if (r5.y == 0) {
    r0.xyz = r0.xyz + r1.xyz;
    r0.xyz = r2.xyz + r0.xyz;
    r0.xyz = r4.xyz + r0.xyz;
    r0.xyz = r3.xyz + r0.xyz;
    r1.x = r1.w + r0.w;
    r1.x = r3.w + r1.x;
    r1.x = r4.w + r1.x;
    r1.x = r1.x * 0.25 + -r2.w;
    r1.y = 1 / r5.x;
    r1.y = min(3.40282347e+38, r1.y);
    r1.x = abs(r1.x) * r1.y + -0.25;
    r1.y = 1.33333337 * r1.x;
    r1.x = cmp(r1.x >= 0);
    r1.x = r1.x ? r1.y : 0;
    r1.x = min(0.75, r1.x);
    r1.yz = -v1.zw + v1.xy;
    r3.xyz = TextureInput.SampleLevel(TextureInput_s_s, r1.yz, 0).xyz;
    r5.xyzw = v1.zwzw * float4(1, -1, -1, 1) + v1.xyxy;
    r4.xyz = TextureInput.SampleLevel(TextureInput_s_s, r5.xy, 0).xyz;
    r5.xyz = TextureInput.SampleLevel(TextureInput_s_s, r5.zw, 0).xyz;
    r1.yz = v1.zw + v1.xy;
    r6.xyz = TextureInput.SampleLevel(TextureInput_s_s, r1.yz, 0).xyz;
    r7.xyz = r4.xyz + r3.xyz;
    r7.xyz = r7.xyz + r5.xyz;
    r7.xyz = r7.xyz + r6.xyz;
    r0.xyz = r7.xyz + r0.xyz;
    r0.xyz = r1.xxx * r0.xyz;
    r1.y = r3.y * 1.9632107 + r3.x;
    r1.z = r4.y * 1.9632107 + r4.x;
    r3.x = r5.y * 1.9632107 + r5.x;
    r3.y = r6.y * 1.9632107 + r6.x;
    r3.z = -0.5 * r0.w;
    r3.z = r1.y * 0.25 + r3.z;
    r3.z = r1.z * 0.25 + r3.z;
    r4.x = -0.5 * r1.w;
    r4.y = r1.w * 0.5 + -r2.w;
    r4.z = -0.5 * r3.w;
    r4.y = r3.w * 0.5 + r4.y;
    r3.z = abs(r4.y) + abs(r3.z);
    r4.y = -0.5 * r4.w;
    r4.y = r3.x * 0.25 + r4.y;
    r4.y = r3.y * 0.25 + r4.y;
    r3.z = abs(r4.y) + r3.z;
    r1.y = r1.y * 0.25 + r4.x;
    r1.y = r3.x * 0.25 + r1.y;
    r3.x = r0.w * 0.5 + -r2.w;
    r3.x = r4.w * 0.5 + r3.x;
    r1.y = abs(r3.x) + abs(r1.y);
    r1.z = r1.z * 0.25 + r4.z;
    r1.z = r3.y * 0.25 + r1.z;
    r1.y = abs(r1.z) + r1.y;
    r1.y = -r3.z + r1.y;
    r1.y = cmp(r1.y >= 0);
    r1.z = r1.y ? -v1.w : -v1.z;
    r0.w = r1.y ? r0.w : r1.w;
    r1.w = r1.y ? r4.w : r3.w;
    r3.x = -r2.w + r0.w;
    r3.y = -r2.w + r1.w;
    r0.w = r2.w + r0.w;
    r0.w = 0.5 * r0.w;
    r1.w = r2.w + r1.w;
    r1.w = 0.5 * r1.w;
    r3.z = abs(r3.x) + -abs(r3.y);
    r3.z = cmp(r3.z >= 0);
    r0.w = r3.z ? r0.w : r1.w;
    r1.w = max(abs(r3.x), abs(r3.y));
    r1.z = r3.z ? r1.z : -r1.z;
    r3.x = 0.5 * r1.z;
    r4.x = r1.y ? 0 : r3.x;
    r4.y = r1.y ? r3.x : 0;
    r3.xy = v1.xy + r4.xy;
    r4.xyz = float3(1, 0, 1) * v1.zxw;
    r3.zw = r1.yy ? r4.xy : r4.yz;
    r4.xy = -r3.zw + r3.xy;
    r3.xy = r3.zw + r3.xy;
    r4.zw = r4.xy;
    r5.xy = r3.xy;
    r5.zw = r0.ww;
    r6.xyz = float3(0, 0, 0);
    while (true) {
      r6.w = cmp((int)r6.z >= 16);
      if (r6.w != 0) break;
      r6.w = cmp(-r6.x != r6.x);
      if (r6.w != 0) {
        r7.x = r5.z;
      } else {
        r7.zw = TextureInput.SampleLevel(TextureInput_s_s, r4.zw, 0).xy;
        r7.x = r7.w * 1.9632107 + r7.z;
      }
      r6.w = cmp(-r6.y != r6.y);
      if (r6.w != 0) {
        r7.y = r5.w;
      } else {
        r7.zw = TextureInput.SampleLevel(TextureInput_s_s, r5.xy, 0).xy;
        r7.y = r7.w * 1.9632107 + r7.z;
      }
      r7.zw = r7.xy + -r0.ww;
      r7.zw = r1.ww * float2(-0.25, -0.25) + abs(r7.zw);
      r7.zw = cmp(r7.zw >= float2(0, 0));
      r7.zw = r7.zw ? float2(1, 1) : 0;
      r7.zw = r6.xy + r7.zw;
      r7.zw = cmp(-r7.zw >= float2(0, 0));
      r6.xy = r7.zw ? float2(0, 0) : float2(1, 1);
      r6.w = r6.y * r6.x;
      r6.w = cmp(-r6.w != r6.w);
      if (r6.w != 0) {
        r5.zw = r7.xy;
        break;
      }
      r8.xy = r4.zw + -r3.zw;
      r4.zw = r7.zz ? r8.xy : r4.zw;
      r8.xy = r5.xy + r3.zw;
      r5.xy = r7.ww ? r8.xy : r5.xy;
      r5.zw = r7.xy;
      r6.z = (int)r6.z + 1;
    }
    r3.xy = v1.xy + -r4.zw;
    r1.w = r1.y ? r3.x : r3.y;
    r3.xy = -v1.xy + r5.xy;
    r3.x = r1.y ? r3.x : r3.y;
    r3.y = -r3.x + r1.w;
    r3.y = cmp(r3.y >= 0);
    r3.y = r3.y ? r5.w : r5.z;
    r2.w = -r0.w + r2.w;
    r2.w = cmp(r2.w >= 0);
    r2.w = r2.w ? 0 : 1;
    r0.w = r3.y + -r0.w;
    r0.w = cmp(r0.w >= 0);
    r0.w = r0.w ? -0 : -1;
    r0.w = r0.w + r2.w;
    r0.w = cmp(-abs(r0.w) >= 0);
    r0.w = r0.w ? 0 : r1.z;
    r1.z = r3.x + r1.w;
    r1.w = min(r3.x, r1.w);
    r1.z = 1 / r1.z;
    r1.z = min(3.40282347e+38, r1.z);
    r1.z = r1.w * -r1.z + 0.5;
    r0.w = r1.z * r0.w;
    r1.z = r1.y ? 0 : r0.w;
    r3.x = v1.x + r1.z;
    r0.w = r1.y ? r0.w : 0;
    r3.y = v1.y + r0.w;
    r1.yzw = TextureInput.SampleLevel(TextureInput_s_s, r3.xy, 0).xyz;
    r0.xyz = r0.xyz * float3(0.111111112, 0.111111112, 0.111111112) + r1.yzw;
    r2.xyz = -r1.xxx * r1.yzw + r0.xyz;
  }
  r0.x = g_Flags & 1;
  r0.x = cmp((int)r0.x != 0);
  r0.y = 1 + -g_AlphaThreshold;
  r0.y = cmp(r0.y < 0);
  r0.x = r0.x ? r0.y : 0;
  if (r0.x != 0) discard;
  o0.xyz = r2.xyz;
  o0.w = 1;

  o0.rgb = max(0, o0.rgb);
  o0.rgb = injectedData.toneMapGammaCorrection ? pow(o0.rgb, 2.2f) : linearFromSRGB(o0.rgb);
  o0.rgb *= injectedData.toneMapUINits / 80.f;
  return;
}
