#include "../../common.hlsl"

Texture2D<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s5_s : register(s5);
SamplerState s4_s : register(s4);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[43];
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

  r0.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + float4(v1, w1);
  r1.xyzw = r0.xyzw * cb0[28].zzzz + float4(0.5,0.5,0.5,0.5);
  r0.xyzw = r0.xyzw * cb0[28].zzzz + -cb0[29].xyxy;
  r0.xyzw = cb0[29].zwzw * r0.xyzw;
  r2.x = dot(r0.xy, r0.xy);
  r2.x = sqrt(r2.x);
  if (cb0[28].w > 0) {
    r2.zw = cb0[28].xy * r2.xx;
    sincos(r2.z, r3.x, r4.x);
    r2.z = r3.x / r4.x;
    r2.w = 1 / r2.w;
    r2.z = r2.z * r2.w + -1;
    r2.zw = r0.xy * r2.zz + r1.xy;
  } else {
    r3.x = 1 / r2.x;
    r3.x = cb0[28].x * r3.x;
    r2.x = cb0[28].y * r2.x;
    r3.y = min(1, abs(r2.x));
    r3.z = max(1, abs(r2.x));
    r3.z = 1 / r3.z;
    r3.y = r3.y * r3.z;
    r3.z = r3.y * r3.y;
    r3.w = r3.z * 0.0208350997 + -0.0851330012;
    r3.w = r3.z * r3.w + 0.180141002;
    r3.w = r3.z * r3.w + -0.330299497;
    r3.z = r3.z * r3.w + 0.999866009;
    r3.w = r3.y * r3.z;
    r3.w = r3.w * -2 + 1.57079637;
    r3.w = abs(r2.x) > 1 ? r3.w : 0;
    r3.y = r3.y * r3.z + r3.w;
    r2.x = min(1, r2.x);
    r2.x = (r2.x < -r2.x) ? -r3.y : r3.y;
    r2.x = r3.x * r2.x + -1;
    r2.zw = r0.xy * r2.xx + r1.xy;
  }
  r0.x = dot(r0.zw, r0.zw);
  r0.x = sqrt(r0.x);
  if (cb0[28].w > 0) {
    r1.xy = cb0[28].xy * r0.xx;
    sincos(r1.x, r1.x, r2.x);
    r0.y = r1.x / r2.x;
    r1.x = 1 / r1.y;
    r0.y = r0.y * r1.x + -1;
    r1.xy = r0.zw * r0.yy + r1.zw;
  } else {
    r0.y = 1 / r0.x;
    r0.y = cb0[28].x * r0.y;
    r0.x = cb0[28].y * r0.x;
    r2.x = min(1, abs(r0.x));
    r2.y = max(1, abs(r0.x));
    r2.y = 1 / r2.y;
    r2.x = r2.x * r2.y;
    r2.y = r2.x * r2.x;
    r3.x = r2.y * 0.0208350997 + -0.0851330012;
    r3.x = r2.y * r3.x + 0.180141002;
    r3.x = r2.y * r3.x + -0.330299497;
    r2.y = r2.y * r3.x + 0.999866009;
    r3.x = r2.x * r2.y;
    r3.x = r3.x * -2 + 1.57079637;
    r3.x = abs(r0.x) > 1 ? r3.x : 0;
    r2.x = r2.x * r2.y + r3.x;
    r0.x = min(1, r0.x);
    r0.x = (r0.x < -r0.x) ? -r2.x : r2.x;
    r0.x = r0.y * r0.x + -1;
    r1.xy = r0.zw * r0.xx + r1.zw;
  }
  r0.xyzw = t1.Sample(s1_s, v1.xy).xyzw;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r0.yzw = renodx::color::srgb::DecodeSafe(r1.xyz);
  r1.xyz = r0.yzw * r0.xxx;
  r0.xyzw = float4(-1,-1,1,1) * cb0[32].xyxy;
  r2.x = 0.5 * cb0[34].x;
  r3.xyzw = saturate(r0.xyzy * r2.xxxx + r2.zwzw);
  r3.xyzw = cb0[26].xxxx * r3.xyzw;
  r4.xyzw = t2.Sample(s2_s, r3.xy).xyzw;
  r3.xyzw = t2.Sample(s2_s, r3.zw).xyzw;
  r3.xyzw = r4.xyzw + r3.xyzw;
  r0.xyzw = saturate(r0.xwzw * r2.xxxx + r2.zwzw);
  r0.xyzw = cb0[26].xxxx * r0.xyzw;
  r4.xyzw = t2.Sample(s2_s, r0.xy).xyzw;
  r3.xyzw = r4.xyzw + r3.xyzw;
  r0.xyzw = t2.Sample(s2_s, r0.zw).xyzw;
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = cb0[34].yyyy * r0.xyzw * injectedData.fxBloom;
  r2.xy = r2.zw * cb0[33].xy + cb0[33].zw;
  r3.xyzw = t3.Sample(s3_s, r2.xy).xyzw;
  r4.xyzw = float4(0.25,0.25,0.25,0.25) * r0.xyzw;
  r3.xyz = cb0[34].zzz * r3.xyz * injectedData.fxLens;
  r3.w = 0;
  r0.xyzw = float4(0.25,0.25,0.25,1) * r0.xyzw;
  r5.xyz = cb0[35].xyz * r0.xyz;
  r5.w = 0.25 * r0.w;
  r0.xyzw = r5.xyzw + r1.xyzw;
  r0.xyzw = r3.xyzw * r4.xyzw + r0.xyzw;
  if (cb0[40].y < 0.5) {
    r1.xy = -cb0[38].xy + r2.zw;
    r1.yz = cb0[39].xx * abs(r1.yx) * min(1.f, injectedData.fxVignette);
    r1.w = cb0[22].x / cb0[22].y;
    r1.w = -1 + r1.w;
    r1.w = cb0[39].w * r1.w + 1;
    r1.x = r1.z * r1.w;
    r1.xy = saturate(r1.xy);
    r1.xy = log2(r1.xy);
    r1.xy = cb0[39].zz * r1.xy;
    r1.xy = exp2(r1.xy);
    r1.x = dot(r1.xy, r1.xy);
    r1.x = 1 + -r1.x;
    r1.x = max(0, r1.x);
    r1.x = log2(r1.x);
    r1.x = cb0[39].y * r1.x * max(1.f, injectedData.fxVignette);
    r1.x = exp2(r1.x);
    r1.yzw = float3(1,1,1) + -cb0[37].xyz;
    r1.yzw = r1.xxx * r1.yzw + cb0[37].xyz;
    r3.xyz = r1.yzw * r0.xyz;
    r1.y = -1 + r0.w;
    r3.w = r1.x * r1.y + 1;
  } else {
    r1.xyzw = t5.Sample(s5_s, r2.zw).xyzw;
    r1.xyz = float3(1,1,1) + -cb0[37].xyz;
    r1.xyz = r1.www * r1.xyz + cb0[37].xyz;
    r1.xyz = r0.xyz * r1.xyz + -r0.xyz;
    r3.xyz = cb0[40].xxx * r1.xyz + r0.xyz;
    r0.x = -1 + r0.w;
    r3.w = r1.w * r0.x + 1;
  }
  r3.w = saturate(r3.w);
  r0.yzx = lutShaper(r3.xyz, false, 2);
  if(injectedData.colorGradeLUTSampling == 0.f){
  r0.yzw = cb0[36].zzz * r0.xyz;
  r0.y = floor(r0.y);
  r1.xy = float2(0.5,0.5) * cb0[36].xy;
  r1.yz = r0.zw * cb0[36].xy + r1.xy;
  r1.x = r0.y * cb0[36].y + r1.y;
  r2.xyzw = t4.Sample(s4_s, r1.xz).xyzw;
  r3.x = cb0[36].y;
  r3.y = 0;
  r0.zw = r3.xy + r1.xz;
  r1.xyzw = t4.Sample(s4_s, r0.zw).xyzw;
  r0.x = r0.x * cb0[36].z + -r0.y;
  r0.yzw = r1.xyz + -r2.xyz;
  r0.xyz = r0.xxx * r0.yzw + r2.xyz;
  } else {
    r0.xyz = renodx::lut::SampleTetrahedral(t4, r0.yzx, cb0[36].z + 1u);
  }
  r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  if (cb0[42].x > 0.5) {
    o0.w = renodx::color::y::from::BT709(saturate(r0.xyz));
  } else {
    o0.w = r3.w;
  }
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz, true);
  } else {
    r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
  }
  o0.xyz = r0.xyz;
  return;
}