#include "../../common.hlsl"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t4 : register(t4);

Texture3D<float4> t5 : register(t5);

Texture3D<float4> t6 : register(t6);

cbuffer cb0 : register(b0) {
  float cb0_037y : packoffset(c037.y);
  float cb0_037z : packoffset(c037.z);
  float cb0_037w : packoffset(c037.w);
  float cb0_038x : packoffset(c038.x);
  float cb0_038y : packoffset(c038.y);
  float cb0_038z : packoffset(c038.z);
  float cb0_048x : packoffset(c048.x);
  float cb0_048y : packoffset(c048.y);
  float cb0_048z : packoffset(c048.z);
  float cb0_048w : packoffset(c048.w);
  float cb0_049x : packoffset(c049.x);
  float cb0_049y : packoffset(c049.y);
  float cb0_060z : packoffset(c060.z);
  float cb0_060w : packoffset(c060.w);
  float cb0_061x : packoffset(c061.x);
  float cb0_061y : packoffset(c061.y);
  float cb0_068z : packoffset(c068.z);
  float cb0_068w : packoffset(c068.w);
  float cb0_069x : packoffset(c069.x);
  float cb0_069y : packoffset(c069.y);
  float cb0_075z : packoffset(c075.z);
  float cb0_075w : packoffset(c075.w);
  float cb0_076x : packoffset(c076.x);
  float cb0_076y : packoffset(c076.y);
  float cb0_076z : packoffset(c076.z);
  float cb0_076w : packoffset(c076.w);
  float cb0_077x : packoffset(c077.x);
  float cb0_077y : packoffset(c077.y);
  float cb0_083z : packoffset(c083.z);
  float cb0_083w : packoffset(c083.w);
  float cb0_084x : packoffset(c084.x);
  float cb0_084y : packoffset(c084.y);
  float cb0_084z : packoffset(c084.z);
  float cb0_084w : packoffset(c084.w);
  float cb0_085x : packoffset(c085.x);
  float cb0_085y : packoffset(c085.y);
  int cb0_085z : packoffset(c085.z);
  int cb0_085w : packoffset(c085.w);
  int cb0_086x : packoffset(c086.x);
  float cb0_087x : packoffset(c087.x);
  float cb0_087y : packoffset(c087.y);
  float cb0_087z : packoffset(c087.z);
  float cb0_089x : packoffset(c089.x);
  float cb0_089z : packoffset(c089.z);
  float cb0_089w : packoffset(c089.w);
  float cb0_090x : packoffset(c090.x);
  float cb0_090y : packoffset(c090.y);
  float cb0_090z : packoffset(c090.z);
  float cb0_090w : packoffset(c090.w);
  float cb0_091x : packoffset(c091.x);
  float cb0_091y : packoffset(c091.y);
  float cb0_091z : packoffset(c091.z);
  float cb0_092x : packoffset(c092.x);
  float cb0_092z : packoffset(c092.z);
  float cb0_092w : packoffset(c092.w);
  float cb0_093x : packoffset(c093.x);
  float cb0_093y : packoffset(c093.y);
  float cb0_093z : packoffset(c093.z);
  float cb0_093w : packoffset(c093.w);
  float cb0_094x : packoffset(c094.x);
  float cb0_094y : packoffset(c094.y);
  float cb0_094z : packoffset(c094.z);
  float cb0_094w : packoffset(c094.w);
  float cb0_095x : packoffset(c095.x);
  float cb0_095y : packoffset(c095.y);
  float cb0_095z : packoffset(c095.z);
  float cb0_095w : packoffset(c095.w);
  float cb0_096x : packoffset(c096.x);
  float cb0_096y : packoffset(c096.y);
  float cb0_096z : packoffset(c096.z);
  float cb0_096w : packoffset(c096.w);
  float cb0_097x : packoffset(c097.x);
  int cb0_106w : packoffset(c106.w);
  float cb0_107x : packoffset(c107.x);
  float cb0_107z : packoffset(c107.z);
  int cb0_107w : packoffset(c107.w);
  int cb0_108x : packoffset(c108.x);
  int cb0_108y : packoffset(c108.y);
  int cb0_108z : packoffset(c108.z);
  int cb0_108w : packoffset(c108.w);
  float cb0_114x : packoffset(c114.x);
  float cb0_114y : packoffset(c114.y);
  float cb0_114z : packoffset(c114.z);
  float cb0_114w : packoffset(c114.w);
  float cb0_115x : packoffset(c115.x);
  float cb0_115y : packoffset(c115.y);
  float cb0_115z : packoffset(c115.z);
  float cb0_115w : packoffset(c115.w);
  float cb0_117x : packoffset(c117.x);
  float cb0_117y : packoffset(c117.y);
  float cb0_117z : packoffset(c117.z);
  float cb0_118x : packoffset(c118.x);
  float cb0_118y : packoffset(c118.y);
  float cb0_118z : packoffset(c118.z);
  float cb0_118w : packoffset(c118.w);
};

