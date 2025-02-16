#include "./common.hlsl"

Texture2D<float4> shScreenTex : register(t0);

Texture2D<float4> shScreenScaledTex : register(t1);

cbuffer PER_BATCH : register(b0, space2) {
  float PER_BATCH_000x : packoffset(c000.x);
  float PER_BATCH_000w : packoffset(c000.w);
};

cbuffer CBPerViewGlobal : register(b0, space1) {
  float CBPerViewGlobal_038z : packoffset(c038.z);
  float CBPerViewGlobal_038w : packoffset(c038.w);
};

SamplerState shLinearClampSampler : register(s3);

SamplerState shPointClampSampler : register(s2);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float4 TEXCOORD: TEXCOORD)
    : SV_Target {
  float4 SV_Target;
  float4 _9 = shScreenTex.SampleLevel(shPointClampSampler, float2((TEXCOORD.x), (TEXCOORD.y)), 0.0f);
  float4 _42 = shScreenScaledTex.SampleLevel(shLinearClampSampler, float2((TEXCOORD.x), (TEXCOORD.y)), 0.0f);
  return float4(_9.rgb, _42.a);

  float _12 = (TEXCOORD.x) + -0.5f;
  float _13 = (TEXCOORD.y) + -0.5f;
  float _16 = (PER_BATCH_000x) * 2.0f;
  float _20 = _16 * (CBPerViewGlobal_038z);
  float _21 = _16 * (CBPerViewGlobal_038w);
  float _22 = _20 + 1.0f;
  float _23 = _21 + 1.0f;
  float _24 = _22 * _12;
  float _25 = _23 * _13;
  float _26 = _24 + 0.5f;
  float _27 = _25 + 0.5f;
  float4 _28 = shScreenTex.SampleLevel(shPointClampSampler, float2(_26, _27), 0.0f);

  float _30 = 1.0f - _20;
  float _31 = 1.0f - _21;
  float _32 = _30 * _12;
  float _33 = _31 * _13;
  float _34 = _32 + 0.5f;
  float _35 = _33 + 0.5f;
  float4 _36 = shScreenTex.SampleLevel(shPointClampSampler, float2(_34, _35), 0.0f);

  float _38 = (_28.x) * (_28.x);
  float _39 = (_9.y) * (_9.y);
  float _40 = (_36.z) * (_36.z);
  float _41 = (_9.w) * (_9.w);
  _42 = shScreenScaledTex.SampleLevel(shLinearClampSampler, float2((TEXCOORD.x), (TEXCOORD.y)), 0.0f);
  // _42.rgb = _36.rgb;
  
  float _47 = (_42.x) ;
  float _48 = (_42.y) ;
  float _49 = (_42.z) ;
  float _50 = (_42.w) ;
  float _52 = _38 - _47;
  float _53 = _39 - _48;
  float _54 = _40 - _49;
  float _55 = _41 - _50;
  float _56 = _52 * (PER_BATCH_000w);
  float _57 = _53 * (PER_BATCH_000w);
  float _58 = _54 * (PER_BATCH_000w);
  float _59 = _55 * (PER_BATCH_000w);
  float _60 = _56 + _47;
  float _61 = _57 + _48;
  float _62 = _58 + _49;
  float _63 = _59 + _50;
  float _64 = renodx::math::SqrtSafe(_60);
  float _65 = renodx::math::SqrtSafe(_61);
  float _66 = renodx::math::SqrtSafe(_62);
  float _67 = renodx::math::SqrtSafe(_63);
  SV_Target.x = _64;
  SV_Target.y = _65;
  SV_Target.z = _66;
  SV_Target.w = _67;
  // SV_Target.rgb = renodx::color::srgb::Encode(SV_Target.rgb);
  return SV_Target;
}
