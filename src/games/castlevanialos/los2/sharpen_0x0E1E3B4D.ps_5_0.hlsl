#include "../shared.h"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb4 : register(b4){
  float4 cb4[236];
}
cbuffer cb3 : register(b3){
  float4 cb3[77];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD8,
  float4 v2 : COLOR0,
  float4 v3 : COLOR1,
  float4 v4 : TEXCOORD9,
  float4 v5 : TEXCOORD0,
  float4 v6 : TEXCOORD1,
  float4 v7 : TEXCOORD2,
  float4 v8 : TEXCOORD3,
  float4 v9 : TEXCOORD4,
  float4 v10 : TEXCOORD5,
  float4 v11 : TEXCOORD6,
  float4 v12 : TEXCOORD7,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,r16,r17,r18,r19,r20,r21,r22,r23,r24;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(-1.5,1.5);
  r1.x = cb4[8].z * r0.x + v5.x;
  r1.y = v5.y;
  r2.x = cb4[8].z * r0.y + v5.x;
  r2.y = v5.y;
  r3.y = cb4[8].w * r0.x + v5.y;
  r3.x = v5.x;
  r4.y = -cb4[8].w + v5.y;
  r5.y = cb4[8].w + v5.y;
  r5.x = v5.x;
  r4.x = v5.x;
  r6.xyzw = t0.Sample(s0_s, r4.xy).xyzw;
  r7.xyzw = t0.Sample(s0_s, r5.xy).xyzw;
  r5.xyz = r7.xyz + r6.xyz;
  r4.xyzw = t0.Sample(s0_s, v5.xy).xyzw;
  r5.xyz = float3(2,2,2) * -r4.xyz + r5.xyz;
  r8.y = cb4[8].w * r0.y + v5.y;
  r5.xyz = float3(0.5,0.5,0.5) * abs(r5.xyz);
  r0.x = -cb4[8].z + v5.x;
  r1.w = dot(r5.xyz, float3(0.33,0.33,0.33));
  r9.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r10.xyzw = t0.Sample(s0_s, r2.xy).xyzw;
  r2.xyzw = r4.xyzw + r4.xyzw;
  r5.xyzw = r10.xyzw + r9.xyzw;
  r0.w = r1.w * 3 + -0.1;
  r5.xyzw = float4(2,2,2,2) * r5.xyzw + r2.xyzw;
  r0.y = v5.y;
  r1.xyz = float3(0.166666999,0.166666999,0.166666999) * r5.xyz;
  r11.x = cb4[8].z + v5.x;
  r0.z = dot(r1.xyz, float3(0.33,0.33,0.33));
  r1.xyzw = r5.xyzw * float4(0.166666999,0.166666999,0.166666999,0.166666999) + -r4.xyzw;
  /*r12.y = cmp(0 < abs(r0.z));
  r12.x = rcp(r0.z);
  r5.w = r12.y ? r12.x : 9999999933815812510711506376257961984;*/
  r5.w = renodx::math::DivideSafe(1.f, r0.z);
  r0.w = saturate(r5.w * r0.w);
  r8.x = v5.x;
  r12.xyzw = t0.Sample(s0_s, r3.xy).xyzw;
  r13.xyzw = t0.Sample(s0_s, r8.xy).xyzw;
  r5.xyzw = r13.xyzw + r12.xyzw;
  r14.xyzw = r0.wwww * r1.xyzw + r4.xyzw;
  r5.xyzw = float4(2,2,2,2) * r5.xyzw + r2.xyzw;
  r1.xyz = float3(0.166666999,0.166666999,0.166666999) * r5.xyz;
  r11.y = v5.y;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r11.xyzw = t0.Sample(s0_s, r11.xy).xyzw;
  r2.xyz = r11.xyz + r0.xyz;
  r2.w = dot(r1.xyz, float3(0.33,0.33,0.33));
  r2.xyz = float3(2,2,2) * -r4.xyz + r2.xyz;
  /*r16.y = cmp(0 < abs(r2.w));
  r16.x = rcp(r2.w);
  r15.w = r16.y ? r16.x : 9999999933815812510711506376257961984;*/
  r15.w = renodx::math::DivideSafe(1.f, r2.w);
  r2.xyz = float3(0.5,0.5,0.5) * abs(r2.xyz);
  r5.xyzw = r5.xyzw * float4(0.166666999,0.166666999,0.166666999,0.166666999) + -r14.xyzw;
  r1.w = dot(r2.xyz, float3(0.330000013,0.330000013,0.330000013));
  r2.zw = cb4[8].zw;
  r2.x = r2.z * 3.5 + v5.x;
  r2.y = v5.y;
  r16.xyzw = t0.Sample(s0_s, r2.xy).xyzw;
  r1.z = r16.w + r10.w;
  r2.x = r2.z * 5.5 + v5.x;
  r2.y = v5.y;
  r17.xyzw = t0.Sample(s0_s, r2.xy).xyzw;
  r1.z = r17.w + r1.z;
  r2.x = r2.z * 7.5 + v5.x;
  r2.y = v5.y;
  r18.xyzw = t0.Sample(s0_s, r2.xy).xyzw;
  r2.y = r18.w + r1.z;
  r18.w = r1.w * 3 + -0.100000001;
  r1.w = r2.y + r9.w;
  r2.x = r2.z * -3.5 + v5.x;
  r2.y = v5.y;
  r19.xyzw = t0.Sample(s0_s, r2.xy).xyzw;
  r1.w = r19.w + r1.w;
  r2.x = r2.z * -5.5 + v5.x;
  r2.y = v5.y;
  r20.xyzw = t0.Sample(s0_s, r2.xy).xyzw;
  r1.w = r20.w + r1.w;
  r2.x = r2.z * -7.5 + v5.x;
  r2.y = v5.y;
  r8.xyzw = t0.Sample(s0_s, r2.xy).xyzw;
  r2.y = r2.w * 3.5 + v5.y;
  r2.x = v5.x;
  r21.xyzw = t0.Sample(s0_s, r2.xy).xyzw;
  r2.z = r21.w + r13.w;
  r2.y = r2.w * 5.5 + v5.y;
  r2.x = v5.x;
  r22.xyzw = t0.Sample(s0_s, r2.xy).xyzw;
  r2.z = r22.w + r2.z;
  r2.y = r2.w * 7.5 + v5.y;
  r2.x = v5.x;
  r23.xyzw = t0.Sample(s0_s, r2.xy).xyzw;
  r2.z = r23.w + r2.z;
  r8.w = r8.w + r1.w;
  r2.z = r2.z + r12.w;
  r2.y = r2.w * -3.5 + v5.y;
  r2.x = v5.x;
  r3.xyzw = t0.Sample(s0_s, r2.xy).xyzw;
  r2.z = r3.w + r2.z;
  r2.y = r2.w * -5.5 + v5.y;
  r2.x = v5.x;
  r1.xyzw = t0.Sample(s0_s, r2.xy).xyzw;
  r1.w = r1.w + r2.z;
  r2.y = r2.w * -7.5 + v5.y;
  r2.x = v5.x;
  r2.xyzw = t0.Sample(s0_s, r2.xy).xyzw;
  r2.w = r2.w + r1.w;
  r8.w = saturate(r8.w * 0.25 + -1);
  r3.w = saturate(r2.w * 0.25 + -1);
  r1.w = saturate(r18.w * r15.w);
  r2.w = -r3.w + r8.w;
  r1.w = 0.5 * r1.w;
  r2.w = 0.2 + -abs(r2.w);
  r5.xyzw = r1.wwww * r5.xyzw + r14.xyzw;
  r24.w = cmp(r2.w >= 0);
  r2.w = r24.w ? -0 : 1;
  r24.x = cmp(r2.w != -r2.w);
  if (r24.x != 0) {
    r10.xyz = r16.xyz + r10.xyz;
    r17.xyz = r10.xyz + r17.xyz;
    r13.xyz = r21.xyz + r13.xyz;
    r18.xyz = r17.xyz + r18.xyz;
    r22.xyz = r13.xyz + r22.xyz;
    r9.xyz = r18.xyz + r9.xyz;
    r23.xyz = r22.xyz + r23.xyz;
    r19.xyz = r9.xyz + r19.xyz;
    r12.xyz = r23.xyz + r12.xyz;
    r20.xyz = r19.xyz + r20.xyz;
    r3.xyz = r12.xyz + r3.xyz;
    r8.xyz = r20.xyz + r8.xyz;
    r1.xyz = r3.xyz + r1.xyz;
    r2.xyz = r1.xyz + r2.xyz;
    r1.xyz = float3(0.125,0.125,0.125) * r8.xyz;
    r1.y = dot(r1.xyz, float3(0.33,0.33,0.33));
    r2.xyz = float3(0.125,0.125,0.125) * r2.xyz;
    r1.w = dot(r4.xyz, float3(0.33,0.33,0.33));
    r2.w = dot(r11.xyz, float3(0.33,0.33,0.33));
    r2.x = dot(r2.xyz, float3(0.33,0.33,0.33));
    r2.z = -r2.w + r1.w;
    r2.w = r2.x + -r1.w;
    /*r24.y = cmp(0 < abs(r2.z));
    r24.x = rcp(r2.z);
    r2.z = r24.y ? r24.x : 9999999933815812510711506376257961984;*/
    r2.z = renodx::math::DivideSafe(1.f, r2.z);
    r2.y = saturate(r2.w * r2.z + 1);
    r2.z = dot(r7.xyz, float3(0.33,0.33,0.33));
    r2.w = -r1.w + r1.y;
    r2.z = -r2.z + r1.w;
    /*r24.y = cmp(0 < abs(r2.z));
    r24.x = rcp(r2.z);
    r2.z = r24.y ? r24.x : 9999999933815812510711506376257961984;*/
    r2.z = renodx::math::DivideSafe(1.f, r2.z);
    r1.x = dot(r0.xyz, float3(0.33,0.33,0.33));
    r2.w = saturate(r2.w * r2.z + 1);
    r2.z = -r1.x + r1.w;
    /*r24.y = cmp(0 < abs(r2.z));
    r24.x = rcp(r2.z);
    r1.z = r24.y ? r24.x : 9999999933815812510711506376257961984;*/
    r1.z = renodx::math::DivideSafe(1.f, r2.z);
    r2.z = dot(r6.xyz, float3(0.33,0.33,0.33));
    r2.x = -r1.x + r2.x;
    r1.w = -r2.z + r1.w;
    /*r24.y = cmp(0 < abs(r1.w));
    r24.x = rcp(r1.w);
    r1.w = r24.y ? r24.x : 9999999933815812510711506376257961984;*/
    r1.w = renodx::math::DivideSafe(1.f, r1.w);
    r2.z = -r2.z + r1.y;
    r2.x = saturate(r2.x * r1.z);
    r2.z = saturate(r2.z * r1.w);
    r24.xyzw = cmp(-r2.xyzw >= float4(0,0,0,0));
    r2.xyzw = r24.xyzw ? float4(1,1,1,1) : r2.xyzw;
    r24.xyzw = -r0.xyzw + r4.xyzw;
    r1.xyzw = r2.xxxx * r24.xyzw + r0.xyzw;
    r24.xyzw = -r6.xyzw + r4.xyzw;
    r0.xyzw = r2.zzzz * r24.xyzw + r6.xyzw;
    r24.xyzw = -r11.xyzw + r1.xyzw;
    r4.xyzw = r2.yyyy * r24.xyzw + r11.xyzw;
    r24.xyzw = -r7.xyzw + r0.xyzw;
    r1.xyzw = r2.wwww * r24.xyzw + r7.xyzw;
    r24.xyzw = -r5.xyzw + r4.xyzw;
    r2.xyzw = r3.wwww * r24.xyzw + r5.xyzw;
    r5.xyzw = -r2.xyzw + r1.xyzw;
    o0.xyzw = r8.wwww * r5.xyzw + r2.xyzw;
  } else {
    o0.xyzw = r5.xyzw;
  }
  o0.xyz = renodx::color::srgb::DecodeSafe(o0.xyz);
  if (CUSTOM_FILM_GRAIN_STRENGTH > 0.f) {
    o0.xyz = renodx::effects::ApplyFilmGrain(
        o0.xyz,
        v5.xy,
        CUSTOM_RANDOM,
        CUSTOM_FILM_GRAIN_STRENGTH * 0.03f);
  }
  o0.xyz = renodx::draw::RenderIntermediatePass(o0.xyz);
  return;
}