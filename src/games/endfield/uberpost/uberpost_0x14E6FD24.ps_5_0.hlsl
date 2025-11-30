#include "../shared.h"

// Uberpost - main shader 1

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1)
{
  float4 cb1[25];
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
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xz = cb0[66].zw;
  r0.yw = float2(0,0);
  r1.xy = v1.xy + r0.xw;
  r0.xyzw = v1.xyxy + -r0.xyzw;
  r1.xyz = t0.SampleLevel(s0_s, r1.xy, 0).xyz;
  r1.w = r1.x * 0.5 + r1.y;
  r1.w = r1.z * 0.5 + r1.w;
  r2.xyz = t0.SampleLevel(s0_s, r0.zw, 0).xyz;
  r0.xyz = t0.SampleLevel(s0_s, r0.xy, 0).xyz;
  r0.w = r2.x * 0.5 + r2.y;
  r0.w = r2.z * 0.5 + r0.w;
  r2.w = max(r1.w, r0.w);
  r3.x = r0.x * 0.5 + r0.y;
  r3.x = r0.z * 0.5 + r3.x;
  r4.xyzw = t0.SampleLevel(s0_s, v1.xy, 0).xyzw;
  r3.y = r4.x * 0.5 + r4.y;
  r3.y = r4.z * 0.5 + r3.y;
  r3.z = max(r3.x, r3.y);
  r5.x = cb0[66].w;
  r5.yw = float2(0,0);
  r5.xy = v1.xy + r5.xy;
  r6.xyz = t0.SampleLevel(s0_s, r5.xy, 0).xyz;
  r3.w = r6.x * 0.5 + r6.y;
  r3.w = r6.z * 0.5 + r3.w;
  r3.z = max(r3.w, r3.z);
  r2.w = max(r3.z, r2.w);
  r3.z = min(r3.x, r3.y);
  r3.x = r3.w + r3.x;
  r3.z = min(r3.w, r3.z);
  r3.x = r3.x + r1.w;
  r1.w = min(r1.w, r0.w);
  r0.w = r3.x + r0.w;
  r0.w = r0.w * 0.25 + -r3.y;
  r1.w = min(r3.z, r1.w);
  r1.w = r2.w + -r1.w;
  r1.w = 1 / r1.w;
  r0.w = saturate(r1.w * abs(r0.w));
  r0.w = r0.w * -0.5 + 1;
  r3.xyz = max(r0.xyz, r1.xyz);
  r3.xyz = max(r6.xyz, r3.xyz);
  r3.xyz = max(r3.xyz, r2.xyz);
  r7.xyz = float3(0.25,0.25,0.25) / r3.xyz;
  r3.xyz = float3(1,1,1) + -r3.xyz;
  r8.xyz = min(r0.xyz, r1.xyz);
  r0.xyz = r6.zxy + r0.zxy;
  r6.xyz = min(r8.xyz, r6.xyz);
  r6.xyz = min(r6.xyz, r2.xyz);
  r0.xyz = r0.xyz + r2.zxy;
  r0.xyz = r0.xyz + r1.zxy;
  r1.xyz = r6.xyz * r7.xyz;
  r2.xyz = r6.xyz * float3(4,4,4) + float3(-4,-4,-4);
  r2.xyz = float3(1,1,1) / r2.xyz;
  r2.xyz = r3.xyz * r2.xyz;
  r1.xyz = max(r2.xyz, -r1.xyz);
  r1.y = max(r1.y, r1.z);
  r1.x = max(r1.x, r1.y);
  r1.x = min(0, r1.x);
  r1.x = max(-0.1875, r1.x);
  r1.x = cb1[24].x * r1.x;
  r0.w = r1.x * r0.w;
  r0.xyz = r0.www * r0.xyz + r4.zxy;
  r0.w = r0.w * 4 + 1;
  r0.w = 1 / r0.w;
  r0.xyz = r0.xyz * r0.www;
  o0.w = min(1, r4.w);
  r1.xyz = cb0[93].xxx * r0.xyz;
  r0.w = max(r1.y, r1.z);
  r0.w = max(r0.w, r1.x);
  r2.xy = -cb1[10].yx + r0.ww;
  r0.w = max(9.99999975e-005, r0.w);
  r1.w = max(0, r2.x);
  r1.w = min(cb1[10].z, r1.w);
  r1.w = r1.w * r1.w;
  r1.w = cb1[10].w * r1.w;
  r1.w = max(r1.w, r2.y);
  r0.w = r1.w / r0.w;
  r2.xyz = r1.xyz * r0.www;
  r2.xyz = -r2.xyz * cb1[9].zzz + r1.xyz;
  r3.xyz = t1.SampleLevel(s0_s, v1.xy, 0).xyz;
  r4.xyz = log2(r3.zxy);
  r4.xyz = float3(0.330000013,0.330000013,0.330000013) * r4.xyz;
  r4.xyz = exp2(r4.xyz);
  r4.xyz = r4.xyz * float3(1.49380004,1.49380004,1.49380004) + float3(-0.699999988,-0.699999988,-0.699999988);
  r0.w = -cb1[9].z + 1;
  r6.xyz = r3.zxy * r0.www;
  r6.xyz = cmp(float3(0.300000012,0.300000012,0.300000012) < r6.xyz);
  r3.xyz = r6.xyz ? r4.xyz : r3.zxy;
  r2.xyz = r3.xyz * cb1[11].zxy + r2.xyz;
  r0.xyz = -r0.xyz * cb0[93].xxx + r2.xyz;
  r0.xyz = cb1[9].xxx * r0.xyz + r1.xyz;
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
  r1.xy = cb1[7].xy * float2(0.5,0.5);
  r1.yz = r0.zw * cb1[7].xy + r1.xy;
  r0.y = floor(r0.y);
  r1.x = r0.y * cb1[7].y + r1.y;
  r0.x = r0.x * cb1[7].z + -r0.y;
  r5.z = cb1[7].y;
  r0.yz = r1.xz + r5.zw;
  r1.xyz = t2.SampleLevel(s0_s, r1.xz, 0).xyz;
  r0.yzw = t2.SampleLevel(s0_s, r0.yz, 0).xyz;
  r0.yzw = r0.yzw + -r1.xyz;
  r0.xyz = r0.xxx * r0.yzw + r1.xyz;

  r1.xyz = log2(abs(r0.xyz));
  r1.xyz = float3(0.416666657,0.416666657,0.416666657) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.xyz = r1.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  r2.xyz = float3(12.9200001,12.9200001,12.9200001) * r0.xyz;
  r0.xyz = cmp(float3(0.00313080009,0.00313080009,0.00313080009) >= r0.xyz);
  r0.xyz = r0.xyz ? r2.xyz : r1.xyz;


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
  return;
}