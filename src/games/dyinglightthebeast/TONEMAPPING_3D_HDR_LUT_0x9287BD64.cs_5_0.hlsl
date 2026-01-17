#include "./common.hlsli"
// ---- Created with 3Dmigoto v1.4.1 on Thu Sep 18 12:45:04 2025
cbuffer cb0 : register(b0) {
  float4 cb0[1];
}

RWTexture3D<float4> u0 : register(u0);

// 3Dmigoto declarations
#define cmp -

[numthreads(4, 4, 4)]
void main(uint3 vThreadID: SV_DispatchThreadID) {
  // Needs manual fix for instruction:
  // unknown dcl_: dcl_uav_typed_texture3d (float,float,float,float) u0
  float4 r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12;
  uint4 bitmask, uiDest;
  float4 fDest;

  // Needs manual fix for instruction:
  // unknown dcl_: dcl_thread_group 4, 4, 4
  r0.xyz = (uint3)vThreadID.xyz;
  if (RENODX_LUT_SHAPER != 0.f) {
    r0.rgb = renodx::color::pq::DecodeSafe((r0.rgb / 31.f), 100.f);
    r0.rgb = renodx::color::bt709::from::BT2020(r0.rgb);
  } else {  // incorrect
    r0.xyz = exp2(r0.xyz * (0.625 / 0.96875) - 13.f);
    r0.xyz -= 0.0005;  // clips blacks
    r0.xyz = max(float3(0, 0, 0), r0.xyz);

    // this is how it should actually look
    // r0.rgb /= 31.f;
    // r0.rgb = exp2(r0.rgb / 0.05f - 13.0f);
  }

  float3 untonemapped_bt709 = r0.rgb;

  float shadows = cb0[0].w;
  float max_nits = cb0[0].x;
  float min_nits = cb0[0].z;

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    u0[vThreadID] = float4(GenerateOutput(untonemapped_bt709, min_nits, max_nits, shadows), 0.f);
    return;
  }

  r0.w = dot(r0.xyz, float3(0.212500006, 0.715399981, 0.0720999986));
  r1.xy = r0.ww * float2(1.06858003, 0.421909988) + float2(0.0638085008, 1.26671004);
  r1.x = r1.x * r0.w;
  r1.y = r0.w * r1.y + 0.0144766998;
  r1.x = r1.x / r1.y;
  r1.x = r1.x + -r0.w;
  r1.x = shadows * r1.x + r0.w;
  r1.yzw = r0.xyz / r0.www;
  r1.xyz = r1.yzw * r1.xxx;
  r0.w = cmp(r0.w < 0.180000007);
  r0.xyz = r0.www ? r1.xyz : r0.xyz;

  // BT.709 -> AP0
  r1.z = dot(r0.xyz, float3(0.439633012, 0.382988989, 0.177377999));
  r1.y = dot(r0.xyz, float3(0.0897760019, 0.813439012, 0.0967840031));
  r1.x = dot(r0.xyz, float3(0.0175410006, 0.111547001, 0.870912015));

  r0.xyzw = log2(float4(min_nits, min_nits, max_nits, max_nits));  // r0.xyzw = log2(cb0[0].zzxx);

  r2.xz = float2(0.30103001, 0.30103001) * r0.wy;
  r3.xyzw = cmp(r0.yyww < float4(-13.2877121, -13.2877121, 5.58496284, 5.58496284));
  r4.xyzw = cmp(r0.xyzw >= float4(-5.64385605, -5.64385605, 13.2877121, 13.2877121));
  r5.xyzw = r3.yyww ? float4(-15, -15, 6.5, 6.5) : float4(-6.5, -6.5, 10, 10);
  r3.xyzw = (int4)r3.xyzw | (int4)r4.xyzw;
  r4.xyz = r0.yww * float3(0.30103001, 0.30103001, 0.30103001) + float3(4, -1.68124127, -0.681241274);
  r0.xz = float2(-2.82482171, 4.31265259) * r4.xy;
  r6.xyzw = -r4.xxyy * float4(0.434587955, 0.434587955, 0.431265235, 0.431265235) + float4(1, 1, 1, 1);
  r6.xyzw = r6.xyzw * float4(-15, -15, 6.5, 6.5) + r0.xxzz;
  r3.xyzw = r3.xyzw ? r5.xyzw : r6.xyzw;
  r3.xyzw = exp2(r3.xyzw);
  r3.xyzw = float4(0.180000007, 1, 0.180000007, 1) * r3.xyzw;
  r3.xyzw = log2(r3.xyzw);
  r0.xz = float2(0.30103001, 0.30103001) * r3.xz;
  r1.w = -r3.x * 0.30103001 + -0.744727433;
  r4.x = 0.166666672 * r1.w;
  r4.y = -r1.w * 0.166666672 + -0.744727433;
  r4.y = r4.y * 1.54999995 + 1.83556879;
  r4.w = r1.w * 0.166666672 + -0.744727433;
  r4.w = r4.w * 1.54999995 + 1.83556879;
  r5.xy = cmp(r3.yw < float2(-15, 6.5));
  r5.zw = cmp(r3.yw >= float2(-6.5, 10));
  r6.xy = r5.xy ? float2(0.180000007, 0.889999986) : float2(0.349999994, 0.899999976);
  r5.xy = (int2)r5.zw | (int2)r5.xy;
  r7.xyzw = float4(15, 15, -6.5, -6.5) + r3.yyww;
  r3.yw = float2(0.0411764719, 0.257142872) * r7.yw;
  r5.zw = -r7.xz * float2(0.117647059, 0.285714298) + float2(1, 1);
  r3.yw = r5.zw * float2(0.180000007, 0.889999986) + r3.yw;
  r3.yw = r5.xy ? r6.xy : r3.yw;
  r5.x = -r0.y * 0.30103001 + 0.681241274;
  r5.y = r3.y * r5.x + r2.z;
  r3.y = r3.z * 0.30103001 + 0.744727433;
  r6.x = 0.166666672 * r3.y;
  r6.y = -r3.y * 0.166666672 + -0.744727433;
  r6.y = r6.y * 1.54999995 + 1.83556879;
  r6.z = r3.y * 0.166666672 + -0.744727433;
  r7.y = r6.z * 1.54999995 + 1.83556879;
  r2.y = r3.w * r4.z + 0.681241274;
  r3.w = max(1.00000001e-10, cb0[0].y);
  r3.w = log2(r3.w);
  r4.z = 0.30103001 * r3.w;
  r6.z = cmp(r2.z >= r4.z);
  if (r6.z == 0) {
    r6.z = cmp(r2.z < r4.z);
    r6.w = cmp(2.26303458 >= r3.w);
    r6.z = r6.w ? r6.z : 0;
    if (r6.z != 0) {
      r1.w = 0.333333343 * r1.w;
      r0.y = r0.y * 0.30103001 + r5.y;
      r0.y = 0.5 * r0.y;
      r6.z = r5.y + r4.y;
      r6.w = r4.y + r4.w;
      r6.zw = float2(0.5, 0.5) * r6.zw;
      r8.x = cmp(r0.y >= r4.z);
      r0.y = cmp(r0.y < r4.z);
      r8.y = cmp(r6.z >= r4.z);
      r0.y = r0.y ? r8.y : 0;
      r6.z = cmp(r6.z < r4.z);
      r6.w = cmp(r6.w >= r4.z);
      r6.z = r6.w ? r6.z : 0;
      r5.x = 2;
      r5.zw = r4.xx * float2(-1.54999995, 1.54999995) + float2(0.681241274, 0.681241274);
      r9.xyzw = r6.zzzz ? r5.xyzw : 0;
      r10.x = 1;
      r10.y = r2.z;
      r10.zw = r5.zy;
      r9.xyzw = r0.yyyy ? r10.xywz : r9.xyzw;
      r10.x = 0;
      r8.xyzw = r8.xxxx ? r10.xyyw : r9.xyzw;
      r0.y = dot(r8.ywz, float3(0.5, 0.5, -1));
      r4.x = dot(r8.yz, float2(-1, 1));
      r5.x = dot(r8.yz, float2(0.5, 0.5));
      r5.x = -r3.w * 0.30103001 + r5.x;
      r0.y = r5.x * r0.y;
      r0.y = 4 * r0.y;
      r0.y = r4.x * r4.x + -r0.y;
      r0.y = sqrt(r0.y);
      r5.x = r5.x + r5.x;
      r0.y = -r0.y + -r4.x;
      r0.y = r5.x / r0.y;
      r4.x = (uint)r8.x;
      r0.y = r4.x + r0.y;
      r0.x = r0.y * r1.w + r0.x;
    } else {
      r0.y = 0.333333343 * r3.y;
      r1.w = r7.y + r6.y;
      r1.w = 0.5 * r1.w;
      r3.y = r7.y + r2.y;
      r3.y = 0.5 * r3.y;
      r0.w = r0.w * 0.30103001 + r2.y;
      r0.w = 0.5 * r0.w;
      r4.x = cmp(2.26303458 < r3.w);
      r5.x = cmp(r4.z < r2.x);
      r4.x = r4.x ? r5.x : 0;
      r1.w = cmp(r4.z >= r1.w);
      r5.x = cmp(r3.y >= r4.z);
      r1.w = r1.w ? r5.x : 0;
      r3.y = cmp(r3.y < r4.z);
      r5.x = cmp(r0.w >= r4.z);
      r3.y = r3.y ? r5.x : 0;
      r0.w = cmp(r0.w < r4.z);
      r4.z = cmp(r2.x >= r4.z);
      r0.w = r0.w ? r4.z : 0;
      r2.w = 2;
      r8.xyzw = r0.wwww ? r2.wyxx : 0;
      r7.x = 1;
      r7.zw = r2.yx;
      r8.xyzw = r3.yyyy ? r7.xyzw : r8.xyzw;
      r9.x = 0;
      r9.yz = r6.xx * float2(-1.54999995, 1.54999995) + float2(0.681241274, 0.681241274);
      r9.w = r7.z;
      r8.xyzw = r1.wwww ? r9.xyzw : r8.xyzw;
      r0.w = dot(r8.ywz, float3(0.5, 0.5, -1));
      r1.w = dot(r8.yz, float2(-1, 1));
      r2.w = dot(r8.yz, float2(0.5, 0.5));
      r2.w = -r3.w * 0.30103001 + r2.w;
      r0.w = r2.w * r0.w;
      r0.w = 4 * r0.w;
      r0.w = r1.w * r1.w + -r0.w;
      r0.w = sqrt(r0.w);
      r2.w = r2.w + r2.w;
      r0.w = -r0.w + -r1.w;
      r0.w = r2.w / r0.w;
      r1.w = (uint)r8.x;
      r0.w = r1.w + r0.w;
      r0.y = r0.w * r0.y + -0.744727433;
      r0.x = r4.x ? r0.y : r0.z;
    }
  }
  r0.x = r0.x * 3.32192802 + 2.47393107;
  r0.y = -2.47393107 + -r0.x;
  r0.xz = r3.xz + -r0.xx;
  r0.w = max(r1.y, r1.x);
  r0.w = max(r1.z, r0.w);
  r3.xy = max(float2(1.00000001e-10, 0.00999999978), r0.ww);
  r0.w = min(r1.y, r1.x);
  r0.w = min(r1.z, r0.w);
  r0.w = max(1.00000001e-10, r0.w);
  r0.w = r3.x + -r0.w;
  r0.w = r0.w / r3.y;
  r3.xyz = r1.xyz + -r1.yzx;
  r3.xy = r3.xy * r1.xy;
  r1.w = r3.x + r3.y;
  r1.w = r1.z * r3.z + r1.w;
  r1.w = sqrt(r1.w);
  r2.w = r1.x + r1.y;
  r2.w = r2.w + r1.z;
  r1.w = r1.w * 1.75 + r2.w;
  r2.w = 0.333333343 * r1.w;
  r3.x = -0.400000006 + r0.w;
  r3.y = 2.5 * r3.x;
  r3.y = 1 + -abs(r3.y);
  r3.y = max(0, r3.y);
  r3.z = cmp(0 < r3.x);
  r3.x = cmp(r3.x < 0);
  r3.x = (int)-r3.z + (int)r3.x;
  r3.x = (int)r3.x;
  r3.y = -r3.y * r3.y + 1;
  r3.x = r3.x * r3.y + 1;
  r3.x = 0.0250000004 * r3.x;
  r3.y = cmp(0.159999996 >= r1.w);
  r1.w = cmp(r1.w >= 0.479999989);
  r2.w = 0.0799999982 / r2.w;
  r2.w = -0.5 + r2.w;
  r2.w = r3.x * r2.w;
  r1.w = r1.w ? 0 : r2.w;
  r1.w = r3.y ? r3.x : r1.w;
  r1.w = 1 + r1.w;
  r3.xyz = r1.www * r1.xyz;
  r4.xz = cmp(r3.yx == r3.zy);
  r2.w = r4.z ? r4.x : 0;
  r1.y = r1.w * r1.y + -r3.x;
  r1.y = 1.73205078 * r1.y;
  r3.w = r3.z * 2 + -r3.y;
  r1.x = -r1.w * r1.x + r3.w;
  r3.w = min(abs(r1.y), abs(r1.x));
  r4.x = max(abs(r1.y), abs(r1.x));
  r4.x = 1 / r4.x;
  r3.w = r4.x * r3.w;
  r4.x = r3.w * r3.w;
  r4.z = r4.x * 0.0208350997 + -0.0851330012;
  r4.z = r4.x * r4.z + 0.180141002;
  r4.z = r4.x * r4.z + -0.330299497;
  r4.x = r4.x * r4.z + 0.999866009;
  r4.z = r4.x * r3.w;
  r5.x = cmp(abs(r1.x) < abs(r1.y));
  r4.z = r4.z * -2 + 1.57079637;
  r4.z = r5.x ? r4.z : 0;
  r3.w = r3.w * r4.x + r4.z;
  r4.x = cmp(r1.x < -r1.x);
  r4.x = r4.x ? -3.141593 : 0;
  r3.w = r4.x + r3.w;
  r4.x = min(r1.y, r1.x);
  r1.x = max(r1.y, r1.x);
  r1.y = cmp(r4.x < -r4.x);
  r1.x = cmp(r1.x >= -r1.x);
  r1.x = r1.x ? r1.y : 0;
  r1.x = r1.x ? -r3.w : r3.w;
  r1.x = 57.2957802 * r1.x;
  r1.x = r2.w ? 0 : r1.x;
  r1.y = cmp(r1.x < 0);
  r2.w = 360 + r1.x;
  r1.x = r1.y ? r2.w : r1.x;
  r1.y = cmp(r1.x < -180);
  r2.w = cmp(180 < r1.x);
  r4.xz = float2(360, -360) + r1.xx;
  r1.x = r2.w ? r4.z : r1.x;
  r1.x = r1.y ? r4.x : r1.x;
  r1.y = cmp(-67.5 < r1.x);
  r2.w = cmp(r1.x < 67.5);
  r1.y = r1.y ? r2.w : 0;
  if (r1.y != 0) {
    r1.x = 67.5 + r1.x;
    r1.y = 0.0296296291 * r1.x;
    r2.w = (int)r1.y;
    r1.y = trunc(r1.y);
    r1.x = r1.x * 0.0296296291 + -r1.y;
    r1.y = r1.x * r1.x;
    r3.w = r1.y * r1.x;
    r5.xzw = float3(-0.166666672, -0.5, 0.166666672) * r3.www;
    r4.xz = r1.yy * float2(0.5, 0.5) + r5.xz;
    r4.xz = r1.xx * float2(-0.5, 0.5) + r4.xz;
    r1.x = r3.w * 0.5 + -r1.y;
    r1.x = 0.666666687 + r1.x;
    r6.xzw = cmp((int3)r2.www == int3(3, 2, 1));
    r4.xz = float2(0.166666672, 0.166666672) + r4.xz;
    r1.y = r2.w ? 0 : r5.w;
    r1.y = r6.w ? r4.z : r1.y;
    r1.x = r6.z ? r1.x : r1.y;
    r1.x = r6.x ? r4.x : r1.x;
  } else {
    r1.x = 0;
  }
  r0.w = r1.x * r0.w;
  r0.xw = float2(0.30103001, 1.5) * r0.xw;
  r1.x = -r1.w * r1.z + 0.0299999993;
  r0.w = r1.x * r0.w;
  r0.w = r0.w * 0.180000007 + r3.z;
  r0.w = max(0, r0.w);
  r1.x = min(65536, r0.w);
  r3.xy = max(float2(0, 0), r3.yx);
  r1.yz = min(float2(65536, 65536), r3.xy);
  r0.w = dot(r1.xyz, float3(1.45143926, -0.236510754, -0.214928582));
  r1.w = dot(r1.xyz, float3(-0.076553911, 1.17622995, -0.099675931));
  r1.x = dot(r1.xyz, float3(0.00831612945, -0.00603244873, 0.997716486));
  r0.w = max(0, r0.w);
  r3.x = min(65504, r0.w);
  r0.w = max(0, r1.w);
  r3.y = min(65504, r0.w);
  r0.w = max(0, r1.x);
  r3.z = min(65504, r0.w);

  // RRT_SAT_MAT
  r0.w = dot(r3.xyz, float3(0.970889151, 0.0269632824, 0.00214758189));
  r1.x = dot(r3.xyz, float3(0.0108891567, 0.986963272, 0.00214758189));
  r1.y = dot(r3.xyz, float3(0.0108891567, 0.0269632824, 0.962147534));
  r0.w = max(1.17549435e-38, r0.w);
  r0.w = log2(r0.w);
  r1.z = 0.30103001 * r0.w;
  r1.w = cmp(r0.x >= r1.z);
  if (r1.w != 0) {
    r1.w = r2.z;
  } else {
    r2.w = cmp(r0.x < r1.z);
    r3.x = 0.30103001 * r0.y;
    r3.y = cmp(r1.z < r3.x);
    r2.w = r2.w ? r3.y : 0;
    if (r2.w != 0) {
      r2.w = r0.w * 0.30103001 + -r0.x;
      r2.w = 3 * r2.w;
      r3.y = r0.y * 0.30103001 + -r0.x;
      r2.w = r2.w / r3.y;
      r3.y = (int)r2.w;
      r3.z = trunc(r2.w);
      r8.y = -r3.z + r2.w;
      r9.xyzw = cmp((int4)r3.yyyy == int4(0, 1, 2, 3));
      r3.zw = cmp((int2)r3.yy == int2(4, 5));
      r9.xyzw = r9.xyzw ? float4(1, 1, 1, 1) : 0;
      r3.zw = r3.zw ? float2(1, 1) : 0;
      r2.w = dot(r9.yx, r2.zz);
      r2.w = r9.z * r5.y + r2.w;
      r2.w = r9.w * r4.y + r2.w;
      r2.w = r3.z * r4.w + r2.w;
      r9.x = r3.w * r4.w + r2.w;
      r10.xyzw = (int4)r3.yyyy + int4(1, 1, 2, 2);
      r11.xyzw = cmp((int4)r10.yyyy == int4(0, 1, 2, 3));
      r12.xyzw = cmp((int4)r10.xyzw == int4(4, 5, 4, 5));
      r11.xyzw = r11.xyzw ? float4(1, 1, 1, 1) : 0;
      r12.xyzw = r12.xyzw ? float4(1, 1, 1, 1) : 0;
      r2.w = dot(r11.yx, r2.zz);
      r2.w = r11.z * r5.y + r2.w;
      r2.w = r11.w * r4.y + r2.w;
      r2.w = r12.x * r4.w + r2.w;
      r9.y = r12.y * r4.w + r2.w;
      r10.xyzw = cmp((int4)r10.wwww == int4(0, 1, 2, 3));
      r10.xyzw = r10.xyzw ? float4(1, 1, 1, 1) : 0;
      r2.w = dot(r10.yx, r2.zz);
      r2.w = r10.z * r5.y + r2.w;
      r2.w = r10.w * r4.y + r2.w;
      r2.w = r12.z * r4.w + r2.w;
      r9.z = r12.w * r4.w + r2.w;
      r8.x = r8.y * r8.y;
      r10.x = dot(r9.xzy, float3(0.5, 0.5, -1));
      r10.y = dot(r9.xy, float2(-1, 1));
      r10.z = dot(r9.xy, float2(0.5, 0.5));
      r8.z = 1;
      r1.w = dot(r8.xyz, r10.xyz);
    } else {
      r2.w = cmp(r1.z >= r3.x);
      r3.y = 0.30103001 * r0.z;
      r1.z = cmp(r1.z < r3.y);
      r1.z = r1.z ? r2.w : 0;
      if (r1.z != 0) {
        r0.w = r0.w * 0.30103001 + -r3.x;
        r0.w = 3 * r0.w;
        r1.z = r0.z * 0.30103001 + -r3.x;
        r0.w = r0.w / r1.z;
        r1.z = (int)r0.w;
        r2.w = trunc(r0.w);
        r3.y = -r2.w + r0.w;
        r8.xyzw = cmp((int4)r1.zzzz == int4(0, 1, 2, 3));
        r4.xz = cmp((int2)r1.zz == int2(4, 5));
        r8.xyzw = r8.xyzw ? float4(1, 1, 1, 1) : 0;
        r4.xz = r4.xz ? float2(1, 1) : 0;
        r0.w = r8.x * r6.y;
        r0.w = r8.y * r7.y + r0.w;
        r0.w = r8.z * r2.y + r0.w;
        r0.w = r8.w * r2.x + r0.w;
        r0.w = r4.x * r2.x + r0.w;
        r8.x = r4.z * r2.x + r0.w;
        r9.xyzw = (int4)r1.zzzz + int4(1, 1, 2, 2);
        r10.xyzw = cmp((int4)r9.yyyy == int4(0, 1, 2, 3));
        r11.xyzw = cmp((int4)r9.xyzw == int4(4, 5, 4, 5));
        r10.xyzw = r10.xyzw ? float4(1, 1, 1, 1) : 0;
        r11.xyzw = r11.xyzw ? float4(1, 1, 1, 1) : 0;
        r0.w = r10.x * r6.y;
        r0.w = r10.y * r7.y + r0.w;
        r0.w = r10.z * r2.y + r0.w;
        r0.w = r10.w * r2.x + r0.w;
        r0.w = r11.x * r2.x + r0.w;
        r8.y = r11.y * r2.x + r0.w;
        r9.xyzw = cmp((int4)r9.wwww == int4(0, 1, 2, 3));
        r9.xyzw = r9.xyzw ? float4(1, 1, 1, 1) : 0;
        r0.w = r9.x * r6.y;
        r0.w = r9.y * r7.y + r0.w;
        r0.w = r9.z * r2.y + r0.w;
        r0.w = r9.w * r2.x + r0.w;
        r0.w = r11.z * r2.x + r0.w;
        r8.z = r11.w * r2.x + r0.w;
        r3.x = r3.y * r3.y;
        r9.x = dot(r8.xzy, float3(0.5, 0.5, -1));
        r9.y = dot(r8.xy, float2(-1, 1));
        r9.z = dot(r8.xy, float2(0.5, 0.5));
        r3.z = 1;
        r1.w = dot(r3.xyz, r9.xyz);
      } else {
        r1.w = r2.x;
      }
    }
  }
  r0.w = 3.32192802 * r1.w;
  r0.w = exp2(r0.w);
  r1.xy = max(float2(1.17549435e-38, 1.17549435e-38), r1.xy);
  r1.x = log2(r1.x);
  r1.z = 0.30103001 * r1.x;
  r1.w = cmp(r0.x >= r1.z);
  if (r1.w != 0) {
    r1.w = r2.z;
  } else {
    r2.w = cmp(r0.x < r1.z);
    r3.x = 0.30103001 * r0.y;
    r3.y = cmp(r1.z < r3.x);
    r2.w = r2.w ? r3.y : 0;
    if (r2.w != 0) {
      r2.w = r1.x * 0.30103001 + -r0.x;
      r2.w = 3 * r2.w;
      r3.y = r0.y * 0.30103001 + -r0.x;
      r2.w = r2.w / r3.y;
      r3.y = (int)r2.w;
      r3.z = trunc(r2.w);
      r8.y = -r3.z + r2.w;
      r9.xyzw = cmp((int4)r3.yyyy == int4(0, 1, 2, 3));
      r3.zw = cmp((int2)r3.yy == int2(4, 5));
      r9.xyzw = r9.xyzw ? float4(1, 1, 1, 1) : 0;
      r3.zw = r3.zw ? float2(1, 1) : 0;
      r2.w = dot(r9.yx, r2.zz);
      r2.w = r9.z * r5.y + r2.w;
      r2.w = r9.w * r4.y + r2.w;
      r2.w = r3.z * r4.w + r2.w;
      r9.x = r3.w * r4.w + r2.w;
      r10.xyzw = (int4)r3.yyyy + int4(1, 1, 2, 2);
      r11.xyzw = cmp((int4)r10.yyyy == int4(0, 1, 2, 3));
      r12.xyzw = cmp((int4)r10.xyzw == int4(4, 5, 4, 5));
      r11.xyzw = r11.xyzw ? float4(1, 1, 1, 1) : 0;
      r12.xyzw = r12.xyzw ? float4(1, 1, 1, 1) : 0;
      r2.w = dot(r11.yx, r2.zz);
      r2.w = r11.z * r5.y + r2.w;
      r2.w = r11.w * r4.y + r2.w;
      r2.w = r12.x * r4.w + r2.w;
      r9.y = r12.y * r4.w + r2.w;
      r10.xyzw = cmp((int4)r10.wwww == int4(0, 1, 2, 3));
      r10.xyzw = r10.xyzw ? float4(1, 1, 1, 1) : 0;
      r2.w = dot(r10.yx, r2.zz);
      r2.w = r10.z * r5.y + r2.w;
      r2.w = r10.w * r4.y + r2.w;
      r2.w = r12.z * r4.w + r2.w;
      r9.z = r12.w * r4.w + r2.w;
      r8.x = r8.y * r8.y;
      r10.x = dot(r9.xzy, float3(0.5, 0.5, -1));
      r10.y = dot(r9.xy, float2(-1, 1));
      r10.z = dot(r9.xy, float2(0.5, 0.5));
      r8.z = 1;
      r1.w = dot(r8.xyz, r10.xyz);
    } else {
      r2.w = cmp(r1.z >= r3.x);
      r3.y = 0.30103001 * r0.z;
      r1.z = cmp(r1.z < r3.y);
      r1.z = r1.z ? r2.w : 0;
      if (r1.z != 0) {
        r1.x = r1.x * 0.30103001 + -r3.x;
        r1.x = 3 * r1.x;
        r1.z = r0.z * 0.30103001 + -r3.x;
        r1.x = r1.x / r1.z;
        r1.z = (int)r1.x;
        r2.w = trunc(r1.x);
        r3.y = -r2.w + r1.x;
        r8.xyzw = cmp((int4)r1.zzzz == int4(0, 1, 2, 3));
        r4.xz = cmp((int2)r1.zz == int2(4, 5));
        r8.xyzw = r8.xyzw ? float4(1, 1, 1, 1) : 0;
        r4.xz = r4.xz ? float2(1, 1) : 0;
        r1.x = r8.x * r6.y;
        r1.x = r8.y * r7.y + r1.x;
        r1.x = r8.z * r2.y + r1.x;
        r1.x = r8.w * r2.x + r1.x;
        r1.x = r4.x * r2.x + r1.x;
        r8.x = r4.z * r2.x + r1.x;
        r9.xyzw = (int4)r1.zzzz + int4(1, 1, 2, 2);
        r10.xyzw = cmp((int4)r9.yyyy == int4(0, 1, 2, 3));
        r11.xyzw = cmp((int4)r9.xyzw == int4(4, 5, 4, 5));
        r10.xyzw = r10.xyzw ? float4(1, 1, 1, 1) : 0;
        r11.xyzw = r11.xyzw ? float4(1, 1, 1, 1) : 0;
        r1.x = r10.x * r6.y;
        r1.x = r10.y * r7.y + r1.x;
        r1.x = r10.z * r2.y + r1.x;
        r1.x = r10.w * r2.x + r1.x;
        r1.x = r11.x * r2.x + r1.x;
        r8.y = r11.y * r2.x + r1.x;
        r9.xyzw = cmp((int4)r9.wwww == int4(0, 1, 2, 3));
        r9.xyzw = r9.xyzw ? float4(1, 1, 1, 1) : 0;
        r1.x = r9.x * r6.y;
        r1.x = r9.y * r7.y + r1.x;
        r1.x = r9.z * r2.y + r1.x;
        r1.x = r9.w * r2.x + r1.x;
        r1.x = r11.z * r2.x + r1.x;
        r8.z = r11.w * r2.x + r1.x;
        r3.x = r3.y * r3.y;
        r9.x = dot(r8.xzy, float3(0.5, 0.5, -1));
        r9.y = dot(r8.xy, float2(-1, 1));
        r9.z = dot(r8.xy, float2(0.5, 0.5));
        r3.z = 1;
        r1.w = dot(r3.xyz, r9.xyz);
      } else {
        r1.w = r2.x;
      }
    }
  }
  r1.x = 3.32192802 * r1.w;
  r1.x = exp2(r1.x);
  r1.y = log2(r1.y);
  r1.z = 0.30103001 * r1.y;
  r1.w = cmp(r0.x >= r1.z);
  if (r1.w != 0) {
    r2.x = r2.z;
  } else {
    r1.w = cmp(r0.x < r1.z);
    r2.w = 0.30103001 * r0.y;
    r3.x = cmp(r1.z < r2.w);
    r1.w = r1.w ? r3.x : 0;
    if (r1.w != 0) {
      r1.w = r1.y * 0.30103001 + -r0.x;
      r1.w = 3 * r1.w;
      r0.x = r0.y * 0.30103001 + -r0.x;
      r0.x = r1.w / r0.x;
      r0.y = (int)r0.x;
      r1.w = trunc(r0.x);
      r3.y = -r1.w + r0.x;
      r8.xyzw = cmp((int4)r0.yyyy == int4(0, 1, 2, 3));
      r4.xz = cmp((int2)r0.yy == int2(4, 5));
      r8.xyzw = r8.xyzw ? float4(1, 1, 1, 1) : 0;
      r4.xz = r4.xz ? float2(1, 1) : 0;
      r0.x = dot(r8.yx, r2.zz);
      r0.x = r8.z * r5.y + r0.x;
      r0.x = r8.w * r4.y + r0.x;
      r0.x = r4.x * r4.w + r0.x;
      r8.x = r4.z * r4.w + r0.x;
      r9.xyzw = (int4)r0.yyyy + int4(1, 1, 2, 2);
      r10.xyzw = cmp((int4)r9.yyyy == int4(0, 1, 2, 3));
      r11.xyzw = cmp((int4)r9.xyzw == int4(4, 5, 4, 5));
      r10.xyzw = r10.xyzw ? float4(1, 1, 1, 1) : 0;
      r11.xyzw = r11.xyzw ? float4(1, 1, 1, 1) : 0;
      r0.x = dot(r10.yx, r2.zz);
      r0.x = r10.z * r5.y + r0.x;
      r0.x = r10.w * r4.y + r0.x;
      r0.x = r11.x * r4.w + r0.x;
      r8.y = r11.y * r4.w + r0.x;
      r9.xyzw = cmp((int4)r9.wwww == int4(0, 1, 2, 3));
      r9.xyzw = r9.xyzw ? float4(1, 1, 1, 1) : 0;
      r0.x = dot(r9.yx, r2.zz);
      r0.x = r9.z * r5.y + r0.x;
      r0.x = r9.w * r4.y + r0.x;
      r0.x = r11.z * r4.w + r0.x;
      r8.z = r11.w * r4.w + r0.x;
      r3.x = r3.y * r3.y;
      r4.x = dot(r8.xzy, float3(0.5, 0.5, -1));
      r4.y = dot(r8.xy, float2(-1, 1));
      r4.z = dot(r8.xy, float2(0.5, 0.5));
      r3.z = 1;
      r2.x = dot(r3.xyz, r4.xyz);
    } else {
      r0.x = cmp(r1.z >= r2.w);
      r0.y = 0.30103001 * r0.z;
      r0.y = cmp(r1.z < r0.y);
      r0.x = r0.y ? r0.x : 0;
      if (r0.x != 0) {
        r0.x = r1.y * 0.30103001 + -r2.w;
        r0.x = 3 * r0.x;
        r0.y = r0.z * 0.30103001 + -r2.w;
        r0.x = r0.x / r0.y;
        r0.y = (int)r0.x;
        r0.z = trunc(r0.x);
        r3.y = r0.x + -r0.z;
        r4.xyzw = cmp((int4)r0.yyyy == int4(0, 1, 2, 3));
        r0.xz = cmp((int2)r0.yy == int2(4, 5));
        r4.xyzw = r4.xyzw ? float4(1, 1, 1, 1) : 0;
        r0.xz = r0.xz ? float2(1, 1) : 0;
        r1.y = r4.x * r6.y;
        r1.y = r4.y * r7.y + r1.y;
        r1.y = r4.z * r2.y + r1.y;
        r1.y = r4.w * r2.x + r1.y;
        r0.x = r0.x * r2.x + r1.y;
        r4.x = r0.z * r2.x + r0.x;
        r5.xyzw = (int4)r0.yyyy + int4(1, 1, 2, 2);
        r8.xyzw = cmp((int4)r5.yyyy == int4(0, 1, 2, 3));
        r9.xyzw = cmp((int4)r5.xyzw == int4(4, 5, 4, 5));
        r8.xyzw = r8.xyzw ? float4(1, 1, 1, 1) : 0;
        r9.xyzw = r9.xyzw ? float4(1, 1, 1, 1) : 0;
        r0.x = r8.x * r6.y;
        r0.x = r8.y * r7.y + r0.x;
        r0.x = r8.z * r2.y + r0.x;
        r0.x = r8.w * r2.x + r0.x;
        r0.x = r9.x * r2.x + r0.x;
        r4.y = r9.y * r2.x + r0.x;
        r5.xyzw = cmp((int4)r5.wwww == int4(0, 1, 2, 3));
        r5.xyzw = r5.xyzw ? float4(1, 1, 1, 1) : 0;
        r0.x = r5.x * r6.y;
        r0.x = r5.y * r7.y + r0.x;
        r0.x = r5.z * r2.y + r0.x;
        r0.x = r5.w * r2.x + r0.x;
        r0.x = r9.z * r2.x + r0.x;
        r4.z = r9.w * r2.x + r0.x;
        r3.x = r3.y * r3.y;
        r0.x = dot(r4.xzy, float3(0.5, 0.5, -1));
        r0.y = dot(r4.xy, float2(-1, 1));
        r0.z = dot(r4.xy, float2(0.5, 0.5));
        r3.z = 1;
        r2.x = dot(r3.xyz, r0.xyz);
      }
    }
  }
  r0.x = 3.32192802 * r2.x;
  r0.x = exp2(r0.x);
  r0.xy = -min_nits + r0.xw;
  r0.z = max_nits + -min_nits;
  r2.x = r0.y / r0.z;
  r0.y = -min_nits + r1.x;
  r2.yz = r0.yx / r0.zz;

  // AP1 -> XYZ
  r1.x = dot(r2.xyz, float3(0.662454247, 0.134004205, 0.156187698));
  r1.y = dot(r2.xyz, float3(0.272228777, 0.674081683, 0.0536895208));
  r1.z = dot(r2.xyz, float3(-0.00557466177, 0.00406072894, 1.01033902));

  // XYZ -> BT.709
  r2.x = saturate(dot(r1.xyz, float3(3.24097013, -1.53738332, -0.498610854)));
  r2.y = saturate(dot(r1.xyz, float3(-0.969243765, 1.87596786, 0.0415550806)));
  r2.z = saturate(dot(r1.xyz, float3(0.0556300357, -0.203976855, 1.05697155)));

  // BT.709 -> XYZ
  r1.x = dot(r2.xyz, float3(0.412390769, 0.357584298, 0.180480793));
  r1.y = dot(r2.xyz, float3(0.212639004, 0.715168595, 0.0721923113));
  r1.z = dot(r2.xyz, float3(0.0193308182, 0.119194716, 0.950532138));

  // D60 -> D65
  r2.x = dot(r1.xyz, float3(0.987224042, -0.00611322373, 0.0159532577));
  r2.y = dot(r1.xyz, float3(-0.00759830978, 1.00186133, 0.00533002242));
  r2.z = dot(r1.xyz, float3(0.00307257194, -0.00509595545, 1.08168054));

  // XYZ -> BT.709
  r0.x = dot(r2.xyz, float3(3.24097013, -1.53738332, -0.498610854));
  r0.y = dot(r2.xyz, float3(-0.969243765, 1.87596786, 0.0415550806));
  r0.w = dot(r2.xyz, float3(0.0556300357, -0.203976855, 1.05697155));
  r0.xyw = max(float3(0, 0, 0), r0.xyw);
  r0.x = r0.x * r0.z + min_nits;
  r0.y = r0.y * r0.z + min_nits;
  r0.z = r0.w * r0.z + min_nits;

  r1.rgb = renodx::color::pq::EncodeSafe(r0.rgb, 1.f);
  r1.w = 0;
  u0[vThreadID] = r1;  // store_uav_typed u0.xyzw, vThreadID.xyzz, r1.xyzw
  // u0[vThreadID] = float4(renodx::color::pq::EncodeSafe(untonemapped_bt709, 100.f), 0.f);
  return;
}
