#include "C:\Users\Adrian\Documents\VSrepos\akuru\renodx\src\shaders\renodx.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Sat Mar  1 01:01:22 2025
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[7];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float2 v0 : TEXCOORD0,
  float4 v1 : SV_POSITION0,
  float4 v2 : COLOR0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = v0.y * 2 + -2;
  r0.y = -v2.w * 1.20000005 + 1;
  r0.x = r0.x + r0.y;
  r1.y = 0.200000003 + r0.x;
  r1.xz = v0.xx;
  r2.xyzw = t0.Sample(s1_s, r1.xy).xyzw;
  r0.x = v0.y * -2 + r0.y;
  r1.w = 0.200000003 + r0.x;
  r0.xyzw = t0.Sample(s1_s, r1.zw).xyzw;
  r0.y = cmp(v2.w < 0.99000001);
  if (r0.y != 0) {
    r0.yz = float2(-0.5,-0.5) + v0.xy;
    r0.w = dot(r0.yz, r0.yz);
    r1.x = sqrt(r0.w);
    r1.y = cmp(r1.x >= 0.00999999978);
    if (r1.y != 0) {
      r1.y = 1 + -v2.w;
      r1.y = -r1.y * cb0[3].y + 0.00100000005;
      r1.yz = float2(4.44288206,-22.2144108) * r1.yy;
      r0.w = rsqrt(r0.w);
      r0.yz = r0.yz * r0.ww;
      r0.w = r1.x * -r1.y;
      r0.w = 10 * r0.w;
      r1.x = min(1, abs(r0.w));
      r1.y = max(1, abs(r0.w));
      r1.y = 1 / r1.y;
      r1.x = r1.x * r1.y;
      r1.y = r1.x * r1.x;
      r1.w = r1.y * 0.0208350997 + -0.0851330012;
      r1.w = r1.y * r1.w + 0.180141002;
      r1.w = r1.y * r1.w + -0.330299497;
      r1.y = r1.y * r1.w + 0.999866009;
      r1.w = r1.x * r1.y;
      r2.y = cmp(1 < abs(r0.w));
      r1.w = r1.w * -2 + 1.57079637;
      r1.w = r2.y ? r1.w : 0;
      r1.x = r1.x * r1.y + r1.w;
      r0.w = min(1, r0.w);
      r0.w = cmp(r0.w < -r0.w);
      r0.w = r0.w ? -r1.x : r1.x;
      r0.yz = r0.yz * r0.ww;
      r0.yz = float2(0.5,0.5) * r0.yz;
      r0.w = min(1, abs(r1.z));
      r1.x = max(1, abs(r1.z));
      r1.x = 1 / r1.x;
      r0.w = r1.x * r0.w;
      r1.x = r0.w * r0.w;
      r1.y = r1.x * 0.0208350997 + -0.0851330012;
      r1.y = r1.x * r1.y + 0.180141002;
      r1.y = r1.x * r1.y + -0.330299497;
      r1.x = r1.x * r1.y + 0.999866009;
      r1.y = r1.x * r0.w;
      r1.w = cmp(1 < abs(r1.z));
      r1.y = r1.y * -2 + 1.57079637;
      r1.y = r1.w ? r1.y : 0;
      r0.w = r0.w * r1.x + r1.y;
      r1.x = min(1, r1.z);
      r1.x = cmp(r1.x < -r1.x);
      r0.w = r1.x ? -r0.w : r0.w;
      r0.yz = r0.yz / r0.ww;
      r0.yz = float2(0.5,0.5) + r0.yz;
    } else {
      r0.yz = v0.xy;
    }
  } else {
    r0.yz = v0.xy;
  }
  r1.xyzw = t1.Sample(s0_s, r0.yz).xyzw;
  r0.y = 1 + -v2.w;
  r0.y = r0.y * r0.y;
  r0.y = cb0[6].x * r0.y;
  r0.yzw = r0.yyy * cb0[4].xyz + r1.xyz;
  r0.x = saturate(r2.x * r0.x);
  //o0.xyz = saturate(r0.yzw * r0.xxx);
  o0.xyz = (r0.yzw * r0.xxx);
  o0.w = saturate(r1.w);
  return;
}