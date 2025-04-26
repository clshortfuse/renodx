#include "./shared.h"
cbuffer _13_15 : register(b1, space0) {
  float4 _15_m0[22] : packoffset(c0);
};

Texture2D<float4> _8 : register(t0, space0);

static float4 gl_FragCoord;
static float4 SV_Target;

struct SPIRV_Cross_Input {
  float4 gl_FragCoord : SV_Position;
};

struct SPIRV_Cross_Output {
  float4 SV_Target : SV_Target0;
};

void frag_main() {
  float4 _33 = _8.Load(int3(uint2(uint(int(gl_FragCoord.x)), uint(int(gl_FragCoord.y))), 0u));
  float _36 = _33.x;
  float _37 = _33.y;
  float _38 = _33.z;
  float _53, _62, _71, _77;
  float3 gamma_color = float3(_36, _37, _38);
  float3 linear_color;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    linear_color = renodx::color::srgb::Decode(max(0, gamma_color));
    _77 = _15_m0[18u].y * 2.f / 10000.f;
    _53 = linear_color.r, _62 = linear_color.g, _71 = linear_color.b;
  } else {
    if (RENODX_GAMMA_CORRECTION) {
      linear_color = renodx::color::gamma::DecodeSafe(gamma_color, 2.2f);
    } else {
      linear_color = renodx::color::srgb::DecodeSafe(gamma_color);
    }
    _77 = RENODX_DIFFUSE_WHITE_NITS / 10000.f;
    _53 = linear_color.r, _62 = linear_color.g, _71 = linear_color.b;
  }

  float _79 = _53;
  float _80 = _62;
  float _81 = _71;

  // ?
  float _86 = mad(0.0457799993455410003662109375f, _81, mad(0.31119000911712646484375f, _80, _79 * 0.643040001392364501953125f));
  float _92 = mad(0.009300000034272670745849609375f, _81, mad(0.93143999576568603515625f, _80, _79 * 0.0592699982225894927978515625f));
  float _98 = mad(0.930119991302490234375f, _81, mad(0.063919998705387115478515625f, _80, _79 * 0.0059600002132356166839599609375f));

  // ODT_SAT => XYZ => D60_2_D65 => BT.2020
  float _127 = mad(-0.001811660011298954486846923828125f, _98, mad(0.0251869000494480133056640625f, _92, _86 * 0.966957986354827880859375f));
  float _144 = mad(0.00182385998778045177459716796875f, _98, mad(0.9818990230560302734375f, _92, _86 * 0.01681750081479549407958984375f));
  float _157 = mad(0.94286501407623291015625f, _98, mad(0.0234305001795291900634765625f, _92, _86 * 0.0140284001827239990234375f));
  SV_Target = float4(renodx::color::pq::EncodeSafe(float3(_127, _144, _157) * _77), 1.f);
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  gl_FragCoord = stage_input.gl_FragCoord;
  gl_FragCoord.w = 1.0 / gl_FragCoord.w;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_Target = SV_Target;
  return stage_output;
}
