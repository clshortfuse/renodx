#include "../../common.hlsl"

Texture2D<float4> t6 : register(t6);
Texture3D<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s6_s : register(s6);
SamplerState s5_s : register(s5);
SamplerState s4_s : register(s4);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[44];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t4.Sample(s4_s, v1.xy).xyzw;
  r0.x = cb0[36].x * r0.x;
  r1.xyzw = float4(0.5,0.5,0.5,0.5) + -float4(v1, w1);
  r0.xy = r1.xy * r0.xx + v1.xy;
  r2.xyzw = t4.Sample(s4_s, w1.xy).xyzw;
  r0.z = cb0[36].x * r2.x;
  r0.zw = r1.zw * r0.zz + w1.xy;
  r1.xyzw = t1.Sample(s1_s, v1.xy).xyzw;
  r2.xyzw = t0.Sample(s0_s, r0.zw).xyzw;
  r2.xyz = r2.xyz * r1.xxx;
  r1.xyzw = float4(1,1,-1,0) * cb0[30].xyxy;
  r3.xyzw = saturate(-r1.xywy * cb0[32].xxxx + r0.xyxy);
  r3.xyzw = cb0[26].xxxx * r3.xyzw;
  r4.xyzw = t2.Sample(s2_s, r3.xy).xyzw;
  r3.xyzw = t2.Sample(s2_s, r3.zw).xyzw;
  r3.xyzw = r3.xyzw * float4(2,2,2,2) + r4.xyzw;
  r0.zw = saturate(-r1.zy * cb0[32].xx + r0.xy);
  r0.zw = cb0[26].xx * r0.zw;
  r4.xyzw = t2.Sample(s2_s, r0.zw).xyzw;
  r3.xyzw = r4.xyzw + r3.xyzw;
  r4.xyzw = saturate(r1.zwxw * cb0[32].xxxx + r0.xyxy);
  r4.xyzw = cb0[26].xxxx * r4.xyzw;
  r5.xyzw = t2.Sample(s2_s, r4.xy).xyzw;
  r3.xyzw = r5.xyzw * float4(2,2,2,2) + r3.xyzw;
  r0.zw = saturate(r0.xy);
  r0.zw = cb0[26].xx * r0.zw;
  r5.xyzw = t2.Sample(s2_s, r0.zw).xyzw;
  r3.xyzw = r5.xyzw * float4(4,4,4,4) + r3.xyzw;
  r4.xyzw = t2.Sample(s2_s, r4.zw).xyzw;
  r3.xyzw = r4.xyzw * float4(2,2,2,2) + r3.xyzw;
  r4.xyzw = saturate(r1.zywy * cb0[32].xxxx + r0.xyxy);
  r4.xyzw = cb0[26].xxxx * r4.xyzw;
  r5.xyzw = t2.Sample(s2_s, r4.xy).xyzw;
  r3.xyzw = r5.xyzw + r3.xyzw;
  r4.xyzw = t2.Sample(s2_s, r4.zw).xyzw;
  r3.xyzw = r4.xyzw * float4(2,2,2,2) + r3.xyzw;
  r0.zw = saturate(r1.xy * cb0[32].xx + r0.xy);
  r0.zw = cb0[26].xx * r0.zw;
  r1.xyzw = t2.Sample(s2_s, r0.zw).xyzw;
  r1.xyzw = r3.xyzw + r1.xyzw;
  r1.xyzw = cb0[32].yyyy * r1.xyzw * injectedData.fxBloom;
  r3.xyzw = t3.Sample(s3_s, r0.xy).xyzw;
  r4.xyz = float3(0.0625,0.0625,0.0625) * r1.xyz;
  r3.xyz = cb0[32].zzz * r3.xyz * injectedData.fxLens;
  r1.xyzw = float4(0.0625,0.0625,0.0625,1) * r1.xyzw;
  r5.xyz = cb0[33].xyz * r1.xyz;
  r5.w = 0.0625 * r1.w;
  r1.xyzw = r5.xyzw + r2.xyzw;
  r2.xyz = r3.xyz * r4.xyz;
  r2.w = 0;
  r1.xyzw = r2.xyzw + r1.xyzw;
  if (cb0[41].y < 0.5) {
    r0.zw = -cb0[39].xy + r0.xy;
    r2.yz = cb0[40].xx * abs(r0.wz) * min(1.f, injectedData.fxVignette);
    r0.z = cb0[22].x / cb0[22].y;
    r0.z = -1 + r0.z;
    r0.z = cb0[40].w * r0.z + 1;
    r2.x = r2.z * r0.z;
    r2.xy = saturate(r2.xy);
    r0.zw = log2(r2.xy);
    r0.zw = cb0[40].zz * r0.zw;
    r0.zw = exp2(r0.zw);
    r0.z = dot(r0.zw, r0.zw);
    r0.z = 1 + -r0.z;
    r0.z = max(0, r0.z);
    r0.z = log2(r0.z);
    r0.z = cb0[40].y * r0.z * max(1.f, injectedData.fxVignette);
    r0.z = exp2(r0.z);
    r2.xyz = float3(1,1,1) + -cb0[38].xyz;
    r2.xyz = r0.zzz * r2.xyz + cb0[38].xyz;
    r2.xyz = r2.xyz * r1.xyz;
    r0.w = -1 + r1.w;
    r2.w = r0.z * r0.w + 1;
  } else {
    r0.xyzw = t6.Sample(s6_s, r0.xy).xyzw;
    r0.x = renodx::color::srgb::DecodeSafe(r0.w);
    r0.yzw = float3(1,1,1) + -cb0[38].xyz;
    r0.yzw = r0.xxx * r0.yzw + cb0[38].xyz;
    r0.yzw = r1.xyz * r0.yzw + -r1.xyz;
    r2.xyz = cb0[41].xxx * r0.yzw + r1.xyz;
    r0.y = -1 + r1.w;
    r2.w = r0.x * r0.y + 1;
  }
  r0.xyzw = cb0[37].wwww * r2.xyzw;
  r0.xyz = lutShaper(r0.xyz);
  if(injectedData.colorGradeLUTSampling == 0.f){
  r0.xyz = cb0[37].zzz * r0.xyz;
  r1.x = 0.5 * cb0[37].y;
  r0.xyz = r0.xyz * cb0[37].yyy + r1.xxx;
  r1.xyzw = t5.Sample(s5_s, r0.xyz).wxyz;
  } else {
    r1.yzw = renodx::lut::SampleTetrahedral(t5, r0.xyz, 1 / cb0[37].y);
  }
  if (cb0[43].x > 0.5) {
    r1.x = renodx::color::y::from::BT709(saturate(r1.yzw));
  } else {
    r1.x = r0.w;
  }
  if (injectedData.countOld == injectedData.countNew) {
    r1.yzw = PostToneMapScale(r1.yzw);
  }
  o0.xyzw = r1.yzwx;
  return;
}