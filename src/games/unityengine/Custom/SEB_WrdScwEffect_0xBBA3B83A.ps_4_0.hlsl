#include "../common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[1];
}
cbuffer cb0 : register(b0){
  float4 cb0[9];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float4 v2 : TEXCOORD0,
  float4 v3 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = float4(-0.5,-0.800000012,-0.157079637,0.157079637) * cb1[0].yyyy;
  r1.xy = float2(5,5) * v2.xy;
  r1.zw = floor(r1.xy);
  r1.xy = frac(r1.xy);
  r2.xyz = float3(8,8,-1);
  while (true) {
    r2.w = cmp(1 < (int)r2.z);
    if (r2.w != 0) break;
    r3.y = (int)r2.z;
    r3.zw = r2.xy;
    r2.w = -1;
    while (true) {
      r4.x = cmp(1 < (int)r2.w);
      if (r4.x != 0) break;
      r3.x = (int)r2.w;
      r4.xy = r3.xy + r1.zw;
      r4.z = dot(r4.xy, float2(127.099998,311.700012));
      r4.x = dot(r4.xy, float2(269.5,183.300003));
      r5.xy = sin(r4.zx);
      r4.xy = float2(43758.5469,43758.5469) * r5.xy;
      r4.xy = frac(r4.xy);
      r4.xy = r4.xy * float2(6.28310013,6.28310013) + r0.xx;
      r4.xy = sin(r4.xy);
      r4.xy = r4.xy * float2(0.5,0.5) + float2(0.5,0.5);
      r4.zw = -r3.xy + r1.xy;
      r4.xy = r4.zw + -r4.xy;
      r3.x = dot(r4.xy, r4.xy);
      r4.x = 0.5 * r3.x;
      r5.xy = cmp(r4.xx < r3.zw);
      r4.z = r5.y ? r4.x : r3.w;
      r4.y = r3.z;
      r3.zw = r5.xx ? r4.xy : r4.yz;
      r2.w = (int)r2.w + 1;
    }
    r2.xy = r3.zw;
    r2.z = (int)r2.z + 1;
  }
  r0.x = r2.y + r2.x;
  sincos(r0.z, r1.x, r2.x);
  r1.yz = float2(-0.5,-0.5) + v2.xy;
  r3.x = -r1.x;
  r3.y = r2.x;
  r3.z = r1.x;
  r2.x = dot(r1.yz, r3.yz);
  r2.y = dot(r1.yz, r3.xy);
  r1.xw = float2(0.5,0.5) + r2.xy;
  r1.xw = float2(6.03999996,6.03999996) * r1.xw;
  r2.xy = r1.xw;
  r0.z = 0.5;
  r2.zw = float2(0,0);
  while (true) {
    r3.x = cmp((int)r2.w >= 3);
    if (r3.x != 0) break;
    r3.xy = floor(r2.xy);
    r3.zw = frac(r2.xy);
    r4.xyz = float3(8,8,-1);
    while (true) {
      r4.w = cmp(1 < (int)r4.z);
      if (r4.w != 0) break;
      r5.y = (int)r4.z;
      r5.zw = r4.xy;
      r4.w = -1;
      while (true) {
        r6.x = cmp(1 < (int)r4.w);
        if (r6.x != 0) break;
        r5.x = (int)r4.w;
        r6.xy = r5.xy + r3.xy;
        r6.z = dot(r6.xy, float2(127.099998,311.700012));
        r6.x = dot(r6.xy, float2(269.5,183.300003));
        r7.xy = sin(r6.zx);
        r6.xy = float2(43758.5469,43758.5469) * r7.xy;
        r6.xy = frac(r6.xy);
        r6.xy = r6.xy * float2(6.28310013,6.28310013) + r0.yy;
        r6.xy = sin(r6.xy);
        r6.xy = r6.xy * float2(0.5,0.5) + float2(0.5,0.5);
        r6.zw = -r5.xy + r3.zw;
        r6.xy = r6.zw + -r6.xy;
        r5.x = dot(r6.xy, r6.xy);
        r6.x = 0.5 * r5.x;
        r7.xy = cmp(r6.xx < r5.zw);
        r6.z = r7.y ? r6.x : r5.w;
        r6.y = r5.z;
        r5.zw = r7.xx ? r6.xy : r6.yz;
        r4.w = (int)r4.w + 1;
      }
      r4.xy = r5.zw;
      r4.z = (int)r4.z + 1;
    }
    r3.x = r4.y + r4.x;
    r3.x = r3.x * r0.z;
    r2.z = r3.x * 0.5 + r2.z;
    r2.xy = r2.xy + r2.xy;
    r0.z = 0.5 * r0.z;
    r2.w = (int)r2.w + 1;
  }
  r0.y = r2.z * 1.14285719 + -0.00999999978;
  r0.y = saturate(2.38095236 * r0.y);
  r0.z = r0.y * -2 + 3;
  sincos(r0.w, r1.x, r2.x);
  r3.x = -r1.x;
  r3.y = r2.x;
  r3.z = r1.x;
  r2.x = dot(r1.yz, r3.yz);
  r2.y = dot(r1.yz, r3.xy);
  r1.xy = float2(0.5,0.5) + r2.xy;
  r1.xy = float2(6,6) * r1.xy;
  r1.zw = floor(r1.xy);
  r1.xy = frac(r1.xy);
  r2.xy = float2(8,8);
  r0.w = -1;
  while (true) {
    r2.z = cmp(1 < (int)r0.w);
    if (r2.z != 0) break;
    r3.y = (int)r0.w;
    r2.zw = r2.yx;
    r3.z = -1;
    while (true) {
      r3.w = cmp(1 < (int)r3.z);
      if (r3.w != 0) break;
      r3.x = (int)r3.z;
      r4.xy = r3.xy + r1.zw;
      r3.w = dot(r4.xy, float2(127.099998,311.700012));
      r4.x = dot(r4.xy, float2(269.5,183.300003));
      r5.x = sin(r3.w);
      r5.y = sin(r4.x);
      r4.xy = float2(43758.5469,43758.5469) * r5.xy;
      r4.xy = frac(r4.xy);
      r4.xy = float2(6.28310013,6.28310013) * r4.xy;
      r4.xy = sin(r4.xy);
      r4.xy = r4.xy * float2(0.5,0.5) + float2(0.5,0.5);
      r3.xw = -r3.xy + r1.xy;
      r3.xw = r3.xw + -r4.xy;
      r3.x = dot(r3.xw, r3.xw);
      r4.x = 0.5 * r3.x;
      r3.xw = cmp(r4.xx < r2.zw);
      r4.z = r3.w ? r4.x : r2.w;
      r4.y = r2.z;
      r2.zw = r3.xx ? r4.xy : r4.yz;
      r3.z = (int)r3.z + 1;
    }
    r2.xy = r2.wz;
    r0.w = (int)r0.w + 1;
  }
  r0.w = -0.159999996 + r2.x;
  r0.w = saturate(3.57142854 * r0.w);
  r1.x = r0.w * -2 + 3;
  r0.yw = r0.yw * r0.yw;
  r0.w = r1.x * r0.w;
  r1.xyzw = cb1[0].yyyy * float4(0,-0.200000003,0,0.200000003) + v2.xyxy;
  r1.xyzw = float4(3,3,4,4) * r1.xyzw;
  r2.xyzw = floor(r1.xyzw);
  r1.xyzw = frac(r1.xyzw);
  r3.xy = float2(8,-1);
  while (true) {
    r3.z = cmp(1 < (int)r3.y);
    if (r3.z != 0) break;
    r4.y = (int)r3.y;
    r3.z = r3.x;
    r3.w = -1;
    while (true) {
      r4.z = cmp(1 < (int)r3.w);
      if (r4.z != 0) break;
      r4.x = (int)r3.w;
      r4.zw = r4.xy + r2.xy;
      r5.x = dot(r4.zw, float2(127.099998,311.700012));
      r4.z = dot(r4.zw, float2(269.5,183.300003));
      r5.x = sin(r5.x);
      r5.y = sin(r4.z);
      r4.zw = float2(43758.5469,43758.5469) * r5.xy;
      r4.zw = frac(r4.zw);
      r4.zw = float2(6.28310013,6.28310013) * r4.zw;
      r4.zw = sin(r4.zw);
      r4.zw = r4.zw * float2(0.5,0.5) + float2(0.5,0.5);
      r5.xy = -r4.xy + r1.xy;
      r4.xz = r5.xy + -r4.zw;
      r4.x = dot(r4.xz, r4.xz);
      r4.x = 0.5 * r4.x;
      r4.z = cmp(r4.x < r3.z);
      r3.z = r4.z ? r4.x : r3.z;
      r3.w = (int)r3.w + 1;
    }
    r3.x = r3.z;
    r3.y = (int)r3.y + 1;
  }
  r1.xy = float2(8,-1);
  while (true) {
    r2.x = cmp(1 < (int)r1.y);
    if (r2.x != 0) break;
    r2.y = (int)r1.y;
    r3.y = r1.x;
    r3.z = -1;
    while (true) {
      r3.w = cmp(1 < (int)r3.z);
      if (r3.w != 0) break;
      r2.x = (int)r3.z;
      r4.xy = r2.zw + r2.xy;
      r3.w = dot(r4.xy, float2(127.099998,311.700012));
      r4.x = dot(r4.xy, float2(269.5,183.300003));
      r5.x = sin(r3.w);
      r5.y = sin(r4.x);
      r4.xy = float2(43758.5469,43758.5469) * r5.xy;
      r4.xy = frac(r4.xy);
      r4.xy = float2(6.28310013,6.28310013) * r4.xy;
      r4.xy = sin(r4.xy);
      r4.xy = r4.xy * float2(0.5,0.5) + float2(0.5,0.5);
      r4.zw = -r2.xy + r1.zw;
      r4.xy = r4.zw + -r4.xy;
      r2.x = dot(r4.xy, r4.xy);
      r2.x = 0.5 * r2.x;
      r3.w = cmp(r2.x < r3.y);
      r3.y = r3.w ? r2.x : r3.y;
      r3.z = (int)r3.z + 1;
    }
    r1.x = r3.y;
    r1.y = (int)r1.y + 1;
  }
  r1.yz = r3.xx * float2(0.100000001,0.100000001) + v2.xy;
  r2.xyzw = t0.Sample(s0_s, r1.yz).xyzw;
  r1.xy = r1.xx * float2(0.0500000007,0.0500000007) + v2.xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.x = r1.w + -r2.w;
  r1.x = r1.x * 0.300000012 + r2.w;
  r1.yz = v2.xy * cb0[7].xy + cb0[7].zw;
  r0.w = 1.39999998 * r0.w;
  r0.y = r0.z * r0.y + r0.w;
  r0.x = r0.x * 0.5 + r0.y;
  r0.x = r1.x + r0.x;
  r0.x = -0.400000006 + r0.x;
  r1.xyzw = t1.Sample(s1_s, r1.yz).xyzw;
  r0.x = r1.w * r0.x;
  r0.x = 1.35000002 * r0.x;
  r1.xyzw = cb0[6].xyzw + -cb0[5].xyzw;
  r0.xyzw = r0.xxxx * r1.xyzw + cb0[5].xyzw;
  r0.xyzw = max(float4(9.99999975e-05,9.99999975e-05,9.99999975e-05,9.99999975e-05), r0.xyzw);
  r0.xyzw = log2(r0.xyzw);
  r0.xyzw = cb0[8].xxxx * r0.xyzw;
  r0.xyzw = exp2(r0.xyzw);
  o0.xyzw = v1.xyzw * r0.xyzw;
  if(injectedData.toneMapType >= 2.f){
    o0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(o0.xyz) : o0.xyz;
    o0.xyz = rolloff(o0.xyz, 0.85f, true);
    o0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(o0.xyz) : o0.xyz;
  }
  o0.w = saturate(o0.w);
  return;
}