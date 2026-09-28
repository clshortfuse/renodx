#include "../common.hlsli"

RWTexture3D<float3> u7 : register(u7);

cbuffer cb0 : register(b0) {
  float4 _ColorGradingCB_000 : packoffset(c000.x);
  float4 _ColorGradingCB_016 : packoffset(c001.x);
  float4 _ColorGradingCB_032 : packoffset(c002.x);
  float4 _ColorGradingCB_048 : packoffset(c003.x);
  float4 _ColorGradingCB_064 : packoffset(c004.x);
  float4 _ColorGradingCB_080 : packoffset(c005.x);
  float4 _ColorGradingCB_096 : packoffset(c006.x);
  float4 _ColorGradingCB_112 : packoffset(c007.x);
  float4 _ColorGradingCB_128 : packoffset(c008.x);
  float4 _ColorGradingCB_144 : packoffset(c009.x);
  float4 _ColorGradingCB_160 : packoffset(c010.x);
  float4 _ColorGradingCB_176 : packoffset(c011.x);
  float4 _ColorGradingCB_192 : packoffset(c012.x);
  float4 _ColorGradingCB_208 : packoffset(c013.x);
  float4 _ColorGradingCB_224 : packoffset(c014.x);
  float4 _ColorGradingCB_240 : packoffset(c015.x);
  float4 _ColorGradingCB_256 : packoffset(c016.x);
  float4 _ColorGradingCB_272 : packoffset(c017.x);
  float4 _ColorGradingCB_288 : packoffset(c018.x);
  float4 _ColorGradingCB_304 : packoffset(c019.x);
  float4 _ColorGradingCB_320 : packoffset(c020.x);
  float4 _ColorGradingCB_336 : packoffset(c021.x);
  float4 _ColorGradingCB_352 : packoffset(c022.x);
  float4 _ColorGradingCB_368 : packoffset(c023.x);
  float4 _ColorGradingCB_384 : packoffset(c024.x);
  float4 _ColorGradingCB_400 : packoffset(c025.x);
  int _ColorGradingCB_416 : packoffset(c026.x);
  int _ColorGradingCB_420 : packoffset(c026.y);
  int _ColorGradingCB_424 : packoffset(c026.z);
  int _ColorGradingCB_428 : packoffset(c026.w);
};

cbuffer cb1 : register(b1) {
  float _FilmTonemappingCB_000 : packoffset(c000.x);
  float _FilmTonemappingCB_004 : packoffset(c000.y);
  float _FilmTonemappingCB_008 : packoffset(c000.z);
  float _FilmTonemappingCB_012 : packoffset(c000.w);
  float _FilmTonemappingCB_016 : packoffset(c001.x);
  float _FilmTonemappingCB_020 : packoffset(c001.y);
  float _FilmTonemappingCB_024 : packoffset(c001.z);
  float _FilmTonemappingCB_028 : packoffset(c001.w);
};

cbuffer cb2 : register(b2) {
  float4 _PostProcessCombineLUTsCB_000 : packoffset(c000.x);
};

namespace unrealengine {

namespace filmtonemap {

struct Config {
  // UE parameters
  float FilmSlope;
  float FilmToe;
  float FilmShoulder;
  float FilmBlackClip;
  float FilmWhiteClip;

  // Derived values
  float toe_width;
  float shoulder_width;

