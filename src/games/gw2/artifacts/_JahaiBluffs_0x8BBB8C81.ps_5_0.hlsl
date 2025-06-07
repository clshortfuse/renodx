Texture2D<float4> t12 : register(t12);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s12_s : register(s12);
SamplerState s4_s : register(s4);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[17];
}

#define cmp -

void main(
  float4 v0 : TEXCOORD0,
  float3 v1 : TEXCOORD1,
  float w1 : TEXCOORD2,
  float4 v2 : TEXCOORD3,
  float4 v3 : TEXCOORD4,
  float4 v4 : SV_POSITION0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = 100 * cb0[11].x;
  r0.x = cb0[12].x * 100 + -r0.x;
  r0.x = 1 / r0.x;
  r0.y = -cb0[11].x * 100 + v2.x;
  r0.x = saturate(r0.y * r0.x);
  r0.y = r0.x * -2 + 3;
  r0.x = r0.x * r0.x;
  r0.x = -r0.y * r0.x + 1;
  r0.x = max(0, r0.x);
  r0.yz = cb0[8].yx * cb0[1].xx;
  r0.yz = frac(r0.yz);
  r0.y = r0.y * 2 + -1;
  r0.w = cb0[8].w + -cb0[8].z;
  r0.y = abs(r0.y) * r0.w + cb0[8].z;
  r1.z = v0.y * r0.y + r0.z;
  r1.x = v0.x * r0.y;
  r0.yz = t2.Sample(s2_s, r1.xz).xy;
  r0.yz = r0.yz * float2(2,2) + float2(-1,-1);
  r1.xy = cb0[9].yx * cb0[1].xx;
  r1.xy = frac(r1.xy);
  r0.w = r1.x * 2 + -1;
  r1.x = cb0[9].w + -cb0[9].z;
  r0.w = abs(r0.w) * r1.x + cb0[9].z;
  r1.z = v0.y * r0.w + r1.y;
  r1.x = v0.x * r0.w;
  r1.xy = t3.Sample(s3_s, r1.xz).xy;
  r0.yz = r1.xy * float2(2,2) + r0.yz;
  r0.yz = float2(-1,-1) + r0.yz;
  r1.xy = cb0[10].xx * r0.yz;
  r1.zw = cb0[6].yx * cb0[1].xx;
  r1.zw = frac(r1.zw);
  r0.w = r1.z * 2 + -1;
  r1.z = cb0[6].w + -cb0[6].z;
  r0.w = abs(r0.w) * r1.z + cb0[6].z;
  r2.z = v0.y * r0.w + r1.w;
  r2.x = v0.x * r0.w;
  r0.w = cb0[7].x * cb0[1].x + -0.5;
  r0.w = frac(r0.w);
  r1.zw = r1.xy * r0.ww + r2.xz;
  r1.z = t1.Sample(s1_s, r1.zw).y;
  r1.w = cb0[7].x * cb0[1].x;
  r1.w = frac(r1.w);
  r1.xy = r1.ww * r1.xy + r2.xz;
  r1.x = t1.Sample(s1_s, r1.xy).y;
  r1.y = r1.z + -r1.x;
  r1.z = r1.w * 2 + -1;
  r1.x = abs(r1.z) * r1.y + r1.x;
  r2.xyz = cb0[5].xyz + -cb0[4].xyz;
  r2.xyz = r1.xxx * r2.xyz + cb0[4].xyz;
  r1.x = 0.05 + r1.x;
  r1.x = saturate(2.03593016 * r1.x);
  r1.y = r1.x * -2 + 3;
  r1.x = r1.x * r1.x;
  r3.w = r1.y * r1.x;
  r3.xyz = r3.www * r2.xyz;
  r2.xyzw = r3.xyzw * float4(3.23999977,3.23999977,3.23999977,1.79999995) + -v3.xyzw;
  r2.xyzw = r0.xxxx * r2.xyzw + v3.xyzw;
  r0.x = t4.Sample(s4_s, v0.zw).x;
  r1.x = cb0[13].y + -cb0[13].x;
  r0.x = r0.x * r1.x + cb0[13].x;
  r0.xy = r0.yz * r0.xx;
  r0.xy = cb0[14].xx * r0.xy;
  r0.zw = r0.xy * r0.ww + v0.zw;
  r0.xy = r0.xy * r1.ww + v0.zw;
  r0.x = t0.Sample(s0_s, r0.xy).y;
  r0.y = t0.Sample(s0_s, r0.zw).y;
  r0.y = r0.y + -r0.x;
  r0.x = abs(r1.z) * r0.y + r0.x;
  r0.xyzw = r2.xyzw * r0.xxxx;
  r1.xy = cb0[2].xx + v4.xy;
  r1.xy = cb0[0].xy * r1.xy;
  r1.x = t12.Sample(s12_s, r1.xy).x;
  r1.x = r1.x * cb0[0].w + -cb0[0].z;
  r1.x = -w1.x + r1.x;
  r1.x = saturate(r1.x / cb0[15].x);
  r1.y = r1.x * -2 + 3;
  r1.x = r1.x * r1.x;
  r1.x = r1.y * r1.x;
  r0.xyzw = r1.xxxx * r0.xyzw;
  r1.x = 1 + v1.z;
  r1.yz = cmp(float2(9.99999991e-38,0) < abs(r1.xx));
  r1.z = (int)-r1.z;
  r1.w = cmp(r1.z != 0.000000);
  r1.z = 9.99999991e-38 * r1.z;
  r1.z = r1.w ? r1.z : 9.99999991e-38;
  r1.x = r1.y ? abs(r1.x) : r1.z;
  r1.x = r1.x * r1.x;
  r1.x = -r1.x * 1.5 + 1;
  r1.x = max(0, r1.x);
  r0.xyzw = r1.xxxx * r0.xyzw;
  o0.xyzw = cb0[16].xxxx * r0.xyzw;
  o0.a = saturate(o0.a);
  return;
}