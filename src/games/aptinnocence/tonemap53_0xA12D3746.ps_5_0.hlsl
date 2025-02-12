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
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = v1.xyz * float3(2,1.125,2) + float3(-1,-0.5625,-1);
  r0.x = dot(r0.xy, r0.xy);
  r0.x = sqrt(r0.x);
  r0.x = 0.871575534 * r0.x;
  r0.y = r0.x * r0.x + -0.150000006;
  r0.x = r0.x * r0.x;
  r0.y = saturate(1.81818199 * r0.y);
  r1.x = r0.y * -2 + 3;
  r0.y = r0.y * r0.y;
  r0.y = r1.x * r0.y;
  r0.x = r0.x * r0.y;
  r1.xy = v1.zw * float2(2,2) + float2(-1,-1);
  r1.xz = Global.c[15].xy * r1.xy;
  r0.w = PostProcess.Settings[13].w * r1.y * injectedData.fxVignette;
  r0.y = dot(r0.zw, r0.zw);
  r0.y = sqrt(r0.y);
  r0.y = saturate(r0.y * PostProcess.Settings[13].x + PostProcess.Settings[13].y);
  r0.y = log2(r0.y);
  r0.y = PostProcess.Settings[13].z * r0.y;
  r0.y = exp2(r0.y);
  r0.z = dot(r1.xz, r1.xz);
  r0.z = sqrt(r0.z);
  r0.z = PostProcess.Settings[2].w * r0.z;
  r0.x = r0.z * r0.x;
  r0.zw = r1.xz * PostProcess.Settings[2].zz * injectedData.fxChroma + v1.zw;
  r1.xy = -r1.xz * PostProcess.Settings[2].zz * injectedData.fxChroma + v1.zw;
  r1.y = s0.SampleLevel(s0Sampler_s, r1.xy, r0.x).y;
  r1.x = s0.SampleLevel(s0Sampler_s, r0.zw, r0.x).x;
  r1.zw = s0.SampleLevel(s0Sampler_s, v1.zw, r0.x).zw;
  o0.w = r1.w;
  r0.xzw = r1.xyz;
  r1.xyz = s2.Sample(s2Sampler_s, v1.zw).xyz;
  r1.xyz = r1.xyz + -r0.xzw;
  r2.xyz = s8.Sample(s8Sampler_s, v1.xy).xyz;
  r2.xyz = r2.xyz * PostProcess.Settings[4].www * injectedData.fxLens + PostProcess.Settings[4].zzz * injectedData.fxBloom;
  r0.xzw = r2.xyz * r1.xyz + r0.xzw;
  r1.x = s1.Load(int3(0,0,0)).x;
  r0.xzw = lerp(1.f, r1.xxx, injectedData.fxAutoExposure) * r0.xzw;
  r1.xyz = r0.xzw * PostProcess.Settings[12].xyz + -r0.xzw;
  r0.xyz = r0.yyy * r1.xyz + r0.xzw;
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
  float3 untonemapped = r0.rgb;
  r1.xyz = r0.xyz * r0.xyz;
  r1.xyz = r1.xyz * r1.xyz;
  r1.xyz = r0.xyz * r1.xyz + float3(-1,-1,-1);
  r2.xyz = float3(-1,-1,-1) + r0.xyz;
  r0.xyz = cmp(r0.xyz != float3(1,1,1));
  r1.xyz = r1.xyz / r2.xyz;
  r2.xyz = float3(-1,-1,-1) + r1.xyz;
  r1.xyz = r2.xyz / r1.xyz;
  r0.xyz = r0.xyz ? r1.xyz : float3(0.800000012,0.800000012,0.800000012);
  float3 vanilla = r0.rgb;
  r0.rgb = applyUserTonemap(untonemapped, vanilla);
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