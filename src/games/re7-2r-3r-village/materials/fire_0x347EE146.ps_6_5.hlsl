#include "./materials.hlsli"

Texture2D<float> ReadonlyDepth : register(t0);

Buffer<uint4> WhitePtSrv : register(t1);

Texture2D<float4> primTex : register(t2);

cbuffer SceneInfo : register(b0) {
  float4 viewProjMat[4] : packoffset(c000.x);
  float4 transposeViewMat[3] : packoffset(c004.x);
  float4 transposeViewInvMat[3] : packoffset(c007.x);
  float4 projElement[2] : packoffset(c010.x);
  float4 projInvElements[2] : packoffset(c012.x);
  float4 viewProjInvMat[4] : packoffset(c014.x);
  float4 prevViewProjMat[4] : packoffset(c018.x);
  float3 ZToLinear : packoffset(c022.x);
  float subdivisionLevel : packoffset(c022.w);
  float2 screenSize : packoffset(c023.x);
  float2 screenInverseSize : packoffset(c023.z);
  float2 cullingHelper : packoffset(c024.x);
  float cameraNearPlane : packoffset(c024.z);
  float cameraFarPlane : packoffset(c024.w);
  float4 viewFrustum[6] : packoffset(c025.x);
  float4 clipplane : packoffset(c031.x);
  float2 vrsVelocityThreshold : packoffset(c032.x);
  uint renderOutputId : packoffset(c032.z);
  uint SceneInfo_Reserve : packoffset(c032.w);
};

