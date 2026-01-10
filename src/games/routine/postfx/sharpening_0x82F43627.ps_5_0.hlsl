#include "./lilium_rcas.hlsli"

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1) {
  float4 cb1[2];
}

cbuffer cb0 : register(b0) {
  float4 cb0[11];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float4 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;
  o0.w = saturate(cb1[1].w);

  if (CUSTOM_SHARPENING_TYPE != 0.f) {
    float3 color = ApplyLiliumRCAS(v1.xy, t0, s0_s);
    o0.rgb = color;
    return;
  }

  r0.xyzw = asuint(cb0[10].xyxy);
  r0.xyzw = v0.xyxy + -r0.xyzw;
  r1.xyzw = r0.zwzw * cb0[10].zwzw + float4(0, 0.00100000005, 0, -0.00100000005);
  r0.xyzw = cb0[10].zwzw * r0.xyzw;
  r1.xyzw = r1.xyzw * cb0[0].zwzw + cb0[0].xyxy;
  r1.xyzw = max(cb0[1].xyxy, r1.xyzw);
  r1.xyzw = min(cb0[1].zwzw, r1.xyzw);

  r2.xyz = t0.Sample(s0_s, r1.xy).xyz;
  r1.xyz = t0.Sample(s0_s, r1.zw).xyz;
#if 1
  r2.rgb = ScaleSceneInverse(r2.rgb);
  r1.rgb = ScaleSceneInverse(r1.rgb);
#endif

  r1.xyz = r2.xyz + r1.xyz;
  r2.xyzw = float4(0.00100000005, 0, -0.00100000005, 0) + r0.xyzw;
  r0.xy = r0.zw * cb0[0].zw + cb0[0].xy;
  r0.xy = max(cb0[1].xy, r0.xy);
  r0.xy = min(cb0[1].zw, r0.xy);

  r0.xyz = t0.Sample(s0_s, r0.xy).xyz;
  // float3 center = r0.rgb;
#if 1
  r0.rgb = ScaleSceneInverse(r0.rgb);
#endif

  r2.xyzw = r2.xyzw * cb0[0].zwzw + cb0[0].xyxy;
  r2.xyzw = max(cb0[1].xyxy, r2.xyzw);
  r2.xyzw = min(cb0[1].zwzw, r2.xyzw);

  r3.xyz = t0.Sample(s0_s, r2.xy).xyz;
  r2.xyz = t0.Sample(s0_s, r2.zw).xyz;
#if 1
  r3.rgb = ScaleSceneInverse(r3.rgb);
  r2.rgb = ScaleSceneInverse(r2.rgb);
#endif

  r2.xyz = r3.xyz + r2.xyz;
  r1.xyz = r2.xyz + r1.xyz;
  r1.xyz = -r1.xyz * float3(0.25, 0.25, 0.25) + r0.xyz;
  r1.xyz = cb1[0].xxx * r1.xyz;
  r0.w = dot(r1.xyz, float3(0.212639004, 0.715168655, 0.0721923187));
  r0.xyz = r0.www + r0.xyz;
  r1.xyz = cb1[1].xyz + -r0.xyz;
  r0.xyz = cb1[0].yyy * r1.xyz + r0.xyz;
  o0.xyz = r0.xyz;

  o0.rgb = LinearizeAndClampMaxChannel(o0.rgb);

  o0.rgb = ScaleScene(o0.rgb);

  return;
}
