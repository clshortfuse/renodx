#include "../../tonemap.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[41];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cb0[35].y;
  r0.y = 0;
  r1.yz = -cb0[34].yz + w1.xy;
  r0.z = cb0[34].x * r1.y;
  r1.x = frac(r0.z);
  r0.z = r1.x / cb0[34].x;
  r1.w = r1.y + -r0.z;
  r2.xyz = cb0[34].www * r1.xzw;
  r2.xyz = lutShaper(r2.xyz, true, 2);
  float3 preCG = renodx::color::srgb::DecodeSafe(r2.xyz);
  float3 sdrColor = renodx::tonemap::renodrt::NeutralSDR(preCG);
  float3 userLutInput = injectedData.toneMapType == 0.f ? saturate(preCG) : sdrColor;
  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.lut_sampler = s0_s;
  lut_config.strength = injectedData.colorGradeUserLUTStrength;
  lut_config.scaling = injectedData.colorGradeUserLUTScaling;
  lut_config.type_input = renodx::lut::config::type::SRGB;
  lut_config.type_input = renodx::lut::config::type::SRGB;
  lut_config.precompute = cb0[35].xyz;
  lut_config.recolor = 0.f;
  lut_config.max_channel = injectedData.toneMapType == 0.f ? 0.f : 1.f;
  lut_config.gamut_compress = injectedData.toneMapType == 0.f ? 0.f : 1.f;
  lut_config.tetrahedral = false;
  r0.xyz = renodx::lut::Sample(userLutInput, lut_config, t0);
  if (injectedData.toneMapType != 0.f) {
    lut_config.strength = 1.f;
    r0.xyz = renodx::tonemap::UpgradeToneMap(preCG, userLutInput, r0.xyz, injectedData.colorGradeUserLUTStrength);
  }
  preCG = r0.xyz;
  r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
  r0.xyz = lerp(r2.xyz, r0.xyz, cb0[35].w);
  r0.xyz = float3(-0.217637643,-0.217637643,-0.217637643) + r0.xyz;
  r0.xyz = r0.xyz * cb0[36].zzz + float3(0.217637643,0.217637643,0.217637643);
  float3 preLGG = r0.xyz;
  r0.xyz = r0.xyz * cb0[39].xyz + cb0[37].xyz;
  r1.xyz = log2(abs(r0.xyz));
  r0.xyz = saturate(r0.xyz * renodx::math::FLT_MAX + float3(0.5,0.5,0.5));
  r0.xyz = r0.xyz * float3(2,2,2) + float3(-1,-1,-1);
  r1.xyz = cb0[38].xyz * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r0.xyz = r1.xyz * r0.xyz;
  r0.xyz = liftGammaGainScaling(r0.xyz, preLGG, cb0[37].xyz, cb0[38].xyz, cb0[39].xyz, 2);
  if(injectedData.toneMapType == 0.f){
  r0.xyz = max(float3(0,0,0), r0.xyz);
  }
  r0.w = dot(r0.xyz, float3(0.212672904,0.715152204,0.0721750036));
  r0.xyz = lerp(r0.www, r0.xyz, cb0[36].y);
  if(injectedData.toneMapType == 0.f){
    r0.xyz = saturate(r0.xyz);
  }
  r1.xyz = float3(1,1,1) + -r0.xyz;
  if(injectedData.toneMapType == 0.f){
  r1.xyz = max((1.0 / 255.0), r1.xyz);
  }
  r2.xyz = max(float3(0.001,0.001,0.001), cb0[29].xyz);
  r2.xyz = r1.xyz / r2.xyz;
  r2.xyz = float3(1,1,1) + -r2.xyz;
  if(injectedData.toneMapType == 0.f){
  r2.xyz = max(float3(0,0,0), r2.xyz);
  }
  r2.xyz = lerp(r0.xyz, r2.xyz, cb0[29].w);
  r3.xyz = max(float3(0.001,0.001,0.001), cb0[28].xyz);
  r1.xyz = r1.xyz / r3.xyz;
  r1.xyz = float3(1,1,1) + -r1.xyz;
  if(injectedData.toneMapType == 0.f){
  r1.xyz = max(float3(0,0,0), r1.xyz);
  }
  r0.xyz = lerp(r0.xyz, r1.xyz, cb0[28].w);
  r0.xyz = lerp(r0.xyz, r2.xyz, cb0[30].x);
  r0.xyz = r0.xyz * cb0[40].xxx + float3(-0.217637643,-0.217637643,-0.217637643);
  r0.xyz = r0.xyz * cb0[40].yyy + float3(0.217637643,0.217637643,0.217637643);
  if(injectedData.toneMapType == 0.f){
    r0.xyz = saturate(r0.xyz);
  }
  r0.xyz = renodx::math::SignPow(r0.xyz, cb0[40].z);
  r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  r0.xyz = lerp(preCG, r0.xyz, injectedData.colorGradeInternalLUTStrength);
  if (injectedData.tonemapCheck == 1.f && (injectedData.count2Old == injectedData.count2New)) {
  r0.xyz = applyUserNoTonemap(r0.xyz);
  }
  r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}