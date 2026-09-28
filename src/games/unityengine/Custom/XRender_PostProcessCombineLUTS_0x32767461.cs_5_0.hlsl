#include "../common.hlsli"

RWTexture3D<float4> u7 : register(u7);
cbuffer cb2 : register(b2){
  float4 cb2[1];
}
cbuffer cb1 : register(b1){
  float4 cb1[2];
}
cbuffer cb0 : register(b0){
  float4 cb0[2];
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
  r0.xyz = lerp(preGradingAp1, r0.xyz, CUSTOM_INTERNAL_LUT_STRENGTH);
  // Blue correct ?
  r1.x = dot(float3(0.938639402,5.86919541e-011,0.0613606237), r0.xyz);
  r1.y = dot(float3(1.34311572e-011,0.830794156,0.169205874), r0.xyz);
  r1.z = dot(float3(-2.80590065e-011,1.2291188e-011,1), r0.xyz);
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = cb0[1].yyy * r1.xyz + r0.xyz;
  float3 preRRTAp1 = r0.xyz;
  r1.y = dot(float3(0.695452213,0.140678704,0.163869068), r0.xyz);
  r1.z = dot(float3(0.0447945632,0.859671116,0.0955343172), r0.xyz);
  r1.w = dot(float3(-0.00552588282,0.00402521016,1.00150073), r0.xyz);
  /*r2.xyz = r1.wzy + -r1.zyw;
  r2.xy = r2.xy * r1.wz;
  r0.w = r2.x + r2.y;
  r0.w = r1.y * r2.z + r0.w;
  r0.w = sqrt(r0.w);
  r1.x = r1.w + r1.z;
  r1.x = r1.x + r1.y;
  r0.w = r0.w * 1.75 + r1.x;
  r1.x = 0.333333343 * r0.w;
  r1.x = 0.0799999982 / r1.x;
  r1.x = -0.5 + r1.x;
  r2.x = min(r1.y, r1.z);
  r2.x = min(r2.x, r1.w);
  r2.y = max(r1.y, r1.z);
  r2.y = max(r2.y, r1.w);
  r2.xyz = max(float3(1.00000001e-010,1.00000001e-010,0.00999999978), r2.xyy);
  r2.x = r2.y + -r2.x;
  r2.x = r2.x / r2.z;
  r2.y = -0.400000006 + r2.x;
  r2.z = cmp(0 < r2.y);
  r2.w = cmp(r2.y < 0);
  r2.y = 2.5 * r2.y;
  r2.y = 1 + -abs(r2.y);
  r2.y = max(0, r2.y);
  r2.y = -r2.y * r2.y + 1;
  r2.z = (int)-r2.z + (int)r2.w;
  r2.z = (int)r2.z;
  r2.y = r2.z * r2.y + 1;
  r2.y = 0.0250000004 * r2.y;
  r1.x = r2.y * r1.x;
  r2.z = cmp(r0.w >= 0.479999989);
  r0.w = cmp(0.159999996 >= r0.w);
  r1.x = r2.z ? 0 : r1.x;
  r0.w = r0.w ? r2.y : r1.x;
  r0.w = 1 + r0.w;
  r3.yzw = r1.yzw * r0.www;
  r1.x = -r1.y * r0.w + 0.0299999993;
  r1.y = r1.z * r0.w + -r3.w;
  r1.y = 1.73205078 * r1.y;
  r1.z = r3.y * 2 + -r3.z;
  r0.w = -r1.w * r0.w + r1.z;
  r1.z = max(abs(r1.y), abs(r0.w));
  r1.z = 1 / r1.z;
  r1.w = min(abs(r1.y), abs(r0.w));
  r1.z = r1.w * r1.z;
  r1.w = r1.z * r1.z;
  r2.y = r1.w * 0.0208350997 + -0.0851330012;
  r2.y = r1.w * r2.y + 0.180141002;
  r2.y = r1.w * r2.y + -0.330299497;
  r1.w = r1.w * r2.y + 0.999866009;
  r2.y = r1.z * r1.w;
  r2.y = r2.y * -2 + 1.57079637;
  r2.z = cmp(abs(r0.w) < abs(r1.y));
  r2.y = r2.z ? r2.y : 0;
  r1.z = r1.z * r1.w + r2.y;
  r1.w = cmp(r0.w < -r0.w);
  r1.w = r1.w ? -3.141593 : 0;
  r1.z = r1.z + r1.w;
  r1.w = min(r1.y, r0.w);
  r0.w = max(r1.y, r0.w);
  r0.w = cmp(r0.w >= -r0.w);
  r1.y = cmp(r1.w < -r1.w);
  r0.w = r0.w ? r1.y : 0;
  r0.w = r0.w ? -r1.z : r1.z;
  r0.w = 57.2957802 * r0.w;
  r1.yz = cmp(r3.zw == r3.yz);
  r1.y = r1.z ? r1.y : 0;
  r0.w = r1.y ? 0 : r0.w;
  r1.y = cmp(r0.w < 0);
  r1.z = 360 + r0.w;
  r0.w = r1.y ? r1.z : r0.w;
  r0.w = max(0, r0.w);
  r0.w = min(360, r0.w);
  r1.y = cmp(180 < r0.w);
  r1.z = -360 + r0.w;
  r0.w = r1.y ? r1.z : r0.w;
  r0.w = 0.0148148146 * r0.w;
  r0.w = 1 + -abs(r0.w);
  r0.w = max(0, r0.w);
  r1.y = r0.w * -2 + 3;
  r0.w = r0.w * r0.w;
  r0.w = r1.y * r0.w;
  r0.w = r0.w * r0.w;
  r0.w = r0.w * r2.x;
  r0.w = r0.w * r1.x;
  r3.x = r0.w * 0.180000007 + r3.y;
  r1.x = dot(float3(1.45143926,-0.236510754,-0.214928567), r3.xzw);
  r1.y = dot(float3(-0.0765537769,1.17622972,-0.0996759236), r3.xzw);
  r1.z = dot(float3(0.00831614807,-0.00603244966,0.997716308), r3.xzw);
  r1.xyz = max(float3(0,0,0), r1.xyz);
  r0.w = dot(r1.xyz, float3(0.272228718,0.674081743,0.0536895171));
  r1.xyz = r1.xyz + -r0.www;
  r1.xyz = r1.xyz * float3(0.959999979,0.959999979,0.959999979) + r0.www;*/
  r1.xyz = RRT(r1.yzw);
  float3 RRTresult = r1.xyz;
  /*r1.xyz = log2(r1.xyz);
  r2.xy = float2(1,0.180000007) + cb1[0].ww;
  r0.w = -cb1[0].y + r2.x;
  r1.w = r2.y / r0.w;
  r2.x = -1 + r1.w;
  r2.x = 1 + -r2.x;
  r1.w = r1.w / r2.x;
  r1.w = log2(r1.w);
  r1.w = 0.346573591 * r1.w;
  r2.x = r0.w / cb1[0].x;
  r1.w = -r1.w * r2.x + -0.744727492;
  r2.x = cmp(0.800000012 < cb1[0].y);
  r2.yz = float2(0.819999993,1) + -cb1[0].yy;
  r2.yz = r2.yz / cb1[0].xx;
  r2.y = -0.744727492 + r2.y;
  r1.w = r2.x ? r2.y : r1.w;
  r2.xyw = r1.xyz * float3(0.30103001,0.30103001,0.30103001) + -r1.www;
  r3.x = -2 * cb1[0].x;
  r3.x = r3.x / r0.w;
  r0.w = r0.w + r0.w;
  r3.xyz = r3.xxx * r2.xyw;
  r3.xyz = float3(1.44269502,1.44269502,1.44269502) * r3.xyz;
  r3.xyz = exp2(r3.xyz);
  r3.xyz = float3(1,1,1) + r3.xyz;
  r3.xyz = r0.www / r3.xyz;
  r3.xyz = -cb1[0].www + r3.xyz;
  r0.w = r2.z + -r1.w;
  r4.xyz = r1.xyz * float3(0.30103001,0.30103001,0.30103001) + r0.www;
  r3.xyz = -cb1[0].xxx * r4.xyz + r3.xyz;
  r5.xyz = float3(0.30103001,0.30103001,0.30103001) * r1.xyz;
  r6.xyz = cmp(r5.xyz < r1.www);
  r6.xyz = r6.xyz ? float3(1,1,1) : 0;
  r7.xyz = cb1[0].xxx * r4.xyz;
  r3.xyz = r6.xyz * r3.xyz + r7.xyz;
  r2.z = cb1[0].z / cb1[0].x;
  r0.w = r2.z + -r0.w;
  r1.xyz = r1.xyz * float3(0.30103001,0.30103001,0.30103001) + -r0.www;
  r2.z = cb1[0].x + cb1[0].x;
  r3.w = 1 + cb1[1].x;
  r4.w = -cb1[0].z + r3.w;
  r2.z = r2.z / r4.w;
  r4.w = r4.w + r4.w;
  r1.xyz = r2.zzz * r1.xyz;
  r1.xyz = float3(1.44269502,1.44269502,1.44269502) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.xyz = float3(1,1,1) + r1.xyz;
  r1.xyz = r4.www / r1.xyz;
  r1.xyz = r3.www + -r1.xyz;
  r1.xyz = -cb1[0].xxx * r4.xyz + r1.xyz;
  r4.xyz = cmp(r0.www < r5.xyz);
  r4.xyz = r4.xyz ? float3(1,1,1) : 0;
  r1.xyz = r4.xyz * r1.xyz + r7.xyz;
  r1.xyz = r1.xyz + -r3.xyz;
  r2.z = r0.w + -r1.w;
  r0.w = cmp(r0.w < r1.w);
  r2.xyz = saturate(r2.xyw / r2.zzz);
  r4.xyz = float3(1,1,1) + -r2.xyz;
  r2.xyz = r0.www ? r4.xyz : r2.xyz;
  r4.xyz = -r2.xyz * float3(2,2,2) + float3(3,3,3);
  r2.xyz = r2.xyz * r2.xyz;
  r2.xyz = r2.xyz * r4.xyz;
  r1.xyz = r2.xyz * r1.xyz + r3.xyz;*/
  float3 sdrTonemappedAp1 = unrealengine::filmtonemap::ApplyToneCurve(r1.xyz, cb1[0].x, cb1[0].y, cb1[0].z, cb1[0].w, cb1[1].x);
  r1.xyz = sdrTonemappedAp1;
  r0.w = dot(r1.xyz, float3(0.272228718,0.674081743,0.0536895171));
  r1.xyz = r1.xyz + -r0.www;
  r1.xyz = r1.xyz * float3(0.930000007,0.930000007,0.930000007) + r0.www;
  r1.xyz = max(float3(0,0,0), r1.xyz);
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = cb0[1].www * r1.xyz + r0.xyz;
  r1.x = dot(float3(1.06537485,1.44673368e-006,-0.0653710067), r0.xyz);
  r1.y = dot(float3(-3.4558721e-007,1.20366347,-0.203667715), r0.xyz);
  r1.z = dot(float3(1.98354986e-008,2.12240607e-008,0.999999583), r0.xyz);
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = cb0[1].yyy * r1.xyz + r0.xyz;
  r1.x = dot(float3(1.70505095,-0.621792018,-0.0832588673), r0.xyz);
  r1.y = dot(float3(-0.130256414,1.14080465,-0.0105483187), r0.xyz);
  r1.z = dot(float3(-0.024003353,-0.128968969,1.15297234), r0.xyz);
  float3 sdrTonemappedBt709 = r1.xyz;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    r1.xyz = max(0.f, sdrTonemappedBt709);
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
  r0.xyzw = max(float4(0,0,0,0), r1.xyzx);
  r0.xyzw = renodx::color::srgb::EncodeSafe(r1.xyzx);
  r0.xyzw = float4(0.952381015, 0.952381015, 0.952381015, 0.952381015) * r0.xyzw;
  u7[vThreadID] = r0;
  return;
}