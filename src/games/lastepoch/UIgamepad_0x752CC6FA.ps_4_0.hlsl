#include "./common.hlsl"

cbuffer cb1 : register(b1){
  float4 cb1[7];
}
cbuffer cb0 : register(b0){
  float4 cb0[6];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = 4 * cb0[3].w;
  r0.x = sin(r0.x);
  r0.x = r0.x * cb0[4].x + cb0[3].z;
  r0.y = cb0[4].y + r0.x;
  r0.zw = v1.xy / v1.ww;
  r0.zw = r0.zw * cb1[6].xy + -cb0[2].xy;
  r1.x = asint(cb0[2].w);
  r1.xy = float2(3.14159274,6.28318548) / r1.xx;
  r1.x = cb0[2].z * r1.x;
  sincos(r1.x, r1.x, r2.x);
  r3.z = r1.x;
  r3.y = r2.x;
  r3.x = -r1.x;
  r1.x = dot(r0.zw, r3.xy);
  r0.z = dot(r0.zw, r3.yz);
  r0.w = cmp(r0.z >= 0);
  r1.z = r0.w ? 0 : 1;
  r1.w = cb0[3].x + r0.z;
  r1.z = r1.z * r1.w;
  r1.w = -cb0[3].x + r0.z;
  r0.z = -cb0[3].x + abs(r0.z);
  r0.z = cmp(r0.z >= 0);
  r0.zw = r0.zw ? float2(1,1) : 0;
  r0.w = r0.w * r1.w + r1.z;
  r2.x = r0.z * r0.w;
  r0.z = cb0[3].y + r1.x;
  r0.w = cmp(r1.x >= 0);
  r1.z = r0.w ? 0 : 1;
  r0.w = r0.w ? 1.000000 : 0;
  r0.z = r1.z * r0.z;
  r1.z = -cb0[3].y + r1.x;
  r1.x = -cb0[3].y + abs(r1.x);
  r1.x = cmp(r1.x >= 0);
  r1.x = r1.x ? 1.000000 : 0;
  r0.z = r0.w * r1.z + r0.z;
  r2.y = r1.x * r0.z;
  r0.xyzw = r2.xxyy / r0.xyyx;
  r1.x = max(abs(r0.y), abs(r0.z));
  r1.x = 1 / r1.x;
  r1.z = min(abs(r0.y), abs(r0.z));
  r1.x = r1.z * r1.x;
  r1.z = r1.x * r1.x;
  r1.w = r1.z * 0.0208350997 + -0.0851330012;
  r1.w = r1.z * r1.w + 0.180141002;
  r1.w = r1.z * r1.w + -0.330299497;
  r1.z = r1.z * r1.w + 0.999866009;
  r1.w = r1.x * r1.z;
  r1.w = r1.w * -2 + 1.57079637;
  r2.x = cmp(abs(r0.z) < abs(r0.y));
  r1.w = r2.x ? r1.w : 0;
  r1.x = r1.x * r1.z + r1.w;
  r1.z = cmp(r0.z < -r0.z);
  r1.z = r1.z ? -3.141593 : 0;
  r1.x = r1.x + r1.z;
  r1.z = min(r0.y, r0.z);
  r1.z = cmp(r1.z < -r1.z);
  r1.w = max(r0.y, r0.z);
  r0.y = dot(r0.yz, r0.yz);
  r0.y = sqrt(r0.y);
  r0.z = cmp(r1.w >= -r1.w);
  r0.z = r0.z ? r1.z : 0;
  r0.z = r0.z ? -r1.x : r1.x;
  r0.z = 3.14159274 + r0.z;
  r1.x = r0.z / r1.y;
  r1.x = 0.5 + r1.x;
  r1.x = floor(r1.x);
  r0.z = r1.x * r1.y + -r0.z;
  r0.z = cos(r0.z);
  r0.y = r0.z * r0.y + -0.5;
  r0.y = saturate(100.000099 * r0.y);
  r0.z = r0.y * -2 + 3;
  r0.y = r0.y * r0.y;
  r0.y = -r0.z * r0.y + 1;
  r0.z = max(abs(r0.x), abs(r0.w));
  r0.z = 1 / r0.z;
  r1.x = min(abs(r0.x), abs(r0.w));
  r0.z = r1.x * r0.z;
  r1.x = r0.z * r0.z;
  r1.z = r1.x * 0.0208350997 + -0.0851330012;
  r1.z = r1.x * r1.z + 0.180141002;
  r1.z = r1.x * r1.z + -0.330299497;
  r1.x = r1.x * r1.z + 0.999866009;
  r1.z = r1.x * r0.z;
  r1.z = r1.z * -2 + 1.57079637;
  r1.w = cmp(abs(r0.w) < abs(r0.x));
  r1.z = r1.w ? r1.z : 0;
  r0.z = r0.z * r1.x + r1.z;
  r1.x = cmp(r0.w < -r0.w);
  r1.x = r1.x ? -3.141593 : 0;
  r0.z = r1.x + r0.z;
  r1.x = min(r0.x, r0.w);
  r1.x = cmp(r1.x < -r1.x);
  r1.z = max(r0.x, r0.w);
  r0.x = dot(r0.xw, r0.xw);
  r0.x = sqrt(r0.x);
  r0.w = cmp(r1.z >= -r1.z);
  r0.w = r0.w ? r1.x : 0;
  r0.z = r0.w ? -r0.z : r0.z;
  r0.z = 3.14159274 + r0.z;
  r0.w = r0.z / r1.y;
  r0.w = 0.5 + r0.w;
  r0.w = floor(r0.w);
  r0.z = r0.w * r1.y + -r0.z;
  r0.w = cos(r0.z);
  r0.x = r0.w * r0.x + -0.5;
  r0.x = saturate(100.000099 * r0.x);
  r0.w = r0.x * -2 + 3;
  r0.x = r0.x * r0.x;
  r0.x = -r0.w * r0.x + 1;
  r0.xy = max(float2(0,0), r0.xy);
  r0.x = r0.y + -r0.x;
  r0.y = -cb0[4].z + r0.z;
  r0.z = cb0[4].z + r0.z;
  r0.w = 1 / cb0[4].w;
  r0.y = saturate(r0.y * r0.w);
  r0.w = r0.y * -2 + 3;
  r0.y = r0.y * r0.y;
  r0.y = -r0.w * r0.y + 1;
  r0.w = 1 / -cb0[4].w;
  r0.z = saturate(r0.z * r0.w);
  r0.w = r0.z * -2 + 3;
  r0.z = r0.z * r0.z;
  r0.z = -r0.w * r0.z + 1;
  r0.y = saturate(r0.y * r0.z);
  o0.xyz = r0.xxx + -r0.yyy;
  o0.w = cb0[5].x;
  o0.rgb = max(0.f, o0.rgb);
  return;
}