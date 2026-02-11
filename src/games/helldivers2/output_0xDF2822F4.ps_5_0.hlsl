#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.4.1 on Wed Sep  3 05:58:14 2025
Texture2DMS<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1)
{
  float4 cb1[9];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[46];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;
  float inf = 1e+20;

  r0.x = cmp(0.5 < cb1[1].w);
  r0.y = 1 + -v1.x;
  r0.x = r0.x ? r0.y : v1.x;
  r0.y = v1.y;
  r1.xyz = t0.Sample(s1_s, r0.xy, int2(0, 0)).xyz;

  float3 game_color = r1.xyz;

  r0.z = max(cb1[4].x, cb1[4].y);
  r0.w = cmp(0 < r0.z);
  if (r0.w != 0) {
    r0.w = cb1[7].y * cb0[43].w;
    r0.w = 3.14159298 * r0.w;
    sincos(r0.w, r2.x, r3.x);
    r0.w = cb1[7].x * cb1[4].y;
    r3.y = r2.x;
    r2.xy = float2(-1,-0) + r3.xy;
    r2.xy = r0.ww * r2.xy + float2(1,0);
    r2.zw = float2(-0.5,-0.5) + r0.xy;
    r0.w = dot(r2.zw, r2.zw);
    r0.w = sqrt(r0.w);
    r0.w = 1.41421402 * r0.w;
    r0.w = min(1, r0.w);
    r0.w = sqrt(r0.w);
    r0.w = -1 + r0.w;
    r0.w = cb1[7].z * r0.w + 1;
    r2.z = 1 + -r0.w;
    r0.w = cb1[4].x * r2.z + r0.w;
    r0.z = r0.z * r0.w;
    r2.zw = -cb1[6].xy + cb1[5].xy;
    r2.zw = cb1[4].xx * r2.zw + cb1[6].xy;
    r2.xy = r2.zz * r2.xy;
    r3.xy = r2.xy * r0.zz;
    r3.xy = r3.xy * float2(0.5,0.5) + r0.xy;
    r3.xyzw = t0.Sample(s0_s, r3.xy, int2(0, 0)).xyzw;
    r2.xy = r2.xy * r0.zz + r0.xy;
    r4.xyzw = t0.Sample(s0_s, r2.xy, int2(0, 0)).xyzw;
    r0.w = r2.w * r0.z;
    r2.x = 0.5 * r0.w;
    r1.w = 1;
    r3.xyzw = r3.xyzw + -r1.xyzw;
    r3.xyzw = r0.wwww * r3.xyzw + r1.xyzw;
    r4.xyzw = r4.xyzw + -r3.xyzw;
    r1.xyzw = r2.xxxx * r4.xyzw + r3.xyzw;
  } else {
    r1.w = 1;
  }
  r0.w = cmp(0 < r0.z);
  r2.x = -cb1[6].z + cb1[5].z;
  r2.x = cb1[4].x * r2.x + cb1[6].z;
  r2.x = cb0[44].x * r2.x;
  // r2.x = r2.x;
  r2.x = exp2(-r2.x);
  r0.z = -r0.z * r2.x + 1;
  r0.z = r1.w * r0.z;
  o0.w = r0.w ? r0.z : r1.w;

  // missing instruction:
  // sampleinfo_uint r0.z, t1.x
  t1.GetDimensions(uiDest.x, uiDest.y, uiDest.z);
  r0.z = uiDest.z;

  r0.w = cmp(0 < cb1[7].w);
  r1.w = 0.00999999978 * cb0[44].x;
  // r1.w = 0.00999999978;
  r2.x = cb1[8].y * v1.y;
  r2.y = ceil(r2.x);
  r2.y = 9668.88965 * r2.y;
  r2.y = sin(r2.y);
  r2.y = frac(r2.y);
  r2.y = r0.x * cb1[8].x + r2.y;
  r2.y = ceil(r2.y);
  r2.x = floor(r2.x);
  r2.x = r2.x * cb1[8].x + r2.y;
  r2.x = ceil(r2.x);
  r2.y = 1225 * r2.x;
  r2.y = sin(r2.y);
  r2.y = 1265 * r2.y;
  r2.y = frac(r2.y);
  r1.w = r2.x * r1.w;
  r1.w = sin(r1.w);
  r1.w = 10010 * r1.w;
  r1.w = frac(r1.w);
  r1.w = cb1[7].w + -r1.w;
  r1.w = saturate(ceil(r1.w));
  r2.x = -0.5 + r2.y;
  r1.w = r2.x * r1.w;
  r1.w = 0.0500000007 * r1.w;
  r0.w = r0.w ? r1.w : 0;
  r2.xy = r0.xy + r0.ww;
  r2.xy = frac(r2.xy);
  r2.xy = cb1[0].zw * r2.xy;
  r2.xy = (int2)r2.xy;
  r2.zw = float2(0,0);
  r3.xyzw = float4(0,0,0,0);
  r0.w = 0;
  while (true) {
    r1.w = cmp((uint)r0.w >= (uint)r0.z);
    if (r1.w != 0) break;
    r4.xyzw = t1.Load(r2.xy, r0.w).xyzw;
    r5.xyz = cmp(float3(0.0404499993,0.0404499993,0.0404499993) >= r4.xyz);
    r6.xyz = float3(0.0773990005,0.0773990005,0.0773990005) * r4.xyz;
    r4.xyz = float3(0.0549999997,0.0549999997,0.0549999997) + r4.xyz;
    r4.xyz = float3(0.947866976,0.947866976,0.947866976) * r4.xyz;
    r4.xyz = log2(r4.xyz);
    r4.xyz = float3(2.4000001,2.4000001,2.4000001) * r4.xyz;
    r4.xyz = exp2(r4.xyz);
    r4.xyz = r5.xyz ? r6.xyz : r4.xyz;
    r3.xyzw = r4.xyzw + r3.xyzw;
    r0.w = (int)r0.w + 1;
  }
  // missing instruction
  // sampleinfo r0.z, t1.x
  t1.GetDimensions(fDest.x, fDest.y, fDest.z);
  r0.z = fDest.z;

  r0.z = 1 / r0.z;

  r2.xyzw = r3.xyzw * r0.zzzz;

#if 1
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    float4 ui_color = r2;
    ui_color = renodx::color::srgb::Encode(ui_color);
    
    HandleUICompositing(ui_color, game_color, o0, v1);
    return;
  }
