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
SamplerState s5Sampler_s : register(s5);
SamplerState s6Sampler_s : register(s6);
SamplerState s7Sampler_s : register(s7);
SamplerState s8Sampler_s : register(s8);
SamplerState s9Sampler_s : register(s9);
Texture2D<float4> s0 : register(t0);
Texture2D<float4> s1 : register(t1);
Texture2D<float4> s2 : register(t2);
Texture3D<float4> s3_3D : register(t3);
Texture2D<float4> s5 : register(t5);
Texture2D<float4> s6 : register(t6);
Texture2D<float4> s7 : register(t7);
Texture2D<float4> s8 : register(t8);
Texture2D<float4> s9 : register(t9);
Texture2DArray<float4> sBlueNoiseR8 : register(t11);
Texture2DArray<float4> sBlueNoiseR8G8 : register(t12);

#define cmp -

void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.zw * float2(2,2) + float2(-1,-1);
  r0.xz = Global.c[15].xy * r0.xy;
  r0.w = dot(r0.xz, r0.xz);
  r0.w = sqrt(r0.w);
  r0.w = PostProcess.Settings[2].w * r0.w;
  r1.xy = v1.xy * float2(2,1.125) + float2(-1,-0.5625);
  r1.x = dot(r1.xy, r1.xy);
  r1.x = sqrt(r1.x);
  r1.x = 0.871575534 * r1.x;
  r1.y = r1.x * r1.x;
  r1.x = r1.x * r1.x + -0.150000006;
  r1.x = saturate(1.81818199 * r1.x);
  r1.z = r1.x * -2 + 3;
  r1.x = r1.x * r1.x;
  r1.x = r1.z * r1.x;
  r1.x = r1.y * r1.x;
  r0.w = r1.x * r0.w;
  r1.xy = r0.xz * PostProcess.Settings[2].zz * injectedData.fxChroma + v1.zw;
  r0.xz = -r0.xz * PostProcess.Settings[2].zz * injectedData.fxChroma + v1.zw;
  r1.x = s0.SampleLevel(s0Sampler_s, r1.xy, r0.w).x;
  r1.y = s0.SampleLevel(s0Sampler_s, r0.xz, r0.w).y;
  r2.xyzw = s0.SampleLevel(s0Sampler_s, v1.zw, r0.w).xyzw;
  r0.xz = -User.c[2].zw + v1.zw;
  r3.xyz = s0.SampleLevel(s0Sampler_s, r0.xz, r0.w).xyz;
  r4.xw = User.c[2].xy;
  r4.yz = float2(0,0);
  r4.xyzw = r4.xyzw + r0.xzxz;
  r5.xyz = s0.SampleLevel(s0Sampler_s, r4.xy, r0.w).xyz;
  r4.xyz = s0.SampleLevel(s0Sampler_s, r4.zw, r0.w).xyz;
  r0.xz = User.c[2].xy + r0.xz;
  r0.xzw = s0.SampleLevel(s0Sampler_s, r0.xz, r0.w).xyz;
  r3.xyz = r5.xyz + r3.xyz;
  r3.xyz = r3.xyz + r4.xyz;
  r0.xzw = r3.xyz + r0.xzw;
  r0.xzw = r2.xyz * float3(4,4,4) + -r0.xzw;
  r1.z = r2.z;
  if (Global.c[0].x == 0.f) {
    r0.xzw = r0.xzw * PostProcess.Settings[0].www + r1.xyz;
  } else {
    r0.xzw = r0.xzw * PostProcess.Settings[0].www * injectedData.fxSharpen + r1.xyz;
  }
  r1.xyz = float3(0.5,0.5,0.5) * r2.xyz;
  r2.xyz = r2.xyz + r2.xyz;
  r0.xzw = max(r1.xyz, r0.xzw);
  r0.xzw = min(r0.xzw, r2.xyz);
  r1.z = s6.SampleLevel(s6Sampler_s, v1.xy, 0).x;
  r1.xy = v1.xy * float2(2,2) + float2(-1,-1);
  r1.w = 1;
  r2.x = dot(r1.xyzw, Global.c[53].xyzw);
  r2.y = dot(r1.xyzw, Global.c[54].xyzw);
  r2.z = dot(r1.xyzw, Global.c[55].xyzw);
  r1.x = dot(r1.xyzw, Global.c[56].xyzw);
  r1.xyz = r2.xyz / r1.xxx;
  r1.x = dot(r1.xyz, r1.xyz);
  r1.x = sqrt(r1.x);
  r1.yzw = s2.Sample(s2Sampler_s, v1.zw).xyz;
  r2.xyz = s8.Sample(s8Sampler_s, v1.xy).xyz;
  r2.xyz = r2.xyz * PostProcess.Settings[4].www * injectedData.fxLens + PostProcess.Settings[4].zzz * injectedData.fxBloom;
  r1.yzw = r1.yzw + -r0.xzw;
  r0.xzw = r2.xyz * r1.yzw + r0.xzw;
  r3.xyzw = s5.Sample(s5Sampler_s, v1.xy).xyzw;
  r1.y = s7.Sample(s7Sampler_s, float2(0.5,0.5)).x;
  r1.z = 1;
  r1.w = dot(r1.yz, Global.c[55].zw);
  r1.y = dot(r1.yz, Global.c[56].zw);
  r1.y = r1.w / r1.y;
  r1.z = -PostProcess.Settings[6].w * r1.y + r1.y;
  r1.w = PostProcess.Settings[6].w * r1.y + r1.y;
  r1.z = max(r1.x, r1.z);
  r1.z = min(r1.z, r1.w);
  r1.w = r1.x + -r1.z;
  r1.w = PostProcess.Settings[5].w * r1.w;
  r1.z = -PostProcess.Settings[5].y + r1.z;
  r1.x = r1.x * r1.z;
  r1.x = r1.w / r1.x;
  r1.z = min(0, r1.x);
  r1.z = PostProcess.Settings[7].z * r1.z;
  r1.y = PostProcess.Settings[6].w * r1.y + 1;
  r1.y = rcp(r1.y);
  r1.x = max(0, r1.x);
  r1.x = r1.z * r1.y + r1.x;
  r1.y = min(r3.w, r1.x);
  r1.x = max(abs(r1.y), abs(r1.x));
  r1.x = min(1, r1.x);
  r1.y = PostProcess.Settings[6].x * r1.x;
  r1.yz = r1.yy * PostProcess.Settings[7].xy + v1.xy;
  r1.yz = s5.Sample(s5Sampler_s, r1.yz).zw;
  r1.y = r1.y + -r3.z;
  r3.z = abs(r1.z) * r1.y + r3.z;
  r1.x = r1.x * PostProcess.Settings[6].x + -1;
  r1.y = -1 + PostProcess.Settings[7].w;
  r1.x = saturate(r1.x / r1.y);
  r1.yzw = r3.xyz + -r0.xzw;
  if (Global.c[0].x == 0.f) {
    r0.xzw = r1.xxx * r1.yzw + r0.xzw;
  } else {
    r0.xzw = r1.xxx * r1.yzw * injectedData.fxDoF + r0.xzw;
  }
  r1.x = s1.Load(int3(0,0,0)).x;
  r0.xzw = lerp(1.f, r1.xxx, injectedData.fxAutoExposure) * r0.xzw;
  r1.y = PostProcess.Settings[13].w * r0.y * injectedData.fxVignette;
  r1.x = v1.z * 2 + -1;
  r0.y = dot(r1.xy, r1.xy);
  r0.y = sqrt(r0.y);
  r0.y = saturate(r0.y * PostProcess.Settings[13].x + PostProcess.Settings[13].y);
  r0.y = log2(r0.y);
  r0.y = PostProcess.Settings[13].z * r0.y;
  r0.y = exp2(r0.y);
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
  if (injectedData.fxFilmGrainType == 0.f) {
  r0.a = renodx::color::y::from::BT709(r0.rgb);
  r1.x = cmp(0 < PostProcess.Settings[10].y);
  if (r1.x != 0) {
    r1.xy = (uint2)v0.xy;
    r1.z = cmp(0 < PostProcess.Settings[10].x);
    r1.z = r1.z ? 1.000000 : 0;
    r1.w = (uint)Global.c[1].w;
    r3.z = (int)r1.w * (int)r1.z;
    r3.xy = (int2)r1.xy & int2(63,63);
    r3.w = 0;
    r1.xy = sBlueNoiseR8G8.Load(r3.xyzw).xy;
    r1.y = r1.x * r1.y;
    r1.yzw = float3(-2,2,2) * r1.yyy;
    r1.xyz = r1.xxx * float3(1,-1,-1) + r1.yzw;
  } else {
    r2.xy = v1.xy * PostProcess.Settings[9].xy + PostProcess.Settings[9].zw;
    r2.xyz = s9.Sample(s9Sampler_s, r2.xy).xyz;
    r3.xy = (uint2)v0.xy;
    r3.xy = (int2)r3.xy & int2(63,63);
    r3.zw = float2(0,0);
    r1.w = sBlueNoiseR8.Load(r3.xyzw).x;
    r3.xyz = r1.www + -r2.xyz;
    r2.xyz = r3.xyz * float3(0.5,0.5,0.5) + r2.xyz;
    r1.xyz = r2.xyz * float3(2,2,2) + float3(-1,-1,-1);
  }
  r1.w = 1 + r0.w;
  r0.w = r0.w / r1.w;
  r1.w = -9.99999975e-05 + r0.w;
  r1.w = saturate(1111.11108 * r1.w);
  r2.x = r1.w * -2 + 3;
  r1.w = r1.w * r1.w;
  r1.w = r2.x * r1.w;
  r2.x = PostProcess.Settings[2].y + -PostProcess.Settings[2].x;
  r0.w = r0.w * r2.x + PostProcess.Settings[2].x;
  r1.xyz = r1.xyz * r0.www;
  r0.xyz = r1.xyz * r1.www + r0.xyz;
  } else {
    r0.rgb = applyFilmGrain(r0.rgb, v1.xy);
  }
  r0.rgb = applyUserTonemap(r0.rgb);
  r0.rgb = renodx::color::srgb::EncodeSafe(r0.rgb);
  r1.xy = (uint2)v0.xy;
  r3.z = (uint)Global.c[1].w;
  r3.xy = (int2)r1.xy & int2(63,63);
  r3.w = 0;
  r1.x = sBlueNoiseR8.Load(r3.xyzw).x;
  r0.w = 0;
  r1.xyz = r1.xxx * float3(-0.00392156886,0.00392156886,0.00392156886) + r0.xww;
  r0.x = 0.00392156886;
  o0.xyz = r0.xyz + r1.xyz;
  o0.w = r2.w;
  o0.rgb = PostToneMapScale(o0.rgb);
  return;
}