Texture2D<float4> t12 : register(t12);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s12_s : register(s12);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[17];
}

#define cmp -

void main(
  float2 v0 : TEXCOORD0,
  float w0 : TEXCOORD1,
  float4 v1 : TEXCOORD2,
  float4 v2 : TEXCOORD3,
  float4 v3 : SV_POSITION0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb0[2].xx + v3.xy;
  r0.xy = cb0[0].xy * r0.xy;
  r0.x = t12.Sample(s12_s, r0.xy).x;
  r0.x = r0.x * cb0[0].w + -cb0[0].z;
  r0.x = -w0.x + r0.x;
  r0.x = saturate(r0.x / cb0[16].x);
  r0.y = r0.x * -2 + 3;
  r0.x = r0.x * r0.x;
  r0.x = r0.y * r0.x;
  r1.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  r1.xyzw = v1.xyzw * r1.xyzw;
  r0.y = r1.w * r0.x + -cb0[1].x;
  r0.x = r1.w * r0.x;
  o0.w = r0.x;
  r0.x = cmp(r0.y < 0);
  if (r0.x != 0) discard;
  r0.xyzw = t1.Sample(s1_s, v0.xy).xyzw;
  r1.w = dot(r0.xyzw, float4(1,1,1,1));
  r2.x = cmp(0 < r1.w);
  r2.y = cmp(r1.w < 0);
  r2.x = (int)-r2.x + (int)r2.y;
  r2.x = (int)r2.x;
  r2.y = cmp(r2.x != 0.000000);
  r2.x = 9.99999991e-38 * r2.x;
  r2.x = r2.y ? r2.x : 9.99999991e-38;
  r2.y = cmp(9.99999991e-38 < abs(r1.w));
  r2.x = r2.y ? r1.w : r2.x;
  r1.w = min(1, r1.w);
  r1.w = 1 + -r1.w;
  r0.xyzw = r0.xyzw / r2.xxxx;
  r2.xyz = r1.xyz + r1.xyz;
  r2.w = 1;
  r3.x = dot(cb0[4].xyzw, r2.xyzw);
  r3.y = dot(cb0[5].xyzw, r2.xyzw);
  r3.z = dot(cb0[6].xyzw, r2.xyzw);
  r3.w = dot(cb0[7].xyzw, r2.xyzw);
  r3.x = dot(r3.xyzw, r0.xyzw);
  r4.x = dot(cb0[8].xyzw, r2.xyzw);
  r4.y = dot(cb0[9].xyzw, r2.xyzw);
  r4.z = dot(cb0[10].xyzw, r2.xyzw);
  r4.w = dot(cb0[11].xyzw, r2.xyzw);
  r3.y = dot(r4.xyzw, r0.xyzw);
  r4.x = dot(cb0[12].xyzw, r2.xyzw);
  r4.y = dot(cb0[13].xyzw, r2.xyzw);
  r4.z = dot(cb0[14].xyzw, r2.xyzw);
  r4.w = dot(cb0[15].xyzw, r2.xyzw);
  r3.z = dot(r4.xyzw, r0.xyzw);
  r0.xyz = r1.xyz * float3(2,2,2) + -r3.xyz;
  r0.xyz = r1.www * r0.xyz + r3.xyz;
  r0.w = 1 + -v2.w;
  o0.xyz = r0.xyz * r0.www + v2.xyz;
  o0 = max(0.f, o0);
  return;
}