// Edge-aware post-processing resolve generated from 3Dmigoto capture.
// The shader blends the current pixel with its neighbours when the
// hardware-provided edge classification textures request additional
// filtering, effectively reproducing Creative Assembly's MLAA resolve.
// ---- Created with 3Dmigoto v1.4.1 on Thu Oct  9 20:13:54 2025

Texture2D<float4> g_txInitialImage_10 : register(t0);
Texture2D<uint> g_txHorzCount_10 : register(t1);
Texture2D<uint> g_txVertCount_10 : register(t2);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xw = (int2)v0.yx;
  r0.y = 0;
  r1.xyzw = g_txInitialImage_10.Load(r0.wxy).xyzw;
  r2.x = g_txHorzCount_10.Load(r0.wxy).x;
  r2.y = (int)r2.x & 136;
  if (r2.y != 0) {
    // Horizontal edge smoothing: derive tap offsets from the encoded count texture
    // and blend the current pixel towards a neighbour or towards a pre-smoothed value.
    r2.y = (uint)r2.x >> 4;
    r2.y = (int)r2.y & 7;
    r3.x = (int)r2.x & 7;
    r4.xyzw = (int4)r0.wxyy + int4(0,-1,0,0);
    r4.xyzw = g_txInitialImage_10.Load(r4.xyz).xyzw;
    r2.x = (int)r2.y + (int)r3.x;
    r5.xyzw = r4.xyzw + -r1.xyzw;
    r5.xyzw = r5.xyzw * float4(0.125,0.125,0.125,0.125) + r1.xyzw;
    r2.z = (int)r2.x + 1;
    r2.z = (int)r2.z;
    r2.w = 0.5 * r2.z;
    r6.x = (int)r2.y;
    r7.x = -(int)r2.y;
    r7.yzw = float3(0,0,0);
    r7.xyzw = (int4)r0.wxyy + (int4)r7.xyzw;
    r7.xyzw = g_txInitialImage_10.Load(r7.xyz).xyzw;
    r8.x = (int)-r2.y + -1;
    r8.yzw = float3(0,0,0);
    r8.xyzw = (int4)r0.wxyy + (int4)r8.xyzw;
    r8.xyzw = g_txInitialImage_10.Load(r8.xyz).xyzw;
    r6.yzw = -r8.xyz + r7.xyz;
    r6.yzw = cmp(float3(0.0625,0.0625,0.0625) < abs(r6.yzw));
    r2.y = (int)r6.z | (int)r6.y;
    r2.y = (int)r6.w | (int)r2.y;
    r6.y = (int)r2.y & 1;
    r3.yzw = float3(0,0,0);
    r7.xyzw = (int4)r0.wxyy + (int4)r3.xyzw;
    r7.xyzw = g_txInitialImage_10.Load(r7.xyz).xyzw;
    r3.x = (int)r3.x + (int)r0.w;
    r8.xzw = float3(1,0,0);
    r8.y = r0.x;
    r3.yzw = float3(0,0,0);
    r3.xyzw = (int4)r8.xyzw + (int4)r3.xyzw;
    r3.xyzw = g_txInitialImage_10.Load(r3.xyz).xyzw;
    r3.xyz = r7.xyz + -r3.xyz;
    r3.xyz = cmp(float3(0.0625,0.0625,0.0625) < abs(r3.xyz));
    r3.x = (int)r3.y | (int)r3.x;
    r3.x = (int)r3.z | (int)r3.x;
    r2.y = r2.y ? 3 : 2;
    r2.y = r3.x ? r2.y : r6.y;
    r3.xyz = cmp((int3)r2.yyy == int3(2,1,3));
    r2.y = cmp(r6.x >= r2.w);
    r2.w = cmp(r2.w >= r6.x);
    r2.yw = r2.yw ? r3.xy : 0;
    r2.y = (int)r2.w | (int)r2.y;
    r2.y = (int)r3.z | (int)r2.y;
    r2.w = 1 / r2.z;
    r2.z = -r6.x + r2.z;
    r3.x = r2.w * r2.z + -0.5;
    r2.z = -1 + r2.z;
    r2.z = r2.w * r2.z + -0.5;
    r2.z = abs(r3.x) + abs(r2.z);
    r2.z = 0.5 * r2.z;
    r3.xyzw = r1.xyzw * r1.xyzw;
    r4.xyzw = r4.xyzw * r4.xyzw + -r3.xyzw;
    r3.xyzw = r2.zzzz * r4.xyzw + r3.xyzw;
    r3.xyzw = sqrt(r3.xyzw);
    r3.xyzw = r2.yyyy ? r3.xyzw : r1.xyzw;
    r1.xyzw = r2.xxxx ? r3.xyzw : r5.xyzw;
  }
  r2.xyz = (int3)r0.wxy + int3(0,1,0);
  r3.x = g_txHorzCount_10.Load(r2.xyz).x;
  r3.y = (int)r3.x & 136;
  if (r3.y != 0) {
    // Repeat the horizontal resolve for the pixel one row below. This effectively
    // finishes the bilateral filter for both halves of the pixel quad.
    r3.y = (uint)r3.x >> 4;
    r3.y = (int)r3.y & 7;
    r4.x = (int)r3.x & 7;
    r5.xyzw = g_txInitialImage_10.Load(r2.xyz).xyzw;
    r3.x = (int)r3.y + (int)r4.x;
    r6.xyzw = r5.xyzw + -r1.xyzw;
    r6.xyzw = r6.xyzw * float4(0.125,0.125,0.125,0.125) + r1.xyzw;
    r3.z = (int)r3.x + 1;
    r3.z = (int)r3.z;
    r3.w = 0.5 * r3.z;
    r7.x = (int)r3.y;
    r8.x = -(int)r3.y;
    r8.yzw = float3(0,0,0);
    r8.xyzw = (int4)r2.xyzz + (int4)r8.xyzw;
    r8.xyzw = g_txInitialImage_10.Load(r8.xyz).xyzw;
    r9.x = (int)-r3.y + -1;
    r9.yzw = float3(0,0,0);
    r9.xyzw = (int4)r2.xyzz + (int4)r9.xyzw;
    r9.xyzw = g_txInitialImage_10.Load(r9.xyz).xyzw;
    r7.yzw = -r9.xyz + r8.xyz;
    r7.yzw = cmp(float3(0.0625,0.0625,0.0625) < abs(r7.yzw));
    r2.y = (int)r7.z | (int)r7.y;
    r2.y = (int)r7.w | (int)r2.y;
    r3.y = (int)r2.y & 1;
    r2.w = r0.x;
    r4.yzw = float3(1.40129846e-45,0,0);
    r8.xyzw = (int4)r2.xwzz + (int4)r4.xyzw;
    r8.xyzw = g_txInitialImage_10.Load(r8.xyz).xyzw;
    r4.x = (int)r4.x + (int)r2.x;
    r9.x = 1;
    r9.yzw = r2.wzz;
    r4.yzw = float3(1.40129846e-45,0,0);
    r4.xyzw = (int4)r9.xyzw + (int4)r4.xyzw;
    r4.xyzw = g_txInitialImage_10.Load(r4.xyz).xyzw;
    r2.xzw = r8.xyz + -r4.xyz;
    r2.xzw = cmp(float3(0.0625,0.0625,0.0625) < abs(r2.xzw));
    r2.x = (int)r2.z | (int)r2.x;
    r2.x = (int)r2.w | (int)r2.x;
    r2.y = r2.y ? 3 : 2;
    r2.x = r2.x ? r2.y : r3.y;
    r2.xyz = cmp((int3)r2.xxx == int3(2,1,0));
    r2.w = cmp(r3.w >= r7.x);
    r2.x = r2.w ? r2.x : 0;
    r2.w = cmp(r7.x >= r3.w);
    r2.y = r2.w ? r2.y : 0;
    r2.x = (int)r2.y | (int)r2.x;
    r2.x = (int)r2.z | (int)r2.x;
    r2.y = 1 / r3.z;
    r2.z = -r7.x + r3.z;
    r2.w = r2.y * r2.z + -0.5;
    r2.z = -1 + r2.z;
    r2.y = r2.y * r2.z + -0.5;
    r2.y = abs(r2.w) + abs(r2.y);
    r2.y = 0.5 * r2.y;
    r4.xyzw = r1.xyzw * r1.xyzw;
    r5.xyzw = r5.xyzw * r5.xyzw + -r4.xyzw;
    r4.xyzw = r2.yyyy * r5.xyzw + r4.xyzw;
    r4.xyzw = sqrt(r4.xyzw);
    r2.xyzw = r2.xxxx ? r4.xyzw : r1.xyzw;
    r1.xyzw = r3.xxxx ? r2.xyzw : r6.xyzw;
  }
  r2.x = g_txVertCount_10.Load(r0.wxy).x;
  r2.y = (int)r2.x & 136;
  if (r2.y != 0) {
    // Vertical edge smoothing: use the vertical count texture to decide whether to
    // gather along the column, mirroring the logic from the horizontal branch above.
    r2.y = (uint)r2.x >> 4;
    r2.y = (int)r2.y & 7;
    r2.x = (int)r2.x & 7;
    r3.xyzw = (int4)r0.wxyy + int4(1,0,0,0);
    r3.xyzw = g_txInitialImage_10.Load(r3.xyz).xyzw;
    r2.z = (int)r2.y + (int)r2.x;
    r4.xyzw = r3.xyzw + -r1.xyzw;
    r4.xyzw = r4.xyzw * float4(0.125,0.125,0.125,0.125) + r1.xyzw;
    r2.w = (int)r2.z + 1;
    r2.w = (int)r2.w;
    r5.x = 0.5 * r2.w;
    r5.y = (int)r2.y;
    r6.xzw = float3(0,0,0);
    r6.y = r2.y;
    r6.xyzw = (int4)r0.wxyy + (int4)r6.xyzw;
    r6.xyzw = g_txInitialImage_10.Load(r6.xyz).xyzw;
    r7.xzw = float3(0,0,0);
    r7.y = (int)r2.y + 1;
    r7.xyzw = (int4)r0.wxyy + (int4)r7.xyzw;
    r7.xyzw = g_txInitialImage_10.Load(r7.xyz).xyzw;
    r6.xyz = -r7.xyz + r6.xyz;
    r6.xyz = cmp(float3(0.0625,0.0625,0.0625) < abs(r6.xyz));
    r2.y = (int)r6.y | (int)r6.x;
    r2.y = (int)r6.z | (int)r2.y;
    r5.z = (int)r2.y & 1;
    r6.y = -(int)r2.x;
    r6.xzw = float3(0,0,0);
    r7.xyzw = (int4)r0.wxyy + (int4)r6.xyzw;
    r7.xyzw = g_txInitialImage_10.Load(r7.xyz).xyzw;
    r6.y = (int)r6.y + (int)r0.x;
    r0.z = -1;
    r6.xzw = float3(0,0,0);
    r6.xyzw = (int4)r0.wzyy + (int4)r6.xyzw;
    r6.xyzw = g_txInitialImage_10.Load(r6.xyz).xyzw;
    r6.xyz = r7.xyz + -r6.xyz;
    r6.xyz = cmp(float3(0.0625,0.0625,0.0625) < abs(r6.xyz));
    r2.x = (int)r6.y | (int)r6.x;
    r2.x = (int)r6.z | (int)r2.x;
    r2.y = r2.y ? 3 : 2;
    r2.x = r2.x ? r2.y : r5.z;
    r6.xyz = cmp((int3)r2.xxx == int3(2,1,3));
    r2.xy = cmp(r5.yx >= r5.xy);
    r2.xy = r2.xy ? r6.xy : 0;
    r2.x = (int)r2.y | (int)r2.x;
    r2.x = (int)r6.z | (int)r2.x;
    r2.y = 1 / r2.w;
    r2.w = -r5.y + r2.w;
    r5.x = r2.y * r2.w + -0.5;
    r2.w = -1 + r2.w;
    r2.y = r2.y * r2.w + -0.5;
    r2.y = abs(r5.x) + abs(r2.y);
    r2.y = 0.5 * r2.y;
    r5.xyzw = r1.xyzw * r1.xyzw;
    r3.xyzw = r3.xyzw * r3.xyzw + -r5.xyzw;
    r3.xyzw = r2.yyyy * r3.xyzw + r5.xyzw;
    r3.xyzw = sqrt(r3.xyzw);
    r3.xyzw = r2.xxxx ? r3.xyzw : r1.xyzw;
    r1.xyzw = r2.zzzz ? r3.xyzw : r4.xyzw;
  }
  r0.xyz = (int3)r0.wxy + int3(-1,0,0);
  r2.x = g_txVertCount_10.Load(r0.xyz).x;
  r2.y = (int)r2.x & 136;
  if (r2.y != 0) {
    // Vertical resolve for the pixel to the left completes the four-pixel block.
    r2.y = (uint)r2.x >> 4;
    r2.y = (int)r2.y & 7;
    r2.x = (int)r2.x & 7;
    r3.xyzw = g_txInitialImage_10.Load(r0.xyz).xyzw;
    r2.z = (int)r2.y + (int)r2.x;
    r4.xyzw = r3.xyzw + -r1.xyzw;
    r4.xyzw = r4.xyzw * float4(0.125,0.125,0.125,0.125) + r1.xyzw;
    r2.w = (int)r2.z + 1;
    r2.w = (int)r2.w;
    r5.x = 0.5 * r2.w;
    r5.y = (int)r2.y;
    r6.xzw = float3(0,0,0);
    r6.y = r2.y;
    r6.xyzw = (int4)r0.xyzz + (int4)r6.xyzw;
    r6.xyzw = g_txInitialImage_10.Load(r6.xyz).xyzw;
    r7.xzw = float3(0,0,0);
    r7.y = (int)r2.y + 1;
    r7.xyzw = (int4)r0.xyzz + (int4)r7.xyzw;
    r7.xyzw = g_txInitialImage_10.Load(r7.xyz).xyzw;
    r6.xyz = -r7.xyz + r6.xyz;
    r6.xyz = cmp(float3(0.0625,0.0625,0.0625) < abs(r6.xyz));
    r0.x = (int)r6.y | (int)r6.x;
    r0.x = (int)r6.z | (int)r0.x;
    r2.y = (int)r0.x & 1;
    r6.y = -(int)r2.x;
    r6.xzw = float3(-1,0,0);
    r7.xyzw = (int4)r0.wyzz + (int4)r6.xyzw;
    r7.xyzw = g_txInitialImage_10.Load(r7.xyz).xyzw;
    r6.y = (int)r6.y + (int)r0.y;
    r8.xzw = r0.wzz;
    r8.y = -1;
    r6.xzw = float3(-1,0,0);
    r6.xyzw = (int4)r8.xyzw + (int4)r6.xyzw;
    r6.xyzw = g_txInitialImage_10.Load(r6.xyz).xyzw;
    r0.yzw = r7.xyz + -r6.xyz;
    r0.yzw = cmp(float3(0.0625,0.0625,0.0625) < abs(r0.yzw));
    r0.y = (int)r0.z | (int)r0.y;
    r0.y = (int)r0.w | (int)r0.y;
    r0.x = r0.x ? 3 : 2;
    r0.x = r0.y ? r0.x : r2.y;
    r0.xyz = cmp((int3)r0.xxx == int3(2,1,0));
    r0.w = cmp(r5.x >= r5.y);
    r0.x = r0.w ? r0.x : 0;
    r0.w = cmp(r5.y >= r5.x);
    r0.y = r0.w ? r0.y : 0;
    r0.x = (int)r0.y | (int)r0.x;
    r0.x = (int)r0.z | (int)r0.x;
    r0.y = 1 / r2.w;
    r0.z = -r5.y + r2.w;
    r0.w = r0.y * r0.z + -0.5;
    r0.z = -1 + r0.z;
    r0.y = r0.y * r0.z + -0.5;
    r0.y = abs(r0.w) + abs(r0.y);
    r0.y = 0.5 * r0.y;
    r5.xyzw = r1.xyzw * r1.xyzw;
    r3.xyzw = r3.xyzw * r3.xyzw + -r5.xyzw;
    r3.xyzw = r0.yyyy * r3.xyzw + r5.xyzw;
    r3.xyzw = sqrt(r3.xyzw);
    r0.xyzw = r0.xxxx ? r3.xyzw : r1.xyzw;
    o0.xyzw = r2.zzzz ? r0.xyzw : r4.xyzw;
  } else {
    o0.xyzw = r1.xyzw;
  }
  return;
}