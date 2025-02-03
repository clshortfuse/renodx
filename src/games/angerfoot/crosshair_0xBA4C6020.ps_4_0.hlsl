Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1) {
  float4 cb1[6];
}
cbuffer cb0 : register(b0) {
  float4 cb0[4];
}

void main(
    float4 v0: SV_POSITION0,
    float4 v1: TEXCOORD1,
    float4 v2: TEXCOORD2,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = 0.5 * v1.w;
  r0.y = -v1.w * 0.5 + v1.y;
  r0.y = -r0.y * cb1[5].x + r0.x;
  r0.x = v1.x;
  r0.xy = r0.xy / v1.ww;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r1.xyz = float3(1, 1, 1) + -r0.xyz;
  r2.xy = v2.xy * cb0[2].xy + cb0[2].zw;
  r2.xyzw = t1.Sample(s1_s, r2.xy).xyzw;
  r1.xyz = r2.www * r1.xyz;
  r2.xyzw = -r2.wwww + r0.xyzw;
  r1.xyz = cb0[3].xyz * r1.xyz;
  r1.xyz = float3(2, 2, 2) * r1.xyz;
  r1.w = 0;
  r1.xyzw = r1.xyzw + r2.xyzw;
  r1.xyzw = r1.xyzw + -r0.xyzw;
  o0.xyzw = cb0[3].wwww * r1.xyzw + r0.xyzw;
  o0 = saturate(o0);
  return;
}
