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
  float4 cb0[7];
}

void main(
  float4 v0 : TEXCOORD0,
  float2 v1 : TEXCOORD1,
  float w1 : TEXCOORD2,
  float4 v2 : TEXCOORD3,
  float4 v3 : TEXCOORD4,
  float4 v4 : TEXCOORD5,
  float4 v5 : SV_POSITION0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb0[1].xx + v5.xy;
  r0.xy = cb0[0].xy * r0.xy;
  r0.x = t12.Sample(s12_s, r0.xy).x;
  r0.x = r0.x * cb0[0].w + -cb0[0].z;
  r0.x = -w1.x + r0.x;
  r0.x = saturate(r0.x / cb0[6].x);
  r0.y = r0.x * -2 + 3;
  r0.x = r0.x * r0.x;
  r0.x = r0.y * r0.x;
  r0.y = dot(v3.xyz, v2.xyz);
  r0.y = abs(r0.y);
  r0.y = t3.Sample(s3_s, r0.yy).x;
  r0.zw = t1.Sample(s1_s, v0.xy).xy;
  r0.zw = r0.zw * float2(2,2) + float2(-1,-1);
  r1.xy = r0.zw * cb0[3].xx + v0.zw;
  r0.zw = r0.zw * cb0[4].xx + v1.xy;
  r0.z = t2.Sample(s2_s, r0.zw).x;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r0.y = r1.w * r0.y;
  r0.y = r0.z * r0.y;
  r0.y = cb0[5].x * r0.y;
  r0.x = r0.y * r0.x;
  r0.yzw = r1.xyz * r0.xxx;
  o0.w = r0.x;
  r0.x = 1 + -v4.w;
  o0.xyz = r0.yzw * r0.xxx;
  o0 = saturate(o0);
  return;
}