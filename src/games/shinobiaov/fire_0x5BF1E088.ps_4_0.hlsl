// ---- Created with 3Dmigoto v1.3.16 on Wed Aug 27 22:12:51 2025
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1) {
  float4 cb1[6];
}

cbuffer cb0 : register(b0) {
  float4 cb0[5];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float4 v1: TEXCOORD0,
    float4 v2: TEXCOORD1,
    float4 v3: TEXCOORD2,
    float4 v4: TEXCOORD3,
    float4 v5: TEXCOORD4,
    float4 v6: TEXCOORD7,
    out float4 o0: SV_Target0) {
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = 9.99999996e-12 + v4.w;
  r0.y = 0.5 * r0.x;
  r0.z = -r0.x * 0.5 + v4.y;
  r1.y = -r0.z * cb1[5].x + r0.y;
  r1.x = v4.x;
  r0.xy = r1.xy / r0.xx;
  r0.zw = v1.xy * cb0[4].xy + cb0[4].zw;
  r1.xyzw = t0.Sample(s1_s, r0.zw).xyzw;
  r1.x = r1.x * r1.w;
  r0.zw = r1.xy * float2(2, 2) + float2(-1, -1);
  r1.x = 0.00999999978 * v1.z;
  r0.xy = r1.xx * r0.zw + r0.xy;
  r0.xyzw = t1.Sample(s0_s, r0.xy).xyzw;
  // o0.xyz = saturate(r0.xyz);
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}
