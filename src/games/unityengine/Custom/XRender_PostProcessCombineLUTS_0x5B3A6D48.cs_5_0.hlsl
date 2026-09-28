#include "../common.hlsli"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
RWTexture3D<float4> u7 : register(u7);
cbuffer cb3 : register(b3){
  float4 cb3[1];
}
cbuffer cb2 : register(b2){
  float4 cb2[1];
}
cbuffer cb1 : register(b1){
  float4 cb1[2];
}
cbuffer cb0 : register(b0){
  float4 cb0[22];
}

#define cmp -

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
void main(uint3 vThreadID: SV_DispatchThreadID) {
  float4 r0,r1,r2,r3,r4,r5,r6,r7;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = (uint3)vThreadID.xyz;
  r0.xy = float2(0.5,0.5) + r0.xy;
  r0.xy = r0.xy * cb2[0].zw + float2(-0.015625,-0.015625);
  r1.xyz = float3(1.03225803,1.03225803,0.0322580636) * r0.xyz;
  if(CUSTOM_INTERNAL_LUT_SHAPER == 0.f){
  r0.xyz = float3(-0.434017599,-0.434017599,-0.434017599) + r1.xyz;
  r0.xyz = r0.xyz * float3(14,14,14) + float3(-2.47393107,-2.47393107,-2.47393107);
  r0.xyz = exp2(r0.xyz);
  r0.xyz = float3(-0.00266771903, -0.00266771903, -0.00266771903) + r0.xyz;
  } else {
    r0.xyz = lutShaper(r1.xyz, true);
  }
  // BT709 to AP1
  r1.x = dot(float3(0.613097429,0.339523137,0.0473794527), r0.xyz);
  r1.y = dot(float3(0.0701937228,0.916353881,0.0134523986), r0.xyz);
  r1.z = dot(float3(0.0206155926,0.109569773,0.869814634), r0.xyz);
  float3 preGradingAp1 = r1.xyz;
  // some other matrix
  r0.x = dot(float3(1.37041235,-0.329292119,-0.0636831149), r1.xyz);
  r0.y = dot(float3(-0.0834334865,1.09709263,-0.0108613791), r1.xyz);
  r0.z = dot(float3(-0.0257933177,-0.0986257941,1.20369494), r1.xyz);
  r0.xyz = r0.xyz + -r1.xyz;
  r0.w = dot(r1.xyz, float3(0.272228718,0.674081743,0.0536895171));
  r2.xyz = r1.xyz / r0.www;
  r0.w = r0.w * r0.w;
  r0.w = cb0[1].z * r0.w;
  r0.w = -4 * r0.w;
  r0.w = exp2(r0.w);
  r0.w = 1 + -r0.w;
  r2.xyz = float3(-1,-1,-1) + r2.xyz;
  r1.w = dot(r2.xyz, r2.xyz);
  r1.w = -4 * r1.w;
  r1.w = exp2(r1.w);
  r1.w = 1 + -r1.w;
  r0.w = r1.w * r0.w;
  r0.xyz = r0.www * r0.xyz + r1.xyz;
  r0.w = dot(r0.xyz, float3(0.272228718,0.674081743,0.0536895171));
  r0.xyz = r0.xyz + -r0.www;
  r1.xyzw = cb0[12].xyzw * cb0[2].xyzw;
  r1.xyz = r1.xyz * r1.www;
  r1.xyz = r1.xyz * r0.xyz + r0.www;
  r1.xyz = max(float3(0,0,0), r1.xyz);
  r1.xyz = float3(5.55555534,5.55555534,5.55555534) * r1.xyz;
  r1.xyz = log2(r1.xyz);
  r2.xyzw = cb0[13].xyzw * cb0[3].xyzw;
  r2.xyz = r2.xyz * r2.www;
  r1.xyz = r2.xyz * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.xyz = float3(0.180000007,0.180000007,0.180000007) * r1.xyz;
  r1.xyz = log2(r1.xyz);
  r2.xyzw = cb0[14].xyzw * cb0[4].xyzw;
  r2.xyz = r2.xyz * r2.www;
  r2.xyz = float3(1,1,1) / r2.xyz;
  r1.xyz = r2.xyz * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r2.xyzw = cb0[15].xyzw * cb0[5].xyzw;
  r2.xyz = r2.xyz * r2.www;
  r3.xyzw = cb0[16].xyzw + cb0[6].xyzw;
  r3.xyz = r3.xyz + r3.www;
  r1.xyz = r1.xyz * r2.xyz + r3.xyz;
  r1.w = 1 / cb0[0].z;
  r1.w = saturate(r1.w * r0.w);
  r2.x = r1.w * -2 + 3;
  r1.w = r1.w * r1.w;
  r1.w = -r2.x * r1.w + 1;
  r2.x = 1 + -r1.w;
  r2.y = -cb0[0].w + r0.w;
  r2.z = cb0[1].x + -cb0[0].w;
  r2.z = 1 / r2.z;
  r2.y = saturate(r2.y * r2.z);
  r2.z = r2.y * -2 + 3;
  r2.y = r2.y * r2.y;
  r2.x = -r2.z * r2.y + r2.x;
  r2.y = r2.z * r2.y;
  r1.xyz = r2.xxx * r1.xyz;
  r3.xyzw = cb0[7].xyzw * cb0[2].xyzw;
  r2.xzw = r3.xyz * r3.www;
  r2.xzw = r2.xzw * r0.xyz + r0.www;
  r2.xzw = max(float3(0,0,0), r2.xzw);
  r2.xzw = float3(5.55555534,5.55555534,5.55555534) * r2.xzw;
  r2.xzw = log2(r2.xzw);
  r3.xyzw = cb0[8].xyzw * cb0[3].xyzw;
  r3.xyz = r3.xyz * r3.www;
  r2.xzw = r3.xyz * r2.xzw;
  r2.xzw = exp2(r2.xzw);
  r2.xzw = float3(0.180000007,0.180000007,0.180000007) * r2.xzw;
  r2.xzw = log2(r2.xzw);
  r3.xyzw = cb0[9].xyzw * cb0[4].xyzw;
  r3.xyz = r3.xyz * r3.www;
  r3.xyz = float3(1,1,1) / r3.xyz;
  r2.xzw = r3.xyz * r2.xzw;
  r2.xzw = exp2(r2.xzw);
  r3.xyzw = cb0[10].xyzw * cb0[5].xyzw;
  r3.xyz = r3.xyz * r3.www;
  r4.xyzw = cb0[11].xyzw + cb0[6].xyzw;
  r4.xyz = r4.xyz + r4.www;
  r2.xzw = r2.xzw * r3.xyz + r4.xyz;
  r1.xyz = r2.xzw * r1.www + r1.xyz;
  r3.xyzw = cb0[17].xyzw * cb0[2].xyzw;
  r2.xzw = r3.xyz * r3.www;
  r0.xyz = r2.xzw * r0.xyz + r0.www;
  r0.xyz = max(float3(0,0,0), r0.xyz);
  r0.xyz = float3(5.55555534,5.55555534,5.55555534) * r0.xyz;
  r0.xyz = log2(r0.xyz);
  r3.xyzw = cb0[18].xyzw * cb0[3].xyzw;
  r2.xzw = r3.xyz * r3.www;
  r0.xyz = r2.xzw * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = float3(0.180000007,0.180000007,0.180000007) * r0.xyz;
  r0.xyz = log2(r0.xyz);
  r3.xyzw = cb0[19].xyzw * cb0[4].xyzw;
  r2.xzw = r3.xyz * r3.www;
  r2.xzw = float3(1,1,1) / r2.xzw;
  r0.xyz = r2.xzw * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r3.xyzw = cb0[20].xyzw * cb0[5].xyzw;
  r2.xzw = r3.xyz * r3.www;
  r3.xyzw = cb0[21].xyzw + cb0[6].xyzw;
  r3.xyz = r3.xyz + r3.www;
  r0.xyz = r0.xyz * r2.xzw + r3.xyz;
  r0.xyz = r0.xyz * r2.yyy + r1.xyz;
  r0.xyz = lerp(preGradingAp1, r0.xyz, CUSTOM_INTERNAL_LUT_STRENGTH);
  // Blue correct ?
  r1.x = dot(float3(0.938639402,5.86919541e-011,0.0613606237), r0.xyz);
  r1.y = dot(float3(1.34311572e-011,0.830794156,0.169205874), r0.xyz);
  r1.z = dot(float3(-2.80590065e-011,1.2291188e-011,1), r0.xyz);
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = cb0[1].yyy * r1.xyz + r0.xyz;
  float3 preRRTAp1 = r0.xyz;
  // AP1 to AP0
  r1.y = dot(float3(0.695452213,0.140678704,0.163869068), r0.xyz);
  r1.z = dot(float3(0.0447945632,0.859671116,0.0955343172), r0.xyz);
  r1.w = dot(float3(-0.00552588282, 0.00402521016, 1.00150073), r0.xyz);
  // RRT start
  r1.xyz = RRT(r1.yzw);
  float3 RRTresult = r1.xyz;
  // RRT end
  float3 sdrTonemappedAp1 = unrealengine::filmtonemap::ApplyToneCurve(r1.xyz, cb1[0].x, cb1[0].y, cb1[0].z, cb1[0].w, cb1[1].x);
  r1.xyz = sdrTonemappedAp1;
  r0.w = dot(r1.xyz, float3(0.272228718, 0.674081743, 0.0536895171));
  r1.xyz = r1.xyz + -r0.www;
  r1.xyz = r1.xyz * float3(0.930000007, 0.930000007, 0.930000007) + r0.www;
  r1.xyz = max(float3(0, 0, 0), r1.xyz);
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = cb0[1].www * r1.xyz + r0.xyz;
  r1.x = dot(float3(1.06537485, 1.44673368e-006, -0.0653710067), r0.xyz);
  r1.y = dot(float3(-3.4558721e-007, 1.20366347, -0.203667715), r0.xyz);
  r1.z = dot(float3(1.98354986e-008, 2.12240607e-008, 0.999999583), r0.xyz);
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = cb0[1].yyy * r1.xyz + r0.xyz;
  r1.x = dot(float3(1.70505095, -0.621792018, -0.0832588673), r0.xyz);
  r1.y = dot(float3(-0.130256414, 1.14080465, -0.0105483187), r0.xyz);
  r1.z = dot(float3(-0.024003353, -0.128968969, 1.15297234), r0.xyz);
  float3 sdrTonemappedBt709 = r1.xyz;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    r1.xyz = sdrTonemappedBt709;
  } else if (RENODX_TONE_MAP_TYPE == 1.f) {
    r0.xyz = preRRTAp1;
    r1.x = dot(float3(1.06537485, 1.44673368e-006, -0.0653710067), r0.xyz);
    r1.y = dot(float3(-3.4558721e-007, 1.20366347, -0.203667715), r0.xyz);
    r1.z = dot(float3(1.98354986e-008, 2.12240607e-008, 0.999999583), r0.xyz);
    r1.xyz = r1.xyz + -r0.xyz;
    r0.xyz = cb0[1].yyy * r1.xyz + r0.xyz;
    r1.x = dot(float3(1.70505095, -0.621792018, -0.0832588673), r0.xyz);
    r1.y = dot(float3(-0.130256414, 1.14080465, -0.0105483187), r0.xyz);
    r1.z = dot(float3(-0.024003353, -0.128968969, 1.15297234), r0.xyz);
  } else {
    // SDR
    r1.xyz = RRTresult;
    r0.xyz = preRRTAp1;
    r1.xyz = unrealengine::filmtonemap::extended::ApplyToneCurveExtended(r1.xyz, sdrTonemappedAp1, cb1[0].x, cb1[0].y, cb1[0].z, cb1[0].w, cb1[1].x);
    r0.w = dot(r1.xyz, float3(0.272228718, 0.674081743, 0.0536895171));
    r1.xyz = r1.xyz + -r0.www;
    r1.xyz = r1.xyz * float3(0.930000007, 0.930000007, 0.930000007) + r0.www;
    r1.xyz = max(float3(0, 0, 0), r1.xyz);
    r1.xyz = r1.xyz + -r0.xyz;
    r0.xyz = cb0[1].www * r1.xyz + r0.xyz;
    r1.x = dot(float3(1.06537485, 1.44673368e-006, -0.0653710067), r0.xyz);
    r1.y = dot(float3(-3.4558721e-007, 1.20366347, -0.203667715), r0.xyz);
    r1.z = dot(float3(1.98354986e-008, 2.12240607e-008, 0.999999583), r0.xyz);
    r1.xyz = r1.xyz + -r0.xyz;
    r0.xyz = cb0[1].yyy * r1.xyz + r0.xyz;
    r1.x = dot(float3(1.70505095, -0.621792018, -0.0832588673), r0.xyz);
    r1.y = dot(float3(-0.130256414, 1.14080465, -0.0105483187), r0.xyz);
    r1.z = dot(float3(-0.024003353, -0.128968969, 1.15297234), r0.xyz);
    r1.xyz = CorrectHueAndChrominanceOKLAB(r1.xyz, sdrTonemappedBt709, RENODX_TONE_MAP_SDRIFY, RENODX_TONE_MAP_SDRIFY);
  }
  float3 preLUT = r1.xyz;
  float compression_scale;
  float max_channel_scale;
  GamutCompression(r1.xyz, compression_scale);
  NeutwoMaxCh(r1.xyz, max_channel_scale);
  r0.xyzw = saturate(r1.xyzx);
  r1.xyzw = log2(r0.wyzw);
  r1.xyzw = float4(0.416666657,0.416666657,0.416666657,0.416666657) * r1.xyzw;
  r1.xyzw = exp2(r1.xyzw);
  r1.xyzw = r1.xyzw * float4(1.05499995,1.05499995,1.05499995,1.05499995) + float4(-0.0549999997,-0.0549999997,-0.0549999997,-0.0549999997);
  r2.xyzw = r0.wyzw * float4(12.9200001,12.9200001,12.9200001,12.9200001) + -r1.wyzw;
  r0.xyzw = cmp(float4(0.00313080009,0.00313080009,0.00313080009,0.00313080009) >= r0.xyzw);
  r0.xyzw = r0.xyzw ? float4(1,1,1,1) : 0;
  r0.xyzw = r0.xyzw * r2.xyzw + r1.xyzw;
  r1.xyz = r0.wyz * float3(0.9375,0.9375,0.9375) + float3(0.03125,0.03125,0.03125);
  r2.y = 1 + -r1.y;
  r1.y = r1.z * 16 + -0.5;
  r1.z = floor(r1.y);
  r1.y = r1.y + -r1.z;
  r1.x = r1.x + r1.z;
  r2.z = r1.x * 0.0625 + 0.0625;
  r2.x = 0.0625 * r1.x;
  r1.xzw = t0.SampleLevel(s0_s, r2.xy, 0).xyz;
  r2.xyz = t0.SampleLevel(s0_s, r2.zy, 0).xyz;
  r2.xyzw = r2.xyzx + -r1.xzwx;
  r1.xyzw = r1.yyyy * r2.xyzw + r1.xzwx;
  r1.xyzw = cb3[0].yyyy * r1.xyzw;
  r0.xyzw = cb3[0].xxxx * r0.xyzw + r1.xyzw;
  r0.xyzw = renodx::color::srgb::DecodeSafe(r0.xyzw);
  NeutwoMaxChInverse(r0.xyz, max_channel_scale);
  GamutDecompression(r0.xyz, compression_scale);
  r0.xyz = lerp(preLUT, r0.xyz, CUSTOM_USER_LUT_STRENGTH);
  r0.xyzw = renodx::color::srgb::EncodeSafe(r0.xyzx);
  r0.xyzw = float4(0.952381015,0.952381015,0.952381015,0.952381015) * r0.xyzw;
  u7[vThreadID] = r0;
  return;
}