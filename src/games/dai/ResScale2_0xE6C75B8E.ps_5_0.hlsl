#include "./common.hlsl"

cbuffer _Globals : register(b0){
  float2 invPixelSize : packoffset(c0);
  float4 mainTextureDimensions : packoffset(c1);
}
SamplerState mainTextureSampler_s : register(s0);
SamplerState mainTexture2Sampler_s : register(s1);
Texture2D<float4> mainTexture : register(t0);
Texture1D<float4> mainTexture2 : register(t1);

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = 1 / mainTextureDimensions.y;
  r0.y = -r0.x * 0.5 + v1.y;
  r0.z = mainTextureDimensions.y * r0.y;
  r0.z = frac(r0.z);
  r0.w = -0.5 + -r0.z;
  r1.xyzw = mainTexture2.Sample(mainTexture2Sampler_s, r0.z).xyzw;
  r1.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + r1.xyzw;
  r1.xyzw = r1.xyzw + r1.xyzw;
  r2.y = r0.w * r0.x + r0.y;
  r2.w = r2.y + r0.x;
  r2.xz = v1.xx;
  r0.yzw = mainTexture.Sample(mainTextureSampler_s, r2.zw).xyz;
  r2.xzw = mainTexture.Sample(mainTextureSampler_s, r2.xy).xyz;
  r3.x = dot(r1.xyzw, float4(1,1,1,1));
  r1.xyzw = r1.xyzw / r3.xxxx;
  r0.yzw = r1.yyy * r0.yzw;
  r0.yzw = r1.xxx * r2.xzw + r0.yzw;
  r3.y = r0.x * 2 + r2.y;
  r3.w = r0.x * 3 + r2.y;
  r3.xz = v1.xx;
  r2.xyz = mainTexture.Sample(mainTextureSampler_s, r3.xy).xyz;
  r3.xyz = mainTexture.Sample(mainTextureSampler_s, r3.zw).xyz;
  r0.xyz = r1.zzz * r2.xyz + r0.yzw;
  o0.xyz = r1.www * r3.xyz + r0.xyz;
  o0.w = 1;
  o0.rgb = renodx::color::srgb::DecodeSafe(o0.rgb);
  if (injectedData.fxFilmGrain > 0.f) {
    o0.rgb = applyFilmGrain(o0.rgb, v1, injectedData.fxFilmGrainType != 0.f);
  }
  o0.rgb = PostToneMapScale(o0.rgb);
  return;
}