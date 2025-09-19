#include "../common.hlsli"
cbuffer CB0_buf : register(b0, space8) {
  uint4 CB0_m0 : packoffset(c0);
  float4 CB0_m1 : packoffset(c1);
  float4 CB0_m2 : packoffset(c2);
  float4 CB0_m3 : packoffset(c3);
  uint4 CB0_m4 : packoffset(c4);
  float2 CB0_m5 : packoffset(c5);
  float2 CB0_m6 : packoffset(c5.z);
  float4 CB0_m7 : packoffset(c6);
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
  precise float _102 = a.x * b.x;
  return mad(a.z, b.z, mad(a.y, b.y, _102));
}

void frag_main() {
  float4 _135 = T0.Sample(S0, float2(TEXCOORD.x, TEXCOORD.y));
  float _136 = _135.x;
  float _137 = _135.y;
  float _138 = _135.z;
  uint _144 = uint(cvt_f32_i32(CB0_m6.y));
  float _232;
  float _233;
  float _234;
  if (_144 == 1u) {
    float _172 = 1.0f / CB0_m5.x;
    _232 = exp2(_172 * log2((_138 < 0.040449999272823333740234375f) ? (_138 * 0.077399380505084991455078125f) : exp2(log2(mad(_138, 0.94786727428436279296875f, 0.0521326996386051177978515625f)) * 2.400000095367431640625f)));
    _233 = exp2(_172 * log2((_137 < 0.040449999272823333740234375f) ? (_137 * 0.077399380505084991455078125f) : exp2(log2(mad(_137, 0.94786727428436279296875f, 0.0521326996386051177978515625f)) * 2.400000095367431640625f)));
    _234 = exp2(log2((_136 < 0.040449999272823333740234375f) ? (_136 * 0.077399380505084991455078125f) : exp2(log2(mad(_136, 0.94786727428436279296875f, 0.0521326996386051177978515625f)) * 2.400000095367431640625f)) * _172);
  } else {
    float _229;
    float _230;
    float _231;
    if (_144 == 2u) {
#if 1
      DecodePQ(float3(_136, _137, _138), CB0_m5.x, CB0_m5.y, _229, _230, _231);
#else
      float _191 = exp2(log2(_136) * 0.0126833133399486541748046875f);
      float _192 = exp2(log2(_137) * 0.0126833133399486541748046875f);
      float _193 = exp2(log2(_138) * 0.0126833133399486541748046875f);
      float _211 = 1.0f / CB0_m5.x;
      float _212 = 1.0f / CB0_m5.y;
      float3 _225 = float3(exp2(_211 * log2(max((_191 - 0.8359375f) / mad(_191, -18.6875f, 18.8515625f), 0.0f))) * _212, exp2(_211 * log2(max((_192 - 0.8359375f) / mad(_192, -18.6875f, 18.8515625f), 0.0f))) * _212, exp2(_211 * log2(max((_193 - 0.8359375f) / mad(_193, -18.6875f, 18.8515625f), 0.0f))) * _212);
      _229 = dp3_f32(float3(-0.01815080083906650543212890625f, -0.100579001009464263916015625f, 1.11872994899749755859375f), _225);
      _230 = dp3_f32(float3(-0.12454999983310699462890625f, 1.1328999996185302734375f, -0.008349419571459293365478515625f), _225);
      _231 = dp3_f32(float3(1.6604900360107421875f, -0.5876410007476806640625f, -0.0728498995304107666015625f), _225);
#endif
    } else {
      _229 = _138;
      _230 = _137;
      _231 = _136;
    }
    _232 = _229;
    _233 = _230;
    _234 = _231;
  }
  //   float _265 = sqrt((CB0_m2.z > _234) ? mad(_234, CB0_m1.y, CB0_m1.z) : (CB0_m2.y - (CB0_m1.w / (_234 + CB0_m2.x))));
  //   float _266 = sqrt((_233 < CB0_m2.z) ? mad(_233, CB0_m1.y, CB0_m1.z) : (CB0_m2.y - (CB0_m1.w / (_233 + CB0_m2.x))));
  //   float _267 = sqrt((_232 < CB0_m2.z) ? mad(_232, CB0_m1.y, CB0_m1.z) : (CB0_m2.y - (CB0_m1.w / (_232 + CB0_m2.x))));
  //   float _282 = (_265 > 0.0f) ? exp2(log2(_265) * CB0_m3.w) : 0.0f;
  //   float _283 = (_266 > 0.0f) ? exp2(log2(_266) * CB0_m3.w) : 0.0f;
  //   float _284 = (_267 > 0.0f) ? exp2(log2(_267) * CB0_m3.w) : 0.0f;
  //   float _290 = min(_282 * _282, CB0_m1.x);
  //   float _291 = min(_283 * _283, CB0_m1.x);
  //   float _292 = min(_284 * _284, CB0_m1.x);
  //   float _316 = (_290 < CB0_m2.w) ? ((_290 - CB0_m1.z) / CB0_m1.y) : (-((CB0_m1.w / (_290 - CB0_m2.y)) + CB0_m2.x));
  //   float _317 = (_291 < CB0_m2.w) ? ((_291 - CB0_m1.z) / CB0_m1.y) : (-((CB0_m1.w / (_291 - CB0_m2.y)) + CB0_m2.x));
  //   float _318 = (_292 < CB0_m2.w) ? ((_292 - CB0_m1.z) / CB0_m1.y) : (-((CB0_m1.w / (_292 - CB0_m2.y)) + CB0_m2.x));
  //   float _340 = (CB0_m2.z > _316) ? mad(_316, CB0_m1.y, CB0_m1.z) : (CB0_m3.z - (CB0_m3.x / (CB0_m3.y + _316)));
  //   float _341 = (CB0_m2.z > _317) ? mad(_317, CB0_m1.y, CB0_m1.z) : (CB0_m3.z - (CB0_m3.x / (CB0_m3.y + _317)));
  //   float _342 = (CB0_m2.z > _318) ? mad(_318, CB0_m1.y, CB0_m1.z) : (CB0_m3.z - (CB0_m3.x / (CB0_m3.y + _318)));

  float _340, _341, _342;
  float3 tonemapped;
  float3 untonemapped = float3(_234, _233, _232);
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    tonemapped = ApplyDeathStrandingToneMap(untonemapped, CB0_m1, CB0_m2, CB0_m3);
    _340 = tonemapped.x, _341 = tonemapped.y, _342 = tonemapped.z;
  } else {
    tonemapped = ApplyDeathStrandingToneMap(untonemapped, CB0_m1, CB0_m2, CB0_m3, 1u);

    tonemapped = ApplyDisplayMap(tonemapped);
    tonemapped = ScaleScene(tonemapped);
    _340 = tonemapped.x, _341 = tonemapped.y, _342 = tonemapped.z;
  }

  uint _346 = uint(cvt_f32_i32(CB0_m7.w));
  float _424;
  float _425;
  float _426;
  if (_346 == 1u) {
    float _356 = log2(_340) * CB0_m7.x;
    float _357 = log2(_341) * CB0_m7.x;
    float _358 = log2(_342) * CB0_m7.x;
    float _359 = exp2(_356);
    float _360 = exp2(_357);
    float _361 = exp2(_358);
    _424 = (_361 < 0.00310000008903443813323974609375f) ? (_361 * 12.9200000762939453125f) : mad(exp2(_358 * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
    _425 = (_360 < 0.00310000008903443813323974609375f) ? (_360 * 12.9200000762939453125f) : mad(exp2(_357 * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
    _426 = (_359 < 0.00310000008903443813323974609375f) ? (_359 * 12.9200000762939453125f) : mad(exp2(_356 * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
  } else {
    float _421;
    float _422;
    float _423;
    if (_346 == 2u) {
      float3 _383 = float3(_340, _341, _342);
#if 1
      EncodePQ(_383, CB0_m7.x, CB0_m7.y, _421, _422, _423);
#else
      float _400 = exp2(CB0_m7.x * log2(CB0_m7.y * dp3_f32(float3(0.627403914928436279296875f, 0.3292830288410186767578125f, 0.0433130674064159393310546875f), _383)));
      float _401 = exp2(log2(CB0_m7.y * dp3_f32(float3(0.069097287952899932861328125f, 0.9195404052734375f, 0.01136231608688831329345703125f), _383)) * CB0_m7.x);
      float _402 = exp2(log2(CB0_m7.y * dp3_f32(float3(0.01639143936336040496826171875f, 0.08801330626010894775390625f, 0.895595252513885498046875f), _383)) * CB0_m7.x);
      _421 = exp2(log2(mad(_402, 18.8515625f, 0.8359375f) / mad(_402, 18.6875f, 1.0f)) * 78.84375f);
      _422 = exp2(log2(mad(_401, 18.8515625f, 0.8359375f) / mad(_401, 18.6875f, 1.0f)) * 78.84375f);
      _423 = exp2(log2(mad(_400, 18.8515625f, 0.8359375f) / mad(_400, 18.6875f, 1.0f)) * 78.84375f);
#endif
    } else {
      _421 = _342;
      _422 = _341;
      _423 = _340;
    }
    _424 = _421;
    _425 = _422;
    _426 = _423;
  }
  SV_TARGET.x = _426;
  SV_TARGET.y = _425;
  SV_TARGET.z = _424;
  SV_TARGET.w = 1.0f;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  TEXCOORD = stage_input.TEXCOORD;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_TARGET = SV_TARGET;
  return stage_output;
}
