#include "../common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[3];
}
cbuffer cb0 : register(b0){
  float4 cb0[129];
}

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : INTERP0,
  float4 v2 : INTERP1,
  out float4 o0 : SV_TARGET0)
{
  const float4 icb[] = { { 0, 0, 0, 0},
                              { 32, 0, 0, 0},
                              { 8, 0, 0, 0},
                              { 40, 0, 0, 0},
                              { 2, 0, 0, 0},
                              { 34, 0, 0, 0},
                              { 10, 0, 0, 0},
                              { 42, 0, 0, 0},
                              { 48, 0, 0, 0},
                              { 16, 0, 0, 0},
                              { 56, 0, 0, 0},
                              { 24, 0, 0, 0},
                              { 50, 0, 0, 0},
                              { 18, 0, 0, 0},
                              { 58, 0, 0, 0},
                              { 26, 0, 0, 0},
                              { 12, 0, 0, 0},
                              { 44, 0, 0, 0},
                              { 4, 0, 0, 0},
                              { 36, 0, 0, 0},
                              { 14, 0, 0, 0},
                              { 46, 0, 0, 0},
                              { 6, 0, 0, 0},
                              { 38, 0, 0, 0},
                              { 60, 0, 0, 0},
                              { 28, 0, 0, 0},
                              { 52, 0, 0, 0},
                              { 20, 0, 0, 0},
                              { 62, 0, 0, 0},
                              { 30, 0, 0, 0},
                              { 54, 0, 0, 0},
                              { 22, 0, 0, 0},
                              { 3, 0, 0, 0},
                              { 35, 0, 0, 0},
                              { 11, 0, 0, 0},
                              { 43, 0, 0, 0},
                              { 1, 0, 0, 0},
                              { 33, 0, 0, 0},
                              { 9, 0, 0, 0},
                              { 41, 0, 0, 0},
                              { 51, 0, 0, 0},
                              { 19, 0, 0, 0},
                              { 59, 0, 0, 0},
                              { 27, 0, 0, 0},
                              { 49, 0, 0, 0},
                              { 17, 0, 0, 0},
                              { 57, 0, 0, 0},
                              { 25, 0, 0, 0},
                              { 15, 0, 0, 0},
                              { 47, 0, 0, 0},
                              { 7, 0, 0, 0},
                              { 39, 0, 0, 0},
                              { 13, 0, 0, 0},
                              { 45, 0, 0, 0},
                              { 5, 0, 0, 0},
                              { 37, 0, 0, 0},
                              { 63, 0, 0, 0},
                              { 31, 0, 0, 0},
                              { 55, 0, 0, 0},
                              { 23, 0, 0, 0},
                              { 61, 0, 0, 0},
                              { 29, 0, 0, 0},
                              { 53, 0, 0, 0},
                              { 21, 0, 0, 0} };
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb1[0].zw * v1.xy;
  r0.xy = floor(r0.xy);
  r1.xyzw = float4(8,8,8,8) * r0.xxyy;
  r1.xyzw = r1.xyzw >= -r1.yyww ? float4(8,0.125,8,0.125) : float4(-8,-0.125,-8,-0.125);
  r0.xy = r1.yw * r0.xy;
  r0.xy = frac(r0.xy);
  r0.xy = r1.xz * r0.xy;
  r0.x = r0.y * 8 + r0.x;
  r0.x = (uint)r0.x;
  r0.x = (int)icb[r0.x+0].x;
  r0.x = r0.x * 0.015625 + -0.5;
  r1.xyzw = t0.SampleBias(s0_s, v1.xy, cb0[5].x).xyzw;
  r0.yzw = sign(r1.xyz) * pow(abs(r1.xyz), cb1[2].z);
  r1.w = -1 + cb1[2].y;
  r2.xyz = r1.www * r0.yzw;
  r3.xyz = ceil(r2.xyz);
  r2.xyz = floor(r2.xyz);
  r2.xyz = r2.xyz + -r3.xyz;
  r0.yzw = r0.yzw * r1.www + -r3.xyz;
  r0.yzw = r0.yzw / r2.xyz;
  r0.xyz = r0.xxx * cb1[2].xxx + r0.yzw;
  if (injectedData.toneMapType == 0) {
    r0.xyz = saturate(r0.xyz);
  }
  r0.xyz = round(r0.xyz);
  r0.xyz = r0.xyz * r2.xyz + r3.xyz;
  r0.xyz = r0.xyz / r1.www;
  /*r0.xyz = log2(r0.xyz);
  r0.w = 1 / cb1[2].z;
  r0.xyz = r0.www * r0.xyz;
  r0.xyz = exp2(r0.xyz);*/
  r0.xyz = sign(r0.xyz) * pow(abs(r0.xyz), 1 / cb1[2].z);
  r0.xyz = cb0[128].zzz ? r1.xyz : r0.xyz;
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  r1.xyzw = t1.SampleBias(s1_s, v1.xy, cb0[5].x).xyzw;
  r0.xyz = r1.w > 0 ? max(0.f, r0.xyz) : r0.xyz;
  r1.xyz = r1.xyz + -r0.xyz;
  r0.w = cb0[128].y ? 0 : r1.w;
  o0.xyz = r0.www * r1.xyz + r0.xyz;
  o0.w = 1;
  return;
}