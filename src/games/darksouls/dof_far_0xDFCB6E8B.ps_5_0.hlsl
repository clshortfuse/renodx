#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Tue Jun 04 23:18:33 2024

cbuffer _Globals : register(b0) {
  float4 DL_FREG_007 : packoffset(c7);
  float4 DL_FREG_008 : packoffset(c8);
  float4 DL_FREG_009 : packoffset(c9);
  float4 DL_FREG_010 : packoffset(c10);
  float4 DL_FREG_011 : packoffset(c11);
  float4 DL_FREG_012 : packoffset(c12);
  float4 DL_FREG_013 : packoffset(c13);
  float4 DL_FREG_014 : packoffset(c14);
  float4 DL_FREG_015 : packoffset(c15);
  float4 DL_FREG_016 : packoffset(c16);
  float4 DL_FREG_017 : packoffset(c17);
  float4 DL_FREG_018 : packoffset(c18);
  float4 DL_FREG_019 : packoffset(c19);
  float4 DL_FREG_020 : packoffset(c20);
  float4 DL_FREG_021 : packoffset(c21);
  float4 DL_FREG_022 : packoffset(c22);
  float4 DL_FREG_023 : packoffset(c23);
  float4 DL_FREG_024 : packoffset(c24);
  float4 DL_FREG_025 : packoffset(c25);
  float4 DL_FREG_026 : packoffset(c26);
  float4 DL_FREG_027 : packoffset(c27);
  float4 DL_FREG_028 : packoffset(c28);
  float4 DL_FREG_029 : packoffset(c29);
  float4 DL_FREG_030 : packoffset(c30);
  float4 DL_FREG_031 : packoffset(c31);
  float4 DL_FREG_032 : packoffset(c32);
  float4 DL_FREG_033 : packoffset(c33);
  float4 DL_FREG_034 : packoffset(c34);
  float4 DL_FREG_035 : packoffset(c35);
  float4 DL_FREG_036 : packoffset(c36);
  float4 DL_FREG_037 : packoffset(c37);
  float4 DL_FREG_038 : packoffset(c38);
  float4 DL_FREG_039 : packoffset(c39);
  float4 DL_FREG_040 : packoffset(c40);
  float4 DL_FREG_041 : packoffset(c41);
  float4 DL_FREG_042 : packoffset(c42);
  float4 DL_FREG_043 : packoffset(c43);
  float4 DL_FREG_044 : packoffset(c44);
  float4 DL_FREG_045 : packoffset(c45);
  float4 DL_FREG_046 : packoffset(c46);
  float4 DL_FREG_047 : packoffset(c47);
  float4 DL_FREG_048 : packoffset(c48);
  float4 DL_FREG_049 : packoffset(c49);
  float4 DL_FREG_050 : packoffset(c50);
  float4 DL_FREG_051 : packoffset(c51);
  float4 DL_FREG_052 : packoffset(c52);
  float4 DL_FREG_053 : packoffset(c53);
  float4 DL_FREG_054 : packoffset(c54);
  float4 DL_FREG_055 : packoffset(c55);
  float4 DL_FREG_056 : packoffset(c56);
  float4 DL_FREG_057 : packoffset(c57);
  float4x4 DL_FREG_058 : packoffset(c58);
  float4x4 DL_FREG_062 : packoffset(c62);
  float4 DL_FREG_066 : packoffset(c66);
  float4 DL_FREG_067 : packoffset(c67);
  float4 DL_FREG_068 : packoffset(c68);
  float4 DL_FREG_069 : packoffset(c69);
  float4 DL_FREG_070 : packoffset(c70);
  float4 DL_FREG_071 : packoffset(c71);
  float4 DL_FREG_072 : packoffset(c72);
  float4 DL_FREG_073 : packoffset(c73);
  float4x4 DL_FREG_074 : packoffset(c74);
  float4 DL_FREG_078 : packoffset(c78);
  uint4 gFC_FrameIndex : packoffset(c81);
  float4x4 gVC_WorldViewClipMtx : packoffset(c82);
  float4 gVC_ScreenSize : packoffset(c86);
  float4 gVC_NoiseParam : packoffset(c87);
}

SamplerState gSMP_0Sampler_s : register(s0);
SamplerState gSMP_1Sampler_s : register(s1);
SamplerState gSMP_2Sampler_s : register(s2);
SamplerState gSMP_3Sampler_s : register(s3);
SamplerState gSMP_4Sampler_s : register(s4);
SamplerState gSMP_5Sampler_s : register(s5);
Texture2D<float4> gSMP_0 : register(t0);
Texture2D<float4> gSMP_1 : register(t1);
Texture2D<float4> gSMP_2 : register(t2);
Texture2D<float4> gSMP_3 : register(t3);
Texture2D<float4> gSMP_4 : register(t4);
Texture2D<float4> gSMP_5 : register(t5);

// 3Dmigoto declarations
#define cmp -

void main(float4 v0
          : SV_Position0, float4 v1
          : TEXCOORD0, float4 v2
          : TEXCOORD1, out float4 o0
          : SV_Target0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = gSMP_5.Sample(gSMP_5Sampler_s, v1.xy).x;
  r0.y = DL_FREG_008.x + -DL_FREG_008.y;
  r0.x = r0.x * r0.y + DL_FREG_008.y;
  r0.x = DL_FREG_008.x / r0.x;
  r0.yz = DL_FREG_009.xy / DL_FREG_008.yy;
  r0.x = r0.x + -r0.y;
  r0.y = r0.z + -r0.y;

  // r0.x = saturate(r0.x / r0.y);
  // r0.x = saturate(DL_FREG_009.z * r0.x) * injectedData.fxDoF;

  // Increases DoF strength based on distance
  r0.x = clamp(r0.x / r0.y, 0, injectedData.fxDoF);
  r0.x = clamp(DL_FREG_009.z * r0.x, 0, injectedData.fxDoF);

  r0.yz = float2(-0.5, -0.5) + v1.xy;
  r0.yz = DL_FREG_012.xy * r0.yz;
  r0.y = dot(r0.yz, r0.yz);
  r0.y = sqrt(r0.y);
  r0.y = -DL_FREG_007.x + r0.y;
  r0.y = saturate(DL_FREG_007.y * r0.y);
  r0.x = r0.y * DL_FREG_007.z + r0.x;
  r0.y = gSMP_4.Sample(gSMP_4Sampler_s, v1.xy).w;
  r0.x = max(r0.x, r0.y);
  r0.xyzw = saturate(r0.xxxx * DL_FREG_066.xyzw + DL_FREG_067.xyzw);
  r0.yzw = r0.yzw + -r0.xyz;
  r1.xyzw = gSMP_1.Sample(gSMP_1Sampler_s, v1.xy).xyzw;
  r1.xyzw = r1.xyzw * r0.yyyy;
  r2.xyzw = gSMP_0.Sample(gSMP_0Sampler_s, v1.xy).xyzw;
  r1.xyzw = r2.xyzw * r0.xxxx + r1.xyzw;
  r2.xyzw = gSMP_2.Sample(gSMP_2Sampler_s, v1.xy).xyzw;
  r1.xyzw = r2.xyzw * r0.zzzz + r1.xyzw;
  r2.xyzw = gSMP_3.Sample(gSMP_3Sampler_s, v1.xy).xyzw;
  o0.xyzw = r2.xyzw * r0.wwww + r1.xyzw;
  return;
}