Texture2D<float3> __3__36__0__0__g_higherRes : register(t77, space36);

Texture2D<float3> __3__36__0__0__g_lowerRes : register(t78, space36);

RWTexture2D<float3> __3__38__0__1__g_blurredBloomUAV : register(u26, space38);

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

SamplerState __0__4__0__0__g_staticBilinearBlackBorder : register(s4, space4);

groupshared uint Cache2R[128];
groupshared uint Cache2G[128];
groupshared uint Cache2B[128];
groupshared float Cache[384];

[numthreads(8, 8, 1)]
void main(
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
  float3 _25 = __3__36__0__0__g_higherRes.Load(int3((((int)(((SV_GroupID.x << 3) + (uint)(-4)) + (SV_GroupThreadID.x << 1))) | 1), ((int)(((SV_GroupID.y << 3) + (uint)(-4)) + (SV_GroupThreadID.y << 1))), 0));
  float3 _29 = __3__36__0__0__g_higherRes.Load(int3(((int)(((SV_GroupID.x << 3) + (uint)(-4)) + (SV_GroupThreadID.x << 1))), ((int)(((SV_GroupID.y << 3) + (uint)(-4)) + (SV_GroupThreadID.y << 1))), 0));
  Cache2R[((int)((SV_GroupThreadID.y << 4) + SV_GroupThreadID.x))] = (((int)(f32tof16(_25.x) << 16)) | ((int)(f32tof16(_29.x)) & 65535));
  Cache2G[((int)((SV_GroupThreadID.y << 4) + SV_GroupThreadID.x))] = (((int)(f32tof16(_25.y) << 16)) | ((int)(f32tof16(_29.y)) & 65535));
  Cache2B[((int)((SV_GroupThreadID.y << 4) + SV_GroupThreadID.x))] = (((int)(f32tof16(_25.z) << 16)) | ((int)(f32tof16(_29.z)) & 65535));
  float3 _53 = __3__36__0__0__g_higherRes.Load(int3((((int)(((SV_GroupID.x << 3) + (uint)(-4)) + (SV_GroupThreadID.x << 1))) | 1), (((int)(((SV_GroupID.y << 3) + (uint)(-4)) + (SV_GroupThreadID.y << 1))) | 1), 0));
  float3 _57 = __3__36__0__0__g_higherRes.Load(int3(((int)(((SV_GroupID.x << 3) + (uint)(-4)) + (SV_GroupThreadID.x << 1))), (((int)(((SV_GroupID.y << 3) + (uint)(-4)) + (SV_GroupThreadID.y << 1))) | 1), 0));
  Cache2R[(((int)((SV_GroupThreadID.y << 4) + SV_GroupThreadID.x)) + 8)] = (((int)(f32tof16(_53.x) << 16)) | ((int)(f32tof16(_57.x)) & 65535));
  Cache2G[(((int)((SV_GroupThreadID.y << 4) + SV_GroupThreadID.x)) + 8)] = (((int)(f32tof16(_53.y) << 16)) | ((int)(f32tof16(_57.y)) & 65535));
  Cache2B[(((int)((SV_GroupThreadID.y << 4) + SV_GroupThreadID.x)) + 8)] = (((int)(f32tof16(_53.z) << 16)) | ((int)(f32tof16(_57.z)) & 65535));
  GroupMemoryBarrierWithGroupSync();
  int _84 = Cache2R[((int)(((SV_GroupThreadID.y << 4) + SV_GroupThreadID.x) + ((uint)((int)(SV_GroupThreadID.x) & 4))))];
  int _86 = Cache2G[((int)(((SV_GroupThreadID.y << 4) + SV_GroupThreadID.x) + ((uint)((int)(SV_GroupThreadID.x) & 4))))];
  int _88 = Cache2B[((int)(((SV_GroupThreadID.y << 4) + SV_GroupThreadID.x) + ((uint)((int)(SV_GroupThreadID.x) & 4))))];
  float _95 = f16tof32(((uint)((uint)((uint)(_84)) >> 16)));
  float _96 = f16tof32(((uint)((uint)((uint)(_86)) >> 16)));
  float _97 = f16tof32(((uint)((uint)((uint)(_88)) >> 16)));
  int _100 = Cache2R[((int)((((SV_GroupThreadID.y << 4) + SV_GroupThreadID.x) + ((uint)((int)(SV_GroupThreadID.x) & 4))) + 1u))];
  int _102 = Cache2G[((int)((((SV_GroupThreadID.y << 4) + SV_GroupThreadID.x) + ((uint)((int)(SV_GroupThreadID.x) & 4))) + 1u))];
  int _104 = Cache2B[((int)((((SV_GroupThreadID.y << 4) + SV_GroupThreadID.x) + ((uint)((int)(SV_GroupThreadID.x) & 4))) + 1u))];
  float _105 = f16tof32((uint)(_100));
  float _106 = f16tof32((uint)(_102));
  float _107 = f16tof32((uint)(_104));
  float _111 = f16tof32(((uint)((uint)((uint)(_100)) >> 16)));
  float _112 = f16tof32(((uint)((uint)((uint)(_102)) >> 16)));
  float _113 = f16tof32(((uint)((uint)((uint)(_104)) >> 16)));
  int _116 = Cache2R[((int)((((SV_GroupThreadID.y << 4) + SV_GroupThreadID.x) + ((uint)((int)(SV_GroupThreadID.x) & 4))) + 2u))];
  int _118 = Cache2G[((int)((((SV_GroupThreadID.y << 4) + SV_GroupThreadID.x) + ((uint)((int)(SV_GroupThreadID.x) & 4))) + 2u))];
  int _120 = Cache2B[((int)((((SV_GroupThreadID.y << 4) + SV_GroupThreadID.x) + ((uint)((int)(SV_GroupThreadID.x) & 4))) + 2u))];
  float _121 = f16tof32((uint)(_116));
  float _122 = f16tof32((uint)(_118));
  float _123 = f16tof32((uint)(_120));
  float _127 = f16tof32(((uint)((uint)((uint)(_116)) >> 16)));
  float _128 = f16tof32(((uint)((uint)((uint)(_118)) >> 16)));
  float _129 = f16tof32(((uint)((uint)((uint)(_120)) >> 16)));
  int _132 = Cache2R[((int)((((SV_GroupThreadID.y << 4) + SV_GroupThreadID.x) + ((uint)((int)(SV_GroupThreadID.x) & 4))) + 3u))];
  int _134 = Cache2G[((int)((((SV_GroupThreadID.y << 4) + SV_GroupThreadID.x) + ((uint)((int)(SV_GroupThreadID.x) & 4))) + 3u))];
  int _136 = Cache2B[((int)((((SV_GroupThreadID.y << 4) + SV_GroupThreadID.x) + ((uint)((int)(SV_GroupThreadID.x) & 4))) + 3u))];
  float _137 = f16tof32((uint)(_132));
  float _138 = f16tof32((uint)(_134));
  float _139 = f16tof32((uint)(_136));
  float _143 = f16tof32(((uint)((uint)((uint)(_132)) >> 16)));
  float _144 = f16tof32(((uint)((uint)((uint)(_134)) >> 16)));
  float _145 = f16tof32(((uint)((uint)((uint)(_136)) >> 16)));
  int _148 = Cache2R[((int)((((SV_GroupThreadID.y << 4) + SV_GroupThreadID.x) + ((uint)((int)(SV_GroupThreadID.x) & 4))) + 4u))];
  int _150 = Cache2G[((int)((((SV_GroupThreadID.y << 4) + SV_GroupThreadID.x) + ((uint)((int)(SV_GroupThreadID.x) & 4))) + 4u))];
  int _152 = Cache2B[((int)((((SV_GroupThreadID.y << 4) + SV_GroupThreadID.x) + ((uint)((int)(SV_GroupThreadID.x) & 4))) + 4u))];
  float _153 = f16tof32((uint)(_148));
  float _154 = f16tof32((uint)(_150));
  float _155 = f16tof32((uint)(_152));
  Cache[((int)(0u + (((int)((SV_GroupThreadID.y << 4) + (SV_GroupThreadID.x << 1))) * 3)))] = ((((((_127 + _111) * 0.21875f) + (_121 * 0.2734375f)) + ((_137 + _105) * 0.109375f)) + ((_143 + _95) * 0.03125f)) + ((_153 + f16tof32((uint)(_84))) * 0.00390625f));
  Cache[((int)(1u + (((int)((SV_GroupThreadID.y << 4) + (SV_GroupThreadID.x << 1))) * 3)))] = ((((((_128 + _112) * 0.21875f) + (_122 * 0.2734375f)) + ((_138 + _106) * 0.109375f)) + ((_144 + _96) * 0.03125f)) + ((_154 + f16tof32((uint)(_86))) * 0.00390625f));
  Cache[((int)(2u + (((int)((SV_GroupThreadID.y << 4) + (SV_GroupThreadID.x << 1))) * 3)))] = ((((((_129 + _113) * 0.21875f) + (_123 * 0.2734375f)) + ((_139 + _107) * 0.109375f)) + ((_145 + _97) * 0.03125f)) + ((_155 + f16tof32((uint)(_88))) * 0.00390625f));
  Cache[((int)(0u + ((((int)((SV_GroupThreadID.y << 4) + (SV_GroupThreadID.x << 1))) | 1) * 3)))] = ((((((_137 + _121) * 0.21875f) + (_127 * 0.2734375f)) + ((_143 + _111) * 0.109375f)) + ((_153 + _105) * 0.03125f)) + ((f16tof32(((uint)((uint)((uint)(_148)) >> 16))) + _95) * 0.00390625f));
  Cache[((int)(1u + ((((int)((SV_GroupThreadID.y << 4) + (SV_GroupThreadID.x << 1))) | 1) * 3)))] = ((((((_138 + _122) * 0.21875f) + (_128 * 0.2734375f)) + ((_144 + _112) * 0.109375f)) + ((_154 + _106) * 0.03125f)) + ((f16tof32(((uint)((uint)((uint)(_150)) >> 16))) + _96) * 0.00390625f));
  Cache[((int)(2u + ((((int)((SV_GroupThreadID.y << 4) + (SV_GroupThreadID.x << 1))) | 1) * 3)))] = ((((((_139 + _123) * 0.21875f) + (_129 * 0.2734375f)) + ((_145 + _113) * 0.109375f)) + ((_155 + _107) * 0.03125f)) + ((f16tof32(((uint)((uint)((uint)(_152)) >> 16))) + _97) * 0.00390625f));
  GroupMemoryBarrierWithGroupSync();
  __3__38__0__1__g_blurredBloomUAV[int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y))] = float3((((((((Cache[((int)(0u + (((int)(((SV_GroupThreadID.y << 3) + SV_GroupThreadID.x) + 40u)) * 3)))]) + (Cache[((int)(0u + (((int)(((SV_GroupThreadID.y << 3) + SV_GroupThreadID.x) + 24u)) * 3)))])) * 0.21875f) + ((Cache[((int)(0u + (((int)(((SV_GroupThreadID.y << 3) + SV_GroupThreadID.x) + 32u)) * 3)))]) * 0.2734375f)) + (((Cache[((int)(0u + (((int)(((SV_GroupThreadID.y << 3) + SV_GroupThreadID.x) + 48u)) * 3)))]) + (Cache[((int)(0u + (((int)(((SV_GroupThreadID.y << 3) + SV_GroupThreadID.x) + 16u)) * 3)))])) * 0.109375f)) + (((Cache[((int)(0u + (((int)(((SV_GroupThreadID.y << 3) + SV_GroupThreadID.x) + 56u)) * 3)))]) + (Cache[((int)(0u + (((int)(((SV_GroupThreadID.y << 3) + SV_GroupThreadID.x) + 8u)) * 3)))])) * 0.03125f)) + (((Cache[((int)(0u + (((int)(((SV_GroupThreadID.y << 3) + SV_GroupThreadID.x) + 64u)) * 3)))]) + (Cache[((int)(0u + (((int)((SV_GroupThreadID.y << 3) + SV_GroupThreadID.x)) * 3)))])) * 0.00390625f)), (((((((Cache[((int)(1u + (((int)(((SV_GroupThreadID.y << 3) + SV_GroupThreadID.x) + 40u)) * 3)))]) + (Cache[((int)(1u + (((int)(((SV_GroupThreadID.y << 3) + SV_GroupThreadID.x) + 24u)) * 3)))])) * 0.21875f) + ((Cache[((int)(1u + (((int)(((SV_GroupThreadID.y << 3) + SV_GroupThreadID.x) + 32u)) * 3)))]) * 0.2734375f)) + (((Cache[((int)(1u + (((int)(((SV_GroupThreadID.y << 3) + SV_GroupThreadID.x) + 48u)) * 3)))]) + (Cache[((int)(1u + (((int)(((SV_GroupThreadID.y << 3) + SV_GroupThreadID.x) + 16u)) * 3)))])) * 0.109375f)) + (((Cache[((int)(1u + (((int)(((SV_GroupThreadID.y << 3) + SV_GroupThreadID.x) + 56u)) * 3)))]) + (Cache[((int)(1u + (((int)(((SV_GroupThreadID.y << 3) + SV_GroupThreadID.x) + 8u)) * 3)))])) * 0.03125f)) + (((Cache[((int)(1u + (((int)(((SV_GroupThreadID.y << 3) + SV_GroupThreadID.x) + 64u)) * 3)))]) + (Cache[((int)(1u + (((int)((SV_GroupThreadID.y << 3) + SV_GroupThreadID.x)) * 3)))])) * 0.00390625f)), (((((((Cache[((int)(2u + (((int)(((SV_GroupThreadID.y << 3) + SV_GroupThreadID.x) + 40u)) * 3)))]) + (Cache[((int)(2u + (((int)(((SV_GroupThreadID.y << 3) + SV_GroupThreadID.x) + 24u)) * 3)))])) * 0.21875f) + ((Cache[((int)(2u + (((int)(((SV_GroupThreadID.y << 3) + SV_GroupThreadID.x) + 32u)) * 3)))]) * 0.2734375f)) + (((Cache[((int)(2u + (((int)(((SV_GroupThreadID.y << 3) + SV_GroupThreadID.x) + 48u)) * 3)))]) + (Cache[((int)(2u + (((int)(((SV_GroupThreadID.y << 3) + SV_GroupThreadID.x) + 16u)) * 3)))])) * 0.109375f)) + (((Cache[((int)(2u + (((int)(((SV_GroupThreadID.y << 3) + SV_GroupThreadID.x) + 56u)) * 3)))]) + (Cache[((int)(2u + (((int)(((SV_GroupThreadID.y << 3) + SV_GroupThreadID.x) + 8u)) * 3)))])) * 0.03125f)) + (((Cache[((int)(2u + (((int)(((SV_GroupThreadID.y << 3) + SV_GroupThreadID.x) + 64u)) * 3)))]) + (Cache[((int)(2u + (((int)((SV_GroupThreadID.y << 3) + SV_GroupThreadID.x)) * 3)))])) * 0.00390625f)));
  float3 _428 = __3__36__0__0__g_lowerRes.SampleLevel(__0__4__0__0__g_staticBilinearBlackBorder, float2((_textureSizeAndInvSize.z * (float((uint)SV_DispatchThreadID.x) + 0.5f)), (_textureSizeAndInvSize.w * (float((uint)SV_DispatchThreadID.y) + 0.5f))), 0.0f);
  float3 _438 = __3__38__0__1__g_blurredBloomUAV.Load(int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y)));
  __3__38__0__1__g_blurredBloomUAV[int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y))] = float3((_438.x + (_glareBlurParam.x * _428.x)), (_438.y + (_glareBlurParam.x * _428.y)), (_438.z + (_glareBlurParam.x * _428.z)));
}