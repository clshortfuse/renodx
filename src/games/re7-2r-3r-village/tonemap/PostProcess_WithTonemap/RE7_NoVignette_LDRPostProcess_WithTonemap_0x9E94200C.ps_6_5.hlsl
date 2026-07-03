#define SHADER_HASH 0x9E94200C
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

cbuffer LensDistortionParam : register(b2) {
  float fDistortionCoef : packoffset(c000.x);
  float fRefraction : packoffset(c000.y);
  uint aberrationEnable : packoffset(c000.z);
  uint distortionType : packoffset(c000.w);
  float fCorrectCoef : packoffset(c001.x);
  uint reserve1 : packoffset(c001.y);
  uint reserve2 : packoffset(c001.z);
  uint reserve3 : packoffset(c001.w);
};

cbuffer PaniniProjectionParam : register(b3) {
  float4 fOptimizedParam : packoffset(c000.x);
};

cbuffer RadialBlurRenderParam : register(b4) {
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

cbuffer FilmGrainParam : register(b5) {
  float2 fNoisePower : packoffset(c000.x);
  float2 fNoiseUVOffset : packoffset(c000.z);
  float fNoiseDensity : packoffset(c001.x);
  float fNoiseContrast : packoffset(c001.y);
  float fBlendRate : packoffset(c001.z);
  float fReverseNoiseSize : packoffset(c001.w);
};

cbuffer ColorCorrectTexture : register(b6) {
  float fTextureSize : packoffset(c000.x);
  float fTextureBlendRate : packoffset(c000.y);
  float fTextureBlendRate2 : packoffset(c000.z);
  float fTextureInverseSize : packoffset(c000.w);
  float4 fColorMatrix[4] : packoffset(c001.x);
};

cbuffer ColorDeficientTable : register(b7) {
  float4 cvdR : packoffset(c000.x);
  float4 cvdG : packoffset(c001.x);
  float4 cvdB : packoffset(c002.x);
};

cbuffer ImagePlaneParam : register(b8) {
  float4 ColorParam : packoffset(c000.x);
  float Levels_Rate : packoffset(c001.x);
  float Levels_Range : packoffset(c001.y);
  uint Blend_Type : packoffset(c001.z);
};

cbuffer CBControl : register(b9) {
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
  bool _27 = ((cPassEnabled & 1) != 0);
  bool _31 = _27 && (bool)(distortionType == 0);
  bool _33 = _27 && (bool)(distortionType == 1);
  float _100;
  float _118;
  float _209;
  float _210;
  float _211;
  float _212;
  float _213;
  float _214;
  float _215;
  float _216;
  float _217;
  float _571;
  float _572;
  float _573;
  float _870;
  float _871;
  float _872;
  float _958;
  float _959;
  float _960;
  float _971;
  float _972;
  float _973;
  float _999;
  float _1000;
  float _1001;
  float _1012;
  float _1013;
  float _1014;
  float _1056;
  float _1072;
  float _1088;
  float _1113;
  float _1114;
  float _1115;
  float _1147;
  float _1148;
  float _1149;
  float _1161;
  float _1172;
  float _1183;
  float _1222;
  float _1233;
  float _1244;
  float _1269;
  float _1280;
  float _1291;
  float _1306;
  float _1307;
  float _1308;
  float _1326;
  float _1327;
  float _1328;
  float _1363;
  float _1364;
  float _1365;
  float _1434;
  float _1435;
  float _1436;
  if (_31) {
    float _46 = (screenInverseSize.x * SV_Position.x) + -0.5f;
    float _47 = (screenInverseSize.y * SV_Position.y) + -0.5f;
    float _48 = dot(float2(_46, _47), float2(_46, _47));
    float _51 = ((_48 * fDistortionCoef) + 1.0f) * fCorrectCoef;
    float4 _57 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_51 * _46) + 0.5f), ((_51 * _47) + 0.5f)));
    float _61 = _57.x * Exposure;
    float _62 = _57.y * Exposure;
    float _63 = _57.z * Exposure;
    float _65 = max(max(_61, _62), _63);
    bool _66 = isfinite(_65);
    if (aberrationEnable == 0) {
      if (_66) {
        float _72 = (tonemapRange * _65) + 1.0f;
        _209 = (_61 / _72);
        _210 = (_62 / _72);
        _211 = (_63 / _72);
        _212 = fDistortionCoef;
        _213 = 0.0f;
        _214 = 0.0f;
        _215 = 0.0f;
        _216 = 0.0f;
        _217 = fCorrectCoef;
      } else {
        _209 = 1.0f;
        _210 = 1.0f;
        _211 = 1.0f;
        _212 = fDistortionCoef;
        _213 = 0.0f;
        _214 = 0.0f;
        _215 = 0.0f;
        _216 = 0.0f;
        _217 = fCorrectCoef;
      }
    } else {
      float _77 = _48 + fRefraction;
      float _79 = (_77 * fDistortionCoef) + 1.0f;
      float _80 = _46 * fCorrectCoef;
      float _82 = _47 * fCorrectCoef;
      float _88 = ((_77 + fRefraction) * fDistortionCoef) + 1.0f;
      do {
        if (_66) {
          _100 = (_61 / ((tonemapRange * _65) + 1.0f));
        } else {
          _100 = 1.0f;
        }
        float4 _101 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_80 * _79) + 0.5f), ((_82 * _79) + 0.5f)));
        float _106 = _101.y * Exposure;
        float _109 = max(max((_101.x * Exposure), _106), (_101.z * Exposure));
        do {
          if (isfinite(_109)) {
            _118 = (_106 / ((tonemapRange * _109) + 1.0f));
          } else {
            _118 = 1.0f;
          }
          float4 _119 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(((_80 * _88) + 0.5f), ((_82 * _88) + 0.5f)));
          float _125 = _119.z * Exposure;
          float _127 = max(max((_119.x * Exposure), (_119.y * Exposure)), _125);
          if (isfinite(_127)) {
            _209 = _100;
            _210 = _118;
            _211 = (_125 / ((tonemapRange * _127) + 1.0f));
            _212 = fDistortionCoef;
            _213 = 0.0f;
            _214 = 0.0f;
            _215 = 0.0f;
            _216 = 0.0f;
            _217 = fCorrectCoef;
          } else {
            _209 = _100;
            _210 = _118;
            _211 = 1.0f;
            _212 = fDistortionCoef;
            _213 = 0.0f;
            _214 = 0.0f;
            _215 = 0.0f;
            _216 = 0.0f;
            _217 = fCorrectCoef;
          }
        } while (false);
      } while (false);
    }
  } else {
    if (_33) {
      float _149 = ((SV_Position.x * 2.0f) * screenInverseSize.x) + -1.0f;
      float _153 = sqrt((_149 * _149) + 1.0f);
      float _154 = 1.0f / _153;
      float _157 = (_153 * fOptimizedParam.z) * (_154 + fOptimizedParam.x);
      float _161 = fOptimizedParam.w * 0.5f;
      float4 _169 = RE_POSTPROCESS_Color.Sample(BilinearBorder, float2((((_161 * _149) * _157) + 0.5f), ((((_161 * (((SV_Position.y * 2.0f) * screenInverseSize.y) + -1.0f)) * (((_154 + -1.0f) * fOptimizedParam.y) + 1.0f)) * _157) + 0.5f)));
      float _173 = _169.x * Exposure;
      float _174 = _169.y * Exposure;
      float _175 = _169.z * Exposure;
      float _177 = max(max(_173, _174), _175);
      if (isfinite(_177)) {
        float _183 = (tonemapRange * _177) + 1.0f;
        _209 = (_173 / _183);
        _210 = (_174 / _183);
        _211 = (_175 / _183);
        _212 = 0.0f;
        _213 = fOptimizedParam.x;
        _214 = fOptimizedParam.y;
        _215 = fOptimizedParam.z;
        _216 = fOptimizedParam.w;
        _217 = 1.0f;
      } else {
        _209 = 1.0f;
        _210 = 1.0f;
        _211 = 1.0f;
        _212 = 0.0f;
        _213 = fOptimizedParam.x;
        _214 = fOptimizedParam.y;
        _215 = fOptimizedParam.z;
        _216 = fOptimizedParam.w;
        _217 = 1.0f;
      }
    } else {
      float4 _190 = RE_POSTPROCESS_Color.Load(int3((uint)(uint(SV_Position.x)), (uint)(uint(SV_Position.y)), 0));
      float _194 = _190.x * Exposure;
      float _195 = _190.y * Exposure;
      float _196 = _190.z * Exposure;
      float _198 = max(max(_194, _195), _196);
      if (isfinite(_198)) {
        float _204 = (tonemapRange * _198) + 1.0f;
        _209 = (_194 / _204);
        _210 = (_195 / _204);
        _211 = (_196 / _204);
        _212 = 0.0f;
        _213 = 0.0f;
        _214 = 0.0f;
        _215 = 0.0f;
        _216 = 0.0f;
        _217 = 1.0f;
      } else {
        _209 = 1.0f;
        _210 = 1.0f;
        _211 = 1.0f;
        _212 = 0.0f;
        _213 = 0.0f;
        _214 = 0.0f;
        _215 = 0.0f;
        _216 = 0.0f;
        _217 = 1.0f;
      }
    }
  }
  if (!((cPassEnabled & 32) == 0)) {
    float _239 = float((bool)(bool)((cbRadialBlurFlags & 2) != 0));
    float _242 = ComputeResultSRV[0].computeAlpha;
    float _245 = ((1.0f - _239) + (_242 * _239)) * cbRadialColor.w;
    if (!(_245 == 0.0f)) {
      float _252 = screenInverseSize.x * SV_Position.x;
      float _253 = screenInverseSize.y * SV_Position.y;
      float _255 = (-0.5f - cbRadialScreenPos.x) + _252;
      float _257 = (-0.5f - cbRadialScreenPos.y) + _253;
      float _260 = select((_255 < 0.0f), (1.0f - _252), _252);
      float _263 = select((_257 < 0.0f), (1.0f - _253), _253);
      float _268 = rsqrt(dot(float2(_255, _257), float2(_255, _257))) * cbRadialSharpRange;
      uint _275 = uint(abs(_268 * _257)) + uint(abs(_268 * _255));
      uint _279 = ((_275 ^ 61) ^ ((uint)(_275) >> 16)) * 9;
      uint _282 = (((uint)(_279) >> 4) ^ _279) * 668265261;
      float _287 = select(((cbRadialBlurFlags & 1) != 0), (float((uint)((int)(((uint)(_282) >> 15) ^ _282))) * 2.3283064365386963e-10f), 1.0f);
      float _293 = 1.0f / max(1.0f, sqrt((_255 * _255) + (_257 * _257)));
      float _294 = cbRadialBlurPower * -0.0011111111380159855f;
      float _303 = ((((_294 * _260) * _287) * _293) + 1.0f) * _255;
      float _304 = ((((_294 * _263) * _287) * _293) + 1.0f) * _257;
      float _305 = cbRadialBlurPower * -0.002222222276031971f;
      float _314 = ((((_305 * _260) * _287) * _293) + 1.0f) * _255;
      float _315 = ((((_305 * _263) * _287) * _293) + 1.0f) * _257;
      float _316 = cbRadialBlurPower * -0.0033333334140479565f;
      float _325 = ((((_316 * _260) * _287) * _293) + 1.0f) * _255;
      float _326 = ((((_316 * _263) * _287) * _293) + 1.0f) * _257;
      float _327 = cbRadialBlurPower * -0.004444444552063942f;
      float _336 = ((((_327 * _260) * _287) * _293) + 1.0f) * _255;
      float _337 = ((((_327 * _263) * _287) * _293) + 1.0f) * _257;
      float _338 = cbRadialBlurPower * -0.0055555556900799274f;
      float _347 = ((((_338 * _260) * _287) * _293) + 1.0f) * _255;
      float _348 = ((((_338 * _263) * _287) * _293) + 1.0f) * _257;
      float _349 = cbRadialBlurPower * -0.006666666828095913f;
      float _358 = ((((_349 * _260) * _287) * _293) + 1.0f) * _255;
      float _359 = ((((_349 * _263) * _287) * _293) + 1.0f) * _257;
      float _360 = cbRadialBlurPower * -0.007777777966111898f;
      float _369 = ((((_360 * _260) * _287) * _293) + 1.0f) * _255;
      float _370 = ((((_360 * _263) * _287) * _293) + 1.0f) * _257;
      float _371 = cbRadialBlurPower * -0.008888889104127884f;
      float _380 = ((((_371 * _260) * _287) * _293) + 1.0f) * _255;
      float _381 = ((((_371 * _263) * _287) * _293) + 1.0f) * _257;
      float _382 = cbRadialBlurPower * -0.009999999776482582f;
      float _391 = ((((_382 * _260) * _287) * _293) + 1.0f) * _255;
      float _392 = ((((_382 * _263) * _287) * _293) + 1.0f) * _257;
      float _393 = Exposure * 0.10000000149011612f;
      float _394 = _393 * cbRadialColor.x;
      float _395 = _393 * cbRadialColor.y;
      float _396 = _393 * cbRadialColor.z;
      do {
        if (_31) {
          float _398 = _303 + cbRadialScreenPos.x;
          float _399 = _304 + cbRadialScreenPos.y;
          float _403 = ((dot(float2(_398, _399), float2(_398, _399)) * _212) + 1.0f) * _217;
          float4 _408 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_403 * _398) + 0.5f), ((_403 * _399) + 0.5f)), 0.0f);
          float _412 = _314 + cbRadialScreenPos.x;
          float _413 = _315 + cbRadialScreenPos.y;
          float _416 = (dot(float2(_412, _413), float2(_412, _413)) * _212) + 1.0f;
          float4 _423 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_412 * _217) * _416) + 0.5f), (((_413 * _217) * _416) + 0.5f)), 0.0f);
          float _430 = _325 + cbRadialScreenPos.x;
          float _431 = _326 + cbRadialScreenPos.y;
          float _434 = (dot(float2(_430, _431), float2(_430, _431)) * _212) + 1.0f;
          float4 _441 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_430 * _217) * _434) + 0.5f), (((_431 * _217) * _434) + 0.5f)), 0.0f);
          float _448 = _336 + cbRadialScreenPos.x;
          float _449 = _337 + cbRadialScreenPos.y;
          float _452 = (dot(float2(_448, _449), float2(_448, _449)) * _212) + 1.0f;
          float4 _459 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_448 * _217) * _452) + 0.5f), (((_449 * _217) * _452) + 0.5f)), 0.0f);
          float _466 = _347 + cbRadialScreenPos.x;
          float _467 = _348 + cbRadialScreenPos.y;
          float _470 = (dot(float2(_466, _467), float2(_466, _467)) * _212) + 1.0f;
          float4 _477 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_466 * _217) * _470) + 0.5f), (((_467 * _217) * _470) + 0.5f)), 0.0f);
          float _484 = _358 + cbRadialScreenPos.x;
          float _485 = _359 + cbRadialScreenPos.y;
          float _488 = (dot(float2(_484, _485), float2(_484, _485)) * _212) + 1.0f;
          float4 _495 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_484 * _217) * _488) + 0.5f), (((_485 * _217) * _488) + 0.5f)), 0.0f);
          float _502 = _369 + cbRadialScreenPos.x;
          float _503 = _370 + cbRadialScreenPos.y;
          float _506 = (dot(float2(_502, _503), float2(_502, _503)) * _212) + 1.0f;
          float4 _513 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_502 * _217) * _506) + 0.5f), (((_503 * _217) * _506) + 0.5f)), 0.0f);
          float _520 = _380 + cbRadialScreenPos.x;
          float _521 = _381 + cbRadialScreenPos.y;
          float _524 = (dot(float2(_520, _521), float2(_520, _521)) * _212) + 1.0f;
          float4 _531 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_520 * _217) * _524) + 0.5f), (((_521 * _217) * _524) + 0.5f)), 0.0f);
          float _538 = _391 + cbRadialScreenPos.x;
          float _539 = _392 + cbRadialScreenPos.y;
          float _542 = (dot(float2(_538, _539), float2(_538, _539)) * _212) + 1.0f;
          float4 _549 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((((_538 * _217) * _542) + 0.5f), (((_539 * _217) * _542) + 0.5f)), 0.0f);
          float _556 = _394 * ((((((((_423.x + _408.x) + _441.x) + _459.x) + _477.x) + _495.x) + _513.x) + _531.x) + _549.x);
          float _557 = _395 * ((((((((_423.y + _408.y) + _441.y) + _459.y) + _477.y) + _495.y) + _513.y) + _531.y) + _549.y);
          float _558 = _396 * ((((((((_423.z + _408.z) + _441.z) + _459.z) + _477.z) + _495.z) + _513.z) + _531.z) + _549.z);
          float _560 = max(max(_556, _557), _558);
          do {
            if (isfinite(_560)) {
              float _566 = (tonemapRange * _560) + 1.0f;
              _571 = (_556 / _566);
              _572 = (_557 / _566);
              _573 = (_558 / _566);
            } else {
              _571 = 1.0f;
              _572 = 1.0f;
              _573 = 1.0f;
            }
            _971 = (_571 + ((_209 * 0.10000000149011612f) * cbRadialColor.x));
            _972 = (_572 + ((_210 * 0.10000000149011612f) * cbRadialColor.y));
            _973 = (_573 + ((_211 * 0.10000000149011612f) * cbRadialColor.z));
          } while (false);
        } else {
          float _584 = cbRadialScreenPos.x + 0.5f;
          float _585 = _584 + _303;
          float _586 = cbRadialScreenPos.y + 0.5f;
          float _587 = _586 + _304;
          float _588 = _584 + _314;
          float _589 = _586 + _315;
          float _590 = _584 + _325;
          float _591 = _586 + _326;
          float _592 = _584 + _336;
          float _593 = _586 + _337;
          float _594 = _584 + _347;
          float _595 = _586 + _348;
          float _596 = _584 + _358;
          float _597 = _586 + _359;
          float _598 = _584 + _369;
          float _599 = _586 + _370;
          float _600 = _584 + _380;
          float _601 = _586 + _381;
          float _602 = _584 + _391;
          float _603 = _586 + _392;
          if (_33) {
            float _607 = (_585 * 2.0f) + -1.0f;
            float _611 = sqrt((_607 * _607) + 1.0f);
            float _612 = 1.0f / _611;
            float _615 = (_611 * _215) * (_612 + _213);
            float _619 = _216 * 0.5f;
            float4 _627 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_619 * _615) * _607) + 0.5f), ((((_619 * (((_612 + -1.0f) * _214) + 1.0f)) * _615) * ((_587 * 2.0f) + -1.0f)) + 0.5f)), 0.0f);
            float _633 = (_588 * 2.0f) + -1.0f;
            float _637 = sqrt((_633 * _633) + 1.0f);
            float _638 = 1.0f / _637;
            float _641 = (_637 * _215) * (_638 + _213);
            float4 _652 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_619 * _633) * _641) + 0.5f), ((((_619 * ((_589 * 2.0f) + -1.0f)) * (((_638 + -1.0f) * _214) + 1.0f)) * _641) + 0.5f)), 0.0f);
            float _661 = (_590 * 2.0f) + -1.0f;
            float _665 = sqrt((_661 * _661) + 1.0f);
            float _666 = 1.0f / _665;
            float _669 = (_665 * _215) * (_666 + _213);
            float4 _680 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_619 * _661) * _669) + 0.5f), ((((_619 * ((_591 * 2.0f) + -1.0f)) * (((_666 + -1.0f) * _214) + 1.0f)) * _669) + 0.5f)), 0.0f);
            float _689 = (_592 * 2.0f) + -1.0f;
            float _693 = sqrt((_689 * _689) + 1.0f);
            float _694 = 1.0f / _693;
            float _697 = (_693 * _215) * (_694 + _213);
            float4 _708 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_619 * _689) * _697) + 0.5f), ((((_619 * ((_593 * 2.0f) + -1.0f)) * (((_694 + -1.0f) * _214) + 1.0f)) * _697) + 0.5f)), 0.0f);
            float _717 = (_594 * 2.0f) + -1.0f;
            float _721 = sqrt((_717 * _717) + 1.0f);
            float _722 = 1.0f / _721;
            float _725 = (_721 * _215) * (_722 + _213);
            float4 _736 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_619 * _717) * _725) + 0.5f), ((((_619 * ((_595 * 2.0f) + -1.0f)) * (((_722 + -1.0f) * _214) + 1.0f)) * _725) + 0.5f)), 0.0f);
            float _745 = (_596 * 2.0f) + -1.0f;
            float _749 = sqrt((_745 * _745) + 1.0f);
            float _750 = 1.0f / _749;
            float _753 = (_749 * _215) * (_750 + _213);
            float4 _764 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_619 * _745) * _753) + 0.5f), ((((_619 * ((_597 * 2.0f) + -1.0f)) * (((_750 + -1.0f) * _214) + 1.0f)) * _753) + 0.5f)), 0.0f);
            float _773 = (_598 * 2.0f) + -1.0f;
            float _777 = sqrt((_773 * _773) + 1.0f);
            float _778 = 1.0f / _777;
            float _781 = (_777 * _215) * (_778 + _213);
            float4 _792 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_619 * _773) * _781) + 0.5f), ((((_619 * ((_599 * 2.0f) + -1.0f)) * (((_778 + -1.0f) * _214) + 1.0f)) * _781) + 0.5f)), 0.0f);
            float _801 = (_600 * 2.0f) + -1.0f;
            float _805 = sqrt((_801 * _801) + 1.0f);
            float _806 = 1.0f / _805;
            float _809 = (_805 * _215) * (_806 + _213);
            float4 _820 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_619 * _801) * _809) + 0.5f), ((((_619 * ((_601 * 2.0f) + -1.0f)) * (((_806 + -1.0f) * _214) + 1.0f)) * _809) + 0.5f)), 0.0f);
            float _829 = (_602 * 2.0f) + -1.0f;
            float _833 = sqrt((_829 * _829) + 1.0f);
            float _834 = 1.0f / _833;
            float _837 = (_833 * _215) * (_834 + _213);
            float4 _848 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2((((_619 * _829) * _837) + 0.5f), ((((_619 * ((_603 * 2.0f) + -1.0f)) * (((_834 + -1.0f) * _214) + 1.0f)) * _837) + 0.5f)), 0.0f);
            float _855 = _394 * ((((((((_652.x + _627.x) + _680.x) + _708.x) + _736.x) + _764.x) + _792.x) + _820.x) + _848.x);
            float _856 = _395 * ((((((((_652.y + _627.y) + _680.y) + _708.y) + _736.y) + _764.y) + _792.y) + _820.y) + _848.y);
            float _857 = _396 * ((((((((_652.z + _627.z) + _680.z) + _708.z) + _736.z) + _764.z) + _792.z) + _820.z) + _848.z);
            float _859 = max(max(_855, _856), _857);
            do {
              if (isfinite(_859)) {
                float _865 = (tonemapRange * _859) + 1.0f;
                _870 = (_855 / _865);
                _871 = (_856 / _865);
                _872 = (_857 / _865);
              } else {
                _870 = 1.0f;
                _871 = 1.0f;
                _872 = 1.0f;
              }
              _971 = (_870 + ((_209 * 0.10000000149011612f) * cbRadialColor.x));
              _972 = (_871 + ((_210 * 0.10000000149011612f) * cbRadialColor.y));
              _973 = (_872 + ((_211 * 0.10000000149011612f) * cbRadialColor.z));
            } while (false);
          } else {
            float4 _883 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_585, _587), 0.0f);
            float4 _887 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_588, _589), 0.0f);
            float4 _894 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_590, _591), 0.0f);
            float4 _901 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_592, _593), 0.0f);
            float4 _908 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_594, _595), 0.0f);
            float4 _915 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_596, _597), 0.0f);
            float4 _922 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_598, _599), 0.0f);
            float4 _929 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_600, _601), 0.0f);
            float4 _936 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_602, _603), 0.0f);
            float _943 = _394 * ((((((((_887.x + _883.x) + _894.x) + _901.x) + _908.x) + _915.x) + _922.x) + _929.x) + _936.x);
            float _944 = _395 * ((((((((_887.y + _883.y) + _894.y) + _901.y) + _908.y) + _915.y) + _922.y) + _929.y) + _936.y);
            float _945 = _396 * ((((((((_887.z + _883.z) + _894.z) + _901.z) + _908.z) + _915.z) + _922.z) + _929.z) + _936.z);
            float _947 = max(max(_943, _944), _945);
            do {
              if (isfinite(_947)) {
                float _953 = (tonemapRange * _947) + 1.0f;
                _958 = (_943 / _953);
                _959 = (_944 / _953);
                _960 = (_945 / _953);
              } else {
                _958 = 1.0f;
                _959 = 1.0f;
                _960 = 1.0f;
              }
              _971 = (_958 + ((_209 * 0.10000000149011612f) * cbRadialColor.x));
              _972 = (_959 + ((_210 * 0.10000000149011612f) * cbRadialColor.y));
              _973 = (_960 + ((_211 * 0.10000000149011612f) * cbRadialColor.z));
            } while (false);
          }
        }
        do {
          if (cbRadialMaskRate.x > 0.0f) {
            float _982 = saturate((sqrt((_255 * _255) + (_257 * _257)) * cbRadialMaskSmoothstep.x) + cbRadialMaskSmoothstep.y);
            float _988 = (((_982 * _982) * cbRadialMaskRate.x) * (3.0f - (_982 * 2.0f))) + cbRadialMaskRate.y;
            _999 = ((_988 * (_971 - _209)) + _209);
            _1000 = ((_988 * (_972 - _210)) + _210);
            _1001 = ((_988 * (_973 - _211)) + _211);
          } else {
            _999 = _971;
            _1000 = _972;
            _1001 = _973;
          }
          _1012 = (lerp(_209, _999, _245));
          _1013 = (lerp(_210, _1000, _245));
          _1014 = (lerp(_211, _1001, _245));
        } while (false);
      } while (false);
    } else {
      _1012 = _209;
      _1013 = _210;
      _1014 = _211;
    }
  } else {
    _1012 = _209;
    _1013 = _210;
    _1014 = _211;
  }
  if (!((cPassEnabled & 2) == 0)) {
    float _1036 = floor(((screenSize.x * fNoiseUVOffset.x) + SV_Position.x) * fReverseNoiseSize);
    float _1038 = floor(((screenSize.y * fNoiseUVOffset.y) + SV_Position.y) * fReverseNoiseSize);
    float _1042 = frac(frac(dot(float2(_1036, _1038), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f);
    do {
      if (_1042 < fNoiseDensity) {
        int _1047 = (uint)(uint(_1038 * _1036)) ^ 12345391;
        uint _1048 = _1047 * 3635641;
        _1056 = (float((uint)((int)((((uint)(_1048) >> 26) | ((uint)(_1047 * 232681024))) ^ _1048))) * 2.3283064365386963e-10f);
      } else {
        _1056 = 0.0f;
      }
      float _1058 = frac(_1042 * 757.4846801757812f);
      do {
        if (_1058 < fNoiseDensity) {
          int _1062 = asint(_1058) ^ 12345391;
          uint _1063 = _1062 * 3635641;
          _1072 = ((float((uint)((int)((((uint)(_1063) >> 26) | ((uint)(_1062 * 232681024))) ^ _1063))) * 2.3283064365386963e-10f) + -0.5f);
        } else {
          _1072 = 0.0f;
        }
        float _1074 = frac(_1058 * 757.4846801757812f);
        do {
          if (_1074 < fNoiseDensity) {
            int _1078 = asint(_1074) ^ 12345391;
            uint _1079 = _1078 * 3635641;
            _1088 = ((float((uint)((int)((((uint)(_1079) >> 26) | ((uint)(_1078 * 232681024))) ^ _1079))) * 2.3283064365386963e-10f) + -0.5f);
          } else {
            _1088 = 0.0f;
          }
          float _1089 = _1056 * CUSTOM_NOISE * fNoisePower.x;
          float _1090 = _1088 * CUSTOM_NOISE * fNoisePower.y;
          float _1091 = _1072 * CUSTOM_NOISE * fNoisePower.y;
          float _1102 = exp2(log2(1.0f - saturate(dot(float3(_1012, _1013, _1014), float3(0.29899999499320984f, -0.16899999976158142f, 0.5f)))) * fNoiseContrast) * fBlendRate;
          _1113 = ((_1102 * (mad(_1091, 1.4019999504089355f, _1089) - _1012)) + _1012);
          _1114 = ((_1102 * (mad(_1091, -0.7139999866485596f, mad(_1090, -0.3440000116825104f, _1089)) - _1013)) + _1013);
          _1115 = ((_1102 * (mad(_1090, 1.7719999551773071f, _1089) - _1014)) + _1014);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _1113 = _1012;
    _1114 = _1013;
    _1115 = _1014;
  }
#if 1
  ApplyColorGrading(
      _1113, _1114, _1115,  // input color (pre-grade)
      _1326, _1327, _1328,  // output color (post-grade)
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
    float _1140 = max(max(_1113, _1114), _1115);
    bool _1141 = (_1140 > 1.0f);
    do {
      if (_1141) {
        _1147 = (_1113 / _1140);
        _1148 = (_1114 / _1140);
        _1149 = (_1115 / _1140);
      } else {
        _1147 = _1113;
        _1148 = _1114;
        _1149 = _1115;
      }
      float _1150 = fTextureInverseSize * 0.5f;
      do {
        [branch]
        if (!(!(_1147 <= 0.0031308000907301903f))) {
          _1161 = (_1147 * 12.920000076293945f);
        } else {
          _1161 = (((pow(_1147, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          [branch]
          if (!(!(_1148 <= 0.0031308000907301903f))) {
            _1172 = (_1148 * 12.920000076293945f);
          } else {
            _1172 = (((pow(_1148, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          do {
            [branch]
            if (!(!(_1149 <= 0.0031308000907301903f))) {
              _1183 = (_1149 * 12.920000076293945f);
            } else {
              _1183 = (((pow(_1149, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
            }
            float _1184 = 1.0f - fTextureInverseSize;
            float _1188 = (_1161 * _1184) + _1150;
            float _1189 = (_1172 * _1184) + _1150;
            float _1190 = (_1183 * _1184) + _1150;
            float4 _1191 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_1188, _1189, _1190), 0.0f);
            do {
              [branch]
              if (fTextureBlendRate > 0.0f) {
                float4 _1197 = tTextureMap1.SampleLevel(TrilinearClamp, float3(_1188, _1189, _1190), 0.0f);
                float _1207 = ((_1197.x - _1191.x) * fTextureBlendRate) + _1191.x;
                float _1208 = ((_1197.y - _1191.y) * fTextureBlendRate) + _1191.y;
                float _1209 = ((_1197.z - _1191.z) * fTextureBlendRate) + _1191.z;
                if (fTextureBlendRate2 > 0.0f) {
                  do {
                    [branch]
                    if (!(!(_1207 <= 0.0031308000907301903f))) {
                      _1222 = (_1207 * 12.920000076293945f);
                    } else {
                      _1222 = (((pow(_1207, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                    }
                    do {
                      [branch]
                      if (!(!(_1208 <= 0.0031308000907301903f))) {
                        _1233 = (_1208 * 12.920000076293945f);
                      } else {
                        _1233 = (((pow(_1208, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                      }
                      do {
                        [branch]
                        if (!(!(_1209 <= 0.0031308000907301903f))) {
                          _1244 = (_1209 * 12.920000076293945f);
                        } else {
                          _1244 = (((pow(_1209, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                        }
                        float4 _1245 = tTextureMap2.SampleLevel(TrilinearClamp, float3(_1222, _1233, _1244), 0.0f);
                        _1306 = (lerp(_1207, _1245.x, fTextureBlendRate2));
                        _1307 = (lerp(_1208, _1245.y, fTextureBlendRate2));
                        _1308 = (lerp(_1209, _1245.z, fTextureBlendRate2));
                      } while (false);
                    } while (false);
                  } while (false);
                } else {
                  _1306 = _1207;
                  _1307 = _1208;
                  _1308 = _1209;
                }
              } else {
                do {
                  [branch]
                  if (!(!(_1191.x <= 0.0031308000907301903f))) {
                    _1269 = (_1191.x * 12.920000076293945f);
                  } else {
                    _1269 = (((pow(_1191.x, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                  }
                  do {
                    [branch]
                    if (!(!(_1191.y <= 0.0031308000907301903f))) {
                      _1280 = (_1191.y * 12.920000076293945f);
                    } else {
                      _1280 = (((pow(_1191.y, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                    }
                    do {
                      [branch]
                      if (!(!(_1191.z <= 0.0031308000907301903f))) {
                        _1291 = (_1191.z * 12.920000076293945f);
                      } else {
                        _1291 = (((pow(_1191.z, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                      }
                      float4 _1292 = tTextureMap2.SampleLevel(TrilinearClamp, float3(_1269, _1280, _1291), 0.0f);
                      _1306 = (lerp(_1191.x, _1292.x, fTextureBlendRate2));
                      _1307 = (lerp(_1191.y, _1292.y, fTextureBlendRate2));
                      _1308 = (lerp(_1191.z, _1292.z, fTextureBlendRate2));
                    } while (false);
                  } while (false);
                } while (false);
              }
              float _1312 = mad(_1308, (fColorMatrix[2].x), mad(_1307, (fColorMatrix[1].x), (_1306 * (fColorMatrix[0].x)))) + (fColorMatrix[3].x);
              float _1316 = mad(_1308, (fColorMatrix[2].y), mad(_1307, (fColorMatrix[1].y), (_1306 * (fColorMatrix[0].y)))) + (fColorMatrix[3].y);
              float _1320 = mad(_1308, (fColorMatrix[2].z), mad(_1307, (fColorMatrix[1].z), (_1306 * (fColorMatrix[0].z)))) + (fColorMatrix[3].z);
              if (_1141) {
                _1326 = (_1312 * _1140);
                _1327 = (_1316 * _1140);
                _1328 = (_1320 * _1140);
              } else {
                _1326 = _1312;
                _1327 = _1316;
                _1328 = _1320;
              }
            } while (false);
          } while (false);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _1326 = _1113;
    _1327 = _1114;
    _1328 = _1115;
  }
#endif
  if (!((cPassEnabled & 8) == 0)) {
    _1363 = saturate(((cvdR.x * _1326) + (cvdR.y * _1327)) + (cvdR.z * _1328));
    _1364 = saturate(((cvdG.x * _1326) + (cvdG.y * _1327)) + (cvdG.z * _1328));
    _1365 = saturate(((cvdB.x * _1326) + (cvdB.y * _1327)) + (cvdB.z * _1328));
  } else {
    _1363 = _1326;
    _1364 = _1327;
    _1365 = _1328;
  }
  if (!((cPassEnabled & 16) == 0)) {
    float _1380 = screenInverseSize.x * SV_Position.x;
    float _1381 = screenInverseSize.y * SV_Position.y;
    float4 _1382 = ImagePlameBase.SampleLevel(BilinearClamp, float2(_1380, _1381), 0.0f);
    float _1387 = _1382.x * ColorParam.x;
    float _1388 = _1382.y * ColorParam.y;
    float _1389 = _1382.z * ColorParam.z;
    float _1391 = ImagePlameAlpha.SampleLevel(BilinearClamp, float2(_1380, _1381), 0.0f);
    float _1396 = (_1382.w * ColorParam.w) * saturate((_1391.x * Levels_Rate) + Levels_Range);
    _1434 = (((select((_1387 < 0.5f), ((_1363 * 2.0f) * _1387), (1.0f - (((1.0f - _1363) * 2.0f) * (1.0f - _1387)))) - _1363) * _1396) + _1363);
    _1435 = (((select((_1388 < 0.5f), ((_1364 * 2.0f) * _1388), (1.0f - (((1.0f - _1364) * 2.0f) * (1.0f - _1388)))) - _1364) * _1396) + _1364);
    _1436 = (((select((_1389 < 0.5f), ((_1365 * 2.0f) * _1389), (1.0f - (((1.0f - _1365) * 2.0f) * (1.0f - _1389)))) - _1365) * _1396) + _1365);
  } else {
    _1434 = _1363;
    _1435 = _1364;
    _1436 = _1365;
  }
  SV_Target.x = _1434;
  SV_Target.y = _1435;
  SV_Target.z = _1436;
  SV_Target.w = 0.0f;

#if 1
  float2 grain_uv = SV_Position.xy * screenInverseSize;
  SV_Target.rgb = ApplyUserGradingAndToneMap(SV_Target.rgb, grain_uv);
#endif

  return SV_Target;
}
