#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Mon Feb 10 03:20:20 2025

cbuffer g_databuffer : register(b0)
{

  struct
  {
    float4 pixelData;
    float4 pixelSize;
    float4 inverseGamma;
  } g_data : packoffset(c0);

}

SamplerState g_color_buffer_sampler_s : register(s0);
Texture2D<float4> g_color_buffer_texture : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = g_color_buffer_texture.SampleLevel(g_color_buffer_sampler_s, v1.xy, 0, int2(0, 0)).xyzw;
  r1.xyzw = g_color_buffer_texture.SampleLevel(g_color_buffer_sampler_s, v1.xy, 0, int2(0, 0)).xyzw;
  r2.xyzw = g_color_buffer_texture.SampleLevel(g_color_buffer_sampler_s, v1.xy, 0).xyzw;
  r3.xyzw = g_color_buffer_texture.SampleLevel(g_color_buffer_sampler_s, v1.xy, 0, int2(0, 0)).xyzw;
  r4.xyzw = g_color_buffer_texture.SampleLevel(g_color_buffer_sampler_s, v1.xy, 0, int2(0, 0)).xyzw;
  r0.x = min(r1.w, r0.w);
  r0.y = min(r4.w, r3.w);
  r0.x = min(r0.x, r0.y);
  r0.x = min(r2.w, r0.x);
  r0.y = max(r1.w, r0.w);
  r0.z = max(r4.w, r3.w);
  r0.y = max(r0.y, r0.z);
  r0.y = max(r2.w, r0.y);
  r0.x = r0.y + -r0.x;
  r0.y = 0.166666672 * r0.y;
  r0.y = max(0.0833333358, r0.y);
  r0.y = cmp(r0.x >= r0.y);
  if (r0.y != 0) {
    r5.xyzw = g_color_buffer_texture.SampleLevel(g_color_buffer_sampler_s, v1.xy, 0, int2(0, 0)).xyzw;
    r6.xyzw = g_color_buffer_texture.SampleLevel(g_color_buffer_sampler_s, v1.xy, 0, int2(0, 0)).xyzw;
    r7.xyzw = g_color_buffer_texture.SampleLevel(g_color_buffer_sampler_s, v1.xy, 0, int2(0, 0)).xyzw;
    r8.xyzw = g_color_buffer_texture.SampleLevel(g_color_buffer_sampler_s, v1.xy, 0, int2(0, 0)).xyzw;
    r0.y = r1.w + r0.w;
    r0.y = r0.y + r3.w;
    r0.y = r0.y + r4.w;
    r0.z = r0.y * 0.25 + -r2.w;
    r0.x = abs(r0.z) / r0.x;
    r0.x = saturate(-0.25 + r0.x);
    r0.x = 1.33333337 * r0.x;
    r0.x = min(0.75, r0.x);
    r0.z = r0.w * -2 + r5.w;
    r0.z = r0.z + r6.w;
    r1.x = r2.w * -2 + r1.w;
    r1.x = r1.x + r3.w;
    r0.z = abs(r1.x) * 2 + abs(r0.z);
    r1.x = r4.w * -2 + r7.w;
    r1.x = r1.x + r8.w;
    r0.z = abs(r1.x) + r0.z;
    r1.x = r1.w * -2 + r5.w;
    r1.x = r1.x + r7.w;
    r1.y = r2.w * -2 + r0.w;
    r1.y = r1.y + r4.w;
    r1.x = abs(r1.y) * 2 + abs(r1.x);
    r1.y = r3.w * -2 + r6.w;
    r1.y = r1.y + r8.w;
    r1.x = r1.x + abs(r1.y);
    r0.z = cmp(r1.x >= r0.z);
    r1.x = r0.z ? -g_data.pixelSize.y : -g_data.pixelSize.x;
    r0.w = r0.z ? r0.w : r1.w;
    r1.y = r0.z ? r4.w : r3.w;
    r1.z = r0.w + -r2.w;
    r1.w = r1.y + -r2.w;
    r0.w = r0.w + r2.w;
    r0.w = 0.5 * r0.w;
    r1.y = r1.y + r2.w;
    r1.y = 0.5 * r1.y;
    r3.x = cmp(abs(r1.z) >= abs(r1.w));
    r0.w = r3.x ? r0.w : r1.y;
    r1.y = max(abs(r1.z), abs(r1.w));
    r1.x = r3.x ? r1.x : -r1.x;
    r1.yz = float2(0.25,0.5) * r1.yx;
    r1.w = r0.z ? 0 : r1.z;
    r1.z = r0.z ? r1.z : 0;
    r3.xy = v1.xy + r1.wz;
    r4.yz = float2(0,0);
    r4.xw = g_data.pixelSize.xy;
    r1.zw = r0.zz ? r4.xy : r4.zw;
    r3.xyzw = r1.zwzw * float4(-1.5,-1.5,1.5,1.5) + r3.xyxy;
    r4.xyzw = r3.xyzw;
    r5.xyzw = float4(0,0,0,0);
    r6.x = 0;
    while (true) {
      r6.y = cmp((int)r6.x >= 6);
      if (r6.y != 0) break;
      r7.xyzw = g_color_buffer_texture.SampleLevel(g_color_buffer_sampler_s, r4.xy, 0).xyzw;
      r8.xyzw = g_color_buffer_texture.SampleLevel(g_color_buffer_sampler_s, r4.zw, 0).xyzw;
      r6.y = r7.w + -r0.w;
      r6.z = r8.w + -r0.w;
      r6.yz = cmp(abs(r6.yz) >= r1.yy);
      r6.w = ~(int)r5.z;
      r6.w = r6.y ? r6.w : 0;
      r7.xy = r4.xy + r1.zw;
      r7.xy = r6.ww ? r7.xy : r4.xy;
      r6.w = ~(int)r5.w;
      r6.w = r6.z ? r6.w : 0;
      r8.xy = r4.zw + -r1.zw;
      r8.xy = r6.ww ? r8.xy : r4.zw;
      r6.w = r6.z ? r6.y : 0;
      if (r6.w != 0) {
        r4.xy = r7.xy;
        r4.zw = r8.xy;
        r5.x = r7.w;
        r5.y = r8.w;
        break;
      }
      r9.xy = -r1.zw * float2(2,2) + r7.xy;
      r4.xy = r6.yy ? r7.xy : r9.xy;
      r7.xy = r1.zw * float2(2,2) + r8.xy;
      r4.zw = r6.zz ? r8.xy : r7.xy;
      r6.x = (int)r6.x + 1;
      r5.zw = r6.yz;
      r5.x = r7.w;
      r5.y = r8.w;
    }
    r1.yz = v1.xy + -r4.xy;
    r1.y = r0.z ? r1.y : r1.z;
    r1.zw = -v1.xy + r4.zw;
    r1.z = r0.z ? r1.z : r1.w;
    r1.w = cmp(r1.y < r1.z);
    r1.w = r1.w ? r5.x : r5.y;
    r2.w = r2.w + -r0.w;
    r2.w = cmp(r2.w < 0);
    r0.w = r1.w + -r0.w;
    r0.w = cmp(r0.w < 0);
    r0.w = cmp((int)r2.w == (int)r0.w);
    r0.w = r0.w ? 0 : r1.x;
    r1.x = r1.z + r1.y;
    r1.y = min(r1.z, r1.y);
    r1.x = -1 / r1.x;
    r1.x = r1.y * r1.x + 0.5;
    r1.x = r0.x * 0.125 + r1.x;
    r0.w = r1.x * r0.w;
    r1.x = r0.z ? 0 : r0.w;
    r1.x = v1.x + r1.x;
    r0.z = r0.z ? r0.w : 0;
    r1.y = v1.y + r0.z;
    r1.xyzw = g_color_buffer_texture.SampleLevel(g_color_buffer_sampler_s, r1.xy, 0).xyzw;
    r0.z = dot(r1.xyz, float3(0.298999995,0.587000012,0.114));
    r0.z = 5.96046448e-08 + r0.z;
    r0.y = r0.y * 0.25 + -r0.z;
    r0.x = r0.x * r0.y + r0.z;
    r0.x = r0.x / r0.z;
    r0.x = min(4, r0.x);
    r2.xyz = r1.xyz * r0.xxx;
  }
  o0.xyz = r2.xyz;
  o0.w = 1;
  return;
}