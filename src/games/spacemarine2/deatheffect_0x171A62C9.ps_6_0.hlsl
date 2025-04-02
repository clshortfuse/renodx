#include "./shared.h"

Texture2D<float4> SCREEN_FX_BACKBUFFER : register(t0, space2);

Texture2D<float4> SCREEN_FX_BLURRED_BB : register(t1, space2);

cbuffer CB_PASS_SCREEN_EFFECT : register(b4) {
  float4 SCREEN_FX_BASE_PARAMS[1] : packoffset(c000.x);
  float4 SCREEN_FX_SKY_CAM_VEC_0[1] : packoffset(c001.x);
  float4 SCREEN_FX_SKY_CAM_VEC_X[1] : packoffset(c002.x);
  float4 SCREEN_FX_SKY_CAM_VEC_Y[1] : packoffset(c003.x);
  float4 SCREEN_FX_PARAMS_0[1] : packoffset(c004.x);
  float4 SCREEN_FX_PARAMS_1[1] : packoffset(c005.x);
  float4 SCREEN_FX_PARAMS_2[1] : packoffset(c006.x);
  float4 SCREEN_FX_PARAMS_3[1] : packoffset(c007.x);
  float4 SCREEN_FX_PARAMS_4[1] : packoffset(c008.x);
  float4 SCREEN_FX_PARAMS_5[1] : packoffset(c009.x);
  float4 SCREEN_FX_PARAMS_6[1] : packoffset(c010.x);
  float4 SCREEN_FX_PARAMS_7[1] : packoffset(c011.x);
  float4 SCREEN_FX_COLOR_0[1] : packoffset(c012.x);
  float4 SCREEN_FX_COLOR_1[1] : packoffset(c013.x);
  float4 SCREEN_FX_COLOR_2[1] : packoffset(c014.x);
  float4 SCREEN_FX_COLOR_3[1] : packoffset(c015.x);
  float4 SCREEN_FX_CUSTOM_PARAMS[32] : packoffset(c016.x);
};

SamplerState PS_SAMPLERS[12] : register(s0, space1);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float _10 = (SCREEN_FX_PARAMS_0[0].x) * (SCREEN_FX_BASE_PARAMS[0].x);
  float _11 = mad(TEXCOORD.x, 2.0f, -1.0f);
  float _12 = mad(TEXCOORD.y, 2.0f, -1.0f);
  float4 _18 = SCREEN_FX_BACKBUFFER.Sample(PS_SAMPLERS[1u], float2(TEXCOORD.x, TEXCOORD.y));
  float4 _22 = SCREEN_FX_BLURRED_BB.Sample(PS_SAMPLERS[1u], float2(TEXCOORD.x, TEXCOORD.y));
  float _32 = saturate((renodx::math::SqrtSafe((_12 * _12) + (_11 * _11)) - (SCREEN_FX_PARAMS_0[0].z)) / ((SCREEN_FX_PARAMS_0[0].w) - (SCREEN_FX_PARAMS_0[0].z)));
  float _36 = (_32 * _32) * (3.0f - (_32 * 2.0f));
  float _40 = ((SCREEN_FX_PARAMS_1[0].y) * _10) * _36;
  float _47 = (_40 * (_22.x - _18.x)) + _18.x;
  float _48 = (_40 * (_22.y - _18.y)) + _18.y;
  float _49 = (_40 * (_22.z - _18.z)) + _18.z;
  float _51 = (SCREEN_FX_PARAMS_0[0].y) * _10;
  float _52 = dot(float3(_47, _48, _49), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
  float _61 = (_36 * _10) * (SCREEN_FX_PARAMS_1[0].x);
  SV_Target.x = saturate((_47 - _61) + ((_52 - _47) * _51));
  SV_Target.y = saturate((_48 - _61) + ((_52 - _48) * _51));
  SV_Target.z = saturate((_49 - _61) + ((_52 - _49) * _51));

  SV_Target.rgb = renodx::draw::UpgradeToneMapByLuminance(_18.rgb, saturate(_18.rgb), SV_Target.rgb, 1.f);
  // SV_Target.rgb = _18.rgb;
  SV_Target.w = 1.0f;
  return SV_Target;
}
