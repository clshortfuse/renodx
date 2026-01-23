#include "../../common.hlsl"

// Life is Strange Remastered

// ---- Created with 3Dmigoto v1.4.1 on Sun Dec 14 02:48:03 2025
cbuffer cb0 : register(b0)
{
  float4 cb0[71];
}




// 3Dmigoto declarations
#define cmp -


void main(
  linear noperspective float2 v0 : TEXCOORD0,
  float4 v1 : SV_POSITION0,
  uint v2 : SV_RenderTargetArrayIndex0,
  out float4 o0 : SV_Target0)
{
  const float4 icb[] = { { -4.000000, -0.718548, -4.970622, 0.808913},
                              { -4.000000, 2.081031, -3.029378, 1.191087},
                              { -3.157377, 3.668124, -2.126200, 1.568300},
                              { -0.485250, 4.000000, -1.510500, 1.948300},
                              { 1.847732, 4.000000, -1.057800, 2.308300},
                              { 1.847732, 4.000000, -0.466800, 2.638400},
                              { -2.301030, 0.801995, 0.119380, 2.859500},
                              { -2.301030, 1.198005, 0.708813, 2.987261},
                              { -1.931200, 1.594300, 1.291187, 3.012739},
                              { -1.520500, 1.997300, 1.291187, 3.012739},
                              { -1.057800, 2.378300, 0, 0},
                              { -0.466800, 2.768400, 0, 0},
                              { 0.119380, 3.051500, 0, 0},
                              { 0.708813, 3.274629, 0, 0},
                              { 1.291187, 3.327431, 0, 0},
                              { 1.291187, 3.327431, 0, 0} };
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(-0.015625,-0.015625) + v0.xy;
  r0.xy = float2(1.03225803,1.03225803) * r0.xy;
  r0.z = (uint)v2.x;
  r1.z = 0.0322580636 * r0.z;
  r0.z = cmp(asuint(cb0[70].z) >= 3);
  r2.xy = log2(r0.xy);
  r2.z = log2(r1.z);
  r0.xyw = float3(0.0126833133,0.0126833133,0.0126833133) * r2.xyz;
  r0.xyw = exp2(r0.xyw);
  r2.xyz = float3(-0.8359375,-0.8359375,-0.8359375) + r0.xyw;
  r2.xyz = max(float3(0,0,0), r2.xyz);
  r0.xyw = -r0.xyw * float3(18.6875,18.6875,18.6875) + float3(18.8515625,18.8515625,18.8515625);
  r0.xyw = r2.xyz / r0.xyw;
  r0.xyw = log2(r0.xyw);
  r0.xyw = float3(6.27739477,6.27739477,6.27739477) * r0.xyw;
  r0.xyw = exp2(r0.xyw);
  r0.xyw = float3(100,100,100) * r0.xyw;
  r1.xy = v0.xy * float2(1.03225803,1.03225803) + float2(-0.0161290318,-0.0161290318);
  r1.xyz = float3(-0.434017599,-0.434017599,-0.434017599) + r1.xyz;
  r1.xyz = float3(14,14,14) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.xyz = r1.xyz * float3(0.180000007,0.180000007,0.180000007) + float3(-0.00266771927,-0.00266771927,-0.00266771927);
  r0.xyz = r0.zzz ? r0.xyw : r1.xyz;
  r1.x = dot(float3(0.613191485,0.33951208,0.0473663323), r0.xyz);
  r1.y = dot(float3(0.0702069029,0.916335821,0.0134500116), r0.xyz);
  r1.z = dot(float3(0.0206188709,0.109567292,0.869606733), r0.xyz);
  r0.y = dot(float3(0.695452213,0.140678704,0.163869068), r1.xyz);
  r0.z = dot(float3(0.0447945632,0.859671116,0.0955343172), r1.xyz);
  r0.w = dot(float3(-0.00552588236,0.00402521016,1.00150073), r1.xyz);
  r0.x = min(r0.y, r0.z);
  r0.x = min(r0.x, r0.w);
  r1.w = max(r0.y, r0.z);
  r1.w = max(r1.w, r0.w);
  r2.xy = max(float2(1.00000001e-10,0.00999999978), r1.ww);
  r0.x = max(1.00000001e-10, r0.x);
  r0.x = r2.x + -r0.x;
  r0.x = r0.x / r2.y;
  r2.xyz = r0.wzy + -r0.zyw;
  r2.xy = r2.xy * r0.wz;
  r1.w = r2.x + r2.y;
  r1.w = r0.y * r2.z + r1.w;
  r1.w = sqrt(r1.w);
  r2.x = r0.w + r0.z;
  r2.x = r2.x + r0.y;
  r1.w = r1.w * 1.75 + r2.x;
  r2.x = 0.333333343 * r1.w;
  r2.y = -0.400000006 + r0.x;
  r2.z = 2.5 * r2.y;
  r2.z = 1 + -abs(r2.z);
  r2.z = max(0, r2.z);
  r2.w = cmp(0 < r2.y);
  r2.y = cmp(r2.y < 0);
  r2.y = (int)-r2.w + (int)r2.y;
  r2.y = (int)r2.y;
  r2.z = -r2.z * r2.z + 1;
  r2.y = r2.y * r2.z + 1;
  r2.y = 0.0250000004 * r2.y;
  r2.z = cmp(0.159999996 >= r1.w);
  r1.w = cmp(r1.w >= 0.479999989);
  r2.x = 0.0799999982 / r2.x;
  r2.x = -0.5 + r2.x;
  r2.x = r2.y * r2.x;
  r1.w = r1.w ? 0 : r2.x;
  r1.w = r2.z ? r2.y : r1.w;
  r1.w = 1 + r1.w;
  r2.yzw = r1.www * r0.yzw;
  r3.xy = cmp(r2.zw == r2.yz);
  r3.x = r3.y ? r3.x : 0;
  r0.z = r0.z * r1.w + -r2.w;
  r0.z = 1.73205078 * r0.z;
  r3.y = r2.y * 2 + -r2.z;
  r0.w = -r0.w * r1.w + r3.y;
  r3.y = min(abs(r0.z), abs(r0.w));
  r3.z = max(abs(r0.z), abs(r0.w));
  r3.z = 1 / r3.z;
  r3.y = r3.y * r3.z;
  r3.z = r3.y * r3.y;
  r3.w = r3.z * 0.0208350997 + -0.0851330012;
  r3.w = r3.z * r3.w + 0.180141002;
  r3.w = r3.z * r3.w + -0.330299497;
  r3.z = r3.z * r3.w + 0.999866009;
  r3.w = r3.y * r3.z;
  r4.x = cmp(abs(r0.w) < abs(r0.z));
  r3.w = r3.w * -2 + 1.57079637;
  r3.w = r4.x ? r3.w : 0;
  r3.y = r3.y * r3.z + r3.w;
  r3.z = cmp(r0.w < -r0.w);
  r3.z = r3.z ? -3.141593 : 0;
  r3.y = r3.y + r3.z;
  r3.z = min(r0.z, r0.w);
  r0.z = max(r0.z, r0.w);
  r0.w = cmp(r3.z < -r3.z);
  r0.z = cmp(r0.z >= -r0.z);
  r0.z = r0.z ? r0.w : 0;
  r0.z = r0.z ? -r3.y : r3.y;
  r0.z = 57.2957802 * r0.z;
  r0.z = r3.x ? 0 : r0.z;
  r0.w = cmp(r0.z < 0);
  r3.x = 360 + r0.z;
  r0.z = r0.w ? r3.x : r0.z;
  r0.z = max(0, r0.z);
  r0.z = min(360, r0.z);
  r0.w = cmp(180 < r0.z);
  r3.x = -360 + r0.z;
  r0.z = r0.w ? r3.x : r0.z;
  r0.z = 0.0148148146 * r0.z;
  r0.z = 1 + -abs(r0.z);
  r0.z = max(0, r0.z);
  r0.w = r0.z * -2 + 3;
  r0.z = r0.z * r0.z;
  r0.z = r0.w * r0.z;
  r0.z = r0.z * r0.z;
  r0.x = r0.z * r0.x;
  r0.y = -r0.y * r1.w + 0.0299999993;
  r0.x = r0.x * r0.y;
  r2.x = r0.x * 0.180000007 + r2.y;
  r0.x = dot(float3(1.45143926,-0.236510754,-0.214928567), r2.xzw);
  r0.y = dot(float3(-0.0765537769,1.17622972,-0.0996759236), r2.xzw);
  r0.z = dot(float3(0.00831614807,-0.00603244966,0.997716308), r2.xzw);
  r0.xyz = max(float3(0,0,0), r0.xyz);
  r0.w = dot(r0.xyz, float3(0.272228718,0.674081743,0.0536895171));

  SetUngradedAP1(r0.xyz);

  r0.xyz = r0.xyz + -r0.www;
  r0.xyz = r0.xyz * float3(0.959999979,0.959999979,0.959999979) + r0.www;
  r2.xy = float2(1,0.180000007) + cb0[36].ww;
  r0.w = -cb0[36].y + r2.x;
  r1.w = 1 + cb0[37].x;
  r2.x = -cb0[36].z + r1.w;
  r2.z = cmp(0.800000012 < cb0[36].y);
  r3.xy = float2(0.819999993,1) + -cb0[36].yy;
  r3.xy = r3.xy / cb0[36].xx;
  r2.w = -0.744727492 + r3.x;
  r2.y = r2.y / r0.w;
  r3.x = -1 + r2.y;
  r3.x = 1 + -r3.x;
  r2.y = r2.y / r3.x;
  r2.y = log2(r2.y);
  r2.y = 0.346573591 * r2.y;
  r3.x = r0.w / cb0[36].x;
  r2.y = -r2.y * r3.x + -0.744727492;
  r2.y = r2.z ? r2.w : r2.y;
  r2.z = r3.y + -r2.y;
  r2.w = cb0[36].z / cb0[36].x;
  r2.w = r2.w + -r2.z;
  r0.xyz = log2(r0.xyz);
  r3.xyz = float3(0.30103001,0.30103001,0.30103001) * r0.xyz;
  r4.xyz = r0.xyz * float3(0.30103001,0.30103001,0.30103001) + r2.zzz;
  r4.xyz = cb0[36].xxx * r4.xyz;
  r2.z = r0.w + r0.w;
  r3.w = -2 * cb0[36].x;
  r0.w = r3.w / r0.w;
  r5.xyz = r0.xyz * float3(0.30103001,0.30103001,0.30103001) + -r2.yyy;
  r6.xyz = r5.xyz * r0.www;
  r6.xyz = float3(1.44269502,1.44269502,1.44269502) * r6.xyz;
  r6.xyz = exp2(r6.xyz);
  r6.xyz = float3(1,1,1) + r6.xyz;
  r6.xyz = r2.zzz / r6.xyz;
  r6.xyz = -cb0[36].www + r6.xyz;
  r0.w = r2.x + r2.x;
  r2.z = cb0[36].x + cb0[36].x;
  r2.x = r2.z / r2.x;
  r0.xyz = r0.xyz * float3(0.30103001,0.30103001,0.30103001) + -r2.www;
  r0.xyz = r2.xxx * r0.xyz;
  r0.xyz = float3(1.44269502,1.44269502,1.44269502) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = float3(1,1,1) + r0.xyz;
  r0.xyz = r0.www / r0.xyz;
  r0.xyz = r1.www + -r0.xyz;
  r7.xyz = cmp(r3.xyz < r2.yyy);
  r6.xyz = r7.xyz ? r6.xyz : r4.xyz;
  r3.xyz = cmp(r2.www < r3.xyz);
  r0.xyz = r3.xyz ? r0.xyz : r4.xyz;
  r0.w = r2.w + -r2.y;
  r3.xyz = saturate(r5.xyz / r0.www);
  r0.w = cmp(r2.w < r2.y);
  r2.xyz = float3(1,1,1) + -r3.xyz;
  r2.xyz = r0.www ? r2.xyz : r3.xyz;
  r3.xyz = -r2.xyz * float3(2,2,2) + float3(3,3,3);
  r2.xyz = r2.xyz * r2.xyz;
  r2.xyz = r2.xyz * r3.xyz;
  r0.xyz = r0.xyz + -r6.xyz;
  r0.xyz = r2.xyz * r0.xyz + r6.xyz;
  r0.w = dot(r0.xyz, float3(0.272228718,0.674081743,0.0536895171));
  r0.xyz = r0.xyz + -r0.www;
  r0.xyz = r0.xyz * float3(0.930000007,0.930000007,0.930000007) + r0.www;
  r0.xyz = max(float3(0,0,0), r0.xyz);

  SetUntonemappedAP1(r0.xyz);

  r2.x = dot(float3(1.70505154,-0.621790707,-0.0832583979), r0.xyz);
  r2.y = dot(float3(-0.130257145,1.14080286,-0.0105485283), r0.xyz);
  r2.z = dot(float3(-0.0240032747,-0.128968775,1.15297174), r0.xyz);

  SetTonemappedBT709(r2.xyz);

  r0.xyz = max(float3(0,0,0), r2.xyz);
  r0.xyz = saturate(-cb0[44].xyz * abs(cb0[44].xyz) + r0.xyz);
  r0.xyz = cb0[45].xyz * r0.xyz;
  r0.xyz = max(float3(9.99999994e-09,9.99999994e-09,9.99999994e-09), r0.xyz);
  r0.xyz = log2(r0.xyz);
  r0.xyz = cb0[46].xyz * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.w = dot(r0.xyz, cb0[47].xyz);
  r0.xyz = r0.xyz * cb0[44].www + r0.www;
  r0.xyz = cb0[48].xyz * r0.xyz;
  r2.xyz = r0.xyz * r0.xyz;
  r0.xyz = cb0[26].yyy * r0.xyz;
  r0.xyz = cb0[26].xxx * r2.xyz + r0.xyz;
  r0.xyz = cb0[26].zzz + r0.xyz;
  r2.xyz = cb0[42].yzw * r0.xyz;
  r0.xyz = -r0.xyz * cb0[42].yzw + cb0[43].xyz;
  r0.xyz = cb0[43].www * r0.xyz + r2.xyz;
  r0.xyz = max(float3(0,0,0), r0.xyz);
  r0.xyz = log2(r0.xyz);
  r0.xyz = cb0[27].yyy * r0.xyz;
  r2.xyz = exp2(r0.xyz);

  if (RENODX_TONE_MAP_TYPE != 0) {
    o0 = GenerateOutput(r2.xyz, asuint(cb0[70].z));
    return;
  }

  [branch]
  if (asuint(cb0[70].z) == 0) {
    r3.xyz = float3(12.9200001,12.9200001,12.9200001) * r2.xyz;
    r4.xyz = cmp(r2.xyz >= float3(0.00313066994,0.00313066994,0.00313066994));
    r0.xyz = float3(0.416666657,0.416666657,0.416666657) * r0.xyz;
    r0.xyz = exp2(r0.xyz);
    r0.xyz = r0.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
    r0.xyz = r4.xyz ? r0.xyz : r3.xyz;
  } else {
    r3.xyzw = cmp(asint(cb0[70].wwww) == int4(1,2,3,4));
    r4.xyz = r3.www ? float3(1,0,0) : float3(1.70505154,-0.621790707,-0.0832583979);
    r5.xyz = r3.www ? float3(0,1,0) : float3(-0.130257145,1.14080286,-0.0105485283);
    r6.xyz = r3.www ? float3(0,0,1) : float3(-0.0240032747,-0.128968775,1.15297174);
    r4.xyz = r3.zzz ? float3(0.695452213,0.140678704,0.163869068) : r4.xyz;
    r5.xyz = r3.zzz ? float3(0.0447945632,0.859671116,0.0955343172) : r5.xyz;
    r6.xyz = r3.zzz ? float3(-0.00552588282,0.00402521016,1.00150073) : r6.xyz;
    r4.xyz = r3.yyy ? float3(1.02579927,-0.0200525094,-0.00577136781) : r4.xyz;
    r5.xyz = r3.yyy ? float3(-0.00223502493,1.00458264,-0.00235231337) : r5.xyz;
    r3.yzw = r3.yyy ? float3(-0.00501400325,-0.0252933875,1.03044021) : r6.xyz;
    r4.xyz = r3.xxx ? float3(1.37915885,-0.308850735,-0.0703467429) : r4.xyz;
    r5.xyz = r3.xxx ? float3(-0.0693352968,1.08229232,-0.0129620517) : r5.xyz;
    r3.xyz = r3.xxx ? float3(-0.00215925858,-0.0454653986,1.04775953) : r3.yzw;
    r0.w = cmp(asint(cb0[70].z) == 1);
    if (r0.w != 0) {
      r6.x = dot(float3(0.613191485,0.33951208,0.0473663323), r2.xyz);
      r6.y = dot(float3(0.0702069029,0.916335821,0.0134500116), r2.xyz);
      r6.z = dot(float3(0.0206188709,0.109567292,0.869606733), r2.xyz);
      r7.x = dot(r4.xyz, r6.xyz);
      r7.y = dot(r5.xyz, r6.xyz);
      r7.z = dot(r3.xyz, r6.xyz);
      r6.xyz = max(float3(6.10351999e-05,6.10351999e-05,6.10351999e-05), r7.xyz);
      r7.xyz = float3(4.5,4.5,4.5) * r6.xyz;
      r6.xyz = max(float3(0.0179999992,0.0179999992,0.0179999992), r6.xyz);
      r6.xyz = log2(r6.xyz);
      r6.xyz = float3(0.449999988,0.449999988,0.449999988) * r6.xyz;
      r6.xyz = exp2(r6.xyz);
      r6.xyz = r6.xyz * float3(1.09899998,1.09899998,1.09899998) + float3(-0.0989999995,-0.0989999995,-0.0989999995);
      r0.xyz = min(r7.xyz, r6.xyz);
    } else {
      r6.x = dot(float3(1.70505154,-0.621790707,-0.0832583979), r1.xyz);
      r6.y = dot(float3(-0.130257145,1.14080286,-0.0105485283), r1.xyz);
      r6.z = dot(float3(-0.0240032747,-0.128968775,1.15297174), r1.xyz);
      r1.xy = cmp(asint(cb0[70].zz) == int2(3,5));
      r0.w = (int)r1.y | (int)r1.x;
      if (r0.w != 0) {
        r1.xyz = float3(1.5,1.5,1.5) * r6.xyz;
        r7.y = dot(float3(0.439700812,0.382978052,0.1773348), r1.xyz);
        r7.z = dot(float3(0.0897923037,0.813423157,0.096761629), r1.xyz);
        r7.w = dot(float3(0.0175439864,0.111544058,0.870704114), r1.xyz);
        r0.w = min(r7.y, r7.z);
        r0.w = min(r0.w, r7.w);
        r1.x = max(r7.y, r7.z);
        r1.x = max(r1.x, r7.w);
        r1.xy = max(float2(1.00000001e-10,0.00999999978), r1.xx);
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
        r1.yw = float2(0.333333343,2.5) * r1.xz;
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
          r7.xzw = float3(-0.166666672,-0.5,0.166666672) * r2.www;
          r7.xz = r1.zz * float2(0.5,0.5) + r7.xz;
          r7.xz = r1.yy * float2(-0.5,0.5) + r7.xz;
          r1.y = r2.w * 0.5 + -r1.z;
          r1.y = 0.666666687 + r1.y;
          r9.xyz = cmp((int3)r1.www == int3(3,2,1));
          r7.xz = float2(0.166666672,0.166666672) + r7.xz;
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
        r1.xyz = max(float3(0,0,0), r8.xzw);
        r1.xyz = min(float3(65535,65535,65535), r1.xyz);
        r7.x = dot(float3(1.45143926,-0.236510754,-0.214928567), r1.xyz);
        r7.y = dot(float3(-0.0765537769,1.17622972,-0.0996759236), r1.xyz);
        r7.z = dot(float3(0.00831614807,-0.00603244966,0.997716308), r1.xyz);
        r1.xyz = max(float3(0,0,0), r7.xyz);
        r1.xyz = min(float3(65535,65535,65535), r1.xyz);
        r0.w = dot(r1.xyz, float3(0.272228718,0.674081743,0.0536895171));
        r1.xyz = r1.xyz + -r0.www;
        r1.xyz = r1.xyz * float3(0.959999979,0.959999979,0.959999979) + r0.www;
        r7.xyz = cmp(float3(0,0,0) >= r1.xyz);
        r1.xyz = log2(r1.xyz);
        r1.xyz = r7.xyz ? float3(-14,-14,-14) : r1.xyz;
        r7.xyz = cmp(float3(-17.4739323,-17.4739323,-17.4739323) >= r1.xyz);
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
            r7.xw = (int2)r3.ww + int2(1,2);
            r8.x = r8.y * r8.y;
            r9.x = icb[r3.w+0].x;
            r9.y = icb[r7.x+0].x;
            r9.z = icb[r7.w+0].x;
            r10.x = dot(r9.xzy, float3(0.5,0.5,-1));
            r10.y = dot(r9.xy, float2(-1,1));
            r10.z = dot(r9.xy, float2(0.5,0.5));
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
              r1.xw = (int2)r2.ww + int2(1,2);
              r8.x = r8.y * r8.y;
              r9.x = icb[r2.w+0].y;
              r9.y = icb[r1.x+0].y;
              r9.z = icb[r1.w+0].y;
              r10.x = dot(r9.xzy, float3(0.5,0.5,-1));
              r10.y = dot(r9.xy, float2(-1,1));
              r10.z = dot(r9.xy, float2(0.5,0.5));
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
            r1.xw = (int2)r2.ww + int2(1,2);
            r9.x = r9.y * r9.y;
            r10.x = icb[r2.w+0].x;
            r10.y = icb[r1.x+0].x;
            r10.z = icb[r1.w+0].x;
            r11.x = dot(r10.xzy, float3(0.5,0.5,-1));
            r11.y = dot(r10.xy, float2(-1,1));
            r11.z = dot(r10.xy, float2(0.5,0.5));
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
              r1.xy = (int2)r1.ww + int2(1,2);
              r9.x = r9.y * r9.y;
              r10.x = icb[r1.w+0].y;
              r10.y = icb[r1.x+0].y;
              r10.z = icb[r1.y+0].y;
              r11.x = dot(r10.xzy, float3(0.5,0.5,-1));
              r11.y = dot(r10.xy, float2(-1,1));
              r11.z = dot(r10.xy, float2(0.5,0.5));
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
            r1.xy = (int2)r1.ww + int2(1,2);
            r7.x = r7.y * r7.y;
            r9.x = icb[r1.w+0].x;
            r9.y = icb[r1.x+0].x;
            r9.z = icb[r1.y+0].x;
            r10.x = dot(r9.xzy, float3(0.5,0.5,-1));
            r10.y = dot(r9.xy, float2(-1,1));
            r10.z = dot(r9.xy, float2(0.5,0.5));
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
              r1.xy = (int2)r1.zz + int2(1,2);
              r7.x = r7.y * r7.y;
              r9.x = icb[r1.z+0].y;
              r9.y = icb[r1.x+0].y;
              r9.z = icb[r1.y+0].y;
              r1.x = dot(r9.xzy, float3(0.5,0.5,-1));
              r1.y = dot(r9.xy, float2(-1,1));
              r1.z = dot(r9.xy, float2(0.5,0.5));
              r7.z = 1;
              r0.w = dot(r7.xyz, r1.xyz);
            } else {
              r0.w = 4;
            }
          }
        }
        r0.w = 3.32192802 * r0.w;
        r8.z = exp2(r0.w);
        r1.x = dot(float3(0.695452213,0.140678704,0.163869068), r8.xyz);
        r1.y = dot(float3(0.0447945632,0.859671116,0.0955343172), r8.xyz);
        r1.z = dot(float3(-0.00552588282,0.00402521016,1.00150073), r8.xyz);
        r0.w = dot(float3(1.45143926,-0.236510754,-0.214928567), r1.xyz);
        r1.w = dot(float3(-0.0765537769,1.17622972,-0.0996759236), r1.xyz);
        r1.x = dot(float3(0.00831614807,-0.00603244966,0.997716308), r1.xyz);
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
            r8.xy = (int2)r3.ww + int2(1,2);
            r7.x = r7.y * r7.y;
            r9.x = icb[r3.w+0].z;
            r9.y = icb[r8.x+0].z;
            r9.z = icb[r8.y+0].z;
            r8.x = dot(r9.xzy, float3(0.5,0.5,-1));
            r8.y = dot(r9.xy, float2(-1,1));
            r8.z = dot(r9.xy, float2(0.5,0.5));
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
              r8.xy = (int2)r3.ww + int2(1,2);
              r7.x = r7.y * r7.y;
              r9.x = icb[r3.w+0].w;
              r9.y = icb[r8.x+0].w;
              r9.z = icb[r8.y+0].w;
              r8.x = dot(r9.xzy, float3(0.5,0.5,-1));
              r8.y = dot(r9.xy, float2(-1,1));
              r8.z = dot(r9.xy, float2(0.5,0.5));
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
            r1.zw = (int2)r2.ww + int2(1,2);
            r8.x = r8.y * r8.y;
            r9.x = icb[r2.w+0].z;
            r9.y = icb[r1.z+0].z;
            r9.z = icb[r1.w+0].z;
            r10.x = dot(r9.xzy, float3(0.5,0.5,-1));
            r10.y = dot(r9.xy, float2(-1,1));
            r10.z = dot(r9.xy, float2(0.5,0.5));
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
              r1.zw = (int2)r2.ww + int2(1,2);
              r8.x = r8.y * r8.y;
              r9.x = icb[r2.w+0].w;
              r9.y = icb[r1.z+0].w;
              r9.z = icb[r1.w+0].w;
              r10.x = dot(r9.xzy, float3(0.5,0.5,-1));
              r10.y = dot(r9.xy, float2(-1,1));
              r10.z = dot(r9.xy, float2(0.5,0.5));
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
            r1.yz = (int2)r1.ww + int2(1,2);
            r8.x = r8.y * r8.y;
            r9.x = icb[r1.w+0].z;
            r9.y = icb[r1.y+0].z;
            r9.z = icb[r1.z+0].z;
            r10.x = dot(r9.xzy, float3(0.5,0.5,-1));
            r10.y = dot(r9.xy, float2(-1,1));
            r10.z = dot(r9.xy, float2(0.5,0.5));
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
              r1.yz = (int2)r1.ww + int2(1,2);
              r8.x = r8.y * r8.y;
              r9.x = icb[r1.w+0].w;
              r9.y = icb[r1.y+0].w;
              r9.z = icb[r1.z+0].w;
              r10.x = dot(r9.xzy, float3(0.5,0.5,-1));
              r10.y = dot(r9.xy, float2(-1,1));
              r10.z = dot(r9.xy, float2(0.5,0.5));
              r8.z = 1;
              r1.x = dot(r8.xyz, r10.xyz);
            } else {
              r1.x = r0.w * 0.0180617999 + 2.78077793;
            }
          }
        }
        r0.w = 3.32192802 * r1.x;
        r7.z = exp2(r0.w);
        r1.xyz = float3(-3.50738446e-05,-3.50738446e-05,-3.50738446e-05) + r7.xyz;
        r7.x = dot(r4.xyz, r1.xyz);
        r7.y = dot(r5.xyz, r1.xyz);
        r7.z = dot(r3.xyz, r1.xyz);
        r1.xyz = float3(9.99999975e-05,9.99999975e-05,9.99999975e-05) * r7.xyz;
        r1.xyz = log2(r1.xyz);
        r1.xyz = float3(0.159301758,0.159301758,0.159301758) * r1.xyz;
        r1.xyz = exp2(r1.xyz);
        r7.xyz = r1.xyz * float3(18.8515625,18.8515625,18.8515625) + float3(0.8359375,0.8359375,0.8359375);
        r1.xyz = r1.xyz * float3(18.6875,18.6875,18.6875) + float3(1,1,1);
        r1.xyz = rcp(r1.xyz);
        r1.xyz = r7.xyz * r1.xyz;
        r1.xyz = log2(r1.xyz);
        r1.xyz = float3(78.84375,78.84375,78.84375) * r1.xyz;
        r0.xyz = exp2(r1.xyz);
      } else {
        r1.xy = cmp(asint(cb0[70].zz) == int2(4,6));
        r0.w = (int)r1.y | (int)r1.x;
        if (r0.w != 0) {
          r1.xyz = float3(1.5,1.5,1.5) * r6.xyz;
          r7.y = dot(float3(0.439700812,0.382978052,0.1773348), r1.xyz);
          r7.z = dot(float3(0.0897923037,0.813423157,0.096761629), r1.xyz);
          r7.w = dot(float3(0.0175439864,0.111544058,0.870704114), r1.xyz);
          r0.w = min(r7.y, r7.z);
          r0.w = min(r0.w, r7.w);
          r1.x = max(r7.y, r7.z);
          r1.x = max(r1.x, r7.w);
          r1.xy = max(float2(1.00000001e-10,0.00999999978), r1.xx);
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
          r1.yw = float2(0.333333343,2.5) * r1.xz;
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
            r7.xzw = float3(-0.166666672,-0.5,0.166666672) * r2.www;
            r7.xz = r1.zz * float2(0.5,0.5) + r7.xz;
            r7.xz = r1.yy * float2(-0.5,0.5) + r7.xz;
            r1.y = r2.w * 0.5 + -r1.z;
            r1.y = 0.666666687 + r1.y;
            r9.xyz = cmp((int3)r1.www == int3(3,2,1));
            r7.xz = float2(0.166666672,0.166666672) + r7.xz;
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
          r1.xyz = max(float3(0,0,0), r8.xzw);
          r1.xyz = min(float3(65535,65535,65535), r1.xyz);
          r7.x = dot(float3(1.45143926,-0.236510754,-0.214928567), r1.xyz);
          r7.y = dot(float3(-0.0765537769,1.17622972,-0.0996759236), r1.xyz);
          r7.z = dot(float3(0.00831614807,-0.00603244966,0.997716308), r1.xyz);
          r1.xyz = max(float3(0,0,0), r7.xyz);
          r1.xyz = min(float3(65535,65535,65535), r1.xyz);
          r0.w = dot(r1.xyz, float3(0.272228718,0.674081743,0.0536895171));
          r1.xyz = r1.xyz + -r0.www;
          r1.xyz = r1.xyz * float3(0.959999979,0.959999979,0.959999979) + r0.www;
          r7.xyz = cmp(float3(0,0,0) >= r1.xyz);
          r1.xyz = log2(r1.xyz);
          r1.xyz = r7.xyz ? float3(-14,-14,-14) : r1.xyz;
          r7.xyz = cmp(float3(-17.4739323,-17.4739323,-17.4739323) >= r1.xyz);
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
              r7.xw = (int2)r3.ww + int2(1,2);
              r8.x = r8.y * r8.y;
              r9.x = icb[r3.w+0].x;
              r9.y = icb[r7.x+0].x;
              r9.z = icb[r7.w+0].x;
              r10.x = dot(r9.xzy, float3(0.5,0.5,-1));
              r10.y = dot(r9.xy, float2(-1,1));
              r10.z = dot(r9.xy, float2(0.5,0.5));
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
                r1.xw = (int2)r2.ww + int2(1,2);
                r8.x = r8.y * r8.y;
                r9.x = icb[r2.w+0].y;
                r9.y = icb[r1.x+0].y;
                r9.z = icb[r1.w+0].y;
                r10.x = dot(r9.xzy, float3(0.5,0.5,-1));
                r10.y = dot(r9.xy, float2(-1,1));
                r10.z = dot(r9.xy, float2(0.5,0.5));
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
              r1.xw = (int2)r2.ww + int2(1,2);
              r9.x = r9.y * r9.y;
              r10.x = icb[r2.w+0].x;
              r10.y = icb[r1.x+0].x;
              r10.z = icb[r1.w+0].x;
              r11.x = dot(r10.xzy, float3(0.5,0.5,-1));
              r11.y = dot(r10.xy, float2(-1,1));
              r11.z = dot(r10.xy, float2(0.5,0.5));
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
                r1.xy = (int2)r1.ww + int2(1,2);
                r9.x = r9.y * r9.y;
                r10.x = icb[r1.w+0].y;
                r10.y = icb[r1.x+0].y;
                r10.z = icb[r1.y+0].y;
                r11.x = dot(r10.xzy, float3(0.5,0.5,-1));
                r11.y = dot(r10.xy, float2(-1,1));
                r11.z = dot(r10.xy, float2(0.5,0.5));
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
              r1.xy = (int2)r1.ww + int2(1,2);
              r7.x = r7.y * r7.y;
              r9.x = icb[r1.w+0].x;
              r9.y = icb[r1.x+0].x;
              r9.z = icb[r1.y+0].x;
              r10.x = dot(r9.xzy, float3(0.5,0.5,-1));
              r10.y = dot(r9.xy, float2(-1,1));
              r10.z = dot(r9.xy, float2(0.5,0.5));
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
                r1.xy = (int2)r1.zz + int2(1,2);
                r7.x = r7.y * r7.y;
                r9.x = icb[r1.z+0].y;
                r9.y = icb[r1.x+0].y;
                r9.z = icb[r1.y+0].y;
                r1.x = dot(r9.xzy, float3(0.5,0.5,-1));
                r1.y = dot(r9.xy, float2(-1,1));
                r1.z = dot(r9.xy, float2(0.5,0.5));
                r7.z = 1;
                r0.w = dot(r7.xyz, r1.xyz);
              } else {
                r0.w = 4;
              }
            }
          }
          r0.w = 3.32192802 * r0.w;
          r8.z = exp2(r0.w);
          r1.x = dot(float3(0.695452213,0.140678704,0.163869068), r8.xyz);
          r1.y = dot(float3(0.0447945632,0.859671116,0.0955343172), r8.xyz);
          r1.z = dot(float3(-0.00552588282,0.00402521016,1.00150073), r8.xyz);
          r0.w = dot(float3(1.45143926,-0.236510754,-0.214928567), r1.xyz);
          r1.w = dot(float3(-0.0765537769,1.17622972,-0.0996759236), r1.xyz);
          r1.x = dot(float3(0.00831614807,-0.00603244966,0.997716308), r1.xyz);
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
              r8.xy = (int2)r3.ww + int2(1,2);
              r7.x = r7.y * r7.y;
              r9.x = icb[r3.w+6].x;
              r9.y = icb[r8.x+6].x;
              r9.z = icb[r8.y+6].x;
              r8.x = dot(r9.xzy, float3(0.5,0.5,-1));
              r8.y = dot(r9.xy, float2(-1,1));
              r8.z = dot(r9.xy, float2(0.5,0.5));
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
                r8.xy = (int2)r3.ww + int2(1,2);
                r7.x = r7.y * r7.y;
                r9.x = icb[r3.w+6].y;
                r9.y = icb[r8.x+6].y;
                r9.z = icb[r8.y+6].y;
                r8.x = dot(r9.xzy, float3(0.5,0.5,-1));
                r8.y = dot(r9.xy, float2(-1,1));
                r8.z = dot(r9.xy, float2(0.5,0.5));
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
              r1.zw = (int2)r2.ww + int2(1,2);
              r8.x = r8.y * r8.y;
              r9.x = icb[r2.w+6].x;
              r9.y = icb[r1.z+6].x;
              r9.z = icb[r1.w+6].x;
              r10.x = dot(r9.xzy, float3(0.5,0.5,-1));
              r10.y = dot(r9.xy, float2(-1,1));
              r10.z = dot(r9.xy, float2(0.5,0.5));
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
                r1.zw = (int2)r2.ww + int2(1,2);
                r8.x = r8.y * r8.y;
                r9.x = icb[r2.w+6].y;
                r9.y = icb[r1.z+6].y;
                r9.z = icb[r1.w+6].y;
                r10.x = dot(r9.xzy, float3(0.5,0.5,-1));
                r10.y = dot(r9.xy, float2(-1,1));
                r10.z = dot(r9.xy, float2(0.5,0.5));
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
              r1.yz = (int2)r1.ww + int2(1,2);
              r8.x = r8.y * r8.y;
              r9.x = icb[r1.w+6].x;
              r9.y = icb[r1.y+6].x;
              r9.z = icb[r1.z+6].x;
              r10.x = dot(r9.xzy, float3(0.5,0.5,-1));
              r10.y = dot(r9.xy, float2(-1,1));
              r10.z = dot(r9.xy, float2(0.5,0.5));
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
                r1.yz = (int2)r1.ww + int2(1,2);
                r8.x = r8.y * r8.y;
                r9.x = icb[r1.w+6].y;
                r9.y = icb[r1.y+6].y;
                r9.z = icb[r1.z+6].y;
                r10.x = dot(r9.xzy, float3(0.5,0.5,-1));
                r10.y = dot(r9.xy, float2(-1,1));
                r10.z = dot(r9.xy, float2(0.5,0.5));
                r8.z = 1;
                r1.x = dot(r8.xyz, r10.xyz);
              } else {
                r1.x = r0.w * 0.0361235999 + 2.84967208;
              }
            }
          }
          r0.w = 3.32192802 * r1.x;
          r7.z = exp2(r0.w);
          r1.x = dot(r4.xyz, r7.xyz);
          r1.y = dot(r5.xyz, r7.xyz);
          r1.z = dot(r3.xyz, r7.xyz);
          r1.xyz = float3(9.99999975e-05,9.99999975e-05,9.99999975e-05) * r1.xyz;
          r1.xyz = log2(r1.xyz);
          r1.xyz = float3(0.159301758,0.159301758,0.159301758) * r1.xyz;
          r1.xyz = exp2(r1.xyz);
          r7.xyz = r1.xyz * float3(18.8515625,18.8515625,18.8515625) + float3(0.8359375,0.8359375,0.8359375);
          r1.xyz = r1.xyz * float3(18.6875,18.6875,18.6875) + float3(1,1,1);
          r1.xyz = rcp(r1.xyz);
          r1.xyz = r7.xyz * r1.xyz;
          r1.xyz = log2(r1.xyz);
          r1.xyz = float3(78.84375,78.84375,78.84375) * r1.xyz;
          r0.xyz = exp2(r1.xyz);
        } else {
          r0.w = cmp(asint(cb0[70].z) == 7);
          if (r0.w != 0) {
            r1.x = dot(float3(0.613191485,0.33951208,0.0473663323), r6.xyz);
            r1.y = dot(float3(0.0702069029,0.916335821,0.0134500116), r6.xyz);
            r1.z = dot(float3(0.0206188709,0.109567292,0.869606733), r6.xyz);
            r7.x = dot(r4.xyz, r1.xyz);
            r7.y = dot(r5.xyz, r1.xyz);
            r7.z = dot(r3.xyz, r1.xyz);
            r1.xyz = float3(9.99999975e-05,9.99999975e-05,9.99999975e-05) * r7.xyz;
            r1.xyz = log2(r1.xyz);
            r1.xyz = float3(0.159301758,0.159301758,0.159301758) * r1.xyz;
            r1.xyz = exp2(r1.xyz);
            r7.xyz = r1.xyz * float3(18.8515625,18.8515625,18.8515625) + float3(0.8359375,0.8359375,0.8359375);
            r1.xyz = r1.xyz * float3(18.6875,18.6875,18.6875) + float3(1,1,1);
            r1.xyz = rcp(r1.xyz);
            r1.xyz = r7.xyz * r1.xyz;
            r1.xyz = log2(r1.xyz);
            r1.xyz = float3(78.84375,78.84375,78.84375) * r1.xyz;
            r0.xyz = exp2(r1.xyz);
          } else {
            r0.w = cmp(asint(cb0[70].z) == 8);
            r1.x = dot(float3(0.613191485,0.33951208,0.0473663323), r2.xyz);
            r1.y = dot(float3(0.0702069029,0.916335821,0.0134500116), r2.xyz);
            r1.z = dot(float3(0.0206188709,0.109567292,0.869606733), r2.xyz);
            r1.w = dot(r4.xyz, r1.xyz);
            r2.x = dot(r5.xyz, r1.xyz);
            r1.x = dot(r3.xyz, r1.xyz);
            r3.x = log2(r1.w);
            r3.y = log2(r2.x);
            r3.z = log2(r1.x);
            r1.xyz = cb0[27].zzz * r3.xyz;
            r1.xyz = exp2(r1.xyz);
            r0.xyz = r0.www ? r6.xyz : r1.xyz;
          }
        }
      }
    }
  }
  o0.xyz = float3(0.952381015,0.952381015,0.952381015) * r0.xyz;
  o0.w = 0;

  o0 = saturate(o0);

  return;
}