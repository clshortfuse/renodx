#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Sat May 25 22:39:05 2024
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = t1.Sample(s3_s, v2.zw).x;
  r0.x = r0.x * r0.x;
  r0.y = r0.x * 0.200000003 + 0.600000024;
  r0.z = t0.Sample(s2_s, v2.xy).y;
  r0.w = -r0.z * 0.200000003 + 1;
  r0.z = 0.200000003 * r0.z;
  r1.x = 1 + -v3.z;
  r2.xyzw = float4(0.729918897,0.263174742,0.00715503562,1) * v3.zzzz;
  r1.xyzw = r1.xxxx * float4(0.875137568,0.18014428,0.00258582528,1) + r2.xyzw;
  r2.xyz = saturate(r1.xyz * v1.xyz + float3(0.00499999989,0.00499999989,0.00499999989));
  r1.xyzw = v1.xyzw * r1.xyzw;
  r3.xyz = float3(-0.5,-0.5,-0.5) + r2.xyz;
  r3.xyz = -r3.xyz * float3(2,2,2) + float3(1,1,1);
  r3.xyz = -r3.xyz * r0.www + float3(1,1,1);
  r0.w = saturate(dot(r0.zz, r2.xx));
  r4.xyz = cmp(float3(0.5,0.5,0.5) >= r2.xyz);
  r5.x = r4.x ? r0.w : r3.x;
  r0.w = saturate(dot(r0.zz, r2.yy));
  r0.z = saturate(dot(r0.zz, r2.zz));
  r5.yz = r4.yz ? r0.wz : r3.yz;
  r0.yzw = r5.xyz * r0.yyy;
  r0.yzw = float3(0.800000012,0.800000012,0.800000012) * r0.yzw;
  r0.yzw = r1.xyz * float3(0.800000012,0.800000012,0.800000012) + r0.yzw;
  o0.w = saturate(r1.w);
  o0.xyz = saturate(r0.xxx * float3(0.0170000009,0.0170000009,0.0170000009) + r0.yzw);

  if (injectedData.toneMapGammaCorrection) { // fix srgb 2.2 mismatch
    o0.xyz = renodx::color::srgb::from::BT709(o0.xyz);
    o0.xyz = pow(o0.xyz, 2.2f);
  }
  o0.xyz *= injectedData.toneMapUINits/80.f;
  return;
}