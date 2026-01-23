#include "../common.hlsli"

// ---- Created with 3Dmigoto v1.4.1 on Sat Mar  1 00:56:45 2025

cbuffer SCB_CommonPostEffect : register(b9) {
  float2 g_BlurCenter : packoffset(c0);
  float g_BlurCenterRadius : packoffset(c1);
  float g_BlurWidth : packoffset(c2);
  float4 g_BlurDarkFactors : packoffset(c3);
}

SamplerState s_Texture_s : register(s0);
Texture2D<float4> texture0 : register(t0);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_TARGET0) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = dot(v1.xy, v1.xy);
  r0.y = rsqrt(r0.x);
  r0.x = sqrt(r0.x);
  r0.yz = v1.xy * r0.yy;
  r0.w = -g_BlurCenterRadius + r0.x;
  r0.w = max(0, r0.w);
  r1.x = min(g_BlurCenterRadius, r0.x);
  r0.x = r0.w * r0.x;
  r1.xy = r0.yz * r1.xx + g_BlurCenter.xy;
  r1.zw = r0.yz * r0.ww + r1.xy;
  r0.yz = r0.ww * r0.yz;
  r2.xyzw = texture0.Sample(s_Texture_s, r1.zw).xyzw;

  r2.rgb = InvertIntermediatePass(r2.rgb);

  r0.w = g_BlurWidth * 0.142857 + 1;
  r1.zw = r0.yz * r0.ww + r1.xy;
  r0.w = g_BlurWidth * 0.142857 + r0.w;
  r3.xyzw = texture0.Sample(s_Texture_s, r1.zw).xyzw;

  r3.rgb = InvertIntermediatePass(r3.rgb);

  r2.xyzw = r3.xyzw + r2.xyzw;
  r1.zw = r0.yz * r0.ww + r1.xy;
  r0.w = g_BlurWidth * 0.142857 + r0.w;
  r3.xyzw = texture0.Sample(s_Texture_s, r1.zw).xyzw;

  r3.rgb = InvertIntermediatePass(r3.rgb);

  r2.xyzw = r3.xyzw + r2.xyzw;
  r1.zw = r0.yz * r0.ww + r1.xy;
  r0.w = g_BlurWidth * 0.142857 + r0.w;
  r3.xyzw = texture0.Sample(s_Texture_s, r1.zw).xyzw;

  r3.rgb = InvertIntermediatePass(r3.rgb);

  r2.xyzw = r3.xyzw + r2.xyzw;
  r1.zw = r0.yz * r0.ww + r1.xy;
  r0.w = g_BlurWidth * 0.142857 + r0.w;
  r3.xyzw = texture0.Sample(s_Texture_s, r1.zw).xyzw;

  r3.rgb = InvertIntermediatePass(r3.rgb);

  r2.xyzw = r3.xyzw + r2.xyzw;
  r1.zw = r0.yz * r0.ww + r1.xy;
  r0.w = g_BlurWidth * 0.142857 + r0.w;
  r3.xyzw = texture0.Sample(s_Texture_s, r1.zw).xyzw;

  r3.rgb = InvertIntermediatePass(r3.rgb);

  r2.xyzw = r3.xyzw + r2.xyzw;
  r1.zw = r0.yz * r0.ww + r1.xy;
  r0.w = g_BlurWidth * 0.142857 + r0.w;
  r3.xyzw = texture0.Sample(s_Texture_s, r1.zw).xyzw;

  r3.rgb = InvertIntermediatePass(r3.rgb);

  r2.xyzw = r3.xyzw + r2.xyzw;
  r0.yz = r0.yz * r0.ww + r1.xy;
  r1.xyzw = texture0.Sample(s_Texture_s, r0.yz).xyzw;

  r1.rgb = InvertIntermediatePass(r1.rgb);

  r1.xyzw = r1.xyzw + r2.xyzw;
  r1.xyzw = float4(0.125, 0.125, 0.125, 0.125) * r1.xyzw;
  r0.x = r0.x * g_BlurDarkFactors.x + g_BlurDarkFactors.y;
  r0.x = 1 + -r0.x;
  r0.x = max(g_BlurDarkFactors.z, r0.x);
  r0.x = min(g_BlurDarkFactors.w, r0.x);
  o0.xyzw = r0.xxxx * r1.xyzw;

  o0.rgb = ClampAndRenderIntermediatePass(o0.rgb);

  return;
}
