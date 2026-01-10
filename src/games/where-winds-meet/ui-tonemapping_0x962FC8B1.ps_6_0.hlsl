// HDR combine pass: merges main color with bloom, applies vignette and LUT-based color grading.
Texture2D<float4> SourceTexture : register(t0);

Texture2D<float4> bloomMap0 : register(t1);

Texture3D<float4> tCombineLUTsTex : register(t6);

cbuffer Global : register(b2) {
  float4 ViewProj[4] : packoffset(c000.x);
  float4 ShadowViewProjTexs0[4] : packoffset(c004.x);
  float4 ShadowViewProjTexs1[4] : packoffset(c008.x);
  float4 ShadowViewProjTexs2[4] : packoffset(c012.x);
  float4 CSMShadowBiases : packoffset(c016.x);
  float4 DiyLightingInfo : packoffset(c017.x);
  float4 CameraPos : packoffset(c018.x);
  float4 CameraInfo : packoffset(c019.x);
  float4 ScreenInfo : packoffset(c020.x);
  float4 ScreenColor : packoffset(c021.x);
  float4 FogInfo : packoffset(c022.x);
  float4 FogColor : packoffset(c023.x);
  float4 EnvInfo : packoffset(c024.x);
  float4 SunDirection : packoffset(c025.x);
  float4 SunColor : packoffset(c026.x);
  float4 AmbientColor : packoffset(c027.x);
  float4 ShadowColor : packoffset(c028.x);
  float4 ReflectionProbeBBMin : packoffset(c029.x);
  float4 ReflectionProbeBBMax : packoffset(c030.x);
  float4 Misc : packoffset(c031.x);
  float4 Misc2 : packoffset(c032.x);
  float4 Misc3 : packoffset(c033.x);
  float4 VolumetricFogParam : packoffset(c034.x);
  float4 VolumetricFogParam2 : packoffset(c035.x);
  float4 ShadowViewProjTexs3[4] : packoffset(c036.x);
  float4 VTParam0 : packoffset(c040.x);
  float4 VTParam1 : packoffset(c041.x);
  float4 VTParam2 : packoffset(c042.x);
  float4 VTViewpoint : packoffset(c043.x);
  float4 VTIndMapUVTransform : packoffset(c044.x);
  float4 SunFogColor : packoffset(c045.x);
  float4 WindParam : packoffset(c046.x);
  float4 LastWindParam : packoffset(c047.x);
  float4 ScreenMotionGray : packoffset(c048.x);
  float4 GIInfo : packoffset(c049.x);
  float4 SSRParam[4] : packoffset(c050.x);
  float4 LastViewProjTex[4] : packoffset(c054.x);
  float4 GlobalBurnParam : packoffset(c058.x);
  float4 CSMCacheIndexs : packoffset(c059.x);
  float4 AerialPerspectiveExt : packoffset(c060.x);
  float4 AerialPerspectiveMie : packoffset(c061.x);
  float4 AerialPerspectiveRay : packoffset(c062.x);
  float4 LastCameraPos : packoffset(c063.x);
  float4 SHAOParam : packoffset(c064.x);
  float4 SHSBParam : packoffset(c065.x);
  float4 SHSBParam2 : packoffset(c066.x);
  float4 SHGIParam : packoffset(c067.x);
  float4 SHGIParam2 : packoffset(c068.x);
  float4 TimeOfDayInfos : packoffset(c069.x);
  float4 UserData[4] : packoffset(c070.x);
  float4 ViewRotationProj[4] : packoffset(c074.x);
  float4 WorldProbeInfo : packoffset(c078.x);
  float4 LastPlayerPos : packoffset(c079.x);
  float4 HexEnvData[4] : packoffset(c080.x);
  float4 HexRenderOptionData[4] : packoffset(c084.x);
  float4 OriginSunDir : packoffset(c088.x);
};

