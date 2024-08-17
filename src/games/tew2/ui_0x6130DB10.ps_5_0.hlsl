// ---- Created with 3Dmigoto v1.3.16 on Fri Aug 16 22:01:40 2024
// UI, Hud, Icons, Etc

#include "./shared.h"

SamplerState transmap_samp_state_s : register(s0);
Texture2D<float4> transmap_samp : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : COLOR0,
  float4 v1 : TEXCOORD0,
  float4 v2 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = transmap_samp.Sample(transmap_samp_state_s, v1.xy, int2(0, 0)).xyzw;
  r0.xz = float2(-0.517647088,-0.517647088) + r0.zx;
  r1.x = r0.w + -r0.z;
  r1.z = r1.x + -r0.x;
  r1.xy = r0.ww + r0.zx;
  r1.w = r0.y;
  r1.x = r1.x + -r0.x;
  r0.xyzw = v0.xyzw * r1.xyzw;
  r0.xyz = saturate(r0.xyz * float3(1.03100002,1.03100002,1.03100002) + float3(-0.0309999995,-0.0309999995,-0.0309999995));
  o0.xyz = r0.xyz * r0.www;
  o0.w = r0.w;
    
    o0.rgb = renodx::math::SafePow(o0.rgb, 2.2f); //2.2 gamma correction
    o0.rgb *= injectedData.toneMapUINits / 80.f; //Added ui slider
  return;
}