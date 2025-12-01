#ifndef RENODX_SILENTHILL2_CBUFFERS_LUTBUILDER_H
#define RENODX_SILENTHILL2_CBUFFERS_LUTBUILDER_H

#include "../../shared.h"

// the list of variables in cb0 in lutbuilder 0x865E53FC is a superset of all the others
// this means we don't need to use preprocessor definitions to switch between different cbuffer layouts
// we can just use this one cbuffer for everything
cbuffer cb0 : register(b0) {
  float cb0_005x : packoffset(c005.x);
  float cb0_005y : packoffset(c005.y);
  float cb0_005z : packoffset(c005.z);
  float cb0_005w : packoffset(c005.w);
  float cb0_006x : packoffset(c006.x);
  float cb0_008x : packoffset(c008.x);
  float cb0_008y : packoffset(c008.y);
  float cb0_008z : packoffset(c008.z);
  float cb0_008w : packoffset(c008.w);
  float cb0_009x : packoffset(c009.x);
  float cb0_010x : packoffset(c010.x);
  float cb0_010y : packoffset(c010.y);
  float cb0_010z : packoffset(c010.z);
  float cb0_010w : packoffset(c010.w);
  float cb0_011x : packoffset(c011.x);
  float cb0_011y : packoffset(c011.y);
  float cb0_011z : packoffset(c011.z);
  float cb0_011w : packoffset(c011.w);
  float cb0_012x : packoffset(c012.x);
  float cb0_012y : packoffset(c012.y);
  float cb0_012z : packoffset(c012.z);
  float cb0_013x : packoffset(c013.x);
  float cb0_013y : packoffset(c013.y);
  float cb0_013z : packoffset(c013.z);
  float cb0_013w : packoffset(c013.w);
  float cb0_014x : packoffset(c014.x);
  float cb0_014y : packoffset(c014.y);
  float cb0_014z : packoffset(c014.z);
  float cb0_015x : packoffset(c015.x);
  float cb0_015y : packoffset(c015.y);
  float cb0_015z : packoffset(c015.z);
  float cb0_015w : packoffset(c015.w);
  float cb0_016x : packoffset(c016.x);
  float cb0_016y : packoffset(c016.y);
  float cb0_016z : packoffset(c016.z);
  float cb0_016w : packoffset(c016.w);
  float cb0_017x : packoffset(c017.x);
  float cb0_017y : packoffset(c017.y);
  float cb0_017z : packoffset(c017.z);
  float cb0_017w : packoffset(c017.w);
  float cb0_018x : packoffset(c018.x);
  float cb0_018y : packoffset(c018.y);
  float cb0_018z : packoffset(c018.z);
  float cb0_018w : packoffset(c018.w);
  float cb0_019x : packoffset(c019.x);
  float cb0_019y : packoffset(c019.y);
  float cb0_019z : packoffset(c019.z);
  float cb0_019w : packoffset(c019.w);
  float cb0_020x : packoffset(c020.x);
  float cb0_020y : packoffset(c020.y);
  float cb0_020z : packoffset(c020.z);
  float cb0_020w : packoffset(c020.w);
  float cb0_021x : packoffset(c021.x);
  float cb0_021y : packoffset(c021.y);
  float cb0_021z : packoffset(c021.z);
  float cb0_021w : packoffset(c021.w);
  float cb0_022x : packoffset(c022.x);
  float cb0_022y : packoffset(c022.y);
  float cb0_022z : packoffset(c022.z);
  float cb0_022w : packoffset(c022.w);
  float cb0_023x : packoffset(c023.x);
  float cb0_023y : packoffset(c023.y);
  float cb0_023z : packoffset(c023.z);
  float cb0_023w : packoffset(c023.w);
  float cb0_024x : packoffset(c024.x);
  float cb0_024y : packoffset(c024.y);
  float cb0_024z : packoffset(c024.z);
  float cb0_024w : packoffset(c024.w);
  float cb0_025x : packoffset(c025.x);
  float cb0_025y : packoffset(c025.y);
  float cb0_025z : packoffset(c025.z);
  float cb0_025w : packoffset(c025.w);
  float cb0_026x : packoffset(c026.x);
  float cb0_026y : packoffset(c026.y);
  float cb0_026z : packoffset(c026.z);
  float cb0_026w : packoffset(c026.w);
  float cb0_027x : packoffset(c027.x);
  float cb0_027y : packoffset(c027.y);
  float cb0_027z : packoffset(c027.z);
  float cb0_027w : packoffset(c027.w);
  float cb0_028x : packoffset(c028.x);
  float cb0_028y : packoffset(c028.y);
  float cb0_028z : packoffset(c028.z);
  float cb0_028w : packoffset(c028.w);
  float cb0_029x : packoffset(c029.x);
  float cb0_029y : packoffset(c029.y);
  float cb0_029z : packoffset(c029.z);
  float cb0_029w : packoffset(c029.w);
  float cb0_030x : packoffset(c030.x);
  float cb0_030y : packoffset(c030.y);
  float cb0_030z : packoffset(c030.z);
  float cb0_030w : packoffset(c030.w);
  float cb0_031x : packoffset(c031.x);
  float cb0_031y : packoffset(c031.y);
  float cb0_031z : packoffset(c031.z);
  float cb0_031w : packoffset(c031.w);
  float cb0_032x : packoffset(c032.x);
  float cb0_032y : packoffset(c032.y);
  float cb0_032z : packoffset(c032.z);
  float cb0_032w : packoffset(c032.w);
  float cb0_033x : packoffset(c033.x);
  float cb0_033y : packoffset(c033.y);
  float cb0_033z : packoffset(c033.z);
  float cb0_033w : packoffset(c033.w);
  float cb0_034x : packoffset(c034.x);
  float cb0_034y : packoffset(c034.y);
  float cb0_034z : packoffset(c034.z);
  float cb0_034w : packoffset(c034.w);
  float cb0_035x : packoffset(c035.x);
  float cb0_035y : packoffset(c035.y);
  float cb0_035z : packoffset(c035.z);
  float cb0_035w : packoffset(c035.w);
  float cb0_036x : packoffset(c036.x);
  float cb0_036y : packoffset(c036.y);
  float cb0_036z : packoffset(c036.z);
  float cb0_036w : packoffset(c036.w);
  float cb0_037x : packoffset(c037.x);
  float cb0_037y : packoffset(c037.y);
  float cb0_037z : packoffset(c037.z);
  float cb0_037w : packoffset(c037.w);
  float cb0_038x : packoffset(c038.x);
  int cb0_038z : packoffset(c038.z);
  float cb0_039x : packoffset(c039.x);
  float cb0_039y : packoffset(c039.y);
  float cb0_039z : packoffset(c039.z);
  float cb0_040y : packoffset(c040.y);
  float cb0_040z : packoffset(c040.z);
  int cb0_040w : packoffset(c040.w);
  int cb0_041x : packoffset(c041.x);
  float cb0_042x : packoffset(c042.x);
  float cb0_042y : packoffset(c042.y);
};

