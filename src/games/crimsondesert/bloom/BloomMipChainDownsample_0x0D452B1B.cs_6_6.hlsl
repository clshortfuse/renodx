#include "../shared.h"

// RenoDX: Bloom stability helpers
//
// 1. Soft luminance clamp - prevents high luminance values from causing
//    jitter bloom instability. Uses Reinhard compression
//    so bright values are softened rather than hard clipped
//
// 2. Karis average - weights 2x2 samples by 1/(1+luma) during the first
//    downsample to prevent firefly pixels from dominating the average
//
// Might not need all of this since reworking Histogram-AWB instead (will need to double checck)
//
float3 SoftClampBloom(float3 c, float maxLuma) {
  float luma = dot(c, float3(0.2126, 0.7152, 0.0722));
  if (luma <= maxLuma) return c;
  // Compression
  float compressed = maxLuma * (1.0 + luma / maxLuma) / (1.0 + luma / maxLuma + maxLuma / max(luma, 1e-6));
  return c * (compressed / max(luma, 1e-6));
}

float KarisWeight(float3 c) {
  return 1.0 / (1.0 + dot(c, float3(0.2126, 0.7152, 0.0722)));
}

float3 KarisAverage4(float3 a, float3 b, float3 c, float3 d) {
  float wa = KarisWeight(a);
  float wb = KarisWeight(b);
  float wc = KarisWeight(c);
  float wd = KarisWeight(d);
  float wSum = wa + wb + wc + wd;
  return (a * wa + b * wb + c * wc + d * wd) / max(wSum, 1e-6);
}

Texture2D<float3> __3__36__0__0__g_glareSource : register(t28, space36);

Texture2D<float3> __3__36__0__0__g_colorAdatationSource : register(t76, space36);

RWTexture2D<float3> __3__38__0__1__g_bloom1UAV : register(u17, space38);

RWTexture2D<float3> __3__38__0__1__g_bloom2UAV : register(u18, space38);

RWTexture2D<float3> __3__38__0__1__g_bloom3UAV : register(u19, space38);

RWTexture2D<float3> __3__38__0__1__g_bloom4UAV : register(u20, space38);

RWTexture2D<float3> __3__38__0__1__g_bloom5UAV : register(u21, space38);

RWTexture2D<float3> __3__38__0__1__g_bloom6UAV : register(u22, space38);

RWTexture2D<float3> __3__38__0__1__g_colorAdatationSourceUAV : register(u24, space38);

cbuffer __3__1__0__0__GlobalPushConstants : register(b0, space1) {
  float4 _textureSizeAndInvSize : packoffset(c000.x);
  float4 _blurParam : packoffset(c001.x);
  float4 _glareParam : packoffset(c002.x);
  float4 _renderParam : packoffset(c003.x);
  float4 _exposureParam : packoffset(c004.x);
  float4 _histogramParam : packoffset(c005.x);
  float4 _whiteBalance : packoffset(c006.x);
  float4 _glareBlurParam : packoffset(c007.x);
  float4 _preFrameViewPosition : packoffset(c008.x);
};

SamplerState __0__4__0__0__g_staticBilinearClamp : register(s3, space4);

groupshared float _global_0[3072];
groupshared float _global_1[3072];

