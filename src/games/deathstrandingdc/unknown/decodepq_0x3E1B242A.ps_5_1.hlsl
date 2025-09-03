#include "../common.hlsli"

cbuffer CB0_buf : register(b0, space8) {
  float2 CB0_m0 : packoffset(c0);
  float2 CB0_m1 : packoffset(c0.z);
  float2 CB0_m2 : packoffset(c1);
  float2 CB0_m3 : packoffset(c1.z);
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
  precise float _68 = a.x * b.x;
  return mad(a.z, b.z, mad(a.y, b.y, _68));
}

void frag_main() {
  float _284;
  float _285;
  float _286;
  if ((TEXCOORD.y <= (CB0_m2.y + CB0_m3.y)) && ((TEXCOORD.y >= CB0_m2.y) && ((TEXCOORD.x <= (CB0_m2.x + CB0_m3.x)) && (TEXCOORD.x >= CB0_m2.x)))) {
    float _118 = TEXCOORD.x - CB0_m2.x;
    float _119 = TEXCOORD.y - CB0_m2.y;
    float4 _127 = T0.Sample(S0, float2(_118 / CB0_m3.x, _119 / CB0_m3.y));
    float _134 = (_118 - 0.0010964912362396717071533203125f) / CB0_m3.x;
    float _135 = (_119 + 0.001953125f) / CB0_m3.y;
    float _136 = (_119 - 0.001953125f) / CB0_m3.y;
    float4 _139 = T0.Sample(S0, float2(_134, _135));
    float4 _148 = T0.Sample(S0, float2(_134, _136));
    float _156 = (_118 + 0.0010964912362396717071533203125f) / CB0_m3.x;
    float4 _159 = T0.Sample(S0, float2(_156, _135));
    float4 _168 = T0.Sample(S0, float2(_156, _136));
    float _172 = (((_127.x + _139.x) + _148.x) + _159.x) + _168.x;
    float _173 = _168.y + (_159.y + (_148.y + (_127.y + _139.y)));
    float _174 = _168.z + (_159.z + (_148.z + (_127.z + _139.z)));
    uint _179 = uint(cvt_f32_i32(CB0_m1.y));
    float _269;
    float _270;
    float _271;
    if (_179 == 1u) {
      float _207 = 1.0f / CB0_m0.x;
      _269 = exp2(_207 * log2((_174 < 0.20224998891353607177734375f) ? (_174 * 0.015479876659810543060302734375f) : exp2(log2(mad(_174, 0.18957345187664031982421875f, 0.0521326996386051177978515625f)) * 2.400000095367431640625f)));
      _270 = exp2(_207 * log2((_173 < 0.20224998891353607177734375f) ? (_173 * 0.015479876659810543060302734375f) : exp2(log2(mad(_173, 0.18957345187664031982421875f, 0.0521326996386051177978515625f)) * 2.400000095367431640625f)));
      _271 = exp2(log2((_172 < 0.20224998891353607177734375f) ? (_172 * 0.015479876659810543060302734375f) : exp2(log2(mad(_172, 0.18957345187664031982421875f, 0.0521326996386051177978515625f)) * 2.400000095367431640625f)) * _207);
    } else {
      float _217 = _172 * 0.20000000298023223876953125f;
      float _218 = _173 * 0.20000000298023223876953125f;
      float _219 = _174 * 0.20000000298023223876953125f;
      float _266;
      float _267;
      float _268;
      if (_179 == 2u) {
#if 1
        DecodePQ(float3(_217, _218, _219), CB0_m0.x, CB0_m0.y, _266, _267, _268);
#else
        float _229 = exp2(log2(_217) * 0.0126833133399486541748046875f);
        float _230 = exp2(log2(_218) * 0.0126833133399486541748046875f);
        float _231 = exp2(log2(_219) * 0.0126833133399486541748046875f);
        float _248 = 1.0f / CB0_m0.x;
        float _249 = 1.0f / CB0_m0.y;
        float3 _262 = float3(_249 * exp2(_248 * log2(max((_229 - 0.8359375f) / mad(_229, -18.6875f, 18.8515625f), 0.0f))), exp2(log2(max((_230 - 0.8359375f) / mad(_230, -18.6875f, 18.8515625f), 0.0f)) * _248) * _249, exp2(log2(max((_231 - 0.8359375f) / mad(_231, -18.6875f, 18.8515625f), 0.0f)) * _248) * _249);
        _266 = dp3_f32(float3(-0.01815080083906650543212890625f, -0.100579001009464263916015625f, 1.11872994899749755859375f), _262);
        _267 = dp3_f32(float3(-0.12454999983310699462890625f, 1.1328999996185302734375f, -0.008349419571459293365478515625f), _262);
        _268 = dp3_f32(float3(1.6604900360107421875f, -0.5876410007476806640625f, -0.0728498995304107666015625f), _262);
#endif
      } else {
        _266 = _219;
        _267 = _218;
        _268 = _217;
      }
      _269 = _266;
      _270 = _267;
      _271 = _268;
    }
    _284 = exp2(log2(clamp(_269, 0.0f, 1.0f)) * 0.4545449912548065185546875f);
    _285 = exp2(log2(clamp(_270, 0.0f, 1.0f)) * 0.4545449912548065185546875f);
    _286 = exp2(log2(clamp(_271, 0.0f, 1.0f)) * 0.4545449912548065185546875f);
  } else {
    _284 = 0.0f;
    _285 = 0.0f;
    _286 = 0.0f;
  }
  SV_TARGET.x = _286;
  SV_TARGET.y = _285;
  SV_TARGET.z = _284;
  SV_TARGET.w = 1.0f;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  TEXCOORD = stage_input.TEXCOORD;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_TARGET = SV_TARGET;
  return stage_output;
}
