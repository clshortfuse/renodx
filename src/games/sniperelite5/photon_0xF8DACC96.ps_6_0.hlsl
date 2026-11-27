#include "./shared.h"

// Baseline: 4 fewer fmul fast (dxc reassociation of the two specular product chains: shared factor folded across the 3 color channels), otherwise identical to the original DXIL.

struct PhotonFace {
  uint uLevel;
  float fSize;
  float fInvSize;
  int iShadowIndex;
};

struct PhotonParams {
  float4 m_xLightOrientation[4];
  float4 m_xCustomVolumeMatrix[4];
  float3 m_xLightPos;
  float m_fAreaLightRadius;
  float3 m_xLightDir;
  float m_fLightRange;
  float3 m_xLightColour;
  bool m_bUseLimitAngles;
  float m_fLightFalloffScale;
  float m_fLightFalloffPower;
  float m_fLightAngleOuter;
  float m_fRcpLightAngleRange;
  float m_fArcCosLimitAngle;
  float m_fRcpProjCubeLerpDist;
  bool m_bUseProjCube;
  bool m_bUseDualProjCube;
  float2 m_xDepthProjection;
  float m_fLightMeshRadius;
  float m_fShadowStrength;
  float m_fShadowSoftness;
  float m_fShadowNearPlane;
  float m_fShadowFarPlane;
  float m_fShadowBias;
  float m_fSpecularStrength;
  float m_fPadding;
  int m_iProjCubeTextureIndex;
  int m_iProjCubeBlurredTextureIndex;
  PhotonFace m_axFace[6];
};

Texture2D<float4> g_xLighting_NormalBuffer : register(t2);

Texture2D<float4> g_xLighting_AlbedoBuffer : register(t3);

Texture2D<float4> g_xLighting_PBRPropertiesBuffer : register(t4);

Texture2D<float4> g_xLighting_DepthStencil : register(t5);

StructuredBuffer<PhotonParams> g_axPhotons : register(t41);

TextureCube<float4> g_xProjCubeMap : register(t6);

TextureCube<float4> g_xProjCubeMapBlurred : register(t7);

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

cbuffer PhotonIndex : register(b4) {
  uint g_uPhotonIndex : packoffset(c000.x);
};

SamplerState g_xTrilinearClamp : register(s5);