SamplerState s0 : register(s0);

SamplerState s1 : register(s1);

SamplerState s2 : register(s2);

SamplerState s3 : register(s3);

SamplerState s4 : register(s4);

SamplerState s5 : register(s5);

SamplerState s6 : register(s6);

namespace WUWAUncharted2 {
struct Config {
  float pivot_point;
  float coeffs[6];  // A,B,C,D,E,F
};

static inline float Derivative(float x, float a, float b, float c, float d, float e, float f) {
  float num = -a * b * (c - 1.0f) * x * x + 2.0f * a * d * (f - e) * x + b * d * (c * f - e);
  float den = x * (a * x + b) + d * f;
  return num / (den * den);
}

// Analytic knee root from BatmanAK UC2 extension helper.
static inline float FindThirdDerivativeRoot(float a, float b, float c, float d, float e, float f) {
  float sqrt_ab = sqrt(a * b * b * c * c - 2.f * a * b * b * c + a * b * b);
  float sqrt_df = sqrt(a * d * d * e * e - 2.f * a * d * d * e * f + a * d * d * f * f + b * b * c * c * d * f + b * b * (-c) * d * e - b * b * c * d * f + b * b * d * e);
  float de_df = d * e - d * f;

  float term_top = 32.f * (a * d * d * e * f - a * d * d * f * f + b * b * c * d * f - b * b * d * e) / (a * a * b * (c - 1.f));
  float term_mid = 96.f * de_df * (c * d * f - d * e) / (a * b * (c - 1.f) * (c - 1.f));
  float de_df2 = de_df * de_df;
  float de_df3 = de_df2 * de_df;
  float term_tail = 64.f * de_df3 / (b * b * b * (c - 1.f) * (c - 1.f) * (c - 1.f));

  float Tfrac = sqrt_ab * (term_top - term_mid - term_tail) / (8.f * sqrt_df);
  float Tmid2_num = 12.f * a * a * b * c * d * f - 12.f * a * a * b * d * e;
  float Tmid2_den = 6.f * (a * a * a * b * c - a * a * a * b);
  float Tmid2 = Tmid2_num / Tmid2_den;
  float T3 = 6.f * (c * d * f - d * e) / (a * (c - 1.f));
  float T4 = 8.f * de_df2 / (b * b * (c - 1.f) * (c - 1.f));

  float centerNeg = -Tfrac + Tmid2 + T3 + T4;
  float centerPos = Tfrac + Tmid2 + T3 + T4;

  float sNeg = renodx::math::SignSqrt(-centerNeg);
  float sPos = renodx::math::SignSqrt(centerPos);

  float shift1 = sqrt_df / sqrt_ab + de_df / (b * (c - 1.f));
  float shift2 = sqrt_df / sqrt_ab - de_df / (b * (c - 1.f));

  float r1 = -0.5f * sNeg - shift1;
  float r2 = 0.5f * sNeg - shift1;
  float r3 = -0.5f * sPos + shift2;
  float r4 = 0.5f * sPos + shift2;

  return saturate(renodx::math::Max(r1, r2, r3, r4));
}

static inline Config CreateConfig(float coeffs[6]) {
  Config cfg;
  cfg.pivot_point = FindThirdDerivativeRoot(coeffs[0], coeffs[1], coeffs[2], coeffs[3], coeffs[4], coeffs[5]);
  cfg.coeffs = coeffs;
  return cfg;
}

static inline float3 ApplyExtended(float3 x, float3 base, Config cfg) {
  float A = cfg.coeffs[0], B = cfg.coeffs[1], C = cfg.coeffs[2], D = cfg.coeffs[3], E = cfg.coeffs[4], F = cfg.coeffs[5];

  float pivot_x = saturate(cfg.pivot_point * 0.82f);   // earlier onset
  float pivot_y = renodx::tonemap::ApplyCurve(pivot_x, A, B, C, D, E, F);

  float slope = Derivative(pivot_x, A, B, C, D, E, F);
  slope *= 2.f;

  float3 extended = slope * x + (pivot_y - slope * pivot_x);

  float3 t = smoothstep(pivot_x - 0.05f, pivot_x + 0.05f, x);  // softer transition
  return lerp(base, extended, t);
}
}

