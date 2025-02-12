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
Texture2D<float4> s0 : register(t0);
Texture2D<float4> s1 : register(t1);
Texture2D<float4> s2 : register(t2);
Texture3D<float4> s3_3D : register(t3);
Texture2D<float4> s5 : register(t5);
Texture2D<float4> s6 : register(t6);
Texture2D<float4> s7 : register(t7);
Texture2D<float4> s8 : register(t8);
Texture2DArray<float4> sBlueNoiseR8 : register(t11);

#define cmp -

void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy * float2(2,1.125) + float2(-1,-0.5625);
  r0.x = dot(r0.xy, r0.xy);
  r0.x = sqrt(r0.x);
  r0.x = 0.871575534 * r0.x;
  r0.y = r0.x * r0.x + -0.150000006;
  r0.y = saturate(1.81818199 * r0.y);
  r0.z = r0.y * -2 + 3;
  r0.y = r0.y * r0.y;
  r0.xy = r0.xz * r0.xy;
  r0.x = r0.x * r0.y;
  r0.yz = v1.zw * float2(2,2) + float2(-1,-1);
  r0.yz = Global.c[15].xy * r0.yz;
  r0.w = dot(r0.yz, r0.yz);
  r0.w = sqrt(r0.w);
  r0.w = PostProcess.Settings[2].w * r0.w;
  r0.x = r0.w * r0.x;
  r1.xw = User.c[2].xy;
  r1.yz = float2(0,0);
  r2.xy = -User.c[2].zw + v1.zw;
  r1.xyzw = r2.xyxy + r1.xyzw;
  r3.xyz = s0.SampleLevel(s0Sampler_s, r1.xy, r0.x).xyz;
  r1.xyz = s0.SampleLevel(s0Sampler_s, r1.zw, r0.x).xyz;
  r4.xyz = s0.SampleLevel(s0Sampler_s, r2.xy, r0.x).xyz;
  r2.xy = User.c[2].xy + r2.xy;
  r2.xyz = s0.SampleLevel(s0Sampler_s, r2.xy, r0.x).xyz;
  r3.xyz = r4.xyz + r3.xyz;
  r1.xyz = r3.xyz + r1.xyz;
  r1.xyz = r1.xyz + r2.xyz;
  r2.xyzw = s0.SampleLevel(s0Sampler_s, v1.zw, r0.x).xyzw;
  r1.xyz = r2.xyz * float3(4,4,4) + -r1.xyz;
  r3.xy = r0.yz * PostProcess.Settings[2].zz * injectedData.fxChroma + v1.zw;
  r0.yz = -r0.yz * PostProcess.Settings[2].zz * injectedData.fxChroma + v1.zw;
  r0.z = s0.SampleLevel(s0Sampler_s, r0.yz, r0.x).y;
  r0.y = s0.SampleLevel(s0Sampler_s, r3.xy, r0.x).x;
  r0.w = r2.z;
  if (Global.c[0].x == 0.f) {
    r0.xyz = r1.xyz * PostProcess.Settings[0].www + r0.yzw;
  } else {
    r0.xyz = r1.xyz * PostProcess.Settings[0].www * injectedData.fxSharpen + r0.yzw;
  }
  r1.xyz = float3(0.5,0.5,0.5) * r2.xyz;
  r0.xyz = max(r1.xyz, r0.xyz);
  r1.xyz = r2.xyz + r2.xyz;
  o0.w = r2.w;
  r0.xyz = min(r1.xyz, r0.xyz);
  r1.xyz = s2.Sample(s2Sampler_s, v1.zw).xyz;
  r1.xyz = r1.xyz + -r0.xyz;
  r2.xyz = s8.Sample(s8Sampler_s, v1.xy).xyz;
  r2.xyz = r2.xyz * PostProcess.Settings[4].www * injectedData.fxBloom + PostProcess.Settings[4].zzz * injectedData.fxLens;
  r0.xyz = r2.xyz * r1.xyz + r0.xyz;
  r1.z = s6.SampleLevel(s6Sampler_s, v1.xy, 0).x;
  r1.xy = v1.xy * float2(2,2) + float2(-1,-1);
  r1.w = 1;
  r2.x = dot(r1.xyzw, Global.c[53].xyzw);
  r2.y = dot(r1.xyzw, Global.c[54].xyzw);
  r2.z = dot(r1.xyzw, Global.c[55].xyzw);
  r0.w = dot(r1.xyzw, Global.c[56].xyzw);
  r1.xyz = r2.xyz / r0.www;
  r0.w = dot(r1.xyz, r1.xyz);
  r0.w = sqrt(r0.w);
  r1.x = s7.Sample(s7Sampler_s, float2(0.5,0.5)).x;
  r1.y = 1;
  r1.z = dot(r1.xy, Global.c[55].zw);
  r1.x = dot(r1.xy, Global.c[56].zw);
  r1.x = r1.z / r1.x;
  r1.y = -PostProcess.Settings[6].w * r1.x + r1.x;
  r1.y = max(r1.y, r0.w);
  r1.z = PostProcess.Settings[6].w * r1.x + r1.x;
  r1.x = PostProcess.Settings[6].w * r1.x + 1;
  r1.x = rcp(r1.x);
  r1.y = min(r1.y, r1.z);
  r1.z = -r1.y + r0.w;
  r1.y = -PostProcess.Settings[5].y + r1.y;
  r0.w = r1.y * r0.w;
  r1.y = PostProcess.Settings[5].w * r1.z;
  r0.w = r1.y / r0.w;
  r1.y = min(0, r0.w);
  r0.w = max(0, r0.w);
  r1.y = PostProcess.Settings[7].z * r1.y;
  r0.w = r1.y * r1.x + r0.w;
  r1.xyzw = s5.Sample(s5Sampler_s, v1.xy).xyzw;
  r1.w = min(r1.w, r0.w);
  r0.w = max(abs(r1.w), abs(r0.w));
  r0.w = min(1, r0.w);
  r1.w = PostProcess.Settings[6].x * r0.w;
  r0.w = r0.w * PostProcess.Settings[6].x + -1;
  r2.xy = r1.ww * PostProcess.Settings[7].xy + v1.xy;
  r2.xy = s5.Sample(s5Sampler_s, r2.xy).zw;
  r1.w = r2.x + -r1.z;
  r1.z = abs(r2.y) * r1.w + r1.z;
  r1.xyz = r1.xyz + -r0.xyz;
  r1.w = -1 + PostProcess.Settings[7].w;
  r0.w = saturate(r0.w / r1.w);
  if (Global.c[0].x == 0.f) {
    r0.xyz = r0.www * r1.xyz + r0.xyz;
  } else {
    r0.xyz = r0.www * r1.xyz * injectedData.fxDoF + r0.xyz;
  }
  r0.w = s1.Load(int3(0,0,0)).x;
  r0.xyz = r0.xyz * lerp(1.f, r0.www, injectedData.fxAutoExposure);
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