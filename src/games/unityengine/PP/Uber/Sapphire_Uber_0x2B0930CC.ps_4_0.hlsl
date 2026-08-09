#include "../../tonemap.hlsl"

Texture2D<float4> t7 : register(t7);
Texture2D<float4> t6 : register(t6);
Texture2D<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s7_s : register(s7);
SamplerState s6_s : register(s6);
SamplerState s5_s : register(s5);
SamplerState s4_s : register(s4);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[26];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r1.xyzw = t1.Sample(s1_s, v1.xy).xyzw;
  r1.w = cb0[7].x + cb0[6].x;
  r2.xyzw = t2.Sample(s2_s, v1.xy).xyzw;
  r2.xyz = cb0[7].xxx * r2.xyz;
  r1.xyz = r1.xyz * cb0[6].xxx + r2.xyz;
  r1.w = cb0[8].x + r1.w;
  r2.xyzw = t3.Sample(s3_s, v1.xy).xyzw;
  r1.xyz = r2.xyz * cb0[8].xxx + r1.xyz;
  r1.w = cb0[9].x + r1.w;
  r2.xyzw = t4.Sample(s4_s, v1.xy).xyzw;
  r1.xyz = r2.xyz * cb0[9].xxx + r1.xyz;
  r1.w = cb0[10].x + r1.w;
  r2.xyzw = t5.Sample(s5_s, v1.xy).xyzw;
  r1.xyz = r2.xyz * cb0[10].xxx + r1.xyz;
  r1.w = cb0[11].x + r1.w;
  r2.xyzw = t6.Sample(s6_s, v1.xy).xyzw;
  r1.xyz = r2.xyz * cb0[11].xxx + r1.xyz;
  r1.xyz = r1.xyz / r1.www;
  r1.xyz = r1.xyz * cb0[4].zzz * injectedData.fxBloom + r0.xyz;
  r1.w = exp2(cb0[3].y);
  r2.x = 10 * cb0[3].z;
  r2.y = cb0[3].w * 0.25 + 1;
  r1.xyz = r1.xyz * r1.www + float3(-0.2,-0.2,-0.2);
  r1.xyz = r1.xyz * r2.yyy + float3(0.2,0.2,0.2);
  r1.xyz = max(float3(0,0,0), r1.xyz);
  if (asint(cb0[3].x) == 1) {
    r1.z = dot(r1.xyz, float3(0.0396819152,0.45802179,0.00609653955));
    r1.xyz = r1.zzz;
  } else {
    if (asint(cb0[3].x) == 2) {
      r2.z = dot(r1.xyz, float3(0.45802179,0.0396819152,0.00609653955));
      r1.xyz = min(float3(1,1,1), r2.zzz);
    } else {
      if (asint(cb0[3].x) == 3) {
        r2.z = dot(r1.xyz, float3(0.0396819152,0.45802179,0.00609653955));
        r3.xyz = float3(1.5,1.25294113,1.01176476) * r2.zzz;
        r4.xyz = r1.xyz * float3(1.5,0.75,0.5) + -r3.xyz;
        r1.xyz = r4.xyz * float3(0.05,0.05,0.05) + r3.xyz;
      } else {
        if (asint(cb0[3].x) == 4) {
          r3.xyz = float3(-0.2,-0.2,-0.2) + r1.xyz;
          r3.xyz = r3.xyz * float3(1.00999999,1.00999999,1.00999999) + float3(0.2,0.2,0.2);
          r3.xyz = max(float3(0,0,0), r3.xyz);
          r2.z = dot(r3.xyz, float3(0.0396819152,0.45802179,0.00609653955));
          r3.xyz = r3.xyz + -r2.zzz;
          r1.xyz = r3.xyz * float3(1.25,1.25,1.25) + r2.zzz;
        } else {
          if (asint(cb0[3].x) == 5) {
            r3.xyz = r1.xyz * float3(1.18920708,1.18920708,1.18920708) + float3(-0.200000003,-0.200000003,-0.200000003);
            r3.xyz = r3.xyz * float3(0.899999976,0.899999976,0.899999976) + float3(0.200000003,0.200000003,0.200000003);
            r2.z = dot(r3.xyz, float3(0.0396819152,0.45802179,0.00609653955));
            r2.z = min(1, r2.z);
            r2.w = -0.0500000007 + r2.z;
            r2.w = max(0, r2.w);
            r2.w = 3 * r2.w;
            r2.w = min(1, r2.w);
            r2.z = 0.100000024 + -r2.z;
            r2.z = 3 * r2.z;
            r2.z = max(0, r2.z);
            r4.xyz = float3(1,0.600000024,0.815686285) * r3.xyz;
            r5.xyz = -r3.xyz * float3(1,0.600000024,0.815686285) + float3(1,0.600000024,0.815686285);
            r4.xyz = r5.xyz * float3(0.1,0.1,0.1) + r4.xyz;
            r5.xyz = float3(0.749019623,0.972549021,1) * r3.xyz;
            r6.xyz = -r3.xyz * float3(0.749019623,0.972549021,1) + float3(0.749019623,0.972549021,1);
            r5.xyz = r6.xyz * float3(0.5,0.5,0.5) + r5.xyz;
            r4.xyz = r4.xyz + -r3.xyz;
            r3.xyz = r2.zzz * r4.xyz + r3.xyz;
            r4.xyz = r5.xyz + -r3.xyz;
            r1.xyz = r2.www * r4.xyz + r3.xyz;
          } else {
            if (asint(cb0[3].x) == 6) {
              r2.zw = float2(0.5,0.25) * v0.xx;
              r3.xy = v0.xy * float2(0.166666672,0.166666672) + float2(-0.25,-0.25);
              r3.zw = cmp(r2.zw >= -r2.zw);
              r2.zw = frac(abs(r2.zw));
              r2.zw = r3.zw ? r2.zw : -r2.zw;
              r2.zw = cmp(r2.zw < float2(0.5,0.5));
              r2.zw = r2.zw ? float2(0.0299999993,0.0199999996) : float2(-0.0299999993,-0.0199999996);
              r2.z = r3.y + r2.z;
              r4.yw = r2.zz + r2.ww;
              r3.xz = floor(r3.xx);
              r3.yw = floor(r4.ww);
              r3.xyzw = float4(0.5,0.5,0.5,0.5) + r3.xyzw;
              r4.xz = float2(0.166666672,0.166666672) * v0.xx;
              r5.xyzw = float4(-0.25,0.200000003,-0.25,0.200000003) + r4.zwzw;
              r6.xyzw = float4(-0.5,0,-0.5,0) + r4.xyzw;
              r1.xyz = float3(0,0,0);
              r2.z = -2;
              while (true) {
                r2.w = cmp(2 < (int)r2.z);
                if (r2.w != 0) break;
                r7.xz = (int2)r2.zz;
                r8.xyz = r1.xyz;
                r2.w = -2;
                while (true) {
                  r4.x = cmp(2 < (int)r2.w);
                  if (r4.x != 0) break;
                  r7.yw = (int2)r2.ww;
                  r9.xyzw = r7.xyzw + r3.xyzw;
                  r4.xy = r9.zw / cb0[2].zw;
                  r10.x = 6 * r4.x;
                  r10.z = -r4.y * 6 + 1;
                  r10.xyzw = t0.Sample(s0_s, r10.xz).xyzw;
                  r10.xyz = r10.xyz * r1.www + float3(-0.2,-0.2,-0.2);
                  r10.xyz = r10.xyz * r2.yyy + float3(0.2,0.2,0.2);
                  r10.xyz = max(float3(0,0,0), r10.xyz);
                  r11.xyzw = r9.zwzw + -r5.xyzw;
                  r11.xyzw = float4(1.13125002,1.62899995,1.18781245,1.62899995) * r11.xyzw;
                  r4.x = max(abs(r11.x), abs(r11.y));
                  r4.y = dot(r11.zw, r11.zw);
                  r4.y = sqrt(r4.y);
                  r4.y = r4.y * 0.850000024 + -r4.x;
                  r4.x = r4.y * 0.300000012 + r4.x;
                  r11.xyzw = r9.zwzw + -r4.zwzw;
                  r11.xyzw = float4(1.13125002,1.62899995,1.18781245,1.62899995) * r11.xyzw;
                  r4.y = max(abs(r11.x), abs(r11.y));
                  r7.y = dot(r11.zw, r11.zw);
                  r7.y = sqrt(r7.y);
                  r7.y = r7.y * 0.850000024 + -r4.y;
                  r4.y = r7.y * 0.300000012 + r4.y;
                  r9.xyzw = r9.xyzw + -r6.xyzw;
                  r9.xyzw = float4(1.13125002,1.62899995,1.18781245,1.62899995) * r9.xyzw;
                  r7.y = max(abs(r9.x), abs(r9.y));
                  r7.w = dot(r9.zw, r9.zw);
                  r7.w = sqrt(r7.w);
                  r7.w = r7.w * 0.850000024 + -r7.y;
                  r7.y = r7.w * 0.300000012 + r7.y;
                  r9.xyz = log2(r10.xyz);
                  r9.xyz = float3(1.17999995,1.17999995,1.17999995) * r9.xyz;
                  r9.xyz = exp2(r9.xyz);
                  r9.xyz = float3(1.08000004,1.08000004,1.08000004) * r9.xyz;
                  r7.w = -r4.x * r4.x;
                  r7.w = r7.w * 2.5 + -0.300000012;
                  r7.w = exp2(r7.w);
                  r8.w = r4.x * r4.x;
                  r4.x = r8.w * r4.x;
                  r4.x = r4.x * 0.449999988 + 0.0549999997;
                  r4.x = 0.0500000007 / r4.x;
                  r4.x = r4.x + -r7.w;
                  r4.x = r4.x * 0.649999976 + r7.w;
                  r4.x = 0.99000001 * r4.x;
                  r10.x = r9.x * r4.x;
                  r4.x = -r4.y * r4.y;
                  r4.x = r4.x * 2.5 + -0.300000012;
                  r4.x = exp2(r4.x);
                  r7.w = r4.y * r4.y;
                  r4.y = r7.w * r4.y;
                  r4.y = r4.y * 0.449999988 + 0.0549999997;
                  r4.y = 0.0500000007 / r4.y;
                  r4.y = r4.y + -r4.x;
                  r4.x = r4.y * 0.649999976 + r4.x;
                  r4.x = 0.99000001 * r4.x;
                  r10.y = r9.y * r4.x;
                  r4.x = -r7.y * r7.y;
                  r4.x = r4.x * 2.5 + -0.300000012;
                  r4.x = exp2(r4.x);
                  r4.y = r7.y * r7.y;
                  r4.y = r4.y * r7.y;
                  r4.y = r4.y * 0.449999988 + 0.0549999997;
                  r4.y = 0.0500000007 / r4.y;
                  r4.y = r4.y + -r4.x;
                  r4.x = r4.y * 0.649999976 + r4.x;
                  r4.x = 0.99000001 * r4.x;
                  r10.z = r9.z * r4.x;
                  r8.xyz = r10.xyz + r8.xyz;
                  r2.w = (int)r2.w + 1;
                }
                r1.xyz = r8.xyz;
                r2.z = (int)r2.z + 1;
              }
            }
          }
        }
      }
    }
  }
  r2.yz = float2(-0.5,-0.5) + v1.xy;
  r1.w = dot(r2.yz, r2.yz);
  r1.w = 1 + -r1.w;
  r1.w = log2(r1.w);
  r1.w = r2.x * r1.w;
  r1.w = exp2(r1.w);
  r1.w = min(1, r1.w);
  r1.xyz = r1.xyz * r1.www;
  r1.xyz = applyUserTonemapSapphire(r1.xyz);
  r2.xy = v1.xy * cb0[22].xy + cb0[22].zw;
  r2.xyzw = t7.Sample(s7_s, r2.xy).xyzw;
  r1.w = r2.w * 2 + -1;
  float sign1 = sign(r1.w);
  r1.w = 1 + -abs(r1.w);
  r1.w = sqrt(r1.w);
  r1.w = 1 + -r1.w;
  r1.w = sign1 * r1.w;
  r0.xyz = applyDither(r1.xyz, r1.w * (1.0 / 765.0), 1);
  r0.w = saturate(r0.w);
  r1.x = 1 / cb0[25].x;
  r0.xyz = PostToneMapScale(r0.xyz);
  o0.xyzw = r0.xyzw;
  return;
}