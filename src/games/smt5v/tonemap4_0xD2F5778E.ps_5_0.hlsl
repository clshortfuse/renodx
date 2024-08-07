// ---- Created with 3Dmigoto v1.3.16 on Thu Aug  8 00:13:58 2024
#include "./shared.h"
#include "./tonemapper.hlsl"  //Include our custom tonemapper

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2) {
  float4 cb2[3];
}

cbuffer cb1 : register(b1) {
  float4 cb1[67];
}

cbuffer cb0 : register(b0) {
  float4 cb0[39];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0 : SV_POSITION0,
                out float4 o0 : SV_Target0) {
  float4 r0, r1, r2, r3, r4, r5, r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = asuint(cb0[37].xyxy);
  r0.xyzw = v0.xyxy + -r0.xyzw;
  r0.xyzw = cb0[38].zwzw * r0.xyzw;
  r1.xy = r0.zw * cb0[5].xy + cb0[4].xy;
  r1.xyz = t1.Sample(s1_s, r1.xy).xyz;
  r0.xyzw = r0.xyzw * float4(2, -2, 2, -2) + float4(-1, 1, -1, 1);
  r0.xyzw = r0.xyzw / v0.wwww;
  r0.xyzw = r0.xyzw * cb1[66].xyxy + cb1[66].wzwz;
  r2.xyzw = float4(-0.000520833302, 0, 0.000520833302, 0) + r0.zwzw;
  r3.xyzw = float4(0, -0.00092592591, 0, 0.00092592591) + r0.zwzw;
  r1.w = t0.SampleLevel(s0_s, r0.zw, 0).x;
  r4.x = r1.w * cb1[65].x + cb1[65].y;
  r1.w = r1.w * cb1[65].z + -cb1[65].w;
  r1.w = 1 / r1.w;
  r1.w = r4.x + r1.w;
  r4.x = cmp(5000 >= r1.w);
  if (r4.x != 0) {
    r4.x = t0.SampleLevel(s0_s, r2.xy, 0).x;
    r4.y = r4.x * cb1[65].x + cb1[65].y;
    r4.x = r4.x * cb1[65].z + -cb1[65].w;
    r4.x = 1 / r4.x;
    r4.x = r4.y + r4.x;
    r4.x = cmp(5000 >= r4.x);
    if (r4.x != 0) {
      r4.x = t0.SampleLevel(s0_s, r2.zw, 0).x;
      r4.y = r4.x * cb1[65].x + cb1[65].y;
      r4.x = r4.x * cb1[65].z + -cb1[65].w;
      r4.x = 1 / r4.x;
      r4.x = r4.y + r4.x;
      r4.x = cmp(5000 >= r4.x);
      if (r4.x != 0) {
        r4.x = t0.SampleLevel(s0_s, r3.xy, 0).x;
        r4.y = r4.x * cb1[65].x + cb1[65].y;
        r4.x = r4.x * cb1[65].z + -cb1[65].w;
        r4.x = 1 / r4.x;
        r4.x = r4.y + r4.x;
        r4.x = cmp(5000 >= r4.x);
        if (r4.x != 0) {
          r4.x = t0.SampleLevel(s0_s, r3.zw, 0).x;
          r4.y = r4.x * cb1[65].x + cb1[65].y;
          r4.x = r4.x * cb1[65].z + -cb1[65].w;
          r4.x = 1 / r4.x;
          r4.x = r4.y + r4.x;
          r4.x = cmp(5000 < r4.x);
          r4.x = r4.x ? 1.000000 : 0;
        } else {
          r4.x = 1;
        }
      } else {
        r4.x = 1;
      }
    } else {
      r4.x = 1;
    }
  } else {
    r4.x = 0;
  }
  r1.w = cmp(5000 < r1.w);
  if (r1.w != 0) {
    r1.w = t0.SampleLevel(s0_s, r2.xy, 0).x;
    r2.x = r1.w * cb1[65].x + cb1[65].y;
    r1.w = r1.w * cb1[65].z + -cb1[65].w;
    r1.w = 1 / r1.w;
    r1.w = r2.x + r1.w;
    r1.w = cmp(5000 < r1.w);
    if (r1.w != 0) {
      r1.w = t0.SampleLevel(s0_s, r2.zw, 0).x;
      r2.x = r1.w * cb1[65].x + cb1[65].y;
      r1.w = r1.w * cb1[65].z + -cb1[65].w;
      r1.w = 1 / r1.w;
      r1.w = r2.x + r1.w;
      r1.w = cmp(5000 < r1.w);
      if (r1.w != 0) {
        r1.w = t0.SampleLevel(s0_s, r3.xy, 0).x;
        r2.x = r1.w * cb1[65].x + cb1[65].y;
        r1.w = r1.w * cb1[65].z + -cb1[65].w;
        r1.w = 1 / r1.w;
        r1.w = r2.x + r1.w;
        r1.w = cmp(5000 < r1.w);
        if (r1.w != 0) {
          r1.w = t0.SampleLevel(s0_s, r3.zw, 0).x;
          r2.x = r1.w * cb1[65].x + cb1[65].y;
          r1.w = r1.w * cb1[65].z + -cb1[65].w;
          r1.w = 1 / r1.w;
          r1.w = r2.x + r1.w;
          r1.w = cmp(5000 >= r1.w);
          r1.w = r1.w ? 1.000000 : 0;
        } else {
          r1.w = 1;
        }
      } else {
        r1.w = 1;
      }
    } else {
      r1.w = 1;
    }
  } else {
    r1.w = 0;
  }
  r1.w = r4.x + r1.w;
  r2.xyzw = cb0[3].zwzw * float4(-0.666665971, -0.666665971, 0.666665971, -0.666665971) + r0.zwzw;
  r3.xyz = t1.Sample(s1_s, r2.xy).xyz;
  r2.xyz = t1.Sample(s1_s, r2.zw).xyz;
  r4.xyzw = cb0[3].zwzw * float4(-0.666665971, 0.666665971, 0.666665971, 0.666665971) + r0.zwzw;
  r5.xyz = t1.Sample(s1_s, r4.xy).xyz;
  r4.xyz = t1.Sample(s1_s, r4.zw).xyz;
  r6.xyz = t1.Sample(s1_s, r0.zw).xyz;
  r2.w = dot(r3.xyz, float3(0.298999995, 0.587000012, 0.114));
  r2.x = dot(r2.xyz, float3(0.298999995, 0.587000012, 0.114));
  r2.y = dot(r5.xyz, float3(0.298999995, 0.587000012, 0.114));
  r2.z = dot(r4.xyz, float3(0.298999995, 0.587000012, 0.114));
  r3.x = dot(r6.xyz, float3(0.298999995, 0.587000012, 0.114));
  r3.yz = min(r2.wy, r2.xz);
  r3.y = min(r3.y, r3.z);
  r3.y = min(r3.x, r3.y);
  r3.zw = max(r2.wy, r2.xz);
  r3.z = max(r3.z, r3.w);
  r3.x = max(r3.x, r3.z);
  r3.z = r3.x + -r3.y;
  r3.w = 0.165999994 * r3.x;
  r3.w = max(0.0625, r3.w);
  r3.z = cmp(r3.z >= r3.w);
  if (r3.z != 0) {
    r3.zw = r2.wy + r2.xz;
    r3.w = r3.z + -r3.w;
    r4.xz = -r3.ww;
    r2.xw = r2.xw + r2.zy;
    r4.yw = r2.ww + -r2.xx;
    r2.x = r3.z + r2.y;
    r2.x = r2.x + r2.z;
    r2.x = 0.03125 * r2.x;
    r2.x = max(0.0078125, r2.x);
    r2.y = min(abs(r4.w), abs(r3.w));
    r2.x = r2.y + r2.x;
    r2.x = 1 / r2.x;
    r2.xyzw = r4.xyzw * r2.xxxx;
    r2.xyzw = max(float4(-7.33333349, -7.33333349, -7.33333349, -7.33333349), r2.xyzw);
    r2.xyzw = min(float4(7.33333349, 7.33333349, 7.33333349, 7.33333349), r2.xyzw);
    r2.xyzw = cb0[3].zwzw * r2.xyzw;
    r4.xyzw = r2.zwzw * float4(-0.111111298, -0.111111298, 0.333332688, 0.333332688) + r0.zwzw;
    r5.xyz = t1.Sample(s1_s, r4.xy).xyz;
    r4.xyz = t1.Sample(s1_s, r4.zw).xyz;
    r4.xyz = r5.xyz + r4.xyz;
    r5.xyz = float3(0.5, 0.5, 0.5) * r4.xyz;
    r0.xyzw = r2.xyzw * float4(-0.333333313, -0.333333313, 0.666666687, 0.666666687) + r0.xyzw;
    r2.xyz = t1.Sample(s1_s, r0.xy).xyz;
    r0.xyz = t1.Sample(s1_s, r0.zw).xyz;
    r0.xyz = r2.xyz + r0.xyz;
    r0.xyz = float3(0.25, 0.25, 0.25) * r0.xyz;
    r0.xyz = r4.xyz * float3(0.25, 0.25, 0.25) + r0.xyz;
    r0.w = dot(r0.xyz, float3(0.298999995, 0.587000012, 0.114));
    r2.x = cmp(r0.w < r3.y);
    r0.w = cmp(r3.x < r0.w);
    r0.w = (int)r0.w | (int)r2.x;
    r6.xyz = r0.www ? r5.xyz : r0.xyz;
  }
  r0.x = -1 + r1.w;
  r0.x = cmp(0 < abs(r0.x));
  r0.xyz = r0.xxx ? r1.xyz : r6.xyz;
  r1.xyz = cb2[1].xyz + -r0.xyz;
  r0.xyz = cb2[2].xxx * r1.xyz + r0.xyz;
  o0.xyz = max(float3(0, 0, 0), r0.xyz);
  float3 untonemapped = r0.xyz;
  // Use central tonemapper
  o0.rgb = applyUserTonemap(untonemapped).rgb;

  o0.w = 1;

  return;
}