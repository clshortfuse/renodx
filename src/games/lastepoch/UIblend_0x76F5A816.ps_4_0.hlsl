#include "./common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[4];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float4 v2 : TEXCOORD0,
  float4 v3 : TEXCOORD1,
  float4 v4 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  r0.xyzw = cb0[3].xyzw + r0.xyzw;
  r0.xyzw = v1.xyzw * r0.xyzw;
  r1.xy = v4.xy / v4.ww;
  r1.xyzw = t1.Sample(s1_s, r1.xy).xyzw;
  r1.w = max(r1.y, r1.z);
  r1.w = max(r1.x, r1.w);
  r2.x = min(r1.y, r1.z);
  r2.x = min(r2.x, r1.x);
  r2.y = r2.x + r1.w;
  r2.z = cmp(r1.w == r2.x);
  r2.w = -r2.x + r1.w;
  r3.x = cmp(1 < r2.y);
  r1.w = -r2.x + -r1.w;
  r1.w = 2 + r1.w;
  r1.w = r2.w / r1.w;
  r2.x = r2.w / r2.y;
  r3.x = r3.x ? r1.w : r2.x;
  r4.xyzw = cmp(r1.yzyz < r1.xxzy);
  r1.w = r4.y ? r4.x : 0;
  r1.xyz = r1.yzx + -r1.zxy;
  r1.xyz = r1.xyz / r2.www;
  r2.x = r4.z ? 6.000000 : 0;
  r1.x = r2.x + r1.x;
  r1.yz = float2(2,4) + r1.yz;
  r1.y = r4.w ? r1.y : r1.z;
  r1.x = r1.w ? r1.x : r1.y;
  r3.yzw = float3(0.166666672,0.166666672,0.166666672) * r1.xxx;
  r1.xyzw = r2.zzzz ? float4(0,0,0,0) : r3.xyzw;
  r2.x = max(r0.y, r0.z);
  r2.x = max(r2.x, r0.x);
  r2.y = min(r0.y, r0.z);
  r2.y = min(r2.y, r0.x);
  r2.x = r2.x + r2.y;
  r0.xyz = float3(0.5,0.5,0.5) * r2.xxx;
  r2.y = cmp(r1.x == 0.000000);
  if (r2.y == 0) {
    r2.y = cmp(r2.x < 1);
    r3.xyzw = float4(1,0.333333343,1.33333337,1) + r1.xyzw;
    r1.y = r3.x * r0.z;
    r1.z = r2.x * 0.5 + r1.x;
    r1.x = -r0.z * r1.x + r1.z;
    r1.x = r2.y ? r1.y : r1.x;
    r1.y = r2.x + -r1.x;
    r1.z = cmp(r3.y < 0);
    r1.z = r1.z ? r3.z : r3.y;
    r2.x = cmp(1 < r1.z);
    r2.y = -1 + r1.z;
    r1.z = r2.x ? r2.y : r1.z;
    r2.x = r1.x + -r1.y;
    r2.y = 6 * r2.x;
    r2.z = r2.y * r1.z + r1.y;
    r2.w = cmp(r1.z >= 0.166666672);
    r3.xy = cmp(r1.zz < float2(0.5,0.666666687));
    r1.z = 0.666666687 + -r1.z;
    r1.z = r2.x * r1.z;
    r1.z = r1.z * 6 + r1.y;
    r1.z = r3.y ? r1.z : r1.y;
    r1.z = r3.x ? r1.x : r1.z;
    r0.x = r2.w ? r1.z : r2.z;
    r1.z = cmp(r1.w < 0);
    r1.z = r1.z ? r3.w : r1.w;
    r2.z = cmp(1 < r1.z);
    r2.w = -1 + r1.z;
    r1.z = r2.z ? r2.w : r1.z;
    r2.z = r2.y * r1.z + r1.y;
    r2.w = cmp(r1.z >= 0.166666672);
    r3.xy = cmp(r1.zz < float2(0.5,0.666666687));
    r1.z = 0.666666687 + -r1.z;
    r1.z = r2.x * r1.z;
    r1.z = r1.z * 6 + r1.y;
    r1.z = r3.y ? r1.z : r1.y;
    r1.z = r3.x ? r1.x : r1.z;
    r0.y = r2.w ? r1.z : r2.z;
    r1.zw = float2(-0.333333343,0.666666627) + r1.ww;
    r2.z = cmp(r1.z < 0);
    r1.z = r2.z ? r1.w : r1.z;
    r1.w = cmp(1 < r1.z);
    r2.z = -1 + r1.z;
    r1.z = r1.w ? r2.z : r1.z;
    r1.w = r2.y * r1.z + r1.y;
    r2.y = cmp(r1.z >= 0.166666672);
    r2.zw = cmp(r1.zz < float2(0.5,0.666666687));
    r1.z = 0.666666687 + -r1.z;
    r1.z = r2.x * r1.z;
    r1.z = r1.z * 6 + r1.y;
    r1.y = r2.w ? r1.z : r1.y;
    r1.x = r2.z ? r1.x : r1.y;
    r0.z = r2.y ? r1.x : r1.w;
  }
  o0.xyzw = r0.xyzw;
  o0.rgb = UIScale(o0.rgb);
  return;
}