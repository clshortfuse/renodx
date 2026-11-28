// ---- Created with 3Dmigoto v1.3.16 on Fri May 22 12:45:30 2026
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);

cbuffer cb6 : register(b6)
{
  float4 cb6[3];
}

// 3Dmigoto declarations
#define cmp -

#ifndef CUSTOM_HDR_STRENGTH
#define CUSTOM_HDR_STRENGTH 1.0
#endif

#ifndef CUSTOM_HDR_PAPER_WHITE
#define CUSTOM_HDR_PAPER_WHITE 1.0
#endif

#ifndef CUSTOM_HDR_PEAK
#define CUSTOM_HDR_PEAK 4.0
#endif

#ifndef CUSTOM_HDR_HIGHLIGHT_START
#define CUSTOM_HDR_HIGHLIGHT_START 0.65
#endif

#ifndef CUSTOM_HDR_HIGHLIGHT_POWER
#define CUSTOM_HDR_HIGHLIGHT_POWER 1.35
#endif
#define cmp -
#ifndef MANUAL_SRGB_RT_ENCODE
#define MANUAL_SRGB_RT_ENCODE 1
#endif

float3 LinearToSRGB(float3 c)
{
  float3 lo = c * 12.92;
  float3 hi = 1.055 * pow(max(c, 0.0), 1.0 / 2.4) - 0.055;
  return lerp(lo, hi, step(0.0031308, c));
}

float3 EncodeSRGBOutput(float3 c)
{
#if MANUAL_SRGB_RT_ENCODE
  c = LinearToSRGB(max(c, 0.0));
#endif
  return c;
}
static const float3 CUSTOM_LUMA = float3(0.2126, 0.7152, 0.0722);

float3 ExpandToHDR(float3 color)
{
  color = max(color, 0.0);

  float luma = dot(color, CUSTOM_LUMA);

  float highlight_mask = saturate((luma - CUSTOM_HDR_HIGHLIGHT_START) / max(1.0 - CUSTOM_HDR_HIGHLIGHT_START, 0.0001));
  highlight_mask = pow(highlight_mask, CUSTOM_HDR_HIGHLIGHT_POWER);

  float peak_scale = CUSTOM_HDR_PEAK / max(CUSTOM_HDR_PAPER_WHITE, 0.0001);
  float hdr_scale = lerp(1.0, peak_scale, highlight_mask * CUSTOM_HDR_STRENGTH);

  return color * hdr_scale;
}

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.y = v1.y * cb6[0].x + cb6[0].y;
  r0.x = v1.x;
  r0.xy = float2(-0.5,-0.5) + r0.xy;
  r0.x = dot(r0.xy, r0.xy);
  r0.x = sqrt(r0.x);
  r0.x = cb6[0].z * r0.x;
  r0.x = log2(max(r0.x, 0.000001));
  r0.x = cb6[1].z * r0.x;
  r0.x = exp2(r0.x);

  r0.yzw = cb6[2].xyz + -r0.xxx;
  r0.yzw = -cb6[1].yyy + r0.yzw;

  r1.xy = float2(-0.5,-0.5) + v1.xy;
  r1.xy = r1.xy * r0.xx;
  r1.xy = r1.xy * cb6[1].ww + v1.xy;

  r2.xyz = t1.Sample(s1_s, r1.xy).xyz;
  r1.xyz = t0.Sample(s0_s, r1.xy).xyz;

  r0.xyz = r2.xyz + r0.yzw;
  r0.xyz = r1.xyz * cb6[1].xxx + r0.xyz;

  o0.xyz = ExpandToHDR(r0.xyz);
   o0.xyz = EncodeSRGBOutput(o0.xyz);
  o0.w = 1;
  return;
}