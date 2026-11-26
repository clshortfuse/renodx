#include "./shared.h"
#include "./lilium_rcas.hlsli"

Texture2D<float4> g_xTexture : register(t0);

RWTexture2D<float4> g_xOutputUAV : register(u0);

cbuffer CASConstants : register(b0) {
  float4 const0 : packoffset(c000.x);
  float4 const1 : packoffset(c001.x);
};

// RenoDX: sharpen one pixel. Vanilla CAS runs on sRGB-encoded taps. Lilium RCAS runs on linear taps.
float3 SharpenPixel(int2 pos) {
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    // RenoDX: encode the linear taps to match the vanilla sRGB-encoded input
    float4 up = renodx::color::srgb::EncodeSafe(g_xTexture.Load(int3(pos.x, pos.y - 1, 0)));
    float4 left = renodx::color::srgb::EncodeSafe(g_xTexture.Load(int3(pos.x - 1, pos.y, 0)));
    float4 mid = renodx::color::srgb::EncodeSafe(g_xTexture.Load(int3(pos.x, pos.y, 0)));
    float4 right = renodx::color::srgb::EncodeSafe(g_xTexture.Load(int3(pos.x + 1, pos.y, 0)));
    float4 down = renodx::color::srgb::EncodeSafe(g_xTexture.Load(int3(pos.x, pos.y + 1, 0)));

    // RenoDX: weight from saturated green, as vanilla did on its (already clamped) input
    float lum_up = saturate(up.y);
    float lum_left = saturate(left.y);
    float lum_mid = saturate(mid.y);
    float lum_right = saturate(right.y);
    float lum_down = saturate(down.y);
    float lum_max = max(max(lum_left, max(lum_mid, lum_right)), max(lum_up, lum_down));
    float lum_min = min(min(min(lum_left, min(lum_mid, lum_right)), min(lum_up, lum_down)), 1.0f - lum_max);
    float rcp_max = asfloat((uint)(2129690299u - (int)asint(lum_max)));
    float weight = asfloat((int)((uint)asint(saturate(rcp_max * lum_min)) >> 1) + 532432441u) * const1.x;

    float denom = (weight * 4.0f) + 1.0f;
    float inv = asfloat((uint)(2129764351u - (int)asint(denom)));
    float newton = (2.0f - (inv * denom)) * inv;

    // RenoDX: vanilla filter on unclamped encoded taps; max(0) replaces saturate
    float3 filtered = max(0.f, newton * ((weight * (left.rgb + up.rgb + right.rgb + down.rgb)) + mid.rgb));

    return renodx::draw::RenderIntermediatePass(renodx::color::srgb::DecodeSafe(filtered));
  } else {
    // RenoDX: Lilium RCAS on linear taps, no sRGB encode
    float3 up = g_xTexture.Load(int3(pos.x, pos.y - 1, 0)).rgb;
    float3 left = g_xTexture.Load(int3(pos.x - 1, pos.y, 0)).rgb;
    float3 mid = g_xTexture.Load(int3(pos.x, pos.y, 0)).rgb;
    float3 right = g_xTexture.Load(int3(pos.x + 1, pos.y, 0)).rgb;
    float3 down = g_xTexture.Load(int3(pos.x, pos.y + 1, 0)).rgb;

    // RenoDX: film grain on the linear scene, before the UI is drawn
    uint2 size; g_xTexture.GetDimensions(size.x, size.y);
    float3 sharpened = renodx::effects::ApplyFilmGrain(ApplyLiliumRCAS(up, left, mid, right, down, CUSTOM_SHARPENING, RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS), float2(pos) / float2(size), CUSTOM_RANDOM, CUSTOM_FILM_GRAIN * 0.03f);
    return renodx::draw::RenderIntermediatePass(sharpened);
  }
}

[numthreads(64, 1, 1)]
void main(
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
  int _15 = (((uint)(SV_GroupThreadID.x) >> 1) & 7) | ((uint)((uint)(SV_GroupID.x) << 4));
  int _16 = ((((uint)(SV_GroupThreadID.x) >> 3) & 6) | ((uint)(SV_GroupThreadID.x) & 1)) | ((uint)((uint)(SV_GroupID.y) << 4));
  int _92 = _15 | 8;
  int _166 = _16 | 8;

  g_xOutputUAV[int2(_15, _16)] = float4(SharpenPixel(int2(_15, _16)), 1.0f);
  g_xOutputUAV[int2(_92, _16)] = float4(SharpenPixel(int2(_92, _16)), 1.0f);
  g_xOutputUAV[int2(_92, _166)] = float4(SharpenPixel(int2(_92, _166)), 1.0f);
  g_xOutputUAV[int2(_15, _166)] = float4(SharpenPixel(int2(_15, _166)), 1.0f);
}
