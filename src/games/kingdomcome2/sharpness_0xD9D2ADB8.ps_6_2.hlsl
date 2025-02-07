#include "./shared.h"

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
  noperspective float4 SV_Position : SV_Position,
  linear float4 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _9 = shScreenTex.SampleLevel(shPointClampSampler, float2((TEXCOORD.x), (TEXCOORD.y)), 0.0f);
  float _12 = (TEXCOORD.x) + -0.5f;
  float _13 = (TEXCOORD.y) + -0.5f;
  float _16 = (PER_BATCH_000x) * 2.0f;
  float _20 = _16 * (CBPerViewGlobal_038z);
  float _21 = _16 * (CBPerViewGlobal_038w);
  float4 _42 = shScreenScaledTex.SampleLevel(shLinearClampSampler, float2((TEXCOORD.x), (TEXCOORD.y)), 0.0f);
  float _47 = (_42.x) * (_42.x);
  float _48 = (_42.y) * (_42.y);
  float _49 = (_42.z) * (_42.z);
  float _50 = (_42.w) * (_42.w);
  SV_Target.x = (renodx::math::SqrtSafe((((((((float4)(shScreenTex.SampleLevel(shPointClampSampler, float2((((_20 + 1.0f) * _12) + 0.5f), (((_21 + 1.0f) * _13) + 0.5f)), 0.0f))).x) * (((float4)(shScreenTex.SampleLevel(shPointClampSampler, float2((((_20 + 1.0f) * _12) + 0.5f), (((_21 + 1.0f) * _13) + 0.5f)), 0.0f))).x)) - _47) * (PER_BATCH_000w)) + _47)));
  SV_Target.y = (renodx::math::SqrtSafe((((((_9.y) * (_9.y)) - _48) * (PER_BATCH_000w)) + _48)));
  SV_Target.z = (renodx::math::SqrtSafe((((((((float4)(shScreenTex.SampleLevel(shPointClampSampler, float2((((1.0f - _20) * _12) + 0.5f), (((1.0f - _21) * _13) + 0.5f)), 0.0f))).z) * (((float4)(shScreenTex.SampleLevel(shPointClampSampler, float2((((1.0f - _20) * _12) + 0.5f), (((1.0f - _21) * _13) + 0.5f)), 0.0f))).z)) - _49) * (PER_BATCH_000w)) + _49)));
  SV_Target.w = (renodx::math::SqrtSafe((((((_9.w) * (_9.w)) - _50) * (PER_BATCH_000w)) + _50)));
  return SV_Target;
}
