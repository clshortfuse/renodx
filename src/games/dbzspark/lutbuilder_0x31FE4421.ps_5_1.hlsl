// ---- Created with 3Dmigoto v1.3.16 on Thu Oct 17 13:24:17 2024
#include "./shared.h"
#include "./tonemapper.hlsl"

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1) {
  float4 cb1[21];
}

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
  float4 r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(-0.015625, -0.015625) + v0.xy;
  r0.xy = float2(1.03225803, 1.03225803) * r0.xy;
  r0.z = (uint)v2.x;
  r1.z = 0.0322580636 * r0.z;
  r2.xyzw = cmp(int4(1, 2, 3, 4) == asint(cb0[41].xxxx));
  r3.xyz = r2.www ? float3(1, 0, 0) : float3(1.70505154, -0.621790707, -0.0832583979);
  r4.xyz = r2.www ? float3(0, 1, 0) : float3(-0.130257145, 1.14080286, -0.0105485283);
  r5.xyz = r2.www ? float3(0, 0, 1) : float3(-0.0240032747, -0.128968775, 1.15297174);
  r3.xyz = r2.zzz ? float3(0.695452213, 0.140678704, 0.163869068) : r3.xyz;
  r4.xyz = r2.zzz ? float3(0.0447945632, 0.859671116, 0.0955343172) : r4.xyz;
  r5.xyz = r2.zzz ? float3(-0.00552588282, 0.00402521016, 1.00150073) : r5.xyz;
  r3.xyz = r2.yyy ? float3(1.02579927, -0.0200525094, -0.00577136781) : r3.xyz;
  r4.xyz = r2.yyy ? float3(-0.00223502493, 1.00458264, -0.00235231337) : r4.xyz;
  r2.yzw = r2.yyy ? float3(-0.00501400325, -0.0252933875, 1.03044021) : r5.xyz;
  r3.xyz = r2.xxx ? float3(1.37915885, -0.308850735, -0.0703467429) : r3.xyz;
  r4.xyz = r2.xxx ? float3(-0.0693352968, 1.08229232, -0.0129620517) : r4.xyz;
  r2.xyz = r2.xxx ? float3(-0.00215925858, -0.0454653986, 1.04775953) : r2.yzw;

  // CustomEdit
  uint output_type = OUTPUT_OVERRIDE;
  bool is_hdr = (output_type >= 3u && output_type <= 6u);
  bool shouldTonemap = injectedData.toneMapType != 0.f && is_hdr;

  // Vanilla outputType is always 0, might be devkit
  r0.z = cmp(asuint(cb0[40].w) >= 3);

  if (shouldTonemap) {
    r0.z = cmp(output_type >= 3);
  }

  // PQ Decode
  r5.xy = log2(r0.xy);
  r5.z = log2(r1.z);
  r0.xyw = float3(0.0126833133, 0.0126833133, 0.0126833133) * r5.xyz;
  r0.xyw = exp2(r0.xyw);
  r5.xyz = float3(-0.8359375, -0.8359375, -0.8359375) + r0.xyw;
  r5.xyz = max(float3(0, 0, 0), r5.xyz);
  r0.xyw = -r0.xyw * float3(18.6875, 18.6875, 18.6875) + float3(18.8515625, 18.8515625, 18.8515625);
  r0.xyw = r5.xyz / r0.xyw;
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
  r0.w = cb0[35].x * 1.00055635;
  r0.w = 1 / r0.w;
  r1.x = cmp(6996.10791 >= cb0[35].x);
  r1.yz = -r0.ww * float2(4.60700006e+09, 2.0064e+09) + float2(2967800, 1901800);
  r1.yz = r1.yz * r0.ww + float2(99.1100006, 247.479996);
  r1.yz = r1.yz * r0.ww + float2(0.244063005, 0.237039998);
  r1.x = r1.x ? r1.y : r1.z;
  r0.w = r1.x * r1.x;
  r1.z = 2.86999989 * r1.x;
  r0.w = r0.w * -3 + r1.z;
  r1.y = -0.275000006 + r0.w;
  r5.xyz = cb0[35].xxx * float3(0.000154118257, 0.00084242021, 4.22806261e-05) + float3(0.860117733, 1, 0.317398727);
  r0.w = cb0[35].x * cb0[35].x;
  r5.xyz = r0.www * float3(1.28641219e-07, 7.08145137e-07, 4.20481676e-08) + r5.xyz;
  r1.z = r5.x / r5.y;
  r5.xyw = -cb0[35].xxx * float3(2.8974182e-05, 1916156.25, 705674) + float3(1, -1.13758118e+09, 1.97471539e+09);
  r1.w = r0.w * 1.61456057e-07 + r5.x;
  r1.w = r5.z / r1.w;
  r2.w = 3 * r1.z;
  r3.w = r1.z + r1.z;
  r3.w = -r1.w * 8 + r3.w;
  r3.w = 4 + r3.w;
  r6.x = r2.w / r3.w;
  r2.w = r1.w + r1.w;
  r6.y = r2.w / r3.w;
  r2.w = cmp(cb0[35].x < 4000);
  r1.xy = r2.ww ? r6.xy : r1.xy;
  r5.xy = -r0.ww * float2(1.53176999, 308.606995) + r5.yw;
  r2.w = cb0[35].x * 1189.62 + r0.w;
  r2.w = 1412139.88 + r2.w;
  r2.w = r2.w * r2.w;
  r7.x = r5.x / r2.w;
  r0.w = -cb0[35].x * 179.455994 + r0.w;
  r0.w = 6193636 + r0.w;
  r0.w = r0.w * r0.w;
  r7.y = r5.y / r0.w;
  r0.w = dot(r7.xy, r7.xy);
  r0.w = rsqrt(r0.w);
  r5.xy = r7.xy * r0.ww;
  r0.w = cb0[35].y * r5.y;
  r0.w = r0.w * 0.0500000007 + r1.z;
  r1.z = cb0[35].y * -r5.x;
  r1.z = r1.z * 0.0500000007 + r1.w;
  r1.w = 3 * r0.w;
  r0.w = r0.w + r0.w;
  r0.w = -r1.z * 8 + r0.w;
  r0.w = 4 + r0.w;
  r1.z = r1.z + r1.z;
  r5.xy = r1.wz / r0.ww;
  r1.zw = r5.xy + -r6.xy;
  r1.xy = r1.xy + r1.zw;
  r1.zw = float2(0.312700003, 0.328999996);
  r1.xyzw = cb0[38].zzzz ? r1.xyzw : r1.zwxy;
  r5.xy = max(float2(1.00000001e-10, 1.00000001e-10), r1.yw);
  r5.zw = float2(1, 1) + -r1.xz;
  r1.yw = r5.zw + -r1.yw;
  r6.xy = r1.xz / r5.xy;
  r1.xy = r1.yw / r5.xy;
  r6.z = 1;
  r6.w = r1.x;
  r0.w = dot(float3(0.895099998, 0.266400009, -0.161400005), r6.xzw);
  r1.x = dot(float3(-0.750199974, 1.71350002, 0.0366999991), r6.xzw);
  r2.w = dot(float3(0.0388999991, -0.0684999973, 1.02960002), r6.xzw);
  r1.zw = r6.yz;
  r3.w = dot(float3(-0.161400005, 0.895099998, 0.266400009), r1.yzw);
  r4.w = dot(float3(0.0366999991, -0.750199974, 1.71350002), r1.yzw);
  r1.y = dot(float3(1.02960002, 0.0388999991, -0.0684999973), r1.yzw);
  r0.w = r3.w / r0.w;
  r1.x = r4.w / r1.x;
  r1.y = r1.y / r2.w;
  r5.xyz = float3(0.895099998, 0.266400009, -0.161400005) * r0.www;
  r1.xzw = float3(-0.750199974, 1.71350002, 0.0366999991) * r1.xxx;
  r6.xyz = float3(0.0388999991, -0.0684999973, 1.02960002) * r1.yyy;
  r7.x = r5.x;
  r7.y = r1.x;
  r7.z = r6.x;
  r0.w = dot(float3(0.986992896, -0.1470543, 0.159962699), r7.xyz);
  r8.x = r5.y;
  r8.y = r1.z;
  r8.z = r6.y;
  r1.x = dot(float3(0.986992896, -0.1470543, 0.159962699), r8.xyz);
  r6.x = r5.z;
  r6.y = r1.w;
  r1.y = dot(float3(0.986992896, -0.1470543, 0.159962699), r6.xyz);
  r1.z = dot(float3(0.432305306, 0.518360317, 0.0492912009), r7.xyz);
  r1.w = dot(float3(0.432305306, 0.518360317, 0.0492912009), r8.xyz);
  r2.w = dot(float3(0.432305306, 0.518360317, 0.0492912009), r6.xyz);
  r3.w = dot(float3(-0.0085287001, 0.040042799, 0.968486726), r7.xyz);
  r4.w = dot(float3(-0.0085287001, 0.040042799, 0.968486726), r8.xyz);
  r5.x = dot(float3(-0.0085287001, 0.040042799, 0.968486726), r6.xyz);
  r5.yzw = cb1[1].xyz * r1.xxx;
  r5.yzw = r0.www * cb1[0].xyz + r5.yzw;
  r5.yzw = r1.yyy * cb1[2].xyz + r5.yzw;
  r1.xyw = cb1[1].xyz * r1.www;
  r1.xyz = r1.zzz * cb1[0].xyz + r1.xyw;
  r1.xyz = r2.www * cb1[2].xyz + r1.xyz;
  r6.xyz = cb1[1].xyz * r4.www;
  r6.xyz = r3.www * cb1[0].xyz + r6.xyz;
  r6.xyz = r5.xxx * cb1[2].xyz + r6.xyz;
  r7.xyz = cb1[4].yyy * r1.xyz;
  r7.xyz = cb1[4].xxx * r5.yzw + r7.xyz;
  r7.xyz = cb1[4].zzz * r6.xyz + r7.xyz;
  r8.xyz = cb1[5].yyy * r1.xyz;
  r8.xyz = cb1[5].xxx * r5.yzw + r8.xyz;
  r8.xyz = cb1[5].zzz * r6.xyz + r8.xyz;
  r1.xyz = cb1[6].yyy * r1.xyz;
  r1.xyz = cb1[6].xxx * r5.yzw + r1.xyz;
  r1.xyz = cb1[6].zzz * r6.xyz + r1.xyz;
  r5.x = dot(r7.xyz, r0.xyz);
  r5.y = dot(r8.xyz, r0.xyz);
  r5.z = dot(r1.xyz, r0.xyz);
  r0.x = dot(cb1[8].xyz, r5.xyz);
  r0.y = dot(cb1[9].xyz, r5.xyz);
  r0.z = dot(cb1[10].xyz, r5.xyz);
  r0.w = dot(r0.xyz, float3(0.272228718, 0.674081743, 0.0536895171));
  r1.xyz = r0.xyz / r0.www;
  r1.xyz = float3(-1, -1, -1) + r1.xyz;
  r1.x = dot(r1.xyz, r1.xyz);
  r1.x = -4 * r1.x;
  r1.x = exp2(r1.x);
  r1.x = 1 + -r1.x;
  r0.w = r0.w * r0.w;
  r0.w = cb0[36].z * r0.w;
  r0.w = -4 * r0.w;
  r0.w = exp2(r0.w);
  r0.w = 1 + -r0.w;
  r0.w = r1.x * r0.w;
  r1.x = dot(float3(1.37041271, -0.329291314, -0.0636827648), r0.xyz);
  r1.y = dot(float3(-0.0834341869, 1.09709096, -0.0108615728), r0.xyz);
  r1.z = dot(float3(-0.0257932581, -0.0986256376, 1.20369434), r0.xyz);
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = r0.www * r1.xyz + r0.xyz;
  r0.w = dot(r0.xyz, float3(0.272228718, 0.674081743, 0.0536895171));
  r1.xyzw = cb0[20].xyzw * cb0[15].xyzw;
  r5.xyzw = cb0[21].xyzw * cb0[16].xyzw;
  r6.xyzw = cb0[22].xyzw * cb0[17].xyzw;
  r7.xyzw = cb0[23].xyzw * cb0[18].xyzw;
  r8.xyzw = cb0[24].xyzw + cb0[19].xyzw;
  r1.xyz = r1.xyz * r1.www;
  r0.xyz = r0.xyz + -r0.www;
  r1.xyz = r1.xyz * r0.xyz + r0.www;
  r1.xyz = max(float3(0, 0, 0), r1.xyz);
  r1.xyz = float3(5.55555534, 5.55555534, 5.55555534) * r1.xyz;
  r5.xyz = r5.xyz * r5.www;
  r1.xyz = log2(r1.xyz);
  r1.xyz = r5.xyz * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.xyz = float3(0.180000007, 0.180000007, 0.180000007) * r1.xyz;
  r5.xyz = r6.xyz * r6.www;
  r5.xyz = float3(1, 1, 1) / r5.xyz;
  r1.xyz = log2(r1.xyz);
  r1.xyz = r5.xyz * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r5.xyz = r7.xyz * r7.www;
  r6.xyz = r8.xyz + r8.www;
  r1.xyz = r1.xyz * r5.xyz + r6.xyz;
  r1.w = 1 / cb0[35].z;
  r1.w = saturate(r1.w * r0.w);
  r2.w = r1.w * -2 + 3;
  r1.w = r1.w * r1.w;
  r1.w = -r2.w * r1.w + 1;
  r5.xyzw = cb0[30].xyzw * cb0[15].xyzw;
  r6.xyzw = cb0[31].xyzw * cb0[16].xyzw;
  r7.xyzw = cb0[32].xyzw * cb0[17].xyzw;
  r8.xyzw = cb0[33].xyzw * cb0[18].xyzw;
  r9.xyzw = cb0[34].xyzw + cb0[19].xyzw;
  r5.xyz = r5.xyz * r5.www;
  r5.xyz = r5.xyz * r0.xyz + r0.www;
  r5.xyz = max(float3(0, 0, 0), r5.xyz);
  r5.xyz = float3(5.55555534, 5.55555534, 5.55555534) * r5.xyz;
  r6.xyz = r6.xyz * r6.www;
  r5.xyz = log2(r5.xyz);
  r5.xyz = r6.xyz * r5.xyz;
  r5.xyz = exp2(r5.xyz);
  r5.xyz = float3(0.180000007, 0.180000007, 0.180000007) * r5.xyz;
  r6.xyz = r7.xyz * r7.www;
  r6.xyz = float3(1, 1, 1) / r6.xyz;
  r5.xyz = log2(r5.xyz);
  r5.xyz = r6.xyz * r5.xyz;
  r5.xyz = exp2(r5.xyz);
  r6.xyz = r8.xyz * r8.www;
  r7.xyz = r9.xyz + r9.www;
  r5.xyz = r5.xyz * r6.xyz + r7.xyz;
  r2.w = cb0[36].x + -cb0[35].w;
  r3.w = -cb0[35].w + r0.w;
  r2.w = 1 / r2.w;
  r2.w = saturate(r3.w * r2.w);
  r3.w = r2.w * -2 + 3;
  r2.w = r2.w * r2.w;
  r4.w = r3.w * r2.w;
  r6.xyzw = cb0[25].xyzw * cb0[15].xyzw;
  r7.xyzw = cb0[26].xyzw * cb0[16].xyzw;
  r8.xyzw = cb0[27].xyzw * cb0[17].xyzw;
  r9.xyzw = cb0[28].xyzw * cb0[18].xyzw;
  r10.xyzw = cb0[29].xyzw + cb0[19].xyzw;
  r6.xyz = r6.xyz * r6.www;
  r0.xyz = r6.xyz * r0.xyz + r0.www;
  r0.xyz = max(float3(0, 0, 0), r0.xyz);
  r0.xyz = float3(5.55555534, 5.55555534, 5.55555534) * r0.xyz;
  r6.xyz = r7.xyz * r7.www;
  r0.xyz = log2(r0.xyz);
  r0.xyz = r6.xyz * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = float3(0.180000007, 0.180000007, 0.180000007) * r0.xyz;
  r6.xyz = r8.xyz * r8.www;
  r6.xyz = float3(1, 1, 1) / r6.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = r6.xyz * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r6.xyz = r9.xyz * r9.www;
  r7.xyz = r10.xyz + r10.www;
  r0.xyz = r0.xyz * r6.xyz + r7.xyz;
  r0.w = 1 + -r1.w;
  r0.w = -r3.w * r2.w + r0.w;
  r0.xyz = r0.xyz * r0.www;
  r0.xyz = r1.xyz * r1.www + r0.xyz;
  r0.xyz = r5.xyz * r4.www + r0.xyz;

  // Blue correct
  r1.x = dot(float3(0.938639402, 1.02359565e-10, 0.0613606237), r0.xyz);
  r1.y = dot(float3(8.36008554e-11, 0.830794156, 0.169205874), r0.xyz);
  r1.z = dot(float3(2.13187367e-12, -5.63307213e-12, 1), r0.xyz);
  r1.xyz = r1.xyz + -r0.xyz;
  r1.xyz = cb0[36].yyy * r1.xyz + r0.xyz;

  float3 ap1_graded_color = r1.rgb;  // CustomEdit

  // start of film tonemap
  // AP1 => AP0

  r5.y = dot(float3(0.695452213, 0.140678704, 0.163869068), r1.xyz);
  r5.z = dot(float3(0.0447945632, 0.859671116, 0.0955343172), r1.xyz);
  r5.w = dot(float3(-0.00552588236, 0.00402521016, 1.00150073), r1.xyz);
  r0.w = min(r5.y, r5.z);
  r0.w = min(r0.w, r5.w);
  r1.w = max(r5.y, r5.z);
  r1.w = max(r1.w, r5.w);
  r6.xy = max(float2(1.00000001e-10, 0.00999999978), r1.ww);
  r0.w = max(1.00000001e-10, r0.w);
  r0.w = r6.x + -r0.w;
  r0.w = r0.w / r6.y;
  r6.xyz = r5.wzy + -r5.zyw;
  r6.xy = r6.xy * r5.wz;
  r1.w = r6.x + r6.y;
  r1.w = r5.y * r6.z + r1.w;
  r1.w = sqrt(r1.w);
  r2.w = r5.w + r5.z;
  r2.w = r2.w + r5.y;
  r1.w = r1.w * 1.75 + r2.w;
  r2.w = 0.333333343 * r1.w;
  r3.w = -0.400000006 + r0.w;
  r4.w = 2.5 * r3.w;
  r4.w = 1 + -abs(r4.w);
  r4.w = max(0, r4.w);
  r5.x = cmp(0 < r3.w);
  r3.w = cmp(r3.w < 0);
  r3.w = (int)-r5.x + (int)r3.w;
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
  r6.yzw = r5.yzw * r1.www;
  r7.xy = cmp(r6.zw == r6.yz);
  r2.w = r7.y ? r7.x : 0;
  r3.w = r5.z * r1.w + -r6.w;
  r3.w = 1.73205078 * r3.w;
  r4.w = r6.y * 2 + -r6.z;
  r4.w = -r5.w * r1.w + r4.w;
  r5.x = min(abs(r4.w), abs(r3.w));
  r5.z = max(abs(r4.w), abs(r3.w));
  r5.z = 1 / r5.z;
  r5.x = r5.x * r5.z;
  r5.z = r5.x * r5.x;
  r5.w = r5.z * 0.0208350997 + -0.0851330012;
  r5.w = r5.z * r5.w + 0.180141002;
  r5.w = r5.z * r5.w + -0.330299497;
  r5.z = r5.z * r5.w + 0.999866009;
  r5.w = r5.x * r5.z;
  r7.x = cmp(abs(r4.w) < abs(r3.w));
  r5.w = r5.w * -2 + 1.57079637;
  r5.w = r7.x ? r5.w : 0;
  r5.x = r5.x * r5.z + r5.w;
  r5.z = cmp(r4.w < -r4.w);
  r5.z = r5.z ? -3.141593 : 0;
  r5.x = r5.x + r5.z;
  r5.z = min(r4.w, r3.w);
  r3.w = max(r4.w, r3.w);
  r4.w = cmp(r5.z < -r5.z);
  r3.w = cmp(r3.w >= -r3.w);
  r3.w = r3.w ? r4.w : 0;
  r3.w = r3.w ? -r5.x : r5.x;
  r3.w = 57.2957802 * r3.w;
  r2.w = r2.w ? 0 : r3.w;
  r3.w = cmp(r2.w < 0);
  r4.w = 360 + r2.w;
  r2.w = r3.w ? r4.w : r2.w;
  r2.w = max(0, r2.w);
  r2.w = min(360, r2.w);
  r3.w = cmp(180 < r2.w);
  r4.w = -360 + r2.w;
  // aces::hueweight (with smoothstep)
  r2.w = r3.w ? r4.w : r2.w;
  r2.w = 0.0148148146 * r2.w;
  r2.w = 1 + -abs(r2.w);
  r2.w = max(0, r2.w);
  r3.w = r2.w * -2 + 3;
  r2.w = r2.w * r2.w;
  r2.w = r3.w * r2.w;
  r2.w = r2.w * r2.w;
  r0.w = r2.w * r0.w;
  r1.w = -r5.y * r1.w + 0.0299999993;
  r0.w = r1.w * r0.w;
  r6.x = r0.w * 0.180000007 + r6.y;
  // AP0 => AP1
  r5.x = dot(float3(1.45143926, -0.236510754, -0.214928567), r6.xzw);
  r5.y = dot(float3(-0.0765537769, 1.17622972, -0.0996759236), r6.xzw);
  r5.z = dot(float3(0.00831614807, -0.00603244966, 0.997716308), r6.xzw);
  r5.xyz = max(float3(0, 0, 0), r5.xyz);
  // AP1_RGB2Y
  r0.w = dot(r5.xyz, float3(0.272228718, 0.674081743, 0.0536895171));
  r5.xyz = r5.xyz + -r0.www;
  r5.xyz = r5.xyz * float3(0.959999979, 0.959999979, 0.959999979) + r0.www;  // End of ACES:RRT

  float3 ap1_aces_colored = r5.rgb;  // CustomEdit

  float3 sdr_color;
  float3 hdr_color;
  float3 sdr_ap1_color;
  if (shouldTonemap) {
    renodx::tonemap::Config config = getCommonConfig();
    config.hue_correction_color = ap1_aces_colored;

    float3 config_color = renodx::color::bt709::from::AP1(ap1_graded_color);

    renodx::tonemap::config::DualToneMap dual_tone_map = renodx::tonemap::config::ApplyToneMaps(config_color, config);
    hdr_color = dual_tone_map.color_hdr;
    sdr_color = dual_tone_map.color_sdr;
    sdr_ap1_color = renodx::color::ap1::from::BT709(sdr_color);
  } else {
    // Film Toe > 0.8
    r6.xy = cb0[37].ww + float2(1, 0.180000007);
    r0.w = -cb0[37].y + r6.x;
    r1.w = cb0[38].x + 1;
    r2.w = -cb0[37].z + r1.w;
    r3.w = cmp(0.800000012 < cb0[37].y);
    r6.xz = -cb0[37].yy + float2(0.819999993, 1);
    r6.xz = r6.xz / cb0[37].xx;
    r4.w = -0.744727492 + r6.x;
    r5.w = r6.y / r0.w;
    r6.x = -1 + r5.w;
    r6.x = 1 + -r6.x;
    r5.w = r5.w / r6.x;
    r5.w = log2(r5.w);
    r5.w = 0.346573591 * r5.w;
    r6.x = r0.w / cb0[37].x;
    r5.w = -r5.w * r6.x + -0.744727492;
    r3.w = r3.w ? r4.w : r5.w;
    r4.w = r6.z + -r3.w;
    r5.w = cb0[37].z / cb0[37].x;
    r5.w = r5.w + -r4.w;
    r5.xyz = log2(r5.xyz);
    r6.xyz = float3(0.30103001, 0.30103001, 0.30103001) * r5.xyz;
    r7.xyz = r5.xyz * float3(0.30103001, 0.30103001, 0.30103001) + r4.www;
    r7.xyz = cb0[37].xxx * r7.xyz;
    r4.w = r0.w + r0.w;
    r6.w = cb0[37].x * -2;
    r0.w = r6.w / r0.w;
    r8.xyz = r5.xyz * float3(0.30103001, 0.30103001, 0.30103001) + -r3.www;
    r9.xyz = r8.xyz * r0.www;
    r9.xyz = float3(1.44269502, 1.44269502, 1.44269502) * r9.xyz;
    r9.xyz = exp2(r9.xyz);
    r9.xyz = float3(1, 1, 1) + r9.xyz;
    r9.xyz = r4.www / r9.xyz;
    r9.xyz = -cb0[37].www + r9.xyz;
    r0.w = r2.w + r2.w;
    r4.w = cb0[37].x + cb0[37].x;
    r2.w = r4.w / r2.w;
    r5.xyz = r5.xyz * float3(0.30103001, 0.30103001, 0.30103001) + -r5.www;
    r5.xyz = r5.xyz * r2.www;
    r5.xyz = float3(1.44269502, 1.44269502, 1.44269502) * r5.xyz;
    r5.xyz = exp2(r5.xyz);
    r5.xyz = float3(1, 1, 1) + r5.xyz;
    r5.xyz = r0.www / r5.xyz;
    r5.xyz = -r5.xyz + r1.www;
    r10.xyz = cmp(r6.xyz < r3.www);
    r9.xyz = r10.xyz ? r9.xyz : r7.xyz;
    r6.xyz = cmp(r5.www < r6.xyz);
    r5.xyz = r6.xyz ? r5.xyz : r7.xyz;
    r0.w = r5.w + -r3.w;
    r6.xyz = saturate(r8.xyz / r0.www);
    r0.w = cmp(r5.w < r3.w);
    r7.xyz = float3(1, 1, 1) + -r6.xyz;
    r6.xyz = r0.www ? r7.xyz : r6.xyz;
    r7.xyz = -r6.xyz * float3(2, 2, 2) + float3(3, 3, 3);
    r6.xyz = r6.xyz * r6.xyz;
    r6.xyz = r6.xyz * r7.xyz;
    r5.xyz = r5.xyz + -r9.xyz;
    r5.xyz = r6.xyz * r5.xyz + r9.xyz;
    // AP1_RGB2Y
    r0.w = dot(r5.xyz, float3(0.272228718, 0.674081743, 0.0536895171));
    r5.xyz = r5.xyz + -r0.www;
    r5.xyz = r5.xyz * float3(0.930000007, 0.930000007, 0.930000007) + r0.www;
    r5.xyz = max(float3(0, 0, 0), r5.xyz);
    sdr_ap1_color = r5.xyz;
  }
  r5.rgb = sdr_ap1_color;  // CustomEdit

  r5.xyz = r5.xyz + -r1.xyz;
  r1.xyz = cb0[36].www * r5.xyz + r1.xyz;

  // BlueBlueCorrectInv
  r5.x = dot(float3(1.06537485, 1.44678506e-06, -0.0653710067), r1.xyz);
  r5.y = dot(float3(-3.45525592e-07, 1.20366347, -0.203667715), r1.xyz);
  r5.z = dot(float3(1.9865448e-08, 2.12079581e-08, 0.999999583), r1.xyz);
  // lerp with BlueCorrection
  r5.xyz = r5.xyz + -r1.xyz;
  r1.xyz = cb0[36].yyy * r5.xyz + r1.xyz;

  // Convert to target space but lacks clamp
  /* r5.x = saturate(dot(cb1[12].xyz, r1.xyz));
  r5.y = saturate(dot(cb1[13].xyz, r1.xyz));
  r5.z = saturate(dot(cb1[14].xyz, r1.xyz)); */
  r5.x = dot(cb1[12].xyz, r1.xyz);  // CustomEdit
  r5.y = dot(cb1[13].xyz, r1.xyz);
  r5.z = dot(cb1[14].xyz, r1.xyz);
  r5.rgb = max(0, r5.rgb);

  float3 lut_input_color = r5.rgb;
  float3 post_lut_color;

  if (false) {
    renodx::lut::Config lut_config = renodx::lut::config::Create(
        s0_s,
        1.f,
        0.f,  // Hue shifts too much if enabled
        renodx::lut::config::type::SRGB,
        renodx::lut::config::type::SRGB,
        16.f);

    post_lut_color = renodx::lut::Sample(t0, lut_config, lut_input_color);
  } else {
    r5.rgb = saturate(r5.rgb);  // Better picture
    r1.xyz = float3(12.9200001, 12.9200001, 12.9200001) * r5.xyz;
    r6.xyz = cmp(r5.xyz >= float3(0.00313066994, 0.00313066994, 0.00313066994));
    r5.xyz = log2(r5.xyz);
    r5.xyz = float3(0.416666657, 0.416666657, 0.416666657) * r5.xyz;
    r5.xyz = exp2(r5.xyz);
    r5.xyz = r5.xyz * float3(1.05499995, 1.05499995, 1.05499995) + float3(-0.0549999997, -0.0549999997, -0.0549999997);
    r1.xyz = r6.xyz ? r5.xyz : r1.xyz;
    r5.yzw = r1.xyz * float3(0.9375, 0.9375, 0.9375) + float3(0.03125, 0.03125, 0.03125);
    r0.w = r5.w * 16 + -0.5;
    r1.w = floor(r0.w);
    r0.w = -r1.w + r0.w;
    r1.w = r5.y + r1.w;
    r5.x = 0.0625 * r1.w;
    r6.xyz = t0.Sample(s0_s, r5.xz).xyz;
    r5.xy = float2(0.0625, 0) + r5.xz;
    r5.xyz = t0.Sample(s0_s, r5.xy).xyz;
    r5.xyz = r5.xyz + -r6.xyz;
    r5.xyz = r0.www * r5.xyz + r6.xyz;
    r5.xyz = cb0[5].yyy * r5.xyz;
    r1.xyz = cb0[5].xxx * r1.xyz + r5.xyz;
    r1.xyz = max(float3(6.10351999e-05, 6.10351999e-05, 6.10351999e-05), r1.xyz);
    r5.xyz = cmp(float3(0.0404499993, 0.0404499993, 0.0404499993) < r1.xyz);

    r6.xyz = r1.xyz * float3(0.947867274, 0.947867274, 0.947867274) + float3(0.0521326996, 0.0521326996, 0.0521326996);
    r6.xyz = log2(r6.xyz);
    r6.xyz = float3(2.4000001, 2.4000001, 2.4000001) * r6.xyz;
    r6.xyz = exp2(r6.xyz);
    r1.xyz = float3(0.0773993805, 0.0773993805, 0.0773993805) * r1.xyz;
    r1.xyz = r5.xyz ? r6.xyz : r1.xyz;
    post_lut_color = r1.rgb;
  }  // CustomEdit
  r1.rgb = post_lut_color;
  r1.rgb = renodx::tonemap::UpgradeToneMap(lut_input_color, saturate(lut_input_color), r1.rgb, 1.f);

  r5.xyz = r1.xyz * r1.xyz;
  r1.xyz = cb0[39].yyy * r1.xyz;
  r1.xyz = cb0[39].xxx * r5.xyz + r1.xyz;
  r1.xyz = cb0[39].zzz + r1.xyz;
  r5.xyz = cb0[14].xyz * r1.xyz;
  r1.xyz = -r1.xyz * cb0[14].xyz + cb0[13].xyz;
  r1.xyz = cb0[13].www * r1.xyz + r5.xyz;
  r5.xyz = max(float3(0, 0, 0), r1.xyz);
  r5.xyz = log2(r5.xyz);
  // CustomEdit
  // We're color correcting with the SDR render so we make sure user hasn't adjusted SDR settings
  float gamma = cb0[40].y;
  if (shouldTonemap) {
    gamma = DEFAULT_GAMMA;
  }
  r5.xyz = gamma * r5.xyz;
  // r5.xyz = cb0[40].yyy * r5.xyz;
  r5.xyz = exp2(r5.xyz);

  float3 film_graded_color = r5.rgb;

  // CustomEdit
  // Add upgrade tonemap here
  if (shouldTonemap) {
    float3 final_color = saturate(film_graded_color);

    if (injectedData.toneMapType != 1.f) {
      final_color = renodx::tonemap::UpgradeToneMap(hdr_color, sdr_color, final_color, 1.f);
    } else {
      final_color = hdr_color;
    }

    // We PQ encode at the end
    o0.rgba = float4(final_color, 0);
  } else {
    o0.rgba = float4(film_graded_color, 0);
  }

  if (cb0[40].w == 0) {  // cb[40].w = output device
    // Shader uses this section
    r6.x = dot(cb1[8].xyz, r5.xyz);
    r6.y = dot(cb1[9].xyz, r5.xyz);
    r6.z = dot(cb1[10].xyz, r5.xyz);
    r7.x = dot(r3.xyz, r6.xyz);
    r7.y = dot(r4.xyz, r6.xyz);
    r7.z = dot(r2.xyz, r6.xyz);
    r6.xyz = cb1[20].xxx ? r5.xyz : r7.xyz;
    r7.xyz = float3(12.9200001, 12.9200001, 12.9200001) * r6.xyz;
    r8.xyz = cmp(r6.xyz >= float3(0.00313066994, 0.00313066994, 0.00313066994));
    r6.xyz = log2(r6.xyz);
    r6.xyz = float3(0.416666657, 0.416666657, 0.416666657) * r6.xyz;
    r6.xyz = exp2(r6.xyz);
    r6.xyz = r6.xyz * float3(1.05499995, 1.05499995, 1.05499995) + float3(-0.0549999997, -0.0549999997, -0.0549999997);
    r6.xyz = r8.xyz ? r6.xyz : r7.xyz;
  } else {
    r0.w = cmp(1 == asint(cb0[40].w));
    if (r0.w != 0) {
      r7.x = dot(cb1[8].xyz, r5.xyz);
      r7.y = dot(cb1[9].xyz, r5.xyz);
      r7.z = dot(cb1[10].xyz, r5.xyz);
      r8.x = dot(r3.xyz, r7.xyz);
      r8.y = dot(r4.xyz, r7.xyz);
      r8.z = dot(r2.xyz, r7.xyz);
      r7.xyz = max(float3(6.10351999e-05, 6.10351999e-05, 6.10351999e-05), r8.xyz);
      r8.xyz = float3(4.5, 4.5, 4.5) * r7.xyz;
      r7.xyz = max(float3(0.0179999992, 0.0179999992, 0.0179999992), r7.xyz);
      r7.xyz = log2(r7.xyz);
      r7.xyz = float3(0.449999988, 0.449999988, 0.449999988) * r7.xyz;
      r7.xyz = exp2(r7.xyz);
      r7.xyz = r7.xyz * float3(1.09899998, 1.09899998, 1.09899998) + float3(-0.0989999995, -0.0989999995, -0.0989999995);
      r6.xyz = min(r8.xyz, r7.xyz);
    } else {
      r7.x = dot(cb1[12].xyz, r0.xyz);
      r7.y = dot(cb1[13].xyz, r0.xyz);
      r7.z = dot(cb1[14].xyz, r0.xyz);
      r0.xyz = cb0[14].xyz * r7.xyz;
      r7.xyz = -r7.xyz * cb0[14].xyz + cb0[13].xyz;
      r0.xyz = cb0[13].www * r7.xyz + r0.xyz;
      r7.xy = cmp(int2(3, 5) == asint(cb0[40].ww));
      r0.w = (int)r7.y | (int)r7.x;
      if (r0.w != 0) {
        r7.xyz = cb0[12].zzz * r0.xyz;
        r8.y = dot(cb1[16].xyz, r7.xyz);
        r8.z = dot(cb1[17].xyz, r7.xyz);
        r8.w = dot(cb1[18].xyz, r7.xyz);
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
        r7.xyz = min(float3(65504, 65504, 65504), r7.xyz);
        r0.w = dot(r7.xyz, float3(0.272228718, 0.674081743, 0.0536895171));
        r7.xyz = r7.xyz + -r0.www;
        r7.xyz = r7.xyz * float3(0.959999979, 0.959999979, 0.959999979) + r0.www;
        r7.xyz = max(float3(1.00000001e-10, 1.00000001e-10, 1.00000001e-10), r7.xyz);
        r7.xyz = log2(r7.xyz);
        r8.xyz = float3(0.30103001, 0.30103001, 0.30103001) * r7.xyz;
        r0.w = log2(cb0[8].x);
        r0.w = 0.30103001 * r0.w;
        r9.xyz = cmp(r0.www >= r8.xyz);
        if (r9.x != 0) {
          r1.w = log2(cb0[8].y);
          r1.w = 0.30103001 * r1.w;
        } else {
          r2.w = cmp(r0.w < r8.x);
          r3.w = log2(cb0[9].x);
          r4.w = 0.30103001 * r3.w;
          r5.w = cmp(r8.x < r4.w);
          r2.w = r2.w ? r5.w : 0;
          if (r2.w != 0) {
            r2.w = r7.x * 0.30103001 + -r0.w;
            r2.w = 3 * r2.w;
            r3.w = r3.w * 0.30103001 + -r0.w;
            r2.w = r2.w / r3.w;
            r3.w = (int)r2.w;
            r5.w = trunc(r2.w);
            r10.y = -r5.w + r2.w;
            r11.xyzw = cmp((int4)r3.wwww == int4(3, 2, 1, 0));
            r9.xw = cmp((int2)r3.ww == int2(4, 5));
            r11.xyzw = r11.xyzw ? float4(1, 1, 1, 1) : 0;
            r9.xw = r9.xw ? float2(1, 1) : 0;
            r2.w = dot(r11.wzyx, cb0[10].xyzw);
            r2.w = r9.x * cb0[12].x + r2.w;
            r11.x = r9.w * cb0[12].x + r2.w;
            r12.xyzw = (int4)r3.wwww + int4(1, 1, 2, 2);
            r13.xyzw = cmp((int4)r12.yyyy == int4(3, 2, 1, 0));
            r14.xyzw = cmp((int4)r12.xyzw == int4(4, 5, 4, 5));
            r13.xyzw = r13.xyzw ? float4(1, 1, 1, 1) : 0;
            r14.xyzw = r14.xyzw ? float4(1, 1, 1, 1) : 0;
            r2.w = dot(r13.wzyx, cb0[10].xyzw);
            r2.w = r14.x * cb0[12].x + r2.w;
            r11.y = r14.y * cb0[12].x + r2.w;
            r12.xyzw = cmp((int4)r12.wwww == int4(3, 2, 1, 0));
            r12.xyzw = r12.xyzw ? float4(1, 1, 1, 1) : 0;
            r2.w = dot(r12.wzyx, cb0[10].xyzw);
            r2.w = r14.z * cb0[12].x + r2.w;
            r11.z = r14.w * cb0[12].x + r2.w;
            r10.x = r10.y * r10.y;
            r12.x = dot(r11.xzy, float3(0.5, 0.5, -1));
            r12.y = dot(r11.xy, float2(-1, 1));
            r12.z = dot(r11.xy, float2(0.5, 0.5));
            r10.z = 1;
            r1.w = dot(r10.xyz, r12.xyz);
          } else {
            r2.w = cmp(r8.x >= r4.w);
            r3.w = log2(cb0[8].z);
            r5.w = 0.30103001 * r3.w;
            r5.w = cmp(r8.x < r5.w);
            r2.w = r2.w ? r5.w : 0;
            if (r2.w != 0) {
              r2.w = r7.x * 0.30103001 + -r4.w;
              r2.w = 3 * r2.w;
              r3.w = r3.w * 0.30103001 + -r4.w;
              r2.w = r2.w / r3.w;
              r3.w = (int)r2.w;
              r4.w = trunc(r2.w);
              r10.y = -r4.w + r2.w;
              r11.xyzw = cmp((int4)r3.wwww == int4(3, 2, 1, 0));
              r7.xw = cmp((int2)r3.ww == int2(4, 5));
              r11.xyzw = r11.xyzw ? float4(1, 1, 1, 1) : 0;
              r7.xw = r7.xw ? float2(1, 1) : 0;
              r2.w = dot(r11.wzyx, cb0[11].xyzw);
              r2.w = r7.x * cb0[12].y + r2.w;
              r11.x = r7.w * cb0[12].y + r2.w;
              r12.xyzw = (int4)r3.wwww + int4(1, 1, 2, 2);
              r13.xyzw = cmp((int4)r12.yyyy == int4(3, 2, 1, 0));
              r14.xyzw = cmp((int4)r12.xyzw == int4(4, 5, 4, 5));
              r13.xyzw = r13.xyzw ? float4(1, 1, 1, 1) : 0;
              r14.xyzw = r14.xyzw ? float4(1, 1, 1, 1) : 0;
              r2.w = dot(r13.wzyx, cb0[11].xyzw);
              r2.w = r14.x * cb0[12].y + r2.w;
              r11.y = r14.y * cb0[12].y + r2.w;
              r12.xyzw = cmp((int4)r12.wwww == int4(3, 2, 1, 0));
              r12.xyzw = r12.xyzw ? float4(1, 1, 1, 1) : 0;
              r2.w = dot(r12.wzyx, cb0[11].xyzw);
              r2.w = r14.z * cb0[12].y + r2.w;
              r11.z = r14.w * cb0[12].y + r2.w;
              r10.x = r10.y * r10.y;
              r12.x = dot(r11.xzy, float3(0.5, 0.5, -1));
              r12.y = dot(r11.xy, float2(-1, 1));
              r12.z = dot(r11.xy, float2(0.5, 0.5));
              r10.z = 1;
              r1.w = dot(r10.xyz, r12.xyz);
            } else {
              r2.w = log2(cb0[8].w);
              r1.w = 0.30103001 * r2.w;
            }
          }
        }
        r1.w = 3.32192802 * r1.w;
        r1.w = exp2(r1.w);
        if (r9.y != 0) {
          r2.w = log2(cb0[8].y);
          r2.w = 0.30103001 * r2.w;
        } else {
          r3.w = cmp(r0.w < r8.y);
          r4.w = log2(cb0[9].x);
          r5.w = 0.30103001 * r4.w;
          r6.w = cmp(r8.y < r5.w);
          r3.w = r3.w ? r6.w : 0;
          if (r3.w != 0) {
            r3.w = r7.y * 0.30103001 + -r0.w;
            r3.w = 3 * r3.w;
            r4.w = r4.w * 0.30103001 + -r0.w;
            r3.w = r3.w / r4.w;
            r4.w = (int)r3.w;
            r6.w = trunc(r3.w);
            r10.y = -r6.w + r3.w;
            r11.xyzw = cmp((int4)r4.wwww == int4(3, 2, 1, 0));
            r7.xw = cmp((int2)r4.ww == int2(4, 5));
            r11.xyzw = r11.xyzw ? float4(1, 1, 1, 1) : 0;
            r7.xw = r7.xw ? float2(1, 1) : 0;
            r3.w = dot(r11.wzyx, cb0[10].xyzw);
            r3.w = r7.x * cb0[12].x + r3.w;
            r11.x = r7.w * cb0[12].x + r3.w;
            r12.xyzw = (int4)r4.wwww + int4(1, 1, 2, 2);
            r13.xyzw = cmp((int4)r12.yyyy == int4(3, 2, 1, 0));
            r14.xyzw = cmp((int4)r12.xyzw == int4(4, 5, 4, 5));
            r13.xyzw = r13.xyzw ? float4(1, 1, 1, 1) : 0;
            r14.xyzw = r14.xyzw ? float4(1, 1, 1, 1) : 0;
            r3.w = dot(r13.wzyx, cb0[10].xyzw);
            r3.w = r14.x * cb0[12].x + r3.w;
            r11.y = r14.y * cb0[12].x + r3.w;
            r12.xyzw = cmp((int4)r12.wwww == int4(3, 2, 1, 0));
            r12.xyzw = r12.xyzw ? float4(1, 1, 1, 1) : 0;
            r3.w = dot(r12.wzyx, cb0[10].xyzw);
            r3.w = r14.z * cb0[12].x + r3.w;
            r11.z = r14.w * cb0[12].x + r3.w;
            r10.x = r10.y * r10.y;
            r12.x = dot(r11.xzy, float3(0.5, 0.5, -1));
            r12.y = dot(r11.xy, float2(-1, 1));
            r12.z = dot(r11.xy, float2(0.5, 0.5));
            r10.z = 1;
            r2.w = dot(r10.xyz, r12.xyz);
          } else {
            r3.w = cmp(r8.y >= r5.w);
            r4.w = log2(cb0[8].z);
            r6.w = 0.30103001 * r4.w;
            r6.w = cmp(r8.y < r6.w);
            r3.w = r3.w ? r6.w : 0;
            if (r3.w != 0) {
              r3.w = r7.y * 0.30103001 + -r5.w;
              r3.w = 3 * r3.w;
              r4.w = r4.w * 0.30103001 + -r5.w;
              r3.w = r3.w / r4.w;
              r4.w = (int)r3.w;
              r5.w = trunc(r3.w);
              r10.y = -r5.w + r3.w;
              r11.xyzw = cmp((int4)r4.wwww == int4(3, 2, 1, 0));
              r7.xy = cmp((int2)r4.ww == int2(4, 5));
              r11.xyzw = r11.xyzw ? float4(1, 1, 1, 1) : 0;
              r7.xy = r7.xy ? float2(1, 1) : 0;
              r3.w = dot(r11.wzyx, cb0[11].xyzw);
              r3.w = r7.x * cb0[12].y + r3.w;
              r11.x = r7.y * cb0[12].y + r3.w;
              r12.xyzw = (int4)r4.wwww + int4(1, 1, 2, 2);
              r13.xyzw = cmp((int4)r12.yyyy == int4(3, 2, 1, 0));
              r14.xyzw = cmp((int4)r12.xyzw == int4(4, 5, 4, 5));
              r13.xyzw = r13.xyzw ? float4(1, 1, 1, 1) : 0;
              r14.xyzw = r14.xyzw ? float4(1, 1, 1, 1) : 0;
              r3.w = dot(r13.wzyx, cb0[11].xyzw);
              r3.w = r14.x * cb0[12].y + r3.w;
              r11.y = r14.y * cb0[12].y + r3.w;
              r12.xyzw = cmp((int4)r12.wwww == int4(3, 2, 1, 0));
              r12.xyzw = r12.xyzw ? float4(1, 1, 1, 1) : 0;
              r3.w = dot(r12.wzyx, cb0[11].xyzw);
              r3.w = r14.z * cb0[12].y + r3.w;
              r11.z = r14.w * cb0[12].y + r3.w;
              r10.x = r10.y * r10.y;
              r12.x = dot(r11.xzy, float3(0.5, 0.5, -1));
              r12.y = dot(r11.xy, float2(-1, 1));
              r12.z = dot(r11.xy, float2(0.5, 0.5));
              r10.z = 1;
              r2.w = dot(r10.xyz, r12.xyz);
            } else {
              r3.w = log2(cb0[8].w);
              r2.w = 0.30103001 * r3.w;
            }
          }
        }
        r2.w = 3.32192802 * r2.w;
        r2.w = exp2(r2.w);
        if (r9.z != 0) {
          r3.w = log2(cb0[8].y);
          r3.w = 0.30103001 * r3.w;
        } else {
          r4.w = cmp(r0.w < r8.z);
          r5.w = log2(cb0[9].x);
          r6.w = 0.30103001 * r5.w;
          r7.x = cmp(r8.z < r6.w);
          r4.w = r4.w ? r7.x : 0;
          if (r4.w != 0) {
            r4.w = r7.z * 0.30103001 + -r0.w;
            r4.w = 3 * r4.w;
            r0.w = r5.w * 0.30103001 + -r0.w;
            r0.w = r4.w / r0.w;
            r4.w = (int)r0.w;
            r5.w = trunc(r0.w);
            r9.y = -r5.w + r0.w;
            r10.xyzw = cmp((int4)r4.wwww == int4(3, 2, 1, 0));
            r7.xy = cmp((int2)r4.ww == int2(4, 5));
            r10.xyzw = r10.xyzw ? float4(1, 1, 1, 1) : 0;
            r7.xy = r7.xy ? float2(1, 1) : 0;
            r0.w = dot(r10.wzyx, cb0[10].xyzw);
            r0.w = r7.x * cb0[12].x + r0.w;
            r10.x = r7.y * cb0[12].x + r0.w;
            r11.xyzw = (int4)r4.wwww + int4(1, 1, 2, 2);
            r12.xyzw = cmp((int4)r11.yyyy == int4(3, 2, 1, 0));
            r13.xyzw = cmp((int4)r11.xyzw == int4(4, 5, 4, 5));
            r12.xyzw = r12.xyzw ? float4(1, 1, 1, 1) : 0;
            r13.xyzw = r13.xyzw ? float4(1, 1, 1, 1) : 0;
            r0.w = dot(r12.wzyx, cb0[10].xyzw);
            r0.w = r13.x * cb0[12].x + r0.w;
            r10.y = r13.y * cb0[12].x + r0.w;
            r11.xyzw = cmp((int4)r11.wwww == int4(3, 2, 1, 0));
            r11.xyzw = r11.xyzw ? float4(1, 1, 1, 1) : 0;
            r0.w = dot(r11.wzyx, cb0[10].xyzw);
            r0.w = r13.z * cb0[12].x + r0.w;
            r10.z = r13.w * cb0[12].x + r0.w;
            r9.x = r9.y * r9.y;
            r11.x = dot(r10.xzy, float3(0.5, 0.5, -1));
            r11.y = dot(r10.xy, float2(-1, 1));
            r11.z = dot(r10.xy, float2(0.5, 0.5));
            r9.z = 1;
            r3.w = dot(r9.xyz, r11.xyz);
          } else {
            r0.w = cmp(r8.z >= r6.w);
            r4.w = log2(cb0[8].z);
            r5.w = 0.30103001 * r4.w;
            r5.w = cmp(r8.z < r5.w);
            r0.w = r0.w ? r5.w : 0;
            if (r0.w != 0) {
              r0.w = r7.z * 0.30103001 + -r6.w;
              r0.w = 3 * r0.w;
              r4.w = r4.w * 0.30103001 + -r6.w;
              r0.w = r0.w / r4.w;
              r4.w = (int)r0.w;
              r5.w = trunc(r0.w);
              r7.y = -r5.w + r0.w;
              r8.xyzw = cmp((int4)r4.wwww == int4(3, 2, 1, 0));
              r9.xy = cmp((int2)r4.ww == int2(4, 5));
              r8.xyzw = r8.xyzw ? float4(1, 1, 1, 1) : 0;
              r9.xy = r9.xy ? float2(1, 1) : 0;
              r0.w = dot(r8.wzyx, cb0[11].xyzw);
              r0.w = r9.x * cb0[12].y + r0.w;
              r8.x = r9.y * cb0[12].y + r0.w;
              r9.xyzw = (int4)r4.wwww + int4(1, 1, 2, 2);
              r10.xyzw = cmp((int4)r9.yyyy == int4(3, 2, 1, 0));
              r11.xyzw = cmp((int4)r9.xyzw == int4(4, 5, 4, 5));
              r10.xyzw = r10.xyzw ? float4(1, 1, 1, 1) : 0;
              r11.xyzw = r11.xyzw ? float4(1, 1, 1, 1) : 0;
              r0.w = dot(r10.wzyx, cb0[11].xyzw);
              r0.w = r11.x * cb0[12].y + r0.w;
              r8.y = r11.y * cb0[12].y + r0.w;
              r9.xyzw = cmp((int4)r9.wwww == int4(3, 2, 1, 0));
              r9.xyzw = r9.xyzw ? float4(1, 1, 1, 1) : 0;
              r0.w = dot(r9.wzyx, cb0[11].xyzw);
              r0.w = r11.z * cb0[12].y + r0.w;
              r8.z = r11.w * cb0[12].y + r0.w;
              r7.x = r7.y * r7.y;
              r9.x = dot(r8.xzy, float3(0.5, 0.5, -1));
              r9.y = dot(r8.xy, float2(-1, 1));
              r9.z = dot(r8.xy, float2(0.5, 0.5));
              r7.z = 1;
              r3.w = dot(r7.xyz, r9.xyz);
            } else {
              r0.w = log2(cb0[8].w);
              r3.w = 0.30103001 * r0.w;
            }
          }
        }
        r0.w = 3.32192802 * r3.w;
        r0.w = exp2(r0.w);
        r1.w = -cb0[8].y + r1.w;
        r3.w = cb0[8].w + -cb0[8].y;
        r7.x = r1.w / r3.w;
        r1.w = -cb0[8].y + r2.w;
        r7.y = r1.w / r3.w;
        r0.w = -cb0[8].y + r0.w;
        r7.z = r0.w / r3.w;
        r8.x = dot(float3(0.662454188, 0.134004205, 0.156187683), r7.xyz);
        r8.y = dot(float3(0.272228718, 0.674081743, 0.0536895171), r7.xyz);
        r8.z = dot(float3(-0.00557464967, 0.0040607336, 1.01033914), r7.xyz);
        r7.x = saturate(dot(float3(1.6410234, -0.324803293, -0.236424699), r8.xyz));
        r7.y = saturate(dot(float3(-0.663662851, 1.61533165, 0.0167563483), r8.xyz));
        r7.z = saturate(dot(float3(0.0117218941, -0.00828444213, 0.988394856), r8.xyz));
        r8.x = dot(float3(0.662454188, 0.134004205, 0.156187683), r7.xyz);
        r8.y = dot(float3(0.272228718, 0.674081743, 0.0536895171), r7.xyz);
        r8.z = dot(float3(-0.00557464967, 0.0040607336, 1.01033914), r7.xyz);
        r7.x = dot(float3(1.6410234, -0.324803293, -0.236424699), r8.xyz);
        r7.y = dot(float3(-0.663662851, 1.61533165, 0.0167563483), r8.xyz);
        r7.z = dot(float3(0.0117218941, -0.00828444213, 0.988394856), r8.xyz);
        r7.xyz = max(float3(0, 0, 0), r7.xyz);
        r7.xyz = cb0[8].www * r7.xyz;
        r7.xyz = max(float3(0, 0, 0), r7.xyz);
        r7.xyz = min(float3(65535, 65535, 65535), r7.xyz);
        r0.w = cmp(5 != asint(cb0[40].w));
        r8.x = dot(r3.xyz, r7.xyz);
        r8.y = dot(r4.xyz, r7.xyz);
        r8.z = dot(r2.xyz, r7.xyz);
        r7.xyz = r0.www ? r8.xyz : r7.xyz;
        r7.xyz = float3(9.99999975e-05, 9.99999975e-05, 9.99999975e-05) * r7.xyz;
        r7.xyz = log2(r7.xyz);
        r7.xyz = float3(0.159301758, 0.159301758, 0.159301758) * r7.xyz;
        r7.xyz = exp2(r7.xyz);
        r8.xyz = r7.xyz * float3(18.8515625, 18.8515625, 18.8515625) + float3(0.8359375, 0.8359375, 0.8359375);
        r7.xyz = r7.xyz * float3(18.6875, 18.6875, 18.6875) + float3(1, 1, 1);
        r7.xyz = rcp(r7.xyz);
        r7.xyz = r8.xyz * r7.xyz;
        r7.xyz = log2(r7.xyz);
        r7.xyz = float3(78.84375, 78.84375, 78.84375) * r7.xyz;
        r6.xyz = exp2(r7.xyz);
      } else {
        r7.xy = cmp(int2(4, 6) == asint(cb0[40].ww));
        r0.w = (int)r7.y | (int)r7.x;
        if (r0.w != 0) {
          r7.xyz = cb0[12].zzz * r0.xyz;
          r8.y = dot(cb1[16].xyz, r7.xyz);
          r8.z = dot(cb1[17].xyz, r7.xyz);
          r8.w = dot(cb1[18].xyz, r7.xyz);
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
          r7.xyz = min(float3(65504, 65504, 65504), r7.xyz);
          r0.w = dot(r7.xyz, float3(0.272228718, 0.674081743, 0.0536895171));
          r7.xyz = r7.xyz + -r0.www;
          r7.xyz = r7.xyz * float3(0.959999979, 0.959999979, 0.959999979) + r0.www;
          r7.xyz = max(float3(1.00000001e-10, 1.00000001e-10, 1.00000001e-10), r7.xyz);
          r7.xyz = log2(r7.xyz);
          r8.xyz = float3(0.30103001, 0.30103001, 0.30103001) * r7.xyz;
          r0.w = log2(cb0[8].x);
          r0.w = 0.30103001 * r0.w;
          r9.xyz = cmp(r0.www >= r8.xyz);
          if (r9.x != 0) {
            r1.w = log2(cb0[8].y);
            r1.w = 0.30103001 * r1.w;
          } else {
            r2.w = cmp(r0.w < r8.x);
            r3.w = log2(cb0[9].x);
            r4.w = 0.30103001 * r3.w;
            r5.w = cmp(r8.x < r4.w);
            r2.w = r2.w ? r5.w : 0;
            if (r2.w != 0) {
              r2.w = r7.x * 0.30103001 + -r0.w;
              r2.w = 3 * r2.w;
              r3.w = r3.w * 0.30103001 + -r0.w;
              r2.w = r2.w / r3.w;
              r3.w = (int)r2.w;
              r5.w = trunc(r2.w);
              r10.y = -r5.w + r2.w;
              r11.xyzw = cmp((int4)r3.wwww == int4(3, 2, 1, 0));
              r9.xw = cmp((int2)r3.ww == int2(4, 5));
              r11.xyzw = r11.xyzw ? float4(1, 1, 1, 1) : 0;
              r9.xw = r9.xw ? float2(1, 1) : 0;
              r2.w = dot(r11.wzyx, cb0[10].xyzw);
              r2.w = r9.x * cb0[12].x + r2.w;
              r11.x = r9.w * cb0[12].x + r2.w;
              r12.xyzw = (int4)r3.wwww + int4(1, 1, 2, 2);
              r13.xyzw = cmp((int4)r12.yyyy == int4(3, 2, 1, 0));
              r14.xyzw = cmp((int4)r12.xyzw == int4(4, 5, 4, 5));
              r13.xyzw = r13.xyzw ? float4(1, 1, 1, 1) : 0;
              r14.xyzw = r14.xyzw ? float4(1, 1, 1, 1) : 0;
              r2.w = dot(r13.wzyx, cb0[10].xyzw);
              r2.w = r14.x * cb0[12].x + r2.w;
              r11.y = r14.y * cb0[12].x + r2.w;
              r12.xyzw = cmp((int4)r12.wwww == int4(3, 2, 1, 0));
              r12.xyzw = r12.xyzw ? float4(1, 1, 1, 1) : 0;
              r2.w = dot(r12.wzyx, cb0[10].xyzw);
              r2.w = r14.z * cb0[12].x + r2.w;
              r11.z = r14.w * cb0[12].x + r2.w;
              r10.x = r10.y * r10.y;
              r12.x = dot(r11.xzy, float3(0.5, 0.5, -1));
              r12.y = dot(r11.xy, float2(-1, 1));
              r12.z = dot(r11.xy, float2(0.5, 0.5));
              r10.z = 1;
              r1.w = dot(r10.xyz, r12.xyz);
            } else {
              r2.w = cmp(r8.x >= r4.w);
              r3.w = log2(cb0[8].z);
              r5.w = 0.30103001 * r3.w;
              r5.w = cmp(r8.x < r5.w);
              r2.w = r2.w ? r5.w : 0;
              if (r2.w != 0) {
                r2.w = r7.x * 0.30103001 + -r4.w;
                r2.w = 3 * r2.w;
                r3.w = r3.w * 0.30103001 + -r4.w;
                r2.w = r2.w / r3.w;
                r3.w = (int)r2.w;
                r4.w = trunc(r2.w);
                r10.y = -r4.w + r2.w;
                r11.xyzw = cmp((int4)r3.wwww == int4(3, 2, 1, 0));
                r7.xw = cmp((int2)r3.ww == int2(4, 5));
                r11.xyzw = r11.xyzw ? float4(1, 1, 1, 1) : 0;
                r7.xw = r7.xw ? float2(1, 1) : 0;
                r2.w = dot(r11.wzyx, cb0[11].xyzw);
                r2.w = r7.x * cb0[12].y + r2.w;
                r11.x = r7.w * cb0[12].y + r2.w;
                r12.xyzw = (int4)r3.wwww + int4(1, 1, 2, 2);
                r13.xyzw = cmp((int4)r12.yyyy == int4(3, 2, 1, 0));
                r14.xyzw = cmp((int4)r12.xyzw == int4(4, 5, 4, 5));
                r13.xyzw = r13.xyzw ? float4(1, 1, 1, 1) : 0;
                r14.xyzw = r14.xyzw ? float4(1, 1, 1, 1) : 0;
                r2.w = dot(r13.wzyx, cb0[11].xyzw);
                r2.w = r14.x * cb0[12].y + r2.w;
                r11.y = r14.y * cb0[12].y + r2.w;
                r12.xyzw = cmp((int4)r12.wwww == int4(3, 2, 1, 0));
                r12.xyzw = r12.xyzw ? float4(1, 1, 1, 1) : 0;
                r2.w = dot(r12.wzyx, cb0[11].xyzw);
                r2.w = r14.z * cb0[12].y + r2.w;
                r11.z = r14.w * cb0[12].y + r2.w;
                r10.x = r10.y * r10.y;
                r12.x = dot(r11.xzy, float3(0.5, 0.5, -1));
                r12.y = dot(r11.xy, float2(-1, 1));
                r12.z = dot(r11.xy, float2(0.5, 0.5));
                r10.z = 1;
                r1.w = dot(r10.xyz, r12.xyz);
              } else {
                r2.w = log2(cb0[8].w);
                r1.w = 0.30103001 * r2.w;
              }
            }
          }
          r1.w = 3.32192802 * r1.w;
          r1.w = exp2(r1.w);
          if (r9.y != 0) {
            r2.w = log2(cb0[8].y);
            r2.w = 0.30103001 * r2.w;
          } else {
            r3.w = cmp(r0.w < r8.y);
            r4.w = log2(cb0[9].x);
            r5.w = 0.30103001 * r4.w;
            r6.w = cmp(r8.y < r5.w);
            r3.w = r3.w ? r6.w : 0;
            if (r3.w != 0) {
              r3.w = r7.y * 0.30103001 + -r0.w;
              r3.w = 3 * r3.w;
              r4.w = r4.w * 0.30103001 + -r0.w;
              r3.w = r3.w / r4.w;
              r4.w = (int)r3.w;
              r6.w = trunc(r3.w);
              r10.y = -r6.w + r3.w;
              r11.xyzw = cmp((int4)r4.wwww == int4(3, 2, 1, 0));
              r7.xw = cmp((int2)r4.ww == int2(4, 5));
              r11.xyzw = r11.xyzw ? float4(1, 1, 1, 1) : 0;
              r7.xw = r7.xw ? float2(1, 1) : 0;
              r3.w = dot(r11.wzyx, cb0[10].xyzw);
              r3.w = r7.x * cb0[12].x + r3.w;
              r11.x = r7.w * cb0[12].x + r3.w;
              r12.xyzw = (int4)r4.wwww + int4(1, 1, 2, 2);
              r13.xyzw = cmp((int4)r12.yyyy == int4(3, 2, 1, 0));
              r14.xyzw = cmp((int4)r12.xyzw == int4(4, 5, 4, 5));
              r13.xyzw = r13.xyzw ? float4(1, 1, 1, 1) : 0;
              r14.xyzw = r14.xyzw ? float4(1, 1, 1, 1) : 0;
              r3.w = dot(r13.wzyx, cb0[10].xyzw);
              r3.w = r14.x * cb0[12].x + r3.w;
              r11.y = r14.y * cb0[12].x + r3.w;
              r12.xyzw = cmp((int4)r12.wwww == int4(3, 2, 1, 0));
              r12.xyzw = r12.xyzw ? float4(1, 1, 1, 1) : 0;
              r3.w = dot(r12.wzyx, cb0[10].xyzw);
              r3.w = r14.z * cb0[12].x + r3.w;
              r11.z = r14.w * cb0[12].x + r3.w;
              r10.x = r10.y * r10.y;
              r12.x = dot(r11.xzy, float3(0.5, 0.5, -1));
              r12.y = dot(r11.xy, float2(-1, 1));
              r12.z = dot(r11.xy, float2(0.5, 0.5));
              r10.z = 1;
              r2.w = dot(r10.xyz, r12.xyz);
            } else {
              r3.w = cmp(r8.y >= r5.w);
              r4.w = log2(cb0[8].z);
              r6.w = 0.30103001 * r4.w;
              r6.w = cmp(r8.y < r6.w);
              r3.w = r3.w ? r6.w : 0;
              if (r3.w != 0) {
                r3.w = r7.y * 0.30103001 + -r5.w;
                r3.w = 3 * r3.w;
                r4.w = r4.w * 0.30103001 + -r5.w;
                r3.w = r3.w / r4.w;
                r4.w = (int)r3.w;
                r5.w = trunc(r3.w);
                r10.y = -r5.w + r3.w;
                r11.xyzw = cmp((int4)r4.wwww == int4(3, 2, 1, 0));
                r7.xy = cmp((int2)r4.ww == int2(4, 5));
                r11.xyzw = r11.xyzw ? float4(1, 1, 1, 1) : 0;
                r7.xy = r7.xy ? float2(1, 1) : 0;
                r3.w = dot(r11.wzyx, cb0[11].xyzw);
                r3.w = r7.x * cb0[12].y + r3.w;
                r11.x = r7.y * cb0[12].y + r3.w;
                r12.xyzw = (int4)r4.wwww + int4(1, 1, 2, 2);
                r13.xyzw = cmp((int4)r12.yyyy == int4(3, 2, 1, 0));
                r14.xyzw = cmp((int4)r12.xyzw == int4(4, 5, 4, 5));
                r13.xyzw = r13.xyzw ? float4(1, 1, 1, 1) : 0;
                r14.xyzw = r14.xyzw ? float4(1, 1, 1, 1) : 0;
                r3.w = dot(r13.wzyx, cb0[11].xyzw);
                r3.w = r14.x * cb0[12].y + r3.w;
                r11.y = r14.y * cb0[12].y + r3.w;
                r12.xyzw = cmp((int4)r12.wwww == int4(3, 2, 1, 0));
                r12.xyzw = r12.xyzw ? float4(1, 1, 1, 1) : 0;
                r3.w = dot(r12.wzyx, cb0[11].xyzw);
                r3.w = r14.z * cb0[12].y + r3.w;
                r11.z = r14.w * cb0[12].y + r3.w;
                r10.x = r10.y * r10.y;
                r12.x = dot(r11.xzy, float3(0.5, 0.5, -1));
                r12.y = dot(r11.xy, float2(-1, 1));
                r12.z = dot(r11.xy, float2(0.5, 0.5));
                r10.z = 1;
                r2.w = dot(r10.xyz, r12.xyz);
              } else {
                r3.w = log2(cb0[8].w);
                r2.w = 0.30103001 * r3.w;
              }
            }
          }
          r2.w = 3.32192802 * r2.w;
          r2.w = exp2(r2.w);
          if (r9.z != 0) {
            r3.w = log2(cb0[8].y);
            r3.w = 0.30103001 * r3.w;
          } else {
            r4.w = cmp(r0.w < r8.z);
            r5.w = log2(cb0[9].x);
            r6.w = 0.30103001 * r5.w;
            r7.x = cmp(r8.z < r6.w);
            r4.w = r4.w ? r7.x : 0;
            if (r4.w != 0) {
              r4.w = r7.z * 0.30103001 + -r0.w;
              r4.w = 3 * r4.w;
              r0.w = r5.w * 0.30103001 + -r0.w;
              r0.w = r4.w / r0.w;
              r4.w = (int)r0.w;
              r5.w = trunc(r0.w);
              r9.y = -r5.w + r0.w;
              r10.xyzw = cmp((int4)r4.wwww == int4(3, 2, 1, 0));
              r7.xy = cmp((int2)r4.ww == int2(4, 5));
              r10.xyzw = r10.xyzw ? float4(1, 1, 1, 1) : 0;
              r7.xy = r7.xy ? float2(1, 1) : 0;
              r0.w = dot(r10.wzyx, cb0[10].xyzw);
              r0.w = r7.x * cb0[12].x + r0.w;
              r10.x = r7.y * cb0[12].x + r0.w;
              r11.xyzw = (int4)r4.wwww + int4(1, 1, 2, 2);
              r12.xyzw = cmp((int4)r11.yyyy == int4(3, 2, 1, 0));
              r13.xyzw = cmp((int4)r11.xyzw == int4(4, 5, 4, 5));
              r12.xyzw = r12.xyzw ? float4(1, 1, 1, 1) : 0;
              r13.xyzw = r13.xyzw ? float4(1, 1, 1, 1) : 0;
              r0.w = dot(r12.wzyx, cb0[10].xyzw);
              r0.w = r13.x * cb0[12].x + r0.w;
              r10.y = r13.y * cb0[12].x + r0.w;
              r11.xyzw = cmp((int4)r11.wwww == int4(3, 2, 1, 0));
              r11.xyzw = r11.xyzw ? float4(1, 1, 1, 1) : 0;
              r0.w = dot(r11.wzyx, cb0[10].xyzw);
              r0.w = r13.z * cb0[12].x + r0.w;
              r10.z = r13.w * cb0[12].x + r0.w;
              r9.x = r9.y * r9.y;
              r11.x = dot(r10.xzy, float3(0.5, 0.5, -1));
              r11.y = dot(r10.xy, float2(-1, 1));
              r11.z = dot(r10.xy, float2(0.5, 0.5));
              r9.z = 1;
              r3.w = dot(r9.xyz, r11.xyz);
            } else {
              r0.w = cmp(r8.z >= r6.w);
              r4.w = log2(cb0[8].z);
              r5.w = 0.30103001 * r4.w;
              r5.w = cmp(r8.z < r5.w);
              r0.w = r0.w ? r5.w : 0;
              if (r0.w != 0) {
                r0.w = r7.z * 0.30103001 + -r6.w;
                r0.w = 3 * r0.w;
                r4.w = r4.w * 0.30103001 + -r6.w;
                r0.w = r0.w / r4.w;
                r4.w = (int)r0.w;
                r5.w = trunc(r0.w);
                r7.y = -r5.w + r0.w;
                r8.xyzw = cmp((int4)r4.wwww == int4(3, 2, 1, 0));
                r9.xy = cmp((int2)r4.ww == int2(4, 5));
                r8.xyzw = r8.xyzw ? float4(1, 1, 1, 1) : 0;
                r9.xy = r9.xy ? float2(1, 1) : 0;
                r0.w = dot(r8.wzyx, cb0[11].xyzw);
                r0.w = r9.x * cb0[12].y + r0.w;
                r8.x = r9.y * cb0[12].y + r0.w;
                r9.xyzw = (int4)r4.wwww + int4(1, 1, 2, 2);
                r10.xyzw = cmp((int4)r9.yyyy == int4(3, 2, 1, 0));
                r11.xyzw = cmp((int4)r9.xyzw == int4(4, 5, 4, 5));
                r10.xyzw = r10.xyzw ? float4(1, 1, 1, 1) : 0;
                r11.xyzw = r11.xyzw ? float4(1, 1, 1, 1) : 0;
                r0.w = dot(r10.wzyx, cb0[11].xyzw);
                r0.w = r11.x * cb0[12].y + r0.w;
                r8.y = r11.y * cb0[12].y + r0.w;
                r9.xyzw = cmp((int4)r9.wwww == int4(3, 2, 1, 0));
                r9.xyzw = r9.xyzw ? float4(1, 1, 1, 1) : 0;
                r0.w = dot(r9.wzyx, cb0[11].xyzw);
                r0.w = r11.z * cb0[12].y + r0.w;
                r8.z = r11.w * cb0[12].y + r0.w;
                r7.x = r7.y * r7.y;
                r9.x = dot(r8.xzy, float3(0.5, 0.5, -1));
                r9.y = dot(r8.xy, float2(-1, 1));
                r9.z = dot(r8.xy, float2(0.5, 0.5));
                r7.z = 1;
                r3.w = dot(r7.xyz, r9.xyz);
              } else {
                r0.w = log2(cb0[8].w);
                r3.w = 0.30103001 * r0.w;
              }
            }
          }
          r0.w = 3.32192802 * r3.w;
          r0.w = exp2(r0.w);
          r1.w = -cb0[8].y + r1.w;
          r3.w = cb0[8].w + -cb0[8].y;
          r7.x = r1.w / r3.w;
          r1.w = -cb0[8].y + r2.w;
          r7.y = r1.w / r3.w;
          r0.w = -cb0[8].y + r0.w;
          r7.z = r0.w / r3.w;
          r8.x = dot(float3(0.662454188, 0.134004205, 0.156187683), r7.xyz);
          r8.y = dot(float3(0.272228718, 0.674081743, 0.0536895171), r7.xyz);
          r8.z = dot(float3(-0.00557464967, 0.0040607336, 1.01033914), r7.xyz);
          r7.x = saturate(dot(float3(1.6410234, -0.324803293, -0.236424699), r8.xyz));
          r7.y = saturate(dot(float3(-0.663662851, 1.61533165, 0.0167563483), r8.xyz));
          r7.z = saturate(dot(float3(0.0117218941, -0.00828444213, 0.988394856), r8.xyz));
          r8.x = dot(float3(0.662454188, 0.134004205, 0.156187683), r7.xyz);
          r8.y = dot(float3(0.272228718, 0.674081743, 0.0536895171), r7.xyz);
          r8.z = dot(float3(-0.00557464967, 0.0040607336, 1.01033914), r7.xyz);
          r7.x = dot(float3(1.6410234, -0.324803293, -0.236424699), r8.xyz);
          r7.y = dot(float3(-0.663662851, 1.61533165, 0.0167563483), r8.xyz);
          r7.z = dot(float3(0.0117218941, -0.00828444213, 0.988394856), r8.xyz);
          r7.xyz = max(float3(0, 0, 0), r7.xyz);
          r7.xyz = cb0[8].www * r7.xyz;
          r7.xyz = max(float3(0, 0, 0), r7.xyz);
          r7.xyz = min(float3(65535, 65535, 65535), r7.xyz);
          r0.w = cmp(6 != asint(cb0[40].w));
          r8.x = dot(r3.xyz, r7.xyz);
          r8.y = dot(r4.xyz, r7.xyz);
          r8.z = dot(r2.xyz, r7.xyz);
          r7.xyz = r0.www ? r8.xyz : r7.xyz;
          r7.xyz = float3(9.99999975e-05, 9.99999975e-05, 9.99999975e-05) * r7.xyz;
          r7.xyz = log2(r7.xyz);
          r7.xyz = float3(0.159301758, 0.159301758, 0.159301758) * r7.xyz;
          r7.xyz = exp2(r7.xyz);
          r8.xyz = r7.xyz * float3(18.8515625, 18.8515625, 18.8515625) + float3(0.8359375, 0.8359375, 0.8359375);
          r7.xyz = r7.xyz * float3(18.6875, 18.6875, 18.6875) + float3(1, 1, 1);
          r7.xyz = rcp(r7.xyz);
          r7.xyz = r8.xyz * r7.xyz;
          r7.xyz = log2(r7.xyz);
          r7.xyz = float3(78.84375, 78.84375, 78.84375) * r7.xyz;
          r6.xyz = exp2(r7.xyz);
        } else {
          r0.w = cmp(7 == asint(cb0[40].w));
          if (r0.w != 0) {
            r7.x = dot(cb1[8].xyz, r0.xyz);
            r7.y = dot(cb1[9].xyz, r0.xyz);
            r7.z = dot(cb1[10].xyz, r0.xyz);
            r8.x = dot(r3.xyz, r7.xyz);
            r8.y = dot(r4.xyz, r7.xyz);
            r8.z = dot(r2.xyz, r7.xyz);
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
            r6.xyz = exp2(r7.xyz);
          } else {
            r7.xy = cmp(int2(8, 9) == asint(cb0[40].ww));
            r8.x = dot(cb1[8].xyz, r1.xyz);
            r8.y = dot(cb1[9].xyz, r1.xyz);
            r8.z = dot(cb1[10].xyz, r1.xyz);
            r1.x = dot(r3.xyz, r8.xyz);
            r1.y = dot(r4.xyz, r8.xyz);
            r1.z = dot(r2.xyz, r8.xyz);
            r8.x = dot(cb1[8].xyz, r5.xyz);
            r8.y = dot(cb1[9].xyz, r5.xyz);
            r8.z = dot(cb1[10].xyz, r5.xyz);
            r0.w = dot(r3.xyz, r8.xyz);
            r1.w = dot(r4.xyz, r8.xyz);
            r2.x = dot(r2.xyz, r8.xyz);
            r3.x = log2(r0.w);
            r3.y = log2(r1.w);
            r3.z = log2(r2.x);
            r2.xyz = cb0[40].zzz * r3.xyz;
            r2.xyz = exp2(r2.xyz);
            r1.xyz = r7.yyy ? r1.xyz : r2.xyz;
            r6.xyz = r7.xxx ? r0.xyz : r1.xyz;
          }
        }
      }
    }
  }

  // CustomEdit
  float3 output = o0.rgb;
  output = renodx::color::bt2020::from::BT709(output);
  output = renodx::color::pq::Encode(output, injectedData.toneMapGameNits);
  o0.rgb = output;
  o0.w = 0;

  return;
}
