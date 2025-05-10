// ---- Created with 3Dmigoto v1.4.1 on Mon Apr 28 06:14:33 2025
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb3 : register(b3) {
  float4 cb3[13];
}

cbuffer cb2 : register(b2) {
  float4 cb2[4];
}

cbuffer cb1 : register(b1) {
  float4 cb1[1];
}

cbuffer cb0 : register(b0) {
  float4 cb0[5];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float4 v1: COLOR0,
    float2 v2: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cb1[0].y / cb0[3].x;
  r0.x = floor(r0.x);
  r0.yz = cb3[10].xy * cb2[3].yy;
  r0.yz = cb3[9].xy * cb2[3].xx + r0.yz;
  r0.yz = cb3[11].xy * cb2[3].zz + r0.yz;
  r0.yz = cb3[12].xy * cb2[3].ww + r0.yz;
  r0.x = r0.x * cb0[3].x + r0.y;
  r0.x = r0.x + r0.z;
  r0.y = 2.79299998 + r0.x;
  r0.yz = float2(-91.2228012, 91.2228012) * r0.yy;
  r0.yz = sin(r0.yz);
  r0.yz = float2(43758.5469, 43758.5469) * r0.yz;
  r0.yz = frac(r0.yz);
  r0.yz = float2(-0.5, -0.5) + r0.yz;
  r0.z = r0.z * 0.0199999996 + 0.200000003;
  r0.z = v2.y / r0.z;
  r0.z = floor(r0.z);
  r0.w = r0.z + r0.x;
  r0.z = r0.z + -r0.x;
  r1.xyzw = float4(-65.2432022, 91.2228012, 65.2432022, -91.2228012) * r0.xxxx;
  r1.xyzw = sin(r1.xyzw);
  r1.xyzw = float4(43758.5469, 43758.5469, 43758.5469, 43758.5469) * r1.xyzw;
  r1.xyzw = frac(r1.xyzw);
  r0.x = 78.2330017 * r0.w;
  r0.x = r0.z * 12.9898005 + r0.x;
  r0.x = sin(r0.x);
  r0.x = 43758.5469 * r0.x;
  r0.x = frac(r0.x);
  r0.x = -0.5 + r0.x;
  r0.x = r0.x * cb0[3].y + v2.x;
  r0.z = cmp(r0.x >= -r0.x);
  r0.w = frac(abs(r0.x));
  r0.x = saturate(r0.x);
  r0.z = r0.z ? r0.w : -r0.w;
  r2.xyz = cmp(cb0[4].ywz == float3(1, 1, 1));
  r0.x = r2.y ? r0.z : r0.x;
  r0.z = cmp(r1.x < cb0[3].z);
  r0.z = r2.x ? r0.z : 0;
  r2.x = r0.z ? r0.x : v2.x;
  r3.x = r0.y * cb0[3].w + r2.x;
  r3.y = r0.y * cb0[3].w + v2.y;
  r0.xyzw = t0.Sample(s0_s, r3.xy).xyzw;
  r1.xz = float2(-0.5, -0.5) + r1.zw;
  r1.y = cmp(r1.y < cb0[4].x);
  r1.y = r2.z ? r1.y : 0;
  r3.xy = r1.xz * cb0[3].ww + r2.xx;
  r3.zw = r1.xz * cb0[3].ww + v2.yy;
  r4.xyzw = t0.Sample(s0_s, r3.xz).xyzw;
  r3.xyzw = t0.Sample(s0_s, r3.yw).xyzw;
  r1.x = r4.w + r3.w;
  r0.x = r4.x;
  r0.y = r3.y;
  r1.x = r1.x + r0.w;
  r0.w = 0.333333343 * r1.x;
  r2.y = v2.y;
  r2.xyzw = t0.Sample(s0_s, r2.xy).xyzw;
  r0.xyzw = r1.yyyy ? r0.xyzw : r2.xyzw;
  r0.xyzw = v1.xyzw * r0.xyzw;
  o0.xyz = r0.xyz * saturate(r0.www);  // Added saturate
  o0.w = r0.w;
  o0 = saturate(o0);  // Added saturate
  return;
}