float3 ApplyHermiteSplineByMaxChannel(float3 input, float peak_ratio, float white_clip = 100.f) {
  float max_channel = renodx::math::Max(input);

  float mapped_peak = exp2(renodx::tonemap::HermiteSplineRolloff(log2(max_channel), log2(peak_ratio), log2(white_clip)));
  float scale = renodx::math::DivideSafe(mapped_peak, max_channel, 1.f);
  float3 tonemapped = input * scale;
  return tonemapped;
}

struct UserGradingConfig {
  float exposure;
  float highlights;
  float shadows;
  float contrast;
  float flare;
  float saturation;
  float dechroma;
  float hue_emulation_strength;
  float highlight_saturation;
  float chrominance_emulation_strength;
};

UserGradingConfig CreateColorGradeConfig() {
  const UserGradingConfig cg_config = {
    RENODX_TONE_MAP_EXPOSURE,                             // float exposure;
    RENODX_TONE_MAP_HIGHLIGHTS,                           // float highlights;
    RENODX_TONE_MAP_SHADOWS,                              // float shadows;
    RENODX_TONE_MAP_CONTRAST,                             // float contrast;
    0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f),             // float flare;
    RENODX_TONE_MAP_SATURATION,                           // float saturation;
    shader_injection.color_grade_saturation_correction,    // float dechroma;
    RENODX_TONE_MAP_HUE_SHIFT,                            // float hue_emulation_strength;
    -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f),  // float highlight_saturation;
    shader_injection.color_grade_blowout                  // float chrominance_emulation_strength;
  };
  return cg_config;
}

float Highlights(float x, float highlights, float mid_gray) {
  if (highlights == 1.f) return x;

  if (highlights > 1.f) {
    return max(x, lerp(x, mid_gray * pow(x / mid_gray, highlights), min(x, 10.f)));
  } else {
    x /= mid_gray;
    return lerp(x, pow(x, highlights), step(1.f, x)) * mid_gray;
  }
}

float Shadows(float x, float shadows, float mid_gray) {
  if (shadows == 1.f) return x;

  const float ratio = max(renodx::math::DivideSafe(x, mid_gray, 0.f), 0.f);
  const float base_term = x * mid_gray;
  const float base_scale = renodx::math::DivideSafe(base_term, ratio, 0.f);

  if (shadows > 1.f) {
    float raised = x * (1.f + renodx::math::DivideSafe(base_term, pow(ratio, shadows), 0.f));
    float reference = x * (1.f + base_scale);
    return max(x, x + (raised - reference));
  } else {
    float lowered = x * (1.f - renodx::math::DivideSafe(base_term, pow(ratio, 2.f - shadows), 0.f));
    float reference = x * (1.f - base_scale);
    return clamp(x + (lowered - reference), 0.f, x);
  }
}

