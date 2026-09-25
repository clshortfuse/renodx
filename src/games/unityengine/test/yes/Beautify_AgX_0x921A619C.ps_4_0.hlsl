#include "../../common.hlsli"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[163];
}

// over the hill

static const float3x3 linearBT709_to_something = float3x3(
    0.84247905, 0.078433603, 0.0792237446,
    0.0423282422, 0.878468633, 0.07991661292,
    0.042375654, 0.078433603, 0.879143);

static const float3x3 something_to_linearBT709 = float3x3(
    1.19687903, -0.0980208814, -0.0990297422,
    -0.0528968535, 1.15190315, -0.0989611745,
    -0.052971635, -0.0980434492, 1.15107369);

float3 curve(float3 x) {
  float3 xlog = min(max(log2(x), -12.4739304), 4.02606916) - -12.4739304;
  float3 scaled_xlog = xlog / 16.5;
  float3 x2 = scaled_xlog * scaled_xlog;
  float3 x3 = scaled_xlog * scaled_xlog * scaled_xlog;
  float3 x4 = scaled_xlog * scaled_xlog * scaled_xlog * scaled_xlog;
  float3 x5 = scaled_xlog * scaled_xlog * scaled_xlog * scaled_xlog * scaled_xlog;
  float3 x6 = scaled_xlog * scaled_xlog * scaled_xlog * scaled_xlog * scaled_xlog * scaled_xlog;
  return xlog * 0.00721818209 + x2 * 0.4298 + 31.96 * x4 + 15.5 * x6 - 40.14 * x5 - x3 * 6.868 - 0.00232;
}

float3 AgX(float3 input) {
  float3 some_color_space = mul(linearBT709_to_something, input);
  float3 curved = curve(some_color_space);
  return mul(something_to_linearBT709, curved);
}

float3 AgXtended(float3 input) {
  float3 some_color_space = mul(linearBT709_to_something, input);
  float3 curved = curve(some_color_space);
  float3 extended = some_color_space > 0.4029 ?
  some_color_space * 0.432307757145 + 0.46662152467 :
  curved;
  return mul(something_to_linearBT709, extended);
}

