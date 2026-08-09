Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb2 : register(b2){
  float4 cb2[1];
}
cbuffer cb1 : register(b1){
  float4 cb1[7];
}
cbuffer cb0 : register(b0){
  float4 cb0[15];
}

#define cmp -

void main(
  float2 v0 : TEXCOORD0,
  float2 w0 : TEXCOORD3,
  float4 v1 : SV_POSITION0,
  float4 v2 : COLOR0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(0,-0.5) + v0.xy;
  r1.xw = float2(24,19);
  r1.yz = cb0[13].yy;
  r0.zw = r1.xy * r0.xy;
  r0.zw = r0.zw * r1.zw;
  r0.zw = floor(r0.zw);
  r0.zw = float2(4,4) * r0.zw;
  r1.xy = cmp(cb1[0].xy >= -cb1[0].xy);
  r1.xy = r1.xy ? float2(1,1) : float2(-1,-1);
  r1.zw = cb1[0].xy * r1.xy;
  r1.zw = frac(r1.zw);
  r1.xy = r1.xy * r1.zw;
  r1.xy = r1.xy * float2(12,12) + float2(50,50);
  r1.xy = floor(r1.xy);
  r0.zw = r1.xy * r0.zw;
  r0.z = dot(r0.zw, float2(127.099998,311.700012));
  r0.z = sin(r0.z);
  r0.z = 43758.5469 * r0.z;
  r0.z = frac(r0.z);
  r0.z = cb2[0].x + r0.z;
  r0.w = cmp(r0.z >= -r0.z);
  r0.w = r0.w ? 1 : -1;
  r0.z = r0.z * r0.w;
  r0.z = frac(r0.z);
  r0.z = r0.w * r0.z;
  r0.w = r0.z * r0.z;
  r0.z = r0.z * r0.w;
  r0.z = cb0[13].x * r0.z;
  r2.xw = float2(38,14);
  r2.yz = cb0[13].yy;
  r0.xy = r2.xy * r0.xy;
  r0.xy = r0.xy * r2.zw;
  r0.xy = floor(r0.xy);
  r0.xy = float2(4,4) * r0.xy;
  r0.xy = r0.xy * r1.xy;
  r1.xy = float2(2,1) * r1.xy;
  r0.w = dot(r1.xy, float2(127.099998,311.700012));
  r0.w = sin(r0.w);
  r0.w = 43758.5469 * r0.w;
  r0.w = frac(r0.w);
  r0.x = dot(r0.xy, float2(127.099998,311.700012));
  r0.x = sin(r0.x);
  r0.x = 43758.5469 * r0.x;
  r0.x = frac(r0.x);
  r0.xw = cb2[0].xx + r0.xw;
  r0.y = cmp(r0.x >= -r0.x);
  r0.y = r0.y ? 1 : -1;
  r0.x = r0.x * r0.y;
  r0.x = frac(r0.x);
  r0.x = r0.y * r0.x;
  r0.y = r0.x * r0.x;
  r0.x = r0.x * r0.y;
  r0.x = r0.z * r0.x;
  r0.x = 0.0199999996 * r0.x;
  r0.y = cmp(r0.w >= -r0.w);
  r0.y = r0.y ? 1 : -1;
  r0.z = r0.w * r0.y;
  r0.z = frac(r0.z);
  r0.y = r0.y * r0.z;
  r0.x = r0.x * r0.y;
  r1.xyz = cb2[0].xxx + cb1[0].xyw;
  r2.xy = cb0[11].xy * r1.xx;
  r2.zw = cmp(r2.xy >= -r2.xy);
  r2.zw = r2.zw ? float2(1,1) : float2(-1,-1);
  r2.xy = r2.xy * r2.zw;
  r2.xy = frac(r2.xy);
  r2.xy = r2.zw * r2.xy + w0.xy;
  r2.xyzw = t0.Sample(s1_s, r2.xy).xyzw;
  r1.w = -0.5 + r2.x;
  r1.x = cb0[5].y * r1.x;
  r1.xw = float2(50,0.200000003) * r1.xw;
  sincos(r1.x, r1.x, r2.x);
  r1.x = cb0[5].z * r1.x;
  r2.x = cb0[5].w * r2.x;
  r2.y = 0.00999999978 * r2.x;
  r2.x = 0.0120000001 * r1.x;
  r2.xy = v0.xy + r2.xy;
  r1.xw = r1.ww * cb0[11].zz + r2.xy;
  r2.y = cb0[6].w * cb0[2].x;
  r2.z = cb0[7].x * cb0[2].y;
  r2.xy = r2.yz + -r1.xw;
  r2.zw = cmp(r2.xy >= -r2.xy);
  r2.zw = r2.zw ? float2(1,1) : float2(-1,-1);
  r2.xy = r2.xy * r2.zw;
  r2.xy = frac(r2.xy);
  r2.yz = r2.zw * r2.xy;
  r2.w = cb1[6].x / cb1[6].y;
  r2.x = r2.y * r2.w;
  r2.y = dot(r2.xz, r2.xz);
  r2.y = sqrt(r2.y);
  r1.y = cb0[6].y * r1.y;
  r1.z = r1.z * cb0[13].z + 0.0500000007;
  r1.z = frac(r1.z);
  r1.y = r2.y * cb0[6].x + -r1.y;
  r1.y = sin(r1.y);
  r2.xy = r2.xz * r1.yy;
  r1.y = 0.00100000005 * cb0[6].z;
  r1.xy = r2.xy * r1.yy + r1.xw;
  r0.yw = float2(0,0);
  r0.xy = r1.xy + r0.xy;
  r2.xyzw = t1.Sample(s0_s, r0.xy).xyzw;
  r0.xy = v2.yw * r2.yw;
  r0.z = -0.100000001 * cb0[12].z;
  r0.zw = r1.xy + r0.zw;
  r2.xyzw = t1.Sample(s0_s, r0.zw).xyzw;
  r0.zw = v2.zw * r2.zw;
  r2.z = 0.100000001 * cb0[12].z;
  r2.w = 0;
  r1.xy = r2.zw + r1.xy;
  r2.xyzw = t1.Sample(s0_s, r1.xy).xyzw;
  r1.xy = v2.xw * r2.xw;
  r1.w = max(r1.y, r0.w);
  r0.z = r0.z * r0.w;
  r0.w = r1.x * r1.y;
  r1.x = cb0[12].w * r1.w;
  r0.y = max(r1.x, r0.y);
  r1.x = r0.y * r0.y;
  r1.x = cb0[9].x * r1.x;
  r1.xyw = cb0[8].xyz * r1.xxx;
  r2.x = 0.0174532942 * cb0[11].w;
  sincos(r2.x, r2.x, r3.x);
  r2.y = cb0[12].y * cb0[12].x;
  r2.z = r2.y * r3.x;
  r2.x = r2.y * r2.x;
  r3.xyzw = float4(0.412999988,0.300000012,0.588,0.885999978) * r2.zzzz;
  r4.xyzw = float4(0.700999975,0.587000012,0.114,0.298999995) * r2.zzzz;
  r2.yz = cb0[12].yy * float2(0.298999995,0.587000012) + -r3.yz;
  r2.z = -r2.x * 1.04999995 + r2.z;
  r2.y = r2.x * 1.25 + r2.y;
  r2.z = r2.z * r0.x;
  r2.y = r2.y * r0.w + r2.z;
  r2.z = cb0[12].y * 0.114 + r3.w;
  r2.w = cb0[12].y * 0.587000012 + r3.x;
  r2.w = r2.x * 0.0350000001 + r2.w;
  r2.w = r2.w * r0.x;
  r2.z = -r2.x * 0.202999994 + r2.z;
  r3.z = r2.z * r0.z + r2.y;
  r2.yz = cb0[12].yy * float2(0.587000012,0.298999995) + -r4.yw;
  r2.y = r2.x * 0.330000013 + r2.y;
  r2.z = -r2.x * 0.328000009 + r2.z;
  r2.z = r2.z * r0.w + r2.w;
  r0.x = r2.y * r0.x;
  r2.y = cb0[12].y * 0.298999995 + r4.x;
  r2.w = cb0[12].y * 0.114 + -r4.z;
  r2.y = r2.x * 0.167999998 + r2.y;
  r0.x = r2.y * r0.w + r0.x;
  r0.w = -r2.x * 0.497000009 + r2.w;
  r2.x = r2.x * 0.291999996 + r2.w;
  r3.y = r2.x * r0.z + r2.z;
  r3.x = r0.w * r0.z + r0.x;
  r0.xzw = r3.xyz * r1.xyw;
  r2.xyz = r3.xyz * cb0[9].yyy + r0.xzw;
  r0.x = 1 + -cb0[13].w;
  r0.x = cmp(r0.x >= r1.z);
  r0.x = r0.x ? 1.000000 : 0;
  r0.x = saturate(r0.y * r0.x + cb0[14].x);
  r0.x = r0.y * r0.x;
  r2.w = cb0[5].x * r0.x;
  o0.xyzw = cb0[4].xyzw * r2.xyzw;
  o0 = saturate(o0);
  return;
}