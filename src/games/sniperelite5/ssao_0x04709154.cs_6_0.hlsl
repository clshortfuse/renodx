#include "./shared.h"

Texture2D<float4> g_xNormalTexture : register(t0);

Texture2D<float4> g_xDepthStencil : register(t1);

Texture2D<float4> g_xAlbedoTexture : register(t2);

RWTexture2D<float2> g_xResultTexture : register(u0);

SamplerState g_xPointClamp : register(s1);

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

cbuffer SSAOConstants : register(b1) {
  float m_fKernelSize : packoffset(c000.x);
  float m_fContrastPower : packoffset(c000.y);
};

// One hierarchical-depth tap: sample linear depth at pos (mip chosen from the offset radius),
// rebuild the view-space position, and return the saturated occlusion term.
float SSAOTap(float2 dir, float radius, float2 center, float3 basePos, float3 normal) {
  float _a = log2(radius);
  float _b = floor(_a);
  int _c = (int)_b;
  int _d = _c + -3;
  int _e = max(_d, 0);
  uint _mip = (uint)min(_e, 6);
  float _x = dir.x * radius;
  float _y = dir.y * radius;
  float _px = _x + center.x;
  float _py = _y + center.y;
  float _u = g_xRcpScreenDims.x * _px;
  float _v = g_xRcpScreenDims.y * _py;
  float _depth = g_xDepthStencil.SampleLevel(g_xPointClamp, float2(_u, _v), (float)_mip).x;
  float _tx = g_xCameraTanHalfFOV.x * _depth;
  float _ty = g_xCameraTanHalfFOV.y * _depth;
  float _nx = g_xTwoOverScreenDimensions.z + _px;
  float _ny = g_xTwoOverScreenDimensions.w + _py;
  float _nx2 = _nx * g_xTwoOverScreenDimensions.x;
  float _ny2 = _ny * g_xTwoOverScreenDimensions.y;
  float _nx3 = _nx2 + -1.0f;
  float _ny3 = _ny2 + -1.0f;
  float _pxv = _tx * _nx3;
  float _pyv = _ty * _ny3;
  float _dx = _pxv - basePos.x;
  float _dy = _pyv - basePos.y;
  float _dz = _depth - basePos.z;
  float _len = dot(float3(_dx, _dy, _dz), float3(_dx, _dy, _dz));
  float _den = _len + 0.03999999910593033f;
  float _ndot = dot(float3(_dx, _dy, _dz), normal);
  float _num = _ndot + -0.009999999776482582f;
  float _q = _num / _den;
  return saturate(_q);
}

float2 SSAORotate(float2 dir) {
  float _a = dir.x * 0.1736481785774231f;
  float _x = mad(dir.y, -0.9848077297210693f, _a);
  float _b = dir.x * 0.9848077297210693f;
  float _y = mad(dir.y, 0.1736481785774231f, _b);
  return float2(_x, _y);
}

