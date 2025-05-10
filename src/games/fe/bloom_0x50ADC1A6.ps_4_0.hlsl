#include "./common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[8];
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

  r0.xw = float2(1,0);
  r0.z = cb0[6].w;
  r0.xyzw = cb0[2].xyxy * r0.xxzw;
  r1.x = cb0[6].w;
  r2.xyzw = -r0.xywy * r1.xxxx + v1.xyxy;
  r3.xyzw = t1.Sample(s0_s, r2.xy).xyzw;
  r2.xyzw = t1.Sample(s0_s, r2.zw).xyzw;
  r2.xyz = r2.xyz * float3(2,2,2) + r3.xyz;
  r1.z = -1;
  r1.yw = -r0.zy * r1.zx + v1.xy;
  r3.xyzw = t1.Sample(s0_s, r1.yw).xyzw;
  r2.xyz = r3.xyz + r2.xyz;
  r3.xyzw = r0.zwxw * r1.zxxx + v1.xyxy;
  r4.xyzw = r0.zywy * r1.zxxx + v1.xyxy;
  r0.xy = r0.xy * r1.xx + v1.xy;
  r0.xyzw = t1.Sample(s0_s, r0.xy).xyzw;
  r1.xyzw = t1.Sample(s0_s, r3.xy).xyzw;
  r3.xyzw = t1.Sample(s0_s, r3.zw).xyzw;
  r1.xyz = r1.xyz * float3(2,2,2) + r2.xyz;
  r2.xyzw = t1.Sample(s0_s, v1.xy).xyzw;
  r1.xyz = r2.xyz * float3(4,4,4) + r1.xyz;
  r1.xyz = r3.xyz * float3(2,2,2) + r1.xyz;
  r2.xyzw = t1.Sample(s0_s, r4.xy).xyzw;
  r3.xyzw = t1.Sample(s0_s, r4.zw).xyzw;
  r1.xyz = r2.xyz + r1.xyz;
  r1.xyz = r3.xyz * float3(2,2,2) + r1.xyz;
  r0.xyz = r1.xyz + r0.xyz;
  r0.xyz = cb0[7].xxx * r0.xyz * injectedData.fxBloom;
  r0.xyz = float3(0.0625,0.0625,0.0625) * r0.xyz;
  r1.xyzw = t0.Sample(s1_s, w1.xy).xyzw;
  r1.rgb = renodx::color::srgb::DecodeSafe(r1.rgb);
  r0.rgb = r1.rgb + r0.rgb;
  if (injectedData.fxFilmGrain > 0.f) {
    r0.rgb = applyFilmGrain(r0.rgb, w1, injectedData.fxFilmGrainType != 0.f);
  }
  o0.w = r1.w;
  o0.rgb = PostToneMapScale(r0.rgb);
  return;
}