#include "../../common.hlsli"

Texture2D<float4> t9 : register(t9);
Texture3D<float4> t8 : register(t8);
Texture2D<float4> t7 : register(t7);
Texture2D<float4> t6 : register(t6);
Texture2D<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s9_s : register(s9);
SamplerState s8_s : register(s8);
SamplerState s7_s : register(s7);
SamplerState s6_s : register(s6);
SamplerState s5_s : register(s5);
SamplerState s4_s : register(s4);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[52];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(-0.5,-0.5) + v1.xy;
  r0.zw = r0.xy * cb0[32].zz + float2(0.5,0.5);
  r0.xy = r0.xy * cb0[32].zz + -cb0[33].xy;
  r0.xy = cb0[33].zw * r0.xy;
  r1.x = dot(r0.xy, r0.xy);
  r1.x = sqrt(r1.x);
  r1.y = cmp(0 < cb0[32].w);
  if (r1.y != 0) {
    r1.zw = cb0[32].xy * r1.xx;
    sincos(r1.z, r2.x, r3.x);
    r1.z = r2.x / r3.x;
    r1.w = 1 / r1.w;
    r1.z = r1.z * r1.w + -1;
    r1.zw = r0.xy * r1.zz + r0.zw;
  } else {
    r2.x = 1 / r1.x;
    r2.x = cb0[32].x * r2.x;
    r1.x = cb0[32].y * r1.x;
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
  r0.xyzw = float4(0.5,0.5,0.5,0.5) * r1.zwzw;
  r0.xyzw = frac(r0.xyzw);
  r0.xyzw = r0.xyzw * float4(2,2,2,2) + float4(-1,-1,-1,-1);
  r0.xyzw = float4(1,1,0.5,0.5) + -abs(r0.xyzw);
  r1.xz = r0.zw * cb0[32].zz + float2(0.5,0.5);
  r0.zw = r0.zw * cb0[32].zz + -cb0[33].xy;
  r0.zw = cb0[33].zw * r0.zw;
  r1.w = dot(r0.zw, r0.zw);
  r1.w = sqrt(r1.w);
  if (r1.y != 0) {
    r2.xy = cb0[32].xy * r1.ww;
    sincos(r2.x, r2.x, r3.x);
    r2.x = r2.x / r3.x;
    r2.y = 1 / r2.y;
    r2.x = r2.x * r2.y + -1;
    r2.xy = r0.zw * r2.xx + r1.xz;
  } else {
    r2.z = 1 / r1.w;
    r2.z = cb0[32].x * r2.z;
    r1.w = cb0[32].y * r1.w;
    r2.w = min(1, abs(r1.w));
    r3.x = max(1, abs(r1.w));
    r3.x = 1 / r3.x;
    r2.w = r3.x * r2.w;
    r3.x = r2.w * r2.w;
    r3.y = r3.x * 0.0208350997 + -0.0851330012;
    r3.y = r3.x * r3.y + 0.180141002;
    r3.y = r3.x * r3.y + -0.330299497;
    r3.x = r3.x * r3.y + 0.999866009;
    r3.y = r3.x * r2.w;
    r3.z = cmp(1 < abs(r1.w));
    r3.y = r3.y * -2 + 1.57079637;
    r3.y = r3.z ? r3.y : 0;
    r2.w = r2.w * r3.x + r3.y;
    r1.w = min(1, r1.w);
    r1.w = cmp(r1.w < -r1.w);
    r1.w = r1.w ? -r2.w : r2.w;
    r1.w = r2.z * r1.w + -1;
    r2.xy = r0.zw * r1.ww + r1.xz;
  }
  r2.xyzw = float4(0.5,0.5,0.5,0.5) * r2.xyxy;
  r2.xyzw = frac(r2.xyzw);
  r2.xyzw = r2.xyzw * float4(2,2,2,2) + float4(-1,-1,-1,-1);
  r2.xyzw = float4(1,1,1,1) + -abs(r2.xyzw);
  r0.zw = float2(0.5,0.5) * w1.xy;
  r3.xyzw = t9.Sample(s9_s, r0.zw).xyzw;
  r0.zw = w1.xy * cb0[51].xy + cb0[51].zw;
  r4.xyzw = t9.Sample(s9_s, r0.zw).xyzw;
  r0.zw = float2(0.0250000004,0.0250000004) * r3.xy;
  r1.xz = r4.xy * r4.xy;
  r0.zw = r1.xz * float2(2,2) + r0.zw;
  r1.xz = float2(0.0250000004,0.0250000004) * r4.xy;
  r1.xz = r3.xy * float2(0.100000001,0.100000001) + r1.xz;
  r0.zw = r1.xz * cb0[40].ww + r0.zw;
  r0.zw = float2(0.075000003,0.075000003) * r0.zw;
  r0.zw = r0.zw * cb0[50].ww * CUSTOM_FILM_GRAIN + v1.xy;
  r3.xyzw = t4.Sample(s4_s, v1.xy).xyzw;
  r0.zw = float2(-0.5,-0.5) + r0.zw;
  r1.xz = r0.zw * cb0[32].zz + float2(0.5,0.5);
  r0.zw = r0.zw * cb0[32].zz + -cb0[33].xy;
  r0.zw = cb0[33].zw * r0.zw;
  r1.w = dot(r0.zw, r0.zw);
  r1.w = sqrt(r1.w);
  if (r1.y != 0) {
    r3.yz = cb0[32].xy * r1.ww;
    sincos(r3.y, r5.x, r6.x);
    r3.y = r5.x / r6.x;
    r3.z = 1 / r3.z;
    r3.y = r3.y * r3.z + -1;
    r3.yz = r0.zw * r3.yy + r1.xz;
  } else {
    r3.w = 1 / r1.w;
    r3.w = cb0[32].x * r3.w;
    r4.w = cb0[32].y * r1.w;
    r5.x = min(1, abs(r4.w));
    r5.y = max(1, abs(r4.w));
    r5.y = 1 / r5.y;
    r5.x = r5.x * r5.y;
    r5.y = r5.x * r5.x;
    r5.z = r5.y * 0.0208350997 + -0.0851330012;
    r5.z = r5.y * r5.z + 0.180141002;
    r5.z = r5.y * r5.z + -0.330299497;
    r5.y = r5.y * r5.z + 0.999866009;
    r5.z = r5.x * r5.y;
    r5.w = cmp(1 < abs(r4.w));
    r5.z = r5.z * -2 + 1.57079637;
    r5.z = r5.w ? r5.z : 0;
    r5.x = r5.x * r5.y + r5.z;
    r4.w = min(1, r4.w);
    r4.w = cmp(r4.w < -r4.w);
    r4.w = r4.w ? -r5.x : r5.x;
    r3.w = r3.w * r4.w + -1;
    r3.yz = r0.zw * r3.ww + r1.xz;
  }
  r3.yz = float2(0.5,0.5) * r3.yz;
  r3.yz = frac(r3.yz);
  r3.yz = r3.yz * float2(2,2) + float2(-1,-1);
  r3.yz = float2(1,1) + -abs(r3.yz);
  r3.yz = cb0[30].zz * r3.yz;
  if (r1.y != 0) {
    r5.xy = cb0[32].xy * r1.ww;
    sincos(r5.x, r5.x, r6.x);
    r3.w = r5.x / r6.x;
    r4.w = 1 / r5.y;
    r3.w = r3.w * r4.w + -1;
    r5.xy = r0.zw * r3.ww + r1.xz;
  } else {
    r3.w = 1 / r1.w;
    r3.w = cb0[32].x * r3.w;
    r1.w = cb0[32].y * r1.w;
    r4.w = min(1, abs(r1.w));
    r5.z = max(1, abs(r1.w));
    r5.z = 1 / r5.z;
    r4.w = r5.z * r4.w;
    r5.z = r4.w * r4.w;
    r5.w = r5.z * 0.0208350997 + -0.0851330012;
    r5.w = r5.z * r5.w + 0.180141002;
    r5.w = r5.z * r5.w + -0.330299497;
    r5.z = r5.z * r5.w + 0.999866009;
    r5.w = r5.z * r4.w;
    r6.x = cmp(1 < abs(r1.w));
    r5.w = r5.w * -2 + 1.57079637;
    r5.w = r6.x ? r5.w : 0;
    r4.w = r4.w * r5.z + r5.w;
    r1.w = min(1, r1.w);
    r1.w = cmp(r1.w < -r1.w);
    r1.w = r1.w ? -r4.w : r4.w;
    r1.w = r3.w * r1.w + -1;
    r5.xy = r0.zw * r1.ww + r1.xz;
  }
  r5.xy = saturate(r5.xy);
  r0.zw = cb0[30].zz * r5.xy;
  r5.xyzw = t3.Sample(s3_s, r0.zw).xyzw;
  r6.xyzw = t2.Sample(s2_s, r3.yz).xyzw;
  r0.z = 1 + -cb0[24].w;
  r0.w = cb0[25].x * r6.x;
  r1.x = -cb0[24].w * r0.w + 1;
  r0.z = r0.z * r0.w + cb0[25].y;
  r0.z = r1.x / r0.z;
  r0.w = 1 + -r0.z;
  r0.w = r0.w * r0.w;
  r0.w = -r0.w * r0.w + 1;
  r1.xz = v1.xy * float2(2,2) + float2(-1,-1);
  r1.w = dot(r1.xz, r1.xz);
  r1.xz = r1.xz * r1.ww;
  r1.xz = cb0[42].xx * r1.xz * CUSTOM_CHROMATIC_ABERRATION;
  r0.z = cmp(0.99000001 >= r0.z);
  r0.z = r0.z ? 1.29999995 : 0.300000012;
  r3.yz = cb0[36].zw * -r1.xz;
  r3.yz = float2(0.5,0.5) * r3.yz;
  r1.w = dot(r3.yz, r3.yz);
  r1.w = sqrt(r1.w);
  r1.w = (int)r1.w;
  r1.w = max(3, (int)r1.w);
  r1.w = min(16, (int)r1.w);
  r3.y = (int)r1.w;
  r1.xz = -r1.xz / r3.yy;
  r0.z = r0.z * r0.w;
  r0.zw = float2(0.00999999978,0.000699999975) * r0.zz;
  r3.z = 0.100000001 + cb0[42].x * CUSTOM_CHROMATIC_ABERRATION;
  r0.zw = r0.zw * r3.zz + r1.xz;
  r6.yz = float2(0,1);
  r7.w = 1;
  r8.xyzw = float4(0,0,0,0);
  r9.xyzw = float4(0,0,0,0);
  r1.xz = v1.xy;
  r3.z = 0;
  while (true) {
    r3.w = cmp((int)r3.z >= (int)r1.w);
    if (r3.w != 0) break;
    r3.w = (int)r3.z;
    r3.w = 0.5 + r3.w;
    r6.x = r3.w / r3.y;
    r10.xy = float2(-0.5,-0.5) + r1.xz;
    r10.zw = r10.xy * cb0[32].zz + float2(0.5,0.5);
    r10.xy = r10.xy * cb0[32].zz + -cb0[33].xy;
    r10.xy = cb0[33].zw * r10.xy;
    r3.w = dot(r10.xy, r10.xy);
    r3.w = sqrt(r3.w);
    if (r1.y != 0) {
      r11.xy = cb0[32].xy * r3.ww;
      sincos(r11.x, r11.x, r12.x);
      r4.w = r11.x / r12.x;
      r11.x = 1 / r11.y;
      r4.w = r4.w * r11.x + -1;
      r11.xy = r10.xy * r4.ww + r10.zw;
    } else {
      r4.w = 1 / r3.w;
      r4.w = cb0[32].x * r4.w;
      r3.w = cb0[32].y * r3.w;
      r11.z = min(1, abs(r3.w));
      r11.w = max(1, abs(r3.w));
      r11.w = 1 / r11.w;
      r11.z = r11.z * r11.w;
      r11.w = r11.z * r11.z;
      r12.x = r11.w * 0.0208350997 + -0.0851330012;
      r12.x = r11.w * r12.x + 0.180141002;
      r12.x = r11.w * r12.x + -0.330299497;
      r11.w = r11.w * r12.x + 0.999866009;
      r12.x = r11.z * r11.w;
      r12.y = cmp(1 < abs(r3.w));
      r12.x = r12.x * -2 + 1.57079637;
      r12.x = r12.y ? r12.x : 0;
      r11.z = r11.z * r11.w + r12.x;
      r3.w = min(1, r3.w);
      r3.w = cmp(r3.w < -r3.w);
      r3.w = r3.w ? -r11.z : r11.z;
      r3.w = r4.w * r3.w + -1;
      r11.xy = r10.xy * r3.ww + r10.zw;
    }
    r10.xy = float2(0.5,0.5) * r11.xy;
    r10.xy = frac(r10.xy);
    r10.xy = r10.xy * float2(2,2) + float2(-1,-1);
    r10.xy = float2(1,1) + -abs(r10.xy);
    r10.xy = cb0[30].zz * r10.xy;
    r10.xyzw = t1.SampleLevel(s1_s, r10.xy, 0).xyzw;
    r11.xyzw = t7.SampleLevel(s7_s, r6.xy, 0).xyzw;
    r7.xyz = r11.xyz;
    r8.xyzw = r10.xyzw * r7.xyzw + r8.xyzw;
    r9.xyzw = r9.xyzw + r7.xyzw;
    r1.xz = r1.xz + r0.zw;
    r3.z = (int)r3.z + 1;
  }
  r1.xyzw = r8.xyzw / r9.xyzw;
  r1.xyz = r1.xyz * r3.xxx;
  r0.xyzw = r4.xyxy * float4(0.150000006,0.150000006,0.150000006,0.150000006) + r0.xyxy;
  r3.yz = saturate(r0.zw);
  r3.yz = cb0[30].zz * r3.yz;
  r7.xyzw = t5.Sample(s5_s, r3.yz).xyzw;
  r3.yz = r0.zw * cb0[38].xy + cb0[38].zw;
  r8.xyzw = t6.Sample(s6_s, r3.yz).xyzw;
  r3.y = r8.x * 0.100000001 + 0.550000012;
  r9.xyzw = float4(0.5,0.5,0.5,0.5) + -r0.zwzw;
  r10.xyzw = float4(0.100000001,0.100000001,0.100000001,0.100000001) * r9.zwzw;
  r11.xyzw = r8.xyxy * r8.xyxy;
  r11.xyzw = r11.xyzw * float4(0.200000003,0.200000003,0.200000003,0.200000003) + float4(0.99000001,0.99000001,0.980000019,0.980000019);
  r11.xyzw = -r11.xyzw * float4(0.5,0.5,0.5,0.5) + r0.zwzw;
  r11.xyzw = saturate(float4(0.5,0.5,0.5,0.5) + r11.xyzw);
  r11.xyzw = cb0[30].zzzz * r11.xyzw;
  r12.xyzw = t5.Sample(s5_s, r11.xy).xyzw;
  r11.xyzw = t5.Sample(s5_s, r11.zw).xyzw;
  r12.xyzw = r7.xyzw * float4(0.75,0.75,0.75,0.75) + r12.xyzw;
  r11.xyzw = r12.xyzw + r11.xyzw;
  r11.xyzw = float4(4,4,4,4) * r11.xyzw;
  r11.xyzw = min(float4(0.200000003,0.200000003,0.200000003,0.200000003), r11.xyzw);
  r7.xyzw = r7.xyzw * float4(0.5,0.5,0.5,0.5) + r11.xyzw;
  r6.xw = r7.xy;
  r2.xy = r2.xy * float2(-0.5,0.800000012) + r6.zw;
  r6.y = 0.100000001;
  r2.xy = saturate(r6.xy + r2.xy);
  r2.xy = cb0[30].zz * r2.xy;
  r6.xyzw = t5.Sample(s5_s, r2.xy).xyzw;
  r2.xy = r2.zw * float2(-0.5,-0.5) + r7.xy;
  r2.xy = saturate(float2(0.800000012,0.800000012) + r2.xy);
  r2.xy = cb0[30].zz * r2.xy;
  r2.xyzw = t5.Sample(s5_s, r2.xy).xyzw;
  r2.xyzw = r6.xyzw + r2.xyzw;
  r2.xyzw = min(float4(0.100000001,0.100000001,0.100000001,0.100000001), r2.xyzw);
  r2.xyzw = r7.xyzw + r2.xyzw;
  r3.z = dot(r10.zw, r10.zw);
  r3.z = rsqrt(r3.z);
  r6.xyzw = r10.xyzw * r3.zzzz;
  r3.zw = r6.zw * r3.yy;
  r3.zw = r3.zw * float2(0.899999976,0.899999976) + v1.xy;
  r3.zw = frac(r3.zw);
  r3.zw = float2(0.5,0.5) + -r3.zw;
  r3.z = dot(r3.zw, r3.zw);
  r3.z = sqrt(r3.z);
  r3.z = -r3.z * 3.25626826 + 1;
  r3.z = max(0, r3.z);
  r3.z = r3.z * r3.z;
  r0.xyzw = r6.xyzw * r3.yyyy + r0.xyzw;
  r3.yw = saturate(r0.zw);
  r3.yw = cb0[30].zz * r3.yw;
  r6.xyzw = t5.Sample(s5_s, r3.yw).xyzw;
  r7.xyzw = r9.xyzw * r8.xyxy;
  r0.xyzw = saturate(r7.xyzw * float4(0.0200000014,0.0200000014,0.0400000028,0.0400000028) + r0.xyzw);
  r0.xyzw = cb0[30].zzzz * r0.xyzw;
  r7.xyzw = t5.Sample(s5_s, r0.xy).xyzw;
  r0.xyzw = t5.Sample(s5_s, r0.zw).xyzw;
  r6.xyzw = r7.xyzw + r6.xyzw;
  r0.xyzw = r6.xyzw + r0.xyzw;
  r0.xyzw = min(float4(5,5,5,5), r0.xyzw);
  r0.xyzw = r0.xyzw * r3.zzzz;
  r0.xyzw = r0.xyzw * float4(0.200000003,0.200000003,0.200000003,0.200000003) + r2.xyzw;
  r2.x = -1 + r3.x;
  r2.x = r2.x * 0.75 + 1;
  r2.x = cb0[39].y * r2.x * CUSTOM_BLOOM;
  r0.xyzw = r2.xxxx * r0.xyzw;
  r2.xyz = cb0[39].zzz * r8.xyz * CUSTOM_LENS;
  r2.w = 0;
  r2.xyzw = float4(1,1,1,1) + r2.xyzw;
  r1.xyzw = r0.xyzw * r2.xyzw + r1.xyzw;
  r2.x = saturate(r5.w);
  r2.xy = float2(1.10000002,1.5) * r2.xx;
  r2.x = min(1, r2.x);
  r2.x = 1 + -r2.x;
  r3.xyzw = r2.xxxx * r1.xyzw;
  r5.xyzw = r5.xyzw + r5.xyzw;
  r0.xyzw = r0.xyzw * float4(0.25,0.25,0.25,0.25) + r5.xyzw;
  r0.xyzw = -r1.xyzw * r2.xxxx + r0.xyzw;
  r0.xyzw = r2.yyyy * r0.xyzw + r3.xyzw;
  r1.xyz = r0.xyz * r4.xyz;
  if (CUSTOM_FILM_GRAIN_TYPE == 0.f) {
    r1.xyz = r1.xyz * cb0[50].www * CUSTOM_FILM_GRAIN + r0.xyz;
  } else {
    r1.xyz = applyFilmGrain(r0.xyz, v1);
  }
  r1.xyz = cb0[45].xxx * r1.xyz;
  r1.xyz = lutShaper(r1.xyz);
  if (CUSTOM_LUT_SAMPLE == 0.f) {
  r1.xyz = cb0[42].zzz * r1.xyz;
  r1.w = 0.5 * cb0[42].y;
  r1.xyz = r1.xyz * cb0[42].yyy + r1.www;
  r1.xyzw = t8.Sample(s8_s, r1.xyz).xyzw;
  } else {
    r1.xyz = renodx::lut::SampleTetrahedral(t8, r1.xyz, 1 / cb0[42].y);
  }
  r1.w = cmp(cb0[50].y < 0.5);
  if (r1.w != 0) {
    r0.x = dot(r0.xyz, float3(0.272228986,0.674081981,0.0536894985));
    r0.yz = -cb0[48].xy + v1.xy;
    r2.yz = cb0[49].xx * abs(r0.zy) * min(1.f, CUSTOM_VIGNETTE);
    r0.y = cb0[26].x / cb0[26].y;
    r0.y = -1 + r0.y;
    r0.y = cb0[49].w * r0.y + 1;
    r2.x = r2.z * r0.y;
    r2.xy = saturate(r2.xy);
    r0.yz = log2(r2.xy);
    r0.yz = cb0[49].zz * r0.yz;
    r0.yz = exp2(r0.yz);
    r0.y = dot(r0.yz, r0.yz);
    r0.y = 1 + -r0.y;
    r0.y = max(0, r0.y);
    r0.y = log2(r0.y);
    r0.y = cb0[49].y * r0.y * max(1.f, CUSTOM_VIGNETTE);
    r0.y = exp2(r0.y);
    r0.z = r0.y * r0.y;
    r1.w = r0.z * r0.x;
    r2.xyz = -r0.zzz * r0.xxx + r1.xyz;
    r2.xyz = r0.yyy * r2.xyz + r1.www;
    r0.x = r0.w * cb0[45].x + -1;
    o0.w = r0.y * r0.x + 1;
  } else {
    r0.xyz = r1.xyz * cb0[47].xyz + -r1.xyz;
    r2.xyz = cb0[50].xxx * r0.xyz + r1.xyz;
    o0.w = 1;
  }
  if (CUSTOM_COUNT_OLD_2 == CUSTOM_COUNT_NEW_2) {
    r2.xyz = GradeAndDisplayMap(r2.xyz);
  }
  r0.xy = v1.xy * cb0[35].xy + cb0[35].zw;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r0.x = r0.w * 2 + -1;
  r0.y = saturate(r0.x * renodx::math::FLT_MAX + 0.5);
  r0.y = r0.y * 2 + -1;
  r0.x = 1 + -abs(r0.x);
  r0.x = sqrt(r0.x);
  r0.x = 1 + -r0.x;
  r0.x = r0.y * r0.x;
  r0.xyz = applyDither(r2.xyz, r0.x * (1.0 / 64.0));
  if (CUSTOM_COUNT_OLD == CUSTOM_COUNT_NEW) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  return;
}