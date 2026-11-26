#include "./shared.h"

Texture2D<float4> g_xLighting_NormalBuffer : register(t2);

Texture2D<float4> g_xLighting_AlbedoBuffer : register(t3);

Texture2D<float4> g_xLighting_PBRPropertiesBuffer : register(t4);

Texture2D<float4> g_xLighting_DepthStencil : register(t5);

Texture2D<float4> g_xReflectionMap : register(t7);

TextureCubeArray<float4> g_axCubeMaps : register(t8);

struct CubemapData {
  float4 a[4];
  float4 b[4];
  float3 c;
  float d;
};

StructuredBuffer<CubemapData> g_axCubemapDatas : register(t9);

RWTexture2D<float4> g_xLightingUAV : register(u0);

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

cbuffer ApplyStaticLightingParams : register(b4) {
  float g_fReflectionMips : packoffset(c000.x);
  float g_fSkyboxThreshold : packoffset(c000.y);
  int g_bDisableLighting : packoffset(c000.z);
  uint g_uNumberOfCubemaps : packoffset(c000.w);
  float4 g_xFrustumConst1 : packoffset(c001.x);
  float4 g_xFrustumConst2 : packoffset(c002.x);
  float m_fInternalSunStrength : packoffset(c003.x);
  float m_fExternalSunStrength : packoffset(c003.y);
  int m_bDesaturateDarkAreas : packoffset(c003.z);
};

SamplerState g_xTrilinearClamp : register(s5);

