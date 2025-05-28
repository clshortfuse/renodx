#include "./shared.h"

Texture2D<float4> inputTex : register(t0);

cbuffer PerFrame : register(b0) {
  float4 postCombineParams1 : packoffset(c000.x);
};

SamplerState linearClampSampler : register(s0);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 UV : UV
) : SV_Target {
  float4 SV_Target;
  float4 _6 = inputTex.SampleLevel(linearClampSampler, float2(UV.x, UV.y), 0.0f);
  float _13 = 1.0f / postCombineParams1.y; // seems to stay at 1.f, so the shader essentially does nothing
  
  // kills wcg
  //float _14 = abs(_6.x);
  //float _15 = abs(_6.y);
  //float _16 = abs(_6.z);
  //float _17 = log2(_14);
  //float _18 = log2(_15);
  //float _19 = log2(_16);
  //float _20 = _17 * _13;
  //float _21 = _18 * _13;
  //float _22 = _19 * _13;
  //float _23 = exp2(_20);
  //float _24 = exp2(_21);
  //float _25 = exp2(_22);
  //SV_Target.x = _23;
  //SV_Target.y = _24;
  //SV_Target.z = _25;
  
  SV_Target.rgb = renodx::math::SignPow(_6.rgb, _13);
  
  SV_Target.w = _6.w;
  return SV_Target;
}
