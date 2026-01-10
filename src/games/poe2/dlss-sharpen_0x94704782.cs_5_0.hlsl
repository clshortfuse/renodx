// ---- Created with 3Dmigoto v1.4.1 on Wed Dec  3 06:00:59 2025
// Groupshared tile of luminance samples (each struct stores a 38-element row slice).
groupshared struct { float val[38]; } g0[38];
Texture2D<float4> t0 : register(t0);
RWTexture2D<float4> u0 : register(u0);

SamplerState s1_s : register(s1);

cbuffer cb0 : register(b0)
{
  float4 cb0[7];
}

static const bool kBypassSharpen = true;



// 3Dmigoto declarations
#define cmp -


[numthreads(256, 1, 1)]
void main(uint3 vThreadID : SV_DispatchThreadID,
          uint3 vThreadGroupID : SV_GroupID,
          uint3 vThreadIDInGroup : SV_GroupThreadID)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;
  // Compute the pixel-space origin of this thread group (block of 32x32 texels).
  r0.xy = (uint2)vThreadGroupID.xy << int2(5,5);
  // Two samples per thread lane → each lane walks over a column pair.
  r0.z = (uint)vThreadIDInGroup.x << 1;
  r0.w = r0.z;
  // ---------------------------------------------------------------------------
  // Stage 1: Gather luminance samples into shared memory.
  // Each lane iterates over its assigned column pair, converts them to biased
  // UVs (including cb0[4].xy scale/offset), and stores sqrt(luma) values in g0.
  // ---------------------------------------------------------------------------
  while (true) {
    r1.x = cmp((int)r0.w >= 722);
    if (r1.x != 0) break;
    uiDest.x = (uint)r0.w / 38;
    r2.x = (uint)r0.w % 38;
    r1.x = uiDest.x;
    r1.y = (uint)r1.x << 1;
    r1.z = (int)r0.x + (int)r2.x;
    r1.z = (int)r1.z + asint(cb0[4].z);
    r1.w = (uint)r1.z;
    r1.w = -1.5 + r1.w;
    r3.y = cb0[4].x * r1.w;
    r1.w = (int)r0.y + (int)r1.y;
    r1.w = (int)r1.w + asint(cb0[4].w);
    r2.y = (uint)r1.w;
    r2.y = -1.5 + r2.y;
    r3.z = cb0[4].y * r2.y;
    r2.yzw = t0.SampleLevel(s1_s, r3.yz, 0).xyz;
    r2.x = (uint)r2.x << 2;
    r2.y = dot(r2.yzw, float3(0.212599993,0.715200007,0.0722000003));
    r2.y = sqrt(r2.y);
    r4.x = 0.282842726 * r2.y;
    r1.z = (int)r1.z + 1;
    r1.z = (uint)r1.z;
    r1.z = -1.5 + r1.z;
    r3.x = cb0[4].x * r1.z;
    r2.yzw = t0.SampleLevel(s1_s, r3.xz, 0).xyz;
    r1.z = dot(r2.yzw, float3(0.212599993,0.715200007,0.0722000003));
    r1.z = sqrt(r1.z);
    r4.y = 0.282842726 * r1.z;
    g0[r1.y].val[r2.x/4] = r4.x;
    g0[r1.y].val[r2.x/4+1] = r4.y;
    r1.z = (int)r1.w + 1;
    r1.z = (uint)r1.z;
    r1.z = -1.5 + r1.z;
    r3.w = cb0[4].y * r1.z;
    r2.yzw = t0.SampleLevel(s1_s, r3.yw, 0).xyz;
    bitmask.x = ((~(-1 << 31)) << 1) & 0xffffffff;  r1.x = (((uint)r1.x << 1) & bitmask.x) | ((uint)1 & ~bitmask.x);
    r1.z = dot(r2.yzw, float3(0.212599993,0.715200007,0.0722000003));
    r1.z = sqrt(r1.z);
    r4.x = 0.282842726 * r1.z;
    r2.yzw = t0.SampleLevel(s1_s, r3.xw, 0).xyz;
    r1.z = dot(r2.yzw, float3(0.212599993,0.715200007,0.0722000003));
    r1.z = sqrt(r1.z);
    r4.y = 0.282842726 * r1.z;
    g0[r1.x].val[r2.x/4] = r4.x;
    g0[r1.x].val[r2.x/4+1] = r4.y;
    r0.w = (int)r0.w + 512;
  }
  GroupMemoryBarrierWithGroupSync();
  // ---------------------------------------------------------------------------
  // Stage 2: Each lane now consumes the shared tile, runs the adaptive
  // derivative-based sharpness estimator, and eventually writes one pixel.
  // ---------------------------------------------------------------------------
  r0.x = vThreadIDInGroup.x;
  while (true) {
    r0.z = cmp((int)r0.x >= 1024);
    if (r0.z != 0) break;
    r0.z = (uint)r0.x >> 5;
    bitmask.w = ((~(-1 << 27)) << 5) & 0xffffffff;  r0.w = (((uint)vThreadGroupID.x << 5) & bitmask.w) | ((uint)r0.x & ~bitmask.w);
    r1.x = (int)r0.z + (int)r0.y;
    r1.y = cmp(asuint(cb0[6].x) < (uint)r0.w);
    r1.z = cmp(asuint(cb0[6].y) < (uint)r1.x);
    r1.y = (int)r1.z | (int)r1.y;
    if (r1.y == 0) {
      bitmask.y = ((~(-1 << 5)) << 2) & 0xffffffff;  r1.y = (((uint)r0.x << 2) & bitmask.y) | ((uint)0 & ~bitmask.y);
      r2.xyz = (int3)r1.yyy + int3(8,4,16);
      r1.z = g0[r0.z].val[r2.x/4];
      r3.xyzw = (int4)r0.zzzz + int4(1,2,3,4);
      r4.x = g0[r3.x].val[r2.y/4];
      r4.y = g0[r3.x].val[r2.y/4+1];
      r4.z = g0[r3.x].val[r2.y/4+2];
      r5.x = g0[r3.y].val[r1.y/4];
      r5.y = g0[r3.y].val[r1.y/4+1];
      r5.z = g0[r3.y].val[r1.y/4+2];
      r5.w = g0[r3.y].val[r1.y/4+3];
      r0.z = g0[r3.y].val[r2.z/4];
      r2.y = g0[r3.z].val[r2.y/4];
      r2.z = g0[r3.z].val[r2.y/4+1];
      r2.w = g0[r3.z].val[r2.y/4+2];
      r1.y = g0[r3.w].val[r2.x/4];
      if (kBypassSharpen) {
        int sampleX = (int)r0.w + asint(cb0[4].z);
        int sampleY = (int)r1.x + asint(cb0[4].w);
        float2 passthroughUV = float2(cb0[4].x * (float(sampleX) + 0.5),
                                      cb0[4].y * (float(sampleY) + 0.5));
        int storeX = (int)r0.w + asint(cb0[5].z);
        int storeY = (int)r1.x + asint(cb0[5].w);
        uint2 store_xy = uint2(storeX, storeY);
        float4 passthroughColor = t0.SampleLevel(s1_s, passthroughUV, 0);
        u0[store_xy] = passthroughColor;
      } else {
        r1.w = -cb0[1].z + r5.z;
        r1.w = saturate(cb0[1].w * r1.w);
        r1.w = 1 + -r1.w;
        r3.xy = r1.ww * cb0[2].yw + cb0[2].xz;
        r1.w = r3.y * r5.z;
        r3.yz = float2(1.20019996,-0.600099981) * r5.zy;
        r2.x = r4.y * -0.600099981 + r3.y;
        r2.x = -r2.z * 0.600099981 + r2.x;
        r2.x = r2.x * r3.x;
        r2.x = max(r2.x, -r1.w);
        r2.x = min(r2.x, r1.w);
        r3.w = min(r4.y, r1.z);
        r3.w = min(r3.w, r5.z);
        r1.z = max(r4.y, r1.z);
        r1.z = max(r1.z, r5.z);
        r4.w = min(r5.z, r2.z);
        r4.w = min(r4.w, r1.y);
        r6.x = max(r5.z, r2.z);
        r1.y = max(r6.x, r1.y);
        r1.z = r1.z + -r3.w;
        r1.y = r1.y + -r4.w;
        r3.w = max(r1.z, r1.y);
        r1.y = min(r1.z, r1.y);
        r1.y = cb0[1].y + r1.y;
        r1.y = r3.w / r1.y;
        r1.y = -cb0[0].z + r1.y;
        r1.y = saturate(cb0[0].w * r1.y);
        r1.y = 1 + -r1.y;
        r1.y = cb0[1].x * r1.y;
        r1.y = r2.x * r1.y;
        r1.z = r3.z + r3.y;
        r1.z = -r5.w * 0.600099981 + r1.z;
        r1.z = r1.z * r3.x;
        r1.z = max(-r1.w, r1.z);
        r1.z = min(r1.w, r1.z);
        r3.zw = min(r5.xz, r5.yw);
        r2.x = min(r3.z, r5.z);
        r6.xy = max(r5.xz, r5.yw);
        r3.z = max(r6.x, r5.z);
        r3.w = min(r3.w, r0.z);
        r0.z = max(r6.y, r0.z);
        r2.x = r3.z + -r2.x;
        r0.z = r0.z + -r3.w;
        r3.z = max(r2.x, r0.z);
        r0.z = min(r2.x, r0.z);
        r0.z = cb0[1].y + r0.z;
        r0.z = r3.z / r0.z;
        r0.z = -cb0[0].z + r0.z;
        r0.z = saturate(cb0[0].w * r0.z);
        r0.z = 1 + -r0.z;
        r0.z = cb0[1].x * r0.z;
        r0.z = r1.z * r0.z;
        r3.zw = -r5.yw + r4.yy;
        r3.zw = r3.zw * float2(0.5,0.5) + r5.yw;
        r6.xy = r5.wy + -r2.zz;
        r6.xy = r6.xy * float2(0.5,0.5) + r2.zz;
        r1.z = r3.z * -0.600099981 + r3.y;
        r1.z = -r6.x * 0.600099981 + r1.z;
        r1.z = r1.z * r3.x;
        r1.z = max(-r1.w, r1.z);
        r1.z = min(r1.w, r1.z);
        r2.x = min(r4.x, r3.z);
        r2.x = min(r2.x, r5.z);
        r3.z = max(r4.x, r3.z);
        r3.z = max(r3.z, r5.z);
        r4.w = min(r6.x, r5.z);
        r4.w = min(r4.w, r2.w);
        r5.x = max(r6.x, r5.z);
        r5.x = max(r5.x, r2.w);
        r2.x = r3.z + -r2.x;
        r3.z = r5.x + -r4.w;
        r4.w = max(r3.z, r2.x);
        r2.x = min(r3.z, r2.x);
        r2.x = cb0[1].y + r2.x;
        r2.x = r4.w / r2.x;
        r2.x = -cb0[0].z + r2.x;
        r2.x = saturate(cb0[0].w * r2.x);
        r2.x = 1 + -r2.x;
        r2.x = cb0[1].x * r2.x;
        r1.z = r2.x * r1.z;
        r2.x = r6.y * -0.600099981 + r3.y;
        r2.x = -r3.w * 0.600099981 + r2.x;
        r2.x = r2.x * r3.x;
        r2.x = max(r2.x, -r1.w);
        r1.w = min(r2.x, r1.w);
        r2.x = min(r6.y, r2.y);
        r2.x = min(r2.x, r5.z);
        r3.x = max(r6.y, r2.y);
        r3.x = max(r3.x, r5.z);
        r3.y = min(r5.z, r3.w);
        r3.y = min(r3.y, r4.z);
        r3.z = max(r5.z, r3.w);
        r3.z = max(r3.z, r4.z);
        r2.x = r3.x + -r2.x;
        r3.x = r3.z + -r3.y;
        r3.y = max(r3.x, r2.x);
        r2.x = min(r3.x, r2.x);
        r2.x = cb0[1].y + r2.x;
        r2.x = r3.y / r2.x;
        r2.x = -cb0[0].z + r2.x;
        r2.x = saturate(cb0[0].w * r2.x);
        r2.x = 1 + -r2.x;
        r2.x = cb0[1].x * r2.x;
        r1.w = r2.x * r1.w;
        r2.x = r4.x + r4.y;
        r2.x = r2.x + r4.z;
        r2.x = r2.x + -r2.y;
        r2.x = r2.x + -r2.z;
        r2.x = r2.x + -r2.w;
        r3.x = r5.y + r4.x;
        r3.y = r3.x + r4.y;
        r3.y = r3.y + -r2.z;
        r3.y = r3.y + -r2.w;
        r3.x = r3.x + r2.y;
        r3.x = r3.x + -r4.z;
        r3.xy = r3.xy + -r5.ww;
        r2.w = r3.x + -r2.w;
        r2.y = r5.y + r2.y;
        r2.y = r2.y + r2.z;
        r2.y = r2.y + -r4.y;
        r2.y = r2.y + -r4.z;
        r2.y = r2.y + -r5.w;
        r2.z = max(abs(r2.x), abs(r2.w));
        r2.w = min(abs(r2.x), abs(r2.w));
        r3.x = max(abs(r3.y), abs(r2.y));
        r2.y = min(abs(r3.y), abs(r2.y));
        r3.z = r3.x + r2.z;
        r3.w = cmp(r3.z != 0.000000);
        r3.z = r2.z / r3.z;
        r3.z = min(1, r3.z);
        r4.x = 1 + -r3.z;
        r4.y = cb0[0].x * r2.w;
        r4.y = cmp(r4.y < r2.z);
        r4.z = cmp(cb0[0].y < r2.z);
        r4.y = r4.z ? r4.y : 0;
        r4.z = cmp(r2.y < r2.z);
        r4.y = r4.z ? r4.y : 0;
        r2.y = cb0[0].x * r2.y;
        r2.yw = cmp(r2.yw < r3.xx);
        r4.z = cmp(cb0[0].y < r3.x);
        r2.y = r2.y ? r4.z : 0;
        r2.y = r2.w ? r2.y : 0;
        r2.x = cmp(abs(r2.x) == r2.z);
        r2.z = cmp(abs(r3.y) == r3.x);
        r2.w = r2.y ? r4.y : 0;
        r3.x = r2.w ? r3.z : 1;
        r2.w = r2.w ? r4.x : 1;
        r3.y = r2.x ? r4.y : 0;
        r6.x = (int)r3.x & (int)r3.y;
        r2.x = ~(int)r2.x;
        r2.x = r2.x ? r4.y : 0;
        r6.y = r2.x ? r3.x : 0;
        r2.x = r2.z ? r2.y : 0;
        r6.z = r2.x ? r2.w : 0;
        r2.x = ~(int)r2.z;
        r2.x = r2.x ? r2.y : 0;
        r6.w = r2.x ? r2.w : 0;
        r2.xyzw = r3.wwww ? r6.xyzw : 0;
        r0.z = r2.y * r0.z;
        r0.z = r1.y * r2.x + r0.z;
        r0.z = r1.z * r2.z + r0.z;
        r0.z = r1.w * r2.w + r0.z;
        r1.y = (int)r0.w + asint(cb0[4].z);
        r1.y = (uint)r1.y;
        r1.y = 0.5 + r1.y;
        r2.x = cb0[4].x * r1.y;
        r1.y = (int)r1.x + asint(cb0[4].w);
        r1.y = (uint)r1.y;
        r1.y = 0.5 + r1.y;
        r2.y = cb0[4].y * r1.y;
        r3.x = (int)r0.w + asint(cb0[5].z);
        r3.yzw = (int3)r1.xxx + asint(cb0[5].www);
        r1.xyzw = t0.SampleLevel(s1_s, r2.xy, 0).xyzw;
        r0.z = r5.z + r0.z;
        r0.z = max(0, r0.z);
        r0.z = r0.z * r0.z + 7.99999998e-06;
        r0.w = r5.z * r5.z + 7.99999998e-06;
        r0.z = r0.z / r0.w;
        r1.xyz = r1.xyz * r0.zzz;
        uint2 store_xy = uint2(r3.x, r3.y);
        u0[store_xy] = r1;
      }
    }
    r0.x = (int)r0.x + 256;
  }
  return;
}