cbuffer __3__35__0__0__ExposureConstantBuffer : register(b31, space35) {
  float4 _exposure0 : packoffset(c000.x);
  float4 _exposure1 : packoffset(c001.x);
  float4 _exposure2 : packoffset(c002.x);
  float4 _exposure3 : packoffset(c003.x);
  float4 _exposure4 : packoffset(c004.x);
};

// AE2 fields used by the grading path:
//   _exposure0.x = final adapted exposure scalar written by AdaptExposure
//   _exposure2.x = raw meter / histogram luminance
//   _exposure2.y = signed fast-direction settling delta from the clean field
//   _exposure2.z = clean adapted field ("Adapt" in the debug panel)
//   _exposure2.w = signed slow-direction settling delta from the clean field
//   _exposure4.z = filtered exposure history used by glare/lens effects

cbuffer __3__1__0__0__GlobalPushConstants : register(b0, space1) {
  float4 _postProcessParams : packoffset(c000.x);
  float4 _postProcessParams1 : packoffset(c001.x);
  float4 _toneMapParams0 : packoffset(c002.x);
  float4 _toneMapParams1 : packoffset(c003.x);
  float4 _colorGradingParams : packoffset(c004.x);
  float4 _colorCorrectionParams : packoffset(c005.x);
  float4 _localToneMappingParams : packoffset(c006.x);
  float4 _etcParams : packoffset(c007.x);
  float4 _userImageAdjust : packoffset(c008.x);
  float4 _slopeParams : packoffset(c009.x);
  float4 _offsetParams : packoffset(c010.x);
  float4 _powerParams : packoffset(c011.x);
};

// _userImageAdjust.z is the grading exposure multiplier
// ("ColorGradeExposure" in the addon UI). It sits on top of the AE solve.


float GetPerceptualAdaptedFieldYf() {
  // Prefer the clean adapted field, then fall back to the raw meter when
  // history is invalid (first frame / load / reset).
  float field_state = _exposure2.z;

  // AE2 exposes the live adaptation anchor as the clean field plus signed
  // settling deltas. Negative FastBg means the observer is still catching up
  // to a brighter field; positive SlowBg means the observer is still carrying
  // a brighter past state into a darker field.
  float fast_equivalent_background = _exposure2.y;
  float slow_equivalent_background = _exposure2.w;

  return field_state + fast_equivalent_background + slow_equivalent_background;
}

// // Core SDR curve stage only. Expects per-channel linear inputs and outputs in the same space.
// float3 SDRCurveOnly(float3 color) {
//   float _2972 = min(max(log2(max(color.x, 0.0f)), -12.473930358886719f), 4.026069164276123f) + 12.473930358886719f;
//   float _2973 = min(max(log2(max(color.y, 0.0f)), -12.473930358886719f), 4.026069164276123f) + 12.473930358886719f;
//   float _2974 = min(max(log2(max(color.z, 0.0f)), -12.473930358886719f), 4.026069164276123f) + 12.473930358886719f;
//   float _2975 = _2972 * 0.06060606241226196f;
//   float _2976 = _2973 * 0.06060606241226196f;
//   float _2977 = _2974 * 0.06060606241226196f;
//   float _2978 = _2975 * _2975;
//   float _2979 = _2976 * _2976;
//   float _2980 = _2977 * _2977;
//   float _3026 = min(0.0f, (-0.0f - (((_2972 * 0.007218181621283293f) + ((_2978 * 0.42980000376701355f) + (((_2978 * _2978) * ((31.959999084472656f - (_2972 * 2.432727336883545f)) + (_2978 * 15.5f))) - ((_2972 * 0.41624245047569275f) * _2978)))) + -0.002319999970495701f)));
//   float _3027 = min(0.0f, (-0.0f - (((_2973 * 0.007218181621283293f) + ((_2979 * 0.42980000376701355f) + (((_2979 * _2979) * ((31.959999084472656f - (_2973 * 2.432727336883545f)) + (_2979 * 15.5f))) - ((_2973 * 0.41624245047569275f) * _2979)))) + -0.002319999970495701f)));
//   float _3028 = min(0.0f, (-0.0f - (((_2974 * 0.007218181621283293f) + ((_2980 * 0.42980000376701355f) + (((_2980 * _2980) * ((31.959999084472656f - (_2974 * 2.432727336883545f)) + (_2980 * 15.5f))) - ((_2974 * 0.41624245047569275f) * _2980)))) + -0.002319999970495701f)));
//   float _3029 = -0.0f - _3026;
//   float _3030 = -0.0f - _3027;
//   float _3031 = -0.0f - _3028;
//   float _3032 = dot(float3(_3029, _3030, _3031), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
//   float _3038 = saturate((_exposure2.x + -3.0f) * 0.1428571492433548f) * 0.20000004768371582f;
//   float _3039 = _3038 + 1.0f;
//   float _3070 = ((exp2(log2((_3039 - (_3038 * saturate((_3026 * _3026) * _3029))) * _3029)) - _3032) * 1.399999976158142f) + _3032;
//   float _3071 = ((exp2(log2((_3039 - (saturate((_3027 * _3027) * _3030) * _3038)) * _3030)) - _3032) * 1.399999976158142f) + _3032;
//   float _3072 = ((exp2(log2((_3039 - (saturate((_3028 * _3028) * _3031) * _3038)) * _3031)) - _3032) * 1.399999976158142f) + _3032;
//   return float3(_3070, _3071, _3072);
// }

