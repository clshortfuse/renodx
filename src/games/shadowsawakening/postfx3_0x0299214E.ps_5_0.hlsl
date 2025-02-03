#include "./common.hlsl"

Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0) {
  float4 cb0[5];
}

#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    float4 v2: COLOR0,
    float4 v3: TEXCOORD1,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = t3.Sample(s1_s, v1.xy).y;
  r0.y = cmp(0 < r0.x);
  r0.x = cmp(r0.x < 0);
  r0.x = (int)-r0.y + (int)r0.x;
  r0.x = (int)r0.x;
  r1.xyzw = t2.Sample(s2_s, v1.xy).xyzw;
  r0.y = 1 + -r1.w;
  r0.y = log2(r0.y);
  r0.y = cb0[3].x * r0.y;
  r0.y = exp2(r0.y);
  r0.xy = float2(1, 1) + -r0.xy;
  r0.x = r0.y * r0.x;
  r0.y = 1 + -cb0[2].w;
  r0.x = r0.x * r0.y;
  r0.y = t1.Sample(s3_s, v1.xy).w;
  r0.y = 0.00100000005 + r0.y;
  r0.y = log2(r0.y);
  r0.y = 0.300000012 * r0.y;
  r0.y = exp2(r0.y);
  r0.y = cb0[3].z * r0.y;
  r0.zw = float2(-0.5, -0.5) + v1.xy;
  r0.zw = r0.zw + r0.zw;
  r0.z = dot(r0.zw, r0.zw);
  r0.z = cb0[2].x * r0.z;
  r0.z = -r0.z * 0.100000001 + 1;
  r0.w = 1 + -r0.z;
  r0.z = cb0[2].y * r0.w + r0.z;
  r2.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r3.xyzw = r2.xyzw * r0.zzzz;
  r2.xyzw = -r2.xyzw * r0.zzzz + float4(0.400000006, 0, 0, 1);
  r2.xyzw = r0.yyyy * r2.xyzw + r3.xyzw;
  r0.y = dot(r2.xyz, float3(0.212599993, 0.715200007, 0.0722000003));
  r3.xyzw = r0.yyyy * float4(0.800000012, 0.800000012, 0.800000012, 0.800000012) + -r2.xyzw;
  r0.y = 0.5 * cb0[3].w;
  r2.xyzw = r0.yyyy * r3.xyzw + r2.xyzw;
  r0.yzw = r1.xyz * cb0[3].yyy + -r2.xyz;
  r2.xyz = r0.xxx * r0.yzw + r2.xyz;
  o0.rgba = r2.rgba;
  if (injectedData.fxFilmGrain > 0.f) {
    o0.rgb = applyFilmGrain(o0.rgb, v1, injectedData.fxFilmGrainType != 0.f);
  }
  o0.rgb = PostToneMapScale(o0.rgb);
  return;
}
