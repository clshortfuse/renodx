// ---- Created with 3Dmigoto v1.4.1 on Sun Jun  8 21:01:31 2025
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[33];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = 0.5 * cb0[31].x;

  // disable motion blur (which was supposed to be disabled)
  r0.x = 0.f;

  r0.xy = cb0[29].zw * r0.xx;
  r1.xyzw = t1.Sample(s1_s, v1.xy).xyzw;
  r0.xy = r1.xy * r0.xy;
  r0.z = dot(r0.xy, r0.xy);
  r0.z = sqrt(r0.z);
  r0.z = cb0[32].y * r0.z;
  r0.z = max(1, r0.z);
  r0.xy = r0.xy / r0.zz;
  r0.xy = r0.xy * cb0[32].yy + float2(1,1);
  o0.xy = float2(0.5,0.5) * r0.xy;
  r0.x = 1 + -cb0[20].w;
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r0.y = cb0[21].x * r1.x;
  r0.x = r0.x * r0.y + cb0[21].y;
  r0.y = -cb0[20].w * r0.y + 1;
  o0.z = r0.y / r0.x;
  o0.w = 1;
  return;
}