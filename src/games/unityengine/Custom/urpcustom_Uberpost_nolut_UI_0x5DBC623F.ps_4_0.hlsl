#include "../tonemap.hlsl"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[124];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = 1 + -cb0[123].y;
  r0.y = v1.y * r0.x;
  r0.x = v1.x;
  r0.xyzw = t2.Sample(s2_s, r0.xy).xyzw;
  r1.xyzw = cmp(r0.zwzw >= float4(0.500999987,0.500999987,0.500999987,0.500999987));
  r1.xyzw = r1.xyzw ? float4(1,1,1,1) : 0;
  r2.xyzw = cmp(float4(0.497999996,0.497999996,0.497999996,0.497999996) >= r0.zwzw);
  r0.xyzw = r0.zwzw * float4(2,2,2,2) + float4(-1,-1,-1,-1);
  r2.xyzw = r2.xyzw ? float4(1,1,1,1) : 0;
  r1.xyzw = r2.xyzw + r1.xyzw;
  r0.xyzw = r1.xyzw * r0.xyzw;
  r0.xyzw = cb0[123].zzzz * r0.xyzw + v1.xyxy;
  r1.xyzw = float4(-1,-1,1,1) * cb0[113].xyxy;
  r2.x = 0.5 * cb0[112].x;
  r3.xyzw = r1.xyzy * r2.xxxx + r0.zwzw;
  r1.xyzw = r1.xwzw * r2.xxxx + r0.xyzw;
  r0.xyzw = t0.Sample(s0_s, r0.zw).xyzw;
  r2.xyzw = t1.Sample(s1_s, r3.xy).xyzw;
  r3.xyzw = t1.Sample(s1_s, r3.zw).xyzw;
  r2.xyz = r3.xyz + r2.xyz;
  r3.xyzw = t1.Sample(s1_s, r1.xy).xyzw;
  r1.xyzw = t1.Sample(s1_s, r1.zw).xyzw;
  r2.xyz = r3.xyz + r2.xyz;
  r1.xyz = r2.xyz + r1.xyz;
  r1.xyz = float3(0.25,0.25,0.25) * r1.xyz;
  if(injectedData.countOld < injectedData.countNew){
    r0.xyz = InvertToneMapScale(r0.xyz, true);
  } else {
    r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  }
  r0.xyz = r1.xyz * cb0[112].yyy * injectedData.fxBloom + r0.xyz;
  if (injectedData.tonemapCheck == 1.f && (injectedData.count2Old == injectedData.count2New)) {
    r0.xyz = applyUserNoTonemap(r0.xyz);
  }
  if (injectedData.countOld <= injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz, true);
  } else {
    r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}