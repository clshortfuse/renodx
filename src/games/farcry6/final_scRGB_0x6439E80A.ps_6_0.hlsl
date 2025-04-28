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
  float _53;
  float3 gamma_color = float3(_36, _37, _38);
  float3 linear_color;
  float game_brightness;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    linear_color = renodx::color::srgb::Decode(max(0, gamma_color));
    game_brightness = _15_m0[18u].y * 2.f / 80.f;
  } else {
    if (RENODX_GAMMA_CORRECTION) {
      linear_color = renodx::color::gamma::DecodeSafe(gamma_color, 2.2f);
    } else {
      linear_color = renodx::color::srgb::DecodeSafe(gamma_color);
    }
    game_brightness = RENODX_DIFFUSE_WHITE_NITS / 80.f;
  }
  SV_Target.rgb = linear_color.rgb * game_brightness;
  SV_Target.w = 1.0f;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  gl_FragCoord = stage_input.gl_FragCoord;
  gl_FragCoord.w = 1.0 / gl_FragCoord.w;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_Target = SV_Target;
  return stage_output;
}
