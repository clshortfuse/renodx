#include "./common.hlsli"

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

RWTexture3D<float4> u0 : register(u0);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1)
{
  float4 cb1[240];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[76];
}




// 3Dmigoto declarations
#define cmp -

[numthreads(8, 8, 8)]
void main(uint3 vThreadID: SV_DispatchThreadID)
{
  const float4 icb[] = { { -4.000000, -0.718548, -1.698970, 0.515439},
                              { -4.000000, 2.081031, -1.698970, 0.847044},
                              { -3.157377, 3.668124, -1.477900, 1.135800},
                              { -0.485250, 4.000000, -1.229100, 1.380200},
                              { 1.847732, 4.000000, -0.864800, 1.519700},
                              { 1.847732, 4.000000, -0.448000, 1.598500},
                              { -4.970622, 0.808913, 0.005180, 1.646700},
                              { -3.029378, 1.191087, 0.451108, 1.674609},
                              { -2.126200, 1.568300, 0.911374, 1.687873},
                              { -1.510500, 1.948300, 0.911374, 1.687873},
                              { -1.057800, 2.308300, -2.301030, 0.801995},
                              { -0.466800, 2.638400, -2.301030, 1.198005},
                              { 0.119380, 2.859500, -1.931200, 1.594300},
                              { 0.708813, 2.987261, -1.520500, 1.997300},
                              { 1.291187, 3.012739, -1.057800, 2.378300},
                              { 1.291187, 3.012739, -0.466800, 2.768400},
                              { 0, 0, 0.119380, 3.051500},
                              { 0, 0, 0.708813, 3.274629},
                              { 0, 0, 1.291187, 3.327431},
                              { 0, 0, 1.291187, 3.327431} };
// Needs manual fix for instruction:
// unknown dcl_: dcl_uav_typed_texture3d (float,float,float,float) u0
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13;
  uint4 bitmask, uiDest;
  float4 fDest;

// Needs manual fix for instruction:
// unknown dcl_: dcl_thread_group 8, 8, 8
  r0.xyz = (uint3)vThreadID.xyz;
  r0.xy = float2(0.5,0.5) + r0.xy;
  r0.xy = r0.xy * cb0[75].xy + float2(-0.015625,-0.015625);
  r0.xyz = float3(1.03225803,1.03225803,0.0322580636) * r0.xyz;

  float3 input_color = r0.xyz;
  
  float output_device = cb0[74].x;  // SDR when output device is 0
  float output_gamut = cb0[74].y;  // BT.709 when output gamut is 0

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    output_device = 0.f;
    output_gamut = 0.f;
  }
  

  r1.xy = log2(r0.xy);
  r1.z = log2(r0.z);
  r0.xyz = float3(0.0126833133,0.0126833133,0.0126833133) * r1.xyz;
  r0.xyz = exp2(r0.xyz);
  r1.xyz = float3(-0.8359375,-0.8359375,-0.8359375) + r0.xyz;  
  r1.xyz = max(float3(0,0,0), r1.xyz);  
  r0.xyz = -r0.xyz * float3(18.6875,18.6875,18.6875) + float3(18.8515625,18.8515625,18.8515625);
  r0.xyz = r1.xyz / r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(6.27739477,6.27739477,6.27739477) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = float3(10000,10000,10000) * r0.xyz;
  r0.xyz = r0.xyz / cb0[73].zzz;
  r0.w = 1.00055635 * cb0[52].z;
  r1.x = cmp(6996.10791 >= cb0[52].z);
  r1.yz = float2(4.60700006e+09,2.0064e+09) / r0.ww;
  r1.yz = float2(2967800,1901800) + -r1.yz;
  r1.yz = r1.yz / r0.ww;
  r1.yz = float2(99.1100006,247.479996) + r1.yz;
  r1.yz = r1.yz / r0.ww;
  r1.yz = float2(0.244063005,0.237039998) + r1.yz;
  r1.x = r1.x ? r1.y : r1.z;
  r0.w = r1.x * r1.x;
  r1.z = 2.86999989 * r1.x;
  r0.w = r0.w * -3 + r1.z;
  r1.y = -0.275000006 + r0.w;
  r2.xyz = cb0[52].zzz * float3(0.000154118257,0.00084242021,4.22806261e-05) + float3(0.860117733,1,0.317398727);
  r0.w = cb0[52].z * cb0[52].z;
  r2.xyz = r0.www * float3(1.28641219e-07,7.08145137e-07,4.20481676e-08) + r2.xyz;
  r2.x = r2.x / r2.y;
  r1.z = -cb0[52].z * 2.8974182e-05 + 1;
  r0.w = r0.w * 1.61456057e-07 + r1.z;
  r2.y = r2.z / r0.w;
  r1.zw = r2.xy + r2.xy;
  r0.w = 3 * r2.x;
  r1.z = -r2.y * 8 + r1.z;
  r1.z = 4 + r1.z;
  r3.x = r0.w / r1.z;
  r3.y = r1.w / r1.z;
  r0.w = cmp(cb0[52].z < 4000);
  r1.xy = r0.ww ? r3.xy : r1.xy;
  r0.w = dot(r2.xy, r2.xy);
  r0.w = rsqrt(r0.w);
  r1.zw = r2.xy * r0.ww;
  r0.w = cb0[52].w * -r1.w;
  r0.w = r0.w * 0.0500000007 + r2.x;
  r1.z = cb0[52].w * r1.z;
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

  // Chromatic Adaptation Bradford ConeResponse
  r0.w = dot(float3(0.895099998,0.266400009,-0.161400005), r2.xyz);
  r1.x = dot(float3(-0.750199974,1.71350002,0.0366999991), r2.xyz);
  r1.y = dot(float3(0.0388999991,-0.0684999973,1.02960002), r2.xyz);
  r0.w = 0.941379249 / r0.w;
  r1.xy = float2(1.04043639,1.0897665) / r1.xy;
  r2.xyz = float3(0.895099998,0.266400009,-0.161400005) * r0.www;
  r1.xzw = float3(-0.750199974,1.71350002,0.0366999991) * r1.xxx;
  r3.xyz = float3(0.0388999991,-0.0684999973,1.02960002) * r1.yyy;
  r4.x = r2.x;
  r4.y = r1.x;
  r4.z = r3.x;
  r5.x = dot(float3(0.986992896,-0.1470543,0.159962699), r4.xyz);
  r6.x = r2.y;
  r6.y = r1.z;
  r6.z = r3.y;
  r5.y = dot(float3(0.986992896,-0.1470543,0.159962699), r6.xyz);
  r3.x = r2.z;
  r3.y = r1.w;
  r5.z = dot(float3(0.986992896,-0.1470543,0.159962699), r3.xyz);
  r1.x = dot(float3(0.432305306,0.518360317,0.0492912009), r4.xyz);
  r1.y = dot(float3(0.432305306,0.518360317,0.0492912009), r6.xyz);
  r1.z = dot(float3(0.432305306,0.518360317,0.0492912009), r3.xyz);
  r2.x = dot(float3(-0.0085287001,0.040042799,0.968486726), r4.xyz);
  r2.y = dot(float3(-0.0085287001,0.040042799,0.968486726), r6.xyz);
  r2.z = dot(float3(-0.0085287001,0.040042799,0.968486726), r3.xyz);
  r3.x = dot(r5.xyz, float3(0.662454188,0.272228718,-0.00557464967));
  r4.x = dot(r5.xyz, float3(0.134004205,0.674081743,0.0040607336));
  r5.x = dot(r5.xyz, float3(0.156187683,0.0536895171,1.01033914));
  r3.y = dot(r1.xyz, float3(0.662454188,0.272228718,-0.00557464967));
  r4.y = dot(r1.xyz, float3(0.134004205,0.674081743,0.0040607336));
  r5.y = dot(r1.xyz, float3(0.156187683,0.0536895171,1.01033914));
  r3.z = dot(r2.xyz, float3(0.662454188,0.272228718,-0.00557464967));
  r4.z = dot(r2.xyz, float3(0.134004205,0.674081743,0.0040607336));
  r5.z = dot(r2.xyz, float3(0.156187683,0.0536895171,1.01033914));

  // XYZ -> AP1
  r1.x = dot(float3(1.6410234,-0.324803293,-0.236424699), r3.xyz);
  r1.y = dot(float3(1.6410234,-0.324803293,-0.236424699), r4.xyz);
  r1.z = dot(float3(1.6410234,-0.324803293,-0.236424699), r5.xyz);
  r2.x = dot(float3(-0.663662851,1.61533165,0.0167563483), r3.xyz);
  r2.y = dot(float3(-0.663662851,1.61533165,0.0167563483), r4.xyz);
  r2.z = dot(float3(-0.663662851,1.61533165,0.0167563483), r5.xyz);
  r3.x = dot(float3(0.0117218941,-0.00828444213,0.988394856), r3.xyz);
  r3.y = dot(float3(0.0117218941,-0.00828444213,0.988394856), r4.xyz);
  r3.z = dot(float3(0.0117218941,-0.00828444213,0.988394856), r5.xyz);
  r1.x = dot(r1.xyz, r0.xyz);
  r1.y = dot(r2.xyz, r0.xyz);
  r1.z = dot(r3.xyz, r0.xyz);

  float3 ap1_color = r1.rgb;

  r0.xyz = cb0[73].zzz * r1.xyz;
  r0.xyz = max(float3(9.99999975e-05,9.99999975e-05,9.99999975e-05), r0.xyz);
  r0.xyz = min(float3(10000,10000,10000), r0.xyz);
  r0.xyz = float3(9.99999975e-05,9.99999975e-05,9.99999975e-05) * r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(0.159301758,0.159301758,0.159301758) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r1.xyz = r0.xyz * float3(18.8515625,18.8515625,18.8515625) + float3(0.8359375,0.8359375,0.8359375);
  r0.xyz = r0.xyz * float3(18.6875,18.6875,18.6875) + float3(1,1,1);
  r0.xyz = rcp(r0.xyz);
  r0.xyz = r1.xyz * r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(78.84375,78.84375,78.84375) * r0.xyz;
  r0.xyz = exp2(r0.xyz);



  // does not run
  if (cb0[73].w == 0) {
    r1.xyz = min(float3(1,1,1), r0.xyz);
    r0.w = asuint(cb0[46].x);
    r1.w = -1 + r0.w;
    r1.z = r1.z * r1.w;
    r2.x = floor(r1.z);
    r1.z = frac(r1.z);
    r2.y = r0.w * r0.w;
    r2.y = 1 / r2.y;
    r2.z = r2.x * r0.w + 0.5;
    r1.w = r2.x * r0.w + r1.w;
    r1.w = 0.5 + r1.w;
    r1.w = r1.w + -r2.z;
    r1.x = r1.x * r1.w + r2.z;
    r3.y = r1.x * r2.y;
    r1.x = 0.5 / r0.w;
    r1.w = r1.x * -2 + 1;
    r3.z = r1.y * r1.w + r1.x;
    r1.xyw = t0.SampleLevel(s0_s, r3.yz, 0).xyz;
    r3.x = r0.w * r2.y + r3.y;
    r2.xyz = t0.SampleLevel(s0_s, r3.xz, 0).xyz;
    r2.xyz = r2.xyz + -r1.xyw;
    r1.xyz = r1.zzz * r2.xyz + r1.xyw;
    r1.xyz = cb0[41].xxx * r1.xyz;
    r1.xyz = cb0[40].xxx * r0.xyz + r1.xyz;
    r1.xyz = r1.xyz + -r0.xyz;
    r1.xyz = cb1[239].xxx * r1.xyz + r0.xyz;
    r1.xyz = log2(r1.xyz);
    r1.xyz = float3(0.0126833133,0.0126833133,0.0126833133) * r1.xyz;
    r1.xyz = exp2(r1.xyz);
    r2.xyz = float3(-0.8359375,-0.8359375,-0.8359375) + r1.xyz;
    r2.xyz = max(float3(0,0,0), r2.xyz);
    r1.xyz = -r1.xyz * float3(18.6875,18.6875,18.6875) + float3(18.8515625,18.8515625,18.8515625);
    r1.xyz = r2.xyz / r1.xyz;
    r1.xyz = log2(r1.xyz);
    r1.xyz = float3(6.27739477,6.27739477,6.27739477) * r1.xyz;
    r1.xyz = exp2(r1.xyz);
    r1.xyz = float3(10000,10000,10000) * r1.xyz;
    r1.xyz = r1.xyz / cb0[73].zzz;

    // y from AP1
    r0.w = dot(r1.xyz, float3(0.272228718,0.674081743,0.0536895171));

    r2.xyzw = cb0[58].xyzw * cb0[53].xyzw;
    r3.xyzw = cb0[59].xyzw * cb0[54].xyzw;
    r4.xyzw = cb0[60].xyzw * cb0[55].xyzw;
    r5.xyzw = cb0[61].xyzw * cb0[56].xyzw;
    r6.xyzw = cb0[62].xyzw + cb0[57].xyzw;
    r2.xyz = r2.xyz * r2.www;
    r1.xyz = r1.xyz + -r0.www;
    r2.xyz = r2.xyz * r1.xyz + r0.www;
    r2.xyz = max(float3(0,0,0), r2.xyz);
    r2.xyz = float3(5.55555534,5.55555534,5.55555534) * r2.xyz;
    r3.xyz = r3.xyz * r3.www;
    r2.xyz = log2(r2.xyz);
    r2.xyz = r3.xyz * r2.xyz;
    r2.xyz = exp2(r2.xyz);
    r2.xyz = float3(0.180000007,0.180000007,0.180000007) * r2.xyz;
    r3.xyz = r4.xyz * r4.www;
    r3.xyz = float3(1,1,1) / r3.xyz;
    r2.xyz = log2(r2.xyz);
    r2.xyz = r3.xyz * r2.xyz;
    r2.xyz = exp2(r2.xyz);
    r3.xyz = r5.xyz * r5.www;
    r4.xyz = r6.xyz + r6.www;
    r2.xyz = r2.xyz * r3.xyz + r4.xyz;
    r1.w = 1 / cb0[73].x;
    r1.w = saturate(r1.w * r0.w);
    r2.w = r1.w * -2 + 3;
    r1.w = r1.w * r1.w;
    r1.w = -r2.w * r1.w + 1;
    r3.xyzw = cb0[68].xyzw * cb0[53].xyzw;
    r4.xyzw = cb0[69].xyzw * cb0[54].xyzw;
    r5.xyzw = cb0[70].xyzw * cb0[55].xyzw;
    r6.xyzw = cb0[71].xyzw * cb0[56].xyzw;
    r7.xyzw = cb0[72].xyzw + cb0[57].xyzw;
    r3.xyz = r3.xyz * r3.www;
    r3.xyz = r3.xyz * r1.xyz + r0.www;
    r3.xyz = max(float3(0,0,0), r3.xyz);
    r3.xyz = float3(5.55555534,5.55555534,5.55555534) * r3.xyz;
    r4.xyz = r4.xyz * r4.www;
    r3.xyz = log2(r3.xyz);
    r3.xyz = r4.xyz * r3.xyz;
    r3.xyz = exp2(r3.xyz);
    r3.xyz = float3(0.180000007,0.180000007,0.180000007) * r3.xyz;
    r4.xyz = r5.xyz * r5.www;
    r4.xyz = float3(1,1,1) / r4.xyz;
    r3.xyz = log2(r3.xyz);
    r3.xyz = r4.xyz * r3.xyz;
    r3.xyz = exp2(r3.xyz);
    r4.xyz = r6.xyz * r6.www;
    r5.xyz = r7.xyz + r7.www;
    r3.xyz = r3.xyz * r4.xyz + r5.xyz;
    r2.w = 1 + -cb0[73].y;
    r3.w = -cb0[73].y + r0.w;
    r2.w = 1 / r2.w;
    r2.w = saturate(r3.w * r2.w);
    r3.w = r2.w * -2 + 3;
    r2.w = r2.w * r2.w;
    r4.x = r3.w * r2.w;
    r5.xyzw = cb0[63].xyzw * cb0[53].xyzw;
    r6.xyzw = cb0[64].xyzw * cb0[54].xyzw;
    r7.xyzw = cb0[65].xyzw * cb0[55].xyzw;
    r8.xyzw = cb0[66].xyzw * cb0[56].xyzw;
    r9.xyzw = cb0[67].xyzw + cb0[57].xyzw;
    r4.yzw = r5.xyz * r5.www;
    r1.xyz = r4.yzw * r1.xyz + r0.www;
    r1.xyz = max(float3(0,0,0), r1.xyz);
    r1.xyz = float3(5.55555534,5.55555534,5.55555534) * r1.xyz;
    r4.yzw = r6.xyz * r6.www;
    r1.xyz = log2(r1.xyz);
    r1.xyz = r4.yzw * r1.xyz;
    r1.xyz = exp2(r1.xyz);
    r1.xyz = float3(0.180000007,0.180000007,0.180000007) * r1.xyz;
    r4.yzw = r7.xyz * r7.www;
    r4.yzw = float3(1,1,1) / r4.yzw;
    r1.xyz = log2(r1.xyz);
    r1.xyz = r4.yzw * r1.xyz;
    r1.xyz = exp2(r1.xyz);
    r4.yzw = r8.xyz * r8.www;
    r5.xyz = r9.xyz + r9.www;
    r1.xyz = r1.xyz * r4.yzw + r5.xyz;
    r0.w = 1 + -r1.w;
    r0.w = -r3.w * r2.w + r0.w;
    r1.xyz = r1.xyz * r0.www;
    r1.xyz = r2.xyz * r1.www + r1.xyz;
    r1.xyz = r3.xyz * r4.xxx + r1.xyz;



    // Blue correct
    r2.x = dot(float3(0.938639402,1.02359565e-10,0.0613606237), r1.xyz);
    r2.y = dot(float3(8.36008554e-11,0.830794156,0.169205874), r1.xyz);
    r2.z = dot(float3(2.13187367e-12,-5.63307213e-12,1), r1.xyz);
    r0.w = t1.Load(float4(0,0,0,0)).x;
    r1.x = t1.Load(float4(3,0,0,0)).x;
    r1.y = cmp(0 < r1.x);
    r0.w = r1.x / r0.w;
    r0.w = r1.y ? r0.w : 1;
    r1.x = cmp(asuint(output_device) < 3);
    r1.yzw = r2.xyz * r0.www;
    r1.xyz = r1.xxx ? r1.yzw : r2.xyz;
    r2.xyz = max(float3(0,0,0), r1.xyz);

    float3 ap1_graded = r2.rgb;
    ap1_color = ap1_graded;



    if (cb0[51].x != 0) {
      r3.x = dot(r2.xyz, cb0[28].xyz);
      r3.y = dot(r2.xyz, cb0[29].xyz);
      r3.z = dot(r2.xyz, cb0[30].xyz);
      r0.w = dot(r2.xyz, cb0[33].xyz);
      r0.w = 1 + r0.w;
      r0.w = rcp(r0.w);
      r4.xyz = cb0[35].xyz * r0.www + cb0[34].xyz;
      r3.xyz = r4.xyz * r3.xyz;
      r3.xyz = max(float3(0,0,0), r3.xyz);
      r4.xyz = cb0[31].xxx + -r3.xyz;
      r4.xyz = max(float3(0,0,0), r4.xyz);
      r5.xyz = max(cb0[31].zzz, r3.xyz);
      r3.xyz = max(cb0[31].xxx, r3.xyz);
      r3.xyz = min(cb0[31].zzz, r3.xyz);
      r6.xyz = r5.xyz * cb0[32].xxx + cb0[32].yyy;
      r5.xyz = cb0[31].www + r5.xyz;
      r5.xyz = rcp(r5.xyz);
      r7.xyz = cb0[28].www * r4.xyz;
      r4.xyz = cb0[31].yyy + r4.xyz;
      r4.xyz = rcp(r4.xyz);
      r4.xyz = r7.xyz * r4.xyz + cb0[29].www;
      r3.xyz = r3.xyz * cb0[30].www + r4.xyz;
      r3.xyz = r6.xyz * r5.xyz + r3.xyz;
      r3.xyz = float3(-0.00200000009,-0.00200000009,-0.00200000009) + r3.xyz;

    } else {  // does not run
      // start of film tonemap
      // AP1 => AP0
      r4.y = dot(float3(0.695452213,0.140678704,0.163869068), r1.xyz);
      r4.z = dot(float3(0.0447945632,0.859671116,0.0955343172), r1.xyz);
      r4.w = dot(float3(-0.00552588236,0.00402521016,1.00150073), r1.xyz);
      r0.w = min(r4.y, r4.z);
      r0.w = min(r0.w, r4.w);
      r1.x = max(r4.y, r4.z);
      r1.x = max(r1.x, r4.w);
      r1.xy = max(float2(1.00000001e-10,0.00999999978), r1.xx);
      r0.w = max(1.00000001e-10, r0.w);
      r0.w = r1.x + -r0.w;
      r0.w = r0.w / r1.y;
      r1.xyz = r4.wzy + -r4.zyw;
      r1.xy = r4.wz * r1.xy;
      r1.x = r1.x + r1.y;
      r1.x = r4.y * r1.z + r1.x;
      r1.x = sqrt(r1.x);
      r1.y = r4.w + r4.z;
      r1.y = r1.y + r4.y;
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
      r5.yzw = r4.yzw * r1.xxx;
      r1.yz = cmp(r5.zw == r5.yz);
      r1.y = r1.z ? r1.y : 0;
      r1.z = r4.z * r1.x + -r5.w;
      r1.z = 1.73205078 * r1.z;
      r1.w = r5.y * 2 + -r5.z;
      r1.w = -r4.w * r1.x + r1.w;
      r2.w = min(abs(r1.z), abs(r1.w));
      r3.w = max(abs(r1.z), abs(r1.w));
      r3.w = 1 / r3.w;
      r2.w = r3.w * r2.w;
      r3.w = r2.w * r2.w;
      r4.x = r3.w * 0.0208350997 + -0.0851330012;
      r4.x = r3.w * r4.x + 0.180141002;
      r4.x = r3.w * r4.x + -0.330299497;
      r3.w = r3.w * r4.x + 0.999866009;
      r4.x = r3.w * r2.w;
      r4.z = cmp(abs(r1.w) < abs(r1.z));
      r4.x = r4.x * -2 + 1.57079637;
      r4.x = r4.z ? r4.x : 0;
      r2.w = r2.w * r3.w + r4.x;
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
      r1.y = 0.0148148146 * r1.y;
      r1.y = 1 + -abs(r1.y);
      r1.y = max(0, r1.y);
      r1.z = r1.y * -2 + 3;
      r1.y = r1.y * r1.y;
      r1.y = r1.z * r1.y;
      r1.y = r1.y * r1.y;
      r0.w = r1.y * r0.w;
      r1.x = -r4.y * r1.x + 0.0299999993;
      r0.w = r1.x * r0.w;
      r5.x = r0.w * 0.180000007 + r5.y;
      r1.x = dot(float3(1.45143926,-0.236510754,-0.214928567), r5.xzw);
      r1.y = dot(float3(-0.0765537769,1.17622972,-0.0996759236), r5.xzw);
      r1.z = dot(float3(0.00831614807,-0.00603244966,0.997716308), r5.xzw);
      r1.xyz = max(float3(0,0,0), r1.xyz);
      r0.w = dot(r1.xyz, float3(0.272228718,0.674081743,0.0536895171));
      r1.xyz = r1.xyz + -r0.www;
      r1.xyz = r1.xyz * float3(0.959999979,0.959999979,0.959999979) + r0.www;
      r0.w = cb1[152].w + -cb0[38].y;
      r1.w = cb0[38].z + -cb0[38].y;
      r0.w = saturate(r0.w / r1.w);
      r1.w = -cb0[38].x + cb0[36].w;
      r0.w = r0.w * r1.w + cb0[38].x;
      r1.w = cmp(cb1[152].w == 0.000000);
      r2.w = cb1[152].w + -cb0[39].y;
      r3.w = cb0[39].z + -cb0[39].y;
      r2.w = saturate(r2.w / r3.w);
      r3.w = cb0[39].x + -r0.w;
      r0.w = r2.w * r3.w + r0.w;
      r0.w = r1.w ? cb0[36].w : r0.w;
      r4.xyz = float3(1,1,0.180000007) + cb0[37].yzy;
      r1.w = r4.x + -r0.w;
      r2.w = -cb0[37].x + r4.y;
      r3.w = cmp(0.800000012 < r0.w);
      r4.xw = float2(0.819999993,1) + -r0.ww;
      r4.xw = r4.xw / cb0[36].zz;
      r0.w = -0.744727492 + r4.x;
      r4.x = r4.z / r1.w;
      r4.z = -1 + r4.x;
      r4.z = 1 + -r4.z;
      r4.x = r4.x / r4.z;
      r4.x = log2(r4.x);
      r4.x = 0.346573591 * r4.x;
      r4.z = r1.w / cb0[36].z;
      r4.x = -r4.x * r4.z + -0.744727492;
      r0.w = r3.w ? r0.w : r4.x;
      r3.w = r4.w + -r0.w;
      r4.x = cb0[37].x / cb0[36].z;
      r4.x = r4.x + -r3.w;
      r1.xyz = log2(r1.xyz);
      r5.xyz = float3(0.30103001,0.30103001,0.30103001) * r1.xyz;
      r6.xyz = r1.xyz * float3(0.30103001,0.30103001,0.30103001) + r3.www;
      r6.xyz = cb0[36].zzz * r6.xyz;
      r3.w = r1.w + r1.w;
      r4.z = -2 * cb0[36].z;
      r1.w = r4.z / r1.w;
      r7.xyz = r1.xyz * float3(0.30103001,0.30103001,0.30103001) + -r0.www;
      r8.xyz = r7.xyz * r1.www;
      r8.xyz = float3(1.44269502,1.44269502,1.44269502) * r8.xyz;
      r8.xyz = exp2(r8.xyz);
      r8.xyz = float3(1,1,1) + r8.xyz;
      r8.xyz = r3.www / r8.xyz;
      r8.xyz = -cb0[37].yyy + r8.xyz;
      r1.w = r2.w + r2.w;
      r3.w = cb0[36].z + cb0[36].z;
      r2.w = r3.w / r2.w;
      r1.xyz = r1.xyz * float3(0.30103001,0.30103001,0.30103001) + -r4.xxx;
      r1.xyz = r2.www * r1.xyz;
      r1.xyz = float3(1.44269502,1.44269502,1.44269502) * r1.xyz;
      r1.xyz = exp2(r1.xyz);
      r1.xyz = float3(1,1,1) + r1.xyz;
      r1.xyz = r1.www / r1.xyz;
      r1.xyz = r4.yyy + -r1.xyz;
      r4.yzw = cmp(r5.xyz < r0.www);
      r4.yzw = r4.yzw ? r8.xyz : r6.xyz;
      r5.xyz = cmp(r4.xxx < r5.xyz);
      r1.xyz = r5.xyz ? r1.xyz : r6.xyz;
      r1.w = r4.x + -r0.w;
      r5.xyz = saturate(r7.xyz / r1.www);
      r0.w = cmp(r4.x < r0.w);
      r6.xyz = float3(1,1,1) + -r5.xyz;
      r5.xyz = r0.www ? r6.xyz : r5.xyz;
      r6.xyz = -r5.xyz * float3(2,2,2) + float3(3,3,3);
      r5.xyz = r5.xyz * r5.xyz;
      r5.xyz = r5.xyz * r6.xyz;
      r1.xyz = r1.xyz + -r4.yzw;
      r1.xyz = r5.xyz * r1.xyz + r4.yzw;
      r0.w = dot(r1.xyz, float3(0.272228718,0.674081743,0.0536895171));
      r1.xyz = r1.xyz + -r0.www;
      r1.xyz = r1.xyz * float3(0.930000007,0.930000007,0.930000007) + r0.www;
      r1.xyz = max(float3(0,0,0), r1.xyz);
      r4.x = dot(float3(1.06537485,1.44678506e-06,-0.0653710067), r1.xyz);
      r4.y = dot(float3(-3.45525592e-07,1.20366347,-0.203667715), r1.xyz);
      r4.z = dot(float3(1.9865448e-08,2.12079581e-08,0.999999583), r1.xyz);
      r3.x = dot(float3(1.70505154,-0.621790707,-0.0832583979), r4.xyz);
      r3.y = dot(float3(-0.130257145,1.14080286,-0.0105485283), r4.xyz);
      r3.z = dot(float3(-0.0240032747,-0.128968775,1.15297174), r4.xyz);
    }
    // end code that does not run


    r1.x = dot(float3(1.70505154,-0.621790707,-0.0832583979), r2.xyz);
    r1.y = dot(float3(-0.130257145,1.14080286,-0.0105485283), r2.xyz);
    r1.z = dot(float3(-0.0240032747,-0.128968775,1.15297174), r2.xyz);
    r2.xyz = cb0[49].yzw * r1.xyz;
    r1.xyz = -r1.xyz * cb0[49].yzw + cb0[50].xyz;
    r1.xyz = cb0[50].www * r1.xyz + r2.xyz;
    r2.x = dot(float3(0.613191485,0.33951208,0.0473663323), r1.xyz);
    r2.y = dot(float3(0.0702069029,0.916335821,0.0134500116), r1.xyz);
    r2.z = dot(float3(0.0206188709, 0.109567292, 0.869606733), r1.xyz);
    if (asuint(output_device) == 0u) { // originally (output_device == 0) {    // SDR

      r1.xyz = log2(r2.xyz);
      r1.xyz = float3(0.899999976,0.899999976,0.899999976) * r1.xyz;
      r1.xyz = exp2(r1.xyz);
      r1.xyz = float3(1.5,1.5,1.5) * r1.xyz;  // 1.5x exposure boost
      r4.y = dot(float3(0.706346452,0.146768153,0.150477916), r1.xyz);
      r4.z = dot(float3(0.0459861904,0.856727183,0.0888853893), r1.xyz);
      r4.w = dot(float3(-0.00571021158,0.00647447165,0.925703824), r1.xyz);
      r0.w = min(r4.y, r4.z);
      r0.w = min(r0.w, r4.w);
      r1.x = max(r4.y, r4.z);
      r1.x = max(r1.x, r4.w);
      r1.xy = max(float2(1.00000001e-10,0.00999999978), r1.xx);
      r0.w = max(1.00000001e-10, r0.w);
      r0.w = r1.x + -r0.w;
      r0.w = r0.w / r1.y;
      r1.xyz = r4.wzy + -r4.zyw;
      r1.xy = r4.wz * r1.xy;
      r1.x = r1.x + r1.y;
      r1.x = r4.y * r1.z + r1.x;
      r1.x = sqrt(r1.x);
      r1.y = r4.w + r4.z;
      r1.y = r1.y + r4.y;
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
      r5.yzw = r4.yzw * r1.xxx;
      r1.yz = cmp(r5.zw == r5.yz);
      r1.y = r1.z ? r1.y : 0;
      r1.z = r4.z * r1.x + -r5.w;
      r1.z = 1.73205078 * r1.z;
      r1.w = r5.y * 2 + -r5.z;
      r1.w = -r4.w * r1.x + r1.w;
      r2.w = min(abs(r1.z), abs(r1.w));
      r3.w = max(abs(r1.z), abs(r1.w));
      r3.w = 1 / r3.w;
      r2.w = r3.w * r2.w;
      r3.w = r2.w * r2.w;
      r4.x = r3.w * 0.0208350997 + -0.0851330012;
      r4.x = r3.w * r4.x + 0.180141002;
      r4.x = r3.w * r4.x + -0.330299497;
      r3.w = r3.w * r4.x + 0.999866009;
      r4.x = r3.w * r2.w;
      r4.z = cmp(abs(r1.w) < abs(r1.z));
      r4.x = r4.x * -2 + 1.57079637;
      r4.x = r4.z ? r4.x : 0;
      r2.w = r2.w * r3.w + r4.x;
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
        r4.xzw = float3(-0.166666672,-0.5,0.166666672) * r2.www;
        r4.xz = r1.zz * float2(0.5,0.5) + r4.xz;
        r4.xz = r1.yy * float2(-0.5,0.5) + r4.xz;
        r1.y = r2.w * 0.5 + -r1.z;
        r1.y = 0.666666687 + r1.y;
        r6.xyz = cmp((int3)r1.www == int3(3,2,1));
        r4.xz = float2(0.166666672,0.166666672) + r4.xz;
        r1.z = r1.w ? 0 : r4.w;
        r1.z = r6.z ? r4.z : r1.z;
        r1.y = r6.y ? r1.y : r1.z;
        r1.y = r6.x ? r4.x : r1.y;
      } else {
        r1.y = 0;
      }
      r0.w = r1.y * r0.w;
      r0.w = 1.5 * r0.w;
      r1.x = -r4.y * r1.x + 0.0299999993;
      r0.w = r1.x * r0.w;
      r5.x = r0.w * 0.180000007 + r5.y;
      r1.xyz = max(float3(0,0,0), r5.xzw);
      r1.xyz = min(float3(65535,65535,65535), r1.xyz);
      r4.x = dot(float3(1.45143926,-0.236510754,-0.214928567), r1.xyz);
      r4.y = dot(float3(-0.0765537769,1.17622972,-0.0996759236), r1.xyz);
      r4.z = dot(float3(0.00831614807,-0.00603244966,0.997716308), r1.xyz);
      r1.xyz = max(float3(0,0,0), r4.xyz);
      r1.xyz = min(float3(65535,65535,65535), r1.xyz);
      r0.w = dot(r1.xyz, float3(0.272228718,0.674081743,0.0536895171));
      r1.xyz = r1.xyz + -r0.www;
      r1.xyz = r1.xyz * float3(0.959999979,0.959999979,0.959999979) + r0.www;

      // if HDR is enabled
      if (asint(cb0[74].x) != 0.f && RENODX_TONE_MAP_TYPE != 3.f) {
        u0[vThreadID] = GenerateOutput(r1.rgb);
        return;
      }

      r4.xyz = cmp(float3(0,0,0) >= r1.xyz);
      r1.xyz = log2(r1.xyz);
      r1.xyz = r4.xyz ? float3(-14,-14,-14) : r1.xyz;
      r4.xyz = cmp(float3(-17.4739323,-17.4739323,-17.4739323) >= r1.xyz);
      if (r4.x != 0) {
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
          r5.y = r1.w * 0.664385557 + -r2.w;
          r4.xw = (int2)r3.ww + int2(1,2);
          r5.x = r5.y * r5.y;
          r6.x = icb[r3.w+0].x;
          r6.y = icb[r4.x+0].x;
          r6.z = icb[r4.w+0].x;
          r7.x = dot(r6.xzy, float3(0.5,0.5,-1));
          r7.y = dot(r6.xy, float2(-1,1));
          r7.z = dot(r6.xy, float2(0.5,0.5));
          r5.z = 1;
          r0.w = dot(r5.xyz, r7.xyz);
        } else {
          r1.w = cmp(r1.x >= -2.47393107);
          r2.w = cmp(r1.x < 15.5260687);
          r1.w = r1.w ? r2.w : 0;
          if (r1.w != 0) {
            r1.x = r1.x * 0.30103001 + 0.744727492;
            r1.w = 0.553654671 * r1.x;
            r2.w = (int)r1.w;
            r1.w = trunc(r1.w);
            r5.y = r1.x * 0.553654671 + -r1.w;
            r1.xw = (int2)r2.ww + int2(1,2);
            r5.x = r5.y * r5.y;
            r6.x = icb[r2.w+0].y;
            r6.y = icb[r1.x+0].y;
            r6.z = icb[r1.w+0].y;
            r7.x = dot(r6.xzy, float3(0.5,0.5,-1));
            r7.y = dot(r6.xy, float2(-1,1));
            r7.z = dot(r6.xy, float2(0.5,0.5));
            r5.z = 1;
            r0.w = dot(r5.xyz, r7.xyz);
          } else {
            r0.w = 4;
          }
        }
      }
      r0.w = 3.32192802 * r0.w;
      r5.x = exp2(r0.w);
      if (r4.y != 0) {
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
          r6.y = r1.x * 0.664385557 + -r1.w;
          r1.xw = (int2)r2.ww + int2(1,2);
          r6.x = r6.y * r6.y;
          r7.x = icb[r2.w+0].x;
          r7.y = icb[r1.x+0].x;
          r7.z = icb[r1.w+0].x;
          r8.x = dot(r7.xzy, float3(0.5,0.5,-1));
          r8.y = dot(r7.xy, float2(-1,1));
          r8.z = dot(r7.xy, float2(0.5,0.5));
          r6.z = 1;
          r0.w = dot(r6.xyz, r8.xyz);
        } else {
          r1.x = cmp(r1.y >= -2.47393107);
          r1.w = cmp(r1.y < 15.5260687);
          r1.x = r1.w ? r1.x : 0;
          if (r1.x != 0) {
            r1.x = r1.y * 0.30103001 + 0.744727492;
            r1.y = 0.553654671 * r1.x;
            r1.w = (int)r1.y;
            r1.y = trunc(r1.y);
            r6.y = r1.x * 0.553654671 + -r1.y;
            r1.xy = (int2)r1.ww + int2(1,2);
            r6.x = r6.y * r6.y;
            r7.x = icb[r1.w+0].y;
            r7.y = icb[r1.x+0].y;
            r7.z = icb[r1.y+0].y;
            r8.x = dot(r7.xzy, float3(0.5,0.5,-1));
            r8.y = dot(r7.xy, float2(-1,1));
            r8.z = dot(r7.xy, float2(0.5,0.5));
            r6.z = 1;
            r0.w = dot(r6.xyz, r8.xyz);
          } else {
            r0.w = 4;
          }
        }
      }
      r0.w = 3.32192802 * r0.w;
      r5.y = exp2(r0.w);
      if (r4.z != 0) {
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
          r4.y = r1.x * 0.664385557 + -r1.y;
          r1.xy = (int2)r1.ww + int2(1,2);
          r4.x = r4.y * r4.y;
          r6.x = icb[r1.w+0].x;
          r6.y = icb[r1.x+0].x;
          r6.z = icb[r1.y+0].x;
          r7.x = dot(r6.xzy, float3(0.5,0.5,-1));
          r7.y = dot(r6.xy, float2(-1,1));
          r7.z = dot(r6.xy, float2(0.5,0.5));
          r4.z = 1;
          r0.w = dot(r4.xyz, r7.xyz);
        } else {
          r1.x = cmp(r1.z >= -2.47393107);
          r1.y = cmp(r1.z < 15.5260687);
          r1.x = r1.y ? r1.x : 0;
          if (r1.x != 0) {
            r1.x = r1.z * 0.30103001 + 0.744727492;
            r1.y = 0.553654671 * r1.x;
            r1.z = (int)r1.y;
            r1.y = trunc(r1.y);
            r4.y = r1.x * 0.553654671 + -r1.y;
            r1.xy = (int2)r1.zz + int2(1,2);
            r4.x = r4.y * r4.y;
            r6.x = icb[r1.z+0].y;
            r6.y = icb[r1.x+0].y;
            r6.z = icb[r1.y+0].y;
            r1.x = dot(r6.xzy, float3(0.5,0.5,-1));
            r1.y = dot(r6.xy, float2(-1,1));
            r1.z = dot(r6.xy, float2(0.5,0.5));
            r4.z = 1;
            r0.w = dot(r4.xyz, r1.xyz);
          } else {
            r0.w = 4;
          }
        }
      }
      r0.w = 3.32192802 * r0.w;
      r5.z = exp2(r0.w);
      r1.x = dot(float3(0.695452213,0.140678704,0.163869068), r5.xyz);
      r1.y = dot(float3(0.0447945632,0.859671116,0.0955343172), r5.xyz);
      r1.z = dot(float3(-0.00552588282,0.00402521016,1.00150073), r5.xyz);
      r0.w = dot(float3(1.45143926,-0.236510754,-0.214928567), r1.xyz);
      r1.w = dot(float3(-0.0765537769,1.17622972,-0.0996759236), r1.xyz);
      r1.x = dot(float3(0.00831614807,-0.00603244966,0.997716308), r1.xyz);
      r1.y = cmp(0 >= r0.w);
      r0.w = log2(r0.w);
      r0.w = r1.y ? -13.2877121 : r0.w;
      r1.y = cmp(-8.43976784 >= r0.w);
      if (r1.y != 0) {
        r1.y = -1.69896996;
      } else {
        r1.z = cmp(-8.43976784 < r0.w);
        r2.w = cmp(r0.w < 2.26303458);
        r1.z = r1.z ? r2.w : 0;
        if (r1.z != 0) {
          r1.z = r0.w * 0.30103001 + 2.54062319;
          r2.w = 2.17265511 * r1.z;
          r3.w = (int)r2.w;
          r2.w = trunc(r2.w);
          r4.y = r1.z * 2.17265511 + -r2.w;
          r5.xy = (int2)r3.ww + int2(1,2);
          r4.x = r4.y * r4.y;
          r6.x = icb[r3.w+0].z;
          r6.y = icb[r5.x+0].z;
          r6.z = icb[r5.y+0].z;
          r5.x = dot(r6.xzy, float3(0.5,0.5,-1));
          r5.y = dot(r6.xy, float2(-1,1));
          r5.z = dot(r6.xy, float2(0.5,0.5));
          r4.z = 1;
          r1.y = dot(r4.xyz, r5.xyz);
        } else {
          r1.z = cmp(r0.w >= 2.26303458);
          r2.w = cmp(r0.w < 9.97401142);
          r1.z = r1.z ? r2.w : 0;
          if (r1.z != 0) {
            r1.z = r0.w * 0.30103001 + -0.681241274;
            r2.w = 3.01563549 * r1.z;
            r3.w = (int)r2.w;
            r2.w = trunc(r2.w);
            r4.y = r1.z * 3.01563549 + -r2.w;
            r5.xy = (int2)r3.ww + int2(1,2);
            r4.x = r4.y * r4.y;
            r6.x = icb[r3.w+0].w;
            r6.y = icb[r5.x+0].w;
            r6.z = icb[r5.y+0].w;
            r5.x = dot(r6.xzy, float3(0.5,0.5,-1));
            r5.y = dot(r6.xy, float2(-1,1));
            r5.z = dot(r6.xy, float2(0.5,0.5));
            r4.z = 1;
            r1.y = dot(r4.xyz, r5.xyz);
          } else {
            r1.y = r0.w * 0.0120412 + 1.56114209;
          }
        }
      }
      r0.w = 3.32192802 * r1.y;
      r0.w = exp2(r0.w);
      r1.y = cmp(0 >= r1.w);
      r1.z = log2(r1.w);
      r1.y = r1.y ? -13.2877121 : r1.z;
      r1.z = cmp(-8.43976784 >= r1.y);
      if (r1.z != 0) {
        r1.z = -1.69896996;
      } else {
        r1.w = cmp(-8.43976784 < r1.y);
        r2.w = cmp(r1.y < 2.26303458);
        r1.w = r1.w ? r2.w : 0;
        if (r1.w != 0) {
          r1.w = r1.y * 0.30103001 + 2.54062319;
          r2.w = 2.17265511 * r1.w;
          r3.w = (int)r2.w;
          r2.w = trunc(r2.w);
          r4.y = r1.w * 2.17265511 + -r2.w;
          r5.xy = (int2)r3.ww + int2(1,2);
          r4.x = r4.y * r4.y;
          r6.x = icb[r3.w+0].z;
          r6.y = icb[r5.x+0].z;
          r6.z = icb[r5.y+0].z;
          r5.x = dot(r6.xzy, float3(0.5,0.5,-1));
          r5.y = dot(r6.xy, float2(-1,1));
          r5.z = dot(r6.xy, float2(0.5,0.5));
          r4.z = 1;
          r1.z = dot(r4.xyz, r5.xyz);
        } else {
          r1.w = cmp(r1.y >= 2.26303458);
          r2.w = cmp(r1.y < 9.97401142);
          r1.w = r1.w ? r2.w : 0;
          if (r1.w != 0) {
            r1.w = r1.y * 0.30103001 + -0.681241274;
            r2.w = 3.01563549 * r1.w;
            r3.w = (int)r2.w;
            r2.w = trunc(r2.w);
            r4.y = r1.w * 3.01563549 + -r2.w;
            r5.xy = (int2)r3.ww + int2(1,2);
            r4.x = r4.y * r4.y;
            r6.x = icb[r3.w+0].w;
            r6.y = icb[r5.x+0].w;
            r6.z = icb[r5.y+0].w;
            r5.x = dot(r6.xzy, float3(0.5,0.5,-1));
            r5.y = dot(r6.xy, float2(-1,1));
            r5.z = dot(r6.xy, float2(0.5,0.5));
            r4.z = 1;
            r1.z = dot(r4.xyz, r5.xyz);
          } else {
            r1.z = r1.y * 0.0120412 + 1.56114209;
          }
        }
      }
      r1.y = 3.32192802 * r1.z;
      r1.y = exp2(r1.y);
      r1.z = cmp(0 >= r1.x);
      r1.x = log2(r1.x);
      r1.x = r1.z ? -13.2877121 : r1.x;
      r1.z = cmp(-8.43976784 >= r1.x);
      if (r1.z != 0) {
        r1.z = -1.69896996;
      } else {
        r1.w = cmp(-8.43976784 < r1.x);
        r2.w = cmp(r1.x < 2.26303458);
        r1.w = r1.w ? r2.w : 0;
        if (r1.w != 0) {
          r1.w = r1.x * 0.30103001 + 2.54062319;
          r2.w = 2.17265511 * r1.w;
          r3.w = (int)r2.w;
          r2.w = trunc(r2.w);
          r4.y = r1.w * 2.17265511 + -r2.w;
          r5.xy = (int2)r3.ww + int2(1,2);
          r4.x = r4.y * r4.y;
          r6.x = icb[r3.w+0].z;
          r6.y = icb[r5.x+0].z;
          r6.z = icb[r5.y+0].z;
          r5.x = dot(r6.xzy, float3(0.5,0.5,-1));
          r5.y = dot(r6.xy, float2(-1,1));
          r5.z = dot(r6.xy, float2(0.5,0.5));
          r4.z = 1;
          r1.z = dot(r4.xyz, r5.xyz);
        } else {
          r1.w = cmp(r1.x >= 2.26303458);
          r2.w = cmp(r1.x < 9.97401142);
          r1.w = r1.w ? r2.w : 0;
          if (r1.w != 0) {
            r1.w = r1.x * 0.30103001 + -0.681241274;
            r2.w = 3.01563549 * r1.w;
            r3.w = (int)r2.w;
            r2.w = trunc(r2.w);
            r4.y = r1.w * 3.01563549 + -r2.w;
            r5.xy = (int2)r3.ww + int2(1,2);
            r4.x = r4.y * r4.y;
            r6.x = icb[r3.w+0].w;
            r6.y = icb[r5.x+0].w;
            r6.z = icb[r5.y+0].w;
            r5.x = dot(r6.xzy, float3(0.5,0.5,-1));
            r5.y = dot(r6.xy, float2(-1,1));
            r5.z = dot(r6.xy, float2(0.5,0.5));
            r4.z = 1;
            r1.z = dot(r4.xyz, r5.xyz);
          } else {
            r1.z = r1.x * 0.0120412 + 1.56114209;
          }
        }
      }
      r1.x = 3.32192802 * r1.z;
      r1.x = exp2(r1.x);
      r0.w = -0.0199999996 + r0.w;
      r4.x = 0.0208420176 * r0.w;
      r0.w = -0.0199999996 + r1.y;
      r4.y = 0.0208420176 * r0.w;
      r0.w = -0.0199999996 + r1.x;
      r4.z = 0.0208420176 * r0.w;
      r1.x = dot(float3(0.662454188,0.134004205,0.156187683), r4.xyz);
      r1.y = dot(float3(0.272228718,0.674081743,0.0536895171), r4.xyz);
      r1.z = dot(float3(-0.00557464967,0.0040607336,1.01033914), r4.xyz);
      r1.xyz = max(float3(0,0,0), r1.xyz);
      r0.w = r1.x + r1.y;
      r0.w = r0.w + r1.z;
      r1.z = cmp(r0.w == 0.000000);
      r0.w = r1.z ? 1.00000001e-10 : r0.w;
      r1.xz = r1.xy / r0.ww;
      r0.w = min(65535, r1.y);
      r0.w = log2(r0.w);
      r0.w = 0.981100023 * r0.w;
      r4.y = exp2(r0.w);
      r0.w = r4.y * r1.x;
      r1.y = max(1.00000001e-10, r1.z);
      r4.x = r0.w / r1.y;
      r0.w = 1 + -r1.x;
      r0.w = r0.w + -r1.z;
      r0.w = r0.w * r4.y;
      r4.z = r0.w / r1.y;
      r1.x = dot(float3(1.6410234,-0.324803293,-0.236424699), r4.xyz);
      r1.y = dot(float3(-0.663662851,1.61533165,0.0167563483), r4.xyz);
      r1.z = dot(float3(0.0117218941,-0.00828444213,0.988394856), r4.xyz);
      r0.w = dot(r1.xyz, float3(0.272228718,0.674081743,0.0536895171));
      r1.xyz = r1.xyz + -r0.www;
      r1.xyz = r1.xyz * float3(0.930000007,0.930000007,0.930000007) + r0.www;
      r4.x = dot(float3(0.662454188,0.134004205,0.156187683), r1.xyz);
      r4.y = dot(float3(0.272228718,0.674081743,0.0536895171), r1.xyz);
      r4.z = dot(float3(-0.00557464967,0.0040607336,1.01033914), r1.xyz);
      r1.x = dot(float3(0.987223983,-0.00611326983,0.0159533005), r4.xyz);
      r1.y = dot(float3(-0.00759836007,1.00186002,0.0053300201), r4.xyz);
      r1.z = dot(float3(0.00307257008,-0.00509594986,1.08168006), r4.xyz);
      r4.x = (dot(float3(3.2409699,-1.5373832,-0.498610765), r1.xyz));
      r4.y = (dot(float3(-0.969243646,1.8759675,0.0415550582), r1.xyz));
      r4.z = (dot(float3(0.0556300804,-0.203976959,1.05697155), r1.xyz));

      // if HDR is enabled
      // SDR in HDR
      if (asint(cb0[74].x) != 0.f) {
        r1.rgb = r4.rgb;
        if (RENODX_GAMMA_CORRECTION) {
          r1.rgb = renodx::color::correct::GammaSafe(r1.rgb);
        }
        r1.rgb = renodx::color::bt2020::from::BT709(r1.rgb);
        r1.rgb = renodx::color::pq::EncodeSafe(r1.rgb, RENODX_DIFFUSE_WHITE_NITS);
      } else {
        r4.rgb = saturate(r4.rgb);
        r1.xyz = log2(r4.xyz);
        r1.xyz = cb0[51].www * r1.xyz;
        r4.xyz = exp2(r1.xyz);
        r5.xyz = float3(12.9200001,12.9200001,12.9200001) * r4.xyz;
        r4.xyz = cmp(r4.xyz >= float3(0.00313066994,0.00313066994,0.00313066994));
        r1.xyz = float3(0.416666657,0.416666657,0.416666657) * r1.xyz;
        r1.xyz = exp2(r1.xyz);
        r1.xyz = r1.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
        r1.xyz = r4.xyz ? r1.xyz : r5.xyz;
        r0.w = cb0[52].y + -cb0[52].x;
        r1.xyz = r1.xyz * r0.www + cb0[52].xxx;
      }



    } else {
      r4.xyzw = cmp(asint(output_gamut) == int4(1,2,3,4));
      r5.xyz = r4.www ? float3(1,0,0) : float3(1.70505154,-0.621790707,-0.0832583979);
      r6.xyz = r4.www ? float3(0,1,0) : float3(-0.130257145,1.14080286,-0.0105485283);
      r7.xyz = r4.www ? float3(0,0,1) : float3(-0.0240032747,-0.128968775,1.15297174);


      r5.xyz = r4.zzz ? float3(0.695452213,0.140678704,0.163869068) : r5.xyz;
      r6.xyz = r4.zzz ? float3(0.0447945632,0.859671116,0.0955343172) : r6.xyz;
      r7.xyz = r4.zzz ? float3(-0.00552588282,0.00402521016,1.00150073) : r7.xyz;

      // AP1 -> BT.2020
      r5.xyz = r4.yyy ? float3(1.02579927,-0.0200525094,-0.00577136781) : r5.xyz;
      r6.xyz = r4.yyy ? float3(-0.00223502493,1.00458264,-0.00235231337) : r6.xyz;
      r4.yzw = r4.yyy ? float3(-0.00501400325,-0.0252933875,1.03044021) : r7.xyz;


      r5.xyz = r4.xxx ? float3(1.37915885,-0.308850735,-0.0703467429) : r5.xyz;
      r6.xyz = r4.xxx ? float3(-0.0693352968,1.08229232,-0.0129620517) : r6.xyz;
      r4.xyz = r4.xxx ? float3(-0.00215925858,-0.0454653986,1.04775953) : r4.yzw;
      r7.xyz = r3.xyz * r3.xyz;
      r3.xyz = cb0[26].yyy * r3.xyz;
      r3.xyz = cb0[26].xxx * r7.xyz + r3.xyz;
      r3.xyz = cb0[26].zzz + r3.xyz;
      r7.xyz = cb0[49].yzw * r3.xyz;
      r3.xyz = -r3.xyz * cb0[49].yzw + cb0[50].xyz;
      r3.xyz = cb0[50].www * r3.xyz + r7.xyz;
      r7.xyz = max(float3(0,0,0), r3.xyz);
      r7.xyz = log2(r7.xyz);
      r7.xyz = cb0[27].yyy * r7.xyz;
      r7.xyz = exp2(r7.xyz);
      r0.w = cmp(asint(output_device) == 1);
      if (r0.w != 0) {  // output device

        // BT.709 -> AP1
        r8.x = dot(float3(0.613191485,0.33951208,0.0473663323), r7.xyz);
        r8.y = dot(float3(0.0702069029,0.916335821,0.0134500116), r7.xyz);
        r8.z = dot(float3(0.0206188709,0.109567292,0.869606733), r7.xyz);

        r9.x = dot(r5.xyz, r8.xyz);
        r9.y = dot(r6.xyz, r8.xyz);
        r9.z = dot(r4.xyz, r8.xyz);
        r8.xyz = max(float3(6.10351999e-05,6.10351999e-05,6.10351999e-05), r9.xyz);
        r9.xyz = float3(4.5,4.5,4.5) * r8.xyz;
        r8.xyz = max(float3(0.0179999992,0.0179999992,0.0179999992), r8.xyz);
        r8.xyz = log2(r8.xyz);
        r8.xyz = float3(0.449999988,0.449999988,0.449999988) * r8.xyz;
        r8.xyz = exp2(r8.xyz);
        r8.xyz = r8.xyz * float3(1.09899998,1.09899998,1.09899998) + float3(-0.0989999995,-0.0989999995,-0.0989999995);
        r1.xyz = min(r9.xyz, r8.xyz);
      } else {
        r8.xy = cmp(asint(output_device) == int2(3,5));
        r0.w = (int)r8.y | (int)r8.x;
        if (r0.w != 0) {  // HDR Branch
          r8.rgb = r2.rgb;

          r8.xyz *= cb0[36].yyy; // brightness slider
          r8.xyz *= float3(1.5,1.5,1.5);  // exposure boost in both SDR and HDR


          // AP0 -> AP1 
          r9.y = dot(float3(0.706346452,0.146768153,0.150477916), r8.xyz);
          r9.z = dot(float3(0.0459861904,0.856727183,0.0888853893), r8.xyz);
          r9.w = dot(float3(-0.00571021158,0.00647447165,0.925703824), r8.xyz);

          r0.w = min(r9.y, r9.z);
          r0.w = min(r0.w, r9.w);
          r1.w = max(r9.y, r9.z);
          r1.w = max(r1.w, r9.w);
          r8.xy = max(float2(1.00000001e-10,0.00999999978), r1.ww);
          r0.w = max(1.00000001e-10, r0.w);
          r0.w = r8.x + -r0.w;
          r0.w = r0.w / r8.y;
          r8.xyz = r9.wzy + -r9.zyw;
          r8.xy = r9.wz * r8.xy;
          r1.w = r8.x + r8.y;
          r1.w = r9.y * r8.z + r1.w;
          r1.w = sqrt(r1.w);
          r2.w = r9.w + r9.z;
          r2.w = r2.w + r9.y;
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
          r8.yzw = r9.yzw * r1.www;
          r10.xy = cmp(r8.zw == r8.yz);
          r2.w = r10.y ? r10.x : 0;
          r3.w = r9.z * r1.w + -r8.w;
          r3.w = 1.73205078 * r3.w;
          r4.w = r8.y * 2 + -r8.z;
          r4.w = -r9.w * r1.w + r4.w;
          r5.w = min(abs(r4.w), abs(r3.w));
          r6.w = max(abs(r4.w), abs(r3.w));
          r6.w = 1 / r6.w;
          r5.w = r6.w * r5.w;
          r6.w = r5.w * r5.w;
          r7.w = r6.w * 0.0208350997 + -0.0851330012;
          r7.w = r6.w * r7.w + 0.180141002;
          r7.w = r6.w * r7.w + -0.330299497;
          r6.w = r6.w * r7.w + 0.999866009;
          r7.w = r6.w * r5.w;
          r9.x = cmp(abs(r4.w) < abs(r3.w));
          r7.w = r7.w * -2 + 1.57079637;
          r7.w = r9.x ? r7.w : 0;
          r5.w = r5.w * r6.w + r7.w;
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
            r9.xzw = float3(-0.166666672,-0.5,0.166666672) * r5.www;
            r9.xz = r3.ww * float2(0.5,0.5) + r9.xz;
            r9.xz = r2.ww * float2(-0.5,0.5) + r9.xz;
            r2.w = r5.w * 0.5 + -r3.w;
            r2.w = 0.666666687 + r2.w;
            r10.xyz = cmp((int3)r4.www == int3(3,2,1));
            r9.xz = float2(0.166666672,0.166666672) + r9.xz;
            r3.w = r4.w ? 0 : r9.w;
            r3.w = r10.z ? r9.z : r3.w;
            r2.w = r10.y ? r2.w : r3.w;
            r2.w = r10.x ? r9.x : r2.w;
          } else {
            r2.w = 0;
          }
          r0.w = r2.w * r0.w;
          r0.w = 1.5 * r0.w;
          r1.w = -r9.y * r1.w + 0.0299999993;
          r0.w = r1.w * r0.w;
          r8.x = r0.w * 0.180000007 + r8.y;
          r8.xyz = max(float3(0,0,0), r8.xzw);
          r8.xyz = min(float3(65535,65535,65535), r8.xyz);

          // AP1 -> AP0
          r9.x = dot(float3(1.45143926,-0.236510754,-0.214928567), r8.xyz);
          r9.y = dot(float3(-0.0765537769,1.17622972,-0.0996759236), r8.xyz);
          r9.z = dot(float3(0.00831614807,-0.00603244966,0.997716308), r8.xyz);
          r8.xyz = max(float3(0,0,0), r9.xyz);
          r8.xyz = min(float3(65535,65535,65535), r8.xyz);

          // AP1_RGB2Y
          r0.w = dot(r8.xyz, float3(0.272228718,0.674081743,0.0536895171));
          r8.xyz = r8.xyz + -r0.www;
          r8.xyz = r8.xyz * float3(0.959999979,0.959999979,0.959999979) + r0.www;



          r9.xyz = cmp(float3(0,0,0) >= r8.xyz);
          r8.xyz = log2(r8.xyz);
          r8.xyz = r9.xyz ? float3(-14,-14,-14) : r8.xyz;
          r9.xyz = cmp(float3(-17.4739323,-17.4739323,-17.4739323) >= r8.xyz);



          if (r9.x != 0) {
            r0.w = -4;
          } else {
            r1.w = cmp(-17.4739323 < r8.x);
            r2.w = cmp(r8.x < -2.47393107);
            r1.w = r1.w ? r2.w : 0;
            if (r1.w != 0) {
              r1.w = r8.x * 0.30103001 + 5.26017761;
              r2.w = 0.664385557 * r1.w;
              r3.w = (int)r2.w;
              r2.w = trunc(r2.w);
              r10.y = r1.w * 0.664385557 + -r2.w;
              r9.xw = (int2)r3.ww + int2(1,2);
              r10.x = r10.y * r10.y;
              r11.x = icb[r3.w+0].x;
              r11.y = icb[r9.x+0].x;
              r11.z = icb[r9.w+0].x;
              r12.x = dot(r11.xzy, float3(0.5,0.5,-1));
              r12.y = dot(r11.xy, float2(-1,1));
              r12.z = dot(r11.xy, float2(0.5,0.5));
              r10.z = 1;
              r0.w = dot(r10.xyz, r12.xyz);
            } else {
              r1.w = cmp(r8.x >= -2.47393107);
              r2.w = cmp(r8.x < 15.5260687);
              r1.w = r1.w ? r2.w : 0;
              if (r1.w != 0) {
                r1.w = r8.x * 0.30103001 + 0.744727492;
                r2.w = 0.553654671 * r1.w;
                r3.w = (int)r2.w;
                r2.w = trunc(r2.w);
                r10.y = r1.w * 0.553654671 + -r2.w;
                r8.xw = (int2)r3.ww + int2(1,2);
                r10.x = r10.y * r10.y;
                r11.x = icb[r3.w+0].y;
                r11.y = icb[r8.x+0].y;
                r11.z = icb[r8.w+0].y;
                r12.x = dot(r11.xzy, float3(0.5,0.5,-1));
                r12.y = dot(r11.xy, float2(-1,1));
                r12.z = dot(r11.xy, float2(0.5,0.5));
                r10.z = 1;
                r0.w = dot(r10.xyz, r12.xyz);
              } else {
                r0.w = 4;
              }
            }
          }
          r0.w = 3.32192802 * r0.w;
          r10.x = exp2(r0.w);
          if (r9.y != 0) {
            r0.w = -4;
          } else {
            r1.w = cmp(-17.4739323 < r8.y);
            r2.w = cmp(r8.y < -2.47393107);
            r1.w = r1.w ? r2.w : 0;
            if (r1.w != 0) {
              r1.w = r8.y * 0.30103001 + 5.26017761;
              r2.w = 0.664385557 * r1.w;
              r3.w = (int)r2.w;
              r2.w = trunc(r2.w);
              r11.y = r1.w * 0.664385557 + -r2.w;
              r8.xw = (int2)r3.ww + int2(1,2);
              r11.x = r11.y * r11.y;
              r12.x = icb[r3.w+0].x;
              r12.y = icb[r8.x+0].x;
              r12.z = icb[r8.w+0].x;
              r13.x = dot(r12.xzy, float3(0.5,0.5,-1));
              r13.y = dot(r12.xy, float2(-1,1));
              r13.z = dot(r12.xy, float2(0.5,0.5));
              r11.z = 1;
              r0.w = dot(r11.xyz, r13.xyz);
            } else {
              r1.w = cmp(r8.y >= -2.47393107);
              r2.w = cmp(r8.y < 15.5260687);
              r1.w = r1.w ? r2.w : 0;
              if (r1.w != 0) {
                r1.w = r8.y * 0.30103001 + 0.744727492;
                r2.w = 0.553654671 * r1.w;
                r3.w = (int)r2.w;
                r2.w = trunc(r2.w);
                r11.y = r1.w * 0.553654671 + -r2.w;
                r8.xy = (int2)r3.ww + int2(1,2);
                r11.x = r11.y * r11.y;
                r12.x = icb[r3.w+0].y;
                r12.y = icb[r8.x+0].y;
                r12.z = icb[r8.y+0].y;
                r13.x = dot(r12.xzy, float3(0.5,0.5,-1));
                r13.y = dot(r12.xy, float2(-1,1));
                r13.z = dot(r12.xy, float2(0.5,0.5));
                r11.z = 1;
                r0.w = dot(r11.xyz, r13.xyz);
              } else {
                r0.w = 4;
              }
            }
          }
          r0.w = 3.32192802 * r0.w;
          r10.y = exp2(r0.w);
          if (r9.z != 0) {
            r0.w = -4;
          } else {
            r1.w = cmp(-17.4739323 < r8.z);
            r2.w = cmp(r8.z < -2.47393107);
            r1.w = r1.w ? r2.w : 0;
            if (r1.w != 0) {
              r1.w = r8.z * 0.30103001 + 5.26017761;
              r2.w = 0.664385557 * r1.w;
              r3.w = (int)r2.w;
              r2.w = trunc(r2.w);
              r9.y = r1.w * 0.664385557 + -r2.w;
              r8.xy = (int2)r3.ww + int2(1,2);
              r9.x = r9.y * r9.y;
              r11.x = icb[r3.w+0].x;
              r11.y = icb[r8.x+0].x;
              r11.z = icb[r8.y+0].x;
              r12.x = dot(r11.xzy, float3(0.5,0.5,-1));
              r12.y = dot(r11.xy, float2(-1,1));
              r12.z = dot(r11.xy, float2(0.5,0.5));
              r9.z = 1;
              r0.w = dot(r9.xyz, r12.xyz);
            } else {
              r1.w = cmp(r8.z >= -2.47393107);
              r2.w = cmp(r8.z < 15.5260687);
              r1.w = r1.w ? r2.w : 0;
              if (r1.w != 0) {
                r1.w = r8.z * 0.30103001 + 0.744727492;
                r2.w = 0.553654671 * r1.w;
                r3.w = (int)r2.w;
                r2.w = trunc(r2.w);
                r8.y = r1.w * 0.553654671 + -r2.w;
                r9.xy = (int2)r3.ww + int2(1,2);
                r8.x = r8.y * r8.y;
                r11.x = icb[r3.w+0].y;
                r11.y = icb[r9.x+0].y;
                r11.z = icb[r9.y+0].y;
                r9.x = dot(r11.xzy, float3(0.5,0.5,-1));
                r9.y = dot(r11.xy, float2(-1,1));
                r9.z = dot(r11.xy, float2(0.5,0.5));
                r8.z = 1;
                r0.w = dot(r8.xyz, r9.xyz);
              } else {
                r0.w = 4;
              }
            }
          }
          r0.w = 3.32192802 * r0.w;
          r10.z = exp2(r0.w);


          // AP1 -> AP0
          r8.x = dot(float3(0.695452213,0.140678704,0.163869068), r10.xyz);
          r8.y = dot(float3(0.0447945632,0.859671116,0.0955343172), r10.xyz);
          r8.z = dot(float3(-0.00552588282,0.00402521016,1.00150073), r10.xyz);

          // AP0 -> AP1
          r0.w = dot(float3(1.45143926,-0.236510754,-0.214928567), r8.xyz);
          r1.w = dot(float3(-0.0765537769,1.17622972,-0.0996759236), r8.xyz);
          r2.w = dot(float3(0.00831614807,-0.00603244966,0.997716308), r8.xyz);


          r3.w = cmp(0 >= r0.w);
          r0.w = log2(r0.w);
          r0.w = r3.w ? -13.2877121 : r0.w;
          r3.w = cmp(-12.7838678 >= r0.w);
          if (r3.w != 0) {
            r3.w = r0.w * 0.90309 + 7.54498291;
          } else {
            r4.w = cmp(-12.7838678 < r0.w);
            r5.w = cmp(r0.w < 2.26303458);
            r4.w = r4.w ? r5.w : 0;
            if (r4.w != 0) {
              r4.w = r0.w * 0.30103001 + 3.84832764;
              r5.w = 1.54540098 * r4.w;
              r6.w = (int)r5.w;
              r5.w = trunc(r5.w);
              r8.y = r4.w * 1.54540098 + -r5.w;
              r9.xy = (int2)r6.ww + int2(1,2);
              r8.x = r8.y * r8.y;
              r10.x = icb[r6.w+6].x;
              r10.y = icb[r9.x+6].x;
              r10.z = icb[r9.y+6].x;
              r9.x = dot(r10.xzy, float3(0.5,0.5,-1));
              r9.y = dot(r10.xy, float2(-1,1));
              r9.z = dot(r10.xy, float2(0.5,0.5));
              r8.z = 1;
              r3.w = dot(r8.xyz, r9.xyz);
            } else {
              r4.w = cmp(r0.w >= 2.26303458);
              r5.w = cmp(r0.w < 12.1373367);
              r4.w = r4.w ? r5.w : 0;
              if (r4.w != 0) {
                r4.w = r0.w * 0.30103001 + -0.681241274;
                r5.w = 2.3549509 * r4.w;
                r6.w = (int)r5.w;
                r5.w = trunc(r5.w);
                r8.y = r4.w * 2.3549509 + -r5.w;
                r9.xy = (int2)r6.ww + int2(1,2);
                r8.x = r8.y * r8.y;
                r10.x = icb[r6.w+6].y;
                r10.y = icb[r9.x+6].y;
                r10.z = icb[r9.y+6].y;
                r9.x = dot(r10.xzy, float3(0.5,0.5,-1));
                r9.y = dot(r10.xy, float2(-1,1));
                r9.z = dot(r10.xy, float2(0.5,0.5));
                r8.z = 1;
                r3.w = dot(r8.xyz, r9.xyz);
              } else {
                r3.w = r0.w * 0.0180617999 + 2.78077793;
              }
            }
          }
          r0.w = 3.32192802 * r3.w;
          r8.x = exp2(r0.w);
          r0.w = cmp(0 >= r1.w);
          r1.w = log2(r1.w);
          r0.w = r0.w ? -13.2877121 : r1.w;
          r1.w = cmp(-12.7838678 >= r0.w);
          if (r1.w != 0) {
            r1.w = r0.w * 0.90309 + 7.54498291;
          } else {
            r3.w = cmp(-12.7838678 < r0.w);
            r4.w = cmp(r0.w < 2.26303458);
            r3.w = r3.w ? r4.w : 0;
            if (r3.w != 0) {
              r3.w = r0.w * 0.30103001 + 3.84832764;
              r4.w = 1.54540098 * r3.w;
              r5.w = (int)r4.w;
              r4.w = trunc(r4.w);
              r9.y = r3.w * 1.54540098 + -r4.w;
              r10.xy = (int2)r5.ww + int2(1,2);
              r9.x = r9.y * r9.y;
              r11.x = icb[r5.w+6].x;
              r11.y = icb[r10.x+6].x;
              r11.z = icb[r10.y+6].x;
              r10.x = dot(r11.xzy, float3(0.5,0.5,-1));
              r10.y = dot(r11.xy, float2(-1,1));
              r10.z = dot(r11.xy, float2(0.5,0.5));
              r9.z = 1;
              r1.w = dot(r9.xyz, r10.xyz);
            } else {
              r3.w = cmp(r0.w >= 2.26303458);
              r4.w = cmp(r0.w < 12.1373367);
              r3.w = r3.w ? r4.w : 0;
              if (r3.w != 0) {
                r3.w = r0.w * 0.30103001 + -0.681241274;
                r4.w = 2.3549509 * r3.w;
                r5.w = (int)r4.w;
                r4.w = trunc(r4.w);
                r9.y = r3.w * 2.3549509 + -r4.w;
                r10.xy = (int2)r5.ww + int2(1,2);
                r9.x = r9.y * r9.y;
                r11.x = icb[r5.w+6].y;
                r11.y = icb[r10.x+6].y;
                r11.z = icb[r10.y+6].y;
                r10.x = dot(r11.xzy, float3(0.5,0.5,-1));
                r10.y = dot(r11.xy, float2(-1,1));
                r10.z = dot(r11.xy, float2(0.5,0.5));
                r9.z = 1;
                r1.w = dot(r9.xyz, r10.xyz);
              } else {
                r1.w = r0.w * 0.0180617999 + 2.78077793;
              }
            }
          }
          r0.w = 3.32192802 * r1.w;
          r8.y = exp2(r0.w);
          r0.w = cmp(0 >= r2.w);
          r1.w = log2(r2.w);
          r0.w = r0.w ? -13.2877121 : r1.w;
          r1.w = cmp(-12.7838678 >= r0.w);
          if (r1.w != 0) {
            r1.w = r0.w * 0.90309 + 7.54498291;
          } else {
            r2.w = cmp(-12.7838678 < r0.w);
            r3.w = cmp(r0.w < 2.26303458);
            r2.w = r2.w ? r3.w : 0;
            if (r2.w != 0) {
              r2.w = r0.w * 0.30103001 + 3.84832764;
              r3.w = 1.54540098 * r2.w;
              r4.w = (int)r3.w;
              r3.w = trunc(r3.w);
              r9.y = r2.w * 1.54540098 + -r3.w;
              r10.xy = (int2)r4.ww + int2(1,2);
              r9.x = r9.y * r9.y;
              r11.x = icb[r4.w+6].x;
              r11.y = icb[r10.x+6].x;
              r11.z = icb[r10.y+6].x;
              r10.x = dot(r11.xzy, float3(0.5,0.5,-1));
              r10.y = dot(r11.xy, float2(-1,1));
              r10.z = dot(r11.xy, float2(0.5,0.5));
              r9.z = 1;
              r1.w = dot(r9.xyz, r10.xyz);
            } else {
              r2.w = cmp(r0.w >= 2.26303458);
              r3.w = cmp(r0.w < 12.1373367);
              r2.w = r2.w ? r3.w : 0;
              if (r2.w != 0) {
                r2.w = r0.w * 0.30103001 + -0.681241274;
                r3.w = 2.3549509 * r2.w;
                r4.w = (int)r3.w;
                r3.w = trunc(r3.w);
                r9.y = r2.w * 2.3549509 + -r3.w;
                r10.xy = (int2)r4.ww + int2(1,2);
                r9.x = r9.y * r9.y;
                r11.x = icb[r4.w+6].y;
                r11.y = icb[r10.x+6].y;
                r11.z = icb[r10.y+6].y;
                r10.x = dot(r11.xzy, float3(0.5,0.5,-1));
                r10.y = dot(r11.xy, float2(-1,1));
                r10.z = dot(r11.xy, float2(0.5,0.5));
                r9.z = 1;
                r1.w = dot(r9.xyz, r10.xyz);
              } else {
                r1.w = r0.w * 0.0180617999 + 2.78077793;
              }
            }
          }
          r0.w = 3.32192802 * r1.w;
          r8.z = exp2(r0.w);
          r8.xyz = float3(-3.50738446e-05,-3.50738446e-05,-3.50738446e-05) + r8.xyz;
          r9.x = dot(r5.xyz, r8.xyz);
          r9.y = dot(r6.xyz, r8.xyz);
          r9.z = dot(r4.xyz, r8.xyz);
          r8.xyz = float3(0.00100000005,0.00100000005,0.00100000005) * r9.xyz;
          r0.w = cb0[52].y + -cb0[52].x;
          r8.xyz = r8.xyz * r0.www + cb0[52].xxx;
          r8.xyz = float3(9.99999975e-05,9.99999975e-05,9.99999975e-05) * r8.xyz;
          r8.xyz = log2(r8.xyz);
          r8.xyz = float3(0.159301758,0.159301758,0.159301758) * r8.xyz;
          r8.xyz = exp2(r8.xyz);
          r9.xyz = r8.xyz * float3(18.8515625,18.8515625,18.8515625) + float3(0.8359375,0.8359375,0.8359375);
          r8.xyz = r8.xyz * float3(18.6875,18.6875,18.6875) + float3(1,1,1);
          r8.xyz = rcp(r8.xyz);
          r8.xyz = r9.xyz * r8.xyz;
          r8.xyz = log2(r8.xyz);
          r8.xyz = float3(78.84375,78.84375,78.84375) * r8.xyz;
          r1.xyz = exp2(r8.xyz);
        } else {
          r8.xyz = cmp(asint(output_device) == int3(4,6,10));
          r0.w = (int)r8.y | (int)r8.x;
          r0.w = (int)r8.z | (int)r0.w;
          if (r0.w != 0) {
            r8.xyz = float3(1.5,1.5,1.5) * r2.xyz;
            r9.y = dot(float3(0.439700812,0.382978052,0.1773348), r8.xyz);
            r9.z = dot(float3(0.0897923037,0.813423157,0.096761629), r8.xyz);
            r9.w = dot(float3(0.0175439864,0.111544058,0.870704114), r8.xyz);
            r0.w = min(r9.y, r9.z);
            r0.w = min(r0.w, r9.w);
            r1.w = max(r9.y, r9.z);
            r1.w = max(r1.w, r9.w);
            r8.xy = max(float2(1.00000001e-10,0.00999999978), r1.ww);
            r0.w = max(1.00000001e-10, r0.w);
            r0.w = r8.x + -r0.w;
            r0.w = r0.w / r8.y;
            r8.xyz = r9.wzy + -r9.zyw;
            r8.xy = r9.wz * r8.xy;
            r1.w = r8.x + r8.y;
            r1.w = r9.y * r8.z + r1.w;
            r1.w = sqrt(r1.w);
            r2.w = r9.w + r9.z;
            r2.w = r2.w + r9.y;
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
            r8.yzw = r9.yzw * r1.www;
            r10.xy = cmp(r8.zw == r8.yz);
            r2.w = r10.y ? r10.x : 0;
            r3.w = r9.z * r1.w + -r8.w;
            r3.w = 1.73205078 * r3.w;
            r4.w = r8.y * 2 + -r8.z;
            r4.w = -r9.w * r1.w + r4.w;
            r5.w = min(abs(r4.w), abs(r3.w));
            r6.w = max(abs(r4.w), abs(r3.w));
            r6.w = 1 / r6.w;
            r5.w = r6.w * r5.w;
            r6.w = r5.w * r5.w;
            r7.w = r6.w * 0.0208350997 + -0.0851330012;
            r7.w = r6.w * r7.w + 0.180141002;
            r7.w = r6.w * r7.w + -0.330299497;
            r6.w = r6.w * r7.w + 0.999866009;
            r7.w = r6.w * r5.w;
            r9.x = cmp(abs(r4.w) < abs(r3.w));
            r7.w = r7.w * -2 + 1.57079637;
            r7.w = r9.x ? r7.w : 0;
            r5.w = r5.w * r6.w + r7.w;
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
              r9.xzw = float3(-0.166666672,-0.5,0.166666672) * r5.www;
              r9.xz = r3.ww * float2(0.5,0.5) + r9.xz;
              r9.xz = r2.ww * float2(-0.5,0.5) + r9.xz;
              r2.w = r5.w * 0.5 + -r3.w;
              r2.w = 0.666666687 + r2.w;
              r10.xyz = cmp((int3)r4.www == int3(3,2,1));
              r9.xz = float2(0.166666672,0.166666672) + r9.xz;
              r3.w = r4.w ? 0 : r9.w;
              r3.w = r10.z ? r9.z : r3.w;
              r2.w = r10.y ? r2.w : r3.w;
              r2.w = r10.x ? r9.x : r2.w;
            } else {
              r2.w = 0;
            }
            r0.w = r2.w * r0.w;
            r0.w = 1.5 * r0.w;
            r1.w = -r9.y * r1.w + 0.0299999993;
            r0.w = r1.w * r0.w;
            r8.x = r0.w * 0.180000007 + r8.y;
            r8.xyz = max(float3(0,0,0), r8.xzw);
            r8.xyz = min(float3(65535, 65535, 65535), r8.xyz);
            
            // AP0 -> AP1
            r9.x = dot(float3(1.45143926,-0.236510754,-0.214928567), r8.xyz);
            r9.y = dot(float3(-0.0765537769,1.17622972,-0.0996759236), r8.xyz);
            r9.z = dot(float3(0.00831614807,-0.00603244966,0.997716308), r8.xyz);
            r8.xyz = max(float3(0,0,0), r9.xyz);
            r8.xyz = min(float3(65535,65535,65535), r8.xyz);
            
            // y from AP1
            r0.w = dot(r8.xyz, float3(0.272228718,0.674081743,0.0536895171));
            r8.xyz = r8.xyz + -r0.www;
            r8.xyz = r8.xyz * float3(0.959999979,0.959999979,0.959999979) + r0.www;

            // End RRT

            r9.xyz = cmp(float3(0,0,0) >= r8.xyz);
            r8.xyz = log2(r8.xyz);
            r8.xyz = r9.xyz ? float3(-14,-14,-14) : r8.xyz;
            r9.xyz = cmp(float3(-17.4739323,-17.4739323,-17.4739323) >= r8.xyz);
            if (r9.x != 0) {
              r0.w = -4;
            } else {
              r1.w = cmp(-17.4739323 < r8.x);
              r2.w = cmp(r8.x < -2.47393107);
              r1.w = r1.w ? r2.w : 0;
              if (r1.w != 0) {
                r1.w = r8.x * 0.30103001 + 5.26017761;
                r2.w = 0.664385557 * r1.w;
                r3.w = (int)r2.w;
                r2.w = trunc(r2.w);
                r10.y = r1.w * 0.664385557 + -r2.w;
                r9.xw = (int2)r3.ww + int2(1,2);
                r10.x = r10.y * r10.y;
                r11.x = icb[r3.w+0].x;
                r11.y = icb[r9.x+0].x;
                r11.z = icb[r9.w+0].x;
                r12.x = dot(r11.xzy, float3(0.5,0.5,-1));
                r12.y = dot(r11.xy, float2(-1,1));
                r12.z = dot(r11.xy, float2(0.5,0.5));
                r10.z = 1;
                r0.w = dot(r10.xyz, r12.xyz);
              } else {
                r1.w = cmp(r8.x >= -2.47393107);
                r2.w = cmp(r8.x < 15.5260687);
                r1.w = r1.w ? r2.w : 0;
                if (r1.w != 0) {
                  r1.w = r8.x * 0.30103001 + 0.744727492;
                  r2.w = 0.553654671 * r1.w;
                  r3.w = (int)r2.w;
                  r2.w = trunc(r2.w);
                  r10.y = r1.w * 0.553654671 + -r2.w;
                  r8.xw = (int2)r3.ww + int2(1,2);
                  r10.x = r10.y * r10.y;
                  r11.x = icb[r3.w+0].y;
                  r11.y = icb[r8.x+0].y;
                  r11.z = icb[r8.w+0].y;
                  r12.x = dot(r11.xzy, float3(0.5,0.5,-1));
                  r12.y = dot(r11.xy, float2(-1,1));
                  r12.z = dot(r11.xy, float2(0.5,0.5));
                  r10.z = 1;
                  r0.w = dot(r10.xyz, r12.xyz);
                } else {
                  r0.w = 4;
                }
              }
            }
            r0.w = 3.32192802 * r0.w;
            r10.x = exp2(r0.w);
            if (r9.y != 0) {
              r0.w = -4;
            } else {
              r1.w = cmp(-17.4739323 < r8.y);
              r2.w = cmp(r8.y < -2.47393107);
              r1.w = r1.w ? r2.w : 0;
              if (r1.w != 0) {
                r1.w = r8.y * 0.30103001 + 5.26017761;
                r2.w = 0.664385557 * r1.w;
                r3.w = (int)r2.w;
                r2.w = trunc(r2.w);
                r11.y = r1.w * 0.664385557 + -r2.w;
                r8.xw = (int2)r3.ww + int2(1,2);
                r11.x = r11.y * r11.y;
                r12.x = icb[r3.w+0].x;
                r12.y = icb[r8.x+0].x;
                r12.z = icb[r8.w+0].x;
                r13.x = dot(r12.xzy, float3(0.5,0.5,-1));
                r13.y = dot(r12.xy, float2(-1,1));
                r13.z = dot(r12.xy, float2(0.5,0.5));
                r11.z = 1;
                r0.w = dot(r11.xyz, r13.xyz);
              } else {
                r1.w = cmp(r8.y >= -2.47393107);
                r2.w = cmp(r8.y < 15.5260687);
                r1.w = r1.w ? r2.w : 0;
                if (r1.w != 0) {
                  r1.w = r8.y * 0.30103001 + 0.744727492;
                  r2.w = 0.553654671 * r1.w;
                  r3.w = (int)r2.w;
                  r2.w = trunc(r2.w);
                  r11.y = r1.w * 0.553654671 + -r2.w;
                  r8.xy = (int2)r3.ww + int2(1,2);
                  r11.x = r11.y * r11.y;
                  r12.x = icb[r3.w+0].y;
                  r12.y = icb[r8.x+0].y;
                  r12.z = icb[r8.y+0].y;
                  r13.x = dot(r12.xzy, float3(0.5,0.5,-1));
                  r13.y = dot(r12.xy, float2(-1,1));
                  r13.z = dot(r12.xy, float2(0.5,0.5));
                  r11.z = 1;
                  r0.w = dot(r11.xyz, r13.xyz);
                } else {
                  r0.w = 4;
                }
              }
            }
            r0.w = 3.32192802 * r0.w;
            r10.y = exp2(r0.w);
            if (r9.z != 0) {
              r0.w = -4;
            } else {
              r1.w = cmp(-17.4739323 < r8.z);
              r2.w = cmp(r8.z < -2.47393107);
              r1.w = r1.w ? r2.w : 0;
              if (r1.w != 0) {
                r1.w = r8.z * 0.30103001 + 5.26017761;
                r2.w = 0.664385557 * r1.w;
                r3.w = (int)r2.w;
                r2.w = trunc(r2.w);
                r9.y = r1.w * 0.664385557 + -r2.w;
                r8.xy = (int2)r3.ww + int2(1,2);
                r9.x = r9.y * r9.y;
                r11.x = icb[r3.w+0].x;
                r11.y = icb[r8.x+0].x;
                r11.z = icb[r8.y+0].x;
                r12.x = dot(r11.xzy, float3(0.5,0.5,-1));
                r12.y = dot(r11.xy, float2(-1,1));
                r12.z = dot(r11.xy, float2(0.5,0.5));
                r9.z = 1;
                r0.w = dot(r9.xyz, r12.xyz);
              } else {
                r1.w = cmp(r8.z >= -2.47393107);
                r2.w = cmp(r8.z < 15.5260687);
                r1.w = r1.w ? r2.w : 0;
                if (r1.w != 0) {
                  r1.w = r8.z * 0.30103001 + 0.744727492;
                  r2.w = 0.553654671 * r1.w;
                  r3.w = (int)r2.w;
                  r2.w = trunc(r2.w);
                  r8.y = r1.w * 0.553654671 + -r2.w;
                  r9.xy = (int2)r3.ww + int2(1,2);
                  r8.x = r8.y * r8.y;
                  r11.x = icb[r3.w+0].y;
                  r11.y = icb[r9.x+0].y;
                  r11.z = icb[r9.y+0].y;
                  r9.x = dot(r11.xzy, float3(0.5,0.5,-1));
                  r9.y = dot(r11.xy, float2(-1,1));
                  r9.z = dot(r11.xy, float2(0.5,0.5));
                  r8.z = 1;
                  r0.w = dot(r8.xyz, r9.xyz);
                } else {
                  r0.w = 4;
                }
              }
            }
            r0.w = 3.32192802 * r0.w;
            r10.z = exp2(r0.w);

            // AP1 -> AP0
            r8.x = dot(float3(0.695452213,0.140678704,0.163869068), r10.xyz);
            r8.y = dot(float3(0.0447945632,0.859671116,0.0955343172), r10.xyz);
            r8.z = dot(float3(-0.00552588282,0.00402521016,1.00150073), r10.xyz);

            // AP0 -> AP1
            r0.w = dot(float3(1.45143926,-0.236510754,-0.214928567), r8.xyz);
            r1.w = dot(float3(-0.0765537769,1.17622972,-0.0996759236), r8.xyz);
            r2.w = dot(float3(0.00831614807,-0.00603244966,0.997716308), r8.xyz);




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
                r8.y = r4.w * 1.54540098 + -r5.w;
                r9.xy = (int2)r6.ww + int2(1,2);
                r8.x = r8.y * r8.y;
                r10.x = icb[r6.w+10].z;
                r10.y = icb[r9.x+10].z;
                r10.z = icb[r9.y+10].z;
                r9.x = dot(r10.xzy, float3(0.5,0.5,-1));
                r9.y = dot(r10.xy, float2(-1,1));
                r9.z = dot(r10.xy, float2(0.5,0.5));
                r8.z = 1;
                r3.w = dot(r8.xyz, r9.xyz);
              } else {
                r4.w = cmp(r0.w >= 2.26303458);
                r5.w = cmp(r0.w < 12.4948215);
                r4.w = r4.w ? r5.w : 0;
                if (r4.w != 0) {
                  r4.w = r0.w * 0.30103001 + -0.681241274;
                  r5.w = 2.27267218 * r4.w;
                  r6.w = (int)r5.w;
                  r5.w = trunc(r5.w);
                  r8.y = r4.w * 2.27267218 + -r5.w;
                  r9.xy = (int2)r6.ww + int2(1,2);
                  r8.x = r8.y * r8.y;
                  r10.x = icb[r6.w+10].w;
                  r10.y = icb[r9.x+10].w;
                  r10.z = icb[r9.y+10].w;
                  r9.x = dot(r10.xzy, float3(0.5,0.5,-1));
                  r9.y = dot(r10.xy, float2(-1,1));
                  r9.z = dot(r10.xy, float2(0.5,0.5));
                  r8.z = 1;
                  r3.w = dot(r8.xyz, r9.xyz);
                } else {
                  r3.w = r0.w * 0.0361235999 + 2.84967208;
                }
              }
            }
            r0.w = 3.32192802 * r3.w;
            r8.x = exp2(r0.w);
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
                r9.y = r3.w * 1.54540098 + -r4.w;
                r10.xy = (int2)r5.ww + int2(1,2);
                r9.x = r9.y * r9.y;
                r11.x = icb[r5.w+10].z;
                r11.y = icb[r10.x+10].z;
                r11.z = icb[r10.y+10].z;
                r10.x = dot(r11.xzy, float3(0.5,0.5,-1));
                r10.y = dot(r11.xy, float2(-1,1));
                r10.z = dot(r11.xy, float2(0.5,0.5));
                r9.z = 1;
                r1.w = dot(r9.xyz, r10.xyz);
              } else {
                r3.w = cmp(r0.w >= 2.26303458);
                r4.w = cmp(r0.w < 12.4948215);
                r3.w = r3.w ? r4.w : 0;
                if (r3.w != 0) {
                  r3.w = r0.w * 0.30103001 + -0.681241274;
                  r4.w = 2.27267218 * r3.w;
                  r5.w = (int)r4.w;
                  r4.w = trunc(r4.w);
                  r9.y = r3.w * 2.27267218 + -r4.w;
                  r10.xy = (int2)r5.ww + int2(1,2);
                  r9.x = r9.y * r9.y;
                  r11.x = icb[r5.w+10].w;
                  r11.y = icb[r10.x+10].w;
                  r11.z = icb[r10.y+10].w;
                  r10.x = dot(r11.xzy, float3(0.5,0.5,-1));
                  r10.y = dot(r11.xy, float2(-1,1));
                  r10.z = dot(r11.xy, float2(0.5,0.5));
                  r9.z = 1;
                  r1.w = dot(r9.xyz, r10.xyz);
                } else {
                  r1.w = r0.w * 0.0361235999 + 2.84967208;
                }
              }
            }
            r0.w = 3.32192802 * r1.w;
            r8.y = exp2(r0.w);
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
                r9.y = r2.w * 1.54540098 + -r3.w;
                r10.xy = (int2)r4.ww + int2(1,2);
                r9.x = r9.y * r9.y;
                r11.x = icb[r4.w+10].z;
                r11.y = icb[r10.x+10].z;
                r11.z = icb[r10.y+10].z;
                r10.x = dot(r11.xzy, float3(0.5,0.5,-1));
                r10.y = dot(r11.xy, float2(-1,1));
                r10.z = dot(r11.xy, float2(0.5,0.5));
                r9.z = 1;
                r1.w = dot(r9.xyz, r10.xyz);
              } else {
                r2.w = cmp(r0.w >= 2.26303458);
                r3.w = cmp(r0.w < 12.4948215);
                r2.w = r2.w ? r3.w : 0;
                if (r2.w != 0) {
                  r2.w = r0.w * 0.30103001 + -0.681241274;
                  r3.w = 2.27267218 * r2.w;
                  r4.w = (int)r3.w;
                  r3.w = trunc(r3.w);
                  r9.y = r2.w * 2.27267218 + -r3.w;
                  r10.xy = (int2)r4.ww + int2(1,2);
                  r9.x = r9.y * r9.y;
                  r11.x = icb[r4.w+10].w;
                  r11.y = icb[r10.x+10].w;
                  r11.z = icb[r10.y+10].w;
                  r10.x = dot(r11.xzy, float3(0.5,0.5,-1));
                  r10.y = dot(r11.xy, float2(-1,1));
                  r10.z = dot(r11.xy, float2(0.5,0.5));
                  r9.z = 1;
                  r1.w = dot(r9.xyz, r10.xyz);
                } else {
                  r1.w = r0.w * 0.0361235999 + 2.84967208;
                }
              }
            }
            r0.w = 3.32192802 * r1.w;
            r8.z = exp2(r0.w);
            r9.x = dot(r5.xyz, r8.xyz);
            r9.y = dot(r6.xyz, r8.xyz);
            r9.z = dot(r4.xyz, r8.xyz);
            r8.xyz = float3(9.99999975e-05,9.99999975e-05,9.99999975e-05) * r9.xyz;
            r8.xyz = log2(r8.xyz);
            r8.xyz = float3(0.159301758,0.159301758,0.159301758) * r8.xyz;
            r8.xyz = exp2(r8.xyz);
            r9.xyz = r8.xyz * float3(18.8515625,18.8515625,18.8515625) + float3(0.8359375,0.8359375,0.8359375);
            r8.xyz = r8.xyz * float3(18.6875,18.6875,18.6875) + float3(1,1,1);
            r8.xyz = rcp(r8.xyz);
            r8.xyz = r9.xyz * r8.xyz;
            r8.xyz = log2(r8.xyz);
            r8.xyz = float3(78.84375,78.84375,78.84375) * r8.xyz;
            r1.xyz = exp2(r8.xyz);
          } else {
            r0.w = cmp(asint(output_device) == 7);
            if (r0.w != 0) {
              // BT.709 => AP1 (with Bradford)
              r8.x = dot(float3(0.613191485,0.33951208,0.0473663323), r2.xyz);
              r8.y = dot(float3(0.0702069029,0.916335821,0.0134500116), r2.xyz);
              r8.z = dot(float3(0.0206188709,0.109567292,0.869606733), r2.xyz);
              
              r9.x = dot(r5.xyz, r8.xyz);
              r9.y = dot(r6.xyz, r8.xyz);
              r9.z = dot(r4.xyz, r8.xyz);
              r8.xyz = float3(9.99999975e-05,9.99999975e-05,9.99999975e-05) * r9.xyz;
              r8.xyz = log2(r8.xyz);
              r8.xyz = float3(0.159301758,0.159301758,0.159301758) * r8.xyz;
              r8.xyz = exp2(r8.xyz);
              r9.xyz = r8.xyz * float3(18.8515625,18.8515625,18.8515625) + float3(0.8359375,0.8359375,0.8359375);
              r8.xyz = r8.xyz * float3(18.6875,18.6875,18.6875) + float3(1,1,1);
              r8.xyz = rcp(r8.xyz);
              r8.xyz = r9.xyz * r8.xyz;
              r8.xyz = log2(r8.xyz);
              r8.xyz = float3(78.84375,78.84375,78.84375) * r8.xyz;
              r1.xyz = exp2(r8.xyz);
            } else {
              r8.xy = cmp(asint(output_device) == int2(8, 9));
              // BT.709 => AP1 (with Bradford)
              r9.x = dot(float3(0.613191485,0.33951208,0.0473663323), r3.xyz);
              r9.y = dot(float3(0.0702069029,0.916335821,0.0134500116), r3.xyz);
              r9.z = dot(float3(0.0206188709,0.109567292,0.869606733), r3.xyz);

              r3.x = dot(r5.xyz, r9.xyz);
              r3.y = dot(r6.xyz, r9.xyz);
              r3.z = dot(r4.xyz, r9.xyz);
              r9.x = dot(float3(0.613191485,0.33951208,0.0473663323), r7.xyz);
              r9.y = dot(float3(0.0702069029,0.916335821,0.0134500116), r7.xyz);
              r9.z = dot(float3(0.0206188709,0.109567292,0.869606733), r7.xyz);
              r0.w = dot(r5.xyz, r9.xyz);
              r1.w = dot(r6.xyz, r9.xyz);
              r2.w = dot(r4.xyz, r9.xyz);
              r4.x = log2(r0.w);
              r4.y = log2(r1.w);
              r4.z = log2(r2.w);
              r4.xyz = cb0[27].zzz * r4.xyz;
              r4.xyz = exp2(r4.xyz);
              r3.xyz = r8.yyy ? r3.xyz : r4.xyz;
              r1.xyz = r8.xxx ? r2.xyz : r3.xyz;
            }
          }
        }
      }
    }
    r1.xyz = float3(0.952381015,0.952381015,0.952381015) * r1.xyz;
    r1.w = 0;
  } else {
    r1.xyz = float3(0.952381015,0.952381015,0.952381015) * r0.xyz;
    r1.w = 1;
  }
  // No code for instruction (needs manual fix):
  u0[vThreadID] = r1;  // store_uav_typed u0.xyzw, vThreadID.xyzz, r1.xyzw

  // u0[vThreadID] = float4(renodx::color::pq::EncodeSafe((renodx::color::srgb::DecodeSafe(r1.rgb)), 100.f) * (1.f / 1.05f), r1.w);
  return;
}