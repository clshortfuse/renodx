#include "../tonemap.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[1];
}
cbuffer cb0 : register(b0){
  float4 cb0[7];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = -0.5 + v1.y;
  r0.y = 0.5 + -cb0[6].y;
  if (r0.y < abs(r0.x)) {
    o0.xyzw = float4(0,0,0,1);
    return;
  }
  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r0.w = dot(r0.xyz, float3(0.300000012,0.589999974,0.109999999));
  r1.x = dot(cb0[4].xyz, float3(0.300000012,0.589999974,0.109999999));
  r0.w = -r1.x + r0.w;
  r1.xyz = cb0[4].xyz + r0.www;
  r0.w = dot(r1.xyz, float3(0.300000012,0.589999974,0.109999999));
  r1.w = min(r1.y, r1.z);
  r1.w = min(r1.x, r1.w);
  r2.x = max(r1.y, r1.z);
  r2.x = max(r2.x, r1.x);
  r3.xyz = r1.xyz + -r0.www;
  r3.xyz = r3.xyz * r0.www;
  r3.xyz = r3.xyz / (r0.w - r1.w);
  r3.xyz = r3.xyz + r0.www;
  r1.xyz = (r1.w < 0) ? r3.xyz : r1.xyz;
  r2.yzw = r1.xyz + -r0.www;
  r3.x = 1 + -r0.w;
  r2.yzw = r3.xxx * r2.yzw;
  r2.xyz = r2.yzw / (r2.x - r0.w);
  r2.xyz = r2.xyz + r0.www;
  r1.xyz = (r2.x > 1) ? r2.xyz : r1.xyz;
  r0.w = 1 + -cb0[4].w;
  r1.xyz = cb0[4].www * r1.xyz;
  r0.xyz = r0.www * r0.xyz + r1.xyz;
  r1.xyzw = float4(1,1,1,1) + -cb0[5].wxyz;
  r2.xyz = float3(1,1,1) + -r0.xyz;
  r1.yzw = -r2.xyz * r1.yzw + float3(1,1,1);
  r1.yzw = cb0[5].www * r1.yzw;
  r0.xyz = r0.xyz * r1.xxx + r1.yzw;
  if (injectedData.tonemapCheck == 1.f && (injectedData.count2Old == injectedData.count2New)) {
    r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
    r0.xyz = applyUserNoTonemap(r0.xyz);
  }
  if (injectedData.fxFilmGrainType == 0.f) {
  r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
  r1.xyz = cb1[0].xxy * cb0[3].zzz;
  r1.xyz = floor(r1.xyz);
  r0.w = dot(r1.zzy, float3(12.9898,78.233,45.5432014));
  r0.w = sin(r0.w);
  r0.w = 43758.5469 * r0.w;
  r2.x = frac(r0.w);
  r0.w = dot(r1.xyz, float3(12.9898,78.233,45.5432014));
  r0.w = sin(r0.w);
  r0.w = 43758.546875 * r0.w;
  r2.y = frac(r0.w);
  r1.xy = v1.xy + r2.xy;
  r1.xy = r1.xy / cb0[3].xx;
  r1.xyzw = t1.Sample(s1_s, r1.xy).xyzw;
  r0.w = cb0[3].y * cb0[3].w;
  r1.w = -cb0[3].y * cb0[3].w + 1;
  r2.xyz = float3(1,1,1) + -r0.xyz;
  r1.xyz = float3(1,1,1) + -r1.xyz;
  r1.xyz = saturate(-r2.xyz * r1.xyz + float3(1,1,1));
  r1.xyz = r1.xyz * r0.www;
  r0.xyz = r1.www * r0.xyz + r1.xyz;
  r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  } else {
    r0.xyz = applyFilmGrain(r0.xyz, v1, cb0[3].w * 2.f);
  }
  /*r0.w = -cb0[6].x * 0.3 + 1;
  r1.xyz = log2(r0.xyz);
  r1.w = 0;
  r0.xyzw = r1.xyzw * r0.wwww;
  o0.xyzw = exp2(r0.xyzw);*/
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz, true);
  } else {
    r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
  }
  r0.w = 0;
  o0 = r0;
  return;
}