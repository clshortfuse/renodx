#include "../../common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Sun Apr 13 14:14:45 2025
// Found in Returnal

cbuffer cb0 : register(b0) {
  float4 cb0[68];
}

// 3Dmigoto declarations
#define cmp -

void main(
    linear noperspective float2 v0: TEXCOORD0,
    float4 v1: SV_POSITION0,
    uint v2: SV_RenderTargetArrayIndex0,
    out float4 o0: SV_Target0) {
  const float4 icb[] = { { -4.000000, -0.718548, -4.970622, 0.808913 },
                         { -4.000000, 2.081031, -3.029378, 1.191087 },
                         { -3.157377, 3.668124, -2.126200, 1.568300 },
                         { -0.485250, 4.000000, -1.510500, 1.948300 },
                         { 1.847732, 4.000000, -1.057800, 2.308300 },
                         { 1.847732, 4.000000, -0.466800, 2.638400 },
                         { -2.301030, 0.801995, 0.119380, 2.859500 },
                         { -2.301030, 1.198005, 0.708813, 2.987261 },
                         { -1.931200, 1.594300, 1.291187, 3.012739 },
                         { -1.520500, 1.997300, 1.291187, 3.012739 },
                         { -1.057800, 2.378300, 0, 0 },
                         { -0.466800, 2.768400, 0, 0 },
                         { 0.119380, 3.051500, 0, 0 },
                         { 0.708813, 3.274629, 0, 0 },
                         { 1.291187, 3.327431, 0, 0 },
                         { 1.291187, 3.327431, 0, 0 } };
  float4 r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(-0.015625, -0.015625) + v0.xy;
  r0.xy = float2(1.03225803, 1.03225803) * r0.xy;
  r0.z = (uint)v2.x;
  r1.z = 0.0322580636 * r0.z;
  r0.z = cmp(asuint(cb0[65].z) >= 3);
  r2.xy = log2(r0.xy);
  r2.z = log2(r1.z);
  r0.xyw = float3(0.0126833133, 0.0126833133, 0.0126833133) * r2.xyz;
  r0.xyw = exp2(r0.xyw);
  r2.xyz = float3(-0.8359375, -0.8359375, -0.8359375) + r0.xyw;
  r2.xyz = max(float3(0, 0, 0), r2.xyz);
  r0.xyw = -r0.xyw * float3(18.6875, 18.6875, 18.6875) + float3(18.8515625, 18.8515625, 18.8515625);
  r0.xyw = r2.xyz / r0.xyw;
  r0.xyw = log2(r0.xyw);
  r0.xyw = float3(6.27739477, 6.27739477, 6.27739477) * r0.xyw;
  r0.xyw = exp2(r0.xyw);
  r0.xyw = float3(100, 100, 100) * r0.xyw;
  r1.xy = v0.xy * float2(1.03225803, 1.03225803) + float2(-0.0161290318, -0.0161290318);
  r1.xyz = float3(-0.434017599, -0.434017599, -0.434017599) + r1.xyz;
  r1.xyz = float3(14, 14, 14) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.xyz = r1.xyz * float3(0.180000007, 0.180000007, 0.180000007) + float3(-0.00266771927, -0.00266771927, -0.00266771927);
  r0.xyz = r0.zzz ? r0.xyw : r1.xyz;
  r0.w = 1.00055635 * cb0[44].y;
  r1.x = cmp(6996.10791 >= cb0[44].y);
  r1.yz = float2(4.60700006e+09, 2.0064e+09) / r0.ww;
  r1.yz = float2(2967800, 1901800) + -r1.yz;
  r1.yz = r1.yz / r0.ww;
  r1.yz = float2(99.1100006, 247.479996) + r1.yz;
  r1.yz = r1.yz / r0.ww;
  r1.yz = float2(0.244063005, 0.237039998) + r1.yz;
  r1.x = r1.x ? r1.y : r1.z;
  r0.w = r1.x * r1.x;
  r1.z = 2.86999989 * r1.x;
  r0.w = r0.w * -3 + r1.z;
  r1.y = -0.275000006 + r0.w;
  r2.xyz = cb0[44].yyy * float3(0.000154118257, 0.00084242021, 4.22806261e-05) + float3(0.860117733, 1, 0.317398727);
  r0.w = cb0[44].y * cb0[44].y;
  r2.xyz = r0.www * float3(1.28641219e-07, 7.08145137e-07, 4.20481676e-08) + r2.xyz;
  r2.x = r2.x / r2.y;
  r1.z = -cb0[44].y * 2.8974182e-05 + 1;
  r0.w = r0.w * 1.61456057e-07 + r1.z;
  r2.y = r2.z / r0.w;
  r1.zw = r2.xy + r2.xy;
  r0.w = 3 * r2.x;
  r1.z = -r2.y * 8 + r1.z;
  r1.z = 4 + r1.z;
  r3.x = r0.w / r1.z;
  r3.y = r1.w / r1.z;
  r0.w = cmp(cb0[44].y < 4000);
  r1.xy = r0.ww ? r3.xy : r1.xy;
  r0.w = dot(r2.xy, r2.xy);
  r0.w = rsqrt(r0.w);
  r1.zw = r2.xy * r0.ww;
  r0.w = cb0[44].z * -r1.w;
  r0.w = r0.w * 0.0500000007 + r2.x;
  r1.z = cb0[44].z * r1.z;
  r1.z = r1.z * 0.0500000007 + r2.y;
  r1.w = 3 * r0.w;
  r0.w = r0.w + r0.w;
  r0.w = -r1.z * 8 + r0.w;
  r0.w = 4 + r0.w;
  r1.z = r1.z + r1.z;
  r2.xy = r1.wz / r0.ww;
  r1.zw = r2.xy + -r3.xy;
  r1.xy = r1.xy + r1.zw;
  r0.w = max(1.00000001e-10, r1.y);
  r2.x = r1.x / r0.w;
  r1.x = 1 + -r1.x;
  r1.x = r1.x + -r1.y;
  r2.z = r1.x / r0.w;
  r2.y = 1;
  r0.w = dot(float3(0.895099998, 0.266400009, -0.161400005), r2.xyz);
  r1.x = dot(float3(-0.750199974, 1.71350002, 0.0366999991), r2.xyz);
  r1.y = dot(float3(0.0388999991, -0.0684999973, 1.02960002), r2.xyz);
  r0.w = 0.941379249 / r0.w;
  r1.xy = float2(1.04043639, 1.0897665) / r1.xy;
  r2.xyz = float3(0.895099998, 0.266400009, -0.161400005) * r0.www;
  r1.xzw = float3(-0.750199974, 1.71350002, 0.0366999991) * r1.xxx;
  r3.xyz = float3(0.0388999991, -0.0684999973, 1.02960002) * r1.yyy;
  r4.x = r2.x;
  r4.y = r1.x;
  r4.z = r3.x;
  r5.x = dot(float3(0.986992896, -0.1470543, 0.159962699), r4.xyz);
  r6.x = r2.y;
  r6.y = r1.z;
  r6.z = r3.y;
  r5.y = dot(float3(0.986992896, -0.1470543, 0.159962699), r6.xyz);
  r3.x = r2.z;
  r3.y = r1.w;
  r5.z = dot(float3(0.986992896, -0.1470543, 0.159962699), r3.xyz);
  r1.x = dot(float3(0.432305306, 0.518360317, 0.0492912009), r4.xyz);
  r1.y = dot(float3(0.432305306, 0.518360317, 0.0492912009), r6.xyz);
  r1.z = dot(float3(0.432305306, 0.518360317, 0.0492912009), r3.xyz);
  r2.x = dot(float3(-0.0085287001, 0.040042799, 0.968486726), r4.xyz);
  r2.y = dot(float3(-0.0085287001, 0.040042799, 0.968486726), r6.xyz);
  r2.z = dot(float3(-0.0085287001, 0.040042799, 0.968486726), r3.xyz);
  r3.x = dot(r5.xyz, float3(0.412456393, 0.212672904, 0.0193339009));
  r4.x = dot(r5.xyz, float3(0.357576102, 0.715152204, 0.119191997));
  r5.x = dot(r5.xyz, float3(0.180437505, 0.0721750036, 0.950304091));
  r3.y = dot(r1.xyz, float3(0.412456393, 0.212672904, 0.0193339009));
  r4.y = dot(r1.xyz, float3(0.357576102, 0.715152204, 0.119191997));
  r5.y = dot(r1.xyz, float3(0.180437505, 0.0721750036, 0.950304091));
  r3.z = dot(r2.xyz, float3(0.412456393, 0.212672904, 0.0193339009));
  r4.z = dot(r2.xyz, float3(0.357576102, 0.715152204, 0.119191997));
  r5.z = dot(r2.xyz, float3(0.180437505, 0.0721750036, 0.950304091));
  r1.x = dot(float3(3.2409699, -1.5373832, -0.498610765), r3.xyz);
  r1.y = dot(float3(3.2409699, -1.5373832, -0.498610765), r4.xyz);
  r1.z = dot(float3(3.2409699, -1.5373832, -0.498610765), r5.xyz);
  r2.x = dot(float3(-0.969243646, 1.8759675, 0.0415550582), r3.xyz);
  r2.y = dot(float3(-0.969243646, 1.8759675, 0.0415550582), r4.xyz);
  r2.z = dot(float3(-0.969243646, 1.8759675, 0.0415550582), r5.xyz);
  r3.x = dot(float3(0.0556300804, -0.203976959, 1.05697155), r3.xyz);
  r3.y = dot(float3(0.0556300804, -0.203976959, 1.05697155), r4.xyz);
  r3.z = dot(float3(0.0556300804, -0.203976959, 1.05697155), r5.xyz);
  r1.x = dot(r1.xyz, r0.xyz);
  r1.y = dot(r2.xyz, r0.xyz);
  r1.z = dot(r3.xyz, r0.xyz);
  r0.x = dot(float3(0.613191485, 0.33951208, 0.0473663323), r1.xyz);
  r0.y = dot(float3(0.0702069029, 0.916335821, 0.0134500116), r1.xyz);
  r0.z = dot(float3(0.0206188709, 0.109567292, 0.869606733), r1.xyz);
  r0.w = dot(r0.xyz, float3(0.272228718, 0.674081743, 0.0536895171));
  r1.xyz = r0.xyz / r0.www;
  r1.xyz = float3(-1, -1, -1) + r1.xyz;
  r1.x = dot(r1.xyz, r1.xyz);
  r1.x = -4 * r1.x;
  r1.x = exp2(r1.x);
  r1.x = 1 + -r1.x;
  r0.w = r0.w * r0.w;
  r0.w = cb0[67].w * r0.w;
  r0.w = -4 * r0.w;
  r0.w = exp2(r0.w);
  r0.w = 1 + -r0.w;
  r0.w = r1.x * r0.w;
  r1.x = dot(float3(1.37041271, -0.329291314, -0.0636827648), r0.xyz);
  r1.y = dot(float3(-0.0834341869, 1.09709096, -0.0108615728), r0.xyz);
  r1.z = dot(float3(-0.0257932581, -0.0986256376, 1.20369434), r0.xyz);
  r1.xyz = r1.xyz + -r0.xyz;
  r1.xyz = r0.www * r1.xyz + r0.xyz;
  r0.xyz = cb0[44].xxx ? r0.xyz : r1.xyz;
  r0.w = dot(r0.xyz, float3(0.272228718, 0.674081743, 0.0536895171));
  r1.xyzw = cb0[50].xyzw * cb0[45].xyzw;
  r2.xyzw = cb0[51].xyzw * cb0[46].xyzw;
  r3.xyzw = cb0[52].xyzw * cb0[47].xyzw;
  r4.xyzw = cb0[53].xyzw * cb0[48].xyzw;
  r5.xyzw = cb0[54].xyzw + cb0[49].xyzw;
  r1.xyz = r1.xyz * r1.www;
  r0.xyz = r0.xyz + -r0.www;
  r1.xyz = r1.xyz * r0.xyz + r0.www;
  r1.xyz = max(float3(0, 0, 0), r1.xyz);
  r1.xyz = float3(5.55555534, 5.55555534, 5.55555534) * r1.xyz;
  r2.xyz = r2.xyz * r2.www;
  r1.xyz = log2(r1.xyz);
  r1.xyz = r2.xyz * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.xyz = float3(0.180000007, 0.180000007, 0.180000007) * r1.xyz;
  r2.xyz = r3.xyz * r3.www;
  r2.xyz = float3(1, 1, 1) / r2.xyz;
  r1.xyz = log2(r1.xyz);
  r1.xyz = r2.xyz * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r2.xyz = r4.xyz * r4.www;
  r3.xyz = r5.xyz + r5.www;
  r1.xyz = r1.xyz * r2.xyz + r3.xyz;
  r1.w = 1 / cb0[65].x;
  r1.w = saturate(r1.w * r0.w);
  r2.x = r1.w * -2 + 3;
  r1.w = r1.w * r1.w;
  r1.w = -r2.x * r1.w + 1;
  r2.xyzw = cb0[60].xyzw * cb0[45].xyzw;
  r3.xyzw = cb0[61].xyzw * cb0[46].xyzw;
  r4.xyzw = cb0[62].xyzw * cb0[47].xyzw;
  r5.xyzw = cb0[63].xyzw * cb0[48].xyzw;
  r6.xyzw = cb0[64].xyzw + cb0[49].xyzw;
  r2.xyz = r2.xyz * r2.www;
  r2.xyz = r2.xyz * r0.xyz + r0.www;
  r2.xyz = max(float3(0, 0, 0), r2.xyz);
  r2.xyz = float3(5.55555534, 5.55555534, 5.55555534) * r2.xyz;
  r3.xyz = r3.xyz * r3.www;
  r2.xyz = log2(r2.xyz);
  r2.xyz = r3.xyz * r2.xyz;
  r2.xyz = exp2(r2.xyz);
  r2.xyz = float3(0.180000007, 0.180000007, 0.180000007) * r2.xyz;
  r3.xyz = r4.xyz * r4.www;
  r3.xyz = float3(1, 1, 1) / r3.xyz;
  r2.xyz = log2(r2.xyz);
  r2.xyz = r3.xyz * r2.xyz;
  r2.xyz = exp2(r2.xyz);
  r3.xyz = r5.xyz * r5.www;
  r4.xyz = r6.xyz + r6.www;
  r2.xyz = r2.xyz * r3.xyz + r4.xyz;
  r2.w = 1 + -cb0[65].y;
  r3.x = -cb0[65].y + r0.w;
  r2.w = 1 / r2.w;
  r2.w = saturate(r3.x * r2.w);
  r3.x = r2.w * -2 + 3;
  r2.w = r2.w * r2.w;
  r3.y = r3.x * r2.w;
  r4.xyzw = cb0[55].xyzw * cb0[45].xyzw;
  r5.xyzw = cb0[56].xyzw * cb0[46].xyzw;
  r6.xyzw = cb0[57].xyzw * cb0[47].xyzw;
  r7.xyzw = cb0[58].xyzw * cb0[48].xyzw;
  r8.xyzw = cb0[59].xyzw + cb0[49].xyzw;
  r4.xyz = r4.xyz * r4.www;
  r0.xyz = r4.xyz * r0.xyz + r0.www;
  r0.xyz = max(float3(0, 0, 0), r0.xyz);
  r0.xyz = float3(5.55555534, 5.55555534, 5.55555534) * r0.xyz;
  r4.xyz = r5.xyz * r5.www;
  r0.xyz = log2(r0.xyz);
  r0.xyz = r4.xyz * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = float3(0.180000007, 0.180000007, 0.180000007) * r0.xyz;
  r4.xyz = r6.xyz * r6.www;
  r4.xyz = float3(1, 1, 1) / r4.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = r4.xyz * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r4.xyz = r7.xyz * r7.www;
  r5.xyz = r8.xyz + r8.www;
  r0.xyz = r0.xyz * r4.xyz + r5.xyz;
  r0.w = 1 + -r1.w;
  r0.w = -r3.x * r2.w + r0.w;
  r0.xyz = r0.xyz * r0.www;
  r0.xyz = r1.xyz * r1.www + r0.xyz;
  r0.xyz = r2.xyz * r3.yyy + r0.xyz;

  float3 untonemapped_ap1 = r0.xyz;

  r1.x = dot(float3(1.70505154, -0.621790707, -0.0832583979), r0.xyz);
  r1.y = dot(float3(-0.130257145, 1.14080286, -0.0105485283), r0.xyz);
  r1.z = dot(float3(-0.0240032747, -0.128968775, 1.15297174), r0.xyz);
  if (cb0[44].x != 0) {
    r2.x = dot(r1.xyz, cb0[28].xyz);
    r2.y = dot(r1.xyz, cb0[29].xyz);
    r2.z = dot(r1.xyz, cb0[30].xyz);
    r0.w = dot(r1.xyz, cb0[33].xyz);
    r0.w = 1 + r0.w;
    r0.w = rcp(r0.w);
    r3.xyz = cb0[35].xyz * r0.www + cb0[34].xyz;
    r2.xyz = r3.xyz * r2.xyz;
    r2.xyz = max(float3(0, 0, 0), r2.xyz);
    r3.xyz = cb0[31].xxx + -r2.xyz;
    r3.xyz = max(float3(0, 0, 0), r3.xyz);
    r4.xyz = max(cb0[31].zzz, r2.xyz);
    r2.xyz = max(cb0[31].xxx, r2.xyz);
    r2.xyz = min(cb0[31].zzz, r2.xyz);
    r5.xyz = r4.xyz * cb0[32].xxx + cb0[32].yyy;
    r4.xyz = cb0[31].www + r4.xyz;
    r4.xyz = rcp(r4.xyz);
    r6.xyz = cb0[28].www * r3.xyz;
    r3.xyz = cb0[31].yyy + r3.xyz;
    r3.xyz = rcp(r3.xyz);
    r3.xyz = r6.xyz * r3.xyz + cb0[29].www;
    r2.xyz = r2.xyz * cb0[30].www + r3.xyz;
    r2.xyz = r5.xyz * r4.xyz + r2.xyz;
    r2.xyz = float3(-0.00200000009, -0.00200000009, -0.00200000009) + r2.xyz;
  } else {
    r3.x = dot(float3(0.938639402, 1.02359565e-10, 0.0613606237), r0.xyz);
    r3.y = dot(float3(8.36008554e-11, 0.830794156, 0.169205874), r0.xyz);
    r3.z = dot(float3(2.13187367e-12, -5.63307213e-12, 1), r0.xyz);
    r3.xyz = r3.xyz + -r0.xyz;
    r0.xyz = cb0[67].zzz * r3.xyz + r0.xyz;
    r3.y = dot(float3(0.695452213, 0.140678704, 0.163869068), r0.xyz);
    r3.z = dot(float3(0.0447945632, 0.859671116, 0.0955343172), r0.xyz);
    r3.w = dot(float3(-0.00552588236, 0.00402521016, 1.00150073), r0.xyz);
    r0.x = min(r3.y, r3.z);
    r0.x = min(r0.x, r3.w);
    r0.y = max(r3.y, r3.z);
    r0.y = max(r0.y, r3.w);
    r0.xyz = max(float3(1.00000001e-10, 1.00000001e-10, 0.00999999978), r0.xyy);
    r0.x = r0.y + -r0.x;
    r0.x = r0.x / r0.z;
    r0.yzw = r3.wzy + -r3.zyw;
    r0.yz = r3.wz * r0.yz;
    r0.y = r0.y + r0.z;
    r0.y = r3.y * r0.w + r0.y;
    r0.y = sqrt(r0.y);
    r0.z = r3.w + r3.z;
    r0.z = r0.z + r3.y;
    r0.y = r0.y * 1.75 + r0.z;
    r0.w = -0.400000006 + r0.x;
    r1.w = 2.5 * r0.w;
    r1.w = 1 + -abs(r1.w);
    r1.w = max(0, r1.w);
    r2.w = cmp(0 < r0.w);
    r0.w = cmp(r0.w < 0);
    r0.w = (int)-r2.w + (int)r0.w;
    r0.w = (int)r0.w;
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
    r4.yzw = r3.yzw * r0.yyy;
    r0.zw = cmp(r4.zw == r4.yz);
    r0.z = r0.w ? r0.z : 0;
    r0.w = r3.z * r0.y + -r4.w;
    r0.w = 1.73205078 * r0.w;
    r1.w = r4.y * 2 + -r4.z;
    r1.w = -r3.w * r0.y + r1.w;
    r2.w = min(abs(r1.w), abs(r0.w));
    r3.x = max(abs(r1.w), abs(r0.w));
    r3.x = 1 / r3.x;
    r2.w = r3.x * r2.w;
    r3.x = r2.w * r2.w;
    r3.z = r3.x * 0.0208350997 + -0.0851330012;
    r3.z = r3.x * r3.z + 0.180141002;
    r3.z = r3.x * r3.z + -0.330299497;
    r3.x = r3.x * r3.z + 0.999866009;
    r3.z = r3.x * r2.w;
    r3.w = cmp(abs(r1.w) < abs(r0.w));
    r3.z = r3.z * -2 + 1.57079637;
    r3.z = r3.w ? r3.z : 0;
    r2.w = r2.w * r3.x + r3.z;
    r3.x = cmp(r1.w < -r1.w);
    r3.x = r3.x ? -3.141593 : 0;
    r2.w = r3.x + r2.w;
    r3.x = min(r1.w, r0.w);
    r0.w = max(r1.w, r0.w);
    r1.w = cmp(r3.x < -r3.x);
    r0.w = cmp(r0.w >= -r0.w);
    r0.w = r0.w ? r1.w : 0;
    r0.w = r0.w ? -r2.w : r2.w;
    r0.w = 57.2957802 * r0.w;
    r0.z = r0.z ? 0 : r0.w;
    r0.w = cmp(r0.z < 0);
    r1.w = 360 + r0.z;
    r0.z = r0.w ? r1.w : r0.z;
    r0.z = max(0, r0.z);
    r0.z = min(360, r0.z);
    r0.w = cmp(180 < r0.z);
    r1.w = -360 + r0.z;
    r0.z = r0.w ? r1.w : r0.z;
    r0.z = 0.0148148146 * r0.z;
    r0.z = 1 + -abs(r0.z);
    r0.z = max(0, r0.z);
    r0.w = r0.z * -2 + 3;
    r0.z = r0.z * r0.z;
    r0.z = r0.w * r0.z;
    r0.z = r0.z * r0.z;
    r0.x = r0.z * r0.x;
    r0.y = -r3.y * r0.y + 0.0299999993;
    r0.x = r0.x * r0.y;
    r4.x = r0.x * 0.180000007 + r4.y;
    r0.x = dot(float3(1.45143926, -0.236510754, -0.214928567), r4.xzw);
    r0.y = dot(float3(-0.0765537769, 1.17622972, -0.0996759236), r4.xzw);
    r0.z = dot(float3(0.00831614807, -0.00603244966, 0.997716308), r4.xzw);
    r0.xyz = max(float3(0, 0, 0), r0.xyz);
    r0.w = dot(r0.xyz, float3(0.272228718, 0.674081743, 0.0536895171));
    r0.xyz = r0.xyz + -r0.www;
    r0.xyz = r0.xyz * float3(0.959999979, 0.959999979, 0.959999979) + r0.www;
    r3.xy = float2(1, 0.180000007) + cb0[36].ww;
    r0.w = -cb0[36].y + r3.x;
    r1.w = 1 + cb0[37].x;
    r2.w = -cb0[36].z + r1.w;
    r3.x = cmp(0.800000012 < cb0[36].y);
    r3.zw = float2(0.819999993, 1) + -cb0[36].yy;
    r3.zw = r3.zw / cb0[36].xx;
    r3.z = -0.744727492 + r3.z;
    r3.y = r3.y / r0.w;
    r4.x = -1 + r3.y;
    r4.x = 1 + -r4.x;
    r3.y = r3.y / r4.x;
    r3.y = log2(r3.y);
    r3.y = 0.346573591 * r3.y;
    r4.x = r0.w / cb0[36].x;
    r3.y = -r3.y * r4.x + -0.744727492;
    r3.x = r3.x ? r3.z : r3.y;
    r3.y = r3.w + -r3.x;
    r3.z = cb0[36].z / cb0[36].x;
    r3.z = r3.z + -r3.y;
    r0.xyz = log2(r0.xyz);
    r4.xyz = float3(0.30103001, 0.30103001, 0.30103001) * r0.xyz;
    r5.xyz = r0.xyz * float3(0.30103001, 0.30103001, 0.30103001) + r3.yyy;
    r5.xyz = cb0[36].xxx * r5.xyz;
    r3.y = r0.w + r0.w;
    r3.w = -2 * cb0[36].x;
    r0.w = r3.w / r0.w;
    r6.xyz = r0.xyz * float3(0.30103001, 0.30103001, 0.30103001) + -r3.xxx;
    r7.xyz = r6.xyz * r0.www;
    r7.xyz = float3(1.44269502, 1.44269502, 1.44269502) * r7.xyz;
    r7.xyz = exp2(r7.xyz);
    r7.xyz = float3(1, 1, 1) + r7.xyz;
    r7.xyz = r3.yyy / r7.xyz;
    r7.xyz = -cb0[36].www + r7.xyz;
    r0.w = r2.w + r2.w;
    r3.y = cb0[36].x + cb0[36].x;
    r2.w = r3.y / r2.w;
    r0.xyz = r0.xyz * float3(0.30103001, 0.30103001, 0.30103001) + -r3.zzz;
    r0.xyz = r2.www * r0.xyz;
    r0.xyz = float3(1.44269502, 1.44269502, 1.44269502) * r0.xyz;
    r0.xyz = exp2(r0.xyz);
    r0.xyz = float3(1, 1, 1) + r0.xyz;
    r0.xyz = r0.www / r0.xyz;
    r0.xyz = r1.www + -r0.xyz;
    r8.xyz = cmp(r4.xyz < r3.xxx);
    r7.xyz = r8.xyz ? r7.xyz : r5.xyz;
    r4.xyz = cmp(r3.zzz < r4.xyz);
    r0.xyz = r4.xyz ? r0.xyz : r5.xyz;
    r0.w = r3.z + -r3.x;
    r4.xyz = saturate(r6.xyz / r0.www);
    r0.w = cmp(r3.z < r3.x);
    r3.xyz = float3(1, 1, 1) + -r4.xyz;
    r3.xyz = r0.www ? r3.xyz : r4.xyz;
    r4.xyz = -r3.xyz * float3(2, 2, 2) + float3(3, 3, 3);
    r3.xyz = r3.xyz * r3.xyz;
    r3.xyz = r3.xyz * r4.xyz;
    r0.xyz = r0.xyz + -r7.xyz;
    r0.xyz = r3.xyz * r0.xyz + r7.xyz;
    r0.w = dot(r0.xyz, float3(0.272228718, 0.674081743, 0.0536895171));
    r0.xyz = r0.xyz + -r0.www;
    r0.xyz = r0.xyz * float3(0.930000007, 0.930000007, 0.930000007) + r0.www;
    r0.xyz = max(float3(0, 0, 0), r0.xyz);
    r3.x = dot(float3(1.06537485, 1.44678506e-06, -0.0653710067), r0.xyz);
    r3.y = dot(float3(-3.45525592e-07, 1.20366347, -0.203667715), r0.xyz);
    r3.z = dot(float3(1.9865448e-08, 2.12079581e-08, 0.999999583), r0.xyz);
    r3.xyz = r3.xyz + -r0.xyz;
    r0.xyz = cb0[67].zzz * r3.xyz + r0.xyz;
    r3.x = dot(float3(1.70505154, -0.621790707, -0.0832583979), r0.xyz);
    r3.y = dot(float3(-0.130257145, 1.14080286, -0.0105485283), r0.xyz);
    r3.z = dot(float3(-0.0240032747, -0.128968775, 1.15297174), r0.xyz);
    r2.xyz = max(float3(0, 0, 0), r3.xyz);
  }
  r0.xyz = r2.xyz * r2.xyz;
  r2.xyz = cb0[26].yyy * r2.xyz;
  r0.xyz = cb0[26].xxx * r0.xyz + r2.xyz;
  r0.xyz = cb0[26].zzz + r0.xyz;
  r2.xyz = cb0[42].yzw * r0.xyz;
  r0.xyz = -r0.xyz * cb0[42].yzw + cb0[43].xyz;
  r0.xyz = cb0[43].www * r0.xyz + r2.xyz;
  r2.xyz = max(float3(0, 0, 0), r0.xyz);
  r2.xyz = log2(r2.xyz);
  r2.xyz = cb0[27].yyy * r2.xyz;
  r3.xyz = exp2(r2.xyz);

  if (RENODX_TONE_MAP_TYPE != 0) {
    o0 = LutBuilderToneMap(untonemapped_ap1, r3.xyz);
    return;
  }

  if (cb0[65].z == 0) {
    r4.xyz = float3(12.9200001, 12.9200001, 12.9200001) * r3.xyz;
    r5.xyz = cmp(r3.xyz >= float3(0.00313066994, 0.00313066994, 0.00313066994));
    r2.xyz = float3(0.416666657, 0.416666657, 0.416666657) * r2.xyz;
    r2.xyz = exp2(r2.xyz);
    r2.xyz = r2.xyz * float3(1.05499995, 1.05499995, 1.05499995) + float3(-0.0549999997, -0.0549999997, -0.0549999997);
    r2.xyz = r5.xyz ? r2.xyz : r4.xyz;
  } else {
    r4.xyzw = cmp(asint(cb0[65].wwww) == int4(1, 2, 3, 4));
    r5.xyz = r4.www ? float3(1, 0, 0) : float3(1.70505154, -0.621790707, -0.0832583979);
    r6.xyz = r4.www ? float3(0, 1, 0) : float3(-0.130257145, 1.14080286, -0.0105485283);
    r7.xyz = r4.www ? float3(0, 0, 1) : float3(-0.0240032747, -0.128968775, 1.15297174);
    r5.xyz = r4.zzz ? float3(0.695452213, 0.140678704, 0.163869068) : r5.xyz;
    r6.xyz = r4.zzz ? float3(0.0447945632, 0.859671116, 0.0955343172) : r6.xyz;
    r7.xyz = r4.zzz ? float3(-0.00552588282, 0.00402521016, 1.00150073) : r7.xyz;
    r5.xyz = r4.yyy ? float3(1.02579927, -0.0200525094, -0.00577136781) : r5.xyz;
    r6.xyz = r4.yyy ? float3(-0.00223502493, 1.00458264, -0.00235231337) : r6.xyz;
    r4.yzw = r4.yyy ? float3(-0.00501400325, -0.0252933875, 1.03044021) : r7.xyz;
    r5.xyz = r4.xxx ? float3(1.37915885, -0.308850735, -0.0703467429) : r5.xyz;
    r6.xyz = r4.xxx ? float3(-0.0693352968, 1.08229232, -0.0129620517) : r6.xyz;
    r4.xyz = r4.xxx ? float3(-0.00215925858, -0.0454653986, 1.04775953) : r4.yzw;
    r0.w = cmp(asint(cb0[65].z) == 1);
    if (r0.w != 0) {
      r7.x = dot(float3(0.613191485, 0.33951208, 0.0473663323), r3.xyz);
      r7.y = dot(float3(0.0702069029, 0.916335821, 0.0134500116), r3.xyz);
      r7.z = dot(float3(0.0206188709, 0.109567292, 0.869606733), r3.xyz);
      r8.x = dot(r5.xyz, r7.xyz);
      r8.y = dot(r6.xyz, r7.xyz);
      r8.z = dot(r4.xyz, r7.xyz);
      r7.xyz = max(float3(6.10351999e-05, 6.10351999e-05, 6.10351999e-05), r8.xyz);
      r8.xyz = float3(4.5, 4.5, 4.5) * r7.xyz;
      r7.xyz = max(float3(0.0179999992, 0.0179999992, 0.0179999992), r7.xyz);
      r7.xyz = log2(r7.xyz);
      r7.xyz = float3(0.449999988, 0.449999988, 0.449999988) * r7.xyz;
      r7.xyz = exp2(r7.xyz);
      r7.xyz = r7.xyz * float3(1.09899998, 1.09899998, 1.09899998) + float3(-0.0989999995, -0.0989999995, -0.0989999995);
      r2.xyz = min(r8.xyz, r7.xyz);
    } else {
      r7.xyz = cb0[42].yzw * r1.xyz;
      r1.xyz = -r1.xyz * cb0[42].yzw + cb0[43].xyz;
      r2.xyz = cb0[43].www * r1.xyz + r7.xyz;
      r1.xy = cmp(asint(cb0[65].zz) == int2(3, 5));
      r0.w = (int)r1.y | (int)r1.x;
      if (r0.w != 0) {
        r1.xyz = float3(1.5, 1.5, 1.5) * r2.xyz;
        r7.y = dot(float3(0.439700812, 0.382978052, 0.1773348), r1.xyz);
        r7.z = dot(float3(0.0897923037, 0.813423157, 0.096761629), r1.xyz);
        r7.w = dot(float3(0.0175439864, 0.111544058, 0.870704114), r1.xyz);
        r0.w = min(r7.y, r7.z);
        r0.w = min(r0.w, r7.w);
        r1.x = max(r7.y, r7.z);
        r1.x = max(r1.x, r7.w);
        r1.xy = max(float2(1.00000001e-10, 0.00999999978), r1.xx);
        r0.w = max(1.00000001e-10, r0.w);
        r0.w = r1.x + -r0.w;
        r0.w = r0.w / r1.y;
        r1.xyz = r7.wzy + -r7.zyw;
        r1.xy = r7.wz * r1.xy;
        r1.x = r1.x + r1.y;
        r1.x = r7.y * r1.z + r1.x;
        r1.x = sqrt(r1.x);
        r1.y = r7.w + r7.z;
        r1.y = r1.y + r7.y;
        r1.x = r1.x * 1.75 + r1.y;
        r1.z = -0.400000006 + r0.w;
        r1.yw = float2(0.333333343, 2.5) * r1.xz;
        r1.w = 1 + -abs(r1.w);
        r1.w = max(0, r1.w);
        r2.w = cmp(0 < r1.z);
        r1.z = cmp(r1.z < 0);
        r1.z = (int)-r2.w + (int)r1.z;
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
        r8.yzw = r7.yzw * r1.xxx;
        r1.yz = cmp(r8.zw == r8.yz);
        r1.y = r1.z ? r1.y : 0;
        r1.z = r7.z * r1.x + -r8.w;
        r1.z = 1.73205078 * r1.z;
        r1.w = r8.y * 2 + -r8.z;
        r1.w = -r7.w * r1.x + r1.w;
        r2.w = min(abs(r1.z), abs(r1.w));
        r3.w = max(abs(r1.z), abs(r1.w));
        r3.w = 1 / r3.w;
        r2.w = r3.w * r2.w;
        r3.w = r2.w * r2.w;
        r4.w = r3.w * 0.0208350997 + -0.0851330012;
        r4.w = r3.w * r4.w + 0.180141002;
        r4.w = r3.w * r4.w + -0.330299497;
        r3.w = r3.w * r4.w + 0.999866009;
        r4.w = r3.w * r2.w;
        r5.w = cmp(abs(r1.w) < abs(r1.z));
        r4.w = r4.w * -2 + 1.57079637;
        r4.w = r5.w ? r4.w : 0;
        r2.w = r2.w * r3.w + r4.w;
        r3.w = cmp(r1.w < -r1.w);
        r3.w = r3.w ? -3.141593 : 0;
        r2.w = r3.w + r2.w;
        r3.w = min(r1.z, r1.w);
        r1.z = max(r1.z, r1.w);
        r1.w = cmp(r3.w < -r3.w);
        r1.z = cmp(r1.z >= -r1.z);
        r1.z = r1.z ? r1.w : 0;
        r1.z = r1.z ? -r2.w : r2.w;
        r1.z = 57.2957802 * r1.z;
        r1.y = r1.y ? 0 : r1.z;
        r1.z = cmp(r1.y < 0);
        r1.w = 360 + r1.y;
        r1.y = r1.z ? r1.w : r1.y;
        r1.y = max(0, r1.y);
        r1.y = min(360, r1.y);
        r1.z = cmp(180 < r1.y);
        r1.w = -360 + r1.y;
        r1.y = r1.z ? r1.w : r1.y;
        r1.z = cmp(-67.5 < r1.y);
        r1.w = cmp(r1.y < 67.5);
        r1.z = r1.w ? r1.z : 0;
        if (r1.z != 0) {
          r1.y = 67.5 + r1.y;
          r1.z = 0.0296296291 * r1.y;
          r1.w = (int)r1.z;
          r1.z = trunc(r1.z);
          r1.y = r1.y * 0.0296296291 + -r1.z;
          r1.z = r1.y * r1.y;
          r2.w = r1.z * r1.y;
          r7.xzw = float3(-0.166666672, -0.5, 0.166666672) * r2.www;
          r7.xz = r1.zz * float2(0.5, 0.5) + r7.xz;
          r7.xz = r1.yy * float2(-0.5, 0.5) + r7.xz;
          r1.y = r2.w * 0.5 + -r1.z;
          r1.y = 0.666666687 + r1.y;
          r9.xyz = cmp((int3)r1.www == int3(3, 2, 1));
          r7.xz = float2(0.166666672, 0.166666672) + r7.xz;
          r1.z = r1.w ? 0 : r7.w;
          r1.z = r9.z ? r7.z : r1.z;
          r1.y = r9.y ? r1.y : r1.z;
          r1.y = r9.x ? r7.x : r1.y;
        } else {
          r1.y = 0;
        }
        r0.w = r1.y * r0.w;
        r0.w = 1.5 * r0.w;
        r1.x = -r7.y * r1.x + 0.0299999993;
        r0.w = r1.x * r0.w;
        r8.x = r0.w * 0.180000007 + r8.y;
        r1.xyz = max(float3(0, 0, 0), r8.xzw);
        r1.xyz = min(float3(65535, 65535, 65535), r1.xyz);
        r7.x = dot(float3(1.45143926, -0.236510754, -0.214928567), r1.xyz);
        r7.y = dot(float3(-0.0765537769, 1.17622972, -0.0996759236), r1.xyz);
        r7.z = dot(float3(0.00831614807, -0.00603244966, 0.997716308), r1.xyz);
        r1.xyz = max(float3(0, 0, 0), r7.xyz);
        r1.xyz = min(float3(65535, 65535, 65535), r1.xyz);
        r0.w = dot(r1.xyz, float3(0.272228718, 0.674081743, 0.0536895171));
        r1.xyz = r1.xyz + -r0.www;
        r1.xyz = r1.xyz * float3(0.959999979, 0.959999979, 0.959999979) + r0.www;
        r7.xyz = cmp(float3(0, 0, 0) >= r1.xyz);
        r1.xyz = log2(r1.xyz);
        r1.xyz = r7.xyz ? float3(-14, -14, -14) : r1.xyz;
        r7.xyz = cmp(float3(-17.4739323, -17.4739323, -17.4739323) >= r1.xyz);
        if (r7.x != 0) {
          r0.w = -4;
        } else {
          r1.w = cmp(-17.4739323 < r1.x);
          r2.w = cmp(r1.x < -2.47393107);
          r1.w = r1.w ? r2.w : 0;
          if (r1.w != 0) {
            r1.w = r1.x * 0.30103001 + 5.26017761;
            r2.w = 0.664385557 * r1.w;
            r3.w = (int)r2.w;
            r2.w = trunc(r2.w);
            r8.y = r1.w * 0.664385557 + -r2.w;
            r7.xw = (int2)r3.ww + int2(1, 2);
            r8.x = r8.y * r8.y;
            r9.x = icb[r3.w + 0].x;
            r9.y = icb[r7.x + 0].x;
            r9.z = icb[r7.w + 0].x;
            r10.x = dot(r9.xzy, float3(0.5, 0.5, -1));
            r10.y = dot(r9.xy, float2(-1, 1));
            r10.z = dot(r9.xy, float2(0.5, 0.5));
            r8.z = 1;
            r0.w = dot(r8.xyz, r10.xyz);
          } else {
            r1.w = cmp(r1.x >= -2.47393107);
            r2.w = cmp(r1.x < 15.5260687);
            r1.w = r1.w ? r2.w : 0;
            if (r1.w != 0) {
              r1.x = r1.x * 0.30103001 + 0.744727492;
              r1.w = 0.553654671 * r1.x;
              r2.w = (int)r1.w;
              r1.w = trunc(r1.w);
              r8.y = r1.x * 0.553654671 + -r1.w;
              r1.xw = (int2)r2.ww + int2(1, 2);
              r8.x = r8.y * r8.y;
              r9.x = icb[r2.w + 0].y;
              r9.y = icb[r1.x + 0].y;
              r9.z = icb[r1.w + 0].y;
              r10.x = dot(r9.xzy, float3(0.5, 0.5, -1));
              r10.y = dot(r9.xy, float2(-1, 1));
              r10.z = dot(r9.xy, float2(0.5, 0.5));
              r8.z = 1;
              r0.w = dot(r8.xyz, r10.xyz);
            } else {
              r0.w = 4;
            }
          }
        }
        r0.w = 3.32192802 * r0.w;
        r8.x = exp2(r0.w);
        if (r7.y != 0) {
          r0.w = -4;
        } else {
          r1.x = cmp(-17.4739323 < r1.y);
          r1.w = cmp(r1.y < -2.47393107);
          r1.x = r1.w ? r1.x : 0;
          if (r1.x != 0) {
            r1.x = r1.y * 0.30103001 + 5.26017761;
            r1.w = 0.664385557 * r1.x;
            r2.w = (int)r1.w;
            r1.w = trunc(r1.w);
            r9.y = r1.x * 0.664385557 + -r1.w;
            r1.xw = (int2)r2.ww + int2(1, 2);
            r9.x = r9.y * r9.y;
            r10.x = icb[r2.w + 0].x;
            r10.y = icb[r1.x + 0].x;
            r10.z = icb[r1.w + 0].x;
            r11.x = dot(r10.xzy, float3(0.5, 0.5, -1));
            r11.y = dot(r10.xy, float2(-1, 1));
            r11.z = dot(r10.xy, float2(0.5, 0.5));
            r9.z = 1;
            r0.w = dot(r9.xyz, r11.xyz);
          } else {
            r1.x = cmp(r1.y >= -2.47393107);
            r1.w = cmp(r1.y < 15.5260687);
            r1.x = r1.w ? r1.x : 0;
            if (r1.x != 0) {
              r1.x = r1.y * 0.30103001 + 0.744727492;
              r1.y = 0.553654671 * r1.x;
              r1.w = (int)r1.y;
              r1.y = trunc(r1.y);
              r9.y = r1.x * 0.553654671 + -r1.y;
              r1.xy = (int2)r1.ww + int2(1, 2);
              r9.x = r9.y * r9.y;
              r10.x = icb[r1.w + 0].y;
              r10.y = icb[r1.x + 0].y;
              r10.z = icb[r1.y + 0].y;
              r11.x = dot(r10.xzy, float3(0.5, 0.5, -1));
              r11.y = dot(r10.xy, float2(-1, 1));
              r11.z = dot(r10.xy, float2(0.5, 0.5));
              r9.z = 1;
              r0.w = dot(r9.xyz, r11.xyz);
            } else {
              r0.w = 4;
            }
          }
        }
        r0.w = 3.32192802 * r0.w;
        r8.y = exp2(r0.w);
        if (r7.z != 0) {
          r0.w = -4;
        } else {
          r1.x = cmp(-17.4739323 < r1.z);
          r1.y = cmp(r1.z < -2.47393107);
          r1.x = r1.y ? r1.x : 0;
          if (r1.x != 0) {
            r1.x = r1.z * 0.30103001 + 5.26017761;
            r1.y = 0.664385557 * r1.x;
            r1.w = (int)r1.y;
            r1.y = trunc(r1.y);
            r7.y = r1.x * 0.664385557 + -r1.y;
            r1.xy = (int2)r1.ww + int2(1, 2);
            r7.x = r7.y * r7.y;
            r9.x = icb[r1.w + 0].x;
            r9.y = icb[r1.x + 0].x;
            r9.z = icb[r1.y + 0].x;
            r10.x = dot(r9.xzy, float3(0.5, 0.5, -1));
            r10.y = dot(r9.xy, float2(-1, 1));
            r10.z = dot(r9.xy, float2(0.5, 0.5));
            r7.z = 1;
            r0.w = dot(r7.xyz, r10.xyz);
          } else {
            r1.x = cmp(r1.z >= -2.47393107);
            r1.y = cmp(r1.z < 15.5260687);
            r1.x = r1.y ? r1.x : 0;
            if (r1.x != 0) {
              r1.x = r1.z * 0.30103001 + 0.744727492;
              r1.y = 0.553654671 * r1.x;
              r1.z = (int)r1.y;
              r1.y = trunc(r1.y);
              r7.y = r1.x * 0.553654671 + -r1.y;
              r1.xy = (int2)r1.zz + int2(1, 2);
              r7.x = r7.y * r7.y;
              r9.x = icb[r1.z + 0].y;
              r9.y = icb[r1.x + 0].y;
              r9.z = icb[r1.y + 0].y;
              r1.x = dot(r9.xzy, float3(0.5, 0.5, -1));
              r1.y = dot(r9.xy, float2(-1, 1));
              r1.z = dot(r9.xy, float2(0.5, 0.5));
              r7.z = 1;
              r0.w = dot(r7.xyz, r1.xyz);
            } else {
              r0.w = 4;
            }
          }
        }
        r0.w = 3.32192802 * r0.w;
        r8.z = exp2(r0.w);
        r1.x = dot(float3(0.695452213, 0.140678704, 0.163869068), r8.xyz);
        r1.y = dot(float3(0.0447945632, 0.859671116, 0.0955343172), r8.xyz);
        r1.z = dot(float3(-0.00552588282, 0.00402521016, 1.00150073), r8.xyz);
        r0.w = dot(float3(1.45143926, -0.236510754, -0.214928567), r1.xyz);
        r1.w = dot(float3(-0.0765537769, 1.17622972, -0.0996759236), r1.xyz);
        r1.x = dot(float3(0.00831614807, -0.00603244966, 0.997716308), r1.xyz);
        r1.y = cmp(0 >= r0.w);
        r0.w = log2(r0.w);
        r0.w = r1.y ? -13.2877121 : r0.w;
        r1.y = cmp(-12.7838678 >= r0.w);
        if (r1.y != 0) {
          r1.y = r0.w * 0.90309 + 7.54498291;
        } else {
          r1.z = cmp(-12.7838678 < r0.w);
          r2.w = cmp(r0.w < 2.26303458);
          r1.z = r1.z ? r2.w : 0;
          if (r1.z != 0) {
            r1.z = r0.w * 0.30103001 + 3.84832764;
            r2.w = 1.54540098 * r1.z;
            r3.w = (int)r2.w;
            r2.w = trunc(r2.w);
            r7.y = r1.z * 1.54540098 + -r2.w;
            r8.xy = (int2)r3.ww + int2(1, 2);
            r7.x = r7.y * r7.y;
            r9.x = icb[r3.w + 0].z;
            r9.y = icb[r8.x + 0].z;
            r9.z = icb[r8.y + 0].z;
            r8.x = dot(r9.xzy, float3(0.5, 0.5, -1));
            r8.y = dot(r9.xy, float2(-1, 1));
            r8.z = dot(r9.xy, float2(0.5, 0.5));
            r7.z = 1;
            r1.y = dot(r7.xyz, r8.xyz);
          } else {
            r1.z = cmp(r0.w >= 2.26303458);
            r2.w = cmp(r0.w < 12.1373367);
            r1.z = r1.z ? r2.w : 0;
            if (r1.z != 0) {
              r1.z = r0.w * 0.30103001 + -0.681241274;
              r2.w = 2.3549509 * r1.z;
              r3.w = (int)r2.w;
              r2.w = trunc(r2.w);
              r7.y = r1.z * 2.3549509 + -r2.w;
              r8.xy = (int2)r3.ww + int2(1, 2);
              r7.x = r7.y * r7.y;
              r9.x = icb[r3.w + 0].w;
              r9.y = icb[r8.x + 0].w;
              r9.z = icb[r8.y + 0].w;
              r8.x = dot(r9.xzy, float3(0.5, 0.5, -1));
              r8.y = dot(r9.xy, float2(-1, 1));
              r8.z = dot(r9.xy, float2(0.5, 0.5));
              r7.z = 1;
              r1.y = dot(r7.xyz, r8.xyz);
            } else {
              r1.y = r0.w * 0.0180617999 + 2.78077793;
            }
          }
        }
        r0.w = 3.32192802 * r1.y;
        r7.x = exp2(r0.w);
        r0.w = cmp(0 >= r1.w);
        r1.y = log2(r1.w);
        r0.w = r0.w ? -13.2877121 : r1.y;
        r1.y = cmp(-12.7838678 >= r0.w);
        if (r1.y != 0) {
          r1.y = r0.w * 0.90309 + 7.54498291;
        } else {
          r1.z = cmp(-12.7838678 < r0.w);
          r1.w = cmp(r0.w < 2.26303458);
          r1.z = r1.w ? r1.z : 0;
          if (r1.z != 0) {
            r1.z = r0.w * 0.30103001 + 3.84832764;
            r1.w = 1.54540098 * r1.z;
            r2.w = (int)r1.w;
            r1.w = trunc(r1.w);
            r8.y = r1.z * 1.54540098 + -r1.w;
            r1.zw = (int2)r2.ww + int2(1, 2);
            r8.x = r8.y * r8.y;
            r9.x = icb[r2.w + 0].z;
            r9.y = icb[r1.z + 0].z;
            r9.z = icb[r1.w + 0].z;
            r10.x = dot(r9.xzy, float3(0.5, 0.5, -1));
            r10.y = dot(r9.xy, float2(-1, 1));
            r10.z = dot(r9.xy, float2(0.5, 0.5));
            r8.z = 1;
            r1.y = dot(r8.xyz, r10.xyz);
          } else {
            r1.z = cmp(r0.w >= 2.26303458);
            r1.w = cmp(r0.w < 12.1373367);
            r1.z = r1.w ? r1.z : 0;
            if (r1.z != 0) {
              r1.z = r0.w * 0.30103001 + -0.681241274;
              r1.w = 2.3549509 * r1.z;
              r2.w = (int)r1.w;
              r1.w = trunc(r1.w);
              r8.y = r1.z * 2.3549509 + -r1.w;
              r1.zw = (int2)r2.ww + int2(1, 2);
              r8.x = r8.y * r8.y;
              r9.x = icb[r2.w + 0].w;
              r9.y = icb[r1.z + 0].w;
              r9.z = icb[r1.w + 0].w;
              r10.x = dot(r9.xzy, float3(0.5, 0.5, -1));
              r10.y = dot(r9.xy, float2(-1, 1));
              r10.z = dot(r9.xy, float2(0.5, 0.5));
              r8.z = 1;
              r1.y = dot(r8.xyz, r10.xyz);
            } else {
              r1.y = r0.w * 0.0180617999 + 2.78077793;
            }
          }
        }
        r0.w = 3.32192802 * r1.y;
        r7.y = exp2(r0.w);
        r0.w = cmp(0 >= r1.x);
        r1.x = log2(r1.x);
        r0.w = r0.w ? -13.2877121 : r1.x;
        r1.x = cmp(-12.7838678 >= r0.w);
        if (r1.x != 0) {
          r1.x = r0.w * 0.90309 + 7.54498291;
        } else {
          r1.y = cmp(-12.7838678 < r0.w);
          r1.z = cmp(r0.w < 2.26303458);
          r1.y = r1.z ? r1.y : 0;
          if (r1.y != 0) {
            r1.y = r0.w * 0.30103001 + 3.84832764;
            r1.z = 1.54540098 * r1.y;
            r1.w = (int)r1.z;
            r1.z = trunc(r1.z);
            r8.y = r1.y * 1.54540098 + -r1.z;
            r1.yz = (int2)r1.ww + int2(1, 2);
            r8.x = r8.y * r8.y;
            r9.x = icb[r1.w + 0].z;
            r9.y = icb[r1.y + 0].z;
            r9.z = icb[r1.z + 0].z;
            r10.x = dot(r9.xzy, float3(0.5, 0.5, -1));
            r10.y = dot(r9.xy, float2(-1, 1));
            r10.z = dot(r9.xy, float2(0.5, 0.5));
            r8.z = 1;
            r1.x = dot(r8.xyz, r10.xyz);
          } else {
            r1.y = cmp(r0.w >= 2.26303458);
            r1.z = cmp(r0.w < 12.1373367);
            r1.y = r1.z ? r1.y : 0;
            if (r1.y != 0) {
              r1.y = r0.w * 0.30103001 + -0.681241274;
              r1.z = 2.3549509 * r1.y;
              r1.w = (int)r1.z;
              r1.z = trunc(r1.z);
              r8.y = r1.y * 2.3549509 + -r1.z;
              r1.yz = (int2)r1.ww + int2(1, 2);
              r8.x = r8.y * r8.y;
              r9.x = icb[r1.w + 0].w;
              r9.y = icb[r1.y + 0].w;
              r9.z = icb[r1.z + 0].w;
              r10.x = dot(r9.xzy, float3(0.5, 0.5, -1));
              r10.y = dot(r9.xy, float2(-1, 1));
              r10.z = dot(r9.xy, float2(0.5, 0.5));
              r8.z = 1;
              r1.x = dot(r8.xyz, r10.xyz);
            } else {
              r1.x = r0.w * 0.0180617999 + 2.78077793;
            }
          }
        }
        r0.w = 3.32192802 * r1.x;
        r7.z = exp2(r0.w);
        r1.xyz = float3(-3.50738446e-05, -3.50738446e-05, -3.50738446e-05) + r7.xyz;
        r7.x = dot(r5.xyz, r1.xyz);
        r7.y = dot(r6.xyz, r1.xyz);
        r7.z = dot(r4.xyz, r1.xyz);
        r1.xyz = float3(9.99999975e-05, 9.99999975e-05, 9.99999975e-05) * r7.xyz;
        r1.xyz = log2(r1.xyz);
        r1.xyz = float3(0.159301758, 0.159301758, 0.159301758) * r1.xyz;
        r1.xyz = exp2(r1.xyz);
        r7.xyz = r1.xyz * float3(18.8515625, 18.8515625, 18.8515625) + float3(0.8359375, 0.8359375, 0.8359375);
        r1.xyz = r1.xyz * float3(18.6875, 18.6875, 18.6875) + float3(1, 1, 1);
        r1.xyz = rcp(r1.xyz);
        r1.xyz = r7.xyz * r1.xyz;
        r1.xyz = log2(r1.xyz);
        r1.xyz = float3(78.84375, 78.84375, 78.84375) * r1.xyz;
        r2.xyz = exp2(r1.xyz);
      } else {
        r1.xy = cmp(asint(cb0[65].zz) == int2(4, 6));
        r0.w = (int)r1.y | (int)r1.x;
        if (r0.w != 0) {
          r1.xyz = float3(1.5, 1.5, 1.5) * r2.xyz;
          r7.y = dot(float3(0.439700812, 0.382978052, 0.1773348), r1.xyz);
          r7.z = dot(float3(0.0897923037, 0.813423157, 0.096761629), r1.xyz);
          r7.w = dot(float3(0.0175439864, 0.111544058, 0.870704114), r1.xyz);
          r0.w = min(r7.y, r7.z);
          r0.w = min(r0.w, r7.w);
          r1.x = max(r7.y, r7.z);
          r1.x = max(r1.x, r7.w);
          r1.xy = max(float2(1.00000001e-10, 0.00999999978), r1.xx);
          r0.w = max(1.00000001e-10, r0.w);
          r0.w = r1.x + -r0.w;
          r0.w = r0.w / r1.y;
          r1.xyz = r7.wzy + -r7.zyw;
          r1.xy = r7.wz * r1.xy;
          r1.x = r1.x + r1.y;
          r1.x = r7.y * r1.z + r1.x;
          r1.x = sqrt(r1.x);
          r1.y = r7.w + r7.z;
          r1.y = r1.y + r7.y;
          r1.x = r1.x * 1.75 + r1.y;
          r1.z = -0.400000006 + r0.w;
          r1.yw = float2(0.333333343, 2.5) * r1.xz;
          r1.w = 1 + -abs(r1.w);
          r1.w = max(0, r1.w);
          r2.w = cmp(0 < r1.z);
          r1.z = cmp(r1.z < 0);
          r1.z = (int)-r2.w + (int)r1.z;
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
          r8.yzw = r7.yzw * r1.xxx;
          r1.yz = cmp(r8.zw == r8.yz);
          r1.y = r1.z ? r1.y : 0;
          r1.z = r7.z * r1.x + -r8.w;
          r1.z = 1.73205078 * r1.z;
          r1.w = r8.y * 2 + -r8.z;
          r1.w = -r7.w * r1.x + r1.w;
          r2.w = min(abs(r1.z), abs(r1.w));
          r3.w = max(abs(r1.z), abs(r1.w));
          r3.w = 1 / r3.w;
          r2.w = r3.w * r2.w;
          r3.w = r2.w * r2.w;
          r4.w = r3.w * 0.0208350997 + -0.0851330012;
          r4.w = r3.w * r4.w + 0.180141002;
          r4.w = r3.w * r4.w + -0.330299497;
          r3.w = r3.w * r4.w + 0.999866009;
          r4.w = r3.w * r2.w;
          r5.w = cmp(abs(r1.w) < abs(r1.z));
          r4.w = r4.w * -2 + 1.57079637;
          r4.w = r5.w ? r4.w : 0;
          r2.w = r2.w * r3.w + r4.w;
          r3.w = cmp(r1.w < -r1.w);
          r3.w = r3.w ? -3.141593 : 0;
          r2.w = r3.w + r2.w;
          r3.w = min(r1.z, r1.w);
          r1.z = max(r1.z, r1.w);
          r1.w = cmp(r3.w < -r3.w);
          r1.z = cmp(r1.z >= -r1.z);
          r1.z = r1.z ? r1.w : 0;
          r1.z = r1.z ? -r2.w : r2.w;
          r1.z = 57.2957802 * r1.z;
          r1.y = r1.y ? 0 : r1.z;
          r1.z = cmp(r1.y < 0);
          r1.w = 360 + r1.y;
          r1.y = r1.z ? r1.w : r1.y;
          r1.y = max(0, r1.y);
          r1.y = min(360, r1.y);
          r1.z = cmp(180 < r1.y);
          r1.w = -360 + r1.y;
          r1.y = r1.z ? r1.w : r1.y;
          r1.z = cmp(-67.5 < r1.y);
          r1.w = cmp(r1.y < 67.5);
          r1.z = r1.w ? r1.z : 0;
          if (r1.z != 0) {
            r1.y = 67.5 + r1.y;
            r1.z = 0.0296296291 * r1.y;
            r1.w = (int)r1.z;
            r1.z = trunc(r1.z);
            r1.y = r1.y * 0.0296296291 + -r1.z;
            r1.z = r1.y * r1.y;
            r2.w = r1.z * r1.y;
            r7.xzw = float3(-0.166666672, -0.5, 0.166666672) * r2.www;
            r7.xz = r1.zz * float2(0.5, 0.5) + r7.xz;
            r7.xz = r1.yy * float2(-0.5, 0.5) + r7.xz;
            r1.y = r2.w * 0.5 + -r1.z;
            r1.y = 0.666666687 + r1.y;
            r9.xyz = cmp((int3)r1.www == int3(3, 2, 1));
            r7.xz = float2(0.166666672, 0.166666672) + r7.xz;
            r1.z = r1.w ? 0 : r7.w;
            r1.z = r9.z ? r7.z : r1.z;
            r1.y = r9.y ? r1.y : r1.z;
            r1.y = r9.x ? r7.x : r1.y;
          } else {
            r1.y = 0;
          }
          r0.w = r1.y * r0.w;
          r0.w = 1.5 * r0.w;
          r1.x = -r7.y * r1.x + 0.0299999993;
          r0.w = r1.x * r0.w;
          r8.x = r0.w * 0.180000007 + r8.y;
          r1.xyz = max(float3(0, 0, 0), r8.xzw);
          r1.xyz = min(float3(65535, 65535, 65535), r1.xyz);
          r7.x = dot(float3(1.45143926, -0.236510754, -0.214928567), r1.xyz);
          r7.y = dot(float3(-0.0765537769, 1.17622972, -0.0996759236), r1.xyz);
          r7.z = dot(float3(0.00831614807, -0.00603244966, 0.997716308), r1.xyz);
          r1.xyz = max(float3(0, 0, 0), r7.xyz);
          r1.xyz = min(float3(65535, 65535, 65535), r1.xyz);
          r0.w = dot(r1.xyz, float3(0.272228718, 0.674081743, 0.0536895171));
          r1.xyz = r1.xyz + -r0.www;
          r1.xyz = r1.xyz * float3(0.959999979, 0.959999979, 0.959999979) + r0.www;
          r7.xyz = cmp(float3(0, 0, 0) >= r1.xyz);
          r1.xyz = log2(r1.xyz);
          r1.xyz = r7.xyz ? float3(-14, -14, -14) : r1.xyz;
          r7.xyz = cmp(float3(-17.4739323, -17.4739323, -17.4739323) >= r1.xyz);
          if (r7.x != 0) {
            r0.w = -4;
          } else {
            r1.w = cmp(-17.4739323 < r1.x);
            r2.w = cmp(r1.x < -2.47393107);
            r1.w = r1.w ? r2.w : 0;
            if (r1.w != 0) {
              r1.w = r1.x * 0.30103001 + 5.26017761;
              r2.w = 0.664385557 * r1.w;
              r3.w = (int)r2.w;
              r2.w = trunc(r2.w);
              r8.y = r1.w * 0.664385557 + -r2.w;
              r7.xw = (int2)r3.ww + int2(1, 2);
              r8.x = r8.y * r8.y;
              r9.x = icb[r3.w + 0].x;
              r9.y = icb[r7.x + 0].x;
              r9.z = icb[r7.w + 0].x;
              r10.x = dot(r9.xzy, float3(0.5, 0.5, -1));
              r10.y = dot(r9.xy, float2(-1, 1));
              r10.z = dot(r9.xy, float2(0.5, 0.5));
              r8.z = 1;
              r0.w = dot(r8.xyz, r10.xyz);
            } else {
              r1.w = cmp(r1.x >= -2.47393107);
              r2.w = cmp(r1.x < 15.5260687);
              r1.w = r1.w ? r2.w : 0;
              if (r1.w != 0) {
                r1.x = r1.x * 0.30103001 + 0.744727492;
                r1.w = 0.553654671 * r1.x;
                r2.w = (int)r1.w;
                r1.w = trunc(r1.w);
                r8.y = r1.x * 0.553654671 + -r1.w;
                r1.xw = (int2)r2.ww + int2(1, 2);
                r8.x = r8.y * r8.y;
                r9.x = icb[r2.w + 0].y;
                r9.y = icb[r1.x + 0].y;
                r9.z = icb[r1.w + 0].y;
                r10.x = dot(r9.xzy, float3(0.5, 0.5, -1));
                r10.y = dot(r9.xy, float2(-1, 1));
                r10.z = dot(r9.xy, float2(0.5, 0.5));
                r8.z = 1;
                r0.w = dot(r8.xyz, r10.xyz);
              } else {
                r0.w = 4;
              }
            }
          }
          r0.w = 3.32192802 * r0.w;
          r8.x = exp2(r0.w);
          if (r7.y != 0) {
            r0.w = -4;
          } else {
            r1.x = cmp(-17.4739323 < r1.y);
            r1.w = cmp(r1.y < -2.47393107);
            r1.x = r1.w ? r1.x : 0;
            if (r1.x != 0) {
              r1.x = r1.y * 0.30103001 + 5.26017761;
              r1.w = 0.664385557 * r1.x;
              r2.w = (int)r1.w;
              r1.w = trunc(r1.w);
              r9.y = r1.x * 0.664385557 + -r1.w;
              r1.xw = (int2)r2.ww + int2(1, 2);
              r9.x = r9.y * r9.y;
              r10.x = icb[r2.w + 0].x;
              r10.y = icb[r1.x + 0].x;
              r10.z = icb[r1.w + 0].x;
              r11.x = dot(r10.xzy, float3(0.5, 0.5, -1));
              r11.y = dot(r10.xy, float2(-1, 1));
              r11.z = dot(r10.xy, float2(0.5, 0.5));
              r9.z = 1;
              r0.w = dot(r9.xyz, r11.xyz);
            } else {
              r1.x = cmp(r1.y >= -2.47393107);
              r1.w = cmp(r1.y < 15.5260687);
              r1.x = r1.w ? r1.x : 0;
              if (r1.x != 0) {
                r1.x = r1.y * 0.30103001 + 0.744727492;
                r1.y = 0.553654671 * r1.x;
                r1.w = (int)r1.y;
                r1.y = trunc(r1.y);
                r9.y = r1.x * 0.553654671 + -r1.y;
                r1.xy = (int2)r1.ww + int2(1, 2);
                r9.x = r9.y * r9.y;
                r10.x = icb[r1.w + 0].y;
                r10.y = icb[r1.x + 0].y;
                r10.z = icb[r1.y + 0].y;
                r11.x = dot(r10.xzy, float3(0.5, 0.5, -1));
                r11.y = dot(r10.xy, float2(-1, 1));
                r11.z = dot(r10.xy, float2(0.5, 0.5));
                r9.z = 1;
                r0.w = dot(r9.xyz, r11.xyz);
              } else {
                r0.w = 4;
              }
            }
          }
          r0.w = 3.32192802 * r0.w;
          r8.y = exp2(r0.w);
          if (r7.z != 0) {
            r0.w = -4;
          } else {
            r1.x = cmp(-17.4739323 < r1.z);
            r1.y = cmp(r1.z < -2.47393107);
            r1.x = r1.y ? r1.x : 0;
            if (r1.x != 0) {
              r1.x = r1.z * 0.30103001 + 5.26017761;
              r1.y = 0.664385557 * r1.x;
              r1.w = (int)r1.y;
              r1.y = trunc(r1.y);
              r7.y = r1.x * 0.664385557 + -r1.y;
              r1.xy = (int2)r1.ww + int2(1, 2);
              r7.x = r7.y * r7.y;
              r9.x = icb[r1.w + 0].x;
              r9.y = icb[r1.x + 0].x;
              r9.z = icb[r1.y + 0].x;
              r10.x = dot(r9.xzy, float3(0.5, 0.5, -1));
              r10.y = dot(r9.xy, float2(-1, 1));
              r10.z = dot(r9.xy, float2(0.5, 0.5));
              r7.z = 1;
              r0.w = dot(r7.xyz, r10.xyz);
            } else {
              r1.x = cmp(r1.z >= -2.47393107);
              r1.y = cmp(r1.z < 15.5260687);
              r1.x = r1.y ? r1.x : 0;
              if (r1.x != 0) {
                r1.x = r1.z * 0.30103001 + 0.744727492;
                r1.y = 0.553654671 * r1.x;
                r1.z = (int)r1.y;
                r1.y = trunc(r1.y);
                r7.y = r1.x * 0.553654671 + -r1.y;
                r1.xy = (int2)r1.zz + int2(1, 2);
                r7.x = r7.y * r7.y;
                r9.x = icb[r1.z + 0].y;
                r9.y = icb[r1.x + 0].y;
                r9.z = icb[r1.y + 0].y;
                r1.x = dot(r9.xzy, float3(0.5, 0.5, -1));
                r1.y = dot(r9.xy, float2(-1, 1));
                r1.z = dot(r9.xy, float2(0.5, 0.5));
                r7.z = 1;
                r0.w = dot(r7.xyz, r1.xyz);
              } else {
                r0.w = 4;
              }
            }
          }
          r0.w = 3.32192802 * r0.w;
          r8.z = exp2(r0.w);
          r1.x = dot(float3(0.695452213, 0.140678704, 0.163869068), r8.xyz);
          r1.y = dot(float3(0.0447945632, 0.859671116, 0.0955343172), r8.xyz);
          r1.z = dot(float3(-0.00552588282, 0.00402521016, 1.00150073), r8.xyz);
          r0.w = dot(float3(1.45143926, -0.236510754, -0.214928567), r1.xyz);
          r1.w = dot(float3(-0.0765537769, 1.17622972, -0.0996759236), r1.xyz);
          r1.x = dot(float3(0.00831614807, -0.00603244966, 0.997716308), r1.xyz);
          r1.y = cmp(0 >= r0.w);
          r0.w = log2(r0.w);
          r0.w = r1.y ? -13.2877121 : r0.w;
          r1.y = cmp(-12.7838678 >= r0.w);
          if (r1.y != 0) {
            r1.y = -2.30102992;
          } else {
            r1.z = cmp(-12.7838678 < r0.w);
            r2.w = cmp(r0.w < 2.26303458);
            r1.z = r1.z ? r2.w : 0;
            if (r1.z != 0) {
              r1.z = r0.w * 0.30103001 + 3.84832764;
              r2.w = 1.54540098 * r1.z;
              r3.w = (int)r2.w;
              r2.w = trunc(r2.w);
              r7.y = r1.z * 1.54540098 + -r2.w;
              r8.xy = (int2)r3.ww + int2(1, 2);
              r7.x = r7.y * r7.y;
              r9.x = icb[r3.w + 6].x;
              r9.y = icb[r8.x + 6].x;
              r9.z = icb[r8.y + 6].x;
              r8.x = dot(r9.xzy, float3(0.5, 0.5, -1));
              r8.y = dot(r9.xy, float2(-1, 1));
              r8.z = dot(r9.xy, float2(0.5, 0.5));
              r7.z = 1;
              r1.y = dot(r7.xyz, r8.xyz);
            } else {
              r1.z = cmp(r0.w >= 2.26303458);
              r2.w = cmp(r0.w < 12.4948215);
              r1.z = r1.z ? r2.w : 0;
              if (r1.z != 0) {
                r1.z = r0.w * 0.30103001 + -0.681241274;
                r2.w = 2.27267218 * r1.z;
                r3.w = (int)r2.w;
                r2.w = trunc(r2.w);
                r7.y = r1.z * 2.27267218 + -r2.w;
                r8.xy = (int2)r3.ww + int2(1, 2);
                r7.x = r7.y * r7.y;
                r9.x = icb[r3.w + 6].y;
                r9.y = icb[r8.x + 6].y;
                r9.z = icb[r8.y + 6].y;
                r8.x = dot(r9.xzy, float3(0.5, 0.5, -1));
                r8.y = dot(r9.xy, float2(-1, 1));
                r8.z = dot(r9.xy, float2(0.5, 0.5));
                r7.z = 1;
                r1.y = dot(r7.xyz, r8.xyz);
              } else {
                r1.y = r0.w * 0.0361235999 + 2.84967208;
              }
            }
          }
          r0.w = 3.32192802 * r1.y;
          r7.x = exp2(r0.w);
          r0.w = cmp(0 >= r1.w);
          r1.y = log2(r1.w);
          r0.w = r0.w ? -13.2877121 : r1.y;
          r1.y = cmp(-12.7838678 >= r0.w);
          if (r1.y != 0) {
            r1.y = -2.30102992;
          } else {
            r1.z = cmp(-12.7838678 < r0.w);
            r1.w = cmp(r0.w < 2.26303458);
            r1.z = r1.w ? r1.z : 0;
            if (r1.z != 0) {
              r1.z = r0.w * 0.30103001 + 3.84832764;
              r1.w = 1.54540098 * r1.z;
              r2.w = (int)r1.w;
              r1.w = trunc(r1.w);
              r8.y = r1.z * 1.54540098 + -r1.w;
              r1.zw = (int2)r2.ww + int2(1, 2);
              r8.x = r8.y * r8.y;
              r9.x = icb[r2.w + 6].x;
              r9.y = icb[r1.z + 6].x;
              r9.z = icb[r1.w + 6].x;
              r10.x = dot(r9.xzy, float3(0.5, 0.5, -1));
              r10.y = dot(r9.xy, float2(-1, 1));
              r10.z = dot(r9.xy, float2(0.5, 0.5));
              r8.z = 1;
              r1.y = dot(r8.xyz, r10.xyz);
            } else {
              r1.z = cmp(r0.w >= 2.26303458);
              r1.w = cmp(r0.w < 12.4948215);
              r1.z = r1.w ? r1.z : 0;
              if (r1.z != 0) {
                r1.z = r0.w * 0.30103001 + -0.681241274;
                r1.w = 2.27267218 * r1.z;
                r2.w = (int)r1.w;
                r1.w = trunc(r1.w);
                r8.y = r1.z * 2.27267218 + -r1.w;
                r1.zw = (int2)r2.ww + int2(1, 2);
                r8.x = r8.y * r8.y;
                r9.x = icb[r2.w + 6].y;
                r9.y = icb[r1.z + 6].y;
                r9.z = icb[r1.w + 6].y;
                r10.x = dot(r9.xzy, float3(0.5, 0.5, -1));
                r10.y = dot(r9.xy, float2(-1, 1));
                r10.z = dot(r9.xy, float2(0.5, 0.5));
                r8.z = 1;
                r1.y = dot(r8.xyz, r10.xyz);
              } else {
                r1.y = r0.w * 0.0361235999 + 2.84967208;
              }
            }
          }
          r0.w = 3.32192802 * r1.y;
          r7.y = exp2(r0.w);
          r0.w = cmp(0 >= r1.x);
          r1.x = log2(r1.x);
          r0.w = r0.w ? -13.2877121 : r1.x;
          r1.x = cmp(-12.7838678 >= r0.w);
          if (r1.x != 0) {
            r1.x = -2.30102992;
          } else {
            r1.y = cmp(-12.7838678 < r0.w);
            r1.z = cmp(r0.w < 2.26303458);
            r1.y = r1.z ? r1.y : 0;
            if (r1.y != 0) {
              r1.y = r0.w * 0.30103001 + 3.84832764;
              r1.z = 1.54540098 * r1.y;
              r1.w = (int)r1.z;
              r1.z = trunc(r1.z);
              r8.y = r1.y * 1.54540098 + -r1.z;
              r1.yz = (int2)r1.ww + int2(1, 2);
              r8.x = r8.y * r8.y;
              r9.x = icb[r1.w + 6].x;
              r9.y = icb[r1.y + 6].x;
              r9.z = icb[r1.z + 6].x;
              r10.x = dot(r9.xzy, float3(0.5, 0.5, -1));
              r10.y = dot(r9.xy, float2(-1, 1));
              r10.z = dot(r9.xy, float2(0.5, 0.5));
              r8.z = 1;
              r1.x = dot(r8.xyz, r10.xyz);
            } else {
              r1.y = cmp(r0.w >= 2.26303458);
              r1.z = cmp(r0.w < 12.4948215);
              r1.y = r1.z ? r1.y : 0;
              if (r1.y != 0) {
                r1.y = r0.w * 0.30103001 + -0.681241274;
                r1.z = 2.27267218 * r1.y;
                r1.w = (int)r1.z;
                r1.z = trunc(r1.z);
                r8.y = r1.y * 2.27267218 + -r1.z;
                r1.yz = (int2)r1.ww + int2(1, 2);
                r8.x = r8.y * r8.y;
                r9.x = icb[r1.w + 6].y;
                r9.y = icb[r1.y + 6].y;
                r9.z = icb[r1.z + 6].y;
                r10.x = dot(r9.xzy, float3(0.5, 0.5, -1));
                r10.y = dot(r9.xy, float2(-1, 1));
                r10.z = dot(r9.xy, float2(0.5, 0.5));
                r8.z = 1;
                r1.x = dot(r8.xyz, r10.xyz);
              } else {
                r1.x = r0.w * 0.0361235999 + 2.84967208;
              }
            }
          }
          r0.w = 3.32192802 * r1.x;
          r7.z = exp2(r0.w);
          r1.x = dot(r5.xyz, r7.xyz);
          r1.y = dot(r6.xyz, r7.xyz);
          r1.z = dot(r4.xyz, r7.xyz);
          r1.xyz = float3(9.99999975e-05, 9.99999975e-05, 9.99999975e-05) * r1.xyz;
          r1.xyz = log2(r1.xyz);
          r1.xyz = float3(0.159301758, 0.159301758, 0.159301758) * r1.xyz;
          r1.xyz = exp2(r1.xyz);
          r7.xyz = r1.xyz * float3(18.8515625, 18.8515625, 18.8515625) + float3(0.8359375, 0.8359375, 0.8359375);
          r1.xyz = r1.xyz * float3(18.6875, 18.6875, 18.6875) + float3(1, 1, 1);
          r1.xyz = rcp(r1.xyz);
          r1.xyz = r7.xyz * r1.xyz;
          r1.xyz = log2(r1.xyz);
          r1.xyz = float3(78.84375, 78.84375, 78.84375) * r1.xyz;
          r2.xyz = exp2(r1.xyz);
        } else {
          r0.w = cmp(asint(cb0[65].z) == 7);
          if (r0.w != 0) {
            r1.x = dot(float3(0.613191485, 0.33951208, 0.0473663323), r2.xyz);
            r1.y = dot(float3(0.0702069029, 0.916335821, 0.0134500116), r2.xyz);
            r1.z = dot(float3(0.0206188709, 0.109567292, 0.869606733), r2.xyz);
            r7.x = dot(r5.xyz, r1.xyz);
            r7.y = dot(r6.xyz, r1.xyz);
            r7.z = dot(r4.xyz, r1.xyz);
            r1.xyz = float3(9.99999975e-05, 9.99999975e-05, 9.99999975e-05) * r7.xyz;
            r1.xyz = log2(r1.xyz);
            r1.xyz = float3(0.159301758, 0.159301758, 0.159301758) * r1.xyz;
            r1.xyz = exp2(r1.xyz);
            r7.xyz = r1.xyz * float3(18.8515625, 18.8515625, 18.8515625) + float3(0.8359375, 0.8359375, 0.8359375);
            r1.xyz = r1.xyz * float3(18.6875, 18.6875, 18.6875) + float3(1, 1, 1);
            r1.xyz = rcp(r1.xyz);
            r1.xyz = r7.xyz * r1.xyz;
            r1.xyz = log2(r1.xyz);
            r1.xyz = float3(78.84375, 78.84375, 78.84375) * r1.xyz;
            r2.xyz = exp2(r1.xyz);
          } else {
            r0.w = cmp(asint(cb0[65].z) == 8);
            if (r0.w == 0) {
              r0.w = cmp(asint(cb0[65].z) == 9);
              if (r0.w != 0) {
                r1.x = dot(float3(0.613191485, 0.33951208, 0.0473663323), r0.xyz);
                r1.y = dot(float3(0.0702069029, 0.916335821, 0.0134500116), r0.xyz);
                r1.z = dot(float3(0.0206188709, 0.109567292, 0.869606733), r0.xyz);
                r2.x = dot(r5.xyz, r1.xyz);
                r2.y = dot(r6.xyz, r1.xyz);
                r2.z = dot(r4.xyz, r1.xyz);
              } else {
                r0.x = cmp(asint(cb0[65].z) == 10);
                if (r0.x != 0) {
                  r0.xyz = cb0[66].www * r2.xyz;
                  r1.y = dot(float3(0.439700812, 0.382978052, 0.1773348), r0.xyz);
                  r1.z = dot(float3(0.0897923037, 0.813423157, 0.096761629), r0.xyz);
                  r1.w = dot(float3(0.0175439864, 0.111544058, 0.870704114), r0.xyz);
                  r0.x = min(r1.y, r1.z);
                  r0.x = min(r0.x, r1.w);
                  r0.y = max(r1.y, r1.z);
                  r0.y = max(r0.y, r1.w);
                  r0.xyz = max(float3(1.00000001e-10, 1.00000001e-10, 0.00999999978), r0.xyy);
                  r0.x = r0.y + -r0.x;
                  r0.x = r0.x / r0.z;
                  r0.yzw = r1.wzy + -r1.zyw;
                  r0.yz = r1.wz * r0.yz;
                  r0.y = r0.y + r0.z;
                  r0.y = r1.y * r0.w + r0.y;
                  r0.y = sqrt(r0.y);
                  r0.z = r1.w + r1.z;
                  r0.z = r0.z + r1.y;
                  r0.y = r0.y * 1.75 + r0.z;
                  r0.w = -0.400000006 + r0.x;
                  r1.x = 2.5 * r0.w;
                  r1.x = 1 + -abs(r1.x);
                  r1.x = max(0, r1.x);
                  r2.w = cmp(0 < r0.w);
                  r0.w = cmp(r0.w < 0);
                  r0.w = (int)-r2.w + (int)r0.w;
                  r0.w = (int)r0.w;
                  r1.x = -r1.x * r1.x + 1;
                  r0.w = r0.w * r1.x + 1;
                  r0.zw = float2(0.333333343, 0.0250000004) * r0.yw;
                  r1.x = cmp(0.159999996 >= r0.y);
                  r0.y = cmp(r0.y >= 0.479999989);
                  r0.z = 0.0799999982 / r0.z;
                  r0.z = -0.5 + r0.z;
                  r0.z = r0.w * r0.z;
                  r0.y = r0.y ? 0 : r0.z;
                  r0.y = r1.x ? r0.w : r0.y;
                  r0.y = 1 + r0.y;
                  r7.yzw = r1.yzw * r0.yyy;
                  r0.zw = cmp(r7.zw == r7.yz);
                  r0.z = r0.w ? r0.z : 0;
                  r0.w = r1.z * r0.y + -r7.w;
                  r0.w = 1.73205078 * r0.w;
                  r1.x = r7.y * 2 + -r7.z;
                  r1.x = -r1.w * r0.y + r1.x;
                  r1.z = min(abs(r1.x), abs(r0.w));
                  r1.w = max(abs(r1.x), abs(r0.w));
                  r1.w = 1 / r1.w;
                  r1.z = r1.z * r1.w;
                  r1.w = r1.z * r1.z;
                  r2.w = r1.w * 0.0208350997 + -0.0851330012;
                  r2.w = r1.w * r2.w + 0.180141002;
                  r2.w = r1.w * r2.w + -0.330299497;
                  r1.w = r1.w * r2.w + 0.999866009;
                  r2.w = r1.z * r1.w;
                  r3.w = cmp(abs(r1.x) < abs(r0.w));
                  r2.w = r2.w * -2 + 1.57079637;
                  r2.w = r3.w ? r2.w : 0;
                  r1.z = r1.z * r1.w + r2.w;
                  r1.w = cmp(r1.x < -r1.x);
                  r1.w = r1.w ? -3.141593 : 0;
                  r1.z = r1.z + r1.w;
                  r1.w = min(r1.x, r0.w);
                  r0.w = max(r1.x, r0.w);
                  r1.x = cmp(r1.w < -r1.w);
                  r0.w = cmp(r0.w >= -r0.w);
                  r0.w = r0.w ? r1.x : 0;
                  r0.w = r0.w ? -r1.z : r1.z;
                  r0.w = 57.2957802 * r0.w;
                  r0.z = r0.z ? 0 : r0.w;
                  r0.w = cmp(r0.z < 0);
                  r1.x = 360 + r0.z;
                  r0.z = r0.w ? r1.x : r0.z;
                  r0.z = max(0, r0.z);
                  r0.z = min(360, r0.z);
                  r0.w = cmp(180 < r0.z);
                  r1.x = -360 + r0.z;
                  r0.z = r0.w ? r1.x : r0.z;
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
                    r1.z = r0.w * r0.z;
                    r8.xyz = float3(-0.166666672, -0.5, 0.166666672) * r1.zzz;
                    r8.xy = r0.ww * float2(0.5, 0.5) + r8.xy;
                    r8.xy = r0.zz * float2(-0.5, 0.5) + r8.xy;
                    r0.z = r1.z * 0.5 + -r0.w;
                    r0.z = 0.666666687 + r0.z;
                    r9.xyz = cmp((int3)r1.xxx == int3(3, 2, 1));
                    r1.zw = float2(0.166666672, 0.166666672) + r8.xy;
                    r0.w = r1.x ? 0 : r8.z;
                    r0.w = r9.z ? r1.w : r0.w;
                    r0.z = r9.y ? r0.z : r0.w;
                    r0.z = r9.x ? r1.z : r0.z;
                  } else {
                    r0.z = 0;
                  }
                  r0.x = r0.z * r0.x;
                  r0.x = 1.5 * r0.x;
                  r0.y = -r1.y * r0.y + 0.0299999993;
                  r0.x = r0.x * r0.y;
                  r7.x = r0.x * 0.180000007 + r7.y;
                  r0.xyz = max(float3(0, 0, 0), r7.xzw);
                  r0.xyz = min(float3(65535, 65535, 65535), r0.xyz);
                  r1.x = dot(float3(1.45143926, -0.236510754, -0.214928567), r0.xyz);
                  r1.y = dot(float3(-0.0765537769, 1.17622972, -0.0996759236), r0.xyz);
                  r1.z = dot(float3(0.00831614807, -0.00603244966, 0.997716308), r0.xyz);
                  r0.xyz = max(float3(0, 0, 0), r1.xyz);
                  r0.xyz = min(float3(65535, 65535, 65535), r0.xyz);
                  r0.w = dot(r0.xyz, float3(0.272228718, 0.674081743, 0.0536895171));
                  r0.xyz = r0.xyz + -r0.www;
                  r0.xyz = r0.xyz * float3(0.959999979, 0.959999979, 0.959999979) + r0.www;
                  r1.xyz = cmp(float3(0, 0, 0) >= r0.xyz);
                  r0.xyz = log2(r0.xyz);
                  r0.xyz = r1.xyz ? float3(-14, -14, -14) : r0.xyz;
                  r1.xyz = cmp(float3(-17.4739323, -17.4739323, -17.4739323) >= r0.xyz);
                  if (r1.x != 0) {
                    r0.w = -4;
                  } else {
                    r1.x = cmp(-17.4739323 < r0.x);
                    r1.w = cmp(r0.x < -2.47393107);
                    r1.x = r1.w ? r1.x : 0;
                    if (r1.x != 0) {
                      r1.x = r0.x * 0.30103001 + 5.26017761;
                      r1.w = 0.664385557 * r1.x;
                      r2.w = (int)r1.w;
                      r1.w = trunc(r1.w);
                      r7.y = r1.x * 0.664385557 + -r1.w;
                      r1.xw = (int2)r2.ww + int2(1, 2);
                      r7.x = r7.y * r7.y;
                      r8.x = icb[r2.w + 0].x;
                      r8.y = icb[r1.x + 0].x;
                      r8.z = icb[r1.w + 0].x;
                      r9.x = dot(r8.xzy, float3(0.5, 0.5, -1));
                      r9.y = dot(r8.xy, float2(-1, 1));
                      r9.z = dot(r8.xy, float2(0.5, 0.5));
                      r7.z = 1;
                      r0.w = dot(r7.xyz, r9.xyz);
                    } else {
                      r1.x = cmp(r0.x >= -2.47393107);
                      r1.w = cmp(r0.x < 15.5260687);
                      r1.x = r1.w ? r1.x : 0;
                      if (r1.x != 0) {
                        r0.x = r0.x * 0.30103001 + 0.744727492;
                        r1.x = 0.553654671 * r0.x;
                        r1.w = (int)r1.x;
                        r1.x = trunc(r1.x);
                        r7.y = r0.x * 0.553654671 + -r1.x;
                        r8.xy = (int2)r1.ww + int2(1, 2);
                        r7.x = r7.y * r7.y;
                        r9.x = icb[r1.w + 0].y;
                        r9.y = icb[r8.x + 0].y;
                        r9.z = icb[r8.y + 0].y;
                        r8.x = dot(r9.xzy, float3(0.5, 0.5, -1));
                        r8.y = dot(r9.xy, float2(-1, 1));
                        r8.z = dot(r9.xy, float2(0.5, 0.5));
                        r7.z = 1;
                        r0.w = dot(r7.xyz, r8.xyz);
                      } else {
                        r0.w = 4;
                      }
                    }
                  }
                  r0.x = 3.32192802 * r0.w;
                  r7.x = exp2(r0.x);
                  if (r1.y != 0) {
                    r0.x = -4;
                  } else {
                    r0.w = cmp(-17.4739323 < r0.y);
                    r1.x = cmp(r0.y < -2.47393107);
                    r0.w = r0.w ? r1.x : 0;
                    if (r0.w != 0) {
                      r0.w = r0.y * 0.30103001 + 5.26017761;
                      r1.x = 0.664385557 * r0.w;
                      r1.y = (int)r1.x;
                      r1.x = trunc(r1.x);
                      r8.y = r0.w * 0.664385557 + -r1.x;
                      r1.xw = (int2)r1.yy + int2(1, 2);
                      r8.x = r8.y * r8.y;
                      r9.x = icb[r1.y + 0].x;
                      r9.y = icb[r1.x + 0].x;
                      r9.z = icb[r1.w + 0].x;
                      r10.x = dot(r9.xzy, float3(0.5, 0.5, -1));
                      r10.y = dot(r9.xy, float2(-1, 1));
                      r10.z = dot(r9.xy, float2(0.5, 0.5));
                      r8.z = 1;
                      r0.x = dot(r8.xyz, r10.xyz);
                    } else {
                      r0.w = cmp(r0.y >= -2.47393107);
                      r1.x = cmp(r0.y < 15.5260687);
                      r0.w = r0.w ? r1.x : 0;
                      if (r0.w != 0) {
                        r0.y = r0.y * 0.30103001 + 0.744727492;
                        r0.w = 0.553654671 * r0.y;
                        r1.x = (int)r0.w;
                        r0.w = trunc(r0.w);
                        r8.y = r0.y * 0.553654671 + -r0.w;
                        r0.yw = (int2)r1.xx + int2(1, 2);
                        r8.x = r8.y * r8.y;
                        r9.x = icb[r1.x + 0].y;
                        r9.y = icb[r0.y + 0].y;
                        r9.z = icb[r0.w + 0].y;
                        r10.x = dot(r9.xzy, float3(0.5, 0.5, -1));
                        r10.y = dot(r9.xy, float2(-1, 1));
                        r10.z = dot(r9.xy, float2(0.5, 0.5));
                        r8.z = 1;
                        r0.x = dot(r8.xyz, r10.xyz);
                      } else {
                        r0.x = 4;
                      }
                    }
                  }
                  r0.x = 3.32192802 * r0.x;
                  r7.y = exp2(r0.x);
                  if (r1.z != 0) {
                    r0.x = -4;
                  } else {
                    r0.y = cmp(-17.4739323 < r0.z);
                    r0.w = cmp(r0.z < -2.47393107);
                    r0.y = r0.w ? r0.y : 0;
                    if (r0.y != 0) {
                      r0.y = r0.z * 0.30103001 + 5.26017761;
                      r0.w = 0.664385557 * r0.y;
                      r1.x = (int)r0.w;
                      r0.w = trunc(r0.w);
                      r8.y = r0.y * 0.664385557 + -r0.w;
                      r0.yw = (int2)r1.xx + int2(1, 2);
                      r8.x = r8.y * r8.y;
                      r1.x = icb[r1.x + 0].x;
                      r1.y = icb[r0.y + 0].x;
                      r1.z = icb[r0.w + 0].x;
                      r9.x = dot(r1.xzy, float3(0.5, 0.5, -1));
                      r9.y = dot(r1.xy, float2(-1, 1));
                      r9.z = dot(r1.xy, float2(0.5, 0.5));
                      r8.z = 1;
                      r0.x = dot(r8.xyz, r9.xyz);
                    } else {
                      r0.y = cmp(r0.z >= -2.47393107);
                      r0.w = cmp(r0.z < 15.5260687);
                      r0.y = r0.w ? r0.y : 0;
                      if (r0.y != 0) {
                        r0.y = r0.z * 0.30103001 + 0.744727492;
                        r0.z = 0.553654671 * r0.y;
                        r0.w = (int)r0.z;
                        r0.z = trunc(r0.z);
                        r1.y = r0.y * 0.553654671 + -r0.z;
                        r0.yz = (int2)r0.ww + int2(1, 2);
                        r1.x = r1.y * r1.y;
                        r8.x = icb[r0.w + 0].y;
                        r8.y = icb[r0.y + 0].y;
                        r8.z = icb[r0.z + 0].y;
                        r9.x = dot(r8.xzy, float3(0.5, 0.5, -1));
                        r9.y = dot(r8.xy, float2(-1, 1));
                        r9.z = dot(r8.xy, float2(0.5, 0.5));
                        r1.z = 1;
                        r0.x = dot(r1.xyz, r9.xyz);
                      } else {
                        r0.x = 4;
                      }
                    }
                  }
                  r0.x = 3.32192802 * r0.x;
                  r7.z = exp2(r0.x);
                  r0.x = dot(float3(0.695452213, 0.140678704, 0.163869068), r7.xyz);
                  r0.y = dot(float3(0.0447945632, 0.859671116, 0.0955343172), r7.xyz);
                  r0.z = dot(float3(-0.00552588282, 0.00402521016, 1.00150073), r7.xyz);
                  r1.x = dot(float3(1.51282358, -0.258981079, -0.229780421), r0.xyz);
                  r1.y = dot(float3(-0.0790363327, 1.17706418, -0.100755438), r0.xyz);
                  r1.z = dot(float3(0.00209150789, -0.0311482511, 0.953631222), r0.xyz);
                  r0.xyzw = float4(9.99999975e-05, 9.99999975e-05, 9.99999975e-05, 9.99999975e-05) * r1.xyyz;
                  r0.xyzw = max(float4(0, 0, 0, 0), r0.xyzw);
                  r0.xyzw = log2(r0.xyzw);
                  r0.xyzw = cb0[66].zzzz * r0.xyzw;
                  r0.xyzw = exp2(r0.xyzw);
                  if (cb0[67].y != 0) {
                    r1.xyzw = float4(1, 1, 1, 3333.33325) * r0.xzwx;
                    r1.w = min(1, r1.w);
                    r1.x = r1.w * -9.99999975e-05 + r1.x;
                    r1.w = log2(r1.x);
                    r1.w = 0.992999971 * r1.w;
                    r1.w = exp2(r1.w);
                    r2.w = max(0, r1.x);
                    r1.x = r1.x * r1.x;
                    r3.w = 5000 * r1.x;
                    r7.xyz = r0.xzw * float3(1, 1, 1) + float3(-0.00100000005, -0.00100000005, -0.00100000005);
                    r7.xyz = saturate(float3(166.666672, 166.666672, 166.666672) * r7.xyz);
                    r1.w = -r2.w + r1.w;
                    r1.w = r7.x * r1.w + r2.w;
                    r8.xyzw = float4(2500, 3333.33325, 2500, 3333.33325) * r0.xyzw;
                    r8.xyzw = min(float4(1, 1, 1, 1), r8.xyzw);
                    r0.y = -r1.x * 5000 + r1.w;
                    r9.x = r8.x * r0.y + r3.w;
                    r1.xy = r8.yw * float2(-9.99999975e-05, -9.99999975e-05) + r1.yz;
                    r1.zw = log2(r1.xy);
                    r1.zw = float2(0.992999971, 0.992999971) * r1.zw;
                    r1.zw = exp2(r1.zw);
                    r7.xw = max(float2(0, 0), r1.xy);
                    r1.xy = r1.xy * r1.xy;
                    r8.xy = float2(5000, 5000) * r1.xy;
                    r1.zw = -r7.xw + r1.zw;
                    r1.zw = r7.yz * r1.zw + r7.xw;
                    r1.xy = -r1.xy * float2(5000, 5000) + r1.zw;
                    r9.y = r8.z * r1.x + r8.x;
                    r0.y = 2500 * r0.w;
                    r0.y = min(1, r0.y);
                    r9.z = r0.y * r1.y + r8.y;
                    r1.xyz = float3(10000, 10000, 10000) * r9.xyz;
                  } else {
                    r1.xyz = float3(10000, 10000, 10000) * r0.xzw;
                  }
                  r0.xyz = float3(0.00333333341, 0.00333333341, 0.00333333341) * r1.xyz;
                  r7.xyz = cmp(r1.xyz < float3(45, 45, 45));
                  r1.xyz = r1.xyz * float3(0.00333333341, 0.00333333341, 0.00333333341) + float3(-0.150000006, -0.150000006, -0.150000006);
                  r1.xyz = float3(-1.69728816, -1.69728816, -1.69728816) * r1.xyz;
                  r1.xyz = exp2(r1.xyz);
                  r1.xyz = float3(1, 1, 1) + -r1.xyz;
                  r1.xyz = r1.xyz * float3(0.850000024, 0.850000024, 0.850000024) + float3(0.150000006, 0.150000006, 0.150000006);
                  r1.xyz = r7.xyz ? r0.xyz : r1.xyz;
                  r0.w = dot(r0.xyz, float3(0.262699991, 0.677999973, 0.0593000017));
                  r1.x = dot(r1.xyz, float3(0.262699991, 0.677999973, 0.0593000017));
                  r0.xyz = r1.xxx * r0.xyz;
                  r0.xyz = r0.xyz / r0.www;
                  r1.x = dot(r0.xyz, float3(0.262699991, 0.677999973, 0.0593000017));
                  r1.y = 0.200000003 * r0.w;
                  r1.z = cmp(r0.w < 2.5);
                  r0.w = r0.w * 0.200000003 + -0.5;
                  r0.w = -2.88539004 * r0.w;
                  r0.w = exp2(r0.w);
                  r0.w = 1 + -r0.w;
                  r0.w = r0.w * 0.5 + 0.5;
                  r0.w = r1.z ? r1.y : r0.w;
                  r0.w = r0.w * 1.10000002 + -0.100000001;
                  r0.w = 0.800000012 * r0.w;
                  r7.x = dot(float3(1.66050005, -0.587599993, -0.072800003), r0.xyz);
                  r7.y = dot(float3(-0.124600001, 1.1329, -0.00829999987), r0.xyz);
                  r7.z = dot(float3(-0.0182000007, -0.100599997, 1.11870003), r0.xyz);
                  r1.y = cmp(r1.x < 1);
                  r1.z = cmp(0 >= r1.x);
                  r8.xyz = max(float3(1, 1, 1), r7.xyz);
                  r8.xyz = float3(-1, -1, -1) + r8.xyz;
                  r7.xyz = r7.xyz + -r1.xxx;
                  r9.xyz = cmp(float3(0, 0, 0) < r7.xyz);
                  r7.xyz = r8.xyz / r7.xyz;
                  r7.xyz = r9.xyz ? r7.xyz : 0;
                  r1.w = max(r7.x, r7.y);
                  r1.w = max(r1.w, r7.z);
                  r1.w = 0.5 * r1.w;
                  r1.z = r1.z ? 0 : r1.w;
                  r1.y = r1.y ? r1.z : 0.5;
                  r0.w = max(r1.y, r0.w);
                  r1.xyz = r1.xxx + -r0.xyz;
                  r0.xyz = r0.www * r1.xyz + r0.xyz;
                  r0.w = dot(float3(1.66050005, -0.587599993, -0.072800003), r0.xyz);
                  r1.x = dot(float3(-0.124600001, 1.1329, -0.00829999987), r0.xyz);
                  r0.x = dot(float3(-0.0182000007, -0.100599997, 1.11870003), r0.xyz);
                  if (cb0[67].x == 0) {
                    r7.x = log2(r0.w);
                    r7.y = log2(r1.x);
                    r7.z = log2(r0.x);
                    r1.yzw = float3(0.416666657, 0.416666657, 0.416666657) * r7.xyz;
                    r1.yzw = exp2(r1.yzw);
                  } else {
                    r0.y = cmp(asint(cb0[67].x) == 1);
                    if (r0.y != 0) {
                      r7.x = log2(r0.w);
                      r7.y = log2(r1.x);
                      r7.z = log2(r0.x);
                      r7.xyz = float3(0.454545438, 0.454545438, 0.454545438) * r7.xyz;
                      r1.yzw = exp2(r7.xyz);
                    } else {
                      r0.y = cmp(asint(cb0[67].x) == 2);
                      if (r0.y != 0) {
                        r0.y = cmp(0.00313080009 >= r0.w);
                        r0.z = 12.9200001 * r0.w;
                        r2.w = log2(r0.w);
                        r2.w = 0.416666657 * r2.w;
                        r2.w = exp2(r2.w);
                        r2.w = r2.w * 1.05499995 + -0.0549999997;
                        r1.y = r0.y ? r0.z : r2.w;
                        r0.y = cmp(0.00313080009 >= r1.x);
                        r0.z = 12.9200001 * r1.x;
                        r2.w = log2(r1.x);
                        r2.w = 0.416666657 * r2.w;
                        r2.w = exp2(r2.w);
                        r2.w = r2.w * 1.05499995 + -0.0549999997;
                        r1.z = r0.y ? r0.z : r2.w;
                        r0.y = cmp(0.00313080009 >= r0.x);
                        r0.z = 12.9200001 * r0.x;
                        r2.w = log2(r0.x);
                        r2.w = 0.416666657 * r2.w;
                        r2.w = exp2(r2.w);
                        r2.w = r2.w * 1.05499995 + -0.0549999997;
                        r1.w = r0.y ? r0.z : r2.w;
                      } else {
                        r0.y = cmp(r0.w < 0.0179999992);
                        r0.z = 4.5 * r0.w;
                        r0.w = log2(r0.w);
                        r0.w = 0.454545468 * r0.w;
                        r0.w = exp2(r0.w);
                        r0.w = r0.w * 1.09899998 + -0.0989999995;
                        r1.y = r0.y ? r0.z : r0.w;
                        r0.y = cmp(r1.x < 0.0179999992);
                        r0.z = 4.5 * r1.x;
                        r0.w = log2(r1.x);
                        r0.w = 0.454545468 * r0.w;
                        r0.w = exp2(r0.w);
                        r0.w = r0.w * 1.09899998 + -0.0989999995;
                        r1.z = r0.y ? r0.z : r0.w;
                        r0.y = cmp(r0.x < 0.0179999992);
                        r0.z = 4.5 * r0.x;
                        r0.x = log2(r0.x);
                        r0.x = 0.454545468 * r0.x;
                        r0.x = exp2(r0.x);
                        r0.x = r0.x * 1.09899998 + -0.0989999995;
                        r1.w = r0.y ? r0.z : r0.x;
                      }
                    }
                  }
                  r0.x = cb0[66].y + -cb0[66].x;
                  r2.xyz = saturate(r1.yzw * r0.xxx + cb0[66].xxx);
                } else {
                  r0.x = cmp(asint(cb0[65].z) == 11);
                  if (r0.x != 0) {
                    r0.xyz = cb0[66].www * r2.xyz;
                    r1.y = dot(float3(0.439700812, 0.382978052, 0.1773348), r0.xyz);
                    r1.z = dot(float3(0.0897923037, 0.813423157, 0.096761629), r0.xyz);
                    r1.w = dot(float3(0.0175439864, 0.111544058, 0.870704114), r0.xyz);
                    r0.x = min(r1.y, r1.z);
                    r0.x = min(r0.x, r1.w);
                    r0.y = max(r1.y, r1.z);
                    r0.y = max(r0.y, r1.w);
                    r0.xyz = max(float3(1.00000001e-10, 1.00000001e-10, 0.00999999978), r0.xyy);
                    r0.x = r0.y + -r0.x;
                    r0.x = r0.x / r0.z;
                    r0.yzw = r1.wzy + -r1.zyw;
                    r0.yz = r1.wz * r0.yz;
                    r0.y = r0.y + r0.z;
                    r0.y = r1.y * r0.w + r0.y;
                    r0.y = sqrt(r0.y);
                    r0.z = r1.w + r1.z;
                    r0.z = r0.z + r1.y;
                    r0.y = r0.y * 1.75 + r0.z;
                    r0.w = -0.400000006 + r0.x;
                    r1.x = 2.5 * r0.w;
                    r1.x = 1 + -abs(r1.x);
                    r1.x = max(0, r1.x);
                    r2.w = cmp(0 < r0.w);
                    r0.w = cmp(r0.w < 0);
                    r0.w = (int)-r2.w + (int)r0.w;
                    r0.w = (int)r0.w;
                    r1.x = -r1.x * r1.x + 1;
                    r0.w = r0.w * r1.x + 1;
                    r0.zw = float2(0.333333343, 0.0250000004) * r0.yw;
                    r1.x = cmp(0.159999996 >= r0.y);
                    r0.y = cmp(r0.y >= 0.479999989);
                    r0.z = 0.0799999982 / r0.z;
                    r0.z = -0.5 + r0.z;
                    r0.z = r0.w * r0.z;
                    r0.y = r0.y ? 0 : r0.z;
                    r0.y = r1.x ? r0.w : r0.y;
                    r0.y = 1 + r0.y;
                    r7.yzw = r1.yzw * r0.yyy;
                    r0.zw = cmp(r7.zw == r7.yz);
                    r0.z = r0.w ? r0.z : 0;
                    r0.w = r1.z * r0.y + -r7.w;
                    r0.w = 1.73205078 * r0.w;
                    r1.x = r7.y * 2 + -r7.z;
                    r1.x = -r1.w * r0.y + r1.x;
                    r1.z = min(abs(r1.x), abs(r0.w));
                    r1.w = max(abs(r1.x), abs(r0.w));
                    r1.w = 1 / r1.w;
                    r1.z = r1.z * r1.w;
                    r1.w = r1.z * r1.z;
                    r2.w = r1.w * 0.0208350997 + -0.0851330012;
                    r2.w = r1.w * r2.w + 0.180141002;
                    r2.w = r1.w * r2.w + -0.330299497;
                    r1.w = r1.w * r2.w + 0.999866009;
                    r2.w = r1.z * r1.w;
                    r3.w = cmp(abs(r1.x) < abs(r0.w));
                    r2.w = r2.w * -2 + 1.57079637;
                    r2.w = r3.w ? r2.w : 0;
                    r1.z = r1.z * r1.w + r2.w;
                    r1.w = cmp(r1.x < -r1.x);
                    r1.w = r1.w ? -3.141593 : 0;
                    r1.z = r1.z + r1.w;
                    r1.w = min(r1.x, r0.w);
                    r0.w = max(r1.x, r0.w);
                    r1.x = cmp(r1.w < -r1.w);
                    r0.w = cmp(r0.w >= -r0.w);
                    r0.w = r0.w ? r1.x : 0;
                    r0.w = r0.w ? -r1.z : r1.z;
                    r0.w = 57.2957802 * r0.w;
                    r0.z = r0.z ? 0 : r0.w;
                    r0.w = cmp(r0.z < 0);
                    r1.x = 360 + r0.z;
                    r0.z = r0.w ? r1.x : r0.z;
                    r0.z = max(0, r0.z);
                    r0.z = min(360, r0.z);
                    r0.w = cmp(180 < r0.z);
                    r1.x = -360 + r0.z;
                    r0.z = r0.w ? r1.x : r0.z;
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
                      r1.z = r0.w * r0.z;
                      r8.xyz = float3(-0.166666672, -0.5, 0.166666672) * r1.zzz;
                      r8.xy = r0.ww * float2(0.5, 0.5) + r8.xy;
                      r8.xy = r0.zz * float2(-0.5, 0.5) + r8.xy;
                      r0.z = r1.z * 0.5 + -r0.w;
                      r0.z = 0.666666687 + r0.z;
                      r9.xyz = cmp((int3)r1.xxx == int3(3, 2, 1));
                      r1.zw = float2(0.166666672, 0.166666672) + r8.xy;
                      r0.w = r1.x ? 0 : r8.z;
                      r0.w = r9.z ? r1.w : r0.w;
                      r0.z = r9.y ? r0.z : r0.w;
                      r0.z = r9.x ? r1.z : r0.z;
                    } else {
                      r0.z = 0;
                    }
                    r0.x = r0.z * r0.x;
                    r0.x = 1.5 * r0.x;
                    r0.y = -r1.y * r0.y + 0.0299999993;
                    r0.x = r0.x * r0.y;
                    r7.x = r0.x * 0.180000007 + r7.y;
                    r0.xyz = max(float3(0, 0, 0), r7.xzw);
                    r0.xyz = min(float3(65535, 65535, 65535), r0.xyz);
                    r1.x = dot(float3(1.45143926, -0.236510754, -0.214928567), r0.xyz);
                    r1.y = dot(float3(-0.0765537769, 1.17622972, -0.0996759236), r0.xyz);
                    r1.z = dot(float3(0.00831614807, -0.00603244966, 0.997716308), r0.xyz);
                    r0.xyz = max(float3(0, 0, 0), r1.xyz);
                    r0.xyz = min(float3(65535, 65535, 65535), r0.xyz);
                    r0.w = dot(r0.xyz, float3(0.272228718, 0.674081743, 0.0536895171));
                    r0.xyz = r0.xyz + -r0.www;
                    r0.xyz = r0.xyz * float3(0.959999979, 0.959999979, 0.959999979) + r0.www;
                    r1.xyz = cmp(float3(0, 0, 0) >= r0.xyz);
                    r0.xyz = log2(r0.xyz);
                    r0.xyz = r1.xyz ? float3(-14, -14, -14) : r0.xyz;
                    r1.xyz = cmp(float3(-17.4739323, -17.4739323, -17.4739323) >= r0.xyz);
                    if (r1.x != 0) {
                      r0.w = -4;
                    } else {
                      r1.x = cmp(-17.4739323 < r0.x);
                      r1.w = cmp(r0.x < -2.47393107);
                      r1.x = r1.w ? r1.x : 0;
                      if (r1.x != 0) {
                        r1.x = r0.x * 0.30103001 + 5.26017761;
                        r1.w = 0.664385557 * r1.x;
                        r2.w = (int)r1.w;
                        r1.w = trunc(r1.w);
                        r7.y = r1.x * 0.664385557 + -r1.w;
                        r1.xw = (int2)r2.ww + int2(1, 2);
                        r7.x = r7.y * r7.y;
                        r8.x = icb[r2.w + 0].x;
                        r8.y = icb[r1.x + 0].x;
                        r8.z = icb[r1.w + 0].x;
                        r9.x = dot(r8.xzy, float3(0.5, 0.5, -1));
                        r9.y = dot(r8.xy, float2(-1, 1));
                        r9.z = dot(r8.xy, float2(0.5, 0.5));
                        r7.z = 1;
                        r0.w = dot(r7.xyz, r9.xyz);
                      } else {
                        r1.x = cmp(r0.x >= -2.47393107);
                        r1.w = cmp(r0.x < 15.5260687);
                        r1.x = r1.w ? r1.x : 0;
                        if (r1.x != 0) {
                          r0.x = r0.x * 0.30103001 + 0.744727492;
                          r1.x = 0.553654671 * r0.x;
                          r1.w = (int)r1.x;
                          r1.x = trunc(r1.x);
                          r7.y = r0.x * 0.553654671 + -r1.x;
                          r8.xy = (int2)r1.ww + int2(1, 2);
                          r7.x = r7.y * r7.y;
                          r9.x = icb[r1.w + 0].y;
                          r9.y = icb[r8.x + 0].y;
                          r9.z = icb[r8.y + 0].y;
                          r8.x = dot(r9.xzy, float3(0.5, 0.5, -1));
                          r8.y = dot(r9.xy, float2(-1, 1));
                          r8.z = dot(r9.xy, float2(0.5, 0.5));
                          r7.z = 1;
                          r0.w = dot(r7.xyz, r8.xyz);
                        } else {
                          r0.w = 4;
                        }
                      }
                    }
                    r0.x = 3.32192802 * r0.w;
                    r7.x = exp2(r0.x);
                    if (r1.y != 0) {
                      r0.x = -4;
                    } else {
                      r0.w = cmp(-17.4739323 < r0.y);
                      r1.x = cmp(r0.y < -2.47393107);
                      r0.w = r0.w ? r1.x : 0;
                      if (r0.w != 0) {
                        r0.w = r0.y * 0.30103001 + 5.26017761;
                        r1.x = 0.664385557 * r0.w;
                        r1.y = (int)r1.x;
                        r1.x = trunc(r1.x);
                        r8.y = r0.w * 0.664385557 + -r1.x;
                        r1.xw = (int2)r1.yy + int2(1, 2);
                        r8.x = r8.y * r8.y;
                        r9.x = icb[r1.y + 0].x;
                        r9.y = icb[r1.x + 0].x;
                        r9.z = icb[r1.w + 0].x;
                        r10.x = dot(r9.xzy, float3(0.5, 0.5, -1));
                        r10.y = dot(r9.xy, float2(-1, 1));
                        r10.z = dot(r9.xy, float2(0.5, 0.5));
                        r8.z = 1;
                        r0.x = dot(r8.xyz, r10.xyz);
                      } else {
                        r0.w = cmp(r0.y >= -2.47393107);
                        r1.x = cmp(r0.y < 15.5260687);
                        r0.w = r0.w ? r1.x : 0;
                        if (r0.w != 0) {
                          r0.y = r0.y * 0.30103001 + 0.744727492;
                          r0.w = 0.553654671 * r0.y;
                          r1.x = (int)r0.w;
                          r0.w = trunc(r0.w);
                          r8.y = r0.y * 0.553654671 + -r0.w;
                          r0.yw = (int2)r1.xx + int2(1, 2);
                          r8.x = r8.y * r8.y;
                          r9.x = icb[r1.x + 0].y;
                          r9.y = icb[r0.y + 0].y;
                          r9.z = icb[r0.w + 0].y;
                          r10.x = dot(r9.xzy, float3(0.5, 0.5, -1));
                          r10.y = dot(r9.xy, float2(-1, 1));
                          r10.z = dot(r9.xy, float2(0.5, 0.5));
                          r8.z = 1;
                          r0.x = dot(r8.xyz, r10.xyz);
                        } else {
                          r0.x = 4;
                        }
                      }
                    }
                    r0.x = 3.32192802 * r0.x;
                    r7.y = exp2(r0.x);
                    if (r1.z != 0) {
                      r0.x = -4;
                    } else {
                      r0.y = cmp(-17.4739323 < r0.z);
                      r0.w = cmp(r0.z < -2.47393107);
                      r0.y = r0.w ? r0.y : 0;
                      if (r0.y != 0) {
                        r0.y = r0.z * 0.30103001 + 5.26017761;
                        r0.w = 0.664385557 * r0.y;
                        r1.x = (int)r0.w;
                        r0.w = trunc(r0.w);
                        r8.y = r0.y * 0.664385557 + -r0.w;
                        r0.yw = (int2)r1.xx + int2(1, 2);
                        r8.x = r8.y * r8.y;
                        r1.x = icb[r1.x + 0].x;
                        r1.y = icb[r0.y + 0].x;
                        r1.z = icb[r0.w + 0].x;
                        r9.x = dot(r1.xzy, float3(0.5, 0.5, -1));
                        r9.y = dot(r1.xy, float2(-1, 1));
                        r9.z = dot(r1.xy, float2(0.5, 0.5));
                        r8.z = 1;
                        r0.x = dot(r8.xyz, r9.xyz);
                      } else {
                        r0.y = cmp(r0.z >= -2.47393107);
                        r0.w = cmp(r0.z < 15.5260687);
                        r0.y = r0.w ? r0.y : 0;
                        if (r0.y != 0) {
                          r0.y = r0.z * 0.30103001 + 0.744727492;
                          r0.z = 0.553654671 * r0.y;
                          r0.w = (int)r0.z;
                          r0.z = trunc(r0.z);
                          r1.y = r0.y * 0.553654671 + -r0.z;
                          r0.yz = (int2)r0.ww + int2(1, 2);
                          r1.x = r1.y * r1.y;
                          r8.x = icb[r0.w + 0].y;
                          r8.y = icb[r0.y + 0].y;
                          r8.z = icb[r0.z + 0].y;
                          r9.x = dot(r8.xzy, float3(0.5, 0.5, -1));
                          r9.y = dot(r8.xy, float2(-1, 1));
                          r9.z = dot(r8.xy, float2(0.5, 0.5));
                          r1.z = 1;
                          r0.x = dot(r1.xyz, r9.xyz);
                        } else {
                          r0.x = 4;
                        }
                      }
                    }
                    r0.x = 3.32192802 * r0.x;
                    r7.z = exp2(r0.x);
                    r0.x = dot(float3(0.695452213, 0.140678704, 0.163869068), r7.xyz);
                    r0.y = dot(float3(0.0447945632, 0.859671116, 0.0955343172), r7.xyz);
                    r0.z = dot(float3(-0.00552588282, 0.00402521016, 1.00150073), r7.xyz);
                    r1.x = dot(float3(1.51282358, -0.258981079, -0.229780421), r0.xyz);
                    r1.y = dot(float3(-0.0790363327, 1.17706418, -0.100755438), r0.xyz);
                    r1.z = dot(float3(0.00209150789, -0.0311482511, 0.953631222), r0.xyz);
                    r0.xyzw = float4(9.99999975e-05, 9.99999975e-05, 9.99999975e-05, 9.99999975e-05) * r1.xyyz;
                    r0.xyzw = max(float4(0, 0, 0, 0), r0.xyzw);
                    r0.xyzw = log2(r0.xyzw);
                    r0.xyzw = cb0[66].zzzz * r0.xyzw;
                    r0.xyzw = exp2(r0.xyzw);
                    if (cb0[67].y != 0) {
                      r1.xyzw = float4(1, 1, 1, 3333.33325) * r0.xzwx;
                      r1.w = min(1, r1.w);
                      r1.x = r1.w * -9.99999975e-05 + r1.x;
                      r1.w = log2(r1.x);
                      r1.w = 0.992999971 * r1.w;
                      r1.w = exp2(r1.w);
                      r2.w = max(0, r1.x);
                      r1.x = r1.x * r1.x;
                      r3.w = 5000 * r1.x;
                      r7.xyz = r0.xzw * float3(1, 1, 1) + float3(-0.00100000005, -0.00100000005, -0.00100000005);
                      r7.xyz = saturate(float3(166.666672, 166.666672, 166.666672) * r7.xyz);
                      r1.w = -r2.w + r1.w;
                      r1.w = r7.x * r1.w + r2.w;
                      r8.xyzw = float4(2500, 3333.33325, 2500, 3333.33325) * r0.xyzw;
                      r8.xyzw = min(float4(1, 1, 1, 1), r8.xyzw);
                      r0.y = -r1.x * 5000 + r1.w;
                      r9.x = r8.x * r0.y + r3.w;
                      r1.xy = r8.yw * float2(-9.99999975e-05, -9.99999975e-05) + r1.yz;
                      r1.zw = log2(r1.xy);
                      r1.zw = float2(0.992999971, 0.992999971) * r1.zw;
                      r1.zw = exp2(r1.zw);
                      r7.xw = max(float2(0, 0), r1.xy);
                      r1.xy = r1.xy * r1.xy;
                      r8.xy = float2(5000, 5000) * r1.xy;
                      r1.zw = -r7.xw + r1.zw;
                      r1.zw = r7.yz * r1.zw + r7.xw;
                      r1.xy = -r1.xy * float2(5000, 5000) + r1.zw;
                      r9.y = r8.z * r1.x + r8.x;
                      r0.y = 2500 * r0.w;
                      r0.y = min(1, r0.y);
                      r9.z = r0.y * r1.y + r8.y;
                      r1.xyz = float3(10000, 10000, 10000) * r9.xyz;
                    } else {
                      r1.xyz = float3(10000, 10000, 10000) * r0.xzw;
                    }
                    r0.x = dot(float3(0.412099987, 0.523899972, 0.064000003), r1.xyz);
                    r0.y = dot(float3(0.166700006, 0.720499992, 0.112800002), r1.xyz);
                    r0.z = dot(float3(0.0241999999, 0.0754000023, 0.900399983), r1.xyz);
                    r0.xyzw = float4(9.99999975e-05, 9.99999975e-05, 9.99999975e-05, 9.99999975e-05) * r0.xyzx;
                    r0.xyzw = log2(r0.xyzw);
                    r0.xyzw = float4(0.159301758, 0.159301758, 0.159301758, 0.159301758) * r0.xyzw;
                    r0.xyzw = exp2(r0.xyzw);
                    r1.xyzw = r0.wyzw * float4(18.8515625, 18.8515625, 18.8515625, 18.8515625) + float4(0.8359375, 0.8359375, 0.8359375, 0.8359375);
                    r0.xyzw = r0.xyzw * float4(18.6875, 18.6875, 18.6875, 18.6875) + float4(1, 1, 1, 1);
                    r0.xyzw = r1.xyzw / r0.xyzw;
                    r0.xyzw = log2(r0.xyzw);
                    r0.xyzw = float4(78.84375, 78.84375, 78.84375, 78.84375) * r0.xyzw;
                    r0.xyzw = exp2(r0.xyzw);
                    r1.x = dot(r0.wy, float2(0.5, 0.5));
                    r1.y = 3.32349992 * r0.y;
                    r0.x = r0.x * 1.61380005 + -r1.y;
                    r7.xz = r0.zz * float2(1.70969999, 1.70969999) + r0.xx;
                    r0.x = 4.24560022 * r0.y;
                    r0.x = r0.w * 4.37820005 + -r0.x;
                    r7.yw = -r0.zz * float2(0.132599995, 0.132599995) + r0.xx;
                    r0.x = cb0[66].y * 1.5 + -0.5;
                    r0.y = min(1, r1.x);
                    r0.z = cmp(r0.x < r0.y);
                    r0.w = r0.y + -r0.x;
                    r1.y = 1 + -r0.x;
                    r0.w = r0.w / r1.y;
                    r1.z = r0.w * r0.w;
                    r1.w = r1.z * r0.w;
                    r2.w = 3 * r1.z;
                    r3.w = r1.w * 2 + -r2.w;
                    r3.w = 1 + r3.w;
                    r1.z = -r1.z * 2 + r1.w;
                    r0.w = r1.z + r0.w;
                    r0.w = r0.w * r1.y;
                    r0.x = r3.w * r0.x + r0.w;
                    r0.w = r1.w * -2 + r2.w;
                    r0.x = r0.w * cb0[66].y + r0.x;
                    r0.x = saturate(r0.z ? r0.x : r0.y);
                    r0.y = 1 + -r0.x;
                    r0.y = r0.y * r0.y;
                    r0.y = r0.y * r0.y;
                    r0.x = cb0[66].x * r0.y + r0.x;
                    r0.y = max(1.00000001e-07, r1.x);
                    r0.y = r0.x / r0.y;
                    r0.y = min(1, r0.y);
                    r0.y = r0.y * r0.y;
                    r1.xyzw = r7.xyzw * r0.yyyy;
                    r0.yz = r1.xz * float2(0.00860000029, 0.560000002) + r0.xx;
                    r0.y = r1.y * 0.111000001 + r0.y;
                    r0.x = -r1.x * 0.00860000029 + r0.x;
                    r0.x = -r1.y * 0.111000001 + r0.x;
                    r0.z = -r1.w * 0.320600003 + r0.z;
                    r1.x = log2(r0.y);
                    r1.y = log2(r0.x);
                    r1.z = log2(r0.z);
                    r0.xyz = float3(0.0126833133, 0.0126833133, 0.0126833133) * r1.xyz;
                    r0.xyz = exp2(r0.xyz);
                    r1.xyz = float3(-0.8359375, -0.8359375, -0.8359375) + r0.xyz;
                    r0.xyz = r0.xyz * float3(18.6875, 18.6875, 18.6875) + float3(-18.8515625, -18.8515625, -18.8515625);
                    r0.xyz = -r1.xyz / r0.xyz;
                    r0.xyz = max(float3(0, 0, 0), r0.xyz);
                    r0.xyz = log2(r0.xyz);
                    r0.xyz = float3(6.27739477, 6.27739477, 6.27739477) * r0.xyz;
                    r0.xyz = exp2(r0.xyz);
                    r0.xyz = float3(10000, 10000, 10000) * r0.xyz;
                    r1.x = dot(float3(3.43659997, -2.50650001, 0.0697999969), r0.xyz);
                    r1.y = dot(float3(-0.791299999, 1.98360002, -0.192300007), r0.xyz);
                    r1.z = dot(float3(-0.0259000007, -0.0988999978, 1.12489998), r0.xyz);
                    r0.xyz = float3(9.99999975e-05, 9.99999975e-05, 9.99999975e-05) * r1.xyz;
                    r0.xyz = log2(r0.xyz);
                    r0.xyz = float3(0.159301758, 0.159301758, 0.159301758) * r0.xyz;
                    r0.xyz = exp2(r0.xyz);
                    r1.xyz = r0.xyz * float3(18.8515625, 18.8515625, 18.8515625) + float3(0.8359375, 0.8359375, 0.8359375);
                    r0.xyz = r0.xyz * float3(18.6875, 18.6875, 18.6875) + float3(1, 1, 1);
                    r0.xyz = rcp(r0.xyz);
                    r0.xyz = r1.xyz * r0.xyz;
                    r0.xyz = log2(r0.xyz);
                    r0.xyz = float3(78.84375, 78.84375, 78.84375) * r0.xyz;
                    r2.xyz = exp2(r0.xyz);
                  } else {
                    r0.x = dot(float3(0.613191485, 0.33951208, 0.0473663323), r3.xyz);
                    r0.y = dot(float3(0.0702069029, 0.916335821, 0.0134500116), r3.xyz);
                    r0.z = dot(float3(0.0206188709, 0.109567292, 0.869606733), r3.xyz);
                    r0.w = dot(r5.xyz, r0.xyz);
                    r1.x = dot(r6.xyz, r0.xyz);
                    r0.x = dot(r4.xyz, r0.xyz);
                    r3.x = log2(r0.w);
                    r3.y = log2(r1.x);
                    r3.z = log2(r0.x);
                    r0.xyz = cb0[27].zzz * r3.xyz;
                    r2.xyz = exp2(r0.xyz);
                  }
                }
              }
            }
          }
        }
      }
    }
  }
  o0.xyz = float3(0.952381015, 0.952381015, 0.952381015) * r2.xyz;
  o0.w = 0;
  return;
}