  float log_toe_threshold;
  float log_mid_anchor;
  float log_shoulder_threshold;
};

namespace config {

Config Create(
    float FilmSlope,
    float FilmToe,
    float FilmShoulder,
    float FilmBlackClip,
    float FilmWhiteClip) {
  Config p;
  p.FilmSlope = FilmSlope;
  p.FilmToe = FilmToe;
  p.FilmShoulder = FilmShoulder;
  p.FilmBlackClip = FilmBlackClip;
  p.FilmWhiteClip = FilmWhiteClip;

  p.toe_width = (FilmBlackClip + 1.0f) - FilmToe;
  p.shoulder_width = (FilmWhiteClip + 1.0f) - FilmShoulder;
  if (FilmToe > 0.8) {
    p.log_toe_threshold = (((0.82 - FilmToe) / FilmSlope) - 0.7447274923324585f);
  } else {
    float toe_norm = (FilmBlackClip + 0.18) / p.toe_width;
    p.log_toe_threshold = (-0.7447274923324585f - ((log2(toe_norm / (2.0f - toe_norm)) * 0.3465735912322998f) * (p.toe_width / FilmSlope)));
  }

  p.log_mid_anchor = ((1.0f - FilmToe) / FilmSlope) - p.log_toe_threshold;
  p.log_shoulder_threshold = (FilmShoulder / FilmSlope) - p.log_mid_anchor;

  return p;
}

}  // config

#define FILMTONECURVE_GENERATOR(T)                                                                                                                                                      \
  T ApplyToneCurve(T untonemapped, const Config p) {                                                                                                                                    \
    T untonemapped_log = log2(untonemapped) * 0.3010300099849701f;                                                                                                                      \
                                                                                                                                                                                        \
    /* Straight */                                                                                                                                                                      \
    T straight_curve = p.FilmSlope * (untonemapped_log + p.log_mid_anchor);                                                                                                             \
                                                                                                                                                                                        \
    /* Construct Toe and blend with Straight */                                                                                                                                         \
    T toe_offset = untonemapped_log - p.log_toe_threshold;                                                                                                                              \
    T toe_curve =                                                                                                                                                                       \
        renodx::math::Select((untonemapped_log < p.log_toe_threshold),                                                                                                                  \
                             (((p.toe_width * 2.f) / (exp2((toe_offset * 1.4426950216293335f) * ((p.FilmSlope * -2.f) / p.toe_width)) + 1.f)) - p.FilmBlackClip),                       \
                             straight_curve);                                                                                                                                           \
                                                                                                                                                                                        \
    /* Construct Shoulder and blend with Straight */                                                                                                                                    \
    T shoulder_offset = untonemapped_log - p.log_shoulder_threshold;                                                                                                                    \
    T shoulder_curve =                                                                                                                                                                  \
        renodx::math::Select((untonemapped_log > p.log_shoulder_threshold),                                                                                                             \
                             ((1.f + p.FilmWhiteClip) - ((p.shoulder_width * 2.f) / (exp2((shoulder_offset * 1.4426950216293335f) * ((p.FilmSlope * 2.f) / p.shoulder_width)) + 1.f))), \
                             straight_curve);                                                                                                                                           \
                                                                                                                                                                                        \
    /* Blend between Toe and Shoulder */                                                                                                                                                \
    T t_linear = saturate(toe_offset / (p.log_shoulder_threshold - p.log_toe_threshold));                                                                                               \
    T t_blend = renodx::math::Select((p.log_shoulder_threshold < p.log_toe_threshold), (1.f - t_linear), t_linear);                                                                     \
    T film_tonemapped = (((t_blend * t_blend) * (shoulder_curve - toe_curve)) * (3.f - (t_blend * 2.f))) + toe_curve;                                                                   \
                                                                                                                                                                                        \
    return film_tonemapped;                                                                                                                                                             \
  }
FILMTONECURVE_GENERATOR(float)
FILMTONECURVE_GENERATOR(float3)
#undef FILMTONECURVE_GENERATOR

float3 ApplyToneCurve(
    float3 untonemapped,
    float FilmSlope, float FilmToe, float FilmShoulder, float FilmBlackClip, float FilmWhiteClip) {
  unrealengine::filmtonemap::Config filmic_params = config::Create(FilmSlope, FilmToe, FilmShoulder, FilmBlackClip, FilmWhiteClip);
  return ApplyToneCurve(untonemapped, filmic_params);
}

namespace extended {

float ComputeFilmicSlopeAtInput(const Config p, float x) {
  // Scale epsilon with x so it works for very small or big inputs
  float eps = max(x * (1.0f / 1024.0f), 1e-5f);

  float y_minus = ApplyToneCurve(x - eps, p);
  float y_plus = ApplyToneCurve(x + eps, p);

  return (y_plus - y_minus) / (2.0f * eps);
}

#define FILMTONECURVE_EXTENDED_GENERATOR(T)                                             \
  T ApplyToneCurveExtended(T untonemapped, T vanilla, const Config p) {                 \
    /* Evaluate Filmic at pivot */                                                      \
    float pivot_input = 0.18f; /* tonemapper is centered around 0.18*/                  \
    float y_offset = 0.18f;                                                             \
    float pivot_slope = ComputeFilmicSlopeAtInput(p, pivot_input);                      \
                                                                                        \
    /* Linear HDR tail anchored at (pivot_input, pivot_output) */                       \
    T extended_tail = pivot_slope * (untonemapped - pivot_input) + y_offset;            \
                                                                                        \
    /* use vanilla below pivot, extended after*/                                        \
    return renodx::math::Select(untonemapped < (T)pivot_input, vanilla, extended_tail); \
  }
FILMTONECURVE_EXTENDED_GENERATOR(float)
FILMTONECURVE_EXTENDED_GENERATOR(float3)
#undef FILMTONECURVE_EXTENDED_GENERATOR

float3 ApplyToneCurveExtended(
    float3 untonemapped,
    float FilmSlope, float FilmToe, float FilmShoulder, float FilmBlackClip, float FilmWhiteClip) {
  unrealengine::filmtonemap::Config filmic_params = config::Create(FilmSlope, FilmToe, FilmShoulder, FilmBlackClip, FilmWhiteClip);
  float3 vanilla = unrealengine::filmtonemap::ApplyToneCurve(untonemapped, filmic_params);
  return ApplyToneCurveExtended(untonemapped, vanilla, filmic_params);
}

float3 ApplyToneCurveExtended(
    float3 untonemapped, float3 vanilla,
    float FilmSlope, float FilmToe, float FilmShoulder, float FilmBlackClip, float FilmWhiteClip) {
  unrealengine::filmtonemap::Config filmic_params = config::Create(FilmSlope, FilmToe, FilmShoulder, FilmBlackClip, FilmWhiteClip);
  return ApplyToneCurveExtended(untonemapped, vanilla, filmic_params);
}

}  // extended

}  // filmtonemap

}  // unrealengine

