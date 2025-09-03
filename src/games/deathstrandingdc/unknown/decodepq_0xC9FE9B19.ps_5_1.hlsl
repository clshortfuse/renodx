#include "../common.hlsli"

cbuffer CB0_buf : register(b0, space8) {
  float2 CB0_m0 : packoffset(c0);
  float2 CB0_m1 : packoffset(c0.z);
};

SamplerState S0 : register(s0, space8);
Texture2D<float4> T0 : register(t0, space8);

static float4 SV_POSITION;
static float2 TEXCOORD;
static float4 SV_TARGET;

struct SPIRV_Cross_Input {
  float4 SV_POSITION : SV_POSITION;
  float2 TEXCOORD : TEXCOORD;
};

struct SPIRV_Cross_Output {
  float4 SV_TARGET : SV_Target0;
};

int cvt_f32_i32(float v) {
  return isnan(v) ? 0 : ((v < (-2147483648.0f)) ? int(0x80000000) : ((v > 2147483520.0f) ? 2147483647 : int(v)));
}

float dp3_f32(float3 a, float3 b) {
  precise float _64 = a.x * b.x;
  return mad(a.z, b.z, mad(a.y, b.y, _64));
}

void frag_main() {
  float4 _97 = T0.Sample(S0, float2(TEXCOORD.x, TEXCOORD.y));
  float _98 = _97.x;
  float _99 = _97.y;
  float _100 = _97.z;
  uint _106 = uint(cvt_f32_i32(CB0_m1.y));
  float _194;
  float _195;
  float _196;
  if (_106 == 1u) {
    float _134 = 1.0f / CB0_m0.x;
    _194 = exp2(_134 * log2((_100 < 0.040449999272823333740234375f) ? (_100 * 0.077399380505084991455078125f) : exp2(log2(mad(_100, 0.94786727428436279296875f, 0.0521326996386051177978515625f)) * 2.400000095367431640625f)));
    _195 = exp2(_134 * log2((_99 < 0.040449999272823333740234375f) ? (_99 * 0.077399380505084991455078125f) : exp2(log2(mad(_99, 0.94786727428436279296875f, 0.0521326996386051177978515625f)) * 2.400000095367431640625f)));
    _196 = exp2(log2((_98 < 0.040449999272823333740234375f) ? (_98 * 0.077399380505084991455078125f) : exp2(log2(mad(_98, 0.94786727428436279296875f, 0.0521326996386051177978515625f)) * 2.400000095367431640625f)) * _134);
  } else {
    float _191;
    float _192;
    float _193;
    if (_106 == 2u) {
#if 1
      DecodePQ(float3(_98, _99, _100), CB0_m0.x, CB0_m0.y, _191, _192, _193);
#else
      float _153 = exp2(log2(_98) * 0.0126833133399486541748046875f);
      float _154 = exp2(log2(_99) * 0.0126833133399486541748046875f);
      float _155 = exp2(log2(_100) * 0.0126833133399486541748046875f);
      float _173 = 1.0f / CB0_m0.x;
      float _174 = 1.0f / CB0_m0.y;
      float3 _187 = float3(_174 * exp2(_173 * log2(max((_153 - 0.8359375f) / mad(_153, -18.6875f, 18.8515625f), 0.0f))), exp2(log2(max((_154 - 0.8359375f) / mad(_154, -18.6875f, 18.8515625f), 0.0f)) * _173) * _174, exp2(log2(max((_155 - 0.8359375f) / mad(_155, -18.6875f, 18.8515625f), 0.0f)) * _173) * _174);
      _191 = dp3_f32(float3(-0.01815080083906650543212890625f, -0.100579001009464263916015625f, 1.11872994899749755859375f), _187);
      _192 = dp3_f32(float3(-0.12454999983310699462890625f, 1.1328999996185302734375f, -0.008349419571459293365478515625f), _187);
      _193 = dp3_f32(float3(1.6604900360107421875f, -0.5876410007476806640625f, -0.0728498995304107666015625f), _187);
#endif
    } else {
      _191 = _100;
      _192 = _99;
      _193 = _98;
    }
    _194 = _191;
    _195 = _192;
    _196 = _193;
  }
  SV_TARGET.x = _196;
  SV_TARGET.y = _195;
  SV_TARGET.z = _194;
  SV_TARGET.w = 1.0f;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  TEXCOORD = stage_input.TEXCOORD;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_TARGET = SV_TARGET;
  return stage_output;
}