float4 main(
  noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  int _13 = int(SV_Position.x);
  int _14 = int(SV_Position.y);
  float4 _15 = g_xLighting_DepthStencil.Load(int3(_13, _14, 0));
  float _20 = g_xDepthProjViewUnpack.y - _15.x;
  float _21 = g_xDepthProjViewUnpack.x / _20;
  float _25 = g_xCameraTanHalfFOV.x * _21;
  float _26 = g_xCameraTanHalfFOV.y * _21;
  float _30 = g_xTwoOverScreenDimensions.z + SV_Position.x;
  float _31 = g_xTwoOverScreenDimensions.w + SV_Position.y;
  float _34 = _30 * g_xTwoOverScreenDimensions.x;
  float _35 = _31 * g_xTwoOverScreenDimensions.y;
  float _36 = _34 + -1.0f;
  float _37 = _35 + -1.0f;
  float _38 = _25 * _36;
  float _39 = _26 * _37;
  float _56 = _38 * (g_xInvView[0].x);
  float _57 = mad((g_xInvView[1].x), _39, _56);
  float _58 = mad((g_xInvView[2].x), _21, _57);
  float _59 = _58 + (g_xInvView[3].x);
  float _60 = _38 * (g_xInvView[0].y);
  float _61 = mad((g_xInvView[1].y), _39, _60);
  float _62 = mad((g_xInvView[2].y), _21, _61);
  float _63 = _62 + (g_xInvView[3].y);
  float _64 = _38 * (g_xInvView[0].z);
  float _65 = mad((g_xInvView[1].z), _39, _64);
  float _66 = mad((g_xInvView[2].z), _21, _65);
  float _67 = _66 + (g_xInvView[3].z);
  float4 _68 = g_xLighting_NormalBuffer.Load(int3(_13, _14, 0));
  float4 _73 = g_xLighting_AlbedoBuffer.Load(int3(_13, _14, 0));
  float4 _78 = g_xLighting_PBRPropertiesBuffer.Load(int3(_13, _14, 0));
  float _83 = _68.x * 2.0f;
  float _84 = _68.y * 2.0f;
  float _85 = _68.z * 2.0f;
  float _86 = _83 + -1.0f;
  float _87 = _84 + -1.0f;
  float _88 = _85 + -1.0f;
  float _89 = dot(float3(_86, _87, _88), float3(_86, _87, _88));
  float _90 = rsqrt(_89);
  float _91 = _90 * _86;
  float _92 = _90 * _87;
  float _93 = _90 * _88;
  float _94 = _78.z * 2.0f;
  float _95 = _78.w * 2.0f;
  float _96 = _94 + -1.0f;
  float _97 = _95 + -1.0f;
  float _98 = dot(float2(_96, _97), float2(_96, _97));
  float _99 = 1.0f - _98;
  float _100 = saturate(_99);
  float _101 = sqrt(_100);
  bool _102 = (_68.w != 0.0f);
  float _103 = -0.0f - _101;
  float _104 = select(_102, _101, _103);
  uint _106 = g_uPhotonIndex;
  float3 _107 = g_axPhotons[_106].m_xLightOrientation[0].xyz;
  float3 _111 = g_axPhotons[_106].m_xLightOrientation[1].xyz;
  float3 _115 = g_axPhotons[_106].m_xLightOrientation[2].xyz;
  float3 _119 = g_axPhotons[_106].m_xLightPos;
  float _123 = g_axPhotons[_106].m_fAreaLightRadius;
  float3 _125 = g_axPhotons[_106].m_xLightDir;
  float _126 = g_axPhotons[_106].m_fLightRange;
  float3 _128 = g_axPhotons[_106].m_xLightColour;
  int _132 = g_axPhotons[_106].m_bUseLimitAngles;
  float _134 = g_axPhotons[_106].m_fLightFalloffScale;
  float _136 = g_axPhotons[_106].m_fLightFalloffPower;
  float _138 = g_axPhotons[_106].m_fLightAngleOuter;
  float _139 = g_axPhotons[_106].m_fRcpLightAngleRange;
  float _140 = g_axPhotons[_106].m_fRcpProjCubeLerpDist;
  int _142 = g_axPhotons[_106].m_bUseProjCube;
  int _144 = g_axPhotons[_106].m_bUseDualProjCube;
  float _146 = g_axPhotons[_106].m_fSpecularStrength;
  float _152 = _119.x - _59;
  float _153 = _119.y - _63;
  float _154 = _119.z - _67;
  float _155 = _152 * _152;
  float _156 = _153 * _153;
  float _157 = _155 + _156;
  float _158 = _154 * _154;
  float _159 = _157 + _158;
  float _160 = sqrt(_159);
  float _161 = _152 / _160;
  float _162 = _153 / _160;
  float _163 = _154 / _160;
  float _164 = _160 - _123;
  float _165 = _126 - _123;
  float _166 = _164 / _165;
  float _167 = saturate(_166);
  float _168 = 1.0f - _167;
  float _169 = _168 * _134;
  float _170 = saturate(_169);
  float _171 = log2(_170);
  float _172 = _171 * _136;
  float _173 = exp2(_172);
  bool _174 = (_132 == 0);
  float _187;
  float _227;
  float _228;
  float _229;
  float _234;
  float _235;
  float _236;
  float _288;
  float _289;
  float _290;
  float _291;
  float _351;
  float _352;
  float _353;
  float _354;
  float _355;
  float _356;
  float _357;
  float _491;
  float _516;
  float _517;
  float _518;
  float _603;
  float _604;
  float _605;
  bool _635;
  float _636;
  float _637;
  float _638;
  [branch]
  if (!_174) {
    float _181 = dot(float3(_161, _162, _163), float3(_125.x, _125.y, _125.z));
    float _182 = _181 + _138;
    float _183 = _182 * _139;
    float _184 = saturate(_183);
    float _185 = _184 * _173;
    _187 = _185;
  } else {
    _187 = _173;
  }
  bool _188 = (_187 < 9.999999747378752e-05f);
  [branch]
  if (!_188) {
    float _190 = _187 * _128.x;
    float _191 = _187 * _128.y;
    float _192 = _187 * _128.z;
    bool _193 = (_142 == 0);
    [branch]
    if (!_193) {
      float _195 = _161 * _107.x;
      float _196 = mad(_162, _107.y, _195);
      float _197 = mad(_163, _107.z, _196);
      float _198 = _161 * _111.x;
      float _199 = mad(_162, _111.y, _198);
      float _200 = mad(_163, _111.z, _199);
      float _201 = _161 * _115.x;
      float _202 = mad(_162, _115.y, _201);
      float _203 = mad(_163, _115.z, _202);
      float4 _204 = g_xProjCubeMap.Sample(g_xTrilinearClamp, float3(_197, _200, _203));
      bool _208 = (_144 == 0);
      [branch]
      if (!_208) {
        float4 _210 = g_xProjCubeMapBlurred.Sample(g_xTrilinearClamp, float3(_197, _200, _203));
        float _214 = _160 / _126;
        float _215 = _214 * _140;
        float _216 = min(_215, 1.0f);
        float _217 = _210.x - _204.x;
        float _218 = _210.y - _204.y;
        float _219 = _210.z - _204.z;
        float _220 = _216 * _217;
        float _221 = _216 * _218;
        float _222 = _216 * _219;
        float _223 = _220 + _204.x;
        float _224 = _221 + _204.y;
        float _225 = _222 + _204.z;
        _227 = _223;
        _228 = _224;
        _229 = _225;
      } else {
        _227 = _204.x;
        _228 = _204.y;
        _229 = _204.z;
      }
      float _230 = _227 * _190;
      float _231 = _228 * _191;
      float _232 = _229 * _192;
      _234 = _230;
      _235 = _231;
      _236 = _232;
    } else {
      _234 = _190;
      _235 = _191;
      _236 = _192;
    }
    float _237 = g_xCamPos.x - _59;
    float _238 = g_xCamPos.y - _63;
    float _239 = g_xCamPos.z - _67;
    float _240 = dot(float3(_237, _238, _239), float3(_237, _238, _239));
    float _241 = rsqrt(_240);
    float _242 = _241 * _237;
    float _243 = _241 * _238;
    float _244 = _241 * _239;
    bool _245 = (_123 > 0.0f);
    [branch]
    if (_245) {
      float _247 = dot(float3(_242, _243, _244), float3(_91, _92, _93));
      float _248 = _247 * 2.0f;
      float _249 = _248 * _91;
      float _250 = _248 * _92;
      float _251 = _248 * _93;
      float _252 = _242 - _249;
      float _253 = _243 - _250;
      float _254 = _244 - _251;
      float _255 = -0.0f - _252;
      float _256 = -0.0f - _253;
      float _257 = -0.0f - _254;
      float _258 = dot(float3(_152, _153, _154), float3(_255, _256, _257));
      float _259 = _258 * _255;
      float _260 = _258 * _256;
      float _261 = _258 * _257;
      float _262 = _259 - _152;
      float _263 = _260 - _153;
      float _264 = _261 - _154;
      float _265 = _262 * _262;
      float _266 = _263 * _263;
      float _267 = _265 + _266;
      float _268 = _264 * _264;
      float _269 = _267 + _268;
      float _270 = sqrt(_269);
      float _271 = _123 / _270;
      float _272 = saturate(_271);
      float _273 = _262 * _272;
      float _274 = _263 * _272;
      float _275 = _264 * _272;
      float _276 = _273 + _152;
      float _277 = _274 + _153;
      float _278 = _275 + _154;
      float _279 = dot(float3(_276, _277, _278), float3(_276, _277, _278));
      float _280 = rsqrt(_279);
      float _281 = _276 * _280;
      float _282 = _277 * _280;
      float _283 = _278 * _280;
      float _284 = dot(float3(_152, _153, _154), float3(_152, _153, _154));
      float _285 = rsqrt(_284);
      float _286 = _285 * _123;
      _288 = _281;
      _289 = _282;
      _290 = _283;
      _291 = _286;
    } else {
      _288 = _161;
      _289 = _162;
      _290 = _163;
      _291 = 0.0f;
    }
    // RenoDX: tolerant material-ID compares (MaterialIdEquals, shared.h)
    bool _292 = !MaterialIdEquals(_73.w, 0.019607843831181526f);
    float _293 = select(_292, _78.x, 0.0f);
    float _294 = _288 + _242;
    float _295 = _289 + _243;
    float _296 = _290 + _244;
    float _297 = dot(float3(_294, _295, _296), float3(_294, _295, _296));
    float _298 = rsqrt(_297);
    float _299 = _298 * _294;
    float _300 = _298 * _295;
    float _301 = _298 * _296;
    float _302 = dot(float3(_91, _92, _93), float3(_161, _162, _163));
    float _303 = saturate(_302);
    float _304 = dot(float3(_91, _92, _93), float3(_242, _243, _244));
    float _305 = saturate(_304);
    float _306 = dot(float3(_91, _92, _93), float3(_299, _300, _301));
    float _307 = saturate(_306);
    float _308 = dot(float3(_242, _243, _244), float3(_299, _300, _301));
    float _309 = saturate(_308);
    bool _310 = MaterialIdEquals(_73.w, 0.01568627543747425f);
    [branch]
    if (!_310) {
      bool _312 = MaterialIdEquals(_73.w, 0.007843137718737125f);
      [branch]
      if (!_312) {
        bool _314 = MaterialIdEquals(_73.w, 0.003921568859368563f);
        [branch]
        if (_314) {
          float _316 = -0.0f - _91;
          float _317 = -0.0f - _92;
          float _318 = -0.0f - _93;
          float _319 = dot(float3(_161, _162, _163), float3(_316, _317, _318));
          float _320 = saturate(_319);
          float _321 = _320 * 0.4000000059604645f;
          float _322 = -0.0f - _242;
          float _323 = -0.0f - _243;
          float _324 = -0.0f - _244;
          float _325 = dot(float3(_161, _162, _163), float3(_322, _323, _324));
          float _326 = saturate(_325);
          float _327 = log2(_326);
          float _328 = _327 * 7.0f;
          float _329 = exp2(_328);
          float _330 = _329 + _321;
          float _331 = saturate(_330);
          float _332 = _331 * _293;
          float _333 = _332 + _303;
          _351 = _73.x;
          _352 = _73.y;
          _353 = _73.z;
          _354 = 0.02800000086426735f;
          _355 = 0.02800000086426735f;
          _356 = 0.02800000086426735f;
          _357 = _333;
        } else {
          float _335 = _73.x + -0.03999999910593033f;
          float _336 = _73.y + -0.03999999910593033f;
          float _337 = _73.z + -0.03999999910593033f;
          float _338 = _293 * _335;
          float _339 = _293 * _336;
          float _340 = _293 * _337;
          float _341 = _338 + 0.03999999910593033f;
          float _342 = _339 + 0.03999999910593033f;
          float _343 = _340 + 0.03999999910593033f;
          float _344 = _293 * _73.x;
          float _345 = _293 * _73.y;
          float _346 = _293 * _73.z;
          float _347 = _73.x - _344;
          float _348 = _73.y - _345;
          float _349 = _73.z - _346;
          _351 = _347;
          _352 = _348;
          _353 = _349;
          _354 = _341;
          _355 = _342;
          _356 = _343;
          _357 = _303;
        }
      } else {
        _351 = _73.x;
        _352 = _73.y;
        _353 = _73.z;
        _354 = 0.02800000086426735f;
        _355 = 0.02800000086426735f;
        _356 = 0.02800000086426735f;
        _357 = _303;
      }
    } else {
      _351 = _73.x;
      _352 = _73.y;
      _353 = _73.z;
      _354 = 0.04699999839067459f;
      _355 = 0.04699999839067459f;
      _356 = 0.04699999839067459f;
      _357 = _303;
    }
    float _358 = _357 * _351;
    float _359 = _357 * _352;
    float _360 = _357 * _353;
    float _361 = max(_78.y, 0.05000000074505806f);
    float _362 = _361 * _361;
    [branch]
    if (_310) {
      float _364 = 1.0f - _78.y;
      float _365 = saturate(_364);
      float _366 = dot(float3(_73.x, _73.y, _73.z), float3(0.30000001192092896f, 0.5899999737739563f, 0.10999999940395355f));
      float _367 = _78.x * 0.6000000238418579f;
      float _368 = _367 + -0.3500000238418579f;
      float _369 = _367 + -0.25f;
      float _370 = _365 * 0.05000000074505806f;
      float _371 = _369 - _370;
      float _372 = log2(_365);
      float _373 = _372 * 8.0f;
      float _374 = exp2(_373);
      float _375 = _374 * 500.0f;
      float _376 = _375 + 20.0f;
      float _377 = _372 * 6.0f;
      float _378 = exp2(_377);
      float _379 = _378 * 2000.0f;
      float _380 = _379 + 50.0f;
      float _381 = _78.x * 0.13500000536441803f;
      float _382 = _381 + 0.015000000596046448f;
      float _383 = _365 + 0.10000000149011612f;
      float _384 = _78.x * 0.007499999832361937f;
      float _385 = _384 + 0.007499999832361937f;
      float _386 = _368 * _91;
      float _387 = _368 * _92;
      float _388 = _368 * _93;
      float _389 = _386 + _96;
      float _390 = _387 + _97;
      float _391 = _104 + _388;
      float _392 = dot(float3(_389, _390, _391), float3(_389, _390, _391));
      float _393 = rsqrt(_392);
      float _394 = _393 * _389;
      float _395 = _393 * _390;
      float _396 = _393 * _391;
      float _397 = dot(float3(_394, _395, _396), float3(_299, _300, _301));
      float _398 = _397 * _397;
      float _399 = 1.0f - _398;
      float _400 = saturate(_399);
      float _401 = sqrt(_400);
      float _402 = _397 + 1.0f;
      float _403 = saturate(_402);
      float _404 = _403 * 2.0f;
      float _405 = 3.0f - _404;
      float _406 = log2(_401);
      float _407 = _406 * _376;
      float _408 = exp2(_407);
      float _409 = _374 * 19.89436912536621f;
      float _410 = _409 + 1.1140847206115723f;
      float _411 = _383 * _382;
      float _412 = _411 * _410;
      float _413 = _403 * _403;
      float _414 = _413 * _412;
      float _415 = _414 * _405;
      float _416 = _415 * _408;
      float _417 = max(_366, 0.0010000000474974513f);
      float _418 = _73.x / _417;
      float _419 = _73.y / _417;
      float _420 = _73.z / _417;
      float _421 = _416 * _418;
      float _422 = _416 * _419;
      float _423 = _416 * _420;
      float _424 = _371 * _91;
      float _425 = _371 * _92;
      float _426 = _371 * _93;
      float _427 = _424 + _96;
      float _428 = _425 + _97;
      float _429 = _426 + _104;
      float _430 = dot(float3(_427, _428, _429), float3(_427, _428, _429));
      float _431 = rsqrt(_430);
      float _432 = _431 * _427;
      float _433 = _431 * _428;
      float _434 = _431 * _429;
      float _435 = dot(float3(_432, _433, _434), float3(_299, _300, _301));
      float _436 = _435 * _435;
      float _437 = 1.0f - _436;
      float _438 = saturate(_437);
      float _439 = sqrt(_438);
      float _440 = _435 + 1.0f;
      float _441 = saturate(_440);
      float _442 = _441 * 2.0f;
      float _443 = 3.0f - _442;
      float _444 = log2(_439);
      float _445 = _444 * _380;
      float _446 = exp2(_445);
      float _447 = _378 * 79.57747650146484f;
      float _448 = _447 + 2.3077468872070312f;
      float _449 = _365 * _385;
      float _450 = _449 * _448;
      float _451 = _441 * _441;
      float _452 = _451 * _450;
      float _453 = _452 * _443;
      float _454 = _453 * _446;
      float _455 = _454 + _421;
      float _456 = _454 + _422;
      float _457 = _454 + _423;
      float _458 = _303 * _146;
      float _459 = _458 * _455;
      float _460 = _458 * _456;
      float _461 = _458 * _457;
      _516 = _459;
      _517 = _460;
      _518 = _461;
    } else {
      float _463 = 1.0f - _362;
      float _464 = _463 * _291;
      float _465 = saturate(_464);
      float _466 = 1.0f - _354;
      float _467 = 1.0f - _355;
      float _468 = 1.0f - _356;
      float _469 = _309 * 5.55472993850708f;
      float _470 = -6.983160018920898f - _469;
      float _471 = _470 * _309;
      float _472 = exp2(_471);
      float _473 = _472 * _466;
      float _474 = _472 * _467;
      float _475 = _472 * _468;
      float _476 = _473 + _354;
      float _477 = _474 + _355;
      float _478 = _475 + _356;
      bool _479 = (_465 > 0.0f);
      float _480 = _362 * _362;
      [branch]
      if (_479) {
        float _482 = _465 * 0.25f;
        float _483 = _362 * 3.0f;
        float _484 = _465 + _483;
        float _485 = _482 * _484;
        float _486 = _309 + 0.0010000000474974513f;
        float _487 = _485 / _486;
        float _488 = _487 + _480;
        float _489 = _480 / _488;
        _491 = _489;
      } else {
        _491 = 1.0f;
      }
      float _492 = 2.0f - _362;
      float _493 = _492 * _305;
      float _494 = _493 + _362;
      float _495 = _492 * _303;
      float _496 = _495 + _362;
      float _497 = _494 * _496;
      float _498 = 1.0f / _497;
      float _499 = _480 * _307;
      float _500 = _499 - _307;
      float _501 = _500 * _307;
      float _502 = _501 + 1.0f;
      float _503 = _502 * _502;
      float _504 = 1.0f / _503;
      float _505 = _146 * _303;
      float _506 = _505 * _480;
      float _507 = _506 * _498;
      float _508 = _507 * _504;
      float _509 = _491 * _476;
      float _510 = _509 * _508;
      float _511 = _491 * _477;
      float _512 = _511 * _508;
      float _513 = _491 * _478;
      float _514 = _513 * _508;
      _516 = _510;
      _517 = _512;
      _518 = _514;
    }
    float _519 = _516 + _358;
    float _520 = _517 + _359;
    float _521 = _518 + _360;
    bool _522 = MaterialIdEquals(_73.w, 0.019607843831181526f);
    [branch]
    if (_522) {
      bool _524 = (_78.x > 0.49803921580314636f);
      float _525 = _78.x + -0.501960813999176f;
      float _526 = select(_524, _525, _78.x);
      float _527 = _526 * 2.007874011993408f;
      float _528 = select(_524, 0.5f, 0.0f);
      float _529 = -0.0f - _91;
      float _530 = -0.0f - _92;
      float _531 = -0.0f - _93;
      float _532 = dot(float3(_161, _162, _163), float3(_529, _530, _531));
      float _533 = saturate(_532);
      float _534 = _533 * 0.4000000059604645f;
      float _535 = -0.0f - _242;
      float _536 = -0.0f - _243;
      float _537 = -0.0f - _244;
      float _538 = dot(float3(_161, _162, _163), float3(_535, _536, _537));
      float _539 = saturate(_538);
      float _540 = log2(_539);
      float _541 = _540 * 7.0f;
      float _542 = exp2(_541);
      float _543 = _542 + _534;
      float _544 = saturate(_543);
      float _545 = _544 * _528;
      float _546 = _545 * _351;
      float _547 = _545 * _352;
      float _548 = _545 * _353;
      float _549 = abs(_351);
      float _550 = abs(_352);
      float _551 = abs(_353);
      float _552 = sqrt(_549);
      float _553 = sqrt(_550);
      float _554 = sqrt(_551);
      float _555 = 1.0f - _552;
      float _556 = 1.0f - _553;
      float _557 = 1.0f - _554;
      float _558 = _309 * 5.55472993850708f;
      float _559 = -6.983160018920898f - _558;
      float _560 = _559 * _309;
      float _561 = exp2(_560);
      float _562 = _561 * _555;
      float _563 = _561 * _556;
      float _564 = _557 * _561;
      float _565 = _562 + _552;
      float _566 = _563 + _553;
      float _567 = _564 + _554;
      float _568 = _305 + _303;
      float _569 = _305 * _303;
      float _570 = _568 - _569;
      float _571 = _570 * 4.0f;
      float _572 = _571 + 9.999999682655225e-21f;
      float _573 = 1.0f / _572;
      float _574 = 0.5f / _362;
      float _575 = _307 * _307;
      float _576 = 1.0f - _575;
      float _577 = _574 + 1.0f;
      float _578 = log2(_576);
      float _579 = _578 * _574;
      float _580 = exp2(_579);
      float _581 = _577 * _573;
      float _582 = _581 * _580;
      float _583 = _146 * _303;
      float _584 = _565 * _583;
      float _585 = _584 * _582;
      float _586 = _566 * _583;
      float _587 = _586 * _582;
      float _588 = _567 * _583;
      float _589 = _588 * _582;
      float _590 = _546 - _516;
      float _591 = _590 + _585;
      float _592 = _547 - _517;
      float _593 = _592 + _587;
      float _594 = _548 - _518;
      float _595 = _594 + _589;
      float _596 = _591 * _527;
      float _597 = _593 * _527;
      float _598 = _595 * _527;
      float _599 = _596 + _519;
      float _600 = _597 + _520;
      float _601 = _598 + _521;
      _603 = _599;
      _604 = _600;
      _605 = _601;
    } else {
      _603 = _519;
      _604 = _520;
      _605 = _521;
    }
    float _606 = _603 * _234;
    float _607 = _604 * _235;
    float _608 = _605 * _236;
    float _609 = min(_606, 1000.0f);
    float _610 = min(_607, 1000.0f);
    float _611 = min(_608, 1000.0f);
    bool _612 = MaterialIdEquals(_73.w, 0.007843137718737125f);
    bool _613 = (_21 < 3.0f);
    bool _614 = _613 && _612;
    [branch]
    if (_614) {
      float _616 = _21 + -2.0f;
      float _617 = max(_616, 0.0f);
      float _622 = 1.0f - g_xSubsurfaceScatteringWeight.x;
      float _623 = 1.0f - g_xSubsurfaceScatteringWeight.y;
      float _624 = 1.0f - g_xSubsurfaceScatteringWeight.z;
      float _625 = _622 * _617;
      float _626 = _623 * _617;
      float _627 = _624 * _617;
      float _628 = _625 + g_xSubsurfaceScatteringWeight.x;
      float _629 = _626 + g_xSubsurfaceScatteringWeight.y;
      float _630 = _627 + g_xSubsurfaceScatteringWeight.z;
      float _631 = _628 * _609;
      float _632 = _629 * _610;
      float _633 = _630 * _611;
      _635 = true;
      _636 = _631;
      _637 = _632;
      _638 = _633;
    } else {
      _635 = true;
      _636 = _609;
      _637 = _610;
      _638 = _611;
    }
  } else {
    _635 = false;
    _636 = 0.0f;
    _637 = 0.0f;
    _638 = 0.0f;
  }
  [branch]
  if (!_635) {
    if (true) discard;
  }
  SV_Target.x = _636;
  SV_Target.y = _637;
  SV_Target.z = _638;
  SV_Target.w = 1.0f;
  return SV_Target;
}
