#include "./common.hlsli"
cbuffer cb0 : register(b0) {
  float4 cb0[8];
}

RWTexture3D<float4> u0 : register(u0);  // unknown dcl_: dcl_uav_typed_texture3d (unorm,unorm,unorm,unorm) u0

// 3Dmigoto declarations
#define cmp -

[numthreads(32, 32, 1)]
void main(uint3 vThreadID: SV_DispatchThreadID)  // unknown dcl_: dcl_thread_group 32, 32, 1
{
  float4 r0, r1, r2, r3, r4, r5, r6, r7, r8;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = (uint3)vThreadID.xyz;
  r1.xyz = float3(0.0158730168, 0.0158730168, 0.0158730168) * r0.xyz;
  r0.w = 10000 / cb0[6].x;
  r0.xyz = cmp(r0.xyz == float3(0, 0, 0));
  r1.xyz = log2(r1.xyz);
  r1.xyz = float3(0.0126833133, 0.0126833133, 0.0126833133) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r0.xyz = r0.xyz ? float3(0, 0, 0) : r1.xyz;
  r1.xyz = float3(-0.8359375, -0.8359375, -0.8359375) + r0.xyz;
  r1.xyz = max(float3(0, 0, 0), r1.xyz);
  r0.xyz = -r0.xyz * float3(18.6875, 18.6875, 18.6875) + float3(18.8515625, 18.8515625, 18.8515625);
  r0.xyz = r1.xyz / r0.xyz;
  r1.xyz = cmp(r0.xyz == float3(0, 0, 0));
  r0.xyz = log2(abs(r0.xyz));
  r0.xyz = float3(6.27739477, 6.27739477, 6.27739477) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = float3(10000, 10000, 10000) * r0.xyz;
  r0.xyz = r1.xyz ? float3(0, 0, 0) : r0.xyz;
  r0.xyz = r0.xyz / r0.www;

  float3 untonemapped_ap1 = r0.rgb;

#if RENODX_TONE_MAP_TYPE

  float3 untonemapped_bt709 = renodx::color::bt709::from::AP1(untonemapped_ap1);
  r0.rgb = ApplyUserToneMap(untonemapped_bt709, 0.18);
  r0.rgb = renodx::color::correct::GammaSafe(r0.rgb);
  r0.rgb = renodx::color::bt2020::from::BT709(r0.rgb);

  r0.rgb = renodx::color::pq::EncodeSafe(r0.rgb, 100.f);

  u0[vThreadID] = r0;  // store_uav_typed u0.xyzw, vThreadID.xyzz, r1.xyzw
  return;
#endif



  // AP1 -> AP0
  r1.y = dot(float3(0.695452213, 0.140678704, 0.163869068), r0.xyz);
  r1.z = dot(float3(0.0447945632, 0.859671116, 0.0955343172), r0.xyz);
  r1.w = dot(float3(-0.00552588282, 0.00402521016, 1.00150073), r0.xyz);

  r0.y = dot(float3(0.940437257, -0.0183068793, 0.077869609), r1.yzw);
  r0.z = dot(float3(0.00837869663, 0.828660011, 0.162961304), r1.yzw);
  r0.w = dot(float3(0.00054712611, -0.000883374596, 1.00033629), r1.yzw);
  r0.xyz = r0.yzw + -r1.yzw;
  r0.xyz = cb0[7].xxx * r0.xyz + r1.yzw;
  r0.w = min(r0.x, r0.y);
  r0.w = min(r0.w, r0.z);
  r1.x = max(r0.x, r0.y);
  r1.x = max(r1.x, r0.z);
  r1.xy = max(float2(1.00000001e-10, 0.00999999978), r1.xx);
  r0.w = max(1.00000001e-10, r0.w);
  r0.w = r1.x + -r0.w;
  r0.w = r0.w / r1.y;
  r1.xyz = r0.zyx + -r0.yxz;
  r1.xy = r1.xy * r0.zy;
  r1.x = r1.x + r1.y;
  r1.x = r0.x * r1.z + r1.x;
  r1.x = sqrt(r1.x);
  r1.y = r0.z + r0.y;
  r1.y = r1.y + r0.x;
  r1.x = r1.x * 1.75 + r1.y;
  r1.z = -0.400000006 + r0.w;
  r1.yw = float2(0.333333343, 2.5) * r1.xz;
  r1.w = 1 + -abs(r1.w);
  r1.w = max(0, r1.w);
  r2.x = cmp(0 < r1.z);
  r1.z = cmp(r1.z < 0);
  r1.z = (int)-r2.x + (int)r1.z;
  r1.z = (int)r1.z;
  r1.w = -r1.w * r1.w + 1;
  r1.z = r1.z * r1.w + 1;
  r1.z = 0.0250000004 * r1.z;
  r1.w = cmp(0.159999996 >= r1.x);
  r1.x = cmp(r1.x >= 0.479999989);
  r1.y = 0.0799999982 / r1.y;
  r1.y = -0.5 + r1.y;
  r1.y = r1.z * r1.y;
  r1.x = r1.x ? 0 : r1.y;
  r1.x = r1.w ? r1.z : r1.x;
  r1.x = 1 + r1.x;
  r2.yzw = r1.xxx * r0.xyz;
  r1.yz = cmp(r2.zw == r2.yz);
  r1.y = r1.z ? r1.y : 0;
  r0.y = r0.y * r1.x + -r2.w;
  r0.y = 1.73205078 * r0.y;
  r1.z = r2.y * 2 + -r2.z;
  r0.z = -r0.z * r1.x + r1.z;
  r1.z = min(abs(r0.y), abs(r0.z));
  r1.w = max(abs(r0.y), abs(r0.z));
  r1.w = 1 / r1.w;
  r1.z = r1.z * r1.w;
  r1.w = r1.z * r1.z;
  r3.x = r1.w * 0.0208350997 + -0.0851330012;
  r3.x = r1.w * r3.x + 0.180141002;
  r3.x = r1.w * r3.x + -0.330299497;
  r1.w = r1.w * r3.x + 0.999866009;
  r3.x = r1.z * r1.w;
  r3.y = cmp(abs(r0.z) < abs(r0.y));
  r3.x = r3.x * -2 + 1.57079637;
  r3.x = r3.y ? r3.x : 0;
  r1.z = r1.z * r1.w + r3.x;
  r1.w = cmp(r0.z < -r0.z);
  r1.w = r1.w ? -3.141593 : 0;
  r1.z = r1.z + r1.w;
  r1.w = min(r0.y, r0.z);
  r0.y = max(r0.y, r0.z);
  r0.z = cmp(r1.w < -r1.w);
  r0.y = cmp(r0.y >= -r0.y);
  r0.y = r0.y ? r0.z : 0;
  r0.y = r0.y ? -r1.z : r1.z;
  r0.y = 57.2957802 * r0.y;
  r0.y = r1.y ? 180 : r0.y;
  r0.z = cmp(r0.y < 0);
  r1.y = 360 + r0.y;
  r0.y = r0.z ? r1.y : r0.y;
  r0.y = max(0, r0.y);
  r0.y = min(360, r0.y);
  r0.z = cmp(180 < r0.y);
  r1.y = -360 + r0.y;
  r0.y = r0.z ? r1.y : r0.y;
  r0.z = cmp(-67.5 < r0.y);
  r1.y = cmp(r0.y < 67.5);
  r0.z = r0.z ? r1.y : 0;
  if (r0.z != 0) {
    r0.y = 67.5 + r0.y;
    r0.z = 0.0296296291 * r0.y;
    r1.y = (int)r0.z;
    r0.z = trunc(r0.z);
    r0.y = r0.y * 0.0296296291 + -r0.z;
    r0.z = r0.y * r0.y;
    r1.z = r0.z * r0.y;
    r3.xyz = float3(-0.166666672, -0.5, 0.166666672) * r1.zzz;
    r3.xy = r0.zz * float2(0.5, 0.5) + r3.xy;
    r3.xy = r0.yy * float2(-0.5, 0.5) + r3.xy;
    r0.y = r1.z * 0.5 + -r0.z;
    r0.y = 0.666666687 + r0.y;
    r4.xyz = cmp((int3)r1.yyy == int3(3, 2, 1));
    r1.zw = float2(0.166666672, 0.166666672) + r3.xy;
    r0.z = r1.y ? 0 : r3.z;
    r0.z = r4.z ? r1.w : r0.z;
    r0.y = r4.y ? r0.y : r0.z;
    r0.y = r4.x ? r1.z : r0.y;
  } else {
    r0.y = 0;
  }
  r0.y = r0.y * r0.w;
  r0.y = 1.5 * r0.y;
  r0.x = -r0.x * r1.x + 0.0299999993;
  r0.x = r0.y * r0.x;
  r2.x = r0.x * 0.180000007 + r2.y;
  r0.xyz = max(float3(0, 0, 0), r2.xzw);
  r0.xyz = min(float3(65504, 65504, 65504), r0.xyz);
  r1.x = dot(float3(1.45143926, -0.236510754, -0.214928567), r0.xyz);
  r1.y = dot(float3(-0.0765537769, 1.17622972, -0.0996759236), r0.xyz);
  r1.z = dot(float3(0.00831614807, -0.00603244966, 0.997716308), r0.xyz);
  r0.x = dot(r1.xyz, float3(0.272228718, 0.674081743, 0.0536895171));
  r0.yzw = r1.xyz + -r0.xxx;
  r0.xyz = r0.yzw * float3(0.959999979, 0.959999979, 0.959999979) + r0.xxx;
  r0.xyz = max(float3(6.10351562e-05, 6.10351562e-05, 6.10351562e-05), r0.xyz);
  r0.xyz = log2(r0.xyz);
  r1.xyz = float3(0.30103001, 0.30103001, 0.30103001) * r0.xyz;
  r2.xyz = cmp(cb0[0].xxx >= r1.xyz);
  if (r2.x != 0) {
    r0.w = -cb0[0].z * cb0[0].x + cb0[0].y;
    r0.w = r1.x * cb0[0].z + r0.w;
  } else {
    r1.w = cmp(r1.x < cb0[0].w);
    if (r1.w != 0) {
      r1.w = r0.x * 0.30103001 + -cb0[0].x;
      r1.w = 3 * r1.w;
      r2.x = cb0[0].w + -cb0[0].x;
      r1.w = r1.w / r2.x;
      r2.x = (int)r1.w;
      r2.w = trunc(r1.w);
      r3.y = -r2.w + r1.w;
      r4.xyzw = cmp((int4)r2.xxxx == int4(0, 1, 2, 3));
      r5.xy = cmp((int2)r2.xx == int2(4, 5));
      r4.xyzw = r4.xyzw ? float4(1, 1, 1, 1) : 0;
      r5.xy = r5.xy ? float2(1, 1) : 0;
      r1.w = dot(r4.xyz, cb0[2].yzw);
      r1.w = r4.w * cb0[3].x + r1.w;
      r1.w = r5.x * cb0[3].y + r1.w;
      r4.x = r5.y * cb0[3].z + r1.w;
      r5.xyzw = (int4)r2.xxxx + int4(1, 1, 2, 2);
      r6.xyzw = cmp((int4)r5.yyyy == int4(0, 1, 2, 3));
      r7.xyzw = cmp((int4)r5.xyzw == int4(4, 5, 4, 5));
      r6.xyzw = r6.xyzw ? float4(1, 1, 1, 1) : 0;
      r7.xyzw = r7.xyzw ? float4(1, 1, 1, 1) : 0;
      r1.w = dot(r6.xyz, cb0[2].yzw);
      r1.w = r6.w * cb0[3].x + r1.w;
      r1.w = r7.x * cb0[3].y + r1.w;
      r4.y = r7.y * cb0[3].z + r1.w;
      r5.xyzw = cmp((int4)r5.wwww == int4(0, 1, 2, 3));
      r5.xyzw = r5.xyzw ? float4(1, 1, 1, 1) : 0;
      r1.w = dot(r5.xyz, cb0[2].yzw);
      r1.w = r5.w * cb0[3].x + r1.w;
      r1.w = r7.z * cb0[3].y + r1.w;
      r4.z = r7.w * cb0[3].z + r1.w;
      r3.x = r3.y * r3.y;
      r5.x = dot(r4.xzy, float3(0.5, 0.5, -1));
      r5.y = dot(r4.xy, float2(-1, 1));
      r5.z = dot(r4.xy, float2(0.5, 0.5));
      r3.z = 1;
      r0.w = dot(r3.xyz, r5.xyz);
    } else {
      r1.w = cmp(r1.x < cb0[1].z);
      r0.x = r0.x * 0.30103001 + -cb0[0].w;
      r0.x = 3 * r0.x;
      r2.x = cb0[1].z + -cb0[0].w;
      r0.x = r0.x / r2.x;
      r2.x = (int)r0.x;
      r2.w = trunc(r0.x);
      r3.y = -r2.w + r0.x;
      r4.xyzw = cmp((int4)r2.xxxx == int4(0, 1, 2, 3));
      r5.xy = cmp((int2)r2.xx == int2(4, 5));
      r4.xyzw = r4.xyzw ? float4(1, 1, 1, 1) : 0;
      r5.xy = r5.xy ? float2(1, 1) : 0;
      r0.x = cb0[4].x * r4.y;
      r0.x = r4.x * cb0[3].w + r0.x;
      r0.x = r4.z * cb0[4].y + r0.x;
      r0.x = r4.w * cb0[4].z + r0.x;
      r0.x = r5.x * cb0[4].w + r0.x;
      r4.x = r5.y * cb0[5].x + r0.x;
      r5.xyzw = (int4)r2.xxxx + int4(1, 1, 2, 2);
      r6.xyzw = cmp((int4)r5.yyyy == int4(0, 1, 2, 3));
      r7.xyzw = cmp((int4)r5.xyzw == int4(4, 5, 4, 5));
      r6.xyzw = r6.xyzw ? float4(1, 1, 1, 1) : 0;
      r7.xyzw = r7.xyzw ? float4(1, 1, 1, 1) : 0;
      r0.x = cb0[4].x * r6.y;
      r0.x = r6.x * cb0[3].w + r0.x;
      r0.x = r6.z * cb0[4].y + r0.x;
      r0.x = r6.w * cb0[4].z + r0.x;
      r0.x = r7.x * cb0[4].w + r0.x;
      r4.y = r7.y * cb0[5].x + r0.x;
      r5.xyzw = cmp((int4)r5.wwww == int4(0, 1, 2, 3));
      r5.xyzw = r5.xyzw ? float4(1, 1, 1, 1) : 0;
      r0.x = cb0[4].x * r5.y;
      r0.x = r5.x * cb0[3].w + r0.x;
      r0.x = r5.z * cb0[4].y + r0.x;
      r0.x = r5.w * cb0[4].z + r0.x;
      r0.x = r7.z * cb0[4].w + r0.x;
      r4.z = r7.w * cb0[5].x + r0.x;
      r3.x = r3.y * r3.y;
      r5.x = dot(r4.xzy, float3(0.5, 0.5, -1));
      r5.y = dot(r4.xy, float2(-1, 1));
      r5.z = dot(r4.xy, float2(0.5, 0.5));
      r3.z = 1;
      r0.x = dot(r3.xyz, r5.xyz);
      r2.x = -cb0[2].x * cb0[1].z + cb0[1].w;
      r1.x = r1.x * cb0[2].x + r2.x;
      r0.w = r1.w ? r0.x : r1.x;
    }
  }
  r0.x = 3.32192802 * r0.w;
  r3.x = exp2(r0.x);
  if (r2.y != 0) {
    r0.x = -cb0[0].z * cb0[0].x + cb0[0].y;
    r0.x = r1.y * cb0[0].z + r0.x;
  } else {
    r0.w = cmp(r1.y < cb0[0].w);
    if (r0.w != 0) {
      r0.w = r0.y * 0.30103001 + -cb0[0].x;
      r0.w = 3 * r0.w;
      r1.x = cb0[0].w + -cb0[0].x;
      r0.w = r0.w / r1.x;
      r1.x = (int)r0.w;
      r1.w = trunc(r0.w);
      r4.y = -r1.w + r0.w;
      r5.xyzw = cmp((int4)r1.xxxx == int4(0, 1, 2, 3));
      r2.xy = cmp((int2)r1.xx == int2(4, 5));
      r5.xyzw = r5.xyzw ? float4(1, 1, 1, 1) : 0;
      r2.xy = r2.xy ? float2(1, 1) : 0;
      r0.w = dot(r5.xyz, cb0[2].yzw);
      r0.w = r5.w * cb0[3].x + r0.w;
      r0.w = r2.x * cb0[3].y + r0.w;
      r5.x = r2.y * cb0[3].z + r0.w;
      r6.xyzw = (int4)r1.xxxx + int4(1, 1, 2, 2);
      r7.xyzw = cmp((int4)r6.yyyy == int4(0, 1, 2, 3));
      r8.xyzw = cmp((int4)r6.xyzw == int4(4, 5, 4, 5));
      r7.xyzw = r7.xyzw ? float4(1, 1, 1, 1) : 0;
      r8.xyzw = r8.xyzw ? float4(1, 1, 1, 1) : 0;
      r0.w = dot(r7.xyz, cb0[2].yzw);
      r0.w = r7.w * cb0[3].x + r0.w;
      r0.w = r8.x * cb0[3].y + r0.w;
      r5.y = r8.y * cb0[3].z + r0.w;
      r6.xyzw = cmp((int4)r6.wwww == int4(0, 1, 2, 3));
      r6.xyzw = r6.xyzw ? float4(1, 1, 1, 1) : 0;
      r0.w = dot(r6.xyz, cb0[2].yzw);
      r0.w = r6.w * cb0[3].x + r0.w;
      r0.w = r8.z * cb0[3].y + r0.w;
      r5.z = r8.w * cb0[3].z + r0.w;
      r4.x = r4.y * r4.y;
      r6.x = dot(r5.xzy, float3(0.5, 0.5, -1));
      r6.y = dot(r5.xy, float2(-1, 1));
      r6.z = dot(r5.xy, float2(0.5, 0.5));
      r4.z = 1;
      r0.x = dot(r4.xyz, r6.xyz);
    } else {
      r0.w = cmp(r1.y < cb0[1].z);
      r0.y = r0.y * 0.30103001 + -cb0[0].w;
      r0.y = 3 * r0.y;
      r1.x = cb0[1].z + -cb0[0].w;
      r0.y = r0.y / r1.x;
      r1.x = (int)r0.y;
      r1.w = trunc(r0.y);
      r4.y = -r1.w + r0.y;
      r5.xyzw = cmp((int4)r1.xxxx == int4(0, 1, 2, 3));
      r2.xy = cmp((int2)r1.xx == int2(4, 5));
      r5.xyzw = r5.xyzw ? float4(1, 1, 1, 1) : 0;
      r2.xy = r2.xy ? float2(1, 1) : 0;
      r0.y = cb0[4].x * r5.y;
      r0.y = r5.x * cb0[3].w + r0.y;
      r0.y = r5.z * cb0[4].y + r0.y;
      r0.y = r5.w * cb0[4].z + r0.y;
      r0.y = r2.x * cb0[4].w + r0.y;
      r5.x = r2.y * cb0[5].x + r0.y;
      r6.xyzw = (int4)r1.xxxx + int4(1, 1, 2, 2);
      r7.xyzw = cmp((int4)r6.yyyy == int4(0, 1, 2, 3));
      r8.xyzw = cmp((int4)r6.xyzw == int4(4, 5, 4, 5));
      r7.xyzw = r7.xyzw ? float4(1, 1, 1, 1) : 0;
      r8.xyzw = r8.xyzw ? float4(1, 1, 1, 1) : 0;
      r0.y = cb0[4].x * r7.y;
      r0.y = r7.x * cb0[3].w + r0.y;
      r0.y = r7.z * cb0[4].y + r0.y;
      r0.y = r7.w * cb0[4].z + r0.y;
      r0.y = r8.x * cb0[4].w + r0.y;
      r5.y = r8.y * cb0[5].x + r0.y;
      r6.xyzw = cmp((int4)r6.wwww == int4(0, 1, 2, 3));
      r6.xyzw = r6.xyzw ? float4(1, 1, 1, 1) : 0;
      r0.y = cb0[4].x * r6.y;
      r0.y = r6.x * cb0[3].w + r0.y;
      r0.y = r6.z * cb0[4].y + r0.y;
      r0.y = r6.w * cb0[4].z + r0.y;
      r0.y = r8.z * cb0[4].w + r0.y;
      r5.z = r8.w * cb0[5].x + r0.y;
      r4.x = r4.y * r4.y;
      r6.x = dot(r5.xzy, float3(0.5, 0.5, -1));
      r6.y = dot(r5.xy, float2(-1, 1));
      r6.z = dot(r5.xy, float2(0.5, 0.5));
      r4.z = 1;
      r0.y = dot(r4.xyz, r6.xyz);
      r1.x = -cb0[2].x * cb0[1].z + cb0[1].w;
      r1.x = r1.y * cb0[2].x + r1.x;
      r0.x = r0.w ? r0.y : r1.x;
    }
  }
  r0.x = 3.32192802 * r0.x;
  r3.y = exp2(r0.x);
  if (r2.z != 0) {
    r0.x = -cb0[0].z * cb0[0].x + cb0[0].y;
    r0.x = r1.z * cb0[0].z + r0.x;
  } else {
    r0.y = cmp(r1.z < cb0[0].w);
    if (r0.y != 0) {
      r0.y = r0.z * 0.30103001 + -cb0[0].x;
      r0.y = 3 * r0.y;
      r0.w = cb0[0].w + -cb0[0].x;
      r0.y = r0.y / r0.w;
      r0.w = (int)r0.y;
      r1.x = trunc(r0.y);
      r2.y = -r1.x + r0.y;
      r4.xyzw = cmp((int4)r0.wwww == int4(0, 1, 2, 3));
      r1.xy = cmp((int2)r0.ww == int2(4, 5));
      r4.xyzw = r4.xyzw ? float4(1, 1, 1, 1) : 0;
      r1.xy = r1.xy ? float2(1, 1) : 0;
      r0.y = dot(r4.xyz, cb0[2].yzw);
      r0.y = r4.w * cb0[3].x + r0.y;
      r0.y = r1.x * cb0[3].y + r0.y;
      r4.x = r1.y * cb0[3].z + r0.y;
      r5.xyzw = (int4)r0.wwww + int4(1, 1, 2, 2);
      r6.xyzw = cmp((int4)r5.yyyy == int4(0, 1, 2, 3));
      r7.xyzw = cmp((int4)r5.xyzw == int4(4, 5, 4, 5));
      r6.xyzw = r6.xyzw ? float4(1, 1, 1, 1) : 0;
      r7.xyzw = r7.xyzw ? float4(1, 1, 1, 1) : 0;
      r0.y = dot(r6.xyz, cb0[2].yzw);
      r0.y = r6.w * cb0[3].x + r0.y;
      r0.y = r7.x * cb0[3].y + r0.y;
      r4.y = r7.y * cb0[3].z + r0.y;
      r5.xyzw = cmp((int4)r5.wwww == int4(0, 1, 2, 3));
      r5.xyzw = r5.xyzw ? float4(1, 1, 1, 1) : 0;
      r0.y = dot(r5.xyz, cb0[2].yzw);
      r0.y = r5.w * cb0[3].x + r0.y;
      r0.y = r7.z * cb0[3].y + r0.y;
      r4.z = r7.w * cb0[3].z + r0.y;
      r2.x = r2.y * r2.y;
      r5.x = dot(r4.xzy, float3(0.5, 0.5, -1));
      r5.y = dot(r4.xy, float2(-1, 1));
      r5.z = dot(r4.xy, float2(0.5, 0.5));
      r2.z = 1;
      r0.x = dot(r2.xyz, r5.xyz);
    } else {
      r0.y = cmp(r1.z < cb0[1].z);
      r0.z = r0.z * 0.30103001 + -cb0[0].w;
      r0.z = 3 * r0.z;
      r0.w = cb0[1].z + -cb0[0].w;
      r0.z = r0.z / r0.w;
      r0.w = (int)r0.z;
      r1.x = trunc(r0.z);
      r2.y = -r1.x + r0.z;
      r4.xyzw = cmp((int4)r0.wwww == int4(0, 1, 2, 3));
      r1.xy = cmp((int2)r0.ww == int2(4, 5));
      r4.xyzw = r4.xyzw ? float4(1, 1, 1, 1) : 0;
      r1.xy = r1.xy ? float2(1, 1) : 0;
      r0.z = cb0[4].x * r4.y;
      r0.z = r4.x * cb0[3].w + r0.z;
      r0.z = r4.z * cb0[4].y + r0.z;
      r0.z = r4.w * cb0[4].z + r0.z;
      r0.z = r1.x * cb0[4].w + r0.z;
      r4.x = r1.y * cb0[5].x + r0.z;
      r5.xyzw = (int4)r0.wwww + int4(1, 1, 2, 2);
      r6.xyzw = cmp((int4)r5.yyyy == int4(0, 1, 2, 3));
      r7.xyzw = cmp((int4)r5.xyzw == int4(4, 5, 4, 5));
      r6.xyzw = r6.xyzw ? float4(1, 1, 1, 1) : 0;
      r7.xyzw = r7.xyzw ? float4(1, 1, 1, 1) : 0;
      r0.z = cb0[4].x * r6.y;
      r0.z = r6.x * cb0[3].w + r0.z;
      r0.z = r6.z * cb0[4].y + r0.z;
      r0.z = r6.w * cb0[4].z + r0.z;
      r0.z = r7.x * cb0[4].w + r0.z;
      r4.y = r7.y * cb0[5].x + r0.z;
      r5.xyzw = cmp((int4)r5.wwww == int4(0, 1, 2, 3));
      r5.xyzw = r5.xyzw ? float4(1, 1, 1, 1) : 0;
      r0.z = cb0[4].x * r5.y;
      r0.z = r5.x * cb0[3].w + r0.z;
      r0.z = r5.z * cb0[4].y + r0.z;
      r0.z = r5.w * cb0[4].z + r0.z;
      r0.z = r7.z * cb0[4].w + r0.z;
      r4.z = r7.w * cb0[5].x + r0.z;
      r2.x = r2.y * r2.y;
      r5.x = dot(r4.xzy, float3(0.5, 0.5, -1));
      r5.y = dot(r4.xy, float2(-1, 1));
      r5.z = dot(r4.xy, float2(0.5, 0.5));
      r2.z = 1;
      r0.z = dot(r2.xyz, r5.xyz);
      r0.w = -cb0[2].x * cb0[1].z + cb0[1].w;
      r0.w = r1.z * cb0[2].x + r0.w;
      r0.x = r0.y ? r0.z : r0.w;
    }
  }
  r0.x = 3.32192802 * r0.x;
  r3.z = exp2(r0.x);
  r0.xyz = max(cb0[5].yyy, r3.xyz);
  r1.x = dot(float3(1.06537485, 1.44673368e-06, -0.0653710067), r0.xyz);
  r1.y = dot(float3(-3.4558721e-07, 1.20366347, -0.203667715), r0.xyz);
  r1.z = dot(float3(1.98354986e-08, 2.12240607e-08, 0.999999583), r0.xyz);
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = cb0[7].xxx * r1.xyz + r0.xyz;
  r1.xyz = cmp(cb0[5].yyy < r0.xyz);
  r0.xyz = -cb0[5].yyy + r0.xyz;
  r0.w = cb0[5].w + -cb0[5].y;
  r0.xyz = r0.xyz / r0.www;
  r0.xyz = r1.xyz ? r0.xyz : 0;
  r1.xyz = cmp(float3(0.00100000005, 0.00100000005, 0.00100000005) < r0.xyz);
  r2.xyz = saturate(r0.xyz);
  r0.w = dot(float3(0.652237535, 0.1282361, 0.169982255), r2.xyz);
  r1.w = dot(float3(0.267671794, 0.674338996, 0.0579877384), r2.xyz);
  r2.x = dot(float3(-0.00538181374, 0.00136906456, 1.09306991), r2.xyz);
  r2.y = r1.w + r0.w;
  r2.x = r2.y + r2.x;
  r2.y = cmp(r2.x == 0.000000);
  r2.x = r2.y ? 1.00000001e-10 : r2.x;
  r0.w = r0.w / r2.x;
  r2.x = r1.w / r2.x;
  r2.y = cmp(0 >= r1.w);
  r1.w = log2(r1.w);
  r1.w = 0.981100023 * r1.w;
  r1.w = exp2(r1.w);
  r3.y = r2.y ? 0 : r1.w;
  r1.w = r3.y * r0.w;
  r2.y = max(1.00000001e-10, r2.x);
  r3.x = r1.w / r2.y;
  r0.w = 1 + -r0.w;
  r0.w = r0.w + -r2.x;
  r0.w = r0.w * r3.y;
  r3.z = r0.w / r2.y;
  r2.x = saturate(dot(float3(1.6605773, -0.315296024, -0.241509631), r3.xyz));
  r2.y = saturate(dot(float3(-0.659922779, 1.60839415, 0.0172986612), r3.xyz));
  r2.z = saturate(dot(float3(0.00900251884, -0.0035668863, 0.913644135), r3.xyz));
  r1.xyz = r1.xyz ? r2.xyz : r0.xyz;
  r0.xyz = cb0[6].zzz ? r0.xyz : r1.xyz;
  r0.w = cmp(asint(cb0[6].z) == 1);
  r1.xyz = r0.www ? float3(1.0258249, -0.0200528856, -0.00577135477) : float3(1, 0, 0);
  r2.xyz = r0.www ? float3(-0.00223499862, 1.00458491, -0.00235229917) : float3(0, 1, 0);
  r3.xyz = r0.www ? float3(-0.00501333317, -0.0252900254, 1.03030288) : float3(0, 0, 1);
  r1.xyz = cb0[6].zzz ? r1.xyz : float3(1.70505106, -0.621790528, -0.0832584053);
  r2.xyz = cb0[6].zzz ? r2.xyz : float3(-0.130257174, 1.14080286, -0.0105485115);
  r3.xyz = cb0[6].zzz ? r3.xyz : float3(-0.0240032747, -0.128968775, 1.15297174);
  r1.x = dot(r1.xyz, r0.xyz);
  r1.y = dot(r2.xyz, r0.xyz);
  r1.z = dot(r3.xyz, r0.xyz);
  r0.xyz = max(float3(0, 0, 0), r1.xyz);
  r1.xyz = min(float3(65504, 65504, 65504), r0.xyz);
  if (cb0[6].z == 0) {
    r0.xyz = float3(12.9200001, 12.9200001, 12.9200001) * r1.xyz;
    r2.xyz = log2(r1.xyz);
    r2.xyz = float3(0.416666657, 0.416666657, 0.416666657) * r2.xyz;
    r2.xyz = exp2(r2.xyz);
    r2.xyz = r2.xyz * float3(1.05499995, 1.05499995, 1.05499995) + float3(-0.0549999997, -0.0549999997, -0.0549999997);
    r3.xyz = cmp(float3(0.00313080009, 0.00313080009, 0.00313080009) >= r1.xyz);
    r1.xyz = r3.xyz ? r0.xyz : r2.xyz;
  } else {
    if (r0.w != 0) {
      r0.xyz = cmp(float3(0, 0, 0) >= r1.xyz);
      r2.xyz = log2(r1.xyz);
      r2.xyz = cb0[6].yyy * r2.xyz;
      r2.xyz = exp2(r2.xyz);
      r0.xyz = r0.xyz ? float3(0, 0, 0) : r2.xyz;
      r0.w = cmp(cb0[6].y >= 1);
      r2.xyz = float3(2, 2, 2) + -r1.xyz;
      r3.xyz = r2.xyz * r2.xyz;
      r2.xyz = saturate(r3.xyz * r2.xyz);
      r3.xyz = float3(1, 1, 1) + -r2.xyz;
      r2.xyz = r2.xyz * r0.xyz;
      r2.xyz = r1.xyz * r3.xyz + r2.xyz;
      r0.xyz = r0.www ? r0.xyz : r2.xyz;
      r0.xyz = cb0[1].yyy * r0.xyz;
      r0.xyz = cb0[5].www * r0.xyz;
      r0.xyz = max(float3(0, 0, 0), r0.xyz);
      r0.xyz = min(float3(65504, 65504, 65504), r0.xyz);
      r2.xyz = float3(9.99999975e-05, 9.99999975e-05, 9.99999975e-05) * r0.xyz;
      r0.xyz = cmp(r0.xyz == float3(0, 0, 0));
      r2.xyz = log2(r2.xyz);
      r2.xyz = float3(0.159301758, 0.159301758, 0.159301758) * r2.xyz;
      r2.xyz = exp2(r2.xyz);
      r0.xyz = r0.xyz ? float3(0, 0, 0) : r2.xyz;
      r2.xyz = r0.xyz * float3(18.8515625, 18.8515625, 18.8515625) + float3(0.8359375, 0.8359375, 0.8359375);
      r0.xyz = r0.xyz * float3(18.6875, 18.6875, 18.6875) + float3(1, 1, 1);
      r0.xyz = r2.xyz / r0.xyz;
      r0.xyz = log2(r0.xyz);
      r0.xyz = float3(78.84375, 78.84375, 78.84375) * r0.xyz;
      r1.xyz = exp2(r0.xyz);
    }
  }
  r1.w = 1;
  // No code for instruction (needs manual fix):
  u0[vThreadID] = r1;  // store_uav_typed u0.xyzw, vThreadID.xyzz, r1.xyzw
  return;
}
