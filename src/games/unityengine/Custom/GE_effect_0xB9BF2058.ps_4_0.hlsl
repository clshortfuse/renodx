#include "../shared.h"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[5];
}
cbuffer cb0 : register(b0){
  float4 cb0[131];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : INTERP0,
  float4 v2 : INTERP1,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = cb0[128].yyyy * cb0[77].xyzw;
  r0.xyzw = cb0[76].xyzw * cb0[128].xxxx + r0.xyzw;
  r0.xyzw = cb0[78].xyzw * cb0[128].zzzz + r0.xyzw;
  r0.xyzw = cb0[79].xyzw + r0.xyzw;
  r0.xyz = r0.xyz / r0.www;
  r0.xyz = r0.xyz * float3(0.5,-0.5,1) + float3(0.5,0.5,0);
  r1.z = 0;
  r1.xy = v1.xy;
  r0.xyz = -r1.xyz + r0.xyz;
  r2.x = cb0[129].z / cb0[129].w;
  r2.yz = float2(1,1);
  r0.xyz = r2.xyz * r0.xyz;
  r0.w = max(abs(r0.x), abs(r0.y));
  r0.w = 1 / r0.w;
  r1.z = min(abs(r0.x), abs(r0.y));
  r0.w = r1.z * r0.w;
  r1.z = r0.w * r0.w;
  r1.w = r1.z * 0.0208350997 + -0.0851330012;
  r1.w = r1.z * r1.w + 0.180141002;
  r1.w = r1.z * r1.w + -0.330299497;
  r1.z = r1.z * r1.w + 0.999866009;
  r1.w = r1.z * r0.w;
  r1.w = r1.w * -2 + 1.57079637;
  //r2.x = cmp(abs(r0.y) < abs(r0.x));
  r1.w = abs(r0.y) < abs(r0.x) ? r1.w : 0;
  r0.w = r0.w * r1.z + r1.w;
  //r1.z = cmp(r0.y < -r0.y);
  r1.z = r0.y < -r0.y ? -3.141593 : 0;
  r0.w = r1.z + r0.w;
  r1.z = min(r0.x, r0.y);
  //r1.z = cmp(r1.z < -r1.z);
  r1.w = max(r0.x, r0.y);
  //r1.w = cmp(r1.w >= -r1.w);
  r1.z = (r1.w >= -r1.w) ? (r1.z < -r1.z) : 0;
  r0.w = r1.z ? -r0.w : r0.w;
  r2.y = 0.318471313 * r0.w;
  r0.w = dot(r0.xy, r0.xy);
  r0.x = dot(r0.xyz, r0.xyz);
  r0.xy = sqrt(r0.xw);
  r0.x = cb0[130].x * -0.05 + r0.x;
  r0.x = frac(r0.x);
  r0.z = 0.2 * cb0[19].x;
  r2.x = r0.y * 0.4 + r0.z;
  r2.xyzw = t0.SampleBias(s1_s, r2.xy, cb0[5].x).xyzw;
  r3.xyzw = float4(-0.0617685206,-0.111772299,-0.149996206,-0.211764693) + r0.xxxx;
  r0.xz = float2(-0.300007612,-0.379415601) + r0.xx;
  r0.xz = saturate(float2(12.5931911,1.92089021) * r0.xz);
  r3.xyzw = saturate(float4(19.9984894,26.1616364,16.1894855,11.3323545) * r3.xyzw);
  r0.w = r3.y * -r3.x + r3.x;
  r0.w = r3.z * -r0.w + r0.w;
  r1.z = 1 + -r0.w;
  r0.w = r3.w * r1.z + r0.w;
  r0.x = r0.x * -r0.w + r0.w;
  r0.x = r0.z * -r0.x + r0.x;
  r0.z = r0.x * r2.x;
  r0.xw = v1.xy * r0.xx;
  r0.xw = cb1[2].xx * r0.xw;
  r1.z = 0.5 * r2.x;
  r0.z = r0.z * 0.5 + r1.z;
  r1.zw = float2(-2.2,-0) + cb1[2].zw;
  r1.zw = cb1[2].xx * r1.zw + float2(2.2,0);
  r2.y = -r1.z + r0.y;
  r1.z = r1.w + -r1.z;
  r1.z = 1 / r1.z;
  r1.z = saturate(r2.y * r1.z);
  r1.w = r1.z * -2 + 3;
  r1.z = r1.z * r1.z;
  r1.z = r1.w * r1.z;
  r1.z = min(1, r1.z);
  r0.z = saturate(-r1.z + r0.z);
  r1.z = r2.x * 0.8 + -r1.z;
  r1.z = saturate(r1.z + r0.z);
  r1.z = saturate(dot(cb1[2].xx, r1.zz));
  r1.w = -cb1[3].x + r0.y;
  r0.y = -0.75 + r0.y;
  r0.y = saturate(6.66666794 * r0.y);
  r2.x = 1 / -cb1[3].y;
  r1.w = saturate(r2.x * r1.w);
  r2.x = r1.w * -2 + 3;
  r1.w = r1.w * r1.w;
  r1.w = r2.x * r1.w;
  r1.w = min(1, r1.w);
  r1.w = 1 + -r1.w;
  r1.w = cb1[2].x * r1.w;
  r1.z = max(r1.z, r1.w);
  r2.xy = r0.zz * cb1[2].yy + v1.xy;
  r0.z = 9.99999996e-13 + r0.z;
  r0.xw = r0.xw * float2(0.0199999996,0.0199999996) + r2.xy;
  r0.xw = r0.xw + -r1.xy;
  r0.xw = cb1[2].xx * r0.xw + v1.xy;
  r2.xyzw = t1.SampleBias(s0_s, r0.xw, cb0[5].x).xyzw;
  r1.xyw = r2.xyz * cb1[4].xyz + -r2.xyz;
  r1.xyz = r1.zzz * r1.xyw + r2.xyz;
  if(injectedData.toneMapType == 0.f){
    r1.xyz = saturate(r1.xyz);
  }
  r0.x = r0.y * -2 + 3;
  r0.y = r0.y * r0.y;
  r0.x = r0.x * r0.y;
  r0.x = min(1, r0.x);
  r0.x = -cb1[2].x * r0.x + 1;
  r0.x = r0.x / r0.z;
  r0.x = saturate(1 + -r0.x);
  r0.x = 10 * r0.x;
  r0.x = min(1, r0.x);
  o0.xyz = r1.xyz + -r0.xxx;
  o0.w = 1;
  return;
}