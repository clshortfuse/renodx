// ---- Created with 3Dmigoto v1.4.1 on Tue Apr 15 14:37:19 2025
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[5];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(-0.5,-0.5) + v1.xy;
  r0.y = dot(r0.xy, r0.xy);
  r0.z = sqrt(r0.y);
  r0.z = cb0[2].y * r0.z + cb0[2].x;
  r0.y = r0.y * r0.z + 1;
  r0.y = cb0[2].z * r0.y;
  r0.x = r0.y * r0.x + 0.5;
  r0.x = cb0[3].z * 0.25 + r0.x;
  r0.x = 100 * r0.x;
  r0.x = cos(r0.x);
  r0.x = r0.x / cb0[1].w;
  r0.x = v1.y + r0.x;
  r0.x = frac(r0.x);
  r0.y = cb0[4].y * r0.x;
  r0.y = r0.y / v0.w;
  r0.z = cb0[3].z * cb0[1].y;
  r0.z = 250 * r0.z;
  r0.w = cb0[4].y * r0.z;
  r0.w = cmp(r0.w >= -r0.w);
  r0.w = r0.w ? cb0[4].y : -cb0[4].y;
  r1.x = 1 / r0.w;
  r0.z = r1.x * r0.z;
  r0.z = frac(r0.z);
  r0.y = r0.w * r0.z + r0.y;
  r0.z = cb0[4].y * cb0[1].x;
  r0.z = 0.00499999989 * r0.z;
  r0.z = floor(r0.z);
  r0.y = r0.y / r0.z;
  r0.y = (uint)r0.y;
  r0.y = (int)r0.y & 1;
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r2.xyzw = r0.yyyy ? cb0[0].xyzw : r1.xyzw;
  r0.xyzw = r1.xyzw * r0.xxxx + r2.xyzw;
  r0.xyzw = r0.xyzw + -r1.xyzw;
  o0.xyzw = cb0[1].zzzz * r0.xyzw + r1.xyzw;
  return;
}