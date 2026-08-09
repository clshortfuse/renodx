#include "../common.hlsl"

Texture2D<float4> t0 : register(t0);
cbuffer cb1 : register(b1){
  float4 cb1[3];
}
cbuffer cb0 : register(b0){
  float4 cb0[121];
}

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : INTERP0,
  float4 v2 : INTERP1,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.y = cb1[0].x;
  r0.xz = float2(0,0);
  r1.xyzw = v1.xyxy + r0.yxxy;
  r1.xyzw = cb0[120].xyxy * r1.xyzw;
  r2.xy = (uint2)r1.xy;
  r1.xy = (uint2)r1.zw;
  r2.zw = float2(0,0);
  r2.xyzw = t0.Load(r2.xyz).xyzw;
  r1.zw = float2(0,0);
  r1.xyzw = t0.Load(r1.xyz).xyzw;
  r1.xyz = r2.xyz + r1.xyz;
  r0.w = -cb1[0].x;
  r0.xyzw = v1.xyxy + r0.wzzw;
  r0.xyzw = cb0[120].xyxy * r0.xyzw;
  r2.xy = (uint2)r0.xy;
  r0.xy = (uint2)r0.zw;
  r2.zw = float2(0,0);
  r2.xyzw = t0.Load(r2.xyz).xyzw;
  r0.zw = float2(0,0);
  r0.xyzw = t0.Load(r0.xyz).xyzw;
  r0.xyz = r2.xyz + r0.xyz;
  r0.xyz = r1.xyz + r0.xyz;
  r1.xyz = renodx::color::srgb::Encode(abs(cb1[1].xyz));
  r0.xyz = r1.xyz * r0.xyz;
  r0.w = cb1[2].x * cb0[19].x + v1.y;
  r0.w = 0.5 + r0.w;
  r1.x = r0.w * 200 + 0.25;
  r0.xyzw = float4(0.5,0.5,0.5,200) * r0.xyzw;
  r1.x = frac(r1.x);
  r1.x = -0.5 + r1.x;
  r1.x = abs(r1.x) * 4 + -1;
  r2.x = ddx(r0.w);
  r2.y = ddy(r0.w);
  r0.w = dot(r2.xy, r2.xy);
  r0.w = sqrt(r0.w);
  r1.y = 0.35 / r0.w;
  r0.w = saturate(1.1 + -r0.w);
  r0.w = sqrt(r0.w);
  r1.x = r1.x * r1.y;
  r1.x = max(-1, r1.x);
  r1.x = min(1, r1.x);
  r0.w = r1.x * r0.w;
  r0.w = r0.w * -0.5 + 0.5;
  r0.w = r0.w * 0.5 + 0.2;
  o0.xyz = r0.xyz * r0.www;
  o0.w = 1;
  if (injectedData.countOld == injectedData.countNew) {
    o0.xyz = renodx::color::srgb::DecodeSafe(o0.xyz);
    o0.xyz = PostToneMapScale(o0.xyz, true);
  }
  return;
}