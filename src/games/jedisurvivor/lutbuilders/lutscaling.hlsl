#include "../common.hlsl"
#include "../includes/lutbuilder_cbuffer.hlsl"
#include "../shared.h"

// from Pumbo
// 0 None
// 1 Reduce saturation and increase brightness until luminance is >= 0
// 2 Clip negative colors (makes luminance >= 0)
// 3 Snap to black
void FixColorGradingLUTNegativeLuminance(inout float3 col, uint type = 1) {
  if (type <= 0) {
    return;
  }

  float luminance = renodx::color::y::from::AP1(col.xyz);
  if (luminance < -renodx::math::FLT_MIN)  // -asfloat(0x00800000): -1.175494351e-38f
  {
    if (type == 1) {
      // Make the color more "SDR" (less saturated, and thus less beyond Rec.709) until the luminance is not negative anymore (negative luminance means the color was beyond Rec.709 to begin with, unless all components were negative).
      // This is preferrable to simply clipping all negative colors or snapping to black, because it keeps some HDR colors, even if overall it's still "black", luminance wise.
      // This should work even in case "positiveLuminance" was <= 0, as it will simply make the color black.
      float3 positiveColor = max(col.xyz, 0.0);
      float3 negativeColor = min(col.xyz, 0.0);
      float positiveLuminance = renodx::color::y::from::AP1(positiveColor);
      float negativeLuminance = renodx::color::y::from::AP1(negativeColor);
#pragma warning(disable: 4008)
      float negativePositiveLuminanceRatio = positiveLuminance / -negativeLuminance;
#pragma warning(default: 4008)
      negativeColor.xyz *= negativePositiveLuminanceRatio;
      col.xyz = positiveColor + negativeColor;
    } else if (type == 2) {
      // This can break gradients as it snaps colors to brighter ones (it depends on how the displays clips HDR10 or scRGB invalid colors)
      col.xyz = max(col.xyz, 0.0);
    } else  // if (type >= 3)
    {
      col.xyz = 0.0;
    }
  }
}

float3 ChrominanceOKLab(
    float3 incorrect_color,
    float3 reference_color,
    float strength = 1.f,
    float blowout_restoration = 0.f) {
  if (strength == 0.f) return incorrect_color;

  float3 incorrect_lab = renodx::color::oklab::from::BT709(incorrect_color);
  float3 reference_lab = renodx::color::oklab::from::BT709(reference_color);

  float2 incorrect_ab = incorrect_lab.yz;
  float2 reference_ab = reference_lab.yz;

  // Compute chrominance (magnitude of the a–b vector)
  float incorrect_chrominance = length(incorrect_ab);
  float correct_chrominance = length(reference_ab);

  // Scale original chrominance vector toward target chrominance
  float chrominance_ratio = renodx::math::DivideSafe(correct_chrominance, incorrect_chrominance, 1.f);
  float scale = lerp(1.f, chrominance_ratio, strength);

  float t = 1.0f - step(1.0f, scale);  // t = 1 when scale < 1, 0 when scale >= 1
  scale = lerp(scale, 1.0f, t * blowout_restoration);

  incorrect_lab.yz = incorrect_ab * scale;

  float3 result = renodx::color::bt709::from::OkLab(incorrect_lab);
  return result;
}

float3 ChrominanceICtCp(
    float3 incorrect_color,
    float3 reference_color,
    float strength = 1.f,
    float blowout_restoration = 0.f) {
  if (strength == 0.f) return incorrect_color;

  float3 incorrect_lab = renodx::color::ictcp::from::BT709(incorrect_color);
  float3 reference_lab = renodx::color::ictcp::from::BT709(reference_color);

  float2 incorrect_ab = incorrect_lab.yz;
  float2 reference_ab = reference_lab.yz;

  // Compute chrominance (magnitude of the Ct-Cp vector)
  float incorrect_chrominance = length(incorrect_ab);
  float correct_chrominance = length(reference_ab);

  // Scale original chrominance vector toward target chrominance
  float chrominance_ratio = renodx::math::DivideSafe(correct_chrominance, incorrect_chrominance, 1.f);
  float scale = lerp(1.f, chrominance_ratio, strength);

  float t = 1.0f - step(1.0f, scale);  // t = 1 when scale < 1, 0 when scale >= 1
  scale = lerp(scale, 1.0f, t * blowout_restoration);

  incorrect_lab.yz = incorrect_ab * scale;

  float3 result = renodx::color::bt709::from::ICtCp(incorrect_lab);
  return result;
}

