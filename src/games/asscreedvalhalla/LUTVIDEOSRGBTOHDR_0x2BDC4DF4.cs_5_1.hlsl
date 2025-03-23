#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Sat Mar 22 22:56:20 2025
RWTexture3D<float4> u0 : register(u0, space6);

cbuffer CB0 : register(b0, space6) {
  float4 CB0[1][10];
};

// 3Dmigoto declarations
#define cmp -

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
  float4 r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16;
  uint4 bitmask, uiDest;
  float4 fDest;

  // Needs manual fix for instruction:
  // unknown dcl_: dcl_thread_group 16, 16, 1
  r0.xyz = (uint3)vThreadID.xyz;
  r1.xyz = float3(0.0322580636, 0.0322580636, 0.0322580636) * r0.xyz;
  if (CB0[0][3].x != 0) {
    r1.xyz = log2(r1.xyz);
    r1.xyz = float3(0.0126833133, 0.0126833133, 0.0126833133) * r1.xyz;
    r1.xyz = exp2(r1.xyz);
    r2.xyz = float3(-0.8359375, -0.8359375, -0.8359375) + r1.xyz;
    r2.xyz = max(float3(0, 0, 0), r2.xyz);
    r1.xyz = -r1.xyz * float3(18.6875, 18.6875, 18.6875) + float3(18.8515625, 18.8515625, 18.8515625);
    r1.xyz = r2.xyz / r1.xyz;
    r1.xyz = log2(abs(r1.xyz));
    r1.xyz = float3(6.27739477, 6.27739477, 6.27739477) * r1.xyz;
    r1.xyz = exp2(r1.xyz);
    r1.xyz = float3(10000, 10000, 10000) * r1.xyz;
    r2.x = dot(r1.xyz, float3(0.636958182, 0.144616887, 0.168880954));
    r2.y = dot(r1.xyz, float3(0.26270026, 0.677998006, 0.0593017116));
    r2.z = dot(r1.yz, float2(0.0280726831, 1.06098497));
    r1.x = dot(r2.xyz, float3(1.01303494, 0.0061052707, -0.0149709256));
    r1.y = dot(r2.xyz, float3(0.00769816991, 0.998163581, -0.00503202248));
    r1.z = dot(r2.xyz, float3(-0.00284131337, 0.00468515232, 0.924506247));
    r0.w = dot(r1.xyz, float3(1.64102316, -0.324803293, -0.236424685));
    r1.w = dot(r1.xyz, float3(-0.66366303, 1.61533201, 0.0167563651));
    r1.x = dot(r1.xyz, float3(0.01172191, -0.00828443933, 0.988394737));
    r0.w = 3.50738446e-05 + r0.w;
    r1.xy = float2(3.50738446e-05, 3.50738446e-05) + r1.xw;
    r1.z = cmp(CB0[0][3].w >= 4000);
    if (r1.z != 0) {
      r3.xyzw = float4(-2.30102992, -2.30102992, -1.93120003, -1.52049994);
      r4.xyzw = float4(0.708813429, 0.119379997, -0.466800004, -1.05780005);
      r11.xyzw = float4(0.797318637, 1.2026813, 1.60930002, 2.01079988);
      r8.xyzw = float4(3.53449965, 3.1724999, 2.81789994, 2.41479993);
      r12.xyzw = float4(0.000141798722, 0.00499999989, 10, 6824.36377);
      r7.w = 1.29118657;
      r6.w = 3.66962051;
      r1.z = 4000;
    } else {
      r1.z = cmp(CB0[0][3].w < 48);
      if (r1.z != 0) {
        r3.xyzw = float4(-1.69896996, -1.69896996, -1.47790003, -1.22909999);
        r4.xyzw = float4(0.451108038, 0.00517999986, -0.448000014, -0.864799976);
        r11.xyzw = float4(0.515438676, 0.847043753, 1.1358, 1.38020003);
        r8.xyzw = float4(1.67460918, 1.64670002, 1.59850001, 1.51970005);
        r12.xyzw = float4(0.00287989364, 0.0199999996, 4.80000019, 1005.71893);
        r7.w = 0.91137445;
        r6.w = 1.68787336;
        r1.z = 48;
      } else {
        r1.z = cmp(CB0[0][3].w >= 2000);
        if (r1.z != 0) {
          r1.z = -2000 + CB0[0][3].w;
          r2.x = saturate(0.000500000024 * r1.z);
          r1.z = log2(CB0[0][3].w);
          r2.y = saturate(-10.9657841 + r1.z);
          r1.zw = float2(4000, 12);
          r3.xyzw = float4(-2.30102992, -2.30102992, -1.93120003, -1.52049994);
          r4.xyzw = float4(-1.05780005, -0.466800004, 0.119379997, 0.708813429);
          r5.xyzw = float4(1.29118657, 0.801995218, 1.19800484, 1.59430003);
          r6.xyzw = float4(1.99730003, 2.37829995, 2.76839995, 3.05150008);
          r7.xyzw = float4(3.27462935, 3.32743073, 0.797318637, 1.2026813);
          r8.xyzw = float4(1.60930002, 2.01079988, 2.41479993, 2.81789994);
          r2.zw = float2(0.00499999989, 10);
          r9.xyzw = float4(2000, 3.1724999, 3.53449965, 3.66962051);
          r10.xy = float2(-12, 11);
        } else {
          r1.z = cmp(CB0[0][3].w >= 1000);
          if (r1.z != 0) {
            r1.z = -1000 + CB0[0][3].w;
            r2.x = saturate(0.00100000005 * r1.z);
            r1.z = log2(CB0[0][3].w);
            r2.y = saturate(-9.96578407 + r1.z);
            r1.zw = float2(2000, 11);
            r3.xyzw = float4(-2.30102992, -2.30102992, -1.93120003, -1.52049994);
            r4.xyzw = float4(-1.05780005, -0.466800004, 0.119379997, 0.708813429);
            r5.xyzw = float4(1.29118657, 0.808913231, 1.19108677, 1.56830001);
            r6.xyzw = float4(1.9483, 2.30830002, 2.63840008, 2.85949993);
            r7.xyzw = float4(2.98726082, 3.01273918, 0.801995218, 1.19800484);
            r8.xyzw = float4(1.59430003, 1.99730003, 2.37829995, 2.76839995);
            r2.zw = float2(0.00499999989, 10);
            r9.xyzw = float4(1000, 3.05150008, 3.27462935, 3.32743073);
            r10.xy = float2(-12, 10);
          } else {
            r1.z = -48 + CB0[0][3].w;
            r2.x = saturate(0.00105042022 * r1.z);
            r1.z = log2(CB0[0][3].w);
            r1.z = -5.58496237 + r1.z;
            r2.y = saturate(0.228267685 * r1.z);
            r1.zw = float2(1000, 10);
            r3.xyzw = float4(-1.69896996, -1.69896996, -1.47790003, -1.22909999);
            r4.xyzw = float4(-0.864799976, -0.448000014, 0.00517999986, 0.451108038);
            r5.xyzw = float4(0.91137445, 0.515438676, 0.847043753, 1.1358);
            r6.xyzw = float4(1.38020003, 1.51970005, 1.59850001, 1.64670002);
            r7.xyzw = float4(1.67460918, 1.68787336, 0.808913231, 1.19108677);
            r8.xyzw = float4(1.56830001, 1.9483, 2.30830002, 2.63840008);
            r2.zw = float2(0.0199999996, 4.80000019);
            r9.xyzw = float4(48, 2.85949993, 2.98726082, 3.01273918);
            r10.xy = float2(-6.5, 6.5);
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
        r11.xy = float2(0.30103001, 0.30103001) * r5.xy;
        r8.xyzw = float4(3.32192802, 3.32192802, 3.32192802, 3.32192802) * r8.xyzw;
        r8.xyzw = exp2(r8.xyzw);
        r5.x = r8.x + -r5.z;
        r5.x = r2.x * r5.x + r5.z;
        r5.x = log2(r5.x);
        r11.z = 0.30103001 * r5.x;
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
        r6.xyz = float3(3.32192802, 3.32192802, 3.32192802) * r9.yzw;
        r6.xyz = exp2(r6.xyz);
        r6.x = r6.x + -r6.w;
        r6.x = r2.x * r6.x + r6.w;
        r6.x = log2(r6.x);
        r8.y = 0.30103001 * r6.x;
        r4.xyzw = float4(0.30103001, 0.30103001, 0.30103001, 0.30103001) * r4.wzyx;
        r6.xy = r6.yz + -r7.zw;
        r6.xy = r2.xx * r6.xy + r7.zw;
        r6.xy = log2(r6.xy);
        r6.z = 19.5517921 + -r5.w;
        r5.w = r2.x * r6.z + r5.w;
        r5.w = log2(r5.w);
        r7.w = 0.30103001 * r5.w;
        r6.xw = float2(0.30103001, 0.30103001) * r6.xy;
        r5.w = -12 + -r10.x;
        r5.w = r2.y * r5.w + r10.x;
        r5.w = exp2(r5.w);
        r5.xyzw = float4(0.30103001, 0.30103001, 0.30103001, 0.180000007) * r5.xyzw;
        r5.w = log2(r5.w);
        r9.y = cmp(-17.4739304 >= r5.w);
        if (r9.y != 0) {
          r5.w = -4;
        } else {
          r5.w = r5.w * 0.30103001 + 5.26017714;
          r9.y = 0.664385676 * r5.w;
          r9.z = (int)r9.y;
          r9.y = trunc(r9.y);
          r12.y = r5.w * 0.664385676 + -r9.y;
          r5.w = (int)r9.z + 2;
          r12.x = r12.y * r12.y;
          r13.x = 0.5;
          r13.y = icb[r9.z + 1].x;
          r13.z = icb[r5.w + 0].x;
          r14.x = dot(float3(-4, -1, 0.5), r13.xyz);
          r15.x = -1;
          r15.y = icb[r9.z + 1].x;
          r14.y = dot(float2(-4, 1), r15.xy);
          r14.z = dot(float2(-4, 0.5), r13.xy);
          r12.z = 1;
          r5.w = dot(r12.xyz, r14.xyz);
        }
        r5.w = 3.32192802 * r5.w;
        r12.x = exp2(r5.w);
        r5.w = 0.00499999989 + -r2.z;
        r12.y = r2.x * r5.w + r2.z;
        r2.z = 10 + -r2.w;
        r12.z = r2.x * r2.z + r2.w;
        r1.w = -r10.y + r1.w;
        r1.w = r2.y * r1.w + r10.y;
        r1.w = exp2(r1.w);
        r1.w = 0.180000007 * r1.w;
        r1.w = log2(r1.w);
        r1.w = r1.w * 0.30103001 + 0.744727433;
        r2.y = 0.553654671 * r1.w;
        r2.z = (int)r2.y;
        r2.y = trunc(r2.y);
        r10.y = r1.w * 0.553654671 + -r2.y;
        r10.x = r10.y * r10.y;
        r13.x = icb[r2.z + 0].y;
        r13.y = icb[r2.z + 1].y;
        r13.z = icb[r2.z + 2].y;
        r14.x = dot(r13.xzy, float3(0.5, 0.5, -1));
        r14.y = dot(r13.xy, float2(-1, 1));
        r14.z = dot(r13.xy, float2(0.5, 0.5));
        r10.z = 1;
        r1.w = dot(r10.xyz, r14.xyz);
        r1.w = 3.32192802 * r1.w;
        r12.w = exp2(r1.w);
        r1.z = -r9.x + r1.z;
        r1.z = r2.x * r1.z + r9.x;
        r11.w = r5.x;
        r8.zw = r5.zy;
        r8.x = r6.x;
      }
    }
    r2.xyz = log2(r12.xwy);
    r5.xyz = float3(0.30103001, 0.30103001, 0.30103001) * r2.xyz;
    r1.w = -r2.x * 0.30103001 + 0.681241155;
    r1.w = 0.142857149 * r1.w;
    r2.x = r2.y * 0.30103001 + -0.681241155;
    r2.yzw = r3.xyz + r3.yzw;
    r2.xyzw = float4(0.142857149, 0.5, 0.5, 0.5) * r2.xyzw;
    r5.w = r4.w + r3.w;
    r5.w = 0.5 * r5.w;
    r9.xyz = r4.wzy + r4.zyx;
    r10.xyz = r11.xyz + r11.yzw;
    r10.xyz = float3(0.5, 0.5, 0.5) * r10.xyz;
    r9.w = r11.w + r8.w;
    r9.xyzw = float4(0.5, 0.5, 0.5, 0.5) * r9.xyzw;
    r12.xyw = r8.wzy + r8.zyx;
    r12.xyw = float3(0.5, 0.5, 0.5) * r12.xyw;
    r0.w = log2(r0.w);
    r10.w = 0.30103001 * r0.w;
    r13.x = cmp(r5.z >= r10.w);
    if (r13.x != 0) {
      r13.x = r5.x;
    } else {
      r13.x = cmp(r5.z < r10.w);
      r13.y = log2(r12.z);
      r13.y = 0.30103001 * r13.y;
      r13.z = cmp(r13.y >= r10.w);
      r13.x = r13.z ? r13.x : 0;
      if (r13.x != 0) {
        r13.x = cmp(r2.y < r10.w);
        r13.z = cmp(r2.z >= r10.w);
        r13.x = r13.z ? r13.x : 0;
        if (r13.x != 0) {
          r14.xyz = r3.xyz;
          r14.w = 0;
        } else {
          r13.xz = cmp(r2.zw < r10.ww);
          r13.w = cmp(r2.w >= r10.w);
          r13.x = r13.w ? r13.x : 0;
          r13.w = cmp(r5.w >= r10.w);
          r13.z = r13.w ? r13.z : 0;
          r13.w = cmp(r5.w < r10.w);
          r14.xyz = cmp(r9.xyz >= r10.www);
          r13.w = r13.w ? r14.x : 0;
          r14.xw = cmp(r9.xy < r10.ww);
          r14.xy = r14.yz ? r14.xw : 0;
          r15.x = 5;
          r15.yzw = r4.zyx;
          r7.x = 6;
          r7.yz = r15.zw;
          r15.xyzw = r14.yyyy ? r15.xyzw : r7.xyzw;
          r16.x = 4;
          r16.yzw = r4.yzw;
          r14.xyzw = r14.xxxx ? r16.xwzy : r15.xyzw;
          r16.x = 3;
          r16.y = r3.w;
          r14.xyzw = r13.wwww ? r16.xywz : r14.xyzw;
          r16.x = 2;
          r16.yz = r3.zw;
          r14.xyzw = r13.zzzz ? r16.xyzw : r14.xyzw;
          r15.x = 1;
          r15.yzw = r3.yzw;
          r14.xyzw = r13.xxxx ? r15.yzwx : r14.yzwx;
        }
        r13.x = dot(r14.xzy, float3(0.5, 0.5, -1));
        r13.z = dot(r14.xy, float2(-1, 1));
        r13.w = dot(r14.xy, float2(0.5, 0.5));
        r13.w = -r0.w * 0.30103001 + r13.w;
        r13.x = r13.w * r13.x;
        r13.x = 4 * r13.x;
        r13.x = r13.z * r13.z + -r13.x;
        r13.x = sqrt(r13.x);
        r13.w = r13.w + r13.w;
        r13.x = -r13.x + -r13.z;
        r13.x = r13.w / r13.x;
        r13.z = (uint)r14.w;
        r13.x = r13.x + r13.z;
        r13.x = r13.x * r1.w + r5.x;
      } else {
        r13.y = cmp(r13.y < r10.w);
        r13.z = log2(r1.z);
        r13.z = 0.30103001 * r13.z;
        r13.z = cmp(r10.w < r13.z);
        r13.y = r13.z ? r13.y : 0;
        if (r13.y != 0) {
          r13.y = cmp(r10.x < r10.w);
          r13.z = cmp(r10.y >= r10.w);
          r13.y = r13.z ? r13.y : 0;
          if (r13.y != 0) {
            r14.xyz = r11.xyz;
            r14.w = 0;
          } else {
            r13.yz = cmp(r10.yz < r10.ww);
            r13.w = cmp(r10.z >= r10.w);
            r13.y = r13.w ? r13.y : 0;
            r13.w = cmp(r9.w >= r10.w);
            r13.z = r13.w ? r13.z : 0;
            r13.w = cmp(r9.w < r10.w);
            r14.xyz = cmp(r12.xyw >= r10.www);
            r13.w = r13.w ? r14.x : 0;
            r14.xw = cmp(r12.xy < r10.ww);
            r14.xy = r14.yz ? r14.xw : 0;
            r15.x = 5;
            r15.yzw = r8.zyx;
            r6.x = 6;
            r6.yz = r15.zw;
            r15.xyzw = r14.yyyy ? r15.xyzw : r6.xyzw;
            r16.x = 4;
            r16.yzw = r8.yzw;
            r14.xyzw = r14.xxxx ? r16.xwzy : r15.xyzw;
            r16.x = 3;
            r16.y = r11.w;
            r14.xyzw = r13.wwww ? r16.xywz : r14.xyzw;
            r16.x = 2;
            r16.yz = r11.zw;
            r14.xyzw = r13.zzzz ? r16.xyzw : r14.xyzw;
            r15.x = 1;
            r15.yzw = r11.yzw;
            r14.xyzw = r13.yyyy ? r15.yzwx : r14.yzwx;
          }
          r10.w = dot(r14.xzy, float3(0.5, 0.5, -1));
          r13.y = dot(r14.xy, float2(-1, 1));
          r13.z = dot(r14.xy, float2(0.5, 0.5));
          r0.w = -r0.w * 0.30103001 + r13.z;
          r10.w = r0.w * r10.w;
          r10.w = 4 * r10.w;
          r10.w = r13.y * r13.y + -r10.w;
          r10.w = sqrt(r10.w);
          r0.w = r0.w + r0.w;
          r10.w = -r10.w + -r13.y;
          r0.w = r0.w / r10.w;
          r10.w = (uint)r14.w;
          r0.w = r10.w + r0.w;
          r13.x = r0.w * r2.x + 0.681241155;
        } else {
          r13.x = r5.y;
        }
      }
    }
    r0.w = 3.32192802 * r13.x;
    r13.x = exp2(r0.w);
    r0.w = log2(r1.y);
    r1.y = 0.30103001 * r0.w;
    r10.w = cmp(r5.z >= r1.y);
    if (r10.w != 0) {
      r10.w = r5.x;
    } else {
      r10.w = cmp(r5.z < r1.y);
      r13.w = log2(r12.z);
      r13.w = 0.30103001 * r13.w;
      r14.x = cmp(r13.w >= r1.y);
      r10.w = r10.w ? r14.x : 0;
      if (r10.w != 0) {
        r10.w = cmp(r2.y < r1.y);
        r14.x = cmp(r2.z >= r1.y);
        r10.w = r10.w ? r14.x : 0;
        if (r10.w != 0) {
          r14.xyz = r3.xyz;
          r14.w = 0;
        } else {
          r14.xy = cmp(r2.zw < r1.yy);
          r10.w = cmp(r2.w >= r1.y);
          r10.w = r10.w ? r14.x : 0;
          r14.x = cmp(r5.w >= r1.y);
          r14.x = r14.x ? r14.y : 0;
          r14.y = cmp(r5.w < r1.y);
          r15.xyz = cmp(r9.xyz >= r1.yyy);
          r14.zw = cmp(r9.xy < r1.yy);
          r14.yzw = r14.yzw ? r15.xyz : 0;
          r15.x = 5;
          r15.yzw = r4.zyx;
          r7.x = 6;
          r7.yz = r15.zw;
          r15.xyzw = r14.wwww ? r15.xyzw : r7.xyzw;
          r16.x = 4;
          r16.yzw = r4.yzw;
          r15.xyzw = r14.zzzz ? r16.xwzy : r15.xyzw;
          r16.x = 3;
          r16.y = r3.w;
          r15.xyzw = r14.yyyy ? r16.xywz : r15.xyzw;
          r16.x = 2;
          r16.yz = r3.zw;
          r14.xyzw = r14.xxxx ? r16.xyzw : r15.xyzw;
          r15.x = 1;
          r15.yzw = r3.yzw;
          r14.xyzw = r10.wwww ? r15.yzwx : r14.yzwx;
        }
        r10.w = dot(r14.xzy, float3(0.5, 0.5, -1));
        r14.z = dot(r14.xy, float2(-1, 1));
        r14.x = dot(r14.xy, float2(0.5, 0.5));
        r14.x = -r0.w * 0.30103001 + r14.x;
        r10.w = r14.x * r10.w;
        r10.w = 4 * r10.w;
        r10.w = r14.z * r14.z + -r10.w;
        r10.w = sqrt(r10.w);
        r14.x = r14.x + r14.x;
        r10.w = -r10.w + -r14.z;
        r10.w = r14.x / r10.w;
        r14.x = (uint)r14.w;
        r10.w = r14.x + r10.w;
        r10.w = r10.w * r1.w + r5.x;
      } else {
        r13.w = cmp(r13.w < r1.y);
        r14.x = log2(r1.z);
        r14.x = 0.30103001 * r14.x;
        r14.x = cmp(r1.y < r14.x);
        r13.w = r13.w ? r14.x : 0;
        if (r13.w != 0) {
          r13.w = cmp(r10.x < r1.y);
          r14.x = cmp(r10.y >= r1.y);
          r13.w = r13.w ? r14.x : 0;
          if (r13.w != 0) {
            r14.xyz = r11.xyz;
            r14.w = 0;
          } else {
            r14.xy = cmp(r10.yz < r1.yy);
            r13.w = cmp(r10.z >= r1.y);
            r13.w = r13.w ? r14.x : 0;
            r14.x = cmp(r9.w >= r1.y);
            r14.x = r14.x ? r14.y : 0;
            r14.y = cmp(r9.w < r1.y);
            r15.xyz = cmp(r12.xyw >= r1.yyy);
            r14.zw = cmp(r12.xy < r1.yy);
            r14.yzw = r14.yzw ? r15.xyz : 0;
            r15.x = 5;
            r15.yzw = r8.zyx;
            r6.x = 6;
            r6.yz = r15.zw;
            r15.xyzw = r14.wwww ? r15.xyzw : r6.xyzw;
            r16.x = 4;
            r16.yzw = r8.yzw;
            r15.xyzw = r14.zzzz ? r16.xwzy : r15.xyzw;
            r16.x = 3;
            r16.y = r11.w;
            r15.xyzw = r14.yyyy ? r16.xywz : r15.xyzw;
            r16.x = 2;
            r16.yz = r11.zw;
            r14.xyzw = r14.xxxx ? r16.xyzw : r15.xyzw;
            r15.x = 1;
            r15.yzw = r11.yzw;
            r14.xyzw = r13.wwww ? r15.yzwx : r14.yzwx;
          }
          r1.y = dot(r14.xzy, float3(0.5, 0.5, -1));
          r13.w = dot(r14.xy, float2(-1, 1));
          r14.x = dot(r14.xy, float2(0.5, 0.5));
          r0.w = -r0.w * 0.30103001 + r14.x;
          r1.y = r0.w * r1.y;
          r1.y = 4 * r1.y;
          r1.y = r13.w * r13.w + -r1.y;
          r1.y = sqrt(r1.y);
          r0.w = r0.w + r0.w;
          r1.y = -r1.y + -r13.w;
          r0.w = r0.w / r1.y;
          r1.y = (uint)r14.w;
          r0.w = r1.y + r0.w;
          r10.w = r0.w * r2.x + 0.681241155;
        } else {
          r10.w = r5.y;
        }
      }
    }
    r0.w = 3.32192802 * r10.w;
    r13.y = exp2(r0.w);
    r0.w = log2(r1.x);
    r1.x = 0.30103001 * r0.w;
    r1.y = cmp(r5.z >= r1.x);
    if (r1.y == 0) {
      r1.y = cmp(r5.z < r1.x);
      r5.z = log2(r12.z);
      r5.z = 0.30103001 * r5.z;
      r10.w = cmp(r5.z >= r1.x);
      r1.y = r1.y ? r10.w : 0;
      if (r1.y != 0) {
        r1.y = cmp(r2.y < r1.x);
        r2.y = cmp(r2.z >= r1.x);
        r1.y = r1.y ? r2.y : 0;
        if (r1.y != 0) {
          r3.w = 0;
        } else {
          r2.yz = cmp(r2.zw < r1.xx);
          r1.y = cmp(r2.w >= r1.x);
          r1.y = r1.y ? r2.y : 0;
          r2.y = cmp(r5.w >= r1.x);
          r2.y = r2.y ? r2.z : 0;
          r2.z = cmp(r5.w < r1.x);
          r14.xyz = cmp(r9.xyz >= r1.xxx);
          r2.z = r2.z ? r14.x : 0;
          r9.xy = cmp(r9.xy < r1.xx);
          r9.xy = r14.yz ? r9.xy : 0;
          r14.x = 5;
          r14.yzw = r4.zyx;
          r7.x = 6;
          r7.yz = r14.zw;
          r7.xyzw = r9.yyyy ? r14.xyzw : r7.xyzw;
          r4.x = 4;
          r7.xyzw = r9.xxxx ? r4.xwzy : r7.xyzw;
          r4.x = 3;
          r4.y = r3.w;
          r7.xyzw = r2.zzzz ? r4.xywz : r7.xyzw;
          r4.x = 2;
          r4.yz = r3.zw;
          r4.xyzw = r2.yyyy ? r4.xyzw : r7.xyzw;
          r3.x = 1;
          r3.xyzw = r1.yyyy ? r3.yzwx : r4.yzwx;
        }
        r1.y = dot(r3.xzy, float3(0.5, 0.5, -1));
        r2.y = dot(r3.xy, float2(-1, 1));
        r2.z = dot(r3.xy, float2(0.5, 0.5));
        r2.z = -r0.w * 0.30103001 + r2.z;
        r1.y = r2.z * r1.y;
        r1.y = 4 * r1.y;
        r1.y = r2.y * r2.y + -r1.y;
        r1.y = sqrt(r1.y);
        r2.z = r2.z + r2.z;
        r1.y = -r1.y + -r2.y;
        r1.y = r2.z / r1.y;
        r2.y = (uint)r3.w;
        r1.y = r2.y + r1.y;
        r5.x = r1.y * r1.w + r5.x;
      } else {
        r1.y = cmp(r5.z < r1.x);
        r1.z = log2(r1.z);
        r1.z = 0.30103001 * r1.z;
        r1.z = cmp(r1.x < r1.z);
        r1.y = r1.z ? r1.y : 0;
        if (r1.y != 0) {
          r1.y = cmp(r10.x < r1.x);
          r1.z = cmp(r10.y >= r1.x);
          r1.y = r1.z ? r1.y : 0;
          if (r1.y != 0) {
            r11.w = 0;
          } else {
            r1.yz = cmp(r10.yz < r1.xx);
            r1.w = cmp(r10.z >= r1.x);
            r1.y = r1.w ? r1.y : 0;
            r1.w = cmp(r9.w >= r1.x);
            r1.z = r1.w ? r1.z : 0;
            r1.w = cmp(r9.w < r1.x);
            r2.yzw = cmp(r12.xyw >= r1.xxx);
            r1.w = r1.w ? r2.y : 0;
            r3.xy = cmp(r12.xy < r1.xx);
            r2.yz = r2.zw ? r3.xy : 0;
            r3.x = 5;
            r3.yzw = r8.zyx;
            r6.x = 6;
            r6.yz = r3.zw;
            r3.xyzw = r2.zzzz ? r3.xyzw : r6.xyzw;
            r8.x = 4;
            r3.xyzw = r2.yyyy ? r8.xwzy : r3.xyzw;
            r8.x = 3;
            r8.y = r11.w;
            r3.xyzw = r1.wwww ? r8.xywz : r3.xyzw;
            r8.x = 2;
            r8.yz = r11.zw;
            r3.xyzw = r1.zzzz ? r8.xyzw : r3.xyzw;
            r11.x = 1;
            r11.xyzw = r1.yyyy ? r11.yzwx : r3.yzwx;
          }
          r1.x = dot(r11.xzy, float3(0.5, 0.5, -1));
          r1.y = dot(r11.xy, float2(-1, 1));
          r1.z = dot(r11.xy, float2(0.5, 0.5));
          r0.w = -r0.w * 0.30103001 + r1.z;
          r1.x = r0.w * r1.x;
          r1.x = 4 * r1.x;
          r1.x = r1.y * r1.y + -r1.x;
          r1.x = sqrt(r1.x);
          r0.w = r0.w + r0.w;
          r1.x = -r1.x + -r1.y;
          r0.w = r0.w / r1.x;
          r1.x = (uint)r11.w;
          r0.w = r1.x + r0.w;
          r5.x = r0.w * r2.x + 0.681241155;
        } else {
          r5.x = r5.y;
        }
      }
    }
    r0.w = 3.32192802 * r5.x;
    r13.z = exp2(r0.w);
    r1.x = dot(r13.xyz, float3(0.695452213, 0.140678659, 0.163869068));
    r1.y = dot(r13.xyz, float3(0.0447945744, 0.859670997, 0.0955343246));
    r1.z = dot(r13.xyz, float3(-0.00552586792, 0.00402521156, 1.00150073));
  } else {
#if 0
    r2.xyz = cmp(r0.xyz >= float3(1.21785712, 1.21785712, 1.21785712));
    r3.xyz = r0.xyz * float3(0.0322580636, 0.0322580636, 0.0322580636) + float3(0.0549999997, 0.0549999997, 0.0549999997);
    r3.xyz = float3(0.947867334, 0.947867334, 0.947867334) * r3.xyz;
    r3.xyz = log2(r3.xyz);
    r3.xyz = float3(2.4000001, 2.4000001, 2.4000001) * r3.xyz;
    r3.xyz = exp2(r3.xyz);
    r0.xyz = float3(0.00249613263, 0.00249613263, 0.00249613263) * r0.xyz;
    r0.xyz = r2.xyz ? r3.xyz : r0.xyz;
#else
    r0.rgb = renodx::color::gamma::DecodeSafe(r0.rgb, 2.2f);
#endif
    r2.x = dot(r0.xyz, float3(0.412390828, 0.357584387, 0.180480748));
    r2.y = dot(r0.xyz, float3(0.212639034, 0.715168774, 0.0721922964));
    r2.z = dot(r0.xyz, float3(0.0193308201, 0.119194753, 0.95053196));
    r0.x = dot(r2.xyz, float3(1.01303494, 0.0061052707, -0.0149709256));
    r0.y = dot(r2.xyz, float3(0.00769816991, 0.998163581, -0.00503202248));
    r0.z = dot(r2.xyz, float3(-0.00284131337, 0.00468515232, 0.924506247));
    r2.x = dot(r0.xyz, float3(1.64102316, -0.324803293, -0.236424685));
    r2.y = dot(r0.xyz, float3(-0.66366303, 1.61533201, 0.0167563651));
    r2.z = dot(r0.xyz, float3(0.01172191, -0.00828443933, 0.988394737));
    r0.x = dot(r2.xyz, float3(1.05477846, -0.0507373177, -0.00404114602));
    r0.y = dot(r2.xyz, float3(-0.0204903334, 1.02453136, -0.00404114602));
    r0.z = dot(r2.xyz, float3(-0.0204903334, -0.0507373214, 1.07122755));
    r0.w = dot(r0.xyz, float3(0.662454247, 0.134004191, 0.156187713));
    r1.w = dot(r0.xyz, float3(0.272228748, 0.674081624, 0.0536895208));
    r0.x = dot(r0.xyz, float3(-0.00557466131, 0.00406072894, 1.01033914));
    r0.y = r1.w + r0.w;
    r0.x = r0.y + r0.x;
    r0.y = cmp(r0.x == 0.000000);
    r0.x = r0.y ? 1.00000001e-10 : r0.x;
    r0.y = r0.w / r0.x;
    r0.x = r1.w / r0.x;
    r0.z = max(0, r1.w);
    r0.z = min(65520, r0.z);
    r0.z = log2(r0.z);
    r0.z = 1.0192641 * r0.z;
    r2.y = exp2(r0.z);
    r0.z = r2.y * r0.y;
    r0.w = max(1.00000001e-10, r0.x);
    r0.y = 1 + -r0.y;
    r0.x = r0.y + -r0.x;
    r0.x = r0.x * r2.y;
    r2.xz = r0.zx / r0.ww;
    r0.x = dot(r2.xyz, float3(1.64102316, -0.324803293, -0.236424685));
    r0.y = dot(r2.xyz, float3(-0.66366303, 1.61533201, 0.0167563651));
    r0.z = dot(r2.xyz, float3(0.01172191, -0.00828443933, 0.988394737));
    r0.x = r0.x * 47.9799995 + 0.0199999996;
    r0.y = r0.y * 47.9799995 + 0.0199999996;
    r0.z = r0.z * 47.9799995 + 0.0199999996;
    r0.x = log2(r0.x);
    r0.w = cmp(-5.64385605 >= r0.x);
    if (r0.w != 0) {
      r0.w = -2.54062366;
    } else {
      r0.w = cmp(-5.64385605 < r0.x);
      r1.w = cmp(2.26303458 >= r0.x);
      r0.w = r0.w ? r1.w : 0;
      if (r0.w != 0) {
        r0.w = cmp(-5.27666664 >= r0.x);
        if (r0.w != 0) {
          r2.xyzw = float4(-1.69896996, -1.69896996, -1.47790003, 0);
        } else {
          r2.xyzw = cmp(float4(-5.27666664, -4.49622965, -3.47789264, -2.18051338) < r0.xxxx);
          r3.xyzw = cmp(float4(-4.49622965, -3.47789264, -2.18051338, -0.735508144) >= r0.xxxx);
          r2.xyzw = r2.xyzw ? r3.xyzw : 0;
          r0.w = cmp(-0.735508144 < r0.x);
          r1.w = cmp(0.757878006 >= r0.x);
          r0.w = r0.w ? r1.w : 0;
          r3.xyzw = r0.wwww ? float4(5, -0.448000014, 0.00517999986, 0.451108009) : float4(6, 0.00517999986, 0.451108009, 0.911373973);
          r3.xyzw = r2.wwww ? float4(4, -0.864799976, -0.448000014, 0.00517999986) : r3.xyzw;
          r3.xyzw = r2.zzzz ? float4(3, -1.22909999, -0.864799976, -0.448000014) : r3.xyzw;
          r3.xyzw = r2.yyyy ? float4(2, -1.47790003, -1.22909999, -0.864799976) : r3.xyzw;
          r2.xyzw = r2.xxxx ? float4(-1.69896996, -1.47790003, -1.22909999, 1.40129846e-45) : r3.yzwx;
        }
        r0.w = dot(r2.xzy, float3(0.5, 0.5, -1));
        r1.w = dot(r2.xy, float2(-1, 1));
        r2.x = dot(r2.xy, float2(0.5, 0.5));
        r2.x = -r0.x * 0.30103001 + r2.x;
        r0.w = r2.x * r0.w;
        r0.w = 4 * r0.w;
        r0.w = r1.w * r1.w + -r0.w;
        r0.w = sqrt(r0.w);
        r2.x = r2.x + r2.x;
        r0.w = -r0.w + -r1.w;
        r0.w = r2.x / r0.w;
        r1.w = (uint)r2.w;
        r0.w = r1.w + r0.w;
        r0.w = r0.w * 0.460266382 + -2.54062366;
      } else {
        r1.w = cmp(2.26303458 < r0.x);
        r2.x = cmp(r0.x < 5.58496237);
        r1.w = r1.w ? r2.x : 0;
        if (r1.w != 0) {
          r1.w = cmp(2.26303434 < r0.x);
          r2.x = cmp(3.29343224 >= r0.x);
          r1.w = r1.w ? r2.x : 0;
          if (r1.w != 0) {
            r2.xyzw = float4(0.515438676, 0.847043753, 1.1358, 0);
          } else {
            r2.xyzw = cmp(float4(3.29343224, 4.1789856, 4.81662941, 5.17921829) < r0.xxxx);
            r3.xyzw = cmp(float4(4.1789856, 4.81662941, 5.17921829, 5.39016056) >= r0.xxxx);
            r2.xyzw = r2.xyzw ? r3.xyzw : 0;
            r1.w = cmp(5.39016056 < r0.x);
            r3.x = cmp(5.51657486 >= r0.x);
            r1.w = r1.w ? r3.x : 0;
            r3.xyzw = r1.wwww ? float4(5, 1.59850001, 1.64670002, 1.67460895) : float4(6, 1.64670002, 1.67460895, 1.68787301);
            r3.xyzw = r2.wwww ? float4(4, 1.51970005, 1.59850001, 1.64670002) : r3.xyzw;
            r3.xyzw = r2.zzzz ? float4(3, 1.38020003, 1.51970005, 1.59850001) : r3.xyzw;
            r3.xyzw = r2.yyyy ? float4(2, 1.1358, 1.38020003, 1.51970005) : r3.xyzw;
            r2.xyzw = r2.xxxx ? float4(0.847043753, 1.1358, 1.38020003, 1.40129846e-45) : r3.yzwx;
          }
          r1.w = dot(r2.xzy, float3(0.5, 0.5, -1));
          r2.z = dot(r2.xy, float2(-1, 1));
          r2.x = dot(r2.xy, float2(0.5, 0.5));
          r0.x = -r0.x * 0.30103001 + r2.x;
          r1.w = r0.x * r1.w;
          r1.w = 4 * r1.w;
          r1.w = r2.z * r2.z + -r1.w;
          r1.w = sqrt(r1.w);
          r0.x = r0.x + r0.x;
          r1.w = -r1.w + -r2.z;
          r0.x = r0.x / r1.w;
          r1.w = (uint)r2.w;
          r0.x = r1.w + r0.x;
          r0.w = r0.x * 0.331605107 + 0.681241155;
        } else {
          r0.w = 3.00247669;
        }
      }
    }
    r0.x = 3.32192802 * r0.w;
    r2.x = exp2(r0.x);
    r0.x = log2(r0.y);
    r0.y = cmp(-5.64385605 >= r0.x);
    if (r0.y != 0) {
      r0.y = -2.54062366;
    } else {
      r0.y = cmp(-5.64385605 < r0.x);
      r0.w = cmp(2.26303458 >= r0.x);
      r0.y = r0.w ? r0.y : 0;
      if (r0.y != 0) {
        r0.y = cmp(-5.27666664 >= r0.x);
        if (r0.y != 0) {
          r3.xyzw = float4(-1.69896996, -1.69896996, -1.47790003, 0);
        } else {
          r3.xyzw = cmp(float4(-5.27666664, -4.49622965, -3.47789264, -2.18051338) < r0.xxxx);
          r4.xyzw = cmp(float4(-4.49622965, -3.47789264, -2.18051338, -0.735508144) >= r0.xxxx);
          r3.xyzw = r3.xyzw ? r4.xyzw : 0;
          r0.y = cmp(-0.735508144 < r0.x);
          r0.w = cmp(0.757878006 >= r0.x);
          r0.y = r0.w ? r0.y : 0;
          r4.xyzw = r0.yyyy ? float4(5, -0.448000014, 0.00517999986, 0.451108009) : float4(6, 0.00517999986, 0.451108009, 0.911373973);
          r4.xyzw = r3.wwww ? float4(4, -0.864799976, -0.448000014, 0.00517999986) : r4.xyzw;
          r4.xyzw = r3.zzzz ? float4(3, -1.22909999, -0.864799976, -0.448000014) : r4.xyzw;
          r4.xyzw = r3.yyyy ? float4(2, -1.47790003, -1.22909999, -0.864799976) : r4.xyzw;
          r3.xyzw = r3.xxxx ? float4(-1.69896996, -1.47790003, -1.22909999, 1.40129846e-45) : r4.yzwx;
        }
        r0.y = dot(r3.xzy, float3(0.5, 0.5, -1));
        r0.w = dot(r3.xy, float2(-1, 1));
        r1.w = dot(r3.xy, float2(0.5, 0.5));
        r1.w = -r0.x * 0.30103001 + r1.w;
        r0.y = r1.w * r0.y;
        r0.y = 4 * r0.y;
        r0.y = r0.w * r0.w + -r0.y;
        r0.y = sqrt(r0.y);
        r1.w = r1.w + r1.w;
        r0.y = -r0.y + -r0.w;
        r0.y = r1.w / r0.y;
        r0.w = (uint)r3.w;
        r0.y = r0.y + r0.w;
        r0.y = r0.y * 0.460266382 + -2.54062366;
      } else {
        r0.w = cmp(2.26303458 < r0.x);
        r1.w = cmp(r0.x < 5.58496237);
        r0.w = r0.w ? r1.w : 0;
        if (r0.w != 0) {
          r0.w = cmp(2.26303434 < r0.x);
          r1.w = cmp(3.29343224 >= r0.x);
          r0.w = r0.w ? r1.w : 0;
          if (r0.w != 0) {
            r3.xyzw = float4(0.515438676, 0.847043753, 1.1358, 0);
          } else {
            r3.xyzw = cmp(float4(3.29343224, 4.1789856, 4.81662941, 5.17921829) < r0.xxxx);
            r4.xyzw = cmp(float4(4.1789856, 4.81662941, 5.17921829, 5.39016056) >= r0.xxxx);
            r3.xyzw = r3.xyzw ? r4.xyzw : 0;
            r0.w = cmp(5.39016056 < r0.x);
            r1.w = cmp(5.51657486 >= r0.x);
            r0.w = r0.w ? r1.w : 0;
            r4.xyzw = r0.wwww ? float4(5, 1.59850001, 1.64670002, 1.67460895) : float4(6, 1.64670002, 1.67460895, 1.68787301);
            r4.xyzw = r3.wwww ? float4(4, 1.51970005, 1.59850001, 1.64670002) : r4.xyzw;
            r4.xyzw = r3.zzzz ? float4(3, 1.38020003, 1.51970005, 1.59850001) : r4.xyzw;
            r4.xyzw = r3.yyyy ? float4(2, 1.1358, 1.38020003, 1.51970005) : r4.xyzw;
            r3.xyzw = r3.xxxx ? float4(0.847043753, 1.1358, 1.38020003, 1.40129846e-45) : r4.yzwx;
          }
          r0.w = dot(r3.xzy, float3(0.5, 0.5, -1));
          r1.w = dot(r3.xy, float2(-1, 1));
          r2.w = dot(r3.xy, float2(0.5, 0.5));
          r0.x = -r0.x * 0.30103001 + r2.w;
          r0.w = r0.x * r0.w;
          r0.w = 4 * r0.w;
          r0.w = r1.w * r1.w + -r0.w;
          r0.w = sqrt(r0.w);
          r0.x = r0.x + r0.x;
          r0.w = -r0.w + -r1.w;
          r0.x = r0.x / r0.w;
          r0.w = (uint)r3.w;
          r0.x = r0.x + r0.w;
          r0.y = r0.x * 0.331605107 + 0.681241155;
        } else {
          r0.y = 3.00247669;
        }
      }
    }
    r0.x = 3.32192802 * r0.y;
    r2.y = exp2(r0.x);
    r0.x = log2(r0.z);
    r0.y = cmp(-5.64385605 >= r0.x);
    if (r0.y != 0) {
      r0.y = -2.54062366;
    } else {
      r0.y = cmp(-5.64385605 < r0.x);
      r0.z = cmp(2.26303458 >= r0.x);
      r0.y = r0.z ? r0.y : 0;
      if (r0.y != 0) {
        r0.y = cmp(-5.27666664 >= r0.x);
        if (r0.y != 0) {
          r3.xyzw = float4(-1.69896996, -1.69896996, -1.47790003, 0);
        } else {
          r3.xyzw = cmp(float4(-5.27666664, -4.49622965, -3.47789264, -2.18051338) < r0.xxxx);
          r4.xyzw = cmp(float4(-4.49622965, -3.47789264, -2.18051338, -0.735508144) >= r0.xxxx);
          r3.xyzw = r3.xyzw ? r4.xyzw : 0;
          r0.y = cmp(-0.735508144 < r0.x);
          r0.z = cmp(0.757878006 >= r0.x);
          r0.y = r0.z ? r0.y : 0;
          r4.xyzw = r0.yyyy ? float4(5, -0.448000014, 0.00517999986, 0.451108009) : float4(6, 0.00517999986, 0.451108009, 0.911373973);
          r4.xyzw = r3.wwww ? float4(4, -0.864799976, -0.448000014, 0.00517999986) : r4.xyzw;
          r4.xyzw = r3.zzzz ? float4(3, -1.22909999, -0.864799976, -0.448000014) : r4.xyzw;
          r4.xyzw = r3.yyyy ? float4(2, -1.47790003, -1.22909999, -0.864799976) : r4.xyzw;
          r3.xyzw = r3.xxxx ? float4(-1.69896996, -1.47790003, -1.22909999, 1.40129846e-45) : r4.yzwx;
        }
        r0.y = dot(r3.xzy, float3(0.5, 0.5, -1));
        r0.z = dot(r3.xy, float2(-1, 1));
        r0.w = dot(r3.xy, float2(0.5, 0.5));
        r0.w = -r0.x * 0.30103001 + r0.w;
        r0.y = r0.w * r0.y;
        r0.y = 4 * r0.y;
        r0.y = r0.z * r0.z + -r0.y;
        r0.y = sqrt(r0.y);
        r0.w = r0.w + r0.w;
        r0.y = -r0.y + -r0.z;
        r0.y = r0.w / r0.y;
        r0.z = (uint)r3.w;
        r0.y = r0.y + r0.z;
        r0.y = r0.y * 0.460266382 + -2.54062366;
      } else {
        r0.z = cmp(2.26303458 < r0.x);
        r0.w = cmp(r0.x < 5.58496237);
        r0.z = r0.w ? r0.z : 0;
        if (r0.z != 0) {
          r0.z = cmp(2.26303434 < r0.x);
          r0.w = cmp(3.29343224 >= r0.x);
          r0.z = r0.w ? r0.z : 0;
          if (r0.z != 0) {
            r3.xyzw = float4(0.515438676, 0.847043753, 1.1358, 0);
          } else {
            r3.xyzw = cmp(float4(3.29343224, 4.1789856, 4.81662941, 5.17921829) < r0.xxxx);
            r4.xyzw = cmp(float4(4.1789856, 4.81662941, 5.17921829, 5.39016056) >= r0.xxxx);
            r3.xyzw = r3.xyzw ? r4.xyzw : 0;
            r0.z = cmp(5.39016056 < r0.x);
            r0.w = cmp(5.51657486 >= r0.x);
            r0.z = r0.w ? r0.z : 0;
            r4.xyzw = r0.zzzz ? float4(5, 1.59850001, 1.64670002, 1.67460895) : float4(6, 1.64670002, 1.67460895, 1.68787301);
            r4.xyzw = r3.wwww ? float4(4, 1.51970005, 1.59850001, 1.64670002) : r4.xyzw;
            r4.xyzw = r3.zzzz ? float4(3, 1.38020003, 1.51970005, 1.59850001) : r4.xyzw;
            r4.xyzw = r3.yyyy ? float4(2, 1.1358, 1.38020003, 1.51970005) : r4.xyzw;
            r3.xyzw = r3.xxxx ? float4(0.847043753, 1.1358, 1.38020003, 1.40129846e-45) : r4.yzwx;
          }
          r0.z = dot(r3.xzy, float3(0.5, 0.5, -1));
          r0.w = dot(r3.xy, float2(-1, 1));
          r1.w = dot(r3.xy, float2(0.5, 0.5));
          r0.x = -r0.x * 0.30103001 + r1.w;
          r0.z = r0.x * r0.z;
          r0.z = 4 * r0.z;
          r0.z = r0.w * r0.w + -r0.z;
          r0.z = sqrt(r0.z);
          r0.x = r0.x + r0.x;
          r0.z = -r0.z + -r0.w;
          r0.x = r0.x / r0.z;
          r0.z = (uint)r3.w;
          r0.x = r0.x + r0.z;
          r0.y = r0.x * 0.331605107 + 0.681241155;
        } else {
          r0.y = 3.00247669;
        }
      }
    }
    r0.x = 3.32192802 * r0.y;
    r2.z = exp2(r0.x);
    r1.x = dot(r2.xyz, float3(0.695452213, 0.140678659, 0.163869068));
    r1.y = dot(r2.xyz, float3(0.0447945744, 0.859670997, 0.0955343246));
    r1.z = dot(r2.xyz, float3(-0.00552586792, 0.00402521156, 1.00150073));
  }
  r0.x = dot(r1.xyz, float3(1.45143938, -0.236510724, -0.214928553));
  r0.y = dot(r1.xyz, float3(-0.0765537992, 1.17622995, -0.0996759459));
  r0.z = dot(r1.xyz, float3(0.00831612758, -0.00603244733, 0.997716188));
  r0.x = log2(r0.x);
  r0.w = cmp(-13.2877121 >= r0.x);
  if (r0.w != 0) {
    r0.w = -5.26017714;
  } else {
    r0.w = cmp(-13.2877121 < r0.x);
    r1.x = cmp(2.26303458 >= r0.x);
    r0.w = r0.w ? r1.x : 0;
    if (r0.w != 0) {
      r1.xy = cmp(float2(-11.8881445, -6.05027151) < r0.xx);
      r2.xyz = cmp(float3(-11.8881445, -6.05027151, 2.26303434) >= r0.xxx);
      r1.xy = r1.xy ? r2.yz : 0;
      r3.xyzw = r1.yyyy ? float4(0, -3.157377, -0.485249996, 1.84773195) : 0;
      r1.xyzw = r1.xxxx ? float4(1, -4, -3.157377, -0.485249996) : r3.xyzw;
      r1.xyzw = r2.xxxx ? float4(0, -4, -4, -3.15737653) : r1.xyzw;
      r0.w = dot(r1.ywz, float3(0.5, 0.5, -1));
      r1.w = dot(r1.yz, float2(-1, 1));
      r1.y = dot(r1.yz, float2(0.5, 0.5));
      r1.y = -r0.x * 0.30103001 + r1.y;
      r0.w = r1.y * r0.w;
      r0.w = 4 * r0.w;
      r0.w = r1.w * r1.w + -r0.w;
      r0.w = sqrt(r0.w);
      r1.y = r1.y + r1.y;
      r0.w = -r0.w + -r1.w;
      r0.w = r1.y / r0.w;
      r1.x = (uint)r1.x;
      r0.w = r1.x + r0.w;
      r0.w = r0.w * 1.50514984 + -5.26017714;
    } else {
      r1.xyzw = cmp(float4(2.26303458, 2.26303411, 9.54913998, 12.7364788) < r0.xxxx);
      r2.x = cmp(r0.x < 13.2877121);
      r1.x = r1.x ? r2.x : 0;
      r2.xyz = cmp(float3(9.54913998, 12.7364788, 13.2877121) >= r0.xxx);
      r1.yzw = r1.yzw ? r2.xyz : 0;
      r2.xyzw = r1.wwww ? float4(0, 3.66812396, 4, 4) : 0;
      r2.xyzw = r1.zzzz ? float4(1, 2.08103108, 3.66812396, 4) : r2.xyzw;
      r2.xyzw = r1.yyyy ? float4(0, -0.718548238, 2.08103061, 3.6681242) : r2.xyzw;
      r1.y = dot(r2.ywz, float3(0.5, 0.5, -1));
      r1.z = dot(r2.yz, float2(-1, 1));
      r1.w = dot(r2.yz, float2(0.5, 0.5));
      r0.x = -r0.x * 0.30103001 + r1.w;
      r1.y = r0.x * r1.y;
      r1.y = 4 * r1.y;
      r1.y = r1.z * r1.z + -r1.y;
      r1.y = sqrt(r1.y);
      r0.x = r0.x + r0.x;
      r1.y = -r1.y + -r1.z;
      r0.x = r0.x / r1.y;
      r1.y = (uint)r2.x;
      r0.x = r1.y + r0.x;
      r0.x = r0.x * 1.80618 + -0.744727433;
      r0.w = r1.x ? r0.x : 4.67381239;
    }
  }
  r0.x = 3.32192802 * r0.w;
  r1.x = exp2(r0.x);
  r0.x = log2(r0.y);
  r0.y = cmp(-13.2877121 >= r0.x);
  if (r0.y != 0) {
    r0.y = -5.26017714;
  } else {
    r0.y = cmp(-13.2877121 < r0.x);
    r0.w = cmp(2.26303458 >= r0.x);
    r0.y = r0.w ? r0.y : 0;
    if (r0.y != 0) {
      r0.yw = cmp(float2(-11.8881445, -6.05027151) < r0.xx);
      r2.xyz = cmp(float3(-11.8881445, -6.05027151, 2.26303434) >= r0.xxx);
      r0.yw = r0.yw ? r2.yz : 0;
      r3.xyzw = r0.wwww ? float4(0, -3.157377, -0.485249996, 1.84773195) : 0;
      r3.xyzw = r0.yyyy ? float4(1, -4, -3.157377, -0.485249996) : r3.xyzw;
      r2.xyzw = r2.xxxx ? float4(0, -4, -4, -3.15737653) : r3.xyzw;
      r0.y = dot(r2.ywz, float3(0.5, 0.5, -1));
      r0.w = dot(r2.yz, float2(-1, 1));
      r1.w = dot(r2.yz, float2(0.5, 0.5));
      r1.w = -r0.x * 0.30103001 + r1.w;
      r0.y = r1.w * r0.y;
      r0.y = 4 * r0.y;
      r0.y = r0.w * r0.w + -r0.y;
      r0.y = sqrt(r0.y);
      r1.w = r1.w + r1.w;
      r0.y = -r0.y + -r0.w;
      r0.y = r1.w / r0.y;
      r0.w = (uint)r2.x;
      r0.y = r0.y + r0.w;
      r0.y = r0.y * 1.50514984 + -5.26017714;
    } else {
      r2.xyzw = cmp(float4(2.26303458, 2.26303411, 9.54913998, 12.7364788) < r0.xxxx);
      r0.w = cmp(r0.x < 13.2877121);
      r0.w = r0.w ? r2.x : 0;
      r3.xyz = cmp(float3(9.54913998, 12.7364788, 13.2877121) >= r0.xxx);
      r2.xyz = r2.yzw ? r3.xyz : 0;
      r3.xyzw = r2.zzzz ? float4(0, 3.66812396, 4, 4) : 0;
      r3.xyzw = r2.yyyy ? float4(1, 2.08103108, 3.66812396, 4) : r3.xyzw;
      r2.xyzw = r2.xxxx ? float4(0, -0.718548238, 2.08103061, 3.6681242) : r3.xyzw;
      r1.w = dot(r2.ywz, float3(0.5, 0.5, -1));
      r2.w = dot(r2.yz, float2(-1, 1));
      r2.y = dot(r2.yz, float2(0.5, 0.5));
      r0.x = -r0.x * 0.30103001 + r2.y;
      r1.w = r0.x * r1.w;
      r1.w = 4 * r1.w;
      r1.w = r2.w * r2.w + -r1.w;
      r1.w = sqrt(r1.w);
      r0.x = r0.x + r0.x;
      r1.w = -r1.w + -r2.w;
      r0.x = r0.x / r1.w;
      r1.w = (uint)r2.x;
      r0.x = r1.w + r0.x;
      r0.x = r0.x * 1.80618 + -0.744727433;
      r0.y = r0.w ? r0.x : 4.67381239;
    }
  }
  r0.x = 3.32192802 * r0.y;
  r1.y = exp2(r0.x);
  r0.x = log2(r0.z);
  r0.y = cmp(-13.2877121 >= r0.x);
  if (r0.y != 0) {
    r0.y = -5.26017714;
  } else {
    r0.y = cmp(-13.2877121 < r0.x);
    r0.z = cmp(2.26303458 >= r0.x);
    r0.y = r0.z ? r0.y : 0;
    if (r0.y != 0) {
      r0.yz = cmp(float2(-11.8881445, -6.05027151) < r0.xx);
      r2.xyz = cmp(float3(-11.8881445, -6.05027151, 2.26303434) >= r0.xxx);
      r0.yz = r0.yz ? r2.yz : 0;
      r3.xyzw = r0.zzzz ? float4(0, -3.157377, -0.485249996, 1.84773195) : 0;
      r3.xyzw = r0.yyyy ? float4(1, -4, -3.157377, -0.485249996) : r3.xyzw;
      r2.xyzw = r2.xxxx ? float4(0, -4, -4, -3.15737653) : r3.xyzw;
      r0.y = dot(r2.ywz, float3(0.5, 0.5, -1));
      r0.z = dot(r2.yz, float2(-1, 1));
      r0.w = dot(r2.yz, float2(0.5, 0.5));
      r0.w = -r0.x * 0.30103001 + r0.w;
      r0.y = r0.w * r0.y;
      r0.y = 4 * r0.y;
      r0.y = r0.z * r0.z + -r0.y;
      r0.y = sqrt(r0.y);
      r0.w = r0.w + r0.w;
      r0.y = -r0.y + -r0.z;
      r0.y = r0.w / r0.y;
      r0.z = (uint)r2.x;
      r0.y = r0.y + r0.z;
      r0.y = r0.y * 1.50514984 + -5.26017714;
    } else {
      r2.xyzw = cmp(float4(2.26303458, 2.26303411, 9.54913998, 12.7364788) < r0.xxxx);
      r0.z = cmp(r0.x < 13.2877121);
      r0.z = r0.z ? r2.x : 0;
      r3.xyz = cmp(float3(9.54913998, 12.7364788, 13.2877121) >= r0.xxx);
      r2.xyz = r2.yzw ? r3.xyz : 0;
      r3.xyzw = r2.zzzz ? float4(0, 3.66812396, 4, 4) : 0;
      r3.xyzw = r2.yyyy ? float4(1, 2.08103108, 3.66812396, 4) : r3.xyzw;
      r2.xyzw = r2.xxxx ? float4(0, -0.718548238, 2.08103061, 3.6681242) : r3.xyzw;
      r0.w = dot(r2.ywz, float3(0.5, 0.5, -1));
      r1.w = dot(r2.yz, float2(-1, 1));
      r2.y = dot(r2.yz, float2(0.5, 0.5));
      r0.x = -r0.x * 0.30103001 + r2.y;
      r0.w = r0.x * r0.w;
      r0.w = 4 * r0.w;
      r0.w = r1.w * r1.w + -r0.w;
      r0.w = sqrt(r0.w);
      r0.x = r0.x + r0.x;
      r0.w = -r0.w + -r1.w;
      r0.x = r0.x / r0.w;
      r0.w = (uint)r2.x;
      r0.x = r0.x + r0.w;
      r0.x = r0.x * 1.80618 + -0.744727433;
      r0.y = r0.z ? r0.x : 4.67381239;
    }
  }
  r0.x = 3.32192802 * r0.y;
  r1.z = exp2(r0.x);
  r0.x = dot(r1.xyz, float3(1.03032374, -0.028086748, -0.00223706453));
  r0.y = dot(r1.xyz, float3(-0.0113428701, 1.01357996, -0.00223706476));
  r0.z = dot(r1.xyz, float3(-0.0113428719, -0.0280867498, 1.03942966));
  r0.x = min(65504, r0.x);
  r1.x = max(0, r0.x);
  r0.x = min(65504, r0.y);
  r1.y = max(0, r0.x);
  r0.x = min(65504, r0.z);
  r1.z = max(0, r0.x);
  r0.x = dot(r1.xyz, float3(0.695452213, 0.140678659, 0.163869068));
  r2.y = dot(r1.xyz, float3(0.0447945744, 0.859670997, 0.0955343246));
  r0.y = dot(r1.xyz, float3(-0.00552586792, 0.00402521156, 1.00150073));
  r0.y = min(65504, r0.y);
  r2.z = max(0, r0.y);
  r0.y = cmp(r0.x == r2.y);
  r0.z = cmp(r2.z == r2.y);
  r0.y = r0.z ? r0.y : 0;
  r0.zw = r2.yz + -r2.zy;
  r0.z = 1.73205078 * r0.z;
  r1.x = r0.x * 2 + -r2.y;
  r1.x = r1.x + -r2.z;
  r1.y = min(abs(r1.x), abs(r0.z));
  r1.z = max(abs(r1.x), abs(r0.z));
  r1.z = 1 / r1.z;
  r1.y = r1.y * r1.z;
  r1.z = r1.y * r1.y;
  r1.w = r1.z * 0.0208350997 + -0.0851330012;
  r1.w = r1.z * r1.w + 0.180141002;
  r1.w = r1.z * r1.w + -0.330299497;
  r1.z = r1.z * r1.w + 0.999866009;
  r1.w = r1.y * r1.z;
  r2.w = cmp(abs(r1.x) < abs(r0.z));
  r1.w = r1.w * -2 + 1.57079637;
  r1.w = r2.w ? r1.w : 0;
  r1.y = r1.y * r1.z + r1.w;
  r1.z = cmp(r1.x < -r1.x);
  r1.z = r1.z ? -3.141593 : 0;
  r1.y = r1.y + r1.z;
  r1.z = min(r1.x, r0.z);
  r0.z = max(r1.x, r0.z);
  r1.x = cmp(r1.z < -r1.z);
  r0.z = cmp(r0.z >= -r0.z);
  r0.z = r0.z ? r1.x : 0;
  r0.z = r0.z ? -r1.y : r1.y;
  r0.z = 57.2957802 * r0.z;
  r0.y = r0.y ? 0xffc10000 : r0.z;
  r0.z = cmp(r0.y < 0);
  r1.x = 360 + r0.y;
  r0.y = r0.z ? r1.x : r0.y;
  r0.z = cmp(r0.y < -180);
  r1.x = cmp(180 < r0.y);
  r1.yz = float2(360, -360) + r0.yy;
  r0.y = r1.x ? r1.z : r0.y;
  r0.y = r0.z ? r1.y : r0.y;
  r0.z = cmp(-67.5 < r0.y);
  r1.xy = cmp(r0.yy < float2(67.5, 0));
  r0.z = r0.z ? r1.x : 0;
  if (r0.z != 0) {
    r0.y = 67.5 + r0.y;
    r0.z = 0.0296296291 * r0.y;
    r1.x = (int)r0.z;
    r0.z = trunc(r0.z);
    r0.y = r0.y * 0.0296296291 + -r0.z;
    r0.z = r0.y * r0.y;
    r1.z = r0.z * r0.y;
    r3.xyz = float3(-0.166666672, -0.5, 0.166666672) * r1.zzz;
    r3.xy = r0.zz * float2(0.5, 0.5) + r3.xy;
    r3.xy = r0.yy * float2(-0.5, 0.5) + r3.xy;
    r0.y = r1.z * 0.5 + -r0.z;
    r0.y = 0.666666687 + r0.y;
    r4.xyz = cmp((int3)r1.xxx == int3(3, 2, 1));
    r1.zw = float2(0.166666672, 0.166666672) + r3.xy;
    r0.z = r1.x ? 0 : r3.z;
    r0.z = r4.z ? r1.w : r0.z;
    r0.y = r4.y ? r0.y : r0.z;
    r0.y = r4.x ? r1.z : r0.y;
  } else {
    r0.y = 0;
  }
  r0.z = r1.y ? r2.y : r2.z;
  r1.x = 1.5 * r0.y;
  r1.y = r0.y * 0.270000011 + -1;
  r1.z = 0.0299999993 + r0.z;
  r1.x = r1.x * r1.z;
  r0.x = -r1.x * 0.180000007 + r0.x;
  r0.y = r0.y * r0.z;
  r0.y = r0.y * r1.y;
  r0.y = 0.0324000008 * r0.y;
  r0.y = r0.x * r0.x + -r0.y;
  r0.y = sqrt(r0.y);
  r0.x = -r0.x + -r0.y;
  r0.y = r1.y + r1.y;
  r2.x = r0.x / r0.y;
  r0.x = max(r2.y, r2.z);
  r0.x = max(r2.x, r0.x);
  r0.z = min(r2.y, r2.z);
  r0.z = min(r2.x, r0.z);
  r0.xyz = max(float3(1.00000001e-10, 0.00999999978, 1.00000001e-10), r0.xxz);
  r0.x = r0.x + -r0.z;
  r0.x = r0.x / r0.y;
  r0.yz = r2.yx + -r2.xz;
  r0.y = r2.y * r0.y;
  r0.y = r2.z * r0.w + r0.y;
  r0.y = r2.x * r0.z + r0.y;
  r0.y = max(0, r0.y);
  r0.y = sqrt(r0.y);
  r0.z = r2.z + r2.y;
  r0.z = r0.z + r2.x;
  r0.y = r0.y * 1.75 + r0.z;
  r0.x = -0.400000006 + r0.x;
  r0.zw = float2(0.333333343, 2.5) * r0.yx;
  r0.w = 1 + -abs(r0.w);
  r0.w = max(0, r0.w);
  r1.x = cmp(r0.x < 0);
  r0.x = cmp(0 < r0.x);
  r0.x = r0.x ? 1.000000 : 0;
  r0.x = r1.x ? -1 : r0.x;
  r0.w = -r0.w * r0.w + 1;
  r0.x = r0.x * r0.w + 1;
  r0.w = 0.0250000004 * r0.x;
  r1.xy = r0.xx * float2(0.0250000004, 0.0125000002) + float2(1, -1);
  r0.x = 0.0533333346 * r1.x;
  r0.x = cmp(r0.x >= r0.z);
  r1.x = -r0.w / r1.x;
  r0.y = cmp(r0.y >= 0.479999989);
  r0.z = 0.0799999982 / r0.z;
  r0.z = -0.5 + r0.z;
  r0.z = r0.w * r0.z;
  r0.z = r0.z / r1.y;
  r0.y = r0.y ? 0 : r0.z;
  r0.x = r0.x ? r1.x : r0.y;
  r0.x = 1 + r0.x;
  r0.xyz = r0.xxx * r2.xyz;
  r1.x = dot(r0.xyz, float3(1.45143938, -0.236510724, -0.214928553));
  r1.y = dot(r0.xyz, float3(-0.0765537992, 1.17622995, -0.0996759459));
  r1.z = dot(r0.xyz, float3(0.00831612758, -0.00603244733, 0.997716188));
  r0.xyz = r1.xyz / CB0[0][4].xxx;
  r0.xyz = CB0[0][9].xxx * r0.xyz;
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
  if (CB0[0][8].x != 0) {
    r0.w = dot(r0.xyz, float3(1.45143938, -0.236510724, -0.214928553));
    r1.x = dot(r0.xyz, float3(-0.0765537992, 1.17622995, -0.0996759459));
    r1.y = dot(r0.xyz, float3(0.00831612758, -0.00603244733, 0.997716188));
    r1.z = cmp(CB0[0][8].w >= 4000);
    if (r1.z != 0) {
      r3.xyzw = float4(-2.30102992, -2.30102992, -1.93120003, -1.52049994);
      r4.xyzw = float4(-1.05780005, -0.466800004, 0.119379997, 0.708813429);
      r11.xyzw = float4(1.29118657, 0.797318637, 1.2026813, 1.60930002);
      r8.xyzw = float4(2.01079988, 2.41479993, 2.81789994, 3.1724999);
      r6.xyzw = float4(0.000141798722, 0.00499999989, 6824.36377, 4000);
      r5.xy = float2(3.53449965, 3.66962051);
      r1.z = 0.300000012;
    } else {
      r1.z = cmp(CB0[0][8].w < 48);
      if (r1.z != 0) {
        r3.xyzw = float4(-1.69896996, -1.69896996, -1.47790003, -1.22909999);
        r4.xyzw = float4(-0.864799976, -0.448000014, 0.00517999986, 0.451108038);
        r11.xyzw = float4(0.91137445, 0.515438676, 0.847043753, 1.1358);
        r8.xyzw = float4(1.38020003, 1.51970005, 1.59850001, 1.64670002);
        r6.xyzw = float4(0.00287989364, 0.0199999996, 1005.71893, 48);
        r5.xy = float2(1.67460918, 1.68787336);
        r1.z = 0.0399999991;
      } else {
        r1.z = cmp(CB0[0][8].w >= 2000);
        if (r1.z != 0) {
          r1.z = -2000 + CB0[0][8].w;
          r2.x = saturate(0.000500000024 * r1.z);
          r1.z = log2(CB0[0][8].w);
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
          r1.z = cmp(CB0[0][8].w >= 1000);
          if (r1.z != 0) {
            r1.z = -1000 + CB0[0][8].w;
            r2.x = saturate(0.00100000005 * r1.z);
            r1.z = log2(CB0[0][8].w);
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
            r1.z = -48 + CB0[0][8].w;
            r2.x = saturate(0.00105042022 * r1.z);
            r1.z = log2(CB0[0][8].w);
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
  r2.w = 0;
  // No code for instruction (needs manual fix):
  u0[vThreadID] = r2;                  // store_uav_typed U0[0].xyzw, vThreadID.xyzz, r2.xyzw return;
}
