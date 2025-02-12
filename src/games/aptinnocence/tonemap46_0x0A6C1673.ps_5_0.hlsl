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
  float4 r0,r1,r2,r3,r4,r5,r6,r7;
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
  r1.xy = r0.xy * float2(2,2) + float2(-1,-1);
  r2.xyz = s8.Sample(s8Sampler_s, r0.xy).xyz;
  r2.xyz = r2.xyz * PostProcess.Settings[4].www * injectedData.fxLens + PostProcess.Settings[4].zzz * injectedData.fxBloom;
  r1.z = 0.5625 * r1.y;
  r0.x = dot(r1.xz, r1.xz);
  r0.x = sqrt(r0.x);
  r0.x = 0.871575534 * r0.x;
  r0.y = r0.x * r0.x + -0.150000006;
  r0.x = r0.x * r0.x;
  r0.y = saturate(1.81818199 * r0.y);
  r1.x = r0.y * -2 + 3;
  r0.y = r0.y * r0.y;
  r0.y = r1.x * r0.y;
  r0.x = r0.x * r0.y;
  r1.xy = r0.zw * float2(2,2) + float2(-1,-1);
  r3.xy = Global.c[15].xy * r1.xy;
  r0.y = dot(r3.xy, r3.xy);
  r0.y = sqrt(r0.y);
  r0.y = PostProcess.Settings[2].w * r0.y;
  r0.x = r0.y * r0.x;
  r4.xyzw = r0.zwzw / User.c[2].xyxy;
  r4.xyzw = frac(r4.xyzw);
  r4.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + r4.xyzw;
  r4.xyzw = abs(r4.xyzw) * float4(2,2,2,2) + float4(1,1,1,1);
  r5.xw = User.c[2].xy * r4.xy;
  r5.yz = float2(0,0);
  r3.zw = -User.c[2].zw * r4.zw + r0.zw;
  r4.xy = User.c[2].xy * r4.xy + r3.zw;
  r4.xyz = s0.SampleLevel(s0Sampler_s, r4.xy, r0.x).xyz;
  r5.xyzw = r3.zwzw + r5.xyzw;
  r6.xyz = s0.SampleLevel(s0Sampler_s, r3.zw, r0.x).xyz;
  r7.xyz = s0.SampleLevel(s0Sampler_s, r5.xy, r0.x).xyz;
  r5.xyz = s0.SampleLevel(s0Sampler_s, r5.zw, r0.x).xyz;
  r6.xyz = r7.xyz + r6.xyz;
  r5.xyz = r6.xyz + r5.xyz;
  r4.xyz = r5.xyz + r4.xyz;
  r5.xyzw = s0.SampleLevel(s0Sampler_s, r0.zw, r0.x).xyzw;
  r4.xyz = r5.xyz * float3(4,4,4) + -r4.xyz;
  r3.zw = r3.xy * PostProcess.Settings[2].zz * injectedData.fxChroma + r0.zw;
  r3.xy = -r3.xy * PostProcess.Settings[2].zz * injectedData.fxChroma + r0.zw;
  r0.yzw = s2.Sample(s2Sampler_s, r0.zw).xyz;
  r6.y = s0.SampleLevel(s0Sampler_s, r3.xy, r0.x).y;
  r6.x = s0.SampleLevel(s0Sampler_s, r3.zw, r0.x).x;
  r6.z = r5.z;
  if (Global.c[0].x == 0.f) {
    r3.xyz = r4.xyz * PostProcess.Settings[0].www + r6.xyz;
  } else {
    r3.xyz = r4.xyz * PostProcess.Settings[0].www * injectedData.fxSharpen + r6.xyz;
  }
  r4.xyz = float3(0.5,0.5,0.5) * r5.xyz;
  r3.xyz = max(r4.xyz, r3.xyz);
  r4.xyz = r5.xyz + r5.xyz;
  o0.w = r5.w;
  r3.xyz = min(r4.xyz, r3.xyz);
  r0.xyz = -r3.xyz + r0.yzw;
  r0.xyz = r2.xyz * r0.xyz + r3.xyz;
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