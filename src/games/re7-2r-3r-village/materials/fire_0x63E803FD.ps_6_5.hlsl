
#include "./materials.hlsli"

Buffer<uint4> WhitePtSrv : register(t0);

Texture2D<float4> primTex : register(t1);

cbuffer Tonemap : register(b0) {
  float exposureAdjustment : packoffset(c000.x);
  float tonemapRange : packoffset(c000.y);
  float sharpness : packoffset(c000.z);
  float preTonemapRange : packoffset(c000.w);
  int useAutoExposure : packoffset(c001.x);
  float echoBlend : packoffset(c001.y);
  float AABlend : packoffset(c001.z);
  float AASubPixel : packoffset(c001.w);
  float ResponsiveAARate : packoffset(c002.x);
};

cbuffer Polygon3DConstant : register(b1) {
  float cbDepthBias : packoffset(c000.x);
  float cbSoftParticleDist : packoffset(c000.y);
  float cbFadeCone : packoffset(c000.z);
  float cbFadeSpread : packoffset(c000.w);
  float3 cbFadeConeDir : packoffset(c001.x);
  float cbFadeAlphaRate : packoffset(c001.w);
  float4 cbFadeDepth : packoffset(c002.x);
  float3 cbOcclusionSphereOffset : packoffset(c003.x);
  float cbOcclusionSphereRadius : packoffset(c003.w);
  float cbOcclusionSizeRate : packoffset(c004.x);
  uint cbEffect3DFlags : packoffset(c004.y);
  float cbDofNear : packoffset(c004.z);
  float cbDofMaxScale : packoffset(c004.w);
  float cbDofMinAlpha : packoffset(c005.x);
  uint cbDofUsingMipLevel : packoffset(c005.y);
  float cbDofVanishDistance : packoffset(c005.z);
  float cbFadeEnableAngle : packoffset(c005.w);
  float cbLumaBleed : packoffset(c006.x);
  float cbLumaSlide : packoffset(c006.y);
  float cbLumaScale : packoffset(c006.z);
  float cbLumaBias : packoffset(c006.w);
  float cbLumaTexelScale : packoffset(c007.x);
  float cbDistInfluence : packoffset(c007.y);
  float cbDensityColorMin : packoffset(c007.z);
  float cbDensityColorMax : packoffset(c007.w);
  float cbDensityAlphaMin : packoffset(c008.x);
  float cbDensityAlphaMax : packoffset(c008.y);
  float cbFlowStrength : packoffset(c008.z);
  float cbProjectionAdjust : packoffset(c008.w);
  float3 cbShadowColor : packoffset(c009.x);
  float cbProjectionTimeScale : packoffset(c009.w);
  float cbMieDensityMin : packoffset(c010.x);
  float cbMieDensityMax : packoffset(c010.y);
  float cbMieDensityScale : packoffset(c010.z);
  float cbMieAlphaScale : packoffset(c010.w);
  float4 cbProjectionUV : packoffset(c011.x);
  float3 cbEmitterPos : packoffset(c012.x);
  float cbIntensityScale : packoffset(c012.w);
  float cbPostEdgeDropoff : packoffset(c013.x);
  float cbAlphaRate : packoffset(c013.y);
  float cbMieDropoff : packoffset(c013.z);
  float cbIntensity3D : packoffset(c013.w);
  float4 cbEdgeOuterColor3D : packoffset(c014.x);
  float2 cbOffset : packoffset(c015.x);
  float cbEdgeBlendRange3D : packoffset(c015.z);
  float cbEmissiveRate : packoffset(c015.w);
  float cbUsePhysicalAlphaBlend3D : packoffset(c016.x);
  float cbDetonemapRate : packoffset(c016.y);
  float cbPtFadeCone : packoffset(c016.z);
  float cbPtFadeSpread : packoffset(c016.w);
  float cbPtFadeAlphaRate : packoffset(c017.x);
  float cbPtFadeEnableAngle : packoffset(c017.y);
  float cbPtFadeinStart : packoffset(c017.z);
  float cbPtFadeinEnd : packoffset(c017.w);
  float3 cbProcDistTimes : packoffset(c018.x);
  float cbSSRAlphaThreshold : packoffset(c018.w);
  float2 cbUvSeqRect : packoffset(c019.x);
  float2 cbProcDistUVScale : packoffset(c019.z);
  float cbProcDistVorWFreq : packoffset(c020.x);
  float cbProcDistVorWAmp : packoffset(c020.y);
  float cbProcDistHFreqorWAmpCoef : packoffset(c020.z);
  float cbProcDistHAmporWOffset : packoffset(c020.w);
  float cbProcDistOFreq : packoffset(c021.x);
  float cbProcDistOAmp : packoffset(c021.y);
  float cbProcDistOFreqNoiseFreq : packoffset(c021.z);
  float cbProcDistOFreqNoiseAmp : packoffset(c021.w);
  float cbProcDistOAmpNoiseFreq : packoffset(c022.x);
  float cbProcDistOAmpNoiseAmp : packoffset(c022.y);
  float cbShadowMultiplier : packoffset(c022.z);
  float cbStochasticAlphaCoverage : packoffset(c022.w);
  uint3 cbTexUnitColor : packoffset(c023.x);
  uint cbEffect3DPlayerColor : packoffset(c023.w);
  float3 cbTexUnitColorRate : packoffset(c024.x);
  float cbInterleaveScale : packoffset(c024.w);
  float4 cbTypeParam3D : packoffset(c025.x);
  float3 cbTextureFilter : packoffset(c026.x);
  uint cbEffect3DFlags2 : packoffset(c026.w);
  float2 cbDistortionSpecular : packoffset(c027.x);
  float2 cbFakeVolume : packoffset(c027.z);
  float4 cbContrastHighlighter : packoffset(c028.x);
  uint cbContrastHighlighterColor : packoffset(c029.x);
  float cbContrastHighlighterIntensity : packoffset(c029.y);
  uint cbHighBrightnessColor : packoffset(c029.z);
  uint cbLowBrightnessColor : packoffset(c029.w);
  float cbHighBrightnessIntensity : packoffset(c030.x);
  float cbLowBrightnessIntensity : packoffset(c030.y);
  float cbHighGradingBorder : packoffset(c030.z);
  float cbLowGradingBorder : packoffset(c030.w);
  uint cbChannelHueAttribute : packoffset(c031.x);
  uint cbChannelShadeAttribute : packoffset(c031.y);
  float cbChannelEmissiveRate : packoffset(c031.z);
  float cbChannelEmissionPower : packoffset(c031.w);
  float cbEvPow2 : packoffset(c032.x);
  float cbEvOffsetPow2 : packoffset(c032.y);
  float cbChannelHueIntensityCurve : packoffset(c032.z);
  float cbChannelOpacity : packoffset(c032.w);
  float3 cbStretchVector : packoffset(c033.x);
  uint cbTargetStencil : packoffset(c033.w);
  float3 cbStretchPos : packoffset(c034.x);
  uint cbStretchFade : packoffset(c034.w);
  float2 cbSamplingSize : packoffset(c035.x);
  float cbAlphaIntensity : packoffset(c035.z);
  float cbStrengthBlur : packoffset(c035.w);
  float4 cbScaleByDepthDepth : packoffset(c036.x);
  float2 cbScaleByDepthScale : packoffset(c037.x);
  float2 cbVolumetricLighting : packoffset(c037.z);
  uint4 cbParamRgbItem3D : packoffset(c038.x);
  float cbLightShadowRatio : packoffset(c039.x);
  float cbBackfaceLightRatio : packoffset(c039.y);
  float cbDirectionalLightShadowRatio : packoffset(c039.z);
  uint cbDistortionSpecularColor : packoffset(c039.w);
};

