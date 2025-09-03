#include "../common.hlsli"

cbuffer CB0_buf : register(b0, space8) {
  float4 CB0_m : packoffset(c0);
};

Texture2D<float4> T0 : register(t0, space8);

static float4 gl_FragCoord;
static float2 TEXCOORD;
static float4 SV_TARGET;

struct SPIRV_Cross_Input {
  float4 gl_FragCoord : SV_Position;
  float2 TEXCOORD : TEXCOORD;
};

struct SPIRV_Cross_Output {
  float4 SV_TARGET : SV_Target0;
};

uint cvt_f32_u32(float v) {
  return (v > 4294967040.0f) ? 4294967295u : uint(max(v, 0.0f));
}

int cvt_f32_i32(float v) {
  return isnan(v) ? 0 : ((v < (-2147483648.0f)) ? int(0x80000000) : ((v > 2147483520.0f) ? 2147483647 : int(v)));
}

float dp3_f32(float3 a, float3 b) {
  precise float _59 = a.x * b.x;
  return mad(a.z, b.z, mad(a.y, b.y, _59));
}

void frag_main() {
  float4 _100 = T0.Load(int3(uint2(cvt_f32_u32(gl_FragCoord.x), cvt_f32_u32(gl_FragCoord.y)), 0u));
  float _101 = _100.x;
  float _102 = _100.y;
  float _103 = _100.z;
  uint _110 = uint(cvt_f32_i32(CB0_m.w));
  float _188;
  float _189;
  float _190;
  if (_110 == 1u) {
    float _120 = log2(_101) * CB0_m.x;
    float _121 = CB0_m.x * log2(_102);
    float _122 = CB0_m.x * log2(_103);
    float _123 = exp2(_120);
    float _124 = exp2(_121);
    float _125 = exp2(_122);
    _188 = (_125 < 0.00310000008903443813323974609375f) ? (_125 * 12.9200000762939453125f) : mad(exp2(_122 * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
    _189 = (_124 < 0.00310000008903443813323974609375f) ? (_124 * 12.9200000762939453125f) : mad(exp2(_121 * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
    _190 = (_123 < 0.00310000008903443813323974609375f) ? (_123 * 12.9200000762939453125f) : mad(exp2(_120 * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
  } else {
    float _185;
    float _186;
    float _187;
    if (_110 == 2u) {
      float3 _147 = float3(_101, _102, _103);
#if 1
      EncodePQ(_147, CB0_m.x, CB0_m.y, _185, _186, _187);
#else
      float _164 = exp2(CB0_m.x * log2(CB0_m.y * dp3_f32(float3(0.627403914928436279296875f, 0.3292830288410186767578125f, 0.0433130674064159393310546875f), _147)));
      float _165 = exp2(CB0_m.x * log2(CB0_m.y * dp3_f32(float3(0.069097287952899932861328125f, 0.9195404052734375f, 0.01136231608688831329345703125f), _147)));
      float _166 = exp2(CB0_m.x * log2(CB0_m.y * dp3_f32(float3(0.01639143936336040496826171875f, 0.08801330626010894775390625f, 0.895595252513885498046875f), _147)));
      _185 = exp2(log2(mad(_166, 18.8515625f, 0.8359375f) / mad(_166, 18.6875f, 1.0f)) * 78.84375f);
      _186 = exp2(log2(mad(_165, 18.8515625f, 0.8359375f) / mad(_165, 18.6875f, 1.0f)) * 78.84375f);
      _187 = exp2(log2(mad(_164, 18.8515625f, 0.8359375f) / mad(_164, 18.6875f, 1.0f)) * 78.84375f);
#endif
    } else {
      _185 = _103;
      _186 = _102;
      _187 = _101;
    }
    _188 = _185;
    _189 = _186;
    _190 = _187;
  }
  SV_TARGET.x = _190;
  SV_TARGET.y = _189;
  SV_TARGET.z = _188;
  SV_TARGET.w = _100.w;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  gl_FragCoord = stage_input.gl_FragCoord;
  gl_FragCoord.w = 1.0 / gl_FragCoord.w;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_TARGET = SV_TARGET;
  return stage_output;
}