[numthreads(32, 32, 1)]
void main(
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
  float _9 = float((uint)SV_DispatchThreadID.x);
  float _10 = float((uint)SV_DispatchThreadID.y);
  float _11 = _9 + 0.5f;
  float _12 = _10 + 0.5f;
  float4 _13 = g_xDepthStencil.Load(int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), 0));
  float _20 = _13.x * 0.9980000257492065f;
  float _21 = _20 + -0.0010000000474974513f;
  bool _24 = (_21 > g_xCameraFarClipValues.y);
  [branch]
  if (_24) {
    g_xResultTexture[int2((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y))] = float2(1.0f, _21);
  } else {
    float _30 = g_xCameraTanHalfFOV.x * _21;
    float _31 = g_xCameraTanHalfFOV.y * _21;
    float _35 = g_xTwoOverScreenDimensions.z + _11;
    float _36 = g_xTwoOverScreenDimensions.w + _12;
    float _39 = _35 * g_xTwoOverScreenDimensions.x;
    float _40 = _36 * g_xTwoOverScreenDimensions.y;
    float _41 = _39 + -1.0f;
    float _42 = _40 + -1.0f;
    float _43 = _30 * _41;
    float _44 = _31 * _42;
    int _45 = int(_11);
    int _46 = int(_12);
    float4 _47 = g_xAlbedoTexture.Load(int3(_45, _46, 0));
    // RenoDX: tolerant compare (see MaterialIdEquals in shared.h)
    bool _49 = MaterialIdEquals(_47.w, 0.01568627543747425f);
    [branch]
    if (_49) {
      g_xResultTexture[int2((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y))] = float2(1.0f, g_xCameraFarClipValues.y);
    } else {
      float4 _53 = g_xNormalTexture.Load(int3(_45, _46, 0));
      float _57 = _53.x * 2.0f;
      float _58 = _53.y * 2.0f;
      float _59 = _53.z * 2.0f;
      float _60 = _57 + -1.0f;
      float _61 = _58 + -1.0f;
      float _62 = _59 + -1.0f;
      float _63 = dot(float3(_60, _61, _62), float3(_60, _61, _62));
      float _64 = rsqrt(_63);
      float _65 = _60 * _64;
      float _66 = _61 * _64;
      float _67 = _62 * _64;
      float _80 = (g_xView[0].x) * _65;
      float _81 = mad((g_xView[1].x), _66, _80);
      float _82 = mad((g_xView[2].x), _67, _81);
      float _83 = (g_xView[0].y) * _65;
      float _84 = mad((g_xView[1].y), _66, _83);
      float _85 = mad((g_xView[2].y), _67, _84);
      float _86 = (g_xView[0].z) * _65;
      float _87 = mad((g_xView[1].z), _66, _86);
      float _88 = mad((g_xView[2].z), _67, _87);
      float _89 = dot(float2(_11, _12), float2(0.0671105608344078f, 0.005837149918079376f));
      float _90 = frac(_89);
      float _91 = _90 * 52.98291778564453f;
      float _92 = frac(_91);
      float _93 = _92 * 6.2831854820251465f;
      float _94 = sin(_93);
      float _95 = cos(_93);
      float _96 = max(10.0f, _21);
      float _97 = 10.0f / _96;
      float _100 = m_fKernelSize * _97;
      float2 _center = float2(_11, _12);
      float3 _base = float3(_43, _44, _21);
      float3 _n = float3(_82, _85, _88);
      float2 _d0 = float2(_95, _94);
      float2 _d1 = SSAORotate(_d0);
      float2 _d2 = SSAORotate(_d1);
      float2 _d3 = SSAORotate(_d2);
      float2 _d4 = SSAORotate(_d3);
      float2 _d5 = SSAORotate(_d4);
      float2 _d6 = SSAORotate(_d5);
      float2 _d7 = SSAORotate(_d6);
      float2 _d8 = SSAORotate(_d7);
      float _t0 = SSAOTap(_d0, _100 * 0.0555555559694767f, _center, _base, _n);
      float _t1 = SSAOTap(_d1, _100 * 0.1666666716337204f, _center, _base, _n);
      float _t2 = SSAOTap(_d2, _100 * 0.2777777910232544f, _center, _base, _n);
      float _t3 = SSAOTap(_d3, _100 * 0.3888888955116272f, _center, _base, _n);
      float _t4 = SSAOTap(_d4, _100 * 0.5f, _center, _base, _n);
      float _t5 = SSAOTap(_d5, _100 * 0.6111111044883728f, _center, _base, _n);
      float _t6 = SSAOTap(_d6, _100 * 0.7222222089767456f, _center, _base, _n);
      float _t7 = SSAOTap(_d7, _100 * 0.8333333134651184f, _center, _base, _n);
      float _t8 = SSAOTap(_d8, _100 * 0.9444444179534912f, _center, _base, _n);
      float _144 = -0.0f - _t0;
      float _182 = _144 - _t1;
      float _220 = _182 - _t2;
      float _258 = _220 - _t3;
      float _296 = _258 - _t4;
      float _334 = _296 - _t5;
      float _372 = _334 - _t6;
      float _410 = _372 - _t7;
      float _448 = _410 - _t8;
      float _449 = _448 * 0.1111111119389534f;
      float _450 = _449 + 1.0f;
      float _451 = saturate(_450);
      float _453 = log2(_451);
      float _454 = _453 * m_fContrastPower;
      float _455 = exp2(_454);
      g_xResultTexture[int2((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y))] = float2(_455, _21);
    }
  }
}
