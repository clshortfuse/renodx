// #include "../shared.h"

#define CUSTOM_FILM_GRAIN 0
#define CUSTOM_RANDOM 0

Texture2D<float4> t0_space4 : register(t0, space4);

cbuffer cb0 : register(b0) {
  struct PushConstantWrapper_FilmGrain {
    int PushConstantWrapper_FilmGrain_000;
    int PushConstantWrapper_FilmGrain_004;
    int PushConstantWrapper_FilmGrain_008;
    int PushConstantWrapper_FilmGrain_012;
  } stub_PushConstantWrapper_FilmGrain_000 : packoffset(c000.x);
};

SamplerState s0_space4 : register(s0, space4);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float4 TEXCOORD: TEXCOORD) : SV_Target {
  float4 SV_Target;
  float4 _33 = t0_space4.Sample(s0_space4, float2(TEXCOORD.x, TEXCOORD.y));
  float _41 = (((frac(sin(((float((int)(int(asfloat(stub_PushConstantWrapper_FilmGrain_000.PushConstantWrapper_FilmGrain_000)) & 1023)) * 0.0009775171056389809f) + TEXCOORD.x) + (((float((int)(int(asfloat(stub_PushConstantWrapper_FilmGrain_000.PushConstantWrapper_FilmGrain_004)) & 1023)) * 0.0009775171056389809f) + TEXCOORD.y) * 521.0f)) * 493013.0f) * 2.0f) + -1.0f) * asfloat(stub_PushConstantWrapper_FilmGrain_000.PushConstantWrapper_FilmGrain_008)) * saturate(1.0f - dot(float3(_33.x, _33.y, _33.z), float3(0.21250000596046448f, 0.715399980545044f, 0.07209999859333038f)));
  // SV_Target.x = saturate(_41 + _33.x);
  // SV_Target.y = saturate(_41 + _33.y);
  // SV_Target.z = saturate(_41 + _33.z);

  SV_Target.rgb = _41 + _33.rgb;

  SV_Target.w = 1.0f;

  // if (CUSTOM_FILM_GRAIN) {
  //   float3 outputColor = _33.rgb;
  //   outputColor = renodx::draw::InvertIntermediatePass(outputColor);
  //   outputColor = renodx::effects::ApplyFilmGrain(
  //       outputColor,
  //       TEXCOORD.xy,
  //       CUSTOM_RANDOM,
  //       stub_PushConstantWrapper_FilmGrain_000.PushConstantWrapper_FilmGrain_000 != 0.f ? CUSTOM_FILM_GRAIN * 0.03f : 0,
  //       1.f);

  //   // outputColor = renodx::draw::RenderIntermediatePass(outputColor);
  //   SV_Target.rgb = outputColor;
  // }
  SV_Target.rgb = 2.f;

  return SV_Target;
}
