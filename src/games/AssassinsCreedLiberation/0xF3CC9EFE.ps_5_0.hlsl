#include "./common.hlsl"

// Original DXBC baseline. The decompiler's EV-index constants and bit casts
// are corrected against disassembly: the lookup range is -10 through 21.
// ---- Created with 3Dmigoto v1.3.16 on Thu Nov 05 13:22:46 2026

struct AdaptLuminanceData
{
    float Exposure;                // Offset:    0
    float ExposureDelta;           // Offset:    4
    float LastExposureTarget;      // Offset:    8
    float AverageLuminance;        // Offset:   12
    float HistogramMax;            // Offset:   16
    float CenterEV;                // Offset:   20
    float AverageLuminanceEV;      // Offset:   24
    float ToBeUsed2;               // Offset:   28
    float ToBeUsed3;               // Offset:   32
};

cbuffer AdaptLuminanceConstscb : register(b5)
{

  struct
  {
    float4 m_Params;
    float4 m_AdaptionParams;
    float4 m_EVAdjustments[32];
    int4 m_ScreenWidthHeight;
  } g_AdaptLuminance : packoffset(c0);

}

SamplerState _sampler_Tex0_s : register(s0);
Texture2D<float4> _texture_Tex0 : register(t0);
RWStructuredBuffer<AdaptLuminanceData> g_AdaptionData : register(u1);


// 3Dmigoto declarations
#define cmp -


void OriginalMain(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = g_AdaptionData[0].Exposure;
  r0.y = g_AdaptionData[0].ExposureDelta;
  r0.z = g_AdaptionData[0].LastExposureTarget;
  r1.xy = _texture_Tex0.SampleLevel(_sampler_Tex0_s, float2(0.5,0.5), 10).xw;
  r0.w = r1.x / r1.y;
  r1.w = exp2(r0.w);
  r0.w = 5464 * r1.w;
  r2.y = log2(r0.w);
  r0.w = max(g_AdaptLuminance.m_Params.z, r2.y);
  r0.w = min(g_AdaptLuminance.m_Params.w, r0.w);
  r0.w = exp2(r0.w);
  r0.w = 0.000183016105 * r0.w;
  r1.z = 1 / r0.w;
  r0.w = cmp(r1.z < r0.x);
  r0.w = r0.w ? g_AdaptLuminance.m_AdaptionParams.x : g_AdaptLuminance.m_AdaptionParams.y;
  r2.z = 1 / r0.w;
  r2.z = r2.z * r2.z;
  r2.z = 36 * r2.z;
  r2.w = 11.6999998 / r0.w;
  r0.w = cmp(0 < r0.w);
  r3.x = r2.z * g_AdaptLuminance.m_Params.x + r2.w;
  r2.w = r2.w * g_AdaptLuminance.m_Params.x + 1;
  r3.x = r3.x * -r0.y;
  r3.y = 9.99999994e-009 + r1.z;
  r3.y = log2(r3.y);
  r3.z = 9.99999994e-009 + r0.x;
  r3.z = log2(r3.z);
  r3.y = r3.y + -r3.z;
  r3.x = r2.z * r3.y + r3.x;
  r2.z = g_AdaptLuminance.m_Params.x * r2.z;
  r2.z = r2.z * g_AdaptLuminance.m_Params.x + r2.w;
  r2.z = r3.x / r2.z;
  r3.y = r2.z * g_AdaptLuminance.m_Params.x + r0.y;
  r2.z = r3.y * g_AdaptLuminance.m_Params.x + r3.z;
  r2.z = exp2(r2.z);
  r3.x = -9.99999994e-009 + r2.z;
  r4.xyzw = asint(r0.xxyy) & int4(0x7f800000,0x7fffff,0x7f800000,0x7fffff);
  r0.xy = asint(r0.zz) & int2(0x7f800000,0x7fffff);
  r2.zw = cmp(int2(0x7f800000,0x7f800000) == (int2)r4.xz);
  r3.zw = cmp(int2(0,0) != (int2)r4.yw);
  r2.zw = r2.zw ? r3.zw : 0;
  r2.zw = ~(int2)r2.zw;
  r0.z = cmp(g_AdaptLuminance.m_Params.y == 1.000000);
  r0.z = r2.z ? r0.z : 0;
  r0.z = r2.w ? r0.z : 0;
  r0.x = cmp(0x7f800000 == (int)r0.x);
  r0.y = cmp(0 != (int)r0.y);
  r0.x = r0.y ? r0.x : 0;
  r0.x = ~(int)r0.x;
  r0.x = r0.x ? r0.z : 0;
  r0.x = r0.w ? r0.x : 0;
  r1.x = 0;
  r1.xy = r0.xx ? r3.xy : r1.zx;
  g_AdaptionData[0].Exposure = r1.x;
  g_AdaptionData[0].ExposureDelta = r1.y;
  g_AdaptionData[0].LastExposureTarget = r1.z;
  g_AdaptionData[0].AverageLuminance = r1.w;
  r0.x = 1 / r1.x;
  r0.x = 5464 * r0.x;
  r2.x = log2(r0.x);
  g_AdaptionData[0].CenterEV = r2.x;
  g_AdaptionData[0].AverageLuminanceEV = r2.y;
  r0.x = max(-10, r2.x);
  r0.x = min(21, r0.x);
  r0.y = floor(r2.x);
  r0.z = ceil(r2.x);
  r0.yz = (int2)r0.yz;
  r0.yz = max(int2(-10,-10), (int2)r0.yz);
  r0.yz = min(int2(21,21), (int2)r0.yz);
  r0.w = (int)r0.y;
  r0.yz = (int2)r0.yz + int2(10,10);
  r0.x = r0.x + -r0.w;
  r0.z = g_AdaptLuminance.m_EVAdjustments[r0.z].x + -g_AdaptLuminance.m_EVAdjustments[r0.y].x;
  r0.x = r0.x * r0.z + g_AdaptLuminance.m_EVAdjustments[r0.y].x;
  r0.x = exp2(r0.x);
  o0.xyz = r1.xxx * r0.xxx;
  o0.w = 1;
  return;
}