[numthreads(32, 32, 1)]
void main(
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
  int _16 = (int)(SV_DispatchThreadID.y) | (int)(SV_DispatchThreadID.x);
  float _26 = ((float((uint)SV_DispatchThreadID.x) * 2.0f) + 1.0f) * _textureSizeAndInvSize.z;
  float _27 = ((float((uint)SV_DispatchThreadID.y) * 2.0f) + 1.0f) * _textureSizeAndInvSize.w;
  float3 _30 = __3__36__0__0__g_glareSource.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_26, _27), 0.0f);
  float3 _35 = __3__36__0__0__g_colorAdatationSource.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_26, _27), 0.0f);
  _30 = SoftClampBloom(_30, 500.0);
  _global_0[((int)(0u + ((int)(SV_GroupIndex) * 3)))] = _30.x;
  _global_0[((int)(1u + ((int)(SV_GroupIndex) * 3)))] = _30.y;
  _global_0[((int)(2u + ((int)(SV_GroupIndex) * 3)))] = _30.z;
  __3__38__0__1__g_bloom1UAV[int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y))] = float3(_30.x, _30.y, _30.z);
  _global_1[((int)(0u + ((int)(SV_GroupIndex) * 3)))] = _35.x;
  _global_1[((int)(1u + ((int)(SV_GroupIndex) * 3)))] = _35.y;
  _global_1[((int)(2u + ((int)(SV_GroupIndex) * 3)))] = _35.z;
  GroupMemoryBarrierWithGroupSync();
  float _164;
  float _165;
  float _166;
  float _167;
  float _168;
  float _169;
  float _276;
  float _277;
  float _278;
  float _279;
  float _280;
  float _281;
  float _388;
  float _389;
  float _390;
  float _391;
  float _392;
  float _393;
  float _500;
  float _501;
  float _502;
  float _503;
  float _504;
  float _505;

  // ── Mip 1 (bloom2): 2x2 downsample with Karis averaging ──────────────
  if ((_16 & 1) == 0) {
    uint _61 = SV_GroupIndex + 1u;
    uint _77 = SV_GroupIndex + 32u;
    uint _93 = SV_GroupIndex + 33u;
    float3 _s0 = float3(_30.x, _30.y, _30.z);
    float3 _s1 = float3(_global_0[0u + (_61 * 3)], _global_0[1u + (_61 * 3)], _global_0[2u + (_61 * 3)]);
    float3 _s2 = float3(_global_0[0u + (_77 * 3)], _global_0[1u + (_77 * 3)], _global_0[2u + (_77 * 3)]);
    float3 _s3 = float3(_global_0[0u + (_93 * 3)], _global_0[1u + (_93 * 3)], _global_0[2u + (_93 * 3)]);
    float3 _karis = KarisAverage4(_s0, _s1, _s2, _s3);
    _global_0[((int)(0u + ((int)(SV_GroupIndex) * 3)))] = _karis.x;
    _global_0[((int)(1u + ((int)(SV_GroupIndex) * 3)))] = _karis.y;
    _global_0[((int)(2u + ((int)(SV_GroupIndex) * 3)))] = _karis.z;
    __3__38__0__1__g_bloom2UAV[int2(((uint)(SV_DispatchThreadID.x) >> 1), ((uint)(SV_DispatchThreadID.y) >> 1))] = _karis;
    float _160 = ((((_global_1[((int)(0u + (_61 * 3)))]) + _35.x) + (_global_1[((int)(0u + (_77 * 3)))])) + (_global_1[((int)(0u + (_93 * 3)))])) * 0.25f;
    float _161 = ((((_global_1[((int)(1u + (_61 * 3)))]) + _35.y) + (_global_1[((int)(1u + (_77 * 3)))])) + (_global_1[((int)(1u + (_93 * 3)))])) * 0.25f;
    float _162 = ((((_global_1[((int)(2u + (_61 * 3)))]) + _35.z) + (_global_1[((int)(2u + (_77 * 3)))])) + (_global_1[((int)(2u + (_93 * 3)))])) * 0.25f;
    _global_1[((int)(0u + ((int)(SV_GroupIndex) * 3)))] = _160;
    _global_1[((int)(1u + ((int)(SV_GroupIndex) * 3)))] = _161;
    _global_1[((int)(2u + ((int)(SV_GroupIndex) * 3)))] = _162;
    _164 = _karis.x;
    _165 = _karis.y;
    _166 = _karis.z;
    _167 = _160;
    _168 = _161;
    _169 = _162;
  } else {
    _164 = _30.x;
    _165 = _30.y;
    _166 = _30.z;
    _167 = _35.x;
    _168 = _35.y;
    _169 = _35.z;
  }
  GroupMemoryBarrierWithGroupSync();
  // ── Mip 2 (bloom3): regular box average from here on ─────────────────
  if ((_16 & 3) == 0) {
    uint _173 = SV_GroupIndex + 2u;
    uint _189 = SV_GroupIndex + 64u;
    uint _205 = SV_GroupIndex + 66u;
    float _221 = ((((_global_0[((int)(0u + (_173 * 3)))]) + _164) + (_global_0[((int)(0u + (_189 * 3)))])) + (_global_0[((int)(0u + (_205 * 3)))])) * 0.25f;
    float _222 = ((((_global_0[((int)(1u + (_173 * 3)))]) + _165) + (_global_0[((int)(1u + (_189 * 3)))])) + (_global_0[((int)(1u + (_205 * 3)))])) * 0.25f;
    float _223 = ((((_global_0[((int)(2u + (_173 * 3)))]) + _166) + (_global_0[((int)(2u + (_189 * 3)))])) + (_global_0[((int)(2u + (_205 * 3)))])) * 0.25f;
    _global_0[((int)(0u + ((int)(SV_GroupIndex) * 3)))] = _221;
    _global_0[((int)(1u + ((int)(SV_GroupIndex) * 3)))] = _222;
    _global_0[((int)(2u + ((int)(SV_GroupIndex) * 3)))] = _223;
    __3__38__0__1__g_bloom3UAV[int2(((uint)(SV_DispatchThreadID.x) >> 2), ((uint)(SV_DispatchThreadID.y) >> 2))] = float3(_221, _222, _223);
    float _272 = ((((_global_1[((int)(0u + (_173 * 3)))]) + _167) + (_global_1[((int)(0u + (_189 * 3)))])) + (_global_1[((int)(0u + (_205 * 3)))])) * 0.25f;
    float _273 = ((((_global_1[((int)(1u + (_173 * 3)))]) + _168) + (_global_1[((int)(1u + (_189 * 3)))])) + (_global_1[((int)(1u + (_205 * 3)))])) * 0.25f;
    float _274 = ((((_global_1[((int)(2u + (_173 * 3)))]) + _169) + (_global_1[((int)(2u + (_189 * 3)))])) + (_global_1[((int)(2u + (_205 * 3)))])) * 0.25f;
    _global_1[((int)(0u + ((int)(SV_GroupIndex) * 3)))] = _272;
    _global_1[((int)(1u + ((int)(SV_GroupIndex) * 3)))] = _273;
    _global_1[((int)(2u + ((int)(SV_GroupIndex) * 3)))] = _274;
    _276 = _221;
    _277 = _222;
    _278 = _223;
    _279 = _272;
    _280 = _273;
    _281 = _274;
  } else {
    _276 = _164;
    _277 = _165;
    _278 = _166;
    _279 = _167;
    _280 = _168;
    _281 = _169;
  }
  GroupMemoryBarrierWithGroupSync();
  // ── Mip 3 (bloom4) ─────────────────────────────────────────────────
  if ((_16 & 7) == 0) {
    uint _285 = SV_GroupIndex + 4u;
    uint _301 = SV_GroupIndex + 128u;
    uint _317 = SV_GroupIndex + 132u;
    float _333 = ((((_global_0[((int)(0u + (_285 * 3)))]) + _276) + (_global_0[((int)(0u + (_301 * 3)))])) + (_global_0[((int)(0u + (_317 * 3)))])) * 0.25f;
    float _334 = ((((_global_0[((int)(1u + (_285 * 3)))]) + _277) + (_global_0[((int)(1u + (_301 * 3)))])) + (_global_0[((int)(1u + (_317 * 3)))])) * 0.25f;
    float _335 = ((((_global_0[((int)(2u + (_285 * 3)))]) + _278) + (_global_0[((int)(2u + (_317 * 3)))])) + (_global_0[((int)(2u + (_301 * 3)))])) * 0.25f;
    _global_0[((int)(0u + ((int)(SV_GroupIndex) * 3)))] = _333;
    _global_0[((int)(1u + ((int)(SV_GroupIndex) * 3)))] = _334;
    _global_0[((int)(2u + ((int)(SV_GroupIndex) * 3)))] = _335;
    __3__38__0__1__g_bloom4UAV[int2(((uint)(SV_DispatchThreadID.x) >> 3), ((uint)(SV_DispatchThreadID.y) >> 3))] = float3(_333, _334, _335);
    float _384 = ((((_global_1[((int)(0u + (_285 * 3)))]) + _279) + (_global_1[((int)(0u + (_301 * 3)))])) + (_global_1[((int)(0u + (_317 * 3)))])) * 0.25f;
    float _385 = ((((_global_1[((int)(1u + (_285 * 3)))]) + _280) + (_global_1[((int)(1u + (_301 * 3)))])) + (_global_1[((int)(1u + (_317 * 3)))])) * 0.25f;
    float _386 = ((((_global_1[((int)(2u + (_285 * 3)))]) + _281) + (_global_1[((int)(2u + (_301 * 3)))])) + (_global_1[((int)(2u + (_317 * 3)))])) * 0.25f;
    _global_1[((int)(0u + ((int)(SV_GroupIndex) * 3)))] = _384;
    _global_1[((int)(1u + ((int)(SV_GroupIndex) * 3)))] = _385;
    _global_1[((int)(2u + ((int)(SV_GroupIndex) * 3)))] = _386;
    _388 = _333;
    _389 = _334;
    _390 = _335;
    _391 = _384;
    _392 = _385;
    _393 = _386;
  } else {
    _388 = _276;
    _389 = _277;
    _390 = _278;
    _391 = _279;
    _392 = _280;
    _393 = _281;
  }
  GroupMemoryBarrierWithGroupSync();
  // ── Mip 4 (bloom5) ─────────────────────────────────────────────────
  if ((_16 & 15) == 0) {
    uint _397 = SV_GroupIndex + 8u;
    uint _413 = SV_GroupIndex + 256u;
    uint _429 = SV_GroupIndex + 264u;
    float _445 = ((((_global_0[((int)(0u + (_397 * 3)))]) + _388) + (_global_0[((int)(0u + (_413 * 3)))])) + (_global_0[((int)(0u + (_429 * 3)))])) * 0.25f;
    float _446 = ((((_global_0[((int)(1u + (_397 * 3)))]) + _389) + (_global_0[((int)(1u + (_413 * 3)))])) + (_global_0[((int)(1u + (_429 * 3)))])) * 0.25f;
    float _447 = ((((_global_0[((int)(2u + (_397 * 3)))]) + _390) + (_global_0[((int)(2u + (_429 * 3)))])) + (_global_0[((int)(2u + (_413 * 3)))])) * 0.25f;
    _global_0[((int)(0u + ((int)(SV_GroupIndex) * 3)))] = _445;
    _global_0[((int)(1u + ((int)(SV_GroupIndex) * 3)))] = _446;
    _global_0[((int)(2u + ((int)(SV_GroupIndex) * 3)))] = _447;
    __3__38__0__1__g_bloom5UAV[int2(((uint)(SV_DispatchThreadID.x) >> 4), ((uint)(SV_DispatchThreadID.y) >> 4))] = float3(_445, _446, _447);
    float _496 = ((((_global_1[((int)(0u + (_397 * 3)))]) + _391) + (_global_1[((int)(0u + (_413 * 3)))])) + (_global_1[((int)(0u + (_429 * 3)))])) * 0.25f;
    float _497 = ((((_global_1[((int)(1u + (_397 * 3)))]) + _392) + (_global_1[((int)(1u + (_413 * 3)))])) + (_global_1[((int)(1u + (_429 * 3)))])) * 0.25f;
    float _498 = ((((_global_1[((int)(2u + (_397 * 3)))]) + _393) + (_global_1[((int)(2u + (_413 * 3)))])) + (_global_1[((int)(2u + (_429 * 3)))])) * 0.25f;
    _global_1[((int)(0u + ((int)(SV_GroupIndex) * 3)))] = _496;
    _global_1[((int)(1u + ((int)(SV_GroupIndex) * 3)))] = _497;
    _global_1[((int)(2u + ((int)(SV_GroupIndex) * 3)))] = _498;
    _500 = _445;
    _501 = _446;
    _502 = _447;
    _503 = _496;
    _504 = _497;
    _505 = _498;
  } else {
    _500 = _388;
    _501 = _389;
    _502 = _390;
    _503 = _391;
    _504 = _392;
    _505 = _393;
  }
  GroupMemoryBarrierWithGroupSync();
  // ── Mip 5 (bloom6) + colour adaptation ───────────────────────────────
  if ((_16 & 31) == 0) {
    uint _509 = SV_GroupIndex + 16u;
    uint _525 = SV_GroupIndex + 512u;
    uint _541 = SV_GroupIndex + 528u;
    int _560 = (uint)(SV_DispatchThreadID.x) >> 5;
    int _561 = (uint)(SV_DispatchThreadID.y) >> 5;
    __3__38__0__1__g_bloom6UAV[int2(_560, _561)] = float3((((((_global_0[((int)(0u + (_509 * 3)))]) + _500) + (_global_0[((int)(0u + (_525 * 3)))])) + (_global_0[((int)(0u + (_541 * 3)))])) * 0.25f), (((((_global_0[((int)(1u + (_509 * 3)))]) + _501) + (_global_0[((int)(1u + (_525 * 3)))])) + (_global_0[((int)(1u + (_541 * 3)))])) * 0.25f), (((((_global_0[((int)(2u + (_509 * 3)))]) + _502) + (_global_0[((int)(2u + (_525 * 3)))])) + (_global_0[((int)(2u + (_541 * 3)))])) * 0.25f));
    __3__38__0__1__g_colorAdatationSourceUAV[int2(_560, _561)] = float3((((((_global_1[((int)(0u + (_509 * 3)))]) + _503) + (_global_1[((int)(0u + (_525 * 3)))])) + (_global_1[((int)(0u + (_541 * 3)))])) * 0.25f), (((((_global_1[((int)(1u + (_509 * 3)))]) + _504) + (_global_1[((int)(1u + (_525 * 3)))])) + (_global_1[((int)(1u + (_541 * 3)))])) * 0.25f), (((((_global_1[((int)(2u + (_509 * 3)))]) + _505) + (_global_1[((int)(2u + (_525 * 3)))])) + (_global_1[((int)(2u + (_541 * 3)))])) * 0.25f));
  }
}
