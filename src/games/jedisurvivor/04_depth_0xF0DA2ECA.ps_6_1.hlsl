cbuffer _14_16 : register(b0, space0) {
  float4 _16_m0[45] : packoffset(c0);
};

cbuffer _19_21 : register(b1, space0) {
  float4 _21_m0[235] : packoffset(c0);
};

cbuffer _24_26 : register(b2, space0) {
  float4 _26_m0[4] : packoffset(c0);
};

Texture2D<float4> _8 : register(t0, space0);  // depth
Texture2D<float4> _9 : register(t1, space0);  // render
SamplerState _29 : register(s0, space0);
SamplerState _30 : register(s1, space0);

static float4 gl_FragCoord;
static float4 TEXCOORD;
static float4 SV_Target;

struct SPIRV_Cross_Input {
  float4 gl_FragCoord : SV_Position;
  float4 TEXCOORD : TEXCOORD0;
};

struct SPIRV_Cross_Output {
  float4 SV_Target : SV_Target0;
};

void frag_main() {
  uint4 _52 = asuint(_16_m0[37u]);
  float _60 = (gl_FragCoord.y - float(_52.y)) * _16_m0[38u].w;
  float _65 = (gl_FragCoord.x - float(_52.x)) * _16_m0[38u].z;
  float4 _90 = _8.SampleLevel(_29, float2(((_65 * _21_m0[130u].x) + _21_m0[129u].x) * _21_m0[132u].z, ((_60 * _21_m0[130u].y) + _21_m0[129u].y) * _21_m0[132u].w), 0.0f);
  float _93 = _90.x;
  float _107 = ((_21_m0[65u].x * _93) + _21_m0[65u].y) + (1.0f / ((_21_m0[65u].z * _93) - _21_m0[65u].w));
  float _113 = _107 - _26_m0[2u].y;
  float _115 = (_113 + _26_m0[2u].z) / _26_m0[2u].z;
  float _129 = 1.0f - (_26_m0[2u].y / _26_m0[2u].x);
  float _144 = clamp((((_129 <= 0.0f) ? 0.0f : exp2(log2(_129) * 0.5f)) * ((((1.0f - _115) - clamp(_113 / _26_m0[2u].w, 0.0f, 1.0f)) * ((_107 < _26_m0[2u].y) ? 0.0f : 1.0f)) + _115)) * clamp(_26_m0[2u].y / _26_m0[3u].x, 0.0f, 1.0f), 0.0f, 1.0f);
  float _147 = clamp(1.7999999523162841796875f - _144, 0.0f, 1.0f);
  float4 _162 = _9.Sample(_30, float2((_65 * _16_m0[5u].x) + _16_m0[4u].x, (_60 * _16_m0[5u].y) + _16_m0[4u].y));
  float _167 = _162.x * _147;
  float _181 = clamp(cos(((_60 * _26_m0[3u].y) + _21_m0[143u].z) * 6.283185482025146484375f), 0.0f, 1.0f) + 1.0f;
  float _188 = ((_144 * 0.60000002384185791015625f) * _181) + (_162.y * _147);
  float _189 = ((_144 * 0.699999988079071044921875f) * _181) + (_162.z * _147);
  SV_Target.x = max(((_26_m0[1u].x - _167) * _26_m0[3u].z) + _167, 0.0f);
  SV_Target.y = max(((_26_m0[1u].y - _188) * _26_m0[3u].z) + _188, 0.0f);
  SV_Target.z = max(((_26_m0[1u].z - _189) * _26_m0[3u].z) + _189, 0.0f);
  SV_Target.w = 1.0f;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  gl_FragCoord = stage_input.gl_FragCoord;
  gl_FragCoord.w = 1.0 / gl_FragCoord.w;
  TEXCOORD = stage_input.TEXCOORD;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_Target = SV_Target;
  return stage_output;
}
