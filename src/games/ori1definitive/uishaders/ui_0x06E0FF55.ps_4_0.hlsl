#include "../common.hlsl"

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[32];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float3 v3 : TEXCOORD2,
  float4 v4 : COLOR0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = ddx(v2.x);
  r0.x = 0.5 * r0.x;
  r0.y = 0;
  r0.xy = v2.xy + r0.xy;
  r1.xyzw = t1.SampleLevel(s1_s, r0.xy, 0).xyzw;
  r2.xyzw = t1.SampleLevel(s1_s, r0.xy, 1).xyzw;
  r0.z = r2.w + r1.w;
  r1.xyzw = t1.SampleLevel(s1_s, r0.xy, 2).xyzw;
  r2.xyzw = t1.SampleLevel(s1_s, r0.xy, 3).xyzw;
  r0.x = r1.w + r0.z;
  r0.x = r0.x + r2.w;
  r1.xyzw = t1.SampleLevel(s1_s, v2.xy, 0).xyzw;
  r2.xyzw = t1.SampleLevel(s1_s, v2.xy, 1).xyzw;
  r0.y = r2.w + r1.w;
  r1.xyzw = t1.SampleLevel(s1_s, v2.xy, 2).xyzw;
  r0.y = r1.w + r0.y;
  r1.xyzw = t1.SampleLevel(s1_s, v2.xy, 3).xyzw;
  r0.y = r1.w + r0.y;
  r0.z = 0.25 * r0.y;
  r0.w = ddx(r0.z);
  r0.z = ddy(r0.z);
  r0.z = abs(r0.w) + abs(r0.z);
  r0.w = -r0.z * 0.5 + cb0[22].x;
  r0.z = r0.z * 0.5 + cb0[22].x;
  r0.z = r0.z + -r0.w;
  r0.z = 1 / r0.z;
  r0.x = r0.x * 0.25 + -r0.w;
  r0.y = r0.y * 0.25 + -r0.w;
  r0.xy = saturate(r0.xy * r0.zz);
  r0.z = r0.x * -2 + 3;
  r0.x = r0.x * r0.x;
  r0.x = r0.z * r0.x;
  r0.z = r0.y * -2 + 3;
  r0.y = r0.y * r0.y;
  r0.x = r0.z * r0.y + r0.x;
  r0.x = 0.5 * r0.x;
  r0.x = min(1, r0.x);
  r0.x = sqrt(r0.x);
  r0.yz = saturate(v1.yx);
  r0.yz = -cb0[20].yx + r0.yz;
  r0.yz = saturate(r0.yz / cb0[20].wz);
  r1.xy = cb0[7].yy * r0.yz;
  r0.w = 1 + -cb0[7].y;
  r0.yz = r0.zy * r0.ww + r1.xy;
  r0.yz = r0.yz * cb0[19].zw + cb0[19].xy;
  r1.xyzw = t0.Sample(s0_s, r0.yz).xyzw;
  r0.y = -r0.x * r1.w + 1;
  r0.zw = -cb0[28].xy + v2.xy;
  r2.xyzw = t1.SampleLevel(s1_s, r0.zw, 0).xyzw;
  r3.xyzw = t1.SampleLevel(s1_s, r0.zw, 1).xyzw;
  r2.x = r3.w + r2.w;
  r3.xyzw = t1.SampleLevel(s1_s, r0.zw, 2).xyzw;
  r4.xyzw = t1.SampleLevel(s1_s, r0.zw, 3).xyzw;
  r0.z = r3.w + r2.x;
  r0.z = r0.z + r4.w;
  r0.w = -0.0250000004 + cb0[22].x;
  r0.z = r0.z * 0.25 + -r0.w;
  r0.z = saturate(20 * r0.z);
  r0.w = r0.z * -2 + 3;
  r0.z = r0.z * r0.z;
  r2.x = -r0.w * r0.z + 1;
  r0.z = r0.w * r0.z;
  r2.xyz = r2.xxx * r1.xyz;
  r2.xyz = cb0[27].xyz * r0.zzz + r2.xyz;
  r0.z = saturate(r0.x * r1.w + r0.z);
  r0.x = r1.w * r0.x;
  r2.xyz = r2.xyz * r0.yyy;
  r1.xyz = r1.xyz * r0.xxx + r2.xyz;
  r0.x = saturate(-cb0[26].x + v3.x);
  r0.x = cb0[31].x * r0.x;
  r2.xyzw = t2.Sample(s2_s, v2.zw).xyzw;
  r0.y = -1 + r2.x;
  r0.x = r0.x * r0.y + 1;
  r1.w = r0.z * r0.x;
  r0.xyzw = cb0[21].xyzw + cb0[21].xyzw;
  r0.xyzw = r1.xyzw * r0.xyzw;
  o0.xyzw = v4.xyzw * r0.xyzw;

  o0 = ClampUI(o0);
  return;
}