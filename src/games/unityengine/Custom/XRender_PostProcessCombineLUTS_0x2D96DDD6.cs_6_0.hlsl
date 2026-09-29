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
  float _38 = mad(0.04737945273518562f, _35, mad(0.3395231366157532f, _34, (_33 * 0.6130974292755127f)));
  float _41 = mad(0.013452398590743542f, _35, mad(0.9163538813591003f, _34, (_33 * 0.07019372284412384f)));
  float _44 = mad(0.8698146343231201f, _35, mad(0.10956977307796478f, _34, (_33 * 0.0206155925989151f)));
  float _45 = dot(float3(_38, _41, _44), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _49 = (_38 / _45) + -1.0f;
  float _50 = (_41 / _45) + -1.0f;
  float _51 = (_44 / _45) + -1.0f;
  float _61 = (1.0f - exp2((_45 * _45) * (_ColorGradingCB_016.z * -4.0f))) * (1.0f - exp2(dot(float3(_49, _50, _51), float3(_49, _50, _51)) * -4.0f));
  float _77 = ((mad(-0.06368312239646912f, _44, mad(-0.3292921185493469f, _41, (_38 * 1.3704124689102173f))) - _38) * _61) + _38;
  float _78 = ((mad(-0.010861371643841267f, _44, mad(1.0970927476882935f, _41, (_38 * -0.08343351632356644f))) - _41) * _61) + _41;
  float _79 = ((mad(1.2036949396133423f, _44, mad(-0.0986257940530777f, _41, (_38 * -0.02579331584274769f))) - _44) * _61) + _44;
  float _84 = dot(float3(_77, _78, _79), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _98 = _ColorGradingCB_096.w + _ColorGradingCB_176.w;
  float _112 = _ColorGradingCB_080.w * _ColorGradingCB_160.w;
  float _126 = _ColorGradingCB_064.w * _ColorGradingCB_144.w;
  float _140 = _ColorGradingCB_048.w * _ColorGradingCB_128.w;
  float _151 = _ColorGradingCB_032.w * _ColorGradingCB_112.w;
  float _155 = _ColorGradingCB_032.x * (_77 - _84);
  float _158 = _ColorGradingCB_032.y * (_78 - _84);
  float _161 = _ColorGradingCB_032.z * (_79 - _84);
  float _216 = saturate(_84 / _ColorGradingCB_000.z);
  float _220 = (_216 * _216) * (3.0f - (_216 * 2.0f));
  float _221 = 1.0f - _220;
  float _230 = _ColorGradingCB_336.w + _ColorGradingCB_096.w;
  float _239 = _ColorGradingCB_320.w * _ColorGradingCB_080.w;
  float _248 = _ColorGradingCB_304.w * _ColorGradingCB_064.w;
  float _257 = _ColorGradingCB_288.w * _ColorGradingCB_048.w;
  float _263 = _ColorGradingCB_272.w * _ColorGradingCB_032.w;
  float _324 = saturate((_84 - _ColorGradingCB_000.w) / (_ColorGradingCB_016.x - _ColorGradingCB_000.w));
  float _328 = (_324 * _324) * (3.0f - (_324 * 2.0f));
  float _337 = _ColorGradingCB_256.w + _ColorGradingCB_096.w;
  float _346 = _ColorGradingCB_240.w * _ColorGradingCB_080.w;
  float _355 = _ColorGradingCB_224.w * _ColorGradingCB_064.w;
  float _364 = _ColorGradingCB_208.w * _ColorGradingCB_048.w;
  float _370 = _ColorGradingCB_192.w * _ColorGradingCB_032.w;
  float _428 = _220 - _328;
  float _439 = ((_328 * (((_ColorGradingCB_336.x + _ColorGradingCB_096.x) + _230) + (((_ColorGradingCB_320.x * _ColorGradingCB_080.x) * _239) * exp2(log2(exp2(((_ColorGradingCB_288.x * _ColorGradingCB_048.x) * _257) * log2(max(0.0f, (((_155 * _ColorGradingCB_272.x) * _263) + _84)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((_ColorGradingCB_304.x * _ColorGradingCB_064.x) * _248)))))) + (_221 * (((_ColorGradingCB_096.x + _ColorGradingCB_176.x) + _98) + (((_ColorGradingCB_080.x * _ColorGradingCB_160.x) * _112) * exp2(log2(exp2(((_ColorGradingCB_048.x * _ColorGradingCB_128.x) * _140) * log2(max(0.0f, (((_155 * _ColorGradingCB_112.x) * _151) + _84)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((_ColorGradingCB_064.x * _ColorGradingCB_144.x) * _126))))))) + ((((_ColorGradingCB_256.x + _ColorGradingCB_096.x) + _337) + (((_ColorGradingCB_240.x * _ColorGradingCB_080.x) * _346) * exp2(log2(exp2(((_ColorGradingCB_208.x * _ColorGradingCB_048.x) * _364) * log2(max(0.0f, (((_155 * _ColorGradingCB_192.x) * _370) + _84)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((_ColorGradingCB_224.x * _ColorGradingCB_064.x) * _355))))) * _428);
  float _441 = ((_328 * (((_ColorGradingCB_336.y + _ColorGradingCB_096.y) + _230) + (((_ColorGradingCB_320.y * _ColorGradingCB_080.y) * _239) * exp2(log2(exp2(((_ColorGradingCB_288.y * _ColorGradingCB_048.y) * _257) * log2(max(0.0f, (((_158 * _ColorGradingCB_272.y) * _263) + _84)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((_ColorGradingCB_304.y * _ColorGradingCB_064.y) * _248)))))) + (_221 * (((_ColorGradingCB_096.y + _ColorGradingCB_176.y) + _98) + (((_ColorGradingCB_080.y * _ColorGradingCB_160.y) * _112) * exp2(log2(exp2(((_ColorGradingCB_048.y * _ColorGradingCB_128.y) * _140) * log2(max(0.0f, (((_158 * _ColorGradingCB_112.y) * _151) + _84)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((_ColorGradingCB_064.y * _ColorGradingCB_144.y) * _126))))))) + ((((_ColorGradingCB_256.y + _ColorGradingCB_096.y) + _337) + (((_ColorGradingCB_240.y * _ColorGradingCB_080.y) * _346) * exp2(log2(exp2(((_ColorGradingCB_208.y * _ColorGradingCB_048.y) * _364) * log2(max(0.0f, (((_158 * _ColorGradingCB_192.y) * _370) + _84)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((_ColorGradingCB_224.y * _ColorGradingCB_064.y) * _355))))) * _428);
  float _443 = ((_328 * (((_ColorGradingCB_336.z + _ColorGradingCB_096.z) + _230) + (((_ColorGradingCB_320.z * _ColorGradingCB_080.z) * _239) * exp2(log2(exp2(((_ColorGradingCB_288.z * _ColorGradingCB_048.z) * _257) * log2(max(0.0f, (((_161 * _ColorGradingCB_272.z) * _263) + _84)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((_ColorGradingCB_304.z * _ColorGradingCB_064.z) * _248)))))) + (_221 * (((_ColorGradingCB_096.z + _ColorGradingCB_176.z) + _98) + (((_ColorGradingCB_080.z * _ColorGradingCB_160.z) * _112) * exp2(log2(exp2(((_ColorGradingCB_048.z * _ColorGradingCB_128.z) * _140) * log2(max(0.0f, (((_161 * _ColorGradingCB_112.z) * _151) + _84)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((_ColorGradingCB_064.z * _ColorGradingCB_144.z) * _126))))))) + ((((_ColorGradingCB_256.z + _ColorGradingCB_096.z) + _337) + (((_ColorGradingCB_240.z * _ColorGradingCB_080.z) * _346) * exp2(log2(exp2(((_ColorGradingCB_208.z * _ColorGradingCB_048.z) * _364) * log2(max(0.0f, (((_161 * _ColorGradingCB_192.z) * _370) + _84)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((_ColorGradingCB_224.z * _ColorGradingCB_064.z) * _355))))) * _428);
  _439 = lerp(_38, _439, CUSTOM_INTERNAL_LUT_STRENGTH);
  _441 = lerp(_41, _441, CUSTOM_INTERNAL_LUT_STRENGTH);
  _443 = lerp(_44, _443, CUSTOM_INTERNAL_LUT_STRENGTH);
  float _457 = ((mad(0.06136061251163483f, _443, mad(-4.540197551250458e-09f, _441, (_439 * 0.9386393427848816f))) - _439) * _ColorGradingCB_016.y) + _439;
  float _458 = ((mad(0.169205904006958f, _443, mad(0.8307941555976868f, _441, (_439 * 6.984919309616089e-10f))) - _441) * _ColorGradingCB_016.y) + _441;
  float _459 = (mad(2.3283064365386963e-10f, _441, (_439 * -9.313225746154785e-10f)) * _ColorGradingCB_016.y) + _443;
  float _462 = mad(0.16386906802654266f, _459, mad(0.14067870378494263f, _458, (_457 * 0.6954522132873535f)));
  float _465 = mad(0.0955343171954155f, _459, mad(0.8596711158752441f, _458, (_457 * 0.044794563204050064f)));
  float _468 = mad(1.0015007257461548f, _459, mad(0.004025210160762072f, _458, (_457 * -0.005525882821530104f)));
  // RRT start
  float _472 = max(max(_462, _465), _468);
  float _477 = (max(_472, 1.000000013351432e-10f) - max(min(min(_462, _465), _468), 1.000000013351432e-10f)) / max(_472, 0.009999999776482582f);
  float _490 = ((_465 + _462) + _468) + (sqrt((((_468 - _465) * _468) + ((_465 - _462) * _465)) + ((_462 - _468) * _462)) * 1.75f);
  float _491 = _490 * 0.3333333432674408f;
  float _492 = _477 + -0.4000000059604645f;
  float _493 = _492 * 5.0f;
  float _497 = max((1.0f - abs(_492 * 2.5f)), 0.0f);
  float _508 = ((float((int)(((int)(uint)((bool)(_493 > 0.0f))) - ((int)(uint)((bool)(_493 < 0.0f))))) * (1.0f - (_497 * _497))) + 1.0f) * 0.02500000037252903f;
  float _517;
  float _550;
  float _564;
  float _629;
  if (!(_491 <= 0.0533333346247673f)) {
    if (!(_491 >= 0.1599999964237213f)) {
      _517 = (((0.23999999463558197f / _490) + -0.5f) * _508);
    } else {
      _517 = 0.0f;
    }
  } else {
    _517 = _508;
  }
  float _518 = _517 + 1.0f;
  float _519 = _518 * _462;
  float _520 = _518 * _465;
  float _521 = _518 * _468;
  if (!((bool)(_519 == _520) && (bool)(_520 == _521))) {
    float _528 = ((_519 * 2.0f) - _520) - _521;
    float _531 = ((_465 - _468) * 1.7320507764816284f) * _518;
    float _533 = atan(_531 / _528);
    bool _536 = (_528 < 0.0f);
    bool _537 = (_528 == 0.0f);
    bool _538 = (_531 >= 0.0f);
    bool _539 = (_531 < 0.0f);
    _550 = select((_538 && _537), 90.0f, select((_539 && _537), -90.0f, (select((_539 && _536), (_533 + -3.1415927410125732f), select((_538 && _536), (_533 + 3.1415927410125732f), _533)) * 57.2957763671875f)));
  } else {
    _550 = 0.0f;
  }
  float _555 = min(max(select((_550 < 0.0f), (_550 + 360.0f), _550), 0.0f), 360.0f);
  if (_555 < -180.0f) {
    _564 = (_555 + 360.0f);
  } else {
    if (_555 > 180.0f) {
      _564 = (_555 + -360.0f);
    } else {
      _564 = _555;
    }
  }
  float _568 = saturate(1.0f - abs(_564 * 0.014814814552664757f));
  float _570 = 3.0f - (_568 * 2.0f);
  float _572 = _568 * _568;
  float _579 = (((_570 * _570) * ((_477 * 0.18000000715255737f) * (0.029999999329447746f - _519))) * (_572 * _572)) + _519;
  float _589 = max(0.0f, mad(-0.21492856740951538f, _521, mad(-0.2365107536315918f, _520, (_579 * 1.4514392614364624f))));
  float _590 = max(0.0f, mad(-0.09967592358589172f, _521, mad(1.17622971534729f, _520, (_579 * -0.07655377686023712f))));
  float _591 = max(0.0f, mad(0.9977163076400757f, _521, mad(-0.006032449658960104f, _520, (_579 * 0.008316148072481155f))));
  float _592 = dot(float3(_589, _590, _591), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _606 = (_FilmTonemappingCB_012 + 1.0f) - _FilmTonemappingCB_004;
  float _609 = _FilmTonemappingCB_016 + 1.0f;
  float _611 = _609 - _FilmTonemappingCB_008;
  if (_FilmTonemappingCB_004 > 0.800000011920929f) {
    _629 = (((0.8199999928474426f - _FilmTonemappingCB_004) / _FilmTonemappingCB_000) + -0.7447274923324585f);
  } else {
    float _620 = (_FilmTonemappingCB_012 + 0.18000000715255737f) / _606;
    _629 = (-0.7447274923324585f - ((log2(_620 / (2.0f - _620)) * 0.3465735912322998f) * (_606 / _FilmTonemappingCB_000)));
  }
  float _632 = ((1.0f - _FilmTonemappingCB_004) / _FilmTonemappingCB_000) - _629;
  float _634 = (_FilmTonemappingCB_008 / _FilmTonemappingCB_000) - _632;
  float _638 = lerp(_592, _589, 0.9599999785423279f);
  float _639 = lerp(_592, _590, 0.9599999785423279f);
  float _640 = lerp(_592, _591, 0.9599999785423279f);
  float3 RRTresult = float3(_638, _639, _640);
  _638 = log2(_638) * 0.3010300099849701f;
  _639 = log2(_639) * 0.3010300099849701f;
  _640 = log2(_640) * 0.3010300099849701f;
  float _644 = (_638 + _632) * _FilmTonemappingCB_000;
  float _645 = (_639 + _632) * _FilmTonemappingCB_000;
  float _646 = (_640 + _632) * _FilmTonemappingCB_000;
  float _647 = -0.0f - _FilmTonemappingCB_012;
  float _648 = _606 * 2.0f;
  float _651 = _638 - _629;
  float _652 = _639 - _629;
  float _653 = _640 - _629;
  float _654 = ((_FilmTonemappingCB_000 * -2.0f) / _606) * 1.4426950216293335f;
  float _667 = _611 * 2.0f;
  float _673 = ((_FilmTonemappingCB_000 * 2.0f) / _611) * 1.4426950216293335f;
  float _698 = ((_647 - _644) + (_648 / (exp2(_654 * _651) + 1.0f))) * float((bool)(bool)(_638 < _629));
  float _699 = ((_647 - _645) + (_648 / (exp2(_654 * _652) + 1.0f))) * float((bool)(bool)(_639 < _629));
  float _700 = ((_647 - _646) + (_648 / (exp2(_654 * _653) + 1.0f))) * float((bool)(bool)(_640 < _629));
  float _719 = _634 - _629;
  float _723 = saturate(_651 / _719);
  float _724 = saturate(_652 / _719);
  float _725 = saturate(_653 / _719);
  bool _726 = (_634 < _629);
  float _730 = select(_726, (1.0f - _723), _723);
  float _731 = select(_726, (1.0f - _724), _724);
  float _732 = select(_726, (1.0f - _725), _725);
  float _751 = (_698 + _644) + (((_730 * _730) * ((((_609 - _644) - (_667 / (exp2(_673 * (_638 - _634)) + 1.0f))) * float((bool)(bool)(_638 > _634))) - _698)) * (3.0f - (_730 * 2.0f)));
  float _752 = (_699 + _645) + (((_731 * _731) * ((((_609 - _645) - (_667 / (exp2(_673 * (_639 - _634)) + 1.0f))) * float((bool)(bool)(_639 > _634))) - _699)) * (3.0f - (_731 * 2.0f)));
  float _753 = (_700 + _646) + (((_732 * _732) * ((((_609 - _646) - (_667 / (exp2(_673 * (_640 - _634)) + 1.0f))) * float((bool)(bool)(_640 > _634))) - _700)) * (3.0f - (_732 * 2.0f)));
  float3 sdrTonemappedAp1 = float3(_751, _752, _753);
  float _754 = dot(float3(_751, _752, _753), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _773 = ((max(0.0f, (lerp(_754, _751, 0.9300000071525574f))) - _457) * _ColorGradingCB_016.w) + _457;
  float _774 = ((max(0.0f, (lerp(_754, _752, 0.9300000071525574f))) - _458) * _ColorGradingCB_016.w) + _458;
  float _775 = ((max(0.0f, (lerp(_754, _753, 0.9300000071525574f))) - _459) * _ColorGradingCB_016.w) + _459;
  float _791 = ((mad(-0.06537103652954102f, _775, mad(1.4667166396975517e-06f, _774, (_773 * 1.0653746128082275f))) - _773) * _ColorGradingCB_016.y) + _773;
  float _792 = ((mad(-0.20366773009300232f, _775, mad(1.2036634683609009f, _774, (_773 * -3.3905962482094765e-07f))) - _774) * _ColorGradingCB_016.y) + _774;
  float _793 = ((mad(0.9999996423721313f, _775, mad(2.1886080503463745e-08f, _774, (_773 * 1.862645149230957e-08f))) - _775) * _ColorGradingCB_016.y) + _775;
  float _803 = max(0.0f, mad(-0.08325886726379395f, _793, mad(-0.6217920184135437f, _792, (_791 * 1.7050509452819824f))));
  float _804 = max(0.0f, mad(-0.010548318736255169f, _793, mad(1.140804648399353f, _792, (_791 * -0.13025641441345215f))));
  float _805 = max(0.0f, mad(1.1529723405838013f, _793, mad(-0.1289689689874649f, _792, (_791 * -0.024003352969884872f))));
  float3 sdrTonemappedBt709 = float3(_803, _804, _805);
  if (RENODX_TONE_MAP_TYPE == 0.f) {
  } else if (RENODX_TONE_MAP_TYPE == 1.f) {
    _791 = _439;
    _792 = _441;
    _793 = _443;
    _803 = mad(-0.08325886726379395f, _793, mad(-0.6217920184135437f, _792, (_791 * 1.7050509452819824f)));
    _804 = mad(-0.010548318736255169f, _793, mad(1.140804648399353f, _792, (_791 * -0.13025641441345215f)));
    _805 = mad(1.1529723405838013f, _793, mad(-0.1289689689874649f, _792, (_791 * -0.024003352969884872f)));
  } else {
    float3 extendedTonemapAp1 = unrealengine::filmtonemap::extended::ApplyToneCurveExtended(RRTresult, sdrTonemappedAp1, _FilmTonemappingCB_000, _FilmTonemappingCB_004, _FilmTonemappingCB_008, _FilmTonemappingCB_012, _FilmTonemappingCB_016);
    _751 = extendedTonemapAp1.x;
    _752 = extendedTonemapAp1.y;
    _753 = extendedTonemapAp1.z;
    _754 = dot(float3(_751, _752, _753), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
    _773 = ((max(0.0f, (lerp(_754, _751, 0.9300000071525574f))) - _457) * _ColorGradingCB_016.w) + _457;
    _774 = ((max(0.0f, (lerp(_754, _752, 0.9300000071525574f))) - _458) * _ColorGradingCB_016.w) + _458;
    _775 = ((max(0.0f, (lerp(_754, _753, 0.9300000071525574f))) - _459) * _ColorGradingCB_016.w) + _459;
    _791 = ((mad(-0.06537103652954102f, _775, mad(1.4667166396975517e-06f, _774, (_773 * 1.0653746128082275f))) - _773) * _ColorGradingCB_016.y) + _773;
    _792 = ((mad(-0.20366773009300232f, _775, mad(1.2036634683609009f, _774, (_773 * -3.3905962482094765e-07f))) - _774) * _ColorGradingCB_016.y) + _774;
    _793 = ((mad(0.9999996423721313f, _775, mad(2.1886080503463745e-08f, _774, (_773 * 1.862645149230957e-08f))) - _775) * _ColorGradingCB_016.y) + _775;
    _803 = mad(-0.08325886726379395f, _793, mad(-0.6217920184135437f, _792, (_791 * 1.7050509452819824f)));
    _804 = mad(-0.010548318736255169f, _793, mad(1.140804648399353f, _792, (_791 * -0.13025641441345215f)));
    _805 = mad(1.1529723405838013f, _793, mad(-0.1289689689874649f, _792, (_791 * -0.024003352969884872f)));
    float3 extendedTonemapBt709 = float3(_803, _804, _805);
    extendedTonemapBt709 = CorrectHueAndChrominanceOKLAB(extendedTonemapBt709, sdrTonemappedBt709, RENODX_TONE_MAP_SDRIFY, RENODX_TONE_MAP_SDRIFY);
    _803 = extendedTonemapBt709.x;
    _804 = extendedTonemapBt709.y;
    _805 = extendedTonemapBt709.z;
  }
  u7[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = renodx::color::srgb::EncodeSafe(float3(_803, _804, _805)) * 0.9523810148239136f;
}
