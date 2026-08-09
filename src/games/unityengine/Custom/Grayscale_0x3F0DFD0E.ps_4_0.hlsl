#include "../shared.h"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[29];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cb0[22].x / cb0[22].y;
  r1.xyw = float3(-0.5,-0.5,-0.5) + v1.xyy;
  r1.z = r1.x * r0.x;
  r0.x = max(abs(r1.y), abs(r1.z));
  r0.x = 1 / r0.x;
  r0.y = min(abs(r1.y), abs(r1.z));
  r0.x = r0.y * r0.x;
  r0.y = r0.x * r0.x;
  r0.z = r0.y * 0.0208350997 + -0.0851330012;
  r0.z = r0.y * r0.z + 0.180141002;
  r0.z = r0.y * r0.z + -0.330299497;
  r0.y = r0.y * r0.z + 0.999866009;
  r0.z = r0.x * r0.y;
  r0.z = r0.z * -2 + 1.57079637;
  r0.z = abs(r1.z) < abs(r1.y) ? r0.z : 0;
  r0.x = r0.x * r0.y + r0.z;
  r0.y = r1.z < -r1.z ? -3.141593 : 0;
  r0.x = r0.x + r0.y;
  r0.y = min(r1.y, r1.z);
  r0.z = max(r1.y, r1.z);
  r0.w = dot(r1.zw, r1.zw);
  r2.y = sqrt(r0.w);
  r2.x = ((r0.z >= -r0.z) ? (r0.y < -r0.y) : false) ? -r0.x : r0.x;
  r0.xy = float2(0.159235656,0.166666672) * r2.xy;
  r0.y = cb0[23].y * -0.25 + r0.y;
  r0.xyzw = t1.Sample(s1_s, r0.xy).xyzw;
  r0.xy = r0.ww * float2(2,2) + float2(-1,-0.5);
  r0.z = v1.x * 2 + -1;
  r0.y = abs(r0.z) * r0.y;
  r0.z = abs(r0.z) * abs(r0.z);
  r0.y = 0.05 * r0.y;
  r0.y = -r0.y * cb0[28].x + 1;
  r0.w = r1.x * r0.y;
  r1.xy = r1.xy * r0.yy + float2(0.5,0.5);
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r0.y = abs(r0.w) * 0.5 + 1;
  if(injectedData.toneMapType == 0.f){
  r2.xyzw = log2(r1.xyzw);
  r2.xyzw = r2.xyzw * r0.yyyy;
  r2.xyzw = exp2(r2.xyzw);
  } else {
    r2.xyzw = renodx::math::SignPow(r1.xyzw, r0.y);
  }
  r3.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r2.xyzw = -r3.xyzw + r2.xyzw;
  r2.xyzw = cb0[28].xxxx * r2.xyzw + r3.xyzw;
  r0.y = max(r1.x, r1.y);
  r0.w = cb0[28].x * r0.z;
  r0.z = -r0.z * cb0[28].x + 1;
  r0.y = r0.y * r0.w;
  r0.zw = cb0[28].xx * r0.zw;
  r0.w = r0.w * r1.y;
  r0.x = r0.w * r0.x;
  o0.y = r0.x * 0.05 + r2.y;
  r0.x = -r0.y * 0.75 + r2.x;
  o0.zw = r2.zw;
  r0.y = r0.z * r0.x;
  o0.x = r0.y * 0.4 + r0.x;
  return;
}