// already declared as floats by ShortFuse's decompiler but we'll keep asfloat() here for clarity and easy copy-pasting
// other decompilers like the DXVK one declare the entire cbuffer as uints, requiring the use of asfloat() to interpret them as floats
static const float FilmBlackClip = asfloat(cb0_037w);
static const float FilmToe = asfloat(cb0_037y);
static const float FilmShoulder = asfloat(cb0_037z);
static const float FilmSlope = asfloat(cb0_037x);
static const float FilmWhiteClip = asfloat(cb0_038x);
static const float ToneCurveAmount = asfloat(cb0_036w);
static const float BlueCorrection = asfloat(cb0_036y);

#if ENABLE_CUSTOM_COLOR_CORRECTION  // only neeeded if you plan to use custom color correction
static const float4 ColorSaturation = float4(cb0_015x, cb0_015y, cb0_015z, cb0_015w);
static const float4 ColorContrast = float4(cb0_016x, cb0_016y, cb0_016z, cb0_016w);
static const float4 ColorGamma = float4(cb0_017x, cb0_017y, cb0_017z, cb0_017w);
static const float4 ColorGain = float4(cb0_018x, cb0_018y, cb0_018z, cb0_018w);
static const float4 ColorOffset = float4(cb0_019x, cb0_019y, cb0_019z, cb0_019w);
static const float4 ColorSaturationShadows = float4(cb0_020x, cb0_020y, cb0_020z, cb0_020w);
static const float4 ColorContrastShadows = float4(cb0_021x, cb0_021y, cb0_021z, cb0_021w);
static const float4 ColorGammaShadows = float4(cb0_022x, cb0_022y, cb0_022z, cb0_022w);
static const float4 ColorGainShadows = float4(cb0_023x, cb0_023y, cb0_023z, cb0_023w);
static const float4 ColorOffsetShadows = float4(cb0_024x, cb0_024y, cb0_024z, cb0_024w);
static const float4 ColorSaturationMidtones = float4(cb0_025x, cb0_025y, cb0_025z, cb0_025w);
static const float4 ColorContrastMidtones = float4(cb0_026x, cb0_026y, cb0_026z, cb0_026w);
static const float4 ColorGammaMidtones = float4(cb0_027x, cb0_027y, cb0_027z, cb0_027w);
static const float4 ColorGainMidtones = float4(cb0_028x, cb0_028y, cb0_028z, cb0_028w);
static const float4 ColorOffsetMidtones = float4(cb0_029x, cb0_029y, cb0_029z, cb0_029w);
static const float4 ColorSaturationHighlights = float4(cb0_030x, cb0_030y, cb0_030z, cb0_030w);
static const float4 ColorContrastHighlights = float4(cb0_031x, cb0_031y, cb0_031z, cb0_031w);
static const float4 ColorGammaHighlights = float4(cb0_032x, cb0_032y, cb0_032z, cb0_032w);
static const float4 ColorGainHighlights = float4(cb0_033x, cb0_033y, cb0_033z, cb0_033w);
static const float4 ColorOffsetHighlights = float4(cb0_034x, cb0_034y, cb0_034z, cb0_034w);

static const float ColorCorrectionShadowsMax = asfloat(cb0_035z);
static const float ColorCorrectionHighlightsMin = asfloat(cb0_035w);
static const float ColorCorrectionHighlightsMax = asfloat(cb0_036x);
#endif  // ENABLE_CUSTOM_COLOR_CORRECTION

#if USES_SDR_LUTS
static float4 LUTWeights[2] = {
  float4(cb0_005x, cb0_005y, cb0_005z, cb0_005w),
  float4(cb0_006x, 0.f, 0.f, 0.f)  // only x is populated in SH2; the rest are unused
};
#endif  // USES_SDR_LUTS

static uint output_device = uint(cb0_040w);
static uint output_gamut = uint(cb0_041x);
static float expand_gamut = cb0_036z;
static bool is_hdr = (output_device >= 3u) && (output_gamut <= 6u);

void ApplyLUTOutputOverrides() {
  if (RENODX_TONE_MAP_TYPE != 0.f && is_hdr) {
    output_device = 0u;
    output_gamut = 0u;
    expand_gamut = 0.f;
  }
}

#endif  // RENODX_SILENTHILL2_CBUFFERS_LUTBUILDER_H
