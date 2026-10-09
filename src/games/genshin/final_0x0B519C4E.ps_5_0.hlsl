#include "./common.hlsli"

// Genshin Impact HDR final composite with two cameras (HDR mode only, e.g.
// underwater): same as 0xAE711F61, but the scene is two PQ BT.2020 images
// (main and sub camera) selected per pixel by two screen-space quads.
// Vanilla blends the masks in PQ space, then composites the UI and PQ encodes
// through a 1D LUT (t3).
// RenoDX: the quad masks are kept as is; the rest is CompositeSceneAndUI.
// Original bytecode decompiled with 3Dmigoto, cleaned up and annotated.

Texture2D<float4> t0 : register(t0);  // UI, premultiplied alpha
Texture2D<float4> t1 : register(t1);  // scene A, PQ BT.2020
Texture2D<float4> t2 : register(t2);  // scene B, PQ BT.2020
Texture2D<float4> t3 : register(t3);  // vanilla PQ encode LUT (unused)

SamplerState s0_s : register(s0);
SamplerState s1_s : register(s1);
SamplerState s2_s : register(s2);
SamplerState s3_s : register(s3);

cbuffer cb0 : register(b0) {
  float4 cb0[14];
}

// cb0[9].xy     invert flags for quad A / B (<= 0.5 inverts)
// cb0[10..11]   quad A corners (xy, zw per row)
// cb0[12..13]   quad B corners

// Antialiased quad coverage: signed distance to the quad edges (positive
// inside, even-odd rule), smoothed over 0.001 UV.
float QuadMask(float2 uv, float4 corners_01, float4 corners_23, float invert_flag) {
  float4 x = float4(corners_01.xz, corners_23.xz);
  float4 y = float4(corners_01.yw, corners_23.yw);
  float4 dx = x.yzwx - x;
  float4 dy = y.yzwx - y;

  // Even-odd crossing count along +x
  float4 crossing = float4(y >= uv.y) - float4(y.yzwx >= uv.y);
  float4 valid = float4(abs(dy) >= 1e-6f);
  float4 inv_dy = valid / (dy + (1.f - valid));
  float4 x_at = dx * ((uv.y - y) * inv_dy) + x;
  float crossings = dot(valid * abs(crossing) * float4(x_at >= uv.x), 1.f);
  float inside = (frac(crossings * 0.5f) >= 0.5f) ? 1.f : 0.f;

  // Distance to the closest edge
  float4 length_sq = dx * dx + dy * dy;
  length_sq += (length_sq >= 1e-6f) ? 0.f : 1e-6f;
  float4 t = saturate(((uv.x - x) * dx + (uv.y - y) * dy) / length_sq);
  float4 ex = uv.x - (dx * t + x);
  float4 ey = uv.y - (dy * t + y);
  float4 distance = sqrt(ex * ex + ey * ey);
  float d = min(min(distance.x, distance.y), min(distance.z, distance.w));
  float signed_distance = inside * 2.f * d - d;

  float a = saturate(999.999939f * (signed_distance + 0.001f));
  float b = saturate(999.999939f * signed_distance);
  float smooth_a = a * a * (3.f - 2.f * a);
  float smooth_b = b * b * (3.f - 2.f * b);
  float invert = (0.5f >= invert_flag) ? 1.f : 0.f;
  return invert * (1.f - smooth_a - smooth_b) + smooth_b;
}

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float mask_a = QuadMask(v1.xy, cb0[10], cb0[11], cb0[9].x);
  float mask_b = QuadMask(v1.xy, cb0[12], cb0[13], cb0[9].y);
  float3 scene_pq = mask_a * t1.Sample(s0_s, v1.xy).xyz + mask_b * t2.Sample(s1_s, v1.xy).xyz;

  o0 = CompositeSceneAndUI(scene_pq, t0.Sample(s2_s, v1.xy));
}
