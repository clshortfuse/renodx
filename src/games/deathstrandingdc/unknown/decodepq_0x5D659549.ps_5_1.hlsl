#include "../common.hlsli"

cbuffer CB0_buf : register(b0, space8) {
  float2 CB0_m0 : packoffset(c0);
  float2 CB0_m1 : packoffset(c0.z);
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
  precise float _62 = a.x * b.x;
  return mad(a.z, b.z, mad(a.y, b.y, _62));
}

void frag_main() {
  float4 _102 = T0.Load(int3(uint2(cvt_f32_u32(gl_FragCoord.x), cvt_f32_u32(gl_FragCoord.y)), 0u));
  float _103 = _102.x;
  float _104 = _102.y;
  float _105 = _102.z;
  uint _112 = uint(cvt_f32_i32(CB0_m1.y));
  float _201;
  float _202;
  float _203;
  if (_112 == 1u) {
    float _141 = 1.0f / CB0_m0.x;
    _201 = exp2(_141 * log2((_105 < 0.040449999272823333740234375f) ? (_105 * 0.077399380505084991455078125f) : exp2(log2(mad(_105, 0.94786727428436279296875f, 0.0521326996386051177978515625f)) * 2.400000095367431640625f)));
    _202 = exp2(_141 * log2((_104 < 0.040449999272823333740234375f) ? (_104 * 0.077399380505084991455078125f) : exp2(log2(mad(_104, 0.94786727428436279296875f, 0.0521326996386051177978515625f)) * 2.400000095367431640625f)));
    _203 = exp2(log2((_103 < 0.040449999272823333740234375f) ? (_103 * 0.077399380505084991455078125f) : exp2(log2(mad(_103, 0.94786727428436279296875f, 0.0521326996386051177978515625f)) * 2.400000095367431640625f)) * _141);
  } else {
    float _198;
    float _199;
    float _200;
    if (_112 == 2u) {
#if 1
      DecodePQ(float3(_103, _104, _105), CB0_m0.x, CB0_m0.y, _198, _199, _200);
#else
      float _160 = exp2(log2(_103) * 0.0126833133399486541748046875f);
      float _161 = exp2(log2(_104) * 0.0126833133399486541748046875f);
      float _162 = exp2(log2(_105) * 0.0126833133399486541748046875f);
      float _180 = 1.0f / CB0_m0.x;
      float _181 = 1.0f / CB0_m0.y;
      float3 _194 = float3(_181 * exp2(_180 * log2(max((_160 - 0.8359375f) / mad(_160, -18.6875f, 18.8515625f), 0.0f))), exp2(log2(max((_161 - 0.8359375f) / mad(_161, -18.6875f, 18.8515625f), 0.0f)) * _180) * _181, exp2(log2(max((_162 - 0.8359375f) / mad(_162, -18.6875f, 18.8515625f), 0.0f)) * _180) * _181);
      _198 = dp3_f32(float3(-0.01815080083906650543212890625f, -0.100579001009464263916015625f, 1.11872994899749755859375f), _194);
      _199 = dp3_f32(float3(-0.12454999983310699462890625f, 1.1328999996185302734375f, -0.008349419571459293365478515625f), _194);
      _200 = dp3_f32(float3(1.6604900360107421875f, -0.5876410007476806640625f, -0.0728498995304107666015625f), _194);
#endif
    } else {
      _198 = _105;
      _199 = _104;
      _200 = _103;
    }
    _201 = _198;
    _202 = _199;
    _203 = _200;
  }
  SV_TARGET.x = _203;
  SV_TARGET.y = _202;
  SV_TARGET.z = _201;
  SV_TARGET.w = _102.w;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  gl_FragCoord = stage_input.gl_FragCoord;
  gl_FragCoord.w = 1.0 / gl_FragCoord.w;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_TARGET = SV_TARGET;
  return stage_output;
}