float3 ChrominanceAndHueOKLab(float3 incorrect_color, float3 correct_color, float strength = 1.f) {
  if (strength == 0.f) return incorrect_color;

  float3 incorrect_lab = renodx::color::oklab::from::BT709(incorrect_color);
  float3 correct_lab = renodx::color::oklab::from::BT709(correct_color);

  incorrect_lab.yz = correct_lab.yz;

  float3 result = renodx::color::bt709::from::OkLab(incorrect_lab);
  return result;
}

float3 HueCorrectAP1(float3 incorrect_color_ap1, float3 correct_color_ap1, float hue_correct_strength = 0.5f) {
  float3 incorrect_color_bt709 = renodx::color::bt709::from::AP1(incorrect_color_ap1);
  float3 correct_color_bt709 = renodx::color::bt709::from::AP1(correct_color_ap1);

  float3 corrected_color_bt709 = renodx::color::correct::Hue(incorrect_color_bt709, correct_color_bt709, hue_correct_strength, 0u);
  float3 corrected_color_ap1 = renodx::color::ap1::from::BT709(corrected_color_bt709);
  return corrected_color_ap1;
}

/// Piecewise custom ARRI-style log/linear encoding
#define CUSTOM_ARRILOG_ENCODE_GENERATOR(T)       \
  T CustomArriLogEncode(T x) {                   \
    const float a = 5.5555548667907715f;         \
    const float b = 0.05227227509021759f;        \
    const float c = 0.1111111119389534f;         \
    const float d = 0.3010300099849701f;         \
    const float e = 21.7147216796875f;           \
    const float f = -1.184222936630249f;         \
    const float g = 0.24718964099884033f;        \
    const float h = 0.3855369985103607f;         \
    T tmp = mad(x, a, b);                        \
    T logseg = log2(tmp) * d;                    \
    T linseg = mad(x, e, f);                     \
    T encoded = select(tmp > c, logseg, linseg); \
    return mad(encoded, g, h);                   \
  }

CUSTOM_ARRILOG_ENCODE_GENERATOR(float)
CUSTOM_ARRILOG_ENCODE_GENERATOR(float3)
#undef CUSTOM_ARRILOG_ENCODE_GENERATOR

// Helper for decoding G/B channels (with *0.18)
float CustomArriLogDecodeGB(float x) {
  const float a = 0.3855369985103607f;
  const float b = 1.035006046295166f;
  const float c = 0.3552471697330475f;
  const float d = 0.1111111119389534f;
  const float e = 13.438782691955566f;
  const float f = -0.05227227509021759f;
  const float g = 0.18000002205371857f;
  float shifted = x - a;
  float toe = mad(shifted, b, c);
  float expseg = exp2(shifted * e);
  float val = select(toe > d, expseg, toe);
  return (val + f) * g;
}

// Main float3 decode (R is different from G/B)
float3 CustomArriLogDecode(float3 x) {
  // Red channel (R): same as G/B, but NO final * 0.18
  const float a = 0.3855369985103607f;
  const float b = 1.035006046295166f;
  const float c = 0.3552471697330475f;
  const float d = 0.1111111119389534f;
  const float e = 13.438782691955566f;
  const float f = -0.05227227509021759f;
  float shifted = x.r - a;
  float toe = mad(shifted, b, c);
  float expseg = exp2(shifted * e);
  float val = select(toe > d, expseg, toe);
  float red = val + f;

  // G and B use the helper (includes * 0.18)
  float green = CustomArriLogDecodeGB(x.g);
  float blue = CustomArriLogDecodeGB(x.b);

  return float3(red, green, blue);
}

float3 AP1_to_ARRI_Bradford(float3 ap1) {
  float3x3 M = {
    { 1.0388120412826538f, -0.09624255448579788f, 0.05743134021759033f },
    { -0.04460305720567703f, 0.8598613142967224f, 0.1847389042377472f },
    { -0.009779874235391617f, 0.051399022340774536f, 0.9583789706230164f }
  };
  return mul(ap1, M);
}

// optimized red * 0.18
float3 ARRI_Bradford_to_AP1_optimized_red(float3 arri) {
  float3x3 M = {
    { 0.17401212453842163f, 0.11296817660331726f, -0.07971039414405823f },
    { 0.008746111765503883f, 1.182213306427002f, -0.23079706728458405f },
    { 0.0013065641978755593f, -0.06225089356303215f, 1.0549932718276978f }
  };
  return mul(arri, M);
}

