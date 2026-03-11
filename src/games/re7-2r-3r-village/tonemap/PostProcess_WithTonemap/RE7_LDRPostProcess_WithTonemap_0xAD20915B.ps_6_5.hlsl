#define SHADER_HASH 0xAD20915B
#include "../tonemap.hlsli"

Texture2D<float4> RE_POSTPROCESS_Color : register(t0);

struct RadialBlurComputeResult {
  float computeAlpha;
};
StructuredBuffer<RadialBlurComputeResult> ComputeResultSRV : register(t1);

Texture3D<float4> tTextureMap0 : register(t2);

Texture3D<float4> tTextureMap1 : register(t3);

Texture3D<float4> tTextureMap2 : register(t4);

Texture2D<float4> ImagePlameBase : register(t5);

Texture2D<float> ImagePlameAlpha : register(t6);

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

// cbuffer Tonemap : register(b1) {
//   float exposureAdjustment : packoffset(c000.x);
//   float tonemapRange : packoffset(c000.y);
//   float sharpness : packoffset(c000.z);
//   float preTonemapRange : packoffset(c000.w);
//   int useAutoExposure : packoffset(c001.x);
//   float echoBlend : packoffset(c001.y);
//   float AABlend : packoffset(c001.z);
//   float AASubPixel : packoffset(c001.w);
//   float ResponsiveAARate : packoffset(c002.x);
// };

cbuffer CameraKerare : register(b2) {
  float kerare_scale : packoffset(c000.x);
  float kerare_offset : packoffset(c000.y);
  float kerare_brightness : packoffset(c000.z);
};

cbuffer LensDistortionParam : register(b3) {
  float fDistortionCoef : packoffset(c000.x);
  float fRefraction : packoffset(c000.y);
  uint aberrationEnable : packoffset(c000.z);
  uint distortionType : packoffset(c000.w);
  float fCorrectCoef : packoffset(c001.x);
  uint reserve1 : packoffset(c001.y);
  uint reserve2 : packoffset(c001.z);
  uint reserve3 : packoffset(c001.w);
};

cbuffer PaniniProjectionParam : register(b4) {
  float4 fOptimizedParam : packoffset(c000.x);
};

cbuffer RadialBlurRenderParam : register(b5) {
  float4 cbRadialColor : packoffset(c000.x);
  float2 cbRadialScreenPos : packoffset(c001.x);
  float2 cbRadialMaskSmoothstep : packoffset(c001.z);
  float2 cbRadialMaskRate : packoffset(c002.x);
  float cbRadialBlurPower : packoffset(c002.z);
  float cbRadialSharpRange : packoffset(c002.w);
  uint cbRadialBlurFlags : packoffset(c003.x);
  float cbRadialReserve0 : packoffset(c003.y);
  float cbRadialReserve1 : packoffset(c003.z);
  float cbRadialReserve2 : packoffset(c003.w);
};

cbuffer FilmGrainParam : register(b6) {
  float2 fNoisePower : packoffset(c000.x);
  float2 fNoiseUVOffset : packoffset(c000.z);
  float fNoiseDensity : packoffset(c001.x);
  float fNoiseContrast : packoffset(c001.y);
  float fBlendRate : packoffset(c001.z);
  float fReverseNoiseSize : packoffset(c001.w);
};

cbuffer ColorCorrectTexture : register(b7) {
  float fTextureSize : packoffset(c000.x);
  float fTextureBlendRate : packoffset(c000.y);
  float fTextureBlendRate2 : packoffset(c000.z);
  float fTextureInverseSize : packoffset(c000.w);
  float4 fColorMatrix[4] : packoffset(c001.x);
};

cbuffer ColorDeficientTable : register(b8) {
  float4 cvdR : packoffset(c000.x);
  float4 cvdG : packoffset(c001.x);
  float4 cvdB : packoffset(c002.x);
};

cbuffer ImagePlaneParam : register(b9) {
  float4 ColorParam : packoffset(c000.x);
  float Levels_Rate : packoffset(c001.x);
  float Levels_Range : packoffset(c001.y);
  uint Blend_Type : packoffset(c001.z);
};

cbuffer CBControl : register(b10) {
  uint cPassEnabled : packoffset(c000.x);
};

SamplerState BilinearClamp : register(s5, space32);

SamplerState BilinearBorder : register(s6, space32);

