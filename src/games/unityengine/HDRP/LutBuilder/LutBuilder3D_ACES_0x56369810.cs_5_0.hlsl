#include "../../tonemap.hlsl"

// ---- Created with 3Dmigoto v1.4.1 on Mon Jan 12 22:10:10 2026
Texture2D<float4> t8 : register(t8);

Texture2D<float4> t7 : register(t7);

Texture2D<float4> t6 : register(t6);

Texture2D<float4> t5 : register(t5);

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture3D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);
RWTexture3D<float4> u0 : register(u0);

cbuffer cb1 : register(b1) {
  float4 cb1[28];
}

cbuffer cb0 : register(b0) {
  float4 cb0[2];
}

// 3Dmigoto declarations
#define cmp -

[numthreads(4, 4, 4)]
void main(uint3 vThreadID: SV_DispatchThreadID) {
  const float4 icb[] = { { -4.000000, -0.718548, -1.698970, 0.515439 },
                         { -4.000000, 2.081031, -1.698970, 0.847044 },
                         { -3.157377, 3.668124, -1.477900, 1.135800 },
                         { -0.485250, 4.000000, -1.229100, 1.380200 },
                         { 1.847732, 4.000000, -0.864800, 1.519700 },
                         { 1.847732, 4.000000, -0.448000, 1.598500 },
                         { 0, 0, 0.005180, 1.646700 },
                         { 0, 0, 0.451108, 1.674609 },
                         { 0, 0, 0.911374, 1.687873 },
                         { 0, 0, 0.911374, 1.687873 } };
  float4 r0, r1, r2, r3, r4, r5, r6, r7, r8;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = (uint3)vThreadID.xyz;
  float3 ungraded;
  r0.w = cmp(0 < cb1[17].x);
  if (r0.w != 0) {
    // r1.xyz = r0.xyz * cb1[0].yyy + float3(-0.386036009,-0.386036009,-0.386036009);
    r1.xyz = r0.xyz * cb1[0].yyy;
    r1.xyz = lutShaper(r1.xyz, true);
    ungraded = r1.xyz;
    // r1.xyz = float3(13.6054821,13.6054821,13.6054821) * r1.xyz;
    // r1.xyz = exp2(r1.xyz);
    // r1.xyz = float3(-0.0479959995,-0.0479959995,-0.0479959995) + r1.xyz;
    // r1.xyz = float3(0.179999992,0.179999992,0.179999992) * r1.xyz;
    r2.x = dot(float3(0.390404999, 0.549941003, 0.00892631989), r1.xyz);
    r2.y = dot(float3(0.070841603, 0.963172019, 0.00135775004), r1.xyz);
    r2.z = dot(float3(0.0231081992, 0.128021002, 0.936245024), r1.xyz);
    r1.xyz = cb1[2].xyz * r2.xyz;
    r2.x = dot(float3(2.85846996, -1.62879002, -0.0248910002), r1.xyz);
    r2.y = dot(float3(-0.210181996, 1.15820003, 0.000324280991), r1.xyz);
    r2.z = dot(float3(-0.0418119989, -0.118169002, 1.06867003), r1.xyz);
    r1.x = dot(float3(0.439700991, 0.382977992, 0.177334994), r2.xyz);
    r1.y = dot(float3(0.0897922963, 0.813422978, 0.0967615992), r2.xyz);
    r1.z = dot(float3(0.0175439995, 0.111543998, 0.870703995), r2.xyz);
    r1.xyz = acesccEncode(r1.xyz);

    // r1.xyz = max(float3(0,0,0), r1.xyz);
    // r1.xyz = min(float3(65504,65504,65504), r1.xyz);
    // r2.xyz = cmp(r1.xyz < float3(3.05175708e-05,3.05175708e-05,3.05175708e-05));
    // r3.xyz = r1.xyz * float3(0.5,0.5,0.5) + float3(1.525878e-05,1.525878e-05,1.525878e-05);
    // r3.xyz = log2(r3.xyz);
    // r3.xyz = float3(9.72000027,9.72000027,9.72000027) + r3.xyz;
    // r3.xyz = float3(0.0570776239,0.0570776239,0.0570776239) * r3.xyz;
    // r1.xyz = log2(r1.xyz);
    // r1.xyz = float3(9.72000027,9.72000027,9.72000027) + r1.xyz;
    // r1.xyz = float3(0.0570776239,0.0570776239,0.0570776239) * r1.xyz;
    // r1.xyz = r2.xyz ? r3.xyz : r1.xyz;

    r1.xyz = float3(-0.413588405, -0.413588405, -0.413588405) + r1.xyz;
    r1.xyz = r1.xyz * cb1[7].zzz + float3(0.413588405, 0.413588405, 0.413588405);
    r4.rgb = acescc::Decode(r1.rgb);
    // r2.xyz = r1.xyz * float3(17.5200005,17.5200005,17.5200005) + float3(-9.72000027,-9.72000027,-9.72000027);
    // r2.xyz = exp2(r2.xyz);
    // r3.xyz = float3(-1.52587891e-05,-1.52587891e-05,-1.52587891e-05) + r2.xyz;
    // r3.xyz = r3.xyz + r3.xyz;
    // r4.xyzw = cmp(r1.xxyy < float4(-0.301369876,1.46799636,-0.301369876,1.46799636));
    // r1.xy = r4.yw ? r2.xy : float2(65504,65504);
    // r4.xy = r4.xz ? r3.xy : r1.xy;
    // r1.xy = cmp(r1.zz < float2(-0.301369876,1.46799636));
    // r0.w = r1.y ? r2.z : 65504;
    // r4.z = r1.x ? r3.z : r0.w;
    // r1.x = dot(float3(1.45143926,-0.236510754,-0.214928567), r4.xyz);
    // r1.y = dot(float3(-0.0765537769,1.17622972,-0.0996759236), r4.xyz);
    // r1.z = dot(float3(0.00831614807,-0.00603244966,0.997716308), r4.xyz);
    r1.rgb = mul(ACES_to_ACEScg_MAT, r4.rgb);
    r1.xyz = cb1[3].xyz * r1.xyz;
    r1.xyz = max(float3(0, 0, 0), r1.xyz);
    r1.xyz = log2(r1.xyz);
    r1.xyz = float3(0.454545468, 0.454545468, 0.454545468) * r1.xyz;
    r1.xyz = exp2(r1.xyz);
    r2.xyz = min(float3(1, 1, 1), r1.xyz);
    r0.w = dot(r2.xyz, float3(0.272228986, 0.674081981, 0.0536894985));
    r0.w = saturate(cb1[15].w + r0.w);
    r1.w = 1 + -r0.w;
    r2.xyz = float3(-0.5, -0.5, -0.5) + cb1[15].xyz;
    r2.xyz = r1.www * r2.xyz + float3(0.5, 0.5, 0.5);
    r3.xyz = float3(-0.5, -0.5, -0.5) + cb1[16].xyz;
    r3.xyz = r0.www * r3.xyz + float3(0.5, 0.5, 0.5);
    r4.xyz = r1.xyz + r1.xyz;
    r5.xyz = r1.xyz * r1.xyz;
    r6.xyz = -r2.xyz * float3(2, 2, 2) + float3(1, 1, 1);
    r5.xyz = r6.xyz * r5.xyz;
    r5.xyz = r4.xyz * r2.xyz + r5.xyz;
    r1.xyz = sqrt(r1.xyz);
    r6.xyz = r2.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
    r7.xyz = float3(1, 1, 1) + -r2.xyz;
    r4.xyz = r7.xyz * r4.xyz;
    r1.xyz = r1.xyz * r6.xyz + r4.xyz;
    r2.xyz = cmp(r2.xyz >= float3(0.5, 0.5, 0.5));
    r4.xyz = r2.xyz ? float3(1, 1, 1) : 0;
    r2.xyz = r2.xyz ? float3(0, 0, 0) : float3(1, 1, 1);
    r2.xyz = r2.xyz * r5.xyz;
    r1.xyz = r1.xyz * r4.xyz + r2.xyz;
    r2.xyz = r1.xyz + r1.xyz;
    r4.xyz = r1.xyz * r1.xyz;
    r5.xyz = -r3.xyz * float3(2, 2, 2) + float3(1, 1, 1);
    r4.xyz = r5.xyz * r4.xyz;
    r4.xyz = r2.xyz * r3.xyz + r4.xyz;
    r1.xyz = sqrt(r1.xyz);
    r5.xyz = r3.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
    r6.xyz = float3(1, 1, 1) + -r3.xyz;
    r2.xyz = r6.xyz * r2.xyz;
    r1.xyz = r1.xyz * r5.xyz + r2.xyz;
    r2.xyz = cmp(r3.xyz >= float3(0.5, 0.5, 0.5));
    r3.xyz = r2.xyz ? float3(1, 1, 1) : 0;
    r2.xyz = r2.xyz ? float3(0, 0, 0) : float3(1, 1, 1);
    r2.xyz = r2.xyz * r4.xyz;
    r1.xyz = r1.xyz * r3.xyz + r2.xyz;
    r1.xyz = log2(abs(r1.xyz));
    r1.xyz = float3(2.20000005, 2.20000005, 2.20000005) * r1.xyz;
    r1.xyz = exp2(r1.xyz);
    r2.x = dot(r1.xyz, cb1[4].xyz);
    r2.y = dot(r1.xyz, cb1[5].xyz);
    r2.z = dot(r1.xyz, cb1[6].xyz);
    r0.w = dot(r2.xyz, float3(0.272228986, 0.674081981, 0.0536894985));
    r1.xy = cb1[14].yw + -cb1[14].xz;
    r1.zw = -cb1[14].xz + r0.ww;
    r1.xy = float2(1, 1) / r1.xy;
    r1.xy = saturate(r1.zw * r1.xy);
    r1.zw = r1.xy * float2(-2, -2) + float2(3, 3);
    r1.xy = r1.xy * r1.xy;
    r0.w = r1.w * r1.y;
    r1.x = -r1.z * r1.x + 1;
    r1.z = 1 + -r1.x;
    r1.y = -r1.w * r1.y + r1.z;
    r3.xyz = cb1[11].xyz * r2.xyz;
    r4.xyz = cb1[12].xyz * r2.xyz;
    r1.yzw = r4.xyz * r1.yyy;
    r1.xyz = r3.xyz * r1.xxx + r1.yzw;
    r2.xyz = cb1[13].xyz * r2.xyz;
    r1.xyz = r2.xyz * r0.www + r1.xyz;
    float3 preLGG = r1.xyz;
    r1.xyz = r1.xyz * cb1[10].xyz + cb1[8].xyz;
    r2.xyz = cmp(float3(0,0,0) < r1.xyz);
    r3.xyz = cmp(r1.xyz < float3(0,0,0));
    r2.xyz = (int3)-r2.xyz + (int3)r3.xyz;
    r2.xyz = (int3)r2.xyz;
    // r1.xyz = log2(abs(r1.xyz));
    // r1.xyz = cb1[9].xyz * r1.xyz;
    // r1.xyz = exp2(r1.xyz);
    // r3.xyz = r2.xyz * r1.xyz;
    // r0.w = cmp(r3.y >= r3.z);
    // r0.w = r0.w ? 1.000000 : 0;

    r3.xyz = sign(r1.xyz) * pow(abs(r1.xyz), cb1[9].xyz);
    r3.xyz = liftGammaGainScaling(r3.xyz, preLGG, cb1[8].xyz, cb1[9].xyz, cb1[10].xyz);
    r0.w = step(r3.z, r3.y);
    r4.xy = r3.zy;
    r4.zw = float2(-1, 0.666666687);
    r1.xy = r2.yz * r1.yz + -r4.xy;
    r1.zw = float2(1, -1);
    r1.xyzw = r0.wwww * r1.xyzw + r4.xyzw;
    r0.w = cmp(r3.x >= r1.x);
    r0.w = r0.w ? 1.000000 : 0;
    r2.xyz = r1.xyw;
    r2.w = r3.x;
    r1.xyw = r2.wyx;
    r1.xyzw = r1.xyzw + -r2.xyzw;
    r1.xyzw = r0.wwww * r1.xyzw + r2.xyzw;
    r0.w = min(r1.w, r1.y);
    r0.w = r1.x + -r0.w;
    r1.y = r1.w + -r1.y;
    r1.w = r0.w * 6 + 9.99999975e-05;
    r1.y = r1.y / r1.w;
    r1.y = r1.z + r1.y;
    r2.x = abs(r1.y);
    r1.y = 9.99999975e-05 + r1.x;
    r2.z = r0.w / r1.y;
    r2.yw = float2(0, 0);
    r0.w = t6.SampleLevel(s0_s, r2.xy, 0).x;
    r0.w = saturate(r0.w);
    r0.w = r0.w + r0.w;
    r1.y = t7.SampleLevel(s0_s, r2.zw, 0).x;
    r1.y = saturate(r1.y);
    r0.w = dot(r1.yy, r0.ww);
    r3.x = dot(r3.xyz, float3(0.212672904, 0.715152204, 0.0721750036));
    r3.yw = float2(0, 0);
    r1.y = t8.SampleLevel(s0_s, r3.xy, 0).x;
    r1.y = saturate(r1.y);
    r0.w = r1.y * r0.w;
    r3.z = cb1[7].x + r2.x;
    r1.y = t5.SampleLevel(s0_s, r3.zw, 0).x;
    r1.y = saturate(r1.y);
    r1.y = -0.5 + r1.y;
    r1.y = r3.z + r1.y;
    r1.z = cmp(r1.y < 0);
    r1.w = cmp(1 < r1.y);
    r2.xy = float2(1, -1) + r1.yy;
    r1.y = r1.w ? r2.y : r1.y;
    r1.y = r1.z ? r2.x : r1.y;
    r1.yzw = float3(1, 0.666666687, 0.333333343) + r1.yyy;
    r1.yzw = frac(r1.yzw);
    r1.yzw = r1.yzw * float3(6, 6, 6) + float3(-3, -3, -3);
    r1.yzw = saturate(float3(-1, -1, -1) + abs(r1.yzw));
    r1.yzw = float3(-1, -1, -1) + r1.yzw;
    r1.yzw = r2.zzz * r1.yzw + float3(1, 1, 1);
    r2.xyz = r1.xxx * r1.yzw;
    r2.x = dot(r2.xyz, float3(0.272228986, 0.674081981, 0.0536894985));
    r0.w = dot(cb1[7].yy, r0.ww);
    r1.xyz = r1.xxx * r1.yzw + -r2.xxx;
    r1.xyz = r0.www * r1.xyz + r2.xxx;
    r0.w = max(r1.x, r1.y);
    r0.w = max(r0.w, r1.z);
    r0.w = 1 + r0.w;
    r0.w = rcp(r0.w);
    r1.xyz = r1.xyz * r0.www + float3(0.00390625, 0.00390625, 0.00390625);
    r1.w = 0;
    r2.x = t1.SampleLevel(s0_s, r1.xw, 0).x;
    r2.x = saturate(r2.x);
    r2.y = t1.SampleLevel(s0_s, r1.yw, 0).x;
    r2.y = saturate(r2.y);
    r2.z = t1.SampleLevel(s0_s, r1.zw, 0).x;
    r2.z = saturate(r2.z);
    r1.xyz = float3(0.00390625, 0.00390625, 0.00390625) + r2.xyz;
    r1.w = 0;
    r2.x = t2.SampleLevel(s0_s, r1.xw, 0).x;
    r2.x = saturate(r2.x);
    r2.y = t3.SampleLevel(s0_s, r1.yw, 0).x;
    r2.y = saturate(r2.y);
    r2.z = t4.SampleLevel(s0_s, r1.zw, 0).x;
    r2.z = saturate(r2.z);
    r1.xyz = cb1[27].xyz * r2.xyz;
    r0.w = max(r1.x, r1.y);
    r0.w = max(r0.w, r1.z);
    r0.w = 1 + -r0.w;
    r0.w = rcp(r0.w);
    r1.xyz = r1.xyz * r0.www;
    r1.xyz = max(float3(0, 0, 0), r1.xyz);
  } else {
    // r0.xyz = r0.xyz * cb1[0].yyy + float3(-0.386036009,-0.386036009,-0.386036009);
    // r0.xyz = float3(13.6054821,13.6054821,13.6054821) * r0.xyz;
    // r0.xyz = exp2(r0.xyz);
    // r0.xyz = float3(-0.0479959995,-0.0479959995,-0.0479959995) + r0.xyz;
    // r1.xyz = float3(0.179999992,0.179999992,0.179999992) * r0.xyz;
    r0.xyz = r0.xyz * cb1[0].yyy;
    r1.rgb = lutShaper(r0.rgb, true);
  }
  r0.xyz = max(float3(0, 0, 0), r1.xyz);

  // (Ritsu): I added this to match other lutbuilders
  if (true) {
    r0.rgb = renodx::color::bt709::from::AP1(r0.rgb);
    r0.xyz = lerp(ungraded, r0.xyz, injectedData.colorGradeInternalLUTStrength);
    r0.rgb = renodx::color::ap1::from::BT709(r0.rgb);
  }

  if (injectedData.toneMapType == 0.f) {
    r0.w = (uint)cb0[0].x;
    if (r0.w == 0) {
      // AP1_2_AP0_MAT
      r1.y = dot(float3(0.695452213, 0.140678704, 0.163869068), r0.xyz);
      r1.z = dot(float3(0.0447945632, 0.859671116, 0.0955343172), r0.xyz);
      r1.w = dot(float3(-0.00552588282, 0.00402521016, 1.00150073), r0.xyz);

      r1.x = min(r1.y, r1.z);
      r1.x = min(r1.x, r1.w);
      r2.x = max(r1.y, r1.z);
      r2.x = max(r2.x, r1.w);
      r2.xy = max(float2(9.99999975e-05, 0.00999999978), r2.xx);
      r1.x = max(9.99999975e-05, r1.x);
      r1.x = r2.x + -r1.x;
      r1.x = r1.x / r2.y;
      r2.xyz = r1.wzy + -r1.zyw;
      r2.xy = r2.xy * r1.wz;
      r2.x = r2.x + r2.y;
      r2.x = r1.y * r2.z + r2.x;
      r2.x = max(0, r2.x);
      r2.x = sqrt(r2.x);
      r2.y = r1.w + r1.z;
      r2.y = r2.y + r1.y;
      r2.x = r2.x * 1.75 + r2.y;
      r2.z = -0.400000006 + r1.x;
      r2.yw = float2(0.333333343, 2.5) * r2.xz;
      r2.w = 1 + -abs(r2.w);
      r2.w = max(0, r2.w);
      r2.z = cmp(r2.z >= 0);
      r2.z = r2.z ? 1 : -1;
      r2.w = -r2.w * r2.w + 1;
      r2.z = r2.z * r2.w + 1;
      r2.z = 0.0250000004 * r2.z;
      r2.w = cmp(0.159999996 >= r2.x);
      r2.x = cmp(r2.x >= 0.479999989);
      r2.y = 0.0799999982 / r2.y;
      r2.y = -0.5 + r2.y;
      r2.y = r2.z * r2.y;
      r2.x = r2.x ? 0 : r2.y;
      r2.x = r2.w ? r2.z : r2.x;
      r2.x = 1 + r2.x;
      r3.yzw = r2.xxx * r1.yzw;
      r2.yz = cmp(r3.zw == r3.yz);
      r2.y = r2.z ? r2.y : 0;
      r1.z = r1.z * r2.x + -r3.w;
      r1.z = 1.73205078 * r1.z;
      r2.z = r3.y * 2 + -r3.z;
      r1.w = -r1.w * r2.x + r2.z;
      r2.z = min(abs(r1.z), abs(r1.w));
      r2.w = max(abs(r1.z), abs(r1.w));
      r2.w = 1 / r2.w;
      r2.z = r2.z * r2.w;
      r2.w = r2.z * r2.z;
      r4.x = r2.w * 0.0208350997 + -0.0851330012;
      r4.x = r2.w * r4.x + 0.180141002;
      r4.x = r2.w * r4.x + -0.330299497;
      r2.w = r2.w * r4.x + 0.999866009;
      r4.x = r2.z * r2.w;
      r4.y = cmp(abs(r1.w) < abs(r1.z));
      r4.x = r4.x * -2 + 1.57079637;
      r4.x = r4.y ? r4.x : 0;
      r2.z = r2.z * r2.w + r4.x;
      r2.w = cmp(r1.w < -r1.w);
      r2.w = r2.w ? -3.141593 : 0;
      r2.z = r2.z + r2.w;
      r2.w = min(r1.z, r1.w);
      r1.z = max(r1.z, r1.w);
      r1.w = cmp(r2.w < -r2.w);
      r1.z = cmp(r1.z >= -r1.z);
      r1.z = r1.z ? r1.w : 0;
      r1.z = r1.z ? -r2.z : r2.z;
      r1.z = 57.2957802 * r1.z;
      r1.z = r2.y ? 0 : r1.z;
      r1.w = cmp(r1.z < 0);
      r2.y = 360 + r1.z;
      r1.z = r1.w ? r2.y : r1.z;
      r1.w = cmp(r1.z < -180);
      r2.y = cmp(180 < r1.z);
      r2.zw = float2(360, -360) + r1.zz;
      r1.z = r2.y ? r2.w : r1.z;
      r1.z = r1.w ? r2.z : r1.z;
      r1.z = 0.0148148146 * r1.z;
      r1.z = 1 + -abs(r1.z);
      r1.z = max(0, r1.z);
      r1.w = r1.z * -2 + 3;
      r1.z = r1.z * r1.z;
      r1.z = r1.w * r1.z;
      r1.z = r1.z * r1.z;
      r1.x = r1.z * r1.x;
      r1.y = -r1.y * r2.x + 0.0299999993;
      r1.x = r1.x * r1.y;
      r3.x = r1.x * 0.180000007 + r3.y;
      r1.xyz = max(float3(0, 0, 0), r3.xzw);
      r1.xyz = min(float3(65504, 65504, 65504), r1.xyz);
      // AP0_2_AP1_MAT
      r2.x = dot(float3(1.45143926, -0.236510754, -0.214928567), r1.xyz);
      r2.y = dot(float3(-0.0765537769, 1.17622972, -0.0996759236), r1.xyz);
      r2.z = dot(float3(0.00831614807, -0.00603244966, 0.997716308), r1.xyz);
      r1.xyz = max(float3(0, 0, 0), r2.xyz);
      r1.xyz = min(float3(65504, 65504, 65504), r1.xyz);
      r1.w = dot(r1.xyz, float3(0.272228986, 0.674081981, 0.0536894985));
      r1.xyz = r1.xyz + -r1.www;
      r1.xyz = r1.xyz * float3(0.959999979, 0.959999979, 0.959999979) + r1.www;
      r2.xyz = cmp(float3(0, 0, 0) >= r1.xyz);
      r1.xyz = log2(r1.xyz);
      r1.xyz = r2.xyz ? float3(-14, -14, -14) : r1.xyz;
      r2.xyz = cmp(float3(-17.4739323, -17.4739323, -17.4739323) >= r1.xyz);
      if (r2.x != 0) {
        r1.w = -4;
      } else {
        r2.x = cmp(r1.x < -2.47393107);
        if (r2.x != 0) {
          r2.x = r1.x * 0.30103001 + 5.26017761;
          r2.w = 0.664385557 * r2.x;
          r3.x = (int)r2.w;
          r2.w = trunc(r2.w);
          r4.y = r2.x * 0.664385557 + -r2.w;
          r2.xw = (int2)r3.xx + int2(1, 2);
          r4.x = r4.y * r4.y;
          r3.x = icb[r3.x + 0].x;
          r3.y = icb[r2.x + 0].x;
          r3.z = icb[r2.w + 0].x;
          r5.x = dot(float3(0.5, -1, 0.5), r3.xyz);
          r5.y = dot(float2(-1, 1), r3.xy);
          r5.z = dot(float2(0.5, 0.5), r3.xy);
          r4.z = 1;
          r1.w = dot(r4.xyz, r5.xyz);
        } else {
          r2.x = cmp(r1.x < 15.5260687);
          if (r2.x != 0) {
            r1.x = r1.x * 0.30103001 + 0.744727492;
            r2.x = 0.553654671 * r1.x;
            r2.w = (int)r2.x;
            r2.x = trunc(r2.x);
            r3.y = r1.x * 0.553654671 + -r2.x;
            r4.xy = (int2)r2.ww + int2(1, 2);
            r3.x = r3.y * r3.y;
            r5.x = icb[r2.w + 0].y;
            r5.y = icb[r4.x + 0].y;
            r5.z = icb[r4.y + 0].y;
            r4.x = dot(float3(0.5, -1, 0.5), r5.xyz);
            r4.y = dot(float2(-1, 1), r5.xy);
            r4.z = dot(float2(0.5, 0.5), r5.xy);
            r3.z = 1;
            r1.w = dot(r3.xyz, r4.xyz);
          } else {
            r1.w = 4;
          }
        }
      }
      r1.x = 3.32192802 * r1.w;
      r3.x = exp2(r1.x);
      if (r2.y != 0) {
        r1.x = -4;
      } else {
        r1.w = cmp(r1.y < -2.47393107);
        if (r1.w != 0) {
          r1.w = r1.y * 0.30103001 + 5.26017761;
          r2.x = 0.664385557 * r1.w;
          r2.y = (int)r2.x;
          r2.x = trunc(r2.x);
          r4.y = r1.w * 0.664385557 + -r2.x;
          r2.xw = (int2)r2.yy + int2(1, 2);
          r4.x = r4.y * r4.y;
          r5.x = icb[r2.y + 0].x;
          r5.y = icb[r2.x + 0].x;
          r5.z = icb[r2.w + 0].x;
          r6.x = dot(float3(0.5, -1, 0.5), r5.xyz);
          r6.y = dot(float2(-1, 1), r5.xy);
          r6.z = dot(float2(0.5, 0.5), r5.xy);
          r4.z = 1;
          r1.x = dot(r4.xyz, r6.xyz);
        } else {
          r1.w = cmp(r1.y < 15.5260687);
          if (r1.w != 0) {
            r1.y = r1.y * 0.30103001 + 0.744727492;
            r1.w = 0.553654671 * r1.y;
            r2.x = (int)r1.w;
            r1.w = trunc(r1.w);
            r4.y = r1.y * 0.553654671 + -r1.w;
            r1.yw = (int2)r2.xx + int2(1, 2);
            r4.x = r4.y * r4.y;
            r5.x = icb[r2.x + 0].y;
            r5.y = icb[r1.y + 0].y;
            r5.z = icb[r1.w + 0].y;
            r6.x = dot(float3(0.5, -1, 0.5), r5.xyz);
            r6.y = dot(float2(-1, 1), r5.xy);
            r6.z = dot(float2(0.5, 0.5), r5.xy);
            r4.z = 1;
            r1.x = dot(r4.xyz, r6.xyz);
          } else {
            r1.x = 4;
          }
        }
      }
      r1.x = 3.32192802 * r1.x;
      r3.y = exp2(r1.x);
      if (r2.z != 0) {
        r1.x = -4;
      } else {
        r1.y = cmp(r1.z < -2.47393107);
        if (r1.y != 0) {
          r1.y = r1.z * 0.30103001 + 5.26017761;
          r1.w = 0.664385557 * r1.y;
          r2.x = (int)r1.w;
          r1.w = trunc(r1.w);
          r4.y = r1.y * 0.664385557 + -r1.w;
          r1.yw = (int2)r2.xx + int2(1, 2);
          r4.x = r4.y * r4.y;
          r2.x = icb[r2.x + 0].x;
          r2.y = icb[r1.y + 0].x;
          r2.z = icb[r1.w + 0].x;
          r5.x = dot(float3(0.5, -1, 0.5), r2.xyz);
          r5.y = dot(float2(-1, 1), r2.xy);
          r5.z = dot(float2(0.5, 0.5), r2.xy);
          r4.z = 1;
          r1.x = dot(r4.xyz, r5.xyz);
        } else {
          r1.y = cmp(r1.z < 15.5260687);
          if (r1.y != 0) {
            r1.y = r1.z * 0.30103001 + 0.744727492;
            r1.z = 0.553654671 * r1.y;
            r1.w = (int)r1.z;
            r1.z = trunc(r1.z);
            r2.y = r1.y * 0.553654671 + -r1.z;
            r1.yz = (int2)r1.ww + int2(1, 2);
            r2.x = r2.y * r2.y;
            r4.x = icb[r1.w + 0].y;
            r4.y = icb[r1.y + 0].y;
            r4.z = icb[r1.z + 0].y;
            r5.x = dot(float3(0.5, -1, 0.5), r4.xyz);
            r5.y = dot(float2(-1, 1), r4.xy);
            r5.z = dot(float2(0.5, 0.5), r4.xy);
            r2.z = 1;
            r1.x = dot(r2.xyz, r5.xyz);
          } else {
            r1.x = 4;
          }
        }
      }
      r1.x = 3.32192802 * r1.x;
      r3.z = exp2(r1.x);
      // AP1_2_AP0_MAT
      r1.x = dot(float3(0.695452213, 0.140678704, 0.163869068), r3.xyz);
      r1.y = dot(float3(0.0447945632, 0.859671116, 0.0955343172), r3.xyz);
      r1.z = dot(float3(-0.00552588282, 0.00402521016, 1.00150073), r3.xyz);
      // AP0_2_AP1_MAT
      r1.w = dot(float3(1.45143926, -0.236510754, -0.214928567), r1.xyz);
      r2.x = dot(float3(-0.0765537769, 1.17622972, -0.0996759236), r1.xyz);
      r1.x = dot(float3(0.00831614807, -0.00603244966, 0.997716308), r1.xyz);
      r1.y = cmp(0 >= r1.w);
      r1.z = log2(r1.w);
      r1.y = r1.y ? -13.2877121 : r1.z;
      r1.z = cmp(-8.43976784 >= r1.y);
      if (r1.z != 0) {
        r1.z = -1.69896996;
      } else {
        r1.w = cmp(-8.43976784 < r1.y);
        r2.y = cmp(r1.y < 2.26303458);
        r1.w = r1.w ? r2.y : 0;
        if (r1.w != 0) {
          r1.w = r1.y * 0.30103001 + 2.54062319;
          r2.y = 2.17265511 * r1.w;
          r2.z = (int)r2.y;
          r2.y = trunc(r2.y);
          r3.y = r1.w * 2.17265511 + -r2.y;
          r2.yw = (int2)r2.zz + int2(1, 2);
          r3.x = r3.y * r3.y;
          r4.x = icb[r2.z + 0].z;
          r4.y = icb[r2.y + 0].z;
          r4.z = icb[r2.w + 0].z;
          r5.x = dot(float3(0.5, -1, 0.5), r4.xyz);
          r5.y = dot(float2(-1, 1), r4.xy);
          r5.z = dot(float2(0.5, 0.5), r4.xy);
          r3.z = 1;
          r1.z = dot(r3.xyz, r5.xyz);
        } else {
          r1.w = cmp(r1.y >= 2.26303458);
          r2.y = cmp(r1.y < 9.97401142);
          r1.w = r1.w ? r2.y : 0;
          if (r1.w != 0) {
            r1.w = r1.y * 0.30103001 + -0.681241274;
            r2.y = 3.01563549 * r1.w;
            r2.z = (int)r2.y;
            r2.y = trunc(r2.y);
            r3.y = r1.w * 3.01563549 + -r2.y;
            r2.yw = (int2)r2.zz + int2(1, 2);
            r3.x = r3.y * r3.y;
            r4.x = icb[r2.z + 0].w;
            r4.y = icb[r2.y + 0].w;
            r4.z = icb[r2.w + 0].w;
            r5.x = dot(float3(0.5, -1, 0.5), r4.xyz);
            r5.y = dot(float2(-1, 1), r4.xy);
            r5.z = dot(float2(0.5, 0.5), r4.xy);
            r3.z = 1;
            r1.z = dot(r3.xyz, r5.xyz);
          } else {
            r1.z = r1.y * 0.0120412 + 1.56114209;
          }
        }
      }
      r1.y = 3.32192802 * r1.z;
      r3.x = exp2(r1.y);
      r1.y = cmp(0 >= r2.x);
      r1.z = log2(r2.x);
      r1.y = r1.y ? -13.2877121 : r1.z;
      r1.z = cmp(-8.43976784 >= r1.y);
      if (r1.z != 0) {
        r1.z = -1.69896996;
      } else {
        r1.w = cmp(-8.43976784 < r1.y);
        r2.x = cmp(r1.y < 2.26303458);
        r1.w = r1.w ? r2.x : 0;
        if (r1.w != 0) {
          r1.w = r1.y * 0.30103001 + 2.54062319;
          r2.x = 2.17265511 * r1.w;
          r2.y = (int)r2.x;
          r2.x = trunc(r2.x);
          r4.y = r1.w * 2.17265511 + -r2.x;
          r2.xz = (int2)r2.yy + int2(1, 2);
          r4.x = r4.y * r4.y;
          r5.x = icb[r2.y + 0].z;
          r5.y = icb[r2.x + 0].z;
          r5.z = icb[r2.z + 0].z;
          r2.x = dot(float3(0.5, -1, 0.5), r5.xyz);
          r2.y = dot(float2(-1, 1), r5.xy);
          r2.z = dot(float2(0.5, 0.5), r5.xy);
          r4.z = 1;
          r1.z = dot(r4.xyz, r2.xyz);
        } else {
          r1.w = cmp(r1.y >= 2.26303458);
          r2.x = cmp(r1.y < 9.97401142);
          r1.w = r1.w ? r2.x : 0;
          if (r1.w != 0) {
            r1.w = r1.y * 0.30103001 + -0.681241274;
            r2.x = 3.01563549 * r1.w;
            r2.y = (int)r2.x;
            r2.x = trunc(r2.x);
            r4.y = r1.w * 3.01563549 + -r2.x;
            r2.xz = (int2)r2.yy + int2(1, 2);
            r4.x = r4.y * r4.y;
            r5.x = icb[r2.y + 0].w;
            r5.y = icb[r2.x + 0].w;
            r5.z = icb[r2.z + 0].w;
            r2.x = dot(float3(0.5, -1, 0.5), r5.xyz);
            r2.y = dot(float2(-1, 1), r5.xy);
            r2.z = dot(float2(0.5, 0.5), r5.xy);
            r4.z = 1;
            r1.z = dot(r4.xyz, r2.xyz);
          } else {
            r1.z = r1.y * 0.0120412 + 1.56114209;
          }
        }
      }
      r1.y = 3.32192802 * r1.z;
      r3.y = exp2(r1.y);
      r1.y = cmp(0 >= r1.x);
      r1.x = log2(r1.x);
      r1.x = r1.y ? -13.2877121 : r1.x;
      r1.y = cmp(-8.43976784 >= r1.x);
      if (r1.y != 0) {
        r1.y = -1.69896996;
      } else {
        r1.z = cmp(-8.43976784 < r1.x);
        r1.w = cmp(r1.x < 2.26303458);
        r1.z = r1.w ? r1.z : 0;
        if (r1.z != 0) {
          r1.z = r1.x * 0.30103001 + 2.54062319;
          r1.w = 2.17265511 * r1.z;
          r2.x = (int)r1.w;
          r1.w = trunc(r1.w);
          r4.y = r1.z * 2.17265511 + -r1.w;
          r1.zw = (int2)r2.xx + int2(1, 2);
          r4.x = r4.y * r4.y;
          r2.x = icb[r2.x + 0].z;
          r2.y = icb[r1.z + 0].z;
          r2.z = icb[r1.w + 0].z;
          r5.x = dot(float3(0.5, -1, 0.5), r2.xyz);
          r5.y = dot(float2(-1, 1), r2.xy);
          r5.z = dot(float2(0.5, 0.5), r2.xy);
          r4.z = 1;
          r1.y = dot(r4.xyz, r5.xyz);
        } else {
          r1.z = cmp(r1.x >= 2.26303458);
          r1.w = cmp(r1.x < 9.97401142);
          r1.z = r1.w ? r1.z : 0;
          if (r1.z != 0) {
            r1.z = r1.x * 0.30103001 + -0.681241274;
            r1.w = 3.01563549 * r1.z;
            r2.x = (int)r1.w;
            r1.w = trunc(r1.w);
            r4.y = r1.z * 3.01563549 + -r1.w;
            r1.zw = (int2)r2.xx + int2(1, 2);
            r4.x = r4.y * r4.y;
            r2.x = icb[r2.x + 0].w;
            r2.y = icb[r1.z + 0].w;
            r2.z = icb[r1.w + 0].w;
            r5.x = dot(float3(0.5, -1, 0.5), r2.xyz);
            r5.y = dot(float2(-1, 1), r2.xy);
            r5.z = dot(float2(0.5, 0.5), r2.xy);
            r4.z = 1;
            r1.y = dot(r4.xyz, r5.xyz);
          } else {
            r1.y = r1.x * 0.0120412 + 1.56114209;
          }
        }
      }
      r1.x = 3.32192802 * r1.y;
      r3.z = exp2(r1.x);
      r1.xyz = float3(-0.0199999996, -0.0199999996, -0.0199999996) + r3.xyz;
      r1.xyz = float3(0.0208420176, 0.0208420176, 0.0208420176) * r1.xyz;
      // AP1_2_XYZ_MAT
      r2.x = dot(float3(0.662454188, 0.134004205, 0.156187683), r1.xyz);
      r2.y = dot(float3(0.272228718, 0.674081743, 0.0536895171), r1.xyz);
      r2.z = dot(float3(-0.00557464967, 0.0040607336, 1.01033914), r1.xyz);
      r1.x = dot(r2.xyz, float3(1, 1, 1));
      r1.x = max(9.99999975e-05, r1.x);
      r1.xy = r2.xy / r1.xx;
      r1.w = max(0, r2.y);
      r1.w = min(65504, r1.w);
      r1.w = log2(r1.w);
      r1.w = 0.981100023 * r1.w;
      r2.y = exp2(r1.w);
      r1.w = max(9.99999975e-05, r1.y);
      r1.w = r2.y / r1.w;
      r2.w = 1 + -r1.x;
      r1.z = r2.w + -r1.y;
      r2.xz = r1.xz * r1.ww;
      // XYZ_2_AP1_MAT
      r1.x = dot(float3(1.6410234, -0.324803293, -0.236424699), r2.xyz);
      r1.y = dot(float3(-0.663662851, 1.61533165, 0.0167563483), r2.xyz);
      r1.z = dot(float3(0.0117218941, -0.00828444213, 0.988394856), r2.xyz);
      r1.w = dot(r1.xyz, float3(0.272228986, 0.674081981, 0.0536894985));
      r1.xyz = r1.xyz + -r1.www;
      r1.xyz = r1.xyz * float3(0.930000007, 0.930000007, 0.930000007) + r1.www;
      // AP1_2_XYZ_MAT
      r2.x = dot(float3(0.662454188, 0.134004205, 0.156187683), r1.xyz);
      r2.y = dot(float3(0.272228718, 0.674081743, 0.0536895171), r1.xyz);
      r2.z = dot(float3(-0.00557464967, 0.0040607336, 1.01033914), r1.xyz);
      // D60_2_D65_CAT
      r1.x = dot(float3(0.987223983, -0.00611326983, 0.0159533005), r2.xyz);
      r1.y = dot(float3(-0.00759836007, 1.00186002, 0.00533019984), r2.xyz);
      r1.z = dot(float3(0.00307257008, -0.00509594986, 1.08168006), r2.xyz);
      // XYZ_2_BT709_MAT
      r2.x = saturate(dot(float3(3.2409699, -1.5373832, -0.498610765), r1.xyz));
      r2.y = saturate(dot(float3(-0.969243646, 1.8759675, 0.0415550582), r1.xyz));
      r2.z = saturate(dot(float3(0.0556300804, -0.203976959, 1.05697155), r1.xyz));
    } else {
      r1.x = cmp((int)r0.w == 1);
      if (r1.x != 0) {
        // AP1_TO_BT709_MAT
        r1.x = dot(float3(1.70504999, -0.621789992, -0.0832599998), r0.xyz);
        r1.y = dot(float3(-0.130260006, 1.1408, -0.0105499998), r0.xyz);
        r1.z = dot(float3(-0.0240000002, -0.128969997, 1.15296996), r0.xyz);
        r1.xyz = float3(0.707106769, 0.707106769, 0.707106769) * r1.xyz;
        // AP1_2_AP0_MAT
        r3.y = dot(float3(0.695452213, 0.140678704, 0.163869068), r1.xyz);
        r3.z = dot(float3(0.0447945632, 0.859671116, 0.0955343172), r1.xyz);
        r3.w = dot(float3(-0.00552588236, 0.00402521016, 1.00150073), r1.xyz);
        r1.x = min(r3.y, r3.z);
        r1.x = min(r1.x, r3.w);
        r1.y = max(r3.y, r3.z);
        r1.y = max(r1.y, r3.w);
        r1.xyz = max(float3(9.99999975e-05, 9.99999975e-05, 0.00999999978), r1.xyy);
        r1.x = r1.y + -r1.x;
        r1.x = r1.x / r1.z;
        r1.yzw = r3.wzy + -r3.zyw;
        r1.yz = r3.wz * r1.yz;
        r1.y = r1.y + r1.z;
        r1.y = r3.y * r1.w + r1.y;
        r1.y = max(0, r1.y);
        r1.y = sqrt(r1.y);
        r1.z = r3.w + r3.z;
        r1.z = r1.z + r3.y;
        r1.y = r1.y * 1.75 + r1.z;
        r1.w = -0.400000006 + r1.x;
        r3.x = 2.5 * r1.w;
        r3.x = 1 + -abs(r3.x);
        r3.x = max(0, r3.x);
        r1.w = cmp(r1.w >= 0);
        r1.w = r1.w ? 1 : -1;
        r3.x = -r3.x * r3.x + 1;
        r1.w = r1.w * r3.x + 1;
        r1.zw = float2(0.333333343, 0.0250000004) * r1.yw;
        r3.x = cmp(0.159999996 >= r1.y);
        r1.y = cmp(r1.y >= 0.479999989);
        r1.z = 0.0799999982 / r1.z;
        r1.z = -0.5 + r1.z;
        r1.z = r1.w * r1.z;
        r1.y = r1.y ? 0 : r1.z;
        r1.y = r3.x ? r1.w : r1.y;
        r1.y = 1 + r1.y;
        r4.yzw = r3.yzw * r1.yyy;
        r1.zw = cmp(r4.zw == r4.yz);
        r1.z = r1.w ? r1.z : 0;
        r1.w = r3.z * r1.y + -r4.w;
        r1.w = 1.73205078 * r1.w;
        r3.x = r4.y * 2 + -r4.z;
        r3.x = -r3.w * r1.y + r3.x;
        r3.z = min(abs(r3.x), abs(r1.w));
        r3.w = max(abs(r3.x), abs(r1.w));
        r3.w = 1 / r3.w;
        r3.z = r3.z * r3.w;
        r3.w = r3.z * r3.z;
        r5.x = r3.w * 0.0208350997 + -0.0851330012;
        r5.x = r3.w * r5.x + 0.180141002;
        r5.x = r3.w * r5.x + -0.330299497;
        r3.w = r3.w * r5.x + 0.999866009;
        r5.x = r3.z * r3.w;
        r5.y = cmp(abs(r3.x) < abs(r1.w));
        r5.x = r5.x * -2 + 1.57079637;
        r5.x = r5.y ? r5.x : 0;
        r3.z = r3.z * r3.w + r5.x;
        r3.w = cmp(r3.x < -r3.x);
        r3.w = r3.w ? -3.141593 : 0;
        r3.z = r3.z + r3.w;
        r3.w = min(r3.x, r1.w);
        r1.w = max(r3.x, r1.w);
        r3.x = cmp(r3.w < -r3.w);
        r1.w = cmp(r1.w >= -r1.w);
        r1.w = r1.w ? r3.x : 0;
        r1.w = r1.w ? -r3.z : r3.z;
        r1.w = 57.2957802 * r1.w;
        r1.z = r1.z ? 0 : r1.w;
        r1.w = cmp(r1.z < 0);
        r3.x = 360 + r1.z;
        r1.z = r1.w ? r3.x : r1.z;
        r1.w = cmp(r1.z < -180);
        r3.x = cmp(180 < r1.z);
        r3.zw = float2(360, -360) + r1.zz;
        r1.z = r3.x ? r3.w : r1.z;
        r1.z = r1.w ? r3.z : r1.z;
        r1.z = 0.0148148146 * r1.z;
        r1.z = 1 + -abs(r1.z);
        r1.z = max(0, r1.z);
        r1.w = r1.z * -2 + 3;
        r1.z = r1.z * r1.z;
        r1.z = r1.w * r1.z;
        r1.z = r1.z * r1.z;
        r1.x = r1.z * r1.x;
        r1.y = -r3.y * r1.y + 0.0299999993;
        r1.x = r1.x * r1.y;
        r4.x = r1.x * 0.180000007 + r4.y;
        //  AP0_2_AP1_MAT
        r1.x = dot(float3(1.45143926, -0.236510754, -0.214928567), r4.xzw);
        r1.y = dot(float3(-0.0765537769, 1.17622972, -0.0996759236), r4.xzw);
        r1.z = dot(float3(0.00831614807, -0.00603244966, 0.997716308), r4.xzw);
        r1.w = dot(r1.xyz, float3(0.272228986, 0.674081981, 0.0536894985));
        r1.xyz = r1.xyz + -r1.www;
        r1.xyz = r1.xyz * float3(0.959999979, 0.959999979, 0.959999979) + r1.www;
        r3.xyz = float3(1, 1, 0.180000007) + cb0[1].xyx;
        r3.xw = -cb0[0].zw + r3.xy;
        r1.w = cmp(0.800000012 < cb0[0].z);
        r4.xy = float2(0.819999993, 1) + -cb0[0].zz;
        r4.xy = r4.xy / cb0[0].yy;
        r4.x = -0.744727492 + r4.x;
        r3.z = r3.z / r3.x;
        r4.z = -1 + r3.z;
        r4.z = 1 + -r4.z;
        r3.z = r3.z / r4.z;
        r3.z = log2(r3.z);
        r3.z = 0.346573591 * r3.z;
        r4.z = r3.x / cb0[0].y;
        r3.z = -r3.z * r4.z + -0.744727492;
        r1.w = r1.w ? r4.x : r3.z;
        r3.z = r4.y + -r1.w;
        r4.x = cb0[0].w / cb0[0].y;
        r4.x = r4.x + -r3.z;
        r1.xyz = log2(r1.xyz);
        r4.yzw = float3(0.30103001, 0.30103001, 0.30103001) * r1.xyz;
        r5.xyz = r1.xyz * float3(0.30103001, 0.30103001, 0.30103001) + r3.zzz;
        r5.xyz = cb0[0].yyy * r5.xyz;
        r6.xy = r3.xw + r3.xw;
        r3.z = -2 * cb0[0].y;
        r3.x = r3.z / r3.x;
        r7.xyz = r1.xyz * float3(0.30103001, 0.30103001, 0.30103001) + -r1.www;
        r8.xyz = r7.xyz * r3.xxx;
        r8.xyz = float3(1.44269502, 1.44269502, 1.44269502) * r8.xyz;
        r8.xyz = exp2(r8.xyz);
        r8.xyz = float3(1, 1, 1) + r8.xyz;
        r6.xzw = r6.xxx / r8.xyz;
        r6.xzw = -cb0[1].xxx + r6.xzw;
        r3.x = cb0[0].y + cb0[0].y;
        r3.x = r3.x / r3.w;
        r1.xyz = r1.xyz * float3(0.30103001, 0.30103001, 0.30103001) + -r4.xxx;
        r1.xyz = r3.xxx * r1.xyz;
        r1.xyz = float3(1.44269502, 1.44269502, 1.44269502) * r1.xyz;
        r1.xyz = exp2(r1.xyz);
        r1.xyz = float3(1, 1, 1) + r1.xyz;
        r1.xyz = r6.yyy / r1.xyz;
        r1.xyz = r3.yyy + -r1.xyz;
        r3.xyz = cmp(r4.yzw < r1.www);
        r3.xyz = r3.xyz ? r6.xzw : r5.xyz;
        r4.yzw = cmp(r4.xxx < r4.yzw);
        r1.xyz = r4.yzw ? r1.xyz : r5.xyz;
        r3.w = r4.x + -r1.w;
        r4.yzw = saturate(r7.xyz / r3.www);
        r1.w = cmp(r4.x < r1.w);
        r5.xyz = float3(1, 1, 1) + -r4.yzw;
        r4.xyz = r1.www ? r5.xyz : r4.yzw;
        r5.xyz = -r4.xyz * float3(2, 2, 2) + float3(3, 3, 3);
        r4.xyz = r4.xyz * r4.xyz;
        r4.xyz = r4.xyz * r5.xyz;
        r1.xyz = r1.xyz + -r3.xyz;
        r1.xyz = r4.xyz * r1.xyz + r3.xyz;
        r1.w = dot(r1.xyz, float3(0.272228986, 0.674081981, 0.0536894985));
        r1.xyz = r1.xyz + -r1.www;
        r1.xyz = r1.xyz * float3(0.930000007, 0.930000007, 0.930000007) + r1.www;
        r2.xyz = max(float3(0, 0, 0), r1.xyz);
      } else {
        r0.w = cmp((int)r0.w == 2);
        if (r0.w != 0) {
          // AP1_2_XYZ_MAT
          r1.x = dot(float3(0.662454188, 0.134004205, 0.156187683), r0.xyz);
          r1.y = dot(float3(0.272228718, 0.674081743, 0.0536895171), r0.xyz);
          r1.z = dot(float3(-0.00557464967, 0.0040607336, 1.01033914), r0.xyz);
          // D60_2_D65_CAT
          r0.x = dot(float3(0.987223983, -0.00611326983, 0.0159533005), r1.xyz);
          r0.y = dot(float3(-0.00759836007, 1.00186002, 0.00533019984), r1.xyz);
          r0.z = dot(float3(0.00307257008, -0.00509594986, 1.08168006), r1.xyz);
          r1.xyz = float3(0.850000024, 0.850000024, 0.850000024) * r0.xyz;
          r1.xyz = log2(abs(r1.xyz));
          r1.xyz = float3(0.454545468, 0.454545468, 0.454545468) * r1.xyz;
          r1.xyz = exp2(r1.xyz);
          r1.xyz = min(float3(1, 1, 1), r1.xyz);
          r0.w = dot(r1.xyz, float3(0.212672904, 0.715152204, 0.0721750036));
          r0.w = min(1, r0.w);
          r0.w = r0.w + r0.w;
          r0.w = min(1, r0.w);
          r1.x = r0.w * -2 + 3;
          r0.w = r0.w * r0.w;
          r0.w = r1.x * r0.w;
          r0.xyz = float3(0.425000012, 0.425000012, 0.425000012) * r0.xyz;
          r0.xyz = r0.www * r0.xyz + r0.xyz;
          r0.xyz = log2(abs(r0.xyz));
          r0.xyz = float3(1.09119999, 1.09119999, 1.09119999) * r0.xyz;
          r0.xyz = exp2(r0.xyz);
          // aces stuff
          r1.x = dot(float3(1.52505279, -0.315913498, -0.122658268), r0.xyz);
          r1.y = dot(float3(-0.509152532, 1.33332741, 0.13828437), r0.xyz);
          r1.z = dot(float3(0.095715344, 0.0508974455, 0.787955761), r0.xyz);
          r0.xyz = max(float3(5.96046448e-08, 5.96046448e-08, 5.96046448e-08), r1.xyz);
          r0.xyz = log2(r0.xyz);
          r0.xyz = float3(12.4739304, 12.4739304, 12.4739304) + r0.xyz;
          r0.xyz = saturate(float3(0.0399999991, 0.0399999991, 0.0399999991) * r0.xyz);
          r0.xyz = t0.SampleLevel(s0_s, r0.xyz, 0).xyz;
          r0.xyz = log2(abs(r0.xyz));
          r0.xyz = float3(2.4000001, 2.4000001, 2.4000001) * r0.xyz;
          r2.xyz = exp2(r0.xyz);
        } else {
          r2.xyz = float3(1, 0, 0);
        }
      }
    }
  } else {
    r2.rgb = r0.rgb;
  }
  r2.xyz = applyUserTonemapACES(r2.xyz, 3);
  r2.w = 1;
  u0[vThreadID] = r2;
  return;
}
