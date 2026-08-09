#include "../../common.hlsl"

Texture2D<float4> t6 : register(t6);
Texture2D<float4> t5 : register(t5);
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
  float4 cb0[52];
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

  r0.xy = float2(1,1) + -cb0[29].zw;
  r0.xy = cb0[28].xx * r0.xy;
  r1.xyzw = float4(1,1,-1,0) * cb0[34].xyxy;
  r2.xyzw = min(float4(v1.xy, w1.xy), r0.xyxy);
  r3.xyzw = -r1.xywy * cb0[36].xxxx + r2.xyxy;
  r3.xyzw = saturate(min(r3.xyzw, r0.xyxy));
  r3.xyzw = cb0[26].xxxx * r3.xyzw;
  r4.xyzw = t4.Sample(s4_s, r3.xy).xyzw;
  r3.xyzw = t4.Sample(s4_s, r3.zw).xyzw;
  r3.xyzw = r3.xyzw * float4(2,2,2,2) + r4.xyzw;
  r0.zw = -r1.zy * cb0[36].xx + r2.xy;
  r0.zw = saturate(min(r0.zw, r0.xy));
  r0.zw = cb0[26].xx * r0.zw;
  r4.xyzw = t4.Sample(s4_s, r0.zw).xyzw;
  r3.xyzw = r4.xyzw + r3.xyzw;
  r4.xyzw = r1.zwxw * cb0[36].xxxx + r2.xyxy;
  r4.xyzw = saturate(min(r4.xyzw, r0.xyxy));
  r4.xyzw = cb0[26].xxxx * r4.xyzw;
  r5.xyzw = t4.Sample(s4_s, r4.xy).xyzw;
  r4.xyzw = t4.Sample(s4_s, r4.zw).xyzw;
  r3.xyzw = r5.xyzw * float4(2,2,2,2) + r3.xyzw;
  r0.zw = saturate(min(r2.xy, r0.xy));
  r0.zw = cb0[26].xx * r0.zw;
  r5.xyzw = t4.Sample(s4_s, r0.zw).xyzw;
  r3.xyzw = r5.xyzw * float4(4,4,4,4) + r3.xyzw;
  r3.xyzw = r4.xyzw * float4(2,2,2,2) + r3.xyzw;
  r4.xyzw = r1.zywy * cb0[36].xxxx + r2.xyxy;
  r0.zw = r1.xy * cb0[36].xx + r2.xy;
  r0.zw = saturate(min(r0.zw, r0.xy));
  r1.xyzw = saturate(min(r4.xyzw, r0.xyxy));
  r1.xyzw = cb0[26].xxxx * r1.xyzw;
  r0.xy = cb0[26].xx * r0.zw;
  r0.xyzw = t4.Sample(s4_s, r0.xy).xyzw;
  r4.xyzw = t4.Sample(s4_s, r1.xy).xyzw;
  r1.xyzw = t4.Sample(s4_s, r1.zw).xyzw;
  r3.xyzw = r4.xyzw + r3.xyzw;
  r1.xyzw = r1.xyzw * float4(2,2,2,2) + r3.xyzw;
  r0.xyzw = r1.xyzw + r0.xyzw;
  r1.xyzw = float4(0.0625,0.0625,0.0625,0.0625) * r0.xyzw;
  r3.xyzw = t2.Sample(s2_s, r2.xy).xyzw;
  r4.xyzw = t1.Sample(s1_s, r2.zw).xyzw;
  r4.xyz = r4.xyz * r3.xxx;
  r3.xyzw = min(float4(65504,65504,65504,65504), r4.xyzw);
  r5.xyzw = t2.Sample(s2_s, v1.xy).xyzw;
  r3.xyzw = r5.xxxx * r3.xyzw;
  r3.xyzw = min(cb0[51].xxxx, r3.xyzw);
  r2.z = max(r3.x, r3.y);
  r2.z = max(r2.z, r3.z);
  r5.xy = -cb0[50].yx + r2.zz;
  r2.z = max(9.99999975e-05, r2.z);
  r2.w = max(0, r5.x);
  r2.w = min(cb0[50].z, r2.w);
  r5.x = cb0[50].w * r2.w;
  r2.w = r5.x * r2.w;
  r2.w = max(r2.w, r5.y);
  r2.z = r2.w / r2.z;
  r3.xyzw = r3.xyzw * r2.zzzz;
  r1.xyzw = saturate(-r3.xyzw * float4(4,4,4,4) + r1.xyzw);
  r0.xyzw = r0.xyzw * float4(0.0625,0.0625,0.0625,0.0625) + -r1.xyzw;
  r0.xyzw = cb0[37].wwww * r0.xyzw + r1.xyzw;
  r1.xyzw = cb0[36].yyyy * r0.xyzw * injectedData.fxBloom;
  r2.zw = cb0[28].yy * r2.xy;
  r2.xy = r2.xy * cb0[35].xy + cb0[35].zw;
  r3.xyzw = t5.Sample(s5_s, r2.xy).xyzw;
  r3.xyz = cb0[36].zzz * r3.xyz * injectedData.fxLens;
  r2.xyzw = t3.Sample(s3_s, r2.zw).xyzw;
  r2.x = r2.y + r2.y;
  r1.xyzw = r1.xyzw * r2.xxxx + r4.xyzw;
  r3.w = 0;
  r0.xyzw = r0.xyzw * r3.xyzw + r1.xyzw;
  r0.xyzw = cb0[40].xxxx * r0.xyzw;
  o0.w = r0.w;
  r0.yzx = lutShaper(r0.xyz);
  if(injectedData.colorGradeLUTSampling == 0.f){
  r0.yzw = cb0[39].www * r0.xyz;
  r0.y = floor(r0.y);
  r0.x = r0.x * cb0[39].w + -r0.y;
  r1.xy = float2(0.5,0.5) * cb0[39].yz;
  r1.yz = r0.zw * cb0[39].yz + r1.xy;
  r1.x = r0.y * cb0[39].z + r1.y;
  r2.x = cb0[39].z;
  r2.y = 0;
  r0.yz = r2.xy + r1.xz;
  r1.xyzw = t6.Sample(s6_s, r1.xz).xyzw;
  r2.xyzw = t6.Sample(s6_s, r0.yz).xyzw;
  r0.yzw = r2.xyz + -r1.xyz;
  r0.xyz = r0.xxx * r0.yzw + r1.xyz;
  } else {
    r0.xyz = renodx::lut::SampleTetrahedral(t6, r0.yzx, cb0[39].w + 1u);
  }
  r1.xy = v1.xy * cb0[32].xy + cb0[32].zw;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r0.w = r1.w * 2 + -1;
  r1.x = 1 + -abs(r0.w);
  r0.w = saturate(r0.w * renodx::math::FLT_MAX + 0.5);
  r0.w = r0.w * 2 + -1;
  r1.x = sqrt(r1.x);
  r1.x = 1 + -r1.x;
  r0.w = r1.x * r0.w;
  r0.xyz = applyDither(r0.xyz, r0.w * (1.0 / 255.0));
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  return;
}