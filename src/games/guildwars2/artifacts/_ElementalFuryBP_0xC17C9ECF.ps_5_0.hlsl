Texture2D<float4> t14 : register(t14);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t0 : register(t0);
SamplerState s14_s : register(s14);
SamplerState s2_s : register(s2);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[21];
}

#define cmp -

void main(
  float4 v0 : TEXCOORD0,
  float4 v1 : TEXCOORD1,
  float4 v2 : TEXCOORD2,
  float4 v3 : SV_POSITION0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  r0.xyz = cb0[8].xyz * r0.xyz;
  r0.w = -0.5 + r0.w;
  r0.w = saturate(r0.w + r0.w);
  r1.xyz = cb0[20].xyz * r0.www;
  r1.xyz = r1.xyz + r1.xyz;
  r1.xyz = cb0[3].xyz * r1.xyz;
  r2.xyzw = t2.Sample(s2_s, v0.xy).xyzw;
  r0.w = dot(r2.xyzw, float4(1,1,1,1));
  r1.w = cmp(0 < r0.w);
  r3.x = cmp(r0.w < 0);
  r1.w = (int)-r1.w + (int)r3.x;
  r1.w = (int)r1.w;
  r3.x = cmp(r1.w != 0.000000);
  r1.w = 9.99999991e-38 * r1.w;
  r1.w = r3.x ? r1.w : 9.99999991e-38;
  r3.x = cmp(9.99999991e-38 < abs(r0.w));
  r1.w = r3.x ? r0.w : r1.w;
  r0.w = min(1, r0.w);
  r0.w = 1 + -r0.w;
  r2.xyzw = r2.xyzw / r1.wwww;
  r3.xyz = r0.xyz + r0.xyz;
  r3.w = 1;
  r4.x = dot(cb0[7].xyzw, r3.xyzw);
  r4.y = dot(cb0[9].xyzw, r3.xyzw);
  r4.z = dot(cb0[10].xyzw, r3.xyzw);
  r4.w = dot(cb0[11].xyzw, r3.xyzw);
  r4.x = dot(r4.xyzw, r2.xyzw);
  r5.x = dot(cb0[12].xyzw, r3.xyzw);
  r5.y = dot(cb0[13].xyzw, r3.xyzw);
  r5.z = dot(cb0[14].xyzw, r3.xyzw);
  r5.w = dot(cb0[15].xyzw, r3.xyzw);
  r4.y = dot(r5.xyzw, r2.xyzw);
  r5.x = dot(cb0[16].xyzw, r3.xyzw);
  r5.y = dot(cb0[17].xyzw, r3.xyzw);
  r5.z = dot(cb0[18].xyzw, r3.xyzw);
  r5.w = dot(cb0[19].xyzw, r3.xyzw);
  r4.z = dot(r5.xyzw, r2.xyzw);
  r0.xyz = r0.xyz * float3(2,2,2) + -r4.xyz;
  r0.xyz = r0.www * r0.xyz + r4.xyz;
  r2.xy = cb0[4].xx + v3.xy;
  r2.xy = cb0[2].xy * r2.xy;
  r2.xyzw = t14.Sample(s14_s, r2.xy).xyzw;
  r2.xyzw = cb0[0].yyyy * r2.xyzw;
  r1.xyz = r2.www * r1.xyz;
  r0.xyz = r0.xyz * r2.xyz + r1.xyz;
  r0.w = 1 + -v2.w;
  o0.xyz = r0.xyz * r0.www + v2.xyz;
  o0.w = cb0[1].x;
  o0 = max(0, o0);
  return;
}