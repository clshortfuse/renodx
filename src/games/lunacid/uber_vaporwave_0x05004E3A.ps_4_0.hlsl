#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.4.1 on Sat Apr 12 17:48:01 2025
Texture2D<float4> t5 : register(t5);

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s5_s : register(s5);

SamplerState s4_s : register(s4);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[37];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t1.Sample(s1_s, w1.xy).xyzw;

  // //sRGB to Linear
  // r1.xyz = float3(0.0549999997,0.0549999997,0.0549999997) + r0.xyz;
  // r1.xyz = float3(0.947867334,0.947867334,0.947867334) * r1.xyz;
  // r1.xyz = max(float3(1.1920929e-07,1.1920929e-07,1.1920929e-07), abs(r1.xyz));
  // r1.xyz = log2(r1.xyz);
  // r1.xyz = float3(2.4000001,2.4000001,2.4000001) * r1.xyz;
  // r1.xyz = exp2(r1.xyz);
  // r2.xyz = float3(0.0773993805,0.0773993805,0.0773993805) * r0.xyz;
  // r3.xyz = cmp(float3(0.0404499993,0.0404499993,0.0404499993) >= r0.xyz);
  // r1.xyz = r3.xyz ? r2.xyz : r1.xyz;

  r1.rgb = renodx::color::srgb::DecodeSafe(r0.rgb);

  // Vaporwave
  r2.xyzw = t2.Sample(s2_s, v1.xy).xyzw;
  r0.xyz = r2.xxx * r1.xyz;

  r1.xyzw = float4(-1,-1,1,1) * cb0[32].xyxy;
  //r1.xyzw = float4(-10, -10, 10, 10) * cb0[32].xyxy;

  r2.x = 0.5 * cb0[34].x;

  r3.xyzw = saturate(r1.xyzy * r2.xxxx + v1.xyxy);
  //r3.xyzw = r1.xyzy * r2.xxxx + v1.xyxy;

   r1.xyzw = saturate(r1.xwzw * r2.xxxx + v1.xyxy);
  //r1.xyzw = r1.xwzw * r2.xxxx + v1.xyxy;

  r1.xyzw = cb0[26].xxxx * r1.xyzw;
  r2.xyzw = cb0[26].xxxx * r3.xyzw;
  r3.xyzw = t3.Sample(s3_s, r2.xy).xyzw;
  r2.xyzw = t3.Sample(s3_s, r2.zw).xyzw;
  r2.xyzw = r3.xyzw + r2.xyzw;
  r3.xyzw = t3.Sample(s3_s, r1.xy).xyzw;
  r1.xyzw = t3.Sample(s3_s, r1.zw).xyzw;
  r2.xyzw = r3.xyzw + r2.xyzw;
  r1.xyzw = r2.xyzw + r1.xyzw;
  r1.xyzw = cb0[34].yyyy * r1.xyzw;
  r2.xyzw = float4(0.25,0.25,0.25,1) * r1.xyzw;
  r1.xyzw = float4(0.25,0.25,0.25,0.25) * r1.xyzw;
  r3.xyz = cb0[35].xyz * r2.xyz;
  r3.w = 0.25 * r2.w;
  r0.xyzw = r3.xyzw + r0.xyzw;
  r2.xy = v1.xy * cb0[33].xy + cb0[33].zw;
  r2.xyzw = t4.Sample(s4_s, r2.xy).xyzw;
  r2.xyz = cb0[34].zzz * r2.xyz;
  r2.w = 0;

  // Give untonemapped the unclamped value, but clamp it for lut sampling otherwise artifacts
  // r0.xyzw = saturate(r2.xyzw * r1.xyzw + r0.xyzw);
  r0.xyzw = r2.xyzw * r1.xyzw + r0.xyzw;
  float3 untonemapped = r0.rgb;
  r0.xyzw = saturate(r0.xyzw);

  // // Linear to sRGB
  // r1.xyz = max(float3(1.1920929e-07,1.1920929e-07,1.1920929e-07), r0.zxy);
  // r1.xyz = log2(r1.xyz);
  // r1.xyz = float3(0.416666657,0.416666657,0.416666657) * r1.xyz;
  // r1.xyz = exp2(r1.xyz);
  // r1.xyz = r1.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  // r2.xyz = float3(12.9200001,12.9200001,12.9200001) * r0.zxy;
  // r0.xyz = cmp(float3(0.00313080009,0.00313080009,0.00313080009) >= r0.zxy);
  // o0.w = r0.w;
  // r0.xyz = r0.xyz ? r2.xyz : r1.xyz;

  r0.rgb = renodx::color::srgb::EncodeSafe(r0.zxy);

  // LUT Sampling
  r0.yzw = cb0[36].zzz * r0.xyz;
  r0.y = floor(r0.y);
  r0.x = r0.x * cb0[36].z + -r0.y;
  r1.xy = float2(0.5,0.5) * cb0[36].xy;
  r1.yz = r0.zw * cb0[36].xy + r1.xy;
  r1.x = r0.y * cb0[36].y + r1.y;
  r2.x = cb0[36].y;
  r2.y = 0;
  r0.yz = r2.xy + r1.xz;
  r1.xyzw = t5.Sample(s5_s, r1.xz).xyzw;
  r2.xyzw = t5.Sample(s5_s, r0.yz).xyzw;
  r0.yzw = r2.xyz + -r1.xyz;
  r0.xyz = r0.xxx * r0.yzw + r1.xyz;

  float3 tonemapped_bt709 = renodx::color::srgb::DecodeSafe(r1.xyz);

  // // sRGB to Linear
  // r1.xyz = float3(0.0549999997, 0.0549999997, 0.0549999997) + r0.xyz;
  // r1.xyz = float3(0.947867334, 0.947867334, 0.947867334) * r1.xyz;
  // r1.xyz = max(float3(1.1920929e-07,1.1920929e-07,1.1920929e-07), abs(r1.xyz));
  // r1.xyz = log2(r1.xyz);
  // r1.xyz = float3(2.4000001,2.4000001,2.4000001) * r1.xyz;
  // r1.xyz = exp2(r1.xyz);
  // r2.xyz = float3(0.0773993805,0.0773993805,0.0773993805) * r0.xyz;
  // r0.xyz = cmp(float3(0.0404499993,0.0404499993,0.0404499993) >= r0.xyz);
  // r0.xyz = r0.xyz ? r2.xyz : r1.xyz;

  // // Linear to sRGB
  // r1.xyz = max(float3(1.1920929e-07,1.1920929e-07,1.1920929e-07), abs(r0.xyz));
  // r1.xyz = log2(r1.xyz);
  // r1.xyz = float3(0.416666657,0.416666657,0.416666657) * r1.xyz;
  // r1.xyz = exp2(r1.xyz);
  // r1.xyz = r1.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  // r2.xyz = float3(12.9200001,12.9200001,12.9200001) * r0.xyz;
  // r0.xyz = cmp(float3(0.00313080009,0.00313080009,0.00313080009) >= r0.xyz);
  // r0.xyz = r0.xyz ? r2.xyz : r1.xyz;

  // Dithering noise
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

  o0.rgb = CustomTonemap(untonemapped, tonemapped_bt709, sdr_color);
  return;
}