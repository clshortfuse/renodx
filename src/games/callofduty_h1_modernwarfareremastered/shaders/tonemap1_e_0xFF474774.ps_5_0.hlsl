// ---- Created with 3Dmigoto v1.3.16 on Tue Aug 12 20:03:53 2025

#include "./common.hlsl"

Texture3D<float4> t5 : register(t5);

Texture2D<float4> t4 : register(t4);

Texture2D<uint4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

SamplerState s4_s : register(s4);

SamplerState s2_s : register(s2);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2)
{
  float4 cb2[28];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  //declare renodx colors
  float3 colorUntonemapped, colorTonemapped, colorSDRNeutral;

  //color
  r0.xyzw = t4.Sample(s4_s, v1.xy).xyzw;

  //colorUntonemapped
  colorUntonemapped = r0.xyz;

  //recover r0 from Tonemap0
  Tonemap_RecoverYFromW(r0);

  //unknown
  r1.xy = cb2[23].xy * v1.xy;
  r1.xy = (int2)r1.xy;
  r0.w = (uint)cb2[0].w;
  r2.xz = (int2)r1.yx + (int2)-r0.ww;
  r1.z = r2.x;
  r1.w = 0;

  r1.z = t3.Load(r1.xzw).y;
  r3.xy = (int2)r1.yx + (int2)r0.ww;
  r3.zw = r1.xw;
  r0.w = t3.Load(r3.zxw).y;
  r2.yw = r1.yw;
  r1.x = t3.Load(r2.zyw).y;
  r2.xzw = r3.yww;
  r1.y = t3.Load(r2.xyz).y;
  r0.w = max((uint)r1.z, (uint)r0.w);
  r1.x = max((uint)r1.x, (uint)r1.y);
  r0.w = max((uint)r1.x, (uint)r0.w);
  r0.w = (uint)r0.w >> 5;
  r0.w = cmp((int)r0.w == 1);
  r1.x = t2.SampleLevel(s0_s, v1.xy, 0).x;
  r1.y = cmp(0.984375 < r1.x);
  r1.z = r1.y ? 0.100000001 : cb2[27].x;
  r1.yw = r1.yy ? float2(64,-63) : float2(1,0);
  r1.x = r1.y * r1.x + r1.w;
  r1.x = max(9.99999994e-009, r1.x);
  r1.x = r1.z / r1.x;
  r1.x = saturate(0.00033333333 * r1.x);
  r1.x = 1 + -r1.x;
  r1.x = cb2[23].z * r1.x;
  r1.xyz = cb2[1].xyz * r1.xxx;
  r1.w = 0;
  r2.xyzw = v1.xyxy + r1.xwyw;
  r3.x = t4.Sample(s4_s, r2.xy).x;
  r3.y = t4.Sample(s4_s, r2.zw).y;
  r1.xy = v1.xy + r1.zw;
  r3.z = t4.Sample(s4_s, r1.xy).z;
  if (r0.w != 0) {
    r1.xyz = r3.xyz + -r0.xyz;
    r0.xyz = cb2[1].www * r1.xyz + r0.xyz;
  }
  r0.xyz = saturate(r0.xyz);
  
  //colorSDRNeutral
  colorSDRNeutral = r0.xyz;
  
  //to srgb 
  r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
  // {   
  //   r1.xyz = cmp(float3(0.00313080009,0.00313080009,0.00313080009) >= r0.xyz); //(different order than other, but same)
  //   r2.xyz = float3(12.9200001,12.9200001,12.9200001) * r0.xyz;
  //   r0.xyz = log2(r0.xyz);
  //   r0.xyz = float3(0.416666657,0.416666657,0.416666657) * r0.xyz;
  //   r0.xyz = exp2(r0.xyz);

  //   r0.xyz = r0.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  //   r0.xyz = r1.xyz ? r2.xyz : r0.xyz;
  // }
  
  //LUT
  r0.xyz = r0.xyz * float3(0.96875,0.96875,0.96875) + float3(0.015625,0.015625,0.015625);
  r0.xyz = t5.Sample(s2_s, r0.xyz).xyz;

  //r0.w
  r0.w = dot(r0.xyz, float3(0.298999995,0.587000012,0.114));

  //More color correct tied to Game Brightness
  {
    r1.x = cb2[3].w * r0.w + cb2[2].w;
    r0.w = saturate(r0.w);
    r1.yzw = r0.www + -r0.xyz;
    r0.xyz = r1.xxx * r1.yzw + r0.xyz;
    
    r1.xyz = cb2[4].xyz * r0.www + cb2[3].xyz;
    r1.xyz = r1.xyz * r0.www + cb2[2].xyz;
    r0.xyz = r0.xyz * r1.xyz + cb2[5].xyz;
  }

  //colorTonemapped
  colorTonemapped = r0.xyz;

  //ToneMapPass
  Tonemap_Do(r0, colorUntonemapped, colorTonemapped/* , colorSDRNeutral */, v1, t4);

  //out
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}