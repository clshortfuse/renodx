#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.4.1 on Sat Mar 22 22:57:00 2025
RWTexture3D<float4> u0 : register(u0, space6);

cbuffer CB0 : register(b0, space6) {
  float4 CB0[1][5];
};

// 3Dmigoto declarations
#define cmp            -
#define DISPATCH_BLOCK 16

[numthreads(DISPATCH_BLOCK, DISPATCH_BLOCK, 1)]
void main(uint3 vThreadID: SV_DispatchThreadID) {
  const float4 icb[] = { { -4.000000, -0.718548, -1.698970, 0.515439 },
                         { -4.000000, 2.081031, -1.698970, 0.847044 },
                         { -3.157377, 3.668124, -1.477900, 1.135800 },
                         { -0.485250, 4.000000, -1.229100, 1.380200 },
                         { 1.847732, 4.000000, -0.864800, 1.519700 },
                         { 0, 0, -0.448000, 1.598500 },
                         { 0, 0, 0.005180, 1.646700 },
                         { 0, 0, 0.451108, 1.674609 },
                         { 0, 0, 0.911374, 1.687873 } };
  // Needs manual fix for instruction:
  // unknown dcl_: dcl_uav_typed_texture3d (float,float,float,float) U0[0:0], space=6
  float4 r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13;
  uint4 bitmask, uiDest;
  float4 fDest;

  // Needs manual fix for instruction:
  // unknown dcl_: dcl_thread_group 16, 16, 1
  r0.xyz = (uint3)vThreadID.xyz;
  r0.xyz = r0.xyz * float3(0.645161271, 0.645161271, 0.645161271) + float3(-12.4739313, -12.4739313, -12.4739313);
  r0.xyz = exp2(r0.xyz);

#if 1
  u0[vThreadID.xyz] = float4(ApplyToneMapEncodePQ(r0.rgb, CB0[0][3].w, CB0[0][4].x * 200.f), 1.f);
  return;
#endif

  r0.xyz = CB0[0][4].xxx * r0.xyz;
  r1.z = dot(r0.xyz, float3(0.695452213, 0.140678659, 0.163869068));
  r1.y = dot(r0.xyz, float3(0.0447945744, 0.859670997, 0.0955343246));
  r1.x = dot(r0.xyz, float3(-0.00552586792, 0.00402521156, 1.00150073));
  r0.x = max(r1.y, r1.x);
  r0.x = max(r1.z, r0.x);
  r0.z = min(r1.y, r1.x);
  r0.z = min(r1.z, r0.z);
  r0.xyz = max(float3(1.00000001e-10, 0.00999999978, 1.00000001e-10), r0.xxz);
  r0.x = r0.x + -r0.z;
  r0.x = r0.x / r0.y;
  r0.yzw = r1.xyz + -r1.yzx;
  r0.yz = r1.xy * r0.yz;
  r0.y = r0.y + r0.z;
  r0.y = r1.z * r0.w + r0.y;
  r0.y = max(0, r0.y);
  r0.y = sqrt(r0.y);
  r0.z = r1.x + r1.y;
  r0.z = r0.z + r1.z;
  r0.y = r0.y * 1.75 + r0.z;
  r0.w = -0.400000006 + r0.x;
  r1.w = 2.5 * r0.w;
  r1.w = 1 + -abs(r1.w);
  r1.w = max(0, r1.w);
  r2.x = cmp(r0.w < 0);
  r0.w = cmp(0 < r0.w);
  r0.w = r0.w ? 1.000000 : 0;
  r0.w = r2.x ? -1 : r0.w;
  r1.w = -r1.w * r1.w + 1;
  r0.w = r0.w * r1.w + 1;
  r0.zw = float2(0.333333343, 0.0250000004) * r0.yw;
  r1.w = cmp(0.159999996 >= r0.y);
  r0.y = cmp(r0.y >= 0.479999989);
  r0.z = 0.0799999982 / r0.z;
  r0.z = -0.5 + r0.z;
  r0.z = r0.w * r0.z;
  r0.y = r0.y ? 0 : r0.z;
  r0.y = r1.w ? r0.w : r0.y;
  r0.y = 1 + r0.y;
  r2.xyz = r0.yyy * r1.xyz;
  r0.zw = cmp(r2.yx == r2.zy);
  r0.z = r0.w ? r0.z : 0;
  r0.w = r0.y * r1.y + -r2.x;
  r0.w = 1.73205078 * r0.w;
  r1.y = r2.z * 2 + -r2.y;
  r1.x = -r0.y * r1.x + r1.y;
  r1.y = min(abs(r1.x), abs(r0.w));
  r1.w = max(abs(r1.x), abs(r0.w));
  r1.w = 1 / r1.w;
  r1.y = r1.y * r1.w;
  r1.w = r1.y * r1.y;
  r2.w = r1.w * 0.0208350997 + -0.0851330012;
  r2.w = r1.w * r2.w + 0.180141002;
  r2.w = r1.w * r2.w + -0.330299497;
  r1.w = r1.w * r2.w + 0.999866009;
  r2.w = r1.y * r1.w;
  r3.x = cmp(abs(r1.x) < abs(r0.w));
  r2.w = r2.w * -2 + 1.57079637;
  r2.w = r3.x ? r2.w : 0;
  r1.y = r1.y * r1.w + r2.w;
  r1.w = cmp(r1.x < -r1.x);
  r1.w = r1.w ? -3.141593 : 0;
  r1.y = r1.y + r1.w;
  r1.w = min(r1.x, r0.w);
  r0.w = max(r1.x, r0.w);
  r1.x = cmp(r1.w < -r1.w);
  r0.w = cmp(r0.w >= -r0.w);
  r0.w = r0.w ? r1.x : 0;
  r0.w = r0.w ? -r1.y : r1.y;
  r0.w = 57.2957802 * r0.w;
  r0.z = r0.z ? 0xffc10000 : r0.w;
  r0.w = cmp(r0.z < 0);
  r1.x = 360 + r0.z;
  r0.z = r0.w ? r1.x : r0.z;
  r0.w = cmp(r0.z < -180);
  r1.x = cmp(180 < r0.z);
  r1.yw = float2(360, -360) + r0.zz;
  r0.z = r1.x ? r1.w : r0.z;
  r0.z = r0.w ? r1.y : r0.z;
  r0.w = cmp(-67.5 < r0.z);
  r1.x = cmp(r0.z < 67.5);
  r0.w = r0.w ? r1.x : 0;
  if (r0.w != 0) {
    r0.z = 67.5 + r0.z;
    r0.w = 0.0296296291 * r0.z;
    r1.x = (int)r0.w;
    r0.w = trunc(r0.w);
    r0.z = r0.z * 0.0296296291 + -r0.w;
    r0.w = r0.z * r0.z;
    r1.y = r0.w * r0.z;
    r3.xyz = float3(-0.166666672, -0.5, 0.166666672) * r1.yyy;
    r3.xy = r0.ww * float2(0.5, 0.5) + r3.xy;
    r3.xy = r0.zz * float2(-0.5, 0.5) + r3.xy;
    r0.z = r1.y * 0.5 + -r0.w;
    r0.z = 0.666666687 + r0.z;
    r4.xyz = cmp((int3)r1.xxx == int3(3, 2, 1));
    r1.yw = float2(0.166666672, 0.166666672) + r3.xy;
    r0.w = r1.x ? 0 : r3.z;
    r0.w = r4.z ? r1.w : r0.w;
    r0.z = r4.y ? r0.z : r0.w;
    r0.z = r4.x ? r1.y : r0.z;
  } else {
    r0.z = 0;
  }
  r0.x = r0.z * r0.x;
  r0.x = 1.5 * r0.x;
  r0.y = -r0.y * r1.z + 0.0299999993;
  r0.x = r0.x * r0.y;
  r0.x = r0.x * 0.180000007 + r2.z;
  r0.x = min(65520, r0.x);
  r0.x = max(0, r0.x);
  r1.xy = min(float2(65520, 65520), r2.yx);
  r0.yz = max(float2(0, 0), r1.xy);
  r0.w = dot(r0.xyz, float3(1.45143938, -0.236510724, -0.214928553));
  r1.x = dot(r0.xyz, float3(-0.0765537992, 1.17622995, -0.0996759459));
  r0.x = dot(r0.xyz, float3(0.00831612758, -0.00603244733, 0.997716188));
  r0.xy = min(float2(65504, 65504), r0.xw);
  r2.x = max(0, r0.y);
  r0.y = min(65504, r1.x);
  r2.yz = max(float2(0, 0), r0.yx);
  r0.x = dot(r2.xyz, float3(0.970889151, 0.0269632787, 0.00214758189));
  r0.y = dot(r2.xyz, float3(0.0108891558, 0.986963272, 0.00214758189));
  r0.z = dot(r2.xyz, float3(0.0108891558, 0.0269632787, 0.962147534));
  r0.x = max(5.96046448e-08, r0.x);
  r0.x = log2(r0.x);
  r0.w = cmp(-17.4739304 >= r0.x);
  if (r0.w != 0) {
    r0.w = -4;
  } else {
    r0.w = cmp(r0.x < -2.47393107);
    if (r0.w != 0) {
      r0.w = r0.x * 0.30103001 + 5.26017714;
      r1.x = 0.664385676 * r0.w;
      r1.y = (int)r1.x;
      r1.x = trunc(r1.x);
      r2.y = r0.w * 0.664385676 + -r1.x;
      r1.xz = (int2)r1.yy + int2(1, 2);
      r2.x = r2.y * r2.y;
      r3.x = icb[r1.y + 0].x;
      r3.y = icb[r1.x + 0].x;
      r3.z = icb[r1.z + 0].x;
      r1.x = dot(r3.xzy, float3(0.5, 0.5, -1));
      r1.y = dot(r3.xy, float2(-1, 1));
      r1.z = dot(r3.xy, float2(0.5, 0.5));
      r2.z = 1;
      r0.w = dot(r2.xyz, r1.xyz);
    } else {
      r1.x = cmp(r0.x < 15.5260687);
      if (r1.x != 0) {
        r0.x = r0.x * 0.30103001 + 0.744727433;
        r1.x = 0.553654671 * r0.x;
        r1.y = (int)r1.x;
        r1.x = trunc(r1.x);
        r2.y = r0.x * 0.553654671 + -r1.x;
        r1.xz = (int2)r1.yy + int2(1, 2);
        r2.x = r2.y * r2.y;
        r3.x = icb[r1.y + 0].y;
        r3.y = icb[r1.x + 0].y;
        r3.z = icb[r1.z + 0].y;
        r1.x = dot(r3.xzy, float3(0.5, 0.5, -1));
        r1.y = dot(r3.xy, float2(-1, 1));
        r1.z = dot(r3.xy, float2(0.5, 0.5));
        r2.z = 1;
        r0.w = dot(r2.xyz, r1.xyz);
      } else {
        r0.w = 4;
      }
    }
  }
  r0.x = 3.32192802 * r0.w;
  r1.x = exp2(r0.x);
  r0.x = max(5.96046448e-08, r0.y);
  r0.x = log2(r0.x);
  r0.y = cmp(-17.4739304 >= r0.x);
  if (r0.y != 0) {
    r0.y = -4;
  } else {
    r0.y = cmp(r0.x < -2.47393107);
    if (r0.y != 0) {
      r0.y = r0.x * 0.30103001 + 5.26017714;
      r0.w = 0.664385676 * r0.y;
      r1.w = (int)r0.w;
      r0.w = trunc(r0.w);
      r2.y = r0.y * 0.664385676 + -r0.w;
      r0.yw = (int2)r1.ww + int2(1, 2);
      r2.x = r2.y * r2.y;
      r3.x = icb[r1.w + 0].x;
      r3.y = icb[r0.y + 0].x;
      r3.z = icb[r0.w + 0].x;
      r4.x = dot(r3.xzy, float3(0.5, 0.5, -1));
      r4.y = dot(r3.xy, float2(-1, 1));
      r4.z = dot(r3.xy, float2(0.5, 0.5));
      r2.z = 1;
      r0.y = dot(r2.xyz, r4.xyz);
    } else {
      r0.w = cmp(r0.x < 15.5260687);
      if (r0.w != 0) {
        r0.x = r0.x * 0.30103001 + 0.744727433;
        r0.w = 0.553654671 * r0.x;
        r1.w = (int)r0.w;
        r0.w = trunc(r0.w);
        r2.y = r0.x * 0.553654671 + -r0.w;
        r0.xw = (int2)r1.ww + int2(1, 2);
        r2.x = r2.y * r2.y;
        r3.x = icb[r1.w + 0].y;
        r3.y = icb[r0.x + 0].y;
        r3.z = icb[r0.w + 0].y;
        r4.x = dot(r3.xzy, float3(0.5, 0.5, -1));
        r4.y = dot(r3.xy, float2(-1, 1));
        r4.z = dot(r3.xy, float2(0.5, 0.5));
        r2.z = 1;
        r0.y = dot(r2.xyz, r4.xyz);
      } else {
        r0.y = 4;
      }
    }
  }
  r0.x = 3.32192802 * r0.y;
  r1.y = exp2(r0.x);
  r0.x = max(5.96046448e-08, r0.z);
  r0.x = log2(r0.x);
  r0.y = cmp(-17.4739304 >= r0.x);
  if (r0.y != 0) {
    r0.y = -4;
  } else {
    r0.y = cmp(r0.x < -2.47393107);
    if (r0.y != 0) {
      r0.y = r0.x * 0.30103001 + 5.26017714;
      r0.z = 0.664385676 * r0.y;
      r0.w = (int)r0.z;
      r0.z = trunc(r0.z);
      r2.y = r0.y * 0.664385676 + -r0.z;
      r0.yz = (int2)r0.ww + int2(1, 2);
      r2.x = r2.y * r2.y;
      r3.x = icb[r0.w + 0].x;
      r3.y = icb[r0.y + 0].x;
      r3.z = icb[r0.z + 0].x;
      r4.x = dot(r3.xzy, float3(0.5, 0.5, -1));
      r4.y = dot(r3.xy, float2(-1, 1));
      r4.z = dot(r3.xy, float2(0.5, 0.5));
      r2.z = 1;
      r0.y = dot(r2.xyz, r4.xyz);
    } else {
      r0.z = cmp(r0.x < 15.5260687);
      if (r0.z != 0) {
        r0.x = r0.x * 0.30103001 + 0.744727433;
        r0.z = 0.553654671 * r0.x;
        r0.w = (int)r0.z;
        r0.z = trunc(r0.z);
        r2.y = r0.x * 0.553654671 + -r0.z;
        r0.xz = (int2)r0.ww + int2(1, 2);
        r2.x = r2.y * r2.y;
        r3.x = icb[r0.w + 0].y;
        r3.y = icb[r0.x + 0].y;
        r3.z = icb[r0.z + 0].y;
        r4.x = dot(r3.xzy, float3(0.5, 0.5, -1));
        r4.y = dot(r3.xy, float2(-1, 1));
        r4.z = dot(r3.xy, float2(0.5, 0.5));
        r2.z = 1;
        r0.y = dot(r2.xyz, r4.xyz);
      } else {
        r0.y = 4;
      }
    }
  }
  r0.x = 3.32192802 * r0.y;
  r1.z = exp2(r0.x);
  r0.x = dot(r1.xyz, float3(0.695452213, 0.140678659, 0.163869068));
  r0.y = dot(r1.xyz, float3(0.0447945744, 0.859670997, 0.0955343246));
  r0.z = dot(r1.xyz, float3(-0.00552586792, 0.00402521156, 1.00150073));
  if (CB0[0][3].x != 0) {
    r0.w = dot(r0.xyz, float3(1.45143938, -0.236510724, -0.214928553));
    r1.x = dot(r0.xyz, float3(-0.0765537992, 1.17622995, -0.0996759459));
    r1.y = dot(r0.xyz, float3(0.00831612758, -0.00603244733, 0.997716188));
    r1.z = cmp(CB0[0][3].w >= 4000);
    if (r1.z != 0) {
      r3.xyzw = float4(-2.30102992, -2.30102992, -1.93120003, -1.52049994);
      r4.xyzw = float4(-1.05780005, -0.466800004, 0.119379997, 0.708813429);
      r11.xyzw = float4(1.29118657, 0.797318637, 1.2026813, 1.60930002);
      r8.xyzw = float4(2.01079988, 2.41479993, 2.81789994, 3.1724999);
      r6.xyzw = float4(0.000141798722, 0.00499999989, 6824.36377, 4000);
      r5.xy = float2(3.53449965, 3.66962051);
      r1.z = 0.300000012;
    } else {
      r1.z = cmp(CB0[0][3].w < 48);
      if (r1.z != 0) {
        r3.xyzw = float4(-1.69896996, -1.69896996, -1.47790003, -1.22909999);
        r4.xyzw = float4(-0.864799976, -0.448000014, 0.00517999986, 0.451108038);
        r11.xyzw = float4(0.91137445, 0.515438676, 0.847043753, 1.1358);
        r8.xyzw = float4(1.38020003, 1.51970005, 1.59850001, 1.64670002);
        r6.xyzw = float4(0.00287989364, 0.0199999996, 1005.71893, 48);
        r5.xy = float2(1.67460918, 1.68787336);
        r1.z = 0.0399999991;
      } else {
        r1.z = cmp(CB0[0][3].w >= 2000);
        if (r1.z != 0) {
          r1.z = -2000 + CB0[0][3].w;
          r2.x = saturate(0.000500000024 * r1.z);
          r1.z = log2(CB0[0][3].w);
          r2.y = saturate(-10.9657841 + r1.z);
          r3.xyzw = float4(-2.30102992, -2.30102992, -1.93120003, -1.52049994);
          r4.xyzw = float4(-1.05780005, -0.466800004, 0.119379997, 0.708813429);
          r5.xyzw = float4(1.29118657, 0.801995218, 1.19800484, 1.59430003);
          r6.xyzw = float4(1.99730003, 2.37829995, 2.76839995, 3.05150008);
          r7.xyzw = float4(3.27462935, 3.32743073, 0.797318637, 1.2026813);
          r8.xyzw = float4(1.60930002, 2.01079988, 2.41479993, 2.81789994);
          r1.zw = float2(12, 0.00499999989);
          r2.zw = float2(2000, 0.119999997);
          r9.xyzw = float4(3.1724999, 3.53449965, 3.66962051, -12);
          r10.xyz = float3(4000, 0.300000012, 11);
        } else {
          r1.z = cmp(CB0[0][3].w >= 1000);
          if (r1.z != 0) {
            r1.z = -1000 + CB0[0][3].w;
            r2.x = saturate(0.00100000005 * r1.z);
            r1.z = log2(CB0[0][3].w);
            r2.y = saturate(-9.96578407 + r1.z);
            r3.xyzw = float4(-2.30102992, -2.30102992, -1.93120003, -1.52049994);
            r4.xyzw = float4(-1.05780005, -0.466800004, 0.119379997, 0.708813429);
            r5.xyzw = float4(1.29118657, 0.808913231, 1.19108677, 1.56830001);
            r6.xyzw = float4(1.9483, 2.30830002, 2.63840008, 2.85949993);
            r7.xyzw = float4(2.98726082, 3.01273918, 0.801995218, 1.19800484);
            r8.xyzw = float4(1.59430003, 1.99730003, 2.37829995, 2.76839995);
            r1.zw = float2(11, 0.00499999989);
            r2.zw = float2(1000, 0.0599999987);
            r9.xyzw = float4(3.05150008, 3.27462935, 3.32743073, -12);
            r10.xyz = float3(2000, 0.119999997, 10);
          } else {
            r1.z = -48 + CB0[0][3].w;
            r2.x = saturate(0.00105042022 * r1.z);
            r1.z = log2(CB0[0][3].w);
            r1.z = -5.58496237 + r1.z;
            r2.y = saturate(0.228267685 * r1.z);
            r3.xyzw = float4(-1.69896996, -1.69896996, -1.47790003, -1.22909999);
            r4.xyzw = float4(-0.864799976, -0.448000014, 0.00517999986, 0.451108038);
            r5.xyzw = float4(0.91137445, 0.515438676, 0.847043753, 1.1358);
            r6.xyzw = float4(1.38020003, 1.51970005, 1.59850001, 1.64670002);
            r7.xyzw = float4(1.67460918, 1.68787336, 0.808913231, 1.19108677);
            r8.xyzw = float4(1.56830001, 1.9483, 2.30830002, 2.63840008);
            r1.zw = float2(10, 0.0199999996);
            r2.zw = float2(48, 0.0399999991);
            r9.xyzw = float4(2.85949993, 2.98726082, 3.01273918, -6.5);
            r10.xyz = float3(1000, 0.0599999987, 6.5);
          }
        }
        r3.xyzw = float4(3.32192802, 3.32192802, 3.32192802, 3.32192802) * r3.xyzw;
        r3.xyzw = exp2(r3.xyzw);
        r11.xyzw = float4(0.00500000222, 0.00500000222, 0.0117165567, 0.0301647708) + -r3.xyzw;
        r3.xyzw = r2.xxxx * r11.xyzw + r3.xyzw;
        r3.xyzw = log2(r3.xyzw);
        r5.xyzw = float4(3.32192802, 3.32192802, 3.32192802, 3.32192802) * r5.yzwx;
        r5.xyzw = exp2(r5.xyzw);
        r7.xyzw = float4(3.32192802, 3.32192802, 3.32192802, 3.32192802) * r7.zwxy;
        r7.xyzw = exp2(r7.xyzw);
        r7.xy = r7.xy + -r5.xy;
        r5.xy = r2.xx * r7.xy + r5.xy;
        r5.xy = log2(r5.xy);
        r11.yz = float2(0.30103001, 0.30103001) * r5.xy;
        r8.xyzw = float4(3.32192802, 3.32192802, 3.32192802, 3.32192802) * r8.xyzw;
        r8.xyzw = exp2(r8.xyzw);
        r5.x = r8.x + -r5.z;
        r5.x = r2.x * r5.x + r5.z;
        r5.x = log2(r5.x);
        r11.w = 0.30103001 * r5.x;
        r3.xyzw = float4(0.30103001, 0.30103001, 0.30103001, 0.30103001) * r3.xyzw;
        r6.xyzw = float4(3.32192802, 3.32192802, 3.32192802, 3.32192802) * r6.xyzw;
        r6.xyzw = exp2(r6.xyzw);
        r5.xyz = r8.yzw + -r6.xyz;
        r5.xyz = r2.xxx * r5.xyz + r6.xyz;
        r5.xyz = log2(r5.xyz);
        r4.xyzw = float4(3.32192802, 3.32192802, 3.32192802, 3.32192802) * r4.xyzw;
        r4.xyzw = exp2(r4.xyzw);
        r8.xyzw = float4(0.0875386819, 0.341350079, 1.31637609, 5.11462021) + -r4.xyzw;
        r4.xyzw = r2.xxxx * r8.xyzw + r4.xyzw;
        r4.xyzw = log2(r4.xyzw);
        r8.xyz = float3(0.30103001, 0.30103001, 0.30103001) * r5.xyz;
        r5.xyz = float3(3.32192802, 3.32192802, 3.32192802) * r9.xyz;
        r5.xyz = exp2(r5.xyz);
        r5.x = r5.x + -r6.w;
        r5.x = r2.x * r5.x + r6.w;
        r5.x = log2(r5.x);
        r8.w = 0.30103001 * r5.x;
        r4.xyzw = float4(0.30103001, 0.30103001, 0.30103001, 0.30103001) * r4.xyzw;
        r5.xy = r5.yz + -r7.zw;
        r5.xy = r2.xx * r5.xy + r7.zw;
        r5.xy = log2(r5.xy);
        r5.z = 19.5517921 + -r5.w;
        r5.z = r2.x * r5.z + r5.w;
        r5.z = log2(r5.z);
        r11.x = 0.30103001 * r5.z;
        r5.z = -12 + -r9.w;
        r5.z = r2.y * r5.z + r9.w;
        r5.z = exp2(r5.z);
        r5.xyz = float3(0.30103001, 0.30103001, 0.180000007) * r5.xyz;
        r5.z = log2(r5.z);
        r5.w = cmp(-17.4739304 >= r5.z);
        if (r5.w != 0) {
          r5.z = -4;
        } else {
          r5.z = r5.z * 0.30103001 + 5.26017714;
          r5.w = 0.664385676 * r5.z;
          r6.x = (int)r5.w;
          r5.w = trunc(r5.w);
          r7.y = r5.z * 0.664385676 + -r5.w;
          r5.z = (int)r6.x + 2;
          r7.x = r7.y * r7.y;
          r9.x = 0.5;
          r9.y = icb[r6.x + 1].x;
          r9.z = icb[r5.z + 0].x;
          r12.x = dot(float3(-4, -1, 0.5), r9.xyz);
          r13.x = -1;
          r13.y = icb[r6.x + 1].x;
          r12.y = dot(float2(-4, 1), r13.xy);
          r12.z = dot(float2(-4, 0.5), r9.xy);
          r7.z = 1;
          r5.z = dot(r7.xyz, r12.xyz);
        }
        r5.z = 3.32192802 * r5.z;
        r6.x = exp2(r5.z);
        r5.z = 0.00499999989 + -r1.w;
        r6.y = r2.x * r5.z + r1.w;
        r1.z = -r10.z + r1.z;
        r1.z = r2.y * r1.z + r10.z;
        r1.z = exp2(r1.z);
        r1.z = 0.180000007 * r1.z;
        r1.z = log2(r1.z);
        r1.z = r1.z * 0.30103001 + 0.744727433;
        r1.w = 0.553654671 * r1.z;
        r2.y = (int)r1.w;
        r1.w = trunc(r1.w);
        r7.y = r1.z * 0.553654671 + -r1.w;
        r7.x = r7.y * r7.y;
        r9.x = icb[r2.y + 0].y;
        r9.y = icb[r2.y + 1].y;
        r9.z = icb[r2.y + 2].y;
        r12.x = dot(r9.xzy, float3(0.5, 0.5, -1));
        r12.y = dot(r9.xy, float2(-1, 1));
        r12.z = dot(r9.xy, float2(0.5, 0.5));
        r7.z = 1;
        r1.z = dot(r7.xyz, r12.xyz);
        r1.z = 3.32192802 * r1.z;
        r6.z = exp2(r1.z);
        r1.z = r10.x + -r2.z;
        r6.w = r2.x * r1.z + r2.z;
        r1.z = r10.y + -r2.w;
        r1.z = r2.x * r1.z + r2.w;
      }
    }
    r0.w = max(5.96046448e-08, r0.w);
    r0.w = log2(r0.w);
    r1.w = 0.30103001 * r0.w;
    r2.x = log2(r6.x);
    r2.y = 0.30103001 * r2.x;
    r2.z = cmp(r2.y >= r1.w);
    if (r2.z != 0) {
      r2.z = log2(r6.y);
      r2.z = 0.30103001 * r2.z;
    } else {
      r2.w = cmp(r0.w < 2.26303411);
      if (r2.w != 0) {
        r2.w = r0.w * 0.30103001 + -r2.y;
        r2.w = 7 * r2.w;
        r5.z = -r2.x * 0.30103001 + 0.681241155;
        r2.w = r2.w / r5.z;
        r5.z = (int)r2.w;
        r5.w = trunc(r2.w);
        r7.y = -r5.w + r2.w;
        r9.xyzw = cmp((int4)r5.zzzz == int4(3, 2, 1, 0));
        r10.xyzw = cmp((int4)r5.zzzz == int4(4, 5, 6, 7));
        r2.w = cmp((int)r5.z == 8);
        r9.xyzw = r9.xyzw ? float4(1, 1, 1, 1) : 0;
        r10.xyzw = r10.xyzw ? float4(1, 1, 1, 1) : 0;
        r2.w = r2.w ? 1.000000 : 0;
        r5.w = dot(r9.wzyx, r3.xyzw);
        r5.w = r10.x * r4.x + r5.w;
        r5.w = r10.y * r4.y + r5.w;
        r5.w = r10.z * r4.z + r5.w;
        r5.w = r10.w * r4.w + r5.w;
        r9.x = r2.w * r11.x + r5.w;
        r5.zw = (int2)r5.zz + int2(1, 2);
        r10.xyzw = cmp((int4)r5.zzzz == int4(3, 2, 1, 0));
        r12.xyzw = cmp((int4)r5.zzzz == int4(4, 5, 6, 7));
        r13.xy = cmp((int2)r5.zw == int2(8, 8));
        r10.xyzw = r10.xyzw ? float4(1, 1, 1, 1) : 0;
        r12.xyzw = r12.xyzw ? float4(1, 1, 1, 1) : 0;
        r13.xy = r13.xy ? float2(1, 1) : 0;
        r2.w = dot(r10.wzyx, r3.xyzw);
        r2.w = r12.x * r4.x + r2.w;
        r2.w = r12.y * r4.y + r2.w;
        r2.w = r12.z * r4.z + r2.w;
        r2.w = r12.w * r4.w + r2.w;
        r9.y = r13.x * r11.x + r2.w;
        r10.xyzw = cmp((int4)r5.wwww == int4(3, 2, 1, 0));
        r12.xyzw = cmp((int4)r5.wwww == int4(4, 5, 6, 7));
        r10.xyzw = r10.xyzw ? float4(1, 1, 1, 1) : 0;
        r12.xyzw = r12.xyzw ? float4(1, 1, 1, 1) : 0;
        r2.w = dot(r10.wzyx, r3.xyzw);
        r2.w = r12.x * r4.x + r2.w;
        r2.w = r12.y * r4.y + r2.w;
        r2.w = r12.z * r4.z + r2.w;
        r2.w = r12.w * r4.w + r2.w;
        r9.z = r13.y * r11.x + r2.w;
        r7.x = r7.y * r7.y;
        r10.x = dot(r9.xzy, float3(0.5, 0.5, -1));
        r10.y = dot(r9.xy, float2(-1, 1));
        r10.z = dot(r9.xy, float2(0.5, 0.5));
        r7.z = 1;
        r2.z = dot(r7.xyz, r10.xyz);
      } else {
        r2.w = log2(r6.z);
        r5.z = 0.30103001 * r2.w;
        r5.w = cmp(r1.w < r5.z);
        if (r5.w != 0) {
          r0.w = r0.w * 0.30103001 + -0.681241155;
          r0.w = 7 * r0.w;
          r2.w = r2.w * 0.30103001 + -0.681241155;
          r0.w = r0.w / r2.w;
          r2.w = (int)r0.w;
          r5.w = trunc(r0.w);
          r7.y = -r5.w + r0.w;
          r9.xyzw = cmp((int4)r2.wwww == int4(0, 1, 2, 3));
          r10.xyzw = cmp((int4)r2.wwww == int4(4, 5, 6, 7));
          r0.w = cmp((int)r2.w == 8);
          r9.xyzw = r9.xyzw ? float4(1, 1, 1, 1) : 0;
          r10.xyzw = r10.xyzw ? float4(1, 1, 1, 1) : 0;
          r0.w = r0.w ? 1.000000 : 0;
          r5.w = dot(r9.xyz, r11.yzw);
          r5.w = r9.w * r8.x + r5.w;
          r5.w = r10.x * r8.y + r5.w;
          r5.w = r10.y * r8.z + r5.w;
          r5.w = r10.z * r8.w + r5.w;
          r5.w = r10.w * r5.x + r5.w;
          r9.x = r0.w * r5.y + r5.w;
          r10.xy = (int2)r2.ww + int2(1, 2);
          r12.xyzw = cmp((int4)r10.xxxx == int4(0, 1, 2, 3));
          r13.xyzw = cmp((int4)r10.xxxx == int4(4, 5, 6, 7));
          r10.xz = cmp((int2)r10.xy == int2(8, 8));
          r12.xyzw = r12.xyzw ? float4(1, 1, 1, 1) : 0;
          r13.xyzw = r13.xyzw ? float4(1, 1, 1, 1) : 0;
          r10.xz = r10.xz ? float2(1, 1) : 0;
          r0.w = dot(r12.xyz, r11.yzw);
          r0.w = r12.w * r8.x + r0.w;
          r0.w = r13.x * r8.y + r0.w;
          r0.w = r13.y * r8.z + r0.w;
          r0.w = r13.z * r8.w + r0.w;
          r0.w = r13.w * r5.x + r0.w;
          r9.y = r10.x * r5.y + r0.w;
          r12.xyzw = cmp((int4)r10.yyyy == int4(0, 1, 2, 3));
          r13.xyzw = cmp((int4)r10.yyyy == int4(4, 5, 6, 7));
          r12.xyzw = r12.xyzw ? float4(1, 1, 1, 1) : 0;
          r13.xyzw = r13.xyzw ? float4(1, 1, 1, 1) : 0;
          r0.w = dot(r12.xyz, r11.yzw);
          r0.w = r12.w * r8.x + r0.w;
          r0.w = r13.x * r8.y + r0.w;
          r0.w = r13.y * r8.z + r0.w;
          r0.w = r13.z * r8.w + r0.w;
          r0.w = r13.w * r5.x + r0.w;
          r9.z = r10.z * r5.y + r0.w;
          r7.x = r7.y * r7.y;
          r10.x = dot(r9.xzy, float3(0.5, 0.5, -1));
          r10.y = dot(r9.xy, float2(-1, 1));
          r10.z = dot(r9.xy, float2(0.5, 0.5));
          r7.z = 1;
          r2.z = dot(r7.xyz, r10.xyz);
        } else {
          r0.w = log2(r6.w);
          r2.w = r5.z * r1.z;
          r0.w = r0.w * 0.30103001 + -r2.w;
          r2.z = r1.w * r1.z + r0.w;
        }
      }
    }
    r0.w = 3.32192802 * r2.z;
    r0.w = exp2(r0.w);
    r1.xy = max(float2(5.96046448e-08, 5.96046448e-08), r1.xy);
    r1.x = log2(r1.x);
    r1.w = 0.30103001 * r1.x;
    r2.z = cmp(r2.y >= r1.w);
    if (r2.z != 0) {
      r2.z = log2(r6.y);
      r2.z = 0.30103001 * r2.z;
    } else {
      r2.w = cmp(r1.x < 2.26303411);
      if (r2.w != 0) {
        r2.w = r1.x * 0.30103001 + -r2.y;
        r2.w = 7 * r2.w;
        r5.z = -r2.x * 0.30103001 + 0.681241155;
        r2.w = r2.w / r5.z;
        r5.z = (int)r2.w;
        r5.w = trunc(r2.w);
        r7.y = -r5.w + r2.w;
        r9.xyzw = cmp((int4)r5.zzzz == int4(3, 2, 1, 0));
        r10.xyzw = cmp((int4)r5.zzzz == int4(4, 5, 6, 7));
        r2.w = cmp((int)r5.z == 8);
        r9.xyzw = r9.xyzw ? float4(1, 1, 1, 1) : 0;
        r10.xyzw = r10.xyzw ? float4(1, 1, 1, 1) : 0;
        r2.w = r2.w ? 1.000000 : 0;
        r5.w = dot(r9.wzyx, r3.xyzw);
        r5.w = r10.x * r4.x + r5.w;
        r5.w = r10.y * r4.y + r5.w;
        r5.w = r10.z * r4.z + r5.w;
        r5.w = r10.w * r4.w + r5.w;
        r9.x = r2.w * r11.x + r5.w;
        r5.zw = (int2)r5.zz + int2(1, 2);
        r10.xyzw = cmp((int4)r5.zzzz == int4(3, 2, 1, 0));
        r12.xyzw = cmp((int4)r5.zzzz == int4(4, 5, 6, 7));
        r13.xy = cmp((int2)r5.zw == int2(8, 8));
        r10.xyzw = r10.xyzw ? float4(1, 1, 1, 1) : 0;
        r12.xyzw = r12.xyzw ? float4(1, 1, 1, 1) : 0;
        r13.xy = r13.xy ? float2(1, 1) : 0;
        r2.w = dot(r10.wzyx, r3.xyzw);
        r2.w = r12.x * r4.x + r2.w;
        r2.w = r12.y * r4.y + r2.w;
        r2.w = r12.z * r4.z + r2.w;
        r2.w = r12.w * r4.w + r2.w;
        r9.y = r13.x * r11.x + r2.w;
        r10.xyzw = cmp((int4)r5.wwww == int4(3, 2, 1, 0));
        r12.xyzw = cmp((int4)r5.wwww == int4(4, 5, 6, 7));
        r10.xyzw = r10.xyzw ? float4(1, 1, 1, 1) : 0;
        r12.xyzw = r12.xyzw ? float4(1, 1, 1, 1) : 0;
        r2.w = dot(r10.wzyx, r3.xyzw);
        r2.w = r12.x * r4.x + r2.w;
        r2.w = r12.y * r4.y + r2.w;
        r2.w = r12.z * r4.z + r2.w;
        r2.w = r12.w * r4.w + r2.w;
        r9.z = r13.y * r11.x + r2.w;
        r7.x = r7.y * r7.y;
        r10.x = dot(r9.xzy, float3(0.5, 0.5, -1));
        r10.y = dot(r9.xy, float2(-1, 1));
        r10.z = dot(r9.xy, float2(0.5, 0.5));
        r7.z = 1;
        r2.z = dot(r7.xyz, r10.xyz);
      } else {
        r2.w = log2(r6.z);
        r5.z = 0.30103001 * r2.w;
        r5.w = cmp(r1.w < r5.z);
        if (r5.w != 0) {
          r1.x = r1.x * 0.30103001 + -0.681241155;
          r1.x = 7 * r1.x;
          r2.w = r2.w * 0.30103001 + -0.681241155;
          r1.x = r1.x / r2.w;
          r2.w = (int)r1.x;
          r5.w = trunc(r1.x);
          r7.y = -r5.w + r1.x;
          r9.xyzw = cmp((int4)r2.wwww == int4(0, 1, 2, 3));
          r10.xyzw = cmp((int4)r2.wwww == int4(4, 5, 6, 7));
          r1.x = cmp((int)r2.w == 8);
          r9.xyzw = r9.xyzw ? float4(1, 1, 1, 1) : 0;
          r10.xyzw = r10.xyzw ? float4(1, 1, 1, 1) : 0;
          r1.x = r1.x ? 1.000000 : 0;
          r5.w = dot(r9.xyz, r11.yzw);
          r5.w = r9.w * r8.x + r5.w;
          r5.w = r10.x * r8.y + r5.w;
          r5.w = r10.y * r8.z + r5.w;
          r5.w = r10.z * r8.w + r5.w;
          r5.w = r10.w * r5.x + r5.w;
          r9.x = r1.x * r5.y + r5.w;
          r10.xy = (int2)r2.ww + int2(1, 2);
          r12.xyzw = cmp((int4)r10.xxxx == int4(0, 1, 2, 3));
          r13.xyzw = cmp((int4)r10.xxxx == int4(4, 5, 6, 7));
          r10.xz = cmp((int2)r10.xy == int2(8, 8));
          r12.xyzw = r12.xyzw ? float4(1, 1, 1, 1) : 0;
          r13.xyzw = r13.xyzw ? float4(1, 1, 1, 1) : 0;
          r10.xz = r10.xz ? float2(1, 1) : 0;
          r1.x = dot(r12.xyz, r11.yzw);
          r1.x = r12.w * r8.x + r1.x;
          r1.x = r13.x * r8.y + r1.x;
          r1.x = r13.y * r8.z + r1.x;
          r1.x = r13.z * r8.w + r1.x;
          r1.x = r13.w * r5.x + r1.x;
          r9.y = r10.x * r5.y + r1.x;
          r12.xyzw = cmp((int4)r10.yyyy == int4(0, 1, 2, 3));
          r13.xyzw = cmp((int4)r10.yyyy == int4(4, 5, 6, 7));
          r12.xyzw = r12.xyzw ? float4(1, 1, 1, 1) : 0;
          r13.xyzw = r13.xyzw ? float4(1, 1, 1, 1) : 0;
          r1.x = dot(r12.xyz, r11.yzw);
          r1.x = r12.w * r8.x + r1.x;
          r1.x = r13.x * r8.y + r1.x;
          r1.x = r13.y * r8.z + r1.x;
          r1.x = r13.z * r8.w + r1.x;
          r1.x = r13.w * r5.x + r1.x;
          r9.z = r10.z * r5.y + r1.x;
          r7.x = r7.y * r7.y;
          r10.x = dot(r9.xzy, float3(0.5, 0.5, -1));
          r10.y = dot(r9.xy, float2(-1, 1));
          r10.z = dot(r9.xy, float2(0.5, 0.5));
          r7.z = 1;
          r2.z = dot(r7.xyz, r10.xyz);
        } else {
          r1.x = log2(r6.w);
          r2.w = r5.z * r1.z;
          r1.x = r1.x * 0.30103001 + -r2.w;
          r2.z = r1.w * r1.z + r1.x;
        }
      }
    }
    r1.x = 3.32192802 * r2.z;
    r1.x = exp2(r1.x);
    r1.y = log2(r1.y);
    r1.w = 0.30103001 * r1.y;
    r2.z = cmp(r2.y >= r1.w);
    if (r2.z != 0) {
      r2.z = log2(r6.y);
      r2.z = 0.30103001 * r2.z;
    } else {
      r2.w = cmp(r1.y < 2.26303411);
      if (r2.w != 0) {
        r2.y = r1.y * 0.30103001 + -r2.y;
        r2.y = 7 * r2.y;
        r2.x = -r2.x * 0.30103001 + 0.681241155;
        r2.x = r2.y / r2.x;
        r2.y = (int)r2.x;
        r2.w = trunc(r2.x);
        r7.y = r2.x + -r2.w;
        r9.xyzw = cmp((int4)r2.yyyy == int4(3, 2, 1, 0));
        r10.xyzw = cmp((int4)r2.yyyy == int4(4, 5, 6, 7));
        r2.x = cmp((int)r2.y == 8);
        r9.xyzw = r9.xyzw ? float4(1, 1, 1, 1) : 0;
        r10.xyzw = r10.xyzw ? float4(1, 1, 1, 1) : 0;
        r2.x = r2.x ? 1.000000 : 0;
        r2.w = dot(r9.wzyx, r3.xyzw);
        r2.w = r10.x * r4.x + r2.w;
        r2.w = r10.y * r4.y + r2.w;
        r2.w = r10.z * r4.z + r2.w;
        r2.w = r10.w * r4.w + r2.w;
        r9.x = r2.x * r11.x + r2.w;
        r2.xy = (int2)r2.yy + int2(1, 2);
        r10.xyzw = cmp((int4)r2.xxxx == int4(3, 2, 1, 0));
        r12.xyzw = cmp((int4)r2.xxxx == int4(4, 5, 6, 7));
        r2.xw = cmp((int2)r2.xy == int2(8, 8));
        r10.xyzw = r10.xyzw ? float4(1, 1, 1, 1) : 0;
        r12.xyzw = r12.xyzw ? float4(1, 1, 1, 1) : 0;
        r2.xw = r2.xw ? float2(1, 1) : 0;
        r5.z = dot(r10.wzyx, r3.xyzw);
        r5.z = r12.x * r4.x + r5.z;
        r5.z = r12.y * r4.y + r5.z;
        r5.z = r12.z * r4.z + r5.z;
        r5.z = r12.w * r4.w + r5.z;
        r9.y = r2.x * r11.x + r5.z;
        r10.xyzw = cmp((int4)r2.yyyy == int4(3, 2, 1, 0));
        r12.xyzw = cmp((int4)r2.yyyy == int4(4, 5, 6, 7));
        r10.xyzw = r10.xyzw ? float4(1, 1, 1, 1) : 0;
        r12.xyzw = r12.xyzw ? float4(1, 1, 1, 1) : 0;
        r2.x = dot(r10.wzyx, r3.xyzw);
        r2.x = r12.x * r4.x + r2.x;
        r2.x = r12.y * r4.y + r2.x;
        r2.x = r12.z * r4.z + r2.x;
        r2.x = r12.w * r4.w + r2.x;
        r9.z = r2.w * r11.x + r2.x;
        r7.x = r7.y * r7.y;
        r3.x = dot(r9.xzy, float3(0.5, 0.5, -1));
        r3.y = dot(r9.xy, float2(-1, 1));
        r3.z = dot(r9.xy, float2(0.5, 0.5));
        r7.z = 1;
        r2.z = dot(r7.xyz, r3.xyz);
      } else {
        r2.x = log2(r6.z);
        r2.y = 0.30103001 * r2.x;
        r2.w = cmp(r1.w < r2.y);
        if (r2.w != 0) {
          r1.y = r1.y * 0.30103001 + -0.681241155;
          r1.y = 7 * r1.y;
          r2.x = r2.x * 0.30103001 + -0.681241155;
          r1.y = r1.y / r2.x;
          r2.x = (int)r1.y;
          r2.w = trunc(r1.y);
          r3.y = -r2.w + r1.y;
          r4.xyzw = cmp((int4)r2.xxxx == int4(0, 1, 2, 3));
          r7.xyzw = cmp((int4)r2.xxxx == int4(4, 5, 6, 7));
          r1.y = cmp((int)r2.x == 8);
          r4.xyzw = r4.xyzw ? float4(1, 1, 1, 1) : 0;
          r7.xyzw = r7.xyzw ? float4(1, 1, 1, 1) : 0;
          r1.y = r1.y ? 1.000000 : 0;
          r2.w = dot(r4.xyz, r11.yzw);
          r2.w = r4.w * r8.x + r2.w;
          r2.w = r7.x * r8.y + r2.w;
          r2.w = r7.y * r8.z + r2.w;
          r2.w = r7.z * r8.w + r2.w;
          r2.w = r7.w * r5.x + r2.w;
          r4.x = r1.y * r5.y + r2.w;
          r2.xw = (int2)r2.xx + int2(1, 2);
          r7.xyzw = cmp((int4)r2.xxxx == int4(0, 1, 2, 3));
          r9.xyzw = cmp((int4)r2.xxxx == int4(4, 5, 6, 7));
          r5.zw = cmp((int2)r2.xw == int2(8, 8));
          r7.xyzw = r7.xyzw ? float4(1, 1, 1, 1) : 0;
          r9.xyzw = r9.xyzw ? float4(1, 1, 1, 1) : 0;
          r5.zw = r5.zw ? float2(1, 1) : 0;
          r1.y = dot(r7.xyz, r11.yzw);
          r1.y = r7.w * r8.x + r1.y;
          r1.y = r9.x * r8.y + r1.y;
          r1.y = r9.y * r8.z + r1.y;
          r1.y = r9.z * r8.w + r1.y;
          r1.y = r9.w * r5.x + r1.y;
          r4.y = r5.z * r5.y + r1.y;
          r7.xyzw = cmp((int4)r2.wwww == int4(0, 1, 2, 3));
          r9.xyzw = cmp((int4)r2.wwww == int4(4, 5, 6, 7));
          r7.xyzw = r7.xyzw ? float4(1, 1, 1, 1) : 0;
          r9.xyzw = r9.xyzw ? float4(1, 1, 1, 1) : 0;
          r1.y = dot(r7.xyz, r11.yzw);
          r1.y = r7.w * r8.x + r1.y;
          r1.y = r9.x * r8.y + r1.y;
          r1.y = r9.y * r8.z + r1.y;
          r1.y = r9.z * r8.w + r1.y;
          r1.y = r9.w * r5.x + r1.y;
          r4.z = r5.w * r5.y + r1.y;
          r3.x = r3.y * r3.y;
          r5.x = dot(r4.xzy, float3(0.5, 0.5, -1));
          r5.y = dot(r4.xy, float2(-1, 1));
          r5.z = dot(r4.xy, float2(0.5, 0.5));
          r3.z = 1;
          r2.z = dot(r3.xyz, r5.xyz);
        } else {
          r1.y = log2(r6.w);
          r2.x = r2.y * r1.z;
          r1.y = r1.y * 0.30103001 + -r2.x;
          r2.z = r1.w * r1.z + r1.y;
        }
      }
    }
    r1.y = 3.32192802 * r2.z;
    r1.y = exp2(r1.y);
    r2.x = -3.50738446e-05 + r0.w;
    r2.yz = float2(-3.50738446e-05, -3.50738446e-05) + r1.xy;
    r1.x = dot(r2.xyz, float3(0.662454247, 0.134004191, 0.156187713));
    r1.y = dot(r2.xyz, float3(0.272228748, 0.674081624, 0.0536895208));
    r1.z = dot(r2.xyz, float3(-0.00557466131, 0.00406072894, 1.01033914));
    r2.x = dot(r1.xyz, float3(0.987223983, -0.00611323956, 0.015953267));
    r2.y = dot(r1.xyz, float3(-0.00759830978, 1.00186133, 0.00533001823));
    r2.z = dot(r1.xyz, float3(0.00307257194, -0.00509595545, 1.08168054));
    r0.w = dot(r2.xyz, float3(1.71665084, -0.35567075, -0.253366232));
    r1.x = dot(r2.xyz, float3(-0.666684449, 1.61648142, 0.0157685392));
    r1.y = dot(r2.xyz, float3(0.0176398549, -0.0427706093, 0.942103207));
    r0.w = min(65520, r0.w);
    r0.w = max(0, r0.w);
    r1.xy = min(float2(65520, 65520), r1.xy);
    r1.xy = max(float2(0, 0), r1.xy);
    r0.w = 9.99999975e-05 * r0.w;
    r0.w = log2(r0.w);
    r0.w = 0.159301758 * r0.w;
    r0.w = exp2(r0.w);
    r1.zw = r0.ww * float2(18.8515625, 18.6875) + float2(0.8359375, 1);
    r0.w = r1.z / r1.w;
    r0.w = log2(r0.w);
    r0.w = 78.84375 * r0.w;
    r2.x = exp2(r0.w);
    r0.w = 9.99999975e-05 * r1.x;
    r0.w = log2(r0.w);
    r0.w = 0.159301758 * r0.w;
    r0.w = exp2(r0.w);
    r1.xz = r0.ww * float2(18.8515625, 18.6875) + float2(0.8359375, 1);
    r0.w = r1.x / r1.z;
    r0.w = log2(r0.w);
    r0.w = 78.84375 * r0.w;
    r2.y = exp2(r0.w);
    r0.w = 9.99999975e-05 * r1.y;
    r0.w = log2(r0.w);
    r0.w = 0.159301758 * r0.w;
    r0.w = exp2(r0.w);
    r1.xy = r0.ww * float2(18.8515625, 18.6875) + float2(0.8359375, 1);
    r0.w = r1.x / r1.y;
    r0.w = log2(r0.w);
    r0.w = 78.84375 * r0.w;
    r2.z = exp2(r0.w);
  } else {
    r0.w = dot(r0.xyz, float3(1.45143938, -0.236510724, -0.214928553));
    r1.x = dot(r0.xyz, float3(-0.0765537992, 1.17622995, -0.0996759459));
    r0.x = dot(r0.xyz, float3(0.00831612758, -0.00603244733, 0.997716188));
    r0.xy = max(float2(5.96046448e-08, 5.96046448e-08), r0.xw);
    r0.y = log2(r0.y);
    r0.z = cmp(-8.43976879 >= r0.y);
    if (r0.z != 0) {
      r0.z = -1.69896996;
    } else {
      r0.z = cmp(r0.y < 2.26303411);
      if (r0.z != 0) {
        r0.z = r0.y * 0.30103001 + 2.54062366;
        r0.w = 2.17265487 * r0.z;
        r1.y = (int)r0.w;
        r0.w = trunc(r0.w);
        r3.y = r0.z * 2.17265487 + -r0.w;
        r0.zw = (int2)r1.yy + int2(1, 2);
        r3.x = r3.y * r3.y;
        r4.x = icb[r1.y + 0].z;
        r4.y = icb[r0.z + 0].z;
        r4.z = icb[r0.w + 0].z;
        r5.x = dot(r4.xzy, float3(0.5, 0.5, -1));
        r5.y = dot(r4.xy, float2(-1, 1));
        r5.z = dot(r4.xy, float2(0.5, 0.5));
        r3.z = 1;
        r0.z = dot(r3.xyz, r5.xyz);
      } else {
        r0.w = cmp(r0.y < 9.97401142);
        if (r0.w != 0) {
          r0.w = r0.y * 0.30103001 + -0.681241155;
          r1.y = 3.01563525 * r0.w;
          r1.z = (int)r1.y;
          r1.y = trunc(r1.y);
          r3.y = r0.w * 3.01563525 + -r1.y;
          r1.yw = (int2)r1.zz + int2(1, 2);
          r3.x = r3.y * r3.y;
          r4.x = icb[r1.z + 0].w;
          r4.y = icb[r1.y + 0].w;
          r4.z = icb[r1.w + 0].w;
          r5.x = dot(r4.xzy, float3(0.5, 0.5, -1));
          r5.y = dot(r4.xy, float2(-1, 1));
          r5.z = dot(r4.xy, float2(0.5, 0.5));
          r3.z = 1;
          r0.z = dot(r3.xyz, r5.xyz);
        } else {
          r0.z = r0.y * 0.0120412 + 1.56114209;
        }
      }
    }
    r0.y = 3.32192802 * r0.z;
    r0.y = exp2(r0.y);
    r0.z = max(5.96046448e-08, r1.x);
    r0.z = log2(r0.z);
    r0.w = cmp(-8.43976879 >= r0.z);
    if (r0.w != 0) {
      r0.w = -1.69896996;
    } else {
      r0.w = cmp(r0.z < 2.26303411);
      if (r0.w != 0) {
        r0.w = r0.z * 0.30103001 + 2.54062366;
        r1.x = 2.17265487 * r0.w;
        r1.y = (int)r1.x;
        r1.x = trunc(r1.x);
        r3.y = r0.w * 2.17265487 + -r1.x;
        r1.xz = (int2)r1.yy + int2(1, 2);
        r3.x = r3.y * r3.y;
        r4.x = icb[r1.y + 0].z;
        r4.y = icb[r1.x + 0].z;
        r4.z = icb[r1.z + 0].z;
        r1.x = dot(r4.xzy, float3(0.5, 0.5, -1));
        r1.y = dot(r4.xy, float2(-1, 1));
        r1.z = dot(r4.xy, float2(0.5, 0.5));
        r3.z = 1;
        r0.w = dot(r3.xyz, r1.xyz);
      } else {
        r1.x = cmp(r0.z < 9.97401142);
        if (r1.x != 0) {
          r1.x = r0.z * 0.30103001 + -0.681241155;
          r1.y = 3.01563525 * r1.x;
          r1.z = (int)r1.y;
          r1.y = trunc(r1.y);
          r3.y = r1.x * 3.01563525 + -r1.y;
          r1.xy = (int2)r1.zz + int2(1, 2);
          r3.x = r3.y * r3.y;
          r4.x = icb[r1.z + 0].w;
          r4.y = icb[r1.x + 0].w;
          r4.z = icb[r1.y + 0].w;
          r1.x = dot(r4.xzy, float3(0.5, 0.5, -1));
          r1.y = dot(r4.xy, float2(-1, 1));
          r1.z = dot(r4.xy, float2(0.5, 0.5));
          r3.z = 1;
          r0.w = dot(r3.xyz, r1.xyz);
        } else {
          r0.w = r0.z * 0.0120412 + 1.56114209;
        }
      }
    }
    r0.z = 3.32192802 * r0.w;
    r0.z = exp2(r0.z);
    r0.x = log2(r0.x);
    r0.w = cmp(-8.43976879 >= r0.x);
    if (r0.w != 0) {
      r0.w = -1.69896996;
    } else {
      r0.w = cmp(r0.x < 2.26303411);
      if (r0.w != 0) {
        r0.w = r0.x * 0.30103001 + 2.54062366;
        r1.x = 2.17265487 * r0.w;
        r1.y = (int)r1.x;
        r1.x = trunc(r1.x);
        r3.y = r0.w * 2.17265487 + -r1.x;
        r1.xz = (int2)r1.yy + int2(1, 2);
        r3.x = r3.y * r3.y;
        r4.x = icb[r1.y + 0].z;
        r4.y = icb[r1.x + 0].z;
        r4.z = icb[r1.z + 0].z;
        r1.x = dot(r4.xzy, float3(0.5, 0.5, -1));
        r1.y = dot(r4.xy, float2(-1, 1));
        r1.z = dot(r4.xy, float2(0.5, 0.5));
        r3.z = 1;
        r0.w = dot(r3.xyz, r1.xyz);
      } else {
        r1.x = cmp(r0.x < 9.97401142);
        if (r1.x != 0) {
          r1.x = r0.x * 0.30103001 + -0.681241155;
          r1.y = 3.01563525 * r1.x;
          r1.z = (int)r1.y;
          r1.y = trunc(r1.y);
          r3.y = r1.x * 3.01563525 + -r1.y;
          r1.xy = (int2)r1.zz + int2(1, 2);
          r3.x = r3.y * r3.y;
          r4.x = icb[r1.z + 0].w;
          r4.y = icb[r1.x + 0].w;
          r4.z = icb[r1.y + 0].w;
          r1.x = dot(r4.xzy, float3(0.5, 0.5, -1));
          r1.y = dot(r4.xy, float2(-1, 1));
          r1.z = dot(r4.xy, float2(0.5, 0.5));
          r3.z = 1;
          r0.w = dot(r3.xyz, r1.xyz);
        } else {
          r0.w = r0.x * 0.0120412 + 1.56114209;
        }
      }
    }
    r0.x = 3.32192802 * r0.w;
    r0.x = exp2(r0.x);
    r0.xy = float2(-0.0199999996, -0.0199999996) + r0.xy;
    r1.x = 0.0208420176 * r0.y;
    r0.y = -0.0199999996 + r0.z;
    r1.yz = float2(0.0208420176, 0.0208420176) * r0.yx;
    r0.x = dot(r1.xyz, float3(0.662454247, 0.134004191, 0.156187713));
    r0.y = dot(r1.xyz, float3(0.272228748, 0.674081624, 0.0536895208));
    r0.z = dot(r1.xyz, float3(-0.00557466131, 0.00406072894, 1.01033914));
    r0.w = r0.x + r0.y;
    r0.z = r0.w + r0.z;
    r0.w = cmp(r0.z == 0.000000);
    r0.z = r0.w ? 1.00000001e-10 : r0.z;
    r0.x = r0.x / r0.z;
    r0.z = r0.y / r0.z;
    r0.yw = max(float2(0, 1.00000001e-10), r0.yz);
    r0.y = min(65520, r0.y);
    r0.y = log2(r0.y);
    r0.y = 0.981100023 * r0.y;
    r1.y = exp2(r0.y);
    r0.y = r1.y * r0.x;
    r0.x = 1 + -r0.x;
    r0.x = r0.x + -r0.z;
    r0.x = r0.x * r1.y;
    r1.xz = r0.yx / r0.ww;
    r0.x = dot(r1.xyz, float3(1.64102316, -0.324803293, -0.236424685));
    r0.y = dot(r1.xyz, float3(-0.66366303, 1.61533201, 0.0167563651));
    r0.z = dot(r1.xyz, float3(0.01172191, -0.00828443933, 0.988394737));
    r1.x = dot(r0.xyz, float3(0.949056029, 0.0471857078, 0.0037582661));
    r1.y = dot(r0.xyz, float3(0.019056011, 0.977185726, 0.0037582661));
    r1.z = dot(r0.xyz, float3(0.019056011, 0.0471857078, 0.933758259));
    r0.x = dot(r1.xyz, float3(0.662454247, 0.134004191, 0.156187713));
    r0.y = dot(r1.xyz, float3(0.272228748, 0.674081624, 0.0536895208));
    r0.z = dot(r1.xyz, float3(-0.00557466131, 0.00406072894, 1.01033914));
    r1.x = dot(r0.xyz, float3(0.987223983, -0.00611323956, 0.015953267));
    r1.y = dot(r0.xyz, float3(-0.00759830978, 1.00186133, 0.00533001823));
    r1.z = dot(r0.xyz, float3(0.00307257194, -0.00509595545, 1.08168054));
    r0.x = saturate(dot(r1.xyz, float3(3.2409699, -1.5373832, -0.498610765)));
    r0.y = saturate(dot(r1.xyz, float3(-0.969243586, 1.87596726, 0.0415550619)));
    r0.z = saturate(dot(r1.xyz, float3(0.0556300581, -0.203976914, 1.05697179)));
    r0.w = cmp(r0.x >= 0.00303993281);
    r1.x = log2(r0.x);
    r1.x = 0.416666657 * r1.x;
    r1.x = exp2(r1.x);
    r1.x = r1.x * 1.05499995 + -0.0549999997;
    r0.x = 12.9232101 * r0.x;
    r2.x = r0.w ? r1.x : r0.x;
    r0.x = cmp(r0.y >= 0.00303993281);
    r0.w = log2(r0.y);
    r0.w = 0.416666657 * r0.w;
    r0.w = exp2(r0.w);
    r0.w = r0.w * 1.05499995 + -0.0549999997;
    r0.y = 12.9232101 * r0.y;
    r2.y = r0.x ? r0.w : r0.y;
    r0.x = cmp(r0.z >= 0.00303993281);
    r0.y = log2(r0.z);
    r0.y = 0.416666657 * r0.y;
    r0.y = exp2(r0.y);
    r0.y = r0.y * 1.05499995 + -0.0549999997;
    r0.z = 12.9232101 * r0.z;
    r2.z = r0.x ? r0.y : r0.z;
  }
  r2.w = 1;
  // No code for instruction (needs manual fix):
  // store_uav_typed U0[0].xyzw, vThreadID.xyzz, r2.xyzw
  u0[vThreadID.xyz] = r2.xyzw;
  return;
}
