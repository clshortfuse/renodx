#include "./common.hlsl"

Texture2D<float4> uComposite : register(t16);
Texture2D<float4> uBloom : register(t17);
Texture2D<float4> uExposure : register(t18);
cbuffer PostUpdatableBuffer : register(b3) {
  float4 mubColorBalance : packoffset(c000.x);
  float4 mubPostParams : packoffset(c001.x);
};
SamplerState MinMagMipLinearWrapEdge : register(s5);
SamplerState MinMagMipNearestWrapEdge : register(s7);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _13 = applySharpen(uComposite, MinMagMipLinearWrapEdge, TEXCOORD, injectedData.fxSharpen);
  float4 _17 = uBloom.Sample(MinMagMipLinearWrapEdge, float2(TEXCOORD.x, TEXCOORD.y));
  float _21 = _17.x * mubPostParams.z * injectedData.fxBloom;
  float _22 = _17.y * mubPostParams.z * injectedData.fxBloom;
  float _23 = _17.z * mubPostParams.z * injectedData.fxBloom;
  float _24 = _21 + _13.x;
  float _25 = _22 + _13.y;
  float _26 = _23 + _13.z;
  float4 _27 = uExposure.Sample(MinMagMipNearestWrapEdge, float2(0.5f, 0.5f));
  float _29 = max(_27.x, 0.0010000000474974513f);
  float _30 = min(_29, 100.0f);
  float _31 = _30 * _24;
  float _32 = _30 * _25;
  float _33 = _30 * _26;
  float _34 = _31 * 0.30000001192092896f;
  float _35 = _32 * 0.5f;
  float _36 = _34 + _35;
  float _37 = _33 * 0.20000000298023224f;
  float _38 = _36 + _37;
  float _39 = _31 - _38;
  float _40 = _32 - _38;
  float _41 = _33 - _38;
  float _42 = _39 * mubPostParams.y;
  float _43 = _40 * mubPostParams.y;
  float _44 = _41 * mubPostParams.y;
  float _45 = _42 + _38;
  float _46 = _43 + _38;
  float _47 = _44 + _38;
  float _52 = mubColorBalance.x;
  float _53 = _52 * _45;
  float _54 = mubColorBalance.y;
  float _55 = _54 * _46;
  float _56 = mubColorBalance.z;
  float _57 = _56 * _47;
  float3 untonemapped = lerp(float3(_31,_32,_33), float3(_53,_55,_57), injectedData.colorGradeFilter);
  float3 vignetted = applyVignette(untonemapped, TEXCOORD, injectedData.fxVignette);
  float3 output = applyUserTonemap(vignetted);
    if (injectedData.fxFilmGrain > 0.f) {
      output = applyFilmGrain(output, TEXCOORD, injectedData.fxFilmGrainType != 0.f);
    }
  output = PostToneMapScale(output);
  SV_Target.x = output.r;
  SV_Target.y = output.g;
  SV_Target.z = output.b;
  SV_Target.w = 1.0f;
  return SV_Target;
}
