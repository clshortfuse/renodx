
#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Fri Dec 20 20:07:41 2024
Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[12];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    float2 w1: TEXCOORD1,
    float2 v2: TEXCOORD2,
    float2 w2: TEXCOORD3,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = float4(1, 1, -1, 0) * cb0[10].xyxy;
  r1.xyzw = -r0.xywy * cb0[11].xxxx + w2.rgrg;
  r2.xyzw = t2.Sample(s3_s, r1.xy).xyzw;
  r1.xyzw = t2.Sample(s3_s, r1.zw).xyzw;
  r1.xyz = r1.xyz * float3(2, 2, 2) + r2.xyz;
  r2.xy = -r0.zy * cb0[11].xx + w2.xy;
  r2.xyzw = t2.Sample(s3_s, r2.xy).xyzw;
  r1.xyz = r2.xyz + r1.xyz;
  r2.xyzw = r0.zwxw * cb0[11].xxxx + w2.rgrg;
  r3.xyzw = t2.Sample(s3_s, r2.xy).xyzw;
  r2.xyzw = t2.Sample(s3_s, r2.zw).xyzw;
  r1.xyz = r3.xyz * float3(2, 2, 2) + r1.xyz;
  r3.xyzw = t2.Sample(s3_s, w2.xy).xyzw;
  r1.xyz = r3.xyz * float3(4, 4, 4) + r1.xyz;
  r1.xyz = r2.xyz * float3(2, 2, 2) + r1.xyz;
  r2.xyzw = r0.zywy * cb0[11].xxxx + w2.rgrg;
  r0.xy = r0.xy * cb0[11].xx + w2.xy;
  r0.xyzw = t2.Sample(s3_s, r0.xy).xyzw;
  r3.xyzw = t2.Sample(s3_s, r2.xy).xyzw;
  r2.xyzw = t2.Sample(s3_s, r2.zw).xyzw;
  r1.xyz = r3.xyz + r1.xyz;
  r1.xyz = r2.xyz * float3(2, 2, 2) + r1.xyz;
  r0.xyz = r1.xyz + r0.xyz;
  r0.xyz = cb0[11].yyy * r0.xyz;
  r0.xyz = float3(0.0625, 0.0625, 0.0625) * r0.xyz;
  r1.xyzw = t0.Sample(s2_s, v1.xy).xyzw;
  r2.xyzw = t1.Sample(s0_s, w1.xy).xyzw;
  // r0.xyz = saturate(r2.xyz * r1.xxx + r0.xyz);
  r0.xyz = r2.xyz * r1.xxx + r0.xyz;

  r0.xyz = log2(r0.xyz);
  r0.xyz = cb0[7].yyy * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r1.xy = v1.xy * cb0[6].xy + cb0[6].zw;
  r1.xyzw = t3.Sample(s1_s, r1.xy).xyzw;
  r0.w = r1.w * 2 + -1;
  r1.x = cmp(0 < r0.w);
  r1.y = cmp(r0.w < 0);
  r0.w = 1 + -abs(r0.w);
  r0.w = sqrt(r0.w);
  r0.w = 1 + -r0.w;
  r1.x = (int)-r1.x + (int)r1.y;
  r1.x = (int)r1.x;
  r0.w = r1.x * r0.w;
  r0.w = 0.00392156886 * r0.w;
  o0.xyz = r0.www * cb0[7].xxx + r0.xyz;
  o0.rgb = applyUserTonemap(o0.rgb);
  o0.rgb = renodx::color::bt709::clamp::AP1(o0.rgb);
  o0.rgb = PostToneMapScale(o0.rgb);

  o0.w = 1;
  return;
}
