#include "./common.hlsl"

RWTexture3D<float4> u0 : register(u0, space5);

// cbuffer ColorGradingGenerateLUT : register(b0, space5) {
//   struct ColorGradingGenerateLUT_Constants {
//     struct ColorGradingParameters_Constants {} ColorGradingParams;
//     struct TonemapperParams_Constants {
//       struct GTTonemapperParameters {} GTTonemapper;
//       struct LottesTonemapperParameters {} LottesTonemapper;
//       struct GeneralTonemappingParameters {} GeneralTonemapping;
//       struct ACESTonemapperParameters {} ACESTonemapper;
//     } TonemapperParams;
//   } Constants;
// };
cbuffer cb0 : register(b0, space5) {
  float cb0_000x : packoffset(c000.x);
  float cb0_000y : packoffset(c000.y);
  float cb0_000z : packoffset(c000.z);
  float cb0_000w : packoffset(c000.w);
  float cb0_001x : packoffset(c001.x);
  float cb0_002x : packoffset(c002.x);
  float cb0_002y : packoffset(c002.y);
  float cb0_002z : packoffset(c002.z);
  float cb0_002w : packoffset(c002.w);
  uint cb0_003x : packoffset(c003.x);
  uint cb0_003y : packoffset(c003.y);
  float cb0_003z : packoffset(c003.z);
  float cb0_003w : packoffset(c003.w);
};

