#include "../common.hlsli"

Texture2D<float4> t0 : register(t0);
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

cbuffer cb3 : register(b3) {
  float4 _LUTBlendCB_000 : packoffset(c000.x);
  float4 _LUTBlendCB_016 : packoffset(c001.x);
};

SamplerState s0 : register(s0);

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
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex
) {
  float _36;
  float _37;
  float _38;
  if (CUSTOM_INTERNAL_LUT_SHAPER == 0.f) {
  _36 = exp2((((_PostProcessCombineLUTsCB_000.z * (float((uint)SV_DispatchThreadID.x) + 0.5f)) + -0.015625f) * 14.45161247253418f) + -8.550177574157715f) + -0.002667719032615423f;
  _37 = exp2((((_PostProcessCombineLUTsCB_000.w * (float((uint)SV_DispatchThreadID.y) + 0.5f)) + -0.015625f) * 14.45161247253418f) + -8.550177574157715f) + -0.002667719032615423f;
  _38 = exp2((float((uint)SV_DispatchThreadID.z) * 0.4516128897666931f) + -8.550177574157715f) + -0.002667719032615423f;
  } else {
  _36 = ((_PostProcessCombineLUTsCB_000.z * (float((uint)SV_DispatchThreadID.x) + 0.5f)) + -0.015625f) * 1.03225803f;
  _37 = ((_PostProcessCombineLUTsCB_000.w * (float((uint)SV_DispatchThreadID.y) + 0.5f)) + -0.015625f) * 1.03225803f;
  _38 = float((uint)SV_DispatchThreadID.z) * 0.0322580636f;
  float3 decodedLutInput = lutShaper(float3(_36, _37, _38), true);
  _36 = decodedLutInput.x;
  _37 = decodedLutInput.y;
  _38 = decodedLutInput.z;
  }
  float _41 = mad(0.04737945273518562f, _38, mad(0.3395231366157532f, _37, (_36 * 0.6130974292755127f)));
  float _44 = mad(0.013452398590743542f, _38, mad(0.9163538813591003f, _37, (_36 * 0.07019372284412384f)));
  float _47 = mad(0.8698146343231201f, _38, mad(0.10956977307796478f, _37, (_36 * 0.0206155925989151f)));
  float _48 = dot(float3(_41, _44, _47), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _52 = (_41 / _48) + -1.0f;
  float _53 = (_44 / _48) + -1.0f;
  float _54 = (_47 / _48) + -1.0f;
  float _64 = (1.0f - exp2((_48 * _48) * (_ColorGradingCB_016.z * -4.0f))) * (1.0f - exp2(dot(float3(_52, _53, _54), float3(_52, _53, _54)) * -4.0f));
  float _80 = ((mad(-0.06368312239646912f, _47, mad(-0.3292921185493469f, _44, (_41 * 1.3704124689102173f))) - _41) * _64) + _41;
  float _81 = ((mad(-0.010861371643841267f, _47, mad(1.0970927476882935f, _44, (_41 * -0.08343351632356644f))) - _44) * _64) + _44;
  float _82 = ((mad(1.2036949396133423f, _47, mad(-0.0986257940530777f, _44, (_41 * -0.02579331584274769f))) - _47) * _64) + _47;
  float _87 = dot(float3(_80, _81, _82), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _101 = _ColorGradingCB_096.w + _ColorGradingCB_176.w;
  float _115 = _ColorGradingCB_080.w * _ColorGradingCB_160.w;
  float _129 = _ColorGradingCB_064.w * _ColorGradingCB_144.w;
  float _143 = _ColorGradingCB_048.w * _ColorGradingCB_128.w;
  float _154 = _ColorGradingCB_032.w * _ColorGradingCB_112.w;
  float _158 = _ColorGradingCB_032.x * (_80 - _87);
  float _161 = _ColorGradingCB_032.y * (_81 - _87);
  float _164 = _ColorGradingCB_032.z * (_82 - _87);
  float _219 = saturate(_87 / _ColorGradingCB_000.z);
  float _223 = (_219 * _219) * (3.0f - (_219 * 2.0f));
  float _224 = 1.0f - _223;
  float _233 = _ColorGradingCB_336.w + _ColorGradingCB_096.w;
  float _242 = _ColorGradingCB_320.w * _ColorGradingCB_080.w;
  float _251 = _ColorGradingCB_304.w * _ColorGradingCB_064.w;
  float _260 = _ColorGradingCB_288.w * _ColorGradingCB_048.w;
  float _266 = _ColorGradingCB_272.w * _ColorGradingCB_032.w;
  float _327 = saturate((_87 - _ColorGradingCB_000.w) / (_ColorGradingCB_016.x - _ColorGradingCB_000.w));
  float _331 = (_327 * _327) * (3.0f - (_327 * 2.0f));
  float _340 = _ColorGradingCB_256.w + _ColorGradingCB_096.w;
  float _349 = _ColorGradingCB_240.w * _ColorGradingCB_080.w;
  float _358 = _ColorGradingCB_224.w * _ColorGradingCB_064.w;
  float _367 = _ColorGradingCB_208.w * _ColorGradingCB_048.w;
  float _373 = _ColorGradingCB_192.w * _ColorGradingCB_032.w;
  float _431 = _223 - _331;
  float _442 = ((_331 * (((_ColorGradingCB_336.x + _ColorGradingCB_096.x) + _233) + (((_ColorGradingCB_320.x * _ColorGradingCB_080.x) * _242) * exp2(log2(exp2(((_ColorGradingCB_288.x * _ColorGradingCB_048.x) * _260) * log2(max(0.0f, (((_158 * _ColorGradingCB_272.x) * _266) + _87)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((_ColorGradingCB_304.x * _ColorGradingCB_064.x) * _251)))))) + (_224 * (((_ColorGradingCB_096.x + _ColorGradingCB_176.x) + _101) + (((_ColorGradingCB_080.x * _ColorGradingCB_160.x) * _115) * exp2(log2(exp2(((_ColorGradingCB_048.x * _ColorGradingCB_128.x) * _143) * log2(max(0.0f, (((_158 * _ColorGradingCB_112.x) * _154) + _87)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((_ColorGradingCB_064.x * _ColorGradingCB_144.x) * _129))))))) + ((((_ColorGradingCB_256.x + _ColorGradingCB_096.x) + _340) + (((_ColorGradingCB_240.x * _ColorGradingCB_080.x) * _349) * exp2(log2(exp2(((_ColorGradingCB_208.x * _ColorGradingCB_048.x) * _367) * log2(max(0.0f, (((_158 * _ColorGradingCB_192.x) * _373) + _87)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((_ColorGradingCB_224.x * _ColorGradingCB_064.x) * _358))))) * _431);
  float _444 = ((_331 * (((_ColorGradingCB_336.y + _ColorGradingCB_096.y) + _233) + (((_ColorGradingCB_320.y * _ColorGradingCB_080.y) * _242) * exp2(log2(exp2(((_ColorGradingCB_288.y * _ColorGradingCB_048.y) * _260) * log2(max(0.0f, (((_161 * _ColorGradingCB_272.y) * _266) + _87)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((_ColorGradingCB_304.y * _ColorGradingCB_064.y) * _251)))))) + (_224 * (((_ColorGradingCB_096.y + _ColorGradingCB_176.y) + _101) + (((_ColorGradingCB_080.y * _ColorGradingCB_160.y) * _115) * exp2(log2(exp2(((_ColorGradingCB_048.y * _ColorGradingCB_128.y) * _143) * log2(max(0.0f, (((_161 * _ColorGradingCB_112.y) * _154) + _87)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((_ColorGradingCB_064.y * _ColorGradingCB_144.y) * _129))))))) + ((((_ColorGradingCB_256.y + _ColorGradingCB_096.y) + _340) + (((_ColorGradingCB_240.y * _ColorGradingCB_080.y) * _349) * exp2(log2(exp2(((_ColorGradingCB_208.y * _ColorGradingCB_048.y) * _367) * log2(max(0.0f, (((_161 * _ColorGradingCB_192.y) * _373) + _87)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((_ColorGradingCB_224.y * _ColorGradingCB_064.y) * _358))))) * _431);
  float _446 = ((_331 * (((_ColorGradingCB_336.z + _ColorGradingCB_096.z) + _233) + (((_ColorGradingCB_320.z * _ColorGradingCB_080.z) * _242) * exp2(log2(exp2(((_ColorGradingCB_288.z * _ColorGradingCB_048.z) * _260) * log2(max(0.0f, (((_164 * _ColorGradingCB_272.z) * _266) + _87)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((_ColorGradingCB_304.z * _ColorGradingCB_064.z) * _251)))))) + (_224 * (((_ColorGradingCB_096.z + _ColorGradingCB_176.z) + _101) + (((_ColorGradingCB_080.z * _ColorGradingCB_160.z) * _115) * exp2(log2(exp2(((_ColorGradingCB_048.z * _ColorGradingCB_128.z) * _143) * log2(max(0.0f, (((_164 * _ColorGradingCB_112.z) * _154) + _87)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((_ColorGradingCB_064.z * _ColorGradingCB_144.z) * _129))))))) + ((((_ColorGradingCB_256.z + _ColorGradingCB_096.z) + _340) + (((_ColorGradingCB_240.z * _ColorGradingCB_080.z) * _349) * exp2(log2(exp2(((_ColorGradingCB_208.z * _ColorGradingCB_048.z) * _367) * log2(max(0.0f, (((_164 * _ColorGradingCB_192.z) * _373) + _87)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((_ColorGradingCB_224.z * _ColorGradingCB_064.z) * _358))))) * _431);
  float _460 = ((mad(0.06136061251163483f, _446, mad(-4.540197551250458e-09f, _444, (_442 * 0.9386393427848816f))) - _442) * _ColorGradingCB_016.y) + _442;
  float _461 = ((mad(0.169205904006958f, _446, mad(0.8307941555976868f, _444, (_442 * 6.984919309616089e-10f))) - _444) * _ColorGradingCB_016.y) + _444;
  float _462 = (mad(2.3283064365386963e-10f, _444, (_442 * -9.313225746154785e-10f)) * _ColorGradingCB_016.y) + _446;
  float _465 = mad(0.16386906802654266f, _462, mad(0.14067870378494263f, _461, (_460 * 0.6954522132873535f)));
  float _468 = mad(0.0955343171954155f, _462, mad(0.8596711158752441f, _461, (_460 * 0.044794563204050064f)));
  float _471 = mad(1.0015007257461548f, _462, mad(0.004025210160762072f, _461, (_460 * -0.005525882821530104f)));
  // RRT start
  float _475 = max(max(_465, _468), _471);
  float _480 = (max(_475, 1.000000013351432e-10f) - max(min(min(_465, _468), _471), 1.000000013351432e-10f)) / max(_475, 0.009999999776482582f);
  float _493 = ((_468 + _465) + _471) + (sqrt((((_471 - _468) * _471) + ((_468 - _465) * _468)) + ((_465 - _471) * _465)) * 1.75f);
  float _494 = _493 * 0.3333333432674408f;
  float _495 = _480 + -0.4000000059604645f;
  float _496 = _495 * 5.0f;
  float _500 = max((1.0f - abs(_495 * 2.5f)), 0.0f);
  float _511 = ((float((int)(((int)(uint)((bool)(_496 > 0.0f))) - ((int)(uint)((bool)(_496 < 0.0f))))) * (1.0f - (_500 * _500))) + 1.0f) * 0.02500000037252903f;
  float _520;
  float _553;
  float _567;
  float _632;
  if (!(_494 <= 0.0533333346247673f)) {
    if (!(_494 >= 0.1599999964237213f)) {
      _520 = (((0.23999999463558197f / _493) + -0.5f) * _511);
    } else {
      _520 = 0.0f;
    }
  } else {
    _520 = _511;
  }
  float _521 = _520 + 1.0f;
  float _522 = _521 * _465;
  float _523 = _521 * _468;
  float _524 = _521 * _471;
  if (!((bool)(_522 == _523) && (bool)(_523 == _524))) {
    float _531 = ((_522 * 2.0f) - _523) - _524;
    float _534 = ((_468 - _471) * 1.7320507764816284f) * _521;
    float _536 = atan(_534 / _531);
    bool _539 = (_531 < 0.0f);
    bool _540 = (_531 == 0.0f);
    bool _541 = (_534 >= 0.0f);
    bool _542 = (_534 < 0.0f);
    _553 = select((_541 && _540), 90.0f, select((_542 && _540), -90.0f, (select((_542 && _539), (_536 + -3.1415927410125732f), select((_541 && _539), (_536 + 3.1415927410125732f), _536)) * 57.2957763671875f)));
  } else {
    _553 = 0.0f;
  }
  float _558 = min(max(select((_553 < 0.0f), (_553 + 360.0f), _553), 0.0f), 360.0f);
  if (_558 < -180.0f) {
    _567 = (_558 + 360.0f);
  } else {
    if (_558 > 180.0f) {
      _567 = (_558 + -360.0f);
    } else {
      _567 = _558;
    }
  }
  float _571 = saturate(1.0f - abs(_567 * 0.014814814552664757f));
  float _573 = 3.0f - (_571 * 2.0f);
  float _575 = _571 * _571;
  float _582 = (((_573 * _573) * ((_480 * 0.18000000715255737f) * (0.029999999329447746f - _522))) * (_575 * _575)) + _522;
  float _592 = max(0.0f, mad(-0.21492856740951538f, _524, mad(-0.2365107536315918f, _523, (_582 * 1.4514392614364624f))));
  float _593 = max(0.0f, mad(-0.09967592358589172f, _524, mad(1.17622971534729f, _523, (_582 * -0.07655377686023712f))));
  float _594 = max(0.0f, mad(0.9977163076400757f, _524, mad(-0.006032449658960104f, _523, (_582 * 0.008316148072481155f))));
  float _595 = dot(float3(_592, _593, _594), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _609 = (_FilmTonemappingCB_012 + 1.0f) - _FilmTonemappingCB_004;  // Black Clip / Toe
  float _612 = _FilmTonemappingCB_016 + 1.0f; // White Clip
  float _614 = _612 - _FilmTonemappingCB_008;   // Shoulder
  if (_FilmTonemappingCB_004 > 0.800000011920929f) {
    _632 = (((0.8199999928474426f - _FilmTonemappingCB_004) / _FilmTonemappingCB_000) + -0.7447274923324585f);
  } else {
    float _623 = (_FilmTonemappingCB_012 + 0.18000000715255737f) / _609;
    _632 = (-0.7447274923324585f - ((log2(_623 / (2.0f - _623)) * 0.3465735912322998f) * (_609 / _FilmTonemappingCB_000)));
  }
  float _635 = ((1.0f - _FilmTonemappingCB_004) / _FilmTonemappingCB_000) - _632; // Toe / Slope
  float _637 = (_FilmTonemappingCB_008 / _FilmTonemappingCB_000) - _635;
  float _641 = lerp(_595, _592, 0.9599999785423279f);
  float _642 = lerp(_595, _593, 0.9599999785423279f);
  float _643 = lerp(_595, _594, 0.9599999785423279f);
  float3 RRTresult = float3(_641, _642, _643);
  // RRT End
  _641 = log2(_641) * 0.3010300099849701f;
  _642 = log2(_642) * 0.3010300099849701f;
  _643 = log2(_643) * 0.3010300099849701f;
  float _647 = (_641 + _635) * _FilmTonemappingCB_000;
  float _648 = (_642 + _635) * _FilmTonemappingCB_000;
  float _649 = (_643 + _635) * _FilmTonemappingCB_000;
  float _650 = -0.0f - _FilmTonemappingCB_012;
  float _651 = _609 * 2.0f;
  float _654 = _641 - _632;
  float _655 = _642 - _632;
  float _656 = _643 - _632;
  float _657 = ((_FilmTonemappingCB_000 * -2.0f) / _609) * 1.4426950216293335f;
  float _670 = _614 * 2.0f;
  float _676 = ((_FilmTonemappingCB_000 * 2.0f) / _614) * 1.4426950216293335f;
  float _701 = ((_650 - _647) + (_651 / (exp2(_657 * _654) + 1.0f))) * float((bool)(bool)(_641 < _632));
  float _702 = ((_650 - _648) + (_651 / (exp2(_657 * _655) + 1.0f))) * float((bool)(bool)(_642 < _632));
  float _703 = ((_650 - _649) + (_651 / (exp2(_657 * _656) + 1.0f))) * float((bool)(bool)(_643 < _632));
  float _722 = _637 - _632;
  float _726 = saturate(_654 / _722);
  float _727 = saturate(_655 / _722);
  float _728 = saturate(_656 / _722);
  bool _729 = (_637 < _632);
  float _733 = select(_729, (1.0f - _726), _726);
  float _734 = select(_729, (1.0f - _727), _727);
  float _735 = select(_729, (1.0f - _728), _728);
  float _754 = (_701 + _647) + (((_733 * _733) * ((((_612 - _647) - (_670 / (exp2(_676 * (_641 - _637)) + 1.0f))) * float((bool)(bool)(_641 > _637))) - _701)) * (3.0f - (_733 * 2.0f)));
  float _755 = (_702 + _648) + (((_734 * _734) * ((((_612 - _648) - (_670 / (exp2(_676 * (_642 - _637)) + 1.0f))) * float((bool)(bool)(_642 > _637))) - _702)) * (3.0f - (_734 * 2.0f)));
  float _756 = (_703 + _649) + (((_735 * _735) * ((((_612 - _649) - (_670 / (exp2(_676 * (_643 - _637)) + 1.0f))) * float((bool)(bool)(_643 > _637))) - _703)) * (3.0f - (_735 * 2.0f)));
  float3 sdrTonemappedAp1 = float3(_754, _755, _756);
  float _757 = dot(float3(_754, _755, _756), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _776 = ((max(0.0f, (lerp(_757, _754, 0.9300000071525574f))) - _460) * _ColorGradingCB_016.w) + _460;
  float _777 = ((max(0.0f, (lerp(_757, _755, 0.9300000071525574f))) - _461) * _ColorGradingCB_016.w) + _461;
  float _778 = ((max(0.0f, (lerp(_757, _756, 0.9300000071525574f))) - _462) * _ColorGradingCB_016.w) + _462;
  float _794 = ((mad(-0.06537103652954102f, _778, mad(1.4667166396975517e-06f, _777, (_776 * 1.0653746128082275f))) - _776) * _ColorGradingCB_016.y) + _776;
  float _795 = ((mad(-0.20366773009300232f, _778, mad(1.2036634683609009f, _777, (_776 * -3.3905962482094765e-07f))) - _777) * _ColorGradingCB_016.y) + _777;
  float _796 = ((mad(0.9999996423721313f, _778, mad(2.1886080503463745e-08f, _777, (_776 * 1.862645149230957e-08f))) - _778) * _ColorGradingCB_016.y) + _778;
  float _809 = max(0.0f, mad(-0.08325886726379395f, _796, mad(-0.6217920184135437f, _795, (_794 * 1.7050509452819824f))));
  float _810 = max(0.0f, mad(-0.010548318736255169f, _796, mad(1.140804648399353f, _795, (_794 * -0.13025641441345215f))));
  float _811 = max(0.0f, mad(1.1529723405838013f, _796, mad(-0.1289689689874649f, _795, (_794 * -0.024003352969884872f))));
  float3 sdrTonemappedBt709 = float3(_809, _810, _811);
  if (RENODX_TONE_MAP_TYPE == 0.f) {
  } else if (RENODX_TONE_MAP_TYPE == 1.f) {
    _776 = _460;
    _777 = _461;
    _778 = _462;
    _794 = ((mad(-0.06537103652954102f, _778, mad(1.4667166396975517e-06f, _777, (_776 * 1.0653746128082275f))) - _776) * _ColorGradingCB_016.y) + _776;
    _795 = ((mad(-0.20366773009300232f, _778, mad(1.2036634683609009f, _777, (_776 * -3.3905962482094765e-07f))) - _777) * _ColorGradingCB_016.y) + _777;
    _796 = ((mad(0.9999996423721313f, _778, mad(2.1886080503463745e-08f, _777, (_776 * 1.862645149230957e-08f))) - _778) * _ColorGradingCB_016.y) + _778;
    _809 = mad(-0.08325886726379395f, _796, mad(-0.6217920184135437f, _795, (_794 * 1.7050509452819824f)));
    _810 = mad(-0.010548318736255169f, _796, mad(1.140804648399353f, _795, (_794 * -0.13025641441345215f)));
    _811 = mad(1.1529723405838013f, _796, mad(-0.1289689689874649f, _795, (_794 * -0.024003352969884872f)));
  } else {
    float3 extendedTonemapAp1 = unrealengine::filmtonemap::extended::ApplyToneCurveExtended(RRTresult, sdrTonemappedAp1, _FilmTonemappingCB_000, _FilmTonemappingCB_004, _FilmTonemappingCB_008, _FilmTonemappingCB_012, _FilmTonemappingCB_016);
    float _754 = extendedTonemapAp1.x;
    float _755 = extendedTonemapAp1.y;
    float _756 = extendedTonemapAp1.z;
    float _757 = dot(float3(_754, _755, _756), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
    float _776 = ((max(0.0f, (lerp(_757, _754, 0.9300000071525574f))) - _460) * _ColorGradingCB_016.w) + _460;
    float _777 = ((max(0.0f, (lerp(_757, _755, 0.9300000071525574f))) - _461) * _ColorGradingCB_016.w) + _461;
    float _778 = ((max(0.0f, (lerp(_757, _756, 0.9300000071525574f))) - _462) * _ColorGradingCB_016.w) + _462;
    float _794 = ((mad(-0.06537103652954102f, _778, mad(1.4667166396975517e-06f, _777, (_776 * 1.0653746128082275f))) - _776) * _ColorGradingCB_016.y) + _776;
    float _795 = ((mad(-0.20366773009300232f, _778, mad(1.2036634683609009f, _777, (_776 * -3.3905962482094765e-07f))) - _777) * _ColorGradingCB_016.y) + _777;
    float _796 = ((mad(0.9999996423721313f, _778, mad(2.1886080503463745e-08f, _777, (_776 * 1.862645149230957e-08f))) - _778) * _ColorGradingCB_016.y) + _778;
    _809 = mad(-0.08325886726379395f, _796, mad(-0.6217920184135437f, _795, (_794 * 1.7050509452819824f)));
    _810 = mad(-0.010548318736255169f, _796, mad(1.140804648399353f, _795, (_794 * -0.13025641441345215f)));
    _811 = mad(1.1529723405838013f, _796, mad(-0.1289689689874649f, _795, (_794 * -0.024003352969884872f)));
    float3 extendedTonemapBt709 = float3(_809, _810, _811);
    extendedTonemapBt709 = CorrectHueAndChrominanceOKLAB(extendedTonemapBt709, sdrTonemappedBt709, RENODX_TONE_MAP_SDRIFY, RENODX_TONE_MAP_SDRIFY);
    _809 = extendedTonemapBt709.x;
    _810 = extendedTonemapBt709.y;
    _811 = extendedTonemapBt709.z;
  }
  float3 preLUT = float3(_809, _810, _811);
  float3 lutInput = preLUT;
  float compression_scale;
  float max_channel_scale;
  GamutCompression(lutInput, compression_scale);
  NeutwoMaxCh(lutInput, max_channel_scale);
  //float3(_809, _810, _811) = saturate((_809, _810, _811));
  _809 = saturate(lutInput.x);
  _810 = saturate(lutInput.y);
  _811 = saturate(lutInput.z);
    float _830 = (exp2(log2(abs(_809)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f;
    float _831 = (exp2(log2(abs(_810)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f;
    float _832 = (exp2(log2(abs(_811)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f;
    float _845 = (((_809 * 12.920000076293945f) - _830) * float((bool)(bool)(_809 <= 0.0031308000907301903f))) + _830;
    float _846 = (((_810 * 12.920000076293945f) - _831) * float((bool)(bool)(_810 <= 0.0031308000907301903f))) + _831;
    float _847 = (((_811 * 12.920000076293945f) - _832) * float((bool)(bool)(_811 <= 0.0031308000907301903f))) + _832;
    float _856 = _847 * 15.0f;
    float _857 = floor(_856);
    float _858 = _856 - _857;
    float _861 = ((_857 + 0.03125f) + (_845 * 0.9375f)) * 0.0625f;
    float _862 = 0.96875f - (_846 * 0.9375f);
    float4 _863 = t0.SampleLevel(s0, float2(_861, _862), 0.0f);
    float4 _868 = t0.SampleLevel(s0, float2((_861 + 0.0625f), _862), 0.0f);
    float _884 = ((lerp(_863.x, _868.x, _858)) * _LUTBlendCB_000.y) + (_845 * _LUTBlendCB_000.x);
    float _885 = ((lerp(_863.y, _868.y, _858)) * _LUTBlendCB_000.y) + (_846 * _LUTBlendCB_000.x);
    float _886 = ((lerp(_863.z, _868.z, _858)) * _LUTBlendCB_000.y) + (_847 * _LUTBlendCB_000.x);
    /*float _905 = exp2(log2(abs((_884 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f);
    float _906 = exp2(log2(abs((_885 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f);
    float _907 = exp2(log2(abs((_886 + 0.054999999701976776f) * 0.9478673338890076f)) * 2.4000000953674316f);
    float _920 = (float((bool)(bool)(_884 <= 0.040449999272823334f)) * ((_884 * 0.07739938050508499f) - _905)) + _905;
    float _921 = (((_885 * 0.07739938050508499f) - _906) * float((bool)(bool)(_885 <= 0.040449999272823334f))) + _906;
    float _922 = (((_886 * 0.07739938050508499f) - _907) * float((bool)(bool)(_886 <= 0.040449999272823334f))) + _907;*/

    float3 postLUT = renodx::color::srgb::DecodeSafe(float3(_884, _885, _886));
    NeutwoMaxChInverse(postLUT, max_channel_scale);
    GamutDecompression(postLUT, compression_scale);
    //float3(_920, _921, _922) = lerp(preLUT, float3(_920, _921, _922), CUSTOM_USER_LUT_STRENGTH);
    float _920 = lerp(preLUT.x, postLUT.x, CUSTOM_USER_LUT_STRENGTH);
    float _921 = lerp(preLUT.y, postLUT.y, CUSTOM_USER_LUT_STRENGTH);
    float _922 = lerp(preLUT.z, postLUT.z, CUSTOM_USER_LUT_STRENGTH);
    /*float3 signs = sign(float3(_920, _921, _922));
    float _941 = (exp2(log2(abs(_920)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f;
    float _942 = (exp2(log2(abs(_921)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f;
    float _943 = (exp2(log2(abs(_922)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f;*/
    //u7[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = signs * float3((((((_920 * 12.920000076293945f) - _941) * float((bool)(bool)(_920 <= 0.0031308000907301903f))) + _941) * 0.9523810148239136f), (((((_921 * 12.920000076293945f) - _942) * float((bool)(bool)(_921 <= 0.0031308000907301903f))) + _942) * 0.9523810148239136f), (((((_922 * 12.920000076293945f) - _943) * float((bool)(bool)(_922 <= 0.0031308000907301903f))) + _943) * 0.9523810148239136f));
    u7[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = renodx::color::srgb::EncodeSafe(float3(_920, _921, _922)) * 0.9523810148239136f;
}
