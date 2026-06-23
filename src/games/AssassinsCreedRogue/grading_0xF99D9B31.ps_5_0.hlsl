#include "./common.hlsl"

Texture2D<float4> t7 : register(t7);
Texture2D<float4> t6 : register(t6);
Texture2D<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t0 : register(t0);

SamplerState s7_s : register(s7);
SamplerState s6_s : register(s6);
SamplerState s5_s : register(s5);
SamplerState s4_s : register(s4);
SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[186];
}

#define cmp -

#ifndef RENODX_BLOOM_STRENGTH
#define RENODX_BLOOM_STRENGTH 1.0f
#endif

#ifndef RENODX_BLACK_LEVEL_OFFSET
#define RENODX_BLACK_LEVEL_OFFSET 0.00020f
#endif

#ifndef RENODX_MID_GREY_STRENGTH
#define RENODX_MID_GREY_STRENGTH 0.40f
#endif

#ifndef RENODX_MID_GREY_RANGE
#define RENODX_MID_GREY_RANGE 0.50f
#endif

void GetLutScaleBias(out float3 scale, out float3 bias)
{
  uint widthR, widthG, widthB, height;
  t5.GetDimensions(widthR, height);
  t6.GetDimensions(widthG, height);
  t7.GetDimensions(widthB, height);

  float3 sizes = float3((float)widthR, (float)widthG, (float)widthB);
  scale = (sizes - 1.0) / sizes;
  bias = 0.5 / sizes;
}

float SafeScale(float s)
{
  return max(s, 0.000001);
}

float3 CounteractBlackAndMidGreyRaise(float3 color)
{
  color = max(color, 0.0);

  float y = dot(color, float3(0.2126, 0.7152, 0.0722));

  float shadowMask = 1.0 - smoothstep(0.0, 0.16, y);
  float midMask = 1.0 - smoothstep(0.12, RENODX_MID_GREY_RANGE, y);

  color = max(color - RENODX_BLACK_LEVEL_OFFSET * shadowMask, 0.0);

  float midScale = 1.0 - RENODX_MID_GREY_STRENGTH * midMask;
  color *= midScale;

  return max(color, 0.0);
}

