#include "./shared.h"
// Baseline: 5 fewer fmul fast vs original (dxc reassociation of 3 scalar*vector product chains: sin-ripple normalize*sin*0.01 offset, and two lighting-term chains), otherwise identical to the original DXIL (phi order/undef-vs-0 differ).

Texture2D<float4> g_xTextureArray[] : register(t0, space1);

Texture2D<float4> g_xLighting_NormalBuffer : register(t2);

Texture2D<float4> g_xLighting_AlbedoBuffer : register(t3);

Texture2D<float4> g_xLighting_PBRPropertiesBuffer : register(t4);

Texture2D<float4> g_xLighting_DepthStencil : register(t5);

struct ProjectorParams {
  float4 m_xProjectorMatrix[4];
  float4 m_xWorldToBoundingSpace[4];
  float4 m_xProjectionDirection;
  float4 m_xDetailOffsetScale;
  float4 m_xCausticOffsets;
  float3 m_xProjectorPos;
  float m_fPad;
  float4 m_xOrientation1;
  float4 m_xOrientation2;
  float4 m_xOrientation3;
  float4 m_xPosition_UVAspect;
  float4 m_xOffsets;
  float3 m_xLightColour;
  float m_fDistanceFade;
  float m_fLightFalloffScale;
  float m_fLightFalloffPower;
  float m_fAngularFalloffOfs;
  float m_fAngularFalloffScale;
  float m_fMinRange;
  float m_fLightRange;
  float m_fShadowStrength;
  uint m_bCustomBoundingVolumeSet;
  float m_f2DFilterSize;
  float m_fCubeFilterSize;
  float m_fCubeClampWidth;
  int m_iShadowTextureIndex;
  float m_fShadowSoftness;
  float m_fShadowNearPlane;
  float m_fShadowFarPlane;
  float m_fProjectorOneOverTanHalfFov;
  float m_fShadowBias;
  float m_fSpecularStrength;
  float m_fAreaLightRadius;
  uint m_uShadowPoolLevel;
  int m_iTextureIndex;
  int m_iDetailTextureIndex;
  int m_iCausticTextureIndex;
  uint m_bIsProjector;
};

StructuredBuffer<ProjectorParams> g_axProjectors : register(t42);

cbuffer FrameConstants : register(b0) {
  float4 g_xView[4] : packoffset(c000.x);
  float4 g_xProj[4] : packoffset(c004.x);
  float4 g_xViewProj[4] : packoffset(c008.x);
  float4 g_xInvView[4] : packoffset(c012.x);
  float4 g_xInvProj[4] : packoffset(c016.x);
  float4 g_xInvViewProj[4] : packoffset(c020.x);
  float3 g_xCamPos : packoffset(c024.x);
  float g_fScaledTime : packoffset(c024.w);
  float4 g_xTwoOverScreenDimensions : packoffset(c025.x);
  float2 g_xCameraTanHalfFOV : packoffset(c026.x);
  float2 g_xCameraFarClipValues : packoffset(c026.z);
  float2 g_xRcpScreenDims : packoffset(c027.x);
  float2 g_xDepthProjViewUnpack : packoffset(c027.z);
  float4 g_axViewFrustumPlanes[6] : packoffset(c028.x);
  int4 g_xScreenDimensions : packoffset(c034.x);
  float4 g_xTessCutoffAndFactors : packoffset(c035.x);
  float g_fTessMaxDist : packoffset(c036.x);
  float g_fTessRcpRange : packoffset(c036.y);
  float g_fDisplacementScale : packoffset(c036.z);
  float g_fBackFaceCutoff : packoffset(c036.w);
  float g_fFoliageFadeInvDistance : packoffset(c037.x);
  float g_fFoliageFadePower : packoffset(c037.y);
  int g_bFoliageFadeEnabled : packoffset(c037.z);
  float g_fEnvironmentDecalBias : packoffset(c037.w);
  float g_fInstanceDecalBias : packoffset(c038.x);
  float3 g_xWindDirection : packoffset(c038.y);
  float g_fWindStrength : packoffset(c039.x);
  float3 g_xSubsurfaceScatteringWeight : packoffset(c039.y);
  float g_fGlobalSamplerBias : packoffset(c040.x);
  float3 g_xDeformationWindowCentre : packoffset(c040.y);
  float g_fDeformationWindowSize : packoffset(c041.x);
  float g_fDeformationUVDensity : packoffset(c041.y);
  float g_fDeformationNormalIntensity : packoffset(c041.z);
  float g_fRainfallIntensity : packoffset(c041.w);
  float g_fRainBaseWetness : packoffset(c042.x);
  float3 g_xRainDirection : packoffset(c042.y);
};

