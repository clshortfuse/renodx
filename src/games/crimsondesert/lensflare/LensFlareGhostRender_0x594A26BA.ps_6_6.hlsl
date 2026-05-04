Texture2D<float3> __3__36__0__0__g_sceneColor : register(t15, space36);

cbuffer __3__1__0__0__GlobalPushConstants : register(b0, space1) {
  float4 _textureSizeAndInvSize : packoffset(c000.x);
  float4 _ghostsParams : packoffset(c001.x);
  float4 _ghostsMultiplyColor : packoffset(c002.x);
  float4 _haloParams : packoffset(c003.x);
  float4 _glareBladeParams : packoffset(c004.x);
  uint2 _tileXY : packoffset(c005.x);
  float2 _bufferRatio : packoffset(c005.z);
  float _lensFlareColorScale : packoffset(c006.x);
};

SamplerState __0__4__0__0__g_staticBilinearClamp : register(s3, space4);

static const float _global_0[8] = { -1.5f, 2.5f, -5.0f, 10.0f, 0.699999988079071f, -0.4000000059604645f, -0.20000000298023224f, 0.5f };
static const float _global_1[32] = { 1.0f, 0.800000011920929f, 0.4000000059604645f, 1.0f, 1.0f, 1.0f, 0.6000000238418579f, 1.0f, 0.800000011920929f, 0.800000011920929f, 1.0f, 1.0f, 0.5f, 1.0f, 0.4000000059604645f, 1.0f, 0.5f, 0.800000011920929f, 1.0f, 1.0f, 0.8999999761581421f, 1.0f, 0.800000011920929f, 1.0f, 1.0f, 0.800000011920929f, 0.4000000059604645f, 1.0f, 0.8999999761581421f, 0.699999988079071f, 0.699999988079071f, 1.0f };

float3 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float3 SV_Target;
  int __loop_jump_target = -1;
  float _14;
  float _15;
  float _16;
  int _17;
  float _94;
  float _95;
  float _96;
  _14 = 0.0f;
  _15 = 0.0f;
  _16 = 0.0f;
  _17 = 0;
  while(true) {
    float _21 = _global_1[((int)(3u + (_17 * 4)))];
    float _23 = _global_0[_17];
    if (abs(_23 * _21) > 9.999999747378752e-05f) {
      float _32 = _ghostsParams.y * _23;
      float _33 = _32 * (TEXCOORD.x + -0.5f);
      float _34 = _32 * (TEXCOORD.y + -0.5f);
      float _38 = sqrt((_33 * _33) + (_34 * _34));
      float _41 = saturate((0.5f - _38) * 2.500000238418579f);
      float _48 = saturate((0.25f - _38) * 4.0f);
      float3 _59 = __3__36__0__0__g_sceneColor.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2((_33 + 0.5f), (_34 + 0.5f)), 0.0f);
      float _80 = (((_41 * _41) * (3.0f - (_41 * 2.0f))) * ((((_48 * _48) * 0.949999988079071f) * (3.0f - (_48 * 2.0f))) + 0.05000000074505806f)) * _21;
      _94 = ((((_80 * _59.x) * _ghostsMultiplyColor.x) * (_global_1[((int)(0u + (_17 * 4)))])) + _14);
      _95 = ((((_80 * _59.y) * _ghostsMultiplyColor.y) * (_global_1[((int)(1u + (_17 * 4)))])) + _15);
      _96 = ((((_80 * _59.z) * _ghostsMultiplyColor.z) * (_global_1[((int)(2u + (_17 * 4)))])) + _16);
    } else {
      _94 = _14;
      _95 = _15;
      _96 = _16;
    }
    int _97 = _17 + 1;
    if (!(_97 == 8)) {
      _14 = _94;
      _15 = _95;
      _16 = _96;
      _17 = _97;
      continue;
    }
    SV_Target.x = (_ghostsParams.x * _94);
    SV_Target.y = (_ghostsParams.x * _95);
    SV_Target.z = (_ghostsParams.x * _96);
    break;
  }
  return SV_Target;
}
