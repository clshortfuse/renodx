#include "../common.hlsli"

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
cbuffer cb2 : register(b2){
  float4 cb2[2];
}
cbuffer cb1 : register(b1){
  float4 cb1[2];
}
cbuffer cb0 : register(b0){
  float4 cb0[1];
}

float3 weirdLutSample(float3 color){
float4 r0, r1, r2;
    float3 sampled_color;
  r0.xyz = color;
  r0.y = 1 + -r0.y;
  r1.z = r0.y * 0.9375 + 0.03125;
  r0.x = r0.x * 0.05859375 + 0.001953125;
  r0.y = 15 * r0.z;
  r0.z = floor(r0.y);
  r0.y = frac(r0.y);
  r0.w = 1 + r0.z;
  r1.y = r0.z * 0.0625 + r0.x;
  r1.x = r0.w * 0.0625 + r0.x;
  r2.xyzw = t7.SampleLevel(s7_s, r1.xz, 0).xyzw;
  r1.xyzw = t7.SampleLevel(s7_s, r1.yz, 0).xyzw;
  r0.xzw = r2.xyz + -r1.xyz;
  return r0.yyy * r0.xzw + r1.xyz;
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r1.xyzw = t1.Sample(s1_s, v1.xy).xyzw;
  r0.xyz = r1.xyz * float3(2,2,2) + r0.xyz;
  r1.xyzw = t2.Sample(s2_s, v1.xy).xyzw;
  r0.xyz = r1.xyz * float3(3,3,3) + r0.xyz;
  r1.xyzw = t3.Sample(s3_s, v1.xy).xyzw;
  r0.xyz = r1.xyz * float3(2,2,2) + r0.xyz;
  r1.xyzw = t4.Sample(s4_s, v1.xy).xyzw;
  r0.xyz = r1.xyz + r0.xyz;
  r1.xyzw = t5.Sample(s5_s, v1.xy).xyzw;
  r0.xyz = r1.xyz * float3(0.5,0.5,0.5) + r0.xyz;
  r0.xyz = float3(0.105263159,0.105263159,0.105263159) * r0.xyz;
  r0.xyz = max(float3(0,0,0), r0.xyz);
  r0.xyz = min(float3(10,10,10), r0.xyz);
  r1.xy = float2(-0.5,-0.5) + v1.xy;
  r1.xy = float2(1.5,1.5) * r1.xy;
  r0.w = dot(r1.xy, r1.xy);
  r0.w = 1 + -r0.w;
  r0.w = max(0, r0.w);
  r0.w = r0.w * r0.w;
  r0.w = r0.w * r0.w + -1;
  r0.w = r0.w * 0.5 + 1;
  r0.xyz = r0.www * r0.xyz;
  r1.xyzw = t6.Sample(s6_s, float2(0.5,0.5)).xyzw;
  r0.w = dot(cb0[0].xx, r1.ww);
  r0.xyz = r0.www * r0.xyz;
  r0.xyz = Uncharted2Tonemap(r0.xyz, cb2[0].x, cb2[0].y, cb2[0].z, cb2[0].w, cb2[1].x, cb2[1].y, 20.f);
  r0.xyz = float3(-0.5,-0.5,-0.5) + r0.xyz;
  r0.xyz = r0.xyz * cb0[0].www + float3(0.5,0.5,0.5);
  float max_channel_scale = 1.f;
  float compression_scale = 1.f;
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    GamutCompression(r0.xyz, compression_scale);
    NeutwoMaxCh(r0.xyz, max_channel_scale);
  } else {
    r0.xyz = saturate(r0.xyz);
  }
    float3 lutInputColor = fastSrgbEncodeSafe(r0.xyz);
    float3 lutOutputColor = weirdLutSample(lutInputColor);
    float3 color_output = fastSrgbDecodeSafe(lutOutputColor);
    [branch]
    if (CUSTOM_USER_LUT_SCALING != 0.f) {
      float3 lutBlack = weirdLutSample(fastSrgbEncode(0));
      float3 lutMid = weirdLutSample(fastSrgbEncode(0.18f));
      float3 lutWhite = weirdLutSample(fastSrgbEncode(1.f));
      float3 unclamped_gamma = renodx::lut::Unclamp(
          lutOutputColor,
          lutBlack,
          lutMid,
          lutWhite,
          lutInputColor);
      float3 unclamped_linear = fastSrgbDecodeSafe(unclamped_gamma);
      float3 recolored = renodx::lut::RecolorUnclamped(color_output, unclamped_linear, CUSTOM_USER_LUT_SCALING);
      color_output = recolored;
    } else {
    }
    r0.xyz = lerp(r0.xyz, color_output, CUSTOM_USER_LUT_STRENGTH);
    if(RENODX_TONE_MAP_TYPE != 0.f){
    NeutwoMaxChInverse(r0.xyz, max_channel_scale);
    GamutDecompression(r0.xyz, compression_scale);
    }
  r0.xyz = cb0[0].zzz * r0.xyz;
  if(RENODX_TONE_MAP_TYPE == 0.f){
  r0.xyz = log2(r0.xyz);
  r0.xyz = cb0[0].yyy * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  } else {
    r0.xyz = renodx::math::SignPow(r0.xyz, cb0[0].y);
  }
  r1.xyz = cb1[1].xyz + -r0.xyz;
  r0.xyz = cb1[1].www * r1.xyz + r0.xyz;
  if (CUSTOM_COUNT_OLD == CUSTOM_COUNT_NEW) {
    r0.xyz = GradeAndDisplayMap(r0.xyz);
  }
  if (CUSTOM_COUNT_OLD == CUSTOM_COUNT_NEW) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}