#include "./common.hlsli"

Texture3D<float4> t5 : register(t5);

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

cbuffer cb0 : register(b0) {
  float4 cb0[37];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    float2 w1: TEXCOORD1,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = saturate(v1.xy);
  r0.xy = cb0[26].xx * r0.xy;
  r0.xyzw = t3.Sample(s3_s, r0.xy).xyzw;
  r1.xyzw = float4(1, 1, -1, 0) * cb0[32].xyxy;
  r2.xyzw = saturate(-r1.xywy * cb0[34].xxxx + v1.xyxy);
  r2.xyzw = cb0[26].xxxx * r2.xyzw;
  r3.xyzw = t3.Sample(s3_s, r2.xy).xyzw;
  r2.xyzw = t3.Sample(s3_s, r2.zw).xyzw;
  r2.xyzw = r2.xyzw * float4(2, 2, 2, 2) + r3.xyzw;
  r3.xy = saturate(-r1.zy * cb0[34].xx + v1.xy);
  r3.xy = cb0[26].xx * r3.xy;
  r3.xyzw = t3.Sample(s3_s, r3.xy).xyzw;
  r2.xyzw = r3.xyzw + r2.xyzw;
  r3.xyzw = saturate(r1.zwxw * cb0[34].xxxx + v1.xyxy);
  r3.xyzw = cb0[26].xxxx * r3.xyzw;
  r4.xyzw = t3.Sample(s3_s, r3.xy).xyzw;
  r3.xyzw = t3.Sample(s3_s, r3.zw).xyzw;
  r2.xyzw = r4.xyzw * float4(2, 2, 2, 2) + r2.xyzw;
  r0.xyzw = r0.xyzw * float4(4, 4, 4, 4) + r2.xyzw;
  r0.xyzw = r3.xyzw * float4(2, 2, 2, 2) + r0.xyzw;
  r2.xyzw = saturate(r1.zywy * cb0[34].xxxx + v1.xyxy);
  r1.xy = saturate(r1.xy * cb0[34].xx + v1.xy);
  r1.xy = cb0[26].xx * r1.xy;
  r1.xyzw = t3.Sample(s3_s, r1.xy).xyzw;
  r2.xyzw = cb0[26].xxxx * r2.xyzw;
  r3.xyzw = t3.Sample(s3_s, r2.xy).xyzw;
  r2.xyzw = t3.Sample(s3_s, r2.zw).xyzw;
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = r2.xyzw * float4(2, 2, 2, 2) + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;

  r0.xyzw = cb0[34].yyyy * r0.xyzw * CUSTOM_BLOOM;  // bloom

  r1.xyzw = float4(0.0625, 0.0625, 0.0625, 1) * r0.xyzw;
  r0.xyzw = float4(0.0625, 0.0625, 0.0625, 0.0625) * r0.xyzw;
  r2.xyz = cb0[35].xyz * r1.xyz;
  r2.w = 0.0625 * r1.w;
  r1.xyzw = t2.Sample(s2_s, v1.xy).xyzw;
  r3.xyzw = t1.Sample(s1_s, w1.xy).xyzw;
  r3.xyz = r3.xyz * r1.xxx;
  r1.xyzw = r3.xyzw + r2.xyzw;
  r2.xy = v1.xy * cb0[33].xy + cb0[33].zw;
  r2.xyzw = t4.Sample(s4_s, r2.xy).xyzw;
  r2.xyz = cb0[34].zzz * r2.xyz;
  r2.w = 0;
  r0.xyzw = r2.xyzw * r0.xyzw + r1.xyzw;
  r0.xyzw = cb0[36].zzzz * r0.xyzw;
  o0.w = r0.w;

  // lut shaper
  r0.xyz = r0.xyz * float3(5.55555582, 5.55555582, 5.55555582) + float3(0.0479959995, 0.0479959995, 0.0479959995);
  r0.xyz = log2(r0.xyz);
  r0.xyz = saturate(r0.xyz * float3(0.0734997839, 0.0734997839, 0.0734997839) + float3(0.386036009, 0.386036009, 0.386036009));
  if (CUSTOM_LUT_TETRAHEDRAL) {
    r0.rgb = renodx::lut::SampleTetrahedral(t5, r0.rgb, 1 / cb0[36].x);
  } else {
    r0.xyz = cb0[36].yyy * r0.xyz;
    r0.w = 0.5 * cb0[36].x;
    r0.xyz = r0.xyz * cb0[36].xxx + r0.www;
    r0.xyzw = t5.Sample(s5_s, r0.xyz).xyzw;  // sample LUT
  }

  if (CUSTOM_GRAIN_TYPE) {  // film grain
    float2 noise_uv = v1.xy * cb0[30].xy + cb0[30].zw;
    float random = t0.Sample(s0_s, noise_uv).a;
    o0.rgb = renodx::effects::ApplyFilmGrain(
        r0.rgb,
        noise_uv,
        random,
        CUSTOM_GRAIN_STRENGTH * 0.015f,
        1.f);
  } else {                                             // noise
    r0.rgb = renodx::color::srgb::EncodeSafe(r0.rgb);  // sRGB Encode
    r1.xy = v1.xy * cb0[30].xy + cb0[30].zw;
    r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
    r0.w = r1.w * 2 + -1;
    r1.x = 1 + -abs(r0.w);
    r0.w = saturate(r0.w * 3.40282347e+38 + 0.5);
    r0.w = r0.w * 2 + -1;
    r1.x = sqrt(r1.x);
    r1.x = 1 + -r1.x;
    r0.w = r1.x * r0.w;
    r0.xyz = r0.www * float3(0.00392156886, 0.00392156886, 0.00392156886) * CUSTOM_GRAIN_STRENGTH + r0.xyz;
    o0.rgb = renodx::color::srgb::DecodeSafe(r0.rgb);  // sRGB Decode
  }

  return;
}
