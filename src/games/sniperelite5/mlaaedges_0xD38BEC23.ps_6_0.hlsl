#include "./shared.h"

Texture2D<float4> g_xPostToneMapFrameBufferTexture : register(t0);

// RenoDX: linear view depth copied by the addon, one uint per texel, low 16 bits = half float depth. Header at byte 512: size (xy) and row stride in texels (z).
ByteAddressBuffer depth_buffer : register(t0, space50);

SamplerState g_xPointClamp : register(s1);

// Depth starts at byte 2048; the first 2 KiB are unused.
float LoadDepth(int2 texel, int2 size, uint stride) {
  texel = clamp(texel, int2(0, 0), size - 1);
  return f16tof32(depth_buffer.Load(2048u + ((uint)texel.y * stride + (uint)texel.x) * 4u) & 0xFFFF);
}

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD,
  linear float4 TEXCOORD_1[3] : TEXCOORD1
) : SV_Target {
  float4 SV_Target;
  // RenoDX: detect edges on sRGB-encoded colour. The upgraded float target holds linear HDR, and the 0.1 threshold only finds geometry edges on gamma-space values.
  float4 _17 = g_xPostToneMapFrameBufferTexture.Sample(g_xPointClamp, float2(TEXCOORD.x, TEXCOORD.y));
  _17.xyz = renodx::color::srgb::EncodeSafe(_17.xyz);
  float _21 = dot(float3(_17.x, _17.y, _17.z), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float4 _22 = g_xPostToneMapFrameBufferTexture.Sample(g_xPointClamp, float2(TEXCOORD_1[0].x, TEXCOORD_1[0].y));
  _22.xyz = renodx::color::srgb::EncodeSafe(_22.xyz);
  float _26 = dot(float3(_22.x, _22.y, _22.z), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float4 _27 = g_xPostToneMapFrameBufferTexture.Sample(g_xPointClamp, float2(TEXCOORD_1[0].z, TEXCOORD_1[0].w));
  _27.xyz = renodx::color::srgb::EncodeSafe(_27.xyz);
  float _31 = dot(float3(_27.x, _27.y, _27.z), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  // RenoDX: Ultra uses a lower edge threshold so more subtle edges are anti-aliased.
  float edge_threshold = (CUSTOM_SMAA_ULTRA == 1.f) ? 0.05f : 0.10000000149011612f;
  // RenoDX: lower the edge threshold where depth curves sharply (second difference above 2% of depth), so depth silhouettes get anti-aliased.
  [branch]
  if (CUSTOM_DEPTH_EDGES > 0.f) {
    uint colour_width;
    uint colour_height;
    g_xPostToneMapFrameBufferTexture.GetDimensions(colour_width, colour_height);
    uint3 header = depth_buffer.Load3(512u);
    int2 depth_size = int2(header.xy);
    uint depth_stride = header.z;
    int2 depth_texel = int2(SV_Position.xy * float2(depth_size) / float2(colour_width, colour_height));
    float depth_c = LoadDepth(depth_texel, depth_size, depth_stride);
    float depth_l = LoadDepth(depth_texel + int2(-1, 0), depth_size, depth_stride);
    float depth_r = LoadDepth(depth_texel + int2(1, 0), depth_size, depth_stride);
    float depth_u = LoadDepth(depth_texel + int2(0, -1), depth_size, depth_stride);
    float depth_dn = LoadDepth(depth_texel + int2(0, 1), depth_size, depth_stride);
    float depth_curvature = max(abs(depth_l + depth_r - 2.f * depth_c), abs(depth_u + depth_dn - 2.f * depth_c));
    if (depth_curvature > 0.02f * depth_c) {
      edge_threshold *= lerp(1.f, 0.25f, CUSTOM_DEPTH_EDGES);
    }
  }
  float _34 = abs(_21 - _26);
  float _35 = abs(_21 - _31);
  float _38 = select((_34 < edge_threshold), 0.0f, 1.0f);
  float _39 = select((_35 < edge_threshold), 0.0f, 1.0f);
  [branch]
  if (dot(float2(_38, _39), float2(1.0f, 1.0f)) == 0.0f) {
    if (true) discard;
  }
  float4 _44 = g_xPostToneMapFrameBufferTexture.Sample(g_xPointClamp, float2(TEXCOORD_1[1].x, TEXCOORD_1[1].y));
  _44.xyz = renodx::color::srgb::EncodeSafe(_44.xyz);
  float4 _49 = g_xPostToneMapFrameBufferTexture.Sample(g_xPointClamp, float2(TEXCOORD_1[1].z, TEXCOORD_1[1].w));
  _49.xyz = renodx::color::srgb::EncodeSafe(_49.xyz);
  float4 _60 = g_xPostToneMapFrameBufferTexture.Sample(g_xPointClamp, float2(TEXCOORD_1[2].x, TEXCOORD_1[2].y));
  _60.xyz = renodx::color::srgb::EncodeSafe(_60.xyz);
  float4 _65 = g_xPostToneMapFrameBufferTexture.Sample(g_xPointClamp, float2(TEXCOORD_1[2].z, TEXCOORD_1[2].w));
  _65.xyz = renodx::color::srgb::EncodeSafe(_65.xyz);
  float _76 = max(max(max(_34, abs(_21 - dot(float3(_44.x, _44.y, _44.z), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f)))), abs(_26 - dot(float3(_60.x, _60.y, _60.z), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f)))), max(max(_35, abs(_21 - dot(float3(_49.x, _49.y, _49.z), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f)))), abs(_31 - dot(float3(_65.x, _65.y, _65.z), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f)))));
  SV_Target.x = (select(((_34 * 2.0f) < _76), 0.0f, 1.0f) * _38);
  SV_Target.y = (select(((_35 * 2.0f) < _76), 0.0f, 1.0f) * _39);
  SV_Target.z = 0.0f;
  SV_Target.w = 1.0f;
  return SV_Target;
}
