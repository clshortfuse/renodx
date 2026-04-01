Texture2D<float3> __3__36__0__0__g_higherRes : register(t77, space36);

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
  float3 _23 = __3__36__0__0__g_higherRes.Load(int3((((int)(((SV_GroupID.x << 3) + (uint)(-4)) + (SV_GroupThreadID.x << 1))) | 1), ((int)(((SV_GroupID.y << 3) + (uint)(-4)) + (SV_GroupThreadID.y << 1))), 0));
  float3 _27 = __3__36__0__0__g_higherRes.Load(int3(((int)(((SV_GroupID.x << 3) + (uint)(-4)) + (SV_GroupThreadID.x << 1))), ((int)(((SV_GroupID.y << 3) + (uint)(-4)) + (SV_GroupThreadID.y << 1))), 0));
  Cache2R[((int)((SV_GroupThreadID.y << 4) + SV_GroupThreadID.x))] = (((int)(f32tof16(_23.x) << 16)) | ((int)(f32tof16(_27.x)) & 65535));
  Cache2G[((int)((SV_GroupThreadID.y << 4) + SV_GroupThreadID.x))] = (((int)(f32tof16(_23.y) << 16)) | ((int)(f32tof16(_27.y)) & 65535));
  Cache2B[((int)((SV_GroupThreadID.y << 4) + SV_GroupThreadID.x))] = (((int)(f32tof16(_23.z) << 16)) | ((int)(f32tof16(_27.z)) & 65535));
  float3 _51 = __3__36__0__0__g_higherRes.Load(int3((((int)(((SV_GroupID.x << 3) + (uint)(-4)) + (SV_GroupThreadID.x << 1))) | 1), (((int)(((SV_GroupID.y << 3) + (uint)(-4)) + (SV_GroupThreadID.y << 1))) | 1), 0));
  float3 _55 = __3__36__0__0__g_higherRes.Load(int3(((int)(((SV_GroupID.x << 3) + (uint)(-4)) + (SV_GroupThreadID.x << 1))), (((int)(((SV_GroupID.y << 3) + (uint)(-4)) + (SV_GroupThreadID.y << 1))) | 1), 0));
  Cache2R[(((int)((SV_GroupThreadID.y << 4) + SV_GroupThreadID.x)) + 8)] = (((int)(f32tof16(_51.x) << 16)) | ((int)(f32tof16(_55.x)) & 65535));
  Cache2G[(((int)((SV_GroupThreadID.y << 4) + SV_GroupThreadID.x)) + 8)] = (((int)(f32tof16(_51.y) << 16)) | ((int)(f32tof16(_55.y)) & 65535));
  Cache2B[(((int)((SV_GroupThreadID.y << 4) + SV_GroupThreadID.x)) + 8)] = (((int)(f32tof16(_51.z) << 16)) | ((int)(f32tof16(_55.z)) & 65535));
  GroupMemoryBarrierWithGroupSync();
  int _82 = Cache2R[((int)(((SV_GroupThreadID.y << 4) + SV_GroupThreadID.x) + ((uint)((int)(SV_GroupThreadID.x) & 4))))];
  int _84 = Cache2G[((int)(((SV_GroupThreadID.y << 4) + SV_GroupThreadID.x) + ((uint)((int)(SV_GroupThreadID.x) & 4))))];
  int _86 = Cache2B[((int)(((SV_GroupThreadID.y << 4) + SV_GroupThreadID.x) + ((uint)((int)(SV_GroupThreadID.x) & 4))))];
  float _93 = f16tof32(((uint)((uint)((uint)(_82)) >> 16)));
  float _94 = f16tof32(((uint)((uint)((uint)(_84)) >> 16)));
  float _95 = f16tof32(((uint)((uint)((uint)(_86)) >> 16)));
  int _98 = Cache2R[((int)((((SV_GroupThreadID.y << 4) + SV_GroupThreadID.x) + ((uint)((int)(SV_GroupThreadID.x) & 4))) + 1u))];
  int _100 = Cache2G[((int)((((SV_GroupThreadID.y << 4) + SV_GroupThreadID.x) + ((uint)((int)(SV_GroupThreadID.x) & 4))) + 1u))];
  int _102 = Cache2B[((int)((((SV_GroupThreadID.y << 4) + SV_GroupThreadID.x) + ((uint)((int)(SV_GroupThreadID.x) & 4))) + 1u))];
  float _103 = f16tof32((uint)(_98));
  float _104 = f16tof32((uint)(_100));
  float _105 = f16tof32((uint)(_102));
  float _109 = f16tof32(((uint)((uint)((uint)(_98)) >> 16)));
  float _110 = f16tof32(((uint)((uint)((uint)(_100)) >> 16)));
  float _111 = f16tof32(((uint)((uint)((uint)(_102)) >> 16)));
  int _114 = Cache2R[((int)((((SV_GroupThreadID.y << 4) + SV_GroupThreadID.x) + ((uint)((int)(SV_GroupThreadID.x) & 4))) + 2u))];
  int _116 = Cache2G[((int)((((SV_GroupThreadID.y << 4) + SV_GroupThreadID.x) + ((uint)((int)(SV_GroupThreadID.x) & 4))) + 2u))];
  int _118 = Cache2B[((int)((((SV_GroupThreadID.y << 4) + SV_GroupThreadID.x) + ((uint)((int)(SV_GroupThreadID.x) & 4))) + 2u))];
  float _119 = f16tof32((uint)(_114));
  float _120 = f16tof32((uint)(_116));
  float _121 = f16tof32((uint)(_118));
  float _125 = f16tof32(((uint)((uint)((uint)(_114)) >> 16)));
  float _126 = f16tof32(((uint)((uint)((uint)(_116)) >> 16)));
  float _127 = f16tof32(((uint)((uint)((uint)(_118)) >> 16)));
  int _130 = Cache2R[((int)((((SV_GroupThreadID.y << 4) + SV_GroupThreadID.x) + ((uint)((int)(SV_GroupThreadID.x) & 4))) + 3u))];
  int _132 = Cache2G[((int)((((SV_GroupThreadID.y << 4) + SV_GroupThreadID.x) + ((uint)((int)(SV_GroupThreadID.x) & 4))) + 3u))];
  int _134 = Cache2B[((int)((((SV_GroupThreadID.y << 4) + SV_GroupThreadID.x) + ((uint)((int)(SV_GroupThreadID.x) & 4))) + 3u))];
  float _135 = f16tof32((uint)(_130));
  float _136 = f16tof32((uint)(_132));
  float _137 = f16tof32((uint)(_134));
  float _141 = f16tof32(((uint)((uint)((uint)(_130)) >> 16)));
  float _142 = f16tof32(((uint)((uint)((uint)(_132)) >> 16)));
  float _143 = f16tof32(((uint)((uint)((uint)(_134)) >> 16)));
  int _146 = Cache2R[((int)((((SV_GroupThreadID.y << 4) + SV_GroupThreadID.x) + ((uint)((int)(SV_GroupThreadID.x) & 4))) + 4u))];
  int _148 = Cache2G[((int)((((SV_GroupThreadID.y << 4) + SV_GroupThreadID.x) + ((uint)((int)(SV_GroupThreadID.x) & 4))) + 4u))];
  int _150 = Cache2B[((int)((((SV_GroupThreadID.y << 4) + SV_GroupThreadID.x) + ((uint)((int)(SV_GroupThreadID.x) & 4))) + 4u))];
  float _151 = f16tof32((uint)(_146));
  float _152 = f16tof32((uint)(_148));
  float _153 = f16tof32((uint)(_150));
  Cache[((int)(0u + (((int)((SV_GroupThreadID.y << 4) + (SV_GroupThreadID.x << 1))) * 3)))] = ((((((_125 + _109) * 0.21875f) + (_119 * 0.2734375f)) + ((_135 + _103) * 0.109375f)) + ((_141 + _93) * 0.03125f)) + ((_151 + f16tof32((uint)(_82))) * 0.00390625f));
  Cache[((int)(1u + (((int)((SV_GroupThreadID.y << 4) + (SV_GroupThreadID.x << 1))) * 3)))] = ((((((_126 + _110) * 0.21875f) + (_120 * 0.2734375f)) + ((_136 + _104) * 0.109375f)) + ((_142 + _94) * 0.03125f)) + ((_152 + f16tof32((uint)(_84))) * 0.00390625f));
  Cache[((int)(2u + (((int)((SV_GroupThreadID.y << 4) + (SV_GroupThreadID.x << 1))) * 3)))] = ((((((_127 + _111) * 0.21875f) + (_121 * 0.2734375f)) + ((_137 + _105) * 0.109375f)) + ((_143 + _95) * 0.03125f)) + ((_153 + f16tof32((uint)(_86))) * 0.00390625f));
  Cache[((int)(0u + ((((int)((SV_GroupThreadID.y << 4) + (SV_GroupThreadID.x << 1))) | 1) * 3)))] = ((((((_135 + _119) * 0.21875f) + (_125 * 0.2734375f)) + ((_141 + _109) * 0.109375f)) + ((_151 + _103) * 0.03125f)) + ((f16tof32(((uint)((uint)((uint)(_146)) >> 16))) + _93) * 0.00390625f));
  Cache[((int)(1u + ((((int)((SV_GroupThreadID.y << 4) + (SV_GroupThreadID.x << 1))) | 1) * 3)))] = ((((((_136 + _120) * 0.21875f) + (_126 * 0.2734375f)) + ((_142 + _110) * 0.109375f)) + ((_152 + _104) * 0.03125f)) + ((f16tof32(((uint)((uint)((uint)(_148)) >> 16))) + _94) * 0.00390625f));
  Cache[((int)(2u + ((((int)((SV_GroupThreadID.y << 4) + (SV_GroupThreadID.x << 1))) | 1) * 3)))] = ((((((_137 + _121) * 0.21875f) + (_127 * 0.2734375f)) + ((_143 + _111) * 0.109375f)) + ((_153 + _105) * 0.03125f)) + ((f16tof32(((uint)((uint)((uint)(_150)) >> 16))) + _95) * 0.00390625f));
  GroupMemoryBarrierWithGroupSync();
  __3__38__0__1__g_blurredBloomUAV[int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y))] = float3((_glareBlurParam.x * (((((((Cache[((int)(0u + (((int)(((SV_GroupThreadID.y << 3) + SV_GroupThreadID.x) + 40u)) * 3)))]) + (Cache[((int)(0u + (((int)(((SV_GroupThreadID.y << 3) + SV_GroupThreadID.x) + 24u)) * 3)))])) * 0.21875f) + ((Cache[((int)(0u + (((int)(((SV_GroupThreadID.y << 3) + SV_GroupThreadID.x) + 32u)) * 3)))]) * 0.2734375f)) + (((Cache[((int)(0u + (((int)(((SV_GroupThreadID.y << 3) + SV_GroupThreadID.x) + 48u)) * 3)))]) + (Cache[((int)(0u + (((int)(((SV_GroupThreadID.y << 3) + SV_GroupThreadID.x) + 16u)) * 3)))])) * 0.109375f)) + (((Cache[((int)(0u + (((int)(((SV_GroupThreadID.y << 3) + SV_GroupThreadID.x) + 56u)) * 3)))]) + (Cache[((int)(0u + (((int)(((SV_GroupThreadID.y << 3) + SV_GroupThreadID.x) + 8u)) * 3)))])) * 0.03125f)) + (((Cache[((int)(0u + (((int)(((SV_GroupThreadID.y << 3) + SV_GroupThreadID.x) + 64u)) * 3)))]) + (Cache[((int)(0u + (((int)((SV_GroupThreadID.y << 3) + SV_GroupThreadID.x)) * 3)))])) * 0.00390625f))), ((((((((Cache[((int)(1u + (((int)(((SV_GroupThreadID.y << 3) + SV_GroupThreadID.x) + 40u)) * 3)))]) + (Cache[((int)(1u + (((int)(((SV_GroupThreadID.y << 3) + SV_GroupThreadID.x) + 24u)) * 3)))])) * 0.21875f) + ((Cache[((int)(1u + (((int)(((SV_GroupThreadID.y << 3) + SV_GroupThreadID.x) + 32u)) * 3)))]) * 0.2734375f)) + (((Cache[((int)(1u + (((int)(((SV_GroupThreadID.y << 3) + SV_GroupThreadID.x) + 48u)) * 3)))]) + (Cache[((int)(1u + (((int)(((SV_GroupThreadID.y << 3) + SV_GroupThreadID.x) + 16u)) * 3)))])) * 0.109375f)) + (((Cache[((int)(1u + (((int)(((SV_GroupThreadID.y << 3) + SV_GroupThreadID.x) + 56u)) * 3)))]) + (Cache[((int)(1u + (((int)(((SV_GroupThreadID.y << 3) + SV_GroupThreadID.x) + 8u)) * 3)))])) * 0.03125f)) + (((Cache[((int)(1u + (((int)(((SV_GroupThreadID.y << 3) + SV_GroupThreadID.x) + 64u)) * 3)))]) + (Cache[((int)(1u + (((int)((SV_GroupThreadID.y << 3) + SV_GroupThreadID.x)) * 3)))])) * 0.00390625f)) * _glareBlurParam.x), ((((((((Cache[((int)(2u + (((int)(((SV_GroupThreadID.y << 3) + SV_GroupThreadID.x) + 40u)) * 3)))]) + (Cache[((int)(2u + (((int)(((SV_GroupThreadID.y << 3) + SV_GroupThreadID.x) + 24u)) * 3)))])) * 0.21875f) + ((Cache[((int)(2u + (((int)(((SV_GroupThreadID.y << 3) + SV_GroupThreadID.x) + 32u)) * 3)))]) * 0.2734375f)) + (((Cache[((int)(2u + (((int)(((SV_GroupThreadID.y << 3) + SV_GroupThreadID.x) + 48u)) * 3)))]) + (Cache[((int)(2u + (((int)(((SV_GroupThreadID.y << 3) + SV_GroupThreadID.x) + 16u)) * 3)))])) * 0.109375f)) + (((Cache[((int)(2u + (((int)(((SV_GroupThreadID.y << 3) + SV_GroupThreadID.x) + 56u)) * 3)))]) + (Cache[((int)(2u + (((int)(((SV_GroupThreadID.y << 3) + SV_GroupThreadID.x) + 8u)) * 3)))])) * 0.03125f)) + (((Cache[((int)(2u + (((int)(((SV_GroupThreadID.y << 3) + SV_GroupThreadID.x) + 64u)) * 3)))]) + (Cache[((int)(2u + (((int)((SV_GroupThreadID.y << 3) + SV_GroupThreadID.x)) * 3)))])) * 0.00390625f)) * _glareBlurParam.x));
}