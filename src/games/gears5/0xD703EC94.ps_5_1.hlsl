#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Mon Nov 23 17:46:48 2026
Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2)
{
  float4 cb2[24];
}

cbuffer cb1 : register(b1)
{
  float4 cb1[13];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[33];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb2[18].xx * float2(1.04999995,0.11500001) + float2(0.100000001,1);
  r0.zw = float2(0.5,0.5) / r0.xy;
  r1.x = 6.28318548 * cb2[17].w;
  sincos(r1.x, r1.x, r2.x);
  r3.z = 0;
  r1.yz = float2(0.5,0.5) / cb2[6].xy;
  r2.yz = asuint(cb0[32].xy);
  r2.yz = v0.xy + -r2.yz;
  r4.xy = cb0[30].zw * r2.yz;
  r2.yz = r2.yz * cb0[30].zw + float2(-0.5,-0.5);
  r4.zw = r4.xy / cb2[6].xy;
  r4.zw = float2(0.5,0.5) + r4.zw;
  r1.yz = r4.zw + -r1.yz;
  r4.zw = float2(-0.5,-0.5) + r1.yz;
  r1.yzw = t2.Sample(s2_s, r1.yz).xyw;
  r3.xy = -r4.zw;
  r3.xy = r3.zx + -r3.yz;
  r3.zw = r3.xy * r1.xx;
  r2.xw = r4.zw * r2.xx + r3.zw;
  r2.xw = float2(0.5,0.5) + r2.xw;
  r0.xy = r2.xw / r0.xy;
  r0.xy = float2(0.5,0.5) + r0.xy;
  r0.xy = r0.xy + -r0.zw;
  r0.x = t2.Sample(s2_s, r0.xy).z;
  r0.x = cb2[18].y * r0.x;
  r0.x = 0.5 * r0.x;
  r0.y = 6.28318548 * cb2[18].z;
  sincos(r0.y, r1.x, r2.x);
  r0.yz = r3.xy * r1.xx;
  r0.yz = r4.zw * r2.xx + r0.yz;
  r0.yz = float2(0.5,0.5) + r0.yz;
  r2.xw = cb2[18].ww * float2(1.04999995,0.11500001) + float2(0.100000001,1);
  r0.yz = r0.yz / r2.xw;
  r2.xw = float2(0.5,0.5) / r2.xw;
  r0.yz = float2(0.5,0.5) + r0.yz;
  r0.yz = r0.yz + -r2.xw;
  r0.y = t2.Sample(s2_s, r0.yz).z;
  r0.y = cb2[19].x * r0.y;
  r0.y = 0.5 * r0.y;
  r0.x = max(r0.x, r0.y);
  r0.y = 6.28318548 * cb2[19].y;
  sincos(r0.y, r1.x, r2.x);
  r0.yz = r3.xy * r1.xx;
  r0.yz = r4.zw * r2.xx + r0.yz;
  r0.yz = float2(0.5,0.5) + r0.yz;
  r2.xw = cb2[19].zz * float2(1.04999995,0.11500001) + float2(0.100000001,1);
  r0.yz = r0.yz / r2.xw;
  r2.xw = float2(0.5,0.5) / r2.xw;
  r0.yz = float2(0.5,0.5) + r0.yz;
  r0.yz = r0.yz + -r2.xw;
  r0.y = t2.Sample(s2_s, r0.yz).z;
  r0.y = cb2[19].w * r0.y;
  r0.y = 0.5 * r0.y;
  r0.x = max(r0.x, r0.y);
  r0.y = 6.28318548 * cb2[20].x;
  sincos(r0.y, r1.x, r2.x);
  r0.yz = r3.xy * r1.xx;
  r0.yz = r4.zw * r2.xx + r0.yz;
  r0.w = dot(r4.zw, r4.zw);
  r0.w = sqrt(r0.w);
  r0.w = 1 + -r0.w;
  r0.yz = float2(0.5,0.5) + r0.yz;
  r3.xyz = cb2[20].yyw * float3(1.04999995,0.11500001,-3) + float3(0.100000001,1,4);
  r0.yz = r0.yz / r3.xy;
  r0.yz = float2(0.5,0.5) + r0.yz;
  r2.xw = float2(0.5,0.5) / r3.xy;
  r0.yz = -r2.xw + r0.yz;
  r0.y = t2.Sample(s2_s, r0.yz).z;
  r0.y = cb2[20].z * r0.y;
  r0.y = 0.5 * r0.y;
  r0.x = max(r0.x, r0.y);
  r0.yz = float2(1,1) + -r1.yw;
  r1.x = 0.75 * r1.z;
  r1.x = cb2[17].z * -r1.x + r1.x;
  r0.z = r0.z + -r0.y;
  r0.y = cb2[17].z * r0.z + r0.y;
  r0.y = r0.y * r0.w + r1.x;
  r0.z = -r0.y * r0.x + 1;
  r1.xy = r4.xy * float2(0.349999994,1) + float2(-0.174999997,-0.5);
  r0.w = dot(r1.xy, r1.xy);
  r0.w = sqrt(r0.w);
  r1.xy = cb2[23].xx * float2(-1.25,-1.10000002) + float2(0.75,1);
  r0.w = -r1.x + r0.w;
  r1.x = r1.y + -r1.x;
  r1.x = 1 / r1.x;
  r0.w = saturate(r1.x * r0.w);
  r1.x = r0.w * -2 + 3;
  r0.w = r0.w * r0.w;
  r0.w = r1.x * r0.w;
  r0.w = cb2[20].w * r0.w;
  r1.xyzw = cb2[22].xxzx * float4(-1.25,-1.10000002,-0.0600000024,-0.149999991) + float4(0.75,1,0.50999999,0.349999994);
  r2.xw = abs(r2.yz) + -r1.zz;
  r1.z = 0.600000024 + -r1.z;
  r1.z = 1 / r1.z;
  r2.xw = saturate(r2.xw * r1.zz);
  r3.xy = r2.xw * float2(-2,-2) + float2(3,3);
  r2.xw = r2.xw * r2.xw;
  r2.xw = r3.xy * r2.xw;
  r0.w = max(r2.w, r0.w);
  r1.z = max(r2.x, r2.w);
  r1.z = 0.5 * r1.z;
  r0.w = r0.w * r1.w + r1.z;
  r0.w = 1 + -r0.w;
  r0.xz = r0.yw * r0.xz;
  r3.xy = r4.xy / cb2[10].xy;
  r4.xy = r4.xy / cb2[4].xy;
  r4.xy = float2(0.5,0.5) + r4.xy;
  r3.xy = float2(0.5,0.5) + r3.xy;
  r4.zw = float2(0.5,0.5) / cb2[10].xy;
  r3.xy = -r4.zw + r3.xy;
  r3.xy = t1.Sample(s1_s, r3.xy).xy;
  r0.w = r3.y + -r3.x;
  r0.w = cb2[16].w * r0.w + r3.x;
  r3.xy = float2(0.5,0.5) / cb2[4].xy;
  r3.xy = r4.xy + -r3.xy;
  r4.xy = float2(-0.5,-0.5) + r3.xy;
  r1.w = dot(r4.xy, r4.xy);
  r1.w = sqrt(r1.w);
  r2.x = -0.449999988 + r1.w;
  r2.x = -2.22222233 * r2.x;
  r2.x = max(0, r2.x);
  r3.w = r2.x * -2 + 3;
  r2.x = r2.x * r2.x;
  r2.x = r3.w * r2.x;
  r4.xy = cb2[21].xx * float2(-0.75,0.099999994) + float2(1,0.300000012);
  r4.zw = float2(0.100000001,0.300000012) + -r4.xy;
  r4.xy = cb2[20].ww * r4.zw + r4.xy;
  r2.x = r4.x * r2.x;
  r0.w = r0.w * r3.z + r2.x;
  r1.w = -r4.y + r1.w;
  r2.x = 1 / -r4.y;
  r1.w = saturate(r2.x * r1.w);
  r2.x = r1.w * -2 + 3;
  r1.w = r1.w * r1.w;
  r1.w = r2.x * r1.w;
  r0.w = r1.w * r0.w;
  r1.w = cb2[21].x * r0.y;
  r0.w = r1.w * r0.w;
  r1.w = 0.0500000007 * cb1[12].z;
  sincos(r1.w, r2.x, r4.x);
  r5.x = -r2.x;
  r5.y = r4.x;
  r5.z = r2.x;
  r4.y = dot(r5.zy, r2.yz);
  r4.x = dot(r5.yx, r2.yz);
  r1.w = dot(r2.yz, r2.yz);
  r1.w = sqrt(r1.w);
  r1.w = r1.w + -r1.x;
  r1.x = r1.y + -r1.x;
  r1.x = 1 / r1.x;
  r1.x = saturate(r1.w * r1.x);
  r1.yw = float2(0.5,0.5) + r4.xy;
  r1.y = t0.Sample(s0_s, r1.yw).x;
  r2.xy = r1.yy * float2(0.00300000003,0.00300000003) + r3.xy;
  r1.y = r1.y * -0.199999988 + 1;
  r3.xyzw = t1.Sample(s1_s, r2.xy).xyzw;
  r2.xy = r3.yz + -r3.xw;
  r2.xy = cb2[16].ww * r2.xy + r3.xw;
  r1.w = cb2[20].w * r2.x;
  r1.w = r0.w * 3 + r1.w;
  r0.x = r0.x * 0.300000012 + r0.w;
  r0.w = cb2[21].w * r1.w;
  r1.w = r1.x * -2 + 3;
  r1.x = r1.x * r1.x;
  r1.x = r1.w * r1.x;
  r1.x = cb2[20].w * r1.x;
  r1.x = max(r1.x, r2.w);
  r1.x = r1.x * cb2[22].w + r1.z;
  r0.y = r0.y * cb2[21].x + r1.x;
  r0.y = r0.w * r0.y + -r0.z;
  r0.y = 1 + r0.y;
  r0.y = saturate(cb2[23].y * r0.y);
  o0.w = saturate(cb2[23].w * r0.y);
  r0.y = r2.x * 0.5 + 0.5;
  r0.x = r1.y * r0.y + r0.x;
  r0.yzw = -cb2[14].xyz + cb2[13].xyz;
  r0.yzw = r2.yyy * r0.yzw + cb2[14].xyz;
  r0.xyz = r0.xxx * r0.yzw + cb2[15].xyz;
  o0.xyz = max(float3(0,0,0), r0.xyz);
  if (GEARS5_CUSTOM_HDR_ENABLED) {
    // This material blends into the post-LUT gamma-2 scene carrier.
    o0.rgb = sqrt(renodx::color::srgb::Decode(saturate(o0.rgb))
        * (GEARS5_HDR_UI_NITS / GEARS5_HDR_PEAK_NITS));
  }
  return;
}