SamplerState TrilinearClamp : register(s9, space32);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float4 Kerare: Kerare,
    linear float Exposure: Exposure)
    : SV_Target {
  float4 SV_Target;
  bool _32 = ((cPassEnabled & 1) != 0);
  bool _36 = _32 && (bool)(distortionType == 0);
  bool _38 = _32 && (bool)(distortionType == 1);
  float _41 = Kerare.x / Kerare.w;
  float _42 = Kerare.y / Kerare.w;
  float _43 = Kerare.z / Kerare.w;
  float _47 = abs(rsqrt(dot(float3(_41, _42, _43), float3(_41, _42, _43))) * _43);
  float _54 = _47 * _47;
  float _58 = saturate(((_54 * _54) * (1.0f - saturate((kerare_scale * _47) + kerare_offset))) + kerare_brightness);
  float _59 = _58 * Exposure;
  float _126;
  float _144;
  float _235;
  float _236;
  float _237;
  float _238;
  float _239;
  float _240;
  float _241;
  float _242;
  float _243;
  float _598;
  float _599;
  float _600;
  float _897;
  float _898;
  float _899;
  float _985;
  float _986;
  float _987;
  float _998;
  float _999;
  float _1000;
  float _1026;
  float _1027;
  float _1028;
  float _1039;
  float _1040;
  float _1041;
  float _1083;
  float _1099;
  float _1115;
  float _1140;
  float _1141;
  float _1142;
  float _1174;
  float _1175;
  float _1176;
  float _1188;
  float _1199;
  float _1210;
  float _1249;
  float _1260;
  float _1271;
  float _1296;
  float _1307;
  float _1318;
  float _1333;
  float _1334;
  float _1335;
  float _1353;
  float _1354;
  float _1355;
  float _1390;
  float _1391;
  float _1392;
  float _1461;
  float _1462;
  float _1463;
  if (_36) {
    float _72 = (screenInverseSize.x * SV_Position.x) + -0.5f;
    float _73 = (screenInverseSize.y * SV_Position.y) + -0.5f;
    float _74 = dot(float2(_72, _73), float2(_72, _73));
    float _77 = ((_74 * fDistortionCoef) + 1.0f) * fCorrectCoef;
    float4 _83 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_77 * _72) + 0.5f), ((_77 * _73) + 0.5f)));
    float _87 = _83.x * _59;
    float _88 = _83.y * _59;
    float _89 = _83.z * _59;
    float _91 = max(max(_87, _88), _89);
    bool _92 = isfinite(_91);
    if (aberrationEnable == 0) {
      if (_92) {
        float _98 = (tonemapRange * _91) + 1.0f;
        _235 = (_87 / _98);
        _236 = (_88 / _98);
        _237 = (_89 / _98);
        _238 = fDistortionCoef;
        _239 = 0.0f;
        _240 = 0.0f;
        _241 = 0.0f;
        _242 = 0.0f;
        _243 = fCorrectCoef;
      } else {
        _235 = 1.0f;
        _236 = 1.0f;
        _237 = 1.0f;
        _238 = fDistortionCoef;
        _239 = 0.0f;
        _240 = 0.0f;
        _241 = 0.0f;
        _242 = 0.0f;
        _243 = fCorrectCoef;
      }
    } else {
      float _103 = _74 + fRefraction;
      float _105 = (_103 * fDistortionCoef) + 1.0f;
      float _106 = _72 * fCorrectCoef;
      float _108 = _73 * fCorrectCoef;
      float _114 = ((_103 + fRefraction) * fDistortionCoef) + 1.0f;
      do {
        if (_92) {
          _126 = (_87 / ((tonemapRange * _91) + 1.0f));
        } else {
          _126 = 1.0f;
        }
        float4 _127 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_106 * _105) + 0.5f), ((_108 * _105) + 0.5f)));
        float _132 = _127.y * _59;
        float _135 = max(max((_127.x * _59), _132), (_127.z * _59));
        do {
          if (isfinite(_135)) {
            _144 = (_132 / ((tonemapRange * _135) + 1.0f));
          } else {
            _144 = 1.0f;
          }
          float4 _145 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_106 * _114) + 0.5f), ((_108 * _114) + 0.5f)));
          float _151 = _145.z * _59;
          float _153 = max(max((_145.x * _59), (_145.y * _59)), _151);
          if (isfinite(_153)) {
            _235 = _126;
            _236 = _144;
            _237 = (_151 / ((tonemapRange * _153) + 1.0f));
            _238 = fDistortionCoef;
            _239 = 0.0f;
            _240 = 0.0f;
            _241 = 0.0f;
            _242 = 0.0f;
            _243 = fCorrectCoef;
          } else {
            _235 = _126;
            _236 = _144;
            _237 = 1.0f;
            _238 = fDistortionCoef;
            _239 = 0.0f;
            _240 = 0.0f;
            _241 = 0.0f;
            _242 = 0.0f;
            _243 = fCorrectCoef;
          }
        } while (false);
      } while (false);
    }
  } else {
    if (_38) {
      float _175 = ((SV_Position.x * 2.0f) * screenInverseSize.x) + -1.0f;
      float _179 = sqrt((_175 * _175) + 1.0f);
      float _180 = 1.0f / _179;
      float _183 = (_179 * fOptimizedParam.z) * (_180 + fOptimizedParam.x);
      float _187 = fOptimizedParam.w * 0.5f;
      float4 _195 = RE_POSTPROCESS_Color.Sample(BilinearBorder, float2((((_187 * _175) * _183) + 0.5f), ((((_187 * (((SV_Position.y * 2.0f) * screenInverseSize.y) + -1.0f)) * (((_180 + -1.0f) * fOptimizedParam.y) + 1.0f)) * _183) + 0.5f)));
      float _199 = _195.x * _59;
      float _200 = _195.y * _59;
      float _201 = _195.z * _59;
      float _203 = max(max(_199, _200), _201);
      if (isfinite(_203)) {
        float _209 = (tonemapRange * _203) + 1.0f;
        _235 = (_199 / _209);
        _236 = (_200 / _209);
        _237 = (_201 / _209);
        _238 = 0.0f;
        _239 = fOptimizedParam.x;
        _240 = fOptimizedParam.y;
        _241 = fOptimizedParam.z;
        _242 = fOptimizedParam.w;
        _243 = 1.0f;
      } else {
        _235 = 1.0f;
        _236 = 1.0f;
        _237 = 1.0f;
        _238 = 0.0f;
        _239 = fOptimizedParam.x;
        _240 = fOptimizedParam.y;
        _241 = fOptimizedParam.z;
        _242 = fOptimizedParam.w;
        _243 = 1.0f;
      }
    } else {
      float4 _216 = RE_POSTPROCESS_Color.Load(int3((uint)(uint(SV_Position.x)), (uint)(uint(SV_Position.y)), 0));
      float _220 = _216.x * _59;
      float _221 = _216.y * _59;
      float _222 = _216.z * _59;
      float _224 = max(max(_220, _221), _222);
      if (isfinite(_224)) {
        float _230 = (tonemapRange * _224) + 1.0f;
        _235 = (_220 / _230);
        _236 = (_221 / _230);
        _237 = (_222 / _230);
        _238 = 0.0f;
        _239 = 0.0f;
        _240 = 0.0f;
        _241 = 0.0f;
        _242 = 0.0f;
        _243 = 1.0f;
      } else {
        _235 = 1.0f;
        _236 = 1.0f;
        _237 = 1.0f;
        _238 = 0.0f;
        _239 = 0.0f;
        _240 = 0.0f;
        _241 = 0.0f;
        _242 = 0.0f;
        _243 = 1.0f;
      }
    }
  }
  if (!((cPassEnabled & 32) == 0)) {
    float _265 = float((bool)(bool)((cbRadialBlurFlags & 2) != 0));
    float _268 = ComputeResultSRV[0].computeAlpha;
    float _271 = ((1.0f - _265) + (_268 * _265)) * cbRadialColor.w;
    if (!(_271 == 0.0f)) {
      float _279 = screenInverseSize.x * SV_Position.x;
      float _280 = screenInverseSize.y * SV_Position.y;
      float _282 = (-0.5f - cbRadialScreenPos.x) + _279;
      float _284 = (-0.5f - cbRadialScreenPos.y) + _280;
      float _287 = select((_282 < 0.0f), (1.0f - _279), _279);
      float _290 = select((_284 < 0.0f), (1.0f - _280), _280);
      float _295 = rsqrt(dot(float2(_282, _284), float2(_282, _284))) * cbRadialSharpRange;
      uint _302 = uint(abs(_295 * _284)) + uint(abs(_295 * _282));
      uint _306 = ((_302 ^ 61) ^ ((uint)(_302) >> 16)) * 9;
      uint _309 = (((uint)(_306) >> 4) ^ _306) * 668265261;
      float _314 = select(((cbRadialBlurFlags & 1) != 0), (float((uint)((int)(((uint)(_309) >> 15) ^ _309))) * 2.3283064365386963e-10f), 1.0f);
      float _320 = 1.0f / max(1.0f, sqrt((_282 * _282) + (_284 * _284)));
      float _321 = cbRadialBlurPower * -0.0011111111380159855f;
      float _330 = ((((_321 * _287) * _314) * _320) + 1.0f) * _282;
      float _331 = ((((_321 * _290) * _314) * _320) + 1.0f) * _284;
      float _332 = cbRadialBlurPower * -0.002222222276031971f;
      float _341 = ((((_332 * _287) * _314) * _320) + 1.0f) * _282;
      float _342 = ((((_332 * _290) * _314) * _320) + 1.0f) * _284;
      float _343 = cbRadialBlurPower * -0.0033333334140479565f;
      float _352 = ((((_343 * _287) * _314) * _320) + 1.0f) * _282;
      float _353 = ((((_343 * _290) * _314) * _320) + 1.0f) * _284;
      float _354 = cbRadialBlurPower * -0.004444444552063942f;
      float _363 = ((((_354 * _287) * _314) * _320) + 1.0f) * _282;
      float _364 = ((((_354 * _290) * _314) * _320) + 1.0f) * _284;
      float _365 = cbRadialBlurPower * -0.0055555556900799274f;
      float _374 = ((((_365 * _287) * _314) * _320) + 1.0f) * _282;
      float _375 = ((((_365 * _290) * _314) * _320) + 1.0f) * _284;
      float _376 = cbRadialBlurPower * -0.006666666828095913f;
      float _385 = ((((_376 * _287) * _314) * _320) + 1.0f) * _282;
      float _386 = ((((_376 * _290) * _314) * _320) + 1.0f) * _284;
      float _387 = cbRadialBlurPower * -0.007777777966111898f;
      float _396 = ((((_387 * _287) * _314) * _320) + 1.0f) * _282;
      float _397 = ((((_387 * _290) * _314) * _320) + 1.0f) * _284;
      float _398 = cbRadialBlurPower * -0.008888889104127884f;
      float _407 = ((((_398 * _287) * _314) * _320) + 1.0f) * _282;
      float _408 = ((((_398 * _290) * _314) * _320) + 1.0f) * _284;
      float _409 = cbRadialBlurPower * -0.009999999776482582f;
      float _418 = ((((_409 * _287) * _314) * _320) + 1.0f) * _282;
      float _419 = ((((_409 * _290) * _314) * _320) + 1.0f) * _284;
      float _420 = (_58 * Exposure) * 0.10000000149011612f;
      float _421 = _420 * cbRadialColor.x;
      float _422 = _420 * cbRadialColor.y;
      float _423 = _420 * cbRadialColor.z;
      do {
        if (_36) {
          float _425 = _330 + cbRadialScreenPos.x;
          float _426 = _331 + cbRadialScreenPos.y;
          float _430 = ((dot(float2(_425, _426), float2(_425, _426)) * _238) + 1.0f) * _243;
          float4 _435 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_430 * _425) + 0.5f), ((_430 * _426) + 0.5f)), 0.0f);
          float _439 = _341 + cbRadialScreenPos.x;
          float _440 = _342 + cbRadialScreenPos.y;
          float _443 = (dot(float2(_439, _440), float2(_439, _440)) * _238) + 1.0f;
          float4 _450 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_439 * _243) * _443) + 0.5f), (((_440 * _243) * _443) + 0.5f)), 0.0f);
          float _457 = _352 + cbRadialScreenPos.x;
          float _458 = _353 + cbRadialScreenPos.y;
          float _461 = (dot(float2(_457, _458), float2(_457, _458)) * _238) + 1.0f;
          float4 _468 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_457 * _243) * _461) + 0.5f), (((_458 * _243) * _461) + 0.5f)), 0.0f);
          float _475 = _363 + cbRadialScreenPos.x;
          float _476 = _364 + cbRadialScreenPos.y;
          float _479 = (dot(float2(_475, _476), float2(_475, _476)) * _238) + 1.0f;
          float4 _486 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_475 * _243) * _479) + 0.5f), (((_476 * _243) * _479) + 0.5f)), 0.0f);
          float _493 = _374 + cbRadialScreenPos.x;
          float _494 = _375 + cbRadialScreenPos.y;
          float _497 = (dot(float2(_493, _494), float2(_493, _494)) * _238) + 1.0f;
          float4 _504 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_493 * _243) * _497) + 0.5f), (((_494 * _243) * _497) + 0.5f)), 0.0f);
          float _511 = _385 + cbRadialScreenPos.x;
          float _512 = _386 + cbRadialScreenPos.y;
          float _515 = (dot(float2(_511, _512), float2(_511, _512)) * _238) + 1.0f;
          float4 _522 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_511 * _243) * _515) + 0.5f), (((_512 * _243) * _515) + 0.5f)), 0.0f);
          float _529 = _396 + cbRadialScreenPos.x;
          float _530 = _397 + cbRadialScreenPos.y;
          float _533 = (dot(float2(_529, _530), float2(_529, _530)) * _238) + 1.0f;
          float4 _540 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_529 * _243) * _533) + 0.5f), (((_530 * _243) * _533) + 0.5f)), 0.0f);
          float _547 = _407 + cbRadialScreenPos.x;
          float _548 = _408 + cbRadialScreenPos.y;
          float _551 = (dot(float2(_547, _548), float2(_547, _548)) * _238) + 1.0f;
          float4 _558 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_547 * _243) * _551) + 0.5f), (((_548 * _243) * _551) + 0.5f)), 0.0f);
          float _565 = _418 + cbRadialScreenPos.x;
          float _566 = _419 + cbRadialScreenPos.y;
          float _569 = (dot(float2(_565, _566), float2(_565, _566)) * _238) + 1.0f;
          float4 _576 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_565 * _243) * _569) + 0.5f), (((_566 * _243) * _569) + 0.5f)), 0.0f);
          float _583 = _421 * ((((((((_450.x + _435.x) + _468.x) + _486.x) + _504.x) + _522.x) + _540.x) + _558.x) + _576.x);
          float _584 = _422 * ((((((((_450.y + _435.y) + _468.y) + _486.y) + _504.y) + _522.y) + _540.y) + _558.y) + _576.y);
          float _585 = _423 * ((((((((_450.z + _435.z) + _468.z) + _486.z) + _504.z) + _522.z) + _540.z) + _558.z) + _576.z);
          float _587 = max(max(_583, _584), _585);
          do {
            if (isfinite(_587)) {
              float _593 = (tonemapRange * _587) + 1.0f;
              _598 = (_583 / _593);
              _599 = (_584 / _593);
              _600 = (_585 / _593);
            } else {
              _598 = 1.0f;
              _599 = 1.0f;
              _600 = 1.0f;
            }
            _998 = (_598 + ((_235 * 0.10000000149011612f) * cbRadialColor.x));
            _999 = (_599 + ((_236 * 0.10000000149011612f) * cbRadialColor.y));
            _1000 = (_600 + ((_237 * 0.10000000149011612f) * cbRadialColor.z));
          } while (false);
        } else {
          float _611 = cbRadialScreenPos.x + 0.5f;
          float _612 = _611 + _330;
          float _613 = cbRadialScreenPos.y + 0.5f;
          float _614 = _613 + _331;
          float _615 = _611 + _341;
          float _616 = _613 + _342;
          float _617 = _611 + _352;
          float _618 = _613 + _353;
          float _619 = _611 + _363;
          float _620 = _613 + _364;
          float _621 = _611 + _374;
          float _622 = _613 + _375;
          float _623 = _611 + _385;
          float _624 = _613 + _386;
          float _625 = _611 + _396;
          float _626 = _613 + _397;
          float _627 = _611 + _407;
          float _628 = _613 + _408;
          float _629 = _611 + _418;
          float _630 = _613 + _419;
          if (_38) {
            float _634 = (_612 * 2.0f) + -1.0f;
            float _638 = sqrt((_634 * _634) + 1.0f);
            float _639 = 1.0f / _638;
            float _642 = (_638 * _241) * (_639 + _239);
            float _646 = _242 * 0.5f;
            float4 _654 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_646 * _642) * _634) + 0.5f), ((((_646 * (((_639 + -1.0f) * _240) + 1.0f)) * _642) * ((_614 * 2.0f) + -1.0f)) + 0.5f)), 0.0f);
            float _660 = (_615 * 2.0f) + -1.0f;
            float _664 = sqrt((_660 * _660) + 1.0f);
            float _665 = 1.0f / _664;
            float _668 = (_664 * _241) * (_665 + _239);
            float4 _679 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_646 * _660) * _668) + 0.5f), ((((_646 * ((_616 * 2.0f) + -1.0f)) * (((_665 + -1.0f) * _240) + 1.0f)) * _668) + 0.5f)), 0.0f);
            float _688 = (_617 * 2.0f) + -1.0f;
            float _692 = sqrt((_688 * _688) + 1.0f);
            float _693 = 1.0f / _692;
            float _696 = (_692 * _241) * (_693 + _239);
            float4 _707 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_646 * _688) * _696) + 0.5f), ((((_646 * ((_618 * 2.0f) + -1.0f)) * (((_693 + -1.0f) * _240) + 1.0f)) * _696) + 0.5f)), 0.0f);
            float _716 = (_619 * 2.0f) + -1.0f;
            float _720 = sqrt((_716 * _716) + 1.0f);
            float _721 = 1.0f / _720;
            float _724 = (_720 * _241) * (_721 + _239);
            float4 _735 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_646 * _716) * _724) + 0.5f), ((((_646 * ((_620 * 2.0f) + -1.0f)) * (((_721 + -1.0f) * _240) + 1.0f)) * _724) + 0.5f)), 0.0f);
            float _744 = (_621 * 2.0f) + -1.0f;
            float _748 = sqrt((_744 * _744) + 1.0f);
            float _749 = 1.0f / _748;
            float _752 = (_748 * _241) * (_749 + _239);
            float4 _763 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_646 * _744) * _752) + 0.5f), ((((_646 * ((_622 * 2.0f) + -1.0f)) * (((_749 + -1.0f) * _240) + 1.0f)) * _752) + 0.5f)), 0.0f);
            float _772 = (_623 * 2.0f) + -1.0f;
            float _776 = sqrt((_772 * _772) + 1.0f);
            float _777 = 1.0f / _776;
            float _780 = (_776 * _241) * (_777 + _239);
            float4 _791 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_646 * _772) * _780) + 0.5f), ((((_646 * ((_624 * 2.0f) + -1.0f)) * (((_777 + -1.0f) * _240) + 1.0f)) * _780) + 0.5f)), 0.0f);
            float _800 = (_625 * 2.0f) + -1.0f;
            float _804 = sqrt((_800 * _800) + 1.0f);
            float _805 = 1.0f / _804;
            float _808 = (_804 * _241) * (_805 + _239);
            float4 _819 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_646 * _800) * _808) + 0.5f), ((((_646 * ((_626 * 2.0f) + -1.0f)) * (((_805 + -1.0f) * _240) + 1.0f)) * _808) + 0.5f)), 0.0f);
            float _828 = (_627 * 2.0f) + -1.0f;
            float _832 = sqrt((_828 * _828) + 1.0f);
            float _833 = 1.0f / _832;
            float _836 = (_832 * _241) * (_833 + _239);
            float4 _847 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_646 * _828) * _836) + 0.5f), ((((_646 * ((_628 * 2.0f) + -1.0f)) * (((_833 + -1.0f) * _240) + 1.0f)) * _836) + 0.5f)), 0.0f);
            float _856 = (_629 * 2.0f) + -1.0f;
            float _860 = sqrt((_856 * _856) + 1.0f);
            float _861 = 1.0f / _860;
            float _864 = (_860 * _241) * (_861 + _239);
            float4 _875 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_646 * _856) * _864) + 0.5f), ((((_646 * ((_630 * 2.0f) + -1.0f)) * (((_861 + -1.0f) * _240) + 1.0f)) * _864) + 0.5f)), 0.0f);
            float _882 = _421 * ((((((((_679.x + _654.x) + _707.x) + _735.x) + _763.x) + _791.x) + _819.x) + _847.x) + _875.x);
            float _883 = _422 * ((((((((_679.y + _654.y) + _707.y) + _735.y) + _763.y) + _791.y) + _819.y) + _847.y) + _875.y);
            float _884 = _423 * ((((((((_679.z + _654.z) + _707.z) + _735.z) + _763.z) + _791.z) + _819.z) + _847.z) + _875.z);
            float _886 = max(max(_882, _883), _884);
            do {
              if (isfinite(_886)) {
                float _892 = (tonemapRange * _886) + 1.0f;
                _897 = (_882 / _892);
                _898 = (_883 / _892);
                _899 = (_884 / _892);
              } else {
                _897 = 1.0f;
                _898 = 1.0f;
                _899 = 1.0f;
              }
              _998 = (_897 + ((_235 * 0.10000000149011612f) * cbRadialColor.x));
              _999 = (_898 + ((_236 * 0.10000000149011612f) * cbRadialColor.y));
              _1000 = (_899 + ((_237 * 0.10000000149011612f) * cbRadialColor.z));
            } while (false);
          } else {
            float4 _910 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_612, _614), 0.0f);
            float4 _914 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_615, _616), 0.0f);
            float4 _921 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_617, _618), 0.0f);
            float4 _928 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_619, _620), 0.0f);
            float4 _935 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_621, _622), 0.0f);
            float4 _942 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_623, _624), 0.0f);
            float4 _949 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_625, _626), 0.0f);
            float4 _956 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_627, _628), 0.0f);
            float4 _963 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_629, _630), 0.0f);
            float _970 = _421 * ((((((((_914.x + _910.x) + _921.x) + _928.x) + _935.x) + _942.x) + _949.x) + _956.x) + _963.x);
            float _971 = _422 * ((((((((_914.y + _910.y) + _921.y) + _928.y) + _935.y) + _942.y) + _949.y) + _956.y) + _963.y);
            float _972 = _423 * ((((((((_914.z + _910.z) + _921.z) + _928.z) + _935.z) + _942.z) + _949.z) + _956.z) + _963.z);
            float _974 = max(max(_970, _971), _972);
            do {
              if (isfinite(_974)) {
                float _980 = (tonemapRange * _974) + 1.0f;
                _985 = (_970 / _980);
                _986 = (_971 / _980);
                _987 = (_972 / _980);
              } else {
                _985 = 1.0f;
                _986 = 1.0f;
                _987 = 1.0f;
              }
              _998 = (_985 + ((_235 * 0.10000000149011612f) * cbRadialColor.x));
              _999 = (_986 + ((_236 * 0.10000000149011612f) * cbRadialColor.y));
              _1000 = (_987 + ((_237 * 0.10000000149011612f) * cbRadialColor.z));
            } while (false);
          }
        }
        do {
          if (cbRadialMaskRate.x > 0.0f) {
            float _1009 = saturate((sqrt((_282 * _282) + (_284 * _284)) * cbRadialMaskSmoothstep.x) + cbRadialMaskSmoothstep.y);
            float _1015 = (((_1009 * _1009) * cbRadialMaskRate.x) * (3.0f - (_1009 * 2.0f))) + cbRadialMaskRate.y;
            _1026 = ((_1015 * (_998 - _235)) + _235);
            _1027 = ((_1015 * (_999 - _236)) + _236);
            _1028 = ((_1015 * (_1000 - _237)) + _237);
          } else {
            _1026 = _998;
            _1027 = _999;
            _1028 = _1000;
          }
          _1039 = (lerp(_235, _1026, _271));
          _1040 = (lerp(_236, _1027, _271));
          _1041 = (lerp(_237, _1028, _271));
        } while (false);
      } while (false);
    } else {
      _1039 = _235;
      _1040 = _236;
      _1041 = _237;
    }
  } else {
    _1039 = _235;
    _1040 = _236;
    _1041 = _237;
  }
  if (!((cPassEnabled & 2) == 0)) {
    float _1063 = floor(((screenSize.x * fNoiseUVOffset.x) + SV_Position.x) * fReverseNoiseSize);
    float _1065 = floor(((screenSize.y * fNoiseUVOffset.y) + SV_Position.y) * fReverseNoiseSize);
    float _1069 = frac(frac(dot(float2(_1063, _1065), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f);
    do {
      if (_1069 < fNoiseDensity) {
        int _1074 = (uint)(uint(_1065 * _1063)) ^ 12345391;
        uint _1075 = _1074 * 3635641;
        _1083 = (float((uint)((int)((((uint)(_1075) >> 26) | ((uint)(_1074 * 232681024))) ^ _1075))) * 2.3283064365386963e-10f);
      } else {
        _1083 = 0.0f;
      }
      float _1085 = frac(_1069 * 757.4846801757812f);
      do {
        if (_1085 < fNoiseDensity) {
          int _1089 = asint(_1085) ^ 12345391;
          uint _1090 = _1089 * 3635641;
          _1099 = ((float((uint)((int)((((uint)(_1090) >> 26) | ((uint)(_1089 * 232681024))) ^ _1090))) * 2.3283064365386963e-10f) + -0.5f);
        } else {
          _1099 = 0.0f;
        }
        float _1101 = frac(_1085 * 757.4846801757812f);
        do {
          if (_1101 < fNoiseDensity) {
            int _1105 = asint(_1101) ^ 12345391;
            uint _1106 = _1105 * 3635641;
            _1115 = ((float((uint)((int)((((uint)(_1106) >> 26) | ((uint)(_1105 * 232681024))) ^ _1106))) * 2.3283064365386963e-10f) + -0.5f);
          } else {
            _1115 = 0.0f;
          }
          float _1116 = _1083 * fNoisePower.x;
          float _1117 = _1115 * fNoisePower.y;
          float _1118 = _1099 * fNoisePower.y;
          float _1129 = exp2(log2(1.0f - saturate(dot(float3(_1039, _1040, _1041), float3(0.29899999499320984f, -0.16899999976158142f, 0.5f)))) * fNoiseContrast) * fBlendRate;
          _1140 = ((_1129 * (mad(_1118, 1.4019999504089355f, _1116) - _1039)) + _1039);
          _1141 = ((_1129 * (mad(_1118, -0.7139999866485596f, mad(_1117, -0.3440000116825104f, _1116)) - _1040)) + _1040);
          _1142 = ((_1129 * (mad(_1117, 1.7719999551773071f, _1116) - _1041)) + _1041);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _1140 = _1039;
    _1141 = _1040;
    _1142 = _1041;
  }
#if 1
  ApplyColorGrading(
      _1140, _1141, _1142,
      _1353, _1354, _1355,
      cPassEnabled,
      fTextureSize,
      fTextureBlendRate,
      fTextureBlendRate2,
      fTextureInverseSize,
      fColorMatrix,
      tTextureMap0,
      tTextureMap1,
      tTextureMap2,
      TrilinearClamp);
#else
  if (!((cPassEnabled & 4) == 0)) {
    float _1167 = max(max(_1140, _1141), _1142);
    bool _1168 = (_1167 > 1.0f);
    do {
      if (_1168) {
        _1174 = (_1140 / _1167);
        _1175 = (_1141 / _1167);
        _1176 = (_1142 / _1167);
      } else {
        _1174 = _1140;
        _1175 = _1141;
        _1176 = _1142;
      }
      float _1177 = fTextureInverseSize * 0.5f;
      do {
        [branch]
        if (!(!(_1174 <= 0.0031308000907301903f))) {
          _1188 = (_1174 * 12.920000076293945f);
        } else {
          _1188 = (((pow(_1174, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          [branch]
          if (!(!(_1175 <= 0.0031308000907301903f))) {
            _1199 = (_1175 * 12.920000076293945f);
          } else {
            _1199 = (((pow(_1175, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          do {
            [branch]
            if (!(!(_1176 <= 0.0031308000907301903f))) {
              _1210 = (_1176 * 12.920000076293945f);
            } else {
              _1210 = (((pow(_1176, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
            }
            float _1211 = 1.0f - fTextureInverseSize;
            float _1215 = (_1188 * _1211) + _1177;
            float _1216 = (_1199 * _1211) + _1177;
            float _1217 = (_1210 * _1211) + _1177;
            float4 _1218 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_1215, _1216, _1217), 0.0f);
            do {
              [branch]
              if (fTextureBlendRate > 0.0f) {
                float4 _1224 = tTextureMap1.SampleLevel(TrilinearClamp, float3(_1215, _1216, _1217), 0.0f);
                float _1234 = ((_1224.x - _1218.x) * fTextureBlendRate) + _1218.x;
                float _1235 = ((_1224.y - _1218.y) * fTextureBlendRate) + _1218.y;
                float _1236 = ((_1224.z - _1218.z) * fTextureBlendRate) + _1218.z;
                if (fTextureBlendRate2 > 0.0f) {
                  do {
                    [branch]
                    if (!(!(_1234 <= 0.0031308000907301903f))) {
                      _1249 = (_1234 * 12.920000076293945f);
                    } else {
                      _1249 = (((pow(_1234, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                    }
                    do {
                      [branch]
                      if (!(!(_1235 <= 0.0031308000907301903f))) {
                        _1260 = (_1235 * 12.920000076293945f);
                      } else {
                        _1260 = (((pow(_1235, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                      }
                      do {
                        [branch]
                        if (!(!(_1236 <= 0.0031308000907301903f))) {
                          _1271 = (_1236 * 12.920000076293945f);
                        } else {
                          _1271 = (((pow(_1236, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                        }
                        float4 _1272 = tTextureMap2.SampleLevel(TrilinearClamp, float3(_1249, _1260, _1271), 0.0f);
                        _1333 = (lerp(_1234, _1272.x, fTextureBlendRate2));
                        _1334 = (lerp(_1235, _1272.y, fTextureBlendRate2));
                        _1335 = (lerp(_1236, _1272.z, fTextureBlendRate2));
                      } while (false);
                    } while (false);
                  } while (false);
                } else {
                  _1333 = _1234;
                  _1334 = _1235;
                  _1335 = _1236;
                }
              } else {
                do {
                  [branch]
                  if (!(!(_1218.x <= 0.0031308000907301903f))) {
                    _1296 = (_1218.x * 12.920000076293945f);
                  } else {
                    _1296 = (((pow(_1218.x, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                  }
                  do {
                    [branch]
                    if (!(!(_1218.y <= 0.0031308000907301903f))) {
                      _1307 = (_1218.y * 12.920000076293945f);
                    } else {
                      _1307 = (((pow(_1218.y, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                    }
                    do {
                      [branch]
                      if (!(!(_1218.z <= 0.0031308000907301903f))) {
                        _1318 = (_1218.z * 12.920000076293945f);
                      } else {
                        _1318 = (((pow(_1218.z, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                      }
                      float4 _1319 = tTextureMap2.SampleLevel(TrilinearClamp, float3(_1296, _1307, _1318), 0.0f);
                      _1333 = (lerp(_1218.x, _1319.x, fTextureBlendRate2));
                      _1334 = (lerp(_1218.y, _1319.y, fTextureBlendRate2));
                      _1335 = (lerp(_1218.z, _1319.z, fTextureBlendRate2));
                    } while (false);
                  } while (false);
                } while (false);
              }
              float _1339 = mad(_1335, (fColorMatrix[2].x), mad(_1334, (fColorMatrix[1].x), (_1333 * (fColorMatrix[0].x)))) + (fColorMatrix[3].x);
              float _1343 = mad(_1335, (fColorMatrix[2].y), mad(_1334, (fColorMatrix[1].y), (_1333 * (fColorMatrix[0].y)))) + (fColorMatrix[3].y);
              float _1347 = mad(_1335, (fColorMatrix[2].z), mad(_1334, (fColorMatrix[1].z), (_1333 * (fColorMatrix[0].z)))) + (fColorMatrix[3].z);
              if (_1168) {
                _1353 = (_1339 * _1167);
                _1354 = (_1343 * _1167);
                _1355 = (_1347 * _1167);
              } else {
                _1353 = _1339;
                _1354 = _1343;
                _1355 = _1347;
              }
            } while (false);
          } while (false);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _1353 = _1140;
    _1354 = _1141;
    _1355 = _1142;
  }
#endif
  if (!((cPassEnabled & 8) == 0)) {
    _1390 = saturate(((cvdR.x * _1353) + (cvdR.y * _1354)) + (cvdR.z * _1355));
    _1391 = saturate(((cvdG.x * _1353) + (cvdG.y * _1354)) + (cvdG.z * _1355));
    _1392 = saturate(((cvdB.x * _1353) + (cvdB.y * _1354)) + (cvdB.z * _1355));
  } else {
    _1390 = _1353;
    _1391 = _1354;
    _1392 = _1355;
  }
  if (!((cPassEnabled & 16) == 0)) {
    float _1407 = screenInverseSize.x * SV_Position.x;
    float _1408 = screenInverseSize.y * SV_Position.y;
    float4 _1409 = ImagePlameBase.SampleLevel(BilinearClamp, float2(_1407, _1408), 0.0f);
    float _1414 = _1409.x * ColorParam.x;
    float _1415 = _1409.y * ColorParam.y;
    float _1416 = _1409.z * ColorParam.z;
    float _1418 = ImagePlameAlpha.SampleLevel(BilinearClamp, float2(_1407, _1408), 0.0f);
    float _1423 = (_1409.w * ColorParam.w) * saturate((_1418.x * Levels_Rate) + Levels_Range);
    _1461 = (((select((_1414 < 0.5f), ((_1390 * 2.0f) * _1414), (1.0f - (((1.0f - _1390) * 2.0f) * (1.0f - _1414)))) - _1390) * _1423) + _1390);
    _1462 = (((select((_1415 < 0.5f), ((_1391 * 2.0f) * _1415), (1.0f - (((1.0f - _1391) * 2.0f) * (1.0f - _1415)))) - _1391) * _1423) + _1391);
    _1463 = (((select((_1416 < 0.5f), ((_1392 * 2.0f) * _1416), (1.0f - (((1.0f - _1392) * 2.0f) * (1.0f - _1416)))) - _1392) * _1423) + _1392);
  } else {
    _1461 = _1390;
    _1462 = _1391;
    _1463 = _1392;
  }
  SV_Target.x = _1461;
  SV_Target.y = _1462;
  SV_Target.z = _1463;
  SV_Target.w = 0.0f;

#if 1
  SV_Target.rgb = ApplyUserGrading(SV_Target.rgb);
#endif

  return SV_Target;
}
