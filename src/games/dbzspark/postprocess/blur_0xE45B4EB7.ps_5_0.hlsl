// ---- Created with 3Dmigoto v1.4.1 on Wed Aug 13 16:57:58 2025
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[66];
}




// 3Dmigoto declarations
#define cmp -


void main(
  linear noperspective float2 v0 : TEXCOORD0,
  float4 v1 : SV_POSITION0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = max(cb0[65].xy, v0.xy);
  r0.xy = min(cb0[65].zw, r0.xy);
  r0.xyz = t0.Sample(s0_s, r0.xy).xyz;
  r1.xy = cb0[0].ww * cb0[64].xy;
  r1.zw = r1.xy * cb0[64].zw + v0.xy;
  r1.zw = max(cb0[65].xy, r1.zw);
  r1.zw = min(cb0[65].zw, r1.zw);
  r2.xyz = t0.Sample(s0_s, r1.zw).xyz;
  r1.xy = -r1.xy * cb0[64].zw + v0.xy;
  r1.xy = max(cb0[65].xy, r1.xy);
  r1.xy = min(cb0[65].zw, r1.xy);
  r1.xyz = t0.Sample(s0_s, r1.xy).xyz;
  r1.xyz = cb0[0].zzz * r1.xyz;
  r1.xyz = r2.xyz * cb0[0].zzz + r1.xyz;
  r0.xyz = r0.xyz * cb0[0].xxx + r1.xyz;
  r1.xyz = r0.xyz;
  r0.w = 2;
  while (true) {
    r1.w = cmp((int)r0.w >= asint(cb0[63].x));
    if (r1.w != 0) break;
    r1.w = (int)r0.w ^ 2;
    r2.x = max((int)-r0.w, (int)r0.w);
    r2.x = (uint)r2.x >> 1;
    r2.y = -(int)r2.x;
    r1.w = r1.w ? -0.000000 : 0;
    r1.w = r1.w ? r2.y : r2.x;
    r2.xyzw = cb0[r1.w+0].yyww * cb0[64].xyxy;
    r3.xyzw = r2.xyzw * cb0[64].zwzw + v0.xyxy;
    r3.xyzw = max(cb0[65].xyxy, r3.xyzw);
    r3.xyzw = min(cb0[65].zwzw, r3.xyzw);
    r4.xyz = t0.Sample(s0_s, r3.xy).xyz;
    r2.xyzw = -r2.xyzw * cb0[64].zwzw + v0.xyxy;
    r2.xyzw = max(cb0[65].xyxy, r2.xyzw);
    r2.xyzw = min(cb0[65].zwzw, r2.xyzw);
    r5.xyz = t0.Sample(s0_s, r2.xy).xyz;
    r5.xyz = cb0[r1.w+0].xxx * r5.xyz;
    r4.xyz = r4.xyz * cb0[r1.w+0].xxx + r5.xyz;
    r4.xyz = r4.xyz + r1.xyz;
    r3.xyz = t0.Sample(s0_s, r3.zw).xyz;
    r2.xyz = t0.Sample(s0_s, r2.zw).xyz;
    r2.xyz = cb0[r1.w+0].zzz * r2.xyz;
    r2.xyz = r3.xyz * cb0[r1.w+0].zzz + r2.xyz;
    r1.xyz = r4.xyz + r2.xyz;
    r0.w = (int)r0.w + 2;
  }
  o0.xyz = r1.xyz;
  o0.w = 1;
  return;
}