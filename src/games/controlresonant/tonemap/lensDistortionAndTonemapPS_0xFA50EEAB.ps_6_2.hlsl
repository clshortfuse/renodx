#include "./tonemap.hlsli"

Texture2D<float4> g_tSource : register(t0);

cbuffer shared_sys_constants : register(b0) {
  float2 g_vOutputRes : packoffset(c000.x);
  float2 g_vInvOutputRes : packoffset(c000.z);
  float g_fAlphaFadeMinMultiplier : packoffset(c001.x);
  float g_fAlphaFadeStartDistance : packoffset(c001.y);
  float g_fAlphaFadeEndDistance : packoffset(c001.z);
  float g_fAlphaFadeDynamicObjectMinOpacity : packoffset(c001.w);
  float4 g_vAlphaFadeProjectionConstants : packoffset(c002.x);
  float4 g_vProjectionConstants : packoffset(c003.x);
};

cbuffer shared_hdr_global : register(b1) {
  int g_bHDR : packoffset(c000.x);
  int g_bHDR_scRGB : packoffset(c000.y);
  float g_fSDRBrightnessMultiplier : packoffset(c000.z);
  float g_fMaxOutputNits : packoffset(c000.w);
};

cbuffer shared_tonemap_post : register(b2) {
  float g_fPaperWhite : packoffset(c000.x);
  int g_bApplyVignette : packoffset(c000.y);
  int g_bApplyFilmGrain : packoffset(c000.z);
};

cbuffer postprocess : register(b3) {
  float4 g_vPostClearColor : packoffset(c000.x);
  float4 g_vLensDistortionParams : packoffset(c001.x);
  float2 g_vLensDistortionUVScale : packoffset(c002.x);
  float g_fLensDistortionJincSize : packoffset(c002.z);
  float g_fLensDistortionJincLobes : packoffset(c002.w);
  float2 g_vOverriddenAspectRatioUVScale : packoffset(c003.x);
  int g_bPostProcessApplyTonemap : packoffset(c003.z);
  int g_bPostProcessApplyColorGrade : packoffset(c003.w);
  int g_bPostProcessConvertToBackBufferFormat : packoffset(c004.x);
  int g_bDebugLUT : packoffset(c004.y);
  int g_bDebugValidateOutputRange : packoffset(c004.z);
  int g_bDebugReferenceImage : packoffset(c004.w);
  float4 g_vOverlayRect : packoffset(c005.x);
  float g_fWaveformGain : packoffset(c006.x);
  float g_fCieGain : packoffset(c006.y);
};

SamplerState g_sLinearClamp_internal : register(s6, space1);

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) {
  return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}
uint firstbithigh_msb(uint value) {
  return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}

float4 main(
    precise noperspective float4 SV_Position: SV_Position) : SV_Target {
  float4 SV_Target;
  float4 _14;
  float _21;
  float _22;
  float _23;
  float _57;
  float _58;
  float _59;
  float _75;
  float _76;
  float _77;
  bool _30;
  float _44;
  float _45;
  float _46;
  _14 = g_tSource.Sample(g_sLinearClamp_internal, float2((g_vInvOutputRes.x * SV_Position.x), (g_vInvOutputRes.y * SV_Position.y)));
  const float paper_white = ConditionalOverrideGameBrightness(g_fPaperWhite, g_bHDR);
  _21 = paper_white * _14.x;
  _22 = paper_white * _14.y;
  _23 = paper_white * _14.z;
  if (!(g_bPostProcessConvertToBackBufferFormat == 0)) {
    _30 = (g_bHDR == 0);
    do {
      _57 = _21;
      _58 = _22;
      _59 = _23;
      if (!(_30 || (g_bHDR_scRGB == 0))) {
        _44 = max(mad(0.043306104838848114f, _23, mad(0.329291969537735f, _22, (_21 * 0.6274019479751587f))), 0.0f);
        _45 = max(mad(0.0113602289929986f, _23, mad(0.9195442795753479f, _22, (_21 * 0.06909549236297607f))), 0.0f);
        _46 = max(mad(0.895578145980835f, _23, mad(0.08802816271781921f, _22, (_21 * 0.016393709927797318f))), 0.0f);
        _57 = mad(-0.07283977419137955f, _46, mad(-0.5876564383506775f, _45, (_44 * 1.6604962348937988f)));
        _58 = mad(-0.008348013274371624f, _46, mad(1.1328951120376587f, _45, (_44 * -0.1245470941066742f)));
        _59 = mad(1.118751049041748f, _46, mad(-0.10059737414121628f, _45, (_44 * -0.018153680488467216f)));
      }
      if ((g_bHDR_scRGB == 0) && (!_30)) {
        _75 = mad(0.043306104838848114f, _59, mad(0.329291969537735f, _58, (_57 * 0.6274019479751587f)));
        _76 = mad(0.0113602289929986f, _59, mad(0.9195442795753479f, _58, (_57 * 0.06909549236297607f)));
        _77 = mad(0.895578145980835f, _59, mad(0.08802816271781921f, _58, (_57 * 0.016393709927797318f)));
      } else {
        _75 = _57;
        _76 = _58;
        _77 = _59;
      }
    } while (false);
  } else {
    _75 = _21;
    _76 = _22;
    _77 = _23;
  }
  SV_Target.x = _75;
  SV_Target.y = _76;
  SV_Target.z = _77;
  SV_Target.w = _14.w;
  return SV_Target;
}
