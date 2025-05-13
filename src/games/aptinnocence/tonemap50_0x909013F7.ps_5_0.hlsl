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
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.yz = float2(0,0);
  r1.xyzw = v1.xyzw * float4(2,2,2,2) + float4(-1,-1,-1,-1);
  r2.xyzw = Global.c[15].xyxy * r1.xyzw;
  r2.z = dot(r2.zw, r2.zw);
  r2.x = dot(r2.xy, r2.xy);
  r2.x = r2.x * Global.c[15].z + 1;
  r2.x = Global.c[15].w * r2.x;
  r1.xy = r2.xx * r1.xy;
  r1.xy = r1.xy * float2(0.5,0.5) + float2(0.5,0.5);
  r2.xyw = s8.Sample(s8Sampler_s, r1.xy).xyz;
  r2.xyw = r2.xyw * PostProcess.Settings[4].www * injectedData.fxLens + PostProcess.Settings[4].zzz * injectedData.fxBloom;
  r1.x = r2.z * Global.c[15].z + 1;
  r1.x = Global.c[15].w * r1.x;
  r1.xy = r1.zw * r1.xx;
  r1.xy = r1.xy * float2(0.5,0.5) + float2(0.5,0.5);
  r3.xyzw = r1.xyxy / User.c[2].xyxy;
  r3.xyzw = frac(r3.xyzw);
  r3.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + r3.xyzw;
  r3.xyzw = abs(r3.xyzw) * float4(2,2,2,2) + float4(1,1,1,1);
  r0.xw = User.c[2].xy * r3.xy;
  r1.zw = -User.c[2].zw * r3.zw + r1.xy;
  r3.xy = User.c[2].xy * r3.xy + r1.zw;
  r3.xyz = s0.SampleLevel(s0Sampler_s, r3.xy, 0).xyz;
  r0.xyzw = r1.zwzw + r0.xyzw;
  r4.xyz = s0.SampleLevel(s0Sampler_s, r1.zw, 0).xyz;
  r5.xyz = s0.SampleLevel(s0Sampler_s, r0.xy, 0).xyz;
  r0.xyz = s0.SampleLevel(s0Sampler_s, r0.zw, 0).xyz;
  r4.xyz = r5.xyz + r4.xyz;
  r0.xyz = r4.xyz + r0.xyz;
  r0.xyz = r0.xyz + r3.xyz;
  r3.xyzw = s0.SampleLevel(s0Sampler_s, r1.xy, 0).xyzw;
  r0.xyz = r3.xyz * float3(4,4,4) + -r0.xyz;
  if (Global.c[0].x == 0.f) {
    r0.xyz = r0.xyz * PostProcess.Settings[0].www + r3.xyz;
  } else {
    r0.xyz = r0.xyz * PostProcess.Settings[0].www * injectedData.fxSharpen + r3.xyz;
  }
  r4.xyz = float3(0.5,0.5,0.5) * r3.xyz;
  r0.xyz = max(r4.xyz, r0.xyz);
  r3.xyz = r3.xyz + r3.xyz;
  o0.w = r3.w;
  r0.xyz = min(r3.xyz, r0.xyz);
  r3.xyz = s2.Sample(s2Sampler_s, r1.xy).xyz;
  r1.xy = r1.xy * float2(2,2) + float2(-1,-1);
  r3.xyz = r3.xyz + -r0.xyz;
  r0.xyz = r2.xyw * r3.xyz + r0.xyz;
  r0.w = s1.Load(int3(0,0,0)).x;
  r0.xyz = r0.xyz * lerp(1.f, r0.www, injectedData.fxAutoExposure);
  r2.xyz = r0.xyz * PostProcess.Settings[12].xyz + -r0.xyz;
  r1.z = PostProcess.Settings[13].w * r1.y * injectedData.fxVignette;
  r0.w = dot(r1.xz, r1.xz);
  r0.w = sqrt(r0.w);
  r0.w = saturate(r0.w * PostProcess.Settings[13].x + PostProcess.Settings[13].y);
  r0.w = log2(r0.w);
  r0.w = PostProcess.Settings[13].z * r0.w;
  r0.w = exp2(r0.w);
  r0.xyz = r0.www * r2.xyz + r0.xyz;
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