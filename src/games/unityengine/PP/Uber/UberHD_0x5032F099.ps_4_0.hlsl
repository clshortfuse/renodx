#include "../../common.hlsl"

Texture2D<float4> t7 : register(t7);
Texture2D<float4> t6 : register(t6);
Texture2D<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s7_s : register(s7);
SamplerState s6_s : register(s6);
SamplerState s5_s : register(s5);
SamplerState s4_s : register(s4);
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

  r0.xy = float2(1,1) + -cb0[29].zw;
  r0.xy = cb0[28].xx * r0.xy;
  r1.xyzw = min(float4(v1.xy, w1.xy), r0.xyxy);
  r2.xyzw = t1.Sample(s1_s, r1.xy).xyzw;
  r3.xyzw = t0.Sample(s0_s, r1.zw).xyzw;
  r3.xyz = r3.xyz * r2.xxx;
  r2.xyzw = float4(1,1,-1,0) * cb0[34].xyxy;
  r4.xyzw = -r2.xywy * cb0[36].xxxx + r1.xyxy;
  r4.xyzw = saturate(min(r4.xyzw, r0.xyxy));
  r4.xyzw = cb0[26].xxxx * r4.xyzw;
  r5.xyzw = t3.Sample(s3_s, r4.xy).xyzw;
  r4.xyzw = t3.Sample(s3_s, r4.zw).xyzw;
  r4.xyzw = r4.xyzw * float4(2,2,2,2) + r5.xyzw;
  r0.zw = -r2.zy * cb0[36].xx + r1.xy;
  r0.zw = saturate(min(r0.zw, r0.xy));
  r0.zw = cb0[26].xx * r0.zw;
  r5.xyzw = t3.Sample(s3_s, r0.zw).xyzw;
  r4.xyzw = r5.xyzw + r4.xyzw;
  r5.xyzw = r2.zwxw * cb0[36].xxxx + r1.xyxy;
  r5.xyzw = saturate(min(r5.xyzw, r0.xyxy));
  r5.xyzw = cb0[26].xxxx * r5.xyzw;
  r6.xyzw = t3.Sample(s3_s, r5.xy).xyzw;
  r4.xyzw = r6.xyzw * float4(2,2,2,2) + r4.xyzw;
  r0.zw = saturate(min(r1.xy, r0.xy));
  r0.zw = cb0[26].xx * r0.zw;
  r6.xyzw = t3.Sample(s3_s, r0.zw).xyzw;
  r4.xyzw = r6.xyzw * float4(4,4,4,4) + r4.xyzw;
  r5.xyzw = t3.Sample(s3_s, r5.zw).xyzw;
  r4.xyzw = r5.xyzw * float4(2,2,2,2) + r4.xyzw;
  r5.xyzw = r2.zywy * cb0[36].xxxx + r1.xyxy;
  r5.xyzw = saturate(min(r5.xyzw, r0.xyxy));
  r5.xyzw = cb0[26].xxxx * r5.xyzw;
  r6.xyzw = t3.Sample(s3_s, r5.xy).xyzw;
  r4.xyzw = r6.xyzw + r4.xyzw;
  r5.xyzw = t3.Sample(s3_s, r5.zw).xyzw;
  r4.xyzw = r5.xyzw * float4(2,2,2,2) + r4.xyzw;
  r0.zw = r2.xy * cb0[36].xx + r1.xy;
  r0.xy = saturate(min(r0.zw, r0.xy));
  r0.xy = cb0[26].xx * r0.xy;
  r0.xyzw = t3.Sample(s3_s, r0.xy).xyzw;
  r0.xyzw = r4.xyzw + r0.xyzw;
  r2.xyzw = float4(0.0625,0.0625,0.0625,0.0625) * r0.xyzw;
  r1.zw = r1.xy * cb0[35].xy + cb0[35].zw;
  r4.xyzw = t4.Sample(s4_s, r1.zw).xyzw;
  r5.xyzw = min(float4(65504,65504,65504,65504), r3.xyzw);
  r6.xyzw = t1.Sample(s1_s, v1.xy).xyzw;
  r5.xyzw = r6.xxxx * r5.xyzw;
  r5.xyzw = min(cb0[51].xxxx, r5.xyzw);
  r1.z = max(r5.x, r5.y);
  r1.z = max(r1.z, r5.z);
  r6.xy = -cb0[50].yx + r1.zz;
  r1.w = max(0, r6.x);
  r1.w = min(cb0[50].z, r1.w);
  r4.w = cb0[50].w * r1.w;
  r1.w = r4.w * r1.w;
  r1.w = max(r1.w, r6.y);
  r1.z = max(9.99999975e-05, r1.z);
  r1.z = r1.w / r1.z;
  r5.xyzw = r5.xyzw * r1.zzzz;
  r2.xyzw = saturate(-r5.xyzw * float4(4,4,4,4) + r2.xyzw);
  r4.xyz = cb0[36].zzz * r4.xyz * injectedData.fxLens;
  r4.w = 0;
  r1.zw = cb0[28].yy * r1.xy;
  r5.xyzw = t2.Sample(s2_s, r1.zw).xyzw;
  r1.z = r5.y + r5.y;
  r0.xyzw = r0.xyzw * float4(0.0625,0.0625,0.0625,0.0625) + -r2.xyzw;
  r0.xyzw = cb0[37].wwww * r0.xyzw + r2.xyzw;
  r2.xyzw = cb0[36].yyyy * r0.xyzw * injectedData.fxBloom;
  r2.xyzw = r2.xyzw * r1.zzzz + r3.xyzw;
  r0.xyzw = r0.xyzw * r4.xyzw + r2.xyzw;
  if (cb0[44].y < 0.5) {
    r1.zw = r1.xy / cb0[28].xx;
    r2.xy = -cb0[42].xy + r1.zw;
    r2.yz = cb0[43].xx * abs(r2.yx) * min(1.f, injectedData.fxVignette);
    r2.w = cb0[29].x / cb0[29].y;
    r2.w = -1 + r2.w;
    r2.w = cb0[43].w * r2.w + 1;
    r2.x = r2.z * r2.w;
    r2.xy = saturate(r2.xy);
    r2.xy = log2(r2.xy);
    r2.xy = cb0[43].zz * r2.xy;
    r2.xy = exp2(r2.xy);
    r2.x = dot(r2.xy, r2.xy);
    r2.x = 1 + -r2.x;
    r2.x = max(0, r2.x);
    r2.x = log2(r2.x);
    r2.x = cb0[43].y * r2.x * max(1.f, injectedData.fxVignette);
    r2.x = exp2(r2.x);
    r1.zw = r1.zw * cb0[41].xy + cb0[41].wz;
    r3.xyzw = t6.Sample(s6_s, r1.zw).xyzw;
    r2.yzw = cb0[40].yzw * r3.xyz + float3(-1,-1,-1);
    r2.yzw = r3.www * r2.yzw + float3(1,1,1);
    r3.xyz = float3(1,1,1) + -r2.yzw;
    r2.yzw = r2.xxx * r3.xyz + r2.yzw;
    r4.xyz = r2.yzw * r0.xyz;
    r1.z = 1 + -r0.w;
    r1.z = r3.w * r1.z + r0.w;
    r1.w = -r1.z + r0.w;
    r4.w = r2.x * r1.w + r1.z;
  } else {
    r1.xy = r1.xy / cb0[28].xx;
    r1.xyzw = t7.Sample(s7_s, r1.xy).xyzw;
    r1.x = renodx::color::srgb::DecodeSafe(r1.w);
    r1.yzw = float3(1,1,1) + -cb0[40].yzw;
    r1.yzw = r1.xxx * r1.yzw + cb0[40].yzw;
    r1.yzw = r0.xyz * r1.yzw + -r0.xyz;
    r4.xyz = cb0[44].xxx * r1.yzw + r0.xyz;
    r0.x = -1 + r0.w;
    r4.w = r1.x * r0.x + 1;
  }
  r0.xyzw = cb0[40].xxxx * r4.xyzw;
  r1.yzx = lutShaper(r0.xyz);
  if(injectedData.colorGradeLUTSampling == 0.f){
  r1.yzw = cb0[39].www * r1.xyz;
  r1.y = floor(r1.y);
  r2.xy = float2(0.5,0.5) * cb0[39].yz;
  r2.yz = r1.zw * cb0[39].yz + r2.xy;
  r2.x = r1.y * cb0[39].z + r2.y;
  r3.xyzw = t5.Sample(s5_s, r2.xz).xyzw;
  r4.x = cb0[39].z;
  r4.y = 0;
  r1.zw = r4.xy + r2.xz;
  r2.xyzw = t5.Sample(s5_s, r1.zw).xyzw;
  r1.x = r1.x * cb0[39].w + -r1.y;
  r1.yzw = r2.xyz + -r3.xyz;
  r0.xyz = r1.xxx * r1.yzw + r3.xyz;
  } else {
    r0.xyz = renodx::lut::SampleTetrahedral(t5, r1.yzx, cb0[39].w + 1u);
  }
  if (cb0[53].y > 0.5) {
    r0.w = renodx::color::y::from::BT709(saturate(r0.xyz));
  }
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyzw = r0.xyzw;
  return;
}