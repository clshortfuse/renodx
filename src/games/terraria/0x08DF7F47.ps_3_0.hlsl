#include "./shared.h"
// Reconstructed from DXVK .dxso.dis (ps_2_0) — register-faithful HLSL
// FIX: Correct swizzle+mask behavior for:
//   add r0.zw, r1.wzyx, c12.y
//   add r0.zw, r0, -r1.wzyx
//
// This was the source of the slight scale/height drift.

sampler2D uImage0 : register(s0);
sampler2D uImage1 : register(s1);
sampler2D uImage2 : register(s2);
sampler2D uImage3 : register(s3);

// Runtime constant registers as seen by the PS
float4 c0 : register(c0);
float4 c1 : register(c1);
float4 c2 : register(c2);
float4 c3 : register(c3);
float4 c4 : register(c4);
float4 c5 : register(c5);
float4 c6 : register(c6);

float4 c7 : register(c7);
float4 c8 : register(c8);
float4 c9 : register(c9);
float4 c10 : register(c10);
float4 c11 : register(c11);

// def constants from the disassembly
static const float4 c12 = float4(0.100000001, -0.5, 0.200000003, 0.25);
static const float4 c13 = float4(0.400000006, 1.0, -0.300000012, 0.300000012);
static const float4 c14 = float4(0.100000001, 1.0, 100.0, 0.00100000005);
static const float4 c15 = float4(500.0, -2.0, 3.0, 2.0);
static const float4 c16 = float4(0.0, 0.333333343, 0.0, 0.0);

struct PSIn
{
  float4 t0 : TEXCOORD0;  // PS uses wzyx swizzles in ASM; keep float4.
};

