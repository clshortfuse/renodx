// ---- Created with 3Dmigoto v1.3.16 on Fri Oct 18 20:09:30 2024
#include "./shared.h"
#include "./tonemapper.hlsl"

Texture2D<float4> t5 : register(t5);

Texture2D<float4> t4 : register(t4);

Texture2D<uint4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2) {
  float4 cb2[11];
}

cbuffer cb1 : register(b1) {
  float4 cb1[136];
}

cbuffer cb0 : register(b0) {
  float4 cb0[39];
}

// 3Dmigoto declarations
#define cmp -

// Adjusts colors
// THIS IS ALSO CALLED FOR SHOP
// There's also light shafts shader getting called later
void main(
    float4 v0 : SV_POSITION0,
                out float4 o0 : SV_Target0) {
  float4 r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10;
  uint4 bitmask, uiDest;
  float4 fDest;
  float3 tonemappedPQ, post_srgb;

  r0.xy = asuint(cb0[37].xy);
  r0.xy = v0.xy + -r0.xy;
  r0.xy = cb0[38].zw * r0.xy;
  r0.zw = r0.xy * cb0[5].xy + cb0[4].xy;
  r1.xyz = t5.Sample(s2_s, r0.zw).xyz;

  tonemappedPQ = r1.rgb;

  r1.rgb = pqTosRGB(tonemappedPQ, true);

  r0.zw = r0.xy * cb1[129].xy + cb1[128].xy;
  r0.zw = cb1[132].zw * r0.zw;
  r1.w = t1.SampleLevel(s0_s, r0.zw, 0).x;
  r2.xyz = -cb2[3].xyz + r1.xyz;
  r2.xyz = r1.www * r2.xyz + cb2[3].xyz;
  r2.xyz = r2.xyz + -r1.xyz;
  r3.xyz = cb2[4].xxx * r2.xyz;
  r2.xyz = cb2[4].xxx * r2.xyz + r1.xyz;
  r1.w = t2.SampleLevel(s0_s, r0.zw, 0).x;
  r2.w = r1.w * cb1[71].x + cb1[71].y;
  r1.w = r1.w * cb1[71].z + -cb1[71].w;
  r1.w = 1 / r1.w;
  r1.w = r2.w + r1.w;
  r4.xy = cb1[132].xy * r0.zw;
  r4.xy = cb1[135].xy * r4.xy;
  r4.xy = trunc(r4.xy);
  r4.xy = (int2)r4.xy;
  r4.zw = float2(0, 0);
  r2.w = t3.Load(r4.xyz).y;
  r2.w = (uint)r2.w;
  r0.z = t0.SampleLevel(s0_s, r0.zw, 0).x;
  r0.w = r0.z * cb1[71].x + cb1[71].y;
  r0.z = r0.z * cb1[71].z + -cb1[71].w;
  r0.z = 1 / r0.z;
  r0.z = r0.w + r0.z;
  r0.w = -cb2[4].z + r2.w;
  r0.w = cmp(9.99999975e-06 < abs(r0.w));
  r0.w = r0.w ? -0 : -r0.z;
  r0.w = r1.w + r0.w;
  r1.w = r1.w + -r0.z;
  r2.w = cmp(9.99999975e-06 < abs(cb2[4].w));
  r3.w = cmp(cb2[4].w >= 0);
  r0.w = r3.w ? r0.w : r1.w;
  r0.w = r2.w ? r0.w : r1.w;
  r0.w = saturate(ceil(r0.w));
  r0.w = 1 + -r0.w;
  r3.xyz = r0.www * r3.xyz + r1.xyz;
  r0.w = cmp(9.99999975e-06 < abs(cb2[5].x));
  r1.w = cmp(cb2[5].x >= 0);
  r3.xyz = r1.www ? r3.xyz : r2.xyz;
  r2.xyz = r0.www ? r3.xyz : r2.xyz;
  r3.xyz = float3(1, 1, 1) + -r1.xyz;
  r4.xyz = r3.xyz / r2.xyz;
  r4.xyz = float3(1, 1, 1) + -r4.xyz;
  r0.w = cmp(cb2[5].y != 1.000000);
  if (r0.w != 0) {
    r5.xyz = float3(1, 1, 1) + -r2.xyz;
    r6.xyz = r1.xyz / r5.xyz;
    r0.w = cmp(cb2[5].y == 2.000000);
    r4.xyz = r0.www ? r6.xyz : r4.xyz;
    if (r0.w == 0) {
      r6.xyz = -r2.xyz + r1.xyz;
      r0.w = cmp(cb2[5].y == 3.000000);
      r4.xyz = r0.www ? abs(r6.xyz) : r4.xyz;
      if (r0.w == 0) {
        r6.xyz = float3(-0.5, -0.5, -0.5) + r1.xyz;
        r7.xyz = float3(-0.5, -0.5, -0.5) + r2.xyz;
        r6.xyz = r7.xyz * r6.xyz;
        r6.xyz = -r6.xyz * float3(2, 2, 2) + float3(0.5, 0.5, 0.5);
        r0.w = cmp(cb2[5].y == 4.000000);
        r4.xyz = r0.www ? r6.xyz : r4.xyz;
        if (r0.w == 0) {
          r6.xyz = r7.xyz + r7.xyz;
          r7.xyz = -r7.xyz * float3(2, 2, 2) + float3(1, 1, 1);
          r7.xyz = -r3.xyz * r7.xyz + float3(1, 1, 1);
          r8.xyz = r2.xyz + r2.xyz;
          r9.xyz = r8.xyz * r1.xyz;
          r10.xyz = cmp(r2.xyz >= float3(0.5, 0.5, 0.5));
          r7.xyz = r10.xyz ? r7.xyz : r9.xyz;
          r0.w = cmp(cb2[5].y == 5.000000);
          r4.xyz = r0.www ? abs(r7.xyz) : r4.xyz;
          if (r0.w == 0) {
            r7.xyz = r2.xyz + r1.xyz;
            r9.xyz = float3(-1, -1, -1) + r7.xyz;
            r0.w = cmp(cb2[5].y == 6.000000);
            r4.xyz = r0.www ? r9.xyz : r4.xyz;
            if (r0.w == 0) {
              r0.w = cmp(cb2[5].y == 7.000000);
              r4.xyz = r0.www ? r7.xyz : r4.xyz;
              if (r0.w == 0) {
                r7.xyz = float3(-0.125, -0.125, -0.125) + r2.xyz;
                r7.xyz = r7.xyz * float3(1.25, 1.25, 1.25) + r1.xyz;
                r9.xyz = float3(-0.25, -0.25, -0.25) + r2.xyz;
                r9.xyz = r9.xyz * float3(2, 2, 2) + r1.xyz;
                r7.xyz = r10.xyz ? r7.xyz : r9.xyz;
                r0.w = cmp(cb2[5].y == 8.000000);
                r4.xyz = r0.www ? r7.xyz : r4.xyz;
                if (r0.w == 0) {
                  r6.xyz = max(r6.xyz, r1.xyz);
                  r7.xyz = min(r8.xyz, r1.xyz);
                  r6.xyz = r10.xyz ? r6.xyz : r7.xyz;
                  r0.w = cmp(cb2[5].y == 9.000000);
                  r4.xyz = r0.www ? r6.xyz : r4.xyz;
                  if (r0.w == 0) {
                    r6.xyz = -r2.xyz * float3(2, 2, 2) + float3(1, 1, 1);
                    r6.xyz = -r6.xyz * r3.xyz + float3(1, 1, 1);
                    r6.xyz = r6.xyz * r1.xyz;
                    r7.xyz = -r1.xyz * r8.xyz + float3(1, 1, 1);
                    r7.xyz = -r3.xyz * r7.xyz + float3(1, 1, 1);
                    r6.xyz = r10.xyz ? r6.xyz : r7.xyz;
                    r0.w = cmp(cb2[5].y == 10.000000);
                    r4.xyz = r0.www ? r6.xyz : r4.xyz;
                    if (r0.w == 0) {
                      r6.xyz = r5.xyz * r3.xyz;
                      r3.xyz = -r3.xyz * r5.xyz + float3(1, 1, 1);
                      r0.w = cmp(cb2[5].y == 11.000000);
                      r4.xyz = r0.www ? r3.xyz : r4.xyz;
                      if (r0.w == 0) {
                        r3.xyz = max(r2.xyz, r1.xyz);
                        r0.w = cmp(cb2[5].y == 12.000000);
                        r4.xyz = r0.www ? r3.xyz : r4.xyz;
                        if (r0.w == 0) {
                          r3.xyz = min(r2.xyz, r1.xyz);
                          r0.w = cmp(cb2[5].y == 13.000000);
                          r4.xyz = r0.www ? r3.xyz : r4.xyz;

                          if (r0.w == 0) {
                            // Main Menu stops here
                            r3.xyz = cmp(r1.xyz < float3(0.5, 0.5, 0.5));
                            r5.xyz = r2.xyz * r1.xyz;
                            r7.xyz = r5.xyz + r5.xyz;
                            r6.xyz = -r6.xyz * float3(2, 2, 2) + float3(1, 1, 1);
                            r3.xyz = r3.xyz ? r7.xyz : r6.xyz;

                            r0.w = cmp(cb2[5].y == 14.000000);
                            r4.xyz = r0.www ? r3.xyz : r4.xyz;
                            // r4.rgb = float3(1, 0, 0.5);

                            if (r0.w == 0) {
                              r0.w = cmp(cb2[5].y == 15.000000);
                              r4.xyz = r0.www ? r5.xyz : r4.xyz;

                              if (r0.w == 0) {
                                r0.w = cmp(cb2[5].y != 16.000000);

                                if (r0.w != 0) {
                                  r3.xyzw = cmp(cb2[5].yyyy == float4(17, 18, 19, 20));
                                  r0.w = (int)r3.y | (int)r3.x;
                                  r5.xyz = r0.www ? float3(0, 0, 0) : r4.xyz;
                                  r0.w = (int)r3.z | (int)r0.w;
                                  r6.xyz = r0.www ? float3(0, 0, 0) : r4.xyz;
                                  r0.w = (int)r3.w | (int)r0.w;
                                  r7.xyz = r0.www ? float3(0, 0, 0) : r4.xyz;
                                  r2.xyz = r3.www ? r7.xyz : r2.xyz;
                                  r2.xyz = r3.zzz ? r6.xyz : r2.xyz;
                                  r2.xyz = r3.yyy ? r5.xyz : r2.xyz;
                                  r4.xyz = r3.xxx ? float3(0, 0, 0) : r2.xyz;

                                } else {
                                  r4.xyz = float3(0, 0, 0);
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
  // r4 here has invalid colors
  r2.xyz = r4.xyz + -r1.xyz;
  r2.xyz = cb2[5].zzz * r2.xyz;
  r0.xy = r0.xy * cb2[7].xy + float2(0.5, 0.5);
  r0.xy = -cb2[7].zw + r0.xy;
  r0.x = t4.Sample(s1_s, r0.xy).x;
  r0.xyw = r0.xxx * r2.xyz;
  r0.z = cb2[8].z * r0.z;
  r1.w = cmp(0 >= r0.z);
  r0.z = log2(r0.z);
  r0.z = cb2[8].w * r0.z;
  r0.z = exp2(r0.z);
  r0.z = min(1, r0.z);
  r0.z = r1.w ? 0 : r0.z;
  r1.w = 1 + -r0.z;
  r2.x = cmp(9.99999975e-06 < abs(cb2[9].x));
  r2.y = cmp(cb2[9].x >= 0);
  r1.w = r2.y ? r1.w : r0.z;
  r0.z = r2.x ? r1.w : r0.z;
  r0.xyz = r0.zzz * r0.xyw + r1.xyz;
  r1.xyz = cb2[10].xyz + -r0.xyz;
  r0.xyz = cb2[9].yyy * r1.xyz + r0.xyz;
  o0.xyz = max(float3(0, 0, 0), r0.xyz);
  post_srgb = o0.rgb;
  o0.w = 0;

  o0.rgb = upgradeSRGBtoPQ(tonemappedPQ, post_srgb);
  // o0.rgb = tonemappedPQ;

  return;
}