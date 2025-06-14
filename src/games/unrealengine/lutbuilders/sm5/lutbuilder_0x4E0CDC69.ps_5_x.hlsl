#include "../../common.hlsl"

// Found in Styx: Shards of Darkness

// ---- Created with 3Dmigoto v1.3.16 on Fri May  9 17:42:49 2025
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[42];
}

// 3Dmigoto declarations
#define cmp -

void main(
    linear noperspective float2 v0: TEXCOORD0,
    float4 v1: SV_POSITION0,
    uint v2: SV_RenderTargetArrayIndex0,
    out float4 o0: SV_Target0) {
  const float4 icb[] = { { -4.000000, -0.718548, -2.301030, 0.801995 },
                         { -4.000000, 2.081031, -2.301030, 1.198005 },
                         { -3.157377, 3.668124, -1.931200, 1.594300 },
                         { -0.485250, 4.000000, -1.520500, 1.997300 },
                         { 1.847732, 4.000000, -1.057800, 2.378300 },
                         { 1.847732, 4.000000, -0.466800, 2.768400 },
                         { 0, 0, 0.119380, 3.051500 },
                         { 0, 0, 0.708813, 3.274629 },
                         { 0, 0, 1.291187, 3.327431 },
                         { 0, 0, 1.291187, 3.327431 } };
  float4 r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(-0.015625, -0.015625) + v0.xy;
  r0.xy = float2(1.03225803, 1.03225803) * r0.xy;
  r0.z = (uint)v2.x;
  r1.z = 0.0322580636 * r0.z;
  r0.z = cmp(asuint(cb0[40].w) >= 3);
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
  r0.xyw = float3(10000, 10000, 10000) * r0.xyw;
  r1.xy = v0.xy * float2(1.03225803, 1.03225803) + float2(-0.0161290318, -0.0161290318);
  r1.xyz = float3(-0.434017599, -0.434017599, -0.434017599) + r1.xyz;
  r1.xyz = float3(14, 14, 14) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.xyz = float3(0.180000007, 0.180000007, 0.180000007) * r1.xyz;
  r0.xyz = r0.zzz ? r0.xyw : r1.xyz;
  r0.w = 1.00055635 * cb0[35].x;
  r1.x = cmp(6996.10791 >= cb0[35].x);
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
  r2.xyz = cb0[35].xxx * float3(0.000154118257, 0.00084242021, 4.22806261e-05) + float3(0.860117733, 1, 0.317398727);
  r0.w = cb0[35].x * cb0[35].x;
  r2.xyz = r0.www * float3(1.28641219e-07, 7.08145137e-07, 4.20481676e-08) + r2.xyz;
  r2.x = r2.x / r2.y;
  r1.z = -cb0[35].x * 2.8974182e-05 + 1;
  r0.w = r0.w * 1.61456057e-07 + r1.z;
  r2.y = r2.z / r0.w;
  r1.zw = r2.xy + r2.xy;
  r0.w = 3 * r2.x;
  r1.z = -r2.y * 8 + r1.z;
  r1.z = 4 + r1.z;
  r3.x = r0.w / r1.z;
  r3.y = r1.w / r1.z;
  // r0.w = cmp(cb0[35].x < 4000);
  r0.w = cmp(asint(cb0[35].x) < 4000);
  r1.xy = r0.ww ? r3.xy : r1.xy;
  r0.w = dot(r2.xy, r2.xy);
  r0.w = rsqrt(r0.w);
  r1.zw = r2.xy * r0.ww;
  r0.w = cb0[35].y * -r1.w;
  r0.w = r0.w * 0.0500000007 + r2.x;
  r1.z = cb0[35].y * r1.z;
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

  SetUngradedAP1(r0.xyz);

  r0.xyz = r0.xyz + -r0.www;
  r0.xyz = cb0[36].xyz * r0.xyz + r0.www;
  r0.xyz = max(float3(0, 0, 0), r0.xyz);
  r0.xyz = float3(5.55555534, 5.55555534, 5.55555534) * r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = cb0[37].xyz * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = float3(0.180000007, 0.180000007, 0.180000007) * r0.xyz;
  r1.xyz = float3(1, 1, 1) / cb0[38].xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = r1.xyz * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = r0.xyz * cb0[39].xyz + cb0[40].xyz;

  SetUntonemappedAP1(r0.xyz);

  r1.x = dot(float3(1.70505154, -0.621790707, -0.0832583979), r0.xyz);
  r1.y = dot(float3(-0.130257145, 1.14080286, -0.0105485283), r0.xyz);
  r1.z = dot(float3(-0.0240032747, -0.128968775, 1.15297174), r0.xyz);
  r0.x = dot(float3(0.439700812, 0.382978052, 0.1773348), r1.xyz);
  r2.y = dot(float3(0.0897923037, 0.813423157, 0.096761629), r1.xyz);
  r2.z = dot(float3(0.0175439864, 0.111544058, 0.870704114), r1.xyz);
  r0.y = min(r2.y, r0.x);
  r0.y = min(r0.y, r2.z);
  r0.z = max(r2.y, r0.x);
  r0.z = max(r0.z, r2.z);
  r0.yzw = max(float3(1.00000001e-10, 1.00000001e-10, 0.00999999978), r0.yzz);
  r0.y = r0.z + -r0.y;
  r0.y = r0.y / r0.w;
  r0.z = cmp(r0.x == r2.y);
  r0.w = cmp(r2.z == r2.y);
  r0.z = r0.w ? r0.z : 0;
  r0.w = r2.y + -r2.z;
  r0.w = 1.73205078 * r0.w;
  r1.w = r0.x * 2 + -r2.y;
  r1.w = r1.w + -r2.z;
  r2.w = min(abs(r1.w), abs(r0.w));
  r3.x = max(abs(r1.w), abs(r0.w));
  r3.x = 1 / r3.x;
  r2.w = r3.x * r2.w;
  r3.x = r2.w * r2.w;
  r3.y = r3.x * 0.0208350997 + -0.0851330012;
  r3.y = r3.x * r3.y + 0.180141002;
  r3.y = r3.x * r3.y + -0.330299497;
  r3.x = r3.x * r3.y + 0.999866009;
  r3.y = r3.x * r2.w;
  r3.z = cmp(abs(r1.w) < abs(r0.w));
  r3.y = r3.y * -2 + 1.57079637;
  r3.y = r3.z ? r3.y : 0;
  r2.w = r2.w * r3.x + r3.y;
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
  r0.y = r0.z * r0.y;
  r0.z = 0.0299999993 + -r0.x;
  r0.y = r0.y * r0.z;
  r2.x = r0.y * 0.180000007 + r0.x;
  r0.x = dot(float3(1.45143926, -0.236510754, -0.214928567), r2.xyz);
  r0.y = dot(float3(-0.0765537769, 1.17622972, -0.0996759236), r2.xyz);
  r0.z = dot(float3(0.00831614807, -0.00603244966, 0.997716308), r2.xyz);
  r0.xyz = max(float3(0, 0, 0), r0.xyz);
  r0.w = dot(r0.xyz, float3(0.272228718, 0.674081743, 0.0536895171));
  r0.xyz = r0.xyz + -r0.www;
  r0.xyz = r0.xyz * float3(0.959999979, 0.959999979, 0.959999979) + r0.www;
  r2.xy = float2(1, 0.180000007) + cb0[27].ww;
  r0.w = -cb0[27].y + r2.x;
  r1.w = 1 + cb0[28].x;
  r2.x = -cb0[27].z + r1.w;
  r2.z = cmp(0.800000012 < cb0[27].y);
  r3.xy = float2(0.819999993, 1) + -cb0[27].yy;
  r3.xy = r3.xy / cb0[27].xx;
  r2.w = -0.744727492 + r3.x;
  r2.y = r2.y / r0.w;
  r3.x = -1 + r2.y;
  r3.x = 1 + -r3.x;
  r2.y = r2.y / r3.x;
  r2.y = log2(r2.y);
  r2.y = 0.346573591 * r2.y;
  r3.x = r0.w / cb0[27].x;
  r2.y = -r2.y * r3.x + -0.744727492;
  r2.y = r2.z ? r2.w : r2.y;
  r2.z = r3.y + -r2.y;
  r2.w = cb0[27].z / cb0[27].x;
  r2.w = r2.w + -r2.z;
  r0.xyz = log2(r0.xyz);
  r3.xyz = float3(0.30103001, 0.30103001, 0.30103001) * r0.xyz;
  r4.xyz = r0.xyz * float3(0.30103001, 0.30103001, 0.30103001) + r2.zzz;
  r4.xyz = cb0[27].xxx * r4.xyz;
  r2.z = r0.w + r0.w;
  r3.w = -2 * cb0[27].x;
  r0.w = r3.w / r0.w;
  r5.xyz = r0.xyz * float3(0.30103001, 0.30103001, 0.30103001) + -r2.yyy;
  r6.xyz = r5.xyz * r0.www;
  r6.xyz = float3(1.44269502, 1.44269502, 1.44269502) * r6.xyz;
  r6.xyz = exp2(r6.xyz);
  r6.xyz = float3(1, 1, 1) + r6.xyz;
  r6.xyz = r2.zzz / r6.xyz;
  r6.xyz = -cb0[27].www + r6.xyz;
  r0.w = r2.x + r2.x;
  r2.z = cb0[27].x + cb0[27].x;
  r2.x = r2.z / r2.x;
  r0.xyz = r0.xyz * float3(0.30103001, 0.30103001, 0.30103001) + -r2.www;
  r0.xyz = r2.xxx * r0.xyz;
  r0.xyz = float3(1.44269502, 1.44269502, 1.44269502) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = float3(1, 1, 1) + r0.xyz;
  r0.xyz = r0.www / r0.xyz;
  r0.xyz = r1.www + -r0.xyz;
  r7.xyz = cmp(r3.xyz < r2.yyy);
  r6.xyz = r7.xyz ? r6.xyz : r4.xyz;
  r3.xyz = cmp(r2.www < r3.xyz);
  r0.xyz = r3.xyz ? r0.xyz : r4.xyz;
  r0.w = r2.w + -r2.y;
  r3.xyz = saturate(r5.xyz / r0.www);
  r0.w = cmp(r2.w < r2.y);
  r2.xyz = float3(1, 1, 1) + -r3.xyz;
  r2.xyz = r0.www ? r2.xyz : r3.xyz;
  r3.xyz = -r2.xyz * float3(2, 2, 2) + float3(3, 3, 3);
  r2.xyz = r2.xyz * r2.xyz;
  r2.xyz = r2.xyz * r3.xyz;
  r0.xyz = r0.xyz + -r6.xyz;
  r0.xyz = r2.xyz * r0.xyz + r6.xyz;
  r0.w = dot(r0.xyz, float3(0.272228718, 0.674081743, 0.0536895171));
  r0.xyz = r0.xyz + -r0.www;
  r0.xyz = r0.xyz * float3(0.930000007, 0.930000007, 0.930000007) + r0.www;
  r0.xyz = max(float3(0, 0, 0), r0.xyz);
  r0.w = cmp(cb0[26].w == 0.000000);
  [branch]
  if (r0.w != 0) {
    r2.x = dot(r1.xyz, cb0[19].xyz);
    r2.y = dot(r1.xyz, cb0[20].xyz);
    r2.z = dot(r1.xyz, cb0[21].xyz);
    r0.w = dot(r1.xyz, cb0[24].xyz);
    r0.w = 1 + r0.w;
    r0.w = rcp(r0.w);
    r3.xyz = cb0[26].xyz * r0.www + cb0[25].xyz;
    r2.xyz = r3.xyz * r2.xyz;
    r2.xyz = max(float3(0, 0, 0), r2.xyz);
    r3.xyz = cb0[22].xxx + -r2.xyz;
    r3.xyz = max(float3(0, 0, 0), r3.xyz);
    r4.xyz = max(cb0[22].zzz, r2.xyz);
    r2.xyz = max(cb0[22].xxx, r2.xyz);
    r2.xyz = min(cb0[22].zzz, r2.xyz);
    r5.xyz = r4.xyz * cb0[23].xxx + cb0[23].yyy;
    r4.xyz = cb0[22].www + r4.xyz;
    r4.xyz = rcp(r4.xyz);
    r6.xyz = cb0[19].www * r3.xyz;
    r3.xyz = cb0[22].yyy + r3.xyz;
    r3.xyz = rcp(r3.xyz);
    r3.xyz = r6.xyz * r3.xyz + cb0[20].www;
    r2.xyz = r2.xyz * cb0[21].www + r3.xyz;
    r2.xyz = r5.xyz * r4.xyz + r2.xyz;
    r2.xyz = float3(-0.00200000009, -0.00200000009, -0.00200000009) + r2.xyz;

    SetTonemappedBT709(r2.xyz);

  } else {
    r3.x = dot(float3(1.70505154, -0.621790707, -0.0832583979), r0.xyz);
    r3.y = dot(float3(-0.130257145, 1.14080286, -0.0105485283), r0.xyz);
    r3.z = dot(float3(-0.0240032747, -0.128968775, 1.15297174), r0.xyz);

    SetTonemappedBT709(r3.xyz);

    r2.xyz = max(float3(0, 0, 0), r3.xyz);
  }
  r2.xyz = saturate(r2.xyz);
  r3.xyz = float3(12.9200001, 12.9200001, 12.9200001) * r2.xyz;
  r4.xyz = cmp(r2.xyz >= float3(0.00313066994, 0.00313066994, 0.00313066994));
  r2.xyz = log2(r2.xyz);
  r2.xyz = float3(0.416666657, 0.416666657, 0.416666657) * r2.xyz;
  r2.xyz = exp2(r2.xyz);
  r2.xyz = r2.xyz * float3(1.05499995, 1.05499995, 1.05499995) + float3(-0.0549999997, -0.0549999997, -0.0549999997);
  r2.xyz = r4.xyz ? r2.xyz : r3.xyz;
  r3.yzw = r2.xyz * float3(0.9375, 0.9375, 0.9375) + float3(0.03125, 0.03125, 0.03125);
  r0.w = r3.w * 16 + -0.5;
  r1.w = floor(r0.w);
  r0.w = -r1.w + r0.w;
  r1.w = r3.y + r1.w;
  r3.x = 0.0625 * r1.w;
  r4.xyz = t0.Sample(s0_s, r3.xz).xyz;
  r3.xy = float2(0.0625, 0) + r3.xz;
  r3.xyz = t0.Sample(s0_s, r3.xy).xyz;
  r3.xyz = r3.xyz + -r4.xyz;
  r3.xyz = r0.www * r3.xyz + r4.xyz;
  r3.xyz = cb0[30].xxx * r3.xyz;
  r2.xyz = cb0[29].xxx * r2.xyz + r3.xyz;
  r2.xyz = max(float3(6.10351999e-05, 6.10351999e-05, 6.10351999e-05), r2.xyz);
  r3.xyz = cmp(float3(0.0404499993, 0.0404499993, 0.0404499993) < r2.xyz);
  r4.xyz = r2.xyz * float3(0.947867274, 0.947867274, 0.947867274) + float3(0.0521326996, 0.0521326996, 0.0521326996);
  r4.xyz = log2(r4.xyz);
  r4.xyz = float3(2.4000001, 2.4000001, 2.4000001) * r4.xyz;
  r4.xyz = exp2(r4.xyz);
  r2.xyz = float3(0.0773993805, 0.0773993805, 0.0773993805) * r2.xyz;
  r2.xyz = r3.xyz ? r4.xyz : r2.xyz;
  r3.xyz = r2.xyz * r2.xyz;
  r2.xyz = cb0[17].yyy * r2.xyz;
  r2.xyz = cb0[17].xxx * r3.xyz + r2.xyz;
  r2.xyz = cb0[17].zzz + r2.xyz;
  r3.xyz = cb0[33].yzw * r2.xyz;
  r2.xyz = -r2.xyz * cb0[33].yzw + cb0[34].xyz;
  r2.xyz = cb0[34].www * r2.xyz + r3.xyz;
  r2.xyz = max(float3(0, 0, 0), r2.xyz);
  r2.xyz = log2(r2.xyz);
  r2.xyz = cb0[18].yyy * r2.xyz;
  r3.xyz = exp2(r2.xyz);

  if (RENODX_TONE_MAP_TYPE != 0) {
    o0 = GenerateOutput(r3.xyz, asuint(cb0[40].w));
    return;
  }

  [branch]
  if (asuint(cb0[40].w) == 0) {
    r4.xyz = float3(12.9200001, 12.9200001, 12.9200001) * r3.xyz;
    r5.xyz = cmp(r3.xyz >= float3(0.00313066994, 0.00313066994, 0.00313066994));
    r2.xyz = float3(0.416666657, 0.416666657, 0.416666657) * r2.xyz;
    r2.xyz = exp2(r2.xyz);
    r2.xyz = r2.xyz * float3(1.05499995, 1.05499995, 1.05499995) + float3(-0.0549999997, -0.0549999997, -0.0549999997);
    r2.xyz = r5.xyz ? r2.xyz : r4.xyz;
  } else {
    r4.xyzw = cmp(asint(cb0[41].xxxx) == int4(1, 2, 3, 4));
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
    r0.w = cmp(asint(cb0[40].w) == 1);
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
      r0.w = cmp(asint(cb0[40].w) == 3);
      if (r0.w != 0) {
        r7.xyz = float3(4, 4, 4) * r1.xyz;
        r8.y = dot(float3(0.439700812, 0.382978052, 0.1773348), r7.xyz);
        r8.z = dot(float3(0.0897923037, 0.813423157, 0.096761629), r7.xyz);
        r8.w = dot(float3(0.0175439864, 0.111544058, 0.870704114), r7.xyz);
        r0.w = min(r8.y, r8.z);
        r0.w = min(r0.w, r8.w);
        r1.w = max(r8.y, r8.z);
        r1.w = max(r1.w, r8.w);
        r7.xy = max(float2(1.00000001e-10, 0.00999999978), r1.ww);
        r0.w = max(1.00000001e-10, r0.w);
        r0.w = r7.x + -r0.w;
        r0.w = r0.w / r7.y;
        r7.xyz = r8.wzy + -r8.zyw;
        r7.xy = r8.wz * r7.xy;
        r1.w = r7.x + r7.y;
        r1.w = r8.y * r7.z + r1.w;
        r1.w = sqrt(r1.w);
        r2.w = r8.w + r8.z;
        r2.w = r2.w + r8.y;
        r1.w = r1.w * 1.75 + r2.w;
        r2.w = 0.333333343 * r1.w;
        r3.w = -0.400000006 + r0.w;
        r4.w = 2.5 * r3.w;
        r4.w = 1 + -abs(r4.w);
        r4.w = max(0, r4.w);
        r5.w = cmp(0 < r3.w);
        r3.w = cmp(r3.w < 0);
        r3.w = (int)-r5.w + (int)r3.w;
        r3.w = (int)r3.w;
        r4.w = -r4.w * r4.w + 1;
        r3.w = r3.w * r4.w + 1;
        r3.w = 0.0250000004 * r3.w;
        r4.w = cmp(0.159999996 >= r1.w);
        r1.w = cmp(r1.w >= 0.479999989);
        r2.w = 0.0799999982 / r2.w;
        r2.w = -0.5 + r2.w;
        r2.w = r3.w * r2.w;
        r1.w = r1.w ? 0 : r2.w;
        r1.w = r4.w ? r3.w : r1.w;
        r1.w = 1 + r1.w;
        r7.yzw = r8.yzw * r1.www;
        r9.xy = cmp(r7.zw == r7.yz);
        r2.w = r9.y ? r9.x : 0;
        r3.w = r8.z * r1.w + -r7.w;
        r3.w = 1.73205078 * r3.w;
        r4.w = r7.y * 2 + -r7.z;
        r4.w = -r8.w * r1.w + r4.w;
        r5.w = min(abs(r4.w), abs(r3.w));
        r6.w = max(abs(r4.w), abs(r3.w));
        r6.w = 1 / r6.w;
        r5.w = r6.w * r5.w;
        r6.w = r5.w * r5.w;
        r8.x = r6.w * 0.0208350997 + -0.0851330012;
        r8.x = r6.w * r8.x + 0.180141002;
        r8.x = r6.w * r8.x + -0.330299497;
        r6.w = r6.w * r8.x + 0.999866009;
        r8.x = r6.w * r5.w;
        r8.z = cmp(abs(r4.w) < abs(r3.w));
        r8.x = r8.x * -2 + 1.57079637;
        r8.x = r8.z ? r8.x : 0;
        r5.w = r5.w * r6.w + r8.x;
        r6.w = cmp(r4.w < -r4.w);
        r6.w = r6.w ? -3.141593 : 0;
        r5.w = r6.w + r5.w;
        r6.w = min(r4.w, r3.w);
        r3.w = max(r4.w, r3.w);
        r4.w = cmp(r6.w < -r6.w);
        r3.w = cmp(r3.w >= -r3.w);
        r3.w = r3.w ? r4.w : 0;
        r3.w = r3.w ? -r5.w : r5.w;
        r3.w = 57.2957802 * r3.w;
        r2.w = r2.w ? 0 : r3.w;
        r3.w = cmp(r2.w < 0);
        r4.w = 360 + r2.w;
        r2.w = r3.w ? r4.w : r2.w;
        r2.w = max(0, r2.w);
        r2.w = min(360, r2.w);
        r3.w = cmp(180 < r2.w);
        r4.w = -360 + r2.w;
        r2.w = r3.w ? r4.w : r2.w;
        r3.w = cmp(-67.5 < r2.w);
        r4.w = cmp(r2.w < 67.5);
        r3.w = r3.w ? r4.w : 0;
        if (r3.w != 0) {
          r2.w = 67.5 + r2.w;
          r3.w = 0.0296296291 * r2.w;
          r4.w = (int)r3.w;
          r3.w = trunc(r3.w);
          r2.w = r2.w * 0.0296296291 + -r3.w;
          r3.w = r2.w * r2.w;
          r5.w = r3.w * r2.w;
          r8.xzw = float3(-0.166666672, -0.5, 0.166666672) * r5.www;
          r8.xz = r3.ww * float2(0.5, 0.5) + r8.xz;
          r8.xz = r2.ww * float2(-0.5, 0.5) + r8.xz;
          r2.w = r5.w * 0.5 + -r3.w;
          r2.w = 0.666666687 + r2.w;
          r9.xyz = cmp((int3)r4.www == int3(3, 2, 1));
          r8.xz = float2(0.166666672, 0.166666672) + r8.xz;
          r3.w = r4.w ? 0 : r8.w;
          r3.w = r9.z ? r8.z : r3.w;
          r2.w = r9.y ? r2.w : r3.w;
          r2.w = r9.x ? r8.x : r2.w;
        } else {
          r2.w = 0;
        }
        r0.w = r2.w * r0.w;
        r0.w = 1.5 * r0.w;
        r1.w = -r8.y * r1.w + 0.0299999993;
        r0.w = r1.w * r0.w;
        r7.x = r0.w * 0.180000007 + r7.y;
        r7.xyz = max(float3(0, 0, 0), r7.xzw);
        r7.xyz = min(float3(65535, 65535, 65535), r7.xyz);
        r8.x = dot(float3(1.45143926, -0.236510754, -0.214928567), r7.xyz);
        r8.y = dot(float3(-0.0765537769, 1.17622972, -0.0996759236), r7.xyz);
        r8.z = dot(float3(0.00831614807, -0.00603244966, 0.997716308), r7.xyz);
        r7.xyz = max(float3(0, 0, 0), r8.xyz);
        r7.xyz = min(float3(65535, 65535, 65535), r7.xyz);
        r0.w = dot(r7.xyz, float3(0.272228718, 0.674081743, 0.0536895171));
        r7.xyz = r7.xyz + -r0.www;
        r7.xyz = r7.xyz * float3(0.959999979, 0.959999979, 0.959999979) + r0.www;
        r8.xyz = cmp(float3(0, 0, 0) >= r7.xyz);
        r7.xyz = log2(r7.xyz);
        r7.xyz = r8.xyz ? float3(-14, -14, -14) : r7.xyz;
        r8.xyz = cmp(float3(-17.4739323, -17.4739323, -17.4739323) >= r7.xyz);
        if (r8.x != 0) {
          r0.w = -4;
        } else {
          r1.w = cmp(-17.4739323 < r7.x);
          r2.w = cmp(r7.x < -2.47393107);
          r1.w = r1.w ? r2.w : 0;
          if (r1.w != 0) {
            r1.w = r7.x * 0.30103001 + 5.26017761;
            r2.w = 0.664385557 * r1.w;
            r3.w = (int)r2.w;
            r2.w = trunc(r2.w);
            r9.y = r1.w * 0.664385557 + -r2.w;
            r8.xw = (int2)r3.ww + int2(1, 2);
            r9.x = r9.y * r9.y;
            r10.x = icb[r3.w + 0].x;
            r10.y = icb[r8.x + 0].x;
            r10.z = icb[r8.w + 0].x;
            r11.x = dot(r10.xzy, float3(0.5, 0.5, -1));
            r11.y = dot(r10.xy, float2(-1, 1));
            r11.z = dot(r10.xy, float2(0.5, 0.5));
            r9.z = 1;
            r0.w = dot(r9.xyz, r11.xyz);
          } else {
            r1.w = cmp(r7.x >= -2.47393107);
            r2.w = cmp(r7.x < 15.5260687);
            r1.w = r1.w ? r2.w : 0;
            if (r1.w != 0) {
              r1.w = r7.x * 0.30103001 + 0.744727492;
              r2.w = 0.553654671 * r1.w;
              r3.w = (int)r2.w;
              r2.w = trunc(r2.w);
              r9.y = r1.w * 0.553654671 + -r2.w;
              r7.xw = (int2)r3.ww + int2(1, 2);
              r9.x = r9.y * r9.y;
              r10.x = icb[r3.w + 0].y;
              r10.y = icb[r7.x + 0].y;
              r10.z = icb[r7.w + 0].y;
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
        r9.x = exp2(r0.w);
        if (r8.y != 0) {
          r0.w = -4;
        } else {
          r1.w = cmp(-17.4739323 < r7.y);
          r2.w = cmp(r7.y < -2.47393107);
          r1.w = r1.w ? r2.w : 0;
          if (r1.w != 0) {
            r1.w = r7.y * 0.30103001 + 5.26017761;
            r2.w = 0.664385557 * r1.w;
            r3.w = (int)r2.w;
            r2.w = trunc(r2.w);
            r10.y = r1.w * 0.664385557 + -r2.w;
            r7.xw = (int2)r3.ww + int2(1, 2);
            r10.x = r10.y * r10.y;
            r11.x = icb[r3.w + 0].x;
            r11.y = icb[r7.x + 0].x;
            r11.z = icb[r7.w + 0].x;
            r12.x = dot(r11.xzy, float3(0.5, 0.5, -1));
            r12.y = dot(r11.xy, float2(-1, 1));
            r12.z = dot(r11.xy, float2(0.5, 0.5));
            r10.z = 1;
            r0.w = dot(r10.xyz, r12.xyz);
          } else {
            r1.w = cmp(r7.y >= -2.47393107);
            r2.w = cmp(r7.y < 15.5260687);
            r1.w = r1.w ? r2.w : 0;
            if (r1.w != 0) {
              r1.w = r7.y * 0.30103001 + 0.744727492;
              r2.w = 0.553654671 * r1.w;
              r3.w = (int)r2.w;
              r2.w = trunc(r2.w);
              r10.y = r1.w * 0.553654671 + -r2.w;
              r7.xy = (int2)r3.ww + int2(1, 2);
              r10.x = r10.y * r10.y;
              r11.x = icb[r3.w + 0].y;
              r11.y = icb[r7.x + 0].y;
              r11.z = icb[r7.y + 0].y;
              r12.x = dot(r11.xzy, float3(0.5, 0.5, -1));
              r12.y = dot(r11.xy, float2(-1, 1));
              r12.z = dot(r11.xy, float2(0.5, 0.5));
              r10.z = 1;
              r0.w = dot(r10.xyz, r12.xyz);
            } else {
              r0.w = 4;
            }
          }
        }
        r0.w = 3.32192802 * r0.w;
        r9.y = exp2(r0.w);
        if (r8.z != 0) {
          r0.w = -4;
        } else {
          r1.w = cmp(-17.4739323 < r7.z);
          r2.w = cmp(r7.z < -2.47393107);
          r1.w = r1.w ? r2.w : 0;
          if (r1.w != 0) {
            r1.w = r7.z * 0.30103001 + 5.26017761;
            r2.w = 0.664385557 * r1.w;
            r3.w = (int)r2.w;
            r2.w = trunc(r2.w);
            r8.y = r1.w * 0.664385557 + -r2.w;
            r7.xy = (int2)r3.ww + int2(1, 2);
            r8.x = r8.y * r8.y;
            r10.x = icb[r3.w + 0].x;
            r10.y = icb[r7.x + 0].x;
            r10.z = icb[r7.y + 0].x;
            r11.x = dot(r10.xzy, float3(0.5, 0.5, -1));
            r11.y = dot(r10.xy, float2(-1, 1));
            r11.z = dot(r10.xy, float2(0.5, 0.5));
            r8.z = 1;
            r0.w = dot(r8.xyz, r11.xyz);
          } else {
            r1.w = cmp(r7.z >= -2.47393107);
            r2.w = cmp(r7.z < 15.5260687);
            r1.w = r1.w ? r2.w : 0;
            if (r1.w != 0) {
              r1.w = r7.z * 0.30103001 + 0.744727492;
              r2.w = 0.553654671 * r1.w;
              r3.w = (int)r2.w;
              r2.w = trunc(r2.w);
              r7.y = r1.w * 0.553654671 + -r2.w;
              r8.xy = (int2)r3.ww + int2(1, 2);
              r7.x = r7.y * r7.y;
              r10.x = icb[r3.w + 0].y;
              r10.y = icb[r8.x + 0].y;
              r10.z = icb[r8.y + 0].y;
              r8.x = dot(r10.xzy, float3(0.5, 0.5, -1));
              r8.y = dot(r10.xy, float2(-1, 1));
              r8.z = dot(r10.xy, float2(0.5, 0.5));
              r7.z = 1;
              r0.w = dot(r7.xyz, r8.xyz);
            } else {
              r0.w = 4;
            }
          }
        }
        r0.w = 3.32192802 * r0.w;
        r9.z = exp2(r0.w);
        r7.x = dot(float3(0.695452213, 0.140678704, 0.163869068), r9.xyz);
        r7.y = dot(float3(0.0447945632, 0.859671116, 0.0955343172), r9.xyz);
        r7.z = dot(float3(-0.00552588282, 0.00402521016, 1.00150073), r9.xyz);
        r0.w = dot(float3(1.45143926, -0.236510754, -0.214928567), r7.xyz);
        r1.w = dot(float3(-0.0765537769, 1.17622972, -0.0996759236), r7.xyz);
        r2.w = dot(float3(0.00831614807, -0.00603244966, 0.997716308), r7.xyz);
        r3.w = cmp(0 >= r0.w);
        r0.w = log2(r0.w);
        r0.w = r3.w ? -13.2877121 : r0.w;
        r3.w = cmp(-12.7838678 >= r0.w);
        if (r3.w != 0) {
          r3.w = -2.30102992;
        } else {
          r4.w = cmp(-12.7838678 < r0.w);
          r5.w = cmp(r0.w < 2.26303458);
          r4.w = r4.w ? r5.w : 0;
          if (r4.w != 0) {
            r4.w = r0.w * 0.30103001 + 3.84832764;
            r5.w = 1.54540098 * r4.w;
            r6.w = (int)r5.w;
            r5.w = trunc(r5.w);
            r7.y = r4.w * 1.54540098 + -r5.w;
            r8.xy = (int2)r6.ww + int2(1, 2);
            r7.x = r7.y * r7.y;
            r9.x = icb[r6.w + 0].z;
            r9.y = icb[r8.x + 0].z;
            r9.z = icb[r8.y + 0].z;
            r8.x = dot(r9.xzy, float3(0.5, 0.5, -1));
            r8.y = dot(r9.xy, float2(-1, 1));
            r8.z = dot(r9.xy, float2(0.5, 0.5));
            r7.z = 1;
            r3.w = dot(r7.xyz, r8.xyz);
          } else {
            r4.w = cmp(r0.w >= 2.26303458);
            r5.w = cmp(r0.w < 12.4948215);
            r4.w = r4.w ? r5.w : 0;
            if (r4.w != 0) {
              r4.w = r0.w * 0.30103001 + -0.681241274;
              r5.w = 2.27267218 * r4.w;
              r6.w = (int)r5.w;
              r5.w = trunc(r5.w);
              r7.y = r4.w * 2.27267218 + -r5.w;
              r8.xy = (int2)r6.ww + int2(1, 2);
              r7.x = r7.y * r7.y;
              r9.x = icb[r6.w + 0].w;
              r9.y = icb[r8.x + 0].w;
              r9.z = icb[r8.y + 0].w;
              r8.x = dot(r9.xzy, float3(0.5, 0.5, -1));
              r8.y = dot(r9.xy, float2(-1, 1));
              r8.z = dot(r9.xy, float2(0.5, 0.5));
              r7.z = 1;
              r3.w = dot(r7.xyz, r8.xyz);
            } else {
              r3.w = r0.w * 0.0361235999 + 2.84967208;
            }
          }
        }
        r0.w = 3.32192802 * r3.w;
        r7.x = exp2(r0.w);
        r0.w = cmp(0 >= r1.w);
        r1.w = log2(r1.w);
        r0.w = r0.w ? -13.2877121 : r1.w;
        r1.w = cmp(-12.7838678 >= r0.w);
        if (r1.w != 0) {
          r1.w = -2.30102992;
        } else {
          r3.w = cmp(-12.7838678 < r0.w);
          r4.w = cmp(r0.w < 2.26303458);
          r3.w = r3.w ? r4.w : 0;
          if (r3.w != 0) {
            r3.w = r0.w * 0.30103001 + 3.84832764;
            r4.w = 1.54540098 * r3.w;
            r5.w = (int)r4.w;
            r4.w = trunc(r4.w);
            r8.y = r3.w * 1.54540098 + -r4.w;
            r9.xy = (int2)r5.ww + int2(1, 2);
            r8.x = r8.y * r8.y;
            r10.x = icb[r5.w + 0].z;
            r10.y = icb[r9.x + 0].z;
            r10.z = icb[r9.y + 0].z;
            r9.x = dot(r10.xzy, float3(0.5, 0.5, -1));
            r9.y = dot(r10.xy, float2(-1, 1));
            r9.z = dot(r10.xy, float2(0.5, 0.5));
            r8.z = 1;
            r1.w = dot(r8.xyz, r9.xyz);
          } else {
            r3.w = cmp(r0.w >= 2.26303458);
            r4.w = cmp(r0.w < 12.4948215);
            r3.w = r3.w ? r4.w : 0;
            if (r3.w != 0) {
              r3.w = r0.w * 0.30103001 + -0.681241274;
              r4.w = 2.27267218 * r3.w;
              r5.w = (int)r4.w;
              r4.w = trunc(r4.w);
              r8.y = r3.w * 2.27267218 + -r4.w;
              r9.xy = (int2)r5.ww + int2(1, 2);
              r8.x = r8.y * r8.y;
              r10.x = icb[r5.w + 0].w;
              r10.y = icb[r9.x + 0].w;
              r10.z = icb[r9.y + 0].w;
              r9.x = dot(r10.xzy, float3(0.5, 0.5, -1));
              r9.y = dot(r10.xy, float2(-1, 1));
              r9.z = dot(r10.xy, float2(0.5, 0.5));
              r8.z = 1;
              r1.w = dot(r8.xyz, r9.xyz);
            } else {
              r1.w = r0.w * 0.0361235999 + 2.84967208;
            }
          }
        }
        r0.w = 3.32192802 * r1.w;
        r7.y = exp2(r0.w);
        r0.w = cmp(0 >= r2.w);
        r1.w = log2(r2.w);
        r0.w = r0.w ? -13.2877121 : r1.w;
        r1.w = cmp(-12.7838678 >= r0.w);
        if (r1.w != 0) {
          r1.w = -2.30102992;
        } else {
          r2.w = cmp(-12.7838678 < r0.w);
          r3.w = cmp(r0.w < 2.26303458);
          r2.w = r2.w ? r3.w : 0;
          if (r2.w != 0) {
            r2.w = r0.w * 0.30103001 + 3.84832764;
            r3.w = 1.54540098 * r2.w;
            r4.w = (int)r3.w;
            r3.w = trunc(r3.w);
            r8.y = r2.w * 1.54540098 + -r3.w;
            r9.xy = (int2)r4.ww + int2(1, 2);
            r8.x = r8.y * r8.y;
            r10.x = icb[r4.w + 0].z;
            r10.y = icb[r9.x + 0].z;
            r10.z = icb[r9.y + 0].z;
            r9.x = dot(r10.xzy, float3(0.5, 0.5, -1));
            r9.y = dot(r10.xy, float2(-1, 1));
            r9.z = dot(r10.xy, float2(0.5, 0.5));
            r8.z = 1;
            r1.w = dot(r8.xyz, r9.xyz);
          } else {
            r2.w = cmp(r0.w >= 2.26303458);
            r3.w = cmp(r0.w < 12.4948215);
            r2.w = r2.w ? r3.w : 0;
            if (r2.w != 0) {
              r2.w = r0.w * 0.30103001 + -0.681241274;
              r3.w = 2.27267218 * r2.w;
              r4.w = (int)r3.w;
              r3.w = trunc(r3.w);
              r8.y = r2.w * 2.27267218 + -r3.w;
              r9.xy = (int2)r4.ww + int2(1, 2);
              r8.x = r8.y * r8.y;
              r10.x = icb[r4.w + 0].w;
              r10.y = icb[r9.x + 0].w;
              r10.z = icb[r9.y + 0].w;
              r9.x = dot(r10.xzy, float3(0.5, 0.5, -1));
              r9.y = dot(r10.xy, float2(-1, 1));
              r9.z = dot(r10.xy, float2(0.5, 0.5));
              r8.z = 1;
              r1.w = dot(r8.xyz, r9.xyz);
            } else {
              r1.w = r0.w * 0.0361235999 + 2.84967208;
            }
          }
        }
        r0.w = 3.32192802 * r1.w;
        r7.z = exp2(r0.w);
        r8.x = dot(float3(0.662454188, 0.134004205, 0.156187683), r7.xyz);
        r8.y = dot(float3(0.272228718, 0.674081743, 0.0536895171), r7.xyz);
        r8.z = dot(float3(-0.00557464967, 0.0040607336, 1.01033914), r7.xyz);
        r7.x = dot(float3(1.6410234, -0.324803293, -0.236424699), r8.xyz);
        r7.y = dot(float3(-0.663662851, 1.61533165, 0.0167563483), r8.xyz);
        r7.z = dot(float3(0.0117218941, -0.00828444213, 0.988394856), r8.xyz);
        r8.x = dot(r5.xyz, r7.xyz);
        r8.y = dot(r6.xyz, r7.xyz);
        r8.z = dot(r4.xyz, r7.xyz);
        r7.xyz = float3(9.99999975e-05, 9.99999975e-05, 9.99999975e-05) * r8.xyz;
        r7.xyz = log2(r7.xyz);
        r7.xyz = float3(0.159301758, 0.159301758, 0.159301758) * r7.xyz;
        r7.xyz = exp2(r7.xyz);
        r8.xyz = r7.xyz * float3(18.8515625, 18.8515625, 18.8515625) + float3(0.8359375, 0.8359375, 0.8359375);
        r7.xyz = r7.xyz * float3(18.6875, 18.6875, 18.6875) + float3(1, 1, 1);
        r7.xyz = rcp(r7.xyz);
        r7.xyz = r8.xyz * r7.xyz;
        r7.xyz = log2(r7.xyz);
        r7.xyz = float3(78.84375, 78.84375, 78.84375) * r7.xyz;
        r2.xyz = exp2(r7.xyz);
      } else {
        r0.w = cmp(asint(cb0[40].w) == 4);
        if (r0.w != 0) {
          r7.x = dot(float3(0.613191485, 0.33951208, 0.0473663323), r1.xyz);
          r7.y = dot(float3(0.0702069029, 0.916335821, 0.0134500116), r1.xyz);
          r7.z = dot(float3(0.0206188709, 0.109567292, 0.869606733), r1.xyz);
          r1.x = dot(r5.xyz, r7.xyz);
          r1.y = dot(r6.xyz, r7.xyz);
          r1.z = dot(r4.xyz, r7.xyz);
          r1.xyz = float3(0.0199999996, 0.0199999996, 0.0199999996) * r1.xyz;
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
          r0.w = cmp(asint(cb0[40].w) == 5);
          if (r0.w != 0) {
            r0.xyz = min(float3(0.99000001, 0.99000001, 0.99000001), r0.xyz);
            r1.xyz = r0.xyz * r0.xyz;
            r7.xyzw = float4(2.67146462e+13, 0.146704003, 2.67146462e+13, 0.146704003) * r0.xxyy;
            r1.xy = r1.xy * float2(-2.15104839e+13, -2.15104839e+13) + r7.xz;
            r1.xy = float2(2.77357507e+10, 2.77357507e+10) + r1.xy;
            r1.xy = rsqrt(r1.xy);
            r1.xy = float2(1, 1) / r1.xy;
            r1.xy = r1.xy * float2(-6.32456008e-08, -6.32456008e-08) + -r7.yw;
            r1.xy = float2(0.00832839962, 0.00832839962) + r1.xy;
            r0.xyw = float3(-1.01654005, -1.01654005, -1.01654005) + r0.xyz;
            r0.xyw = rcp(r0.xyw);
            r0.xy = r1.xy * r0.xy;
            r0.xy = min(float2(65504, 65504), r0.xy);
            r7.xy = max(float2(0, 0), r0.xy);
            r0.xy = float2(2.67146462e+13, 0.146704003) * r0.zz;
            r0.x = r1.z * -2.15104839e+13 + r0.x;
            r0.x = 2.77357507e+10 + r0.x;
            r0.x = rsqrt(r0.x);
            r0.x = 1 / r0.x;
            r0.x = r0.x * -6.32456008e-08 + -r0.y;
            r0.x = 0.00832839962 + r0.x;
            r0.x = r0.x * r0.w;
            r0.x = min(65504, r0.x);
            r7.z = max(0, r0.x);
            r0.x = dot(float3(0.412456393, 0.357576102, 0.180437505), r3.xyz);
            r0.y = dot(float3(0.212672904, 0.715152204, 0.0721750036), r3.xyz);
            r0.z = dot(float3(0.0193339009, 0.119191997, 0.950304091), r3.xyz);
            r1.x = dot(float3(1.6410234, -0.324803293, -0.236424699), r0.xyz);
            r1.y = dot(float3(-0.663662851, 1.61533165, 0.0167563483), r0.xyz);
            r1.z = dot(float3(0.0117218941, -0.00828444213, 0.988394856), r0.xyz);
            r0.x = dot(r1.xyz, float3(0.272228718, 0.674081743, 0.0536895171));
            r0.yzw = r1.xyz + -r0.xxx;
            r0.xyz = r0.yzw * float3(1.07526886, 1.07526886, 1.07526886) + r0.xxx;
            r0.w = dot(r0.xyz, float3(0.662454188, 0.272228718, -0.00557464967));
            r1.x = dot(r0.xyz, float3(0.134004205, 0.674081743, 0.0040607336));
            r0.x = dot(r0.xyz, float3(0.156187683, 0.0536895171, 1.01033914));
            r0.y = r1.x + r0.w;
            r0.x = r0.y + r0.x;
            r0.y = cmp(r0.x == 0.000000);
            r0.x = r0.y ? 1.00000001e-10 : r0.x;
            r0.y = r0.w / r0.x;
            r0.x = r1.x / r0.x;
            r0.z = max(0, r1.x);
            r0.z = min(65535, r0.z);
            r0.z = log2(r0.z);
            r0.z = 1.0192641 * r0.z;
            r1.y = exp2(r0.z);
            r0.z = r1.y * r0.y;
            r0.w = max(1.00000001e-10, r0.x);
            r0.y = 1 + -r0.y;
            r0.x = r0.y + -r0.x;
            r0.x = r0.x * r1.y;
            r1.xz = r0.zx / r0.ww;
            r0.x = dot(r1.xyz, float3(1.6410234, -0.663662851, 0.0117218941));
            r0.y = dot(r1.xyz, float3(-0.324803293, 1.61533165, -0.00828444213));
            r0.z = dot(r1.xyz, float3(-0.236424699, 0.0167563483, 0.988394856));
            r0.x = r0.x * 50.2408371 + 0.0199999996;
            r0.y = r0.y * 50.2408371 + 0.0199999996;
            r0.z = r0.z * 50.2408371 + 0.0199999996;
            r0.x = max(1.00000001e-10, r0.x);
            r0.x = log2(r0.x);
            r0.w = cmp(-5.64385605 >= r0.x);
            if (r0.w != 0) {
              r0.w = -2.54062319;
            } else {
              r1.x = cmp(2.26303458 >= r0.x);
              if (r1.x != 0) {
                r1.x = cmp(-5.27666664 >= r0.x);
                if (r1.x != 0) {
                  r1.xyzw = float4(-1.69896996, -1.69896996, -1.47790003, 0);
                } else {
                  r2.w = cmp(-4.49622965 >= r0.x);
                  if (r2.w != 0) {
                    r1.xyzw = float4(-1.69896996, -1.47790003, -1.22909999, 1.40129846e-45);
                  } else {
                    r8.xyz = cmp(float3(-3.47789264, -2.18051338, -0.735508144) < r0.xxx);
                    r9.xyzw = cmp(float4(-3.47789264, -2.18051338, -0.735508144, 0.757878006) >= r0.xxxx);
                    r8.xyz = r8.xyz ? r9.yzw : 0;
                    r10.xyzw = r8.zzzz ? float4(5, -0.448000014, 0.00517999986, 0.451108009) : float4(6, 0.00517999986, 0.451108009, 0.911373973);
                    r10.xyzw = r8.yyyy ? float4(4, -0.864799976, -0.448000014, 0.00517999986) : r10.xyzw;
                    r8.xyzw = r8.xxxx ? float4(3, -1.22909999, -0.864799976, -0.448000014) : r10.xyzw;
                    r1.xyzw = r9.xxxx ? float4(-1.47790003, -1.22909999, -0.864799976, 2.80259693e-45) : r8.yzwx;
                  }
                }
                r1.z = dot(r1.xzy, float3(0.5, 0.5, -1));
                r2.w = dot(r1.xy, float2(-1, 1));
                r1.x = dot(r1.xy, float2(0.5, 0.5));
                r1.x = -r0.x * 0.30103001 + r1.x;
                r1.y = r1.x * r1.z;
                r1.y = 4 * r1.y;
                r1.y = r2.w * r2.w + -r1.y;
                r1.y = sqrt(r1.y);
                r1.x = r1.x + r1.x;
                r1.y = -r1.y + -r2.w;
                r1.x = r1.x / r1.y;
                r1.y = (uint)r1.w;
                r1.x = r1.x + r1.y;
                r0.w = r1.x * 0.460266352 + -2.54062319;
              } else {
                r1.x = cmp(r0.x < 5.58496237);
                if (r1.x != 0) {
                  r1.x = cmp(3.29343224 >= r0.x);
                  if (r1.x != 0) {
                    r1.xyzw = float4(0.515438676, 0.847043753, 1.1358, 0);
                  } else {
                    r2.w = cmp(4.1789856 >= r0.x);
                    if (r2.w != 0) {
                      r1.xyzw = float4(0.847043753, 1.1358, 1.38020003, 1.40129846e-45);
                    } else {
                      r8.xyz = cmp(float3(4.81662941, 5.17921829, 5.39016056) < r0.xxx);
                      r9.xyzw = cmp(float4(4.81662941, 5.17921829, 5.39016056, 5.51657486) >= r0.xxxx);
                      r8.xyz = r8.xyz ? r9.yzw : 0;
                      r10.xyzw = r8.zzzz ? float4(5, 1.59850001, 1.64670002, 1.67460895) : float4(6, 1.64670002, 1.67460895, 1.68787301);
                      r10.xyzw = r8.yyyy ? float4(4, 1.51970005, 1.59850001, 1.64670002) : r10.xyzw;
                      r8.xyzw = r8.xxxx ? float4(3, 1.38020003, 1.51970005, 1.59850001) : r10.xyzw;
                      r1.xyzw = r9.xxxx ? float4(1.1358, 1.38020003, 1.51970005, 2.80259693e-45) : r8.yzwx;
                    }
                  }
                  r1.z = dot(r1.xzy, float3(0.5, 0.5, -1));
                  r2.w = dot(r1.xy, float2(-1, 1));
                  r1.x = dot(r1.xy, float2(0.5, 0.5));
                  r0.x = -r0.x * 0.30103001 + r1.x;
                  r1.x = r0.x * r1.z;
                  r1.x = 4 * r1.x;
                  r1.x = r2.w * r2.w + -r1.x;
                  r1.x = sqrt(r1.x);
                  r0.x = r0.x + r0.x;
                  r1.x = -r1.x + -r2.w;
                  r0.x = r0.x / r1.x;
                  r1.x = (uint)r1.w;
                  r0.x = r1.x + r0.x;
                  r0.w = r0.x * 0.331605047 + 0.681241274;
                } else {
                  r0.w = 3.00247669;
                }
              }
            }
            r0.x = 3.32192802 * r0.w;
            r1.x = exp2(r0.x);
            r0.x = max(1.00000001e-10, r0.y);
            r0.x = log2(r0.x);
            r0.y = cmp(-5.64385605 >= r0.x);
            if (r0.y != 0) {
              r0.y = -2.54062319;
            } else {
              r0.w = cmp(2.26303458 >= r0.x);
              if (r0.w != 0) {
                r0.w = cmp(-5.27666664 >= r0.x);
                if (r0.w != 0) {
                  r8.xyzw = float4(-1.69896996, -1.69896996, -1.47790003, 0);
                } else {
                  r0.w = cmp(-4.49622965 >= r0.x);
                  if (r0.w != 0) {
                    r8.xyzw = float4(-1.69896996, -1.47790003, -1.22909999, 1.40129846e-45);
                  } else {
                    r9.xyz = cmp(float3(-3.47789264, -2.18051338, -0.735508144) < r0.xxx);
                    r10.xyzw = cmp(float4(-3.47789264, -2.18051338, -0.735508144, 0.757878006) >= r0.xxxx);
                    r9.xyz = r9.xyz ? r10.yzw : 0;
                    r11.xyzw = r9.zzzz ? float4(5, -0.448000014, 0.00517999986, 0.451108009) : float4(6, 0.00517999986, 0.451108009, 0.911373973);
                    r11.xyzw = r9.yyyy ? float4(4, -0.864799976, -0.448000014, 0.00517999986) : r11.xyzw;
                    r9.xyzw = r9.xxxx ? float4(3, -1.22909999, -0.864799976, -0.448000014) : r11.xyzw;
                    r8.xyzw = r10.xxxx ? float4(-1.47790003, -1.22909999, -0.864799976, 2.80259693e-45) : r9.yzwx;
                  }
                }
                r0.w = dot(r8.xzy, float3(0.5, 0.5, -1));
                r1.w = dot(r8.xy, float2(-1, 1));
                r2.w = dot(r8.xy, float2(0.5, 0.5));
                r2.w = -r0.x * 0.30103001 + r2.w;
                r0.w = r2.w * r0.w;
                r0.w = 4 * r0.w;
                r0.w = r1.w * r1.w + -r0.w;
                r0.w = sqrt(r0.w);
                r2.w = r2.w + r2.w;
                r0.w = -r0.w + -r1.w;
                r0.w = r2.w / r0.w;
                r1.w = (uint)r8.w;
                r0.w = r1.w + r0.w;
                r0.y = r0.w * 0.460266352 + -2.54062319;
              } else {
                r0.w = cmp(r0.x < 5.58496237);
                if (r0.w != 0) {
                  r0.w = cmp(3.29343224 >= r0.x);
                  if (r0.w != 0) {
                    r8.xyzw = float4(0.515438676, 0.847043753, 1.1358, 0);
                  } else {
                    r0.w = cmp(4.1789856 >= r0.x);
                    if (r0.w != 0) {
                      r8.xyzw = float4(0.847043753, 1.1358, 1.38020003, 1.40129846e-45);
                    } else {
                      r9.xyz = cmp(float3(4.81662941, 5.17921829, 5.39016056) < r0.xxx);
                      r10.xyzw = cmp(float4(4.81662941, 5.17921829, 5.39016056, 5.51657486) >= r0.xxxx);
                      r9.xyz = r9.xyz ? r10.yzw : 0;
                      r11.xyzw = r9.zzzz ? float4(5, 1.59850001, 1.64670002, 1.67460895) : float4(6, 1.64670002, 1.67460895, 1.68787301);
                      r11.xyzw = r9.yyyy ? float4(4, 1.51970005, 1.59850001, 1.64670002) : r11.xyzw;
                      r9.xyzw = r9.xxxx ? float4(3, 1.38020003, 1.51970005, 1.59850001) : r11.xyzw;
                      r8.xyzw = r10.xxxx ? float4(1.1358, 1.38020003, 1.51970005, 2.80259693e-45) : r9.yzwx;
                    }
                  }
                  r0.w = dot(r8.xzy, float3(0.5, 0.5, -1));
                  r1.w = dot(r8.xy, float2(-1, 1));
                  r2.w = dot(r8.xy, float2(0.5, 0.5));
                  r0.x = -r0.x * 0.30103001 + r2.w;
                  r0.w = r0.x * r0.w;
                  r0.w = 4 * r0.w;
                  r0.w = r1.w * r1.w + -r0.w;
                  r0.w = sqrt(r0.w);
                  r0.x = r0.x + r0.x;
                  r0.w = -r0.w + -r1.w;
                  r0.x = r0.x / r0.w;
                  r0.w = (uint)r8.w;
                  r0.x = r0.x + r0.w;
                  r0.y = r0.x * 0.331605047 + 0.681241274;
                } else {
                  r0.y = 3.00247669;
                }
              }
            }
            r0.x = 3.32192802 * r0.y;
            r1.y = exp2(r0.x);
            r0.x = max(1.00000001e-10, r0.z);
            r0.x = log2(r0.x);
            r0.y = cmp(-5.64385605 >= r0.x);
            if (r0.y != 0) {
              r0.y = -2.54062319;
            } else {
              r0.z = cmp(2.26303458 >= r0.x);
              if (r0.z != 0) {
                r0.z = cmp(-5.27666664 >= r0.x);
                if (r0.z != 0) {
                  r8.xyzw = float4(-1.69896996, -1.69896996, -1.47790003, 0);
                } else {
                  r0.z = cmp(-4.49622965 >= r0.x);
                  if (r0.z != 0) {
                    r8.xyzw = float4(-1.69896996, -1.47790003, -1.22909999, 1.40129846e-45);
                  } else {
                    r9.xyz = cmp(float3(-3.47789264, -2.18051338, -0.735508144) < r0.xxx);
                    r10.xyzw = cmp(float4(-3.47789264, -2.18051338, -0.735508144, 0.757878006) >= r0.xxxx);
                    r9.xyz = r9.xyz ? r10.yzw : 0;
                    r11.xyzw = r9.zzzz ? float4(5, -0.448000014, 0.00517999986, 0.451108009) : float4(6, 0.00517999986, 0.451108009, 0.911373973);
                    r11.xyzw = r9.yyyy ? float4(4, -0.864799976, -0.448000014, 0.00517999986) : r11.xyzw;
                    r9.xyzw = r9.xxxx ? float4(3, -1.22909999, -0.864799976, -0.448000014) : r11.xyzw;
                    r8.xyzw = r10.xxxx ? float4(-1.47790003, -1.22909999, -0.864799976, 2.80259693e-45) : r9.yzwx;
                  }
                }
                r0.z = dot(r8.xzy, float3(0.5, 0.5, -1));
                r0.w = dot(r8.xy, float2(-1, 1));
                r1.w = dot(r8.xy, float2(0.5, 0.5));
                r1.w = -r0.x * 0.30103001 + r1.w;
                r0.z = r1.w * r0.z;
                r0.z = 4 * r0.z;
                r0.z = r0.w * r0.w + -r0.z;
                r0.z = sqrt(r0.z);
                r1.w = r1.w + r1.w;
                r0.z = -r0.z + -r0.w;
                r0.z = r1.w / r0.z;
                r0.w = (uint)r8.w;
                r0.z = r0.z + r0.w;
                r0.y = r0.z * 0.460266352 + -2.54062319;
              } else {
                r0.z = cmp(r0.x < 5.58496237);
                if (r0.z != 0) {
                  r0.z = cmp(3.29343224 >= r0.x);
                  if (r0.z != 0) {
                    r8.xyzw = float4(0.515438676, 0.847043753, 1.1358, 0);
                  } else {
                    r0.z = cmp(4.1789856 >= r0.x);
                    if (r0.z != 0) {
                      r8.xyzw = float4(0.847043753, 1.1358, 1.38020003, 1.40129846e-45);
                    } else {
                      r9.xyz = cmp(float3(4.81662941, 5.17921829, 5.39016056) < r0.xxx);
                      r10.xyzw = cmp(float4(4.81662941, 5.17921829, 5.39016056, 5.51657486) >= r0.xxxx);
                      r9.xyz = r9.xyz ? r10.yzw : 0;
                      r11.xyzw = r9.zzzz ? float4(5, 1.59850001, 1.64670002, 1.67460895) : float4(6, 1.64670002, 1.67460895, 1.68787301);
                      r11.xyzw = r9.yyyy ? float4(4, 1.51970005, 1.59850001, 1.64670002) : r11.xyzw;
                      r9.xyzw = r9.xxxx ? float4(3, 1.38020003, 1.51970005, 1.59850001) : r11.xyzw;
                      r8.xyzw = r10.xxxx ? float4(1.1358, 1.38020003, 1.51970005, 2.80259693e-45) : r9.yzwx;
                    }
                  }
                  r0.z = dot(r8.xzy, float3(0.5, 0.5, -1));
                  r0.w = dot(r8.xy, float2(-1, 1));
                  r1.w = dot(r8.xy, float2(0.5, 0.5));
                  r0.x = -r0.x * 0.30103001 + r1.w;
                  r0.z = r0.x * r0.z;
                  r0.z = 4 * r0.z;
                  r0.z = r0.w * r0.w + -r0.z;
                  r0.z = sqrt(r0.z);
                  r0.x = r0.x + r0.x;
                  r0.z = -r0.z + -r0.w;
                  r0.x = r0.x / r0.z;
                  r0.z = (uint)r8.w;
                  r0.x = r0.x + r0.z;
                  r0.y = r0.x * 0.331605047 + 0.681241274;
                } else {
                  r0.y = 3.00247669;
                }
              }
            }
            r0.x = 3.32192802 * r0.y;
            r1.z = exp2(r0.x);
            r0.x = dot(float3(0.695452213, 0.140678704, 0.163869068), r1.xyz);
            r0.y = dot(float3(0.0447945632, 0.859671116, 0.0955343172), r1.xyz);
            r0.z = dot(float3(-0.00552588282, 0.00402521016, 1.00150073), r1.xyz);
            r0.w = dot(float3(1.45143926, -0.236510754, -0.214928567), r0.xyz);
            r1.x = dot(float3(-0.0765537769, 1.17622972, -0.0996759236), r0.xyz);
            r0.x = dot(float3(0.00831614807, -0.00603244966, 0.997716308), r0.xyz);
            r0.xy = max(float2(1.00000001e-10, 1.00000001e-10), r0.xw);
            r0.y = log2(r0.y);
            r0.z = cmp(-13.2877121 >= r0.y);
            if (r0.z != 0) {
              r0.z = -5.26017761;
            } else {
              r0.w = cmp(2.26303434 >= r0.y);
              if (r0.w != 0) {
                r0.w = cmp(-11.8881445 < r0.y);
                r1.yz = cmp(float2(-11.8881445, -6.05027151) >= r0.yy);
                r0.w = r0.w ? r1.z : 0;
                r8.xyzw = r0.wwww ? float4(1, -4, -3.157377, -0.485249996) : float4(2, -3.157377, -0.485249996, 1.84773195);
                r8.xyzw = r1.yyyy ? float4(0, -4, -4, -3.15737653) : r8.xyzw;
                r0.w = dot(r8.ywz, float3(0.5, 0.5, -1));
                r1.y = dot(r8.yz, float2(-1, 1));
                r1.z = dot(r8.yz, float2(0.5, 0.5));
                r1.z = -r0.y * 0.30103001 + r1.z;
                r0.w = r1.z * r0.w;
                r0.w = 4 * r0.w;
                r0.w = r1.y * r1.y + -r0.w;
                r0.w = sqrt(r0.w);
                r1.z = r1.z + r1.z;
                r0.w = -r0.w + -r1.y;
                r0.w = r1.z / r0.w;
                r1.y = (uint)r8.x;
                r0.w = r1.y + r0.w;
                r0.z = r0.w * 1.50514996 + -5.26017761;
              } else {
                r0.w = cmp(r0.y < 13.2877121);
                r1.y = cmp(9.54913998 < r0.y);
                r1.zw = cmp(float2(9.54913998, 12.7364788) >= r0.yy);
                r1.y = r1.w ? r1.y : 0;
                r8.xyzw = r1.yyyy ? float4(1, 2.08103108, 3.66812396, 4) : float4(2, 3.66812396, 4, 4);
                r8.xyzw = r1.zzzz ? float4(0, -0.718548238, 2.08103061, 3.6681242) : r8.xyzw;
                r1.y = dot(r8.ywz, float3(0.5, 0.5, -1));
                r1.z = dot(r8.yz, float2(-1, 1));
                r1.w = dot(r8.yz, float2(0.5, 0.5));
                r0.y = -r0.y * 0.30103001 + r1.w;
                r1.y = r0.y * r1.y;
                r1.y = 4 * r1.y;
                r1.y = r1.z * r1.z + -r1.y;
                r1.y = sqrt(r1.y);
                r0.y = r0.y + r0.y;
                r1.y = -r1.y + -r1.z;
                r0.y = r0.y / r1.y;
                r1.y = (uint)r8.x;
                r0.y = r1.y + r0.y;
                r0.y = r0.y * 1.80618 + -0.744727492;
                r0.z = r0.w ? r0.y : 4.67381239;
              }
            }
            r0.y = 3.32192802 * r0.z;
            r8.x = exp2(r0.y);
            r0.y = max(1.00000001e-10, r1.x);
            r0.y = log2(r0.y);
            r0.z = cmp(-13.2877121 >= r0.y);
            if (r0.z != 0) {
              r0.z = -5.26017761;
            } else {
              r0.w = cmp(2.26303434 >= r0.y);
              if (r0.w != 0) {
                r0.w = cmp(-11.8881445 < r0.y);
                r1.xy = cmp(float2(-11.8881445, -6.05027151) >= r0.yy);
                r0.w = r0.w ? r1.y : 0;
                r9.xyzw = r0.wwww ? float4(1, -4, -3.157377, -0.485249996) : float4(2, -3.157377, -0.485249996, 1.84773195);
                r1.xyzw = r1.xxxx ? float4(0, -4, -4, -3.15737653) : r9.xyzw;
                r0.w = dot(r1.ywz, float3(0.5, 0.5, -1));
                r1.w = dot(r1.yz, float2(-1, 1));
                r1.y = dot(r1.yz, float2(0.5, 0.5));
                r1.y = -r0.y * 0.30103001 + r1.y;
                r0.w = r1.y * r0.w;
                r0.w = 4 * r0.w;
                r0.w = r1.w * r1.w + -r0.w;
                r0.w = sqrt(r0.w);
                r1.y = r1.y + r1.y;
                r0.w = -r0.w + -r1.w;
                r0.w = r1.y / r0.w;
                r1.x = (uint)r1.x;
                r0.w = r1.x + r0.w;
                r0.z = r0.w * 1.50514996 + -5.26017761;
              } else {
                r0.w = cmp(r0.y < 13.2877121);
                r1.x = cmp(9.54913998 < r0.y);
                r1.yz = cmp(float2(9.54913998, 12.7364788) >= r0.yy);
                r1.x = r1.z ? r1.x : 0;
                r9.xyzw = r1.xxxx ? float4(1, 2.08103108, 3.66812396, 4) : float4(2, 3.66812396, 4, 4);
                r1.xyzw = r1.yyyy ? float4(0, -0.718548238, 2.08103061, 3.6681242) : r9.xyzw;
                r1.w = dot(r1.ywz, float3(0.5, 0.5, -1));
                r2.w = dot(r1.yz, float2(-1, 1));
                r1.y = dot(r1.yz, float2(0.5, 0.5));
                r0.y = -r0.y * 0.30103001 + r1.y;
                r1.y = r0.y * r1.w;
                r1.y = 4 * r1.y;
                r1.y = r2.w * r2.w + -r1.y;
                r1.y = sqrt(r1.y);
                r0.y = r0.y + r0.y;
                r1.y = -r1.y + -r2.w;
                r0.y = r0.y / r1.y;
                r1.x = (uint)r1.x;
                r0.y = r1.x + r0.y;
                r0.y = r0.y * 1.80618 + -0.744727492;
                r0.z = r0.w ? r0.y : 4.67381239;
              }
            }
            r0.y = 3.32192802 * r0.z;
            r8.y = exp2(r0.y);
            r0.x = log2(r0.x);
            r0.y = cmp(-13.2877121 >= r0.x);
            if (r0.y != 0) {
              r0.y = -5.26017761;
            } else {
              r0.z = cmp(2.26303434 >= r0.x);
              if (r0.z != 0) {
                r0.z = cmp(-11.8881445 < r0.x);
                r1.xy = cmp(float2(-11.8881445, -6.05027151) >= r0.xx);
                r0.z = r0.z ? r1.y : 0;
                r9.xyzw = r0.zzzz ? float4(1, -4, -3.157377, -0.485249996) : float4(2, -3.157377, -0.485249996, 1.84773195);
                r1.xyzw = r1.xxxx ? float4(0, -4, -4, -3.15737653) : r9.xyzw;
                r0.z = dot(r1.ywz, float3(0.5, 0.5, -1));
                r0.w = dot(r1.yz, float2(-1, 1));
                r1.y = dot(r1.yz, float2(0.5, 0.5));
                r1.y = -r0.x * 0.30103001 + r1.y;
                r0.z = r1.y * r0.z;
                r0.z = 4 * r0.z;
                r0.z = r0.w * r0.w + -r0.z;
                r0.z = sqrt(r0.z);
                r1.y = r1.y + r1.y;
                r0.z = -r0.z + -r0.w;
                r0.z = r1.y / r0.z;
                r0.w = (uint)r1.x;
                r0.z = r0.z + r0.w;
                r0.y = r0.z * 1.50514996 + -5.26017761;
              } else {
                r0.z = cmp(r0.x < 13.2877121);
                r0.w = cmp(9.54913998 < r0.x);
                r1.xy = cmp(float2(9.54913998, 12.7364788) >= r0.xx);
                r0.w = r0.w ? r1.y : 0;
                r9.xyzw = r0.wwww ? float4(1, 2.08103108, 3.66812396, 4) : float4(2, 3.66812396, 4, 4);
                r1.xyzw = r1.xxxx ? float4(0, -0.718548238, 2.08103061, 3.6681242) : r9.xyzw;
                r0.w = dot(r1.ywz, float3(0.5, 0.5, -1));
                r1.w = dot(r1.yz, float2(-1, 1));
                r1.y = dot(r1.yz, float2(0.5, 0.5));
                r0.x = -r0.x * 0.30103001 + r1.y;
                r0.w = r0.x * r0.w;
                r0.w = 4 * r0.w;
                r0.w = r1.w * r1.w + -r0.w;
                r0.w = sqrt(r0.w);
                r0.x = r0.x + r0.x;
                r0.w = -r0.w + -r1.w;
                r0.x = r0.x / r0.w;
                r0.w = (uint)r1.x;
                r0.x = r0.x + r0.w;
                r0.x = r0.x * 1.80618 + -0.744727492;
                r0.y = r0.z ? r0.x : 4.67381239;
              }
            }
            r0.x = 3.32192802 * r0.y;
            r8.z = exp2(r0.x);
            r0.x = dot(r8.xyz, float3(0.272228718, 0.674081743, 0.0536895171));
            r0.yzw = r8.xyz + -r0.xxx;
            r0.xyz = r0.yzw * float3(1.04166675, 1.04166675, 1.04166675) + r0.xxx;
            r0.xyz = max(float3(0, 0, 0), r0.xyz);
            r0.xyz = min(float3(65504, 65504, 65504), r0.xyz);
            r1.y = dot(float3(0.695452213, 0.140678704, 0.163869068), r0.xyz);
            r1.z = dot(float3(0.0447945632, 0.859671116, 0.0955343172), r0.xyz);
            r1.w = dot(float3(-0.00552588282, 0.00402521016, 1.00150073), r0.xyz);
            r0.xyz = max(float3(0, 0, 0), r1.yzw);
            r0.yzw = min(float3(65504, 65504, 65504), r0.xyz);
            r1.xy = cmp(r0.zw == r0.yz);
            r1.x = r1.y ? r1.x : 0;
            r1.yz = r0.zw + -r0.wz;
            r1.y = 1.73205078 * r1.y;
            r1.w = r0.w + r0.z;
            r2.w = r0.y * 2 + -r0.z;
            r2.w = r2.w + -r0.w;
            r3.w = min(abs(r2.w), abs(r1.y));
            r4.w = max(abs(r2.w), abs(r1.y));
            r4.w = 1 / r4.w;
            r3.w = r4.w * r3.w;
            r4.w = r3.w * r3.w;
            r5.w = r4.w * 0.0208350997 + -0.0851330012;
            r5.w = r4.w * r5.w + 0.180141002;
            r5.w = r4.w * r5.w + -0.330299497;
            r4.w = r4.w * r5.w + 0.999866009;
            r5.w = r4.w * r3.w;
            r6.w = cmp(abs(r2.w) < abs(r1.y));
            r5.w = r5.w * -2 + 1.57079637;
            r5.w = r6.w ? r5.w : 0;
            r3.w = r3.w * r4.w + r5.w;
            r4.w = cmp(r2.w < -r2.w);
            r4.w = r4.w ? -3.141593 : 0;
            r3.w = r4.w + r3.w;
            r4.w = min(r2.w, r1.y);
            r1.y = max(r2.w, r1.y);
            r2.w = cmp(r4.w < -r4.w);
            r1.y = cmp(r1.y >= -r1.y);
            r1.y = r1.y ? r2.w : 0;
            r1.y = r1.y ? -r3.w : r3.w;
            r1.y = 57.2957802 * r1.y;
            r1.x = r1.x ? 0 : r1.y;
            r1.y = cmp(r1.x < 0);
            r2.w = 360 + r1.x;
            r1.x = r1.y ? r2.w : r1.x;
            r1.x = max(0, r1.x);
            r1.x = min(360, r1.x);
            r1.y = cmp(180 < r1.x);
            r2.w = -360 + r1.x;
            r1.x = r1.y ? r2.w : r1.x;
            r1.y = cmp(-67.5 < r1.x);
            r8.xy = cmp(r1.xx < float2(67.5, 0));
            r1.y = r1.y ? r8.x : 0;
            if (r1.y != 0) {
              r1.x = 67.5 + r1.x;
              r1.y = 0.0296296291 * r1.x;
              r2.w = (int)r1.y;
              r1.y = trunc(r1.y);
              r1.x = r1.x * 0.0296296291 + -r1.y;
              r1.y = r1.x * r1.x;
              r3.w = r1.y * r1.x;
              r8.xzw = float3(-0.166666672, -0.5, 0.166666672) * r3.www;
              r8.xz = r1.yy * float2(0.5, 0.5) + r8.xz;
              r8.xz = r1.xx * float2(-0.5, 0.5) + r8.xz;
              r1.x = r3.w * 0.5 + -r1.y;
              r1.x = 0.666666687 + r1.x;
              r9.xyz = cmp((int3)r2.www == int3(3, 2, 1));
              r8.xz = float2(0.166666672, 0.166666672) + r8.xz;
              r1.y = r2.w ? 0 : r8.w;
              r1.y = r9.z ? r8.z : r1.y;
              r1.x = r9.y ? r1.x : r1.y;
              r1.x = r9.x ? r8.x : r1.x;
            } else {
              r1.x = 0;
            }
            r1.y = r8.y ? r0.z : r0.w;
            r2.w = 1.5 * r1.x;
            r3.w = r1.x * 0.270000011 + -1;
            r4.w = 0.0299999993 + r1.y;
            r2.w = r4.w * r2.w;
            r0.y = -r2.w * 0.180000007 + r0.y;
            r1.x = r1.x * r1.y;
            r1.x = r1.x * r3.w;
            r1.x = 0.0324000008 * r1.x;
            r1.x = r0.y * r0.y + -r1.x;
            r1.x = sqrt(r1.x);
            r0.y = -r1.x + -r0.y;
            r1.x = r3.w + r3.w;
            r0.x = r0.y / r1.x;
            r0.y = min(r0.x, r0.z);
            r0.y = min(r0.y, r0.w);
            r1.x = max(r0.x, r0.z);
            r1.x = max(r1.x, r0.w);
            r1.xy = max(float2(1.00000001e-10, 0.00999999978), r1.xx);
            r0.y = max(1.00000001e-10, r0.y);
            r0.y = r1.x + -r0.y;
            r0.y = r0.y / r1.y;
            r1.xy = r0.zx + -r0.xw;
            r1.x = r1.x * r0.z;
            r1.x = r0.w * r1.z + r1.x;
            r1.x = r0.x * r1.y + r1.x;
            r1.x = sqrt(r1.x);
            r1.y = r1.w + r0.x;
            r1.x = r1.x * 1.75 + r1.y;
            r1.y = 0.333333343 * r1.x;
            r0.y = -0.400000006 + r0.y;
            r1.z = 2.5 * r0.y;
            r1.z = 1 + -abs(r1.z);
            r1.z = max(0, r1.z);
            r1.w = cmp(0 < r0.y);
            r0.y = cmp(r0.y < 0);
            r0.y = (int)-r1.w + (int)r0.y;
            r0.y = (int)r0.y;
            r1.z = -r1.z * r1.z + 1;
            r0.y = r0.y * r1.z + 1;
            r1.z = 0.0250000004 * r0.y;
            r8.xy = r0.yy * float2(0.0250000004, 0.0125000002) + float2(1, -1);
            r0.y = 0.0533333346 * r8.x;
            r0.y = cmp(r0.y >= r1.y);
            r1.w = -r1.z / r8.x;
            r1.x = cmp(r1.x >= 0.479999989);
            r1.y = 0.0799999982 / r1.y;
            r1.y = -0.5 + r1.y;
            r1.y = r1.z * r1.y;
            r1.y = r1.y / r8.y;
            r1.x = r1.x ? 0 : r1.y;
            r0.y = r0.y ? r1.w : r1.x;
            r0.y = 1 + r0.y;
            r0.xyz = r0.yyy * r0.xzw;
            r1.x = dot(float3(2.52168679, -1.13412941, -0.387554973), r0.xyz);
            r1.y = dot(float3(-0.276480824, 1.37271714, -0.0962390453), r0.xyz);
            r1.z = dot(float3(-0.0153779676, -0.152975112, 1.16835272), r0.xyz);
            r0.x = asuint(cb0[41].y);
            r0.yzw = r1.xyz * float3(0.666599989, 0.666599989, 0.666599989) + -r7.xyz;
            r0.xyz = r0.xxx * r0.yzw + r7.xyz;
            r1.x = dot(r5.xyz, r0.xyz);
            r1.y = dot(r6.xyz, r0.xyz);
            r1.z = dot(r4.xyz, r0.xyz);
            r0.xyz = float3(0.0199999996, 0.0199999996, 0.0199999996) * r1.xyz;
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
            r0.xyz = cb0[18].zzz * r3.xyz;
            r2.xyz = exp2(r0.xyz);
          }
        }
      }
    }
  }
  o0.xyz = float3(0.952381015, 0.952381015, 0.952381015) * r2.xyz;
  o0.w = 0;

  o0 = saturate(o0);

  return;
}
