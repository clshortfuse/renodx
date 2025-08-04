// ---- Created with 3Dmigoto v1.3.16 on Sun Aug 03 16:49:25 2025

//Another Xray shader from custom map: Nightmare.

#include "../common.hlsl"

Texture2D<float4> floatZSampler : register(t0);
Texture2D<float4> codeTexture0 : register(t6);
Texture2D<float4> codeTexture1 : register(t7);
Texture2D<float4> codeTexture2 : register(t9);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,r16,r17,r18;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = (int2)v0.xy;
  r0.zw = float2(0,0);
  r1.xyz = codeTexture0.Load(r0.xyw).xyz;
  r1.w = floatZSampler.Load(r0.xyw).x;

  if (CUSTOM_XRAY_OUTLINE == 0) {
    o0.xyz = r0.xyz;
    o0.w = 1;
    return;
  }

  r2.x = cmp(0.899999976 < r1.w);
  if (r2.x != 0) {
    o0.xyz = r1.xyz;
    o0.w = 1;
    return;
  }
  r2.xyz = codeTexture1.Load(r0.xyw).xyz;
  r2.w = max(r2.y, r2.z);
  r2.w = max(r2.x, r2.w);
  r2.w = cmp(r2.w >= 1);
  if (r2.w != 0) {
    o0.xyz = r1.xyz;
    o0.w = 1;
    return;
  }
  r3.xyzw = (int4)r0.xyww;
  r4.xyzw = float4(4,4,0,0) + r3.xyww;
  r4.xyzw = (int4)r4.xyzw;
  r5.xyz = codeTexture1.Load(r4.xyw).xyz;
  r6.xyzw = float4(0,4,0,0) + r3.xyww;
  r6.xyzw = (int4)r6.xyzw;
  r7.xyz = codeTexture1.Load(r6.xyw).xyz;
  r8.xyzw = float4(-4,4,0,0) + r3.xyww;
  r8.xyzw = (int4)r8.xyzw;
  r9.xyz = codeTexture1.Load(r8.xyw).xyz;
  r10.xyzw = float4(4,0,0,0) + r3.xyww;
  r10.xyzw = (int4)r10.xyzw;
  r11.xyz = codeTexture1.Load(r10.xyw).xyz;
  r12.xyzw = float4(-4,0,0,0) + r3.xyww;
  r12.xyzw = (int4)r12.xyzw;
  r13.xyz = codeTexture1.Load(r12.xyw).xyz;
  r14.xyzw = float4(4,-4,0,0) + r3.xyww;
  r14.xyzw = (int4)r14.xyzw;
  r15.xyz = codeTexture1.Load(r14.xyw).xyz;
  r16.xyzw = float4(0,-4,0,0) + r3.xyww;
  r16.xyzw = (int4)r16.xyzw;
  r17.xyz = codeTexture1.Load(r16.xyw).xyz;
  r3.xyzw = float4(-4,-4,0,0) + r3.xyzw;
  r3.xyzw = (int4)r3.xyzw;
  r18.xyz = codeTexture1.Load(r3.xyw).xyz;
  r5.xyz = r9.xyz + r5.xyz;
  r5.xyz = r5.xyz + r15.xyz;
  r5.xyz = r5.xyz + r18.xyz;
  r7.xyz = r11.xyz + r7.xyz;
  r7.xyz = r7.xyz + r13.xyz;
  r7.xyz = r7.xyz + r17.xyz;
  r7.xyz = float3(0.0838200003,0.0838200003,0.0838200003) * r7.xyz;
  r2.xyz = r2.xyz * float3(0.619346976,0.619346976,0.619346976) + r7.xyz;
  r2.yzw = r5.xyz * float3(0.0113439998,0.0113439998,0.0113439998) + r2.xyz;
  r5.x = max(r2.z, r2.w);
  r5.x = max(r5.x, r2.y);
  r5.x = cmp(r5.x == 0.000000);
  if (r5.x != 0) {
    o0.xyz = r1.xyz;
    o0.w = 1;
    return;
  }
  r4.x = codeTexture2.Load(r4.xyz).x;
  r4.y = codeTexture2.Load(r6.xyz).x;
  r4.x = max(r4.x, r4.y);
  r4.y = codeTexture2.Load(r8.xyz).x;
  r4.x = max(r4.x, r4.y);
  r4.y = codeTexture2.Load(r10.xyz).x;
  r4.x = max(r4.x, r4.y);
  r0.x = codeTexture2.Load(r0.xyz).x;
  r0.x = max(r4.x, r0.x);
  r0.y = codeTexture2.Load(r12.xyz).x;
  r0.x = max(r0.x, r0.y);
  r0.y = codeTexture2.Load(r14.xyz).x;
  r0.x = max(r0.x, r0.y);
  r0.y = codeTexture2.Load(r16.xyz).x;
  r0.x = max(r0.x, r0.y);
  r0.y = codeTexture2.Load(r3.xyz).x;
  r0.x = max(r0.x, r0.y);
  r0.y = cmp(0 < r0.x);
  r0.x = cmp(r0.x < r1.w);
  r0.x = r0.x ? r0.y : 0;
  if (r0.x != 0) {
    o0.xyz = r1.xyz;
    o0.w = 1;
    return;
  }
  r2.x = r2.y * r2.y;
  o0.xyz = r2.xzw * float3(32768,32768,32768) + r1.xyz;
  
  o0.xyz = Tradeoff_PrepareFullWidthFsfx(o0.xyz, CUSTOM_XRAY_OUTLINE);
  o0.w = 1;
  return;
}