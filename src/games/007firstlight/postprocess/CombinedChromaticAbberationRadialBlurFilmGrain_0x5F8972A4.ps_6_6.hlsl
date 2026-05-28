#include "./postprocess.hlsli"

// Post-tonemap pass that combines chromatic aberration, radial blur, and film grain.
// The input is already in the game's intermediate/post-tonemap scale, so every color
// sample from srvRadialBlurInput is converted back before processing and restored at output.

static float _106;

struct S_cbCombinedChromaticAbberationRadialBlurFilmGrain {
  float2 vCenter;
  float2 vOffsetR_CA;
  float2 vOffsetG_CA;
  float2 vOffsetB_CA;
  float fPower_CA;
  float fStrength_CA;
  float2 vLimits_RB;
  float fRadius_RB;
  float fAmount_RB;
  int nSamples_RB;
  uint _pad_0;
  float2 vRandOffset;
  float fNoiseIntensity;
  uint _pad_1;
  float2 vTilingNoiseTexture;
  uint _pad_2;
  uint _pad_3;
};

cbuffer _cbCombinedChromaticAbberationRadialBlurFilmGrain : register(b5, space0) {
  S_cbCombinedChromaticAbberationRadialBlurFilmGrain cbCombinedChromaticAbberationRadialBlurFilmGrain : packoffset(c0);
};

Texture2D<float4> srvRadialBlurInput : register(t0, space0);
Texture2D<float> srvNoise : register(t1, space0);
SamplerState samplerPointWrapNode : register(s1, space0);
SamplerState samplerLinearClampNode : register(s4, space0);

// Sample the previous pass and undo the intermediate brightness scale so this pass
// runs in the same space as the tonemapped game image, independent from UI scaling.
float4 SampleRadialBlurInput(float2 uv) {
  float4 color = srvRadialBlurInput.SampleLevel(samplerLinearClampNode, uv, 0.0f);
  color.rgb = InvertIntermediatePass(color.rgb);
  return color;
}

// Vanilla film grain uses the noise texture to push squared color values, fading near white.
float3 ApplyFilmGrain(float3 color, float2 uv) {
  if (cbCombinedChromaticAbberationRadialBlurFilmGrain.fNoiseIntensity <= 0.f) {
    return color;
  }

  float2 noise_uv = cbCombinedChromaticAbberationRadialBlurFilmGrain.vTilingNoiseTexture * uv
                    + cbCombinedChromaticAbberationRadialBlurFilmGrain.vRandOffset;
  float noise = srvNoise.SampleLevel(samplerPointWrapNode, noise_uv, 0.f);

  if (CUSTOM_GRAIN_TYPE == 2.f) {  // renodx perceptual grain
    color = renodx::color::gamma::DecodeSafe(color);
    color = renodx::effects::ApplyFilmGrain(
        color, uv, noise.x, CUSTOM_GRAIN_STRENGTH * 0.04f * cbCombinedChromaticAbberationRadialBlurFilmGrain.fNoiseIntensity);
    color = renodx::color::gamma::EncodeSafe(color);
    return color;
  } else if (CUSTOM_GRAIN_TYPE == 1.f) {  // vanilla grain with clamped mask

    // linearize properly instead of approximating with square
    float3 color_linear = renodx::color::gamma::DecodeSafe(color, 2.2f);

    // Grain fades out as linear color approaches 1.
    // The saturate prevents negative grain behavior above 1 in HDR.
    float3 grain_mask = 1.f - saturate(color_linear);
    float3 grain = noise * grain_mask * 2.f;

    float3 blended_linear = lerp(color_linear, 1.f, grain);

    // Mask the full grain delta so highlights above 1 do not get boosted.
    float3 grain_delta = ((blended_linear * color_linear) - color_linear) * grain_mask;

    float grain_strength = cbCombinedChromaticAbberationRadialBlurFilmGrain.fNoiseIntensity * CUSTOM_GRAIN_STRENGTH;

    color_linear = grain_delta * grain_strength + color_linear;

    return renodx::color::gamma::EncodeSafe(color_linear, 2.2f);
  } else {  // vanilla grain (broken in hdr)
    float3 color_squared = color * color;

    // Grain fades out as color_squared approaches 1.
    // Above 1 this becomes negative, which is why this vanilla path breaks in HDR.
    float3 grain_mask = 1.f - color_squared;
    float3 grain = noise * grain_mask * 2.f;

    float3 blended_squared = lerp(color_squared, 1.f, grain);

    float grain_strength = cbCombinedChromaticAbberationRadialBlurFilmGrain.fNoiseIntensity * CUSTOM_GRAIN_STRENGTH;

    float3 grained_squared = ((blended_squared * color_squared) - color_squared) * grain_strength + color_squared;

    return sqrt(grained_squared);
  }
}

static float4 COLOR;
static float2 TEXCOORD;
static float4 SV_Target;

