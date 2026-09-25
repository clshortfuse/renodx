#include "../../common.hlsli"

Texture2DArray<float4> t0 : register(t0);
cbuffer cb1 : register(b1){
  float4 cb1[52];
}
cbuffer cb0 : register(b0){
  float4 cb0[5];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(-0.5,-0.5) + v1.xy;
  r0.x = dot(r0.xy, cb0[1].yz);
  r0.x = 0.5 + r0.x;
  r0.y = -cb0[3].w + r0.x;
  r0.x = -cb0[2].w + r0.x;
  r0.z = cb0[4].w + -cb0[3].w;
  r0.y = saturate(r0.y / r0.z);
  r1.xyzw = cb0[3].wxyz + -cb0[2].wxyz;
  r0.x = saturate(r0.x / r1.x);
  r0.xzw = r0.xxx * r1.yzw + cb0[2].xyz;
  r1.xyz = cb0[4].xyz + -r0.xzw;
  r0.xyz = r0.yyy * r1.xyz + r0.xzw;
  r0.w = cb0[0].w;
  r1.xyzw = float4(1,1,1,1) + -r0.xyzw;
  r2.xy = cb1[51].xy * v1.xy;
  r2.xy = (uint2)r2.xy;
  r2.zw = float2(0,0);
  r2.xyzw = t0.Load(r2.xyzw).xyzw;
  r2.xyz = renodx::color::srgb::EncodeSafe(r2.xyz);
  r3.xyzw = float4(1,1,1,1) + -r2.xyzw;
  r1.xyzw = r3.xyzw * r1.xyzw;
  r1.xyzw = -r1.xyzw * float4(2,2,2,2) + float4(1,1,1,1);
  r0.xyzw = r2.xyzw * r0.xyzw;
  r1.xyzw = -r0.xyzw * float4(2,2,2,2) + r1.xyzw;
  r0.xyzw = r0.xyzw + r0.xyzw;
  r3.xyzw = r2.xyzw > float4(0.5,0.5,0.5,0.5) ? float4(1,1,1,1) : 0;
  r0.xyzw = r3.xyzw * r1.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + -r2.xyzw;
  r0.xyzw = cb0[0].wwww * r0.xyzw + r2.xyzw;
  r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  o0.xyzw = r0.xyzw;
  return;
}