float3 ApplyExposureContrastFlareHighlightsShadowsByLuminance(float3 untonemapped, float y, UserGradingConfig config, float mid_gray = 0.18f) {
  if (config.exposure == 1.f && config.shadows == 1.f && config.highlights == 1.f && config.contrast == 1.f && config.flare == 0.f) {
    return untonemapped;
  }
  float3 color = untonemapped;

  color *= config.exposure;

  const float y_normalized = y / mid_gray;
  float flare = renodx::math::DivideSafe(y_normalized + config.flare, y_normalized, 1.f);
  float exponent = config.contrast * flare;
  const float y_contrasted = pow(y_normalized, exponent) * mid_gray;

  float y_highlighted = Highlights(y_contrasted, config.highlights, mid_gray);
  float y_shadowed = Shadows(y_highlighted, config.shadows, mid_gray);
  const float y_final = y_shadowed;

  color = renodx::color::correct::Luminance(color, y, y_final);

  return color;
}

float3 ApplySaturationBlowoutHueCorrectionHighlightSaturation(float3 tonemapped, float3 hue_reference_color, float y, UserGradingConfig config) {
  float3 color = tonemapped;
  if (config.saturation != 1.f || config.dechroma != 0.f || config.hue_emulation_strength != 0.f || config.chrominance_emulation_strength != 0.f || config.highlight_saturation != 0.f) {
    float3 perceptual_new = renodx::color::oklab::from::BT709(color);

    if (config.hue_emulation_strength != 0.0 || config.chrominance_emulation_strength != 0.0) {
      const float3 perceptual_reference = renodx::color::oklab::from::BT709(hue_reference_color);

      float chrominance_current = length(perceptual_new.yz);
      float chrominance_ratio = 1.0;

      if (config.hue_emulation_strength != 0.0) {
        const float chrominance_pre = chrominance_current;
        perceptual_new.yz = lerp(perceptual_new.yz, perceptual_reference.yz, config.hue_emulation_strength);
        const float chrominancePost = length(perceptual_new.yz);
        chrominance_ratio = renodx::math::SafeDivision(chrominance_pre, chrominancePost, 1);
        chrominance_current = chrominancePost;
      }

      if (config.chrominance_emulation_strength != 0.0) {
        const float reference_chrominance = length(perceptual_reference.yz);
        float target_chrominance_ratio = renodx::math::SafeDivision(reference_chrominance, chrominance_current, 1);
        chrominance_ratio = lerp(chrominance_ratio, target_chrominance_ratio, config.chrominance_emulation_strength);
      }
      perceptual_new.yz *= chrominance_ratio;
    }

    if (config.dechroma != 0.f) {
      perceptual_new.yz *= lerp(1.f, 0.f, saturate(pow(y / (10000.f / 100.f), (1.f - config.dechroma))));
    }

    if (config.highlight_saturation != 0.f) {
      float percent_max = saturate(y * 100.f / 10000.f);
      float highlight_saturation_strength = 100.f;
      float highlight_saturation_change = pow(1.f - percent_max, highlight_saturation_strength * abs(config.highlight_saturation));
      if (config.highlight_saturation < 0) {
        highlight_saturation_change = (2.f - highlight_saturation_change);
      }

      perceptual_new.yz *= highlight_saturation_change;
    }

    perceptual_new.yz *= config.saturation;

    color = renodx::color::bt709::from::OkLab(perceptual_new);
    color = renodx::color::bt709::clamp::AP1(color);
  }
  return color;
}