#endif

  r1.xyz = log2(abs(r1.xyz));
  r1.xyz = float3(0.0126830004,0.0126830004,0.0126830004) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r3.xyz = float3(0.835937977,0.835937977,0.835937977) + -r1.xyz;
  r1.xyz = r1.xyz * float3(18.6875,18.6875,18.6875) + float3(-18.8515625,-18.8515625,-18.8515625);
  r1.xyz = r3.xyz / r1.xyz;
  r1.xyz = log2(abs(r1.xyz));
  r1.xyz = float3(6.27739477,6.27739477,6.27739477) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.xyz = float3(10000,10000,10000) * r1.xyz;
  r1.xyz = r1.xyz;
  r3.x = dot(float3(1.63504004,-0.605629981,-0.0763500035), r1.xyz);
  r3.y = dot(float3(-0.12325,1.13884997,-0.0102899997), r1.xyz);
  r3.z = dot(float3(-0.0171600003,-0.101729997,1.21072996), r1.xyz);
  r1.xyz = cb1[8].w * r2.xyz;
  r0.w = cmp(0 < r2.w);
  r2.xy = float2(1.75,3.0625) * cb1[8].ww;
  r4.xyz = min(r3.xyz, r2.xxx);
  r5.xyz = cb1[8].www * float3(3.5,3.5,3.5) + -r4.xyz;
  r2.xyz = r5.xyz / r2.yyy;
  r1.w = sqrt(r2.w);
  r2.xyz = r4.xyz * r2.xyz + -r3.xyz;
  r2.xyz = r1.www * r2.xyz + r3.xyz;
  r2.xyz = r0.www ? r2.xyz : r3.xyz;
  r3.xyz = sqrt(abs(r2.xyz));
  r4.xyz = cmp(float3(0,0,0) < r2.xyz);
  r2.xyz = cmp(r2.xyz < float3(0,0,0));
  r2.xyz = (int3)-r4.xyz + (int3)r2.xyz;
  r2.xyz = (int3)r2.xyz;
  r2.xyz = r3.xyz * r2.xyz;
  r1.xyz = sqrt(r1.xyz);
  r0.z = -r3.w * r0.z + 1;
  r1.xyz = r2.xyz * r0.zzz + r1.xyz;
  r2.xyz = r1.xyz * r1.xyz;
  r3.xyz = cmp(float3(0,0,0) < r1.xyz);
  r1.xyz = cmp(r1.xyz < float3(0,0,0));
  r1.xyz = (int3)-r3.xyz + (int3)r1.xyz;
  r1.xyz = (int3)r1.xyz;
  r1.xyz = r2.xyz * r1.xyz;
  r0.z = dot(float3(0.637920022,0.343095005,0.0431479998), r1.xyz);
  r0.w = dot(float3(0.0691709965,0.915944993,0.0121510001), r1.xyz);
  r1.x = dot(float3(0.0148510002,0.081825003,0.827576995), r1.xyz);
  r0.z = 9.99999975e-05 * r0.z;
  r0.z = log2(abs(r0.z));
  r0.z = 0.159301996 * r0.z;
  r0.z = exp2(r0.z);
  r1.yz = r0.zz * float2(18.8515625,18.6875) + float2(0.835937977,1);
  r0.z = r1.y / r1.z;
  r0.z = log2(r0.z);
  r2.x = 78.84375 * r0.z;
  r0.z = 9.99999975e-05 * r0.w;
  r0.z = log2(abs(r0.z));
  r0.z = 0.159301996 * r0.z;
  r0.z = exp2(r0.z);
  r0.zw = r0.zz * float2(18.8515625,18.6875) + float2(0.835937977,1);
  r0.z = r0.z / r0.w;
  r0.z = log2(r0.z);
  r2.y = 78.84375 * r0.z;
  r0.z = 9.99999975e-05 * r1.x;
  r0.z = log2(abs(r0.z));
  r0.z = 0.159301996 * r0.z;
  r0.z = exp2(r0.z);
  r0.zw = r0.zz * float2(18.8515625,18.6875) + float2(0.835937977,1);
  r0.z = r0.z / r0.w;
  r0.z = log2(r0.z);
  r2.z = 78.84375 * r0.z;
  r0.z = -1 + cb1[1].z;
  r0.z = exp2(-r0.z);
  r0.z = max(0.00100000005, r0.z);
  r1.xyz = r0.zzz * r2.xyz;
  r1.xyz = exp2(r1.xyz);
  r0.xy = cb0[45].xy * r0.xy;
  r0.xy = (uint2)r0.xy;
  r0.z = (uint)cb0[44].y;
  r0.x = (int)r0.z + (int)r0.x;
  r0.xy = (uint2)r0.xy;
  r0.y = 0.271003008 * r0.y;
  r0.x = r0.x * 1.61803401 + r0.y;
  r0.y = floor(r0.x);
  r0.x = r0.x + -r0.y;
  r0.yzw = float3(1023,1023,1023) * r1.xyz;
  r0.yzw = floor(r0.yzw);
  r2.xyz = float3(0.000977999996,0.000977999996,0.000977999996) * r0.yzw;
  r3.xyz = r0.yzw * float3(0.000977999996,0.000977999996,0.000977999996) + float3(0.000977999996,0.000977999996,0.000977999996);
  r1.xyz = -r3.xyz + r1.xyz;
  r0.yzw = r0.yzw * float3(0.000977999996,0.000977999996,0.000977999996) + -r3.xyz;
  r3.xyz = (int3)-r0.yzw + int3(0x7ef19fff,0x7ef19fff,0x7ef19fff);
  r0.yzw = -r3.xyz * r0.yzw + float3(2,2,2);
  r0.yzw = r3.xyz * r0.yzw;
  r0.xyz = -r1.xyz * r0.yzw + r0.xxx;
  r0.xyz = saturate(float3(inf,inf,inf) * r0.xyz);
  r0.xyz = r0.xyz * float3(0.000977999996,0.000977999996,0.000977999996) + r2.xyz;
  o0.xyz = min(float3(1,1,1), r0.xyz);
  return;
}