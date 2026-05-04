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

groupshared float g_Tile[3072];
groupshared float g_Tile2[3072];

[numthreads(32, 32, 1)]
void main(
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
  float _26 = ((float((uint)SV_DispatchThreadID.x) * 2.0f) + 1.0f) * _textureSizeAndInvSize.z;
  float _27 = ((float((uint)SV_DispatchThreadID.y) * 2.0f) + 1.0f) * _textureSizeAndInvSize.w;
  float3 _30 = __3__36__0__0__g_glareSource.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_26, _27), 0.0f);
  float3 _35 = __3__36__0__0__g_colorAdatationSource.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_26, _27), 0.0f);
  g_Tile[((int)(0u + ((int)(SV_GroupIndex) * 3)))] = _30.x;
  g_Tile[((int)(1u + ((int)(SV_GroupIndex) * 3)))] = _30.y;
  g_Tile[((int)(2u + ((int)(SV_GroupIndex) * 3)))] = _30.z;
  __3__38__0__1__g_bloom1UAV[int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y))] = float3(_30.x, _30.y, _30.z);
  g_Tile2[((int)(0u + ((int)(SV_GroupIndex) * 3)))] = _35.x;
  g_Tile2[((int)(1u + ((int)(SV_GroupIndex) * 3)))] = _35.y;
  g_Tile2[((int)(2u + ((int)(SV_GroupIndex) * 3)))] = _35.z;
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
  if ((((int)(SV_DispatchThreadID.y) | (int)(SV_DispatchThreadID.x)) & 1) == 0) {
    float _109 = ((((g_Tile[((int)(0u + (((int)(SV_GroupIndex + 1u)) * 3)))]) + _30.x) + (g_Tile[((int)(0u + (((int)(SV_GroupIndex + 32u)) * 3)))])) + (g_Tile[((int)(0u + (((int)(SV_GroupIndex + 33u)) * 3)))])) * 0.25f;
    float _110 = ((((g_Tile[((int)(1u + (((int)(SV_GroupIndex + 1u)) * 3)))]) + _30.y) + (g_Tile[((int)(1u + (((int)(SV_GroupIndex + 32u)) * 3)))])) + (g_Tile[((int)(1u + (((int)(SV_GroupIndex + 33u)) * 3)))])) * 0.25f;
    float _111 = ((((g_Tile[((int)(2u + (((int)(SV_GroupIndex + 1u)) * 3)))]) + _30.z) + (g_Tile[((int)(2u + (((int)(SV_GroupIndex + 32u)) * 3)))])) + (g_Tile[((int)(2u + (((int)(SV_GroupIndex + 33u)) * 3)))])) * 0.25f;
    g_Tile[((int)(0u + ((int)(SV_GroupIndex) * 3)))] = _109;
    g_Tile[((int)(1u + ((int)(SV_GroupIndex) * 3)))] = _110;
    g_Tile[((int)(2u + ((int)(SV_GroupIndex) * 3)))] = _111;
    __3__38__0__1__g_bloom2UAV[int2(((uint)(SV_DispatchThreadID.x) >> 1), ((uint)(SV_DispatchThreadID.y) >> 1))] = float3(_109, _110, _111);
    float _160 = ((((g_Tile2[((int)(0u + (((int)(SV_GroupIndex + 1u)) * 3)))]) + _35.x) + (g_Tile2[((int)(0u + (((int)(SV_GroupIndex + 32u)) * 3)))])) + (g_Tile2[((int)(0u + (((int)(SV_GroupIndex + 33u)) * 3)))])) * 0.25f;
    float _161 = ((((g_Tile2[((int)(1u + (((int)(SV_GroupIndex + 1u)) * 3)))]) + _35.y) + (g_Tile2[((int)(1u + (((int)(SV_GroupIndex + 32u)) * 3)))])) + (g_Tile2[((int)(1u + (((int)(SV_GroupIndex + 33u)) * 3)))])) * 0.25f;
    float _162 = ((((g_Tile2[((int)(2u + (((int)(SV_GroupIndex + 1u)) * 3)))]) + _35.z) + (g_Tile2[((int)(2u + (((int)(SV_GroupIndex + 32u)) * 3)))])) + (g_Tile2[((int)(2u + (((int)(SV_GroupIndex + 33u)) * 3)))])) * 0.25f;
    g_Tile2[((int)(0u + ((int)(SV_GroupIndex) * 3)))] = _160;
    g_Tile2[((int)(1u + ((int)(SV_GroupIndex) * 3)))] = _161;
    g_Tile2[((int)(2u + ((int)(SV_GroupIndex) * 3)))] = _162;
    _164 = _109;
    _165 = _110;
    _166 = _111;
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
  if ((((int)(SV_DispatchThreadID.y) | (int)(SV_DispatchThreadID.x)) & 3) == 0) {
    float _221 = ((((g_Tile[((int)(0u + (((int)(SV_GroupIndex + 2u)) * 3)))]) + _164) + (g_Tile[((int)(0u + (((int)(SV_GroupIndex + 64u)) * 3)))])) + (g_Tile[((int)(0u + (((int)(SV_GroupIndex + 66u)) * 3)))])) * 0.25f;
    float _222 = ((((g_Tile[((int)(1u + (((int)(SV_GroupIndex + 2u)) * 3)))]) + _165) + (g_Tile[((int)(1u + (((int)(SV_GroupIndex + 64u)) * 3)))])) + (g_Tile[((int)(1u + (((int)(SV_GroupIndex + 66u)) * 3)))])) * 0.25f;
    float _223 = ((((g_Tile[((int)(2u + (((int)(SV_GroupIndex + 2u)) * 3)))]) + _166) + (g_Tile[((int)(2u + (((int)(SV_GroupIndex + 64u)) * 3)))])) + (g_Tile[((int)(2u + (((int)(SV_GroupIndex + 66u)) * 3)))])) * 0.25f;
    g_Tile[((int)(0u + ((int)(SV_GroupIndex) * 3)))] = _221;
    g_Tile[((int)(1u + ((int)(SV_GroupIndex) * 3)))] = _222;
    g_Tile[((int)(2u + ((int)(SV_GroupIndex) * 3)))] = _223;
    __3__38__0__1__g_bloom3UAV[int2(((uint)(SV_DispatchThreadID.x) >> 2), ((uint)(SV_DispatchThreadID.y) >> 2))] = float3(_221, _222, _223);
    float _272 = ((((g_Tile2[((int)(0u + (((int)(SV_GroupIndex + 2u)) * 3)))]) + _167) + (g_Tile2[((int)(0u + (((int)(SV_GroupIndex + 64u)) * 3)))])) + (g_Tile2[((int)(0u + (((int)(SV_GroupIndex + 66u)) * 3)))])) * 0.25f;
    float _273 = ((((g_Tile2[((int)(1u + (((int)(SV_GroupIndex + 2u)) * 3)))]) + _168) + (g_Tile2[((int)(1u + (((int)(SV_GroupIndex + 64u)) * 3)))])) + (g_Tile2[((int)(1u + (((int)(SV_GroupIndex + 66u)) * 3)))])) * 0.25f;
    float _274 = ((((g_Tile2[((int)(2u + (((int)(SV_GroupIndex + 2u)) * 3)))]) + _169) + (g_Tile2[((int)(2u + (((int)(SV_GroupIndex + 64u)) * 3)))])) + (g_Tile2[((int)(2u + (((int)(SV_GroupIndex + 66u)) * 3)))])) * 0.25f;
    g_Tile2[((int)(0u + ((int)(SV_GroupIndex) * 3)))] = _272;
    g_Tile2[((int)(1u + ((int)(SV_GroupIndex) * 3)))] = _273;
    g_Tile2[((int)(2u + ((int)(SV_GroupIndex) * 3)))] = _274;
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
  if ((((int)(SV_DispatchThreadID.y) | (int)(SV_DispatchThreadID.x)) & 7) == 0) {
    float _333 = ((((g_Tile[((int)(0u + (((int)(SV_GroupIndex + 4u)) * 3)))]) + _276) + (g_Tile[((int)(0u + (((int)(SV_GroupIndex + 128u)) * 3)))])) + (g_Tile[((int)(0u + (((int)(SV_GroupIndex + 132u)) * 3)))])) * 0.25f;
    float _334 = ((((g_Tile[((int)(1u + (((int)(SV_GroupIndex + 4u)) * 3)))]) + _277) + (g_Tile[((int)(1u + (((int)(SV_GroupIndex + 128u)) * 3)))])) + (g_Tile[((int)(1u + (((int)(SV_GroupIndex + 132u)) * 3)))])) * 0.25f;
    float _335 = ((((g_Tile[((int)(2u + (((int)(SV_GroupIndex + 4u)) * 3)))]) + _278) + (g_Tile[((int)(2u + (((int)(SV_GroupIndex + 128u)) * 3)))])) + (g_Tile[((int)(2u + (((int)(SV_GroupIndex + 132u)) * 3)))])) * 0.25f;
    g_Tile[((int)(0u + ((int)(SV_GroupIndex) * 3)))] = _333;
    g_Tile[((int)(1u + ((int)(SV_GroupIndex) * 3)))] = _334;
    g_Tile[((int)(2u + ((int)(SV_GroupIndex) * 3)))] = _335;
    __3__38__0__1__g_bloom4UAV[int2(((uint)(SV_DispatchThreadID.x) >> 3), ((uint)(SV_DispatchThreadID.y) >> 3))] = float3(_333, _334, _335);
    float _384 = ((((g_Tile2[((int)(0u + (((int)(SV_GroupIndex + 4u)) * 3)))]) + _279) + (g_Tile2[((int)(0u + (((int)(SV_GroupIndex + 128u)) * 3)))])) + (g_Tile2[((int)(0u + (((int)(SV_GroupIndex + 132u)) * 3)))])) * 0.25f;
    float _385 = ((((g_Tile2[((int)(1u + (((int)(SV_GroupIndex + 4u)) * 3)))]) + _280) + (g_Tile2[((int)(1u + (((int)(SV_GroupIndex + 128u)) * 3)))])) + (g_Tile2[((int)(1u + (((int)(SV_GroupIndex + 132u)) * 3)))])) * 0.25f;
    float _386 = ((((g_Tile2[((int)(2u + (((int)(SV_GroupIndex + 4u)) * 3)))]) + _281) + (g_Tile2[((int)(2u + (((int)(SV_GroupIndex + 128u)) * 3)))])) + (g_Tile2[((int)(2u + (((int)(SV_GroupIndex + 132u)) * 3)))])) * 0.25f;
    g_Tile2[((int)(0u + ((int)(SV_GroupIndex) * 3)))] = _384;
    g_Tile2[((int)(1u + ((int)(SV_GroupIndex) * 3)))] = _385;
    g_Tile2[((int)(2u + ((int)(SV_GroupIndex) * 3)))] = _386;
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
  if ((((int)(SV_DispatchThreadID.y) | (int)(SV_DispatchThreadID.x)) & 15) == 0) {
    float _445 = ((((g_Tile[((int)(0u + (((int)(SV_GroupIndex + 8u)) * 3)))]) + _388) + (g_Tile[((int)(0u + (((int)(SV_GroupIndex + 256u)) * 3)))])) + (g_Tile[((int)(0u + (((int)(SV_GroupIndex + 264u)) * 3)))])) * 0.25f;
    float _446 = ((((g_Tile[((int)(1u + (((int)(SV_GroupIndex + 8u)) * 3)))]) + _389) + (g_Tile[((int)(1u + (((int)(SV_GroupIndex + 256u)) * 3)))])) + (g_Tile[((int)(1u + (((int)(SV_GroupIndex + 264u)) * 3)))])) * 0.25f;
    float _447 = ((((g_Tile[((int)(2u + (((int)(SV_GroupIndex + 8u)) * 3)))]) + _390) + (g_Tile[((int)(2u + (((int)(SV_GroupIndex + 256u)) * 3)))])) + (g_Tile[((int)(2u + (((int)(SV_GroupIndex + 264u)) * 3)))])) * 0.25f;
    g_Tile[((int)(0u + ((int)(SV_GroupIndex) * 3)))] = _445;
    g_Tile[((int)(1u + ((int)(SV_GroupIndex) * 3)))] = _446;
    g_Tile[((int)(2u + ((int)(SV_GroupIndex) * 3)))] = _447;
    __3__38__0__1__g_bloom5UAV[int2(((uint)(SV_DispatchThreadID.x) >> 4), ((uint)(SV_DispatchThreadID.y) >> 4))] = float3(_445, _446, _447);
    float _496 = ((((g_Tile2[((int)(0u + (((int)(SV_GroupIndex + 8u)) * 3)))]) + _391) + (g_Tile2[((int)(0u + (((int)(SV_GroupIndex + 256u)) * 3)))])) + (g_Tile2[((int)(0u + (((int)(SV_GroupIndex + 264u)) * 3)))])) * 0.25f;
    float _497 = ((((g_Tile2[((int)(1u + (((int)(SV_GroupIndex + 8u)) * 3)))]) + _392) + (g_Tile2[((int)(1u + (((int)(SV_GroupIndex + 256u)) * 3)))])) + (g_Tile2[((int)(1u + (((int)(SV_GroupIndex + 264u)) * 3)))])) * 0.25f;
    float _498 = ((((g_Tile2[((int)(2u + (((int)(SV_GroupIndex + 8u)) * 3)))]) + _393) + (g_Tile2[((int)(2u + (((int)(SV_GroupIndex + 256u)) * 3)))])) + (g_Tile2[((int)(2u + (((int)(SV_GroupIndex + 264u)) * 3)))])) * 0.25f;
    g_Tile2[((int)(0u + ((int)(SV_GroupIndex) * 3)))] = _496;
    g_Tile2[((int)(1u + ((int)(SV_GroupIndex) * 3)))] = _497;
    g_Tile2[((int)(2u + ((int)(SV_GroupIndex) * 3)))] = _498;
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
  if ((((int)(SV_DispatchThreadID.y) | (int)(SV_DispatchThreadID.x)) & 31) == 0) {
    int _560 = (uint)(SV_DispatchThreadID.x) >> 5;
    int _561 = (uint)(SV_DispatchThreadID.y) >> 5;
    __3__38__0__1__g_bloom6UAV[int2(_560, _561)] = float3((((((g_Tile[((int)(0u + (((int)(SV_GroupIndex + 16u)) * 3)))]) + _500) + (g_Tile[((int)(0u + (((int)(SV_GroupIndex + 512u)) * 3)))])) + (g_Tile[((int)(0u + (((int)(SV_GroupIndex + 528u)) * 3)))])) * 0.25f), (((((g_Tile[((int)(1u + (((int)(SV_GroupIndex + 16u)) * 3)))]) + _501) + (g_Tile[((int)(1u + (((int)(SV_GroupIndex + 512u)) * 3)))])) + (g_Tile[((int)(1u + (((int)(SV_GroupIndex + 528u)) * 3)))])) * 0.25f), (((((g_Tile[((int)(2u + (((int)(SV_GroupIndex + 16u)) * 3)))]) + _502) + (g_Tile[((int)(2u + (((int)(SV_GroupIndex + 512u)) * 3)))])) + (g_Tile[((int)(2u + (((int)(SV_GroupIndex + 528u)) * 3)))])) * 0.25f));
    __3__38__0__1__g_colorAdatationSourceUAV[int2(_560, _561)] = float3((((((g_Tile2[((int)(0u + (((int)(SV_GroupIndex + 16u)) * 3)))]) + _503) + (g_Tile2[((int)(0u + (((int)(SV_GroupIndex + 512u)) * 3)))])) + (g_Tile2[((int)(0u + (((int)(SV_GroupIndex + 528u)) * 3)))])) * 0.25f), (((((g_Tile2[((int)(1u + (((int)(SV_GroupIndex + 16u)) * 3)))]) + _504) + (g_Tile2[((int)(1u + (((int)(SV_GroupIndex + 512u)) * 3)))])) + (g_Tile2[((int)(1u + (((int)(SV_GroupIndex + 528u)) * 3)))])) * 0.25f), (((((g_Tile2[((int)(2u + (((int)(SV_GroupIndex + 16u)) * 3)))]) + _505) + (g_Tile2[((int)(2u + (((int)(SV_GroupIndex + 512u)) * 3)))])) + (g_Tile2[((int)(2u + (((int)(SV_GroupIndex + 528u)) * 3)))])) * 0.25f));
  }
}