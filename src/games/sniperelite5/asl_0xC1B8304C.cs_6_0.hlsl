// Baseline: 2 fewer fmul fast (dxc reassociation of the specular product chains), loop canonicalization (extra br/phi, add nuw, icmp eq exit), commutative fadd order; otherwise identical to the original DXIL.
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


StructuredBuffer<float4> g_axCullingSpheres : register(t10);

groupshared float g_fMinDepth[64];
groupshared float g_fMaxDepth[64];
groupshared uint g_uCubemapSortedShortlistIndices[128];
groupshared uint g_uCubemapShortlistIndices[128];
groupshared uint g_uNumberOfCubemapsToUse;

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
  uint SV_GroupIndex : SV_GroupIndex
) {
  float _18 = float((uint)SV_DispatchThreadID.x);
  float _19 = float((uint)SV_DispatchThreadID.y);
  float _20 = _18 + 0.5f;
  float _21 = _19 + 0.5f;
  if (g_bDisableLighting != 0) {
    float4 _28 = g_xLighting_AlbedoBuffer.Load(int3(int(_20), int(_21), 0));
    g_xLightingUAV[int2((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y))] = float4(_28.x, _28.y, _28.z, 1.0f);
    return;
  }
  int _33 = int(_18);
  int _34 = int(_19);
  float4 _35 = g_xLighting_DepthStencil.Load(int3(_33, _34, 0));
  float _41 = g_xDepthProjViewUnpack.x / (g_xDepthProjViewUnpack.y - _35.x);
  if (SV_GroupIndex == 0) {
    g_uNumberOfCubemapsToUse = 0u;
  }
  g_fMinDepth[SV_GroupIndex] = _41;
  g_fMaxDepth[SV_GroupIndex] = _41;
  GroupMemoryBarrierWithGroupSync();
  {
    uint _o = (SV_GroupIndex + 32u) & 63u;
    g_fMaxDepth[SV_GroupIndex] = max(g_fMaxDepth[SV_GroupIndex], g_fMaxDepth[_o]);
    g_fMinDepth[SV_GroupIndex] = min(g_fMinDepth[SV_GroupIndex], g_fMinDepth[_o]);
    GroupMemoryBarrierWithGroupSync();
  }
  {
    uint _o = (SV_GroupIndex + 16u) & 63u;
    g_fMaxDepth[SV_GroupIndex] = max(g_fMaxDepth[SV_GroupIndex], g_fMaxDepth[_o]);
    g_fMinDepth[SV_GroupIndex] = min(g_fMinDepth[SV_GroupIndex], g_fMinDepth[_o]);
    GroupMemoryBarrierWithGroupSync();
  }
  {
    uint _o = (SV_GroupIndex + 8u) & 63u;
    g_fMaxDepth[SV_GroupIndex] = max(g_fMaxDepth[SV_GroupIndex], g_fMaxDepth[_o]);
    g_fMinDepth[SV_GroupIndex] = min(g_fMinDepth[SV_GroupIndex], g_fMinDepth[_o]);
    GroupMemoryBarrierWithGroupSync();
  }
  {
    uint _o = (SV_GroupIndex + 4u) & 63u;
    g_fMaxDepth[SV_GroupIndex] = max(g_fMaxDepth[SV_GroupIndex], g_fMaxDepth[_o]);
    g_fMinDepth[SV_GroupIndex] = min(g_fMinDepth[SV_GroupIndex], g_fMinDepth[_o]);
    GroupMemoryBarrierWithGroupSync();
  }
  {
    uint _o = (SV_GroupIndex + 2u) & 63u;
    g_fMaxDepth[SV_GroupIndex] = max(g_fMaxDepth[SV_GroupIndex], g_fMaxDepth[_o]);
    g_fMinDepth[SV_GroupIndex] = min(g_fMinDepth[SV_GroupIndex], g_fMinDepth[_o]);
    GroupMemoryBarrierWithGroupSync();
  }
  uint _98 = (SV_GroupIndex + 1u) & 63u;
  float _102 = max(g_fMaxDepth[SV_GroupIndex], g_fMaxDepth[_98]);
  float _106 = min(g_fMinDepth[SV_GroupIndex], g_fMinDepth[_98]);
  [branch]
  if (_106 < g_fSkyboxThreshold) {
    float _111 = float((uint)SV_GroupID.x);
    float _112 = float((uint)SV_GroupID.y);
    float _118 = g_xFrustumConst1.x * _111;
    float _119 = g_xFrustumConst1.y * _112;
    float _120 = g_xFrustumConst1.z * _111;
    float _121 = g_xFrustumConst1.w * _112;
    float _127 = _118 + g_xFrustumConst2.x;
    float _128 = _119 + g_xFrustumConst2.y;
    float _129 = _120 + g_xFrustumConst2.z;
    float _130 = _121 + g_xFrustumConst2.w;
    float _139 = min(_127 * _106, _127 * _102);
    float _140 = min(_128 * _106, _128 * _102);
    float _141 = max(_129 * _106, _129 * _102);
    float _142 = max(_130 * _106, _130 * _102);
    for (uint _147 = SV_GroupIndex; _147 < g_uNumberOfCubemaps; _147 += 64u) {
      float4 _148 = g_axCullingSpheres[_147];
      float _169 = g_xView[0].x * _148.x;
      float _170 = mad(g_xView[1].x, _148.y, _169);
      float _171 = mad(g_xView[2].x, _148.z, _170);
      float _172 = _171 + g_xView[3].x;
      float _173 = g_xView[0].y * _148.x;
      float _174 = mad(g_xView[1].y, _148.y, _173);
      float _175 = mad(g_xView[2].y, _148.z, _174);
      float _176 = _175 + g_xView[3].y;
      float _177 = g_xView[0].z * _148.x;
      float _178 = mad(g_xView[1].z, _148.y, _177);
      float _179 = mad(g_xView[2].z, _148.z, _178);
      float _180 = _179 + g_xView[3].z;
      float _187 = min(max(_172, _139), _141) - _172;
      float _188 = min(max(_176, _140), _142) - _176;
      float _189 = min(max(_180, _106), _102) - _180;
      float _190 = dot(float3(_187, _188, _189), float3(_187, _188, _189));
      [branch]
      if (_190 < _148.w) {
        uint _193;
        InterlockedAdd(g_uNumberOfCubemapsToUse, 1u, _193);
        g_uCubemapShortlistIndices[_193] = _147;
      }
    }
  }
  GroupMemoryBarrierWithGroupSync();
  uint _204 = g_uNumberOfCubemapsToUse;
  [branch]
  if ((_106 < g_fSkyboxThreshold) & (SV_GroupIndex < _204)) {
    for (uint _208 = SV_GroupIndex; _208 < _204; _208 += 64u) {
      uint _210 = g_uCubemapShortlistIndices[_208];
      uint _225 = 0u;
      for (uint _214 = 0u; _214 < _204; _214++) {
        [branch]
        if (g_uCubemapShortlistIndices[_214] > _210) {
          _225++;
        }
      }
      g_uCubemapSortedShortlistIndices[_225] = _210;
    }
  }
  GroupMemoryBarrierWithGroupSync();
  float4 _38 = g_xLightingUAV.Load(int2((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y)));
  [branch]
  if (_41 > g_fSkyboxThreshold) {
    return;
  }
  float4 _47 = g_xLighting_NormalBuffer.Load(int3(_33, _34, 0));
  float4 _52 = g_xLighting_AlbedoBuffer.Load(int3(_33, _34, 0));
  float4 _57 = g_xLighting_PBRPropertiesBuffer.Load(int3(_33, _34, 0));
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
  float _93 = g_xCameraTanHalfFOV.x * _41;
  float _94 = g_xCameraTanHalfFOV.y * _41;
  float _98b = g_xTwoOverScreenDimensions.z + _20;
  float _99 = g_xTwoOverScreenDimensions.w + _21;
  float _102b = _98b * g_xTwoOverScreenDimensions.x;
  float _103 = _99 * g_xTwoOverScreenDimensions.y;
  float _104 = _102b + -1.0f;
  float _105 = _103 + -1.0f;
  float _106b = _93 * _104;
  float _107 = _94 * _105;
  float _124 = _106b * (g_xInvView[0].x);
  float _125 = mad((g_xInvView[1].x), _107, _124);
  float _126 = mad((g_xInvView[2].x), _41, _125);
  float _127b = _126 + (g_xInvView[3].x);
  float _128b = _106b * (g_xInvView[0].y);
  float _129b = mad((g_xInvView[1].y), _107, _128b);
  float _130b = mad((g_xInvView[2].y), _41, _129b);
  float _131 = _130b + (g_xInvView[3].y);
  float _132 = _106b * (g_xInvView[0].z);
  float _133 = mad((g_xInvView[1].z), _107, _132);
  float _134 = mad((g_xInvView[2].z), _41, _133);
  float _135 = _134 + (g_xInvView[3].z);
  float _140b = g_xCamPos.x - _127b;
  float _141b = g_xCamPos.y - _131;
  float _142b = g_xCamPos.z - _135;
  float _143 = dot(float3(_140b, _141b, _142b), float3(_140b, _141b, _142b));
  float _144 = rsqrt(_143);
  float _145 = _140b * _144;
  float _146 = _141b * _144;
  float _147b = _142b * _144;
  float _160, _161, _162;
  float _494, _495, _496;
  // RenoDX: tolerant material-ID compares (MaterialIdEquals, shared.h)
  if (!MaterialIdEquals(_52.w, 0.01568627543747425f)) {
    float _352 = _38.x;
    float _353 = _38.y;
    float _354 = _38.z;
    if (_47.w != 1.0f) {
      float _344 = dot(float3(_70, _71, _72), float3(_75, _76, _83));
      float _345 = saturate(_344);
      float _346 = _345 * 3.0f;
      float _347 = _346 + 1.0f;
      _352 = _347 * _38.x;
      _353 = _347 * _38.y;
      _354 = _347 * _38.z;
    }
    _160 = _352;
    _161 = _353;
    _162 = _354;
    float4 _refl = float4(0.0f, 0.0f, 0.0f, 0.0f);
    if (g_fReflectionMips > 0.0f) {
      float _359 = _57.y * 2.0f;
      float _360 = _359 + 1.0f;
      float _361 = log2(_360);
      float _362 = _361 * g_fReflectionMips;
      float _363 = min(_362, g_fReflectionMips);
      float _366 = g_xRcpScreenDims.x * _20;
      float _367 = g_xRcpScreenDims.y * _21;
      _refl = g_xReflectionMap.SampleLevel(g_xTrilinearClamp, float2(_366, _367), _363);
    }
    float _378 = -0.0f - _145;
    float _379 = -0.0f - _146;
    float _380 = -0.0f - _147b;
    float _381 = dot(float3(_378, _379, _380), float3(_70, _71, _72));
    float _382 = _381 * 2.0f;
    float _383 = _382 * _70;
    float _384 = _382 * _71;
    float _385 = _382 * _72;
    float _386 = _378 - _383;
    float _387 = _379 - _384;
    float _388 = _380 - _385;
    float _389 = _57.y * 6.0f;
    uint _390 = g_uNumberOfCubemapsToUse;
    float3 _acc = float3(0.0f, 0.0f, 0.0f);
    float _rem = 1.0f;
    for (uint _397 = 0u; _397 < _390; _397++) {
      uint _399 = g_uCubemapSortedShortlistIndices[_397];
      float4 _a0 = g_axCubemapDatas[_399].a[0];
      float4 _a1 = g_axCubemapDatas[_399].a[1];
      float4 _a2 = g_axCubemapDatas[_399].a[2];
      float4 _a3 = g_axCubemapDatas[_399].a[3];
      float _416 = _a0.x * _127b;
      float _417 = mad(_a1.x, _131, _416);
      float _418 = mad(_a2.x, _135, _417);
      float _419 = _418 + _a3.x;
      float _420 = _a0.y * _127b;
      float _421 = mad(_a1.y, _131, _420);
      float _422 = mad(_a2.y, _135, _421);
      float _423 = _422 + _a3.y;
      float _424 = _a0.z * _127b;
      float _425 = mad(_a1.z, _131, _424);
      float _426 = mad(_a2.z, _135, _425);
      float _427 = _426 + _a3.z;
      bool _435 = (abs(_419) < 1.0f) & (abs(_423) < 1.0f) & (abs(_427) < 1.0f);
      if (_435) {
        float _437 = _a0.x * _386;
        float _438 = mad(_a1.x, _387, _437);
        float _439 = mad(_a2.x, _388, _438);
        float _440 = _a0.y * _386;
        float _441 = mad(_a1.y, _387, _440);
        float _442 = mad(_a2.y, _388, _441);
        float _443 = _a0.z * _386;
        float _444 = mad(_a1.z, _387, _443);
        float _445 = mad(_a2.z, _388, _444);
        float _449 = float((bool)(_439 < 0.0f));
        float _450 = float((bool)(_442 < 0.0f));
        float _451 = float((bool)(_445 < 0.0f));
        float _452 = _449 * 2.0f;
        float _453 = _450 * 2.0f;
        float _454 = _451 * 2.0f;
        float _455 = 1.0f - _452;
        float _456 = 1.0f - _453;
        float _457 = 1.0f - _454;
        float _461 = abs(_439) + 1.000000013351432e-10f;
        float _462 = abs(_442) + 1.000000013351432e-10f;
        float _463 = abs(_445) + 1.000000013351432e-10f;
        float _464 = 1.0f / _461;
        float _465 = 1.0f / _462;
        float _466 = 1.0f / _463;
        float _467 = _464 * _455;
        float _468 = _465 * _456;
        float _469 = _466 * _457;
        float _470 = 1.0f - _419;
        float _471 = 1.0f - _423;
        float _472 = 1.0f - _427;
        float _473 = _467 * _470;
        float _474 = _468 * _471;
        float _475 = _469 * _472;
        float _476 = -1.0f - _419;
        float _477 = -1.0f - _423;
        float _478 = -1.0f - _427;
        float _479 = _467 * _476;
        float _480 = _468 * _477;
        float _481 = _469 * _478;
        float _482 = max(_473, _479);
        float _483 = max(_474, _480);
        float _484 = max(_475, _481);
        float _485 = min(_483, _484);
        float _486 = min(_482, _485);
        float _487 = _486 * _439;
        float _488 = _486 * _442;
        float _489 = _486 * _445;
        float _490 = _487 + _419;
        float _491 = _423 + _488;
        float _492 = _489 + _427;
        float3 _494c = g_axCubemapDatas[_399].c;
        float _497 = _490 - _494c.x;
        float _498 = _491 - _494c.y;
        float _499 = _492 - _494c.z;
        float _500 = -0.0f - _498;
        float4 _b0 = g_axCubemapDatas[_399].b[0];
        float4 _b1 = g_axCubemapDatas[_399].b[1];
        float4 _b2 = g_axCubemapDatas[_399].b[2];
        float _513 = _b0.x * _497;
        float _514 = mad(_b1.x, _500, _513);
        float _515 = mad(_b2.x, _499, _514);
        float _516 = _b0.y * _497;
        float _517 = mad(_b1.y, _500, _516);
        float _518 = mad(_b2.y, _499, _517);
        float _519 = _b0.z * _497;
        float _520 = mad(_b1.z, _500, _519);
        float _521 = mad(_b2.z, _499, _520);
        float _522 = float((uint)_399);
        float4 _523 = g_axCubeMaps.SampleLevel(g_xTrilinearClamp, float4(_515, _518, _521, _522), _389);
        float4 _528 = g_axCubeMaps.SampleLevel(g_xTrilinearClamp, float4(_515, _518, _521, _522), 6.0f);
        float _532 = dot(float3(_528.x, _528.y, _528.z), float3(0.30000001192092896f, 0.5899999737739563f, 0.10999999940395355f));
        float _533 = max(0.009999999776482582f, _532);
        float _534 = _84 / _533;
        float _535 = saturate(_534);
        float _536 = _523.w * _rem;
        float _537 = _536 * _523.x;
        float _538 = _537 * _535;
        float _539 = _536 * _523.y;
        float _540 = _539 * _535;
        float _541 = _536 * _523.z;
        float _542 = _541 * _535;
        _acc.x = _538 + _acc.x;
        _acc.y = _540 + _acc.y;
        _acc.z = _542 + _acc.z;
        float _546 = 1.0f - _523.w;
        _rem = _546 * _rem;
        if (_rem <= 0.009999999776482582f) {
          break;
        }
      }
    }
    float _560 = _refl.x - _acc.x;
    float _561 = _refl.y - _acc.y;
    float _562 = _refl.z - _acc.z;
    float _563 = _560 * _refl.w;
    float _564 = _561 * _refl.w;
    float _565 = _562 * _refl.w;
    float _566 = _563 + _acc.x;
    float _567 = _564 + _acc.y;
    float _568 = _565 + _acc.z;
    float _583, _584, _585;
    if (MaterialIdEquals(_52.w, 0.007843137718737125f)) {
      _583 = 0.02800000086426735f;
      _584 = 0.02800000086426735f;
      _585 = 0.02800000086426735f;
    } else {
      float _572 = select(!MaterialIdEquals(_52.w, 0.019607843831181526f), _57.x, 0.0f);
      float _573 = _52.x + -0.03999999910593033f;
      float _574 = _52.y + -0.03999999910593033f;
      float _575 = _52.z + -0.03999999910593033f;
      float _576 = _572 * _573;
      float _577 = _572 * _574;
      float _578 = _572 * _575;
      _583 = _576 + 0.03999999910593033f;
      _584 = _577 + 0.03999999910593033f;
      _585 = _578 + 0.03999999910593033f;
    }
    float _586 = dot(float3(_70, _71, _72), float3(_145, _146, _147b));
    float _587 = saturate(_586);
    float _588 = _57.y * _57.y;
    float _589 = _588 * 0.027499999850988388f;
    float _590 = _588 * 0.5720000267028809f;
    float _591 = _588 * 0.02199999988079071f;
    float _592 = 1.0f - _588;
    float _593 = 0.042500000447034836f - _589;
    float _594 = 1.0399999618530273f - _590;
    float _595 = _591 + -0.03999999910593033f;
    float _596 = _587 * -9.279999732971191f;
    float _597 = exp2(_596);
    float _598 = _592 * _592;
    float _599 = min(_598, _597);
    float _600 = _599 * _592;
    float _601 = _600 + _593;
    float _602 = _601 * 1.0399999618530273f;
    float _603 = _594 - _602;
    float _604 = _595 + _602;
    float _605 = _603 * _583;
    float _606 = _603 * _584;
    float _607 = _603 * _585;
    float _608 = _605 + _604;
    float _609 = _606 + _604;
    float _610 = _607 + _604;
    _494 = _608 * _566;
    _495 = _609 * _567;
    _496 = _610 * _568;
  } else {
    float _615 = 1.0f - _57.y;
    float _616 = saturate(_615);
    float _617 = dot(float3(_52.x, _52.y, _52.z), float3(0.30000001192092896f, 0.5899999737739563f, 0.10999999940395355f));
    float _618 = _57.x * 0.6000000238418579f;
    float _619 = _618 + -0.3500000238418579f;
    float _620 = _618 + -0.25f;
    float _621 = _616 * 0.05000000074505806f;
    float _622 = _620 - _621;
    float _623 = log2(_616);
    float _624 = _623 * 8.0f;
    float _625 = exp2(_624);
    float _626 = _625 * 500.0f;
    float _627 = _626 + 20.0f;
    float _628 = _623 * 6.0f;
    float _629 = exp2(_628);
    float _630 = _629 * 2000.0f;
    float _631 = _630 + 50.0f;
    float _632 = _57.x * 0.13500000536441803f;
    float _633 = _632 + 0.015000000596046448f;
    float _634 = _616 + 0.10000000149011612f;
    float _635 = _57.x * 0.007499999832361937f;
    float _636 = _635 + 0.007499999832361937f;
    float _637 = _619 * _70;
    float _638 = _619 * _71;
    float _639 = _619 * _72;
    float _640 = _637 + _75;
    float _641 = _638 + _76;
    float _642 = _83 + _639;
    float _643 = dot(float3(_640, _641, _642), float3(_640, _641, _642));
    float _644 = rsqrt(_643);
    float _645 = _644 * _640;
    float _646 = _644 * _641;
    float _647 = _644 * _642;
    float _648 = dot(float3(_645, _646, _647), float3(_145, _146, _147b));
    float _649 = _648 * _648;
    float _650 = 1.0f - _649;
    float _651 = saturate(_650);
    float _652 = sqrt(_651);
    float _653 = _648 + 1.0f;
    float _654 = saturate(_653);
    float _655 = _654 * 2.0f;
    float _656 = 3.0f - _655;
    float _657 = log2(_652);
    float _658 = _657 * _627;
    float _659 = exp2(_658);
    float _660 = _625 * 19.89436912536621f;
    float _661 = _660 + 1.1140847206115723f;
    float _662 = _634 * _633;
    float _663 = _662 * _661;
    float _664 = _654 * _654;
    float _665 = _664 * _663;
    float _666 = _665 * _656;
    float _667 = _666 * _659;
    float _668 = max(_617, 0.0010000000474974513f);
    float _669 = _52.x / _668;
    float _670 = _52.y / _668;
    float _671 = _52.z / _668;
    float _672 = _667 * _669;
    float _673 = _667 * _670;
    float _674 = _667 * _671;
    float _675 = _622 * _70;
    float _676 = _622 * _71;
    float _677 = _622 * _72;
    float _678 = _675 + _75;
    float _679 = _676 + _76;
    float _680 = _677 + _83;
    float _681 = dot(float3(_678, _679, _680), float3(_678, _679, _680));
    float _682 = rsqrt(_681);
    float _683 = _682 * _678;
    float _684 = _682 * _679;
    float _685 = _682 * _680;
    float _686 = dot(float3(_683, _684, _685), float3(_145, _146, _147b));
    float _687 = _686 * _686;
    float _688 = 1.0f - _687;
    float _689 = saturate(_688);
    float _690 = sqrt(_689);
    float _691 = _686 + 1.0f;
    float _692 = saturate(_691);
    float _693 = _692 * 2.0f;
    float _694 = 3.0f - _693;
    float _695 = log2(_690);
    float _696 = _695 * _631;
    float _697 = exp2(_696);
    float _698 = _629 * 79.57747650146484f;
    float _699 = _698 + 2.3077468872070312f;
    float _700 = _616 * _636;
    float _701 = _700 * _699;
    float _702 = _692 * _692;
    float _703 = _702 * _701;
    float _704 = _703 * _694;
    float _705 = _704 * _697;
    float _706 = _705 + _672;
    float _707 = _705 + _673;
    float _708 = _705 + _674;
    float _709 = _84 * 0.5f;
    _160 = _38.x;
    _161 = _38.y;
    _162 = _38.z;
    _494 = _709 * _706;
    _495 = _709 * _707;
    _496 = _709 * _708;
  }
  float _720 = _160 * _52.x;
  float _721 = _161 * _52.y;
  float _722 = _162 * _52.z;
  float _723 = _494 + _720;
  float _724 = _495 + _721;
  float _725 = _496 + _722;
  if ((_41 < 3.0f) & MaterialIdEquals(_52.w, 0.007843137718737125f)) {
    float _731 = max(_41 + -2.0f, 0.0f);
    float _736 = 1.0f - g_xSubsurfaceScatteringWeight.x;
    float _737 = 1.0f - g_xSubsurfaceScatteringWeight.y;
    float _738 = 1.0f - g_xSubsurfaceScatteringWeight.z;
    float _742 = _736 * _731 + g_xSubsurfaceScatteringWeight.x;
    float _743 = _737 * _731 + g_xSubsurfaceScatteringWeight.y;
    float _744 = _738 * _731 + g_xSubsurfaceScatteringWeight.z;
    _723 = _742 * _723;
    _724 = _743 * _724;
    _725 = _744 * _725;
  }
  g_xLightingUAV[int2((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y))] = float4(_723, _724, _725, _89);
}