SamplerState BilinearClamp : register(s5, space32);

SamplerState TrilinearClamp : register(s9, space32);

struct OutputSignature {
  float4 SV_Target : SV_Target;
  float SV_Target_1 : SV_Target1;
};

OutputSignature main(
    noperspective float4 SV_Position: SV_Position,
    linear float4 Color: Color,
    linear float4 AlphaCorrection: AlphaCorrection,
    linear float4 GeometryAttribute: GeometryAttribute,
    linear float2 TexCoord: TexCoord,
    linear float GhostItem: GhostItem,
    linear float ParticleTimerItem: ParticleTimerItem,
    linear float4 TexCoord_1: TexCoord1,
    linear float3 TexCoord_2: TexCoord2,
    linear float4 TexCoord_3: TexCoord3,
    nointerpolation uint RgbItem: RgbItem,
    linear float3 NormalFromEmitterItem: NormalFromEmitterItem) {
  float4 SV_Target;
  float SV_Target_1;
  float _38;
  float _39;
  float _56;
  float _57;
  float _121;
  float _122;
  float _123;
  float _124;
  float _179;
  float _180;
  float _181;
  float _182;
  float _396;
  float _397;
  float _398;
  float _399;
  float _400;
  float _401;
  float _402;
  float _471;
  float _472;
  float _528;
  float _529;
  float _530;
  float _587;
  float _588;
  float _589;
  float _623;
  float _624;
  float _625;
  float _700;
  float _701;
  float _702;
  float _736;
  float _737;
  float _738;
  float _799;
  float _800;
  float _801;
  float _834;
  float _835;
  float _836;
  float _916;
  float _917;
  float _918;
  float _951;
  float _952;
  float _953;
  float _1010;
  float _1011;
  float _1012;
  float _1045;
  float _1046;
  float _1047;
  float _1062;
  float _1063;
  float _1064;
  float _1065;
  if (!((cbEffect3DFlags & 8) == 0)) {
    _38 = frac(TexCoord_2.x);
    _39 = frac(TexCoord_2.y);
  } else {
    _38 = TexCoord_2.x;
    _39 = TexCoord_2.y;
  }
  float _44 = (saturate(_38) * (TexCoord_3.z - TexCoord_3.x)) + TexCoord_3.x;
  float _47 = (saturate(_39) * (TexCoord_3.w - TexCoord_3.y)) + TexCoord_3.y;
  if (!((cbEffect3DFlags & 8) == 0)) {
    _56 = frac(TexCoord.x);
    _57 = frac(TexCoord.y);
  } else {
    _56 = TexCoord.x;
    _57 = TexCoord.y;
  }
  float _60 = TexCoord_1.z - TexCoord_1.x;
  float _62 = (saturate(_56) * _60) + TexCoord_1.x;
  float _63 = TexCoord_1.w - TexCoord_1.y;
  float _65 = (saturate(_57) * _63) + TexCoord_1.y;
  bool _66 = (GeometryAttribute.w < 0.0f);
  bool _70 = ((cbEffect3DFlags2 & 6144) == 0);
  if (_66) {
    bool _77 = ((cbEffect3DFlags2 & 1024) != 0);
    if (!((cbEffect3DFlags & 8) == 0)) {
      float _79 = TexCoord.x * _60;
      float _80 = TexCoord.y * _63;
      float4 _85 = primTex.SampleGrad(BilinearClamp, float2(_44, _47), float2(ddx_coarse(_79), ddx_coarse(_80)), float2(ddy_coarse(_79), ddy_coarse(_80)), int2(0, 0));
      float _90 = select(_77, _85.x, _85.y);
      float _91 = select(_77, _85.x, _85.z);
      float _92 = select(_77, _85.y, _85.w);
      if (_70) {
        _121 = _85.x;
        _122 = _90;
        _123 = _91;
        _124 = (pow(_92, 4.840000152587891f));
      } else {
        _121 = _85.x;
        _122 = _90;
        _123 = _91;
        _124 = _92;
      }
    } else {
      float4 _98 = primTex.Sample(BilinearClamp, float2(_44, _47));
      float _103 = select(_77, _98.x, _98.y);
      float _104 = select(_77, _98.x, _98.z);
      float _105 = select(_77, _98.y, _98.w);
      if (_70) {
        _121 = _98.x;
        _122 = _103;
        _123 = _104;
        _124 = (pow(_105, 4.840000152587891f));
      } else {
        _121 = _98.x;
        _122 = _103;
        _123 = _104;
        _124 = _105;
      }
    }
  } else {
    float4 _111 = primTex.SampleLevel(TrilinearClamp, float2(_44, _47), GeometryAttribute.w);
    if (_70) {
      _121 = _111.x;
      _122 = _111.y;
      _123 = _111.z;
      _124 = (pow(_111.w, 4.840000152587891f));
    } else {
      _121 = _111.x;
      _122 = _111.y;
      _123 = _111.z;
      _124 = _111.w;
    }
  }
  bool _128 = ((cbEffect3DFlags2 & 6144) == 0);
  if (_66) {
    bool _135 = ((cbEffect3DFlags2 & 1024) != 0);
    if (!((cbEffect3DFlags & 8) == 0)) {
      float _137 = TexCoord.x * _60;
      float _138 = TexCoord.y * _63;
      float4 _143 = primTex.SampleGrad(BilinearClamp, float2(_62, _65), float2(ddx_coarse(_137), ddx_coarse(_138)), float2(ddy_coarse(_137), ddy_coarse(_138)), int2(0, 0));
      float _148 = select(_135, _143.x, _143.y);
      float _149 = select(_135, _143.x, _143.z);
      float _150 = select(_135, _143.y, _143.w);
      if (_128) {
        _179 = _143.x;
        _180 = _148;
        _181 = _149;
        _182 = (pow(_150, 4.840000152587891f));
      } else {
        _179 = _143.x;
        _180 = _148;
        _181 = _149;
        _182 = _150;
      }
    } else {
      float4 _156 = primTex.Sample(BilinearClamp, float2(_62, _65));
      float _161 = select(_135, _156.x, _156.y);
      float _162 = select(_135, _156.x, _156.z);
      float _163 = select(_135, _156.y, _156.w);
      if (_128) {
        _179 = _156.x;
        _180 = _161;
        _181 = _162;
        _182 = (pow(_163, 4.840000152587891f));
      } else {
        _179 = _156.x;
        _180 = _161;
        _181 = _162;
        _182 = _163;
      }
    }
  } else {
    float4 _169 = primTex.SampleLevel(TrilinearClamp, float2(_62, _65), GeometryAttribute.w);
    if (_128) {
      _179 = _169.x;
      _180 = _169.y;
      _181 = _169.z;
      _182 = (pow(_169.w, 4.840000152587891f));
    } else {
      _179 = _169.x;
      _180 = _169.y;
      _181 = _169.z;
      _182 = _169.w;
    }
  }
  float _191 = ((_179 - _121) * TexCoord_2.z) + _121;
  float _192 = ((_180 - _122) * TexCoord_2.z) + _122;
  float _193 = ((_181 - _123) * TexCoord_2.z) + _123;
  float _195 = saturate(lerp(_124, _182, TexCoord_2.z));
  [branch]
  if (!((cbEffect3DFlags2 & 2048) == 0)) {
    bool _202 = ((cbEffect3DFlags2 & 16384) != 0);
    bool _204 = ((cbEffect3DFlags2 & 8192) != 0);
    float _217 = float((uint)((int)(cbParamRgbItem3D.x & 255))) * 0.003921568859368563f;
    float _218 = float((uint)((int)(((uint)((int)(cbParamRgbItem3D.x)) >> 8) & 255))) * 0.003921568859368563f;
    float _219 = float((uint)((int)(((uint)((int)(cbParamRgbItem3D.x)) >> 16) & 255))) * 0.003921568859368563f;
    float _254 = f16tof32(((int)(RgbItem & 65535)));
    float _262 = (float((uint)((int)((uint)((int)(cbParamRgbItem3D.x)) >> 24))) * 0.003921568859368563f) * exp2(log2(max((f16tof32(((int)((uint)((int)(RgbItem)) >> 16))) * _192), 9.99999993922529e-09f)) * f16tof32(((int)(((uint)((int)(cbParamRgbItem3D.z)) >> 7) & 32752))));
    float _263 = _262 * f16tof32(((int)(((uint)(cbParamRgbItem3D.z << 4)) & 32752)));
    float _266 = saturate(_263 / max(f16tof32(((int)(((uint)((int)(cbParamRgbItem3D.z)) >> 22) << 5))), 9.999999974752427e-07f));
    float _267 = _266 * _266;
    float _277 = ((_267 * (1.0f - _217)) + _217) * _263;
    float _278 = ((_267 * (1.0f - _218)) + _218) * _263;
    float _279 = ((_267 * (1.0f - _219)) + _219) * _263;
    float _287 = ((_254 * (_193 - _191)) + _191) * f16tof32(((int)(((uint)(cbParamRgbItem3D.w << 4)) & 32752)));
    float _288 = (float((uint)((int)(cbParamRgbItem3D.y & 255))) * 0.003921568859368563f) * _287;
    float _289 = (float((uint)((int)(((uint)((int)(cbParamRgbItem3D.y)) >> 8) & 255))) * 0.003921568859368563f) * _287;
    float _290 = (float((uint)((int)(((uint)((int)(cbParamRgbItem3D.y)) >> 16) & 255))) * 0.003921568859368563f) * _287;
    float _292 = float((bool)((bool)(!_204)));
    float _297 = float((bool)((bool)(!_202)));
    float _304 = float((bool)_204);
    float _308 = float((bool)_202);
    float _317 = saturate((_262 + ((float((uint)((int)((uint)((int)(cbParamRgbItem3D.y)) >> 24))) * 0.003921568859368563f) * ((_254 * (_193 - _195)) + _195))) * f16tof32(((int)(((uint)((int)(cbParamRgbItem3D.w)) >> 7) & 32752))));
    _396 = ((_277 * _308) + (_288 * _304));
    _397 = ((_278 * _308) + (_289 * _304));
    _398 = ((_279 * _308) + (_290 * _304));
    _399 = select((_317 <= 9.999999747378752e-05f), 0.0f, _317);
    _400 = ((_277 * _297) + (_288 * _292));
    _401 = ((_278 * _297) + (_289 * _292));
    _402 = ((_279 * _297) + (_290 * _292));
  } else {
    if (!((cbEffect3DFlags2 & 4096) == 0)) {
      float _350 = f16tof32(((int)(((uint)(cbParamRgbItem3D.z << 4)) & 32752)));
      float _353 = f16tof32(((int)(((uint)((int)(cbParamRgbItem3D.z)) >> 7) & 32752)));
      float _368 = _350 * _191;
      float _375 = (f16tof32(((int)(((uint)((int)(RgbItem)) >> 22) << 5))) * (_193 - _192)) + _192;
      _396 = ((((_353 * float((uint)((int)(cbParamRgbItem3D.y & 255)))) * _375) + ((float((uint)((int)(cbParamRgbItem3D.x & 255))) * _191) * _350)) * 0.003921568859368563f);
      _397 = ((((float((uint)((int)(((uint)((int)(cbParamRgbItem3D.y)) >> 8) & 255))) * _353) * _375) + (_368 * float((uint)((int)(((uint)((int)(cbParamRgbItem3D.x)) >> 8) & 255))))) * 0.003921568859368563f);
      _398 = ((((float((uint)((int)(((uint)((int)(cbParamRgbItem3D.y)) >> 16) & 255))) * _353) * _375) + (_368 * float((uint)((int)(((uint)((int)(cbParamRgbItem3D.x)) >> 16) & 255))))) * 0.003921568859368563f);
      _399 = saturate(((_195 * 0.003921568859368563f) * f16tof32(((int)(((uint)((int)(cbParamRgbItem3D.z)) >> 22) << 5)))) * (((f16tof32(((int)(((uint)((int)(RgbItem)) >> 7) & 32752))) * float((uint)((int)((uint)((int)(cbParamRgbItem3D.y)) >> 24)))) * _375) + ((float((uint)((int)((uint)((int)(cbParamRgbItem3D.x)) >> 24))) * _191) * f16tof32(((int)(((uint)(RgbItem << 4)) & 32752))))));
      _400 = 0.0f;
      _401 = 0.0f;
      _402 = 0.0f;
    } else {
      _396 = _191;
      _397 = _192;
      _398 = _193;
      _399 = _195;
      _400 = 0.0f;
      _401 = 0.0f;
      _402 = 0.0f;
    }
  }

#if 1
  HueShiftFire(_396, _397, _398);
#endif

  float _409 = saturate((_399 - cbTextureFilter.z) / (cbTextureFilter.y - cbTextureFilter.z));
  float _418 = exp2(log2(((_409 * _409) * _399) * (3.0f - (_409 * 2.0f))) * cbTextureFilter.x);
  float _419 = 1.0f / AlphaCorrection.y;
  float _427 = saturate(saturate(((_418 * Color.w) - AlphaCorrection.x) * _419));
  float _440 = (((((_427 * _427) * AlphaCorrection.z) * (3.0f - (_427 * 2.0f))) + (saturate((_418 - AlphaCorrection.x) * _419) * (1.0f - AlphaCorrection.z))) * AlphaCorrection.w) + ((Color.w * (1.0f - AlphaCorrection.w)) * _418);
  if (_440 < 1.1920928955078125e-07f) {
    SV_Target.x = 0.0f;
    SV_Target.y = 0.0f;
    SV_Target.z = 0.0f;
    SV_Target.w = 0.0f;
    SV_Target_1 = 0.0f;
    SV_Target.x = 0.0f;
    SV_Target.y = 0.0f;
    SV_Target.z = 0.0f;
    SV_Target.w = 0.0f;
    SV_Target_1 = 0.0f;
  } else {
    bool _446 = (cbContrastHighlighterIntensity > 0.0f);
    do {
      if (_446) {
        float _462 = (((saturate(cbContrastHighlighter.x + saturate((dot(float3(_396, _397, _398), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f)) * _440) * cbContrastHighlighter.w)) / (cbContrastHighlighter.x + 1.0f)) * 2.0f) + -1.0f) * cbContrastHighlighter.y;
        _471 = saturate(_462);
        _472 = (select((saturate(-0.0f - _462) < cbContrastHighlighter.z), 1.0f, 0.0f) * _440);
      } else {
        _471 = 1.0f;
        _472 = _440;
      }
      do {
        if (!((cbEffect3DFlags2 & 262144) == 0)) {
          float _489 = saturate(((dot(float3(_396, _397, _398), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f)) * Color.w) - cbLowGradingBorder) / (cbHighGradingBorder - cbLowGradingBorder));
          float _493 = (_489 * _489) * (3.0f - (_489 * 2.0f));
          float _502 = cbHighBrightnessIntensity * 0.003921568859368563f;
          float _514 = cbLowBrightnessIntensity * 0.003921568859368563f;
          float _515 = _514 * float((uint)((int)(cbLowBrightnessColor & 255)));
          float _516 = _514 * float((uint)((int)(((uint)((int)(cbLowBrightnessColor)) >> 8) & 255)));
          float _517 = _514 * float((uint)((int)(((uint)((int)(cbLowBrightnessColor)) >> 16) & 255)));
          _528 = ((_493 * ((_502 * float((uint)((int)(cbHighBrightnessColor & 255)))) - _515)) + _515);
          _529 = ((_493 * ((_502 * float((uint)((int)(((uint)((int)(cbHighBrightnessColor)) >> 8) & 255)))) - _516)) + _516);
          _530 = ((_493 * ((_502 * float((uint)((int)(((uint)((int)(cbHighBrightnessColor)) >> 16) & 255)))) - _517)) + _517);
        } else {
          _528 = 1.0f;
          _529 = 1.0f;
          _530 = 1.0f;
        }
        switch (((int)(((uint)((int)(cbEffect3DFlags)) >> 11) & 15))) {
          case 0: {
            float _540 = (cbEmissiveRate * (_400 + _396)) * Color.x;
            float _543 = (cbEmissiveRate * (_401 + _397)) * Color.y;
            float _546 = (cbEmissiveRate * (_402 + _398)) * Color.z;
            float _549 = _540 * cbEvOffsetPow2;
            float _550 = _543 * cbEvOffsetPow2;
            float _551 = _546 * cbEvOffsetPow2;
            do {
              if (!((cbEffect3DFlags & 1024) == 0)) {
                int4 _563 = asint(WhitePtSrv[0 / 4]);
                float _568 = (select((useAutoExposure != 0), asfloat(_563.x), 1.0f) * exposureAdjustment) * max((1.0f - tonemapRange), 9.999999747378752e-05f);
                _587 = ((cbDetonemapRate * (max(0.0f, (_540 / _568)) - _549)) + _549);
                _588 = ((cbDetonemapRate * (max(0.0f, (_543 / _568)) - _550)) + _550);
                _589 = ((cbDetonemapRate * (max(0.0f, (_546 / _568)) - _551)) + _551);
              } else {
                _587 = _549;
                _588 = _550;
                _589 = _551;
              }
              float _596 = exp2(log2(max(9.999999974752427e-07f, Color.w)) * cbAlphaRate) * _472;
              do {
                if (_446) {
                  float _609 = exp2(cbContrastHighlighterIntensity * 1.4426950216293335f) * 0.003921568859368563f;
                  float _610 = _609 * float((uint)((int)(cbContrastHighlighterColor & 255)));
                  float _611 = _609 * float((uint)((int)(((uint)((int)(cbContrastHighlighterColor)) >> 8) & 255)));
                  float _612 = _609 * float((uint)((int)(((uint)((int)(cbContrastHighlighterColor)) >> 16) & 255)));
                  _623 = ((_610 + _587) - (_610 * _471));
                  _624 = ((_611 + _588) - (_611 * _471));
                  _625 = ((_612 + _589) - (_612 * _471));
                } else {
                  _623 = _587;
                  _624 = _588;
                  _625 = _589;
                }
                _1062 = (((_596 * _528) * _623) * cbIntensityScale);
                _1063 = (((_596 * _529) * _624) * cbIntensityScale);
                _1064 = (((_596 * _530) * _625) * cbIntensityScale);
                _1065 = _596;
              } while (false);
            } while (false);
            break;
          }
          case 1: {
            float _643 = dot(float3(_396, _397, _398), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
            float _647 = (((_643 * _643) * 37.5f) * cbEmissiveRate) * cbEvPow2;
            float _648 = _647 + 1.0f;
            float _649 = _647 + cbEvOffsetPow2;
            float _654 = ((_649 * _396) + _400) * Color.x;
            float _656 = ((_649 * _397) + _401) * Color.y;
            float _658 = ((_649 * _398) + _402) * Color.z;
            do {
              if (!((cbEffect3DFlags & 1024) == 0)) {
                int4 _676 = asint(WhitePtSrv[0 / 4]);
                float _681 = (select((useAutoExposure != 0), asfloat(_676.x), 1.0f) * exposureAdjustment) * max((1.0f - tonemapRange), 9.999999747378752e-05f);
                _700 = ((cbDetonemapRate * (max(0.0f, (((_396 * Color.x) * _648) / _681)) - _654)) + _654);
                _701 = ((cbDetonemapRate * (max(0.0f, (((_397 * Color.y) * _648) / _681)) - _656)) + _656);
                _702 = ((cbDetonemapRate * (max(0.0f, (((_398 * Color.z) * _648) / _681)) - _658)) + _658);
              } else {
                _700 = _654;
                _701 = _656;
                _702 = _658;
              }
              float _709 = exp2(log2(max(9.999999974752427e-07f, Color.w)) * cbAlphaRate) * _472;
              do {
                if (_446) {
                  float _722 = exp2(cbContrastHighlighterIntensity * 1.4426950216293335f) * 0.003921568859368563f;
                  float _723 = _722 * float((uint)((int)(cbContrastHighlighterColor & 255)));
                  float _724 = _722 * float((uint)((int)(((uint)((int)(cbContrastHighlighterColor)) >> 8) & 255)));
                  float _725 = _722 * float((uint)((int)(((uint)((int)(cbContrastHighlighterColor)) >> 16) & 255)));
                  _736 = ((_723 + _700) - (_723 * _471));
                  _737 = ((_724 + _701) - (_724 * _471));
                  _738 = ((_725 + _702) - (_725 * _471));
                } else {
                  _736 = _700;
                  _737 = _701;
                  _738 = _702;
                }
                _1062 = (((_709 * _528) * _736) * cbIntensityScale);
                _1063 = (((_709 * _529) * _737) * cbIntensityScale);
                _1064 = (((_709 * _530) * _738) * cbIntensityScale);
                _1065 = (cbUsePhysicalAlphaBlend3D * _709);
              } while (false);
            } while (false);
            break;
          }
          case 2: {
            float _762 = (cbEmissiveRate * (_400 + _396)) * Color.x;
            float _765 = (cbEmissiveRate * (_401 + _397)) * Color.y;
            float _768 = (cbEmissiveRate * (_402 + _398)) * Color.z;
            do {
              if (!((cbEffect3DFlags & 1024) == 0)) {
                int4 _780 = asint(WhitePtSrv[0 / 4]);
                float _785 = (select((useAutoExposure != 0), asfloat(_780.x), 1.0f) * exposureAdjustment) * max((1.0f - tonemapRange), 9.999999747378752e-05f);
                _799 = max(0.0f, (_762 / _785));
                _800 = max(0.0f, (_765 / _785));
                _801 = max(0.0f, (_768 / _785));
              } else {
                _799 = (cbEvOffsetPow2 * _762);
                _800 = (cbEvOffsetPow2 * _765);
                _801 = (cbEvOffsetPow2 * _768);
              }
              float _807 = exp2(log2(max(9.999999974752427e-07f, Color.w)) * cbAlphaRate) * _472;
              do {
                if (_446) {
                  float _820 = exp2(cbContrastHighlighterIntensity * 1.4426950216293335f) * 0.003921568859368563f;
                  float _821 = _820 * float((uint)((int)(cbContrastHighlighterColor & 255)));
                  float _822 = _820 * float((uint)((int)(((uint)((int)(cbContrastHighlighterColor)) >> 8) & 255)));
                  float _823 = _820 * float((uint)((int)(((uint)((int)(cbContrastHighlighterColor)) >> 16) & 255)));
                  _834 = ((_821 + _799) - (_821 * _471));
                  _835 = ((_822 + _800) - (_822 * _471));
                  _836 = ((_823 + _801) - (_823 * _471));
                } else {
                  _834 = _799;
                  _835 = _800;
                  _836 = _801;
                }
                _1062 = (((_807 * _528) * _834) * cbIntensityScale);
                _1063 = (((_807 * _529) * _835) * cbIntensityScale);
                _1064 = (((_807 * _530) * _836) * cbIntensityScale);
                _1065 = (-0.0f - (_472 * cbIntensity3D));
              } while (false);
            } while (false);
            break;
          }
          case 3: {
            float _854 = exp2(log2(1.0f - _418) * cbEdgeBlendRange3D);
            float _855 = 1.0f - _854;
            float _864 = _854 * 100.0f;
            float _877 = ((cbEmissiveRate * (_400 + _855)) * Color.x) + (((_864 * cbEdgeOuterColor3D.x) * cbIntensity3D) * cbEdgeOuterColor3D.w);
            float _881 = ((cbEmissiveRate * (_401 + _855)) * Color.y) + (((_864 * cbEdgeOuterColor3D.y) * cbIntensity3D) * cbEdgeOuterColor3D.w);
            float _885 = ((cbEmissiveRate * (_402 + _855)) * Color.z) + (((_864 * cbEdgeOuterColor3D.z) * cbIntensity3D) * cbEdgeOuterColor3D.w);
            do {
              if (!((cbEffect3DFlags & 1024) == 0)) {
                int4 _897 = asint(WhitePtSrv[0 / 4]);
                float _902 = (select((useAutoExposure != 0), asfloat(_897.x), 1.0f) * exposureAdjustment) * max((1.0f - tonemapRange), 9.999999747378752e-05f);
                _916 = max(0.0f, (_877 / _902));
                _917 = max(0.0f, (_881 / _902));
                _918 = max(0.0f, (_885 / _902));
              } else {
                _916 = (cbEvOffsetPow2 * _877);
                _917 = (cbEvOffsetPow2 * _881);
                _918 = (cbEvOffsetPow2 * _885);
              }
              float _924 = exp2(log2(max(9.999999974752427e-07f, Color.w)) * cbAlphaRate) * _472;
              do {
                if (_446) {
                  float _937 = exp2(cbContrastHighlighterIntensity * 1.4426950216293335f) * 0.003921568859368563f;
                  float _938 = _937 * float((uint)((int)(cbContrastHighlighterColor & 255)));
                  float _939 = _937 * float((uint)((int)(((uint)((int)(cbContrastHighlighterColor)) >> 8) & 255)));
                  float _940 = _937 * float((uint)((int)(((uint)((int)(cbContrastHighlighterColor)) >> 16) & 255)));
                  _951 = ((_938 + _916) - (_938 * _471));
                  _952 = ((_939 + _917) - (_939 * _471));
                  _953 = ((_940 + _918) - (_940 * _471));
                } else {
                  _951 = _916;
                  _952 = _917;
                  _953 = _918;
                }
                _1062 = (((_924 * _528) * _951) * cbIntensityScale);
                _1063 = (((_924 * _529) * _952) * cbIntensityScale);
                _1064 = (((_924 * _530) * _953) * cbIntensityScale);
                _1065 = _924;
              } while (false);
            } while (false);
            break;
          }
          case 4: {
            float _973 = (cbEmissiveRate * (_400 + _396)) * Color.x;
            float _976 = (cbEmissiveRate * (_401 + _397)) * Color.y;
            float _979 = (cbEmissiveRate * (_402 + _398)) * Color.z;
            do {
              if (!((cbEffect3DFlags & 1024) == 0)) {
                int4 _991 = asint(WhitePtSrv[0 / 4]);
                float _996 = (select((useAutoExposure != 0), asfloat(_991.x), 1.0f) * exposureAdjustment) * max((1.0f - tonemapRange), 9.999999747378752e-05f);
                _1010 = max(0.0f, (_973 / _996));
                _1011 = max(0.0f, (_976 / _996));
                _1012 = max(0.0f, (_979 / _996));
              } else {
                _1010 = (cbEvOffsetPow2 * _973);
                _1011 = (cbEvOffsetPow2 * _976);
                _1012 = (cbEvOffsetPow2 * _979);
              }
              float _1018 = exp2(log2(max(9.999999974752427e-07f, Color.w)) * cbAlphaRate) * _472;
              do {
                if (_446) {
                  float _1031 = exp2(cbContrastHighlighterIntensity * 1.4426950216293335f) * 0.003921568859368563f;
                  float _1032 = _1031 * float((uint)((int)(cbContrastHighlighterColor & 255)));
                  float _1033 = _1031 * float((uint)((int)(((uint)((int)(cbContrastHighlighterColor)) >> 8) & 255)));
                  float _1034 = _1031 * float((uint)((int)(((uint)((int)(cbContrastHighlighterColor)) >> 16) & 255)));
                  _1045 = ((_1032 + _1010) - (_1032 * _471));
                  _1046 = ((_1033 + _1011) - (_1033 * _471));
                  _1047 = ((_1034 + _1012) - (_1034 * _471));
                } else {
                  _1045 = _1010;
                  _1046 = _1011;
                  _1047 = _1012;
                }
                _1062 = (((_1018 * _528) * _1045) * cbIntensityScale);
                _1063 = (((_1018 * _529) * _1046) * cbIntensityScale);
                _1064 = (((_1018 * _530) * _1047) * cbIntensityScale);
                _1065 = min(((cbIntensity3D * Color.w) * _1018), 1.0f);
              } while (false);
            } while (false);
            break;
          }
          default: {
            _1062 = 0.0f;
            _1063 = 0.0f;
            _1064 = 0.0f;
            _1065 = 0.0f;
            break;
          }
        }
        SV_Target.x = 0.0f;
        SV_Target.y = 0.0f;
        SV_Target.z = 0.0f;
        SV_Target.w = 0.0f;
        SV_Target_1 = 0.0f;
        SV_Target.x = _1062;
        SV_Target.y = _1063;
        SV_Target.z = _1064;
        SV_Target.w = _1065;
        SV_Target_1 = _1065;
      } while (false);
    } while (false);
  }

  OutputSignature output_signature = { SV_Target, SV_Target_1 };
  return output_signature;
}
