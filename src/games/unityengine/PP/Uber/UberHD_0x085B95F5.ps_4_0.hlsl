#include "../../common.hlsl"

Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[54];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = float4(1,1,1,1) + -cb0[29].zwzw;
  r0.xyzw = cb0[28].xxxx * r0.xyzw;
  r0.xyzw = min(float4(v1.xy, w1.xy), r0.xyzw);
  r1.xyzw = t1.Sample(s1_s, r0.xy).xyzw;
  r0.xyzw = t0.Sample(s0_s, r0.zw).xyzw;
  r1.yzw = r0.xyz * r1.xxx;
  r2.xyzw = t3.Sample(s3_s, w1.xy).xyzw;
  r3.xyz = cb0[52].xyz * cb0[52].www;
  r3.xyz = r3.xyz / cb0[28].xxx;
  r4.xyz = r3.xyz * r2.xyz;
  r6.xyz = r0.xyz * r1.xxx + r4.xyz;
  r1.xyz = cb0[53].x == 0.0 ? r6.xyz : r1.yzw;
  r2.xyz = r2.xyz * r3.xyz + r1.xyz;
  r3.xyz = saturate(r1.xyz);
  r3.xyz = min(r3.xyz, r1.xyz);
  r2.xyz = -r4.xyz * r3.xyz + r2.xyz;
  r0.xyz = cb0[53].x == 1.0 ? r2.xyz : r1.xyz;
  r0.xyzw = cb0[40].xxxx * r0.xyzw;
  r1.yzx = lutShaper(r0.xyz);
  if(injectedData.colorGradeLUTSampling == 0.f){
  r1.yzw = cb0[39].www * r1.xyz;
  r1.y = floor(r1.y);
  r2.xy = float2(0.5,0.5) * cb0[39].yz;
  r2.yz = r1.zw * cb0[39].yz + r2.xy;
  r2.x = r1.y * cb0[39].z + r2.y;
  r3.xyzw = t2.Sample(s2_s, r2.xz).xyzw;
  r4.x = cb0[39].z;
  r4.y = 0;
  r1.zw = r4.xy + r2.xz;
  r2.xyzw = t2.Sample(s2_s, r1.zw).xyzw;
  r1.x = r1.x * cb0[39].w + -r1.y;
  r1.yzw = r2.xyz + -r3.xyz;
  r0.xyz = r1.xxx * r1.yzw + r3.xyz;
  } else {
    r0.xyz = renodx::lut::SampleTetrahedral(t2, r1.yzx, cb0[39].w + 1u);
  }
  if (cb0[53].y > 0.5) {
    r0.w = renodx::color::y::from::BT709(saturate(r0.xyz));
  }
  if(injectedData.countOld == injectedData.countNew){
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyzw = r0.xyzw;
  return;
}