[numthreads(8, 8, 8)]
void main(
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
  float _33;
  float _34;
  float _35;
  if (CUSTOM_INTERNAL_LUT_SHAPER == 0.f) {
  _33 = exp2((((_PostProcessCombineLUTsCB_000.z * (float((uint)SV_DispatchThreadID.x) + 0.5f)) + -0.015625f) * 14.45161247253418f) + -8.550177574157715f) + -0.002667719032615423f;
  _34 = exp2((((_PostProcessCombineLUTsCB_000.w * (float((uint)SV_DispatchThreadID.y) + 0.5f)) + -0.015625f) * 14.45161247253418f) + -8.550177574157715f) + -0.002667719032615423f;
  _35 = exp2((float((uint)SV_DispatchThreadID.z) * 0.4516128897666931f) + -8.550177574157715f) + -0.002667719032615423f;
  } else {
    _33 = ((_PostProcessCombineLUTsCB_000.z * (float((uint)SV_DispatchThreadID.x) + 0.5f)) + -0.015625f) * 1.03225803f;
    _34 = ((_PostProcessCombineLUTsCB_000.w * (float((uint)SV_DispatchThreadID.y) + 0.5f)) + -0.015625f) * 1.03225803f;
    _35 = float((uint)SV_DispatchThreadID.z) * 0.0322580636f;
    float3 decodedLutInput = lutShaper(float3(_33, _34, _35), true);
    _33 = decodedLutInput.x;
    _34 = decodedLutInput.y;
    _35 = decodedLutInput.z;
  }
  // BT709 to AP1
  float _38 = mad(0.04737945273518562f, _35, mad(0.3395231366157532f, _34, (_33 * 0.6130974292755127f)));
  float _41 = mad(0.013452398590743542f, _35, mad(0.9163538813591003f, _34, (_33 * 0.07019372284412384f)));
  float _44 = mad(0.8698146343231201f, _35, mad(0.10956977307796478f, _34, (_33 * 0.0206155925989151f)));
  float _45 = dot(float3(_38, _41, _44), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _49 = (_38 / _45) + -1.0f;
  float _50 = (_41 / _45) + -1.0f;
  float _51 = (_44 / _45) + -1.0f;
  float _61 = (1.0f - exp2((_45 * _45) * (_ColorGradingCB_016.z * -4.0f))) * (1.0f - exp2(dot(float3(_49, _50, _51), float3(_49, _50, _51)) * -4.0f));
  // some other matrix
  float _77 = ((mad(-0.06368312239646912f, _44, mad(-0.3292921185493469f, _41, (_38 * 1.3704124689102173f))) - _38) * _61) + _38;
  float _78 = ((mad(-0.010861371643841267f, _44, mad(1.0970927476882935f, _41, (_38 * -0.08343351632356644f))) - _41) * _61) + _41;
  float _79 = ((mad(1.2036949396133423f, _44, mad(-0.0986257940530777f, _41, (_38 * -0.02579331584274769f))) - _44) * _61) + _44;
  _77 = lerp(_38, _77, CUSTOM_INTERNAL_LUT_STRENGTH);
  _78 = lerp(_41, _78, CUSTOM_INTERNAL_LUT_STRENGTH);
  _79 = lerp(_44, _79, CUSTOM_INTERNAL_LUT_STRENGTH);
  // blue correct
  float _93 = ((mad(0.06136061251163483f, _79, mad(-4.540197551250458e-09f, _78, (_77 * 0.9386393427848816f))) - _77) * _ColorGradingCB_016.y) + _77;
  float _94 = ((mad(0.169205904006958f, _79, mad(0.8307941555976868f, _78, (_77 * 6.984919309616089e-10f))) - _78) * _ColorGradingCB_016.y) + _78;
  float _95 = (mad(2.3283064365386963e-10f, _78, (_77 * -9.313225746154785e-10f)) * _ColorGradingCB_016.y) + _79;
  // AP1 to AP0
  float _98 = mad(0.16386906802654266f, _95, mad(0.14067870378494263f, _94, (_93 * 0.6954522132873535f)));
  float _101 = mad(0.0955343171954155f, _95, mad(0.8596711158752441f, _94, (_93 * 0.044794563204050064f)));
  float _104 = mad(1.0015007257461548f, _95, mad(0.004025210160762072f, _94, (_93 * -0.005525882821530104f)));
  // RRT
  float _108 = max(max(_98, _101), _104);
  float _113 = (max(_108, 1.000000013351432e-10f) - max(min(min(_98, _101), _104), 1.000000013351432e-10f)) / max(_108, 0.009999999776482582f);
  float _126 = ((_101 + _98) + _104) + (sqrt((((_104 - _101) * _104) + ((_101 - _98) * _101)) + ((_98 - _104) * _98)) * 1.75f);
  float _127 = _126 * 0.3333333432674408f;
  float _128 = _113 + -0.4000000059604645f;
  float _129 = _128 * 5.0f;
  float _133 = max((1.0f - abs(_128 * 2.5f)), 0.0f);
  float _144 = ((float((int)(((int)(uint)((bool)(_129 > 0.0f))) - ((int)(uint)((bool)(_129 < 0.0f))))) * (1.0f - (_133 * _133))) + 1.0f) * 0.02500000037252903f;
  float _153;
  float _186;
  float _200;
  float _265;
  if (!(_127 <= 0.0533333346247673f)) {
    if (!(_127 >= 0.1599999964237213f)) {
      _153 = (((0.23999999463558197f / _126) + -0.5f) * _144);
    } else {
      _153 = 0.0f;
    }
  } else {
    _153 = _144;
  }
  float _154 = _153 + 1.0f;
  float _155 = _154 * _98;
  float _156 = _154 * _101;
  float _157 = _154 * _104;
  if (!((bool)(_155 == _156) && (bool)(_156 == _157))) {
    float _164 = ((_155 * 2.0f) - _156) - _157;
    float _167 = ((_101 - _104) * 1.7320507764816284f) * _154;
    float _169 = atan(_167 / _164);
    bool _172 = (_164 < 0.0f);
    bool _173 = (_164 == 0.0f);
    bool _174 = (_167 >= 0.0f);
    bool _175 = (_167 < 0.0f);
    _186 = select((_174 && _173), 90.0f, select((_175 && _173), -90.0f, (select((_175 && _172), (_169 + -3.1415927410125732f), select((_174 && _172), (_169 + 3.1415927410125732f), _169)) * 57.2957763671875f)));
  } else {
    _186 = 0.0f;
  }
  float _191 = min(max(select((_186 < 0.0f), (_186 + 360.0f), _186), 0.0f), 360.0f);
  if (_191 < -180.0f) {
    _200 = (_191 + 360.0f);
  } else {
    if (_191 > 180.0f) {
      _200 = (_191 + -360.0f);
    } else {
      _200 = _191;
    }
  }
  float _204 = saturate(1.0f - abs(_200 * 0.014814814552664757f));
  float _206 = 3.0f - (_204 * 2.0f);
  float _208 = _204 * _204;
  float _215 = (((_206 * _206) * ((_113 * 0.18000000715255737f) * (0.029999999329447746f - _155))) * (_208 * _208)) + _155;
  float _225 = max(0.0f, mad(-0.21492856740951538f, _157, mad(-0.2365107536315918f, _156, (_215 * 1.4514392614364624f))));
  float _226 = max(0.0f, mad(-0.09967592358589172f, _157, mad(1.17622971534729f, _156, (_215 * -0.07655377686023712f))));
  float _227 = max(0.0f, mad(0.9977163076400757f, _157, mad(-0.006032449658960104f, _156, (_215 * 0.008316148072481155f))));
  float _228 = dot(float3(_225, _226, _227), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _242 = (_FilmTonemappingCB_012 + 1.0f) - _FilmTonemappingCB_004;
  float _245 = _FilmTonemappingCB_016 + 1.0f;
  float _247 = _245 - _FilmTonemappingCB_008;
  if (_FilmTonemappingCB_004 > 0.800000011920929f) {
    _265 = (((0.8199999928474426f - _FilmTonemappingCB_004) / _FilmTonemappingCB_000) + -0.7447274923324585f);
  } else {
    float _256 = (_FilmTonemappingCB_012 + 0.18000000715255737f) / _242;
    _265 = (-0.7447274923324585f - ((log2(_256 / (2.0f - _256)) * 0.3465735912322998f) * (_242 / _FilmTonemappingCB_000)));
  }
  float _268 = ((1.0f - _FilmTonemappingCB_004) / _FilmTonemappingCB_000) - _265;
  float _270 = (_FilmTonemappingCB_008 / _FilmTonemappingCB_000) - _268;
  float _274 = lerp(_228, _225, 0.9599999785423279f);
  float _275 = lerp(_228, _226, 0.9599999785423279f);
  float _276 = lerp(_228, _227, 0.9599999785423279f);
  float3 RRTresult = float3(_274, _275, _276);
  // RRT End
  _274 = log2(_274) * 0.3010300099849701f;
  _275 = log2(_275) * 0.3010300099849701f;
  _276 = log2(_276) * 0.3010300099849701f;
  float _280 = (_274 + _268) * _FilmTonemappingCB_000;
  float _281 = (_275 + _268) * _FilmTonemappingCB_000;
  float _282 = (_276 + _268) * _FilmTonemappingCB_000;
  float _283 = -0.0f - _FilmTonemappingCB_012;
  float _284 = _242 * 2.0f;
  float _287 = _274 - _265;
  float _288 = _275 - _265;
  float _289 = _276 - _265;
  float _290 = ((_FilmTonemappingCB_000 * -2.0f) / _242) * 1.4426950216293335f;
  float _303 = _247 * 2.0f;
  float _309 = ((_FilmTonemappingCB_000 * 2.0f) / _247) * 1.4426950216293335f;
  float _334 = ((_283 - _280) + (_284 / (exp2(_290 * _287) + 1.0f))) * float((bool)(bool)(_274 < _265));
  float _335 = ((_283 - _281) + (_284 / (exp2(_290 * _288) + 1.0f))) * float((bool)(bool)(_275 < _265));
  float _336 = ((_283 - _282) + (_284 / (exp2(_290 * _289) + 1.0f))) * float((bool)(bool)(_276 < _265));
  float _355 = _270 - _265;
  float _359 = saturate(_287 / _355);
  float _360 = saturate(_288 / _355);
  float _361 = saturate(_289 / _355);
  bool _362 = (_270 < _265);
  float _366 = select(_362, (1.0f - _359), _359);
  float _367 = select(_362, (1.0f - _360), _360);
  float _368 = select(_362, (1.0f - _361), _361);
  float _387 = (_334 + _280) + (((_366 * _366) * ((((_245 - _280) - (_303 / (exp2(_309 * (_274 - _270)) + 1.0f))) * float((bool)(bool)(_274 > _270))) - _334)) * (3.0f - (_366 * 2.0f)));
  float _388 = (_335 + _281) + (((_367 * _367) * ((((_245 - _281) - (_303 / (exp2(_309 * (_275 - _270)) + 1.0f))) * float((bool)(bool)(_275 > _270))) - _335)) * (3.0f - (_367 * 2.0f)));
  float _389 = (_336 + _282) + (((_368 * _368) * ((((_245 - _282) - (_303 / (exp2(_309 * (_276 - _270)) + 1.0f))) * float((bool)(bool)(_276 > _270))) - _336)) * (3.0f - (_368 * 2.0f)));
  float3 sdrTonemappedAp1 = float3(_387, _388, _389);
  float _390 = dot(float3(_387, _388, _389), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _409 = ((max(0.0f, (lerp(_390, _387, 0.9300000071525574f))) - _93) * _ColorGradingCB_016.w) + _93;
  float _410 = ((max(0.0f, (lerp(_390, _388, 0.9300000071525574f))) - _94) * _ColorGradingCB_016.w) + _94;
  float _411 = ((max(0.0f, (lerp(_390, _389, 0.9300000071525574f))) - _95) * _ColorGradingCB_016.w) + _95;
  float _427 = ((mad(-0.06537103652954102f, _411, mad(1.4667166396975517e-06f, _410, (_409 * 1.0653746128082275f))) - _409) * _ColorGradingCB_016.y) + _409;
  float _428 = ((mad(-0.20366773009300232f, _411, mad(1.2036634683609009f, _410, (_409 * -3.3905962482094765e-07f))) - _410) * _ColorGradingCB_016.y) + _410;
  float _429 = ((mad(0.9999996423721313f, _411, mad(2.1886080503463745e-08f, _410, (_409 * 1.862645149230957e-08f))) - _411) * _ColorGradingCB_016.y) + _411;
  float _439 = max(0.0f, mad(-0.08325886726379395f, _429, mad(-0.6217920184135437f, _428, (_427 * 1.7050509452819824f))));
  float _440 = max(0.0f, mad(-0.010548318736255169f, _429, mad(1.140804648399353f, _428, (_427 * -0.13025641441345215f))));
  float _441 = max(0.0f, mad(1.1529723405838013f, _429, mad(-0.1289689689874649f, _428, (_427 * -0.024003352969884872f))));
  float3 sdrTonemappedBt709 = float3(_439, _440, _441);
  if (RENODX_TONE_MAP_TYPE == 0.f) {
  } else if (RENODX_TONE_MAP_TYPE == 1.f) {
    _427 = _77;
    _428 = _78;
    _429 = _79;
  _439 = max(0.0f, mad(-0.08325886726379395f, _429, mad(-0.6217920184135437f, _428, (_427 * 1.7050509452819824f))));
  _440 = max(0.0f, mad(-0.010548318736255169f, _429, mad(1.140804648399353f, _428, (_427 * -0.13025641441345215f))));
  _441 = max(0.0f, mad(1.1529723405838013f, _429, mad(-0.1289689689874649f, _428, (_427 * -0.024003352969884872f))));
  } else {
    float3 extendedTonemapAp1 = unrealengine::filmtonemap::extended::ApplyToneCurveExtended(RRTresult, sdrTonemappedAp1, _FilmTonemappingCB_000, _FilmTonemappingCB_004, _FilmTonemappingCB_008, _FilmTonemappingCB_012, _FilmTonemappingCB_016);
    _387 = extendedTonemapAp1.x;
    _388 = extendedTonemapAp1.y;
    _389 = extendedTonemapAp1.z;
    _390 = dot(float3(_387, _388, _389), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
    _409 = ((max(0.0f, (lerp(_390, _387, 0.9300000071525574f))) - _93) * _ColorGradingCB_016.w) + _93;
    _410 = ((max(0.0f, (lerp(_390, _388, 0.9300000071525574f))) - _94) * _ColorGradingCB_016.w) + _94;
    _411 = ((max(0.0f, (lerp(_390, _389, 0.9300000071525574f))) - _95) * _ColorGradingCB_016.w) + _95;
    _427 = ((mad(-0.06537103652954102f, _411, mad(1.4667166396975517e-06f, _410, (_409 * 1.0653746128082275f))) - _409) * _ColorGradingCB_016.y) + _409;
    _428 = ((mad(-0.20366773009300232f, _411, mad(1.2036634683609009f, _410, (_409 * -3.3905962482094765e-07f))) - _410) * _ColorGradingCB_016.y) + _410;
    _429 = ((mad(0.9999996423721313f, _411, mad(2.1886080503463745e-08f, _410, (_409 * 1.862645149230957e-08f))) - _411) * _ColorGradingCB_016.y) + _411;
    _439 = mad(-0.08325886726379395f, _429, mad(-0.6217920184135437f, _428, (_427 * 1.7050509452819824f)));
    _440 = mad(-0.010548318736255169f, _429, mad(1.140804648399353f, _428, (_427 * -0.13025641441345215f)));
    _441 = mad(1.1529723405838013f, _429, mad(-0.1289689689874649f, _428, (_427 * -0.024003352969884872f)));
    float3 extendedTonemapBt709 = float3(_439, _440, _441);
    extendedTonemapBt709 = CorrectHueAndChrominanceOKLAB(extendedTonemapBt709, sdrTonemappedBt709, RENODX_TONE_MAP_SDRIFY, RENODX_TONE_MAP_SDRIFY);
    _439 = extendedTonemapBt709.x;
    _440 = extendedTonemapBt709.y;
    _441 = extendedTonemapBt709.z;
  }
  u7[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = renodx::color::srgb::EncodeSafe(float3(_439, _440, _441)) * 0.9523810148239136f;
}
