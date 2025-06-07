#include "./common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[2];
}

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(1,0) + v0.xy;
  r0.x = dot(r0.xy, float2(0.0671105608,0.00583714992));
  r0.x = frac(r0.x);
  r0.x = 52.9829178 * r0.x;
  r0.x = frac(r0.x);
  r0.y = max(9.99999975e-06, cb0[1].x);
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  float3 preLA = r1.rgb;
  r1.rgb = renodx::math::SignPow(r1.rgb, 2.f);
  o0.w = saturate(r1.w);
  r0.z = renodx::color::y::from::BT709(r1.xyz);
  r0.y = renodx::math::SignPow(r0.z, r0.y);
  r0.y = cb0[0].x * r0.y;
  r0.w = 4 * r0.z;
  r0.w = r0.w * r0.w;
  r0.w = (1.0 / 6.0) * r0.w;
  r0.w = min(r0.w, r0.z);
  r2.xyz = t1.Sample(s1_s, float2(0,0)).yzw;
  r0.w = r2.y * r0.w;
  r0.y = r0.y * r2.x + r0.w;
  r2.y = r0.z * r2.z + r0.y;
  if (injectedData.toneMapType == 0.f) {
    r2.y = saturate(r2.y);
  }
  r0.y = mul(renodx::color::BT709_TO_XYZ_MAT[2].rgb, r1.xyz);
  r0.w = mul(renodx::color::BT709_TO_XYZ_MAT[0].rgb, r1.xyz);
  r1.x = r0.w + r0.z;
  r0.y = r1.x + r0.y;
  r0.xy = float2(-0.5,9.99999975e-06) + r0.xy;
  r0.z = r0.z / r0.y;
  r0.y = r0.w / r0.y;
  r0.w = 9.99999975e-06 + r0.z;
  r0.w = r2.y / r0.w;
  r1.x = 1 + -r0.y;
  r2.x = r0.y * r0.w;
  r0.y = r1.x + -r0.z;
  r2.z = r0.y * r0.w;
  r0.y = mul(renodx::color::XYZ_TO_BT709_MAT[0].rgb, r2.xyz);
  r1.x = renodx::math::SignSqrt(r0.y);
  r0.y = mul(renodx::color::XYZ_TO_BT709_MAT[1].rgb, r2.xyz);
  r0.z = mul(renodx::color::XYZ_TO_BT709_MAT[2].rgb, r2.xyz);
  r1.yz = renodx::math::SignSqrt(r0.yz);
  r1.rgb = lerp(preLA, r1.rgb, injectedData.fxLightAdaptation);
  o0.xyz = r0.xxx * (1.0 / 255.0) + r1.xyz;
  o0.rgb = renodx::color::bt709::clamp::BT2020(o0.rgb);
  return;
}