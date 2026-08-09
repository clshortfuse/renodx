#include "../../common.hlsl"

Texture2D<float4> t8 : register(t8);
Texture2D<float4> t7 : register(t7);
Texture2D<float4> t6 : register(t6);
Texture2D<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s8_s : register(s8);
SamplerState s7_s : register(s7);
SamplerState s6_s : register(s6);
SamplerState s5_s : register(s5);
SamplerState s4_s : register(s4);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[42];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t2.Sample(s2_s, v1.xy).xyzw;
  r0.yz = v1.xy * float2(2,2) + float2(-1,-1);
  r0.w = dot(r0.yz, r0.yz);
  r0.yz = r0.yz * r0.ww;
  r0.yz = cb0[35].ww * r0.yz * injectedData.fxCA;
  r1.xy = cb0[31].zw * -r0.yz;
  r1.xy = float2(0.5,0.5) * r1.xy;
  r0.w = dot(r1.xy, r1.xy);
  r0.w = sqrt(r0.w);
  r0.w = (int)r0.w;
  r0.w = max(3, (int)r0.w);
  r0.w = min(16, (int)r0.w);
  r1.x = (int)r0.w;
  r0.yz = -r0.yz / r1.xx;
  r2.yw = float2(0,0);
  r3.w = 1;
  r4.xyzw = float4(0,0,0,0);
  r5.xyzw = float4(0,0,0,0);
  r1.yz = v1.xy;
  r1.w = 0;
  while (true) {
    r6.x = cmp((int)r1.w >= (int)r0.w);
    if (r6.x != 0) break;
    r6.x = (int)r1.w;
    r6.x = 0.5 + r6.x;
    r2.x = r6.x / r1.x;
    r6.xy = saturate(r1.yz);
    r6.xy = cb0[26].xx * r6.xy;
    r6.xyzw = t1.SampleLevel(s1_s, r6.xy, 0).xyzw;
    r7.xyzw = t5.SampleLevel(s5_s, r2.xy, 0).xyzw;
    r3.xyz = r7.xyz;
    r4.xyzw = r6.xyzw * r3.xyzw + r4.xyzw;
    r5.xyzw = r5.xyzw + r3.xyzw;
    r1.yz = r1.yz + r0.yz;
    r1.w = (int)r1.w + 1;
  }
  r1.xyzw = r4.xyzw / r5.xyzw;
  r0.yzw = renodx::color::srgb::DecodeSafe(r1.xyz);
  r1.xyz = r0.yzw * r0.xxx;
  r0.xyzw = float4(-1,-1,1,1) * cb0[32].xyxy;
  r2.x = 0.5 * cb0[34].x;
  r3.xyzw = saturate(r0.xyzy * r2.xxxx + v1.xyxy);
  r3.xyzw = cb0[26].xxxx * r3.xyzw;
  r4.xyzw = t3.Sample(s3_s, r3.xy).xyzw;
  r3.xyzw = t3.Sample(s3_s, r3.zw).xyzw;
  r3.xyzw = r4.xyzw + r3.xyzw;
  r0.xyzw = saturate(r0.xwzw * r2.xxxx + v1.xyxy);
  r0.xyzw = cb0[26].xxxx * r0.xyzw;
  r4.xyzw = t3.Sample(s3_s, r0.xy).xyzw;
  r3.xyzw = r4.xyzw + r3.xyzw;
  r0.xyzw = t3.Sample(s3_s, r0.zw).xyzw;
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = cb0[34].yyyy * r0.xyzw * injectedData.fxBloom;
  r2.xy = v1.xy * cb0[33].xy + cb0[33].zw;
  r3.xyzw = t4.Sample(s4_s, r2.xy).xyzw;
  r4.xyz = float3(0.25,0.25,0.25) * r0.xyz;
  r3.xyz = cb0[34].zzz * r3.xyz * injectedData.fxLens;
  r0.xyzw = float4(0.25,0.25,0.25,1) * r0.xyzw;
  r5.xyz = cb0[35].xyz * r0.xyz;
  r5.w = 0.25 * r0.w;
  r0.xyzw = r5.xyzw + r1.xyzw;
  r1.xyz = r3.xyz * r4.xyz;
  r1.w = 0;
  r0.xyzw = r1.xyzw + r0.xyzw;
  if (cb0[40].y < 0.5) {
    r1.xy = -cb0[38].xy + v1.xy;
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
    r1.yzw = r1.yzw * r0.xyz;
    r2.x = -1 + r0.w;
    r3.w = r1.x * r2.x + 1;
  } else {
    r4.xyzw = t7.Sample(s7_s, v1.xy).xyzw;
    r4.xyz = float3(1,1,1) + -cb0[37].xyz;
    r4.xyz = r4.www * r4.xyz + cb0[37].xyz;
    r4.xyz = r0.xyz * r4.xyz + -r0.xyz;
    r1.yzw = cb0[40].xxx * r4.xyz + r0.xyz;
    r0.x = -1 + r0.w;
    r3.w = r4.w * r0.x + 1;
  }
  if(injectedData.fxFilmGrainType == 0.f){
  r0.xy = w1.xy * cb0[41].xy + cb0[41].zw;
  r0.xyzw = t8.Sample(s8_s, r0.xy).xyzw;
  r0.w = renodx::color::y::from::BT709(saturate(r1.yzw));
  r0.w = sqrt(r0.w);
  r0.w = cb0[40].z * -r0.w + 1;
  r0.xyz = r1.yzw * r0.xyz;
  r0.xyz = cb0[40].www * r0.xyz * injectedData.fxFilmGrain;
  r3.xyz = r0.xyz * r0.www + r1.yzw;
  } else {
    r3.xyz = applyFilmGrain(r1.yzw, w1);
  }
  r3.w = saturate(r3.w);
  r0.yzx = lutShaper(r3.xyz, false, 2);
  if(injectedData.colorGradeLUTSampling == 0.f){
  r0.yzw = cb0[36].zzz * r0.xyz;
  r0.y = floor(r0.y);
  r1.xy = float2(0.5,0.5) * cb0[36].xy;
  r1.yz = r0.zw * cb0[36].xy + r1.xy;
  r1.x = r0.y * cb0[36].y + r1.y;
  r4.xyzw = t6.Sample(s6_s, r1.xz).xyzw;
  r2.z = cb0[36].y;
  r0.zw = r1.xz + r2.zw;
  r1.xyzw = t6.Sample(s6_s, r0.zw).xyzw;
  r0.x = r0.x * cb0[36].z + -r0.y;
  r0.yzw = r1.xyz + -r4.xyz;
  r0.xyz = r0.xxx * r0.yzw + r4.xyz;
  } else {
    r0.xyz = renodx::lut::SampleTetrahedral(t6, r0.yzx, cb0[36].z + 1u);
  }
  r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  r1.xy = v1.xy * cb0[30].xy + cb0[30].zw;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r0.w = r1.w * 2 + -1;
  r1.x = saturate(r0.w * renodx::math::FLT_MAX + 0.5);
  r1.x = r1.x * 2 + -1;
  r0.w = 1 + -abs(r0.w);
  r0.w = sqrt(r0.w);
  r0.w = 1 + -r0.w;
  r0.w = r1.x * r0.w;
  r3.xyz = applyDither(r0.xyz, r0.w * (1.0 / 255.0));
  if(injectedData.countOld <= injectedData.countNew){
    r3.xyz = PostToneMapScale(r3.xyz, true);
  } else {
    r3.xyz = renodx::color::srgb::EncodeSafe(r3.xyz);
  }
  o0.xyzw = r3.xyzw;
  return;
}