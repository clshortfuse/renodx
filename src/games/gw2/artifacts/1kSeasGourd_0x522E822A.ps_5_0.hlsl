Texture2D<float4> t12 : register(t12);
Texture2D<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s12_s : register(s12);
SamplerState s5_s : register(s5);
SamplerState s4_s : register(s4);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[17];
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
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb0[2].xx + v5.xy;
  r0.xy = cb0[0].xy * r0.xy;
  r0.x = t12.Sample(s12_s, r0.xy).x;
  r0.x = r0.x * cb0[0].w + -cb0[0].z;
  r0.x = -w1.x + r0.x;
  r0.x = saturate(r0.x / cb0[15].x);
  r0.y = r0.x * -2 + 3;
  r0.x = r0.x * r0.x;
  r0.x = r0.y * r0.x;
  r0.y = cb0[1].x * cb0[7].z + 0.5;
  r0.y = frac(r0.y);
  r0.zw = t3.Sample(s3_s, v0.xy).xy;
  r0.zw = r0.zw * float2(2,2) + float2(-1,-1);
  r1.xy = r0.zw * r0.yy;
  r1.xy = cb0[7].yy * r1.xy + v0.zw;
  r1.xy = t2.Sample(s2_s, r1.xy).xy;
  r1.xy = r1.xy * float2(2,2) + float2(-1,-1);
  r0.y = cb0[7].z * cb0[1].x;
  r0.y = frac(r0.y);
  r0.zw = r0.zw * r0.yy;
  r0.y = r0.y * 2 + -1;
  r0.zw = cb0[7].yy * r0.zw + v0.zw;
  r0.zw = t2.Sample(s2_s, r0.zw).xy;
  r0.zw = r0.zw * float2(2,2) + float2(-1,-1);
  r1.xy = r1.xy + -r0.zw;
  r0.yz = abs(r0.yy) * r1.xy + r0.zw;
  r1.xy = cb0[16].xx * r0.yz + v1.xy;
  r1.xyzw = t5.Sample(s5_s, r1.xy).xyzw;
  r1.xyzw = r1.xyzw * r0.xxxx;
  r2.x = cb0[10].x * cb0[1].x;
  r2.y = cb0[11].x * cb0[1].x;
  r0.xw = v0.xy * cb0[4].xx + r2.xy;
  r0.xw = cb0[7].xx * r0.yz + r0.xw;
  r2.xyzw = t4.Sample(s4_s, r0.xw).xyzw;
  r0.x = dot(v3.xyz, v2.xyz);
  r0.x = abs(r0.x);
  r0.w = 1 + -r0.x;
  r3.xyzw = t1.Sample(s1_s, r0.xx).xyzw;
  r0.x = max(0, r0.w);
  r4.xyzw = r2.xyzw * r0.xxxx;
  r3.xyzw = -r4.xyzw * cb0[13].xxxx + r3.xyzw;
  r4.x = cb0[5].x * cb0[1].x;
  r4.y = cb0[6].x * cb0[1].x;
  r0.xw = v0.xy * cb0[4].xx + r4.xy;
  r0.xy = cb0[7].xx * r0.yz + r0.xw;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r0.w = r2.w * cb0[12].x + r0.w;
  r3.xyzw = r0.wwww * r3.xyzw;
  r3.xyzw = cb0[14].xxxx * r3.xyzw;
  r1.xyzw = r3.yzwx * r1.yzwx;
  r3.xyzw = saturate(r1.wxyz);
  r2.yzw = cb0[9].xyz + -cb0[8].xyz;
  r4.xyz = r2.xxx * r2.yzw + cb0[8].xyz;
  r2.xyz = r0.xxx * r2.yzw + cb0[8].xyz;
  r2.xyz = r2.xyz * r4.xyz;
  r0.xyz = r2.xyz * r0.xyz;
  r1.xyz = float3(4,4,4) * r0.xyz;
  r0.xyzw = r1.xyzw * r3.xyzw;
  r1.x = 1 + -v4.w;
  o0.xyzw = r1.xxxx * r0.xyzw;
  o0 = max(0, o0);
  return;
}