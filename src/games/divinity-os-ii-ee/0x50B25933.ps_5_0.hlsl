// ---- Created with 3Dmigoto v1.4.1 on Sat Dec 27 06:39:35 2025
// Complex edge/hit detection and offset sampling pass. Uses Base as a mask to
// walk outward in four directions, counts steps until edges, then samples
// Base2/Base3 lookup tables to produce outputs in o0.xy/o0.zw.

cbuffer PerView : register(b12)
{
  row_major float4x4 global_View : packoffset(c0);
  row_major float4x4 global_Projection : packoffset(c4);
  row_major float4x4 global_ViewProjection : packoffset(c8);
  float4 global_ViewPos : packoffset(c12);
  float4 global_ViewInfo : packoffset(c13);
  float4 global_ScaleAndBias : packoffset(c14);
}

SamplerState LinearSampler_s : register(s0);
SamplerState PointSampler_s : register(s1);
Texture2D<float4> Base : register(t0);
Texture2D<float4> Base2 : register(t1);
Texture2D<float4> Base3 : register(t2);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  float4 v2 : TEXCOORD2,
  float4 v3 : TEXCOORD3,
  float4 v4 : TEXCOORD4,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  // Initial mask read
  r0.xy = Base.SampleLevel(LinearSampler_s, v1.xy, 0).xy;
  r0.y = cmp(0 < r0.y);
  if (r0.y != 0) {
    // Scan up-left to find edge count
    r0.y = cmp(0 < r0.x);
    r0.zw = float2(1,1) / global_ViewInfo.zw;
    r1.xyzw = r0.zwzw * float4(-1,1,1,-1) + v1.xyxy;
    r2.xy = r1.xy;
    r2.zw = float2(0,0);
    while (true) {
      r3.x = cmp(r2.w >= 8);
      if (r3.x != 0) break;
      r3.xy = Base.SampleLevel(LinearSampler_s, r2.xy, 0).xy;
      r3.x = dot(r3.xy, float2(1,1));
      r3.x = cmp(r3.x < 1.89999998);
      r2.z = r3.y;
      if (r3.x != 0) break;
      r2.xy = r0.zw * float2(-1,1) + r2.xy;
      r2.w = 1 + r2.w;
      r2.z = r3.y;
    }
    r1.x = cmp(0.899999976 < r2.z);
    r1.x = r1.x ? 1.000000 : 0;
    r1.x = r2.w + r1.x;
    r2.y = r0.y ? r1.x : 0;
    r1.xy = r1.zw;
    r0.y = 0;
    // Scan down-right
    while (true) {
      r3.x = cmp(r0.y >= 8);
      if (r3.x != 0) break;
      r3.xy = Base.SampleLevel(LinearSampler_s, r1.xy, 0).xy;
      r3.x = dot(r3.xy, float2(1,1));
      r3.x = cmp(r3.x < 1.89999998);
      if (r3.x != 0) break;
      r1.xy = r0.zw * float2(1,-1) + r1.xy;
      r0.y = 1 + r0.y;
    }
    r1.x = r2.y + r0.y;
    r1.x = cmp(2 < r1.x);
    if (r1.x != 0) {
      // Use Base samples around the edge counts to fetch from Base2 LUT
      r2.x = -r2.y;
      r2.zw = float2(1,-1) * r0.yy;
      r1.xyzw = r2.xyzw * r0.zwzw + v1.xyxy;
      r2.x = Base.SampleLevel(LinearSampler_s, r1.xy, 0, int2(-1, 0)).y;
      r1.x = Base.SampleLevel(LinearSampler_s, r1.xy, 0, int2(0, 0)).x;
      r2.w = Base.SampleLevel(LinearSampler_s, r1.zw, 0, int2(1, 0)).y;
      r1.y = Base.SampleLevel(LinearSampler_s, r1.zw, 0, int2(1, -1)).x;
      r1.xy = r2.xw * float2(2,2) + r1.xy;
      r1.zw = cmp(float2(7,7) >= r2.yz);
      r1.zw = r1.zw ? float2(1,1) : 0;
      r1.xy = r1.xy * r1.zw;
      r1.xy = r1.xy * float2(20,20) + r2.yz;
      r1.xy = r1.xy * float2(0.00625000009,0.0017857143) + float2(0.503125012,0.000892857148);
      r1.xy = Base2.SampleLevel(LinearSampler_s, r1.xy, 0).xy;
    } else {
      r1.xy = float2(0,0);
    }
    // Scan left for secondary edge measure
    r1.zw = v1.xy + -r0.zw;
    r2.xy = r1.zw;
    r3.x = 0;
    while (true) {
      r0.y = cmp(r3.x >= 8);
      if (r0.y != 0) break;
      r2.w = Base.SampleLevel(LinearSampler_s, r2.xy, 0).y;
      r2.z = Base.SampleLevel(LinearSampler_s, r2.xy, 0, int2(1, 0)).x;
      r0.y = dot(r2.zw, float2(1,1));
      r0.y = cmp(r0.y < 1.89999998);
      if (r0.y != 0) break;
      r2.xy = r2.xy + -r0.zw;
      r3.x = 1 + r3.x;
    }
    r0.y = Base.SampleLevel(LinearSampler_s, v1.xy, 0, int2(1, 0)).x;
    r0.y = cmp(0 < r0.y);
    r1.zw = v1.xy + r0.zw;
    r2.xy = r1.zw;
    r2.zw = float2(0,0);
    while (true) {
      r3.w = cmp(r2.w >= 8);
      if (r3.w != 0) break;
      r4.y = Base.SampleLevel(LinearSampler_s, r2.xy, 0).y;
      r4.x = Base.SampleLevel(LinearSampler_s, r2.xy, 0, int2(1, 0)).x;
      r3.w = dot(r4.xy, float2(1,1));
      r3.w = cmp(r3.w < 1.89999998);
      r2.z = r4.y;
      if (r3.w != 0) break;
      r2.xy = r2.xy + r0.zw;
      r2.w = 1 + r2.w;
      r2.z = r4.y;
    }
    r1.z = cmp(0.899999976 < r2.z);
    r1.z = r1.z ? 1.000000 : 0;
    r1.z = r2.w + r1.z;
    r3.z = r0.y ? r1.z : 0;
    r0.y = r3.x + r3.z;
    r0.y = cmp(2 < r0.y);
    if (r0.y != 0) {
      // Second LUT lookup path using Base2 when thresholds met
      r3.y = -r3.x;
      r2.xyzw = r3.yyzz * r0.zwzw + v1.xyxy;
      r4.x = Base.SampleLevel(LinearSampler_s, r2.xy, 0, int2(-1, 0)).y;
      r4.z = Base.SampleLevel(LinearSampler_s, r2.xy, 0, int2(0, -1)).x;
      r4.yw = Base.SampleLevel(LinearSampler_s, r2.zw, 0, int2(1, 0)).yx;
      r1.zw = r4.xy * float2(2,2) + r4.zw;
      r2.xy = cmp(float2(7,7) >= r3.xz);
      r2.xy = r2.xy ? float2(1,1) : 0;
      r1.zw = r2.xy * r1.zw;
      r1.zw = r1.zw * float2(20,20) + r3.xz;
      r1.zw = r1.zw * float2(0.00625000009,0.0017857143) + float2(0.503125012,0.000892857148);
      r1.zw = Base2.SampleLevel(LinearSampler_s, r1.zw, 0).xy;
      r1.xy = r1.xy + r1.wz;
    }
    // If both lookups are zero, fall back to additional search using Base3
    r0.y = dot(r1.xy, float2(1,1));
    r0.y = cmp(r0.y == 0.000000);
    if (r0.y != 0) {
      r2.xy = v2.yx;
      r2.z = 1;
      r1.z = 0;
      while (true) {
        r0.y = cmp(v4.x < r2.y);
        r2.w = cmp(0.828100026 < r2.z);
        r0.y = r0.y ? r2.w : 0;
        r2.w = cmp(r1.z == 0.000000);
        r0.y = r0.y ? r2.w : 0;
        if (r0.y == 0) break;
        r1.zw = Base.SampleLevel(LinearSampler_s, r2.yx, 0).xy;
        r2.xy = -r0.wz * float2(0,2) + r2.xy;
        r2.z = r1.w;
      }
      r0.y = 1 / global_ViewInfo.z;
      r1.w = r0.y * 1.25 + r2.y;
      r1.w = r0.y * 2 + r1.w;
      r2.x = 0.5 * r1.z;
      r1.z = Base3.SampleLevel(PointSampler_s, r2.xz, 0).x;
      r1.z = r1.z * r0.y;
      r2.x = -r1.z * 255 + r1.w;
      r2.y = v3.y;
      r1.z = Base.SampleLevel(LinearSampler_s, r2.xy, 0).x;
      r3.xy = v2.wz;
      r3.z = 1;
      r4.x = 0;
      // Mirror search on positive Y side
      while (true) {
        r2.w = cmp(r3.y < v4.y);
        r3.w = cmp(0.828100026 < r3.z);
        r2.w = r2.w ? r3.w : 0;
        r3.w = cmp(r4.x == 0.000000);
        r2.w = r2.w ? r3.w : 0;
        if (r2.w == 0) break;
        r4.xy = Base.SampleLevel(LinearSampler_s, r3.yx, 0).xy;
        r3.xy = r0.wz * float2(0,2) + r3.xy;
        r3.z = r4.y;
      }
      r0.w = -r0.y * 0.25 + r3.y;
      r0.w = r0.w + -r0.y;
      r0.w = -r0.y * 2 + r0.w;
      r3.x = r4.x * 0.5 + 0.5;
      r2.w = Base3.SampleLevel(PointSampler_s, r3.xz, 0).x;
      r2.w = r2.w * r0.y;
      r2.z = r2.w * 255 + r0.w;
      r0.yw = r2.xz / r0.yy;
      r0.yw = -w1.xz + r0.yw;
      r2.xw = sqrt(abs(r0.yw));
      r1.w = Base.SampleLevel(LinearSampler_s, r2.zy, 0, int2(1, 0)).x;
      r1.zw = float2(4,4) * r1.zw;
      r1.zw = round(r1.zw);
      r1.zw = r1.zw * float2(16,16) + r2.xw;
      r1.zw = r1.zw * float2(0.00625000009,0.0017857143) + float2(0.00312500005,0.000892857148);
      r1.zw = Base2.SampleLevel(LinearSampler_s, r1.zw, 0).xy;
      r2.xz = r0.yw * r0.zz;
      r2.y = 0;
      r2.xyz = v1.xyx + r2.xyz;
      r3.x = Base.SampleLevel(LinearSampler_s, r2.xy, 0, int2(0, 1)).x;
      r0.y = cmp(abs(r0.y) < abs(r0.w));
      r3.y = Base.SampleLevel(LinearSampler_s, r2.xy, 0, int2(0, -2)).x;
      r0.zw = saturate(float2(1.25,1.25) + -r3.xy);
      r0.zw = r1.zw * r0.zw;
      r1.zw = r0.yy ? r0.zw : r1.zw;
      r2.x = Base.SampleLevel(LinearSampler_s, r2.zy, 0, int2(1, 1)).x;
      r2.w = Base.SampleLevel(LinearSampler_s, r2.zy, 0, int2(1, -2)).x;
      r2.xy = saturate(float2(1.25,1.25) + -r2.xw);
      r1.zw = r2.xy * r1.zw;
      o0.xy = r0.yy ? r0.zw : r1.zw;
    } else {
      o0.xy = r1.xy;
      r0.x = 0;
    }
  } else {
    o0.xy = float2(0,0);
  }
  r0.x = cmp(0 < r0.x);
  if (r0.x != 0) {
    // Repeat similar edge search for o0.zw using different axes/coords
    r0.xyz = float3(1,1,1) / global_ViewInfo.zww;
    r1.xy = v3.xy;
    r1.z = 1;
    r2.x = 0;
    while (true) {
      r0.w = cmp(v4.z < r1.y);
      r1.w = cmp(0.828100026 < r1.z);
      r0.w = r0.w ? r1.w : 0;
      r1.w = cmp(r2.x == 0.000000);
      r0.w = r0.w ? r1.w : 0;
      if (r0.w == 0) break;
      r2.xy = Base.SampleLevel(LinearSampler_s, r1.xy, 0).yx;
      r1.xy = -r0.xz * float2(0,2) + r1.xy;
      r1.z = r2.y;
    }
    r0.w = r0.z * 3.25 + r1.y;
    r1.x = 0.5 * r2.x;
    r1.x = Base3.SampleLevel(PointSampler_s, r1.xz, 0).x;
    r1.x = r1.x * r0.z;
    r1.x = -r1.x * 255 + r0.w;
    r1.y = v2.x;
    r2.x = Base.SampleLevel(LinearSampler_s, r1.yx, 0).y;
    r3.xy = v3.zw;
    r3.z = 1;
    r2.z = 0;
    while (true) {
      r0.w = cmp(r3.y < v4.w);
      r1.w = cmp(0.828100026 < r3.z);
      r0.w = r0.w ? r1.w : 0;
      r1.w = cmp(r2.z == 0.000000);
      r0.w = r0.w ? r1.w : 0;
      if (r0.w == 0) break;
      r2.zw = Base.SampleLevel(LinearSampler_s, r3.xy, 0).yx;
      r3.xy = r0.xz * float2(0,2) + r3.xy;
      r3.z = r2.w;
    }
    r0.w = -r0.z * 0.25 + r3.y;
    r0.w = r0.z * -3 + r0.w;
    r3.x = r2.z * 0.5 + 0.5;
    r1.w = Base3.SampleLevel(PointSampler_s, r3.xz, 0).x;
    r1.w = r1.w * r0.z;
    r1.z = r1.w * 255 + r0.w;
    r1.xw = r1.xz / r0.zz;
    r3.yz = -w1.yw + r1.xw;
    r1.xw = sqrt(abs(r3.yz));
    r2.y = Base.SampleLevel(LinearSampler_s, r1.yz, 0, int2(0, 1)).y;
    r1.yz = float2(4,4) * r2.xy;
    r1.yz = round(r1.yz);
    r1.xy = r1.yz * float2(16,16) + r1.xw;
    r1.xy = r1.xy * float2(0.00625000009,0.0017857143) + float2(0.00312500005,0.000892857148);
    r1.xy = Base2.SampleLevel(LinearSampler_s, r1.xy, 0).xy;
    r3.x = 0;
    r0.xyz = r3.xyz * r0.xyz + v1.xyy;
    r1.z = Base.SampleLevel(LinearSampler_s, r0.xy, 0, int2(1, 0)).y;
    r0.w = cmp(abs(r3.y) < abs(r3.z));
    r1.w = Base.SampleLevel(LinearSampler_s, r0.xy, 0, int2(-2, 0)).y;
    r1.zw = saturate(float2(1.25,1.25) + -r1.zw);
    r1.zw = r1.xy * r1.zw;
    r1.xy = r0.ww ? r1.zw : r1.xy;
    r2.x = Base.SampleLevel(LinearSampler_s, r0.xz, 0, int2(1, 1)).y;
    r2.y = Base.SampleLevel(LinearSampler_s, r0.xz, 0, int2(-2, 1)).y;
    r0.xy = saturate(float2(1.25,1.25) + -r2.xy);
    r0.xy = r1.xy * r0.xy;
    o0.zw = r0.ww ? r1.zw : r0.xy;
  } else {
    o0.zw = float2(0,0);
  }
  return;
}