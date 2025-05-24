#include "./common.hlsl"

Texture2DArray<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[7];
}
cbuffer cb0 : register(b0){
  float4 cb0[9];
}

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float4 v2 : TEXCOORD0,
  float4 v3 : TEXCOORD1,
  float4 v4 : TEXCOORD2,
  float4 v5 : TEXCOORD3,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.z = 0;
  r1.xw = v5.xy;
  r2.xy = float2(1,1) + -cb1[6].wz;
  r1.yz = r2.xy * cb0[7].ww + v5.yx;
  r2.xy = -r2.xy * cb0[7].ww + v5.yx;
  r3.xyzw = r1.xyzw / cb1[6].wwww;
  r0.xy = cb0[4].xy * r3.xy;
  r3.xy = cb0[4].xy * r3.zw;
  r0.w = asint(cb0[8].x);
  r4.xyzw = t1.SampleLevel(s1_s, r0.xyz, r0.w).xyzw;
  r0.xy = v5.xy / cb1[6].ww;
  r0.xy = cb0[4].xy * r0.xy;
  r0.z = 0;
  r5.xyzw = t1.SampleLevel(s1_s, r0.xyz, r0.w).xyzw;
  r0.xyz = r5.xyz + r4.xyz;
  r2.zw = v5.xy;
  r4.xyzw = r2.zxyw / cb1[6].wwww;
  r5.xy = cb0[4].xy * r4.xy;
  r4.xy = cb0[4].xy * r4.zw;
  r5.z = 0;
  r5.xyzw = t1.SampleLevel(s1_s, r5.xyz, r0.w).xyzw;
  r0.xyz = r5.xyz + r0.xyz;
  r4.z = 0;
  r4.xyzw = t1.SampleLevel(s1_s, r4.xyz, r0.w).xyzw;
  r0.xyz = r4.xyz + r0.xyz;
  r3.z = 0;
  r3.xyzw = t1.SampleLevel(s1_s, r3.xyz, r0.w).xyzw;
  r0.xyz = r3.xyz + r0.xyz;
  r1.xw = r2.yx;
  r2.xy = r2.yx / cb1[6].ww;
  r2.xy = cb0[4].xy * r2.xy;
  r3.xy = r1.zy / cb1[6].ww;
  r3.xy = cb0[4].xy * r3.xy;
  r1.xyzw = r1.xyzw / cb1[6].wwww;
  r4.xy = cb0[4].xy * r1.xy;
  r1.xy = cb0[4].xy * r1.zw;
  r4.z = 0;
  r4.xyzw = t1.SampleLevel(s1_s, r4.xyz, r0.w).xyzw;
  r0.xyz = r4.xyz + r0.xyz;
  r3.z = 0;
  r3.xyzw = t1.SampleLevel(s1_s, r3.xyz, r0.w).xyzw;
  r0.xyz = r3.xyz + r0.xyz;
  r2.z = 0;
  r2.xyzw = t1.SampleLevel(s1_s, r2.xyz, r0.w).xyzw;
  r0.xyz = r2.xyz + r0.xyz;
  r1.z = 0;
  r1.xyzw = t1.SampleLevel(s1_s, r1.xyz, r0.w).xyzw;
  r0.xyz = r1.xyz + r0.xyz;
  r0.xyz = float3(0.111111112,0.111111112,0.111111112) * r0.xyz;
  if (injectedData.check == 2) {
    r0.rgb = renodx::color::pq::Decode(r0.rgb);
    r0.rgb = renodx::color::bt709::from::BT2020(r0.rgb);
  }
  r1.xyz = cb0[2].xyz + -r0.xyz;
  r0.xyz = cb0[2].www * r1.xyz + r0.xyz;
  r1.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  r0.w = cb0[3].w + r1.w;
  r0.w = v1.w * r0.w;
  o0.xyz = r0.xyz * r0.www;
  o0.w = r0.w;
  return;
}