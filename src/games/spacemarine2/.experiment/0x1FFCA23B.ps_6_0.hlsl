static const float _33[32] = { -1.5f, -1.5f, -1.5f, -0.5f, -1.5f, 0.5f,  -1.5f,
                               1.5f,  -0.5f, -1.5f, -0.5f, -0.5f, -0.5f, 0.5f,
                               -0.5f, 1.5f,  0.5f,  -1.5f, 0.5f,  -0.5f, 0.5f,
                               0.5f,  0.5f,  1.5f,  1.5f,  -1.5f, 1.5f,  -0.5f,
                               1.5f,  0.5f,  1.5f,  1.5f };

cbuffer CB_PASS_HDRUBO : register(b4, space0) {
  float4 CB_PASS_HDR_m0[12] : packoffset(c0);
};

Texture2D<float4> HDR_TEX1 : register(t0, space2);
SamplerState PS_SAMPLERS[12] : register(s0, space1);

static float2 TEXCOORD;
static float4 SV_Target;

struct SPIRV_Cross_Input {
  float2 TEXCOORD : TEXCOORD1;
};

struct SPIRV_Cross_Output {
  float4 SV_Target : SV_Target0;
};

void frag_main() {
  float _48;
  uint _51;
  _48 = 0.0f;
  _51 = 0u;
  float _50;
  for (;;) {
    float4 _74 = HDR_TEX1.Sample(
        PS_SAMPLERS[4u],
        float2((CB_PASS_HDR_m0[2u].x * _33[0u + (_51 * 2u)]) + TEXCOORD.x,
               (CB_PASS_HDR_m0[2u].y * _33[1u + (_51 * 2u)]) + TEXCOORD.y));
    _50 = (log2(dot(float3(min(max(_74.x, 0.0f), 64512.0f),
                           min(max(_74.y, 0.0f), 64512.0f),
                           min(max(_74.z, 0.0f), 64512.0f)),
                    float3(0.21267099678516387939453125f,
                           0.71516001224517822265625f,
                           0.072168998420238494873046875f)) +
                1.0f) *
           0.693147182464599609375f) +
          _48;
    uint _52 = _51 + 1u;
    if (_52 == 16u) {
      break;
    } else {
      _48 = _50;
      _51 = _52;
    }
  }
  SV_Target.x = _50 * 0.0625f;
  SV_Target.y = 0.0f;
  SV_Target.z = 0.0f;
  SV_Target.w = 0.0f;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  TEXCOORD = stage_input.TEXCOORD;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_Target = SV_Target;
  return stage_output;
}
