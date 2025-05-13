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
SamplerState s8Sampler_s : register(s8);
Texture2D<float4> s0 : register(t0);
Texture2D<float4> s1 : register(t1);
Texture2D<float4> s2 : register(t2);
Texture3D<float4> s3_3D : register(t3);
Texture2D<float4> s5 : register(t5);
Texture2D<float4> s6 : register(t6);
Texture2D<float4> s8 : register(t8);
Texture2DArray<float4> sBlueNoiseR8 : register(t11);

#define cmp -

void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = v1.xyzw * float4(2,2,2,2) + float4(-1,-1,-1,-1);
  r1.xyzw = Global.c[15].xyxy * r0.xyzw;
  r1.x = dot(r1.xy, r1.xy);
  r1.y = dot(r1.zw, r1.zw);
  r1.y = r1.y * Global.c[15].z + 1;
  r1.y = Global.c[15].w * r1.y;
  r0.zw = r1.yy * r0.zw;
  r0.zw = r0.zw * float2(0.5,0.5) + float2(0.5,0.5);
  r1.x = r1.x * Global.c[15].z + 1;
  r1.x = Global.c[15].w * r1.x;
  r0.xy = r1.xx * r0.xy;
  r0.xy = r0.xy * float2(0.5,0.5) + float2(0.5,0.5);
  r1.z = s6.SampleLevel(s6Sampler_s, r0.xy, 0).x;
  r1.xy = r0.xy * float2(2,2) + float2(-1,-1);
  r1.w = 1;
  r2.x = dot(r1.xyzw, Global.c[53].xyzw);
  r2.y = dot(r1.xyzw, Global.c[54].xyzw);
  r2.z = dot(r1.xyzw, Global.c[55].xyzw);
  r1.x = dot(r1.xyzw, Global.c[56].xyzw);
  r1.xyz = r2.xyz / r1.xxx;
  r1.x = dot(r1.xyz, r1.xyz);
  r1.x = sqrt(r1.x);
  r1.y = -PostProcess.Settings[6].w * PostProcess.Settings[5].x + PostProcess.Settings[5].x;
  r1.y = max(r1.x, r1.y);
  r1.z = PostProcess.Settings[6].w * PostProcess.Settings[5].x + PostProcess.Settings[5].x;
  r1.y = min(r1.y, r1.z);
  r1.z = r1.x + -r1.y;
  r1.y = -PostProcess.Settings[5].y + r1.y;
  r1.x = r1.x * r1.y;
  r1.y = PostProcess.Settings[5].w * r1.z;
  r1.x = r1.y / r1.x;
  r1.y = min(0, r1.x);
  r1.x = max(0, r1.x);
  r1.y = PostProcess.Settings[7].z * r1.y;
  r1.z = PostProcess.Settings[6].w * PostProcess.Settings[5].x + 1;
  r1.z = rcp(r1.z);
  r1.x = r1.y * r1.z + r1.x;
  r2.xyzw = s5.Sample(s5Sampler_s, r0.xy).xyzw;
  r1.y = min(r2.w, r1.x);
  r1.x = max(abs(r1.y), abs(r1.x));
  r1.x = min(1, r1.x);
  r1.y = PostProcess.Settings[6].x * r1.x;
  r1.x = r1.x * PostProcess.Settings[6].x + -1;
  r1.yz = r1.yy * PostProcess.Settings[7].xy + r0.xy;
  r3.xyz = s8.Sample(s8Sampler_s, r0.xy).xyz;
  r3.xyz = r3.xyz * PostProcess.Settings[4].www * injectedData.fxLens + PostProcess.Settings[4].zzz * injectedData.fxBloom;
  r0.xy = s5.Sample(s5Sampler_s, r1.yz).zw;
  r0.x = r0.x + -r2.z;
  r2.z = abs(r0.y) * r0.x + r2.z;
  r4.xyzw = r0.zwzw / User.c[2].xyxy;
  r4.xyzw = frac(r4.xyzw);
  r4.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + r4.xyzw;
  r4.xyzw = abs(r4.xyzw) * float4(2,2,2,2) + float4(1,1,1,1);
  r5.xw = User.c[2].xy * r4.xy;
  r0.xy = -User.c[2].zw * r4.zw + r0.zw;
  r1.yz = User.c[2].xy * r4.xy + r0.xy;
  r1.yzw = s0.SampleLevel(s0Sampler_s, r1.yz, 0).xyz;
  r5.yz = float2(0,0);
  r4.xyzw = r0.xyxy + r5.xyzw;
  r5.xyz = s0.SampleLevel(s0Sampler_s, r0.xy, 0).xyz;
  r6.xyz = s0.SampleLevel(s0Sampler_s, r4.xy, 0).xyz;
  r4.xyz = s0.SampleLevel(s0Sampler_s, r4.zw, 0).xyz;
  r5.xyz = r6.xyz + r5.xyz;
  r4.xyz = r5.xyz + r4.xyz;
  r1.yzw = r4.xyz + r1.yzw;
  r4.xyzw = s0.SampleLevel(s0Sampler_s, r0.zw, 0).xyzw;
  r1.yzw = r4.xyz * float3(4,4,4) + -r1.yzw;
  if (Global.c[0].x == 0.f) {
    r1.yzw = r1.yzw * PostProcess.Settings[0].www + r4.xyz;
  } else {
    r1.yzw = r1.yzw * PostProcess.Settings[0].www * injectedData.fxSharpen + r4.xyz;
  }
  r5.xyz = float3(0.5,0.5,0.5) * r4.xyz;
  r1.yzw = max(r5.xyz, r1.yzw);
  r4.xyz = r4.xyz + r4.xyz;
  o0.w = r4.w;
  r1.yzw = min(r4.xyz, r1.yzw);
  r4.xyz = s2.Sample(s2Sampler_s, r0.zw).xyz;
  r0.xy = r0.zw * float2(2,2) + float2(-1,-1);
  r4.xyz = r4.xyz + -r1.yzw;
  r1.yzw = r3.xyz * r4.xyz + r1.yzw;
  r2.xyz = r2.xyz + -r1.yzw;
  r0.w = -1 + PostProcess.Settings[7].w;
  r0.w = saturate(r1.x / r0.w);
  if (Global.c[0].x == 0.f) {
    r1.xyz = r0.www * r2.xyz + r1.yzw;
  } else {
    r1.xyz = r0.www * r2.xyz * injectedData.fxDoF + r1.yzw;
  }
  r0.w = s1.Load(int3(0,0,0)).x;
  r1.xyz = r1.xyz * lerp(1.f, r0.www, injectedData.fxAutoExposure);
  r2.xyz = r1.xyz * PostProcess.Settings[12].xyz + -r1.xyz;
  r0.z = PostProcess.Settings[13].w * r0.y * injectedData.fxVignette;
  r0.x = dot(r0.xz, r0.xz);
  r0.x = sqrt(r0.x);
  r0.x = saturate(r0.x * PostProcess.Settings[13].x + PostProcess.Settings[13].y);
  r0.x = log2(r0.x);
  r0.x = PostProcess.Settings[13].z * r0.x;
  r0.x = exp2(r0.x);
  r0.xyz = r0.xxx * r2.xyz + r1.xyz;
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