float4 main(
  noperspective float2 TEXCOORD : TEXCOORD,
  noperspective float2 TEXCOORD_3 : TEXCOORD3,
  noperspective float4 TEXCOORD_1 : TEXCOORD1,
  noperspective float4 TEXCOORD_2 : TEXCOORD2,
  noperspective float2 TEXCOORD_4 : TEXCOORD4,
  noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  float _35 = ((cb0_048z * TEXCOORD_3.x) + cb0_049x) * cb0_048x;
  float _36 = ((cb0_048w * TEXCOORD_3.y) + cb0_049y) * cb0_048y;
  float _37 = TEXCOORD_2.w * 543.3099975585938f;
  float _41 = frac(sin(_37 + TEXCOORD_2.z) * 493013.0f);
  float _65;
  float _66;
  float _127;
  float _128;
  float _196;
  float _197;
  float _262;
  float _263;
  float _264;
  float _276;
  float _277;
  float _278;
  float _406;
  float _407;
  float _408;
  float _440;
  float _441;
  float _442;
  float _489;
  float _490;
  float _491;
  float _506;
  float _507;
  float _508;
  float _581;
  float _582;
  float _583;
  float _671;
  float _672;
  float _673;
  if (cb0_097x > 0.0f) {
    _65 = ((cb0_097x * (frac((sin((TEXCOORD_2.z + 33.9900016784668f) + _37) * 493013.0f) + 7.177000045776367f) - _41)) + _41);
    _66 = ((cb0_097x * (frac((sin((TEXCOORD_2.z + 66.98999786376953f) + _37) * 493013.0f) + 14.298999786376953f) - _41)) + _41);
  } else {
    _65 = _41;
    _66 = _41;
  }
  float _76 = cb0_118z * cb0_117x;
  float _77 = cb0_118z * cb0_117y;
  bool _78 = (cb0_118x == 0.0f);
  float _88 = (cb0_114z * TEXCOORD_3.x) + cb0_114x;
  float _89 = (cb0_114w * TEXCOORD_3.y) + cb0_114y;
  float _100 = float((int)(((int)(uint)((bool)(_88 > 0.0f))) - ((int)(uint)((bool)(_88 < 0.0f)))));
  float _101 = float((int)(((int)(uint)((bool)(_89 > 0.0f))) - ((int)(uint)((bool)(_89 < 0.0f)))));
  float _106 = saturate(abs(_88) - cb0_117z);
  float _107 = saturate(abs(_89) - cb0_117z);
  float _117 = _89 - ((_107 * _76) * _101);
  float _119 = _89 - ((_107 * _77) * _101);
  bool _120 = (cb0_118x > 0.0f);
  if (_120) {
    _127 = (_117 - (cb0_118w * 0.4000000059604645f));
    _128 = (_119 - (cb0_118w * 0.20000000298023224f));
  } else {
    _127 = _117;
    _128 = _119;
  }
  float4 _162 = t0.Sample(s0, float2(_35, _36));
  float4 _166 = t0.Sample(s0, float2((((cb0_048z * ((cb0_115z * (_88 - ((_106 * select(_78, _76, cb0_117x)) * _100))) + cb0_115x)) + cb0_049x) * cb0_048x), (((cb0_048w * ((cb0_115w * _127) + cb0_115y)) + cb0_049y) * cb0_048y)));
  float4 _168 = t0.Sample(s0, float2((((cb0_048z * ((cb0_115z * (_88 - ((_106 * select(_78, _77, cb0_117y)) * _100))) + cb0_115x)) + cb0_049x) * cb0_048x), (((cb0_048w * ((cb0_115w * _128) + cb0_115y)) + cb0_049y) * cb0_048y)));
  if (_120) {
    float _178 = saturate(((((_162.y * 0.5870000123977661f) - cb0_118y) + (_162.x * 0.29899999499320984f)) + (_162.z * 0.11400000005960464f)) * 10.0f);
    float _182 = (_178 * _178) * (3.0f - (_178 * 2.0f));
    _196 = ((((_162.x - _166.x) + (_182 * (_166.x - _162.x))) * cb0_118x) + _166.x);
    _197 = ((((_162.y - _168.y) + (_182 * (_168.y - _162.y))) * cb0_118x) + _168.y);
  } else {
    _196 = _166.x;
    _197 = _168.y;
  }
  float4 _222 = t1.Sample(s1, float2(min(max(((cb0_068z * _35) + cb0_069x), cb0_060z), cb0_061x), min(max(((cb0_068w * _36) + cb0_069y), cb0_060w), cb0_061y)));
  APPLY_BLOOM(_222);
  [branch]
  if (!(cb0_085z == 0)) {
    bool _251 = (cb0_086x != 0);
    float4 _254 = t2.Sample(s2, float2(select(_251, _35, min(max(((cb0_076z * _35) + cb0_077x), cb0_075z), cb0_076x)), select(_251, _36, min(max(((cb0_076w * _36) + cb0_077y), cb0_075w), cb0_076y))));
    _262 = (_254.x + _222.x);
    _263 = (_254.y + _222.y);
    _264 = (_254.z + _222.z);
  } else {
    _262 = _222.x;
    _263 = _222.y;
    _264 = _222.z;
  }
  [branch]
  if (!(cb0_085w == 0)) {
    float4 _268 = t3.Sample(s3, float2(_35, _36));
    _276 = (_268.x + _262);
    _277 = (_268.y + _263);
    _278 = (_268.z + _264);
  } else {
    _276 = _262;
    _277 = _263;
    _278 = _264;
  }
  float _303 = TEXCOORD_1.z + -1.0f;
  float _305 = TEXCOORD_1.w + -1.0f;
  float _308 = ((_303 + (cb0_091x * 2.0f)) * cb0_089z) * cb0_089x;
  float _310 = ((_305 + (cb0_091y * 2.0f)) * cb0_089w) * cb0_089x;
  float _317 = 1.0f / ((((saturate(cb0_090w) * 9.0f) + 1.0f) * dot(float2(_308, _310), float2(_308, _310))) + 1.0f);
  float _318 = _317 * _317;
  float _319 = cb0_091z + 1.0f;
  float _347 = ((_303 + (cb0_094x * 2.0f)) * cb0_092z) * cb0_092x;
  float _349 = ((_305 + (cb0_094y * 2.0f)) * cb0_092w) * cb0_092x;
  float _356 = 1.0f / ((((saturate(cb0_093w) * 9.0f) + 1.0f) * dot(float2(_347, _349), float2(_347, _349))) + 1.0f);
  float _357 = _356 * _356;
  float _358 = cb0_094z + 1.0f;
  float _369 = (((_318 * (_319 - cb0_090x)) + cb0_090x) * (_276 + ((_196 * TEXCOORD_1.x) * cb0_087x))) * ((_357 * (_358 - cb0_093x)) + cb0_093x);
  float _371 = (((_318 * (_319 - cb0_090y)) + cb0_090y) * (_277 + ((_197 * TEXCOORD_1.x) * cb0_087y))) * ((_357 * (_358 - cb0_093y)) + cb0_093y);
  float _373 = (((_318 * (_319 - cb0_090z)) + cb0_090z) * (_278 + ((_162.z * TEXCOORD_1.x) * cb0_087z))) * ((_357 * (_358 - cb0_093z)) + cb0_093z);

  CAPTURE_UNTONEMAPPED(float3(_369, _371, _373));

  [branch]
  if (WUWA_TM_IS(1)) {
    _406 = ((((_369 * 1.3600000143051147f) + 0.04699999839067459f) * _369) / ((((_369 * 0.9599999785423279f) + 0.5600000023841858f) * _369) + 0.14000000059604645f));
    _407 = ((((_371 * 1.3600000143051147f) + 0.04699999839067459f) * _371) / ((((_371 * 0.9599999785423279f) + 0.5600000023841858f) * _371) + 0.14000000059604645f));
    _408 = ((((_373 * 1.3600000143051147f) + 0.04699999839067459f) * _373) / ((((_373 * 0.9599999785423279f) + 0.5600000023841858f) * _373) + 0.14000000059604645f));
  } else {
    _406 = _369;
    _407 = _371;
    _408 = _373;
  }
  [branch]
  if (WUWA_TM_IS(2)) {
    float _418 = 1.0049500465393066f - (0.16398000717163086f / (_406 + -0.19505000114440918f));
    float _419 = 1.0049500465393066f - (0.16398000717163086f / (_407 + -0.19505000114440918f));
    float _420 = 1.0049500465393066f - (0.16398000717163086f / (_408 + -0.19505000114440918f));
    _440 = (((_406 - _418) * select((_406 > 0.6000000238418579f), 0.0f, 1.0f)) + _418);
    _441 = (((_407 - _419) * select((_407 > 0.6000000238418579f), 0.0f, 1.0f)) + _419);
    _442 = (((_408 - _420) * select((_408 > 0.6000000238418579f), 0.0f, 1.0f)) + _420);
  } else {
    _440 = _406;
    _441 = _407;
    _442 = _408;
  }
  [branch]
  if (WUWA_TM_IS(3)) {
    float _448 = cb0_037y * _440;
    float _449 = cb0_037y * _441;
    float _450 = cb0_037y * _442;
    float _453 = cb0_037z * cb0_037w;
    float _463 = cb0_038y * cb0_038x;
    float _474 = cb0_038z * cb0_038x;
    float _481 = cb0_038y / cb0_038z;
    _489 = (((((_453 + _448) * _440) + _463) / (_474 + ((_448 + cb0_037z) * _440))) - _481);
    _490 = (((((_453 + _449) * _441) + _463) / (_474 + ((_449 + cb0_037z) * _441))) - _481);
    _491 = (((((_453 + _450) * _442) + _463) / (_474 + ((_450 + cb0_037z) * _442))) - _481);
  } else {
    _489 = _440;
    _490 = _441;
    _491 = _442;
  }
  [branch]
  if (!(cb0_106w == 0)) {
    if (!(cb0_107x == 1.0f)) {
      float _501 = (cb0_107x * 0.699999988079071f) + 0.30000001192092896f;
      _506 = (_501 * _489);
      _507 = (_501 * _490);
      _508 = (_501 * _491);
    } else {
      _506 = _489;
      _507 = _490;
      _508 = _491;
    }
  } else {
    _506 = _489;
    _507 = _490;
    _508 = _491;
  }
  float3 _renodx_tonemapped_capture = float3(_506, _507, _508);
  
  float3 _renodx_extended_tm = float3(_506, _507, _508);
  if (true) {
    float coeffs[6] = { cb0_037y, cb0_037z, cb0_037w, cb0_038x, cb0_038y, cb0_038z };
    WUWAUncharted2::Config uc2_config = WUWAUncharted2::CreateConfig(coeffs);
    _renodx_extended_tm = WUWAUncharted2::ApplyExtended(max(0.f, float3(_369, _371, _373)), float3(_506, _507, _508), uc2_config);
  }

  _506 = _renodx_extended_tm.x;
  _507 = _renodx_extended_tm.y;
  _508 = _renodx_extended_tm.z;

  CLAMP_IF_SDR3(_506, _507, _508);
  CAPTURE_TONEMAPPED(_renodx_tonemapped_capture);
  float _529 = (saturate((log2(_506 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  float _530 = (saturate((log2(_507 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;
  float _531 = (saturate((log2(_508 + 0.002667719265446067f) * 0.0714285746216774f) + 0.6107269525527954f) * 0.96875f) + 0.015625f;

  float4 _532 = t5.Sample(s5, float3(_529, _530, _531));
  [branch]
  if (!(cb0_108w == 0)) {
    float4 _556 = t4.Sample(s4, float2(min(max(((cb0_084z * _35) + cb0_085x), cb0_083z), cb0_084x), min(max(((cb0_084w * _36) + cb0_085y), cb0_083w), cb0_084y)));
    float _566 = select((((uint)(uint(float((uint)((int)((uint)(uint(round(_556.w * 255.0f))) & 15))))) & -4) == 12), 1.0f, 0.0f);
    float4 _567 = t6.Sample(s6, float3(_529, _530, _531));
    _581 = (lerp(_567.x, _532.x, _566));
    _582 = (lerp(_567.y, _532.y, _566));
    _583 = (lerp(_567.z, _532.z, _566));
  } else {
    _581 = _532.x;
    _582 = _532.y;
    _583 = _532.z;
  }


  float _584 = _583 * 1.0499999523162842f;
  float _585 = _582 * 1.0499999523162842f;
  float _586 = _581 * 1.0499999523162842f;
  float _594 = ((_41 * 0.00390625f) + -0.001953125f) + _586;
  float _595 = ((_65 * 0.00390625f) + -0.001953125f) + _585;
  float _596 = ((_66 * 0.00390625f) + -0.001953125f) + _584;
  [branch]
  if (!(cb0_107w == 0)) {
    float _608 = (pow(_594, 0.012683313339948654f));
    float _609 = (pow(_595, 0.012683313339948654f));
    float _610 = (pow(_596, 0.012683313339948654f));
    float _643 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_608 + -0.8359375f)) / (18.8515625f - (_608 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_107z));
    float _644 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_609 + -0.8359375f)) / (18.8515625f - (_609 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_107z));
    float _645 = max(6.103519990574569e-05f, ((exp2(log2(max(0.0f, (_610 + -0.8359375f)) / (18.8515625f - (_610 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / cb0_107z));
    _671 = min((_643 * 12.920000076293945f), ((exp2(log2(max(_643, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _672 = min((_644 * 12.920000076293945f), ((exp2(log2(max(_644, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
    _673 = min((_645 * 12.920000076293945f), ((exp2(log2(max(_645, 0.0031306699384003878f)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f));
  } else {
    _671 = _594;
    _672 = _595;
    _673 = _596;
  }
  SV_Target.x = _671;
  SV_Target.y = _672;
  SV_Target.z = _673;
  SV_Target.xyz = renodx::draw::InvertIntermediatePass(SV_Target.xyz);

  {
    float3 graded = SV_Target.xyz;
    UserGradingConfig cg_config = CreateColorGradeConfig();
    float y = renodx::color::y::from::BT709(graded);
    float3 graded_ap1 = renodx::color::ap1::from::BT709(graded);
    float3 hue_chrominance_reference_color = renodx::color::bt709::from::AP1(renodx::tonemap::ReinhardPiecewise(graded_ap1, 2.f, 0.18f));
    float3 graded_bt709 = ApplyExposureContrastFlareHighlightsShadowsByLuminance(graded, y, cg_config);
    SV_Target.xyz = ApplySaturationBlowoutHueCorrectionHighlightSaturation(graded_bt709, hue_chrominance_reference_color, y, cg_config);
    SV_Target.xyz = renodx::color::bt2020::from::BT709(SV_Target.xyz);
    SV_Target.xyz = ApplyHermiteSplineByMaxChannel(SV_Target.xyz, RENODX_PEAK_NITS / RENODX_GAME_NITS);
    SV_Target.xyz = renodx::color::bt709::from::BT2020(SV_Target.xyz);
  }


  SV_Target.xyz = renodx::draw::RenderIntermediatePass(SV_Target.xyz);
  SV_Target.w = dot(float3(_586, _585, _584), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  CLAMP_IF_SDR(SV_Target.w);
  return SV_Target;
}
