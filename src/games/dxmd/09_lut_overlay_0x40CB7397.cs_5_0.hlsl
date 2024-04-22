#include "./shared.h"

Texture2D<float4> t0 : register(t0);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t3 : register(t3);

SamplerState s0_s : register(s0);

cbuffer cb11 : register(b11) {
  float4 cb11[14];
}

RWTexture2D<float4> u0 : register(u0);

// 3Dmigoto declarations
#define cmp -

[numthreads(8, 8, 1)] void main(uint2 vThreadGroupID : SV_GroupID, uint2 vThreadIDInGroup : SV_GroupThreadID) {
  // Needs manual fix for instruction:
  // unknown dcl_: dcl_uav_typed_texture2d (float,float,float,float) u0
  float4 r0, r1, r2, r3, r4, r5, r6, r7, r8;
  uint4 bitmask, uiDest;
  float4 fDest;

  // Needs manual fix for instruction:
  // unknown dcl_: dcl_thread_group 8, 8, 1
  uint3 coords = uint3(
    mad(vThreadGroupID.xy, int2(8, 8), vThreadIDInGroup.xy),
    0
  );
  r0.xy = mad(vThreadGroupID.xy, int2(8, 8), vThreadIDInGroup.xy);
  r1.xy = (uint2)cb11[11].xy;
  r1.xy = cmp(coords.xy >= (uint2)r1.xy);
  r1.x = (int)r1.y | (int)r1.x;
  if (r1.x == 0) {
    r1.xy = (uint2)r0.xy;
    r1.xy = float2(0.5, 0.5) + r1.xy;
    r1.xy = cb11[11].zw * r1.xy;
    r0.zw = float2(0, 0);
    r2.xyz = t1.Load(coords).xyz;
    const float3 inputColor = r2.rgb;
    r2.xyz = cb11[13].yyy * r2.xyz;
    r1.z = dot(r2.xyz, float3(0.212599993, 0.715200007, 0.0722000003));
    r1.w = r1.z * cb11[13].z + 1;
    r1.z = 1 + r1.z;
    r1.z = r1.w / r1.z;
    r3.xyz = r2.xyz * r1.zzz;
    r1.w = dot(r3.xyz, float3(0.298038989, 0.588235974, 0.113724999));
    r2.xyz = r2.xyz * r1.zzz + -r1.www;
    r2.xyz = cb11[13].xxx * r2.xyz + r1.www;
    r2.xyz = max(float3(0, 0, 0), r2.xyz);
    r2.xyz = sqrt(r2.xyz);
    r0.z = t0.Load(r0.xyz).x;
    r0.w = 0;
    r0.z = t2.SampleLevel(s0_s, r0.zw, 0).w;
    r3.xyzw = cb11[1].xyzw * r0.zzzz + cb11[0].xyzw;
    r4.xyzw = cb11[3].xyzw * r0.zzzz + cb11[2].xyzw;
    r5.xyzw = cb11[5].xyzw * r0.zzzz + cb11[4].xyzw;
    r6.xyzw = cb11[7].xyzw * r0.zzzz + cb11[6].xyzw;
    r7.xyzw = cb11[9].xyzw * r0.zzzz + cb11[8].xyzw;
    r1.zw = cb11[10].yw * r0.zz + cb11[10].xz;
    r0.w = 1 + r1.w;
    r8.xyzw = r5.xyzw + -r3.xyzw;
    r3.xyzw = r5.xyzw + r3.xyzw;
    r5.xyzw = r7.xyzw + -r6.xyzw;
    // r7.xyzw = (int4)-r4.xyzw + int4(0x7ef311c3, 0x7ef311c3, 0x7ef311c3, 0x7ef311c3);
    // r4.xyzw = -r7.xyzw * r4.xyzw + float4(2, 2, 2, 2);
    // r4.xyzw = r7.xyzw * r4.xyzw;
    r4 = rcp(r4);

    // r7.xyzw = (int4)-r8.xyzw + int4(0x7ef311c3, 0x7ef311c3, 0x7ef311c3, 0x7ef311c3);
    // r8.xyzw = -r7.xyzw * r8.xyzw + float4(2, 2, 2, 2);
    // r7.xyzw = r8.xyzw * r7.xyzw;
    r7 = rcp(r8);

    r2.xyz = -r3.xyz * float3(0.5, 0.5, 0.5) + r2.xyz;
    r2.xyz = r2.xyz * r7.xyz + float3(0.5, 0.5, 0.5);
    r2.xyz = max(float3(0, 0, 0), r2.xyz);
    r2.xyz = log2(r2.xyz);
    r2.xyz = r4.xyz * r2.xyz;
    r2.xyz = exp2(r2.xyz);
    r2.xyz = r2.xyz * r5.xyz + r6.xyz;
    r2.xyz = -r3.www * float3(0.5, 0.5, 0.5) + r2.xyz;
    r2.xyz = r2.xyz * r7.www + float3(0.5, 0.5, 0.5);
    r2.xyz = max(float3(0, 0, 0), r2.xyz);
    r2.xyz = log2(r2.xyz);
    r2.xyz = r4.www * r2.xyz;
    r2.xyz = exp2(r2.xyz);
    r2.xyz = r2.xyz * r5.www + r6.www;
    r2.xyz = float3(-0.5, -0.5, -0.5) + r2.xyz;
    r2.xyz = r2.xyz * r0.www + r1.zzz;
    r2.xyz = float3(0.5, 0.5, 0.5) + r2.xyz;
    r3.x = dot(r2.xyz, float3(0.212599993, 0.715200007, 0.0722000003));
    r3.yz = r0.zz * float2(0.25, 0.25) + float2(0.125, 0.625);
    r4.xyz = t2.SampleLevel(s0_s, r3.xy, 0).xyz;
    r3.xyz = t2.SampleLevel(s0_s, r3.xz, 0).xyz;
    r4.xyz = r4.xyz * float3(6.28318501, 2, 2) + float3(-3.1415925, 0, -1);
    r3.xyz = r3.xyz + r3.xyz;
    sincos(r4.x, r4.x, r5.x);
    r0.z = r5.x * r4.y;
    r0.w = r4.y * r4.x;
    r1.z = r0.z * 0.700999975 + 0.298999995;
    r5.x = r0.w * 0.167999998 + r1.z;
    r4.xyw = -r0.zzz * float3(0.587000012, 0.114, 0.298999995) + float3(0.587000012, 0.114, 0.298999995);
    r5.y = r0.w * 0.330000013 + r4.x;
    r5.zw = -r0.ww * float2(0.497000009, 0.328000009) + r4.yw;
    r1.zw = r0.zz * float2(0.412999988, 0.885999978) + float2(0.587000012, 0.114);
    r6.y = r0.w * 0.0350000001 + r1.z;
    r6.z = r0.w * 0.291999996 + r4.y;
    r4.xy = -r0.zz * float2(0.300000012, 0.588) + float2(0.298999995, 0.587000012);
    r7.x = r0.w * 1.25 + r4.x;
    r7.y = -r0.w * 1.04999995 + r4.y;
    r7.z = -r0.w * 0.202999994 + r1.w;
    r5.x = dot(r5.xyz, r2.xyz);
    r6.x = r5.w;
    r5.y = dot(r6.xyz, r2.xyz);
    r5.z = dot(r7.xyz, r2.xyz);
    r2.xyz = r5.xyz + r4.zzz;
    r2.xyz = r2.xyz * r3.xyz;
    r2.xyz = max(float3(0, 0, 0), r2.xyz);
    r2.xyz = lerp(inputColor, r2.xyz, injectedData.colorGradeLUTStrength);
    r1.xyz = t3.SampleLevel(s0_s, r1.xy, 0).xyz;
    r1.xyz = r1.xyz * cb11[12].xyz + r2.xyz;
    r1.w = dot(r1.xyz, float3(0.298999995, 0.587000012, 0.114));
    // No code for instruction (needs manual fix):
    // store_uav_typed u0.xyzw, r0.xyyy, r1.xyzw
    u0[coords.xy] = r1.xyzw;
  }
  return;
}