cbuffer ProjectorIndex : register(b4) {
  uint g_uProjectorIndex : packoffset(c000.x);
};

SamplerState g_xTrilinearWrap : register(s4);

SamplerState g_xTrilinearClamp : register(s5);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float3 CamDir : CamDir
) : SV_Target {
  float4 SV_Target;
  int _15 = int(SV_Position.x);
  int _16 = int(SV_Position.y);
  float4 _17 = g_xLighting_DepthStencil.Load(int3(_15, _16, 0));
  float _22 = g_xDepthProjViewUnpack.y - _17.x;
  float _23 = g_xDepthProjViewUnpack.x / _22;
  float _27 = g_xCameraTanHalfFOV.x * _23;
  float _28 = g_xCameraTanHalfFOV.y * _23;
  float _32 = g_xTwoOverScreenDimensions.z + SV_Position.x;
  float _33 = g_xTwoOverScreenDimensions.w + SV_Position.y;
  float _36 = _32 * g_xTwoOverScreenDimensions.x;
  float _37 = _33 * g_xTwoOverScreenDimensions.y;
  float _38 = _36 + -1.0f;
  float _39 = _37 + -1.0f;
  float _40 = _27 * _38;
  float _41 = _28 * _39;
  ProjectorParams P = g_axProjectors[g_uProjectorIndex];
  float4 _100 = g_xLighting_NormalBuffer.Load(int3(_15, _16, 0));
  float4 _105 = g_xLighting_AlbedoBuffer.Load(int3(_15, _16, 0));
  float4 _110 = g_xLighting_PBRPropertiesBuffer.Load(int3(_15, _16, 0));
  float _115 = _100.x * 2.0f;
  float _116 = _100.y * 2.0f;
  float _117 = _100.z * 2.0f;
  float _118 = _115 + -1.0f;
  float _119 = _116 + -1.0f;
  float _120 = _117 + -1.0f;
  float _121 = dot(float3(_118, _119, _120), float3(_118, _119, _120));
  float _122 = rsqrt(_121);
  float _123 = _122 * _118;
  float _124 = _122 * _119;
  float _125 = _122 * _120;
  float _126 = _110.z * 2.0f;
  float _127 = _110.w * 2.0f;
  float _128 = _126 + -1.0f;
  float _129 = _127 + -1.0f;
  float _130 = dot(float2(_128, _129), float2(_128, _129));
  float _131 = 1.0f - _130;
  float _132 = saturate(_131);
  float _133 = sqrt(_132);
  bool _134 = (_100.w != 0.0f);
  float _135 = -0.0f - _133;
  float _136 = select(_134, _133, _135);
  float _137 = dot(float3(CamDir.x, CamDir.y, CamDir.z), float3(CamDir.x, CamDir.y, CamDir.z));
  float _138 = rsqrt(_137);
  float _139 = _138 * CamDir.x;
  float _140 = _138 * CamDir.y;
  float _141 = _138 * CamDir.z;
  float _142 = P.m_xProjectorMatrix[0].z * _40;
  float _143 = mad(P.m_xProjectorMatrix[1].z, _41, _142);
  float _144 = mad(P.m_xProjectorMatrix[2].z, _23, _143);
  float _145 = _144 + P.m_xProjectorMatrix[3].z;
  float _146 = P.m_xProjectorMatrix[0].w * _40;
  float _147 = mad(P.m_xProjectorMatrix[1].w, _41, _146);
  float _148 = mad(P.m_xProjectorMatrix[2].w, _23, _147);
  float _149 = _148 + P.m_xProjectorMatrix[3].w;
  bool _150 = (_145 < 0.0f);
  bool _181;
  float _182;
  float _183;
  float _256;
  float _257;
  float _258;
  float _270;
  float _312;
  float _313;
  float _322;
  float _323;
  float _324;
  float _337;
  float _338;
  float _339;
  float _389;
  float _390;
  float _391;
  float _392;
  float _452;
  float _453;
  float _454;
  float _455;
  float _456;
  float _457;
  float _458;
  float _592;
  float _617;
  float _618;
  float _619;
  float _704;
  float _705;
  float _706;
  bool _736;
  float _737;
  float _738;
  float _739;
  [branch]
  if (!_150) {
    float _156 = P.m_xProjectorMatrix[0].y * _40;
    float _157 = mad(P.m_xProjectorMatrix[1].y, _41, _156);
    float _158 = mad(P.m_xProjectorMatrix[2].y, _23, _157);
    float _159 = _158 + P.m_xProjectorMatrix[3].y;
    float _164 = P.m_xProjectorMatrix[0].x * _40;
    float _165 = mad(P.m_xProjectorMatrix[1].x, _41, _164);
    float _166 = mad(P.m_xProjectorMatrix[2].x, _23, _165);
    float _167 = _166 + P.m_xProjectorMatrix[3].x;
    float _168 = _167 / _149;
    float _169 = _159 / _149;
    float _170 = _168 + -0.5f;
    float _171 = _169 + -0.5f;
    float _172 = abs(_170);
    float _173 = abs(_171);
    float _174 = 0.5f - _172;
    float _175 = 0.5f - _173;
    bool _176 = (_174 < 0.0f);
    bool _177 = (_175 < 0.0f);
    bool _178 = or(_176, _177);
    [branch]
    if (!_178) {
      _181 = true;
      _182 = _168;
      _183 = _169;
    } else {
      _181 = false;
      _182 = _168;
      _183 = _169;
    }
  } else {
    _181 = false;
    _182 = 0.0f;
    _183 = 0.0f;
  }
  [branch]
  if (_181) {
    float _201 = (g_xInvView[0].x) * _40;
    float _202 = mad((g_xInvView[1].x), _41, _201);
    float _203 = mad((g_xInvView[2].x), _23, _202);
    float _204 = (g_xInvView[0].y) * _40;
    float _205 = mad((g_xInvView[1].y), _41, _204);
    float _206 = mad((g_xInvView[2].y), _23, _205);
    float _207 = (g_xInvView[0].z) * _40;
    float _208 = mad((g_xInvView[1].z), _41, _207);
    float _209 = mad((g_xInvView[2].z), _23, _208);
    float _210 = P.m_xProjectorPos.x - (g_xInvView[3].x);
    float _211 = _210 - _203;
    float _212 = P.m_xProjectorPos.y - (g_xInvView[3].y);
    float _213 = _212 - _206;
    float _214 = P.m_xProjectorPos.z - (g_xInvView[3].z);
    float _215 = _214 - _209;
    bool _216 = (P.m_bCustomBoundingVolumeSet == 0);
    do {
      [branch]
      if (!_216) {
        float _218 = dot(float3(_211, _213, _215), float3(P.m_xProjectionDirection.x, P.m_xProjectionDirection.y, P.m_xProjectionDirection.z));
        float _219 = -0.0f - _218;
        bool _220 = (P.m_fMinRange > _219);
        bool _221 = (P.m_fLightRange < _219);
        bool _222 = _220 || _221;
        [branch]
        if (_222) {
          _736 = false;
          _737 = 0.0f;
          _738 = 0.0f;
          _739 = 0.0f;
          break;
        }
      }
      float _224 = _211 * _211;
      float _225 = _213 * _213;
      float _226 = _225 + _224;
      float _227 = _215 * _215;
      float _228 = _226 + _227;
      float _229 = sqrt(_228);
      float _230 = _211 / _229;
      float _231 = _213 / _229;
      float _232 = _215 / _229;
      float _233 = _229 - P.m_fAreaLightRadius;
      float _234 = P.m_fLightRange - P.m_fAreaLightRadius;
      float _235 = _233 / _234;
      float _236 = saturate(_235);
      float _237 = 1.0f - _236;
      float _238 = _237 * P.m_fLightFalloffScale;
      float _239 = saturate(_238);
      float _240 = log2(_239);
      float _241 = _240 * P.m_fLightFalloffPower;
      float _242 = exp2(_241);
      float _243 = _242 * P.m_fDistanceFade;
      float _244 = _243 + -9.999999747378752e-05f;
      bool _245 = (_244 < 0.0f);
      [branch]
      if (!_245) {
        bool _247 = ((int)P.m_iTextureIndex > (int)0);
        do {
          [branch]
          if (_247) {
            uint _249 = (int)(P.m_iTextureIndex) + 0u;
            float4 _251 = g_xTextureArray[NonUniformResourceIndex(_249)].SampleLevel(g_xTrilinearClamp, float2(_182, _183), 0.0f);
            _256 = _251.x;
            _257 = _251.y;
            _258 = _251.z;
          } else {
            _256 = 1.0f;
            _257 = 1.0f;
            _258 = 1.0f;
          }
          float _259 = _182 * P.m_xCausticOffsets.z;
          float _260 = _183 * P.m_xCausticOffsets.z;
          float _261 = _259 + P.m_xCausticOffsets.x;
          float _262 = _260 + P.m_xCausticOffsets.y;
          bool _263 = ((int)P.m_iCausticTextureIndex > (int)0);
          do {
            [branch]
            if (_263) {
              uint _265 = (int)(P.m_iCausticTextureIndex) + 0u;
              float4 _267 = g_xTextureArray[NonUniformResourceIndex(_265)].SampleLevel(g_xTrilinearWrap, float2(_261, _262), 0.0f);
              _270 = _267.x;
            } else {
              _270 = 1.0f;
            }
            bool _271 = ((int)P.m_iDetailTextureIndex > (int)0);
            do {
              [branch]
              if (_271) {
                float _273 = _182 * P.m_xDetailOffsetScale.z;
                float _274 = _183 * P.m_xDetailOffsetScale.w;
                float _275 = _273 + P.m_xDetailOffsetScale.x;
                float _276 = _274 + P.m_xDetailOffsetScale.y;
                do {
                  [branch]
                  if (_263) {
                    uint _278 = (int)(P.m_iCausticTextureIndex) + 0u;
                    float4 _280 = g_xTextureArray[NonUniformResourceIndex(_278)].SampleLevel(g_xTrilinearWrap, float2(_261, _262), 0.0f);
                    float _282 = _261 + 0.10000000149011612f;
                    float4 _283 = g_xTextureArray[NonUniformResourceIndex(_278)].SampleLevel(g_xTrilinearWrap, float2(_282, _262), 0.0f);
                    float _285 = _262 + 0.10000000149011612f;
                    float4 _286 = g_xTextureArray[NonUniformResourceIndex(_278)].SampleLevel(g_xTrilinearWrap, float2(_261, _285), 0.0f);
                    float _288 = _261 + -0.10000000149011612f;
                    float4 _289 = g_xTextureArray[NonUniformResourceIndex(_278)].SampleLevel(g_xTrilinearWrap, float2(_288, _262), 0.0f);
                    float _291 = _262 + -0.10000000149011612f;
                    float4 _292 = g_xTextureArray[NonUniformResourceIndex(_278)].SampleLevel(g_xTrilinearWrap, float2(_261, _291), 0.0f);
                    float _294 = _283.x + _280.x;
                    float _295 = _294 + _289.x;
                    float _296 = _286.x + _280.x;
                    float _297 = _296 + _292.x;
                    float _298 = _297 + _295;
                    float _299 = abs(_298);
                    float _300 = dot(float2(_295, _297), float2(_295, _297));
                    float _301 = rsqrt(_300);
                    float _302 = _301 * _295;
                    float _303 = _301 * _297;
                    float _304 = _299 + P.m_xCausticOffsets.w;
                    float _305 = sin(_304);
                    float _306 = _305 * 0.009999999776482582f;
                    float _307 = _302 * _306;
                    float _308 = _303 * _306;
                    float _309 = _307 + _275;
                    float _310 = _308 + _276;
                    _312 = _309;
                    _313 = _310;
                  } else {
                    _312 = _275;
                    _313 = _276;
                  }
                  uint _314 = (int)(P.m_iDetailTextureIndex) + 0u;
                  float4 _316 = g_xTextureArray[NonUniformResourceIndex(_314)].SampleLevel(g_xTrilinearWrap, float2(_312, _313), 0.0f);
                  float _318 = _316.x * _256;
                  float _319 = _316.x * _257;
                  float _320 = _316.x * _258;
                  _322 = _318;
                  _323 = _319;
                  _324 = _320;
                } while (false);
              } else {
                _322 = _256;
                _323 = _257;
                _324 = _258;
              }
              do {
                [branch]
                if (_263) {
                  float _326 = min(_270, 1.0f);
                  float _327 = _326 * _322;
                  float _328 = _326 * _323;
                  float _329 = _326 * _324;
                  float _330 = max(_327, 0.0f);
                  float _331 = max(_328, 0.0f);
                  float _332 = max(_329, 0.0f);
                  float _333 = min(_330, 0.15000000596046448f);
                  float _334 = min(_331, 0.15000000596046448f);
                  float _335 = min(_332, 0.15000000596046448f);
                  _337 = _333;
                  _338 = _334;
                  _339 = _335;
                } else {
                  _337 = _322;
                  _338 = _323;
                  _339 = _324;
                }
                float _340 = _243 * P.m_xLightColour.x;
                float _341 = _243 * P.m_xLightColour.y;
                float _342 = _243 * P.m_xLightColour.z;
                float _343 = _340 * _337;
                float _344 = _341 * _338;
                float _345 = _342 * _339;
                bool _346 = (P.m_fAreaLightRadius > 0.0f);
                do {
                  [branch]
                  if (_346) {
                    float _348 = dot(float3(_139, _140, _141), float3(_123, _124, _125));
                    float _349 = _348 * 2.0f;
                    float _350 = _349 * _123;
                    float _351 = _349 * _124;
                    float _352 = _349 * _125;
                    float _353 = _139 - _350;
                    float _354 = _140 - _351;
                    float _355 = _141 - _352;
                    float _356 = -0.0f - _353;
                    float _357 = -0.0f - _354;
                    float _358 = -0.0f - _355;
                    float _359 = dot(float3(_211, _213, _215), float3(_356, _357, _358));
                    float _360 = _359 * _356;
                    float _361 = _359 * _357;
                    float _362 = _359 * _358;
                    float _363 = _360 - _211;
                    float _364 = _361 - _213;
                    float _365 = _362 - _215;
                    float _366 = _363 * _363;
                    float _367 = _364 * _364;
                    float _368 = _366 + _367;
                    float _369 = _365 * _365;
                    float _370 = _368 + _369;
                    float _371 = sqrt(_370);
                    float _372 = P.m_fAreaLightRadius / _371;
                    float _373 = saturate(_372);
                    float _374 = _363 * _373;
                    float _375 = _364 * _373;
                    float _376 = _365 * _373;
                    float _377 = _374 + _211;
                    float _378 = _375 + _213;
                    float _379 = _376 + _215;
                    float _380 = dot(float3(_377, _378, _379), float3(_377, _378, _379));
                    float _381 = rsqrt(_380);
                    float _382 = _377 * _381;
                    float _383 = _378 * _381;
                    float _384 = _379 * _381;
                    float _385 = dot(float3(_211, _213, _215), float3(_211, _213, _215));
                    float _386 = rsqrt(_385);
                    float _387 = _386 * P.m_fAreaLightRadius;
                    _389 = _382;
                    _390 = _383;
                    _391 = _384;
                    _392 = _387;
                  } else {
                    _389 = _230;
                    _390 = _231;
                    _391 = _232;
                    _392 = 0.0f;
                  }
                  // RenoDX: tolerant material-ID compares (MaterialIdEquals, shared.h)
                  bool _393 = (!MaterialIdEquals(_105.w, 0.019607843831181526f));
                  float _394 = select(_393, _110.x, 0.0f);
                  float _395 = _389 + _139;
                  float _396 = _390 + _140;
                  float _397 = _391 + _141;
                  float _398 = dot(float3(_395, _396, _397), float3(_395, _396, _397));
                  float _399 = rsqrt(_398);
                  float _400 = _399 * _395;
                  float _401 = _399 * _396;
                  float _402 = _399 * _397;
                  float _403 = dot(float3(_123, _124, _125), float3(_230, _231, _232));
                  float _404 = saturate(_403);
                  float _405 = dot(float3(_123, _124, _125), float3(_139, _140, _141));
                  float _406 = saturate(_405);
                  float _407 = dot(float3(_123, _124, _125), float3(_400, _401, _402));
                  float _408 = saturate(_407);
                  float _409 = dot(float3(_139, _140, _141), float3(_400, _401, _402));
                  float _410 = saturate(_409);
                  bool _411 = (MaterialIdEquals(_105.w, 0.01568627543747425f));
                  do {
                    [branch]
                    if (!_411) {
                      bool _413 = (MaterialIdEquals(_105.w, 0.007843137718737125f));
                      [branch]
                      if (!_413) {
                        bool _415 = (MaterialIdEquals(_105.w, 0.003921568859368563f));
                        [branch]
                        if (_415) {
                          float _417 = -0.0f - _123;
                          float _418 = -0.0f - _124;
                          float _419 = -0.0f - _125;
                          float _420 = dot(float3(_230, _231, _232), float3(_417, _418, _419));
                          float _421 = saturate(_420);
                          float _422 = _421 * 0.4000000059604645f;
                          float _423 = -0.0f - _139;
                          float _424 = -0.0f - _140;
                          float _425 = -0.0f - _141;
                          float _426 = dot(float3(_230, _231, _232), float3(_423, _424, _425));
                          float _427 = saturate(_426);
                          float _428 = log2(_427);
                          float _429 = _428 * 7.0f;
                          float _430 = exp2(_429);
                          float _431 = _430 + _422;
                          float _432 = saturate(_431);
                          float _433 = _432 * _394;
                          float _434 = _433 + _404;
                          _452 = _105.x;
                          _453 = _105.y;
                          _454 = _105.z;
                          _455 = 0.02800000086426735f;
                          _456 = 0.02800000086426735f;
                          _457 = 0.02800000086426735f;
                          _458 = _434;
                        } else {
                          float _436 = _105.x + -0.03999999910593033f;
                          float _437 = _105.y + -0.03999999910593033f;
                          float _438 = _105.z + -0.03999999910593033f;
                          float _439 = _394 * _436;
                          float _440 = _394 * _437;
                          float _441 = _394 * _438;
                          float _442 = _439 + 0.03999999910593033f;
                          float _443 = _440 + 0.03999999910593033f;
                          float _444 = _441 + 0.03999999910593033f;
                          float _445 = _394 * _105.x;
                          float _446 = _394 * _105.y;
                          float _447 = _394 * _105.z;
                          float _448 = _105.x - _445;
                          float _449 = _105.y - _446;
                          float _450 = _105.z - _447;
                          _452 = _448;
                          _453 = _449;
                          _454 = _450;
                          _455 = _442;
                          _456 = _443;
                          _457 = _444;
                          _458 = _404;
                        }
                      } else {
                        _452 = _105.x;
                        _453 = _105.y;
                        _454 = _105.z;
                        _455 = 0.02800000086426735f;
                        _456 = 0.02800000086426735f;
                        _457 = 0.02800000086426735f;
                        _458 = _404;
                      }
                    } else {
                      _452 = _105.x;
                      _453 = _105.y;
                      _454 = _105.z;
                      _455 = 0.04699999839067459f;
                      _456 = 0.04699999839067459f;
                      _457 = 0.04699999839067459f;
                      _458 = _404;
                    }
                    float _459 = _458 * _452;
                    float _460 = _458 * _453;
                    float _461 = _458 * _454;
                    float _462 = max(_110.y, 0.05000000074505806f);
                    float _463 = _462 * _462;
                    do {
                      [branch]
                      if (_411) {
                        float _465 = 1.0f - _110.y;
                        float _466 = saturate(_465);
                        float _467 = dot(float3(_105.x, _105.y, _105.z), float3(0.30000001192092896f, 0.5899999737739563f, 0.10999999940395355f));
                        float _468 = _110.x * 0.6000000238418579f;
                        float _469 = _468 + -0.3500000238418579f;
                        float _470 = _468 + -0.25f;
                        float _471 = _466 * 0.05000000074505806f;
                        float _472 = _470 - _471;
                        float _473 = log2(_466);
                        float _474 = _473 * 8.0f;
                        float _475 = exp2(_474);
                        float _476 = _475 * 500.0f;
                        float _477 = _476 + 20.0f;
                        float _478 = _473 * 6.0f;
                        float _479 = exp2(_478);
                        float _480 = _479 * 2000.0f;
                        float _481 = _480 + 50.0f;
                        float _482 = _110.x * 0.13500000536441803f;
                        float _483 = _482 + 0.015000000596046448f;
                        float _484 = _466 + 0.10000000149011612f;
                        float _485 = _110.x * 0.007499999832361937f;
                        float _486 = _485 + 0.007499999832361937f;
                        float _487 = _469 * _123;
                        float _488 = _469 * _124;
                        float _489 = _469 * _125;
                        float _490 = _487 + _128;
                        float _491 = _488 + _129;
                        float _492 = _136 + _489;
                        float _493 = dot(float3(_490, _491, _492), float3(_490, _491, _492));
                        float _494 = rsqrt(_493);
                        float _495 = _494 * _490;
                        float _496 = _494 * _491;
                        float _497 = _494 * _492;
                        float _498 = dot(float3(_495, _496, _497), float3(_400, _401, _402));
                        float _499 = _498 * _498;
                        float _500 = 1.0f - _499;
                        float _501 = saturate(_500);
                        float _502 = sqrt(_501);
                        float _503 = _498 + 1.0f;
                        float _504 = saturate(_503);
                        float _505 = _504 * 2.0f;
                        float _506 = 3.0f - _505;
                        float _507 = log2(_502);
                        float _508 = _507 * _477;
                        float _509 = exp2(_508);
                        float _510 = _475 * 19.89436912536621f;
                        float _511 = _510 + 1.1140847206115723f;
                        float _512 = _484 * _483;
                        float _513 = _512 * _511;
                        float _514 = _504 * _504;
                        float _515 = _514 * _513;
                        float _516 = _515 * _506;
                        float _517 = _516 * _509;
                        float _518 = max(_467, 0.0010000000474974513f);
                        float _519 = _105.x / _518;
                        float _520 = _105.y / _518;
                        float _521 = _105.z / _518;
                        float _522 = _517 * _519;
                        float _523 = _517 * _520;
                        float _524 = _517 * _521;
                        float _525 = _472 * _123;
                        float _526 = _472 * _124;
                        float _527 = _472 * _125;
                        float _528 = _525 + _128;
                        float _529 = _526 + _129;
                        float _530 = _527 + _136;
                        float _531 = dot(float3(_528, _529, _530), float3(_528, _529, _530));
                        float _532 = rsqrt(_531);
                        float _533 = _532 * _528;
                        float _534 = _532 * _529;
                        float _535 = _532 * _530;
                        float _536 = dot(float3(_533, _534, _535), float3(_400, _401, _402));
                        float _537 = _536 * _536;
                        float _538 = 1.0f - _537;
                        float _539 = saturate(_538);
                        float _540 = sqrt(_539);
                        float _541 = _536 + 1.0f;
                        float _542 = saturate(_541);
                        float _543 = _542 * 2.0f;
                        float _544 = 3.0f - _543;
                        float _545 = log2(_540);
                        float _546 = _545 * _481;
                        float _547 = exp2(_546);
                        float _548 = _479 * 79.57747650146484f;
                        float _549 = _548 + 2.3077468872070312f;
                        float _550 = _466 * _486;
                        float _551 = _550 * _549;
                        float _552 = _542 * _542;
                        float _553 = _552 * _551;
                        float _554 = _553 * _544;
                        float _555 = _554 * _547;
                        float _556 = _555 + _522;
                        float _557 = _555 + _523;
                        float _558 = _555 + _524;
                        float _559 = _404 * P.m_fSpecularStrength;
                        float _560 = _559 * _556;
                        float _561 = _559 * _557;
                        float _562 = _559 * _558;
                        _617 = _560;
                        _618 = _561;
                        _619 = _562;
                      } else {
                        float _564 = 1.0f - _463;
                        float _565 = _564 * _392;
                        float _566 = saturate(_565);
                        float _567 = 1.0f - _455;
                        float _568 = 1.0f - _456;
                        float _569 = 1.0f - _457;
                        float _570 = _410 * 5.55472993850708f;
                        float _571 = -6.983160018920898f - _570;
                        float _572 = _571 * _410;
                        float _573 = exp2(_572);
                        float _574 = _573 * _567;
                        float _575 = _573 * _568;
                        float _576 = _573 * _569;
                        float _577 = _574 + _455;
                        float _578 = _575 + _456;
                        float _579 = _576 + _457;
                        bool _580 = (_566 > 0.0f);
                        float _581 = _463 * _463;
                        do {
                          [branch]
                          if (_580) {
                            float _583 = _566 * 0.25f;
                            float _584 = _463 * 3.0f;
                            float _585 = _566 + _584;
                            float _586 = _583 * _585;
                            float _587 = _410 + 0.0010000000474974513f;
                            float _588 = _586 / _587;
                            float _589 = _588 + _581;
                            float _590 = _581 / _589;
                            _592 = _590;
                          } else {
                            _592 = 1.0f;
                          }
                          float _593 = 2.0f - _463;
                          float _594 = _593 * _406;
                          float _595 = _594 + _463;
                          float _596 = _593 * _404;
                          float _597 = _596 + _463;
                          float _598 = _595 * _597;
                          float _599 = 1.0f / _598;
                          float _600 = _581 * _408;
                          float _601 = _600 - _408;
                          float _602 = _601 * _408;
                          float _603 = _602 + 1.0f;
                          float _604 = _603 * _603;
                          float _605 = 1.0f / _604;
                          float _606 = _404 * P.m_fSpecularStrength;
                          float _607 = _606 * _581;
                          float _608 = _607 * _599;
                          float _609 = _608 * _605;
                          float _610 = _592 * _577;
                          float _611 = _610 * _609;
                          float _612 = _592 * _578;
                          float _613 = _612 * _609;
                          float _614 = _592 * _579;
                          float _615 = _614 * _609;
                          _617 = _611;
                          _618 = _613;
                          _619 = _615;
                        } while (false);
                      }
                      float _620 = _617 + _459;
                      float _621 = _618 + _460;
                      float _622 = _619 + _461;
                      bool _623 = (MaterialIdEquals(_105.w, 0.019607843831181526f));
                      do {
                        [branch]
                        if (_623) {
                          bool _625 = (_110.x > 0.49803921580314636f);
                          float _626 = _110.x + -0.501960813999176f;
                          float _627 = select(_625, _626, _110.x);
                          float _628 = _627 * 2.007874011993408f;
                          float _629 = select(_625, 0.5f, 0.0f);
                          float _630 = -0.0f - _123;
                          float _631 = -0.0f - _124;
                          float _632 = -0.0f - _125;
                          float _633 = dot(float3(_230, _231, _232), float3(_630, _631, _632));
                          float _634 = saturate(_633);
                          float _635 = _634 * 0.4000000059604645f;
                          float _636 = -0.0f - _139;
                          float _637 = -0.0f - _140;
                          float _638 = -0.0f - _141;
                          float _639 = dot(float3(_230, _231, _232), float3(_636, _637, _638));
                          float _640 = saturate(_639);
                          float _641 = log2(_640);
                          float _642 = _641 * 7.0f;
                          float _643 = exp2(_642);
                          float _644 = _643 + _635;
                          float _645 = saturate(_644);
                          float _646 = _645 * _629;
                          float _647 = _646 * _452;
                          float _648 = _646 * _453;
                          float _649 = _646 * _454;
                          float _650 = abs(_452);
                          float _651 = abs(_453);
                          float _652 = abs(_454);
                          float _653 = sqrt(_650);
                          float _654 = sqrt(_651);
                          float _655 = sqrt(_652);
                          float _656 = 1.0f - _653;
                          float _657 = 1.0f - _654;
                          float _658 = 1.0f - _655;
                          float _659 = _410 * 5.55472993850708f;
                          float _660 = -6.983160018920898f - _659;
                          float _661 = _660 * _410;
                          float _662 = exp2(_661);
                          float _663 = _662 * _656;
                          float _664 = _662 * _657;
                          float _665 = _658 * _662;
                          float _666 = _663 + _653;
                          float _667 = _664 + _654;
                          float _668 = _665 + _655;
                          float _669 = _406 + _404;
                          float _670 = _406 * _404;
                          float _671 = _669 - _670;
                          float _672 = _671 * 4.0f;
                          float _673 = _672 + 9.999999682655225e-21f;
                          float _674 = 1.0f / _673;
                          float _675 = 0.5f / _463;
                          float _676 = _408 * _408;
                          float _677 = 1.0f - _676;
                          float _678 = _675 + 1.0f;
                          float _679 = log2(_677);
                          float _680 = _679 * _675;
                          float _681 = exp2(_680);
                          float _682 = _678 * _674;
                          float _683 = _682 * _681;
                          float _684 = _404 * P.m_fSpecularStrength;
                          float _685 = _666 * _684;
                          float _686 = _685 * _683;
                          float _687 = _667 * _684;
                          float _688 = _687 * _683;
                          float _689 = _668 * _684;
                          float _690 = _689 * _683;
                          float _691 = _647 - _617;
                          float _692 = _691 + _686;
                          float _693 = _648 - _618;
                          float _694 = _693 + _688;
                          float _695 = _649 - _619;
                          float _696 = _695 + _690;
                          float _697 = _692 * _628;
                          float _698 = _694 * _628;
                          float _699 = _696 * _628;
                          float _700 = _697 + _620;
                          float _701 = _698 + _621;
                          float _702 = _699 + _622;
                          _704 = _700;
                          _705 = _701;
                          _706 = _702;
                        } else {
                          _704 = _620;
                          _705 = _621;
                          _706 = _622;
                        }
                        float _707 = _343 * _704;
                        float _708 = _344 * _705;
                        float _709 = _345 * _706;
                        float _710 = min(_707, 1000.0f);
                        float _711 = min(_708, 1000.0f);
                        float _712 = min(_709, 1000.0f);
                        bool _713 = (MaterialIdEquals(_105.w, 0.007843137718737125f));
                        bool _714 = (_23 < 3.0f);
                        bool _715 = _714 && _713;
                        [branch]
                        if (_715) {
                          float _717 = _23 + -2.0f;
                          float _718 = max(_717, 0.0f);
                          float _723 = 1.0f - g_xSubsurfaceScatteringWeight.x;
                          float _724 = 1.0f - g_xSubsurfaceScatteringWeight.y;
                          float _725 = 1.0f - g_xSubsurfaceScatteringWeight.z;
                          float _726 = _723 * _718;
                          float _727 = _724 * _718;
                          float _728 = _725 * _718;
                          float _729 = _726 + g_xSubsurfaceScatteringWeight.x;
                          float _730 = _727 + g_xSubsurfaceScatteringWeight.y;
                          float _731 = _728 + g_xSubsurfaceScatteringWeight.z;
                          float _732 = _729 * _710;
                          float _733 = _730 * _711;
                          float _734 = _731 * _712;
                          _736 = true;
                          _737 = _732;
                          _738 = _733;
                          _739 = _734;
                        } else {
                          _736 = true;
                          _737 = _710;
                          _738 = _711;
                          _739 = _712;
                        }
                      } while (false);
                    } while (false);
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } else {
        _736 = false;
        _737 = 0.0f;
        _738 = 0.0f;
        _739 = 0.0f;
      }
    } while (false);
  } else {
    _736 = false;
    _737 = 0.0f;
    _738 = 0.0f;
    _739 = 0.0f;
  }
  [branch]
  if (!_736) {
    if (true) discard;
  }
  SV_Target.x = _737;
  SV_Target.y = _738;
  SV_Target.z = _739;
  SV_Target.w = 1.0f;
  return SV_Target;
}
