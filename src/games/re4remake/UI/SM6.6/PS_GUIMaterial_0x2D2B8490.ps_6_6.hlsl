// transparent HUD elements during boat ride
Texture2D<float4> SrcImage : register(t0);

Texture2D<float4> _Texture2D_1 : register(t1);

cbuffer SceneInfo : register(b0) {
  row_major float4x4 viewProjMat : packoffset(c000.x);
  row_major float3x4 transposeViewMat : packoffset(c004.x);
  row_major float3x4 transposeViewInvMat : packoffset(c007.x);
  float4 projElement[2] : packoffset(c010.x);
  float4 projInvElements[2] : packoffset(c012.x);
  row_major float4x4 viewProjInvMat : packoffset(c014.x);
  row_major float4x4 prevViewProjMat : packoffset(c018.x);
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
  uint GPUVisibleMask : packoffset(c032.z);
  uint resolutionRatioPacked : packoffset(c032.w);
};

cbuffer CheckerBoardInfo : register(b1) {
  float2 cbr : packoffset(c000.x);
  float cbr_bias : packoffset(c000.z);
  float cbr_using : packoffset(c000.w);
};

cbuffer GUIConstant : register(b2) {
  row_major float4x4 guiViewMatrix : packoffset(c000.x);
  row_major float4x4 guiProjMatrix : packoffset(c004.x);
  row_major float4x4 guiWorldMat : packoffset(c008.x);
  float guiIntensity : packoffset(c012.x);
  float guiSaturation : packoffset(c012.y);
  float guiSoftParticleDist : packoffset(c012.z);
  float guiFilterParam : packoffset(c012.w);
  float4 guiScreenSizeRatio : packoffset(c013.x);
  float2 guiCaptureSizeRatio : packoffset(c014.x);
  float2 guiDistortionOffset : packoffset(c014.z);
  float guiFilterMipLevel : packoffset(c015.x);
  float guiStencilScale : packoffset(c015.y);
  uint guiDepthTestTargetStencil : packoffset(c015.z);
  uint guiShaderCommonFlag : packoffset(c015.w);
  float4 guiAdjustAddColor : packoffset(c016.x);
};

cbuffer UserMaterial : register(b3) {
  float VAR_light : packoffset(c000.x);
  float VAR_strength : packoffset(c000.y);
  float VAR_HDR : packoffset(c000.z);
  float CAPCOM_MATERIAL_RESERVE : packoffset(c000.w);
};

SamplerState PointClamp : register(s1, space32);

SamplerState BilinearWrap : register(s4, space32);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float3 POSITION: POSITION,
    linear float4 COLOR: COLOR,
    linear float2 TEXCOORD: TEXCOORD,
    linear float2 TEXCOORD_1: TEXCOORD1)
    : SV_Target {
  float4 SV_Target;
  float4 _28 = SrcImage.SampleLevel(PointClamp, float2((screenInverseSize.x * SV_Position.x), (screenInverseSize.y * SV_Position.y)), 0.0f);

  _28.rgb = max(0, _28.rgb);  // fix negative values breaking UI

  float4 _45 = _Texture2D_1.SampleGrad(BilinearWrap, float2(TEXCOORD.x, TEXCOORD.y), float2((cbr.x * ddx_coarse(TEXCOORD.x)), (cbr.x * ddx_coarse(TEXCOORD.y))), float2((cbr.y * ddy_coarse(TEXCOORD.x)), (cbr.y * ddy_coarse(TEXCOORD.y))), int2(0, 0));
  float _52 = VAR_HDR * _28.x;
  float _53 = VAR_HDR * _28.y;
  float _54 = VAR_HDR * _28.z;
  float _96 = ((VAR_light * _52) + (exp2(log2(max(_52, 9.999999974752427e-07f)) * _52) * 0.10000000149011612f)) * _45.x;
  float _98 = ((VAR_light * _53) + (exp2(log2(max(_53, 9.999999974752427e-07f)) * _53) * 0.10000000149011612f)) * _45.y;
  float _100 = ((VAR_light * _54) + (exp2(log2(max(_54, 9.999999974752427e-07f)) * _54) * 0.10000000149011612f)) * _45.z;
  float _110 = 1.0f - _45.w;
  float _190;
  if (!(!(_45.w <= 0.0f))) {
    if (true) discard;
  }
  bool _140 = ((_45.w + -9.999999747378752e-05f) < 0.0f);
  if (_140) discard;
  float _141 = (((VAR_strength * _45.x) + (_52 * _110)) + ((((((sqrt(_52) * ((_45.x * 2.0f) - _52)) + (((1.0f - _45.x) * 2.0f) * _52)) - _96) * select((_45.x > -0.5f), 0.0f, 1.0f)) + _96) * _45.w)) * COLOR.x;
  float _142 = (((VAR_strength * _45.y) + (_53 * _110)) + ((((((sqrt(_53) * ((_45.y * 2.0f) - _53)) + (((1.0f - _45.y) * 2.0f) * _53)) - _98) * select((_45.y > -0.5f), 0.0f, 1.0f)) + _98) * _45.w)) * COLOR.y;
  float _143 = (((VAR_strength * _45.z) + (_54 * _110)) + ((((((sqrt(_54) * ((_45.z * 2.0f) - _54)) + (((1.0f - _45.z) * 2.0f) * _54)) - _100) * select((_45.z > -0.5f), 0.0f, 1.0f)) + _100) * _45.w)) * COLOR.z;
  float _144 = _45.w * COLOR.w;
  bool _146 = ((_144 + -9.999999747378752e-05f) < 0.0f);
  if (_146) discard;
  float _147 = dot(float4(_141, _142, _143, _144), float4(0.2989000082015991f, 0.5866000056266785f, 0.1145000010728836f, 0.0f));
  float _156 = (guiSaturation * (_147 - _141)) + _141;
  float _157 = (guiSaturation * (_147 - _142)) + _142;
  float _158 = (guiSaturation * (_147 - _143)) + _143;
  if ((bool)(_144 < 1.0f) && (bool)((guiShaderCommonFlag & 2) != 0)) {
    float _172 = ((((_144 * 0.30530601739883423f) + 0.682171106338501f) * _144) + 0.012522878125309944f) * _144;
    if ((guiShaderCommonFlag & 4) == 0) {
      float _174 = 1.0f - _144;
      float _180 = 1.0f - (((((_174 * 0.30530601739883423f) + 0.682171106338501f) * _174) + 0.012522878125309944f) * _174);
      _190 = ((((_172 - _180) * 0.3333333432674408f) * (((_156 + _157) + _158) / guiIntensity)) + _180);
    } else {
      _190 = _172;
    }
  } else {
    _190 = _144;
  }
  SV_Target.x = ((guiAdjustAddColor.x + _156) * _190);
  SV_Target.y = ((guiAdjustAddColor.y + _157) * _190);
  SV_Target.z = ((guiAdjustAddColor.z + _158) * _190);
  SV_Target.w = _190;
  return SV_Target;
}
