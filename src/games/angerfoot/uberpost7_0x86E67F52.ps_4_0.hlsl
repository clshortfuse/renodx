#include "./common.hlsl"

Texture3D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0) {
  float4 cb0[43];
}

#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    float2 w1: TEXCOORD1,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4, r5, r6, r7;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t1.Sample(s1_s, v1.xy).xyzw;
  r0.yz = v1.xy * float2(2, 2) + float2(-1, -1);
  r0.w = dot(r0.yz, r0.yz);
  r0.yz = r0.yz * r0.ww;
  r0.yz = cb0[35].ww * r0.yz * injectedData.fxChroma;
  r1.xy = cb0[31].zw * -r0.yz;
  r1.xy = float2(0.5, 0.5) * r1.xy;
  r0.w = dot(r1.xy, r1.xy);
  r0.w = sqrt(r0.w);
  r0.w = (int)r0.w;
  r0.w = max(3, (int)r0.w);
  r0.w = min(16, (int)r0.w);
  r1.x = (int)r0.w;
  r0.yz = -r0.yz / r1.xx;
  r2.y = 0;
  r3.w = 1;
  r4.xyzw = float4(0, 0, 0, 0);
  r5.xyzw = float4(0, 0, 0, 0);
  r1.yz = v1.xy;
  r1.w = 0;
  while (true) {
    r2.z = cmp((int)r1.w >= (int)r0.w);
    if (r2.z != 0) break;
    r2.z = (int)r1.w;
    r2.z = 0.5 + r2.z;
    r2.x = r2.z / r1.x;
    r2.zw = saturate(r1.yz);
    r2.zw = cb0[26].xx * r2.zw;
    r6.xyzw = t0.SampleLevel(s0_s, r2.zw, 0).xyzw;
    r7.xyzw = t2.SampleLevel(s2_s, r2.xy, 0).xyzw;
    r3.xyz = r7.xyz;
    r4.xyzw = r6.xyzw * r3.xyzw + r4.xyzw;
    r5.xyzw = r5.xyzw + r3.xyzw;
    r1.yz = r1.yz + r0.yz;
    r1.w = (int)r1.w + 1;
  }
  r1.xyzw = r4.xyzw / r5.xyzw;
  r1.xyz = r1.xyz * r0.xxx;
  r0.xyzw = cb0[36].zzzz * r1.xyzw;
  r0.rgb = lutShaper(r0.rgb);
  r0.xyz = cb0[36].yyy * r0.xyz;
  r1.x = 0.5 * cb0[36].x;
  r0.xyz = r0.xyz * cb0[36].xxx + r1.xxx;
  r1.xyzw = t3.Sample(s3_s, r0.xyz).wxyz;
  r0.x = cmp(0.5 < cb0[42].x);
  if (r0.x != 0) {
    r1.x = renodx::color::y::from::BT709(r1.gba);
  } else {
    r1.x = r0.w;
  }
  o0.xyzw = r1.yzwx;
  return;
}
