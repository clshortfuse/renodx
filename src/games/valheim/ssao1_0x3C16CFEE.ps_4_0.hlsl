// ---- Created with 3Dmigoto v1.3.16 on Sun Feb 02 01:40:03 2025
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2)
{
  float4 cb2[17];
}

cbuffer cb1 : register(b1)
{
  float4 cb1[9];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[9];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  float2 v2 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy * cb0[4].xy + cb0[4].zw;
  r1.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r0.z = dot(r1.xyz, r1.xyz);
  r0.z = cmp(r0.z != 0.000000);
  r0.z = r0.z ? -1 : -0;
  r1.xyz = r1.xyz * float3(2,2,2) + r0.zzz;
  r2.xyz = cb2[15].xyz * r1.yyy;
  r1.xyw = cb2[14].xyz * r1.xxx + r2.xyz;
  r1.xyz = cb2[16].xyz * r1.zzz + r1.xyw;
  r2.xyzw = t1.Sample(s1_s, r0.xy).xyzw;
  r0.z = 1 + -cb1[8].w;
  r0.w = cb1[7].x * r2.x;
  r1.w = -cb1[8].w * r0.w + 1;
  r0.w = r0.z * r0.w + cb1[7].y;
  r0.w = r1.w / r0.w;
  r2.xy = cmp(r0.xy < float2(0,0));
  r1.w = (int)r2.y | (int)r2.x;
  r1.w = (int)r1.w & 1;
  r0.xy = cmp(float2(1,1) < r0.xy);
  r0.x = (int)r0.y | (int)r0.x;
  r0.x = r0.x ? 0.000000 : 0;
  r0.x = (int)r0.x + (int)r1.w;
  r0.x = (int)r0.x;
  r0.y = cmp(9.99999975e-006 >= r0.w);
  r0.y = r0.y ? 1.000000 : 0;
  r0.x = r0.x + r0.y;
  r0.x = 100000000 * r0.x;
  r2.z = r0.w * cb1[5].z + r0.x;
  r0.xy = w1.xy * float2(2,2) + float2(-1,-1);
  r0.xy = -cb2[8].xy + r0.xy;
  r3.x = cb2[6].x;
  r3.y = cb2[7].y;
  r0.xy = r0.xy / r3.xy;
  r0.w = 1 + -r2.z;
  r0.w = cb1[8].w * r0.w + r2.z;
  r2.xy = r0.xy * r0.ww;
  r0.xy = cb0[8].xx * v1.xy;
  r0.xy = cb1[6].xy * r0.xy;
  r0.xy = floor(r0.xy);
  r0.x = dot(float2(0.0671105608,0.00583714992), r0.xy);
  r0.x = frac(r0.x);
  r0.x = 52.9829178 * r0.x;
  r0.x = frac(r0.x);
  r0.y = asint(cb0[5].x);
  r4.x = 12.9898005;
  r0.w = 0;
  r1.w = 0;

  // r2.w += 10;

  while (true) {
    r2.w = cmp((int)r1.w >= asint(cb0[5].x));
    if (r2.w != 0) break;
    r2.w = (int)r1.w;
    r2.w = 1.00010002 * r2.w;
    r2.w = floor(r2.w);
    r4.y = v1.x * 1.00000001e-010 + r2.w;
    r3.z = 78.2330017 * r4.y;
    r3.z = sin(r3.z);
    r3.z = 43758.5469 * r3.z;
    r3.z = frac(r3.z);
    r3.z = r3.z + r0.x;
    r3.z = frac(r3.z);
    r5.z = r3.z * 2 + -1;
    r3.z = dot(r4.xy, float2(1,78.2330017));
    r3.z = sin(r3.z);
    r3.z = 43758.5469 * r3.z;
    r3.z = frac(r3.z);
    r3.z = r3.z + r0.x;
    r3.z = 6.28318548 * r3.z;
    sincos(r3.z, r6.x, r7.x);
    r3.z = -r5.z * r5.z + 1;
    r3.z = sqrt(r3.z);
    r7.y = r6.x;
    r5.xy = r7.xy * r3.zz;
    r2.w = 1 + r2.w;
    r2.w = r2.w / r0.y;
    r2.w = sqrt(r2.w);
    r2.w = cb0[7].w * r2.w;
    r4.yzw = r5.xyz * r2.www;
    r2.w = dot(-r1.xyz, r4.yzw);
    r2.w = cmp(r2.w >= 0);
    r4.yzw = r2.www ? -r4.yzw : r4.yzw;
    r4.yzw = r4.yzw * r2.zzz + r2.xyz;
    r3.zw = cb2[7].xy * r4.zz;
    r3.zw = cb2[6].xy * r4.yy + r3.zw;
    r3.zw = cb2[8].xy * r4.ww + r3.zw;
    r2.w = 1 + -r4.w;
    r2.w = cb1[8].w * r2.w + r4.w;
    r3.zw = r3.zw / r2.ww;
    r3.zw = float2(1,1) + r3.zw;

    r4.yz = float2(0.5,0.5) * r3.zw;
    //r4.yz = float2(1, 1) * r3.zw;

    r4.yz = r4.yz * cb0[4].xy + cb0[4].zw;
    r5.xyzw = t1.Sample(s1_s, r4.yz).xyzw;
    r2.w = cb1[7].x * r5.x;
    r4.w = -cb1[8].w * r2.w + 1;
    r2.w = r0.z * r2.w + cb1[7].y;
    r2.w = r4.w / r2.w;
    r5.xy = cmp(r4.yz < float2(0,0));
    r4.w = (int)r5.y | (int)r5.x;
    r4.yz = cmp(float2(1,1) < r4.yz);
    r4.y = (int)r4.z | (int)r4.y;
    r4.yw = r4.yw ? float2(0,0) : 0;
    r4.y = (int)r4.y + (int)r4.w;
    r4.y = (int)r4.y;
    r4.z = cmp(9.99999975e-006 >= r2.w);
    r4.z = r4.z ? 1.000000 : 0;
    r4.y = r4.y + r4.z;
    r4.y = 100000000 * r4.y;
    r5.z = r2.w * cb1[5].z + r4.y;
    r3.zw = -cb2[8].xy * 10 + r3.zw;
    r3.zw = float2(-1,-1) + r3.zw;
    r3.zw = r3.zw / r3.xy;
    r2.w = 1 + -r5.z;
    r2.w = cb1[8].w * r2.w + r5.z;
    r5.xy = r3.zw * r2.ww;
    r4.yzw = r5.xyz + -r2.xyz;
    r2.w = dot(r4.yzw, r1.xyz);
    r2.w = -r2.z * 0.00200000009 + r2.w;
    r2.w = max(0, r2.w);
    r3.z = dot(r4.yzw, r4.yzw);
    r3.z = 9.99999975e-005 + r3.z;
    r2.w = r2.w / r3.z;
    r0.w = r2.w + r0.w;
    r1.w = (int)r1.w + 1;
  }
  r0.x = cb0[7].w * r2.z;
  r0.x = r0.w * r0.x;
  r0.z = saturate(r2.z / cb0[7].z);
  r0.w = cb0[7].y + -cb0[7].x;
  r0.z = r0.z * r0.w + cb0[7].x;
  r0.x = r0.x * r0.z;
  r0.x = r0.x / r0.y;
  r0.x = log2(r0.x);
  r0.x = 0.600000024 * r0.x;
  o0.x = exp2(r0.x);
  o0.yzw = r1.xyz * float3(0.5,0.5,0.5) + float3(0.5,0.5,0.5);
  return;
}