// AP1 in, AP1 out
float3 ApplyLUT(float3 pre_lut_color, Texture2D<float4> t0, Texture2D<float4> t1, SamplerState s0, bool return_encoded = false) {
  float _393, _394, _395;
  float _932, _933, _934;

  float _294 = pre_lut_color.r, _297 = pre_lut_color.g, _300 = pre_lut_color.b;

  // AP1 -> ARRI Wide Gamut (with Bradford)
  float3 arri = AP1_to_ARRI_Bradford(pre_lut_color);

  // Alexa Wide Gamut Y
  float _310 = dot(arri, float3(0.29195401072502136f, 0.8238409757614136f, -0.11579500138759613f));

  // Custom Arri Encoding
  float3 unencoded1 = arri;
  float3 encoded1 = CustomArriLogEncode(unencoded1);
  float _323 = encoded1.x, _336 = encoded1.y, _349 = encoded1.z;

  // sample LUT1
  if (!(cb0_067x == 0.0f)) {
    float _358 = (cb0_067x + -1.0f) / cb0_067x;
    float _362 = 0.5f / cb0_067x;
    float _364 = (_358 * saturate(_336)) + _362;
    float _366 = ((_358 * saturate(_349)) + _362) * cb0_067x;
    float _368 = floor(_366 + -0.5f);
    float _370 = (-0.5f - _368) + _366;
    float _371 = ((_358 * saturate(_323)) + _362) + _368;
    float4 _373 = t0.Sample(s0, float2((_371 / cb0_067x), _364));
    float4 _379 = t0.Sample(s0, float2(((_371 + 1.0f) / cb0_067x), _364));
    _393 = (lerp(_373.x, _379.x, _370));
    _394 = (lerp(_373.y, _379.y, _370));
    _395 = (lerp(_373.z, _379.z, _370));
  } else {
    _393 = _323;
    _394 = _336;
    _395 = _349;
  }
  float3 lut1_input_color = float3(_323, _336, _349);
  float3 lut1_output_color = float3(_393, _394, _395);
  lut1_output_color = lerp(lut1_input_color, lut1_output_color, 1.f);
  _393 = lut1_output_color.r, _394 = lut1_output_color.g, _395 = lut1_output_color.b;

  // XYZ_2_ALEXA Wide Gamut RGB (grayscale)
  float _398 = mad(-0.20007599890232086f, _310, mad(-0.4825339913368225f, _310, (_310 * 1.789065957069397f)));
  float _401 = mad(0.19443200528621674f, _310, mad(1.396399974822998f, _310, (_310 * -0.6398490071296692f)));
  float _404 = mad(0.8788679838180542f, _310, mad(0.08233500272035599f, _310, (_310 * -0.0415319986641407f)));

  // Same Custom ARRI Encoding
  float3 unencoded2 = float3(_398, _401, _404);
  float3 encoded2 = CustomArriLogEncode(unencoded2);
  float _417 = encoded2.x, _430 = encoded2.y, _443 = encoded2.z;

  float _457 = cb0_047w + cb0_053w;  // ColorOffset.w + ColorOffsetShadows.w
  float _471 = cb0_046w * cb0_052w;
  float _485 = cb0_045w * cb0_051w;
  float _499 = cb0_044w * cb0_050w;
  float _513 = cb0_043w * cb0_049w;
  float _524 = cb0_042w * cb0_048w;
  float _525 = _393 - _417;
  float _526 = _394 - _430;
  float _527 = _395 - _443;

  // not in the usual code block
  float _576 = (cb0_044x * cb0_050x) * _499;
  float _577 = (cb0_044y * cb0_050y) * _499;
  float _578 = (cb0_044z * cb0_050z) * _499;

  float _606 = saturate(_310 / cb0_066x);
  float _610 = (_606 * _606) * (3.0f - (_606 * 2.0f));
  float _611 = 1.0f - _610;
  float _620 = cb0_047w + cb0_065w;
  float _629 = cb0_046w * cb0_064w;
  float _638 = cb0_045w * cb0_063w;
  float _647 = cb0_044w * cb0_062w;
  float _656 = cb0_043w * cb0_061w;
  float _662 = cb0_042w * cb0_060w;

  // not in the usual code block
  float _711 = (cb0_044x * cb0_062x) * _647;
  float _712 = (cb0_044y * cb0_062y) * _647;
  float _713 = (cb0_044z * cb0_062z) * _647;

  float _742 = saturate((_310 - cb0_066y) / (1.0f - cb0_066y));
  float _746 = (_742 * _742) * (3.0f - (_742 * 2.0f));
  float _755 = cb0_047w + cb0_059w;
  float _764 = cb0_046w * cb0_058w;
  float _773 = cb0_045w * cb0_057w;
  float _782 = cb0_044w * cb0_056w;
  float _791 = cb0_043w * cb0_055w;
  float _797 = cb0_042w * cb0_054w;

  // not in the usual code block
  float _846 = (cb0_044x * cb0_056x) * _782;
  float _847 = (cb0_044y * cb0_056y) * _782;
  float _848 = (cb0_044z * cb0_056z) * _782;

  float _873 = _610 - _746;

  float ColorOffsetx = cb0_047x;
  float ColorOffsety = cb0_047y;
  float ColorOffsetz = cb0_047z;

  float ColorOffsetShadowsx = cb0_053x;
  float ColorOffsetShadowsy = cb0_053y;
  float ColorOffsetShadowsz = cb0_053z;

  float _884 = ((_746 * (((ColorOffsetx + cb0_065x) + _620) + (((cb0_046x * cb0_064x) * _629) * ((_711 + -1.0f) + (exp2(log2(exp2(((cb0_043x * cb0_061x) * _656) * log2(max(0.0f, ((((cb0_060x * _525) * cb0_042x) * _662) + _417)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_045x * cb0_063x) * _638))) * (2.0f - _711)))))) + (_611 * (((ColorOffsetx + ColorOffsetShadowsx) + _457) + (((cb0_046x * cb0_052x) * _471) * ((_576 + -1.0f) + (exp2(log2(exp2(((cb0_043x * cb0_049x) * _513) * log2(max(0.0f, ((((cb0_048x * _525) * cb0_042x) * _524) + _417)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_045x * cb0_051x) * _485))) * (2.0f - _576))))))) + ((((ColorOffsetx + cb0_059x) + _755) + (((cb0_046x * cb0_058x) * _764) * ((_846 + -1.0f) + (exp2(log2(exp2(((cb0_043x * cb0_055x) * _791) * log2(max(0.0f, ((((cb0_054x * _525) * cb0_042x) * _797) + _417)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_045x * cb0_057x) * _773))) * (2.0f - _846))))) * _873);
  float _886 = ((_746 * (((ColorOffsety + cb0_065y) + _620) + (((cb0_046y * cb0_064y) * _629) * ((_712 + -1.0f) + (exp2(log2(exp2(((cb0_043y * cb0_061y) * _656) * log2(max(0.0f, ((((cb0_060y * _526) * cb0_042y) * _662) + _430)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_045y * cb0_063y) * _638))) * (2.0f - _712)))))) + (_611 * (((ColorOffsety + ColorOffsetShadowsy) + _457) + (((cb0_046y * cb0_052y) * _471) * ((_577 + -1.0f) + (exp2(log2(exp2(((cb0_043y * cb0_049y) * _513) * log2(max(0.0f, ((((cb0_048y * _526) * cb0_042y) * _524) + _430)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_045y * cb0_051y) * _485))) * (2.0f - _577))))))) + ((((ColorOffsety + cb0_059y) + _755) + (((cb0_046y * cb0_058y) * _764) * ((_847 + -1.0f) + (exp2(log2(exp2(((cb0_043y * cb0_055y) * _791) * log2(max(0.0f, ((((cb0_054y * _526) * cb0_042y) * _797) + _430)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_045y * cb0_057y) * _773))) * (2.0f - _847))))) * _873);
  float _888 = ((_746 * (((ColorOffsetz + cb0_065z) + _620) + (((cb0_046z * cb0_064z) * _629) * ((_713 + -1.0f) + (exp2(log2(exp2(((cb0_043z * cb0_061z) * _656) * log2(max(0.0f, ((((cb0_060z * _527) * cb0_042z) * _662) + _443)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_045z * cb0_063z) * _638))) * (2.0f - _713)))))) + (_611 * (((ColorOffsetz + ColorOffsetShadowsz) + _457) + (((cb0_046z * cb0_052z) * _471) * ((_578 + -1.0f) + (exp2(log2(exp2(((cb0_043z * cb0_049z) * _513) * log2(max(0.0f, ((((cb0_048z * _527) * cb0_042z) * _524) + _443)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_045z * cb0_051z) * _485))) * (2.0f - _578))))))) + ((((ColorOffsetz + cb0_059z) + _755) + (((cb0_046z * cb0_058z) * _764) * ((_848 + -1.0f) + (exp2(log2(exp2(((cb0_043z * cb0_055z) * _791) * log2(max(0.0f, ((((cb0_054z * _527) * cb0_042z) * _797) + _443)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_045z * cb0_057z) * _773))) * (2.0f - _848))))) * _873);

  // sample LUT2
  if (!(cb0_067y == 0.0f)) {
    float _897 = (cb0_067y + -1.0f) / cb0_067y;
    float _901 = 0.5f / cb0_067y;
    float _903 = (_897 * saturate(_886)) + _901;
    float _905 = ((_897 * saturate(_888)) + _901) * cb0_067y;
    float _907 = floor(_905 + -0.5f);
    float _909 = (-0.5f - _907) + _905;
    float _910 = ((_897 * saturate(_884)) + _901) + _907;
    float4 _912 = t1.Sample(s0, float2((_910 / cb0_067y), _903));
    float4 _918 = t1.Sample(s0, float2(((_910 + 1.0f) / cb0_067y), _903));
    _932 = (lerp(_912.x, _918.x, _909));
    _933 = (lerp(_912.y, _918.y, _909));
    _934 = (lerp(_912.z, _918.z, _909));
  } else {
    _932 = _884;
    _933 = _886;
    _934 = _888;
  }
  float3 lut2_input_color = float3(_884, _886, _888);
  float3 lut2_output_color = float3(_932, _933, _934);
  lut2_output_color = lerp(lut2_input_color, lut2_output_color, 1.f);
  _932 = lut2_output_color.r, _933 = lut2_output_color.g, _934 = lut2_output_color.b;

  if (return_encoded) return lut2_output_color;

  // Encode Blend of Encoding and grayscale to Custom ARRI (different)
  float3 undecoded3 = float3(_932, _933, _934);
  float3 decoded3 = CustomArriLogDecode(undecoded3);
  float _944 = decoded3.x, _955 = decoded3.y, _966 = decoded3.z;

  // ARRI -> AP1 with Bradford (optimized red * 0.18)
  float3 lut_output_final = ARRI_Bradford_to_AP1_optimized_red(float3(_944, _955, _966));

  return lut_output_final;
}

float3 RecolorUnclampedAP1(float3 original_linear, float3 unclamped_linear, float strength = 1.f) {
  const float3 original_perceptual = renodx::color::oklab::from::BT709(renodx::color::bt709::from::AP1(original_linear));

  // Hue correction
  float3 retinted_perceptual = renodx::color::oklab::from::BT709(unclamped_linear);
  retinted_perceptual[0] = max(0, retinted_perceptual[0]);
  retinted_perceptual[1] = original_perceptual[1];
  retinted_perceptual[2] = original_perceptual[2];

  // Blend values
  retinted_perceptual = lerp(original_perceptual, retinted_perceptual, strength);

  float3 retinted_linear = renodx::color::bt709::from::OkLab(retinted_perceptual);
  retinted_linear = renodx::color::ap1::from::BT709(retinted_linear);
  return retinted_linear;
}

float3 UnclampARRILog(
    float3 original_arri,  // LUT output in ARRI log space
    float3 black_arri,     // ARRI-encoded value of (0,0,0)
    float3 mid_gray_arri,  // ARRI-encoded value of (0.18,0.18,0.18)
    float3 neutral_arri    // ARRI-encoded input color
) {
  const float ARRI_BLACK = CustomArriLogEncode(0.f);  // 0.09280935594213702f
  const float3 added = black_arri;

  const float mid_gray_average = renodx::math::Average(mid_gray_arri);

  // Remove offset from black up to midgray
  const float shadow_length = mid_gray_average;
  const float shadow_stop = max(neutral_arri.r, max(neutral_arri.g, neutral_arri.b));
  const float3 floor_remove = added * max(0, shadow_length - shadow_stop) / shadow_length;

  const float3 unclamped_arri = max(ARRI_BLACK, original_arri - floor_remove);
  return unclamped_arri;
}

float3 CorrectBlackARRI(float3 lut_output_color_ap1, float3 lut_input_color_ap1, Texture2D<float4> t0, Texture2D<float4> t1, SamplerState s0) {
  float3 black_arri = ApplyLUT(float3(0, 0, 0), t0, t1, s0, true);

  // float black_level = CustomArriLogEncode(AP1_to_ARRI_Bradford(black_arri);

  float3 original_arri = CustomArriLogEncode(AP1_to_ARRI_Bradford(lut_output_color_ap1));
  float3 mid_gray_arri = ApplyLUT(float3(0.18, 0.18, 0.18), t0, t1, s0, true);
  float3 neutral_arri = CustomArriLogEncode(AP1_to_ARRI_Bradford(lut_input_color_ap1));

  float3 arri_unclamped = UnclampARRILog(
      original_arri,
      black_arri,
      mid_gray_arri,
      neutral_arri);

  float3 ap1_unclamped = ARRI_Bradford_to_AP1_optimized_red(CustomArriLogDecode(arri_unclamped));

  ap1_unclamped = RecolorUnclampedAP1(lut_output_color_ap1, ap1_unclamped);

  return ap1_unclamped;
}

// float3 LUTCorrectBlack(float3 lut_output_color_ap1, float3 lut_input_color_ap1, Texture2D<float4> t0, Texture2D<float4> t1, SamplerState s0) {
//   if (CUSTOM_LUT_SCALING) {
//     float3 corrected_black = CorrectBlackARRI(lut_output_color_ap1, lut_input_color_ap1, t0, t1, s0);

//     lut_output_color_ap1 = lerp(lut_output_color_ap1, corrected_black, CUSTOM_LUT_SCALING);
//   }

//   return lut_output_color_ap1;
// }

float3 CorrectBlack(float3 color_input, float3 lut_color, float lut_black_y, float strength) {
  const float input_y = renodx::color::y::from::AP1(max(0, color_input));
  const float color_y = renodx::color::y::from::AP1(max(0, lut_color));
  const float a = lut_black_y;
  const float b = lerp(0, lut_black_y, strength);
  const float g = input_y;
  const float h = color_y;
  const float new_y = h - pow(lut_black_y, pow(1.f + g, b / a));
  float3 new_lut_color = lut_color * ((color_y > 0) ? min(color_y, new_y) / color_y : 1.f);

  return new_lut_color;
}

float3 CorrectBlackPerChannel(float3 color_input, float3 lut_color, float3 lut_black, float strength) {
  // For each channel: r, g, b
  float3 input_c = (color_input);
  float3 color_c = (lut_color);
  float3 a = lut_black;  // Black level per channel
  float3 b = lerp(float3(0, 0, 0), lut_black, strength);
  float3 g = input_c;
  float3 h = color_c;

  // New value per channel
  float3 new_c = h - pow(lut_black, pow(1.0 + g, b / a));
  // Protect against divide by zero
  float3 out_color = lut_color * select((color_c > 0), min(color_c, new_c) / color_c, 1.0);

  return out_color;
}

float3 CorrectBlackChrominance(float3 lut_input_color_ap1, float3 lut_output_color_ap1, float3 min_black, float lut_min_y, float strength) {
  float3 corrected_black_ch = CorrectBlackPerChannel(lut_input_color_ap1, lut_output_color_ap1, min_black, strength);
  float3 corrected_black_lum = CorrectBlack(lut_input_color_ap1, lut_output_color_ap1, lut_min_y, strength);
  float3 corrected_black = renodx::color::ap1::from::BT709(ChrominanceICtCp(renodx::color::bt709::from::AP1(corrected_black_lum), renodx::color::bt709::from::AP1(corrected_black_ch), 1.f, 1.f));

  return corrected_black;
}

float3 LUTCorrectBlack(float3 lut_output_color_ap1, float3 lut_input_color_ap1, Texture2D<float4> t0, Texture2D<float4> t1, SamplerState s0) {
  if (CUSTOM_LUT_SCALING) {
    float3 min_black = max(0, ApplyLUT(float3(0, 0, 0), t0, t1, s0));
    float lut_min_y = (renodx::color::y::from::AP1(min_black));
    if (lut_min_y > 0) {
      lut_input_color_ap1 *= max(0, ApplyLUT(float3(0.18, 0.18, 0.18), t0, t1, s0)) / 0.18f;  // align midgray of pre and post lut colors

      // Strength at 80 is actually weaker, brings down shadows in such a way that it targets only the darkest shadows
      // This is needed as ACES and gamma correction afterwards bring down shadows even more
      // It's abusing the function but that will have to do for now
      // float3 corrected_black = CorrectBlackChrominance(lut_input_color_ap1, lut_output_color_ap1, min_black, lut_min_y, 80.f);
      float3 corrected_black = (CorrectBlack(lut_input_color_ap1, lut_output_color_ap1, lut_min_y, 80.f));

      lut_output_color_ap1 = lerp(lut_output_color_ap1, corrected_black, CUSTOM_LUT_SCALING);
    }
  }

  return lut_output_color_ap1;
}
