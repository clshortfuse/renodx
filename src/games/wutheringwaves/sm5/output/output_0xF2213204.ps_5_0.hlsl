#include "../../common.hlsl"

// ---- Created with 3Dmigoto v1.4.1 on Sat Oct 11 13:05:35 2025
Texture3D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s4_s : register(s4);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1)
{
  float4 cb1[149];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[92];
}




// 3Dmigoto declarations
#define cmp -


void main(
  linear noperspective float2 v0 : TEXCOORD0,
  linear noperspective float2 w0 : TEXCOORD3,
  linear noperspective float4 v1 : TEXCOORD1,
  linear noperspective float4 v2 : TEXCOORD2,
  float2 v3 : TEXCOORD4,
  float4 v4 : SV_POSITION0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = w0.xy * float2(0.5,0.5) + float2(0.5,0.5);
  r0.z = cmp(0 < cb0[85].x);
  r0.w = cmp(cb0[85].x < 0);
  r1.x = (int)r0.w | (int)r0.z;
  if (r1.x != 0) {
    r1.xy = r0.xy * float2(2,2) + float2(-1,-1);
    if (r0.z != 0) {
      r0.z = cb0[85].x + cb0[85].x;
      r2.x = cb0[65].x * cb0[64].w;
      r0.z = 0.5 * abs(r0.z);
      sincos(r0.z, r3.x, r4.x);
      r1.z = r3.x / r4.x;
      r2.y = 1;
      r2.zw = r2.xy * r1.xy;
      r1.w = dot(r2.xy, r2.xy);
      r3.x = sqrt(r1.w);
      r3.y = dot(r2.zw, r2.zw);
      r3.z = sqrt(r3.y);
      r3.x = r3.z / r3.x;
      r3.y = rsqrt(r3.y);
      r2.zw = r3.yy * r2.zw;
      r1.w = rsqrt(r1.w);
      r2.xy = r2.xy * r1.ww;
      r2.xy = r2.zw / r2.xy;
      r0.z = r3.x * r0.z;
      sincos(r0.z, r3.x, r4.x);
      r0.z = r3.x / r4.x;
      r2.xy = r2.xy * r0.zz;
      r1.zw = r2.xy / r1.zz;
      r1.zw = r1.zw * float2(0.5,0.5) + float2(0.5,0.5);
    } else {
      r2.xy = r1.xy * r1.xy;
      r2.xy = float2(0.25,0.25) * r2.xy;
      r0.z = r2.x + r2.y;
      r2.x = sqrt(r0.z);
      r0.z = cb0[85].x * r0.z;
      r0.z = r0.z * 0.699999988 + 1;
      r0.z = r2.x * r0.z;
      r1.xy = float2(0.5,0.5) * r1.xy;
      r2.x = min(abs(r1.x), abs(r1.y));
      r2.y = max(abs(r1.x), abs(r1.y));
      r2.y = 1 / r2.y;
      r2.x = r2.x * r2.y;
      r2.y = r2.x * r2.x;
      r2.z = r2.y * 0.0208350997 + -0.0851330012;
      r2.z = r2.y * r2.z + 0.180141002;
      r2.z = r2.y * r2.z + -0.330299497;
      r2.y = r2.y * r2.z + 0.999866009;
      r2.z = r2.x * r2.y;
      r2.w = cmp(abs(r1.y) < abs(r1.x));
      r2.z = r2.z * -2 + 1.57079637;
      r2.z = r2.w ? r2.z : 0;
      r2.x = r2.x * r2.y + r2.z;
      r2.y = cmp(r1.y < -r1.y);
      r2.y = r2.y ? -3.141593 : 0;
      r2.x = r2.x + r2.y;
      r2.y = min(r1.x, r1.y);
      r1.x = max(r1.x, r1.y);
      r1.y = cmp(r2.y < -r2.y);
      r1.x = cmp(r1.x >= -r1.x);
      r1.x = r1.x ? r1.y : 0;
      r1.x = r1.x ? -r2.x : r2.x;
      sincos(r1.x, r1.x, r2.x);
      r1.x = r1.x * r0.z + 0.5;
      r1.y = r2.x * r0.z + 0.5;
      r1.zw = r0.ww ? r1.xy : r0.xy;
    }
    r0.xz = r1.zw * float2(2,2) + float2(-1,-1);
  } else {
    r0.xz = w0.xy;
  }
  r0.w = r0.z * 0.5 + 0.5;
  r1.xy = r0.xz * cb0[48].zw + cb0[49].xy;
  r1.xy = cb0[48].xy * r1.xy;
  r1.z = t3.SampleLevel(s3_s, r1.xy, 0).x;
  r1.w = r1.z * cb1[65].x + cb1[65].y;
  r1.z = r1.z * cb1[65].z + -cb1[65].w;
  r1.z = 1 / r1.z;
  r1.z = r1.w + r1.z;
  r1.w = t2.Sample(s2_s, r1.xy).x;
  r2.x = cmp(cb1[31].w >= 1);
  r2.x = r2.x ? 1.000000 : 0;
  r2.y = cb1[65].w + r1.z;
  r2.y = cb1[65].z * r2.y;
  r2.y = 1 / r2.y;
  r2.z = r1.z * cb1[30].z + cb1[31].z;
  r2.z = r2.z + -r2.y;
  r2.x = r2.x * r2.z + r2.y;
  r2.x = r2.x + -r1.w;
  r2.x = cmp(0.000500000024 >= r2.x);
  r2.yz = cmp(float2(0,0) != cb0[81].yx);
  r3.xy = cmp(float2(0,0) != cb0[85].yz);
  r2.y = (int)r2.y | (int)r3.x;
  r3.xzw = cmp(float3(0,0,0) != cb0[86].yzx);
  r2.y = (int)r2.y | (int)r3.x;
  r4.xyz = cmp(float3(0,0,0) != cb0[87].yzx);
  r2.y = (int)r2.y | (int)r4.x;
  r5.xyz = cmp(float3(0,0,0) != cb0[88].yzx);
  r2.y = (int)r2.y | (int)r5.x;
  r4.xw = cmp(float2(0,0) != cb0[80].yz);
  r2.y = (int)r2.y | (int)r4.x;
  r6.x = max(cb0[85].y, cb0[80].y);
  r6.y = max(cb0[86].y, cb0[80].y);
  r6.z = max(cb0[87].y, cb0[80].y);
  r2.w = saturate(cb0[81].z);
  r2.w = r2.w * -1.49000001 + cb0[81].y;
  r2.w = 1.5 + r2.w;
  r0.x = dot(r0.xz, r0.xz);
  r0.x = sqrt(r0.x);
  r0.z = cb0[81].y + -r2.w;
  r0.x = r0.x + -r2.w;
  r0.z = 1 / r0.z;
  r0.x = saturate(r0.x * r0.z);
  r0.z = r0.x * -2 + 3;
  r0.x = r0.x * r0.x;
  r0.x = r0.z * r0.x;
  r6.xyz = -r6.xyz * r0.xxx + float3(1,1,1);
  r6.xyz = r2.yyy ? r6.xyz : float3(1,1,1);
  r0.x = (int)r3.y | (int)r4.w;
  r0.x = (int)r3.z | (int)r0.x;
  r0.x = (int)r4.y | (int)r0.x;
  r0.x = (int)r5.y | (int)r0.x;
  if (r0.x != 0) {
    r0.x = saturate(cb0[80].z);
    r0.z = r0.x * r0.x;
    r0.x = r0.x * r0.z;
    r0.x = r4.w ? r0.x : 0;
    r0.z = saturate(cb0[85].z);
    r2.y = r0.z * r0.z;
    r0.z = r2.y * r0.z;
    r0.z = r3.y ? r0.z : 0;
    r2.y = saturate(cb0[86].z);
    r2.w = r2.y * r2.y;
    r2.y = r2.y * r2.w;
    r2.y = r3.z ? r2.y : 0;
    r2.w = saturate(cb0[87].z);
    r3.x = r2.w * r2.w;
    r2.w = r3.x * r2.w;
    r2.w = r4.y ? r2.w : 0;
    r3.x = max(r0.x, r0.z);
    r3.yz = max(r2.yw, r0.xx);
    r4.xyw = r3.xyz * float3(9999.99023,9999.99023,9999.99023) + float3(0.00999999978,0.00999999978,0.00999999978);
    r3.xyz = -r3.xyz * float3(1000,1000,1000) + r1.zzz;
    r4.xyw = float3(1,1,1) / r4.xyw;
    r3.xyz = saturate(r4.xyw * r3.xyz);
    r4.xyw = r3.xyz * float3(-2,-2,-2) + float3(3,3,3);
    r3.xyz = r3.xyz * r3.xyz;
    r3.xyz = r4.xyw * r3.xyz;
  } else {
    r3.xyz = float3(1,1,1);
  }
  r0.x = (int)r2.z | (int)r3.w;
  r0.x = (int)r4.z | (int)r0.x;
  r0.x = (int)r5.z | (int)r0.x;
  r0.z = cmp(0 != cb0[89].x);
  r0.x = (int)r0.z | (int)r0.x;
  r0.z = cmp(0.000500000024 >= r1.w);
  r0.z = r0.z ? 1.000000 : 0;
  r1.z = r2.x ? -1 : -0;
  r0.z = r1.z + r0.z;
  r0.z = 1 + r0.z;
  r0.z = min(1, r0.z);
  r2.x = saturate(max(cb0[86].x, cb0[81].x));
  r2.y = saturate(max(cb0[87].x, cb0[81].x));
  r2.z = saturate(max(cb0[88].x, cb0[81].x));
  r2.xyz = float3(1,1,1) + -r2.xyz;
  r2.xyz = max(r2.xyz, r0.zzz);
  r2.xyz = r0.xxx ? r2.xyz : float3(1,1,1);
  r0.x = v2.w * 543.309998 + v2.z;
  r0.z = sin(r0.x);
  r0.z = 493013 * r0.z;
  r4.xy = frac(r0.zz);
  r0.z = cmp(0 < cb0[80].x);
  r1.zw = float2(33.9900017,66.9899979) + r0.xx;
  r1.zw = sin(r1.zw);
  r1.zw = r1.zw * float2(493013,493013) + float2(7.17700005,14.2989998);
  r4.zw = frac(r1.zw);
  r5.xyzw = r4.xyzw + -r4.yyyy;
  r5.xyzw = cb0[80].xxxx * r5.xyzw + r4.yyyy;
  r4.xyzw = r0.zzzz ? r5.xyzw : r4.yyyy;
  r0.xz = cmp(float2(0,0) < cb0[83].zy);
  r5.xyz = float3(4,0.000166666665,10) * cb1[148].zzz;
  r1.z = r0.y * 20 + r5.x;
  r1.z = r4.x * 0.00200000009 + r1.z;
  r1.z = sin(r1.z);
  r1.z = r1.z * 0.5 + 0.5;
  r1.w = cb0[83].z * r3.z;
  r1.w = r1.w * r6.z;
  r1.w = r1.w * r2.z;
  r1.z = r1.z * r1.w;
  r0.x = r0.x ? r1.z : 0;
  r1.z = cb0[83].y * r6.y;
  r1.z = r1.z * r3.y;
  r1.z = r1.z * r2.y;
  r1.w = cmp(r5.y >= -r5.y);
  r2.z = frac(abs(r5.y));
  r1.w = r1.w ? r2.z : -r2.z;
  r0.y = r1.w * r0.y;
  r0.y = 222000 * r0.y;
  r0.y = dot(r0.yy, float2(12.9898005,78.2330017));
  r0.y = sin(r0.y);
  r0.y = 43758.5469 * r0.y;
  r0.y = frac(r0.y);
  r0.y = 0.5 + -r0.y;
  r0.y = r1.z * r0.y;
  r1.zw = r0.yy * float2(0.00749999983,0.0149999997) + r1.xy;
  r0.yz = r0.zz ? r1.zw : r1.xy;
  r1.x = -r4.y * r4.y + 1;
  r1.x = cb0[79].z * r1.x;
  r1.yz = v2.xy + -r0.yz;
  r0.yz = r1.xx * r1.yz + r0.yz;
  r1.xy = max(cb0[53].zw, r0.yz);
  r1.xy = min(cb0[54].xy, r1.xy);
  r1.xyz = t0.Sample(s0_s, r1.xy).xyz;
  r2.zw = saturate(cb0[82].xy);
  r1.w = saturate(1 + -cb0[82].z);
  r3.z = cmp(0 < r2.z);
  r3.w = saturate(dot(r1.xyz, float3(0.298999995,0.587000012,0.114)));
  r4.x = r3.w * -2 + 3;
  r3.w = r3.w * r3.w;
  r3.w = r4.x * r3.w;
  r7.x = dot(r3.ww, r1.ww);
  r1.w = dot(r1.xyz, r1.xyz);
  r1.w = sqrt(r1.w);
  r1.w = max(0.0149999997, r1.w);
  r5.xyw = r1.xyz / r1.www;
  r8.xyz = float3(1,1,1) + -r5.xyw;
  r5.xyw = r8.xyz * float3(0.25,0.25,0.25) + r5.xyw;
  r1.w = log2(r7.x);
  r6.zw = float2(0.899999976,0.949999988) * r1.ww;
  r7.yz = exp2(r6.zw);
  r7.xyz = r2.www * float3(0.170000002,0.180000007,0.179999992) + r7.xyz;
  r7.xyz = float3(0.0299999993,0.0500000007,0.0799999982) + r7.xyz;
  r1.w = r2.z * r6.x;
  r1.w = r1.w * r3.x;
  r1.w = r1.w * r2.x;
  r2.xzw = r5.xyw * r7.xyz + -r1.xyz;
  r2.xzw = r1.www * r2.xzw + r1.xyz;
  r1.xyz = r3.zzz ? r2.xzw : r1.xyz;
  r1.w = saturate(cb0[83].x);
  r2.x = r1.w * r6.y;
  r2.x = r2.x * r3.y;
  r2.x = r2.x * r2.y;
  r1.w = cmp(0 < r1.w);
  r0.w = r0.w * 1280 + -r5.z;
  r0.w = sin(r0.w);
  r0.w = r0.w * 0.5 + 1;
  r2.yzw = r0.www * r1.xyz + -r1.xyz;
  r2.xyz = r2.xxx * r2.yzw + r1.xyz;
  r1.xyz = r1.www ? r2.xyz : r1.xyz;
  r1.xyz = cb0[70].xyz * r1.xyz;
  r0.yz = cb0[68].zw * r0.yz + cb0[69].xy;
  r0.yz = max(cb0[60].zw, r0.yz);
  r0.yz = min(cb0[61].xy, r0.yz);

  r0.yzw = t1.Sample(s1_s, r0.yz).xyz;
  r0.yzw = r1.xyz * v1.xxx + RENODX_WUWA_BLOOM * r0.yzw;

  r1.xy = cb0[74].xy * float2(2,2) + v1.zw;
  r1.xy = float2(-1,-1) + r1.xy;
  r1.xy = cb0[72].xx * r1.xy;
  r1.xy = cb0[72].zw * r1.xy;
  r1.x = dot(r1.xy, r1.xy);
  r1.y = saturate(cb0[73].w);
  r1.y = r1.y * 9 + 1;
  r1.x = r1.x * r1.y + 1;
  r1.x = rcp(r1.x);
  r1.x = r1.x * r1.x;
  r1.y = 1 + cb0[74].z;
  r1.yzw = -cb0[73].xyz + r1.yyy;
  r1.xyz = r1.xxx * r1.yzw + cb0[73].xyz;
  r2.xy = cb0[77].xy * float2(2,2) + v1.zw;
  r2.xy = float2(-1,-1) + r2.xy;
  r2.xy = cb0[75].xx * r2.xy;
  r2.xy = cb0[75].zw * r2.xy;
  r1.w = dot(r2.xy, r2.xy);
  r2.x = saturate(cb0[76].w);
  r2.x = r2.x * 9 + 1;
  r1.w = r1.w * r2.x + 1;
  r1.w = rcp(r1.w);
  r1.w = r1.w * r1.w;
  r2.x = 1 + cb0[77].z;
  r2.xyz = -cb0[76].xyz + r2.xxx;
  r2.xyz = r1.www * r2.xyz + cb0[76].xyz;
  r1.xyz = r2.xyz * r1.xyz;
  r0.yzw = r1.xyz * r0.yzw;
  r0.x = 1 + r0.x;
  r0.xyz = r0.yzw * r0.xxx;

  CAPTURE_UNTONEMAPPED(r0);

  [branch]
  if (WUWA_TM_IS(1)) {
    r1.xyz = r0.xyz * float3(1.36000001,1.36000001,1.36000001) + float3(0.0469999984,0.0469999984,0.0469999984);
    r1.xyz = r1.xyz * r0.xyz;
    r2.xyz = r0.xyz * float3(0.959999979,0.959999979,0.959999979) + float3(0.560000002,0.560000002,0.560000002);
    r2.xyz = r0.xyz * r2.xyz + float3(0.140000001,0.140000001,0.140000001);
    r0.xyz = (r1.xyz / r2.xyz);
  }

  [branch]
  if (WUWA_TM_IS(2)) {
    r1.xyz = float3(-0.195050001,-0.195050001,-0.195050001) + r0.xyz;
    r1.xyz = float3(-0.163980007,-0.163980007,-0.163980007) / r1.xyz;
    r1.xyz = float3(1.00495005,1.00495005,1.00495005) + r1.xyz;
    r2.xyz = cmp(float3(0.600000024,0.600000024,0.600000024) >= r0.xyz);
    r2.xyz = r2.xyz ? float3(1,1,1) : 0;
    r3.xyz = -r1.xyz + r0.xyz;
    r0.xyz = (r2.xyz * r3.xyz + r1.xyz);
  }

  [branch]
  if (WUWA_TM_IS(3)) {
    r1.xyz = cb0[37].yyy * r0.xyz;
    r1.xyz = cb0[37].www * cb0[37].zzz + r1.xyz;
    r2.xy = cb0[38].xx * cb0[38].yz;
    r1.xyz = r0.xyz * r1.xyz + r2.xxx;
    r2.xzw = r0.xyz * cb0[37].yyy + cb0[37].zzz;
    r2.xyz = r0.xyz * r2.xzw + r2.yyy;
    r1.xyz = r1.xyz / r2.xyz;
    r0.w = cb0[38].y / cb0[38].z;
    r0.xyz = (r1.xyz + -r0.www);
  }

  [branch]
  if (cb0[89].w != 0) {
    r0.w = cmp(cb0[90].x != 1.000000);
    if (r0.w != 0) {
      r0.w = dot(r0.xyz, float3(0.212599993,0.715200007,0.0722000003));
      r1.x = cmp(9.99999975e-05 < r0.w);
      if (r1.x != 0) {
        r1.xyz = log2(r0.xyz);
        r1.xyz = float3(0.159301758,0.159301758,0.159301758) * r1.xyz;
        r1.xyz = exp2(r1.xyz);
        r2.xyz = r1.xyz * float3(18.8515625,18.8515625,18.8515625) + float3(0.8359375,0.8359375,0.8359375);
        r1.xyz = r1.xyz * float3(18.6875,18.6875,18.6875) + float3(1,1,1);
        r1.xyz = r2.xyz / r1.xyz;
        r1.xyz = log2(r1.xyz);
        r1.xyz = float3(78.84375,78.84375,78.84375) * r1.xyz;
        r1.xyz = exp2(r1.xyz);
        r0.w = cmp(0.00499999989 < r0.w);
        if (r0.w != 0) {
          r0.w = 1 + -cb0[90].x;
          r2.xyz = cmp(float3(0.440281361,0.440281361,0.440281361) < r1.xyz);
          r3.xyz = float3(-0.440281361,-0.440281361,-0.440281361) + r1.xyz;
          r5.xyz = r3.xyz * r0.www + float3(1,1,1);
          r3.xyz = r3.xyz / r5.xyz;
          r3.xyz = float3(0.440281361,0.440281361,0.440281361) + r3.xyz;
          r1.xyz = r2.xyz ? r3.xyz : r1.xyz;
        }
        r1.xyz = log2(r1.xyz);
        r1.xyz = float3(0.0126833133,0.0126833133,0.0126833133) * r1.xyz;
        r1.xyz = exp2(r1.xyz);
        r2.xyz = float3(-0.8359375,-0.8359375,-0.8359375) + r1.xyz;
        r2.xyz = max(float3(0,0,0), r2.xyz);
        r1.xyz = -r1.xyz * float3(18.6875,18.6875,18.6875) + float3(18.8515625,18.8515625,18.8515625);
        r1.xyz = r2.xyz / r1.xyz;
        r1.xyz = log2(r1.xyz);
        r1.xyz = float3(6.27739477,6.27739477,6.27739477) * r1.xyz;
        r0.xyz = exp2(r1.xyz);
      }
    }
  }

  CLAMP_IF_SDR(r0);
  CAPTURE_TONEMAPPED(r0);

  r0.xyz = float3(0.00266771927,0.00266771927,0.00266771927) + r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = saturate(r0.xyz * float3(0.0714285746,0.0714285746,0.0714285746) + float3(0.610726953,0.610726953,0.610726953));
  r0.xyz = r0.xyz * float3(0.96875,0.96875,0.96875) + float3(0.015625,0.015625,0.015625);

  r0.xyz = t4.Sample(s4_s, r0.xyz).xyz;
  HANDLE_LUT_OUTPUT(r0);

  r0.xyz = float3(1.04999995,1.04999995,1.04999995) * r0.xyz;

  o0.w = (dot(r0.xyz, float3(0.298999995,0.587000012,0.114)));
  CLAMP_IF_SDR(o0.w);

  r0.xyz = r4.yzw * float3(0.00390625,0.00390625,0.00390625) + r0.xyz;
  r0.xyz = float3(-0.001953125,-0.001953125,-0.001953125) + r0.xyz;
  if (cb0[90].w != 0) {
    r1.xyz = log2(r0.xyz);
    r1.xyz = float3(0.0126833133,0.0126833133,0.0126833133) * r1.xyz;
    r1.xyz = exp2(r1.xyz);
    r2.xyz = float3(-0.8359375,-0.8359375,-0.8359375) + r1.xyz;
    r2.xyz = max(float3(0,0,0), r2.xyz);
    r1.xyz = -r1.xyz * float3(18.6875,18.6875,18.6875) + float3(18.8515625,18.8515625,18.8515625);
    r1.xyz = r2.xyz / r1.xyz;
    r1.xyz = log2(r1.xyz);
    r1.xyz = float3(6.27739477,6.27739477,6.27739477) * r1.xyz;
    r1.xyz = exp2(r1.xyz);
    r1.xyz = float3(10000,10000,10000) * r1.xyz;
    r1.xyz = r1.xyz / cb0[90].zzz;
    r1.xyz = max(float3(6.10351999e-05,6.10351999e-05,6.10351999e-05), r1.xyz);
    r2.xyz = float3(12.9200001,12.9200001,12.9200001) * r1.xyz;
    r1.xyz = max(float3(0.00313066994,0.00313066994,0.00313066994), r1.xyz);
    r1.xyz = log2(r1.xyz);
    r1.xyz = float3(0.416666657,0.416666657,0.416666657) * r1.xyz;
    r1.xyz = exp2(r1.xyz);
    r1.xyz = r1.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
    o0.xyz = min(r2.xyz, r1.xyz);
  } else {
    o0.xyz = r0.xyz;
  }
  return;
}