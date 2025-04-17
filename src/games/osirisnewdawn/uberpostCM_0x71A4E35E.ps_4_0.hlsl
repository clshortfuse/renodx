#include "./common.hlsl"

Texture2D<float4> t7 : register(t7);
Texture2D<float4> t6 : register(t6);
Texture3D<float4> t5 : register(t5);
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
cbuffer cb0 : register(b0) {
  float4 cb0[42];
}

#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    float2 w1: TEXCOORD1,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t2.Sample(s2_s, v1.xy).xyzw;
  r1.xyzw = t1.Sample(s1_s, w1.xy).xyzw;
  r1.xyz = r1.xyz * r0.xxx;
  r0.xyzw = float4(1, 1, -1, 0) * cb0[32].xyxy;
  r2.xyzw = saturate(-r0.xywy * cb0[34].xxxx + v1.xyxy);
  r2.xyzw = cb0[26].xxxx * r2.xyzw;
  r3.xyzw = t3.Sample(s3_s, r2.xy).xyzw;
  r2.xyzw = t3.Sample(s3_s, r2.zw).xyzw;
  r2.xyzw = r2.xyzw * float4(2, 2, 2, 2) + r3.xyzw;
  r3.xy = saturate(-r0.zy * cb0[34].xx + v1.xy);
  r3.xy = cb0[26].xx * r3.xy;
  r3.xyzw = t3.Sample(s3_s, r3.xy).xyzw;
  r2.xyzw = r3.xyzw + r2.xyzw;
  r3.xyzw = saturate(r0.zwxw * cb0[34].xxxx + v1.xyxy);
  r3.xyzw = cb0[26].xxxx * r3.xyzw;
  r4.xyzw = t3.Sample(s3_s, r3.xy).xyzw;
  r2.xyzw = r4.xyzw * float4(2, 2, 2, 2) + r2.xyzw;
  r3.xy = saturate(v1.xy);
  r3.xy = cb0[26].xx * r3.xy;
  r4.xyzw = t3.Sample(s3_s, r3.xy).xyzw;
  r2.xyzw = r4.xyzw * float4(4, 4, 4, 4) + r2.xyzw;
  r3.xyzw = t3.Sample(s3_s, r3.zw).xyzw;
  r2.xyzw = r3.xyzw * float4(2, 2, 2, 2) + r2.xyzw;
  r3.xyzw = saturate(r0.zywy * cb0[34].xxxx + v1.xyxy);
  r3.xyzw = cb0[26].xxxx * r3.xyzw;
  r4.xyzw = t3.Sample(s3_s, r3.xy).xyzw;
  r2.xyzw = r4.xyzw + r2.xyzw;
  r3.xyzw = t3.Sample(s3_s, r3.zw).xyzw;
  r2.xyzw = r3.xyzw * float4(2, 2, 2, 2) + r2.xyzw;
  r0.xy = saturate(r0.xy * cb0[34].xx + v1.xy);
  r0.xy = cb0[26].xx * r0.xy;
  r0.xyzw = t3.Sample(s3_s, r0.xy).xyzw;
  r0.xyzw = r2.xyzw + r0.xyzw;
  r0.xyzw = cb0[34].yyyy * r0.xyzw * injectedData.fxBloom;
  r2.xy = v1.xy * cb0[33].xy + cb0[33].zw;
  r2.xyzw = t4.Sample(s4_s, r2.xy).xyzw;
  r3.xyzw = float4(0.0625, 0.0625, 0.0625, 0.0625) * r0.xyzw;
  r2.xyz = cb0[34].zzz * r2.xyz * injectedData.fxLensFlare;
  r2.w = 0;
  r0.xyzw = float4(0.0625, 0.0625, 0.0625, 1) * r0.xyzw;
  r4.xyz = cb0[35].xyz * r0.xyz;
  r4.w = 0.0625 * r0.w;
  r0.xyzw = r4.xyzw + r1.xyzw;
  r0.xyzw = r2.xyzw * r3.xyzw + r0.xyzw;
  r1.x = cmp(cb0[40].y < 0.5);
  if (r1.x != 0) {
    r1.xy = -cb0[38].xy + v1.xy;
    r1.yz = cb0[39].xx * abs(r1.yx) * min(1, injectedData.fxVignette);
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
    r1.x = cb0[39].y * r1.x * max(1, injectedData.fxVignette);
    r1.x = exp2(r1.x);
    r1.yzw = float3(1, 1, 1) + -cb0[37].xyz;
    r1.yzw = r1.xxx * r1.yzw + cb0[37].xyz;
    r1.yzw = r1.yzw * r0.xyz;
    r2.x = -1 + r0.w;
    r2.w = r1.x * r2.x + 1;
  } else {
    r3.xyzw = t6.Sample(s6_s, v1.xy).xyzw;
    r1.x = 0.0773993805 * r3.w;
    r3.x = 0.0549999997 + r3.w;
    r3.x = 0.947867334 * r3.x;
    r3.x = max(1.1920929e-07, abs(r3.x));
    r3.x = log2(r3.x);
    r3.x = 2.4000001 * r3.x;
    r3.x = exp2(r3.x);
    r3.y = cmp(0.0404499993 >= r3.w);
    r1.x = r3.y ? r1.x : r3.x;
    r3.xyz = float3(1, 1, 1) + -cb0[37].xyz;
    r3.xyz = r1.xxx * r3.xyz + cb0[37].xyz;
    r3.xyz = r0.xyz * r3.xyz + -r0.xyz;
    r1.yzw = cb0[40].xxx * r3.xyz + r0.xyz;
    r0.x = -1 + r0.w;
    r2.w = r1.x * r0.x + 1;
  }
  r0.xy = w1.xy * cb0[41].xy + cb0[41].zw;
  r0.xyzw = t7.Sample(s7_s, r0.xy).xyzw;
  r0.w = renodx::color::y::from::BT709(r1.gba);
  r0.a = renodx::math::SignSqrt(r0.a);
  r0.w = cb0[40].z * -r0.w + 1;
  r0.xyz = r1.yzw * r0.xyz;
  r0.xyz = cb0[40].www * r0.xyz * injectedData.fxFilmGrain;
  if (injectedData.fxFilmGrainType == 0.f) {
    r2.xyz = r0.xyz * r0.www + r1.yzw;
  } else {
    r2.rgb = applyFilmGrain(r1.gba, v1);
  }
  r0.xyzw = cb0[36].zzzz * r2.xyzw;
  r0.rgb = lutShaper(r0.rgb);
  if (injectedData.colorGradeLUTSampling == 0.f) {
  r0.xyz = cb0[36].yyy * r0.xyz;
  r1.x = 0.5 * cb0[36].x;
  r0.xyz = r0.xyz * cb0[36].xxx + r1.xxx;
  r1.xyzw = t5.Sample(s5_s, r0.xyz).xyzw;
  } else {
    r1.rgb = renodx::lut::SampleTetrahedral(t5, r0.rgb, 1 / cb0[36].x);
  }
  if (injectedData.fxNoise > 0.f) {
    r0.xy = v1.xy * cb0[30].xy + cb0[30].zw;
    r2.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
    r0.x = r2.w * 2 + -1;
    r0.y = saturate(r0.x * 3.40282347e+38 + 0.5);
    r0.y = r0.y * 2 + -1;
    r0.x = 1 + -abs(r0.x);
    r0.x = sqrt(r0.x);
    r0.x = 1 + -r0.x;
    r0.x = r0.y * r0.x;
    r1.rgb = renodx::color::srgb::EncodeSafe(r1.rgb);
    r1.rgb = r0.rrr * float3(0.00392156886, 0.00392156886, 0.00392156886) * injectedData.fxNoise + r1.rgb;
    r1.rgb = renodx::color::srgb::DecodeSafe(r1.rgb);
  }
  r1.rgb = PostToneMapScale(r1.rgb);
  o0.rgb = r1.rgb;
  o0.w = r0.w;
  return;
}