void main(float4 position : SV_Position0, float2 uv : TEXCOORD0, out float4 output : SV_Target0) {
  float speed = saturate(CUSTOM_AUTO_EXPOSURE_SPEED);
  float protection = saturate(CUSTOM_AUTO_EXPOSURE_HIGHLIGHT_PROTECTION);
  if (!IsCustomHDRMode() || RENODX_PEAK_WHITE_NITS <= 0.f
      || CUSTOM_AUTO_EXPOSURE_MODE < 0.5f || (speed >= 1.f && protection == 0.f)) {
    OriginalMain(position, uv, output);
    return;
  }

  AdaptLuminanceData history = g_AdaptionData[0];
  float4 average_sample = _texture_Tex0.SampleLevel(_sampler_Tex0_s, 0.5f.xx, 10);
  float original_log_average = average_sample.x / max(average_sample.w, 1.e-8f);
  if (!isfinite(original_log_average)) {
    original_log_average = history.AverageLuminance > 0.f && isfinite(history.AverageLuminance)
        ? log2(history.AverageLuminance) : 0.f;
  }
  float metered_log_average = original_log_average;
  if (protection > 0.f && isfinite(original_log_average)) {
    float log_sum = 0.f;
    float weight_sum = 0.f;
    // This is the game's weighted log-luminance pyramid, not display color.
    // Mip 6 contains 16x8 cells. Limit only unusually bright metering cells;
    // scene RGB and the highlight signal remain untouched.
    [loop]
    for (uint y = 0; y < 8; ++y) {
      [loop]
      for (uint x = 0; x < 16; ++x) {
        float4 cell = _texture_Tex0.SampleLevel(
            _sampler_Tex0_s, (float2(x, y) + 0.5f) / float2(16.f, 8.f), 6);
        if (cell.w > 1.e-8f && isfinite(cell.x) && isfinite(cell.w)) {
          log_sum += min(cell.x / cell.w, original_log_average + 2.f) * cell.w;
          weight_sum += cell.w;
        }
      }
    }
    if (weight_sum > 0.f) {
      metered_log_average = lerp(original_log_average, log_sum / weight_sum, protection);
    }
  }

  float original_luminance_ev = log2(5464.f) + original_log_average;
  float target_ev = clamp(log2(5464.f) + metered_log_average,
      g_AdaptLuminance.m_Params.z, g_AdaptLuminance.m_Params.w);
  float target = rcp(0.000183016105f * exp2(target_ev));
  float minimum_exposure = rcp(0.000183016105f * exp2(g_AdaptLuminance.m_Params.w));
  float maximum_exposure = rcp(0.000183016105f * exp2(g_AdaptLuminance.m_Params.z));
  float duration = target < history.Exposure
      ? g_AdaptLuminance.m_AdaptionParams.x : g_AdaptLuminance.m_AdaptionParams.y;
  float dt = g_AdaptLuminance.m_Params.x;
  bool valid_history = history.Exposure > 0.f && isfinite(history.Exposure)
      && isfinite(history.ExposureDelta) && isfinite(history.LastExposureTarget)
      && g_AdaptLuminance.m_Params.y == 1.f && duration > 0.f && dt >= 0.f;
  float exposure = target;
  float velocity = 0.f;
  if (valid_history) {
    if (speed == 0.f) {
      exposure = clamp(history.Exposure, minimum_exposure, maximum_exposure);
    } else {
      // Preserve the native damped log-exposure integrator and its timing input.
      // Stretch the directional adaptation durations instead of guessing dt units.
      duration /= speed;
      float stiffness = 36.f / (duration * duration);
      float damping = 11.6999998f / duration;
      float previous_stops = log2(history.Exposure + 1.e-8f);
      float target_stops = log2(target + 1.e-8f);
      float acceleration = (stiffness * (target_stops - previous_stops)
          - (stiffness * dt + damping) * history.ExposureDelta)
          / (stiffness * dt * dt + damping * dt + 1.f);
      velocity = history.ExposureDelta + acceleration * dt;
      exposure = exp2(previous_stops + velocity * dt) - 1.e-8f;
      float bounded = clamp(exposure, minimum_exposure, maximum_exposure);
      if (bounded != exposure) velocity = 0.f;
      exposure = bounded;
    }
  }
  if (!isfinite(exposure) || exposure <= 0.f) {
    exposure = target;
    velocity = 0.f;
  }

  g_AdaptionData[0].Exposure = exposure;
  g_AdaptionData[0].ExposureDelta = velocity;
  g_AdaptionData[0].LastExposureTarget = target;
  g_AdaptionData[0].AverageLuminance = exp2(original_log_average);
  float center_ev = log2(5464.f / exposure);
  g_AdaptionData[0].CenterEV = center_ev;
  g_AdaptionData[0].AverageLuminanceEV = original_luminance_ev;

  // Preserve the engine's EV-dependent artistic exposure compensation.
  float bounded_ev = clamp(center_ev, -10.f, 21.f);
  int lower_ev = (int)floor(bounded_ev);
  int upper_ev = min(lower_ev + 1, 21);
  float adjustment = lerp(g_AdaptLuminance.m_EVAdjustments[lower_ev + 10].x,
      g_AdaptLuminance.m_EVAdjustments[upper_ev + 10].x, bounded_ev - lower_ev);
  output = float4((exposure * exp2(adjustment)).xxx, 1.f);
}
