// ---- Created with 3Dmigoto v1.3.16 on Tue Aug 12 12:44:40 2025

#include "./common.hlsl"

Texture2D<float4> t4 : register(t4);

Texture3D<float4> t2 : register(t2);

SamplerState s4_s : register(s4);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2)
{
  float4 cb2[23];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  //declare renodx colors
  float3 colorUntonemapped, colorTonemapped, colorSDRNeutral;

  //CA coords offset
  r0.xyz = cb2[22].zzz * cb2[0].xyz;
  r0.w = 0;
  r1.xy = v1.xy + r0.zw;
  r0.xyzw = v1.xyxy + r0.xwyw;

  //CA sample
  r1.z = t4.Sample(s4_s, r1.xy).z;
  r1.x = t4.Sample(s4_s, r0.xy).x;
  r1.y = t4.Sample(s4_s, r0.zw).y;

  //color
  r0.xyzw = t4.Sample(s4_s, v1.xy).xyzw;

  //CA composite
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = cb2[0].www * r1.xyz + r0.xyz;

  //colorUntonemapped
  colorUntonemapped = r0.xyz;

  //recover r0 from Tonemap0
  Tonemap_RecoverYFromW(r0);

  //color clamp
  r0.xyz = saturate(r0.xyz);

  //colorSDRNeutral
  colorSDRNeutral = r0.xyz;

  ///to srgb
  r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
  // {  r1.xyz = log2(r0.xyz);
  //   r1.xyz = float3(0.416666657,0.416666657,0.416666657) * r1.xyz; //2.4
  //   r1.xyz = exp2(r1.xyz);

  //   r1.xyz = r1.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  //   r2.xyz = cmp(float3(0.00313080009,0.00313080009,0.00313080009) >= r0.xyz);
  //   r0.xyz = float3(12.9200001,12.9200001,12.9200001) * r0.xyz;
  //   r0.xyz = r2.xyz ? r0.xyz : r1.xyz;
  // }

  
  //LUT
  r0.xyz = r0.xyz * float3(0.96875,0.96875,0.96875) + float3(0.015625,0.015625,0.015625); //some offset idk
  r0.xyz = t2.Sample(s0_s, r0.xyz).xyz;

  //r0.w
  r0.w = dot(r0.xyz, float3(0.298999995,0.587000012,0.114));

  //More color correct tied to Game Brightness
  {
    r1.x = cb2[2].w * r0.w + cb2[1].w;
    r0.w = saturate(r0.w);
    r1.yzw = r0.www + -r0.xyz;
    r0.xyz = r1.xxx * r1.yzw + r0.xyz;
    
    r1.xyz = cb2[3].xyz * r0.www + cb2[2].xyz;
    r1.xyz = r1.xyz * r0.www + cb2[1].xyz;
    r0.xyz = r0.xyz * r1.xyz + cb2[4].xyz;
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