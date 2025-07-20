#include "../common.hlsl"

Texture2D<float4> Textures_1 : register(t0);

Texture2D<float4> Textures_2 : register(t1);

Texture2D<float4> Textures_3 : register(t2);

Texture2D<float4> Textures_4 : register(t3);

RWTexture3D<float4> RWOutputTexture : register(u0);

cbuffer _RootShaderParameters : register(b0) {
  float4 LUTWeights[2] : packoffset(c005.x);
  float4 ACESMinMaxData : packoffset(c008.x);
  float4 ACESMidData : packoffset(c009.x);
  float4 ACESCoefsLow_0 : packoffset(c010.x);
  float4 ACESCoefsHigh_0 : packoffset(c011.x);
  float ACESCoefsLow_4 : packoffset(c012.x);
  float ACESCoefsHigh_4 : packoffset(c012.y);
  float ACESSceneColorMultiplier : packoffset(c012.z);
  float4 OverlayColor : packoffset(c013.x);
  float3 ColorScale : packoffset(c014.x);
  float4 ColorSaturation : packoffset(c015.x);
  float4 ColorContrast : packoffset(c016.x);
  float4 ColorGamma : packoffset(c017.x);
  float4 ColorGain : packoffset(c018.x);
  float4 ColorOffset : packoffset(c019.x);
  float4 ColorSaturationShadows : packoffset(c020.x);
  float4 ColorContrastShadows : packoffset(c021.x);
  float4 ColorGammaShadows : packoffset(c022.x);
  float4 ColorGainShadows : packoffset(c023.x);
  float4 ColorOffsetShadows : packoffset(c024.x);
  float4 ColorSaturationMidtones : packoffset(c025.x);
  float4 ColorContrastMidtones : packoffset(c026.x);
  float4 ColorGammaMidtones : packoffset(c027.x);
  float4 ColorGainMidtones : packoffset(c028.x);
  float4 ColorOffsetMidtones : packoffset(c029.x);
  float4 ColorSaturationHighlights : packoffset(c030.x);
  float4 ColorContrastHighlights : packoffset(c031.x);
  float4 ColorGammaHighlights : packoffset(c032.x);
  float4 ColorGainHighlights : packoffset(c033.x);
  float4 ColorOffsetHighlights : packoffset(c034.x);
  float LUTSize : packoffset(c035.x);
  float WhiteTemp : packoffset(c035.y);
  float WhiteTint : packoffset(c035.z);
  float ColorCorrectionShadowsMax : packoffset(c035.w);
  float ColorCorrectionHighlightsMin : packoffset(c036.x);
  float ColorCorrectionHighlightsMax : packoffset(c036.y);
  float BlueCorrection : packoffset(c036.z);
  float ExpandGamut : packoffset(c036.w);
  float ToneCurveAmount : packoffset(c037.x);
  float FilmSlope : packoffset(c037.y);
  float FilmToe : packoffset(c037.z);
  float FilmShoulder : packoffset(c037.w);
  float FilmBlackClip : packoffset(c038.x);
  float FilmWhiteClip : packoffset(c038.y);
  uint bUseMobileTonemapper : packoffset(c038.z);
  uint bIsTemperatureWhiteBalance : packoffset(c038.w);
  float3 MappingPolynomial : packoffset(c039.x);
  float3 InverseGamma : packoffset(c040.x);
  uint OutputDevice : packoffset(c040.w);
  uint OutputGamut : packoffset(c041.x);
  float OutputMaxLuminance : packoffset(c041.y);
  float2 OutputExtentInverse : packoffset(c042.x);
};

cbuffer UniformBufferConstants_WorkingColorSpace : register(b1) {
  float4 WorkingColorSpace_ToXYZ[4] : packoffset(c000.x);
  float4 WorkingColorSpace_FromXYZ[4] : packoffset(c004.x);
  float4 WorkingColorSpace_ToAP1[4] : packoffset(c008.x);
  float4 WorkingColorSpace_FromAP1[4] : packoffset(c012.x);
  float4 WorkingColorSpace_ToAP0[4] : packoffset(c016.x);
  uint WorkingColorSpace_bIsSRGB : packoffset(c020.x);
};

SamplerState Samplers_1 : register(s0);

SamplerState Samplers_2 : register(s1);

SamplerState Samplers_3 : register(s2);

SamplerState Samplers_4 : register(s3);

