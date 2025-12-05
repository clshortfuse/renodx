#include "../shared.h"

// Uberpost - character skills 2

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1)
{
  float4 cb1[26];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[94];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  const float4 icb[] = { { 0.500000, 0, 0, 0},
                              { 1.000000, 0, 0, 0},
                              { 1.500000, 0, 0, 0},
                              { 2.000000, 0, 0, 0},
                              { 2.500000, 0, 0, 0} };
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = -cb1[0].xy + v1.xy;
  r0.z = dot(r0.xy, r0.xy);
  r0.z = sqrt(r0.z);
  r0.w = log2(r0.z);
  r0.w = cb1[0].w * r0.w;
  r0.w = exp2(r0.w);
  r0.xy = r0.xy * r0.ww;
  r0.z = max(0.00999999978, r0.z);
  r0.z = 1 / r0.z;
  r0.z = -1 + r0.z;
  r0.z = cb1[25].z * r0.z + 1;
  r0.xy = r0.xy * r0.zz;
  r1.xyzw = t0.SampleLevel(s0_s, v1.xy, 0).xyzw;
  r2.xyz = r1.xyz;
  r0.z = 0;
  while (true) {
    r0.w = cmp((int)r0.z >= 5);
    if (r0.w != 0) break;
    r0.w = icb[r0.z+0].x * cb1[0].z;
    r3.xy = -r0.xy * r0.ww + v1.xy;
    r3.xyz = t0.SampleLevel(s0_s, r3.xy, 0).xyz;
    r3.xyz = r3.xyz + r2.xyz;
    r0.w = (int)r0.z + 1;
    r2.xyz = r3.xyz;
    r0.z = r0.w;
    continue;
  }
  r0.xyzw = r2.xyzz;
  r2.x = cb0[66].w;
  r2.yw = float2(0,0);
  r1.xy = v1.xy + r2.xy;
  r1.xyz = t0.SampleLevel(s0_s, r1.xy, 0).xyz;
  r3.xz = cb0[66].zw;
  r3.yw = float2(0,0);
  r4.xyzw = v1.xyxy + -r3.xyzw;
  r5.xyz = t0.SampleLevel(s0_s, r4.xy, 0).xyz;
  r2.xy = v1.xy + r3.xw;
  r3.xyz = t0.SampleLevel(s0_s, r2.xy, 0).xyz;
  r4.xyz = t0.SampleLevel(s0_s, r4.zw, 0).xyz;
  r2.x = r1.x * 0.5 + r1.y;
  r2.x = r1.z * 0.5 + r2.x;
  r2.y = r5.x * 0.5 + r5.y;
  r2.y = r5.z * 0.5 + r2.y;
  r6.xyz = float3(0.166666672,0.166666672,0.166666672) * r0.xyz;
  r0.x = r0.x * 0.0833333358 + r6.y;
  r0.x = r0.w * 0.0833333358 + r0.x;
  r0.y = r3.x * 0.5 + r3.y;
  r0.y = r3.z * 0.5 + r0.y;
  r0.z = r4.x * 0.5 + r4.y;
  r0.z = r4.z * 0.5 + r0.z;
  r7.xyz = min(r5.xyz, r3.xyz);
  r7.xyz = min(r7.xyz, r1.xyz);
  r7.xyz = min(r7.xyz, r4.xyz);
  r8.xyz = max(r5.xyz, r3.xyz);
  r8.xyz = max(r8.xyz, r1.xyz);
  r8.xyz = max(r8.xyz, r4.xyz);
  r9.xyz = float3(0.25,0.25,0.25) / r8.xyz;
  r9.xyz = r9.xyz * r7.xyz;
  r8.xyz = float3(1,1,1) + -r8.xyz;
  r7.xyz = r7.xyz * float3(4,4,4) + float3(-4,-4,-4);
  r7.xyz = float3(1,1,1) / r7.xyz;
  r7.xyz = r8.xyz * r7.xyz;
  r7.xyz = max(-r9.xyz, r7.xyz);
  r0.w = max(r7.y, r7.z);
  r0.w = max(r7.x, r0.w);
  r0.w = min(0, r0.w);
  r0.w = max(-0.1875, r0.w);
  r0.w = cb1[24].x * r0.w;
  r3.w = r2.x + r2.y;
  r3.w = r3.w + r0.y;
  r3.w = r3.w + r0.z;
  r3.w = r3.w * 0.25 + -r0.x;
  r4.w = max(r2.y, r0.x);
  r4.w = max(r4.w, r2.x);
  r5.w = max(r0.y, r0.z);
  r4.w = max(r5.w, r4.w);
  r0.x = min(r2.y, r0.x);
  r0.x = min(r2.x, r0.x);
  r0.y = min(r0.y, r0.z);
  r0.x = min(r0.x, r0.y);
  r0.x = r4.w + -r0.x;
  r0.x = 1 / r0.x;
  r0.x = saturate(abs(r3.w) * r0.x);
  r0.x = r0.x * -0.5 + 1;
  r0.x = r0.w * r0.x;
  r0.y = r0.x * 4 + 1;
  r0.y = 1 / r0.y;
  r1.xyz = r5.zxy + r1.zxy;
  r1.xyz = r1.xyz + r4.zxy;
  r1.xyz = r1.xyz + r3.zxy;
  r0.xzw = r0.xxx * r1.xyz + r6.zxy;
  r0.xyz = r0.xzw * r0.yyy;
  r1.xyz = cb0[93].xxx * r0.xyz;
  r3.xyz = t1.SampleLevel(s0_s, v1.xy, 0).xyz;
  r0.w = -cb1[9].z + 1;
  r4.xyz = r3.zxy * r0.www;
  r4.xyz = cmp(float3(0.300000012,0.300000012,0.300000012) < r4.xyz);
  r5.xyz = log2(r3.zxy);
  r5.xyz = float3(0.330000013,0.330000013,0.330000013) * r5.xyz;
  r5.xyz = exp2(r5.xyz);
  r5.xyz = r5.xyz * float3(1.49380004,1.49380004,1.49380004) + float3(-0.699999988,-0.699999988,-0.699999988);
  r0.w = max(r1.y, r1.z);
  r0.w = max(r0.w, r1.x);
  r2.xy = -cb1[10].yx + r0.ww;
  r2.x = max(0, r2.x);
  r2.x = min(cb1[10].z, r2.x);
  r6.xy = -cb1[1].xy + v1.xy;
  r3.w = -cb1[2].x + 1;
  r3.w = cb1[1].w * r3.w + cb1[2].x;
  r6.xy = abs(r6.xy) * r3.ww;
  r3.w = saturate(cb1[2].x * 1.04999995);
  r3.w = r3.w * 1.5 + -1;
  r3.w = cb1[1].w * r3.w + 1;
  r3.w = r6.x * r3.w;
  r4.w = cb1[2].x * 2 + -1;
  r4.w = cb1[1].w * r4.w + 1;
  r5.w = saturate(cb1[2].x + -2.79999995);
  r5.w = 5 * r5.w;
  r6.y = saturate(r6.y * r4.w + r5.w);
  r4.w = cb0[66].x / cb0[66].y;
  r5.w = -1 + r4.w;
  r5.w = cb1[2].w * r5.w + 1;
  r4.w = r4.w * 0.5625 + -r5.w;
  r4.w = cb1[1].w * r4.w + r5.w;
  r6.x = saturate(r4.w * r3.w);
  r6.xy = log2(r6.xy);
  r6.xy = cb1[2].zz * r6.xy;
  r6.xy = exp2(r6.xy);
  r2.x = r2.x * r2.x;
  r2.x = cb1[10].w * r2.x;
  r2.x = max(r2.x, r2.y);
  r0.w = max(9.99999975e-005, r0.w);
  r0.w = r2.x / r0.w;
  r7.xyz = r1.xyz * r0.www;
  r7.xyz = -r7.xyz * cb1[9].zzz + r1.xyz;
  r3.xyz = r4.xyz ? r5.xyz : r3.zxy;
  r3.xyz = r3.xyz * cb1[11].zxy + r7.xyz;
  r0.xyz = -r0.xyz * cb0[93].xxx + r3.xyz;
  r0.xyz = cb1[9].xxx * r0.xyz + r1.xyz;
  r0.w = dot(r6.xy, r6.xy);
  r0.w = 1 + -r0.w;
  r0.w = max(0, r0.w);
  r0.w = log2(r0.w);
  r0.w = cb1[2].y * r0.w;
  r0.w = exp2(r0.w);
  r1.xyz = -cb1[4].zxy + float3(1,1,1);
  r1.xyz = r0.www * r1.xyz + cb1[4].zxy;
  r0.xyz = r1.xyz * r0.xyz;
  r0.xyz = cb1[7].www * r0.xyz;

  // Define untonemapped
  float3 untonemapped = (r0.yzx);

  // RenoDX LUT Sampling & SRGB Encode
  /*
  renodx::lut::Config lut_config = renodx::lut::config::Create(
      s0_s,
      1.f,
      0.f,
      renodx::lut::config::type::ARRI_C1000_NO_CUT,
      renodx::lut::config::type::LINEAR);

  r0.xyz = renodx::lut::Sample(t2, lut_config, untonemapped);
  */

  // Original LUT Sampling & sRGB Encode
  r0.xyz = r0.xyz * float3(5.55555582,5.55555582,5.55555582) + float3(0.0479959995,0.0479959995,0.0479959995);
  r0.xyz = max(float3(0,0,0), r0.xyz);
  r0.xyz = log2(r0.xyz);
  r0.xyz = saturate(r0.xyz * float3(0.0734997839,0.0734997839,0.0734997839) + float3(0.386036009,0.386036009,0.386036009));
  r0.yzw = cb1[7].zzz * r0.xyz;
  r0.y = floor(r0.y);
  r1.xy = cb1[7].xy * float2(0.5,0.5);
  r1.yz = r0.zw * cb1[7].xy + r1.xy;
  r1.x = r0.y * cb1[7].y + r1.y;
  r3.xyz = t2.SampleLevel(s0_s, r1.xz, 0).xyz;
  r2.z = cb1[7].y;
  r0.zw = r1.xz + r2.zw;
  r1.xyz = t2.SampleLevel(s0_s, r0.zw, 0).xyz;
  r0.x = r0.x * cb1[7].z + -r0.y;
  r0.yzw = r1.xyz + -r3.xyz;
  r0.xyz = r0.xxx * r0.yzw + r3.xyz;
  
  r1.xyz = float3(12.9200001,12.9200001,12.9200001) * r0.xyz;
  r2.xyz = log2(abs(r0.xyz));
  r2.xyz = float3(0.416666657,0.416666657,0.416666657) * r2.xyz;
  r2.xyz = exp2(r2.xyz);
  r2.xyz = r2.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  r0.xyz = cmp(float3(0.00313080009,0.00313080009,0.00313080009) >= r0.xyz);
  r0.xyz = r0.xyz ? r1.xyz : r2.xyz;
 

  // Dithering
  r1.xy = cb0[66].xy * v1.xy;
  r0.w = dot(float2(171,231), r1.xy);
  r1.xyz = float3(0.00970873795,0.0140845068,0.010309278) * r0.www;
  r1.xyz = frac(r1.xyz);
  r1.xyz = float3(-0.5,-0.5,-0.5) + r1.xyz;
  o0.xyz = r1.xyz * float3(0.0013725491,0.0013725491,0.0013725491) + r0.xyz;

  // sRGB Decode and output
  o0.xyz = renodx::color::srgb::Decode(o0.xyz);
  o0.xyz = renodx::draw::ToneMapPass(untonemapped, o0.xyz);
  o0.xyz = renodx::draw::RenderIntermediatePass(o0.xyz);
  o0.w = min(1, r1.w);
  return;
}