float4 main(PSIn i) : COLOR0
{
  float4 t0 = i.t0;

  float4 r0 = 0, r1 = 0, r2 = 0, r3 = 0, r4 = 0;
  float4 tmp;

  // 121: mov r0.xy, c7
  r0.xy = c7.xy;

  // 122: mad r0.zw, t0.wzyx, r0.wzyx, c8.wzyx
  tmp = t0.wzyx * r0.wzyx + c8.wzyx;
  r0.zw = tmp.zw;

  // 123: mul r0.zw, r0, c0.wzyx
  tmp = r0 * c0.wzyx;
  r0.zw = tmp.zw;

  // 124: mul r1.x, r0.w, c12.x
  r1.x = r0.w * c12.x;

  // 125: mov r2.xz, c12
  r2.x = c12.x;
  r2.z = c12.z;

  // 126: mad r1.y, r0.z, r2.x, c1.x
  r1.y = r0.z * r2.x + c1.x;

  // 127: mul r2.x, r0.w, c12.z
  r2.x = r0.w * c12.z;

  // 128: mad r2.y, r0.z, r2.z, c2.x
  r2.y = r0.z * r2.z + c2.x;

  // 129: mad r0.zw, t0.wzyx, r0.wzyx, c11.wzyx
  tmp = t0.wzyx * r0.wzyx + c11.wzyx;
  r0.zw = tmp.zw;

  // 130: mul r0.zw, r0, c12.w
  tmp = r0 * c12.w;
  r0.zw = tmp.zw;

  // 131: mul r3.xy, r0.wzyx, c3
  tmp = r0.wzyx * c3;
  r3.xy = tmp.xy;

  // 132: texld r1, r1, s1
  r1 = tex2D(uImage1, r1.xy);

  // 133: texld r2, r2, s1
  r2 = tex2D(uImage1, r2.xy);

  // 134: texld r3, r3, s2
  r3 = tex2D(uImage2, r3.xy);

  // 135: add r0.zw, r1.wzyx, c12.y
  // Correct mask+swizzle mapping:
  //   result = r1.wzyx + (-0.5)
  //   r0.z = result.z = r1.y - 0.5
  //   r0.w = result.w = r1.x - 0.5
  r0.z = r1.y + c12.y;
  r0.w = r1.x + c12.y;

  // 136: add r1.xy, r2, c12.y
  r1.xy = r2.xy + c12.y;

  // 137: add r0.zw, r0, -r1.wzyx
  // result = r0 + (-r1.wzyx)
  // r0.z = result.z = r0.z - r1.y
  // r0.w = result.w = r0.w - r1.x
  r0.z = r0.z - r1.y;
  r0.w = r0.w - r1.x;

  // 138: mul r1.xy, r0.wzyx, c12.x
  tmp = r0.wzyx * c12.x;
  r1.xy = tmp.xy;

  // 139: add r0.z, r3.x, c12.y
  r0.z = r3.x + c12.y;

  // 140: mad r0.w, r3.z, -c13.x, c13.y
  r0.w = r3.z * (-c13.x) + c13.y;

  // 141: mul r0.z, r0.z, r0.w
  r0.z = r0.z * r0.w;

  // 142: max r1.z, -r0.z, c13.z
  r1.z = max(-r0.z, c13.z);

  // 143: min r0.w, r1.z, c13.w
  r0.w = min(r1.z, c13.w);

  // 144: mad r2.y, r1.y, c10.x, r0.w
  r2.y = r1.y * c10.x + r0.w;

  // 145: mul r2.x, r1.x, c10.x
  r2.x = r1.x * c10.x;

  // 146: dp2add r0.w, r1, r1, c16.x
  r0.w = dot(r1.xy, r1.xy) + c16.x;

  // 147: rsq r0.w, r0.w
  r0.w = rsqrt(r0.w);

  // 148: rcp r0.w, r0.w
  r0.w = 1.0 / r0.w;

  // 149: mad r0.z, r0.z, c13.w, r0.w
  r0.z = r0.z * c13.w + r0.w;

  // 150: mul r1.xy, r2, c14
  r1.xy = r2.xy * c14.xy;

  // 151: mov r0.w, c14.w
  r0.w = c14.w;

  // 152: mad r0.w, r1.y, c5.y, r0.w
  r0.w = r1.y * c5.y + r0.w;

  // 153: mad r1.xy, r1, c5, t0
  r1.xy = r1.xy * c5.xy + t0.xy;

  // 154: mul_sat r0.w, r0.w, c15.x
  r0.w = saturate(r0.w * c15.x);

  // 155: mad r1.z, r0.w, c15.y, c15.z
  r1.z = r0.w * c15.y + c15.z;

  // 156: mul r0.w, r0.w, r0.w
  r0.w = r0.w * r0.w;

  // 157: mul r0.w, r1.z, r0.w
  r0.w = r1.z * r0.w;

  // 158: mad r1.zw, r1.wzyx, r0.wzyx, c9.wzyx
  tmp = r1.wzyx * r0.wzyx + c9.wzyx;
  r1.zw = tmp.zw;

  // 159: mul r2.xy, r1.wzyx, c6
  tmp = r1.wzyx * c6;
  r2.xy = tmp.xy;

  // 160: mad r0.xy, t0, r0, c9
  r0.xy = t0.xy * r0.xy + c9.xy;

  // 161: mul r0.xy, r0, c6
  r0.xy = r0.xy * c6.xy;

  // 162: texld r1, r1, s0
  r1 = tex2D(uImage0, r1.xy);

  // 163: texld r2, r2, s3
  r2 = tex2D(uImage3, r2.xy);

  // 164: texld r3, r0, s3
  r3 = tex2D(uImage3, r0.xy);

  // 165: texld r4, t0, s0
  r4 = tex2D(uImage0, t0.xy);

  // 166: mul r0.x, r2.w, c14.z
  r0.x = r2.w * c14.z;

  // 167: min r2.x, r0.x, c13.y
  r2.x = min(r0.x, c13.y);

  // 168: mul r0.x, r3.w, c14.z
  r0.x = r3.w * c14.z;

  // 169: min r2.y, r0.x, c13.y
  r2.y = min(r0.x, c13.y);

  // 170: add r0.x, r2.x, -r2.y
  r0.x = r2.x + (-r2.y);

  // 171: add r0.y, r2.x, r2.y
  r0.y = r2.x + r2.y;

  // 172: mul r0.y, r0.y, c14.z
  r0.y = r0.y * c14.z;

  // 173: min r2.y, r0.y, c13.y
  r2.y = min(r0.y, c13.y);

  // 174: mad r0.y, r0.w, c15.w, r0.x
  r0.y = r0.w * c15.w + r0.x;

  // 175: abs r0.x, r0.x
  r0.x = abs(r0.x);

  // 176: add r0.y, r0.y, -c13.y
  r0.y = r0.y + (-c13.y);

  // 177: abs r0.y, r0.y
  r0.y = abs(r0.y);

  // 178: add r0.y, -r0.y, c13.y
  r0.y = (-r0.y) + c13.y;

  // 179: mul_sat r0.x, r0.x, r0.y
  r0.x = saturate(r0.x * r0.y);

  // 180: add r0.x, -r0.x, c13.y
  r0.x = (-r0.x) + c13.y;

  // 181: mul r0.y, r2.y, r0.x
  r0.y = r2.y * r0.x;

  // 182: lrp r3, r0.y, r1, r4  => r3 = lerp(r4, r1, r0.y)
  r3 = lerp(r4, r1, r0.y);

  // 183: add r0.y, r3.y, r3.x
  r0.y = r3.y + r3.x;

  // 184: add r0.y, r3.z, r0.y
  r0.y = r3.z + r0.y;

  // 185: mul r0.y, r0.z, r0.y
  r0.y = r0.z * r0.y;

  // 186: mul r0.y, r2.x, r0.y
  r0.y = r2.x * r0.y;

  // 187: mul r0.x, r0.x, r0.y
  r0.x = r0.x * r0.y;

  // 188: mad r3.xyz, r0.x, c16.y, r3
  r3.xyz = r0.x * c16.y + r3.xyz;
  r3.rgb = renodx::color::srgb::DecodeSafe(r3.rgb);
  // o0.rgb = renodx::draw::ToneMapPass(o0.rgb);
  // o0.rgb = renodx::draw::RenderIntermediatePass(o0.rgb);
  if (RENODX_TONE_MAP_TYPE != 0) {
    r3.rgb = renodx::draw::ToneMapPass(r3.rgb);
    r3.rgb = renodx::draw::RenderIntermediatePass(r3.rgb);
  } else {
    r3.rgb = saturate(r3.rgb);
    r3.rgb = renodx::draw::RenderIntermediatePass(r3.rgb);
  }
  // 189: mov oC0, r3
  return r3;
}

  