[numthreads(8, 8, 8)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  float _28 = 0.5f / LUTSize;
  float _33 = LUTSize + -1.0f;
  float _57;
  float _58;
  float _59;
  float _60;
  float _61;
  float _62;
  float _63;
  float _64;
  float _65;
  float _128;
  float _835;
  float _868;
  float _882;
  float _946;
  float _1137;
  float _1148;
  float _1159;
  float _1381;
  float _1382;
  float _1383;
  float _1394;
  float _1405;
  float _1416;
  if (!((uint)(OutputGamut) == 1)) {
    if (!((uint)(OutputGamut) == 2)) {
      if (!((uint)(OutputGamut) == 3)) {
        bool _46 = ((uint)(OutputGamut) == 4);
        _57 = select(_46, 1.0f, 1.705051064491272f);
        _58 = select(_46, 0.0f, -0.6217921376228333f);
        _59 = select(_46, 0.0f, -0.0832589864730835f);
        _60 = select(_46, 0.0f, -0.13025647401809692f);
        _61 = select(_46, 1.0f, 1.140804648399353f);
        _62 = select(_46, 0.0f, -0.010548308491706848f);
        _63 = select(_46, 0.0f, -0.024003351107239723f);
        _64 = select(_46, 0.0f, -0.1289689838886261f);
        _65 = select(_46, 1.0f, 1.1529725790023804f);
      } else {
        _57 = 0.6954522132873535f;
        _58 = 0.14067870378494263f;
        _59 = 0.16386906802654266f;
        _60 = 0.044794563204050064f;
        _61 = 0.8596711158752441f;
        _62 = 0.0955343171954155f;
        _63 = -0.005525882821530104f;
        _64 = 0.004025210160762072f;
        _65 = 1.0015007257461548f;
      }
    } else {
      _57 = 1.0258246660232544f;
      _58 = -0.020053181797266006f;
      _59 = -0.005771636962890625f;
      _60 = -0.002234415616840124f;
      _61 = 1.0045864582061768f;
      _62 = -0.002352118492126465f;
      _63 = -0.005013350863009691f;
      _64 = -0.025290070101618767f;
      _65 = 1.0303035974502563f;
    }
  } else {
    _57 = 1.3792141675949097f;
    _58 = -0.30886411666870117f;
    _59 = -0.0703500509262085f;
    _60 = -0.06933490186929703f;
    _61 = 1.08229660987854f;
    _62 = -0.012961871922016144f;
    _63 = -0.0021590073592960835f;
    _64 = -0.0454593189060688f;
    _65 = 1.0476183891296387f;
  }
  float _78 = (exp2((((LUTSize * ((OutputExtentInverse.x * (float((uint)SV_DispatchThreadID.x) + 0.5f)) - _28)) / _33) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _79 = (exp2((((LUTSize * ((OutputExtentInverse.y * (float((uint)SV_DispatchThreadID.y) + 0.5f)) - _28)) / _33) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _80 = (exp2(((float((uint)SV_DispatchThreadID.z) / _33) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  bool _107 = ((uint)(bIsTemperatureWhiteBalance) != 0);
  float _111 = 0.9994439482688904f / WhiteTemp;
  if (!(!((WhiteTemp * 1.0005563497543335f) <= 7000.0f))) {
    _128 = (((((2967800.0f - (_111 * 4607000064.0f)) * _111) + 99.11000061035156f) * _111) + 0.24406300485134125f);
  } else {
    _128 = (((((1901800.0f - (_111 * 2006400000.0f)) * _111) + 247.47999572753906f) * _111) + 0.23703999817371368f);
  }
  float _142 = ((((WhiteTemp * 1.2864121856637212e-07f) + 0.00015411825734190643f) * WhiteTemp) + 0.8601177334785461f) / ((((WhiteTemp * 7.081451371959702e-07f) + 0.0008424202096648514f) * WhiteTemp) + 1.0f);
  float _149 = WhiteTemp * WhiteTemp;
  float _152 = ((((WhiteTemp * 4.204816761443908e-08f) + 4.228062607580796e-05f) * WhiteTemp) + 0.31739872694015503f) / ((1.0f - (WhiteTemp * 2.8974181986995973e-05f)) + (_149 * 1.6145605741257896e-07f));
  float _157 = ((_142 * 2.0f) + 4.0f) - (_152 * 8.0f);
  float _158 = (_142 * 3.0f) / _157;
  float _160 = (_152 * 2.0f) / _157;
  bool _161 = (WhiteTemp < 4000.0f);
  float _170 = ((WhiteTemp + 1189.6199951171875f) * WhiteTemp) + 1412139.875f;
  float _172 = ((-1137581184.0f - (WhiteTemp * 1916156.25f)) - (_149 * 1.5317699909210205f)) / (_170 * _170);
  float _179 = (6193636.0f - (WhiteTemp * 179.45599365234375f)) + _149;
  float _181 = ((1974715392.0f - (WhiteTemp * 705674.0f)) - (_149 * 308.60699462890625f)) / (_179 * _179);
  float _183 = rsqrt(dot(float2(_172, _181), float2(_172, _181)));
  float _184 = WhiteTint * 0.05000000074505806f;
  float _187 = ((_184 * _181) * _183) + _142;
  float _190 = _152 - ((_184 * _172) * _183);
  float _195 = (4.0f - (_190 * 8.0f)) + (_187 * 2.0f);
  float _201 = (((_187 * 3.0f) / _195) - _158) + select(_161, _158, _128);
  float _202 = (((_190 * 2.0f) / _195) - _160) + select(_161, _160, (((_128 * 2.869999885559082f) + -0.2750000059604645f) - ((_128 * _128) * 3.0f)));
  float _203 = select(_107, _201, 0.3127000033855438f);
  float _204 = select(_107, _202, 0.32899999618530273f);
  float _205 = select(_107, 0.3127000033855438f, _201);
  float _206 = select(_107, 0.32899999618530273f, _202);
  float _207 = max(_204, 1.000000013351432e-10f);
  float _208 = _203 / _207;
  float _211 = ((1.0f - _203) - _204) / _207;
  float _212 = max(_206, 1.000000013351432e-10f);
  float _213 = _205 / _212;
  float _216 = ((1.0f - _205) - _206) / _212;
  float _235 = mad(-0.16140000522136688f, _216, ((_213 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _211, ((_208 * 0.8950999975204468f) + 0.266400009393692f));
  float _236 = mad(0.03669999912381172f, _216, (1.7135000228881836f - (_213 * 0.7501999735832214f))) / mad(0.03669999912381172f, _211, (1.7135000228881836f - (_208 * 0.7501999735832214f)));
  float _237 = mad(1.0296000242233276f, _216, ((_213 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _211, ((_208 * 0.03889999911189079f) + -0.06849999725818634f));
  float _238 = mad(_236, -0.7501999735832214f, 0.0f);
  float _239 = mad(_236, 1.7135000228881836f, 0.0f);
  float _240 = mad(_236, 0.03669999912381172f, -0.0f);
  float _241 = mad(_237, 0.03889999911189079f, 0.0f);
  float _242 = mad(_237, -0.06849999725818634f, 0.0f);
  float _243 = mad(_237, 1.0296000242233276f, 0.0f);
  float _246 = mad(0.1599626988172531f, _241, mad(-0.1470542997121811f, _238, (_235 * 0.883457362651825f)));
  float _249 = mad(0.1599626988172531f, _242, mad(-0.1470542997121811f, _239, (_235 * 0.26293492317199707f)));
  float _252 = mad(0.1599626988172531f, _243, mad(-0.1470542997121811f, _240, (_235 * -0.15930065512657166f)));
  float _255 = mad(0.04929120093584061f, _241, mad(0.5183603167533875f, _238, (_235 * 0.38695648312568665f)));
  float _258 = mad(0.04929120093584061f, _242, mad(0.5183603167533875f, _239, (_235 * 0.11516613513231277f)));
  float _261 = mad(0.04929120093584061f, _243, mad(0.5183603167533875f, _240, (_235 * -0.0697740763425827f)));
  float _264 = mad(0.9684867262840271f, _241, mad(0.04004279896616936f, _238, (_235 * -0.007634039502590895f)));
  float _267 = mad(0.9684867262840271f, _242, mad(0.04004279896616936f, _239, (_235 * -0.0022720457054674625f)));
  float _270 = mad(0.9684867262840271f, _243, mad(0.04004279896616936f, _240, (_235 * 0.0013765322510153055f)));
  float _273 = mad(_252, (WorkingColorSpace_ToXYZ[2].x), mad(_249, (WorkingColorSpace_ToXYZ[1].x), (_246 * (WorkingColorSpace_ToXYZ[0].x))));
  float _276 = mad(_252, (WorkingColorSpace_ToXYZ[2].y), mad(_249, (WorkingColorSpace_ToXYZ[1].y), (_246 * (WorkingColorSpace_ToXYZ[0].y))));
  float _279 = mad(_252, (WorkingColorSpace_ToXYZ[2].z), mad(_249, (WorkingColorSpace_ToXYZ[1].z), (_246 * (WorkingColorSpace_ToXYZ[0].z))));
  float _282 = mad(_261, (WorkingColorSpace_ToXYZ[2].x), mad(_258, (WorkingColorSpace_ToXYZ[1].x), (_255 * (WorkingColorSpace_ToXYZ[0].x))));
  float _285 = mad(_261, (WorkingColorSpace_ToXYZ[2].y), mad(_258, (WorkingColorSpace_ToXYZ[1].y), (_255 * (WorkingColorSpace_ToXYZ[0].y))));
  float _288 = mad(_261, (WorkingColorSpace_ToXYZ[2].z), mad(_258, (WorkingColorSpace_ToXYZ[1].z), (_255 * (WorkingColorSpace_ToXYZ[0].z))));
  float _291 = mad(_270, (WorkingColorSpace_ToXYZ[2].x), mad(_267, (WorkingColorSpace_ToXYZ[1].x), (_264 * (WorkingColorSpace_ToXYZ[0].x))));
  float _294 = mad(_270, (WorkingColorSpace_ToXYZ[2].y), mad(_267, (WorkingColorSpace_ToXYZ[1].y), (_264 * (WorkingColorSpace_ToXYZ[0].y))));
  float _297 = mad(_270, (WorkingColorSpace_ToXYZ[2].z), mad(_267, (WorkingColorSpace_ToXYZ[1].z), (_264 * (WorkingColorSpace_ToXYZ[0].z))));
  float _327 = mad(mad((WorkingColorSpace_FromXYZ[0].z), _297, mad((WorkingColorSpace_FromXYZ[0].y), _288, (_279 * (WorkingColorSpace_FromXYZ[0].x)))), _80, mad(mad((WorkingColorSpace_FromXYZ[0].z), _294, mad((WorkingColorSpace_FromXYZ[0].y), _285, (_276 * (WorkingColorSpace_FromXYZ[0].x)))), _79, (mad((WorkingColorSpace_FromXYZ[0].z), _291, mad((WorkingColorSpace_FromXYZ[0].y), _282, (_273 * (WorkingColorSpace_FromXYZ[0].x)))) * _78)));
  float _330 = mad(mad((WorkingColorSpace_FromXYZ[1].z), _297, mad((WorkingColorSpace_FromXYZ[1].y), _288, (_279 * (WorkingColorSpace_FromXYZ[1].x)))), _80, mad(mad((WorkingColorSpace_FromXYZ[1].z), _294, mad((WorkingColorSpace_FromXYZ[1].y), _285, (_276 * (WorkingColorSpace_FromXYZ[1].x)))), _79, (mad((WorkingColorSpace_FromXYZ[1].z), _291, mad((WorkingColorSpace_FromXYZ[1].y), _282, (_273 * (WorkingColorSpace_FromXYZ[1].x)))) * _78)));
  float _333 = mad(mad((WorkingColorSpace_FromXYZ[2].z), _297, mad((WorkingColorSpace_FromXYZ[2].y), _288, (_279 * (WorkingColorSpace_FromXYZ[2].x)))), _80, mad(mad((WorkingColorSpace_FromXYZ[2].z), _294, mad((WorkingColorSpace_FromXYZ[2].y), _285, (_276 * (WorkingColorSpace_FromXYZ[2].x)))), _79, (mad((WorkingColorSpace_FromXYZ[2].z), _291, mad((WorkingColorSpace_FromXYZ[2].y), _282, (_273 * (WorkingColorSpace_FromXYZ[2].x)))) * _78)));
  float _348 = mad((WorkingColorSpace_ToAP1[0].z), _333, mad((WorkingColorSpace_ToAP1[0].y), _330, ((WorkingColorSpace_ToAP1[0].x) * _327)));
  float _351 = mad((WorkingColorSpace_ToAP1[1].z), _333, mad((WorkingColorSpace_ToAP1[1].y), _330, ((WorkingColorSpace_ToAP1[1].x) * _327)));
  float _354 = mad((WorkingColorSpace_ToAP1[2].z), _333, mad((WorkingColorSpace_ToAP1[2].y), _330, ((WorkingColorSpace_ToAP1[2].x) * _327)));
  float _355 = dot(float3(_348, _351, _354), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));

  SetUngradedAP1(float3(_348, _351, _354));

  float _359 = (_348 / _355) + -1.0f;
  float _360 = (_351 / _355) + -1.0f;
  float _361 = (_354 / _355) + -1.0f;
  float _373 = (1.0f - exp2(((_355 * _355) * -4.0f) * ExpandGamut)) * (1.0f - exp2(dot(float3(_359, _360, _361), float3(_359, _360, _361)) * -4.0f));
  float _389 = ((mad(-0.06368321925401688f, _354, mad(-0.3292922377586365f, _351, (_348 * 1.3704125881195068f))) - _348) * _373) + _348;
  float _390 = ((mad(-0.010861365124583244f, _354, mad(1.0970927476882935f, _351, (_348 * -0.08343357592821121f))) - _351) * _373) + _351;
  float _391 = ((mad(1.2036951780319214f, _354, mad(-0.09862580895423889f, _351, (_348 * -0.02579331398010254f))) - _354) * _373) + _354;
  float _392 = dot(float3(_389, _390, _391), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _406 = ColorOffset.w + ColorOffsetShadows.w;
  float _420 = ColorGain.w * ColorGainShadows.w;
  float _434 = ColorGamma.w * ColorGammaShadows.w;
  float _448 = ColorContrast.w * ColorContrastShadows.w;
  float _462 = ColorSaturation.w * ColorSaturationShadows.w;
  float _466 = _389 - _392;
  float _467 = _390 - _392;
  float _468 = _391 - _392;
  float _525 = saturate(_392 / ColorCorrectionShadowsMax);
  float _529 = (_525 * _525) * (3.0f - (_525 * 2.0f));
  float _530 = 1.0f - _529;
  float _539 = ColorOffset.w + ColorOffsetHighlights.w;
  float _548 = ColorGain.w * ColorGainHighlights.w;
  float _557 = ColorGamma.w * ColorGammaHighlights.w;
  float _566 = ColorContrast.w * ColorContrastHighlights.w;
  float _575 = ColorSaturation.w * ColorSaturationHighlights.w;
  float _638 = saturate((_392 - ColorCorrectionHighlightsMin) / (ColorCorrectionHighlightsMax - ColorCorrectionHighlightsMin));
  float _642 = (_638 * _638) * (3.0f - (_638 * 2.0f));
  float _651 = ColorOffset.w + ColorOffsetMidtones.w;
  float _660 = ColorGain.w * ColorGainMidtones.w;
  float _669 = ColorGamma.w * ColorGammaMidtones.w;
  float _678 = ColorContrast.w * ColorContrastMidtones.w;
  float _687 = ColorSaturation.w * ColorSaturationMidtones.w;
  float _745 = _529 - _642;
  float _756 = ((_642 * (((ColorOffset.x + ColorOffsetHighlights.x) + _539) + (((ColorGain.x * ColorGainHighlights.x) * _548) * exp2(log2(exp2(((ColorContrast.x * ColorContrastHighlights.x) * _566) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationHighlights.x) * _575) * _466) + _392)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaHighlights.x) * _557)))))) + (_530 * (((ColorOffset.x + ColorOffsetShadows.x) + _406) + (((ColorGain.x * ColorGainShadows.x) * _420) * exp2(log2(exp2(((ColorContrast.x * ColorContrastShadows.x) * _448) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationShadows.x) * _462) * _466) + _392)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaShadows.x) * _434))))))) + ((((ColorOffset.x + ColorOffsetMidtones.x) + _651) + (((ColorGain.x * ColorGainMidtones.x) * _660) * exp2(log2(exp2(((ColorContrast.x * ColorContrastMidtones.x) * _678) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationMidtones.x) * _687) * _466) + _392)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaMidtones.x) * _669))))) * _745);
  float _758 = ((_642 * (((ColorOffset.y + ColorOffsetHighlights.y) + _539) + (((ColorGain.y * ColorGainHighlights.y) * _548) * exp2(log2(exp2(((ColorContrast.y * ColorContrastHighlights.y) * _566) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationHighlights.y) * _575) * _467) + _392)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaHighlights.y) * _557)))))) + (_530 * (((ColorOffset.y + ColorOffsetShadows.y) + _406) + (((ColorGain.y * ColorGainShadows.y) * _420) * exp2(log2(exp2(((ColorContrast.y * ColorContrastShadows.y) * _448) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationShadows.y) * _462) * _467) + _392)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaShadows.y) * _434))))))) + ((((ColorOffset.y + ColorOffsetMidtones.y) + _651) + (((ColorGain.y * ColorGainMidtones.y) * _660) * exp2(log2(exp2(((ColorContrast.y * ColorContrastMidtones.y) * _678) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationMidtones.y) * _687) * _467) + _392)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaMidtones.y) * _669))))) * _745);
  float _760 = ((_642 * (((ColorOffset.z + ColorOffsetHighlights.z) + _539) + (((ColorGain.z * ColorGainHighlights.z) * _548) * exp2(log2(exp2(((ColorContrast.z * ColorContrastHighlights.z) * _566) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationHighlights.z) * _575) * _468) + _392)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaHighlights.z) * _557)))))) + (_530 * (((ColorOffset.z + ColorOffsetShadows.z) + _406) + (((ColorGain.z * ColorGainShadows.z) * _420) * exp2(log2(exp2(((ColorContrast.z * ColorContrastShadows.z) * _448) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationShadows.z) * _462) * _468) + _392)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaShadows.z) * _434))))))) + ((((ColorOffset.z + ColorOffsetMidtones.z) + _651) + (((ColorGain.z * ColorGainMidtones.z) * _660) * exp2(log2(exp2(((ColorContrast.z * ColorContrastMidtones.z) * _678) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationMidtones.z) * _687) * _468) + _392)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaMidtones.z) * _669))))) * _745);

  SetUntonemappedAP1(float3(_756, _758, _760));

  float _775 = ((mad(0.061360642313957214f, _760, mad(-4.540197551250458e-09f, _758, (_756 * 0.9386394023895264f))) - _756) * BlueCorrection) + _756;
  float _776 = ((mad(0.169205904006958f, _760, mad(0.8307942152023315f, _758, (_756 * 6.775371730327606e-08f))) - _758) * BlueCorrection) + _758;
  float _777 = (mad(-2.3283064365386963e-10f, _758, (_756 * -9.313225746154785e-10f)) * BlueCorrection) + _760;
  float _780 = mad(0.16386905312538147f, _777, mad(0.14067868888378143f, _776, (_775 * 0.6954522132873535f)));
  float _783 = mad(0.0955343246459961f, _777, mad(0.8596711158752441f, _776, (_775 * 0.044794581830501556f)));
  float _786 = mad(1.0015007257461548f, _777, mad(0.004025210160762072f, _776, (_775 * -0.005525882821530104f)));
  float _790 = max(max(_780, _783), _786);
  float _795 = (max(_790, 1.000000013351432e-10f) - max(min(min(_780, _783), _786), 1.000000013351432e-10f)) / max(_790, 0.009999999776482582f);
  float _808 = ((_783 + _780) + _786) + (sqrt((((_786 - _783) * _786) + ((_783 - _780) * _783)) + ((_780 - _786) * _780)) * 1.75f);
  float _809 = _808 * 0.3333333432674408f;
  float _810 = _795 + -0.4000000059604645f;
  float _811 = _810 * 5.0f;
  float _815 = max((1.0f - abs(_810 * 2.5f)), 0.0f);
  float _826 = ((float(((int)(uint)((bool)(_811 > 0.0f))) - ((int)(uint)((bool)(_811 < 0.0f)))) * (1.0f - (_815 * _815))) + 1.0f) * 0.02500000037252903f;
  if (!(_809 <= 0.0533333346247673f)) {
    if (!(_809 >= 0.1599999964237213f)) {
      _835 = (((0.23999999463558197f / _808) + -0.5f) * _826);
    } else {
      _835 = 0.0f;
    }
  } else {
    _835 = _826;
  }
  float _836 = _835 + 1.0f;
  float _837 = _836 * _780;
  float _838 = _836 * _783;
  float _839 = _836 * _786;
  if (!((bool)(_837 == _838) && (bool)(_838 == _839))) {
    float _846 = ((_837 * 2.0f) - _838) - _839;
    float _849 = ((_783 - _786) * 1.7320507764816284f) * _836;
    float _851 = atan(_849 / _846);
    bool _854 = (_846 < 0.0f);
    bool _855 = (_846 == 0.0f);
    bool _856 = (_849 >= 0.0f);
    bool _857 = (_849 < 0.0f);
    _868 = select((_856 && _855), 90.0f, select((_857 && _855), -90.0f, (select((_857 && _854), (_851 + -3.1415927410125732f), select((_856 && _854), (_851 + 3.1415927410125732f), _851)) * 57.2957763671875f)));
  } else {
    _868 = 0.0f;
  }
  float _873 = min(max(select((_868 < 0.0f), (_868 + 360.0f), _868), 0.0f), 360.0f);
  if (_873 < -180.0f) {
    _882 = (_873 + 360.0f);
  } else {
    if (_873 > 180.0f) {
      _882 = (_873 + -360.0f);
    } else {
      _882 = _873;
    }
  }
  float _886 = saturate(1.0f - abs(_882 * 0.014814814552664757f));
  float _890 = (_886 * _886) * (3.0f - (_886 * 2.0f));
  float _896 = ((_890 * _890) * ((_795 * 0.18000000715255737f) * (0.029999999329447746f - _837))) + _837;
  float _906 = max(0.0f, mad(-0.21492856740951538f, _839, mad(-0.2365107536315918f, _838, (_896 * 1.4514392614364624f))));
  float _907 = max(0.0f, mad(-0.09967592358589172f, _839, mad(1.17622971534729f, _838, (_896 * -0.07655377686023712f))));
  float _908 = max(0.0f, mad(0.9977163076400757f, _839, mad(-0.006032449658960104f, _838, (_896 * 0.008316148072481155f))));
  float _909 = dot(float3(_906, _907, _908), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _924 = (FilmBlackClip + 1.0f) - FilmToe;
  float _926 = FilmWhiteClip + 1.0f;
  float _928 = _926 - FilmShoulder;
  if (FilmToe > 0.800000011920929f) {
    _946 = (((0.8199999928474426f - FilmToe) / FilmSlope) + -0.7447274923324585f);
  } else {
    float _937 = (FilmBlackClip + 0.18000000715255737f) / _924;
    _946 = (-0.7447274923324585f - ((log2(_937 / (2.0f - _937)) * 0.3465735912322998f) * (_924 / FilmSlope)));
  }
  float _949 = ((1.0f - FilmToe) / FilmSlope) - _946;
  float _951 = (FilmShoulder / FilmSlope) - _949;
  float _955 = log2(lerp(_909, _906, 0.9599999785423279f)) * 0.3010300099849701f;
  float _956 = log2(lerp(_909, _907, 0.9599999785423279f)) * 0.3010300099849701f;
  float _957 = log2(lerp(_909, _908, 0.9599999785423279f)) * 0.3010300099849701f;
  float _961 = FilmSlope * (_955 + _949);
  float _962 = FilmSlope * (_956 + _949);
  float _963 = FilmSlope * (_957 + _949);
  float _964 = _924 * 2.0f;
  float _966 = (FilmSlope * -2.0f) / _924;
  float _967 = _955 - _946;
  float _968 = _956 - _946;
  float _969 = _957 - _946;
  float _988 = _928 * 2.0f;
  float _990 = (FilmSlope * 2.0f) / _928;
  float _1015 = select((_955 < _946), ((_964 / (exp2((_967 * 1.4426950216293335f) * _966) + 1.0f)) - FilmBlackClip), _961);
  float _1016 = select((_956 < _946), ((_964 / (exp2((_968 * 1.4426950216293335f) * _966) + 1.0f)) - FilmBlackClip), _962);
  float _1017 = select((_957 < _946), ((_964 / (exp2((_969 * 1.4426950216293335f) * _966) + 1.0f)) - FilmBlackClip), _963);
  float _1024 = _951 - _946;
  float _1028 = saturate(_967 / _1024);
  float _1029 = saturate(_968 / _1024);
  float _1030 = saturate(_969 / _1024);
  bool _1031 = (_951 < _946);
  float _1035 = select(_1031, (1.0f - _1028), _1028);
  float _1036 = select(_1031, (1.0f - _1029), _1029);
  float _1037 = select(_1031, (1.0f - _1030), _1030);
  float _1056 = (((_1035 * _1035) * (select((_955 > _951), (_926 - (_988 / (exp2(((_955 - _951) * 1.4426950216293335f) * _990) + 1.0f))), _961) - _1015)) * (3.0f - (_1035 * 2.0f))) + _1015;
  float _1057 = (((_1036 * _1036) * (select((_956 > _951), (_926 - (_988 / (exp2(((_956 - _951) * 1.4426950216293335f) * _990) + 1.0f))), _962) - _1016)) * (3.0f - (_1036 * 2.0f))) + _1016;
  float _1058 = (((_1037 * _1037) * (select((_957 > _951), (_926 - (_988 / (exp2(((_957 - _951) * 1.4426950216293335f) * _990) + 1.0f))), _963) - _1017)) * (3.0f - (_1037 * 2.0f))) + _1017;
  float _1059 = dot(float3(_1056, _1057, _1058), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1079 = (ToneCurveAmount * (max(0.0f, (lerp(_1059, _1056, 0.9300000071525574f))) - _775)) + _775;
  float _1080 = (ToneCurveAmount * (max(0.0f, (lerp(_1059, _1057, 0.9300000071525574f))) - _776)) + _776;
  float _1081 = (ToneCurveAmount * (max(0.0f, (lerp(_1059, _1058, 0.9300000071525574f))) - _777)) + _777;
  float _1097 = ((mad(-0.06537103652954102f, _1081, mad(1.451815478503704e-06f, _1080, (_1079 * 1.065374732017517f))) - _1079) * BlueCorrection) + _1079;
  float _1098 = ((mad(-0.20366770029067993f, _1081, mad(1.2036634683609009f, _1080, (_1079 * -2.57161445915699e-07f))) - _1080) * BlueCorrection) + _1080;
  float _1099 = ((mad(0.9999996423721313f, _1081, mad(2.0954757928848267e-08f, _1080, (_1079 * 1.862645149230957e-08f))) - _1081) * BlueCorrection) + _1081;

  SetTonemappedAP1(_1097, _1098, _1099);

  float _1124 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[0].z), _1099, mad((WorkingColorSpace_FromAP1[0].y), _1098, ((WorkingColorSpace_FromAP1[0].x) * _1097)))));
  float _1125 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[1].z), _1099, mad((WorkingColorSpace_FromAP1[1].y), _1098, ((WorkingColorSpace_FromAP1[1].x) * _1097)))));
  float _1126 = saturate(max(0.0f, mad((WorkingColorSpace_FromAP1[2].z), _1099, mad((WorkingColorSpace_FromAP1[2].y), _1098, ((WorkingColorSpace_FromAP1[2].x) * _1097)))));
  if (_1124 < 0.0031306699384003878f) {
    _1137 = (_1124 * 12.920000076293945f);
  } else {
    _1137 = (((pow(_1124, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1125 < 0.0031306699384003878f) {
    _1148 = (_1125 * 12.920000076293945f);
  } else {
    _1148 = (((pow(_1125, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1126 < 0.0031306699384003878f) {
    _1159 = (_1126 * 12.920000076293945f);
  } else {
    _1159 = (((pow(_1126, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _1163 = (_1148 * 0.9375f) + 0.03125f;
  float _1170 = _1159 * 15.0f;
  float _1171 = floor(_1170);
  float _1172 = _1170 - _1171;
  float _1174 = (_1171 + ((_1137 * 0.9375f) + 0.03125f)) * 0.0625f;
  float4 _1177 = Textures_1.SampleLevel(Samplers_1, float2(_1174, _1163), 0.0f);
  float _1181 = _1174 + 0.0625f;
  float4 _1182 = Textures_1.SampleLevel(Samplers_1, float2(_1181, _1163), 0.0f);
  float4 _1204 = Textures_2.SampleLevel(Samplers_2, float2(_1174, _1163), 0.0f);
  float4 _1208 = Textures_2.SampleLevel(Samplers_2, float2(_1181, _1163), 0.0f);
  float4 _1230 = Textures_3.SampleLevel(Samplers_3, float2(_1174, _1163), 0.0f);
  float4 _1234 = Textures_3.SampleLevel(Samplers_3, float2(_1181, _1163), 0.0f);
  float4 _1257 = Textures_4.SampleLevel(Samplers_4, float2(_1174, _1163), 0.0f);
  float4 _1261 = Textures_4.SampleLevel(Samplers_4, float2(_1181, _1163), 0.0f);
  float _1280 = max(6.103519990574569e-05f, ((((((lerp(_1177.x, _1182.x, _1172)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _1137)) + ((lerp(_1204.x, _1208.x, _1172)) * (LUTWeights[0].z))) + ((lerp(_1230.x, _1234.x, _1172)) * (LUTWeights[0].w))) + ((lerp(_1257.x, _1261.x, _1172)) * (LUTWeights[1].x))));
  float _1281 = max(6.103519990574569e-05f, ((((((lerp(_1177.y, _1182.y, _1172)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _1148)) + ((lerp(_1204.y, _1208.y, _1172)) * (LUTWeights[0].z))) + ((lerp(_1230.y, _1234.y, _1172)) * (LUTWeights[0].w))) + ((lerp(_1257.y, _1261.y, _1172)) * (LUTWeights[1].x))));
  float _1282 = max(6.103519990574569e-05f, ((((((lerp(_1177.z, _1182.z, _1172)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _1159)) + ((lerp(_1204.z, _1208.z, _1172)) * (LUTWeights[0].z))) + ((lerp(_1230.z, _1234.z, _1172)) * (LUTWeights[0].w))) + ((lerp(_1257.z, _1261.z, _1172)) * (LUTWeights[1].x))));
  float _1304 = select((_1280 > 0.040449999272823334f), exp2(log2((_1280 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1280 * 0.07739938050508499f));
  float _1305 = select((_1281 > 0.040449999272823334f), exp2(log2((_1281 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1281 * 0.07739938050508499f));
  float _1306 = select((_1282 > 0.040449999272823334f), exp2(log2((_1282 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1282 * 0.07739938050508499f));
  float _1332 = ColorScale.x * (((MappingPolynomial.y + (MappingPolynomial.x * _1304)) * _1304) + MappingPolynomial.z);
  float _1333 = ColorScale.y * (((MappingPolynomial.y + (MappingPolynomial.x * _1305)) * _1305) + MappingPolynomial.z);
  float _1334 = ColorScale.z * (((MappingPolynomial.y + (MappingPolynomial.x * _1306)) * _1306) + MappingPolynomial.z);
  float _1355 = exp2(log2(max(0.0f, (lerp(_1332, OverlayColor.x, OverlayColor.w)))) * InverseGamma.y);
  float _1356 = exp2(log2(max(0.0f, (lerp(_1333, OverlayColor.y, OverlayColor.w)))) * InverseGamma.y);
  float _1357 = exp2(log2(max(0.0f, (lerp(_1334, OverlayColor.z, OverlayColor.w)))) * InverseGamma.y);

  if (true) {
    RWOutputTexture[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] =
        GenerateOutput(float3(_1355, _1356, _1357), OutputDevice);
    return;
  }

  if ((uint)(WorkingColorSpace_bIsSRGB) == 0) {
    float _1364 = mad((WorkingColorSpace_ToAP1[0].z), _1357, mad((WorkingColorSpace_ToAP1[0].y), _1356, ((WorkingColorSpace_ToAP1[0].x) * _1355)));
    float _1367 = mad((WorkingColorSpace_ToAP1[1].z), _1357, mad((WorkingColorSpace_ToAP1[1].y), _1356, ((WorkingColorSpace_ToAP1[1].x) * _1355)));
    float _1370 = mad((WorkingColorSpace_ToAP1[2].z), _1357, mad((WorkingColorSpace_ToAP1[2].y), _1356, ((WorkingColorSpace_ToAP1[2].x) * _1355)));
    _1381 = mad(_59, _1370, mad(_58, _1367, (_1364 * _57)));
    _1382 = mad(_62, _1370, mad(_61, _1367, (_1364 * _60)));
    _1383 = mad(_65, _1370, mad(_64, _1367, (_1364 * _63)));
  } else {
    _1381 = _1355;
    _1382 = _1356;
    _1383 = _1357;
  }
  if (_1381 < 0.0031306699384003878f) {
    _1394 = (_1381 * 12.920000076293945f);
  } else {
    _1394 = (((pow(_1381, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1382 < 0.0031306699384003878f) {
    _1405 = (_1382 * 12.920000076293945f);
  } else {
    _1405 = (((pow(_1382, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1383 < 0.0031306699384003878f) {
    _1416 = (_1383 * 12.920000076293945f);
  } else {
    _1416 = (((pow(_1383, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  RWOutputTexture[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = float4((_1394 * 0.9523810148239136f), (_1405 * 0.9523810148239136f), (_1416 * 0.9523810148239136f), 0.0f);
}
