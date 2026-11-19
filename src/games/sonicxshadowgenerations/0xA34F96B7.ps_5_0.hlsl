// ---- Created with 3Dmigoto v1.3.16 on Wed Nov 18 12:36:00 2026

#include "./shared.h"

cbuffer cbDynamicFactor : register(b10)
{
  float4 u_blur_factor[2] : packoffset(c0);
  float4 u_screen_info[2] : packoffset(c2);
  float4 u_view_param : packoffset(c4);
  row_major float4x4 u_view_mtx : packoffset(c5);
  row_major float4x4 u_proj_mtx : packoffset(c9);
}

Texture2D<float4> s_Source : register(t0);
Texture2D<float4> s_Velocity : register(t1);
Texture2D<float4> s_TileNeighbourMaxVelocity : register(t2);
Texture2D<float4> s_DepthBuffer : register(t3);
Texture2D<float4> s_FullResSource : register(t4);

// Source color at a full-res position. Vanilla: half-res Load. Improved: full-res Load when bound, else bilinear half-res.
float3 SampleSource(float2 full_pos) {
  if (shader_injection.fx_motion_blur > 1.5) {
    if (shader_injection.fx_motion_blur_full_res > 0.5) {
      return s_FullResSource.Load(int3(int2(full_pos), 0)).xyz;
    }
    float2 p = full_pos * 0.5 - 0.5;
    float2 i = floor(p);
    float2 f = p - i;
    int2 t0 = max(int2(i), int2(0, 0));
    int2 t1 = max(int2(i) + int2(1, 1), int2(0, 0));
    float3 top = lerp(s_Source.Load(int3(t0, 0)).xyz, s_Source.Load(int3(t1.x, t0.y, 0)).xyz, f.x);
    float3 bottom = lerp(s_Source.Load(int3(t0.x, t1.y, 0)).xyz, s_Source.Load(int3(t1, 0)).xyz, f.x);
    return lerp(top, bottom, f.y);
  }
  return s_Source.Load(int3(int2(full_pos * 0.5), 0)).xyz;
}


// 3Dmigoto declarations
#define cmp -


