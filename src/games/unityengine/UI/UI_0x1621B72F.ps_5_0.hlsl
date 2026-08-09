#include "../common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[7];
}
cbuffer cb0 : register(b0){
  float4 cb0[15];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  float4 v2 : COLOR0,
  float4 v3 : TEXCOORD2,
  float4 v4 : TEXCOORD3,
  float4 v5 : TEXCOORD4,
  float4 v6 : TEXCOORD5,
  uint v7 : SV_IsFrontFace0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cmp(0.5 < cb0[10].w);
  r0.y = cmp(0.5 < cb0[8].w);
  r0.z = 6.28318024 * cb0[7].x;
  sincos(r0.z, r1.x, r2.x);
  r2.y = -r1.x;
  r0.z = max(abs(r2.x), abs(r1.x));
  r0.w = cmp(0.5 < cb0[9].z);
  r1.y = r0.w ? cb0[5].x : cb0[5].y;
  r1.x = cb0[5].x;
  r1.zw = v1.xy * r1.xy;
  r1.zw = floor(r1.zw);
  r1.zw = r1.zw / r1.xy;
  r1.xy = float2(0.5,0.5) / r1.xy;
  r2.zw = r1.zw + r1.xy;
  r3.xy = float2(-0.5,-0.5) + r2.zw;
  r0.w = dot(r3.xy, r2.xy);
  r0.z = saturate(r0.w * r0.z + 0.5);
  r0.w = 1 + -r0.z;
  r0.y = r0.y ? r0.w : r0.z;
  r0.z = 1 + -r0.y;
  r0.x = r0.x ? r0.z : r0.y;
  r0.z = cb1[0].y * cb0[10].y;
  r3.xyz = t0.Sample(s1_s, r2.zw).xyz;
  r0.w = dot(r3.xyz, float3(0.0396819152,0.45802179,0.00609653955));
  r0.w = -0.5 + r0.w;
  r2.x = cb0[10].z * r0.w;
  r2.x = cb0[10].z * r2.x;
  r2.x = 10 * r2.x;
  r0.z = r0.z * 3 + r2.x;
  r0.z = frac(r0.z);
  r2.x = -0.5 + r0.z;
  r0.z = 1 + -r0.z;
  r2.x = r2.x + r0.w;
  r2.y = cb0[8].z + cb0[8].z;
  r2.x = r2.x * r2.y;
  r3.x = cb0[8].y * 15 + 1;
  r3.y = 1 / r3.x;
  r0.x = r2.x * r3.y + r0.x;
  r0.x = r0.x + -r0.z;
  r0.x = r3.x * r0.x + r0.z;
  r0.z = r0.z * 3 + -1;
  r0.x = r0.x + -r0.z;
  r0.x = min(1, abs(r0.x));
  r0.x = 1 + -r0.x;
  r0.x = cb0[10].x * r0.x;
  r0.z = -0.5 + cb0[8].x;
  r0.z = r0.w + r0.z;
  r0.z = r0.z * r2.y;
  r0.y = r0.z * r3.y + r0.y;
  r0.z = 1 + -cb0[8].x;
  r0.y = r0.y + -r0.z;
  r0.y = r3.x * r0.y + r0.z;
  r0.z = r0.z * 2 + -1;
  r0.y = saturate(r0.y + -r0.z);
  r0.y = 1 + -r0.y;
  r0.z = r0.y * r0.y;
  r0.x = saturate(r0.y * r0.z + r0.x);
  r0.y = -r0.z * r0.z + 1;
  r0.zw = r0.xx * cb0[6].xy + float2(1,1);
  r2.xy = r2.zw + r1.xy;
  r2.xy = r2.xy + -r1.zw;
  r1.zw = cb0[6].zw * r2.xy + r1.zw;
  r2.xy = saturate(cb0[6].zw);
  r1.zw = -r2.xy + r1.zw;
  r1.zw = cb0[12].xx * r1.zw + r2.xy;
  r2.xy = v1.xy + -r1.zw;
  r3.yz = r2.xy * r0.zw + r1.zw;
  r0.zw = r3.yz + -r2.zw;
  r1.z = dot(r0.zw, r0.zw);
  r0.zw = abs(r0.zw) / r1.xy;
  r1.z = sqrt(r1.z);
  r1.z = 0.707106769 * r1.z;
  r1.w = max(r1.x, r1.y);
  r1.xy = float2(1,1) + r1.xy;
  r1.z = r1.z / r1.w;
  r1.z = r1.z + -r1.x;
  r2.xy = float2(1,1) + -r1.xy;
  r0.zw = -r1.xy + r0.zw;
  r1.xy = float2(1,1) / r2.xy;
  r1.z = saturate(r1.z * r1.x);
  r0.zw = saturate(r1.xy * r0.zw);
  r1.x = r1.z * -2 + 3;
  r1.y = r1.z * r1.z;
  r1.x = r1.x * r1.y;
  r1.yz = r0.zw * float2(-2,-2) + float2(3,3);
  r0.zw = r0.zw * r0.zw;
  r0.zw = r1.yz * r0.zw;
  r0.z = r0.z * r0.w;
  r0.w = cmp(0 != cb0[11].w);
  r0.z = r0.w ? r1.x : r0.z;
  r0.y = r0.y * r0.z;
  r0.z = r0.x + r0.x;
  r0.x = cb0[9].y * r0.x;
  r0.w = v6.y / v6.w;
  r0.w = 0.0199999996 * r0.w;
  r1.x = cb0[13].y * 10 + 1;
  r0.w = r1.x * r0.w;
  r1.x = cb1[0].w * cb0[13].w;
  r0.w = r0.w * cb1[6].y + r1.x;
  r0.w = frac(r0.w);
  r0.w = r0.w * 2 + -1;
  r0.w = -0.5 + abs(r0.w);
  r1.x = ddx_coarse(r0.w);
  r1.y = ddy_coarse(r0.w);
  r1.x = abs(r1.x) + abs(r1.y);
  r1.y = r1.x + r0.w;
  r1.z = r1.x + r1.x;
  r1.x = cmp(r1.x != 0.000000);
  r1.z = 1 / r1.z;
  r1.y = saturate(r1.y * r1.z);
  r1.z = r1.y * -2 + 3;
  r1.y = r1.y * r1.y;
  r1.y = r1.z * r1.y;
  r0.w = r1.x ? r1.y : r0.w;
  r1.x = -0.5 + r0.w;
  r0.w = -r0.w * cb0[13].x + 1;
  r1.x = 5 * r1.x;
  r1.y = cb0[13].z / cb1[6].x;
  r1.z = r1.x * r1.y;
  r3.x = r1.x * r1.y + r3.y;
  r1.xy = r3.xz * cb0[4].xy + cb0[4].zw;
  r2.xyz = cb1[4].xyz + -v3.xyz;
  r1.w = dot(r2.xyz, r2.xyz);
  r1.w = rsqrt(r1.w);
  r2.xyz = r2.xyz * r1.www;
  r1.w = dot(v5.xyz, r2.xyz);
  r2.xy = -r1.ww * v5.xy + r2.xy;
  r1.w = 1 + -abs(r1.w);
  r1.z = r1.w * cb0[11].x + r1.z;
  r1.z = r0.z * cb0[11].y + r1.z;
  r0.z = cb0[9].y * r0.z;
  r1.zw = r2.xy * r1.zz;
  r2.xy = -r1.zw * float2(0.0250000004,0.0250000004) + r1.xy;
  r1.zw = r1.zw * float2(0.0250000004,0.0250000004) + r1.xy;
  r1.xy = t1.Sample(s0_s, r1.xy).yw;
  r1.zw = t1.Sample(s0_s, r1.zw).xw;
  r2.xy = t1.Sample(s0_s, r2.xy).zw;
  r3.xyzw = cb0[3].xyzw + -cb0[2].xyzw;
  r4.xyzw = r0.zzzz * r3.xyzw + cb0[2].xyzw;
  r3.xyzw = r0.xxxx * r3.xyzw + cb0[2].xyzw;
  r0.x = r0.x * r0.y;
  r0.x = r0.x * 10 + 1;
  r2.xy = r4.zw * r2.xy;
  r2.z = r2.x * r2.y;
  r1.xyzw = r4.ywxw * r1.xyzw;
  r2.xy = r1.zx * r1.wy;
  r0.z = max(r2.y, r2.z);
  r2.w = max(r2.x, r0.z);
  r1.xyzw = r2.xyzw * r0.yyyy;
  r1.xyzw = r3.xyzw * r1.xyzw;
  r0.xyz = r1.xyz * r0.xxx;
  r1.w = max(0, r1.w);
  r0.xyz = r1.www * r0.xyz;
  r2.x = cb0[9].x * cb0[9].x;
  r2.x = r2.x * 16 + 1;
  r0.xyz = r2.xxx * r0.xyz;
  r1.xyz = v2.xyz * r0.xyz;
  r0.xyzw = r1.xyzw * r0.wwww;
  r1.x = 30 * cb1[0].w;
  r1.x = floor(r1.x);
  r1.y = r1.x + r1.x;
  r1.y = cmp(r1.y >= -r1.y);
  r1.yz = r1.yy ? float2(2,0.5) : float2(-2,-0.5);
  r1.x = r1.x * r1.z;
  r1.x = frac(r1.x);
  r1.x = r1.y * r1.x;
  r1.x = cmp(r1.x == 0.000000);
  r1.x = r1.x ? 1.000000 : 0;
  r1.y = 0.200000003 * cb0[14].y;
  r1.x = -r1.y * r1.x + 1;
  r0.xyzw = r1.xxxx * r0.xyzw;
  r1.xyzw = cb0[14].xxxx * r0.xyzw;
  r0.xyzw = v7.xxxx ? r0.xyzw : r1.xyzw;
  o0.xyzw = max(float4(0,0,0,0), r0.xyzw);
  o0.w = saturate(o0.w);
  if(injectedData.rolloffUI == 1.f){
    o0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(o0.xyz) : o0.xyz;
    o0.xyz = rolloff(o0.xyz, 0.85f, true);
    o0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(o0.xyz) : o0.xyz;
  } else if(injectedData.rolloffUI == 2.f){
    o0.xyz = saturate(o0.xyz);
  }
  return;
}