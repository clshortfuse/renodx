
// ---- Created with 3Dmigoto v1.4.1 on Thu Apr 17 19:18:34 2025
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[29];
}

// TODO: Figure out if any changes were made here.

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    float2 w1: TEXCOORD1,
    out float4 o0: SV_Target0) {
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy * cb0[28].xy + cb0[28].zw;
  r0.x = t0.Sample(s0_s, r0.xy).w;
  r0.x = r0.x * 2 + -1;
  r0.y = 1 + -abs(r0.x);
  r0.x = saturate(r0.x * 3.40282347e+38 + 0.5);
  r0.x = r0.x * 2 + -1;
  r0.y = sqrt(r0.y);
  r0.y = 1 + -r0.y;
  r0.x = r0.x * r0.y;
  r1.xyzw = t1.Sample(s1_s, w1.xy).xyzw;
  o0.xyz = r0.xxx * float3(0.00392156886, 0.00392156886, 0.00392156886) + r1.xyz;
  o0.xyz = r1.xyz;
  o0.w = r1.w;

  return;
}

