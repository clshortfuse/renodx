#include "./common.hlsl"

Texture2D<float4> t8 : register(t8);
Texture3D<float4> t7 : register(t7);
Texture2D<float4> t6 : register(t6);
Texture2D<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb3 : register(b3){
  float4 cb3[254];
}
cbuffer cb2 : register(b2){
  float4 cb2[34];
}
cbuffer cb1 : register(b1){
  float4 cb1[3];
}
cbuffer cb0 : register(b0){
  float4 cb0[2];
}

#define cmp -

void main(
  float4 v0 : SV_Position0,
  float4 v1 : VDATA0,
  float4 v2 : VDATA1,
  float4 v3 : VDATA2,
  float4 v4 : VDATA3,
  float4 v5 : VDATA4,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb2[12].zw * v0.xy;
  r1.xyzw = t0.Sample(s0_s, v5.xy).xyzw;
  r2.xyzw = t0.Sample(s0_s, v5.zw).xyzw;
  r2.xyzw = r2.xyzw + -r1.xyzw;
  r1.xyzw = v4.zzzz * r2.xyzw + r1.xyzw;
  r0.z = cb1[2].z * r1.w;
  r0.w = t1.Sample(s1_s, r0.xy).x;
  r0.w = -v2.z + r0.w;
  r0.w = cb2[2].y * r0.w;
  r0.w = saturate(r0.w / cb1[1].x);
  r0.w = v4.w * r0.w;
  r0.z = v3.z * r0.z;
  r2.w = saturate(r0.z * r0.w);
  r0.z = -0.00499999989 + r2.w;
  r0.z = cmp(r0.z < 0);
  if (r0.z != 0) discard;
  r3.x = v2.w;
  r3.yz = v3.xy;
  r2.xyz = r3.xyz * r1.xyz;
  r0.z = t2.Sample(s1_s, float2(0,0)).w;
  r1.xyz = r0.zzz * r1.xyz;
  r3.x = v3.w;
  r3.yz = v4.xy;
  r1.xyz = r3.xyz * r1.xyz;
  r1.xyz = cb1[0].xyz * r1.xyz;
  r1.xyz = cb1[0].www * r1.xyz;
  r1.xyz = cb0[0].xxx * r1.xyz;
  r1.w = 0;
  r1.xyzw = r2.xyzw + r1.xyzw;
  r2.zw = r0.xy * cb2[9].xy + cb2[9].zw;
  r0.z = t8.SampleLevel(s1_s, r2.zw, 0).y;
  r0.w = cb3[5].x * cb2[2].w;
  r0.w = max(9.99999975e-06, r0.w);
  r0.z = min(v2.z, r0.z);
  r0.z = r0.z / r0.w;
  r0.z = rsqrt(r0.z);
  r0.z = 1 / r0.z;
  r0.z = min(1, r0.z);
  r0.z = r0.z * cb3[6].x + -1;
  r3.x = cb3[6].x + -1;
  r3.y = max(0, r0.z);
  r3.y = min(r3.y, r3.x);
  r3.y = floor(r3.y);
  r3.z = r3.y + r2.z;
  r2.y = cb3[6].y * r3.z;
  r4.xyz = t3.SampleLevel(s2_s, r2.yw, 0).xyz;
  r5.xyz = t5.SampleLevel(s2_s, r2.yw, 0).xyz;
  r2.y = cmp(r0.w < v2.z);
  if (r2.y != 0) {
    r0.xy = r0.xy * float2(2,-2) + float2(-1,1);
    r0.xy = -cb2[7].xy + r0.xy;
    r2.y = cb2[26].z * cb2[26].y;
    r6.x = r2.y * r0.x;
    r0.x = cb2[26].w * r0.y;
    r6.z = r0.x * r2.y;
    r6.y = cb2[26].y;
    r6.w = 1;
    r7.x = dot(cb2[31].xyzw, r6.xyzw);
    r7.y = dot(cb2[32].xyzw, r6.xyzw);
    r7.z = dot(cb2[33].xyzw, r6.xyzw);
    r6.xyz = -cb2[1].xyz + r7.xyz;
    r6.xyz = cb2[2].www * r6.xyz;
    r0.x = dot(r6.xyz, r6.xyz);
    r0.x = rsqrt(r0.x);
    r7.xyz = r6.xyz * r0.xxx;
    r0.x = dot(cb3[16].xyz, r7.xyz);
    r0.y = -cb3[61].x + 1;
    r0.y = r0.y * r0.y;
    r0.x = -r0.x * 2 + cb3[61].x;
    r0.x = cb3[61].x * r0.x + 1;
    r0.x = log2(r0.x);
    r0.x = 1.5 * r0.x;
    r0.x = exp2(r0.x);
    r0.x = r0.x + r0.x;
    r0.x = r0.y / r0.x;
    r0.x = cb3[61].z * r0.x;
    r7.xyz = cb3[22].xyz * r0.xxx;
    r0.x = cb2[14].z + cb2[1].z;
    r0.y = cb2[2].y * v2.z;
    r2.y = r6.z * cb3[5].x + r0.x;
    r0.x = r6.z * r0.y + r0.x;
    r8.xyz = cb3[64].xyz * cb3[63].yyy;
    r3.z = max(r2.y, r0.x);
    r3.z = 0.00100000005 + r3.z;
    r0.x = min(r2.y, r0.x);
    r2.y = cb3[62].y + -cb3[62].x;
    r3.w = -cb3[62].x + r3.z;
    r2.y = 1 / r2.y;
    r3.w = saturate(r3.w * r2.y);
    r4.w = r3.w * -2 + 3;
    r3.w = r3.w * r3.w;
    r5.w = -cb3[62].x + r0.x;
    r2.y = saturate(r5.w * r2.y);
    r5.w = r2.y * -2 + 3;
    r2.y = r2.y * r2.y;
    r2.y = r5.w * r2.y;
    r2.y = r4.w * r3.w + -r2.y;
    r2.y = cb3[62].w * r2.y;
    r0.x = r3.z + -r0.x;
    r0.x = r2.y / r0.x;
    r0.x = min(0.999899983, r0.x);
    r0.y = 0.899999976 * r0.y;
    r6.xyz = r6.xyz * r0.yyy + cb2[1].xyz;
    r9.xyz = -cb3[237].xyz + r6.xyz;
    r9.xyz = cb3[236].yzw * r9.xyz;
    r0.y = max(abs(r9.y), abs(r9.z));
    r0.y = max(abs(r9.x), r0.y);
    r0.y = (uint)r0.y >> 23;
    r0.y = max(126, (uint)r0.y);
    r0.y = (int)r0.y + -126;
    r2.y = -1 + asint(cb3[236].x);
    r0.y = min((uint)r2.y, (uint)r0.y);
    r6.xyz = -cb3[r0.y+237].xyz + r6.xyz;
    r6.xyz = cb3[r0.y+237].www * r6.xyz;
    r6.xyz = r6.xyz / cb3[235].xyz;
    r6.xyz = saturate(float3(0.5,0.5,0.5) + r6.xyz);
    r2.y = 0.5 / cb3[235].z;
    r6.w = max(r2.y, r6.z);
    r9.z = (uint)r0.y;
    r9.xy = float2(0,0);
    r6.xyz = r9.xyz + r6.xyw;
    r9.z = 1 / cb3[235].w;
    r9.xy = float2(1,1);
    r6.xyz = r9.xyz * r6.xyz;
    r6.xyz = t7.SampleLevel(s2_s, r6.xyz, 0).xyz;
    r6.xyz = max(float3(0,0,0), r6.xyz);
    r6.xyz = min(float3(65504,65504,65504), r6.xyz);
    r6.xyz = cb3[64].xyz * r6.xyz;
    r0.x = 1 + -r0.x;
    r0.y = v2.z * cb2[2].y + -cb3[5].x;
    r0.x = log2(r0.x);
    r0.x = r0.y * r0.x;
    r0.x = exp2(r0.x);
    r0.x = min(1, r0.x);
    r7.xyz = r8.xyz * r7.xyz;
    r6.xyz = r6.xyz * cb3[2].xyz + r7.xyz;
    r0.y = 1 + -r0.x;
    r6.xyz = r6.xyz * r0.yyy;
    r6.xyz = r6.xyz * r5.xyz + r4.xyz;
    r7.xyz = r5.xyz * r0.xxx;
    r8.xyz = t4.SampleLevel(s2_s, r2.zw, 0).xyz;
    r9.xyz = t6.SampleLevel(s2_s, r2.zw, 0).xyz;
    r0.x = v2.z + -r0.w;
    r0.y = 1 + -r0.w;
    r0.x = r0.x / r0.y;
    r10.xyz = max(float3(0,0,0), r9.xyz);
    r10.xyz = log2(r10.xyz);
    r0.xyw = r10.xyz * r0.xxx;
    r0.xyw = exp2(r0.xyw);
    r10.xyz = float3(-1,-1,-1) + r0.xyw;
    r8.xyz = r10.xyz * r8.xyz;
    r9.xyz = float3(-1,-1,-1) + r9.xyz;
    r9.xyz = min(float3(-9.99999975e-06,-9.99999975e-06,-9.99999975e-06), r9.xyz);
    r8.xyz = r8.xyz / r9.xyz;
    r6.xyz = r8.xyz * r7.xyz + r6.xyz;
    r0.xyw = r7.xyz * r0.xyw;
  } else {
    r2.y = 1 + r3.y;
    r2.y = min(r2.y, r3.x);
    r2.y = r2.z + r2.y;
    r2.x = cb3[6].y * r2.y;
    r3.xzw = t3.SampleLevel(s2_s, r2.xw, 0).xyz;
    r2.xyz = t5.SampleLevel(s2_s, r2.xw, 0).xyz;
    r0.z = saturate(-r3.y + r0.z);
    r3.xyz = r3.xzw + -r4.xyz;
    r6.xyz = r0.zzz * r3.xyz + r4.xyz;
    r2.xyz = r2.xyz + -r5.xyz;
    r0.xyw = r0.zzz * r2.xyz + r5.xyz;
  }
  r2.xyz = cb0[1].xxx * r6.xyz;
  r0.xyz = r1.xyz * r0.xyw + r2.xyz;
  r0.w = cmp(0.000000 != cb3[9].x);
  if (r0.w != 0) {
    r0.w = dot(r0.xyz, float3(0.212500006,0.715399981,0.0720999986));
    r0.w = 9.99999975e-06 + r0.w;
    r0.w = log2(r0.w);
    r0.w = cb3[9].x * r0.w;
    r0.xyz = exp2(r0.www);
  }
  o0.xyz = r1.www * r0.xyz;
  o0.w = r1.w;
    float peak = injectedData.toneMapPeakNits / injectedData.toneMapGameNits;
    if (injectedData.toneMapGammaCorrection != 0.f) {
      peak = renodx::color::correct::Gamma(peak, true, injectedData.toneMapGammaCorrection == 1.f ? 2.2f : 2.4f);
    }
    float y = renodx::color::y::from::BT709(abs(o0.rgb));
    if (y > peak) {
      o0.rgb = renodx::tonemap::ExponentialRollOff(o0.rgb, 1.f, max(1.005f, peak));
    }
    o0.rgb = renodx::color::srgb::EncodeSafe(o0.rgb);
    o0.rgb = InvertFinalizeOutput(o0.rgb);
  return;
}