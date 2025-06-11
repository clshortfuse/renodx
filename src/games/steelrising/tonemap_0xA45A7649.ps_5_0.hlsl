#include "./common.hlsl"

cbuffer cbMaterial : register(b1){
  float4 g_BloomParams : packoffset(c0);
  float4 g_ColorGradingGlobal : packoffset(c1);
  float4 g_ColorGradingSaturation : packoffset(c2);
  float4 g_ColorGradingRegion : packoffset(c3);
  float4 g_ColorGradingShadow : packoffset(c4);
  float4 g_ColorGradingMidTone : packoffset(c5);
  float4 g_ColorGradingHighlight : packoffset(c6);
  float4 g_ColorGradingColorFilter : packoffset(c7);
  float4 g_HDRAutoExposure : packoffset(c8);
  float4 g_TonemapperParams : packoffset(c9);
  int g_ToneMapOperator : packoffset(c10);
}
SamplerState g_Sampler_PointClamp_s : register(s0);
SamplerState g_Sampler_LinearClamp_s : register(s1);
Texture2D<float4> g_Texture : register(t0);
Texture2D<float4> g_BloomTexture : register(t1);

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float3 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = g_Texture.Sample(g_Sampler_PointClamp_s, v1.xy).xyz;
  r0.xyz = v1.zzz * r0.xyz;
  r0.w = log2(g_HDRAutoExposure.y);
  r1.xyzw = g_ColorGradingRegion.xyzw + r0.wwww;
  r1.xw = r1.xw + -r1.yz;
  r0.w = min(-9.99999997e-07, r1.x);
  r0.w = 1 / r0.w;
  r1.x = -r0.w * r1.y;
  r1.y = max(9.99999997e-07, r1.w);
  r1.y = 1 / r1.y;
  r1.z = -r1.y * r1.z;
  r1.w = dot(r0.xyz, float3(0.212599993,0.715200007,0.0722000003));
  r1.w = log2(r1.w);
  r0.xyz = r0.xyz / g_HDRAutoExposure.yyy;
  r0.xyz = log2(abs(r0.xyz));
  r0.xyz = g_ColorGradingGlobal.xxx * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.w = saturate(r1.w * r0.w + r1.x);
  r1.x = saturate(r1.w * r1.y + r1.z);
  r1.y = 1 + -r0.w;
  r1.y = r1.y + -r1.x;
  r1.y = max(0, r1.y);
  r2.xyzw = g_ColorGradingMidTone.xyzw * r1.yyyy;
  r2.xyzw = g_ColorGradingShadow.xyzw * r0.wwww + r2.xyzw;
  r1.xyzw = g_ColorGradingHighlight.xyzw * r1.xxxx + r2.xyzw;
  r1.xyz = g_HDRAutoExposure.yyy * r1.xyz;
  r0.xyz = g_HDRAutoExposure.yyy * r0.xyz + r1.xyz;
  r0.xyw = r0.yzx * r1.www;
  r1.x = cmp(r0.x < r0.y);
  r2.xy = r0.yx;
  r2.zw = float2(-1,0.666666687);
  r3.xy = r2.yx;
  r3.zw = float2(0,-0.333333343);
  r1.xyzw = r1.xxxx ? r2.xyzw : r3.xyzw;
  r2.x = cmp(r0.w < r1.x);
  r0.xyz = r1.xyw;
  r1.xyw = r0.wyx;
  r0.xyzw = r2.xxxx ? r0.xyzw : r1.xyzw;
  r1.x = min(r0.w, r0.y);
  r1.x = -r1.x + r0.x;
  r0.y = r0.w + -r0.y;
  r0.w = r1.x * 6 + 1.00000001e-10;
  r0.y = r0.y / r0.w;
  r0.y = r0.z + r0.y;
  r0.z = 1.00000001e-10 + r0.x;
  r0.z = r1.x / r0.z;
  r1.xyzw = abs(r0.yyyy) * float4(3,3,3,3) + float4(-0,-1,-2,-3);
  r1.xyzw = float4(1,1,1,1) + -abs(r1.xyzw);
  r1.x = max(r1.x, r1.w);
  r0.w = dot(g_ColorGradingSaturation.xyz, r1.xyz);
  r0.w = g_ColorGradingSaturation.w + r0.w;
  r0.z = r0.z + r0.w;
  r0.z = max(0, r0.z);
  r0.z = log2(r0.z);
  r0.z = g_ColorGradingGlobal.y * r0.z;
  r0.z = exp2(r0.z);
  r1.xyz = float3(1,0.666666687,0.333333343) + abs(r0.yyy);
  r1.xyz = frac(r1.xyz);
  r1.xyz = r1.xyz * float3(6,6,6) + float3(-3,-3,-3);
  r1.xyz = saturate(float3(-1,-1,-1) + abs(r1.xyz));
  r1.xyz = float3(-1,-1,-1) + r1.xyz;
  r0.yzw = r0.zzz * r1.xyz + float3(1,1,1);
  r0.xyz = r0.xxx * r0.yzw;
  r0.w = max(r0.y, r0.z);
  r0.w = max(r0.x, r0.w);
  r1.xyz = g_ColorGradingColorFilter.xyz * r0.www + -r0.xyz;
  r0.xyz = g_ColorGradingColorFilter.www * r1.xyz + r0.xyz;
  r1.xyz = g_BloomTexture.Sample(g_Sampler_LinearClamp_s, v1.xy).xyz;
  r1.xyz = g_BloomParams.xxx * r1.xyz * injectedData.fxBloom;
  r1.xyz = max(float3(0,0,0), r1.xyz);
  r0.xyz = r1.xyz + r0.xyz;
  float3 untonemapped = r0.rgb;
  r0.w = cmp(g_ToneMapOperator == 1);
  if (r0.w != 0) {
    r1.xyz = float3(1,1,1) + r0.xyz;
    r1.xyz = r0.xyz / r1.xyz;
    r1.xyz = log2(r1.xyz);
    r1.xyz = float3(0.454545468,0.454545468,0.454545468) * r1.xyz;
    r1.xyz = exp2(r1.xyz);
  } else {
    if (g_ToneMapOperator == 0) {
      r2.xyz = float3(-0.00400000019,-0.00400000019,-0.00400000019) + r0.xyz;
      r2.xyz = max(float3(0,0,0), r2.xyz);
      r3.xyz = r2.xyz * float3(6.19999981,6.19999981,6.19999981) + float3(0.5,0.5,0.5);
      r3.xyz = r3.xyz * r2.xyz;
      r4.xyz = r2.xyz * float3(6.19999981,6.19999981,6.19999981) + float3(1.70000005,1.70000005,1.70000005);
      r2.xyz = r2.xyz * r4.xyz + float3(0.0599999987,0.0599999987,0.0599999987);
      r1.xyz = r3.xyz / r2.xyz;
    } else {
      r0.w = cmp(g_ToneMapOperator == 2);
      if (r0.w != 0) {
        r2.xyz = r0.xyz + r0.xyz;
        r3.xyz = r0.xyz * float3(0.300000012,0.300000012,0.300000012) + float3(0.0500000007,0.0500000007,0.0500000007);
        r3.xyz = r2.xyz * r3.xyz + float3(0.00400000019,0.00400000019,0.00400000019);
        r4.xyz = r0.xyz * float3(0.300000012,0.300000012,0.300000012) + float3(0.5,0.5,0.5);
        r2.xyz = r2.xyz * r4.xyz + float3(0.0599999987,0.0599999987,0.0599999987);
        r2.xyz = r3.xyz / r2.xyz;
        r2.xyz = float3(-0.0666666701,-0.0666666701,-0.0666666701) + r2.xyz;
        r2.xyz = float3(1.37906432,1.37906432,1.37906432) * r2.xyz;
        r2.xyz = max(float3(0,0,0), r2.xyz);
        r2.xyz = log2(r2.xyz);
        r2.xyz = float3(0.454545468,0.454545468,0.454545468) * r2.xyz;
        r1.xyz = exp2(r2.xyz);
      } else {
        r0.w = cmp(g_ToneMapOperator == 4);
        if (r0.w != 0) {
          r2.xyz = r0.xyz * float3(2.50999999,2.50999999,2.50999999) + float3(0.0299999993,0.0299999993,0.0299999993);
          r2.xyz = r2.xyz * r0.xyz;
          r3.xyz = r0.xyz * float3(2.43000007,2.43000007,2.43000007) + float3(0.589999974,0.589999974,0.589999974);
          r3.xyz = r0.xyz * r3.xyz + float3(0.140000001,0.140000001,0.140000001);
          r2.xyz = r2.xyz / r3.xyz;
          r2.xyz = log2(r2.xyz);
          r2.xyz = float3(0.454545468,0.454545468,0.454545468) * r2.xyz;
          r1.xyz = exp2(r2.xyz);
        } else {
          r0.w = cmp(g_ToneMapOperator == 5);
          if (r0.w != 0) {
            r2.xyz = log2(r0.xyz);
            r2.xyz = float3(1.29999995,1.29999995,1.29999995) * r2.xyz;
            r2.xyz = exp2(r2.xyz);
            r3.xyz = r2.xyz * float3(0.997784019,0.997784019,0.997784019) + float3(0.493900597,0.493900597,0.493900597);
            r2.xyz = r2.xyz / r3.xyz;
            r1.rgb = injectedData.toneMapType == 0.f ? saturate(r2.rgb) : untonemapped;
          } else {
            r0.w = cmp(g_ToneMapOperator == 6);
            if (r0.w != 0) {
              r2.xyz = log2(r0.xyz);
              r2.xyz = g_TonemapperParams.xxx * r2.xyz;
              r3.xyz = exp2(r2.xyz);
              r2.xyz = g_TonemapperParams.www * r2.xyz;
              r2.xyz = exp2(r2.xyz);
              r2.xyz = r2.xyz * g_TonemapperParams.yyy + g_TonemapperParams.zzz;
              r2.xyz = r3.xyz / r2.xyz;
              r2.xyz = max(float3(0,0,0), r2.xyz);
              r2.xyz = log2(r2.xyz);
              r2.xyz = float3(0.454545468,0.454545468,0.454545468) * r2.xyz;
              r1.xyz = exp2(r2.xyz);
            } else {
              r0.xyz = log2(r0.xyz);
              r0.xyz = float3(0.454545468,0.454545468,0.454545468) * r0.xyz;
              r1.xyz = exp2(r0.xyz);
            }
          }
        }
      }
    }
  }
  o0.xyz = r1.xyz;
  o0.w = 1;
  return;
}