float3 AgXTonemap(float3 color, float pre_exposure, float post_exposure, float gamma) {
  bool extended = RENODX_TONE_MAP_TYPE != 0.f;
  color *= pre_exposure;
  float3 sdr_color = pow(AgX(color), gamma);
  float3 output_color;
  [branch]
  if (!extended) {
    output_color = saturate(sdr_color * post_exposure);
  } else {
    float compression_scale;
    GamutCompression(color, compression_scale);
    float3 hdr_color = AgXtended(color);
    GamutDecompression(hdr_color, compression_scale);
    hdr_color = renodx::math::SignPow(hdr_color, gamma);
    output_color = CorrectHueAndChrominanceOKLAB(hdr_color, sdr_color, RENODX_TONE_MAP_SDRIFY, RENODX_TONE_MAP_SDRIFY);
    output_color *= post_exposure;
  }
  return output_color;
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  float2 v2 : TEXCOORD2,
  float2 w2 : TEXCOORD3,
  float2 v3 : TEXCOORD4,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.SampleBias(s1_s, v1.xy, cb0[4].x).xyzw;
  o0.w = r0.w;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
  r0.xyz = max(float3(0,0,0), r0.xyz);
  r0.xyz = min(cb0[148].zzz, r0.xyz);
  }
  r1.xyz = saturate(r0.xyz);
  r1.xyz = float3(1,1,1) + -r1.xyz;
  r2.xyz = r1.yxx * r0.xyz;
  r1.xyz = r2.xyz * r1.zzy;
  r1.xyz = r1.xyz * cb0[144].yyy + float3(1,1,1);
  r1.xyz = r1.xyz * r0.xyz;
  r0.x = renodx::color::y::from::NTSC1953(r0.xyz);
  r0.y = renodx::color::y::from::NTSC1953(r1.xyz);
  r0.y = 9.99999975e-005 + r0.y;
  r0.x = r0.x / r0.y;
  r2.xyzw = t1.SampleBias(s0_s, v1.xy, cb0[4].x).xyzw;
  r0.yzw = cb0[146].xxx * r2.xyz * CUSTOM_BLOOM;
  r0.xyz = r1.xyz * r0.xxx + r0.yzw;
  r0.xyz = AgXTonemap(r0.xyz, cb0[148].x, cb0[148].y, cb0[136].x);
  r1.xyz = handleUserLUT(r0.xyz, t2, s0_s, 0, 1);
  r0.xyz = fastSrgbEncodeSafe(r0.xyz);
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = cb0[148].www * r1.xyz + r0.xyz;
  r2.xyz = fastSrgbDecodeSafe(r0.xyz);
  r3.x = dot(r2.xyz, float3(0.393000007,0.768999994,0.188999996));
  r3.y = dot(r2.xyz, float3(0.349000007,0.68599999,0.167999998));
  r3.z = dot(r2.xyz, float3(0.272000015,0.533999979,0.130999997));
  r0.xyz = -r0.xyz * r1.xyz + r3.xyz;
  r0.xyz = cb0[144].xxx * r0.xyz + r2.xyz;
  r0.w = max(r0.y, r0.z);
  r0.w = max(r0.x, r0.w);
  r1.x = min(r0.y, r0.z);
  r1.x = min(r1.x, r0.x);
  r0.w = saturate(-r1.x + r0.w);
  r0.w = 1 + -r0.w;
  r0.w = cb0[149].z * r0.w;
  r1.x = dot(r0.xyz, float3(0.298999995,0.587000012,0.114));
  r1.xyz = -r1.xxx + r0.xyz;
  r1.xyz = r0.www * r1.xyz + float3(1,1,1);
  r0.xyz = r1.xyz * r0.xyz;
  r1.xyz = r0.xyz * cb0[150].xyz + -r0.xyz;
  r0.xyz = cb0[150].www * r1.xyz + r0.xyz;
  r0.xyz = float3(-0.5,-0.5,-0.5) + r0.xyz;
  r0.xyz = r0.xyz * cb0[149].yyy + float3(0.5,0.5,0.5);
  r0.xyz = cb0[149].xxx * r0.xyz;
  r0.w = -1000 + cb0[159].x;
  r0.w = saturate(-0.00100000005 * r0.w);
  r1.x = r0.w * -2 + 3;
  r0.w = r0.w * r0.w;
  r0.w = r1.x * r0.w;
  r1.x = max(1000, cb0[159].x);
  r1.x = min(40000, r1.x);
  r1.xyz = float3(0,1669.58032,2575.28271) + r1.xxx;
  r1.xyz = float3(0,-2902.19556,-8257.7998) / r1.xyz;
  r1.xyz = float3(1,1.33026743,1.89937544) + r1.xyz;
  r2.xyz = float3(1,1,1) + -r1.xyz;
  r1.xyz = r0.www * r2.xyz + r1.xyz;
  r1.xyz = r0.xyz * r1.xyz + -r0.xyz;
  r1.xyz = cb0[159].yyy * r1.xyz + r0.xyz;
  if (CUSTOM_COUNT_OLD_2 == CUSTOM_COUNT_NEW_2) {
    r1.xyz = GradeAndDisplayMap(r1.xyz);
  }
  r0.x = renodx::color::y::from::NTSC1953(saturate(r0.xyz));
  r0.y = r0.x * 0.828427017 + -1.82842696;
  r0.x = r0.x * r0.y;
  r0.x = cb0[139].y * r0.x + 1;
  r2.xyzw = cb0[139].zzzz * cb0[135].zwzw;
  r3.xyzw = v1.xyxy * r2.zwzw;
  r3.xyzw = floor(r3.xyzw);
  r2.xyzw = r3.xyzw / r2.xyzw;
  r0.y = dot(r2.zw, float2(321.894196,1225.65479));
  r2.xyzw = float4(0.100000001,0.100000001,0.200000003,0.200000003) + r2.xyzw;
  r3.x = sin(r0.y);
  r0.y = dot(r2.xy, float2(321.894196,1225.65479));
  r0.z = dot(r2.zw, float2(321.894196,1225.65479));
  r3.yz = sin(r0.yz);
  r0.yzw = r3.xyz * float3(4251.48633,4251.48633,4251.48633) + cb0[15].yyy;
  r0.yzw = frac(r0.yzw);
  r0.yzw = float3(-0.5,-0.5,-0.5) + r0.yzw;
  r0.yzw = float3(1,0.949999988,1.04999995) * r0.yzw;
  r0.xyz = r0.yzw * r0.xxx;
  r0.xyz = r0.xyz * cb0[139].xxx + float3(1,1,1);
  float max_channel_scale = 1.f;
  if(RENODX_TONE_MAP_TYPE != 0.f){
    NeutwoMaxCh(r1.xyz, max_channel_scale);
  }
  r0.xyz = r1.xyz * r0.xyz;
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    NeutwoMaxChInverse(r0.xyz, max_channel_scale);
  }
  if (CUSTOM_COUNT_OLD == CUSTOM_COUNT_NEW) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  return;
}