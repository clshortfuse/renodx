#include "./common.hlsl"

cbuffer CBufferGlobalConstant_Z : register(b0){
  struct
  {
    float4 c[90];
  } Global : packoffset(c0);
}
cbuffer CBufferUserConstant_Z : register(b1){
  struct
  {
    float4 c[58];
  } User : packoffset(c0);
}
cbuffer CBufferPostProcessConstant_Z : register(b2){
  struct
  {
    float4 Settings[16];
    float4 OffsetWeight[32];
  } PostProcess : packoffset(c0);
}
SamplerState s0Sampler_s : register(s0);
SamplerState s2Sampler_s : register(s2);
SamplerState s3_3DSampler_s : register(s3);
SamplerState s8Sampler_s : register(s8);
Texture2D<float4> s0 : register(t0);
Texture2D<float4> s1 : register(t1);
Texture2D<float4> s2 : register(t2);
Texture3D<float4> s3_3D : register(t3);
Texture2D<float4> s8 : register(t8);
Texture2DArray<float4> sBlueNoiseR8 : register(t11);

#define cmp -

void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = v1.w * 2 + -1;
  r0.y = PostProcess.Settings[13].w * r0.x * injectedData.fxVignette;
  r0.x = v1.z * 2 + -1;
  r0.x = dot(r0.xy, r0.xy);
  r0.x = sqrt(r0.x);
  r0.x = saturate(r0.x * PostProcess.Settings[13].x + PostProcess.Settings[13].y);
  r0.x = log2(r0.x);
  r0.x = PostProcess.Settings[13].z * r0.x;
  r0.x = exp2(r0.x);
  r1.xw = User.c[2].xy;
  r1.yz = float2(0,0);
  r0.yz = -User.c[2].zw + v1.zw;
  r1.xyzw = r0.yzyz + r1.xyzw;
  r2.xyz = s0.SampleLevel(s0Sampler_s, r1.xy, 0).xyz;
  r1.xyz = s0.SampleLevel(s0Sampler_s, r1.zw, 0).xyz;
  r3.xyz = s0.SampleLevel(s0Sampler_s, r0.yz, 0).xyz;
  r0.yz = User.c[2].xy + r0.yz;
  r0.yzw = s0.SampleLevel(s0Sampler_s, r0.yz, 0).xyz;
  r2.xyz = r3.xyz + r2.xyz;
  r1.xyz = r2.xyz + r1.xyz;
  r0.yzw = r1.xyz + r0.yzw;
  r1.xyzw = s0.SampleLevel(s0Sampler_s, v1.zw, 0).xyzw;
  r0.yzw = r1.xyz * float3(4,4,4) + -r0.yzw;
  if (Global.c[0].x == 0.f) {
    r0.yzw = r0.yzw * PostProcess.Settings[0].www + r1.xyz;
  } else {
    r0.yzw = r0.yzw * PostProcess.Settings[0].www * injectedData.fxSharpen + r1.xyz;
  }
  r2.xyz = float3(0.5,0.5,0.5) * r1.xyz;
  r0.yzw = max(r2.xyz, r0.yzw);
  r1.xyz = r1.xyz + r1.xyz;
  o0.w = r1.w;
  r0.yzw = min(r1.xyz, r0.yzw);
  r1.xyz = s2.Sample(s2Sampler_s, v1.zw).xyz;
  r1.xyz = r1.xyz + -r0.yzw;
  r2.xyz = s8.Sample(s8Sampler_s, v1.xy).xyz;
  r2.xyz = r2.xyz * PostProcess.Settings[4].www * injectedData.fxLens + PostProcess.Settings[4].zzz * injectedData.fxBloom;
  r0.yzw = r2.xyz * r1.xyz + r0.yzw;
  r1.x = s1.Load(int3(0,0,0)).x;
  r0.yzw = lerp(1.f, r1.xxx, injectedData.fxAutoExposure) * r0.yzw;
  r1.xyz = r0.yzw * PostProcess.Settings[12].xyz + -r0.yzw;
  r0.xyz = r0.xxx * r1.xyz + r0.yzw;
  float3 preLUT = r0.rgb;
  r0.rgb = renodx::color::pq::Encode(r0.rgb, PostProcess.Settings[10].w);
  r0.xyz = r0.xyz * PostProcess.OffsetWeight[0].xxx + PostProcess.OffsetWeight[0].yyy;
  r0.xyz = s3_3D.Sample(s3_3DSampler_s, r0.xyz).xyz;
  r0.rgb = renodx::color::pq::Decode(r0.rgb, PostProcess.Settings[10].w);
  if (injectedData.colorGradeLUTStrength > 0.f && injectedData.colorGradeLUTScaling > 0.f) {
    float3 scalingInput = float3(0,0,0) + PostProcess.OffsetWeight[0].yyy;
    float3 minBlack = s3_3D.Sample(s3_3DSampler_s, scalingInput).xyz;
    minBlack = renodx::color::pq::Decode(minBlack, PostProcess.Settings[10].w);
    float lutMinY = renodx::color::y::from::BT709(abs(minBlack));
    if (lutMinY > 0) {
      float3 correctedBlack = renodx::lut::CorrectBlack(preLUT, r0.rgb, lutMinY, 0.f);
      r0.rgb = lerp(r0.rgb, correctedBlack, injectedData.colorGradeLUTScaling);
    }
  }
  r0.rgb = lerp(preLUT, r0.rgb, injectedData.colorGradeLUTStrength);
  r0.rgb = applyUserTonemap(r0.rgb);
  r0.rgb = renodx::color::srgb::EncodeSafe(r0.rgb);
  r1.xy = (uint2)v0.xy;
  r1.xy = (int2)r1.xy & int2(63,63);
  r1.z = (uint)Global.c[1].w;
  r1.w = 0;
  r1.x = sBlueNoiseR8.Load(r1.xyzw).x;
  r0.w = 0;
  r1.xyz = r1.xxx * float3(-0.00392156886,0.00392156886,0.00392156886) + r0.xww;
  r0.x = 0.00392156886;
  o0.xyz = r0.xyz + r1.xyz;
  o0.rgb = PostToneMapScale(o0.rgb);
  return;
}