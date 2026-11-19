#include "./shared.h"
// Patched from 3Dmigoto decompilation of 0x73F01A45.ps_5_0 (RenoDX CS2 experiment)
// Only change: the unconditional saturate() on the scene colour was removed so
// linear values above 1.0 survive into the Intermediate Postprocess buffer.
Texture2DArray<float4> t3 : register(t3);

Texture2DArray<float4> t2 : register(t2);

Texture2DArray<float4> t1 : register(t1);

Texture2DArray<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1)
{
  float4 cb1[80];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[6];
}


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb1[46].xy * v1.xy;
  r0.xy = (uint2)r0.xy;
  r0.xy = (uint2)r0.xy;
  r0.zw = float2(-1,-1) + cb1[46].xy;
  r0.zw = cb0[3].zw * r0.zw;
  r0.xy = r0.xy * cb0[3].xy + r0.zw;
  r0.xy = (uint2)r0.xy;
  r0.zw = float2(0,0);
  r1.xyz = t0.Load(r0.xyww).xyz;
  // RenoDX intermediate scaling: scene white point is Game Brightness (diffuse),
  // while the swapchain scales by UI Brightness (graphics). Dividing here keeps
  // the scene independent from the UI brightness knob.
  r1.xyz = r1.xyz * clamp(RENODX_DIFFUSE_WHITE_NITS / max(RENODX_GRAPHICS_WHITE_NITS, 1.f), 0.1f, 10.f);
  r0.x = t3.Load(r0.xyzw).x;
  // VANILLA: r1.xyz = saturate(r1.xyz);
  r0.yzw = log2(r1.xyz);
  r0.yzw = float3(0.416666657,0.416666657,0.416666657) * r0.yzw;
  r0.yzw = exp2(r0.yzw);
  r0.yzw = r0.yzw * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  r2.xyz = cmp(float3(0.00313080009,0.00313080009,0.00313080009) >= r1.xyz);
  r1.xyz = float3(12.9232101,12.9232101,12.9232101) * r1.xyz;
  r0.yzw = r2.xyz ? r1.xyz : r0.yzw;
  r1.z = cb0[2].z;
  r2.xy = v1.xy * cb0[3].xy + cb0[3].zw;
  r1.xy = cb0[2].xy * r2.xy;
  r2.xy = cb1[48].xy * r2.xy;
  r1.x = t2.SampleBias(s1_s, r1.xyz, cb1[79].y).w;
  r1.x = r1.x * 2 + -1;
  r1.y = 1 + -abs(r1.x);
  r1.x = cmp(r1.x >= 0);
  r1.x = r1.x ? 1 : -1;
  r1.y = sqrt(r1.y);
  r1.y = 1 + -r1.y;
  r1.x = r1.x * r1.y;
  r0.yzw = r1.xxx * float3(0.00392156886,0.00392156886,0.00392156886) + r0.yzw;
  r1.xyz = float3(0.0549999997,0.0549999997,0.0549999997) + r0.yzw;
  r1.xyz = float3(0.947867334,0.947867334,0.947867334) * r1.xyz;
  r1.xyz = log2(abs(r1.xyz));
  r1.xyz = float3(2.4000001,2.4000001,2.4000001) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r3.xyz = float3(0.0773993805,0.0773993805,0.0773993805) * r0.yzw;
  r0.yzw = cmp(float3(0.0404499993,0.0404499993,0.0404499993) >= r0.yzw);
  r0.yzw = r0.yzw ? r3.xyz : r1.xyz;
  r2.z = 0;
  r1.xyzw = t1.SampleLevel(s0_s, r2.xyz, 0).xyzw;
  o0.xyz = r1.www * r0.yzw + r1.xyz;
  r0.y = cmp(cb0[5].x == 1.000000);
  o0.w = r0.y ? r0.x : 1;
  return;
}
