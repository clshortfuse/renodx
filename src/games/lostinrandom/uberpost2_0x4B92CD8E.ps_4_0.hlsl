// Dice world

#include "./common.hlsl"

Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[136];
}

#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4, r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(-0.5, -0.5) + v1.xy;
  r0.zw = r0.xy * cb0[132].zz + float2(0.5, 0.5);
  r0.xy = r0.xy * cb0[132].zz + -cb0[131].xy;
  r0.xy = cb0[131].zw * r0.xy;
  r1.x = dot(r0.xy, r0.xy);
  r1.x = sqrt(r1.x);
  r1.y = cmp(0 < cb0[132].w);
  if (r1.y != 0) {
    r1.zw = cb0[132].xy * r1.xx;
    sincos(r1.z, r2.x, r3.x);
    r1.z = r2.x / r3.x;
    r1.w = 1 / r1.w;
    r1.z = r1.z * r1.w + -1;
    r1.zw = r0.xy * r1.zz + r0.zw;
  } else {
    r2.x = 1 / r1.x;
    r2.x = cb0[132].x * r2.x;
    r1.x = cb0[132].y * r1.x;
    r2.y = min(1, abs(r1.x));
    r2.z = max(1, abs(r1.x));
    r2.z = 1 / r2.z;
    r2.y = r2.y * r2.z;
    r2.z = r2.y * r2.y;
    r2.w = r2.z * 0.0208350997 + -0.0851330012;
    r2.w = r2.z * r2.w + 0.180141002;
    r2.w = r2.z * r2.w + -0.330299497;
    r2.z = r2.z * r2.w + 0.999866009;
    r2.w = r2.y * r2.z;
    r3.x = cmp(1 < abs(r1.x));
    r2.w = r2.w * -2 + 1.57079637;
    r2.w = r3.x ? r2.w : 0;
    r2.y = r2.y * r2.z + r2.w;
    r1.x = min(1, r1.x);
    r1.x = cmp(r1.x < -r1.x);
    r1.x = r1.x ? -r2.y : r2.y;
    r1.x = r2.x * r1.x + -1;
    r1.zw = r0.xy * r1.xx + r0.zw;
  }
  r0.xyzw = v1.xyxy * float4(2, 2, 2, 2) + float4(-1, -1, -1, -1);
  r1.x = dot(r0.zw, r0.zw);
  r0.xyzw = r1.xxxx * r0.xyzw;
  r0.xyzw = cb0[133].xxxx * r0.xyzw;
  r2.xyzw = t0.Sample(s0_s, r1.zw).xyzw;
  r0.xyzw = r0.xyzw * float4(-0.333333343, -0.333333343, -0.666666687, -0.666666687) + v1.xyxy;
  r0.xyzw = float4(-0.5, -0.5, -0.5, -0.5) + r0.xyzw;
  r3.xyzw = r0.xyzw * cb0[132].zzzz + float4(0.5, 0.5, 0.5, 0.5);
  r0.xyzw = r0.xyzw * cb0[132].zzzz + -cb0[131].xyxy;
  r0.xyzw = cb0[131].zwzw * r0.xyzw;
  r1.x = dot(r0.xy, r0.xy);
  r1.x = sqrt(r1.x);
  if (r1.y != 0) {
    r2.yz = cb0[132].xy * r1.xx;
    sincos(r2.y, r4.x, r5.x);
    r2.y = r4.x / r5.x;
    r2.z = 1 / r2.z;
    r2.y = r2.y * r2.z + -1;
    r2.yz = r0.xy * r2.yy + r3.xy;
  } else {
    r2.w = 1 / r1.x;
    r2.w = cb0[132].x * r2.w;
    r1.x = cb0[132].y * r1.x;
    r4.x = min(1, abs(r1.x));
    r4.y = max(1, abs(r1.x));
    r4.y = 1 / r4.y;
    r4.x = r4.x * r4.y;
    r4.y = r4.x * r4.x;
    r4.z = r4.y * 0.0208350997 + -0.0851330012;
    r4.z = r4.y * r4.z + 0.180141002;
    r4.z = r4.y * r4.z + -0.330299497;
    r4.y = r4.y * r4.z + 0.999866009;
    r4.z = r4.x * r4.y;
    r4.w = cmp(1 < abs(r1.x));
    r4.z = r4.z * -2 + 1.57079637;
    r4.z = r4.w ? r4.z : 0;
    r4.x = r4.x * r4.y + r4.z;
    r1.x = min(1, r1.x);
    r1.x = cmp(r1.x < -r1.x);
    r1.x = r1.x ? -r4.x : r4.x;
    r1.x = r2.w * r1.x + -1;
    r2.yz = r0.xy * r1.xx + r3.xy;
  }
  r4.xyzw = t0.Sample(s0_s, r2.yz).xyzw;
  r0.x = dot(r0.zw, r0.zw);
  r0.x = sqrt(r0.x);
  if (r1.y != 0) {
    r1.xy = cb0[132].xy * r0.xx;
    sincos(r1.x, r1.x, r3.x);
    r0.y = r1.x / r3.x;
    r1.x = 1 / r1.y;
    r0.y = r0.y * r1.x + -1;
    r1.xy = r0.zw * r0.yy + r3.zw;
  } else {
    r0.y = 1 / r0.x;
    r0.y = cb0[132].x * r0.y;
    r0.x = cb0[132].y * r0.x;
    r2.y = min(1, abs(r0.x));
    r2.z = max(1, abs(r0.x));
    r2.z = 1 / r2.z;
    r2.y = r2.y * r2.z;
    r2.z = r2.y * r2.y;
    r2.w = r2.z * 0.0208350997 + -0.0851330012;
    r2.w = r2.z * r2.w + 0.180141002;
    r2.w = r2.z * r2.w + -0.330299497;
    r2.z = r2.z * r2.w + 0.999866009;
    r2.w = r2.y * r2.z;
    r3.x = cmp(1 < abs(r0.x));
    r2.w = r2.w * -2 + 1.57079637;
    r2.w = r3.x ? r2.w : 0;
    r2.y = r2.y * r2.z + r2.w;
    r0.x = min(1, r0.x);
    r0.x = cmp(r0.x < -r0.x);
    r0.x = r0.x ? -r2.y : r2.y;
    r0.x = r0.y * r0.x + -1;
    r1.xy = r0.zw * r0.xx + r3.zw;
  }
  r0.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r3.xyzw = t1.Sample(s0_s, r1.zw).xyzw;
  r0.w = cmp(0 < cb0[128].x);
  if (r0.w != 0) {
    r2.yzw = r3.xyz * r3.www;
    r3.xyz = float3(8, 8, 8) * r2.yzw;
  }

  r2.yzw = cb0[127].xxx * r3.xyz * injectedData.fxBloom;

  r0.x = r2.x;
  r0.y = r4.y;
  r0.xyz = r2.yzw * cb0[127].yzw + r0.xyz;
  r0.w = cmp(0 < cb0[135].z);
  if (r0.w != 0) {
    r1.xy = -cb0[135].xy + r1.zw;

    r1.yz = cb0[135].zz * abs(r1.xy) * min(1, injectedData.fxVignette);

    r1.x = cb0[134].w * r1.y;
    r0.w = dot(r1.xz, r1.xz);
    r0.w = 1 + -r0.w;
    r0.w = max(0, r0.w);

    r0.w = log2(r0.w);
    r0.w = cb0[135].w * r0.w * max(1, injectedData.fxVignette);
    r0.w = exp2(r0.w);

    r1.xyz = float3(1, 1, 1) + -cb0[134].xyz;
    r1.xyz = r0.www * r1.xyz + cb0[134].xyz;
    r0.xyz = r1.xyz * r0.xyz;
  }
  r0.xyz = cb0[125].www * r0.xyz;

  float3 untonemapped = r0.rgb;

  r0.x = cmp(0 < cb0[126].w);
  if (r0.x != 0) {
    r0.xyz = float3(12.9200001, 12.9200001, 12.9200001) * r1.xyz;
    r2.xyz = log2(r1.xyz);
    r2.xyz = float3(0.416666657, 0.416666657, 0.416666657) * r2.xyz;
    r2.xyz = exp2(r2.xyz);
    r2.xyz = r2.xyz * float3(1.05499995, 1.05499995, 1.05499995) + float3(-0.0549999997, -0.0549999997, -0.0549999997);
    r3.xyz = cmp(float3(0.00313080009, 0.00313080009, 0.00313080009) >= r1.xyz);
    r0.xyz = r3.xyz ? r0.xyz : r2.xyz;
    r2.xyz = cb0[126].zzz * r0.zxy;
    r0.w = floor(r2.x);
    r2.xw = float2(0.5, 0.5) * cb0[126].xy;
    r2.yz = r2.yz * cb0[126].xy + r2.xw;
    r2.x = r0.w * cb0[126].y + r2.y;
    r3.xyzw = t3.SampleLevel(s0_s, r2.xz, 0).xyzw;
    r4.x = cb0[126].y;
    r4.y = 0;
    r2.xy = r4.xy + r2.xz;
    r2.xyzw = t3.SampleLevel(s0_s, r2.xy, 0).xyzw;
    r0.w = r0.z * cb0[126].z + -r0.w;
    r2.xyz = r2.xyz + -r3.xyz;
    r2.xyz = r0.www * r2.xyz + r3.xyz;
    r2.xyz = r2.xyz + -r0.xyz;
    r0.xyz = cb0[126].www * r2.xyz + r0.xyz;
    r2.xyz = float3(0.0773993805, 0.0773993805, 0.0773993805) * r0.xyz;
    r3.xyz = float3(0.0549999997, 0.0549999997, 0.0549999997) + r0.xyz;
    r3.xyz = float3(0.947867334, 0.947867334, 0.947867334) * r3.xyz;
    r3.xyz = log2(abs(r3.xyz));
    r3.xyz = float3(2.4000001, 2.4000001, 2.4000001) * r3.xyz;
    r3.xyz = exp2(r3.xyz);
    r0.xyz = cmp(float3(0.0404499993, 0.0404499993, 0.0404499993) >= r0.xyz);
    r1.xyz = r0.xyz ? r2.xyz : r3.xyz;
  }
  r0.xyz = cb0[125].zzz * r1.zxy;
  r0.x = floor(r0.x);
  r1.xy = float2(0.5, 0.5) * cb0[125].xy;
  r2.yz = r0.yz * cb0[125].xy + r1.xy;
  r2.x = r0.x * cb0[125].y + r2.y;
  r3.xyzw = t2.SampleLevel(s0_s, r2.xz, 0).xyzw;
  r1.x = cb0[125].y;
  r1.y = 0;
  r0.yz = r2.xz + r1.xy;
  r2.xyzw = t2.SampleLevel(s0_s, r0.yz, 0).xyzw;
  r0.x = r1.z * cb0[125].z + -r0.x;
  r0.yzw = r2.xyz + -r3.xyz;
  o0.xyz = r0.xxx * r0.yzw + r3.xyz;
  o0.rgb = applyUserTonemap(untonemapped, t2, s0_s, cb0[125].rgb);
  o0.w = 1;
  return;
}
