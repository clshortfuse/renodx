
#include "./shared.h"

/*
  // Vanilla values
  const float invLinearBegin = 20.f;
  const float linearBegin = 0.05f;
  const float linearStart = 1.70833f;
  const float contrast = 0.3f;
  const float madLinearStartContrastFactor = 0.035f;
  const float toe = 1.f;
  const float maxNit = 10.f;
  const float contrastFactor = -0.0457877f;
  const float mulLinearStartContrastFactor = 0.0782207f;
  const float displayMaxNitSubContrastFactor = 9.4525f;
*/
float3 VanillaSDRTonemapper(float3 color, bool is_sdr = false) {
  color = renodx::color::bt709::clamp::BT709(color);  // Deal with AP1 shenanigans

  float invLinearBegin = 20.f;
  float linearBegin = 0.05f;
  float linearStart = 1.70833f;
  float contrast = 0.3f;
  float madLinearStartContrastFactor = 0.035f;
  float toe = 1.f;
  float maxNit = 10.f;
  float contrastFactor = -0.0457877f;
  float mulLinearStartContrastFactor = 0.0782207f;
  float displayMaxNitSubContrastFactor = 9.4525f;

  if (RENODX_TONE_MAP_TYPE > 0.f) {
    if (is_sdr) {
      contrast = 0.35f;
      madLinearStartContrastFactor = 0.f;
      toe = 1.2f;
    } else {
      contrast = 0.72f;
      madLinearStartContrastFactor = 0.f;
      toe = 1.2f;
    }
  }

  // Attmpted rewrite
  /* float3 invLinearColor = invLinearBegin * color;
  float3 startColor = float3(1.f, 1.f, 1.f);

  if (color.rgb < linearBegin) {
    startColor = ((invLinearColor * invLinearColor) * (3.0f - (invLinearColor * 2.0f)));
  }
  float3 linearStartColor = select(color < linearStart, 0.0f, 1.0f);
  color = ((((((contrast)*color) + (madLinearStartContrastFactor)) * (startColor - linearStartColor)) + (((exp2(((log2(invLinearColor)) * (toe)))) * (1.0f - startColor)) * (linearBegin))) + (((maxNit) - ((exp2((((contrastFactor)*color) + (mulLinearStartContrastFactor)))) * (displayMaxNitSubContrastFactor))) * linearStartColor));
 */

  float _2673 = (invLinearBegin)*color.r;
  float _2681 = 1.0f;
  // linearBegin
  if ((!(color.r >= (linearBegin)))) {
    _2681 = ((_2673 * _2673) * (3.0f - (_2673 * 2.0f)));
  }
  // invLinearBegin
  float _2682 = (invLinearBegin)*color.g;
  float _2690 = 1.0f;
  if ((!(color.g >= (linearBegin)))) {
    _2690 = ((_2682 * _2682) * (3.0f - (_2682 * 2.0f)));
  }
  float _2691 = (invLinearBegin)*color.b;
  float _2699 = 1.0f;
  if ((!(color.b >= (linearBegin)))) {
    _2699 = ((_2691 * _2691) * (3.0f - (_2691 * 2.0f)));
  }
  // linearStart
  float _2708 = (((bool)((color.r < (linearStart)))) ? 0.0f : 1.0f);
  float _2709 = (((bool)((color.g < (linearStart)))) ? 0.0f : 1.0f);
  float _2710 = (((bool)((color.b < (linearStart)))) ? 0.0f : 1.0f);

  // contrast + madLinearStartContrastFactor + toe (and max nits and other stuff)
  color.r = ((((((contrast)*color.r) + (madLinearStartContrastFactor)) * (_2681 - _2708)) + (((exp2(((log2(_2673)) * (toe)))) * (1.0f - _2681)) * (linearBegin))) + (((maxNit) - ((exp2((((contrastFactor)*color.r) + (mulLinearStartContrastFactor)))) * (displayMaxNitSubContrastFactor))) * _2708));
  color.g = ((((((contrast)*color.g) + (madLinearStartContrastFactor)) * (_2690 - _2709)) + (((exp2(((log2(_2682)) * (toe)))) * (1.0f - _2690)) * (linearBegin))) + (((maxNit) - ((exp2((((contrastFactor)*color.g) + (mulLinearStartContrastFactor)))) * (displayMaxNitSubContrastFactor))) * _2709));
  color.b = ((((((contrast)*color.b) + (madLinearStartContrastFactor)) * (_2699 - _2710)) + (((exp2(((log2(_2691)) * (toe)))) * (1.0f - _2699)) * (linearBegin))) + (((maxNit) - ((exp2((((contrastFactor)*color.b) + (mulLinearStartContrastFactor)))) * (displayMaxNitSubContrastFactor))) * _2710));

  return color;
}
