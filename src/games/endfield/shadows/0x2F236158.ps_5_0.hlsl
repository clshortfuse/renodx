// ---- Created with 3Dmigoto v1.4.1 on Sat Jan 24 04:33:32 2026
Texture2D<float4> t0 : register(t0);

cbuffer cb0 : register(b0)
{
  float4 cb0[1];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.zw = float2(0,0);
  r1.xyzw = (int4)v0.xyxy;
  r2.xyzw = (int4)r1.zwzw + int4(-3,0,-2,0);
  r2.xyzw = (int4)r2.xyzw;
  r2.xyzw = max(float4(0,0,0,0), r2.xyzw);
  r3.xyzw = cb0[0].zwzw + float4(-1,-1,-1,-1);
  r2.xyzw = min(r3.xyzw, r2.xyzw);
  r2.xyzw = (uint4)r2.xyzw;
  r0.xy = r2.zw;
  r0.x = t0.Load(r0.xyz).x;
  r0.x = 0.142857149 * r0.x;
  r2.zw = float2(0,0);
  r0.y = t0.Load(r2.xyz).x;
  r0.x = r0.y * 0.142857149 + r0.x;
  r2.xyzw = (int4)r1.zwzw + int4(-1,0,1,0);
  r1.xyzw = (int4)r1.xyzw + int4(2,0,3,0);
  r1.xyzw = (int4)r1.xyzw;
  r1.xyzw = max(float4(0,0,0,0), r1.xyzw);
  r1.xyzw = min(r1.xyzw, r3.xyzw);
  r1.xyzw = (uint4)r1.zwxy;
  r2.xyzw = (int4)r2.xyzw;
  r2.xyzw = max(float4(0,0,0,0), r2.xyzw);
  r2.xyzw = min(r2.xyzw, r3.xyzw);
  r2.xyzw = (uint4)r2.zwxy;
  r4.xy = r2.zw;
  r4.zw = float2(0,0);
  r0.y = t0.Load(r4.xyz).x;
  r0.x = r0.y * 0.142857149 + r0.x;
  r0.yz = trunc(v0.xy);
  r0.yz = max(float2(0,0), r0.yz);
  r0.yz = min(r0.yz, r3.xy);
  r3.xy = (uint2)r0.yz;
  r3.zw = float2(0,0);
  r0.y = t0.Load(r3.xyz).x;
  r0.x = r0.y * 0.142857149 + r0.x;
  r2.zw = float2(0,0);
  r0.y = t0.Load(r2.xyz).x;
  r0.x = r0.y * 0.142857149 + r0.x;
  r2.xy = r1.zw;
  r2.zw = float2(0,0);
  r0.y = t0.Load(r2.xyz).x;
  r0.x = r0.y * 0.142857149 + r0.x;
  r1.zw = float2(0,0);
  r0.y = t0.Load(r1.xyz).x;
  o0.xyz = r0.yyy * float3(0.142857149,0.142857149,0.142857149) + r0.xxx;
  o0.w = 1;
  return;
}