cbuffer Batch : register(b0) {
  float cBloomThreshold : packoffset(c000.x);
  float cBloomSizeScale : packoffset(c000.y);
  float cExposureCompensation : packoffset(c000.z);
  float cBloomTint : packoffset(c000.w);
  float cBloomIntensity : packoffset(c001.x);
  float cBlurRadius : packoffset(c001.y);
  float cFrameTime : packoffset(c001.z);
  float cPlaceHold : packoffset(c001.w);
  float4 cHDRParam3 : packoffset(c002.x);
  float4 cHDRParam4 : packoffset(c003.x);
  float4 cTextureSize : packoffset(c004.x);
  float4 cSaturation : packoffset(c005.x);
  float4 cContrast : packoffset(c006.x);
  float4 cGamma : packoffset(c007.x);
  float4 cGain : packoffset(c008.x);
  float4 cOffset : packoffset(c009.x);
  float4 cSaturationSMH : packoffset(c010.x);
  float4 cContrastSMH : packoffset(c011.x);
  float4 cGammaShadows : packoffset(c012.x);
  float4 cGammaMidtones : packoffset(c013.x);
  float4 cGammaHighlights : packoffset(c014.x);
  float4 cGainShadows : packoffset(c015.x);
  float4 cGainMidtones : packoffset(c016.x);
  float4 cGainHighlights : packoffset(c017.x);
  float4 cCGParams0 : packoffset(c018.x);
  float4 cBlurWeights[32] : packoffset(c019.x);
  float4 cBlurOffsets[32] : packoffset(c051.x);
  float4 cFusionInfo : packoffset(c083.x);
  float cWhiteTemp : packoffset(c084.x);
  float cWhiteTint : packoffset(c084.y);
  float cVignettingDarkenss : packoffset(c084.z);
  int cMipLevel : packoffset(c084.w);
  float2 cCursorPos : packoffset(c085.x);
  float cDpiScale : packoffset(c085.z);
  float4 cRTInfo : packoffset(c086.x);
  float2 cDualFilterTint : packoffset(c087.x);
  float cBrightnessAdjVal : packoffset(c087.z);
  float cHDRWhitePoint : packoffset(c087.w);
  float4 cHDRParam : packoffset(c088.x);
  float cColorLookupTableSize : packoffset(c089.x);
};

SamplerState SourceTexture_Sampler : register(s0);

SamplerState bloomMap0_Sampler : register(s1);

SamplerState sCombineLUTsTex : register(s6);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  // Fetch linear scene color and bloom contribution.
  float4 _11 = SourceTexture.Sample(SourceTexture_Sampler, float2(TEXCOORD.x, TEXCOORD.y));
  float4 _18 = bloomMap0.Sample(bloomMap0_Sampler, float2(TEXCOORD.x, TEXCOORD.y));
  // Compute vignetting factor around screen center.
  float _35 = TEXCOORD.x + -0.5f;
  float _36 = TEXCOORD.y + -0.5f;
  float _40 = max(0.0f, (1.0f - (cVignettingDarkenss * dot(float2(_35, _36), float2(_35, _36)))));
  float _41 = _40 * _40;
  float _42 = _41 * _41;
  // Bring color into log space, apply exposure + vignette. Temporarily bypass LUT sampling to inspect unclamped values.
  float3 _preLUT;
  _preLUT.x = log2(((((cBloomIntensity * _18.x) + _11.x) * cExposureCompensation) * _42) + 0.002667719265446067f);
  _preLUT.y = log2(((((cBloomIntensity * _18.y) + _11.y) * cExposureCompensation) * _42) + 0.002667719265446067f);
  _preLUT.z = log2(((((cBloomIntensity * _18.z) + _11.z) * cExposureCompensation) * _42) + 0.002667719265446067f);
  float3 _67 = exp2(_preLUT);
  // Add small blue-noise dither and scale output (1.05f appears to bake slight gain; still limited by prior clamp).
  float _84 = (frac(frac(dot(float2((ScreenInfo.x * TEXCOORD.x), (ScreenInfo.y * TEXCOORD.y)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) + -0.5f) * 0.00390625f;
  SV_Target.x = (_84 + (_67.x * 1.0499999523162842f));
  SV_Target.y = (_84 + (_67.y * 1.0499999523162842f));
  SV_Target.z = (_84 + (_67.z * 1.0499999523162842f));
  // Preserve alpha from source layer.
  SV_Target.w = _11.w;
  return SV_Target;
}
