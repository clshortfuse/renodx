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
    nointerpolation uint RgbItem: RgbItem,
    linear float3 NormalFromEmitterItem: NormalFromEmitterItem) {
  float4 SV_Target;
  float SV_Target_1;
  bool _31 = ((cbEffect3DFlags & 8) == 0);
  float _36;
  float _37;
  float _127;
  float _247;
  float _248;
  float _299;
  float _300;
  float _301;
  float _302;
  float _500;
  float _501;
  float _502;
  float _503;
  float _504;
  float _505;
  float _506;
  float _564;
  float _633;
  float _634;
  float _689;
  float _690;
  float _691;
  float _746;
  float _747;
  float _748;
  float _782;
  float _783;
  float _784;
  float _864;
  float _865;
  float _866;
  float _900;
  float _901;
  float _902;
  float _963;
  float _964;
  float _965;
  float _998;
  float _999;
  float _1000;
  float _1080;
  float _1081;
  float _1082;
  float _1115;
  float _1116;
  float _1117;
  float _1174;
  float _1175;
  float _1176;
  float _1209;
  float _1210;
  float _1211;
  float _1226;
  float _1227;
  float _1228;
  float _1229;
  if (!_31) {
    _36 = frac(TexCoord.x);
    _37 = frac(TexCoord.y);
  } else {
    _36 = TexCoord.x;
    _37 = TexCoord.y;
  }
  float _40 = TexCoord_1.z - TexCoord_1.x;
  float _42 = (saturate(_36) * _40) + TexCoord_1.x;
  float _43 = TexCoord_1.w - TexCoord_1.y;
  float _45 = (saturate(_37) * _43) + TexCoord_1.y;
  if (!((cbEffect3DFlags2 & 131072) == 0)) {
    if (!((cbEffect3DFlags & 134217728) == 0)) {
      float _61 = cbProcDistUVScale.x * cbUvSeqRect.x;
      float _62 = cbProcDistUVScale.y * cbUvSeqRect.y;
      float _63 = _42 / _61;
      float _64 = _45 / _62;
      float _71 = frac(abs(_63));
      float _72 = frac(abs(_64));
      float _83 = ((select((_63 >= (-0.0f - _63)), _71, (-0.0f - _71)) * _61) / _61) + -0.5f;
      float _84 = ((select((_64 >= (-0.0f - _64)), _72, (-0.0f - _72)) * _62) / _62) + -0.5f;
      float _88 = sqrt((_84 * _84) + (_83 * _83));
      float _90 = atan(_84 / _83);
      bool _93 = (_83 < 0.0f);
      bool _94 = (_83 == 0.0f);
      bool _95 = (_84 >= 0.0f);
      bool _96 = (_84 < 0.0f);
      float _104 = select((_94 && _95), 1.5707963705062866f, select((_94 && _96), -1.5707963705062866f, select((_93 && _96), (_90 + -3.1415927410125732f), select((_93 && _95), (_90 + 3.1415927410125732f), _90))));
      float _110 = select(((bool)((cbEffect3DFlags & 268435456) != 0) && (bool)(_104 > 0.0f)), (-0.0f - _104), _104);
      float _113 = log2(_88 * 2.0f);
      do {
        if (cbProcDistTimes.y > 0.0f) {
          _127 = ((_110 + 1.0f) - exp2((cbProcDistTimes.y * -0.15915493667125702f) * _113));
        } else {
          _127 = ((_110 + -1.0f) + exp2((cbProcDistTimes.y * 0.15915493667125702f) * _113));
        }
        float _150 = _127 + -3.1415927410125732f;
        float _153 = cbProcDistOFreqNoiseFreq * _150;
        float _155 = sin(_153);
        float _158 = sin(_153 * 3.1415927410125732f);
        float _164 = cbProcDistOAmpNoiseFreq * _150;
        float _166 = sin(_164);
        float _169 = sin(_164 * 3.1415927410125732f);
        float _178 = (cbProcDistTimes.z + _127) + ((((((cbProcDistOFreqNoiseAmp * _155) + _158) * 2.0f) - cbProcDistOFreqNoiseAmp) * 0.009999999776482582f) * (_158 + _155));
        float _188 = ((((((cbProcDistVorWAmp * sin(((_88 * 6.2831854820251465f) * cbProcDistVorWFreq) + cbProcDistTimes.x)) + cbProcDistHAmporWOffset) * 0.10000000149011612f) * (pow(_88, cbProcDistHFreqorWAmpCoef))) + _88) + ((((((cbProcDistOAmpNoiseAmp * _166) + _169) * 2.0f) - cbProcDistOAmpNoiseAmp) * 0.009999999776482582f) * (_169 + _166))) + (sin(cbProcDistOFreq * _178) * cbProcDistOAmp);
        _247 = (((float((uint)uint(_63)) + 0.5f) + (_188 * cos(_178))) * _61);
        _248 = (((float((uint)uint(_64)) + 0.5f) + (sin(_178) * _188)) * _62);
      } while (false);
    } else {
      float _198 = _42 / cbUvSeqRect.x;
      float _199 = _45 / cbUvSeqRect.y;
      float _206 = frac(abs(_198));
      float _207 = frac(abs(_199));
      float _230 = sin(((((select((_199 >= (-0.0f - _199)), _207, (-0.0f - _207)) * cbUvSeqRect.y) / cbUvSeqRect.y) * 6.2831854820251465f) * cbProcDistVorWFreq) + cbProcDistTimes.x);
      float _235 = sin(((((select((_198 >= (-0.0f - _198)), _206, (-0.0f - _206)) * cbUvSeqRect.x) / cbUvSeqRect.x) * 6.2831854820251465f) * cbProcDistHFreqorWAmpCoef) + cbProcDistTimes.y);
      _247 = ((((_235 * abs(min(cbProcDistHAmporWOffset, 0.0f))) + (_230 * max(cbProcDistVorWAmp, 0.0f))) * 0.10000000149011612f) + _42);
      _248 = ((((_235 * max(cbProcDistHAmporWOffset, 0.0f)) + (_230 * abs(min(cbProcDistVorWAmp, 0.0f)))) * 0.10000000149011612f) + _45);
    }
  } else {
    _247 = _42;
    _248 = _45;
  }
  bool _252 = ((cbEffect3DFlags2 & 6144) == 0);
  if (GeometryAttribute.w < 0.0f) {
    bool _255 = ((cbEffect3DFlags2 & 1024) != 0);
    if (!_31) {
      float _257 = TexCoord.x * _40;
      float _258 = TexCoord.y * _43;
      float4 _263 = primTex.SampleGrad(BilinearClamp, float2(_247, _248), float2(ddx_coarse(_257), ddx_coarse(_258)), float2(ddy_coarse(_257), ddy_coarse(_258)), int2(0, 0));
      float _268 = select(_255, _263.x, _263.y);
      float _269 = select(_255, _263.x, _263.z);
      float _270 = select(_255, _263.y, _263.w);
      if (_252) {
        _299 = _263.x;
        _300 = _268;
        _301 = _269;
        _302 = (pow(_270, 4.840000152587891f));
      } else {
        _299 = _263.x;
        _300 = _268;
        _301 = _269;
        _302 = _270;
      }
    } else {
      float4 _276 = primTex.Sample(BilinearClamp, float2(_247, _248));
      float _281 = select(_255, _276.x, _276.y);
      float _282 = select(_255, _276.x, _276.z);
      float _283 = select(_255, _276.y, _276.w);
      if (_252) {
        _299 = _276.x;
        _300 = _281;
        _301 = _282;
        _302 = (pow(_283, 4.840000152587891f));
      } else {
        _299 = _276.x;
        _300 = _281;
        _301 = _282;
        _302 = _283;
      }
    }
  } else {
    float4 _289 = primTex.SampleLevel(TrilinearClamp, float2(_247, _248), GeometryAttribute.w);
    if (_252) {
      _299 = _289.x;
      _300 = _289.y;
      _301 = _289.z;
      _302 = (pow(_289.w, 4.840000152587891f));
    } else {
      _299 = _289.x;
      _300 = _289.y;
      _301 = _289.z;
      _302 = _289.w;
    }
  }
  [branch]
  if (!((cbEffect3DFlags2 & 2048) == 0)) {
    bool _306 = ((cbEffect3DFlags2 & 16384) != 0);
    bool _308 = ((cbEffect3DFlags2 & 8192) != 0);
    float _321 = float((uint)((int)(cbParamRgbItem3D.x & 255))) * 0.003921568859368563f;
    float _322 = float((uint)((int)(((uint)((int)(cbParamRgbItem3D.x)) >> 8) & 255))) * 0.003921568859368563f;
    float _323 = float((uint)((int)(((uint)((int)(cbParamRgbItem3D.x)) >> 16) & 255))) * 0.003921568859368563f;
    float _358 = f16tof32(((int)(RgbItem & 65535)));
    float _366 = (float((uint)((int)((uint)((int)(cbParamRgbItem3D.x)) >> 24))) * 0.003921568859368563f) * exp2(log2(max((f16tof32(((int)((uint)((int)(RgbItem)) >> 16))) * _300), 9.99999993922529e-09f)) * f16tof32(((int)(((uint)((int)(cbParamRgbItem3D.z)) >> 7) & 32752))));
    float _367 = _366 * f16tof32(((int)(((uint)(cbParamRgbItem3D.z << 4)) & 32752)));
    float _370 = saturate(_367 / max(f16tof32(((int)(((uint)((int)(cbParamRgbItem3D.z)) >> 22) << 5))), 9.999999974752427e-07f));
    float _371 = _370 * _370;
    float _381 = ((_371 * (1.0f - _321)) + _321) * _367;
    float _382 = ((_371 * (1.0f - _322)) + _322) * _367;
    float _383 = ((_371 * (1.0f - _323)) + _323) * _367;
    float _391 = ((_358 * (_301 - _299)) + _299) * f16tof32(((int)(((uint)(cbParamRgbItem3D.w << 4)) & 32752)));
    float _392 = (float((uint)((int)(cbParamRgbItem3D.y & 255))) * 0.003921568859368563f) * _391;
    float _393 = (float((uint)((int)(((uint)((int)(cbParamRgbItem3D.y)) >> 8) & 255))) * 0.003921568859368563f) * _391;
    float _394 = (float((uint)((int)(((uint)((int)(cbParamRgbItem3D.y)) >> 16) & 255))) * 0.003921568859368563f) * _391;
    float _396 = float((bool)((bool)(!_308)));
    float _401 = float((bool)((bool)(!_306)));
    float _408 = float((bool)_308);
    float _412 = float((bool)_306);
    float _421 = saturate((_366 + ((float((uint)((int)((uint)((int)(cbParamRgbItem3D.y)) >> 24))) * 0.003921568859368563f) * ((_358 * (_301 - _302)) + _302))) * f16tof32(((int)(((uint)((int)(cbParamRgbItem3D.w)) >> 7) & 32752))));
    _500 = ((_381 * _412) + (_392 * _408));
    _501 = ((_382 * _412) + (_393 * _408));
    _502 = ((_383 * _412) + (_394 * _408));
    _503 = select((_421 <= 9.999999747378752e-05f), 0.0f, _421);
    _504 = ((_381 * _401) + (_392 * _396));
    _505 = ((_382 * _401) + (_393 * _396));
    _506 = ((_383 * _401) + (_394 * _396));
  } else {
    if (!((cbEffect3DFlags2 & 4096) == 0)) {
      float _454 = f16tof32(((int)(((uint)(cbParamRgbItem3D.z << 4)) & 32752)));
      float _457 = f16tof32(((int)(((uint)((int)(cbParamRgbItem3D.z)) >> 7) & 32752)));
      float _472 = _454 * _299;
      float _479 = (f16tof32(((int)(((uint)((int)(RgbItem)) >> 22) << 5))) * (_301 - _300)) + _300;
      _500 = ((((_457 * float((uint)((int)(cbParamRgbItem3D.y & 255)))) * _479) + ((float((uint)((int)(cbParamRgbItem3D.x & 255))) * _299) * _454)) * 0.003921568859368563f);
      _501 = ((((float((uint)((int)(((uint)((int)(cbParamRgbItem3D.y)) >> 8) & 255))) * _457) * _479) + (_472 * float((uint)((int)(((uint)((int)(cbParamRgbItem3D.x)) >> 8) & 255))))) * 0.003921568859368563f);
      _502 = ((((float((uint)((int)(((uint)((int)(cbParamRgbItem3D.y)) >> 16) & 255))) * _457) * _479) + (_472 * float((uint)((int)(((uint)((int)(cbParamRgbItem3D.x)) >> 16) & 255))))) * 0.003921568859368563f);
      _503 = saturate(((_302 * 0.003921568859368563f) * f16tof32(((int)(((uint)((int)(cbParamRgbItem3D.z)) >> 22) << 5)))) * (((f16tof32(((int)(((uint)((int)(RgbItem)) >> 7) & 32752))) * float((uint)((int)((uint)((int)(cbParamRgbItem3D.y)) >> 24)))) * _479) + ((float((uint)((int)((uint)((int)(cbParamRgbItem3D.x)) >> 24))) * _299) * f16tof32(((int)(((uint)(RgbItem << 4)) & 32752))))));
      _504 = 0.0f;
      _505 = 0.0f;
      _506 = 0.0f;
    } else {
      _500 = _299;
      _501 = _300;
      _502 = _301;
      _503 = _302;
      _504 = 0.0f;
      _505 = 0.0f;
      _506 = 0.0f;
    }
  }

#if 1
  HueShiftFire(_500, _501, _502);
#endif

  float _510 = _503 * Color.w;
  float _515 = ReadonlyDepth.Load(int3(int(SV_Position.x), int(SV_Position.y), 0));
  float _523 = ZToLinear.z / (ZToLinear.x - (ZToLinear.y * _515.x));
  float _527 = dot(float3(_500, _501, _502), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _528 = _527 * _510;
  float _539 = ((ZToLinear.z / (ZToLinear.x - (ZToLinear.y * SV_Position.z))) + cbFakeVolume.x) - ((((exp2(log2(sin(_510 * 1.5707963705062866f)) * 0.4545449912548065f) - _528) * cbFakeVolume.y) + _528) * cbFakeVolume.x);
  if (cbSoftParticleDist > 0.0f) {
    _564 = saturate((_523 - _539) / cbSoftParticleDist);
  } else {
    if (cbSoftParticleDist < 0.0f) {
      float _552 = saturate(abs(_523 - _539) / (-0.0f - cbSoftParticleDist));
      float _554 = select((_552 < 0.5f), 0.0f, 1.0f);
      _564 = (((_552 * 2.0f) * (1.0f - _554)) + ((1.0f - ((_552 + -0.5f) * 2.0f)) * _554));
    } else {
      _564 = 1.0f;
    }
  }
  float _571 = saturate((_503 - cbTextureFilter.z) / (cbTextureFilter.y - cbTextureFilter.z));
  float _580 = exp2(log2(((_571 * _571) * _503) * (3.0f - (_571 * 2.0f))) * cbTextureFilter.x);
  float _581 = 1.0f / AlphaCorrection.y;
  float _589 = saturate(saturate(((_580 * Color.w) - AlphaCorrection.x) * _581));
  float _603 = ((((((_589 * _589) * AlphaCorrection.z) * (3.0f - (_589 * 2.0f))) + (saturate((_580 - AlphaCorrection.x) * _581) * (1.0f - AlphaCorrection.z))) * AlphaCorrection.w) + ((Color.w * (1.0f - AlphaCorrection.w)) * _580)) * _564;
  if (_603 < 1.1920928955078125e-07f) {
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
    bool _609 = (cbContrastHighlighterIntensity > 0.0f);
    do {
      if (_609) {
        float _624 = (((saturate(cbContrastHighlighter.x + saturate((_527 * _603) * cbContrastHighlighter.w)) / (cbContrastHighlighter.x + 1.0f)) * 2.0f) + -1.0f) * cbContrastHighlighter.y;
        _633 = saturate(_624);
        _634 = (select((saturate(-0.0f - _624) < cbContrastHighlighter.z), 1.0f, 0.0f) * _603);
      } else {
        _633 = 1.0f;
        _634 = _603;
      }
      do {
        if (!((cbEffect3DFlags2 & 262144) == 0)) {
          float _650 = saturate(((_527 * Color.w) - cbLowGradingBorder) / (cbHighGradingBorder - cbLowGradingBorder));
          float _654 = (_650 * _650) * (3.0f - (_650 * 2.0f));
          float _663 = cbHighBrightnessIntensity * 0.003921568859368563f;
          float _675 = cbLowBrightnessIntensity * 0.003921568859368563f;
          float _676 = _675 * float((uint)((int)(cbLowBrightnessColor & 255)));
          float _677 = _675 * float((uint)((int)(((uint)((int)(cbLowBrightnessColor)) >> 8) & 255)));
          float _678 = _675 * float((uint)((int)(((uint)((int)(cbLowBrightnessColor)) >> 16) & 255)));
          _689 = ((_654 * ((_663 * float((uint)((int)(cbHighBrightnessColor & 255)))) - _676)) + _676);
          _690 = ((_654 * ((_663 * float((uint)((int)(((uint)((int)(cbHighBrightnessColor)) >> 8) & 255)))) - _677)) + _677);
          _691 = ((_654 * ((_663 * float((uint)((int)(((uint)((int)(cbHighBrightnessColor)) >> 16) & 255)))) - _678)) + _678);
        } else {
          _689 = 1.0f;
          _690 = 1.0f;
          _691 = 1.0f;
        }
        switch (((int)(((uint)((int)(cbEffect3DFlags)) >> 11) & 15))) {
          case 0: {
            float _699 = (cbEmissiveRate * (_504 + _500)) * Color.x;
            float _702 = (cbEmissiveRate * (_505 + _501)) * Color.y;
            float _705 = (cbEmissiveRate * (_506 + _502)) * Color.z;
            float _708 = _699 * cbEvOffsetPow2;
            float _709 = _702 * cbEvOffsetPow2;
            float _710 = _705 * cbEvOffsetPow2;
            do {
              if (!((cbEffect3DFlags & 1024) == 0)) {
                int4 _722 = asint(WhitePtSrv[0 / 4]);
                float _727 = (select((useAutoExposure != 0), asfloat(_722.x), 1.0f) * exposureAdjustment) * max((1.0f - tonemapRange), 9.999999747378752e-05f);
                _746 = ((cbDetonemapRate * (max(0.0f, (_699 / _727)) - _708)) + _708);
                _747 = ((cbDetonemapRate * (max(0.0f, (_702 / _727)) - _709)) + _709);
                _748 = ((cbDetonemapRate * (max(0.0f, (_705 / _727)) - _710)) + _710);
              } else {
                _746 = _708;
                _747 = _709;
                _748 = _710;
              }
              float _755 = exp2(log2(max(9.999999974752427e-07f, Color.w)) * cbAlphaRate) * _634;
              do {
                if (_609) {
                  float _768 = exp2(cbContrastHighlighterIntensity * 1.4426950216293335f) * 0.003921568859368563f;
                  float _769 = _768 * float((uint)((int)(cbContrastHighlighterColor & 255)));
                  float _770 = _768 * float((uint)((int)(((uint)((int)(cbContrastHighlighterColor)) >> 8) & 255)));
                  float _771 = _768 * float((uint)((int)(((uint)((int)(cbContrastHighlighterColor)) >> 16) & 255)));
                  _782 = ((_769 + _746) - (_769 * _633));
                  _783 = ((_770 + _747) - (_770 * _633));
                  _784 = ((_771 + _748) - (_771 * _633));
                } else {
                  _782 = _746;
                  _783 = _747;
                  _784 = _748;
                }
                _1226 = (((_755 * _689) * _782) * cbIntensityScale);
                _1227 = (((_755 * _690) * _783) * cbIntensityScale);
                _1228 = (((_755 * _691) * _784) * cbIntensityScale);
                _1229 = _755;
              } while (false);
            } while (false);
            break;
          }
          case 1: {
            float _805 = (((_527 * _527) * 37.5f) * cbEmissiveRate) * cbEvPow2;
            float _806 = _805 + 1.0f;
            float _807 = _805 + cbEvOffsetPow2;
            float _811 = (_564 * Color.x) * _500;
            float _813 = (_564 * Color.y) * _501;
            float _815 = (_564 * Color.z) * _502;
            float _823 = (_811 * _807) + ((_504 * Color.x) * _564);
            float _824 = (_813 * _807) + ((_505 * Color.y) * _564);
            float _825 = (_815 * _807) + ((_506 * Color.z) * _564);
            do {
              if (!((cbEffect3DFlags & 1024) == 0)) {
                int4 _840 = asint(WhitePtSrv[0 / 4]);
                float _845 = (select((useAutoExposure != 0), asfloat(_840.x), 1.0f) * exposureAdjustment) * max((1.0f - tonemapRange), 9.999999747378752e-05f);
                _864 = ((cbDetonemapRate * (max(0.0f, ((_811 * _806) / _845)) - _823)) + _823);
                _865 = ((cbDetonemapRate * (max(0.0f, ((_813 * _806) / _845)) - _824)) + _824);
                _866 = ((cbDetonemapRate * (max(0.0f, ((_815 * _806) / _845)) - _825)) + _825);
              } else {
                _864 = _823;
                _865 = _824;
                _866 = _825;
              }
              float _873 = exp2(log2(max(9.999999974752427e-07f, Color.w)) * cbAlphaRate) * _634;
              do {
                if (_609) {
                  float _886 = exp2(cbContrastHighlighterIntensity * 1.4426950216293335f) * 0.003921568859368563f;
                  float _887 = _886 * float((uint)((int)(cbContrastHighlighterColor & 255)));
                  float _888 = _886 * float((uint)((int)(((uint)((int)(cbContrastHighlighterColor)) >> 8) & 255)));
                  float _889 = _886 * float((uint)((int)(((uint)((int)(cbContrastHighlighterColor)) >> 16) & 255)));
                  _900 = ((_887 + _864) - (_887 * _633));
                  _901 = ((_888 + _865) - (_888 * _633));
                  _902 = ((_889 + _866) - (_889 * _633));
                } else {
                  _900 = _864;
                  _901 = _865;
                  _902 = _866;
                }
                _1226 = (((_873 * _689) * _900) * cbIntensityScale);
                _1227 = (((_873 * _690) * _901) * cbIntensityScale);
                _1228 = (((_873 * _691) * _902) * cbIntensityScale);
                _1229 = (cbUsePhysicalAlphaBlend3D * _873);
              } while (false);
            } while (false);
            break;
          }
          case 2: {
            float _926 = (cbEmissiveRate * (_504 + _500)) * Color.x;
            float _929 = (cbEmissiveRate * (_505 + _501)) * Color.y;
            float _932 = (cbEmissiveRate * (_506 + _502)) * Color.z;
            do {
              if (!((cbEffect3DFlags & 1024) == 0)) {
                int4 _944 = asint(WhitePtSrv[0 / 4]);
                float _949 = (select((useAutoExposure != 0), asfloat(_944.x), 1.0f) * exposureAdjustment) * max((1.0f - tonemapRange), 9.999999747378752e-05f);
                _963 = max(0.0f, (_926 / _949));
                _964 = max(0.0f, (_929 / _949));
                _965 = max(0.0f, (_932 / _949));
              } else {
                _963 = (cbEvOffsetPow2 * _926);
                _964 = (cbEvOffsetPow2 * _929);
                _965 = (cbEvOffsetPow2 * _932);
              }
              float _971 = exp2(log2(max(9.999999974752427e-07f, Color.w)) * cbAlphaRate) * _634;
              do {
                if (_609) {
                  float _984 = exp2(cbContrastHighlighterIntensity * 1.4426950216293335f) * 0.003921568859368563f;
                  float _985 = _984 * float((uint)((int)(cbContrastHighlighterColor & 255)));
                  float _986 = _984 * float((uint)((int)(((uint)((int)(cbContrastHighlighterColor)) >> 8) & 255)));
                  float _987 = _984 * float((uint)((int)(((uint)((int)(cbContrastHighlighterColor)) >> 16) & 255)));
                  _998 = ((_985 + _963) - (_985 * _633));
                  _999 = ((_986 + _964) - (_986 * _633));
                  _1000 = ((_987 + _965) - (_987 * _633));
                } else {
                  _998 = _963;
                  _999 = _964;
                  _1000 = _965;
                }
                _1226 = (((_971 * _689) * _998) * cbIntensityScale);
                _1227 = (((_971 * _690) * _999) * cbIntensityScale);
                _1228 = (((_971 * _691) * _1000) * cbIntensityScale);
                _1229 = (-0.0f - (_634 * cbIntensity3D));
              } while (false);
            } while (false);
            break;
          }
          case 3: {
            float _1018 = exp2(log2(1.0f - _580) * cbEdgeBlendRange3D);
            float _1019 = 1.0f - _1018;
            float _1028 = _1018 * 100.0f;
            float _1041 = ((cbEmissiveRate * (_504 + _1019)) * Color.x) + (((_1028 * cbEdgeOuterColor3D.x) * cbIntensity3D) * cbEdgeOuterColor3D.w);
            float _1045 = ((cbEmissiveRate * (_505 + _1019)) * Color.y) + (((_1028 * cbEdgeOuterColor3D.y) * cbIntensity3D) * cbEdgeOuterColor3D.w);
            float _1049 = ((cbEmissiveRate * (_506 + _1019)) * Color.z) + (((_1028 * cbEdgeOuterColor3D.z) * cbIntensity3D) * cbEdgeOuterColor3D.w);
            do {
              if (!((cbEffect3DFlags & 1024) == 0)) {
                int4 _1061 = asint(WhitePtSrv[0 / 4]);
                float _1066 = (select((useAutoExposure != 0), asfloat(_1061.x), 1.0f) * exposureAdjustment) * max((1.0f - tonemapRange), 9.999999747378752e-05f);
                _1080 = max(0.0f, (_1041 / _1066));
                _1081 = max(0.0f, (_1045 / _1066));
                _1082 = max(0.0f, (_1049 / _1066));
              } else {
                _1080 = (cbEvOffsetPow2 * _1041);
                _1081 = (cbEvOffsetPow2 * _1045);
                _1082 = (cbEvOffsetPow2 * _1049);
              }
              float _1088 = exp2(log2(max(9.999999974752427e-07f, Color.w)) * cbAlphaRate) * _634;
              do {
                if (_609) {
                  float _1101 = exp2(cbContrastHighlighterIntensity * 1.4426950216293335f) * 0.003921568859368563f;
                  float _1102 = _1101 * float((uint)((int)(cbContrastHighlighterColor & 255)));
                  float _1103 = _1101 * float((uint)((int)(((uint)((int)(cbContrastHighlighterColor)) >> 8) & 255)));
                  float _1104 = _1101 * float((uint)((int)(((uint)((int)(cbContrastHighlighterColor)) >> 16) & 255)));
                  _1115 = ((_1102 + _1080) - (_1102 * _633));
                  _1116 = ((_1103 + _1081) - (_1103 * _633));
                  _1117 = ((_1104 + _1082) - (_1104 * _633));
                } else {
                  _1115 = _1080;
                  _1116 = _1081;
                  _1117 = _1082;
                }
                _1226 = (((_1088 * _689) * _1115) * cbIntensityScale);
                _1227 = (((_1088 * _690) * _1116) * cbIntensityScale);
                _1228 = (((_1088 * _691) * _1117) * cbIntensityScale);
                _1229 = _1088;
              } while (false);
            } while (false);
            break;
          }
          case 4: {
            float _1137 = (cbEmissiveRate * (_504 + _500)) * Color.x;
            float _1140 = (cbEmissiveRate * (_505 + _501)) * Color.y;
            float _1143 = (cbEmissiveRate * (_506 + _502)) * Color.z;
            do {
              if (!((cbEffect3DFlags & 1024) == 0)) {
                int4 _1155 = asint(WhitePtSrv[0 / 4]);
                float _1160 = (select((useAutoExposure != 0), asfloat(_1155.x), 1.0f) * exposureAdjustment) * max((1.0f - tonemapRange), 9.999999747378752e-05f);
                _1174 = max(0.0f, (_1137 / _1160));
                _1175 = max(0.0f, (_1140 / _1160));
                _1176 = max(0.0f, (_1143 / _1160));
              } else {
                _1174 = (cbEvOffsetPow2 * _1137);
                _1175 = (cbEvOffsetPow2 * _1140);
                _1176 = (cbEvOffsetPow2 * _1143);
              }
              float _1182 = exp2(log2(max(9.999999974752427e-07f, Color.w)) * cbAlphaRate) * _634;
              do {
                if (_609) {
                  float _1195 = exp2(cbContrastHighlighterIntensity * 1.4426950216293335f) * 0.003921568859368563f;
                  float _1196 = _1195 * float((uint)((int)(cbContrastHighlighterColor & 255)));
                  float _1197 = _1195 * float((uint)((int)(((uint)((int)(cbContrastHighlighterColor)) >> 8) & 255)));
                  float _1198 = _1195 * float((uint)((int)(((uint)((int)(cbContrastHighlighterColor)) >> 16) & 255)));
                  _1209 = ((_1196 + _1174) - (_1196 * _633));
                  _1210 = ((_1197 + _1175) - (_1197 * _633));
                  _1211 = ((_1198 + _1176) - (_1198 * _633));
                } else {
                  _1209 = _1174;
                  _1210 = _1175;
                  _1211 = _1176;
                }
                _1226 = (((_1182 * _689) * _1209) * cbIntensityScale);
                _1227 = (((_1182 * _690) * _1210) * cbIntensityScale);
                _1228 = (((_1182 * _691) * _1211) * cbIntensityScale);
                _1229 = min(((cbIntensity3D * Color.w) * _1182), 1.0f);
              } while (false);
            } while (false);
            break;
          }
          default: {
            _1226 = 0.0f;
            _1227 = 0.0f;
            _1228 = 0.0f;
            _1229 = 0.0f;
            break;
          }
        }
        SV_Target.x = 0.0f;
        SV_Target.y = 0.0f;
        SV_Target.z = 0.0f;
        SV_Target.w = 0.0f;
        SV_Target_1 = 0.0f;
        SV_Target.x = _1226;
        SV_Target.y = _1227;
        SV_Target.z = _1228;
        SV_Target.w = _1229;
        SV_Target_1 = _1229;
      } while (false);
    } while (false);
  }

  OutputSignature output_signature = { SV_Target, SV_Target_1 };
  return output_signature;
}