cbuffer Tonemap : register(b1) {
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

cbuffer Polygon3DConstant : register(b2) {
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
  float _43;
  float _44;
  float _61;
  float _62;
  float _126;
  float _127;
  float _128;
  float _129;
  float _184;
  float _185;
  float _186;
  float _187;
  float _401;
  float _402;
  float _403;
  float _404;
  float _405;
  float _406;
  float _407;
  float _465;
  float _534;
  float _535;
  float _590;
  float _591;
  float _592;
  float _649;
  float _650;
  float _651;
  float _685;
  float _686;
  float _687;
  float _767;
  float _768;
  float _769;
  float _803;
  float _804;
  float _805;
  float _866;
  float _867;
  float _868;
  float _901;
  float _902;
  float _903;
  float _983;
  float _984;
  float _985;
  float _1018;
  float _1019;
  float _1020;
  float _1077;
  float _1078;
  float _1079;
  float _1112;
  float _1113;
  float _1114;
  float _1129;
  float _1130;
  float _1131;
  float _1132;
  if (!((cbEffect3DFlags & 8) == 0)) {
    _43 = frac(TexCoord_2.x);
    _44 = frac(TexCoord_2.y);
  } else {
    _43 = TexCoord_2.x;
    _44 = TexCoord_2.y;
  }
  float _49 = (saturate(_43) * (TexCoord_3.z - TexCoord_3.x)) + TexCoord_3.x;
  float _52 = (saturate(_44) * (TexCoord_3.w - TexCoord_3.y)) + TexCoord_3.y;
  if (!((cbEffect3DFlags & 8) == 0)) {
    _61 = frac(TexCoord.x);
    _62 = frac(TexCoord.y);
  } else {
    _61 = TexCoord.x;
    _62 = TexCoord.y;
  }
  float _65 = TexCoord_1.z - TexCoord_1.x;
  float _67 = (saturate(_61) * _65) + TexCoord_1.x;
  float _68 = TexCoord_1.w - TexCoord_1.y;
  float _70 = (saturate(_62) * _68) + TexCoord_1.y;
  bool _71 = (GeometryAttribute.w < 0.0f);
  bool _75 = ((cbEffect3DFlags2 & 6144) == 0);
  if (_71) {
    bool _82 = ((cbEffect3DFlags2 & 1024) != 0);
    if (!((cbEffect3DFlags & 8) == 0)) {
      float _84 = TexCoord.x * _65;
      float _85 = TexCoord.y * _68;
      float4 _90 = primTex.SampleGrad(BilinearClamp, float2(_49, _52), float2(ddx_coarse(_84), ddx_coarse(_85)), float2(ddy_coarse(_84), ddy_coarse(_85)), int2(0, 0));
      float _95 = select(_82, _90.x, _90.y);
      float _96 = select(_82, _90.x, _90.z);
      float _97 = select(_82, _90.y, _90.w);
      if (_75) {
        _126 = _90.x;
        _127 = _95;
        _128 = _96;
        _129 = (pow(_97, 4.840000152587891f));
      } else {
        _126 = _90.x;
        _127 = _95;
        _128 = _96;
        _129 = _97;
      }
    } else {
      float4 _103 = primTex.Sample(BilinearClamp, float2(_49, _52));
      float _108 = select(_82, _103.x, _103.y);
      float _109 = select(_82, _103.x, _103.z);
      float _110 = select(_82, _103.y, _103.w);
      if (_75) {
        _126 = _103.x;
        _127 = _108;
        _128 = _109;
        _129 = (pow(_110, 4.840000152587891f));
      } else {
        _126 = _103.x;
        _127 = _108;
        _128 = _109;
        _129 = _110;
      }
    }
  } else {
    float4 _116 = primTex.SampleLevel(TrilinearClamp, float2(_49, _52), GeometryAttribute.w);
    if (_75) {
      _126 = _116.x;
      _127 = _116.y;
      _128 = _116.z;
      _129 = (pow(_116.w, 4.840000152587891f));
    } else {
      _126 = _116.x;
      _127 = _116.y;
      _128 = _116.z;
      _129 = _116.w;
    }
  }
  bool _133 = ((cbEffect3DFlags2 & 6144) == 0);
  if (_71) {
    bool _140 = ((cbEffect3DFlags2 & 1024) != 0);
    if (!((cbEffect3DFlags & 8) == 0)) {
      float _142 = TexCoord.x * _65;
      float _143 = TexCoord.y * _68;
      float4 _148 = primTex.SampleGrad(BilinearClamp, float2(_67, _70), float2(ddx_coarse(_142), ddx_coarse(_143)), float2(ddy_coarse(_142), ddy_coarse(_143)), int2(0, 0));
      float _153 = select(_140, _148.x, _148.y);
      float _154 = select(_140, _148.x, _148.z);
      float _155 = select(_140, _148.y, _148.w);
      if (_133) {
        _184 = _148.x;
        _185 = _153;
        _186 = _154;
        _187 = (pow(_155, 4.840000152587891f));
      } else {
        _184 = _148.x;
        _185 = _153;
        _186 = _154;
        _187 = _155;
      }
    } else {
      float4 _161 = primTex.Sample(BilinearClamp, float2(_67, _70));
      float _166 = select(_140, _161.x, _161.y);
      float _167 = select(_140, _161.x, _161.z);
      float _168 = select(_140, _161.y, _161.w);
      if (_133) {
        _184 = _161.x;
        _185 = _166;
        _186 = _167;
        _187 = (pow(_168, 4.840000152587891f));
      } else {
        _184 = _161.x;
        _185 = _166;
        _186 = _167;
        _187 = _168;
      }
    }
  } else {
    float4 _174 = primTex.SampleLevel(TrilinearClamp, float2(_67, _70), GeometryAttribute.w);
    if (_133) {
      _184 = _174.x;
      _185 = _174.y;
      _186 = _174.z;
      _187 = (pow(_174.w, 4.840000152587891f));
    } else {
      _184 = _174.x;
      _185 = _174.y;
      _186 = _174.z;
      _187 = _174.w;
    }
  }
  float _196 = ((_184 - _126) * TexCoord_2.z) + _126;
  float _197 = ((_185 - _127) * TexCoord_2.z) + _127;
  float _198 = ((_186 - _128) * TexCoord_2.z) + _128;
  float _200 = saturate(lerp(_129, _187, TexCoord_2.z));
  [branch]
  if (!((cbEffect3DFlags2 & 2048) == 0)) {
    bool _207 = ((cbEffect3DFlags2 & 16384) != 0);
    bool _209 = ((cbEffect3DFlags2 & 8192) != 0);
    float _222 = float((uint)((int)(cbParamRgbItem3D.x & 255))) * 0.003921568859368563f;
    float _223 = float((uint)((int)(((uint)((int)(cbParamRgbItem3D.x)) >> 8) & 255))) * 0.003921568859368563f;
    float _224 = float((uint)((int)(((uint)((int)(cbParamRgbItem3D.x)) >> 16) & 255))) * 0.003921568859368563f;
    float _259 = f16tof32(((int)(RgbItem & 65535)));
    float _267 = (float((uint)((int)((uint)((int)(cbParamRgbItem3D.x)) >> 24))) * 0.003921568859368563f) * exp2(log2(max((f16tof32(((int)((uint)((int)(RgbItem)) >> 16))) * _197), 9.99999993922529e-09f)) * f16tof32(((int)(((uint)((int)(cbParamRgbItem3D.z)) >> 7) & 32752))));
    float _268 = _267 * f16tof32(((int)(((uint)(cbParamRgbItem3D.z << 4)) & 32752)));
    float _271 = saturate(_268 / max(f16tof32(((int)(((uint)((int)(cbParamRgbItem3D.z)) >> 22) << 5))), 9.999999974752427e-07f));
    float _272 = _271 * _271;
    float _282 = ((_272 * (1.0f - _222)) + _222) * _268;
    float _283 = ((_272 * (1.0f - _223)) + _223) * _268;
    float _284 = ((_272 * (1.0f - _224)) + _224) * _268;
    float _292 = ((_259 * (_198 - _196)) + _196) * f16tof32(((int)(((uint)(cbParamRgbItem3D.w << 4)) & 32752)));
    float _293 = (float((uint)((int)(cbParamRgbItem3D.y & 255))) * 0.003921568859368563f) * _292;
    float _294 = (float((uint)((int)(((uint)((int)(cbParamRgbItem3D.y)) >> 8) & 255))) * 0.003921568859368563f) * _292;
    float _295 = (float((uint)((int)(((uint)((int)(cbParamRgbItem3D.y)) >> 16) & 255))) * 0.003921568859368563f) * _292;
    float _297 = float((bool)((bool)(!_209)));
    float _302 = float((bool)((bool)(!_207)));
    float _309 = float((bool)_209);
    float _313 = float((bool)_207);
    float _322 = saturate((_267 + ((float((uint)((int)((uint)((int)(cbParamRgbItem3D.y)) >> 24))) * 0.003921568859368563f) * ((_259 * (_198 - _200)) + _200))) * f16tof32(((int)(((uint)((int)(cbParamRgbItem3D.w)) >> 7) & 32752))));
    _401 = ((_282 * _313) + (_293 * _309));
    _402 = ((_283 * _313) + (_294 * _309));
    _403 = ((_284 * _313) + (_295 * _309));
    _404 = select((_322 <= 9.999999747378752e-05f), 0.0f, _322);
    _405 = ((_282 * _302) + (_293 * _297));
    _406 = ((_283 * _302) + (_294 * _297));
    _407 = ((_284 * _302) + (_295 * _297));
  } else {
    if (!((cbEffect3DFlags2 & 4096) == 0)) {
      float _355 = f16tof32(((int)(((uint)(cbParamRgbItem3D.z << 4)) & 32752)));
      float _358 = f16tof32(((int)(((uint)((int)(cbParamRgbItem3D.z)) >> 7) & 32752)));
      float _373 = _355 * _196;
      float _380 = (f16tof32(((int)(((uint)((int)(RgbItem)) >> 22) << 5))) * (_198 - _197)) + _197;
      _401 = ((((_358 * float((uint)((int)(cbParamRgbItem3D.y & 255)))) * _380) + ((float((uint)((int)(cbParamRgbItem3D.x & 255))) * _196) * _355)) * 0.003921568859368563f);
      _402 = ((((float((uint)((int)(((uint)((int)(cbParamRgbItem3D.y)) >> 8) & 255))) * _358) * _380) + (_373 * float((uint)((int)(((uint)((int)(cbParamRgbItem3D.x)) >> 8) & 255))))) * 0.003921568859368563f);
      _403 = ((((float((uint)((int)(((uint)((int)(cbParamRgbItem3D.y)) >> 16) & 255))) * _358) * _380) + (_373 * float((uint)((int)(((uint)((int)(cbParamRgbItem3D.x)) >> 16) & 255))))) * 0.003921568859368563f);
      _404 = saturate(((_200 * 0.003921568859368563f) * f16tof32(((int)(((uint)((int)(cbParamRgbItem3D.z)) >> 22) << 5)))) * (((f16tof32(((int)(((uint)((int)(RgbItem)) >> 7) & 32752))) * float((uint)((int)((uint)((int)(cbParamRgbItem3D.y)) >> 24)))) * _380) + ((float((uint)((int)((uint)((int)(cbParamRgbItem3D.x)) >> 24))) * _196) * f16tof32(((int)(((uint)(RgbItem << 4)) & 32752))))));
      _405 = 0.0f;
      _406 = 0.0f;
      _407 = 0.0f;
    } else {
      _401 = _196;
      _402 = _197;
      _403 = _198;
      _404 = _200;
      _405 = 0.0f;
      _406 = 0.0f;
      _407 = 0.0f;
    }
  }

#if 1
  HueShiftFire(_401, _402, _403);
#endif
  
  float _411 = _404 * Color.w;
  float _416 = ReadonlyDepth.Load(int3(int(SV_Position.x), int(SV_Position.y), 0));
  float _424 = ZToLinear.z / (ZToLinear.x - (ZToLinear.y * _416.x));
  float _428 = dot(float3(_401, _402, _403), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _429 = _428 * _411;
  float _440 = ((ZToLinear.z / (ZToLinear.x - (ZToLinear.y * SV_Position.z))) + cbFakeVolume.x) - ((((exp2(log2(sin(_411 * 1.5707963705062866f)) * 0.4545449912548065f) - _429) * cbFakeVolume.y) + _429) * cbFakeVolume.x);
  if (cbSoftParticleDist > 0.0f) {
    _465 = saturate((_424 - _440) / cbSoftParticleDist);
  } else {
    if (cbSoftParticleDist < 0.0f) {
      float _453 = saturate(abs(_424 - _440) / (-0.0f - cbSoftParticleDist));
      float _455 = select((_453 < 0.5f), 0.0f, 1.0f);
      _465 = (((_453 * 2.0f) * (1.0f - _455)) + ((1.0f - ((_453 + -0.5f) * 2.0f)) * _455));
    } else {
      _465 = 1.0f;
    }
  }
  float _472 = saturate((_404 - cbTextureFilter.z) / (cbTextureFilter.y - cbTextureFilter.z));
  float _481 = exp2(log2(((_472 * _472) * _404) * (3.0f - (_472 * 2.0f))) * cbTextureFilter.x);
  float _482 = 1.0f / AlphaCorrection.y;
  float _490 = saturate(saturate(((_481 * Color.w) - AlphaCorrection.x) * _482));
  float _504 = ((((((_490 * _490) * AlphaCorrection.z) * (3.0f - (_490 * 2.0f))) + (saturate((_481 - AlphaCorrection.x) * _482) * (1.0f - AlphaCorrection.z))) * AlphaCorrection.w) + ((Color.w * (1.0f - AlphaCorrection.w)) * _481)) * _465;
  if (_504 < 1.1920928955078125e-07f) {
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
    bool _510 = (cbContrastHighlighterIntensity > 0.0f);
    do {
      if (_510) {
        float _525 = (((saturate(cbContrastHighlighter.x + saturate((_428 * _504) * cbContrastHighlighter.w)) / (cbContrastHighlighter.x + 1.0f)) * 2.0f) + -1.0f) * cbContrastHighlighter.y;
        _534 = saturate(_525);
        _535 = (select((saturate(-0.0f - _525) < cbContrastHighlighter.z), 1.0f, 0.0f) * _504);
      } else {
        _534 = 1.0f;
        _535 = _504;
      }
      do {
        if (!((cbEffect3DFlags2 & 262144) == 0)) {
          float _551 = saturate(((_428 * Color.w) - cbLowGradingBorder) / (cbHighGradingBorder - cbLowGradingBorder));
          float _555 = (_551 * _551) * (3.0f - (_551 * 2.0f));
          float _564 = cbHighBrightnessIntensity * 0.003921568859368563f;
          float _576 = cbLowBrightnessIntensity * 0.003921568859368563f;
          float _577 = _576 * float((uint)((int)(cbLowBrightnessColor & 255)));
          float _578 = _576 * float((uint)((int)(((uint)((int)(cbLowBrightnessColor)) >> 8) & 255)));
          float _579 = _576 * float((uint)((int)(((uint)((int)(cbLowBrightnessColor)) >> 16) & 255)));
          _590 = ((_555 * ((_564 * float((uint)((int)(cbHighBrightnessColor & 255)))) - _577)) + _577);
          _591 = ((_555 * ((_564 * float((uint)((int)(((uint)((int)(cbHighBrightnessColor)) >> 8) & 255)))) - _578)) + _578);
          _592 = ((_555 * ((_564 * float((uint)((int)(((uint)((int)(cbHighBrightnessColor)) >> 16) & 255)))) - _579)) + _579);
        } else {
          _590 = 1.0f;
          _591 = 1.0f;
          _592 = 1.0f;
        }
        switch (((int)(((uint)((int)(cbEffect3DFlags)) >> 11) & 15))) {
          case 0: {
            float _602 = (cbEmissiveRate * (_405 + _401)) * Color.x;
            float _605 = (cbEmissiveRate * (_406 + _402)) * Color.y;
            float _608 = (cbEmissiveRate * (_407 + _403)) * Color.z;
            float _611 = _602 * cbEvOffsetPow2;
            float _612 = _605 * cbEvOffsetPow2;
            float _613 = _608 * cbEvOffsetPow2;
            do {
              if (!((cbEffect3DFlags & 1024) == 0)) {
                int4 _625 = asint(WhitePtSrv[0 / 4]);
                float _630 = (select((useAutoExposure != 0), asfloat(_625.x), 1.0f) * exposureAdjustment) * max((1.0f - tonemapRange), 9.999999747378752e-05f);
                _649 = ((cbDetonemapRate * (max(0.0f, (_602 / _630)) - _611)) + _611);
                _650 = ((cbDetonemapRate * (max(0.0f, (_605 / _630)) - _612)) + _612);
                _651 = ((cbDetonemapRate * (max(0.0f, (_608 / _630)) - _613)) + _613);
              } else {
                _649 = _611;
                _650 = _612;
                _651 = _613;
              }
              float _658 = exp2(log2(max(9.999999974752427e-07f, Color.w)) * cbAlphaRate) * _535;
              do {
                if (_510) {
                  float _671 = exp2(cbContrastHighlighterIntensity * 1.4426950216293335f) * 0.003921568859368563f;
                  float _672 = _671 * float((uint)((int)(cbContrastHighlighterColor & 255)));
                  float _673 = _671 * float((uint)((int)(((uint)((int)(cbContrastHighlighterColor)) >> 8) & 255)));
                  float _674 = _671 * float((uint)((int)(((uint)((int)(cbContrastHighlighterColor)) >> 16) & 255)));
                  _685 = ((_672 + _649) - (_672 * _534));
                  _686 = ((_673 + _650) - (_673 * _534));
                  _687 = ((_674 + _651) - (_674 * _534));
                } else {
                  _685 = _649;
                  _686 = _650;
                  _687 = _651;
                }
                _1129 = (((_658 * _590) * _685) * cbIntensityScale);
                _1130 = (((_658 * _591) * _686) * cbIntensityScale);
                _1131 = (((_658 * _592) * _687) * cbIntensityScale);
                _1132 = _658;
              } while (false);
            } while (false);
            break;
          }
          case 1: {
            float _708 = (((_428 * _428) * 37.5f) * cbEmissiveRate) * cbEvPow2;
            float _709 = _708 + 1.0f;
            float _710 = _708 + cbEvOffsetPow2;
            float _714 = (_465 * Color.x) * _401;
            float _716 = (_465 * Color.y) * _402;
            float _718 = (_465 * Color.z) * _403;
            float _726 = (_714 * _710) + ((_405 * Color.x) * _465);
            float _727 = (_716 * _710) + ((_406 * Color.y) * _465);
            float _728 = (_718 * _710) + ((_407 * Color.z) * _465);
            do {
              if (!((cbEffect3DFlags & 1024) == 0)) {
                int4 _743 = asint(WhitePtSrv[0 / 4]);
                float _748 = (select((useAutoExposure != 0), asfloat(_743.x), 1.0f) * exposureAdjustment) * max((1.0f - tonemapRange), 9.999999747378752e-05f);
                _767 = ((cbDetonemapRate * (max(0.0f, ((_714 * _709) / _748)) - _726)) + _726);
                _768 = ((cbDetonemapRate * (max(0.0f, ((_716 * _709) / _748)) - _727)) + _727);
                _769 = ((cbDetonemapRate * (max(0.0f, ((_718 * _709) / _748)) - _728)) + _728);
              } else {
                _767 = _726;
                _768 = _727;
                _769 = _728;
              }
              float _776 = exp2(log2(max(9.999999974752427e-07f, Color.w)) * cbAlphaRate) * _535;
              do {
                if (_510) {
                  float _789 = exp2(cbContrastHighlighterIntensity * 1.4426950216293335f) * 0.003921568859368563f;
                  float _790 = _789 * float((uint)((int)(cbContrastHighlighterColor & 255)));
                  float _791 = _789 * float((uint)((int)(((uint)((int)(cbContrastHighlighterColor)) >> 8) & 255)));
                  float _792 = _789 * float((uint)((int)(((uint)((int)(cbContrastHighlighterColor)) >> 16) & 255)));
                  _803 = ((_790 + _767) - (_790 * _534));
                  _804 = ((_791 + _768) - (_791 * _534));
                  _805 = ((_792 + _769) - (_792 * _534));
                } else {
                  _803 = _767;
                  _804 = _768;
                  _805 = _769;
                }
                _1129 = (((_776 * _590) * _803) * cbIntensityScale);
                _1130 = (((_776 * _591) * _804) * cbIntensityScale);
                _1131 = (((_776 * _592) * _805) * cbIntensityScale);
                _1132 = (cbUsePhysicalAlphaBlend3D * _776);
              } while (false);
            } while (false);
            break;
          }
          case 2: {
            float _829 = (cbEmissiveRate * (_405 + _401)) * Color.x;
            float _832 = (cbEmissiveRate * (_406 + _402)) * Color.y;
            float _835 = (cbEmissiveRate * (_407 + _403)) * Color.z;
            do {
              if (!((cbEffect3DFlags & 1024) == 0)) {
                int4 _847 = asint(WhitePtSrv[0 / 4]);
                float _852 = (select((useAutoExposure != 0), asfloat(_847.x), 1.0f) * exposureAdjustment) * max((1.0f - tonemapRange), 9.999999747378752e-05f);
                _866 = max(0.0f, (_829 / _852));
                _867 = max(0.0f, (_832 / _852));
                _868 = max(0.0f, (_835 / _852));
              } else {
                _866 = (cbEvOffsetPow2 * _829);
                _867 = (cbEvOffsetPow2 * _832);
                _868 = (cbEvOffsetPow2 * _835);
              }
              float _874 = exp2(log2(max(9.999999974752427e-07f, Color.w)) * cbAlphaRate) * _535;
              do {
                if (_510) {
                  float _887 = exp2(cbContrastHighlighterIntensity * 1.4426950216293335f) * 0.003921568859368563f;
                  float _888 = _887 * float((uint)((int)(cbContrastHighlighterColor & 255)));
                  float _889 = _887 * float((uint)((int)(((uint)((int)(cbContrastHighlighterColor)) >> 8) & 255)));
                  float _890 = _887 * float((uint)((int)(((uint)((int)(cbContrastHighlighterColor)) >> 16) & 255)));
                  _901 = ((_888 + _866) - (_888 * _534));
                  _902 = ((_889 + _867) - (_889 * _534));
                  _903 = ((_890 + _868) - (_890 * _534));
                } else {
                  _901 = _866;
                  _902 = _867;
                  _903 = _868;
                }
                _1129 = (((_874 * _590) * _901) * cbIntensityScale);
                _1130 = (((_874 * _591) * _902) * cbIntensityScale);
                _1131 = (((_874 * _592) * _903) * cbIntensityScale);
                _1132 = (-0.0f - (_535 * cbIntensity3D));
              } while (false);
            } while (false);
            break;
          }
          case 3: {
            float _921 = exp2(log2(1.0f - _481) * cbEdgeBlendRange3D);
            float _922 = 1.0f - _921;
            float _931 = _921 * 100.0f;
            float _944 = ((cbEmissiveRate * (_405 + _922)) * Color.x) + (((_931 * cbEdgeOuterColor3D.x) * cbIntensity3D) * cbEdgeOuterColor3D.w);
            float _948 = ((cbEmissiveRate * (_406 + _922)) * Color.y) + (((_931 * cbEdgeOuterColor3D.y) * cbIntensity3D) * cbEdgeOuterColor3D.w);
            float _952 = ((cbEmissiveRate * (_407 + _922)) * Color.z) + (((_931 * cbEdgeOuterColor3D.z) * cbIntensity3D) * cbEdgeOuterColor3D.w);
            do {
              if (!((cbEffect3DFlags & 1024) == 0)) {
                int4 _964 = asint(WhitePtSrv[0 / 4]);
                float _969 = (select((useAutoExposure != 0), asfloat(_964.x), 1.0f) * exposureAdjustment) * max((1.0f - tonemapRange), 9.999999747378752e-05f);
                _983 = max(0.0f, (_944 / _969));
                _984 = max(0.0f, (_948 / _969));
                _985 = max(0.0f, (_952 / _969));
              } else {
                _983 = (cbEvOffsetPow2 * _944);
                _984 = (cbEvOffsetPow2 * _948);
                _985 = (cbEvOffsetPow2 * _952);
              }
              float _991 = exp2(log2(max(9.999999974752427e-07f, Color.w)) * cbAlphaRate) * _535;
              do {
                if (_510) {
                  float _1004 = exp2(cbContrastHighlighterIntensity * 1.4426950216293335f) * 0.003921568859368563f;
                  float _1005 = _1004 * float((uint)((int)(cbContrastHighlighterColor & 255)));
                  float _1006 = _1004 * float((uint)((int)(((uint)((int)(cbContrastHighlighterColor)) >> 8) & 255)));
                  float _1007 = _1004 * float((uint)((int)(((uint)((int)(cbContrastHighlighterColor)) >> 16) & 255)));
                  _1018 = ((_1005 + _983) - (_1005 * _534));
                  _1019 = ((_1006 + _984) - (_1006 * _534));
                  _1020 = ((_1007 + _985) - (_1007 * _534));
                } else {
                  _1018 = _983;
                  _1019 = _984;
                  _1020 = _985;
                }
                _1129 = (((_991 * _590) * _1018) * cbIntensityScale);
                _1130 = (((_991 * _591) * _1019) * cbIntensityScale);
                _1131 = (((_991 * _592) * _1020) * cbIntensityScale);
                _1132 = _991;
              } while (false);
            } while (false);
            break;
          }
          case 4: {
            float _1040 = (cbEmissiveRate * (_405 + _401)) * Color.x;
            float _1043 = (cbEmissiveRate * (_406 + _402)) * Color.y;
            float _1046 = (cbEmissiveRate * (_407 + _403)) * Color.z;
            do {
              if (!((cbEffect3DFlags & 1024) == 0)) {
                int4 _1058 = asint(WhitePtSrv[0 / 4]);
                float _1063 = (select((useAutoExposure != 0), asfloat(_1058.x), 1.0f) * exposureAdjustment) * max((1.0f - tonemapRange), 9.999999747378752e-05f);
                _1077 = max(0.0f, (_1040 / _1063));
                _1078 = max(0.0f, (_1043 / _1063));
                _1079 = max(0.0f, (_1046 / _1063));
              } else {
                _1077 = (cbEvOffsetPow2 * _1040);
                _1078 = (cbEvOffsetPow2 * _1043);
                _1079 = (cbEvOffsetPow2 * _1046);
              }
              float _1085 = exp2(log2(max(9.999999974752427e-07f, Color.w)) * cbAlphaRate) * _535;
              do {
                if (_510) {
                  float _1098 = exp2(cbContrastHighlighterIntensity * 1.4426950216293335f) * 0.003921568859368563f;
                  float _1099 = _1098 * float((uint)((int)(cbContrastHighlighterColor & 255)));
                  float _1100 = _1098 * float((uint)((int)(((uint)((int)(cbContrastHighlighterColor)) >> 8) & 255)));
                  float _1101 = _1098 * float((uint)((int)(((uint)((int)(cbContrastHighlighterColor)) >> 16) & 255)));
                  _1112 = ((_1099 + _1077) - (_1099 * _534));
                  _1113 = ((_1100 + _1078) - (_1100 * _534));
                  _1114 = ((_1101 + _1079) - (_1101 * _534));
                } else {
                  _1112 = _1077;
                  _1113 = _1078;
                  _1114 = _1079;
                }
                _1129 = (((_1085 * _590) * _1112) * cbIntensityScale);
                _1130 = (((_1085 * _591) * _1113) * cbIntensityScale);
                _1131 = (((_1085 * _592) * _1114) * cbIntensityScale);
                _1132 = min(((cbIntensity3D * Color.w) * _1085), 1.0f);
              } while (false);
            } while (false);
            break;
          }
          default: {
            _1129 = 0.0f;
            _1130 = 0.0f;
            _1131 = 0.0f;
            _1132 = 0.0f;
            break;
          }
        }
        SV_Target.x = 0.0f;
        SV_Target.y = 0.0f;
        SV_Target.z = 0.0f;
        SV_Target.w = 0.0f;
        SV_Target_1 = 0.0f;
        SV_Target.x = _1129;
        SV_Target.y = _1130;
        SV_Target.z = _1131;
        SV_Target.w = _1132;
        SV_Target_1 = _1132;
      } while (false);
    } while (false);
  }

  OutputSignature output_signature = { SV_Target, SV_Target_1 };
  return output_signature;
}
