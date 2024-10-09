// ---- Created with 3Dmigoto v1.3.16 on Sun Sep 29 03:09:50 2024
// Movies 1 (Intro Movies)

#include "./shared.h"

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1)
{
  float4 cb1[11];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[39];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = asuint(cb0[37].xy);
  r0.xy = v0.xy + -r0.xy;
  r0.z = cmp(0 >= cb1[7].y);
  r0.w = log2(cb1[7].y);
  r0.w = 0.45449999 * r0.w;
  r0.w = exp2(r0.w);
  r0.z = r0.z ? 0 : r0.w;
  r1.xy = float2(-2,-1.10000002) + cb1[7].zw;
  r0.zw = r0.zz * r1.xy + float2(2,1.10000002);
  r1.xy = r0.xy * cb0[38].zw + float2(-0.5,-0.5);
  r1.xy = cb1[1].xy * r1.xy;
  r1.x = dot(r1.xy, r1.xy);
  r1.x = sqrt(r1.x);
  r1.x = r1.x + -r0.z;
  r0.z = r0.w + -r0.z;
  r0.z = saturate(r1.x / r0.z);
  r0.w = r0.z * r0.z;
  r0.z = -r0.z * 2 + 3;
  r0.z = r0.w * r0.z;
  r0.z = min(1, r0.z);
  r1.xy = r0.xy * cb0[38].zw + -cb1[10].yz;
  r0.w = -1 + cb1[10].x;
  r2.xyz = float3(0,0,0);
  r1.z = 0;
  while (true) {
    r1.w = (int)r1.z;
    r2.w = cmp(r1.w >= cb1[10].x);
    if (r2.w != 0) break;
    r1.w = r1.w / r0.w;
    r3.xyzw = cb1[4].zzww * r1.wwww + cb1[4].yyzz;
    r1.w = cb1[5].y * r1.w + cb1[5].x;
    r3.xyzw = r1.xyxy * r3.xyzw + cb1[10].yzyz;
    r4.xyzw = r0.xyxy * cb0[38].zwzw + -r3.xyzw;
    r3.xyzw = r0.zzzz * r4.xyzw + r3.xyzw;
    r4.xy = r1.xy * r1.ww + cb1[10].yz;
    r4.zw = r0.xy * cb0[38].zw + -r4.xy;
    r4.xy = r0.zz * r4.zw + r4.xy;
    r3.xyzw = r3.xyzw * cb0[5].xyxy + cb0[4].xyxy;
    r1.w = t0.Sample(s0_s, r3.xy).x;
    r2.x = r2.x + r1.w;
    r1.w = t0.Sample(s0_s, r3.zw).y;
    r2.y = r2.y + r1.w;
    r3.xy = r4.xy * cb0[5].xy + cb0[4].xy;
    r1.w = t0.Sample(s0_s, r3.xy).z;
    r2.z = r2.z + r1.w;
    r1.z = (int)r1.z + 1;
  }
  r0.xyz = r2.xyz / cb1[10].xxx;
  r1.xyz = cb1[6].xyz + -r0.xyz;
  r0.xyz = cb1[10].www * r1.xyz + r0.xyz;
    if (injectedData.toneMapType == 0){
        o0.xyz = max(float3(0, 0, 0), r0.xyz);
    }
    else{
        o0.rgb = r0.xyz; //unclamp rec709
    }
  o0.w = 1;
  
  // o0.rgb = renodx::math::SafePow(o0.rgb, 2.2f); //2.2 gamma correction
  //o0.rgb *= injectedData.toneMapGameNits / 80.f; //Added ui slider
  return;
}