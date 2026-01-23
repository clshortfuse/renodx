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
    nointerpolation uint RgbItem: RgbItem,
    linear float3 NormalFromEmitterItem: NormalFromEmitterItem) {
  float4 SV_Target;
  float SV_Target_1;
  bool _26 = ((cbEffect3DFlags & 8) == 0);
  float _31;
  float _32;
  float _122;
  float _242;
  float _243;
  float _294;
  float _295;
  float _296;
  float _297;
  float _495;
  float _496;
  float _497;
  float _498;
  float _499;
  float _500;
  float _501;
  float _570;
  float _571;
  float _627;
  float _628;
  float _629;
  float _684;
  float _685;
  float _686;
  float _720;
  float _721;
  float _722;
  float _797;
  float _798;
  float _799;
  float _833;
  float _834;
  float _835;
  float _896;
  float _897;
  float _898;
  float _931;
  float _932;
  float _933;
  float _1013;
  float _1014;
  float _1015;
  float _1048;
  float _1049;
  float _1050;
  float _1107;
  float _1108;
  float _1109;
  float _1142;
  float _1143;
  float _1144;
  float _1159;
  float _1160;
  float _1161;
  float _1162;
  if (!_26) {
    _31 = frac(TexCoord.x);
    _32 = frac(TexCoord.y);
  } else {
    _31 = TexCoord.x;
    _32 = TexCoord.y;
  }
  float _35 = TexCoord_1.z - TexCoord_1.x;
  float _37 = (saturate(_31) * _35) + TexCoord_1.x;
  float _38 = TexCoord_1.w - TexCoord_1.y;
  float _40 = (saturate(_32) * _38) + TexCoord_1.y;
  if (!((cbEffect3DFlags2 & 131072) == 0)) {
    if (!((cbEffect3DFlags & 134217728) == 0)) {
      float _56 = cbProcDistUVScale.x * cbUvSeqRect.x;
      float _57 = cbProcDistUVScale.y * cbUvSeqRect.y;
      float _58 = _37 / _56;
      float _59 = _40 / _57;
      float _66 = frac(abs(_58));
      float _67 = frac(abs(_59));
      float _78 = ((select((_58 >= (-0.0f - _58)), _66, (-0.0f - _66)) * _56) / _56) + -0.5f;
      float _79 = ((select((_59 >= (-0.0f - _59)), _67, (-0.0f - _67)) * _57) / _57) + -0.5f;
      float _83 = sqrt((_79 * _79) + (_78 * _78));
      float _85 = atan(_79 / _78);
      bool _88 = (_78 < 0.0f);
      bool _89 = (_78 == 0.0f);
      bool _90 = (_79 >= 0.0f);
      bool _91 = (_79 < 0.0f);
      float _99 = select((_89 && _90), 1.5707963705062866f, select((_89 && _91), -1.5707963705062866f, select((_88 && _91), (_85 + -3.1415927410125732f), select((_88 && _90), (_85 + 3.1415927410125732f), _85))));
      float _105 = select(((bool)((cbEffect3DFlags & 268435456) != 0) && (bool)(_99 > 0.0f)), (-0.0f - _99), _99);
      float _108 = log2(_83 * 2.0f);
      do {
        if (cbProcDistTimes.y > 0.0f) {
          _122 = ((_105 + 1.0f) - exp2((cbProcDistTimes.y * -0.15915493667125702f) * _108));
        } else {
          _122 = ((_105 + -1.0f) + exp2((cbProcDistTimes.y * 0.15915493667125702f) * _108));
        }
        float _145 = _122 + -3.1415927410125732f;
        float _148 = cbProcDistOFreqNoiseFreq * _145;
        float _150 = sin(_148);
        float _153 = sin(_148 * 3.1415927410125732f);
        float _159 = cbProcDistOAmpNoiseFreq * _145;
        float _161 = sin(_159);
        float _164 = sin(_159 * 3.1415927410125732f);
        float _173 = (cbProcDistTimes.z + _122) + ((((((cbProcDistOFreqNoiseAmp * _150) + _153) * 2.0f) - cbProcDistOFreqNoiseAmp) * 0.009999999776482582f) * (_153 + _150));
        float _183 = ((((((cbProcDistVorWAmp * sin(((_83 * 6.2831854820251465f) * cbProcDistVorWFreq) + cbProcDistTimes.x)) + cbProcDistHAmporWOffset) * 0.10000000149011612f) * (pow(_83, cbProcDistHFreqorWAmpCoef))) + _83) + ((((((cbProcDistOAmpNoiseAmp * _161) + _164) * 2.0f) - cbProcDistOAmpNoiseAmp) * 0.009999999776482582f) * (_164 + _161))) + (sin(cbProcDistOFreq * _173) * cbProcDistOAmp);
        _242 = (((float((uint)uint(_58)) + 0.5f) + (_183 * cos(_173))) * _56);
        _243 = (((float((uint)uint(_59)) + 0.5f) + (sin(_173) * _183)) * _57);
      } while (false);
    } else {
      float _193 = _37 / cbUvSeqRect.x;
      float _194 = _40 / cbUvSeqRect.y;
      float _201 = frac(abs(_193));
      float _202 = frac(abs(_194));
      float _225 = sin(((((select((_194 >= (-0.0f - _194)), _202, (-0.0f - _202)) * cbUvSeqRect.y) / cbUvSeqRect.y) * 6.2831854820251465f) * cbProcDistVorWFreq) + cbProcDistTimes.x);
      float _230 = sin(((((select((_193 >= (-0.0f - _193)), _201, (-0.0f - _201)) * cbUvSeqRect.x) / cbUvSeqRect.x) * 6.2831854820251465f) * cbProcDistHFreqorWAmpCoef) + cbProcDistTimes.y);
      _242 = ((((_230 * abs(min(cbProcDistHAmporWOffset, 0.0f))) + (_225 * max(cbProcDistVorWAmp, 0.0f))) * 0.10000000149011612f) + _37);
      _243 = ((((_230 * max(cbProcDistHAmporWOffset, 0.0f)) + (_225 * abs(min(cbProcDistVorWAmp, 0.0f)))) * 0.10000000149011612f) + _40);
    }
  } else {
    _242 = _37;
    _243 = _40;
  }
  bool _247 = ((cbEffect3DFlags2 & 6144) == 0);
  if (GeometryAttribute.w < 0.0f) {
    bool _250 = ((cbEffect3DFlags2 & 1024) != 0);
    if (!_26) {
      float _252 = TexCoord.x * _35;
      float _253 = TexCoord.y * _38;
      float4 _258 = primTex.SampleGrad(BilinearClamp, float2(_242, _243), float2(ddx_coarse(_252), ddx_coarse(_253)), float2(ddy_coarse(_252), ddy_coarse(_253)), int2(0, 0));
      float _263 = select(_250, _258.x, _258.y);
      float _264 = select(_250, _258.x, _258.z);
      float _265 = select(_250, _258.y, _258.w);
      if (_247) {
        _294 = _258.x;
        _295 = _263;
        _296 = _264;
        _297 = (pow(_265, 4.840000152587891f));
      } else {
        _294 = _258.x;
        _295 = _263;
        _296 = _264;
        _297 = _265;
      }
    } else {
      float4 _271 = primTex.Sample(BilinearClamp, float2(_242, _243));
      float _276 = select(_250, _271.x, _271.y);
      float _277 = select(_250, _271.x, _271.z);
      float _278 = select(_250, _271.y, _271.w);
      if (_247) {
        _294 = _271.x;
        _295 = _276;
        _296 = _277;
        _297 = (pow(_278, 4.840000152587891f));
      } else {
        _294 = _271.x;
        _295 = _276;
        _296 = _277;
        _297 = _278;
      }
    }
  } else {
    float4 _284 = primTex.SampleLevel(TrilinearClamp, float2(_242, _243), GeometryAttribute.w);
    if (_247) {
      _294 = _284.x;
      _295 = _284.y;
      _296 = _284.z;
      _297 = (pow(_284.w, 4.840000152587891f));
    } else {
      _294 = _284.x;
      _295 = _284.y;
      _296 = _284.z;
      _297 = _284.w;
    }
  }
  [branch]
  if (!((cbEffect3DFlags2 & 2048) == 0)) {
    bool _301 = ((cbEffect3DFlags2 & 16384) != 0);
    bool _303 = ((cbEffect3DFlags2 & 8192) != 0);
    float _316 = float((uint)((int)(cbParamRgbItem3D.x & 255))) * 0.003921568859368563f;
    float _317 = float((uint)((int)(((uint)((int)(cbParamRgbItem3D.x)) >> 8) & 255))) * 0.003921568859368563f;
    float _318 = float((uint)((int)(((uint)((int)(cbParamRgbItem3D.x)) >> 16) & 255))) * 0.003921568859368563f;
    float _353 = f16tof32(((int)(RgbItem & 65535)));
    float _361 = (float((uint)((int)((uint)((int)(cbParamRgbItem3D.x)) >> 24))) * 0.003921568859368563f) * exp2(log2(max((f16tof32(((int)((uint)((int)(RgbItem)) >> 16))) * _295), 9.99999993922529e-09f)) * f16tof32(((int)(((uint)((int)(cbParamRgbItem3D.z)) >> 7) & 32752))));
    float _362 = _361 * f16tof32(((int)(((uint)(cbParamRgbItem3D.z << 4)) & 32752)));
    float _365 = saturate(_362 / max(f16tof32(((int)(((uint)((int)(cbParamRgbItem3D.z)) >> 22) << 5))), 9.999999974752427e-07f));
    float _366 = _365 * _365;
    float _376 = ((_366 * (1.0f - _316)) + _316) * _362;
    float _377 = ((_366 * (1.0f - _317)) + _317) * _362;
    float _378 = ((_366 * (1.0f - _318)) + _318) * _362;
    float _386 = ((_353 * (_296 - _294)) + _294) * f16tof32(((int)(((uint)(cbParamRgbItem3D.w << 4)) & 32752)));
    float _387 = (float((uint)((int)(cbParamRgbItem3D.y & 255))) * 0.003921568859368563f) * _386;
    float _388 = (float((uint)((int)(((uint)((int)(cbParamRgbItem3D.y)) >> 8) & 255))) * 0.003921568859368563f) * _386;
    float _389 = (float((uint)((int)(((uint)((int)(cbParamRgbItem3D.y)) >> 16) & 255))) * 0.003921568859368563f) * _386;
    float _391 = float((bool)((bool)(!_303)));
    float _396 = float((bool)((bool)(!_301)));
    float _403 = float((bool)_303);
    float _407 = float((bool)_301);
    float _416 = saturate((_361 + ((float((uint)((int)((uint)((int)(cbParamRgbItem3D.y)) >> 24))) * 0.003921568859368563f) * ((_353 * (_296 - _297)) + _297))) * f16tof32(((int)(((uint)((int)(cbParamRgbItem3D.w)) >> 7) & 32752))));
    _495 = ((_376 * _407) + (_387 * _403));
    _496 = ((_377 * _407) + (_388 * _403));
    _497 = ((_378 * _407) + (_389 * _403));
    _498 = select((_416 <= 9.999999747378752e-05f), 0.0f, _416);
    _499 = ((_376 * _396) + (_387 * _391));
    _500 = ((_377 * _396) + (_388 * _391));
    _501 = ((_378 * _396) + (_389 * _391));
  } else {
    if (!((cbEffect3DFlags2 & 4096) == 0)) {
      float _449 = f16tof32(((int)(((uint)(cbParamRgbItem3D.z << 4)) & 32752)));
      float _452 = f16tof32(((int)(((uint)((int)(cbParamRgbItem3D.z)) >> 7) & 32752)));
      float _467 = _449 * _294;
      float _474 = (f16tof32(((int)(((uint)((int)(RgbItem)) >> 22) << 5))) * (_296 - _295)) + _295;
      _495 = ((((_452 * float((uint)((int)(cbParamRgbItem3D.y & 255)))) * _474) + ((float((uint)((int)(cbParamRgbItem3D.x & 255))) * _294) * _449)) * 0.003921568859368563f);
      _496 = ((((float((uint)((int)(((uint)((int)(cbParamRgbItem3D.y)) >> 8) & 255))) * _452) * _474) + (_467 * float((uint)((int)(((uint)((int)(cbParamRgbItem3D.x)) >> 8) & 255))))) * 0.003921568859368563f);
      _497 = ((((float((uint)((int)(((uint)((int)(cbParamRgbItem3D.y)) >> 16) & 255))) * _452) * _474) + (_467 * float((uint)((int)(((uint)((int)(cbParamRgbItem3D.x)) >> 16) & 255))))) * 0.003921568859368563f);
      _498 = saturate(((_297 * 0.003921568859368563f) * f16tof32(((int)(((uint)((int)(cbParamRgbItem3D.z)) >> 22) << 5)))) * (((f16tof32(((int)(((uint)((int)(RgbItem)) >> 7) & 32752))) * float((uint)((int)((uint)((int)(cbParamRgbItem3D.y)) >> 24)))) * _474) + ((float((uint)((int)((uint)((int)(cbParamRgbItem3D.x)) >> 24))) * _294) * f16tof32(((int)(((uint)(RgbItem << 4)) & 32752))))));
      _499 = 0.0f;
      _500 = 0.0f;
      _501 = 0.0f;
    } else {
      _495 = _294;
      _496 = _295;
      _497 = _296;
      _498 = _297;
      _499 = 0.0f;
      _500 = 0.0f;
      _501 = 0.0f;
    }
  }

#if 1
  HueShiftFire(_495, _496, _497);
#endif

  float _508 = saturate((_498 - cbTextureFilter.z) / (cbTextureFilter.y - cbTextureFilter.z));
  float _517 = exp2(log2(((_508 * _508) * _498) * (3.0f - (_508 * 2.0f))) * cbTextureFilter.x);
  float _518 = 1.0f / AlphaCorrection.y;
  float _526 = saturate(saturate(((_517 * Color.w) - AlphaCorrection.x) * _518));
  float _539 = (((((_526 * _526) * AlphaCorrection.z) * (3.0f - (_526 * 2.0f))) + (saturate((_517 - AlphaCorrection.x) * _518) * (1.0f - AlphaCorrection.z))) * AlphaCorrection.w) + ((Color.w * (1.0f - AlphaCorrection.w)) * _517);
  if (_539 < 1.1920928955078125e-07f) {
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
    bool _545 = (cbContrastHighlighterIntensity > 0.0f);
    do {
      if (_545) {
        float _561 = (((saturate(cbContrastHighlighter.x + saturate((dot(float3(_495, _496, _497), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f)) * _539) * cbContrastHighlighter.w)) / (cbContrastHighlighter.x + 1.0f)) * 2.0f) + -1.0f) * cbContrastHighlighter.y;
        _570 = saturate(_561);
        _571 = (select((saturate(-0.0f - _561) < cbContrastHighlighter.z), 1.0f, 0.0f) * _539);
      } else {
        _570 = 1.0f;
        _571 = _539;
      }
      do {
        if (!((cbEffect3DFlags2 & 262144) == 0)) {
          float _588 = saturate(((dot(float3(_495, _496, _497), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f)) * Color.w) - cbLowGradingBorder) / (cbHighGradingBorder - cbLowGradingBorder));
          float _592 = (_588 * _588) * (3.0f - (_588 * 2.0f));
          float _601 = cbHighBrightnessIntensity * 0.003921568859368563f;
          float _613 = cbLowBrightnessIntensity * 0.003921568859368563f;
          float _614 = _613 * float((uint)((int)(cbLowBrightnessColor & 255)));
          float _615 = _613 * float((uint)((int)(((uint)((int)(cbLowBrightnessColor)) >> 8) & 255)));
          float _616 = _613 * float((uint)((int)(((uint)((int)(cbLowBrightnessColor)) >> 16) & 255)));
          _627 = ((_592 * ((_601 * float((uint)((int)(cbHighBrightnessColor & 255)))) - _614)) + _614);
          _628 = ((_592 * ((_601 * float((uint)((int)(((uint)((int)(cbHighBrightnessColor)) >> 8) & 255)))) - _615)) + _615);
          _629 = ((_592 * ((_601 * float((uint)((int)(((uint)((int)(cbHighBrightnessColor)) >> 16) & 255)))) - _616)) + _616);
        } else {
          _627 = 1.0f;
          _628 = 1.0f;
          _629 = 1.0f;
        }
        switch (((int)(((uint)((int)(cbEffect3DFlags)) >> 11) & 15))) {
          case 0: {
            float _637 = (cbEmissiveRate * (_499 + _495)) * Color.x;
            float _640 = (cbEmissiveRate * (_500 + _496)) * Color.y;
            float _643 = (cbEmissiveRate * (_501 + _497)) * Color.z;
            float _646 = _637 * cbEvOffsetPow2;
            float _647 = _640 * cbEvOffsetPow2;
            float _648 = _643 * cbEvOffsetPow2;
            do {
              if (!((cbEffect3DFlags & 1024) == 0)) {
                int4 _660 = asint(WhitePtSrv[0 / 4]);
                float _665 = (select((useAutoExposure != 0), asfloat(_660.x), 1.0f) * exposureAdjustment) * max((1.0f - tonemapRange), 9.999999747378752e-05f);
                _684 = ((cbDetonemapRate * (max(0.0f, (_637 / _665)) - _646)) + _646);
                _685 = ((cbDetonemapRate * (max(0.0f, (_640 / _665)) - _647)) + _647);
                _686 = ((cbDetonemapRate * (max(0.0f, (_643 / _665)) - _648)) + _648);
              } else {
                _684 = _646;
                _685 = _647;
                _686 = _648;
              }
              float _693 = exp2(log2(max(9.999999974752427e-07f, Color.w)) * cbAlphaRate) * _571;
              do {
                if (_545) {
                  float _706 = exp2(cbContrastHighlighterIntensity * 1.4426950216293335f) * 0.003921568859368563f;
                  float _707 = _706 * float((uint)((int)(cbContrastHighlighterColor & 255)));
                  float _708 = _706 * float((uint)((int)(((uint)((int)(cbContrastHighlighterColor)) >> 8) & 255)));
                  float _709 = _706 * float((uint)((int)(((uint)((int)(cbContrastHighlighterColor)) >> 16) & 255)));
                  _720 = ((_707 + _684) - (_707 * _570));
                  _721 = ((_708 + _685) - (_708 * _570));
                  _722 = ((_709 + _686) - (_709 * _570));
                } else {
                  _720 = _684;
                  _721 = _685;
                  _722 = _686;
                }
                _1159 = (((_693 * _627) * _720) * cbIntensityScale);
                _1160 = (((_693 * _628) * _721) * cbIntensityScale);
                _1161 = (((_693 * _629) * _722) * cbIntensityScale);
                _1162 = _693;
              } while (false);
            } while (false);
            break;
          }
          case 1: {
            float _740 = dot(float3(_495, _496, _497), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
            float _744 = (((_740 * _740) * 37.5f) * cbEmissiveRate) * cbEvPow2;
            float _745 = _744 + 1.0f;
            float _746 = _744 + cbEvOffsetPow2;
            float _751 = ((_746 * _495) + _499) * Color.x;
            float _753 = ((_746 * _496) + _500) * Color.y;
            float _755 = ((_746 * _497) + _501) * Color.z;
            do {
              if (!((cbEffect3DFlags & 1024) == 0)) {
                int4 _773 = asint(WhitePtSrv[0 / 4]);
                float _778 = (select((useAutoExposure != 0), asfloat(_773.x), 1.0f) * exposureAdjustment) * max((1.0f - tonemapRange), 9.999999747378752e-05f);
                _797 = ((cbDetonemapRate * (max(0.0f, (((_495 * Color.x) * _745) / _778)) - _751)) + _751);
                _798 = ((cbDetonemapRate * (max(0.0f, (((_496 * Color.y) * _745) / _778)) - _753)) + _753);
                _799 = ((cbDetonemapRate * (max(0.0f, (((_497 * Color.z) * _745) / _778)) - _755)) + _755);
              } else {
                _797 = _751;
                _798 = _753;
                _799 = _755;
              }
              float _806 = exp2(log2(max(9.999999974752427e-07f, Color.w)) * cbAlphaRate) * _571;
              do {
                if (_545) {
                  float _819 = exp2(cbContrastHighlighterIntensity * 1.4426950216293335f) * 0.003921568859368563f;
                  float _820 = _819 * float((uint)((int)(cbContrastHighlighterColor & 255)));
                  float _821 = _819 * float((uint)((int)(((uint)((int)(cbContrastHighlighterColor)) >> 8) & 255)));
                  float _822 = _819 * float((uint)((int)(((uint)((int)(cbContrastHighlighterColor)) >> 16) & 255)));
                  _833 = ((_820 + _797) - (_820 * _570));
                  _834 = ((_821 + _798) - (_821 * _570));
                  _835 = ((_822 + _799) - (_822 * _570));
                } else {
                  _833 = _797;
                  _834 = _798;
                  _835 = _799;
                }
                _1159 = (((_806 * _627) * _833) * cbIntensityScale);
                _1160 = (((_806 * _628) * _834) * cbIntensityScale);
                _1161 = (((_806 * _629) * _835) * cbIntensityScale);
                _1162 = (cbUsePhysicalAlphaBlend3D * _806);
              } while (false);
            } while (false);
            break;
          }
          case 2: {
            float _859 = (cbEmissiveRate * (_499 + _495)) * Color.x;
            float _862 = (cbEmissiveRate * (_500 + _496)) * Color.y;
            float _865 = (cbEmissiveRate * (_501 + _497)) * Color.z;
            do {
              if (!((cbEffect3DFlags & 1024) == 0)) {
                int4 _877 = asint(WhitePtSrv[0 / 4]);
                float _882 = (select((useAutoExposure != 0), asfloat(_877.x), 1.0f) * exposureAdjustment) * max((1.0f - tonemapRange), 9.999999747378752e-05f);
                _896 = max(0.0f, (_859 / _882));
                _897 = max(0.0f, (_862 / _882));
                _898 = max(0.0f, (_865 / _882));
              } else {
                _896 = (cbEvOffsetPow2 * _859);
                _897 = (cbEvOffsetPow2 * _862);
                _898 = (cbEvOffsetPow2 * _865);
              }
              float _904 = exp2(log2(max(9.999999974752427e-07f, Color.w)) * cbAlphaRate) * _571;
              do {
                if (_545) {
                  float _917 = exp2(cbContrastHighlighterIntensity * 1.4426950216293335f) * 0.003921568859368563f;
                  float _918 = _917 * float((uint)((int)(cbContrastHighlighterColor & 255)));
                  float _919 = _917 * float((uint)((int)(((uint)((int)(cbContrastHighlighterColor)) >> 8) & 255)));
                  float _920 = _917 * float((uint)((int)(((uint)((int)(cbContrastHighlighterColor)) >> 16) & 255)));
                  _931 = ((_918 + _896) - (_918 * _570));
                  _932 = ((_919 + _897) - (_919 * _570));
                  _933 = ((_920 + _898) - (_920 * _570));
                } else {
                  _931 = _896;
                  _932 = _897;
                  _933 = _898;
                }
                _1159 = (((_904 * _627) * _931) * cbIntensityScale);
                _1160 = (((_904 * _628) * _932) * cbIntensityScale);
                _1161 = (((_904 * _629) * _933) * cbIntensityScale);
                _1162 = (-0.0f - (_571 * cbIntensity3D));
              } while (false);
            } while (false);
            break;
          }
          case 3: {
            float _951 = exp2(log2(1.0f - _517) * cbEdgeBlendRange3D);
            float _952 = 1.0f - _951;
            float _961 = _951 * 100.0f;
            float _974 = ((cbEmissiveRate * (_499 + _952)) * Color.x) + (((_961 * cbEdgeOuterColor3D.x) * cbIntensity3D) * cbEdgeOuterColor3D.w);
            float _978 = ((cbEmissiveRate * (_500 + _952)) * Color.y) + (((_961 * cbEdgeOuterColor3D.y) * cbIntensity3D) * cbEdgeOuterColor3D.w);
            float _982 = ((cbEmissiveRate * (_501 + _952)) * Color.z) + (((_961 * cbEdgeOuterColor3D.z) * cbIntensity3D) * cbEdgeOuterColor3D.w);
            do {
              if (!((cbEffect3DFlags & 1024) == 0)) {
                int4 _994 = asint(WhitePtSrv[0 / 4]);
                float _999 = (select((useAutoExposure != 0), asfloat(_994.x), 1.0f) * exposureAdjustment) * max((1.0f - tonemapRange), 9.999999747378752e-05f);
                _1013 = max(0.0f, (_974 / _999));
                _1014 = max(0.0f, (_978 / _999));
                _1015 = max(0.0f, (_982 / _999));
              } else {
                _1013 = (cbEvOffsetPow2 * _974);
                _1014 = (cbEvOffsetPow2 * _978);
                _1015 = (cbEvOffsetPow2 * _982);
              }
              float _1021 = exp2(log2(max(9.999999974752427e-07f, Color.w)) * cbAlphaRate) * _571;
              do {
                if (_545) {
                  float _1034 = exp2(cbContrastHighlighterIntensity * 1.4426950216293335f) * 0.003921568859368563f;
                  float _1035 = _1034 * float((uint)((int)(cbContrastHighlighterColor & 255)));
                  float _1036 = _1034 * float((uint)((int)(((uint)((int)(cbContrastHighlighterColor)) >> 8) & 255)));
                  float _1037 = _1034 * float((uint)((int)(((uint)((int)(cbContrastHighlighterColor)) >> 16) & 255)));
                  _1048 = ((_1035 + _1013) - (_1035 * _570));
                  _1049 = ((_1036 + _1014) - (_1036 * _570));
                  _1050 = ((_1037 + _1015) - (_1037 * _570));
                } else {
                  _1048 = _1013;
                  _1049 = _1014;
                  _1050 = _1015;
                }
                _1159 = (((_1021 * _627) * _1048) * cbIntensityScale);
                _1160 = (((_1021 * _628) * _1049) * cbIntensityScale);
                _1161 = (((_1021 * _629) * _1050) * cbIntensityScale);
                _1162 = _1021;
              } while (false);
            } while (false);
            break;
          }
          case 4: {
            float _1070 = (cbEmissiveRate * (_499 + _495)) * Color.x;
            float _1073 = (cbEmissiveRate * (_500 + _496)) * Color.y;
            float _1076 = (cbEmissiveRate * (_501 + _497)) * Color.z;
            do {
              if (!((cbEffect3DFlags & 1024) == 0)) {
                int4 _1088 = asint(WhitePtSrv[0 / 4]);
                float _1093 = (select((useAutoExposure != 0), asfloat(_1088.x), 1.0f) * exposureAdjustment) * max((1.0f - tonemapRange), 9.999999747378752e-05f);
                _1107 = max(0.0f, (_1070 / _1093));
                _1108 = max(0.0f, (_1073 / _1093));
                _1109 = max(0.0f, (_1076 / _1093));
              } else {
                _1107 = (cbEvOffsetPow2 * _1070);
                _1108 = (cbEvOffsetPow2 * _1073);
                _1109 = (cbEvOffsetPow2 * _1076);
              }
              float _1115 = exp2(log2(max(9.999999974752427e-07f, Color.w)) * cbAlphaRate) * _571;
              do {
                if (_545) {
                  float _1128 = exp2(cbContrastHighlighterIntensity * 1.4426950216293335f) * 0.003921568859368563f;
                  float _1129 = _1128 * float((uint)((int)(cbContrastHighlighterColor & 255)));
                  float _1130 = _1128 * float((uint)((int)(((uint)((int)(cbContrastHighlighterColor)) >> 8) & 255)));
                  float _1131 = _1128 * float((uint)((int)(((uint)((int)(cbContrastHighlighterColor)) >> 16) & 255)));
                  _1142 = ((_1129 + _1107) - (_1129 * _570));
                  _1143 = ((_1130 + _1108) - (_1130 * _570));
                  _1144 = ((_1131 + _1109) - (_1131 * _570));
                } else {
                  _1142 = _1107;
                  _1143 = _1108;
                  _1144 = _1109;
                }
                _1159 = (((_1115 * _627) * _1142) * cbIntensityScale);
                _1160 = (((_1115 * _628) * _1143) * cbIntensityScale);
                _1161 = (((_1115 * _629) * _1144) * cbIntensityScale);
                _1162 = min(((cbIntensity3D * Color.w) * _1115), 1.0f);
              } while (false);
            } while (false);
            break;
          }
          default: {
            _1159 = 0.0f;
            _1160 = 0.0f;
            _1161 = 0.0f;
            _1162 = 0.0f;
            break;
          }
        }
        SV_Target.x = 0.0f;
        SV_Target.y = 0.0f;
        SV_Target.z = 0.0f;
        SV_Target.w = 0.0f;
        SV_Target_1 = 0.0f;
        SV_Target.x = _1159;
        SV_Target.y = _1160;
        SV_Target.z = _1161;
        SV_Target.w = _1162;
        SV_Target_1 = _1162;
      } while (false);
    } while (false);
  }

  OutputSignature output_signature = { SV_Target, SV_Target_1 };
  return output_signature;
}
