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
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.z = s6.SampleLevel(s6Sampler_s, v1.xy, 0).x;
  r0.xy = v1.xy * float2(2,2) + float2(-1,-1);
  r0.w = 1;
  r1.x = dot(r0.xyzw, Global.c[53].xyzw);
  r1.y = dot(r0.xyzw, Global.c[54].xyzw);
  r1.z = dot(r0.xyzw, Global.c[55].xyzw);
  r0.x = dot(r0.xyzw, Global.c[56].xyzw);
  r0.xyz = r1.xyz / r0.xxx;
  r0.x = dot(r0.xyz, r0.xyz);
  r0.x = sqrt(r0.x);
  r0.y = -PostProcess.Settings[6].w * PostProcess.Settings[5].x + PostProcess.Settings[5].x;
  r0.y = max(r0.x, r0.y);
  r0.z = PostProcess.Settings[6].w * PostProcess.Settings[5].x + PostProcess.Settings[5].x;
  r0.y = min(r0.y, r0.z);
  r0.z = r0.x + -r0.y;
  r0.y = -PostProcess.Settings[5].y + r0.y;
  r0.x = r0.x * r0.y;
  r0.y = PostProcess.Settings[5].w * r0.z;
  r0.x = r0.y / r0.x;
  r0.y = min(0, r0.x);
  r0.x = max(0, r0.x);
  r0.y = PostProcess.Settings[7].z * r0.y;
  r0.z = PostProcess.Settings[6].w * PostProcess.Settings[5].x + 1;
  r0.z = rcp(r0.z);
  r0.x = r0.y * r0.z + r0.x;
  r1.xyzw = s5.Sample(s5Sampler_s, v1.xy).xyzw;
  r0.y = min(r1.w, r0.x);
  r0.x = max(abs(r0.y), abs(r0.x));
  r0.x = min(1, r0.x);
  r0.y = PostProcess.Settings[6].x * r0.x;
  r0.x = r0.x * PostProcess.Settings[6].x + -1;
  r0.yz = r0.yy * PostProcess.Settings[7].xy + v1.xy;
  r0.yz = s5.Sample(s5Sampler_s, r0.yz).zw;
  r0.y = r0.y + -r1.z;
  r1.z = abs(r0.z) * r0.y + r1.z;
  r0.yz = v1.xy * float2(2,1.125) + float2(-1,-0.5625);
  r0.y = dot(r0.yz, r0.yz);
  r0.y = sqrt(r0.y);
  r0.y = 0.871575534 * r0.y;
  r0.z = r0.y * r0.y + -0.150000006;
  r0.z = saturate(1.81818199 * r0.z);
  r0.w = r0.z * -2 + 3;
  r0.z = r0.z * r0.z;
  r0.yz = r0.yw * r0.yz;
  r0.y = r0.y * r0.z;
  r0.zw = v1.zw * float2(2,2) + float2(-1,-1);
  r0.zw = Global.c[15].xy * r0.zw;
  r1.w = dot(r0.zw, r0.zw);
  r1.w = sqrt(r1.w);
  r1.w = PostProcess.Settings[2].w * r1.w;
  r0.y = r1.w * r0.y;
  r2.xy = r0.zw * PostProcess.Settings[2].zz * injectedData.fxChroma + v1.zw;
  r0.zw = -r0.zw * PostProcess.Settings[2].zz * injectedData.fxChroma + v1.zw;
  r3.y = s0.SampleLevel(s0Sampler_s, r0.zw, r0.y).y;
  r3.x = s0.SampleLevel(s0Sampler_s, r2.xy, r0.y).x;
  r3.zw = s0.SampleLevel(s0Sampler_s, v1.zw, r0.y).zw;
  o0.w = r3.w;
  r0.yzw = r3.xyz;
  r2.xyz = s2.Sample(s2Sampler_s, v1.zw).xyz;
  r2.xyz = r2.xyz + -r0.yzw;
  r3.xyz = s8.Sample(s8Sampler_s, v1.xy).xyz;
  r3.xyz = r3.xyz * PostProcess.Settings[4].www * injectedData.fxLens + PostProcess.Settings[4].zzz * injectedData.fxBloom;
  r0.yzw = r3.xyz * r2.xyz + r0.yzw;
  r1.xyz = r1.xyz + -r0.yzw;
  r1.w = -1 + PostProcess.Settings[7].w;
  r0.x = saturate(r0.x / r1.w);
  if (Global.c[0].x == 0.f) {
    r0.xyz = r0.xxx * r1.xyz + r0.yzw;
  } else {
    r0.xyz = r0.xxx * r1.xyz * injectedData.fxDoF + r0.yzw;
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