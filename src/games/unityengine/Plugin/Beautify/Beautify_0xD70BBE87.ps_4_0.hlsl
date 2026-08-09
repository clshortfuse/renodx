#include "../../common.hlsl"

Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[161];
}

#define cmp -

float3 vanillaSH(float3 color){
  // sRGB => XYZ => D65_2_D60 => AP1 => RRT_SAT
  const float3x3 ACESInputMat = {
    { 0.59719, 0.35458, 0.04823 },
    { 0.07600, 0.90834, 0.01566 },
    { 0.02840, 0.13383, 0.83777 }
  };
  // ODT_SAT => XYZ => D60_2_D65 => sRGB
  const float3x3 ACESOutputMat = {
    { 1.60475, -0.53108, -0.07367 },
    { -0.10208, 1.10813, -0.00605 },
    { -0.00327, -0.07276, 1.07602 }
  };
  color = cb0[143].xxx * color;
  color = mul(ACESInputMat, color);
  float3 a = color * (color + 0.0245786f) - 0.000090537f;
  float3 b = color * (0.983729f * color + 0.4329510f) + 0.238081f;
  color = a / b;
  color = mul(ACESOutputMat, color);
  color = cb0[143].yyy * color;
  return color;
}

float getNewPeak(float oldPeak){
  float Contrast = cb0[144].y;
  if(Contrast <= 1.f){return oldPeak;}
  else {
    return ((oldPeak - 0.5f) * Contrast + 0.5f);
  }
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  float2 v2 : TEXCOORD2,
  float2 w2 : TEXCOORD3,
  float2 v3 : TEXCOORD4,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy * float2(2,2) + float2(-1,-1);
  r0.z = dot(r0.xy, r0.xy);
  r0.zw = cb0[134].xy * r0.zz * injectedData.fxCA;
  r0.xy = r0.xy * r0.zz;
  r0.z = (int)r0.w;
  r0.z = (int)r0.z + 1;
  r0.z = max(3, (int)r0.z);
  r0.z = min(32, (int)r0.z);
  r0.w = (int)r0.z;
  r1.xyz = float3(0.5,1.5,2.5) / r0.www;
  r2.xyz = cb0[134].zzz + r1.xyz;
  r3.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
  r3.xyz = float3(0.166666672,0.166666672,0.166666672) * r3.xyz;
  r3.xyz = (r3.xyz >= -r3.xyz) ? frac(abs(r3.xyz)) : -frac(abs(r3.xyz));
  r3.xyz = r3.xyz * float3(6,6,6) + float3(-3,-3,-3);
  r3.xyz = saturate(float3(-1,-1,-1) + abs(r3.xyz));
  r4.xyzw = -r0.xyxy * r1.xxyy + v1.xyxy;
  r5.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
  r1.xyw = float3(9.99999975e-05,9.99999975e-05,9.99999975e-05) + r3.xyz;
  r2.xyw = r2.yyy * float3(6,6,6) + float3(0,4,2);
  r2.xyw = float3(0.166666672,0.166666672,0.166666672) * r2.xyw;
  r2.xyw = (r2.xyw >= -r2.xyw) ? frac(abs(r2.xyw)) : -frac(abs(r2.xyw));
  r2.xyw = r2.xyw * float3(6,6,6) + float3(-3,-3,-3);
  r2.xyw = saturate(float3(-1,-1,-1) + abs(r2.xyw));
  r4.xyzw = t0.SampleLevel(s0_s, r4.zw, 0).xyzw;
  r4.xyz = r4.xyz * r2.xyw;
  r3.xyz = r5.xyz * r3.xyz + r4.xyz;
  r1.xyw = r2.xyw + r1.xyw;
  r2.xyz = r2.zzz * float3(6,6,6) + float3(0,4,2);
  r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
  r2.xyz = (r2.xyz >= -r2.xyz) ? frac(abs(r2.xyz)) : -frac(abs(r2.xyz));
  r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
  r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
  r4.xy = -r0.xy * r1.zz + v1.xy;
  r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
  r3.xyz = r4.xyz * r2.xyz + r3.xyz;
  r1.xyz = r2.xyz + r1.xyw;
  if (int(r0.z) > 3) {
    r1.w = 3.5 / r0.w;
    r2.x = cb0[134].z + r1.w;
    r4.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r4.xyz = float3(0.166666672,0.166666672,0.166666672) * r4.xyz;
    r4.xyz = (r4.xyz >= -r4.xyz) ? frac(abs(r4.xyz)) : -frac(abs(r4.xyz));
    r4.xyz = r4.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r4.xyz = saturate(float3(-1,-1,-1) + abs(r4.xyz));
    r5.xy = -r0.xy * r1.ww + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r5.xy, 0).xyzw;
    r3.xyz = r5.xyz * r4.xyz + r3.xyz;
    r1.xyz = r4.xyz + r1.xyz;
  }
  if (int(r0.z) > 4) {
    r1.w = 4.5 / r0.w;
    r2.x = cb0[134].z + r1.w;
    r4.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r4.xyz = float3(0.166666672,0.166666672,0.166666672) * r4.xyz;
    r4.xyz = (r4.xyz >= -r4.xyz) ? frac(abs(r4.xyz)) : -frac(abs(r4.xyz));
    r4.xyz = r4.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r4.xyz = saturate(float3(-1,-1,-1) + abs(r4.xyz));
    r2.xy = -r0.xy * r1.ww + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r2.xy, 0).xyzw;
    r3.xyz = r5.xyz * r4.xyz + r3.xyz;
    r1.xyz = r4.xyz + r1.xyz;
  }
  if (int(r0.z) > 5) {
    r1.w = 5.5 / r0.w;
    r2.x = cb0[134].z + r1.w;
    r2.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r2.xyz = (r2.xyz >= -r2.xyz) ? frac(abs(r2.xyz)) : -frac(abs(r2.xyz));
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r4.xy = -r0.xy * r1.ww + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r3.xyz = r4.xyz * r2.xyz + r3.xyz;
    r1.xyz = r2.xyz + r1.xyz;
  }
  if (int(r0.z) > 6) {
    r1.w = 6.5 / r0.w;
    r2.x = cb0[134].z + r1.w;
    r2.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r2.xyz = (r2.xyz >= -r2.xyz) ? frac(abs(r2.xyz)) : -frac(abs(r2.xyz));
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r4.xy = -r0.xy * r1.ww + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r3.xyz = r4.xyz * r2.xyz + r3.xyz;
    r1.xyz = r2.xyz + r1.xyz;
  }
  if (int(r0.z) > 7) {
    r1.w = 7.5 / r0.w;
    r2.x = cb0[134].z + r1.w;
    r4.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r4.xyz = float3(0.166666672,0.166666672,0.166666672) * r4.xyz;
    r4.xyz = (r4.xyz >= -r4.xyz) ? frac(abs(r4.xyz)) : -frac(abs(r4.xyz));
    r4.xyz = r4.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r4.xyz = saturate(float3(-1,-1,-1) + abs(r4.xyz));
    r5.xy = -r0.xy * r1.ww + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r5.xy, 0).xyzw;
    r3.xyz = r5.xyz * r4.xyz + r3.xyz;
    r1.xyz = r4.xyz + r1.xyz;
  }
  if (int(r0.z) > 8) {
    r1.w = 8.5 / r0.w;
    r2.x = cb0[134].z + r1.w;
    r4.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r4.xyz = float3(0.166666672,0.166666672,0.166666672) * r4.xyz;
    r4.xyz = (r4.xyz >= -r4.xyz) ? frac(abs(r4.xyz)) : -frac(abs(r4.xyz));
    r4.xyz = r4.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r4.xyz = saturate(float3(-1,-1,-1) + abs(r4.xyz));
    r2.xy = -r0.xy * r1.ww + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r2.xy, 0).xyzw;
    r3.xyz = r5.xyz * r4.xyz + r3.xyz;
    r1.xyz = r4.xyz + r1.xyz;
  }
  if (int(r0.z) > 9) {
    r1.w = 9.5 / r0.w;
    r2.x = cb0[134].z + r1.w;
    r2.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r2.xyz = (r2.xyz >= -r2.xyz) ? frac(abs(r2.xyz)) : -frac(abs(r2.xyz));
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r4.xy = -r0.xy * r1.ww + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r3.xyz = r4.xyz * r2.xyz + r3.xyz;
    r1.xyz = r2.xyz + r1.xyz;
  }
  if (int(r0.z) > 10) {
    r1.w = 10.5 / r0.w;
    r2.x = cb0[134].z + r1.w;
    r2.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r2.xyz = (r2.xyz >= -r2.xyz) ? frac(abs(r2.xyz)) : -frac(abs(r2.xyz));
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r4.xy = -r0.xy * r1.ww + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r3.xyz = r4.xyz * r2.xyz + r3.xyz;
    r1.xyz = r2.xyz + r1.xyz;
  }
  if (int(r0.z) > 11) {
    r1.w = 11.5 / r0.w;
    r2.x = cb0[134].z + r1.w;
    r4.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r4.xyz = float3(0.166666672,0.166666672,0.166666672) * r4.xyz;
    r4.xyz = (r4.xyz >= -r4.xyz) ? frac(abs(r4.xyz)) : -frac(abs(r4.xyz));
    r4.xyz = r4.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r4.xyz = saturate(float3(-1,-1,-1) + abs(r4.xyz));
    r5.xy = -r0.xy * r1.ww + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r5.xy, 0).xyzw;
    r3.xyz = r5.xyz * r4.xyz + r3.xyz;
    r1.xyz = r4.xyz + r1.xyz;
  }
  if (int(r0.z) > 12) {
    r1.w = 12.5 / r0.w;
    r2.x = cb0[134].z + r1.w;
    r4.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r4.xyz = float3(0.166666672,0.166666672,0.166666672) * r4.xyz;
    r4.xyz = (r4.xyz >= -r4.xyz) ? frac(abs(r4.xyz)) : -frac(abs(r4.xyz));
    r4.xyz = r4.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r4.xyz = saturate(float3(-1,-1,-1) + abs(r4.xyz));
    r2.xy = -r0.xy * r1.ww + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r2.xy, 0).xyzw;
    r3.xyz = r5.xyz * r4.xyz + r3.xyz;
    r1.xyz = r4.xyz + r1.xyz;
  }
  if (int(r0.z) > 13) {
    r1.w = 13.5 / r0.w;
    r2.x = cb0[134].z + r1.w;
    r2.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r2.xyz = (r2.xyz >= -r2.xyz) ? frac(abs(r2.xyz)) : -frac(abs(r2.xyz));
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r4.xy = -r0.xy * r1.ww + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r3.xyz = r4.xyz * r2.xyz + r3.xyz;
    r1.xyz = r2.xyz + r1.xyz;
  }
  if (int(r0.z) > 14) {
    r1.w = 14.5 / r0.w;
    r2.x = cb0[134].z + r1.w;
    r2.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r2.xyz = (r2.xyz >= -r2.xyz) ? frac(abs(r2.xyz)) : -frac(abs(r2.xyz));
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r4.xy = -r0.xy * r1.ww + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r3.xyz = r4.xyz * r2.xyz + r3.xyz;
    r1.xyz = r2.xyz + r1.xyz;
  }
  if (int(r0.z) > 15) {
    r1.w = 15.5 / r0.w;
    r2.x = cb0[134].z + r1.w;
    r4.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r4.xyz = float3(0.166666672,0.166666672,0.166666672) * r4.xyz;
    r4.xyz = (r4.xyz >= -r4.xyz) ? frac(abs(r4.xyz)) : -frac(abs(r4.xyz));
    r4.xyz = r4.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r4.xyz = saturate(float3(-1,-1,-1) + abs(r4.xyz));
    r5.xy = -r0.xy * r1.ww + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r5.xy, 0).xyzw;
    r3.xyz = r5.xyz * r4.xyz + r3.xyz;
    r1.xyz = r4.xyz + r1.xyz;
  }
  if (int(r0.z) > 16) {
    r1.w = 16.5 / r0.w;
    r2.x = cb0[134].z + r1.w;
    r4.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r4.xyz = float3(0.166666672,0.166666672,0.166666672) * r4.xyz;
    r4.xyz = (r4.xyz >= -r4.xyz) ? frac(abs(r4.xyz)) : -frac(abs(r4.xyz));
    r4.xyz = r4.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r4.xyz = saturate(float3(-1,-1,-1) + abs(r4.xyz));
    r2.xy = -r0.xy * r1.ww + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r2.xy, 0).xyzw;
    r3.xyz = r5.xyz * r4.xyz + r3.xyz;
    r1.xyz = r4.xyz + r1.xyz;
  }
  if (int(r0.z) > 17) {
    r1.w = 17.5 / r0.w;
    r2.x = cb0[134].z + r1.w;
    r2.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r2.xyz = (r2.xyz >= -r2.xyz) ? frac(abs(r2.xyz)) : -frac(abs(r2.xyz));
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r4.xy = -r0.xy * r1.ww + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r3.xyz = r4.xyz * r2.xyz + r3.xyz;
    r1.xyz = r2.xyz + r1.xyz;
  }
  if (int(r0.z) > 18) {
    r1.w = 18.5 / r0.w;
    r2.x = cb0[134].z + r1.w;
    r2.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r2.xyz = (r2.xyz >= -r2.xyz) ? frac(abs(r2.xyz)) : -frac(abs(r2.xyz));
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r4.xy = -r0.xy * r1.ww + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r3.xyz = r4.xyz * r2.xyz + r3.xyz;
    r1.xyz = r2.xyz + r1.xyz;
  }
  if (int(r0.z) > 19) {
    r1.w = 19.5 / r0.w;
    r2.x = cb0[134].z + r1.w;
    r4.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r4.xyz = float3(0.166666672,0.166666672,0.166666672) * r4.xyz;
    r4.xyz = (r4.xyz >= -r4.xyz) ? frac(abs(r4.xyz)) : -frac(abs(r4.xyz));
    r4.xyz = r4.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r4.xyz = saturate(float3(-1,-1,-1) + abs(r4.xyz));
    r5.xy = -r0.xy * r1.ww + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r5.xy, 0).xyzw;
    r3.xyz = r5.xyz * r4.xyz + r3.xyz;
    r1.xyz = r4.xyz + r1.xyz;
  }
  if (int(r0.z) > 20) {
    r1.w = 20.5 / r0.w;
    r2.x = cb0[134].z + r1.w;
    r4.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r4.xyz = float3(0.166666672,0.166666672,0.166666672) * r4.xyz;
    r4.xyz = (r4.xyz >= -r4.xyz) ? frac(abs(r4.xyz)) : -frac(abs(r4.xyz));
    r4.xyz = r4.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r4.xyz = saturate(float3(-1,-1,-1) + abs(r4.xyz));
    r2.xy = -r0.xy * r1.ww + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r2.xy, 0).xyzw;
    r3.xyz = r5.xyz * r4.xyz + r3.xyz;
    r1.xyz = r4.xyz + r1.xyz;
  }
  if (int(r0.z) > 21) {
    r1.w = 21.5 / r0.w;
    r2.x = cb0[134].z + r1.w;
    r2.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r2.xyz = (r2.xyz >= -r2.xyz) ? frac(abs(r2.xyz)) : -frac(abs(r2.xyz));
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r4.xy = -r0.xy * r1.ww + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r3.xyz = r4.xyz * r2.xyz + r3.xyz;
    r1.xyz = r2.xyz + r1.xyz;
  }
  if (int(r0.z) > 22) {
    r1.w = 22.5 / r0.w;
    r2.x = cb0[134].z + r1.w;
    r2.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r2.xyz = (r2.xyz >= -r2.xyz) ? frac(abs(r2.xyz)) : -frac(abs(r2.xyz));
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r4.xy = -r0.xy * r1.ww + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r3.xyz = r4.xyz * r2.xyz + r3.xyz;
    r1.xyz = r2.xyz + r1.xyz;
  }
  if (int(r0.z) > 23) {
    r1.w = 23.5 / r0.w;
    r2.x = cb0[134].z + r1.w;
    r4.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r4.xyz = float3(0.166666672,0.166666672,0.166666672) * r4.xyz;
    r4.xyz = (r4.xyz >= -r4.xyz) ? frac(abs(r4.xyz)) : -frac(abs(r4.xyz));
    r4.xyz = r4.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r4.xyz = saturate(float3(-1,-1,-1) + abs(r4.xyz));
    r5.xy = -r0.xy * r1.ww + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r5.xy, 0).xyzw;
    r3.xyz = r5.xyz * r4.xyz + r3.xyz;
    r1.xyz = r4.xyz + r1.xyz;
  }
  if (int(r0.z) > 24) {
    r1.w = 24.5 / r0.w;
    r2.x = cb0[134].z + r1.w;
    r4.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r4.xyz = float3(0.166666672,0.166666672,0.166666672) * r4.xyz;
    r4.xyz = (r4.xyz >= -r4.xyz) ? frac(abs(r4.xyz)) : -frac(abs(r4.xyz));
    r4.xyz = r4.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r4.xyz = saturate(float3(-1,-1,-1) + abs(r4.xyz));
    r2.xy = -r0.xy * r1.ww + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r2.xy, 0).xyzw;
    r3.xyz = r5.xyz * r4.xyz + r3.xyz;
    r1.xyz = r4.xyz + r1.xyz;
  }
  if (int(r0.z) > 25) {
    r1.w = 25.5 / r0.w;
    r2.x = cb0[134].z + r1.w;
    r2.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r2.xyz = (r2.xyz >= -r2.xyz) ? frac(abs(r2.xyz)) : -frac(abs(r2.xyz));
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r4.xy = -r0.xy * r1.ww + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r3.xyz = r4.xyz * r2.xyz + r3.xyz;
    r1.xyz = r2.xyz + r1.xyz;
  }
  if (int(r0.z) > 26) {
    r1.w = 26.5 / r0.w;
    r2.x = cb0[134].z + r1.w;
    r2.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r2.xyz = (r2.xyz >= -r2.xyz) ? frac(abs(r2.xyz)) : -frac(abs(r2.xyz));
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r4.xy = -r0.xy * r1.ww + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r3.xyz = r4.xyz * r2.xyz + r3.xyz;
    r1.xyz = r2.xyz + r1.xyz;
  }
  if (int(r0.z) > 27) {
    r1.w = 27.5 / r0.w;
    r2.x = cb0[134].z + r1.w;
    r4.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r4.xyz = float3(0.166666672,0.166666672,0.166666672) * r4.xyz;
    r4.xyz = (r4.xyz >= -r4.xyz) ? frac(abs(r4.xyz)) : -frac(abs(r4.xyz));
    r4.xyz = r4.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r4.xyz = saturate(float3(-1,-1,-1) + abs(r4.xyz));
    r5.xy = -r0.xy * r1.ww + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r5.xy, 0).xyzw;
    r3.xyz = r5.xyz * r4.xyz + r3.xyz;
    r1.xyz = r4.xyz + r1.xyz;
  }
  if (int(r0.z) > 28) {
    r1.w = 28.5 / r0.w;
    r2.x = cb0[134].z + r1.w;
    r4.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r4.xyz = float3(0.166666672,0.166666672,0.166666672) * r4.xyz;
    r4.xyz = (r4.xyz >= -r4.xyz) ? frac(abs(r4.xyz)) : -frac(abs(r4.xyz));
    r4.xyz = r4.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r4.xyz = saturate(float3(-1,-1,-1) + abs(r4.xyz));
    r2.xy = -r0.xy * r1.ww + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r2.xy, 0).xyzw;
    r3.xyz = r5.xyz * r4.xyz + r3.xyz;
    r1.xyz = r4.xyz + r1.xyz;
  }
  if (int(r0.z) > 29) {
    r1.w = 29.5 / r0.w;
    r2.x = cb0[134].z + r1.w;
    r2.xyz = r2.xxx * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r2.xyz = (r2.xyz >= -r2.xyz) ? frac(abs(r2.xyz)) : -frac(abs(r2.xyz));
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r4.xy = -r0.xy * r1.ww + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r3.xyz = r4.xyz * r2.xyz + r3.xyz;
    r1.xyz = r2.xyz + r1.xyz;
  }
  if (int(r0.z) > 30) {
    r0.w = 30.5 / r0.w;
    r1.w = cb0[134].z + r0.w;
    r2.xyz = r1.www * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r2.xyz = (r2.xyz >= -r2.xyz) ? frac(abs(r2.xyz)) : -frac(abs(r2.xyz));
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r4.xy = -r0.xy * r0.ww + v1.xy;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r3.xyz = r4.xyz * r2.xyz + r3.xyz;
    r1.xyz = r2.xyz + r1.xyz;
  }
  if (int(r0.z) > 31) {
    r0.z = 0.984375 + cb0[134].z;
    r2.xyz = r0.zzz * float3(6,6,6) + float3(0,4,2);
    r2.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
    r2.xyz = (r2.xyz >= -r2.xyz) ? frac(abs(r2.xyz)) : -frac(abs(r2.xyz));
    r2.xyz = r2.xyz * float3(6,6,6) + float3(-3,-3,-3);
    r2.xyz = saturate(float3(-1,-1,-1) + abs(r2.xyz));
    r0.xy = -r0.xy * float2(0.984375,0.984375) + v1.xy;
    r0.xyzw = t0.SampleLevel(s0_s, r0.xy, 0).xyzw;
    r3.xyz = r0.xyz * r2.xyz + r3.xyz;
    r1.xyz = r2.xyz + r1.xyz;
  }
  r0.xyz = r3.xyz / r1.xyz;
  r0.xyz = max(float3(0,0,0), r0.xyz);
  r0.xyz = min(cb0[143].zzz, r0.xyz);
  r1.xyzw = t1.SampleBias(s2_s, v3.xy, cb0[5].x).xyzw;
  r0.w = cb0[23].x * r1.x + cb0[23].y;
  r0.w = 1 / r0.w;
  r1.xyzw = t1.SampleBias(s2_s, v2.xy, cb0[5].x).xyzw;
  r1.x = cb0[23].x * r1.x + cb0[23].y;
  r1.x = 1 / r1.x;
  r2.xyzw = t1.SampleBias(s2_s, w2.xy, cb0[5].x).xyzw;
  r1.y = cb0[23].x * r2.x + cb0[23].y;
  r1.y = 1 / r1.y;
  r2.xyzw = t1.SampleBias(s2_s, w1.xy, cb0[5].x).xyzw;
  r1.z = cb0[23].x * r2.x + cb0[23].y;
  r1.z = 1 / r1.z;
  r1.w = max(r1.z, r0.w);
  r1.w = max(r1.w, r1.x);
  r1.w = max(r1.w, r1.y);
  r0.w = min(r1.z, r0.w);
  r0.w = min(r0.w, r1.x);
  r0.w = min(r0.w, r1.y);
  r0.w = r1.w + -r0.w;
  r0.w = 9.99999997e-07 + r0.w;
  r2.xyzw = t0.SampleBias(s0_s, v3.xy, cb0[5].x).xyzw;
  r3.xyzw = t0.SampleBias(s0_s, v2.xy, cb0[5].x).xyzw;
  r4.xyzw = t0.SampleBias(s0_s, w2.xy, cb0[5].x).xyzw;
  r5.xyzw = t0.SampleBias(s0_s, w1.xy, cb0[5].x).xyzw;
  r1.y = renodx::color::y::from::NTSC1953(r5.xyz);
  r1.z = renodx::color::y::from::NTSC1953(r4.xyz);
  r1.w = renodx::color::y::from::NTSC1953(r3.xyz);
  r2.x = renodx::color::y::from::NTSC1953(r2.xyz);
  r2.y = max(r2.x, r1.y);
  r2.y = max(r2.y, r1.w);
  r2.y = max(r2.y, r1.z);
  r1.y = min(r2.x, r1.y);
  r1.y = min(r1.y, r1.w);
  r1.y = min(r1.y, r1.z);
  r1.y = -9.99999997e-07 + r1.y;
  r1.z = renodx::color::y::from::NTSC1953(r0.xyz);
  r0.w = saturate(cb0[140].y / r0.w);
  r1.w = r1.z * 2 + -r1.y;
  r1.w = r1.w + -r2.y;
  r1.y = r2.y + -r1.y;
  r1.y = saturate(cb0[140].w / r1.y);
  r1.x = -cb0[139].z + r1.x;
  r1.x = abs(r1.x) < cb0[139].w ? 1.000000 : 0;
  r1.y = r1.w * r1.y;
  r0.w = r1.y * r0.w;
  r0.w = cb0[140].x * r0.w;
  r0.w = max(-cb0[140].z, r0.w);
  r0.w = min(cb0[140].z, r0.w);
  r0.w = r0.w * r1.x + 1;
  r2.xyzw = t2.SampleBias(s0_s, v1.xy, cb0[5].x).xyzw;
  r1.xyw = cb0[141].xxx * r2.xyz * injectedData.fxBloom;
  r0.xyz = r0.xyz * r0.www + r1.xyw;
  float midGray = vanillaSH(float3(0.18f, 0.18f, 0.18f)).x;
  float3 hueCorrectionColor = vanillaSH(r0.xyz);
  renodx::tonemap::Config config = renodx::tonemap::config::Create();
  config.type = min(3, injectedData.toneMapType);
  config.peak_nits = getNewPeak(injectedData.toneMapPeakNits);
  config.game_nits = injectedData.toneMapGameNits;
  config.gamma_correction = injectedData.toneMapGammaCorrection;
  config.exposure = injectedData.colorGradeExposure;
  config.highlights = injectedData.colorGradeHighlights;
  config.shadows = injectedData.colorGradeShadows;
  config.contrast = injectedData.colorGradeContrast;
  config.saturation = injectedData.colorGradeSaturation;
  config.mid_gray_value = midGray;
  config.mid_gray_nits = midGray * 100;
  config.reno_drt_contrast = 1.6f;
  config.reno_drt_saturation = 0.9f;
  config.reno_drt_dechroma = injectedData.colorGradeDechroma;
  config.reno_drt_flare = 0.10f * pow(injectedData.colorGradeFlare, 10.f);
  config.hue_correction_type = injectedData.toneMapPerChannel != 0.f ? renodx::tonemap::config::hue_correction_type::INPUT
                                                                     : renodx::tonemap::config::hue_correction_type::CUSTOM;
  config.hue_correction_strength = injectedData.toneMapHueCorrection;
  config.hue_correction_color = lerp(r0.xyz, hueCorrectionColor, injectedData.toneMapHueShift);
  config.reno_drt_hue_correction_method = injectedData.toneMapHueProcessor;
  config.reno_drt_tone_map_method = injectedData.toneMapType == 4.f ? renodx::tonemap::renodrt::config::tone_map_method::REINHARD
                                                                    : renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
  config.reno_drt_working_color_space = (int)injectedData.toneMapColorSpace;
  config.reno_drt_per_channel = injectedData.toneMapPerChannel != 0.f;
  config.reno_drt_blowout = 1.f - injectedData.colorGradeBlowout * 0.875f;
  config.reno_drt_white_clip = injectedData.colorGradeClip == 0.f ? 26.f : injectedData.colorGradeClip;
  if(injectedData.toneMapType == 0.f){
    r0.xyz = hueCorrectionColor;
  }
  r0.xyz = renodx::tonemap::config::Apply(r0.xyz, config);
  // vibrance
  r0.w = max(r0.y, r0.z);
  r0.w = max(r0.x, r0.w);
  r1.x = min(r0.y, r0.z);
  r1.x = min(r1.x, r0.x);
  if(injectedData.toneMapType != 0.f){
    r1.x = max(0.f, r1.x);
  }
  r0.w = saturate(-r1.x + r0.w);
  r0.w = 1 + -r0.w;
  r0.w = cb0[144].z * r0.w;
  r1.x = renodx::color::y::from::NTSC1953(r0.xyz);
  r1.xyw = r0.xyz + -r1.xxx;
  r1.xyw = r0.www * r1.xyw + float3(1,1,1);
  r0.xyz = r1.xyw * r0.xyz;
  // tint
  r1.xyw = r0.xyz * cb0[145].xyz + -r0.xyz;
  r0.xyz = cb0[145].www * r1.xyw + r0.xyz;
  // contrast
  r0.xyz = float3(-0.5,-0.5,-0.5) + r0.xyz;
  r0.xyz = r0.xyz * cb0[144].yyy + float3(0.5,0.5,0.5);
  //
  r1.xyw = cb0[144].xxx * r0.xyz;
  r2.xy = -cb0[159].xy + v1.xy;
  r3.x = cb0[160].x * r2.x;
  r3.y = cb0[159].z * r2.y;
  r0.w = dot(r3.xy, r3.xy);
  r0.w = -cb0[159].w + r0.w;
  r2.x = -cb0[159].w + cb0[146].w;
  r0.w = saturate(r0.w / r2.x);
  r0.w = saturate(-cb0[146].z + r0.w);
  r2.xyz = r0.xyz * cb0[144].xxx + -cb0[158].xyz;
  r2.xyz = r0.www * r2.xyz + cb0[158].xyz;
  r0.xyz = -r0.xyz * cb0[144].xxx + r2.xyz;
  r0.xyz = cb0[158].www * r0.xyz + r1.xyw;
  // noise
  r1.xy = cb0[136].xy * v1.xy;
  r1.xy = cb0[132].zw * r1.xy;
  r2.xyzw = t3.SampleBias(s1_s, r1.xy, cb0[5].x).xyzw;
  r1.xyw = float3(-0.5,-0.5,-0.5) + r2.xyz;
  r1.xyw = cb0[144].www * r1.xyw * injectedData.fxNoise;
  r0.w = saturate(1 + -r1.z);
  r0.xyz = r1.xyw * r0.www + r0.xyz;
  if(injectedData.toneMapType == 0.f){
    r0.xyz = max(float3(0,0,0), r0.xyz);
  } else {
    r0.xyz = renodx::color::bt709::clamp::AP1(r0.xyz);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  if (injectedData.countOld == injectedData.countNew) {
    o0.xyz = PostToneMapScale(o0.xyz);
  }
  return;
}