void frag_main() {
  float _104;
  float _105;
  float _107;
  float _108;
  float _109;
  float _110;
  float _111;
  float _112;
  float _113;
  float _114;
  float _115;

  // Chromatic aberration setup. Disabled path keeps the original sampled color and alpha.
  // Enabled path computes a radial CA strength and samples R/G/B at separate offsets.
  if (cbCombinedChromaticAbberationRadialBlurFilmGrain.fStrength_CA == 0.0f) {
    float4 _48 = SampleRadialBlurInput(float2(TEXCOORD.x, TEXCOORD.y));
    _104 = 0.0f;
    _105 = _106;
    _107 = _106;
    _108 = _106;
    _109 = _106;
    _110 = _106;
    _111 = _106;
    _112 = _48.x;
    _113 = _48.y;
    _114 = _48.z;
    _115 = _48.w;
  } else {
    float _56 = mad(TEXCOORD.x, 2.0f, -1.0f);
    float _59 = mad(TEXCOORD.y, 2.0f, -1.0f);
    float _71 = clamp(cbCombinedChromaticAbberationRadialBlurFilmGrain.fStrength_CA, 0.0f, 1.0f) * exp2(log2(clamp(dot(float2(_56, _59), float2(_56, _59)) * 0.5f, 0.0f, 1.0f)) * cbCombinedChromaticAbberationRadialBlurFilmGrain.fPower_CA);
    float _76 = cbCombinedChromaticAbberationRadialBlurFilmGrain.vOffsetR_CA.x * _71;
    float _77 = cbCombinedChromaticAbberationRadialBlurFilmGrain.vOffsetR_CA.y * _71;
    float _82 = cbCombinedChromaticAbberationRadialBlurFilmGrain.vOffsetG_CA.x * _71;
    float _83 = cbCombinedChromaticAbberationRadialBlurFilmGrain.vOffsetG_CA.y * _71;
    float _86 = cbCombinedChromaticAbberationRadialBlurFilmGrain.vOffsetB_CA.x * _71;
    float _87 = cbCombinedChromaticAbberationRadialBlurFilmGrain.vOffsetB_CA.y * _71;
    _104 = 1.0f;
    _105 = _76;
    _107 = _77;
    _108 = _82;
    _109 = _83;
    _110 = _86;
    _111 = _87;
    _112 = SampleRadialBlurInput(float2(_76 + TEXCOORD.x, _77 + TEXCOORD.y)).x;
    _113 = SampleRadialBlurInput(float2(_82 + TEXCOORD.x, _83 + TEXCOORD.y)).y;
    _114 = SampleRadialBlurInput(float2(_86 + TEXCOORD.x, _87 + TEXCOORD.y)).z;
    _115 = 1.0f;
  }

  // Radial blur amount is based on distance from vCenter. The smoothstep-shaped value
  // determines the integer sample count plus a fractional final sample weight.
  float _128 = float(cbCombinedChromaticAbberationRadialBlurFilmGrain.nSamples_RB);
  float _129 = TEXCOORD.x - cbCombinedChromaticAbberationRadialBlurFilmGrain.vCenter.x;
  float _130 = TEXCOORD.y - cbCombinedChromaticAbberationRadialBlurFilmGrain.vCenter.y;
  float _134 = sqrt((_129 * _129) + (_130 * _130));
  float _137 = clamp(_134 / (cbCombinedChromaticAbberationRadialBlurFilmGrain.vLimits_RB.y * 0.5f), 0.0f, 1.0f);
  float _147 = exp2(log2((_137 * _137) * (3.0f - (_137 * 2.0f))) * 1.5f) * _128;
  uint _149 = uint(floor(_147));
  float _150 = frac(_147);

  // No radial blur branch: inside the inner limit or with zero samples, only apply
  // optional film grain to the CA/base color and preserve the original alpha.
  if ((_134 < cbCombinedChromaticAbberationRadialBlurFilmGrain.vLimits_RB.x) || (_149 == 0u)) {
    float3 grained_color = ApplyFilmGrain(float3(_112, _113, _114), TEXCOORD);
    SV_Target.x = grained_color.x;
    SV_Target.y = grained_color.y;
    SV_Target.z = grained_color.z;
    SV_Target.w = _115;
  } else {
    // Radial blur branch: blur strength ramps between vLimits_RB.x/y, then samples
    // along the vector from the current UV back toward vCenter.
    float _162 = clamp((_134 - cbCombinedChromaticAbberationRadialBlurFilmGrain.vLimits_RB.x) / (cbCombinedChromaticAbberationRadialBlurFilmGrain.vLimits_RB.y - cbCombinedChromaticAbberationRadialBlurFilmGrain.vLimits_RB.x), 0.0f, 1.0f);
    float _170 = ((_162 * _162) * (3.0f - (_162 * 2.0f))) * cbCombinedChromaticAbberationRadialBlurFilmGrain.fAmount_RB;
    float _173 = clamp(cbCombinedChromaticAbberationRadialBlurFilmGrain.fRadius_RB * _134, 0.0f, 1.0f);
    float _259;
    float _260;
    float _261;
    float _262;
    float _263;
    if (_149 > 1u) {
      // Accumulate whole-number blur taps. When CA is active, each tap samples separate
      // R/G/B offsets; otherwise a single source sample contributes all channels.
      float _238;
      precise float _240;
      precise float _242;
      precise float _244;
      float _318;
      float _319;
      float _320;
      float _237 = _104;
      float _239 = _112;
      float _241 = _113;
      float _243 = _114;
      uint _245 = 1u;
      float _249;
      float _254;
      float _255;
      bool _256;
      for (;;) {
        _249 = _170 * _173;
        float _251 = 1.0f - (_249 * (float(_245) / _128));
        _254 = (_251 * _129) + cbCombinedChromaticAbberationRadialBlurFilmGrain.vCenter.x;
        _255 = (_251 * _130) + cbCombinedChromaticAbberationRadialBlurFilmGrain.vCenter.y;
        _256 = _237 > 0.0f;
        float frontier_phi_17_pred;
        float frontier_phi_17_pred_1;
        float frontier_phi_17_pred_2;
        float frontier_phi_17_pred_3;
        if (_256) {
          frontier_phi_17_pred = SampleRadialBlurInput(float2(_254 + _110, _255 + _111)).z;
          frontier_phi_17_pred_1 = SampleRadialBlurInput(float2(_254 + _108, _255 + _109)).y;
          frontier_phi_17_pred_2 = SampleRadialBlurInput(float2(_254 + _105, _255 + _107)).x;
          frontier_phi_17_pred_3 = clamp(_237 + (-0.5f), 0.0f, 1.0f);
        } else {
          float4 _294 = SampleRadialBlurInput(float2(_254, _255));
          frontier_phi_17_pred = _294.z;
          frontier_phi_17_pred_1 = _294.y;
          frontier_phi_17_pred_2 = _294.x;
          frontier_phi_17_pred_3 = _237;
        }
        _320 = frontier_phi_17_pred;
        _319 = frontier_phi_17_pred_1;
        _318 = frontier_phi_17_pred_2;
        _238 = frontier_phi_17_pred_3;
        _244 = _243 + _320;
        _242 = _241 + _319;
        _240 = _239 + _318;
        uint _246 = _245 + 1u;
        if (_246 == _149) {
          break;
        } else {
          _237 = _238;
          _239 = _240;
          _241 = _242;
          _243 = _244;
          _245 = _246;
          continue;
        }
      }
      _259 = _249;
      _260 = _238;
      _261 = _240;
      _262 = _242;
      _263 = _244;
    } else {
      _259 = _170 * _173;
      _260 = _104;
      _261 = _112;
      _262 = _113;
      _263 = _114;
    }
    float _267 = 1.0f - (_259 * (float(_149) / _128));
    float _270 = (_267 * _129) + cbCombinedChromaticAbberationRadialBlurFilmGrain.vCenter.x;
    float _271 = (_267 * _130) + cbCombinedChromaticAbberationRadialBlurFilmGrain.vCenter.y;
    float _302;
    float _305;
    float _308;
    if (_150 > 9.9999997473787516355514526367188e-06f) {
      // Add the fractional final tap so radial blur sample counts transition smoothly.
      float frontier_phi_16_15_ladder;
      float frontier_phi_16_15_ladder_1;
      float frontier_phi_16_15_ladder_2;
      if (_260 > 0.0f) {
        frontier_phi_16_15_ladder = (SampleRadialBlurInput(float2(_270 + _110, _271 + _111)).z * _150) + _263;
        frontier_phi_16_15_ladder_1 = (SampleRadialBlurInput(float2(_270 + _108, _271 + _109)).y * _150) + _262;
        frontier_phi_16_15_ladder_2 = (SampleRadialBlurInput(float2(_270 + _105, _271 + _107)).x * _150) + _261;
      } else {
        float4 _342 = SampleRadialBlurInput(float2(_270, _271));
        frontier_phi_16_15_ladder = (_342.z * _150) + _263;
        frontier_phi_16_15_ladder_1 = (_342.y * _150) + _262;
        frontier_phi_16_15_ladder_2 = (_342.x * _150) + _261;
      }
      _302 = frontier_phi_16_15_ladder_2;
      _305 = frontier_phi_16_15_ladder_1;
      _308 = frontier_phi_16_15_ladder;
    } else {
      _302 = _261;
      _305 = _262;
      _308 = _263;
    }
    float _311 = _302 / _147;
    float _312 = _305 / _147;
    float _313 = _308 / _147;
    // Apply the same grain model after blur so blurred and unblurred paths match.
    float3 grained_color = ApplyFilmGrain(float3(_311, _312, _313), TEXCOORD);
    SV_Target.rgb = grained_color;
    SV_Target.w = 1.0f;
  }

  // Re-apply the intermediate brightness scale for downstream post-tonemap/UI composition.
  SV_Target.rgb = RenderIntermediatePass(SV_Target.rgb);
  // SV_Target.rgb *= 2.f;
}

float4 main(
    precise noperspective float4 SV_Position: SV_Position,
    linear float4 input_COLOR: COLOR,
    linear float2 input_TEXCOORD: TEXCOORD)
    : SV_Target {
  COLOR = input_COLOR;
  TEXCOORD = input_TEXCOORD;
  frag_main();
  return SV_Target;
}
