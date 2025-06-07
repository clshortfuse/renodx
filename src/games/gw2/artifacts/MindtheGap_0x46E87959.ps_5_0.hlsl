Texture2D<float4> t12 : register(t12);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s12_s : register(s12);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[7];
}

#define cmp -

void main(
  float2 v0 : TEXCOORD0,
  float w0 : TEXCOORD1,
  float4 v1 : TEXCOORD2,
  float4 v2 : TEXCOORD3,
  float4 v3 : TEXCOORD4,
  float4 v4 : TEXCOORD5,
  float4 v5 : SV_POSITION0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = v2.w;
  r0.y = v1.w;
  r0.z = v3.w;
  r0.w = dot(r0.xyz, r0.xyz);
  r0.w = sqrt(r0.w);
  r1.xy = cmp(float2(9.99999991e-38,0) < r0.ww);
  r1.y = (int)-r1.y;
  r1.z = cmp(r1.y != 0.000000);
  r1.y = 9.99999991e-38 * r1.y;
  r1.y = r1.z ? r1.y : 9.99999991e-38;
  r0.w = r1.x ? r0.w : r1.y;
  r0.xyz = r0.xyz / r0.www;
  r1.xy = t1.Sample(s1_s, v0.xy).xy;
  r1.xy = r1.xy * float2(2,2) + float2(-1,-1);
  r0.w = dot(r1.xy, r1.xy);
  r0.w = 1 + -r0.w;
  r0.w = max(0, r0.w);
  r1.z = sqrt(r0.w);
  r0.w = dot(r1.xyz, r1.xyz);
  r0.w = rsqrt(r0.w);
  r1.xyz = r1.xyz * r0.www;
  r2.xyzw = v1.zxyz * r1.yyyy;
  r2.xyzw = r1.xxxx * v2.zxyz + r2.xyzw;
  r1.xyzw = r1.zzzz * v3.zxyz + r2.xyzw;
  r0.w = dot(r1.yzw, r1.yzw);
  r0.w = sqrt(r0.w);
  r2.xy = cmp(float2(9.99999991e-38,0) < r0.ww);
  r2.y = (int)-r2.y;
  r2.z = cmp(r2.y != 0.000000);
  r2.y = 9.99999991e-38 * r2.y;
  r2.y = r2.z ? r2.y : 9.99999991e-38;
  r0.w = r2.x ? r0.w : r2.y;
  r1.xyzw = r1.xyzw / r0.wwww;
  r0.x = saturate(dot(r0.xyz, r1.yzw));
  r1.x = saturate(-r1.x);
  r0.y = -1 + r1.x;
  r0.z = r0.x * -2 + 3;
  r0.x = r0.x * r0.x;
  r0.x = r0.z * r0.x;
  r0.z = r0.y * 2 + 3;
  r0.y = r0.y * r0.y;
  r0.x = r0.z * r0.y + r0.x;
  r0.x = cb0[5].x * r0.x;
  r1.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  r1.xyzw = cb0[3].xxxx * r1.xyzw;
  r0.yzw = cb0[4].xyz * r1.xyz;
  r0.yzw = r0.yzw + r0.yzw;
  r0.xyz = r0.yzw * r0.xxx;
  r1.xy = cb0[1].xx + v5.xy;
  r1.xy = cb0[0].xy * r1.xy;
  r0.w = t12.Sample(s12_s, r1.xy).x;
  r0.w = r0.w * cb0[0].w + -cb0[0].z;
  r0.w = -w0.x + r0.w;
  r0.w = saturate(r0.w / cb0[6].x);
  r1.x = r0.w * -2 + 3;
  r0.w = r0.w * r0.w;
  r0.w = r1.x * r0.w;
  r0.w = r1.w * r0.w;
  r0.xyz = r0.xyz * r0.www;
  o0.w = r0.w;
  r0.w = 1 + -v4.w;
  o0.xyz = r0.xyz * r0.www;
  o0 = saturate(o0);
  return;
}