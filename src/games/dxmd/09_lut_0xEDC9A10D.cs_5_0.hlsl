#include "./shared.h"

Texture2D<float4> t0 : register(t0);  // Depth Map
Texture2D<float4> t1 : register(t1);  // Untonemapped
Texture2D<float4> t2 : register(t2);  // Screen Overlay 256x4 LUT



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
    r0.zw = float2(0, 0);
    r1.xyz = t1.Load(coords).xyz;
    const float3 inputColor = r1.rgb;
    r1.xyz = cb11[13].yyy * r1.xyz;
    r1.w = dot(r1.xyz, float3(0.212599993, 0.715200007, 0.0722000003));
    r2.x = r1.w * cb11[13].z + 1;
    r1.w = 1 + r1.w;
    r1.w = r2.x / r1.w;
    r2.xyz = r1.xyz * r1.www;
    r2.x = dot(r2.xyz, float3(0.298038989, 0.588235974, 0.113724999));
    r1.xyz = r1.xyz * r1.www + -r2.xxx;
    r1.xyz = cb11[13].xxx * r1.xyz + r2.xxx;
    r1.xyz = max(float3(0, 0, 0), r1.xyz);
    r1.xyz = sqrt(r1.xyz);
    r0.z = t0.Load(coords).x;
    r0.w = 0;
    r0.z = t2.SampleLevel(s0_s, r0.zw, 0).w;
    r2.xyzw = cb11[1].xyzw * r0.zzzz + cb11[0].xyzw;
    r3.xyzw = cb11[3].xyzw * r0.zzzz + cb11[2].xyzw;
    r4.xyzw = cb11[5].xyzw * r0.zzzz + cb11[4].xyzw;
    r5.xyzw = cb11[7].xyzw * r0.zzzz + cb11[6].xyzw;
    r6.xyzw = cb11[9].xyzw * r0.zzzz + cb11[8].xyzw;
    r7.xy = cb11[10].yw * r0.zz + cb11[10].xz;
    r0.w = 1 + r7.y;
    r8.xyzw = r4.xyzw + -r2.xyzw;
    r2.xyzw = r4.xyzw + r2.xyzw;
    r4.xyzw = r6.xyzw + -r5.xyzw;

    // r6.xyzw = -(int4)r3.xyzw + int4(0x7ef311c3, 0x7ef311c3, 0x7ef311c3, 0x7ef311c3);
    // r3.xyzw = -r6.xyzw * r3.xyzw + float4(2, 2, 2, 2);
    // r3.xyzw = r6.xyzw * r3.xyzw;
    r3 = rcp(r3);

    // r6.xyzw = (int4)-r8.xyzw + int4(0x7ef311c3, 0x7ef311c3, 0x7ef311c3, 0x7ef311c3);
    // r8.xyzw = -r6.xyzw * r8.xyzw + float4(2, 2, 2, 2);
    // r6.xyzw = r8.xyzw * r6.xyzw;
    r6 = rcp(r8);

    r1.xyz = -r2.xyz * float3(0.5, 0.5, 0.5) + r1.xyz;
    r1.xyz = r1.xyz * r6.xyz + float3(0.5, 0.5, 0.5);
    r1.xyz = max(float3(0, 0, 0), r1.xyz);
    r1.xyz = log2(r1.xyz);
    r1.xyz = r3.xyz * r1.xyz;
    r1.xyz = exp2(r1.xyz);
    r1.xyz = r1.xyz * r4.xyz + r5.xyz;
    r1.xyz = -r2.www * float3(0.5, 0.5, 0.5) + r1.xyz;
    r1.xyz = r1.xyz * r6.www + float3(0.5, 0.5, 0.5);
    r1.xyz = max(float3(0, 0, 0), r1.xyz);
    r1.xyz = log2(r1.xyz);
    r1.xyz = r3.www * r1.xyz;
    r1.xyz = exp2(r1.xyz);
    r1.xyz = r1.xyz * r4.www + r5.www;
    r1.xyz = float3(-0.5, -0.5, -0.5) + r1.xyz;
    r1.xyz = r1.xyz * r0.www + r7.xxx;
    r1.xyz = float3(0.5, 0.5, 0.5) + r1.xyz;
    r2.x = dot(r1.xyz, float3(0.212599993, 0.715200007, 0.0722000003));
    r2.yz = r0.zz * float2(0.25, 0.25) + float2(0.125, 0.625);
    r3.xyz = t2.SampleLevel(s0_s, r2.xy, 0).xyz;
    r2.xyz = t2.SampleLevel(s0_s, r2.xz, 0).xyz;
    r3.xyz = r3.xyz * float3(6.28318501, 2, 2) + float3(-3.1415925, 0, -1);
    r2.xyz = r2.xyz + r2.xyz;
    sincos(r3.x, r3.x, r4.x);
    r0.z = r4.x * r3.y;
    r0.w = r3.y * r3.x;
    r1.w = r0.z * 0.700999975 + 0.298999995;
    r4.x = r0.w * 0.167999998 + r1.w;
    r3.xyw = -r0.zzz * float3(0.587000012, 0.114, 0.298999995) + float3(0.587000012, 0.114, 0.298999995);
    r4.y = r0.w * 0.330000013 + r3.x;
    r4.zw = -r0.ww * float2(0.497000009, 0.328000009) + r3.yw;
    r3.xw = r0.zz * float2(0.412999988, 0.885999978) + float2(0.587000012, 0.114);
    r5.y = r0.w * 0.0350000001 + r3.x;
    r5.z = r0.w * 0.291999996 + r3.y;
    r3.xy = -r0.zz * float2(0.300000012, 0.588) + float2(0.298999995, 0.587000012);
    r6.x = r0.w * 1.25 + r3.x;
    r6.y = -r0.w * 1.04999995 + r3.y;
    r6.z = -r0.w * 0.202999994 + r3.w;
    r4.x = dot(r4.xyz, r1.xyz);
    r5.x = r4.w;
    r4.y = dot(r5.xyz, r1.xyz);
    r4.z = dot(r6.xyz, r1.xyz);
    r1.xyz = r4.xyz + r3.zzz;
    r1.xyz = r1.xyz * r2.xyz;
    r1.xyz = max(float3(0, 0, 0), r1.xyz);
    r1.xyz = lerp(inputColor, r1.xyz, injectedData.colorGradeLUTStrength);
    r1.w = dot(r1.xyz, float3(0.298999995, 0.587000012, 0.114));
    // No code for instruction (needs manual fix):
    // store_uav_typed u0.xyzw, r0.xyyy, r1.xyzw
    u0[coords.xy] = r1.xyzw;
  }
  return;
}
