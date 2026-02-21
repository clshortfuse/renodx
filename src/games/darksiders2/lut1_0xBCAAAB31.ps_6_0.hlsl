#include "./common.hlsl"

Texture2D<float4> FrameBuffer : register(t0);

Texture2D<float4> DepthBuffer : register(t1);

Texture2D<float4> pBlurredFrameBuffer : register(t2);

Texture3D<float4> pCLUT : register(t3);

cbuffer $Globals : register(b0) {
  float4 pProjectionParams : packoffset(c000.x);
  float4 pBlurParams : packoffset(c001.x);
  float4 pCLUTParams : packoffset(c002.x);
};

SamplerState FrameBufferS : register(s0);

SamplerState DepthBufferS : register(s1);

SamplerState pBlurredFrameBufferS : register(s2);

SamplerState pCLUTS : register(s3);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _12 = DepthBuffer.Sample(DepthBufferS, float2(TEXCOORD.x, TEXCOORD.y));
  float _20 = ((_12.x * 0.99609375f) + (_12.y * 0.0038909912109375f)) + (_12.z * 1.519918441772461e-05f);
  float _42 = (saturate(pBlurParams.y * max(0.0f, (abs(((-0.0f - (pProjectionParams.y * pProjectionParams.z)) / (_20 - pProjectionParams.z)) - pProjectionParams.x) - pBlurParams.x))) * select((_20 > 0.9999899864196777f), 0.0f, 1.0f)) * pBlurParams.z;
  float4 _43 = FrameBuffer.Sample(FrameBufferS, float2(TEXCOORD.x, TEXCOORD.y));
  float4 _48 = pBlurredFrameBuffer.Sample(pBlurredFrameBufferS, float2(TEXCOORD.x, TEXCOORD.y));
  float _58 = ((_48.x - _43.x) * _42) + _43.x;
  float _59 = ((_48.y - _43.y) * _42) + _43.y;
  float _60 = ((_48.z - _43.z) * _42) + _43.z;

  // SV_Target.rgb = float3(_58, _59, _60);
  // SV_Target.w = _43.w;
  // return SV_Target;

  float3 ungraded = float3(_58, _59, _60);
  float scale = ComputeReinhardSmoothClampScale(ungraded);
  _58 *= scale;
  _59 *= scale;
  _60 *= scale;

  float4 _72 = pCLUT.Sample(pCLUTS, float3(((_58 * pCLUTParams.x) + pCLUTParams.y), ((_59 * pCLUTParams.x) + pCLUTParams.y), ((_60 * pCLUTParams.x) + pCLUTParams.y)));
  SV_Target.x = (lerp(_58, _72.x, pCLUTParams.z));
  SV_Target.y = (lerp(_59, _72.y, pCLUTParams.z));
  SV_Target.z = (lerp(_60, _72.z, pCLUTParams.z));

  SV_Target.rgb /= scale;
  SV_Target.rgb = lerp(ungraded, SV_Target.rgb, SCENE_GRADE_LUT_STRENGTH);
  SV_Target.w = _43.w;
  return SV_Target;
}
