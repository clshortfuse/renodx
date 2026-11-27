// Baseline: 5 fewer fmul fast (dxc reassociation of 3 chains: normalize*sin*0.01 offset, spec visibility*D*G*F product, Fresnel*geometry term), phi incoming order/undef-vs-0 differs; otherwise identical to the original DXIL.
#include "./shared.h"

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
  int m_bCustomBoundingVolumeSet;
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
  int m_bIsProjector;
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

SamplerState g_xBilinearClamp : register(s3);

SamplerState g_xTrilinearWrap : register(s4);

SamplerState g_xTrilinearClamp : register(s5);

SamplerComparisonState g_xShadowCmpSampler : register(s8);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float3 CamDir : CamDir
) : SV_Target {
  float4 SV_Target;
  int _17 = int(SV_Position.x);
  int _18 = int(SV_Position.y);
  float4 _19 = g_xLighting_DepthStencil.Load(int3(_17, _18, 0));
  float _24 = g_xDepthProjViewUnpack.y - _19.x;
  float _25 = g_xDepthProjViewUnpack.x / _24;
  float _29 = g_xCameraTanHalfFOV.x * _25;
  float _30 = g_xCameraTanHalfFOV.y * _25;
  float _34 = g_xTwoOverScreenDimensions.z + SV_Position.x;
  float _35 = g_xTwoOverScreenDimensions.w + SV_Position.y;
  float _38 = _34 * g_xTwoOverScreenDimensions.x;
  float _39 = _35 * g_xTwoOverScreenDimensions.y;
  float _40 = _38 + -1.0f;
  float _41 = _39 + -1.0f;
  float _42 = _29 * _40;
  float _43 = _30 * _41;
  uint _45 = g_uProjectorIndex;
  float4 _46 = g_axProjectors[_45].m_xProjectorMatrix[0];
  float4 _49 = g_axProjectors[_45].m_xProjectorMatrix[1];
  float4 _52 = g_axProjectors[_45].m_xProjectorMatrix[2];
  float4 _55 = g_axProjectors[_45].m_xProjectorMatrix[3];
  float4 _58 = g_axProjectors[_45].m_xProjectionDirection;
  float4 _62 = g_axProjectors[_45].m_xDetailOffsetScale;
  float4 _67 = g_axProjectors[_45].m_xCausticOffsets;
  float3 _72 = g_axProjectors[_45].m_xProjectorPos;
  float3 _76 = g_axProjectors[_45].m_xLightColour;
  float _80 = g_axProjectors[_45].m_fDistanceFade;
  float _82 = g_axProjectors[_45].m_fLightFalloffScale;
  float _84 = g_axProjectors[_45].m_fLightFalloffPower;
  float _86 = g_axProjectors[_45].m_fMinRange;
  float _88 = g_axProjectors[_45].m_fLightRange;
  float _90 = g_axProjectors[_45].m_fShadowStrength;
  int _92 = g_axProjectors[_45].m_bCustomBoundingVolumeSet;
  float _94 = g_axProjectors[_45].m_f2DFilterSize;
  int _96 = g_axProjectors[_45].m_iShadowTextureIndex;
  float _98 = g_axProjectors[_45].m_fShadowSoftness;
  float _100 = g_axProjectors[_45].m_fShadowNearPlane;
  float _102 = g_axProjectors[_45].m_fShadowFarPlane;
  float _104 = g_axProjectors[_45].m_fProjectorOneOverTanHalfFov;
  float _106 = g_axProjectors[_45].m_fShadowBias;
  float _108 = g_axProjectors[_45].m_fSpecularStrength;
  float _110 = g_axProjectors[_45].m_fAreaLightRadius;
  int _112 = g_axProjectors[_45].m_iTextureIndex;
  int _114 = g_axProjectors[_45].m_iDetailTextureIndex;
  int _116 = g_axProjectors[_45].m_iCausticTextureIndex;
  float4 _118 = g_xLighting_NormalBuffer.Load(int3(_17, _18, 0));
  float4 _123 = g_xLighting_AlbedoBuffer.Load(int3(_17, _18, 0));
  float4 _128 = g_xLighting_PBRPropertiesBuffer.Load(int3(_17, _18, 0));
  float _133 = _118.x * 2.0f;
  float _134 = _118.y * 2.0f;
  float _135 = _118.z * 2.0f;
  float _136 = _133 + -1.0f;
  float _137 = _134 + -1.0f;
  float _138 = _135 + -1.0f;
  float _139 = dot(float3(_136, _137, _138), float3(_136, _137, _138));
  float _140 = rsqrt(_139);
  float _141 = _140 * _136;
  float _142 = _140 * _137;
  float _143 = _140 * _138;
  float _144 = _128.z * 2.0f;
  float _145 = _128.w * 2.0f;
  float _146 = _144 + -1.0f;
  float _147 = _145 + -1.0f;
  float _148 = dot(float2(_146, _147), float2(_146, _147));
  float _149 = 1.0f - _148;
  float _150 = saturate(_149);
  float _151 = sqrt(_150);
  bool _152 = (_118.w != 0.0f);
  float _153 = -0.0f - _151;
  float _154 = select(_152, _151, _153);
  float _155 = dot(float3(CamDir.x, CamDir.y, CamDir.z), float3(CamDir.x, CamDir.y, CamDir.z));
  float _156 = rsqrt(_155);
  float _157 = _156 * CamDir.x;
  float _158 = _156 * CamDir.y;
  float _159 = _156 * CamDir.z;
  float _160 = _46.z * _42;
  float _161 = mad(_49.z, _43, _160);
  float _162 = mad(_52.z, _25, _161);
  float _163 = _162 + _55.z;
  float _164 = _46.w * _42;
  float _165 = mad(_49.w, _43, _164);
  float _166 = mad(_52.w, _25, _165);
  float _167 = _166 + _55.w;
  bool _168 = (_163 < 0.0f);
  bool _199;
  float _200;
  float _201;
  float _323;
  float _324;
  float _351;
  float _352;
  float _377;
  float _378;
  float _403;
  float _404;
  float _605;
  float _609;
  float _621;
  float _622;
  float _623;
  float _635;
  float _677;
  float _678;
  float _687;
  float _688;
  float _689;
  float _702;
  float _703;
  float _704;
  float _754;
  float _755;
  float _756;
  float _757;
  float _817;
  float _818;
  float _819;
  float _820;
  float _821;
  float _822;
  float _823;
  float _957;
  float _982;
  float _983;
  float _984;
  float _1069;
  float _1070;
  float _1071;
  bool _1101;
  float _1102;
  float _1103;
  float _1104;
  float _1105;
  [branch]
  if (!_168) {
    float _174 = _46.y * _42;
    float _175 = mad(_49.y, _43, _174);
    float _176 = mad(_52.y, _25, _175);
    float _177 = _176 + _55.y;
    float _182 = _46.x * _42;
    float _183 = mad(_49.x, _43, _182);
    float _184 = mad(_52.x, _25, _183);
    float _185 = _184 + _55.x;
    float _186 = _185 / _167;
    float _187 = _177 / _167;
    float _188 = _186 + -0.5f;
    float _189 = _187 + -0.5f;
    float _190 = abs(_188);
    float _191 = abs(_189);
    float _192 = 0.5f - _190;
    float _193 = 0.5f - _191;
    bool _194 = (_192 < 0.0f);
    bool _195 = (_193 < 0.0f);
    bool _196 = _194 || _195;
    [branch]
    if (!_196) {
      _199 = true;
      _200 = _186;
      _201 = _187;
    } else {
      _199 = false;
      _200 = _186;
      _201 = _187;
    }
  } else {
    _199 = false;
  }
  [branch]
  if (_199) {
    float _219 = (g_xInvView[0].x) * _42;
    float _220 = mad((g_xInvView[1].x), _43, _219);
    float _221 = mad((g_xInvView[2].x), _25, _220);
    float _222 = (g_xInvView[0].y) * _42;
    float _223 = mad((g_xInvView[1].y), _43, _222);
    float _224 = mad((g_xInvView[2].y), _25, _223);
    float _225 = (g_xInvView[0].z) * _42;
    float _226 = mad((g_xInvView[1].z), _43, _225);
    float _227 = mad((g_xInvView[2].z), _25, _226);
    float _228 = _72.x - (g_xInvView[3].x);
    float _229 = _228 - _221;
    float _230 = _72.y - (g_xInvView[3].y);
    float _231 = _230 - _224;
    float _232 = _72.z - (g_xInvView[3].z);
    float _233 = _232 - _227;
    bool _234 = (_92 == 0);
    do {
      [branch]
      if (!_234) {
        float _236 = dot(float3(_229, _231, _233), float3(_58.x, _58.y, _58.z));
        float _237 = -0.0f - _236;
        bool _238 = (_86 > _237);
        bool _239 = (_88 < _237);
        bool _240 = _238 || _239;
        [branch]
        if (_240) {
          _1101 = false;
          break;
        }
      }
      float _242 = _229 * _229;
      float _243 = _231 * _231;
      float _244 = _243 + _242;
      float _245 = _233 * _233;
      float _246 = _244 + _245;
      float _247 = sqrt(_246);
      float _248 = _229 / _247;
      float _249 = _231 / _247;
      float _250 = _233 / _247;
      float _251 = _247 - _110;
      float _252 = _88 - _110;
      float _253 = _251 / _252;
      float _254 = saturate(_253);
      float _255 = 1.0f - _254;
      float _256 = _255 * _82;
      float _257 = saturate(_256);
      float _258 = log2(_257);
      float _259 = _258 * _84;
      float _260 = exp2(_259);
      float _261 = _260 * _80;
      float _262 = _261 + -9.999999747378752e-05f;
      bool _263 = (_262 < 0.0f);
      [branch]
      if (!_263) {
        bool _265 = (_96 == -1);
        do {
          [branch]
          if (!_265) {
            float _267 = dot(float3(_141, _142, _143), float3(_248, _249, _250));
            float _268 = saturate(_267);
            float _269 = 1.0f - _268;
            float _270 = _269 * _106;
            float _271 = max(_270, _106);
            float _272 = _271 + _163;
            float _273 = _272 / _167;
            float _274 = 1.0f - _273;
            float _275 = _274 * 2.0f;
            float _276 = _275 + -1.0f;
            float _277 = _100 * 2.0f;
            float _278 = _277 * _102;
            float _279 = _102 + _100;
            float _280 = _102 - _100;
            float _281 = _276 * _280;
            float _282 = _279 - _281;
            float _283 = _278 / _282;
            float _284 = _283 - _100;
            float _285 = _284 / _280;
            float _286 = saturate(_285);
            bool _287 = (_90 > 0.0f);
            [branch]
            if (_287) {
              bool _289 = (_98 > 0.0f);
              uint _290 = (int)(_96) + 0u;
              do {
                [branch]
                if (_289) {
                  float _293 = dot(float2(SV_Position.x, SV_Position.y), float2(0.0671105608344078f, 0.005837149918079376f));
                  float _294 = frac(_293);
                  float _295 = _294 * 52.98291778564453f;
                  float _296 = frac(_295);
                  float _297 = _296 * 6.283185005187988f;
                  float _298 = sin(_297);
                  float _299 = cos(_297);
                  float _300 = _98 * 0.02500000037252903f;
                  float _301 = _300 * _104;
                  float _302 = _301 * 0.3535533845424652f;
                  float _303 = _302 * _299;
                  float _304 = _302 * _298;
                  float _305 = _303 + _200;
                  float _306 = _304 + _201;
                  float4 _309 = g_xTextureArray[NonUniformResourceIndex(_290)].SampleBias(g_xBilinearClamp, float2(_305, _306), g_fGlobalSamplerBias, int2(0, 0));
                  float _311 = 1.0f - _309.x;
                  float _312 = _311 * 2.0f;
                  float _313 = _312 + -1.0f;
                  float _314 = _313 * _280;
                  float _315 = _279 - _314;
                  float _316 = _278 / _315;
                  float _317 = _316 - _100;
                  float _318 = _317 / _280;
                  float _319 = saturate(_318);
                  bool _320 = (_319 < _286);
                  do {
                    [branch]
                    if (_320) {
                      _323 = _319;
                      _324 = 1.0f;
                    } else {
                      _323 = 0.0f;
                      _324 = 0.0f;
                    }
                    float _325 = _297 + 2.4000000953674316f;
                    float _326 = sin(_325);
                    float _327 = cos(_325);
                    float _328 = _301 * 0.6123724579811096f;
                    float _329 = _328 * _327;
                    float _330 = _328 * _326;
                    float _331 = _329 + _200;
                    float _332 = _330 + _201;
                    float4 _335 = g_xTextureArray[NonUniformResourceIndex(_290)].SampleBias(g_xBilinearClamp, float2(_331, _332), g_fGlobalSamplerBias, int2(0, 0));
                    float _337 = 1.0f - _335.x;
                    float _338 = _337 * 2.0f;
                    float _339 = _338 + -1.0f;
                    float _340 = _339 * _280;
                    float _341 = _279 - _340;
                    float _342 = _278 / _341;
                    float _343 = _342 - _100;
                    float _344 = _343 / _280;
                    float _345 = saturate(_344);
                    bool _346 = (_345 < _286);
                    do {
                      [branch]
                      if (_346) {
                        float _348 = _345 + _323;
                        float _349 = _324 + 1.0f;
                        _351 = _348;
                        _352 = _349;
                      } else {
                        _351 = _323;
                        _352 = _324;
                      }
                      float _353 = _297 + 4.800000190734863f;
                      float _354 = sin(_353);
                      float _355 = cos(_353);
                      float _356 = _301 * 0.7905694246292114f;
                      float _357 = _356 * _355;
                      float _358 = _356 * _354;
                      float _359 = _357 + _200;
                      float _360 = _358 + _201;
                      float4 _361 = g_xTextureArray[NonUniformResourceIndex(_290)].SampleBias(g_xBilinearClamp, float2(_359, _360), g_fGlobalSamplerBias, int2(0, 0));
                      float _363 = 1.0f - _361.x;
                      float _364 = _363 * 2.0f;
                      float _365 = _364 + -1.0f;
                      float _366 = _365 * _280;
                      float _367 = _279 - _366;
                      float _368 = _278 / _367;
                      float _369 = _368 - _100;
                      float _370 = _369 / _280;
                      float _371 = saturate(_370);
                      bool _372 = (_371 < _286);
                      do {
                        [branch]
                        if (_372) {
                          float _374 = _371 + _351;
                          float _375 = _352 + 1.0f;
                          _377 = _374;
                          _378 = _375;
                        } else {
                          _377 = _351;
                          _378 = _352;
                        }
                        float _379 = _297 + 7.200000286102295f;
                        float _380 = sin(_379);
                        float _381 = cos(_379);
                        float _382 = _301 * 0.9354143738746643f;
                        float _383 = _382 * _381;
                        float _384 = _382 * _380;
                        float _385 = _383 + _200;
                        float _386 = _384 + _201;
                        float4 _387 = g_xTextureArray[NonUniformResourceIndex(_290)].SampleBias(g_xBilinearClamp, float2(_385, _386), g_fGlobalSamplerBias, int2(0, 0));
                        float _389 = 1.0f - _387.x;
                        float _390 = _389 * 2.0f;
                        float _391 = _390 + -1.0f;
                        float _392 = _391 * _280;
                        float _393 = _279 - _392;
                        float _394 = _278 / _393;
                        float _395 = _394 - _100;
                        float _396 = _395 / _280;
                        float _397 = saturate(_396);
                        bool _398 = (_397 < _286);
                        do {
                          [branch]
                          if (_398) {
                            float _400 = _397 + _377;
                            float _401 = _378 + 1.0f;
                            _403 = _400;
                            _404 = _401;
                          } else {
                            _403 = _377;
                            _404 = _378;
                          }
                          bool _405 = (_404 > 0.0f);
                          [branch]
                          if (_405) {
                            float _407 = _403 / _404;
                            float _408 = _286 - _407;
                            float _409 = _408 / _407;
                            float _410 = _409 * _409;
                            float _411 = saturate(_410);
                            float _412 = _301 * _411;
                            float _413 = _94 * 2.0f;
                            float _414 = _412 + _413;
                            float _415 = _298 * 0.32621198892593384f;
                            float _416 = _299 * 0.40580499172210693f;
                            float _417 = _416 - _415;
                            float _418 = _298 * 0.40580499172210693f;
                            float _419 = _299 * -0.32621198892593384f;
                            float _420 = _419 - _418;
                            float _421 = _414 * _417;
                            float _422 = _414 * _420;
                            float _423 = _421 + _200;
                            float _424 = _422 + _201;
                            float4 _425 = g_xTextureArray[NonUniformResourceIndex(_290)].SampleCmp(g_xShadowCmpSampler, float2(_423, _424), _273);
                            float _427 = _298 * 0.8401439785957336f;
                            float _428 = _299 * 0.07357999682426453f;
                            float _429 = _428 - _427;
                            float _430 = _298 * 0.07357999682426453f;
                            float _431 = _299 * -0.8401439785957336f;
                            float _432 = _431 - _430;
                            float _433 = _414 * _429;
                            float _434 = _414 * _432;
                            float _435 = _433 + _200;
                            float _436 = _434 + _201;
                            float4 _437 = g_xTextureArray[NonUniformResourceIndex(_290)].SampleCmp(g_xShadowCmpSampler, float2(_435, _436), _273);
                            float _439 = _437.x + _425.x;
                            float _440 = _298 * -0.6959139704704285f;
                            float _441 = _299 * 0.45713698863983154f;
                            float _442 = _440 - _441;
                            float _443 = _298 * 0.45713698863983154f;
                            float _444 = _299 * 0.6959139704704285f;
                            float _445 = _443 - _444;
                            float _446 = _414 * _442;
                            float _447 = _414 * _445;
                            float _448 = _446 + _200;
                            float _449 = _447 + _201;
                            float4 _450 = g_xTextureArray[NonUniformResourceIndex(_290)].SampleCmp(g_xShadowCmpSampler, float2(_448, _449), _273);
                            float _452 = _439 + _450.x;
                            float _453 = _298 * -0.20334500074386597f;
                            float _454 = _299 * 0.6207159757614136f;
                            float _455 = _453 - _454;
                            float _456 = _298 * 0.6207159757614136f;
                            float _457 = _299 * 0.20334500074386597f;
                            float _458 = _456 - _457;
                            float _459 = _414 * _455;
                            float _460 = _414 * _458;
                            float _461 = _459 + _200;
                            float _462 = _460 + _201;
                            float4 _463 = g_xTextureArray[NonUniformResourceIndex(_290)].SampleCmp(g_xShadowCmpSampler, float2(_461, _462), _273);
                            float _465 = _452 + _463.x;
                            float _466 = _298 * 0.9623399972915649f;
                            float _467 = _299 * 0.19498300552368164f;
                            float _468 = _467 + _466;
                            float _469 = _298 * 0.19498300552368164f;
                            float _470 = _299 * 0.9623399972915649f;
                            float _471 = _470 - _469;
                            float _472 = _414 * _468;
                            float _473 = _414 * _471;
                            float _474 = _472 + _200;
                            float _475 = _473 + _201;
                            float4 _476 = g_xTextureArray[NonUniformResourceIndex(_290)].SampleCmp(g_xShadowCmpSampler, float2(_474, _475), _273);
                            float _478 = _465 + _476.x;
                            float _479 = _298 * 0.4734340012073517f;
                            float _480 = _299 * 0.4800260066986084f;
                            float _481 = _480 + _479;
                            float _482 = _298 * 0.4800260066986084f;
                            float _483 = _299 * 0.4734340012073517f;
                            float _484 = _483 - _482;
                            float _485 = _414 * _481;
                            float _486 = _414 * _484;
                            float _487 = _485 + _200;
                            float _488 = _486 + _201;
                            float4 _489 = g_xTextureArray[NonUniformResourceIndex(_290)].SampleCmp(g_xShadowCmpSampler, float2(_487, _488), _273);
                            float _491 = _478 + _489.x;
                            float _492 = _298 * 0.5194560289382935f;
                            float _493 = _299 * 0.7670220136642456f;
                            float _494 = _492 - _493;
                            float _495 = _298 * 0.7670220136642456f;
                            float _496 = _299 * 0.5194560289382935f;
                            float _497 = _496 + _495;
                            float _498 = _414 * _494;
                            float _499 = _414 * _497;
                            float _500 = _498 + _200;
                            float _501 = _499 + _201;
                            float4 _502 = g_xTextureArray[NonUniformResourceIndex(_290)].SampleCmp(g_xShadowCmpSampler, float2(_500, _501), _273);
                            float _504 = _491 + _502.x;
                            float _505 = _298 * 0.18546099960803986f;
                            float _506 = _299 * 0.893123984336853f;
                            float _507 = _506 + _505;
                            float _508 = _298 * 0.893123984336853f;
                            float _509 = _299 * 0.18546099960803986f;
                            float _510 = _509 - _508;
                            float _511 = _414 * _507;
                            float _512 = _414 * _510;
                            float _513 = _511 + _200;
                            float _514 = _512 + _201;
                            float4 _515 = g_xTextureArray[NonUniformResourceIndex(_290)].SampleCmp(g_xShadowCmpSampler, float2(_513, _514), _273);
                            float _517 = _504 + _515.x;
                            float _518 = _517 * 0.125f;
                            _605 = _518;
                          } else {
                            _605 = 0.0f;
                          }
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                } else {
                  float _520 = _94 * 0.32621198892593384f;
                  float _521 = _94 * 0.40580499172210693f;
                  float _522 = _200 - _520;
                  float _523 = _201 - _521;
                  float4 _524 = g_xTextureArray[NonUniformResourceIndex(_290)].SampleCmp(g_xShadowCmpSampler, float2(_522, _523), _273);
                  float _526 = _94 * 0.8401439785957336f;
                  float _527 = _94 * 0.07357999682426453f;
                  float _528 = _200 - _526;
                  float _529 = _201 - _527;
                  float4 _530 = g_xTextureArray[NonUniformResourceIndex(_290)].SampleCmp(g_xShadowCmpSampler, float2(_528, _529), _273);
                  float _532 = _530.x + _524.x;
                  float _533 = _94 * 0.6959139704704285f;
                  float _534 = _94 * 0.45713698863983154f;
                  float _535 = _200 - _533;
                  float _536 = _201 + _534;
                  float4 _537 = g_xTextureArray[NonUniformResourceIndex(_290)].SampleCmp(g_xShadowCmpSampler, float2(_535, _536), _273);
                  float _539 = _532 + _537.x;
                  float _540 = _94 * 0.20334500074386597f;
                  float _541 = _94 * 0.6207159757614136f;
                  float _542 = _200 - _540;
                  float _543 = _201 + _541;
                  float4 _544 = g_xTextureArray[NonUniformResourceIndex(_290)].SampleCmp(g_xShadowCmpSampler, float2(_542, _543), _273);
                  float _546 = _539 + _544.x;
                  float _547 = _94 * 0.9623399972915649f;
                  float _548 = _94 * 0.19498300552368164f;
                  float _549 = _200 + _547;
                  float _550 = _201 - _548;
                  float4 _551 = g_xTextureArray[NonUniformResourceIndex(_290)].SampleCmp(g_xShadowCmpSampler, float2(_549, _550), _273);
                  float _553 = _546 + _551.x;
                  float _554 = _94 * 0.4734340012073517f;
                  float _555 = _94 * 0.4800260066986084f;
                  float _556 = _200 + _554;
                  float _557 = _201 - _555;
                  float4 _558 = g_xTextureArray[NonUniformResourceIndex(_290)].SampleCmp(g_xShadowCmpSampler, float2(_556, _557), _273);
                  float _560 = _553 + _558.x;
                  float _561 = _94 * 0.5194560289382935f;
                  float _562 = _94 * 0.7670220136642456f;
                  float _563 = _200 + _561;
                  float _564 = _201 + _562;
                  float4 _565 = g_xTextureArray[NonUniformResourceIndex(_290)].SampleCmp(g_xShadowCmpSampler, float2(_563, _564), _273);
                  float _567 = _560 + _565.x;
                  float _568 = _94 * 0.18546099960803986f;
                  float _569 = _94 * 0.893123984336853f;
                  float _570 = _200 + _568;
                  float _571 = _201 - _569;
                  float4 _572 = g_xTextureArray[NonUniformResourceIndex(_290)].SampleCmp(g_xShadowCmpSampler, float2(_570, _571), _273);
                  float _574 = _567 + _572.x;
                  float _575 = _94 * 0.5074309706687927f;
                  float _576 = _94 * 0.06442499905824661f;
                  float _577 = _200 + _575;
                  float _578 = _201 + _576;
                  float4 _579 = g_xTextureArray[NonUniformResourceIndex(_290)].SampleCmp(g_xShadowCmpSampler, float2(_577, _578), _273);
                  float _581 = _574 + _579.x;
                  float _582 = _94 * 0.8964200019836426f;
                  float _583 = _94 * 0.41245800256729126f;
                  float _584 = _200 + _582;
                  float _585 = _201 + _583;
                  float4 _586 = g_xTextureArray[NonUniformResourceIndex(_290)].SampleCmp(g_xShadowCmpSampler, float2(_584, _585), _273);
                  float _588 = _581 + _586.x;
                  float _589 = _94 * 0.32194000482559204f;
                  float _590 = _94 * 0.9326149821281433f;
                  float _591 = _200 - _589;
                  float _592 = _201 - _590;
                  float4 _593 = g_xTextureArray[NonUniformResourceIndex(_290)].SampleCmp(g_xShadowCmpSampler, float2(_591, _592), _273);
                  float _595 = _588 + _593.x;
                  float _596 = _94 * 0.7915589809417725f;
                  float _597 = _94 * 0.5977050065994263f;
                  float _598 = _200 - _596;
                  float _599 = _201 - _597;
                  float4 _600 = g_xTextureArray[NonUniformResourceIndex(_290)].SampleCmp(g_xShadowCmpSampler, float2(_598, _599), _273);
                  float _602 = _595 + _600.x;
                  float _603 = _602 * 0.0833333358168602f;
                  _605 = _603;
                }
                float _606 = _605 * _90;
                float _607 = 1.0f - _606;
                _609 = _607;
              } while (false);
            } else {
              _609 = 1.0f;
            }
          } else {
            _609 = 1.0f;
          }
          bool _610 = (_609 > 0.0f);
          [branch]
          if (_610) {
            bool _612 = ((int)_112 > (int)0);
            do {
              [branch]
              if (_612) {
                uint _614 = (int)(_112) + 0u;
                float4 _616 = g_xTextureArray[NonUniformResourceIndex(_614)].SampleLevel(g_xTrilinearClamp, float2(_200, _201), 0.0f);
                _621 = _616.x;
                _622 = _616.y;
                _623 = _616.z;
              } else {
                _621 = 1.0f;
                _622 = 1.0f;
                _623 = 1.0f;
              }
              float _624 = _200 * _67.z;
              float _625 = _201 * _67.z;
              float _626 = _624 + _67.x;
              float _627 = _625 + _67.y;
              bool _628 = ((int)_116 > (int)0);
              do {
                [branch]
                if (_628) {
                  uint _630 = (int)(_116) + 0u;
                  float4 _632 = g_xTextureArray[NonUniformResourceIndex(_630)].SampleLevel(g_xTrilinearWrap, float2(_626, _627), 0.0f);
                  _635 = _632.x;
                } else {
                  _635 = 1.0f;
                }
                bool _636 = ((int)_114 > (int)0);
                do {
                  [branch]
                  if (_636) {
                    float _638 = _200 * _62.z;
                    float _639 = _201 * _62.w;
                    float _640 = _638 + _62.x;
                    float _641 = _639 + _62.y;
                    do {
                      [branch]
                      if (_628) {
                        uint _643 = (int)(_116) + 0u;
                        float4 _645 = g_xTextureArray[NonUniformResourceIndex(_643)].SampleLevel(g_xTrilinearWrap, float2(_626, _627), 0.0f);
                        float _647 = _626 + 0.10000000149011612f;
                        float4 _648 = g_xTextureArray[NonUniformResourceIndex(_643)].SampleLevel(g_xTrilinearWrap, float2(_647, _627), 0.0f);
                        float _650 = _627 + 0.10000000149011612f;
                        float4 _651 = g_xTextureArray[NonUniformResourceIndex(_643)].SampleLevel(g_xTrilinearWrap, float2(_626, _650), 0.0f);
                        float _653 = _626 + -0.10000000149011612f;
                        float4 _654 = g_xTextureArray[NonUniformResourceIndex(_643)].SampleLevel(g_xTrilinearWrap, float2(_653, _627), 0.0f);
                        float _656 = _627 + -0.10000000149011612f;
                        float4 _657 = g_xTextureArray[NonUniformResourceIndex(_643)].SampleLevel(g_xTrilinearWrap, float2(_626, _656), 0.0f);
                        float _659 = _648.x + _645.x;
                        float _660 = _659 + _654.x;
                        float _661 = _651.x + _645.x;
                        float _662 = _661 + _657.x;
                        float _663 = _662 + _660;
                        float _664 = abs(_663);
                        float _665 = dot(float2(_660, _662), float2(_660, _662));
                        float _666 = rsqrt(_665);
                        float _667 = _666 * _660;
                        float _668 = _666 * _662;
                        float _669 = _664 + _67.w;
                        float _670 = sin(_669);
                        float _671 = _670 * 0.009999999776482582f;
                        float _672 = _667 * _671;
                        float _673 = _668 * _671;
                        float _674 = _672 + _640;
                        float _675 = _673 + _641;
                        _677 = _674;
                        _678 = _675;
                      } else {
                        _677 = _640;
                        _678 = _641;
                      }
                      uint _679 = (int)(_114) + 0u;
                      float4 _681 = g_xTextureArray[NonUniformResourceIndex(_679)].SampleLevel(g_xTrilinearWrap, float2(_677, _678), 0.0f);
                      float _683 = _681.x * _621;
                      float _684 = _681.x * _622;
                      float _685 = _681.x * _623;
                      _687 = _683;
                      _688 = _684;
                      _689 = _685;
                    } while (false);
                  } else {
                    _687 = _621;
                    _688 = _622;
                    _689 = _623;
                  }
                  do {
                    [branch]
                    if (_628) {
                      float _691 = min(_635, 1.0f);
                      float _692 = _691 * _687;
                      float _693 = _691 * _688;
                      float _694 = _691 * _689;
                      float _695 = max(_692, 0.0f);
                      float _696 = max(_693, 0.0f);
                      float _697 = max(_694, 0.0f);
                      float _698 = min(_695, 0.15000000596046448f);
                      float _699 = min(_696, 0.15000000596046448f);
                      float _700 = min(_697, 0.15000000596046448f);
                      _702 = _698;
                      _703 = _699;
                      _704 = _700;
                    } else {
                      _702 = _687;
                      _703 = _688;
                      _704 = _689;
                    }
                    float _705 = _261 * _76.x;
                    float _706 = _261 * _76.y;
                    float _707 = _261 * _76.z;
                    float _708 = _705 * _702;
                    float _709 = _706 * _703;
                    float _710 = _707 * _704;
                    bool _711 = (_110 > 0.0f);
                    do {
                      [branch]
                      if (_711) {
                        float _713 = dot(float3(_157, _158, _159), float3(_141, _142, _143));
                        float _714 = _713 * 2.0f;
                        float _715 = _714 * _141;
                        float _716 = _714 * _142;
                        float _717 = _714 * _143;
                        float _718 = _157 - _715;
                        float _719 = _158 - _716;
                        float _720 = _159 - _717;
                        float _721 = -0.0f - _718;
                        float _722 = -0.0f - _719;
                        float _723 = -0.0f - _720;
                        float _724 = dot(float3(_229, _231, _233), float3(_721, _722, _723));
                        float _725 = _724 * _721;
                        float _726 = _724 * _722;
                        float _727 = _724 * _723;
                        float _728 = _725 - _229;
                        float _729 = _726 - _231;
                        float _730 = _727 - _233;
                        float _731 = _728 * _728;
                        float _732 = _729 * _729;
                        float _733 = _731 + _732;
                        float _734 = _730 * _730;
                        float _735 = _733 + _734;
                        float _736 = sqrt(_735);
                        float _737 = _110 / _736;
                        float _738 = saturate(_737);
                        float _739 = _728 * _738;
                        float _740 = _729 * _738;
                        float _741 = _730 * _738;
                        float _742 = _739 + _229;
                        float _743 = _740 + _231;
                        float _744 = _741 + _233;
                        float _745 = dot(float3(_742, _743, _744), float3(_742, _743, _744));
                        float _746 = rsqrt(_745);
                        float _747 = _742 * _746;
                        float _748 = _743 * _746;
                        float _749 = _744 * _746;
                        float _750 = dot(float3(_229, _231, _233), float3(_229, _231, _233));
                        float _751 = rsqrt(_750);
                        float _752 = _751 * _110;
                        _754 = _747;
                        _755 = _748;
                        _756 = _749;
                        _757 = _752;
                      } else {
                        _754 = _248;
                        _755 = _249;
                        _756 = _250;
                        _757 = 0.0f;
                      }
                      // RenoDX: tolerant material-ID compares (MaterialIdEquals, shared.h)
                      bool _758 = !MaterialIdEquals(_123.w, 0.019607843831181526f);
                      float _759 = select(_758, _128.x, 0.0f);
                      float _760 = _754 + _157;
                      float _761 = _755 + _158;
                      float _762 = _756 + _159;
                      float _763 = dot(float3(_760, _761, _762), float3(_760, _761, _762));
                      float _764 = rsqrt(_763);
                      float _765 = _764 * _760;
                      float _766 = _764 * _761;
                      float _767 = _764 * _762;
                      float _768 = dot(float3(_141, _142, _143), float3(_248, _249, _250));
                      float _769 = saturate(_768);
                      float _770 = dot(float3(_141, _142, _143), float3(_157, _158, _159));
                      float _771 = saturate(_770);
                      float _772 = dot(float3(_141, _142, _143), float3(_765, _766, _767));
                      float _773 = saturate(_772);
                      float _774 = dot(float3(_157, _158, _159), float3(_765, _766, _767));
                      float _775 = saturate(_774);
                      bool _776 = MaterialIdEquals(_123.w, 0.01568627543747425f);
                      do {
                        [branch]
                        if (!_776) {
                          bool _778 = MaterialIdEquals(_123.w, 0.007843137718737125f);
                          [branch]
                          if (!_778) {
                            bool _780 = MaterialIdEquals(_123.w, 0.003921568859368563f);
                            [branch]
                            if (_780) {
                              float _782 = -0.0f - _141;
                              float _783 = -0.0f - _142;
                              float _784 = -0.0f - _143;
                              float _785 = dot(float3(_248, _249, _250), float3(_782, _783, _784));
                              float _786 = saturate(_785);
                              float _787 = _786 * 0.4000000059604645f;
                              float _788 = -0.0f - _157;
                              float _789 = -0.0f - _158;
                              float _790 = -0.0f - _159;
                              float _791 = dot(float3(_248, _249, _250), float3(_788, _789, _790));
                              float _792 = saturate(_791);
                              float _793 = log2(_792);
                              float _794 = _793 * 7.0f;
                              float _795 = exp2(_794);
                              float _796 = _795 + _787;
                              float _797 = saturate(_796);
                              float _798 = _797 * _759;
                              float _799 = _798 + _769;
                              _817 = _123.x;
                              _818 = _123.y;
                              _819 = _123.z;
                              _820 = 0.02800000086426735f;
                              _821 = 0.02800000086426735f;
                              _822 = 0.02800000086426735f;
                              _823 = _799;
                            } else {
                              float _801 = _123.x + -0.03999999910593033f;
                              float _802 = _123.y + -0.03999999910593033f;
                              float _803 = _123.z + -0.03999999910593033f;
                              float _804 = _759 * _801;
                              float _805 = _759 * _802;
                              float _806 = _759 * _803;
                              float _807 = _804 + 0.03999999910593033f;
                              float _808 = _805 + 0.03999999910593033f;
                              float _809 = _806 + 0.03999999910593033f;
                              float _810 = _759 * _123.x;
                              float _811 = _759 * _123.y;
                              float _812 = _759 * _123.z;
                              float _813 = _123.x - _810;
                              float _814 = _123.y - _811;
                              float _815 = _123.z - _812;
                              _817 = _813;
                              _818 = _814;
                              _819 = _815;
                              _820 = _807;
                              _821 = _808;
                              _822 = _809;
                              _823 = _769;
                            }
                          } else {
                            _817 = _123.x;
                            _818 = _123.y;
                            _819 = _123.z;
                            _820 = 0.02800000086426735f;
                            _821 = 0.02800000086426735f;
                            _822 = 0.02800000086426735f;
                            _823 = _769;
                          }
                        } else {
                          _817 = _123.x;
                          _818 = _123.y;
                          _819 = _123.z;
                          _820 = 0.04699999839067459f;
                          _821 = 0.04699999839067459f;
                          _822 = 0.04699999839067459f;
                          _823 = _769;
                        }
                        float _824 = _823 * _817;
                        float _825 = _823 * _818;
                        float _826 = _823 * _819;
                        float _827 = max(_128.y, 0.05000000074505806f);
                        float _828 = _827 * _827;
                        do {
                          [branch]
                          if (_776) {
                            float _830 = 1.0f - _128.y;
                            float _831 = saturate(_830);
                            float _832 = dot(float3(_123.x, _123.y, _123.z), float3(0.30000001192092896f, 0.5899999737739563f, 0.10999999940395355f));
                            float _833 = _128.x * 0.6000000238418579f;
                            float _834 = _833 + -0.3500000238418579f;
                            float _835 = _833 + -0.25f;
                            float _836 = _831 * 0.05000000074505806f;
                            float _837 = _835 - _836;
                            float _838 = log2(_831);
                            float _839 = _838 * 8.0f;
                            float _840 = exp2(_839);
                            float _841 = _840 * 500.0f;
                            float _842 = _841 + 20.0f;
                            float _843 = _838 * 6.0f;
                            float _844 = exp2(_843);
                            float _845 = _844 * 2000.0f;
                            float _846 = _845 + 50.0f;
                            float _847 = _128.x * 0.13500000536441803f;
                            float _848 = _847 + 0.015000000596046448f;
                            float _849 = _831 + 0.10000000149011612f;
                            float _850 = _128.x * 0.007499999832361937f;
                            float _851 = _850 + 0.007499999832361937f;
                            float _852 = _141 * _834;
                            float _853 = _142 * _834;
                            float _854 = _143 * _834;
                            float _855 = _852 + _146;
                            float _856 = _853 + _147;
                            float _857 = _154 + _854;
                            float _858 = dot(float3(_855, _856, _857), float3(_855, _856, _857));
                            float _859 = rsqrt(_858);
                            float _860 = _859 * _855;
                            float _861 = _859 * _856;
                            float _862 = _859 * _857;
                            float _863 = dot(float3(_860, _861, _862), float3(_765, _766, _767));
                            float _864 = _863 * _863;
                            float _865 = 1.0f - _864;
                            float _866 = saturate(_865);
                            float _867 = sqrt(_866);
                            float _868 = _863 + 1.0f;
                            float _869 = saturate(_868);
                            float _870 = _869 * 2.0f;
                            float _871 = 3.0f - _870;
                            float _872 = log2(_867);
                            float _873 = _872 * _842;
                            float _874 = exp2(_873);
                            float _875 = _840 * 19.89436912536621f;
                            float _876 = _875 + 1.1140847206115723f;
                            float _877 = _849 * _848;
                            float _878 = _877 * _876;
                            float _879 = _869 * _869;
                            float _880 = _879 * _878;
                            float _881 = _880 * _871;
                            float _882 = _881 * _874;
                            float _883 = max(_832, 0.0010000000474974513f);
                            float _884 = _123.x / _883;
                            float _885 = _123.y / _883;
                            float _886 = _123.z / _883;
                            float _887 = _882 * _884;
                            float _888 = _882 * _885;
                            float _889 = _882 * _886;
                            float _890 = _837 * _141;
                            float _891 = _837 * _142;
                            float _892 = _837 * _143;
                            float _893 = _890 + _146;
                            float _894 = _891 + _147;
                            float _895 = _892 + _154;
                            float _896 = dot(float3(_893, _894, _895), float3(_893, _894, _895));
                            float _897 = rsqrt(_896);
                            float _898 = _897 * _893;
                            float _899 = _897 * _894;
                            float _900 = _897 * _895;
                            float _901 = dot(float3(_898, _899, _900), float3(_765, _766, _767));
                            float _902 = _901 * _901;
                            float _903 = 1.0f - _902;
                            float _904 = saturate(_903);
                            float _905 = sqrt(_904);
                            float _906 = _901 + 1.0f;
                            float _907 = saturate(_906);
                            float _908 = _907 * 2.0f;
                            float _909 = 3.0f - _908;
                            float _910 = log2(_905);
                            float _911 = _910 * _846;
                            float _912 = exp2(_911);
                            float _913 = _844 * 79.57747650146484f;
                            float _914 = _913 + 2.3077468872070312f;
                            float _915 = _831 * _851;
                            float _916 = _915 * _914;
                            float _917 = _907 * _907;
                            float _918 = _917 * _916;
                            float _919 = _918 * _909;
                            float _920 = _919 * _912;
                            float _921 = _920 + _887;
                            float _922 = _920 + _888;
                            float _923 = _920 + _889;
                            float _924 = _769 * _108;
                            float _925 = _924 * _921;
                            float _926 = _924 * _922;
                            float _927 = _924 * _923;
                            _982 = _925;
                            _983 = _926;
                            _984 = _927;
                          } else {
                            float _929 = 1.0f - _828;
                            float _930 = _929 * _757;
                            float _931 = saturate(_930);
                            float _932 = 1.0f - _820;
                            float _933 = 1.0f - _821;
                            float _934 = 1.0f - _822;
                            float _935 = _775 * 5.55472993850708f;
                            float _936 = -6.983160018920898f - _935;
                            float _937 = _936 * _775;
                            float _938 = exp2(_937);
                            float _939 = _938 * _932;
                            float _940 = _938 * _933;
                            float _941 = _938 * _934;
                            float _942 = _939 + _820;
                            float _943 = _940 + _821;
                            float _944 = _941 + _822;
                            bool _945 = (_931 > 0.0f);
                            float _946 = _828 * _828;
                            do {
                              [branch]
                              if (_945) {
                                float _948 = _931 * 0.25f;
                                float _949 = _828 * 3.0f;
                                float _950 = _931 + _949;
                                float _951 = _948 * _950;
                                float _952 = _775 + 0.0010000000474974513f;
                                float _953 = _951 / _952;
                                float _954 = _953 + _946;
                                float _955 = _946 / _954;
                                _957 = _955;
                              } else {
                                _957 = 1.0f;
                              }
                              float _958 = 2.0f - _828;
                              float _959 = _958 * _771;
                              float _960 = _959 + _828;
                              float _961 = _958 * _769;
                              float _962 = _961 + _828;
                              float _963 = _960 * _962;
                              float _964 = 1.0f / _963;
                              float _965 = _946 * _773;
                              float _966 = _965 - _773;
                              float _967 = _966 * _773;
                              float _968 = _967 + 1.0f;
                              float _969 = _968 * _968;
                              float _970 = 1.0f / _969;
                              float _971 = _769 * _108;
                              float _972 = _971 * _946;
                              float _973 = _972 * _964;
                              float _974 = _973 * _970;
                              float _975 = _957 * _942;
                              float _976 = _975 * _974;
                              float _977 = _957 * _943;
                              float _978 = _977 * _974;
                              float _979 = _957 * _944;
                              float _980 = _979 * _974;
                              _982 = _976;
                              _983 = _978;
                              _984 = _980;
                            } while (false);
                          }
                          float _985 = _982 + _824;
                          float _986 = _983 + _825;
                          float _987 = _984 + _826;
                          bool _988 = MaterialIdEquals(_123.w, 0.019607843831181526f);
                          do {
                            [branch]
                            if (_988) {
                              bool _990 = (_128.x > 0.49803921580314636f);
                              float _991 = _128.x + -0.501960813999176f;
                              float _992 = select(_990, _991, _128.x);
                              float _993 = _992 * 2.007874011993408f;
                              float _994 = select(_990, 0.5f, 0.0f);
                              float _995 = -0.0f - _141;
                              float _996 = -0.0f - _142;
                              float _997 = -0.0f - _143;
                              float _998 = dot(float3(_248, _249, _250), float3(_995, _996, _997));
                              float _999 = saturate(_998);
                              float _1000 = _999 * 0.4000000059604645f;
                              float _1001 = -0.0f - _157;
                              float _1002 = -0.0f - _158;
                              float _1003 = -0.0f - _159;
                              float _1004 = dot(float3(_248, _249, _250), float3(_1001, _1002, _1003));
                              float _1005 = saturate(_1004);
                              float _1006 = log2(_1005);
                              float _1007 = _1006 * 7.0f;
                              float _1008 = exp2(_1007);
                              float _1009 = _1008 + _1000;
                              float _1010 = saturate(_1009);
                              float _1011 = _1010 * _994;
                              float _1012 = _1011 * _817;
                              float _1013 = _1011 * _818;
                              float _1014 = _1011 * _819;
                              float _1015 = abs(_817);
                              float _1016 = abs(_818);
                              float _1017 = abs(_819);
                              float _1018 = sqrt(_1015);
                              float _1019 = sqrt(_1016);
                              float _1020 = sqrt(_1017);
                              float _1021 = 1.0f - _1018;
                              float _1022 = 1.0f - _1019;
                              float _1023 = 1.0f - _1020;
                              float _1024 = _775 * 5.55472993850708f;
                              float _1025 = -6.983160018920898f - _1024;
                              float _1026 = _1025 * _775;
                              float _1027 = exp2(_1026);
                              float _1028 = _1027 * _1021;
                              float _1029 = _1027 * _1022;
                              float _1030 = _1023 * _1027;
                              float _1031 = _1028 + _1018;
                              float _1032 = _1029 + _1019;
                              float _1033 = _1030 + _1020;
                              float _1034 = _771 + _769;
                              float _1035 = _771 * _769;
                              float _1036 = _1034 - _1035;
                              float _1037 = _1036 * 4.0f;
                              float _1038 = _1037 + 9.999999682655225e-21f;
                              float _1039 = 1.0f / _1038;
                              float _1040 = 0.5f / _828;
                              float _1041 = _773 * _773;
                              float _1042 = 1.0f - _1041;
                              float _1043 = _1040 + 1.0f;
                              float _1044 = log2(_1042);
                              float _1045 = _1044 * _1040;
                              float _1046 = exp2(_1045);
                              float _1047 = _1043 * _1039;
                              float _1048 = _1047 * _1046;
                              float _1049 = _769 * _108;
                              float _1050 = _1031 * _1049;
                              float _1051 = _1050 * _1048;
                              float _1052 = _1032 * _1049;
                              float _1053 = _1052 * _1048;
                              float _1054 = _1033 * _1049;
                              float _1055 = _1054 * _1048;
                              float _1056 = _1012 - _982;
                              float _1057 = _1056 + _1051;
                              float _1058 = _1013 - _983;
                              float _1059 = _1058 + _1053;
                              float _1060 = _1014 - _984;
                              float _1061 = _1060 + _1055;
                              float _1062 = _1057 * _993;
                              float _1063 = _1059 * _993;
                              float _1064 = _1061 * _993;
                              float _1065 = _1062 + _985;
                              float _1066 = _1063 + _986;
                              float _1067 = _1064 + _987;
                              _1069 = _1065;
                              _1070 = _1066;
                              _1071 = _1067;
                            } else {
                              _1069 = _985;
                              _1070 = _986;
                              _1071 = _987;
                            }
                            float _1072 = _708 * _1069;
                            float _1073 = _709 * _1070;
                            float _1074 = _710 * _1071;
                            float _1075 = min(_1072, 1000.0f);
                            float _1076 = min(_1073, 1000.0f);
                            float _1077 = min(_1074, 1000.0f);
                            bool _1078 = MaterialIdEquals(_123.w, 0.007843137718737125f);
                            bool _1079 = (_25 < 3.0f);
                            bool _1080 = _1079 && _1078;
                            [branch]
                            if (_1080) {
                              float _1082 = _25 + -2.0f;
                              float _1083 = max(_1082, 0.0f);
                              float _1088 = 1.0f - g_xSubsurfaceScatteringWeight.x;
                              float _1089 = 1.0f - g_xSubsurfaceScatteringWeight.y;
                              float _1090 = 1.0f - g_xSubsurfaceScatteringWeight.z;
                              float _1091 = _1088 * _1083;
                              float _1092 = _1089 * _1083;
                              float _1093 = _1090 * _1083;
                              float _1094 = _1091 + g_xSubsurfaceScatteringWeight.x;
                              float _1095 = _1092 + g_xSubsurfaceScatteringWeight.y;
                              float _1096 = _1093 + g_xSubsurfaceScatteringWeight.z;
                              float _1097 = _1094 * _1075;
                              float _1098 = _1095 * _1076;
                              float _1099 = _1096 * _1077;
                              _1101 = true;
                              _1102 = _1097;
                              _1103 = _1098;
                              _1104 = _1099;
                              _1105 = _609;
                            } else {
                              _1101 = true;
                              _1102 = _1075;
                              _1103 = _1076;
                              _1104 = _1077;
                              _1105 = _609;
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
            _1101 = true;
            _1102 = 0.0f;
            _1103 = 0.0f;
            _1104 = 0.0f;
            _1105 = _609;
          }
        } while (false);
      } else {
        _1101 = false;
      }
    } while (false);
  } else {
    _1101 = false;
  }
  [branch]
  if (!_1101) {
    if (true) discard;
  }
  SV_Target.x = _1102;
  SV_Target.y = _1103;
  SV_Target.z = _1104;
  SV_Target.w = _1105;
  return SV_Target;
}
