#include "./common.hlsl"

cbuffer CBufferGlobalConstant_Z : register(b0){
  struct
  {
    float4 c[90];
  } Global : packoffset(c0);
}
cbuffer CBufferPostProcessConstant_Z : register(b1){
  struct
  {
    float4 Settings[16];
    float4 OffsetWeight[32];
  } PostProcess : packoffset(c0);
}
SamplerState s0Sampler_s : register(s0);
SamplerState s3_3DSampler_s : register(s3);
SamplerState s9Sampler_s : register(s9);
Texture2D<float4> s0 : register(t0);
Texture2D<float4> s1 : register(t1);
Texture3D<float4> s3_3D : register(t3);
Texture2D<float4> s9 : register(t9);
Texture2DArray<float4> sBlueNoiseR8 : register(t11);
Texture2DArray<float4> sBlueNoiseR8G8 : register(t12);

#define cmp -

void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = s0.SampleLevel(s0Sampler_s, v1.zw, 0).xyzw;
  r1.x = s1.Load(int3(0,0,0)).x;
  r0.xyz = lerp(1.f, r1.xxx, injectedData.fxAutoExposure) * r0.xyz;
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
  if (injectedData.fxFilmGrainType == 0.f) {
  r1.r = renodx::color::y::from::BT709(r0.rgb);
  r1.y = cmp(0 < PostProcess.Settings[10].y);
  if (r1.y != 0) {
    r1.yz = (uint2)v0.xy;
    r1.w = cmp(0 < PostProcess.Settings[10].x);
    r1.w = r1.w ? 1.000000 : 0;
    r2.x = (uint)Global.c[1].w;
    r2.z = (int)r1.w * (int)r2.x;
    r2.xy = (int2)r1.yz & int2(63,63);
    r2.w = 0;
    r1.yz = sBlueNoiseR8G8.Load(r2.xyzw).xy;
    r1.z = r1.y * r1.z;
    r2.xyz = float3(-2,2,2) * r1.zzz;
    r1.yzw = r1.yyy * float3(1,-1,-1) + r2.xyz;
  } else {
    r2.xy = v1.xy * PostProcess.Settings[9].xy + PostProcess.Settings[9].zw;
    r2.xyz = s9.Sample(s9Sampler_s, r2.xy).xyz;
    r3.xy = (uint2)v0.xy;
    r3.xy = (int2)r3.xy & int2(63,63);
    r3.zw = float2(0,0);
    r2.w = sBlueNoiseR8.Load(r3.xyzw).x;
    r3.xyz = r2.www + -r2.xyz;
    r2.xyz = r3.xyz * float3(0.5,0.5,0.5) + r2.xyz;
    r1.yzw = r2.xyz * float3(2,2,2) + float3(-1,-1,-1);
  }
  r2.x = 1 + r1.x;
  r1.x = r1.x / r2.x;
  r2.x = -9.99999975e-05 + r1.x;
  r2.x = saturate(1111.11108 * r2.x);
  r2.y = r2.x * -2 + 3;
  r2.x = r2.x * r2.x;
  r2.x = r2.y * r2.x;
  r2.y = PostProcess.Settings[2].y + -PostProcess.Settings[2].x;
  r1.x = r1.x * r2.y + PostProcess.Settings[2].x;
  r1.xyz = r1.yzw * r1.xxx;
  r0.xyz = r1.xyz * r2.xxx * injectedData.fxFilmGrain + r0.xyz;
  } else {
    r0.rgb = applyFilmGrain(r0.rgb, v1.xy);
  }
  float3 untonemapped = r0.rgb;
  r0.xyz = max(float3(0,0,0), r0.xyz);
  r1.xyz = r0.xyz * r0.xyz;
  r1.xyz = r1.xyz * r1.xyz;
  r1.xyz = r0.xyz * r1.xyz + float3(-1,-1,-1);
  r2.xyz = float3(-1,-1,-1) + r0.xyz;
  r1.xyz = r1.xyz / r2.xyz;
  r2.xyz = float3(-1,-1,-1) + r1.xyz;
  r0.xyz = cmp(r0.xyz != float3(1,1,1));
  r1.xyz = r2.xyz / r1.xyz;
  r0.xyz = r0.xyz ? r1.xyz : float3(0.800000012,0.800000012,0.800000012);
  float3 vanilla = r0.rgb;
  r0.rgb = applyUserTonemap(untonemapped, vanilla);
  r1.rgb = renodx::color::srgb::EncodeSafe(r0.rgb);
  r0.xy = (uint2)v0.xy;
  r2.z = (uint)Global.c[1].w;
  r2.xy = (int2)r0.xy & int2(63,63);
  r2.w = 0;
  r0.x = sBlueNoiseR8.Load(r2.xyzw).x;
  r1.w = 0;
  r0.xyz = r0.xxx * float3(-0.00392156886,0.00392156886,0.00392156886) + r1.xww;
  r1.x = 0.00392156886;
  o0.xyz = r1.xyz + r0.xyz;
  o0.w = r0.w;
  o0.rgb = PostToneMapScale(o0.rgb);
  return;
}