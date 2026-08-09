#include "../../tonemap.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[3];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.zw = float2(-1.0, 2.0 / 3.0);
  r1.zw = float2(1,-1);
  r2.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  float3 preCG = r2.xyz;
  r3.x = step(r2.z, r2.y);
  r0.xy = r2.zy;
  r1.xy = r2.yz + -r0.xy;
  r0.xyzw = r3.xxxx * r1.xywz + r0.xywz;
  r1.z = r0.w;
  r2.y = step(r0.x, r2.x);
  r0.w = r2.x;
  o0.w = r2.w;
  r1.xyw = r0.wyx;
  r1.xyzw = r1.xyzw + -r0.xyzw;
  r0.xyzw = r2.yyyy * r1.yxzw + r0.yxzw;
  r1.x = min(r0.w, r0.x);
  r1.x = -r1.x + r0.y;
  r1.y = r1.x * 6.0 + 1.00000000e-10;
  r0.w = r0.w + -r0.x;
  r0.w = r0.w / r1.y;
  r0.z = r0.z + r0.w;
  r0.z = cb0[2].x + abs(r0.z);
  r1.yz = float2(1,-1) + r0.zz;
  r0.w = (r0.z > 1) ? r1.z : r0.z;
  r0.z = (r0.z < 0) ? r1.y : r0.w;
  r1.yzw = float3(1.0, 2.0 / 3.0, 1.0 / 3.0) + r0.zzz;
  r1.yzw = frac(r1.yzw);
  r1.yzw = r1.yzw * float3(6,6,6) + float3(-3,-3,-3);
  r1.yzw = saturate(float3(-1,-1,-1) + abs(r1.yzw));
  r1.yzw = float3(-1,-1,-1) + r1.yzw;
  r0.z = 1.00000000e-10 + r0.y;
  r0.x = r1.x / r0.z;
  r0.xy = cb0[2].yz * r0.xy;
  r0.xzw = r0.xxx * r1.yzw + float3(1,1,1);
  o0.xyz = r0.yyy * r0.xzw;
  o0.xyz = lerp(preCG, o0.xyz, injectedData.colorGradeUserLUTStrength);
  if(injectedData.gammaSpace != 0.f){
    o0.xyz = renodx::color::srgb::DecodeSafe(o0.xyz);
  }
  if (injectedData.tonemapCheck == 1.f && (injectedData.count2Old == injectedData.count2New)) {
    o0.xyz = applyUserNoTonemap(o0.xyz);
  }
  if (injectedData.countOld == injectedData.countNew) {
    o0.xyz = PostToneMapScale(o0.xyz, injectedData.gammaSpace != 0.f);
  } else if(injectedData.gammaSpace != 0.f){
    o0.xyz = renodx::color::srgb::EncodeSafe(o0.xyz);
  }
  return;
}