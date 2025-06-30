#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.4.1 on Sat Apr 12 15:12:04 2025
Texture2D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s4_s : register(s4);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[36];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = saturate(v1.xy);
  r0.xy = cb0[26].xx * r0.xy;
  r0.xyzw = t3.Sample(s3_s, r0.xy).xyzw;
  r1.xyzw = float4(1,1,-1,0) * cb0[32].xyxy;
  r2.xyzw = saturate(-r1.xywy * cb0[34].xxxx + v1.xyxy);
  r2.xyzw = cb0[26].xxxx * r2.xyzw;
  r3.xyzw = t3.Sample(s3_s, r2.xy).xyzw;
  r2.xyzw = t3.Sample(s3_s, r2.zw).xyzw;
  r2.xyzw = r2.xyzw * float4(2,2,2,2) + r3.xyzw;
  r3.xy = saturate(-r1.zy * cb0[34].xx + v1.xy);
  r3.xy = cb0[26].xx * r3.xy;
  r3.xyzw = t3.Sample(s3_s, r3.xy).xyzw;
  r2.xyzw = r3.xyzw + r2.xyzw;
  r3.xyzw = saturate(r1.zwxw * cb0[34].xxxx + v1.xyxy);
  r3.xyzw = cb0[26].xxxx * r3.xyzw;
  r4.xyzw = t3.Sample(s3_s, r3.xy).xyzw;
  r3.xyzw = t3.Sample(s3_s, r3.zw).xyzw;
  r2.xyzw = r4.xyzw * float4(2,2,2,2) + r2.xyzw;
  r0.xyzw = r0.xyzw * float4(4,4,4,4) + r2.xyzw;
  r0.xyzw = r3.xyzw * float4(2,2,2,2) + r0.xyzw;
  r2.xyzw = saturate(r1.zywy * cb0[34].xxxx + v1.xyxy);
  r1.xy = saturate(r1.xy * cb0[34].xx + v1.xy);
  r1.xy = cb0[26].xx * r1.xy;
  r1.xyzw = t3.Sample(s3_s, r1.xy).xyzw;
  r2.xyzw = cb0[26].xxxx * r2.xyzw;
  r3.xyzw = t3.Sample(s3_s, r2.xy).xyzw;
  r2.xyzw = t3.Sample(s3_s, r2.zw).xyzw;
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = r2.xyzw * float4(2,2,2,2) + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r0.xyzw = cb0[34].yyyy * r0.xyzw;
  r1.xyzw = float4(0.0625,0.0625,0.0625,1) * r0.xyzw;
  r0.xyzw = float4(0.0625,0.0625,0.0625,0.0625) * r0.xyzw;
  r2.xyz = cb0[35].xyz * r1.xyz;
  r2.w = 0.0625 * r1.w;
  r1.xyzw = t1.Sample(s1_s, w1.xy).xyzw;


  // srgb to linear (srgb decode)
  r3.xyz = float3(0.0549999997,0.0549999997,0.0549999997) + r1.xyz;
  r3.xyz = float3(0.947867334,0.947867334,0.947867334) * r3.xyz;
  r3.xyz = max(float3(1.1920929e-07,1.1920929e-07,1.1920929e-07), abs(r3.xyz));
  r3.xyz = log2(r3.xyz);
  r3.xyz = float3(2.4000001,2.4000001,2.4000001) * r3.xyz;
  r3.xyz = exp2(r3.xyz);
  r4.xyz = float3(0.0773993805,0.0773993805,0.0773993805) * r1.xyz;
  r5.xyz = cmp(float3(0.0404499993,0.0404499993,0.0404499993) >= r1.xyz);
  r3.xyz = r5.xyz ? r4.xyz : r3.xyz;

  // bloom????
  r4.xyzw = t2.Sample(s2_s, v1.xy).xyzw;
  r1.xyz = r4.xxx * r3.xyz;
  r1.xyzw = r1.xyzw + r2.xyzw;
  r2.xy = v1.xy * cb0[33].xy + cb0[33].zw;
  r2.xyzw = t4.Sample(s4_s, r2.xy).xyzw;
  r2.xyz = cb0[34].zzz * r2.xyz;
  r2.w = 0;
  r0.xyzw = r2.xyzw * r0.xyzw + r1.xyzw;

  float3 untonemapped = r0.xyz;

  // linear to srgb (srgb encode)
  r1.xyz = max(float3(1.1920929e-07,1.1920929e-07,1.1920929e-07), abs(r0.xyz));
  r1.xyz = log2(r1.xyz);
  r1.xyz = float3(0.416666657,0.416666657,0.416666657) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.xyz = r1.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  r2.xyz = float3(12.9200001,12.9200001,12.9200001) * r0.xyz;
  r0.xyz = cmp(float3(0.00313080009,0.00313080009,0.00313080009) >= r0.xyz);
  r0.xyz = r0.xyz ? r2.xyz : r1.xyz;
  o0.w = r0.w;

  // dithering noise
  r1.xy = v1.xy * cb0[30].xy + cb0[30].zw;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r0.w = r1.w * 2 + -1;
  r1.x = 1 + -abs(r0.w);
  r0.w = saturate(r0.w * 3.40282347e+38 + 0.5);
  r0.w = r0.w * 2 + -1;
  r1.x = sqrt(r1.x);
  r1.x = 1 + -r1.x;
  r0.w = r1.x * r0.w;
  o0.xyz = r0.www * float3(0.00392156886,0.00392156886,0.00392156886) + r0.xyz;

  float3 sdr_color = renodx::color::srgb::DecodeSafe(o0.rgb);

  o0.rgb = CustomTonemapClip(untonemapped, sdr_color);
  return;
}