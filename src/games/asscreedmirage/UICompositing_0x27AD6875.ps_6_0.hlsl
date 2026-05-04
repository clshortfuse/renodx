#include "./tonemap.hlsli"

Texture2D<float4> t0_space4 : register(t0, space4);

Texture2D<float4> t1_space4 : register(t1, space4);

Texture3D<float4> t3_space4 : register(t3, space4);

// clang-format off
cbuffer cb0_space4 : register(b0, space4) {
  struct UICompositingParameters__Constants {
    float UICompositingParameters__Constants_000;
    float UICompositingParameters__Constants_004;
    float UICompositingParameters__Constants_008;
    float UICompositingParameters__Constants_012;
  } UICompositingParameters_cbuffer_000: packoffset(c000.x);
};
// clang-format on

SamplerState s2_space98 : register(s2, space98);

SamplerState s0_space5 : register(s0, space5);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float2 TEXCOORD: TEXCOORD)
    : SV_Target {
  float4 SV_Target;
  float4 _9 = t0_space4.Sample(s2_space98, float2(TEXCOORD.x, TEXCOORD.y));
  float4 _14 = t1_space4.Sample(s2_space98, float2(TEXCOORD.x, TEXCOORD.y));

  // UICompositingParameters__Constants_012 = 400.f;

  float _19 = 1.0f - _9.w;
  float _26 = exp2(log2(abs(_14.x)) * 0.012683313339948654f);
  float _27 = _26 + -0.8359375f;
  float _37 = exp2(log2(abs(select((_27 < 0.0f), 0.0f, _27) / (18.8515625f - (_26 * 18.6875f)))) * 6.277394771575928f) * 10000.0f;
  float _41 = exp2(log2(abs(_14.y)) * 0.012683313339948654f);
  float _42 = _41 + -0.8359375f;
  float _52 = exp2(log2(abs(select((_42 < 0.0f), 0.0f, _42) / (18.8515625f - (_41 * 18.6875f)))) * 6.277394771575928f) * 10000.0f;
  float _56 = exp2(log2(abs(_14.z)) * 0.012683313339948654f);
  float _57 = _56 + -0.8359375f;
  float _67 = exp2(log2(abs(select((_57 < 0.0f), 0.0f, _57) / (18.8515625f - (_56 * 18.6875f)))) * 6.277394771575928f) * 10000.0f;

  float3 scene_linear;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    float UICompositingParameters__Constants_012 = UICompositingParameters_cbuffer_000.UICompositingParameters__Constants_012;
    float _68 = UICompositingParameters__Constants_012 * 0.10000002384185791f;
    float _22 = UICompositingParameters__Constants_012 * 0.8999999761581421f;
    scene_linear.r = (select((_37 < _22), _37, (UICompositingParameters__Constants_012 - (exp2(((_22 - _37) / _68) * 1.4426950216293335f) * _68))));
    scene_linear.g = (select((_52 < _22), _52, (UICompositingParameters__Constants_012 - (exp2(((_22 - _52) / _68) * 1.4426950216293335f) * _68))));
    scene_linear.b = (select((_67 < _22), _67, (UICompositingParameters__Constants_012 - (exp2(((_22 - _67) / _68) * 1.4426950216293335f) * _68))));
  } else {
    scene_linear = float3(_37, _52, _67);
    scene_linear = min(RENODX_PEAK_WHITE_NITS, scene_linear);
  }

  float _97 = pow(abs(scene_linear.r) * 9.999999747378752e-05f, 0.1593017578125f);
  float _110 = pow(abs(scene_linear.g) * 9.999999747378752e-05f, 0.1593017578125f);
  float _123 = pow(abs(scene_linear.b) * 9.999999747378752e-05f, 0.1593017578125f);

  float _133 = 1.0f / max(_9.w, 1.0000000116860974e-07f);
  float4 _146 = t3_space4.SampleLevel(s0_space5, float3(((saturate(_133 * _9.x) * 0.96875f) + 0.015625f), ((saturate(_133 * _9.y) * 0.96875f) + 0.015625f), ((saturate(_133 * _9.z) * 0.96875f) + 0.015625f)), 0.0f);
  float _164 = exp2(log2(abs((_146.x * _9.w) + (exp2(log2(((_97 * 18.8515625f) + 0.8359375f) / ((_97 * 18.6875f) + 1.0f)) * 78.84375f) * _19))) * 0.012683313339948654f);
  float _165 = _164 + -0.8359375f;
  float _174 = exp2(log2(abs(select((_165 < 0.0f), 0.0f, _165) / (18.8515625f - (_164 * 18.6875f)))) * 6.277394771575928f);
  float _178 = exp2(log2(abs((_146.y * _9.w) + (exp2(log2(((_110 * 18.8515625f) + 0.8359375f) / ((_110 * 18.6875f) + 1.0f)) * 78.84375f) * _19))) * 0.012683313339948654f);
  float _179 = _178 + -0.8359375f;
  float _189 = exp2(log2(abs(select((_179 < 0.0f), 0.0f, _179) / (18.8515625f - (_178 * 18.6875f)))) * 6.277394771575928f) * 10000.0f;
  float _193 = exp2(log2(abs((_146.z * _9.w) + (exp2(log2(((_123 * 18.8515625f) + 0.8359375f) / ((_123 * 18.6875f) + 1.0f)) * 78.84375f) * _19))) * 0.012683313339948654f);
  float _194 = _193 + -0.8359375f;
  float _204 = exp2(log2(abs(select((_194 < 0.0f), 0.0f, _194) / (18.8515625f - (_193 * 18.6875f)))) * 6.277394771575928f) * 10000.0f;
  float _207 = mad(_204, 0.16888095438480377f, mad(_189, 0.14461688697338104f, (_174 * 6369.58203125f)));
  float _210 = mad(_204, 0.0593017116189003f, mad(_189, 0.6779980063438416f, (_174 * 2627.002685546875f)));
  float _212 = mad(_204, 1.0609849691390991f, mad(_189, 0.02807268314063549f, 0.0f));
  SV_Target.x = (mad(_212, -0.4986107349395752f, mad(_210, -1.5373830795288086f, (_207 * 3.240969657897949f))) * 0.012500000186264515f);
  SV_Target.y = (mad(_212, 0.04155506193637848f, mad(_210, 1.8759671449661255f, (_207 * -0.9692435264587402f))) * 0.012500000186264515f);
  SV_Target.z = (mad(_212, 1.056971788406372f, mad(_210, -0.20397689938545227f, (_207 * 0.05563005432486534f))) * 0.012500000186264515f);
  SV_Target.w = ((_14.w * _19) + _9.w);
  return SV_Target;
}