float3 ApplyGameLUTAndGrade(float3 inputColor)
{
  float4 r0, r1, r2, r3, r4;

  bool hdr_path = ((RENODX_TONE_MAP_TYPE == renodx::draw::TONE_MAP_TYPE_RENO_DRT));

  r0.xyz = inputColor;
  r0.xyz = r0.xyz * cb0[128].xyz + cb0[129].xyz;
  r0.w = 0.5;

  float lut_maxch_scale = 1.0;

  if (hdr_path)
  {
    float3 lutScale, lutBias;
    GetLutScaleBias(lutScale, lutBias);

    float3 indexed_gamma = (r0.xyz - lutBias) / lutScale;
    float3 indexed_linear = renodx::color::gamma::DecodeSafe(max(indexed_gamma, 0.0));

    lut_maxch_scale = renodx::tonemap::neutwo::ComputeMaxChannelScale(indexed_linear);

    indexed_linear *= lut_maxch_scale;
    indexed_gamma = renodx::color::gamma::EncodeSafe(max(indexed_linear, 0.0));

    r0.xyz = indexed_gamma * lutScale + lutBias;
  }

  r1.x = t5.SampleLevel(s5_s, r0.xw, 0).x;
  r1.y = t6.SampleLevel(s6_s, r0.yw, 0).x;
  r1.z = t7.SampleLevel(s7_s, r0.zw, 0).x;
  r1.w = 1.0;

  if (hdr_path)
  {
    float3 post_lut_linear = renodx::color::gamma::DecodeSafe(max(r1.xyz, 0.0));
    post_lut_linear /= SafeScale(lut_maxch_scale);
    r1.xyz = renodx::color::gamma::EncodeSafe(max(post_lut_linear, 0.0));
  }

  r0.x = dot(r1.xyzw, cb0[183].xyzw);
  r0.y = dot(r1.xyzw, cb0[184].xyzw);
  r0.z = dot(r1.xyzw, cb0[185].xyzw);

  float filter_maxch_scale = 1.0;

  if (hdr_path)
  {
    float3 filter_input_linear = renodx::color::gamma::DecodeSafe(max(r0.xyz, 0.0));

    filter_maxch_scale = renodx::tonemap::neutwo::ComputeMaxChannelScale(filter_input_linear);

    filter_input_linear *= filter_maxch_scale;
    r0.xyz = renodx::color::gamma::EncodeSafe(max(filter_input_linear, 0.0));
  }

  r0.w = dot(r0.xyz, float3(0.212500006, 0.715399981, 0.0720999986));

  r1.xyz = r0.www + -r0.xyz;
  r1.xyz = cb0[133].xxx * r1.xyz + r0.xyz;

  r2.xyz = -r1.xyz * cb0[134].xyz + float3(1.0, 1.0, 1.0);

  r1.xyz = cb0[134].xyz * r1.xyz;
  r1.xyz = r1.xyz * r0.xyz;
  r1.xyz = r1.xyz + r1.xyz;

  r3.xyz = float3(1.0, 1.0, 1.0) + -r0.xyz;
  r3.xyz = r3.xyz + r3.xyz;

  r2.xyz = -r3.xyz * r2.xyz + float3(1.0, 1.0, 1.0);

  r3.xyz = cmp(r0.xyz < float3(0.5, 0.5, 0.5));

  r4.xyz = r3.xyz ? float3(0.0, 0.0, 0.0) : float3(1.0, 1.0, 1.0);
  r3.xyz = r3.xyz ? float3(1.0, 1.0, 1.0) : float3(0.0, 0.0, 0.0);

  r2.xyz = r4.xyz * r2.xyz;

  r1.xyz = r1.xyz * r3.xyz + r2.xyz;
  r1.xyz = r1.xyz + -r0.xyz;
  r1.xyz = cb0[134].www * r1.xyz + r0.xyz;

  float3 filteredColor = cb0[132].xxx ? r1.xyz : r0.xyz;

  if (hdr_path)
  {
    float3 filtered_linear = renodx::color::gamma::DecodeSafe(max(filteredColor, 0.0));
    filtered_linear /= SafeScale(filter_maxch_scale);
    filteredColor = renodx::color::gamma::EncodeSafe(max(filtered_linear, 0.0));
  }

  return filteredColor;
}

void main(
    float4 v0 : SV_Position0,
    float2 v1 : TEXCOORD0,
    out float4 o0 : SV_Target0)
{
  float3 sceneColor = t0.Sample(s0_s, v1.xy).xyz;
  float3 bloomColor = t4.Sample(s4_s, v1.xy).xyz;

  if (RENODX_TONE_MAP_TYPE != renodx::draw::TONE_MAP_TYPE_RENO_DRT) 
  {
    float3 colorSDR = saturate(sceneColor + bloomColor);
    colorSDR = ApplyGameLUTAndGrade(colorSDR);

    o0.xyz = colorSDR;
    o0.w = 0.0;
    return;
  }

  sceneColor = max(sceneColor, 0.0);
  bloomColor = max(bloomColor, 0.0);

  float3 combinedColor = sceneColor + bloomColor * RENODX_BLOOM_STRENGTH;

  float3 ungraded_color = renodx::color::gamma::DecodeSafe(max(combinedColor, 0.0));

  ungraded_color = PreTonemapSliders(ungraded_color);

  float3 sdr_color = CustomGradingBegin(ungraded_color);
  float3 lutInput = renodx::color::gamma::EncodeSafe(max(sdr_color, 0.0));

  float3 graded_lut_output = ApplyGameLUTAndGrade(lutInput);
  float3 graded_color = renodx::color::gamma::DecodeSafe(max(graded_lut_output, 0.0));

  float3 outputColor = CustomGradingEnd(ungraded_color, sdr_color, graded_color);

  outputColor = CounteractBlackAndMidGreyRaise(outputColor);

  outputColor = PostTonemapSliders(outputColor);

  o0.rgb = renodx::color::gamma::EncodeSafe(max(outputColor, 0.0));
  o0.w = 0.0;
  return;
}