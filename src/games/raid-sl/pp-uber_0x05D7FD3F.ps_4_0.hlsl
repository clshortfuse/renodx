#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Wed Jan  7 00:29:40 2026
Texture2D<float4> t6 : register(t6);

Texture2D<float4> t5 : register(t5);

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s6_s : register(s6);

SamplerState s5_s : register(s5);

SamplerState s4_s : register(s4);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[41];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  // --- Input Sampling & Linearization ---
  // Sample t2 (Main Scene?)
  r0.xyzw = t2.Sample(s2_s, v1.xy).xyzw;
  // Sample t1 
  r1.xyzw = t1.Sample(s1_s, w1.xy).xyzw;

  // Manual sRGB to Linear conversion for r1 (t1 sample)
  r0.yzw = float3(0.0773993805,0.0773993805,0.0773993805) * r1.xyz;
  r2.xyz = float3(0.0549999997,0.0549999997,0.0549999997) + r1.xyz;
  r2.xyz = float3(0.947867334,0.947867334,0.947867334) * r2.xyz;
  r2.xyz = max(float3(1.1920929e-07,1.1920929e-07,1.1920929e-07), abs(r2.xyz));
  r2.xyz = log2(r2.xyz);
  r2.xyz = float3(2.4000001,2.4000001,2.4000001) * r2.xyz;
  r2.xyz = exp2(r2.xyz);
  r3.xyz = cmp(float3(0.0404499993,0.0404499993,0.0404499993) >= r1.xyz);
  r0.yzw = r3.xyz ? r0.yzw : r2.xyz; // r0.yzw now contains Linear version of t1.rgb
  r1.xyz = r0.yzw * r0.xxx; // Apply alpha premultiplication or masking?

  // --- Blur / Bloom / Distortion Effect ---
  // Calculates offsets based on UVs and constants, samples t3 multiple times
  r0.xyzw = float4(1,1,-1,0) * cb0[32].xyxy;
  r2.xyzw = saturate(-r0.xywy * cb0[34].xxxx + v1.xyxy);
  r2.xyzw = cb0[26].xxxx * r2.xyzw;
  r3.xyzw = t3.Sample(s3_s, r2.xy).xyzw;
  r2.xyzw = t3.Sample(s3_s, r2.zw).xyzw;
  r2.xyzw = r2.xyzw * float4(2,2,2,2) + r3.xyzw; // Accumulate samples

  r3.xy = saturate(-r0.zy * cb0[34].xx + v1.xy);
  r3.xy = cb0[26].xx * r3.xy;
  r3.xyzw = t3.Sample(s3_s, r3.xy).xyzw;
  r2.xyzw = r3.xyzw + r2.xyzw;

  r3.xyzw = saturate(r0.zwxw * cb0[34].xxxx + v1.xyxy);
  r3.xyzw = cb0[26].xxxx * r3.xyzw;
  r4.xyzw = t3.Sample(s3_s, r3.xy).xyzw;
  r2.xyzw = r4.xyzw * float4(2,2,2,2) + r2.xyzw;

  r3.xy = saturate(v1.xy);
  r3.xy = cb0[26].xx * r3.xy;
  r4.xyzw = t3.Sample(s3_s, r3.xy).xyzw;
  r2.xyzw = r4.xyzw * float4(4,4,4,4) + r2.xyzw; // Center sample weight?

  r3.xyzw = t3.Sample(s3_s, r3.zw).xyzw;
  r2.xyzw = r3.xyzw * float4(2,2,2,2) + r2.xyzw;

  r3.xyzw = saturate(r0.zywy * cb0[34].xxxx + v1.xyxy);
  r3.xyzw = cb0[26].xxxx * r3.xyzw;
  r4.xyzw = t3.Sample(s3_s, r3.xy).xyzw;
  r2.xyzw = r4.xyzw + r2.xyzw;

  r3.xyzw = t3.Sample(s3_s, r3.zw).xyzw;
  r2.xyzw = r3.xyzw * float4(2,2,2,2) + r2.xyzw;

  r0.xy = saturate(r0.xy * cb0[34].xx + v1.xy);
  r0.xy = cb0[26].xx * r0.xy;
  r0.xyzw = t3.Sample(s3_s, r0.xy).xyzw;
  r0.xyzw = r2.xyzw + r0.xyzw;
  r0.xyzw = cb0[34].yyyy * r0.xyzw; // Scale final accumulation

  // --- Grain / Overlay (t4) ---
  r2.xy = v1.xy * cb0[33].xy + cb0[33].zw;
  r2.xyzw = t4.Sample(s4_s, r2.xy).xyzw;
  r3.xyzw = float4(0.0625,0.0625,0.0625,0.0625) * r0.xyzw;
  r2.xyz = cb0[34].zzz * r2.xyz;
  r2.w = 0;
  r0.xyzw = float4(0.0625,0.0625,0.0625,1) * r0.xyzw;
  r4.xyz = cb0[35].xyz * r0.xyz;
  r4.w = 0.0625 * r0.w;
  r0.xyzw = r4.xyzw + r1.xyzw; // Combine with t1 (Linear)
  r0.xyzw = r2.xyzw * r3.xyzw + r0.xyzw;

  // --- Vignette / Masking / Composition ---
  r1.x = cmp(cb0[40].y < 0.5);
  if (r1.x != 0) {
    r1.xy = -cb0[38].xy + v1.xy;
    r1.yz = cb0[39].xx * abs(r1.yx);
    r1.w = cb0[22].x / cb0[22].y;
    r1.w = -1 + r1.w;
    r1.w = cb0[39].w * r1.w + 1;
    r1.x = r1.z * r1.w;
    r1.xy = saturate(r1.xy);
    r1.xy = log2(r1.xy);
    r1.xy = cb0[39].zz * r1.xy;
    r1.xy = exp2(r1.xy);
    r1.x = dot(r1.xy, r1.xy);
    r1.x = 1 + -r1.x;
    r1.x = max(0, r1.x);
    r1.x = log2(r1.x);
    r1.x = cb0[39].y * r1.x;
    r1.x = exp2(r1.x);
    r1.yzw = float3(1,1,1) + -cb0[37].xyz;
    r1.yzw = r1.xxx * r1.yzw + cb0[37].xyz;
    // Vignette color is in r1.yzw. If vignette effect is full, it's cb0[37].
    // If r1.xxx (shape) is 1, result is 1 (white). If r1.xxx is 0, result is cb0[37].
    // We want to scale the strength of this modulation.
    r1.yzw = lerp(1.f, r1.yzw, RENODX_VIGNETTE_STRENGTH);
    r2.xyz = r1.yzw * r0.xyz;
    r1.y = -1 + r0.w;
    r2.w = r1.x * r1.y + 1;
  } else {
    // Original (or UI) composition path
    r1.xyzw = t6.Sample(s6_s, v1.xy).xyzw;
    r1.xyz = float3(1,1,1) + -cb0[37].xyz;
    r1.xyz = r1.www * r1.xyz + cb0[37].xyz;
    r1.xyz = r0.xyz * r1.xyz + -r0.xyz;
    r2.xyz = cb0[40].xxx * r1.xyz + r0.xyz;
    r0.x = -1 + r0.w;
    r2.w = r1.w * r0.x + 1;
  }

  float3 linearInput = r2.xyz; // Save Linear Input for HDR

  r2.xyzw = saturate(r2.xyzw); // Clamp for Vanilla LUT

  // --- Linear to sRGB Conversion ---
  r0.xyz = float3(12.9200001,12.9200001,12.9200001) * r2.zxy;
  r1.xyz = max(float3(1.1920929e-07,1.1920929e-07,1.1920929e-07), r2.zxy);
  r1.xyz = log2(r1.xyz);
  r1.xyz = float3(0.416666657,0.416666657,0.416666657) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.xyz = r1.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  r2.xyz = cmp(float3(0.00313080009,0.00313080009,0.00313080009) >= r2.zxy);
  r0.xyz = r2.xyz ? r0.xyz : r1.xyz; // r0 is now sRGB

  // --- Color Grading LUT (t5) ---
  // Calculate LUT coordinates from r0 (which is sRGB)
  r0.yzw = cb0[36].zzz * r0.xyz;
  r0.y = floor(r0.y);
  r1.xy = float2(0.5,0.5) * cb0[36].xy;
  r1.yz = r0.zw * cb0[36].xy + r1.xy;
  r1.x = r0.y * cb0[36].y + r1.y;
  
  // Sample LUT (slice interpolation?)
  r3.xyzw = t5.Sample(s5_s, r1.xz).xyzw;
  r2.x = cb0[36].y;
  r2.y = 0;
  r0.zw = r2.xy + r1.xz;
  r1.xyzw = t5.Sample(s5_s, r0.zw).xyzw;
  
  // Lerp between LUT samples
  r0.x = r0.x * cb0[36].z + -r0.y;
  r0.yzw = r1.xyz + -r3.xyz;
  r0.xyz = r0.xxx * r0.yzw + r3.xyz;

  // --- Redundant Conversion / Sanitization ---
  // sRGB to Linear
  r1.xyz = float3(0.0773993805,0.0773993805,0.0773993805) * r0.xyz;
  r2.xyz = float3(0.0549999997,0.0549999997,0.0549999997) + r0.xyz;
  r2.xyz = float3(0.947867334,0.947867334,0.947867334) * r2.xyz;
  r2.xyz = max(float3(1.1920929e-07,1.1920929e-07,1.1920929e-07), abs(r2.xyz));
  r2.xyz = log2(r2.xyz);
  r2.xyz = float3(2.4000001,2.4000001,2.4000001) * r2.xyz;
  r2.xyz = exp2(r2.xyz);
  r0.xyz = cmp(float3(0.0404499993,0.0404499993,0.0404499993) >= r0.xyz);
  r0.xyz = r0.xyz ? r1.xyz : r2.xyz; // r0 is Linear

  // Linear to sRGB (Again)
  r1.xyz = float3(12.9200001,12.9200001,12.9200001) * r0.xyz;
  r2.xyz = max(float3(1.1920929e-07,1.1920929e-07,1.1920929e-07), abs(r0.xyz));
  r2.xyz = log2(r2.xyz);
  r2.xyz = float3(0.416666657,0.416666657,0.416666657) * r2.xyz;
  r2.xyz = exp2(r2.xyz);
  r2.xyz = r2.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  r0.xyz = cmp(float3(0.00313080009,0.00313080009,0.00313080009) >= r0.xyz);
  r0.xyz = r0.xyz ? r1.xyz : r2.xyz; // r0 is sRGB

  float3 lutColor = r0.xyz; // Capture final SDR color

  if (RENODX_TONE_MAP_TYPE != 0.f) {
      // Decode the LUT color because prior to this it was sRGB
      float3 sdrColor = renodx::color::srgb::DecodeSafe(lutColor);
      o0.xyz = renodx::draw::ToneMapPass(linearInput, sdrColor);
      o0.w = r2.w;
      o0.xyz = renodx::effects::ApplyFilmGrain(
          o0.xyz,
          v1.xy,
          CUSTOM_RANDOM,
          CUSTOM_GRAIN_STRENGTH * 0.03f);
      o0.xyz = renodx::draw::RenderIntermediatePass(o0.xyz);
  } else {
      o0.xyz = lutColor;
      o0.w = r2.w;
  }
  return;
}