float3 ACESv2Curves(float3 color) {
  float _2972 = min(max(log2(mad(color.z, 0.07922374457120895f, mad(color.y, 0.07843360304832458f, (color.x * 0.8424790501594543f)))), -12.473930358886719f), 4.026069164276123f) + 12.473930358886719f;
  float _2973 = min(max(log2(mad(color.z, 0.07916612923145294f, mad(color.y, 0.8784686326980591f, (color.x * 0.04232824221253395f)))), -12.473930358886719f), 4.026069164276123f) + 12.473930358886719f;
  float _2974 = min(max(log2(mad(color.z, 0.8791429996490479f, mad(color.y, 0.07843360304832458f, (color.x * 0.042375653982162476f)))), -12.473930358886719f), 4.026069164276123f) + 12.473930358886719f;
  float _2975 = _2972 * 0.06060606241226196f;
  float _2976 = _2973 * 0.06060606241226196f;
  float _2977 = _2974 * 0.06060606241226196f;
  float _2978 = _2975 * _2975;
  float _2979 = _2976 * _2976;
  float _2980 = _2977 * _2977;
  float _3026 = min(0.0f, (-0.0f - (((_2972 * 0.007218181621283293f) + ((_2978 * 0.42980000376701355f) + (((_2978 * _2978) * ((31.959999084472656f - (_2972 * 2.432727336883545f)) + (_2978 * 15.5f))) - ((_2972 * 0.41624245047569275f) * _2978)))) + -0.002319999970495701f)));
  float _3027 = min(0.0f, (-0.0f - (((_2973 * 0.007218181621283293f) + ((_2979 * 0.42980000376701355f) + (((_2979 * _2979) * ((31.959999084472656f - (_2973 * 2.432727336883545f)) + (_2979 * 15.5f))) - ((_2973 * 0.41624245047569275f) * _2979)))) + -0.002319999970495701f)));
  float _3028 = min(0.0f, (-0.0f - (((_2974 * 0.007218181621283293f) + ((_2980 * 0.42980000376701355f) + (((_2980 * _2980) * ((31.959999084472656f - (_2974 * 2.432727336883545f)) + (_2980 * 15.5f))) - ((_2974 * 0.41624245047569275f) * _2980)))) + -0.002319999970495701f)));
  float _3029 = -0.0f - _3026;
  float _3030 = -0.0f - _3027;
  float _3031 = -0.0f - _3028;
  float _3032 = dot(float3(_3029, _3030, _3031), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _3038 = saturate((_exposure2.x + -3.0f) * 0.1428571492433548f) * 0.20000004768371582f;
  float _3039 = _3038 + 1.0f;
  float _3070 = ((exp2(log2((_3039 - (_3038 * saturate((_3026 * _3026) * _3029))) * _3029)) - _3032) * 1.399999976158142f) + _3032;
  float _3071 = ((exp2(log2((_3039 - (saturate((_3027 * _3027) * _3030) * _3038)) * _3030)) - _3032) * 1.399999976158142f) + _3032;
  float _3072 = ((exp2(log2((_3039 - (saturate((_3028 * _3028) * _3031) * _3038)) * _3031)) - _3032) * 1.399999976158142f) + _3032;
  float _3091 = saturate(exp2(log2(mad(_3072, -0.09902974218130112f, mad(_3071, -0.09802088141441345f, (_3070 * 1.1968790292739868f)))) * 2.200000047683716f));
  float _3092 = saturate(exp2(log2(mad(_3072, -0.09896117448806763f, mad(_3071, 1.1519031524658203f, (_3070 * -0.052896853536367416f)))) * 2.200000047683716f));
  float _3093 = saturate(exp2(log2(mad(_3072, 1.151073694229126f, mad(_3071, -0.09804344922304153f, (_3070 * -0.05297163501381874f)))) * 2.200000047683716f));
  return float3(_3091, _3092, _3093);
}

float3 VanillaCurves(float3 color) {
  float3 aces = ACESv2Curves(color);
  float curveR = aces.x;
  float curveG = aces.y;
  float curveB = aces.z;

  if (_etcParams.z == 0.0f) {
    float blendAmount = 1.0f - abs(_etcParams.w);
    float blendOffset = saturate(_etcParams.w);
    float blendedR = (blendAmount * curveR) + blendOffset;
    float blendedG = (blendAmount * curveG) + blendOffset;
    float blendedB = (blendAmount * curveB) + blendOffset;

    if (_colorGradingParams.w > 0.0f) {
      float gradeStrength = saturate(_colorGradingParams.w);
      blendedR = (((max(0.0f, (1.0f - blendedR)) - blendedR) * gradeStrength) + blendedR);
      blendedG = (((max(0.0f, (1.0f - blendedG)) - blendedG) * gradeStrength) + blendedG);
      blendedB = (((max(0.0f, (1.0f - blendedB)) - blendedB) * gradeStrength) + blendedB);
    }

    float contrast = _userImageAdjust.y + 1.0f;
    float offset = _userImageAdjust.x + 0.5f;
    float gamma = 2.200000047683716f / ((min(max(_userImageAdjust.w, -1.0f), 1.0f) * 0.800000011920929f) + 2.200000047683716f);

    curveR = exp2(log2(saturate(((blendedR + -0.5f) * contrast) + offset)) * gamma);
    curveG = exp2(log2(saturate(((blendedG + -0.5f) * contrast) + offset)) * gamma);
    curveB = exp2(log2(saturate(((blendedB + -0.5f) * contrast) + offset)) * gamma);
  }

  return float3(curveR, curveG, curveB);
}

float3 SDRToneMap(float3 color) {
  float _3128;
  float _3129;
  float _3130;
  float _3163;
  float _3164;
  float _3165;

  float _2972 = min(max(log2(mad(color.z, 0.07922374457120895f, mad(color.y, 0.07843360304832458f, (color.x * 0.8424790501594543f)))), -12.473930358886719f), 4.026069164276123f) + 12.473930358886719f;
  float _2973 = min(max(log2(mad(color.z, 0.07916612923145294f, mad(color.y, 0.8784686326980591f, (color.x * 0.04232824221253395f)))), -12.473930358886719f), 4.026069164276123f) + 12.473930358886719f;
  float _2974 = min(max(log2(mad(color.z, 0.8791429996490479f, mad(color.y, 0.07843360304832458f, (color.x * 0.042375653982162476f)))), -12.473930358886719f), 4.026069164276123f) + 12.473930358886719f;
  float _2975 = _2972 * 0.06060606241226196f;
  float _2976 = _2973 * 0.06060606241226196f;
  float _2977 = _2974 * 0.06060606241226196f;
  float _2978 = _2975 * _2975;
  float _2979 = _2976 * _2976;
  float _2980 = _2977 * _2977;
  float _3026 = min(0.0f, (-0.0f - (((_2972 * 0.007218181621283293f) + ((_2978 * 0.42980000376701355f) + (((_2978 * _2978) * ((31.959999084472656f - (_2972 * 2.432727336883545f)) + (_2978 * 15.5f))) - ((_2972 * 0.41624245047569275f) * _2978)))) + -0.002319999970495701f)));
  float _3027 = min(0.0f, (-0.0f - (((_2973 * 0.007218181621283293f) + ((_2979 * 0.42980000376701355f) + (((_2979 * _2979) * ((31.959999084472656f - (_2973 * 2.432727336883545f)) + (_2979 * 15.5f))) - ((_2973 * 0.41624245047569275f) * _2979)))) + -0.002319999970495701f)));
  float _3028 = min(0.0f, (-0.0f - (((_2974 * 0.007218181621283293f) + ((_2980 * 0.42980000376701355f) + (((_2980 * _2980) * ((31.959999084472656f - (_2974 * 2.432727336883545f)) + (_2980 * 15.5f))) - ((_2974 * 0.41624245047569275f) * _2980)))) + -0.002319999970495701f)));
  float _3029 = -0.0f - _3026;
  float _3030 = -0.0f - _3027;
  float _3031 = -0.0f - _3028;
  float _3032 = dot(float3(_3029, _3030, _3031), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _3038 = saturate((_exposure2.x + -3.0f) * 0.1428571492433548f) * 0.20000004768371582f;
  float _3039 = _3038 + 1.0f;
  float _3070 = ((exp2(log2((_3039 - (_3038 * saturate((_3026 * _3026) * _3029))) * _3029)) - _3032) * 1.399999976158142f) + _3032;
  float _3071 = ((exp2(log2((_3039 - (saturate((_3027 * _3027) * _3030) * _3038)) * _3030)) - _3032) * 1.399999976158142f) + _3032;
  float _3072 = ((exp2(log2((_3039 - (saturate((_3028 * _3028) * _3031) * _3038)) * _3031)) - _3032) * 1.399999976158142f) + _3032;
  float _3091 = saturate(exp2(log2(mad(_3072, -0.09902974218130112f, mad(_3071, -0.09802088141441345f, (_3070 * 1.1968790292739868f)))) * 2.200000047683716f));
  float _3092 = saturate(exp2(log2(mad(_3072, -0.09896117448806763f, mad(_3071, 1.1519031524658203f, (_3070 * -0.052896853536367416f)))) * 2.200000047683716f));
  float _3093 = saturate(exp2(log2(mad(_3072, 1.151073694229126f, mad(_3071, -0.09804344922304153f, (_3070 * -0.05297163501381874f)))) * 2.200000047683716f));
  if (_etcParams.z == 0.0f) {
    float _3099 = 1.0f - abs(_etcParams.w);
    float _3103 = saturate(_etcParams.w);
    float _3104 = (_3099 * _3091) + _3103;
    float _3105 = (_3099 * _3092) + _3103;
    float _3106 = (_3099 * _3093) + _3103;
    if (_colorGradingParams.w > 0.0f) {
      float _3111 = saturate(_colorGradingParams.w);
      _3128 = (((max(0.0f, (1.0f - _3104)) - _3104) * _3111) + _3104);
      _3129 = (((max(0.0f, (1.0f - _3105)) - _3105) * _3111) + _3105);
      _3130 = (((max(0.0f, (1.0f - _3106)) - _3106) * _3111) + _3106);
    } else {
      _3128 = _3104;
      _3129 = _3105;
      _3130 = _3106;
    }
    float _3136 = _userImageAdjust.y + 1.0f;
    float _3140 = _userImageAdjust.x + 0.5f;
    float _3152 = 2.200000047683716f / ((min(max(_userImageAdjust.w, -1.0f), 1.0f) * 0.800000011920929f) + 2.200000047683716f);
    _3163 = exp2(log2(saturate(((_3128 + -0.5f) * _3136) + _3140)) * _3152);
    _3164 = exp2(log2(saturate(((_3129 + -0.5f) * _3136) + _3140)) * _3152);
    _3165 = exp2(log2(saturate(((_3130 + -0.5f) * _3136) + _3140)) * _3152);

  } else {
    _3163 = _3091;
    _3164 = _3092;
    _3165 = _3093;
  }
  return float3(_3163, _3164, _3165);
}