[numthreads(8, 8, 1)]
void main(
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
  float _14 = float((uint)SV_DispatchThreadID.x);
  float _15 = float((uint)SV_DispatchThreadID.y);
  float _16 = _14 + 0.5f;
  float _17 = _15 + 0.5f;
  bool _20 = (g_bDisableLighting == 0);
  float _160;
  float _161;
  float _162;
  float _181;
  float _182;
  float _183;
  float _184;
  float _334;
  float _335;
  float _336;
  float _360;
  float _361;
  float _362;
  float _491;
  float _492;
  float _493;
  float _494;
  float _495;
  float _496;
  float _517;
  float _518;
  float _519;
  float _549;
  float _550;
  float _551;
  [branch]
  if (!_20) {
    int _22 = int(_16);
    int _23 = int(_17);
    float4 _24 = g_xLighting_AlbedoBuffer.Load(int3(_22, _23, 0));
    g_xLightingUAV[int2((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y))] = float4(_24.x, _24.y, _24.z, 1.0f);
  } else {
    int _29 = int(_14);
    int _30 = int(_15);
    float4 _31 = g_xLighting_DepthStencil.Load(int3(_29, _30, 0));
    float _36 = g_xDepthProjViewUnpack.y - _31.x;
    float _37 = g_xDepthProjViewUnpack.x / _36;
    float4 _38 = g_xLightingUAV.Load(int2((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y)));
    bool _45 = (_37 > g_fSkyboxThreshold);
    [branch]
    if (!_45) {
      float4 _47 = g_xLighting_NormalBuffer.Load(int3(_29, _30, 0));
      float4 _52 = g_xLighting_AlbedoBuffer.Load(int3(_29, _30, 0));
      float4 _57 = g_xLighting_PBRPropertiesBuffer.Load(int3(_29, _30, 0));
      float _62 = _47.x * 2.0f;
      float _63 = _47.y * 2.0f;
      float _64 = _47.z * 2.0f;
      float _65 = _62 + -1.0f;
      float _66 = _63 + -1.0f;
      float _67 = _64 + -1.0f;
      float _68 = dot(float3(_65, _66, _67), float3(_65, _66, _67));
      float _69 = rsqrt(_68);
      float _70 = _69 * _65;
      float _71 = _69 * _66;
      float _72 = _69 * _67;
      float _73 = _57.z * 2.0f;
      float _74 = _57.w * 2.0f;
      float _75 = _73 + -1.0f;
      float _76 = _74 + -1.0f;
      float _77 = dot(float2(_75, _76), float2(_75, _76));
      float _78 = 1.0f - _77;
      float _79 = saturate(_78);
      float _80 = sqrt(_79);
      bool _81 = (_47.w != 0.0f);
      float _82 = -0.0f - _80;
      float _83 = select(_81, _80, _82);
      float _84 = abs(_38.w);
      bool _85 = (_38.w < 0.0f);
      float _89 = select(_85, m_fInternalSunStrength, m_fExternalSunStrength);
      float _93 = g_xCameraTanHalfFOV.x * _37;
      float _94 = g_xCameraTanHalfFOV.y * _37;
      float _98 = g_xTwoOverScreenDimensions.z + _16;
      float _99 = g_xTwoOverScreenDimensions.w + _17;
      float _102 = _98 * g_xTwoOverScreenDimensions.x;
      float _103 = _99 * g_xTwoOverScreenDimensions.y;
      float _104 = _102 + -1.0f;
      float _105 = _103 + -1.0f;
      float _106 = _93 * _104;
      float _107 = _94 * _105;
      float _124 = _106 * (g_xInvView[0].x);
      float _125 = mad((g_xInvView[1].x), _107, _124);
      float _126 = mad((g_xInvView[2].x), _37, _125);
      float _127 = _126 + (g_xInvView[3].x);
      float _128 = _106 * (g_xInvView[0].y);
      float _129 = mad((g_xInvView[1].y), _107, _128);
      float _130 = mad((g_xInvView[2].y), _37, _129);
      float _131 = _130 + (g_xInvView[3].y);
      float _132 = _106 * (g_xInvView[0].z);
      float _133 = mad((g_xInvView[1].z), _107, _132);
      float _134 = mad((g_xInvView[2].z), _37, _133);
      float _135 = _134 + (g_xInvView[3].z);
      float _140 = g_xCamPos.x - _127;
      float _141 = g_xCamPos.y - _131;
      float _142 = g_xCamPos.z - _135;
      float _143 = dot(float3(_140, _141, _142), float3(_140, _141, _142));
      float _144 = rsqrt(_143);
      float _145 = _140 * _144;
      float _146 = _141 * _144;
      float _147 = _142 * _144;
      // RenoDX: tolerant material-ID compares (MaterialIdEquals, shared.h)
      bool _148 = !MaterialIdEquals(_52.w, 0.01568627543747425f);
      [branch]
      if (_148) {
        bool _150 = (_47.w != 1.0f);
        [branch]
        if (_150) {
          float _152 = dot(float3(_70, _71, _72), float3(_75, _76, _83));
          float _153 = saturate(_152);
          float _154 = _153 * 3.0f;
          float _155 = _154 + 1.0f;
          float _156 = _155 * _38.x;
          float _157 = _155 * _38.y;
          float _158 = _155 * _38.z;
          _160 = _156;
          _161 = _157;
          _162 = _158;
        } else {
          _160 = _38.x;
          _161 = _38.y;
          _162 = _38.z;
        }
        bool _164 = (g_fReflectionMips > 0.0f);
        [branch]
        if (_164) {
          float _166 = _57.y * 2.0f;
          float _167 = _166 + 1.0f;
          float _168 = log2(_167);
          float _169 = _168 * g_fReflectionMips;
          float _170 = min(_169, g_fReflectionMips);
          float _173 = g_xRcpScreenDims.x * _16;
          float _174 = g_xRcpScreenDims.y * _17;
          float4 _175 = g_xReflectionMap.SampleLevel(g_xTrilinearClamp, float2(_173, _174), _170);
          _181 = _175.x;
          _182 = _175.y;
          _183 = _175.z;
          _184 = _175.w;
        } else {
          _181 = 0.0f;
          _182 = 0.0f;
          _183 = 0.0f;
          _184 = 0.0f;
        }
        bool _187 = (g_uNumberOfCubemaps == 0);
        [branch]
        if (!_187) {
          int _189 = (int)(uint)(_85);
          uint _190 = (int)(g_uNumberOfCubemaps) + -1u;
          int _191 = min(_190, _189);
          float _192 = -0.0f - _145;
          float _193 = -0.0f - _146;
          float _194 = -0.0f - _147;
          float _195 = dot(float3(_192, _193, _194), float3(_70, _71, _72));
          float _196 = _195 * 2.0f;
          float _197 = _196 * _70;
          float _198 = _196 * _71;
          float _199 = _196 * _72;
          float _200 = _192 - _197;
          float _201 = _193 - _198;
          float _202 = _194 - _199;
          float _203 = _57.y * 6.0f;
          float4 _204 = g_axCubemapDatas[_191].a[0];
          float4 _208 = g_axCubemapDatas[_191].a[1];
          float4 _212 = g_axCubemapDatas[_191].a[2];
          float4 _216 = g_axCubemapDatas[_191].a[3];
          float _220 = _204.x * _127;
          float _221 = mad(_208.x, _131, _220);
          float _222 = mad(_212.x, _135, _221);
          float _223 = _222 + _216.x;
          float _224 = _204.y * _127;
          float _225 = mad(_208.y, _131, _224);
          float _226 = mad(_212.y, _135, _225);
          float _227 = _226 + _216.y;
          float _228 = _204.z * _127;
          float _229 = mad(_208.z, _131, _228);
          float _230 = mad(_212.z, _135, _229);
          float _231 = _230 + _216.z;
          float _232 = _204.x * _200;
          float _233 = mad(_208.x, _201, _232);
          float _234 = mad(_212.x, _202, _233);
          float _235 = _204.y * _200;
          float _236 = mad(_208.y, _201, _235);
          float _237 = mad(_212.y, _202, _236);
          float _238 = _204.z * _200;
          float _239 = mad(_208.z, _201, _238);
          float _240 = mad(_212.z, _202, _239);
          bool _241 = (_234 < 0.0f);
          bool _242 = (_237 < 0.0f);
          bool _243 = (_240 < 0.0f);
          float _244 = float((bool)_241);
          float _245 = float((bool)_242);
          float _246 = float((bool)_243);
          float _247 = _244 * 2.0f;
          float _248 = _245 * 2.0f;
          float _249 = _246 * 2.0f;
          float _250 = 1.0f - _247;
          float _251 = 1.0f - _248;
          float _252 = 1.0f - _249;
          float _253 = abs(_234);
          float _254 = abs(_237);
          float _255 = abs(_240);
          float _256 = _253 + 1.000000013351432e-10f;
          float _257 = _254 + 1.000000013351432e-10f;
          float _258 = _255 + 1.000000013351432e-10f;
          float _259 = 1.0f / _256;
          float _260 = 1.0f / _257;
          float _261 = 1.0f / _258;
          float _262 = _259 * _250;
          float _263 = _260 * _251;
          float _264 = _261 * _252;
          float _265 = 1.0f - _223;
          float _266 = 1.0f - _227;
          float _267 = 1.0f - _231;
          float _268 = _262 * _265;
          float _269 = _263 * _266;
          float _270 = _264 * _267;
          float _271 = -1.0f - _223;
          float _272 = -1.0f - _227;
          float _273 = -1.0f - _231;
          float _274 = _262 * _271;
          float _275 = _263 * _272;
          float _276 = _264 * _273;
          float _277 = max(_268, _274);
          float _278 = max(_269, _275);
          float _279 = max(_270, _276);
          float _280 = min(_278, _279);
          float _281 = min(_277, _280);
          float _282 = _281 * _234;
          float _283 = _281 * _237;
          float _284 = _281 * _240;
          float _285 = _282 + _223;
          float _286 = _227 + _283;
          float _287 = _284 + _231;
          float3 _288 = g_axCubemapDatas[_191].c;
          float _292 = _285 - _288.x;
          float _293 = _286 - _288.y;
          float _294 = _287 - _288.z;
          float _295 = -0.0f - _293;
          float4 _296 = g_axCubemapDatas[_191].b[0];
          float4 _300 = g_axCubemapDatas[_191].b[1];
          float4 _304 = g_axCubemapDatas[_191].b[2];
          float _308 = _296.x * _292;
          float _309 = mad(_300.x, _295, _308);
          float _310 = mad(_304.x, _294, _309);
          float _311 = _296.y * _292;
          float _312 = mad(_300.y, _295, _311);
          float _313 = mad(_304.y, _294, _312);
          float _314 = _296.z * _292;
          float _315 = mad(_300.z, _295, _314);
          float _316 = mad(_304.z, _294, _315);
          float _317 = float((uint)_191);
          float4 _318 = g_axCubeMaps.SampleLevel(g_xTrilinearClamp, float4(_310, _313, _316, _317), _203);
          float4 _322 = g_axCubeMaps.SampleLevel(g_xTrilinearClamp, float4(_310, _313, _316, _317), 6.0f);
          float _326 = dot(float3(_322.x, _322.y, _322.z), float3(0.30000001192092896f, 0.5899999737739563f, 0.10999999940395355f));
          float _327 = max(0.009999999776482582f, _326);
          float _328 = _84 / _327;
          float _329 = saturate(_328);
          float _330 = _329 * _318.x;
          float _331 = _329 * _318.y;
          float _332 = _329 * _318.z;
          _334 = _330;
          _335 = _331;
          _336 = _332;
        } else {
          _334 = 0.0f;
          _335 = 0.0f;
          _336 = 0.0f;
        }
        float _337 = _181 - _334;
        float _338 = _182 - _335;
        float _339 = _183 - _336;
        float _340 = _337 * _184;
        float _341 = _338 * _184;
        float _342 = _339 * _184;
        float _343 = _340 + _334;
        float _344 = _341 + _335;
        float _345 = _342 + _336;
        bool _346 = MaterialIdEquals(_52.w, 0.007843137718737125f);
        [branch]
        if (!_346) {
          bool _348 = !MaterialIdEquals(_52.w, 0.019607843831181526f);
          float _349 = select(_348, _57.x, 0.0f);
          float _350 = _52.x + -0.03999999910593033f;
          float _351 = _52.y + -0.03999999910593033f;
          float _352 = _52.z + -0.03999999910593033f;
          float _353 = _349 * _350;
          float _354 = _349 * _351;
          float _355 = _349 * _352;
          float _356 = _353 + 0.03999999910593033f;
          float _357 = _354 + 0.03999999910593033f;
          float _358 = _355 + 0.03999999910593033f;
          _360 = _356;
          _361 = _357;
          _362 = _358;
        } else {
          _360 = 0.02800000086426735f;
          _361 = 0.02800000086426735f;
          _362 = 0.02800000086426735f;
        }
        float _363 = dot(float3(_70, _71, _72), float3(_145, _146, _147));
        float _364 = saturate(_363);
        float _365 = _57.y * _57.y;
        float _366 = _365 * 0.027499999850988388f;
        float _367 = _365 * 0.5720000267028809f;
        float _368 = _365 * 0.02199999988079071f;
        float _369 = 1.0f - _365;
        float _370 = 0.042500000447034836f - _366;
        float _371 = 1.0399999618530273f - _367;
        float _372 = _368 + -0.03999999910593033f;
        float _373 = _364 * -9.279999732971191f;
        float _374 = exp2(_373);
        float _375 = _369 * _369;
        float _376 = min(_375, _374);
        float _377 = _376 * _369;
        float _378 = _377 + _370;
        float _379 = _378 * 1.0399999618530273f;
        float _380 = _371 - _379;
        float _381 = _372 + _379;
        float _382 = _380 * _360;
        float _383 = _380 * _361;
        float _384 = _380 * _362;
        float _385 = _382 + _381;
        float _386 = _383 + _381;
        float _387 = _384 + _381;
        float _388 = _385 * _343;
        float _389 = _386 * _344;
        float _390 = _387 * _345;
        _491 = _160;
        _492 = _161;
        _493 = _162;
        _494 = _388;
        _495 = _389;
        _496 = _390;
      } else {
        float _392 = 1.0f - _57.y;
        float _393 = saturate(_392);
        float _394 = dot(float3(_52.x, _52.y, _52.z), float3(0.30000001192092896f, 0.5899999737739563f, 0.10999999940395355f));
        float _395 = _57.x * 0.6000000238418579f;
        float _396 = _395 + -0.3500000238418579f;
        float _397 = _395 + -0.25f;
        float _398 = _393 * 0.05000000074505806f;
        float _399 = _397 - _398;
        float _400 = log2(_393);
        float _401 = _400 * 8.0f;
        float _402 = exp2(_401);
        float _403 = _402 * 500.0f;
        float _404 = _403 + 20.0f;
        float _405 = _400 * 6.0f;
        float _406 = exp2(_405);
        float _407 = _406 * 2000.0f;
        float _408 = _407 + 50.0f;
        float _409 = _57.x * 0.13500000536441803f;
        float _410 = _409 + 0.015000000596046448f;
        float _411 = _393 + 0.10000000149011612f;
        float _412 = _57.x * 0.007499999832361937f;
        float _413 = _412 + 0.007499999832361937f;
        float _414 = _396 * _70;
        float _415 = _396 * _71;
        float _416 = _396 * _72;
        float _417 = _414 + _75;
        float _418 = _415 + _76;
        float _419 = _83 + _416;
        float _420 = dot(float3(_417, _418, _419), float3(_417, _418, _419));
        float _421 = rsqrt(_420);
        float _422 = _421 * _417;
        float _423 = _421 * _418;
        float _424 = _421 * _419;
        float _425 = dot(float3(_422, _423, _424), float3(_145, _146, _147));
        float _426 = _425 * _425;
        float _427 = 1.0f - _426;
        float _428 = saturate(_427);
        float _429 = sqrt(_428);
        float _430 = _425 + 1.0f;
        float _431 = saturate(_430);
        float _432 = _431 * 2.0f;
        float _433 = 3.0f - _432;
        float _434 = log2(_429);
        float _435 = _434 * _404;
        float _436 = exp2(_435);
        float _437 = _402 * 19.89436912536621f;
        float _438 = _437 + 1.1140847206115723f;
        float _439 = _411 * _410;
        float _440 = _439 * _438;
        float _441 = _431 * _431;
        float _442 = _441 * _440;
        float _443 = _442 * _433;
        float _444 = _443 * _436;
        float _445 = max(_394, 0.0010000000474974513f);
        float _446 = _52.x / _445;
        float _447 = _52.y / _445;
        float _448 = _52.z / _445;
        float _449 = _444 * _446;
        float _450 = _444 * _447;
        float _451 = _444 * _448;
        float _452 = _399 * _70;
        float _453 = _399 * _71;
        float _454 = _399 * _72;
        float _455 = _452 + _75;
        float _456 = _453 + _76;
        float _457 = _454 + _83;
        float _458 = dot(float3(_455, _456, _457), float3(_455, _456, _457));
        float _459 = rsqrt(_458);
        float _460 = _459 * _455;
        float _461 = _459 * _456;
        float _462 = _459 * _457;
        float _463 = dot(float3(_460, _461, _462), float3(_145, _146, _147));
        float _464 = _463 * _463;
        float _465 = 1.0f - _464;
        float _466 = saturate(_465);
        float _467 = sqrt(_466);
        float _468 = _463 + 1.0f;
        float _469 = saturate(_468);
        float _470 = _469 * 2.0f;
        float _471 = 3.0f - _470;
        float _472 = log2(_467);
        float _473 = _472 * _408;
        float _474 = exp2(_473);
        float _475 = _406 * 79.57747650146484f;
        float _476 = _475 + 2.3077468872070312f;
        float _477 = _393 * _413;
        float _478 = _477 * _476;
        float _479 = _469 * _469;
        float _480 = _479 * _478;
        float _481 = _480 * _471;
        float _482 = _481 * _474;
        float _483 = _482 + _449;
        float _484 = _482 + _450;
        float _485 = _482 + _451;
        float _486 = _84 * 0.5f;
        float _487 = _486 * _483;
        float _488 = _486 * _484;
        float _489 = _486 * _485;
        _491 = _38.x;
        _492 = _38.y;
        _493 = _38.z;
        _494 = _487;
        _495 = _488;
        _496 = _489;
      }
      bool _499 = (m_bDesaturateDarkAreas == 0);
      [branch]
      if (!_499) {
        float _501 = dot(float3(_491, _492, _493), float3(0.30000001192092896f, 0.5899999737739563f, 0.10999999940395355f));
        bool _502 = (_501 < 1.0f);
        bool _503 = _85 && _502;
        [branch]
        if (_503) {
          float _505 = dot(float3(_52.x, _52.y, _52.z), float3(0.30000001192092896f, 0.5899999737739563f, 0.10999999940395355f));
          float _506 = _505 * 0.6000000238418579f;
          float _507 = _506 - _52.x;
          float _508 = _506 - _52.y;
          float _509 = _505 - _52.z;
          float _510 = _507 * 0.5f;
          float _511 = _508 * 0.5f;
          float _512 = _509 * 0.5f;
          float _513 = _510 + _52.x;
          float _514 = _511 + _52.y;
          float _515 = _512 + _52.z;
          _517 = _513;
          _518 = _514;
          _519 = _515;
        } else {
          _517 = _52.x;
          _518 = _52.y;
          _519 = _52.z;
        }
      } else {
        _517 = _52.x;
        _518 = _52.y;
        _519 = _52.z;
      }
      float _520 = _517 * _491;
      float _521 = _518 * _492;
      float _522 = _519 * _493;
      float _523 = _520 + _494;
      float _524 = _521 + _495;
      float _525 = _522 + _496;
      bool _526 = MaterialIdEquals(_52.w, 0.007843137718737125f);
      bool _527 = (_37 < 3.0f);
      bool _528 = _527 && _526;
      [branch]
      if (_528) {
        float _530 = _37 + -2.0f;
        float _531 = max(_530, 0.0f);
        float _536 = 1.0f - g_xSubsurfaceScatteringWeight.x;
        float _537 = 1.0f - g_xSubsurfaceScatteringWeight.y;
        float _538 = 1.0f - g_xSubsurfaceScatteringWeight.z;
        float _539 = _536 * _531;
        float _540 = _537 * _531;
        float _541 = _538 * _531;
        float _542 = _539 + g_xSubsurfaceScatteringWeight.x;
        float _543 = _540 + g_xSubsurfaceScatteringWeight.y;
        float _544 = _541 + g_xSubsurfaceScatteringWeight.z;
        float _545 = _542 * _523;
        float _546 = _543 * _524;
        float _547 = _544 * _525;
        _549 = _545;
        _550 = _546;
        _551 = _547;
      } else {
        _549 = _523;
        _550 = _524;
        _551 = _525;
      }
      g_xLightingUAV[int2((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y))] = float4(_549, _550, _551, _89);
    }
  }
}
