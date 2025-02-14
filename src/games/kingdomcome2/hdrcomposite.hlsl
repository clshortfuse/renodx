#include "./common.hlsl"
#include "./include/CBuffer_PERBATCH.hlsl"
#include "./include/Registers.hlsl"

SamplerState linearClampSS : register(s6);

// Credits to Lilium
float ComputeExposure(float fIlluminance) {
  // Compute EV with ISO 100 and standard camera settings
  float EV100 = log2(fIlluminance * LIGHT_UNIT_SCALE * 100.0 / 330.0);

  // Apply automatic exposure compensation based on scene key
  EV100 -= ((clamp(log10(fIlluminance * LIGHT_UNIT_SCALE + 1), 0.1, 5.2) - 3.0) / 2.0) * HDREyeAdaptation.z;

  // Clamp EV
  EV100 = clamp(EV100, HDREyeAdaptation.x, HDREyeAdaptation.y);

  // Compute maximum luminance based on Saturation Based Film Sensitivity (ISO 100, lens factor q=0.65)
  float maxLum = 1.2 * exp2(EV100) / LIGHT_UNIT_SCALE;

  return 1 / maxLum;
}

// Original code
float4 SDRPath(noperspective float4 TEXCOORD: TEXCOORD,
               noperspective float4 TEXCOORD_1: TEXCOORD1,
               noperspective float4 SV_Position: SV_Position,
               bool hasBloom = false)
    : SV_Target {
  float4 SV_Target;
  float3 _18 = hdrTex.Load(int3((int(SV_Position.x)), (int(SV_Position.y)), 0));
  float3 bloom = bloomTex.Sample(linearClampSS, float2((TEXCOORD_1.x), (TEXCOORD_1.y)));

  KingdomOptions options;
  options.gamma = HDRUserModification;
  options.bloom = HDRBloomColor;

  ModifyOptions(options);

  float _42 = (8333.3330078125f / (exp2((min((max(((log2(((((float4)(luminanceTex.Load(int3(0, 0, 0)))).y) * 3030.30322265625f))) - (((HDREyeAdaptation.z) * 0.5f) * ((min((max(((log2((((((float4)(luminanceTex.Load(int3(0, 0, 0)))).y) * 10000.0f) + 1.0f))) * 0.3010300099849701f), 0.10000000149011612f)), 5.199999809265137f)) + -3.0f))), (HDREyeAdaptation.x))), (HDREyeAdaptation.y)))))) * (((float4)(vignettingTex.Sample(linearClampSS, float2((TEXCOORD_1.x), (TEXCOORD_1.y))))).x * options.vignette);

  float _56, _57, _58;
  if (hasBloom) {
    _56 = (((saturate((options.bloom.x))) * ((bloom.x) - (_18.x))) + (_18.x)) * _42;
    _57 = (((saturate((options.bloom.y))) * ((bloom.y) - (_18.y))) + (_18.y)) * _42;
    _58 = (((saturate((options.bloom.z))) * ((bloom.z) - (_18.z))) + (_18.z)) * _42;
  } else {
    _56 = ((_18.x) - ((saturate((options.bloom.x))) * (_18.x))) * _42;
    _57 = ((_18.y) - ((saturate((options.bloom.y))) * (_18.y))) * _42;
    _58 = ((_18.z) - ((saturate((options.bloom.z))) * (_18.z))) * _42;
  }
  float _59 = dot(float3(_56, _57, _58), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _77 = max(((((HDRColorBalance.a) * (_56 - _59)) + _59) * (HDRColorBalance.x)), 0.0f);
  float _78 = max(((((HDRColorBalance.a) * (_57 - _59)) + _59) * (HDRColorBalance.y)), 0.0f);
  float _79 = max(((((_58 - _59) * (HDRColorBalance.a)) + _59) * (HDRColorBalance.z)), 0.0f);

  float _83 = (HDRFilmCurve.x) * 0.2199999988079071f;
  float _85 = (HDRFilmCurve.y) * 0.30000001192092896f;
  float _87 = _83 * _77;
  float _88 = _83 * _78;
  float _89 = _83 * _79;
  float _90 = _83 * (HDRFilmCurve.a);

  float _91 = (HDRFilmCurve.y) * 0.030000001192092896f;
  float _100 = (HDRFilmCurve.z) * 0.0020000000949949026f;
  float _121 = (HDRFilmCurve.z) * 0.03333333134651184f;
  float _125 = ((((_90 + _91) * (HDRFilmCurve.w)) + _100) / (((_90 + _85) * (HDRFilmCurve.w)) + 0.06000000238418579f)) - _121;
  float _135 = saturate((saturate((saturate(((((((_87 + _91) * _77) + _100) / (((_87 + _85) * _77) + 0.06000000238418579f)) - _121) / _125))))));
  float _136 = saturate((saturate((saturate(((((((_88 + _91) * _78) + _100) / (((_88 + _85) * _78) + 0.06000000238418579f)) - _121) / _125))))));
  float _137 = saturate((saturate((saturate(((((((_89 + _91) * _79) + _100) / (((_89 + _85) * _79) + 0.06000000238418579f)) - _121) / _125))))));
  float _159 = (((bool)((_135 < 0.0031308000907301903f))) ? (_135 * 12.920000076293945f) : (((exp2(((log2(_135)) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f));
  float _160 = (((bool)((_136 < 0.0031308000907301903f))) ? (_136 * 12.920000076293945f) : (((exp2(((log2(_136)) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f));
  float _161 = (((bool)((_137 < 0.0031308000907301903f))) ? (_137 * 12.920000076293945f) : (((exp2(((log2(_137)) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f));
  float4 _162 = sunShaftsTex.Sample(linearClampSS, float2((TEXCOORD_1.x), (TEXCOORD_1.y)));
  float _187 = ((saturate(((((_162.y) * (1.0f - _160)) * (SunShafts_SunCol.y)) + _160))) * 0.9375f) + 0.03125f;
  float _188 = (saturate(((((_162.z) * (1.0f - _161)) * (SunShafts_SunCol.z)) + _161))) * 15.0f;
  float _189 = frac(_188);
  float _193 = (((((saturate(((((_162.x) * (1.0f - _159)) * (SunShafts_SunCol.x)) + _159))) * 0.9375f) + 0.03125f) - _189) + _188) * 0.0625f;
  float4 _194 = colorChartTex.Sample(linearClampSS, float2(_193, _187));
  float4 _199 = colorChartTex.Sample(linearClampSS, float2((_193 + 0.0625f), _187));
  float _213 = sin((dot(float2((SV_Position.x), (SV_Position.y)), float2(34.483001708984375f, 89.63700103759766f))));
  float _223 = sin((dot(float2(((SV_Position.x) + 0.5788999795913696f), ((SV_Position.y) + 0.5788999795913696f)), float2(34.483001708984375f, 89.63700103759766f))));
  SV_Target.x = (saturate((((exp2(((log2((((((_199.x) - (_194.x)) * _189) + (_194.x)) + ((((frac((_213 * 29156.4765625f))) + -0.5f) + (frac((_223 * 29156.4765625f)))) * 0.0019607844296842813f)))) * (options.gamma.x)))) * (options.gamma.y)) + (options.gamma.z))));
  SV_Target.y = (saturate((((exp2(((log2((((((_199.y) - (_194.y)) * _189) + (_194.y)) + ((((frac((_213 * 38273.5625f))) + -0.5f) + (frac((_223 * 38273.5625f)))) * 0.0019607844296842813f)))) * (options.gamma.x)))) * (options.gamma.y)) + (options.gamma.z))));
  SV_Target.z = (saturate((((exp2(((log2((((((_199.z) - (_194.z)) * _189) + (_194.z)) + ((((frac((_213 * 47843.75390625f))) + -0.5f) + (frac((_223 * 47843.75390625f)))) * 0.0019607844296842813f)))) * (options.gamma.x)))) * (options.gamma.y)) + (options.gamma.z))));
  SV_Target.rgb = renodx::color::srgb::DecodeSafe(SV_Target.rgb);
  SV_Target.w = 1.0f;
  return SV_Target;
}

// Copied from Lilium's KCD 1 Luma mod
float4 HDRComposite(noperspective float4 TEXCOORD: TEXCOORD,
                    noperspective float4 TEXCOORD_1: TEXCOORD1,
                    noperspective float4 SV_Position: SV_Position,
                    bool hasBloom = false)
    : SV_Target {
  float4 SV_Target;

  if (RENODX_TONE_MAP_TYPE == 0.f) {
    SV_Target = SDRPath(TEXCOORD, TEXCOORD_1, SV_Position, hasBloom);
  } else {
    float3 cColor, cBloom, cScene, untonemapped;

    if (hasBloom) {
      cBloom = bloomTex.Sample(linearClampSS, float2((TEXCOORD_1.x), (TEXCOORD_1.y)));
    }

    cScene = hdrTex.Load(int3((int(SV_Position.x)), (int(SV_Position.y)), 0));

    // Adjust cbuffers
    KingdomOptions options;
    options.gamma = HDRUserModification;
    options.bloom = HDRBloomColor;

    ModifyOptions(options);

    // Compute exposure
    float4 vAdaptedLum = luminanceTex.Load(int3(0, 0, 0));
    float fVignetting = ((float4)(vignettingTex.Sample(linearClampSS, float2((TEXCOORD_1.x), (TEXCOORD_1.y))))).x * options.vignette;

    float fExposure = ComputeExposure(vAdaptedLum.y);
    float vignetting_x_exposure = fVignetting * fExposure;

    // Add bloom
    float3 saturatedBloomColor = saturate(options.bloom.rgb);
    if (hasBloom) {
      cColor = lerp(cScene.xyz, cBloom.xyz, saturatedBloomColor);
    } else {
      cColor = (cScene.rgb - saturatedBloomColor) * cScene.rgb;
    }

    cColor = vignetting_x_exposure * cColor;

    // Random value because exposure is insane
    untonemapped = cColor * 0.4f;

    if (CUSTOM_FAKE_HDR == 1.f) {
      float normalizationPoint = 0.20;  // Found empyrically
      float mixedSceneColorLuminance = renodx::color::y::from::BT709(untonemapped) / normalizationPoint;
      float fakeHDRIntensity = 0.85;
      mixedSceneColorLuminance = mixedSceneColorLuminance > 1.0 ? pow(mixedSceneColorLuminance, 1.0 + fakeHDRIntensity) : mixedSceneColorLuminance;
      untonemapped = RestoreLuminance(untonemapped, mixedSceneColorLuminance * normalizationPoint);
    }

    // hdr color grading
    float fLuminance = renodx::color::y::from::BT709(cColor.rgb);
    cColor.rgb = fLuminance + HDRColorBalance.a * (cColor.rgb - fLuminance);  // saturation
    cColor.rgb *= HDRColorBalance.rgb;                                        // color balance

    // Apply LUT (Automatically converts to and from sRGB)
    renodx::lut::Config lut_config = renodx::lut::config::Create();
    lut_config.lut_sampler = linearClampSS;
    lut_config.size = 16u;
    lut_config.tetrahedral = true;
    lut_config.type_input = renodx::lut::config::type::SRGB;  // We manually convert
    lut_config.type_output = renodx::lut::config::type::SRGB;
    lut_config.scaling = 0.f;  // Too harsh at 1

    // Tonemapping
    //  // Filmic response curve as proposed by J. Hable
    //  float4 c = float4(max(cColor.rgb, 0), HDRFilmCurve.w);
    //  const float ShoStren = 0.22 * HDRFilmCurve.x, LinStren = 0.3 * HDRFilmCurve.y, LinAngle = 0.1, ToeStren = 0.2, ToeNum = 0.01 * HDRFilmCurve.z, ToeDenom = 0.3;
    //  float4 compressedCol = ((c * (ShoStren * c + LinAngle*LinStren) + ToeStren*ToeNum) / (c * (ShoStren * c + LinStren) + ToeStren*ToeDenom)) - (ToeNum/ToeDenom);
    //  cScene.xyz = saturate(compressedCol / compressedCol.w);
    //
    //  // Apply gamma correction using exact sRGB curve
    //  cScene.xyz = (cScene.xyz < 0.0031308) ? 12.92f * cScene.xyz : 1.055f * pow(cScene.xyz, 1.0f / 2.4f) - float3(0.055f, 0.055f, 0.055f);

    const float orgY = renodx::color::y::from::BT709(cColor.rgb);

    float4 c = float4(max(cColor.rgb, 0.f), HDRFilmCurve.w);

    // Adjusting this will restore some saturation and lower highlights
    const float reduceHighlight = 0.8f;
    const float ShoStren = (0.22f) * (HDRFilmCurve.x * reduceHighlight),  // vanilla = 0.22f * HDRFilmCurve.x,
        LinStren = 0.3f * HDRFilmCurve.y,
                LinAngle = 0.1f,
                ToeStren = 0.2f,
                ToeNum = 0.01f * HDRFilmCurve.z,
                ToeDenom = 0.3f;

    const float4 CTimesShoStrenTimesC = ShoStren * c * c;
    const float4 CTimesLinStren = LinStren * c;

    float4 compressedCol = ((CTimesShoStrenTimesC + (CTimesLinStren * LinAngle) + ToeStren * ToeNum)
                            / (CTimesShoStrenTimesC + CTimesLinStren + ToeStren * ToeDenom))
                           - (ToeNum / ToeDenom);

    compressedCol.rgb = compressedCol.rgb / compressedCol.w;

    compressedCol.rgb = saturate(compressedCol.rgb);

    compressedCol.rgb += sunShaftsTex.Sample(linearClampSS, float2((TEXCOORD_1.x), (TEXCOORD_1.y))).rgb
                         * SunShafts_SunCol
                         * (1.f - compressedCol.rgb);

    float3 cc = renodx::lut::Sample(
        compressedCol.rgb,
        lut_config,
        colorChartTex);

    float3 sdrGraded = cc;

    // Liliums inverse hable
    if (false) {
      float3 compressedColSRGB = renodx::color::srgb::Encode(compressedCol.rgb);

      const float3 ccPow22 = renodx::color::gamma::Decode(compressedColSRGB, 2.2f);

      const float ccY = renodx::color::y::from::BT709(cc);
      const float ccPow22Y = renodx::color::y::from::BT709(ccPow22);

      float3 itm = cc * compressedCol.w;

      const float LinStrenTimesToeDenom = LinStren * ToeDenom;
      const float ShoStrenTimesToeDenom = ShoStren * ToeDenom;

      const float3 itm_0 = LinStrenTimesToeDenom * itm - LinStrenTimesToeDenom * LinAngle + LinStren * ToeNum;
      const float3 itm_1 = ShoStrenTimesToeDenom * itm + ShoStren * ToeNum - ShoStrenTimesToeDenom;
      const float3 itm_2 = 4.f * ToeStren * ToeDenom * ToeDenom * itm;

      itm = ((-itm_0 - sqrt(itm_0 * itm_0 - itm_2 * itm_1)) * 0.5f)
            / itm_1;

      const float itmY = renodx::color::y::from::BT709(itm);

      // only recover hightlights that were brighter before tone mapping
      float itmFactorY = max(orgY / itmY, 1.f);

      itm *= (ccPow22Y / ccY);

      cColor.rgb = itm * itmFactorY;
    }

    renodx::draw::Config config = renodx::draw::BuildConfig();
    // Increase saturation a bit
    config.tone_map_highlight_saturation = RENODX_TONE_MAP_HIGHLIGHT_SATURATION * 1.1f;

    // Tonemap pass
    cColor = renodx::draw::ToneMapPass(untonemapped, sdrGraded, config);
    SV_Target.rgb = cColor;
  }

  SV_Target.rgb = renodx::draw::RenderIntermediatePass(SV_Target.rgb);

  SV_Target.a = 1.f;

  return SV_Target;
}

