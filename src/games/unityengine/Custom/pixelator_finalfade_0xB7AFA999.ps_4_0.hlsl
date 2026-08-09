#include "../tonemap.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[10];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r0.xyzw = -cb0[4].xyzw + r0.xyzw;
  r1.xy = float2(-0.5,-0.5) + v1.yx;
  r1.z = dot(r1.xy, r1.xy);
  r1.xy = abs(r1.xy) >= cb0[9].xy ? float2(1,1) : 0;
  r1.x = r1.x + r1.y;
  r1.x = min(1, r1.x);
  r1.y = -r1.z * cb0[3].x + 1;
  r0.xyzw = r1.yyyy * r0.xyzw + cb0[4].xyzw;
  r1.y = dot(r0.xyz, float3(0.222000003,0.707000017,0.0710000023));
  r2.xyz = -r1.yyy * cb0[6].xyz + r0.xyz;
  r1.yzw = cb0[6].xyz * r1.yyy;
  r1.yzw = cb0[5].xxx * r2.xyz + r1.yzw;
  if(injectedData.toneMapType == 0.f){
    r1.yzw = saturate(r1.yzw);
  }
  r2.xyzw = t1.Sample(s1_s, v1.xy).xyzw;
  r2.xyz = r2.xyz + -r1.yzw;
  r2.w = cb0[9].z * r2.w;
  r0.xyz = r2.www * r2.xyz + r1.yzw;
  //r2.xyzw = saturate(r0.xyzw);
  r2.xyzw = r0.xyzw;
  if(injectedData.toneMapType == 0.f){
    r2 = saturate(r2);
  }
  r0.xyzw = -r2.xyzw + r0.xyzw;
  r1.y = cb0[7].x <= 1 ? 1.000000 : 0;
  r0.xyzw = r1.yyyy * r0.xyzw + r2.xyzw;
  r0.xyzw = -cb0[8].xyzw + r0.xyzw;
  r0.xyzw = cb0[7].xxxx * r0.xyzw + cb0[8].xyzw;
  r2.xyzw = float4(0,0,0,1) + -r0.xyzw;
  o0.xyzw = r1.xxxx * r2.xyzw + r0.xyzw;
  if (injectedData.tonemapCheck == 1.f && (injectedData.count2Old == injectedData.count2New)) {
    o0.xyz = renodx::color::srgb::DecodeSafe(o0.xyz);
  o0.xyz = applyUserNoTonemap(o0.xyz);
  o0.xyz = renodx::color::srgb::EncodeSafe(o0.xyz);
  }
  if (injectedData.countOld == injectedData.countNew) {
    o0.xyz = renodx::color::srgb::DecodeSafe(o0.xyz);
  o0.xyz = PostToneMapScale(o0.xyz, true);
  }
  return;
}