#include "../../common.hlsli"

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
  r2.xyz = renodx::color::srgb::DecodeSafe(r2.xyz);
  r0.xyz = handleUserLUT(r2.xyz, t0, s0_s, cb0[35].xyz, 0, true, true);
  float3 preCG = r0.xyz;
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
  if(RENODX_TONE_MAP_TYPE == 0.f){
  r0.xyz = max(float3(0,0,0), r0.xyz);
  }
  r0.w = dot(r0.xyz, float3(0.212672904,0.715152204,0.0721750036));
  r0.xyz = lerp(r0.www, r0.xyz, cb0[36].y);
  if(RENODX_TONE_MAP_TYPE == 0.f){
    r0.xyz = saturate(r0.xyz);
  }
  r1.xyz = r0.xyz + r0.xyz;
  r2.xyz = cb0[29].xyz * r1.xyz;
  r1.xyz = cb0[28].xyz * r1.xyz;
  r3.xyz = r0.xyz * r0.xyz;
  r4.xyz = -cb0[29].xyz * float3(2,2,2) + float3(1,1,1);
  r2.xyz = r3.xyz * r4.xyz + r2.xyz;
  if(RENODX_TONE_MAP_TYPE == 0.f){
    r2.xyz = saturate(r2.xyz);
  } else {
    float3 newblend = r0.xyz * cb0[29].xyz + (r0.xyz * cb0[29].xyz / (1 + r0.xyz * cb0[29].xyz));
    r2.xyz = cb0[29].xyz > (0.5).xxx ? newblend : r2.xyz;
  }
  r2.xyz = lerp(r0.xyz, r2.xyz, cb0[29].w);
  r4.xyz = -cb0[28].xyz * float3(2,2,2) + float3(1,1,1);
  r1.xyz = r3.xyz * r4.xyz + r1.xyz;
  if(RENODX_TONE_MAP_TYPE == 0.f){
    r1.xyz = saturate(r1.xyz);
  } else {
    float3 newblend = r0.xyz * cb0[28].xyz + (r0.xyz * cb0[28].xyz / (1 + r0.xyz * cb0[28].xyz));
    r1.xyz = cb0[28].xyz > (0.5).xxx ? newblend : r1.xyz;
  }
  r0.xyz = lerp(r0.xyz, r1.xyz, cb0[28].w);
  r0.xyz = lerp(r0.xyz, r2.xyz, cb0[30].x);
  r0.xyz = r0.xyz * cb0[40].xxx + float3(-0.217637643,-0.217637643,-0.217637643);
  r0.xyz = r0.xyz * cb0[40].yyy + float3(0.217637643,0.217637643,0.217637643);
  if(RENODX_TONE_MAP_TYPE == 0.f){
    r0.xyz = saturate(r0.xyz);
  }
  r0.xyz = renodx::math::SignPow(r0.xyz, cb0[40].z);
  r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  r0.xyz = lerp(preCG, r0.xyz, CUSTOM_INTERNAL_LUT_STRENGTH);
  if (CUSTOM_COUNT_OLD_2 == CUSTOM_COUNT_NEW_2) {
  r0.xyz = GradeAndDisplayMap(r0.xyz);
  }
  r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}