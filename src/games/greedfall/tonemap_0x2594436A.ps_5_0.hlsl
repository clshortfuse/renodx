#include "./common.hlsl"

Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[3];
}
cbuffer cb0 : register(b0){
  float4 cb0[97];
}

#define cmp -

void main(
  float4 v0 : SV_Position0,
  float3 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = (int)cb1[0].x;
  r0.yzw = t0.Sample(s0_s, v1.xy).xyz;
  r1.xyz = t1.Sample(s0_s, v1.xy).xyz;
  r1.xyz = cb1[1].xxx * r1.xyz * injectedData.fxBloom;
  r0.yzw = r0.yzw * v1.zzz + r1.xyz;
  r1.xyz = t2.Sample(s0_s, v1.xy).xyz;
  r1.xyz = cb1[2].xxx * r1.xyz * injectedData.fxGodRays;
  r1.w = 0.00100000005 * cb0[96].w;
  r2.xyz = t3.Sample(s0_s, v1.xy).xyz;
  r2.xyz = cb1[2].xxx * r2.xyz * injectedData.fxGodRays;
  r2.xyz = r2.xyz * r1.www;
  r1.xyz = r1.xyz * r1.www + r2.xyz;
  r0.yzw = r1.xyz + r0.yzw;
    float3 untonemapped = r0.yzw;
  r1.x = cmp((int)r0.x == 1);
  if (r1.x != 0) {
    r1.xyz = float3(1,1,1) + r0.yzw;
    r1.xyz = r0.yzw / r1.xyz;
    r1.xyz = max(float3(0,0,0), r1.xyz);
    r1.xyz = log2(r1.xyz);
    r1.xyz = float3(0.454545468,0.454545468,0.454545468) * r1.xyz;
    r1.xyz = exp2(r1.xyz);
  } else {
    if (r0.x == 0) {
      r2.xyz = float3(-0.00400000019,-0.00400000019,-0.00400000019) + r0.yzw;
      r2.xyz = max(float3(0,0,0), r2.xyz);
      r3.xyz = r2.xyz * float3(6.19999981,6.19999981,6.19999981) + float3(0.5,0.5,0.5);
      r3.xyz = r3.xyz * r2.xyz;
      r4.xyz = r2.xyz * float3(6.19999981,6.19999981,6.19999981) + float3(1.70000005,1.70000005,1.70000005);
      r2.xyz = r2.xyz * r4.xyz + float3(0.0599999987,0.0599999987,0.0599999987);
      r1.xyz = r3.xyz / r2.xyz;
    } else {
      r1.w = cmp((int)r0.x == 2);
      if (r1.w != 0) {
        r2.xyz = r0.yzw + r0.yzw;
        r3.xyz = r0.yzw * float3(0.300000012,0.300000012,0.300000012) + float3(0.0500000007,0.0500000007,0.0500000007);
        r3.xyz = r2.xyz * r3.xyz + float3(0.00400000019,0.00400000019,0.00400000019);
        r4.xyz = r0.yzw * float3(0.300000012,0.300000012,0.300000012) + float3(0.5,0.5,0.5);
        r2.xyz = r2.xyz * r4.xyz + float3(0.0599999987,0.0599999987,0.0599999987);
        r2.xyz = r3.xyz / r2.xyz;
        r2.xyz = float3(-0.0666666701,-0.0666666701,-0.0666666701) + r2.xyz;
        r2.xyz = float3(1.37906432,1.37906432,1.37906432) * r2.xyz;
        r2.xyz = max(float3(0,0,0), r2.xyz);
        r2.xyz = log2(r2.xyz);
        r2.xyz = float3(0.454545468,0.454545468,0.454545468) * r2.xyz;
        r1.xyz = exp2(r2.xyz);
      } else {
        r1.w = cmp((int)r0.x == 4);
        if (r1.w != 0) {
          r2.xyz = r0.yzw * float3(2.50999999,2.50999999,2.50999999) + float3(0.0299999993,0.0299999993,0.0299999993);
          r2.xyz = r2.xyz * r0.yzw;
          r3.xyz = r0.yzw * float3(2.43000007,2.43000007,2.43000007) + float3(0.589999974,0.589999974,0.589999974);
          r3.xyz = r0.yzw * r3.xyz + float3(0.140000001,0.140000001,0.140000001);
          r2.xyz = r2.xyz / r3.xyz;
          r2.xyz = max(float3(0,0,0), r2.xyz);
          r2.xyz = log2(r2.xyz);
          r2.xyz = float3(0.454545468,0.454545468,0.454545468) * r2.xyz;
          r1.xyz = exp2(r2.xyz);
            r1.rgb = renodx::color::gamma::EncodeSafe(untonemapped);
        } else {
          r1.w = cmp((int)r0.x == 5);
          if (r1.w != 0) {
            r2.xyz = r0.yzw * r0.yzw;
            r2.xyz = r2.xyz * r0.yzw + r2.xyz;
            r2.xyz = r2.xyz + r0.yzw;
            r3.xyz = float3(1,1,1) + r2.xyz;
            r2.xyz = r2.xyz / r3.xyz;
            r2.xyz = max(float3(0,0,0), r2.xyz);
            r2.xyz = log2(r2.xyz);
            r2.xyz = float3(0.454545468,0.454545468,0.454545468) * r2.xyz;
            r1.xyz = exp2(r2.xyz);
          } else {
            r1.w = cmp((int)r0.x == 6);
            if (r1.w != 0) {
              r1.w = dot(r0.yzw, float3(0.212599993,0.715200007,0.0722000003));
              r2.x = 1 + r1.w;
              r2.x = r1.w / r2.x;
              r2.xyz = r2.xxx * r0.yzw;
              r2.xyz = r2.xyz / r1.www;
              r2.xyz = max(float3(0,0,0), r2.xyz);
              r2.xyz = log2(r2.xyz);
              r2.xyz = float3(0.454545468,0.454545468,0.454545468) * r2.xyz;
              r1.xyz = exp2(r2.xyz);
            } else {
              r1.w = cmp((int)r0.x == 7);
              if (r1.w != 0) {
                r1.w = dot(r0.yzw, float3(0.212599993,0.715200007,0.0722000003));
                r2.xy = r1.ww * float2(2.50999999,2.43000007) + float2(0.0299999993,0.589999974);
                r2.x = r2.x * r1.w;
                r2.y = r1.w * r2.y + 0.140000001;
                r2.x = r2.x / r2.y;
                r2.xyz = r2.xxx * r0.yzw;
                r2.xyz = r2.xyz / r1.www;
                r2.xyz = max(float3(0,0,0), r2.xyz);
                r2.xyz = log2(r2.xyz);
                r2.xyz = float3(0.454545468,0.454545468,0.454545468) * r2.xyz;
                r1.xyz = exp2(r2.xyz);
              } else {
                r0.x = cmp((int)r0.x == 8);
                r1.w = dot(r0.yzw, float3(0.212599993,0.715200007,0.0722000003));
                r2.x = r1.w * r1.w;
                r2.x = r2.x * r1.w + r2.x;
                r2.x = r2.x + r1.w;
                r2.y = 1 + r2.x;
                r2.x = r2.x / r2.y;
                r2.xyz = r2.xxx * r0.yzw;
                r2.xyz = r2.xyz / r1.www;
                r2.xyz = max(float3(0,0,0), r2.xyz);
                r2.xyz = log2(r2.xyz);
                r2.xyz = float3(0.454545468,0.454545468,0.454545468) * r2.xyz;
                r2.xyz = exp2(r2.xyz);
                r0.yzw = max(float3(0,0,0), r0.yzw);
                r0.yzw = log2(r0.yzw);
                r0.yzw = float3(0.454545468,0.454545468,0.454545468) * r0.yzw;
                r0.yzw = exp2(r0.yzw);
                r1.xyz = r0.xxx ? r2.xyz : r0.yzw;
              }
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