[numthreads(16, 16, 1)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  float _20 = (exp2(((float((uint)SV_DispatchThreadID.x)) * 0.6451612710952759f) + -12.473931312561035f));
  float _21 = (exp2(((float((uint)SV_DispatchThreadID.y)) * 0.6451612710952759f) + -12.473931312561035f));
  float _22 = (exp2(((float((uint)SV_DispatchThreadID.z)) * 0.6451612710952759f) + -12.473931312561035f));

  float exposure = 32.f;  // cb0_003z
  _20 *= exposure;
  _21 *= exposure;
  _22 *= exposure;

#if 1  // apply SDR tonemapper
  float3 untonemapped = float3(_20, _21, _22);
  const float diffuse_white_nits = cb0_003z * (203.f / 90.f);  // default exposure was 90.f, offset so 203 paper white at exposure 0.0
  const float peak_nits = cb0_003w;

  float3 tonemapped = ApplyBlendedToneMapEncodePQ(untonemapped, peak_nits, diffuse_white_nits);
  u0[uint3(SV_DispatchThreadID.rgb)] = float4(tonemapped, 1.f);
  return;
#endif

  float _359;
  float _360;
  float _361;
  float _455;
  float _456;
  float _457;
  switch ((uint)(cb0_003y)) {
    case 2: {
      float _27 = abs(_20 * 0.009999999776482582f);
      float _29 = cb0_003w * 0.009999999776482582f;
      float _39 = ((_29 - cb0_000y) * cb0_000z) / cb0_000x;
      float _40 = _27 - cb0_000y;
      bool _43 = (cb0_000y > 9.999999747378752e-06f);
      float _44 = _27 / cb0_000y;
      float _55 = _29 - ((_39 * cb0_000x) + cb0_000y);
      float _56 = (cb0_000x * _29) / _55;
      float _63 = saturate(_44);
      float _67 = (_63 * _63) * (3.0f - (_63 * 2.0f));
      float _69 = _39 + cb0_000y;
      float _71 = select((_27 > _69), 1.0f, 0.0f);
      float _80 = abs(_21 * 0.009999999776482582f);
      float _81 = _80 - cb0_000y;
      float _84 = _80 / cb0_000y;
      float _98 = saturate(_84);
      float _102 = (_98 * _98) * (3.0f - (_98 * 2.0f));
      float _105 = select((_80 > _69), 1.0f, 0.0f);
      float _114 = abs(_22 * 0.009999999776482582f);
      float _115 = _114 - cb0_000y;
      float _118 = _114 / cb0_000y;
      float _132 = saturate(_118);
      float _136 = (_132 * _132) * (3.0f - (_132 * 2.0f));
      float _139 = select((_114 > _69), 1.0f, 0.0f);
      _359 = (((((_67 - _71) * ((_40 * cb0_000x) + cb0_000y)) + ((_29 - (_55 / (((_56 * (_40 - _39)) / _29) + 1.0f))) * _71)) + ((1.0f - _67) * (select(_43, (((exp2((log2(abs(_44)))*cb0_000w))*cb0_000y) + cb0_001x), cb0_001x)))) * 100.0f);
      _360 = (((((_102 - _105) * ((_81 * cb0_000x) + cb0_000y)) + ((_29 - (_55 / (((_56 * (_81 - _39)) / _29) + 1.0f))) * _105)) + ((1.0f - _102) * (select(_43, (((exp2((log2(abs(_84)))*cb0_000w))*cb0_000y) + cb0_001x), cb0_001x)))) * 100.0f);
      _361 = (((((_136 - _139) * ((_115 * cb0_000x) + cb0_000y)) + ((_29 - (_55 / (((_56 * (_115 - _39)) / _29) + 1.0f))) * _139)) + ((1.0f - _136) * (select(_43, (((exp2((log2(abs(_118)))*cb0_000w))*cb0_000y) + cb0_001x), cb0_001x)))) * 100.0f);
      break;
    }
    case 3: {
      float _149 = abs(cb0_003w);
      float _158 = log2(abs(cb0_002x));
      float _161 = cb0_002w * cb0_002z;
      float _163 = exp2(_161 * _158);
      float _164 = log2(_149);
      float _166 = exp2(_164 * cb0_002z);
      float _168 = exp2(_161 * _164);
      float _170 = (_168 - _163) * cb0_002y;
      float _173 = ((_166 * cb0_002y) - (exp2(_158 * cb0_002z))) / _170;
      float _178 = ((_168 * _163) - ((_163 * cb0_002y) * _166)) / _170;
      float _181 = exp2((log2(abs(_20 / _149))) * cb0_002z);
      float _193 = exp2((log2(abs(_21 / _149))) * cb0_002z);
      float _205 = exp2((log2(abs(_22 / _149))) * cb0_002z);
      _359 = (cb0_003w * (_181 / (((exp2((log2(_181))*cb0_002w))*_173) + _178)));
      _360 = (cb0_003w * (_193 / (((exp2((log2(_193))*cb0_002w))*_173) + _178)));
      _361 = (cb0_003w * (_205 / (((exp2((log2(_205))*cb0_002w))*_173) + _178)));
      break;
    }
    case 4: {
      _359 = (_20 / ((_20 / cb0_003w) + 1.0f));
      _360 = (_21 / ((_21 / cb0_003w) + 1.0f));
      _361 = (_22 / ((_22 / cb0_003w) + 1.0f));
      break;
    }
    case 5: {
      _359 = _20;
      _360 = _21;
      _361 = _22;
      break;
    }
    case 6: {
      _359 = (min(_20, cb0_003w));
      _360 = (min(_21, cb0_003w));
      _361 = (min(_22, cb0_003w));
      break;
    }
    case 1: {  // Custom Lottes based tonemapper

      const float paper_white = cb0_003z * (200.f / 90.f);
      const float peak_white = 1.f;

      const float contrast = 1.25f;  // HDR = 1.75f, SDR = 1.25f
      const float shoulder = 0.13f;  // HDR = 0.13f, SDR = 0.13f?
      const float mid_in = 0.5f;     // HDR = 0.50f, SDR = 0.50f
      const float mid_out = 1.f;     // HDR = 1.25f, SDR = 1.00f
      const float offset = 0.f;      // HDR = 0.00f, SDR = 0.00f
      const float inv_ln2 = 1.f / log(2.f);
#if 1
      float _231 = abs(_20 * 0.009999999776482582f);
      float _233 = peak_white;
      float _243 = ((_233 - shoulder) * mid_in) / contrast;
      float _244 = _231 - shoulder;
      bool _247 = (shoulder > 9.999999747378752e-06f);
      float _248 = _231 / shoulder;
      float _259 = _233 - ((_243 * contrast) + shoulder);
      float _260 = (contrast * _233) / _259;
      float _269 = saturate(_248);
      float _273 = (_269 * _269) * (3.0f - (_269 * 2.0f));
      float _275 = _243 + shoulder;
      float _277 = select((_231 > _275), 1.0f, 0.0f);
      float _286 = abs(_21 * 0.009999999776482582f);
      float _287 = _286 - shoulder;
      float _290 = _286 / shoulder;
      float _306 = saturate(_290);
      float _310 = (_306 * _306) * (3.0f - (_306 * 2.0f));
      float _313 = select((_286 > _275), 1.0f, 0.0f);
      float _322 = abs(_22 * 0.009999999776482582f);
      float _323 = _322 - shoulder;
      float _326 = _322 / shoulder;
      float _342 = saturate(_326);
      float _346 = (_342 * _342) * (3.0f - (_342 * 2.0f));
      float _349 = select((_322 > _275), 1.0f, 0.0f);
      _359 = (((((_273 - _277) * ((_244 * contrast) + shoulder)) + ((_233 - ((exp2(((-0.0f - ((_244 - _243) * _260)) / _233) * inv_ln2)) * _259)) * _277)) + ((1.0f - _273) * (select(_247, (((exp2((log2(abs(_248)))*mid_out))*shoulder) + offset), offset)))));
      _360 = (((((_310 - _313) * ((_287 * contrast) + shoulder)) + ((_233 - ((exp2(((-0.0f - ((_287 - _243) * _260)) / _233) * inv_ln2)) * _259)) * _313)) + ((1.0f - _310) * (select(_247, (((exp2((log2(abs(_290)))*mid_out))*shoulder) + offset), offset)))));
      _361 = (((((_346 - _349) * ((_323 * contrast) + shoulder)) + ((_233 - ((exp2(((-0.0f - ((_323 - _243) * _260)) / _233) * inv_ln2)) * _259)) * _349)) + ((1.0f - _346) * (select(_247, (((exp2((log2(abs(_326)))*mid_out))*shoulder) + offset), offset)))));
#else

#endif
      _359 = renodx::color::correct::GammaSafe(_359);
      _360 = renodx::color::correct::GammaSafe(_360);
      _361 = renodx::color::correct::GammaSafe(_361);

      // _359 *= 100.0f;
      // _360 *= 100.0f;
      // _361 *= 100.0f;
      _359 *= paper_white;
      _360 *= paper_white;
      _361 *= paper_white;

      break;
    }
    default: {
      _359 = 0.0f;
      _360 = 0.0f;
      _361 = 0.0f;
      break;
    }
  }
  if (!((uint)(cb0_003x) == 0)) {
    float3 linear_color = float3(_359, _360, _361);
    float3 pq_color = renodx::color::pq::EncodeSafe(linear_color, (1.f));
    _455 = pq_color.x, _456 = pq_color.y, _457 = pq_color.z;
  } else {
    float _427 = saturate((mad(_361, -0.08325883746147156f, (mad(_360, -0.6217920184135437f, (_359 * 1.7050509452819824f))))) / cb0_003w);
    float _428 = saturate((mad(_361, -0.010548345744609833f, (mad(_360, 1.1408041715621948f, (_359 * -0.13025641441345215f))))) / cb0_003w);
    float _429 = saturate((mad(_361, 1.1529725790023804f, (mad(_360, -0.12896890938282013f, (_359 * -0.024003375321626663f))))) / cb0_003w);
    _455 = (select((_427 <= 0.0031308000907301903f), (_427 * 12.920000076293945f), (((exp2((log2(_427)) * 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f)));
    _456 = (select((_428 <= 0.0031308000907301903f), (_428 * 12.920000076293945f), (((exp2((log2(_428)) * 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f)));
    _457 = (select((_429 <= 0.0031308000907301903f), (_429 * 12.920000076293945f), (((exp2((log2(_429)) * 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f)));
  }
  u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = float4(_455, _456, _457, 1.0f);
}
