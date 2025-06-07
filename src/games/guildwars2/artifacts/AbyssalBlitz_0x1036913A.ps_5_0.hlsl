
Texture2D<float4> t12 : register(t12);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s12_s : register(s12);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[15];
}

#define cmp -

void main(
  float4 v0 : TEXCOORD0,
  float3 v1 : TEXCOORD1,
  float w1 : TEXCOORD2,
  float4 v2 : TEXCOORD3,
  float4 v3 : SV_POSITION0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb0[7].yx * cb0[1].xx;
  r0.xy = frac(r0.xy);
  r0.x = r0.x * 2 + -1;
  r0.z = cb0[7].w + -cb0[7].z;
  r0.x = abs(r0.x) * r0.z + cb0[7].z;
  r1.z = v0.y * r0.x + r0.y;
  r1.x = v0.x * r0.x;
  r0.xy = t2.Sample(s2_s, r1.xz).xy;
  r0.xy = r0.xy * float2(2,2) + float2(-1,-1);
  r1.xyz = float3(0.4,0.4,0.4) * cb0[7].xyz;
  r0.zw = cb0[1].xx * r1.yx;
  r0.zw = frac(r0.zw);
  r0.z = r0.z * 2 + -1;
  r1.x = cb0[7].w * 0.4 + -r1.z;
  r0.z = abs(r0.z) * r1.x + r1.z;
  r1.z = v0.y * r0.z + r0.w;
  r1.x = v0.x * r0.z;
  r0.zw = t2.Sample(s2_s, r1.xz).xy;
  r0.xy = r0.zw * float2(2,2) + r0.xy;
  r0.xy = float2(-1,-1) + r0.xy;
  r0.z = t3.Sample(s3_s, v0.zw).y;
  r1.x = cb0[8].x;
  r2.x = cb0[8].y + -r1.x;
  r1.yz = cb0[9].xy;
  r2.yz = cb0[9].zw + -r1.yz;
  r1.xyz = r0.zzz * r2.xyz + r1.xyz;
  r0.zw = r1.xx * r0.xy;
  r0.xy = r0.xy * r1.xx + v0.zw;
  r0.x = t0.Sample(s0_s, r0.xy).y;
  r1.xw = cb0[6].yx * cb0[1].xx;
  r1.xw = frac(r1.xw);
  r0.y = r1.x * 2 + -1;
  r1.x = cb0[6].w + -cb0[6].z;
  r0.y = abs(r0.y) * r1.x + cb0[6].z;
  r2.z = v0.y * r0.y + r1.w;
  r2.x = v0.x * r0.y;
  r0.yz = r0.zw * cb0[10].xx + r2.xz;
  r0.y = t1.Sample(s1_s, r0.yz).y;
  r0.z = r0.y + -r1.y;
  r0.y = -cb0[11].x + r0.y;
  r0.w = r1.z + -r1.y;
  r0.w = 1 / r0.w;
  r0.z = saturate(r0.z * r0.w);
  r0.w = r0.z * -2 + 3;
  r0.z = r0.z * r0.z;
  r0.z = r0.w * r0.z;
  r0.w = cb0[11].y + -cb0[11].x;
  r0.w = 1 / r0.w;
  r0.y = saturate(r0.y * r0.w);
  r0.w = r0.y * -2 + 3;
  r0.y = r0.y * r0.y;
  r0.y = r0.w * r0.y;
  r1.xyzw = cb0[5].xyzw + -cb0[4].xyzw;
  r1.xyzw = r0.yyyy * r1.xyzw + cb0[4].xyzw;
  r0.y = r1.w * r0.z;
  r0.x = r0.y * r0.x;
  r0.yz = cb0[2].xx + v3.xy;
  r0.yz = cb0[0].xy * r0.yz;
  r0.y = t12.Sample(s12_s, r0.yz).x;
  r0.y = r0.y * cb0[0].w + -cb0[0].z;
  r0.y = -w1.x + r0.y;
  r0.y = saturate(r0.y / cb0[12].x);
  r0.z = r0.y * -2 + 3;
  r0.y = r0.y * r0.y;
  r0.y = r0.z * r0.y;
  r0.x = r0.x * r0.y;
  r0.y = 1 + v1.z;
  r0.zw = cmp(float2(9.99999991e-38,0) < abs(r0.yy));
  r0.w = (int)-r0.w;
  r1.w = cmp(r0.w != 0.000000);
  r0.w = 9.99999991e-38 * r0.w;
  r0.w = r1.w ? r0.w : 9.99999991e-38;
  r0.y = r0.z ? abs(r0.y) : r0.w;
  r0.y = r0.y * r0.y;
  r0.y = -r0.y * 1.5 + 1;
  r0.y = max(0, r0.y);
  r0.x = r0.x * r0.y;
  r0.x = cb0[13].x * r0.x;
  r1.xyz = r1.xyz * r0.xxx;
  r1.w = cb0[14].x * r0.x;
  r0.x = 1 + -v2.w;
  o0.xyzw = r1.xyzw * r0.xxxx;
  o0.a = saturate(o0.a);
  return;
}