#include "./filmiclutbuilder.hlsli"

// ---- Created with 3Dmigoto v1.4.1 on Thu Dec 26 02:00:30 2024
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1) {
  float4 cb1[21];
}

// cbuffer cb0 : register(b0) {
//   float4 cb0[42];
// }

// 3Dmigoto declarations
#define cmp -

void main(
    linear noperspective float2 v0: TEXCOORD0,
    float4 v1: SV_POSITION0,
    uint v2: SV_RenderTargetArrayIndex0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4, r5, r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = 0.5 / cb0[35].x;
  r0.xy = v0.xy + -r0.xx;
  r0.xy = cb0[35].xx * r0.xy;
  r0.z = cb0[35].x + -1;
  r1.xy = r0.xy / r0.zz;
  r0.x = (uint)v2.x;
  r1.z = r0.x / r0.z;
  r0.xyz = float3(-0.434017599, -0.434017599, -0.434017599) + r1.xyz;
  r0.xyz = float3(14, 14, 14) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = r0.xyz * float3(0.180000007, 0.180000007, 0.180000007) + float3(-0.00266771927, -0.00266771927, -0.00266771927);
  r1.x = dot(cb1[8].xyz, r0.xyz);
  r1.y = dot(cb1[9].xyz, r0.xyz);
  r1.z = dot(cb1[10].xyz, r0.xyz);
  r0.x = dot(float3(1.37041235, -0.329292178, -0.0636831224), r1.xyz);
  r0.y = dot(float3(-0.083433494, 1.09709275, -0.0108613791), r1.xyz);
  r0.z = dot(float3(-0.0257933214, -0.0986258015, 1.20369494), r1.xyz);
  r0.xyz = r0.xyz + -r1.xyz;
  r0.w = dot(r1.xyz, float3(0.272228718, 0.674081743, 0.0536895171));
  r2.xyz = r1.xyz / r0.www;
  r0.w = r0.w * r0.w;
  r0.w = cb0[36].w * r0.w;
  r0.w = -4 * r0.w;
  r0.w = exp2(r0.w);
  r0.w = 1 + -r0.w;
  r2.xyz = float3(-1, -1, -1) + r2.xyz;
  r1.w = dot(r2.xyz, r2.xyz);
  r1.w = -4 * r1.w;
  r1.w = exp2(r1.w);
  r1.w = 1 + -r1.w;
  r0.w = r1.w * r0.w;
  r0.xyz = r0.www * r0.xyz + r1.xyz;
  r0.w = dot(r0.xyz, float3(0.272228718, 0.674081743, 0.0536895171));
  r0.xyz = r0.xyz + -r0.www;
  r1.xyzw = cb0[25].xyzw * cb0[15].xyzw;
  r1.xyz = r1.xyz * r1.www;
  r1.xyz = r1.xyz * r0.xyz + r0.www;
  r1.xyz = max(float3(0, 0, 0), r1.xyz);
  r1.xyz = float3(5.55555534, 5.55555534, 5.55555534) * r1.xyz;
  r1.xyz = log2(r1.xyz);
  r2.xyzw = cb0[26].xyzw * cb0[16].xyzw;
  r2.xyz = r2.xyz * r2.www;
  r1.xyz = r2.xyz * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.xyz = float3(0.180000007, 0.180000007, 0.180000007) * r1.xyz;
  r1.xyz = log2(r1.xyz);
  r2.xyzw = cb0[27].xyzw * cb0[17].xyzw;
  r2.xyz = r2.xyz * r2.www;
  r2.xyz = float3(1, 1, 1) / r2.xyz;
  r1.xyz = r2.xyz * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r2.xyzw = cb0[28].xyzw * cb0[18].xyzw;
  r2.xyz = r2.xyz * r2.www;
  r3.xyzw = cb0[29].xyzw + cb0[19].xyzw;
  r3.xyz = r3.xyz + r3.www;
  r1.xyz = r1.xyz * r2.xyz + r3.xyz;
  r1.w = 1 / cb0[35].w;
  r1.w = saturate(r1.w * r0.w);
  r2.x = r1.w * -2 + 3;
  r1.w = r1.w * r1.w;
  r1.w = -r2.x * r1.w + 1;
  r2.x = 1 + -r1.w;
  r2.y = -cb0[36].x + r0.w;
  r2.z = cb0[36].y + -cb0[36].x;
  r2.z = 1 / r2.z;
  r2.y = saturate(r2.y * r2.z);
  r2.z = r2.y * -2 + 3;
  r2.y = r2.y * r2.y;
  r2.x = -r2.z * r2.y + r2.x;
  r2.y = r2.z * r2.y;
  r1.xyz = r2.xxx * r1.xyz;
  r3.xyzw = cb0[20].xyzw * cb0[15].xyzw;
  r2.xzw = r3.xyz * r3.www;
  r2.xzw = r2.xzw * r0.xyz + r0.www;
  r2.xzw = max(float3(0, 0, 0), r2.xzw);
  r2.xzw = float3(5.55555534, 5.55555534, 5.55555534) * r2.xzw;
  r2.xzw = log2(r2.xzw);
  r3.xyzw = cb0[21].xyzw * cb0[16].xyzw;
  r3.xyz = r3.xyz * r3.www;
  r2.xzw = r3.xyz * r2.xzw;
  r2.xzw = exp2(r2.xzw);
  r2.xzw = float3(0.180000007, 0.180000007, 0.180000007) * r2.xzw;
  r2.xzw = log2(r2.xzw);
  r3.xyzw = cb0[22].xyzw * cb0[17].xyzw;
  r3.xyz = r3.xyz * r3.www;
  r3.xyz = float3(1, 1, 1) / r3.xyz;
  r2.xzw = r3.xyz * r2.xzw;
  r2.xzw = exp2(r2.xzw);
  r3.xyzw = cb0[23].xyzw * cb0[18].xyzw;
  r3.xyz = r3.xyz * r3.www;
  r4.xyzw = cb0[24].xyzw + cb0[19].xyzw;
  r4.xyz = r4.xyz + r4.www;
  r2.xzw = r2.xzw * r3.xyz + r4.xyz;
  r1.xyz = r2.xzw * r1.www + r1.xyz;
  r3.xyzw = cb0[30].xyzw * cb0[15].xyzw;
  r2.xzw = r3.xyz * r3.www;
  r0.xyz = r2.xzw * r0.xyz + r0.www;
  r0.xyz = max(float3(0, 0, 0), r0.xyz);
  r0.xyz = float3(5.55555534, 5.55555534, 5.55555534) * r0.xyz;
  r0.xyz = log2(r0.xyz);
  r3.xyzw = cb0[31].xyzw * cb0[16].xyzw;
  r2.xzw = r3.xyz * r3.www;
  r0.xyz = r2.xzw * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = float3(0.180000007, 0.180000007, 0.180000007) * r0.xyz;
  r0.xyz = log2(r0.xyz);
  r3.xyzw = cb0[32].xyzw * cb0[17].xyzw;
  r2.xzw = r3.xyz * r3.www;
  r2.xzw = float3(1, 1, 1) / r2.xzw;
  r0.xyz = r2.xzw * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r3.xyzw = cb0[33].xyzw * cb0[18].xyzw;
  r2.xzw = r3.xyz * r3.www;
  r3.xyzw = cb0[34].xyzw + cb0[19].xyzw;
  r3.xyz = r3.xyz + r3.www;
  r0.xyz = r0.xyz * r2.xzw + r3.xyz;
  r0.xyz = r0.xyz * r2.yyy + r1.xyz;

  // SetUntonemappedAP1(r0.xyz);
  float3 untonemapped_ap1 = r0.rgb;

#if 1

  ApplyFilmToneMapWithBlueCorrect(r0.r, r0.g, r0.b,
                                  r0.r, r0.g, r0.b);

#else
  r1.x = dot(float3(0.938639402, 1.02359565e-10, 0.0613606237), r0.xyz);
  r1.y = dot(float3(8.36008554e-11, 0.830794156, 0.169205874), r0.xyz);
  r1.z = dot(float3(2.13187367e-12, -5.63307213e-12, 1), r0.xyz);
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = cb0[36].zzz * r1.xyz + r0.xyz;
  r1.y = dot(float3(0.695452213, 0.140678704, 0.163869068), r0.xyz);
  r1.z = dot(float3(0.0447945632, 0.859671116, 0.0955343172), r0.xyz);
  r1.w = dot(float3(-0.00552588236, 0.00402521016, 1.00150073), r0.xyz);
  r2.xyz = r1.wzy + -r1.zyw;
  r2.xy = r2.xy * r1.wz;
  r0.w = r2.x + r2.y;
  r0.w = r1.y * r2.z + r0.w;
  r0.w = sqrt(r0.w);
  r1.x = r1.w + r1.z;
  r1.x = r1.x + r1.y;
  r0.w = r0.w * 1.75 + r1.x;
  r1.x = 0.333333343 * r0.w;
  r1.x = 0.0799999982 / r1.x;
  r1.x = -0.5 + r1.x;
  r2.x = min(r1.y, r1.z);
  r2.x = min(r2.x, r1.w);
  r2.y = max(r1.y, r1.z);
  r2.y = max(r2.y, r1.w);
  r2.xyz = max(float3(1.00000001e-10, 1.00000001e-10, 0.00999999978), r2.xyy);
  r2.x = r2.y + -r2.x;
  r2.x = r2.x / r2.z;
  r2.y = -0.400000006 + r2.x;
  r2.z = cmp(0 < r2.y);
  r2.w = cmp(r2.y < 0);
  r2.y = 2.5 * r2.y;
  r2.y = 1 + -abs(r2.y);
  r2.y = max(0, r2.y);
  r2.y = -r2.y * r2.y + 1;
  r2.z = (int)-r2.z + (int)r2.w;
  r2.z = (int)r2.z;
  r2.y = r2.z * r2.y + 1;
  r2.y = 0.0250000004 * r2.y;
  r1.x = r2.y * r1.x;
  r2.z = cmp(r0.w >= 0.479999989);
  r0.w = cmp(0.159999996 >= r0.w);
  r1.x = r2.z ? 0 : r1.x;
  r0.w = r0.w ? r2.y : r1.x;
  r0.w = 1 + r0.w;
  r3.yzw = r1.yzw * r0.www;
  r1.x = -r1.y * r0.w + 0.0299999993;
  r1.y = r1.z * r0.w + -r3.w;
  r1.y = 1.73205078 * r1.y;
  r1.z = r3.y * 2 + -r3.z;
  r0.w = -r1.w * r0.w + r1.z;
  r1.z = max(abs(r1.y), abs(r0.w));
  r1.z = 1 / r1.z;
  r1.w = min(abs(r1.y), abs(r0.w));
  r1.z = r1.w * r1.z;
  r1.w = r1.z * r1.z;
  r2.y = r1.w * 0.0208350997 + -0.0851330012;
  r2.y = r1.w * r2.y + 0.180141002;
  r2.y = r1.w * r2.y + -0.330299497;
  r1.w = r1.w * r2.y + 0.999866009;
  r2.y = r1.z * r1.w;
  r2.y = r2.y * -2 + 1.57079637;
  r2.z = cmp(abs(r0.w) < abs(r1.y));
  r2.y = r2.z ? r2.y : 0;
  r1.z = r1.z * r1.w + r2.y;
  r1.w = cmp(r0.w < -r0.w);
  r1.w = r1.w ? -3.141593 : 0;
  r1.z = r1.z + r1.w;
  r1.w = min(r1.y, r0.w);
  r0.w = max(r1.y, r0.w);
  r0.w = cmp(r0.w >= -r0.w);
  r1.y = cmp(r1.w < -r1.w);
  r0.w = r0.w ? r1.y : 0;
  r0.w = r0.w ? -r1.z : r1.z;
  r0.w = 57.2957802 * r0.w;
  r1.yz = cmp(r3.zw == r3.yz);
  r1.y = r1.z ? r1.y : 0;
  r0.w = r1.y ? 0 : r0.w;
  r1.y = cmp(r0.w < 0);
  r1.z = 360 + r0.w;
  r0.w = r1.y ? r1.z : r0.w;
  r0.w = max(0, r0.w);
  r0.w = min(360, r0.w);
  r1.y = cmp(180 < r0.w);
  r1.z = -360 + r0.w;
  r0.w = r1.y ? r1.z : r0.w;
  r0.w = 0.0148148146 * r0.w;
  r0.w = 1 + -abs(r0.w);
  r0.w = max(0, r0.w);
  r1.y = r0.w * -2 + 3;
  r0.w = r0.w * r0.w;
  r0.w = r1.y * r0.w;
  r0.w = r0.w * r0.w;
  r0.w = r0.w * r2.x;
  r0.w = r0.w * r1.x;
  r3.x = r0.w * 0.180000007 + r3.y;

  // AP0 -> AP1
  r1.x = dot(float3(1.45143926, -0.236510754, -0.214928567), r3.xzw);
  r1.y = dot(float3(-0.0765537769, 1.17622972, -0.0996759236), r3.xzw);
  r1.z = dot(float3(0.00831614807, -0.00603244966, 0.997716308), r3.xzw);
  r1.xyz = max(float3(0, 0, 0), r1.xyz);
  r0.w = dot(r1.xyz, float3(0.272228718, 0.674081743, 0.0536895171));
  r1.xyz = r1.xyz + -r0.www;
  r1.xyz = r1.xyz * float3(0.959999979, 0.959999979, 0.959999979) + r0.www;

  // END RRT
  float3 untonemapped_rrt_ap1 = r1.rgb;

  r1.xyz = log2(r1.xyz);
  r0.w = cb0[37].w / cb0[37].y;
  r2.xyz = cb0[38].xyx + float3(1, 1, 0.180000007);
  r2.xw = -cb0[37].zw + r2.xy;
  r1.w = r2.z / r2.x;
  r2.z = -1 + r1.w;
  r2.z = 1 + -r2.z;
  r1.w = r1.w / r2.z;
  r1.w = log2(r1.w);
  r1.w = 0.346573591 * r1.w;
  r2.z = r2.x / cb0[37].y;
  r1.w = -r1.w * r2.z + -0.744727492;
  r2.z = cmp(0.800000012 < cb0[37].z);
  r3.xy = -cb0[37].zz + float2(0.819999993, 1);
  r3.xy = r3.xy / cb0[37].yy;
  r3.x = -0.744727492 + r3.x;
  r1.w = r2.z ? r3.x : r1.w;
  r2.z = r3.y + -r1.w;
  r0.w = -r2.z + r0.w;
  r3.xyz = r1.xyz * float3(0.30103001, 0.30103001, 0.30103001) + r2.zzz;
  r3.xyz = cb0[37].yyy * r3.xyz;
  r4.xyz = r1.xyz * float3(0.30103001, 0.30103001, 0.30103001) + -r0.www;
  r2.z = cb0[37].y + cb0[37].y;
  r2.z = r2.z / r2.w;
  r4.xyz = r2.zzz * r4.xyz;
  r4.xyz = float3(1.44269502, 1.44269502, 1.44269502) * r4.xyz;
  r4.xyz = exp2(r4.xyz);
  r4.xyz = float3(1, 1, 1) + r4.xyz;
  r2.zw = r2.xw + r2.xw;
  r4.xyz = r2.www / r4.xyz;
  r4.xyz = -r4.xyz + r2.yyy;
  r5.xyz = float3(0.30103001, 0.30103001, 0.30103001) * r1.xyz;
  r1.xyz = r1.xyz * float3(0.30103001, 0.30103001, 0.30103001) + -r1.www;
  r6.xyz = cmp(r0.www < r5.xyz);
  r5.xyz = cmp(r5.xyz < r1.www);
  r4.xyz = r6.xyz ? r4.xyz : r3.xyz;
  r2.y = cb0[37].y * -2;
  r2.x = r2.y / r2.x;
  r2.xyw = r2.xxx * r1.xyz;
  r2.xyw = float3(1.44269502, 1.44269502, 1.44269502) * r2.xyw;
  r2.xyw = exp2(r2.xyw);
  r2.xyw = float3(1, 1, 1) + r2.xyw;
  r2.xyz = r2.zzz / r2.xyw;
  r2.xyz = -cb0[38].xxx + r2.xyz;
  r2.xyz = r5.xyz ? r2.xyz : r3.xyz;
  r3.xyz = r4.xyz + -r2.xyz;
  r2.w = r0.w + -r1.w;
  r0.w = cmp(r0.w < r1.w);
  r1.xyz = saturate(r1.xyz / r2.www);
  r4.xyz = float3(1, 1, 1) + -r1.xyz;
  r1.xyz = r0.www ? r4.xyz : r1.xyz;
  r4.xyz = -r1.xyz * float3(2, 2, 2) + float3(3, 3, 3);
  r1.xyz = r1.xyz * r1.xyz;
  r1.xyz = r1.xyz * r4.xyz;
  r1.xyz = r1.xyz * r3.xyz + r2.xyz;
  r0.w = dot(r1.xyz, float3(0.272228718, 0.674081743, 0.0536895171));
  r1.xyz = r1.xyz + -r0.www;
  r1.xyz = r1.xyz * float3(0.930000007, 0.930000007, 0.930000007) + r0.www;
  r1.xyz = max(float3(0, 0, 0), r1.xyz);
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = cb0[37].xxx * r1.xyz + r0.xyz;
  r1.x = dot(float3(1.06537485, 1.44678506e-06, -0.0653710067), r0.xyz);
  r1.y = dot(float3(-3.45525592e-07, 1.20366347, -0.203667715), r0.xyz);
  r1.z = dot(float3(1.9865448e-08, 2.12079581e-08, 0.999999583), r0.xyz);
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = cb0[36].zzz * r1.xyz + r0.xyz;
#endif
  // SetTonemappedAP1(r0.xyz);
  // r0.rgb = untonemapped_ap1;

  // AP1 -> BT.709
  r1.x = (dot(cb1[12].xyz, r0.xyz));
  r1.y = (dot(cb1[13].xyz, r0.xyz));
  r1.z = (dot(cb1[14].xyz, r0.xyz));

  // sRGB LUT

  float3 lut_input_color = r1.rgb;

#if 1
  SampleLUTUpgradeToneMap(lut_input_color, s0_s, t0, r0.r, r0.g, r0.b);
#else
  r1.rgb = saturate(r1.rgb);
  r0.xyz = log2(r1.xyz);
  r0.xyz = float3(0.416666657, 0.416666657, 0.416666657) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = r0.xyz * float3(1.05499995, 1.05499995, 1.05499995) + float3(-0.0549999997, -0.0549999997, -0.0549999997);
  r2.xyz = float3(12.9200001, 12.9200001, 12.9200001) * r1.xyz;
  r1.xyz = cmp(r1.xyz >= float3(0.00313066994, 0.00313066994, 0.00313066994));
  r0.xyz = r1.xyz ? r0.xyz : r2.xyz;
  r1.yzw = r0.xyz * float3(0.9375, 0.9375, 0.9375) + float3(0.03125, 0.03125, 0.03125);
  r0.w = r1.w * 16 + -0.5;
  r1.w = floor(r0.w);
  r0.w = -r1.w + r0.w;
  r1.y = r1.y + r1.w;
  r1.x = 0.0625 * r1.y;
  r1.yw = float2(0.0625, 0) + r1.xz;
  r2.xyz = t0.Sample(s0_s, r1.xz).xyz;
  r1.xyz = t0.Sample(s0_s, r1.yw).xyz;
  r1.xyz = r1.xyz + -r2.xyz;
  r1.xyz = r0.www * r1.xyz + r2.xyz;
  r1.xyz = cb0[5].yyy * r1.xyz;
  r0.xyz = cb0[5].xxx * r0.xyz + r1.xyz;
  r0.xyz = max(float3(6.10351999e-05, 6.10351999e-05, 6.10351999e-05), r0.xyz);
  r1.xyz = r0.xyz * float3(0.947867274, 0.947867274, 0.947867274) + float3(0.0521326996, 0.0521326996, 0.0521326996);
  r1.xyz = log2(r1.xyz);
  r1.xyz = float3(2.4000001, 2.4000001, 2.4000001) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r2.xyz = cmp(float3(0.0404499993, 0.0404499993, 0.0404499993) < r0.xyz);
  r0.xyz = float3(0.0773993805, 0.0773993805, 0.0773993805) * r0.xyz;
  r0.xyz = r2.xyz ? r1.xyz : r0.xyz;
#endif

  r1.xyz = r0.xyz * r0.xyz;
  r0.xyz = cb0[39].yyy * r0.xyz;
  r0.xyz = cb0[39].xxx * r1.xyz + r0.xyz;
  r0.xyz = cb0[39].zzz + r0.xyz;
  r1.xyz = cb0[14].xyz * r0.xyz;
  r0.xyz = -r0.xyz * cb0[14].xyz + cb0[13].xyz;
  r0.xyz = cb0[13].www * r0.xyz + r1.xyz;

  // r0.rgb = renodx::math::SignPow(r0.rgb, cb0[40].y);

  if (RENODX_TONE_MAP_TYPE != 0) {
    GenerateOutput(r0.r, r0.g, r0.b, o0, output_device);
    return;
  }

  r1.x = dot(cb1[8].xyz, r0.xyz);
  r1.y = dot(cb1[9].xyz, r0.xyz);
  r1.z = dot(cb1[10].xyz, r0.xyz);
  r2.xyzw = cmp(int4(1, 2, 3, 4) == asint(cb0[41].xxxx));
  r3.xyz = r2.www ? float3(1, 0, 0) : float3(1.70505095, -0.621792138, -0.0832588747);
  r3.xyz = r2.zzz ? float3(0.695452213, 0.140678704, 0.163869068) : r3.xyz;
  r3.xyz = r2.yyy ? float3(1.02582479, -0.0200531911, -0.00577155687) : r3.xyz;
  r3.xyz = r2.xxx ? float3(1.37921417, -0.308864146, -0.0703499839) : r3.xyz;
  r3.x = dot(r3.xyz, r1.xyz);
  r4.xyz = r2.www ? float3(0, 1, 0) : float3(-0.130256414, 1.14080477, -0.0105483187);
  r4.xyz = r2.zzz ? float3(0.0447945632, 0.859671116, 0.0955343172) : r4.xyz;
  r4.xyz = r2.yyy ? float3(-0.00223436952, 1.00458646, -0.00235213246) : r4.xyz;
  r4.xyz = r2.xxx ? float3(-0.0693348572, 1.08229673, -0.0129618878) : r4.xyz;
  r3.y = dot(r4.xyz, r1.xyz);
  r4.xyz = r2.www ? float3(0, 0, 1) : float3(-0.0240033567, -0.128968969, 1.15297234);
  r4.xyz = r2.zzz ? float3(-0.00552588282, 0.00402521016, 1.00150073) : r4.xyz;
  r2.yzw = r2.yyy ? float3(-0.00501335133, -0.025290072, 1.03030348) : r4.xyz;
  r2.xyz = r2.xxx ? float3(-0.00215900945, -0.0454593264, 1.04761839) : r2.yzw;
  r3.z = dot(r2.xyz, r1.xyz);
  r0.xyz = (asuint(cb1[20].x) != 0u) ? r0.xyz : r3.xyz;

  r0.rgb = saturate(r0.rgb);
  r0.rgb = renodx::color::srgb::Encode(r0.rgb);

  r0.rgb = ScaleScene(r0.rgb);

  o0.xyz = float3(0.952381015, 0.952381015, 0.952381015) * r0.xyz;
  o0.w = 0;
  return;
}
