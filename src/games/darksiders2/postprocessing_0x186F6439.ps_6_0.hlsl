#include "common.hlsl"

Texture2D<float4> pRenderTarget : register(t0);

Texture2D<float4> pDistortTexture : register(t1);

cbuffer $Globals : register(b0) {
  float pAlpha : packoffset(c000.x);
};

cbuffer cbPsPerFrame : register(b4) {
  float4 gFrameDimensions : packoffset(c000.x);
  float4 gTime : packoffset(c001.x);
  float3 gCameraPos : packoffset(c002.x);
  float4 gView[4] : packoffset(c003.x);
  float4 gProj[4] : packoffset(c007.x);
  float4 gInvProj[4] : packoffset(c011.x);
  float4 gViewProj[4] : packoffset(c015.x);
  float4 gInvViewProj[4] : packoffset(c019.x);
  float4 gDepthRange : packoffset(c023.x);
  int gDoSSAO : packoffset(c024.x);
};

SamplerState pRenderTargetS : register(s0);

SamplerState pDistortTextureS : register(s1);

SamplerState pPointClampSampler : register(s2);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _13 = pDistortTexture.Sample(pDistortTextureS, float2(TEXCOORD.x, TEXCOORD.y));
  float _18 = (_13.x * gFrameDimensions.z) + TEXCOORD.x;
  float _19 = (_13.y * gFrameDimensions.w) + TEXCOORD.y;
  float4 _20 = pDistortTexture.Sample(pPointClampSampler, float2(_18, _19));
  float _23 = saturate(_20.x * 1e+06f);
  float _27 = (_23 * _23) * (3.0f - (_23 * 2.0f));
  float4 _34 = pRenderTarget.Sample(pRenderTargetS, float2(((_27 * (_18 - TEXCOORD.x)) + TEXCOORD.x), ((_27 * (_19 - TEXCOORD.y)) + TEXCOORD.y)));
  SV_Target.x = _34.x;
  SV_Target.y = _34.y;
  SV_Target.z = _34.z;

  SV_Target.rgb = CustomDisplayMap(SV_Target.rgb, TEXCOORD, pRenderTarget, pRenderTargetS);

  SV_Target.w = pAlpha;
  return SV_Target;
}
