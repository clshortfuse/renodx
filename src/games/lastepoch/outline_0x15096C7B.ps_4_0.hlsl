Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0) {
  float4 cb0[34];
}

#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    float2 w1: TEXCOORD1,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t2.Sample(s2_s, v1.xy).xyzw;
  r1.xyz = cb0[31].xyz * r0.yyy;
  r1.xyz = cb0[33].xxx * r1.xyz;
  r2.xyzw = t1.Sample(s1_s, v1.xy).xyzw;
  r2.xyz = ceil(r2.xyz);
  r2.xyz = float3(1, 1, 1) + -r2.xyz;
  r3.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r1.xyz = r1.xyz * r2.yyy + r3.xyz;
  r0.yzw = cb0[32].xyz * r0.zzz;
  r4.xyz = cb0[30].xyz * r0.xxx;
  r4.xyz = cb0[33].xxx * r4.xyz;
  r2.xyw = r4.xyz * r2.xxx + r3.xyz;
  r0.xyz = cb0[33].xxx * r0.yzw;
  r0.xyz = r0.xyz * r2.zzz + r3.xyz;
  r0.xyz = max(r1.xyz, r0.xyz);
  o0.xyz = max(r2.xyw, r0.xyz);
  o0.w = 1;
  return;
}
