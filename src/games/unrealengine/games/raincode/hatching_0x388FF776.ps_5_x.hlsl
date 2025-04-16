#include "../../common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Sun Dec 29 18:09:45 2024
Texture2D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<uint4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2)
{
  float4 cb2[18];
}

cbuffer cb1 : register(b1)
{
  float4 cb1[133];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[39];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  float3 tonemapped, neutral_sdr = 0.f;

  r0.x = -cb2[17].x + cb2[16].w;
  r0.yz = -cb2[16].xz + cb2[15].ww;
  r1.xy = asuint(cb0[37].xy);
  r1.xy = v0.xy + -r1.xy;
  r1.xy = cb0[38].zw * r1.xy;
  r1.zw = r1.xy * cb0[5].xy + cb0[4].xy;
  r2.xyz = t4.Sample(s2_s, r1.zw).xyz;

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    tonemapped = r2.rgb;
    tonemapped = renodx::draw::InvertIntermediatePass(tonemapped);
    neutral_sdr = saturate(renodx::tonemap::renodrt::NeutralSDR(tonemapped));
    r2.rgb = renodx::color::srgb::Encode(neutral_sdr);
  }
  
  r0.w = dot(r2.xyz, float3(0.300000012,0.589999974,0.109999999));
  r1.z = 1 + -r0.w;
  r1.w = saturate(r1.z / cb2[16].y);
  r1.z = saturate(r1.z + r1.z);
  r0.z = r1.w * r0.z + cb2[16].z;
  r1.w = saturate(r0.w / cb2[15].z);
  r0.w = saturate(r0.w + r0.w);
  r0.y = r1.w * r0.y + cb2[16].x;
  r1.w = floor(r1.w);
  r0.z = r0.z + -r0.y;
  r0.y = r1.w * r0.z + r0.y;
  r0.x = saturate(r0.y * r0.x + cb2[17].x);
  r3.xyz = float3(1,1,1) + -r2.xyz;
  
  r3.xyz = saturate(r3.xyz * cb2[5].xyz + r2.xyz);
  r3.xyz = saturate(cb2[7].xyz * r3.xyz);
  r4.xyz = saturate(cb2[9].xyz + r3.xyz);
  r4.xyz = saturate(cb2[11].xyz * r4.xyz);
  
  r3.xyz = -r4.xyz + r3.xyz;
  r3.xyz = r0.xxx * r3.xyz + r4.xyz;
  r0.x = 1 + -r0.x;
  r0.xyz = r0.xxx + -r3.xyz;
  r0.xyz = cb2[17].yyy * r0.xyz + r3.xyz;
  r3.xy = cb2[14].xx + -cb2[14].yz;
  r1.z = r1.z * r3.y + cb2[14].z;
  r1.w = r0.w * r3.x + cb2[14].y;
  r0.w = floor(r0.w);
  r1.z = r1.z + -r1.w;
  r0.w = r0.w * r1.z + r1.w;
  r0.w = 1 + -r0.w;
  r1.z = cb2[14].w + -cb2[3].x;
  r0.w = saturate(r0.w * r1.z + cb2[3].x);
  r0.w = cb2[15].x * r0.w;
  r1.zw = cb2[1].xy * r1.xy;
  r1.xy = r1.xy * cb1[130].xy + cb1[129].xy;
  r1.xy = cb1[132].zw * r1.xy;
  r3.xyz = t3.Sample(s1_s, r1.zw).xyz;
  r3.xyz = r2.xyz * r3.xyz + -r2.xyz;
  r3.xyz = r0.www * r3.xyz + r2.xyz;
  r0.xyz = min(r3.xyz, r0.xyz);
  r2.xyz = r2.xyz + -r0.xyz;
  r0.w = t0.SampleLevel(s0_s, r1.xy, 0).x;
  r1.z = r0.w * cb1[65].z + -cb1[65].w;
  r0.w = r0.w * cb1[65].x + cb1[65].y;
  r1.z = 1 / r1.z;
  r0.w = r1.z + r0.w;
  r1.z = t1.SampleLevel(s0_s, r1.xy, 0).x;
  r1.xy = cb1[132].xy * r1.xy;
  r1.xy = trunc(r1.xy);
  r3.xy = (int2)r1.xy;
  r1.x = r1.z * cb1[65].z + -cb1[65].w;
  r1.y = r1.z * cb1[65].x + cb1[65].y;
  r1.x = 1 / r1.x;
  r1.x = r1.y + r1.x;
  r1.y = -r1.x + r0.w;
  r0.w = cmp(r0.w >= r1.x);
  r0.w = r0.w ? 1.000000 : 0;
  r1.x = cmp(9.99999975e-06 < abs(r1.y));
  r0.w = r1.x ? r0.w : 1;
  r3.zw = float2(0,0);
  r1.x = t2.Load(r3.xyz).y;
  r1.x = (uint)r1.x;
  r1.y = cmp(r1.x >= 10);
  r1.x = -10 + r1.x;
  r1.x = cmp(0.899999976 < abs(r1.x));
  r1.y = r1.y ? 0 : r0.w;
  r0.w = r1.x ? r1.y : r0.w;
  r0.xyz = r0.www * r2.xyz + r0.xyz;
  r1.xyz = cb2[12].xyz + -r0.xyz;
  r0.xyz = cb2[17].zzz * r1.xyz + r0.xyz;
  o0.xyz = max(float3(0,0,0), r0.xyz);
  o0.w = 1;

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    o0.rgb = renodx::color::srgb::Decode(o0.rgb);
    o0.rgb = renodx::tonemap::UpgradeToneMap(tonemapped, neutral_sdr, o0.rgb, 1.f);
    o0.rgb = renodx::draw::RenderIntermediatePass(o0.rgb);
  }

  return;
}