// RenoDX: every o0 write is wrapped in saturate() to emulate the original R8G8B8A8_UNORM write clamp (target is upgraded to float; unbounded alpha breaks blending)
void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8;
  uint4 bitmask, uiDest;
  float4 fDest;

  float sample_count = (shader_injection.fx_motion_blur > 1.5) ? max(4.0, shader_injection.fx_motion_blur_samples) : u_blur_factor[1].y;

  r0.xy = float2(0.0500000007,0.0500000007) * v0.xy;
  r0.zw = v0.xy * float2(0.000231481477,0.000231481477) + float2(0.25,0);
  r0.zw = r0.zw * r0.zw;
  r0.z = dot(r0.zw, float2(3571,3571));
  r1.x = frac(r0.z);
  r1.y = 0.000231481477 * v0.y;
  r0.zw = r1.xy * r1.xy;
  r0.z = dot(r0.zw, float2(3571,3571));
  r0.z = frac(r0.z);
  r0.z = r0.z * 2 + -1;
  r1.xy = cmp(r0.xy >= -r0.xy);
  r0.xy = frac(abs(r0.xy));
  r0.xy = r1.xy ? r0.xy : -r0.xy;
  r0.xy = float2(1,1) * r0.xy;
  r0.xy = max(float2(0,0), r0.xy);
  r0.xy = float2(-0.5,-0.5) + r0.xy;
  r1.xy = r0.xy + r0.xy;
  r1.xy = abs(r1.xy);
  r0.w = cmp(r1.y < r1.x);
  r0.xy = cmp(float2(0,0) < r0.xy);
  r2.xy = r0.xy ? float2(1,1) : float2(-1,-1);
  r1.z = r2.x;
  r1.w = 0;
  r2.zw = r1.yw;
  r0.xyw = r0.www ? r1.xzw : r2.zwy;
  r0.x = 1 + -r0.x;
  r0.x = cmp(r0.x >= r0.z);
  r0.yw = float2(20,20) * r0.yw;
  r0.xy = r0.xx ? float2(0,0) : r0.yw;
  r0.xy = v0.xy + r0.xy;
  r0.xy = float2(0.0500000007,0.0500000007) * r0.xy;
  r1.xy = (int2)r0.xy;
  r1.zw = float2(0,0);
  r0.xyw = s_TileNeighbourMaxVelocity.Load(r1.xyz).xyz;
  r0.xy = float2(-0.5,-0.5) + r0.xy;
  r1.xy = float2(40,40) * shader_injection.fx_motion_blur_strength * r0.xy;
  r1.z = dot(r1.xy, r1.xy);
  r1.z = sqrt(r1.z);
  r1.w = cmp(0.515625 >= r1.z);
  if (r1.w != 0) {
    o0.xyz = max(0, float3(0,0,0)); // RenoDX
    o0.w = saturate(0);
    return;
  }
  r0.w = -r0.w * 20 + r1.z;
  r0.w = cmp(r0.w < 10);
  if (r0.w != 0) {
    r2.xy = r1.yx / r1.zz;
    r3.xy = (int2)v0.xy;
    r3.zw = float2(0,0);
    r2.zw = s_Velocity.Load(r3.xyz).xy;
    r2.zw = u_blur_factor[1].xx * shader_injection.fx_motion_blur_strength * r2.zw;
    r0.w = dot(r2.zw, r2.zw);
    r0.w = sqrt(r0.w);
    r1.w = min(20, r0.w);
    r1.w = max(0.5, r1.w);
    r0.w = 9.99999975e-006 + r0.w;
    r0.w = r1.w / r0.w;
    r2.zw = r2.zw * r0.ww;
    r0.w = dot(-r2.xy, r2.zw);
    r0.w = cmp(r0.w < 0);
    r2.xy = r0.ww ? r2.xy : -r2.xy;
    r0.w = dot(r2.zw, r2.zw);
    r0.w = sqrt(r0.w);
    r3.xy = r2.zw / r0.ww;
    r1.w = -0.5 + r0.w;
    r3.z = saturate(0.666666687 * r1.w);
    r3.xy = r3.xy + -r2.xy;
    r2.xy = r3.zz * r3.xy + r2.xy;
    r0.w = u_blur_factor[0].x * r0.w;
    r0.w = sample_count / r0.w;
    r3.x = 1 + sample_count;
    r3.yz = r0.xy * float2(40,40) * shader_injection.fx_motion_blur_strength + -r2.zw;
    r1.w = max(9.99999975e-006, r1.w);
    r4.zw = float2(0,0);
    r5.zw = float2(0,0);
    r3.w = 0;
    r6.xyzw = float4(0,0,0,0);
    while (true) {
      r7.x = (int)r6.w;
      r7.y = cmp(r7.x >= sample_count);
      if (r7.y != 0) break;
      r7.x = r0.z * 0.732857168 + r7.x;
      r7.x = 1 + r7.x;
      r7.x = r7.x / r3.x;
      r7.x = r7.x * 2 + -1;
      r7.y = (int)r6.w & 1;
      r7.y = (uint)r7.y;
      r7.yz = r7.yy * r3.yz + r2.zw;
      r7.w = r7.x * r1.z;
      r8.xy = r7.xx * r7.yz + v0.xy;
      r4.xy = (int2)r8.xy;
      r4.xy = s_Velocity.Load(r4.xyz).xy;
      r4.xy = u_blur_factor[1].xx * shader_injection.fx_motion_blur_strength * r4.xy;
      r7.x = dot(r4.xy, r4.xy);
      r7.x = sqrt(r7.x);
      r8.z = min(20, r7.x);
      r8.z = max(0.5, r8.z);
      r7.x = 9.99999975e-006 + r7.x;
      r7.x = r8.z / r7.x;
      r4.xy = r7.xx * r4.xy;
      r7.x = dot(r4.xy, r4.xy);
      r7.x = sqrt(r7.x);
      r4.xy = r4.xy / r7.xx;
      r8.xyz = SampleSource(r8.xy);
      r5.x = dot(r2.xy, r7.yz);
      r4.x = dot(r4.xy, r7.yz);
      r4.y = -0.5 + r7.x;
      r4.xy = max(float2(0,9.99999975e-006), r4.xy);
      r5.y = abs(r7.w) / r4.y;
      r5.y = 1 + -r5.y;
      r5.xy = max(float2(0,0), r5.xy);
      r7.x = abs(r7.w) / r1.w;
      r7.x = 1 + -r7.x;
      r7.x = max(0, r7.x);
      r7.x = r7.x * r5.x;
      r5.y = r5.y * r4.x + r7.x;
      r4.y = min(r4.y, r1.w);
      r7.x = 0.0999999642 * r4.y;
      r4.y = -r4.y * 0.949999988 + abs(r7.w);
      r7.x = 1 / r7.x;
      r4.y = saturate(r7.x * r4.y);
      r7.x = r4.y * -2 + 3;
      r4.y = r4.y * r4.y;
      r4.y = -r7.x * r4.y + 1;
      r4.x = max(r5.x, r4.x);
      r4.x = dot(r4.yy, r4.xx);
      r4.x = r5.y + r4.x;
      r3.w = r4.x + r3.w;
      r6.xyz = r8.xyz * r4.xxx + r6.xyz;
      r6.w = (int)r6.w + 1;
    }
    r1.w = cmp(0.00999999978 < r3.w);
    r2.xyz = r6.xyz / r3.www;
    r0.w = r0.w / r3.w;
    r2.w = 1 + -r0.w;
    o0.xyz = max(0, (r1.wwww ? r2.xyzw : 0).xyz); // RenoDX
    o0.w = saturate((r1.wwww ? r2.xyzw : 0).w);
    return;
  } else {
    r2.xy = (int2)v0.xy;
    r2.zw = float2(0,0);
    r0.w = s_DepthBuffer.Load(r2.xyw).x;
    r0.w = r0.w * u_view_param.w + -u_view_param.z;
    r0.w = -u_view_param.x / r0.w;
    r1.xy = r1.yx / r1.zz;
    r2.xy = s_Velocity.Load(r2.xyz).xy;
    r2.xy = u_blur_factor[1].xx * r2.xy;
    r1.w = dot(r2.xy, r2.xy);
    r1.w = sqrt(r1.w);
    r2.z = min(20, r1.w);
    r2.z = max(0.5, r2.z);
    r1.w = 9.99999975e-006 + r1.w;
    r1.w = r2.z / r1.w;
    r2.xy = r2.xy * r1.ww;
    r1.w = dot(-r1.xy, r2.xy);
    r1.w = cmp(r1.w < 0);
    r1.xy = r1.ww ? r1.xy : -r1.xy;
    r1.w = dot(r2.xy, r2.xy);
    r1.w = sqrt(r1.w);
    r2.zw = r2.xy / r1.ww;
    r3.x = -0.5 + r1.w;
    r3.y = saturate(0.666666687 * r3.x);
    r2.zw = r2.zw + -r1.xy;
    r1.xy = r3.yy * r2.zw + r1.xy;
    r1.w = u_blur_factor[0].x * r1.w;
    r1.w = sample_count / r1.w;
    r2.z = 1 + sample_count;
    r0.xy = r0.xy * float2(40,40) * shader_injection.fx_motion_blur_strength + -r2.xy;
    r2.w = max(9.99999975e-006, r3.x);
    r3.zw = float2(0,0);
    r4.zw = float2(0,0);
    r5.xyzw = float4(0,0,0,0);
    r6.x = 0;
    while (true) {
      r6.y = (int)r6.x;
      r6.z = cmp(r6.y >= sample_count);
      if (r6.z != 0) break;
      r6.y = r0.z * 0.732857168 + r6.y;
      r6.y = 1 + r6.y;
      r6.y = r6.y / r2.z;
      r6.y = r6.y * 2 + -1;
      r6.z = (int)r6.x & 1;
      r6.z = (uint)r6.z;
      r6.zw = r6.zz * r0.xy + r2.xy;
      r7.x = r6.y * r1.z;
      r7.yz = r6.yy * r6.zw + v0.xy;
      r3.xy = (int2)r7.yz;
      r8.xy = s_Velocity.Load(r3.xyw).xy;
      r8.xy = u_blur_factor[1].xx * shader_injection.fx_motion_blur_strength * r8.xy;
      r6.y = dot(r8.xy, r8.xy);
      r6.y = sqrt(r6.y);
      r7.w = min(20, r6.y);
      r7.w = max(0.5, r7.w);
      r6.y = 9.99999975e-006 + r6.y;
      r6.y = r7.w / r6.y;
      r8.xy = r8.xy * r6.yy;
      r6.y = dot(r8.xy, r8.xy);
      r6.y = sqrt(r6.y);
      r8.xy = r8.xy / r6.yy;
      r7.yzw = SampleSource(r7.yz);
      r3.x = s_DepthBuffer.Load(r3.xyz).x;
      r3.x = r3.x * u_view_param.w + -u_view_param.z;
      r3.x = -u_view_param.x / r3.x;
      r3.y = r3.x + -r0.w;
      r3.x = -r3.x + r0.w;
      r3.xy = saturate(float2(1,1) + -r3.xy);
      r4.x = dot(r1.xy, r6.zw);
      r4.y = dot(r8.xy, r6.zw);
      r4.xy = max(float2(0,0), r4.xy);
      r6.y = -0.5 + r6.y;
      r6.y = max(9.99999975e-006, r6.y);
      r6.z = abs(r7.x) / r6.y;
      r6.z = 1 + -r6.z;
      r6.z = max(0, r6.z);
      r3.y = r6.z * r3.y;
      r6.z = abs(r7.x) / r2.w;
      r6.z = 1 + -r6.z;
      r6.z = max(0, r6.z);
      r3.x = r6.z * r3.x;
      r3.x = r3.x * r4.x;
      r3.x = r3.y * r4.y + r3.x;
      r3.y = min(r6.y, r2.w);
      r6.y = 0.0999999642 * r3.y;
      r3.y = -r3.y * 0.949999988 + abs(r7.x);
      r6.y = 1 / r6.y;
      r3.y = saturate(r6.y * r3.y);
      r6.y = r3.y * -2 + 3;
      r3.y = r3.y * r3.y;
      r3.y = -r6.y * r3.y + 1;
      r4.x = max(r4.x, r4.y);
      r3.y = dot(r3.yy, r4.xx);
      r3.x = r3.x + r3.y;
      r5.w = r5.w + r3.x;
      r5.xyz = r7.yzw * r3.xxx + r5.xyz;
      r6.x = (int)r6.x + 1;
    }
    r0.x = cmp(0.00999999978 < r5.w);
    r2.xyz = r5.xyz / r5.www;
    r0.y = r1.w / r5.w;
    r2.w = 1 + -r0.y;
    o0.xyz = max(0, (r0.xxxx ? r2.xyzw : 0).xyz); // RenoDX
    o0.w = saturate((r0.xxxx ? r2.xyzw : 0).w);
    return;
  }
  return;
}
