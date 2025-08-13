// ---- Created with 3Dmigoto v1.3.16 on Fri Oct 18 20:09:56 2024
#include "./colorcorrectcommon.hlsl"

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<uint4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2) {
  float4 cb2[8];
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
void main(
    float4 v0 : SV_POSITION0,
                out float4 o0 : SV_Target0) {
  float4 r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = asuint(cb0[37].xy);
  r0.xy = v0.xy + -r0.xy;
  r0.xy = cb0[38].zw * r0.xy;
  r0.zw = r0.xy * cb0[5].xy + cb0[4].xy;
  r1.xyz = t4.Sample(s3_s, r0.zw).xyz;
  InverIntermediateToSRGB(r1.rgb);

  r2.xyz = t4.Sample(s2_s, r0.zw).xyz;
  InverIntermediateToSRGB(r2.rgb);

  r3.xyz = cb2[1].xyz * r2.xyz;
  r0.zw = r0.xy * cb1[129].xy + cb1[128].xy;
  r0.zw = cb1[132].zw * r0.zw;
  r1.w = t1.SampleLevel(s0_s, r0.zw, 0).x;
  r2.w = r1.w * cb1[71].x + cb1[71].y;
  r1.w = r1.w * cb1[71].z + -cb1[71].w;
  r1.w = 1 / r1.w;
  r1.w = r2.w + r1.w;
  r4.xy = cb1[132].xy * r0.zw;
  r4.xy = cb1[135].xy * r4.xy;
  r4.xy = trunc(r4.xy);
  r4.xy = (int2)r4.xy;
  r4.zw = float2(0, 0);
  r2.w = t2.Load(r4.xyz).y;
  r2.w = (uint)r2.w;
  r0.z = t0.SampleLevel(s0_s, r0.zw, 0).x;
  r0.w = r0.z * cb1[71].x + cb1[71].y;
  r0.z = r0.z * cb1[71].z + -cb1[71].w;
  r0.z = 1 / r0.z;
  r0.z = r0.w + r0.z;
  r0.w = -cb2[2].x + r2.w;
  r0.w = cmp(9.99999975e-06 < abs(r0.w));
  r0.w = r0.w ? -0 : -r0.z;
  r0.w = r1.w + r0.w;
  r1.w = r1.w + -r0.z;
  r4.xy = cmp(float2(9.99999975e-06, 9.99999975e-06) < abs(cb2[2].yz));
  r4.zw = cmp(cb2[2].yz >= float2(0, 0));
  r0.w = r4.z ? r0.w : r1.w;
  r0.w = r4.x ? r0.w : r1.w;
  r0.w = saturate(ceil(r0.w));
  r0.w = 1 + -r0.w;
  r5.xyz = cb2[1].xyz * r2.xyz + -r2.xyz;
  r5.xyz = r0.www * r5.xyz + r2.xyz;
  r4.xzw = r4.www ? r5.xyz : r3.xyz;
  r3.xyz = r4.yyy ? r4.xzw : r3.xyz;
  r4.xyz = float3(1, 1, 1) + -r2.xyz;
  r5.xyz = r4.xyz / r3.xyz;
  r5.xyz = float3(1, 1, 1) + -r5.xyz;
  r0.w = cmp(cb2[2].w != 1.000000);
  if (r0.w != 0) {
    r6.xyz = float3(1, 1, 1) + -r3.xyz;
    r7.xyz = r2.xyz / r6.xyz;
    r0.w = cmp(cb2[2].w == 2.000000);
    r5.xyz = r0.www ? r7.xyz : r5.xyz;
    if (r0.w == 0) {
      r7.xyz = -r3.xyz + r2.xyz;
      r0.w = cmp(cb2[2].w == 3.000000);
      r5.xyz = r0.www ? abs(r7.xyz) : r5.xyz;
      if (r0.w == 0) {
        r7.xyz = float3(-0.5, -0.5, -0.5) + r2.xyz;
        r8.xyz = float3(-0.5, -0.5, -0.5) + r3.xyz;
        r7.xyz = r8.xyz * r7.xyz;
        r7.xyz = -r7.xyz * float3(2, 2, 2) + float3(0.5, 0.5, 0.5);
        r0.w = cmp(cb2[2].w == 4.000000);
        r5.xyz = r0.www ? r7.xyz : r5.xyz;
        if (r0.w == 0) {
          r7.xyz = r8.xyz + r8.xyz;
          r8.xyz = -r8.xyz * float3(2, 2, 2) + float3(1, 1, 1);
          r8.xyz = -r4.xyz * r8.xyz + float3(1, 1, 1);
          r9.xyz = r3.xyz + r3.xyz;
          r10.xyz = r9.xyz * r2.xyz;
          r11.xyz = cmp(r3.xyz >= float3(0.5, 0.5, 0.5));
          r8.xyz = r11.xyz ? r8.xyz : r10.xyz;
          r0.w = cmp(cb2[2].w == 5.000000);
          r5.xyz = r0.www ? abs(r8.xyz) : r5.xyz;
          if (r0.w == 0) {
            r8.xyz = r3.xyz + r2.xyz;
            r10.xyz = float3(-1, -1, -1) + r8.xyz;
            r0.w = cmp(cb2[2].w == 6.000000);
            r5.xyz = r0.www ? r10.xyz : r5.xyz;
            if (r0.w == 0) {
              r0.w = cmp(cb2[2].w == 7.000000);
              r5.xyz = r0.www ? r8.xyz : r5.xyz;
              if (r0.w == 0) {
                r8.xyz = float3(-0.125, -0.125, -0.125) + r3.xyz;
                r8.xyz = r8.xyz * float3(1.25, 1.25, 1.25) + r2.xyz;
                r10.xyz = float3(-0.25, -0.25, -0.25) + r3.xyz;
                r10.xyz = r10.xyz * float3(2, 2, 2) + r2.xyz;
                r8.xyz = r11.xyz ? r8.xyz : r10.xyz;
                r0.w = cmp(cb2[2].w == 8.000000);
                r5.xyz = r0.www ? r8.xyz : r5.xyz;
                if (r0.w == 0) {
                  r7.xyz = max(r7.xyz, r2.xyz);
                  r8.xyz = min(r9.xyz, r2.xyz);
                  r7.xyz = r11.xyz ? r7.xyz : r8.xyz;
                  r0.w = cmp(cb2[2].w == 9.000000);
                  r5.xyz = r0.www ? r7.xyz : r5.xyz;
                  if (r0.w == 0) {
                    r7.xyz = -r3.xyz * float3(2, 2, 2) + float3(1, 1, 1);
                    r7.xyz = -r7.xyz * r4.xyz + float3(1, 1, 1);
                    r7.xyz = r7.xyz * r2.xyz;
                    r8.xyz = -r2.xyz * r9.xyz + float3(1, 1, 1);
                    r8.xyz = -r4.xyz * r8.xyz + float3(1, 1, 1);
                    r7.xyz = r11.xyz ? r7.xyz : r8.xyz;
                    r0.w = cmp(cb2[2].w == 10.000000);
                    r5.xyz = r0.www ? r7.xyz : r5.xyz;
                    if (r0.w == 0) {
                      r7.xyz = r6.xyz * r4.xyz;
                      r4.xyz = -r4.xyz * r6.xyz + float3(1, 1, 1);
                      r0.w = cmp(cb2[2].w == 11.000000);
                      r5.xyz = r0.www ? r4.xyz : r5.xyz;
                      if (r0.w == 0) {
                        r4.xyz = max(r3.xyz, r2.xyz);
                        r0.w = cmp(cb2[2].w == 12.000000);
                        r5.xyz = r0.www ? r4.xyz : r5.xyz;
                        if (r0.w == 0) {
                          r4.xyz = min(r3.xyz, r2.xyz);
                          r0.w = cmp(cb2[2].w == 13.000000);
                          r5.xyz = r0.www ? r4.xyz : r5.xyz;
                          if (r0.w == 0) {
                            r4.xyz = cmp(r2.xyz < float3(0.5, 0.5, 0.5));
                            r6.xyz = r3.xyz * r2.xyz;
                            r8.xyz = r6.xyz + r6.xyz;
                            r7.xyz = -r7.xyz * float3(2, 2, 2) + float3(1, 1, 1);
                            r4.xyz = r4.xyz ? r8.xyz : r7.xyz;
                            r0.w = cmp(cb2[2].w == 14.000000);
                            r5.xyz = r0.www ? r4.xyz : r5.xyz;
                            if (r0.w == 0) {
                              r0.w = cmp(cb2[2].w == 15.000000);
                              r5.xyz = r0.www ? r6.xyz : r5.xyz;
                              if (r0.w == 0) {
                                r0.w = cmp(cb2[2].w != 16.000000);
                                if (r0.w != 0) {
                                  r4.xyzw = cmp(cb2[2].wwww == float4(17, 18, 19, 20));
                                  r0.w = (int)r4.y | (int)r4.x;
                                  r6.xyz = r0.www ? float3(0, 0, 0) : r5.xyz;
                                  r0.w = (int)r4.z | (int)r0.w;
                                  r7.xyz = r0.www ? float3(0, 0, 0) : r5.xyz;
                                  r0.w = (int)r4.w | (int)r0.w;
                                  r8.xyz = r0.www ? float3(0, 0, 0) : r5.xyz;
                                  r3.xyz = r4.www ? r8.xyz : r3.xyz;
                                  r3.xyz = r4.zzz ? r7.xyz : r3.xyz;
                                  r3.xyz = r4.yyy ? r6.xyz : r3.xyz;
                                  r5.xyz = r4.xxx ? float3(0, 0, 0) : r3.xyz;
                                } else {
                                  r5.xyz = float3(0, 0, 0);
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
  r3.xyz = r5.xyz + -r2.xyz;
  r3.xyz = cb2[3].xxx * r3.xyz;
  r0.xy = r0.xy * cb2[4].zw + float2(0.5, 0.5);
  r0.xy = -cb2[5].xy + r0.xy;
  r0.x = t3.Sample(s1_s, r0.xy).x;
  r0.xyw = r0.xxx * r3.xyz;
  r0.z = cb2[6].x * r0.z;
  r1.w = cmp(0 >= r0.z);
  r0.z = log2(r0.z);
  r0.z = cb2[6].y * r0.z;
  r0.z = exp2(r0.z);
  r0.z = min(1, r0.z);
  r0.z = r1.w ? 0 : r0.z;
  r1.w = 1 + -r0.z;
  r2.w = cmp(9.99999975e-06 < abs(cb2[6].z));
  r3.x = cmp(cb2[6].z >= 0);
  r1.w = r3.x ? r1.w : r0.z;
  r0.z = r2.w ? r1.w : r0.z;
  r0.xyz = r0.zzz * r0.xyw + r2.xyz;
  r0.xyz = r0.xyz + -r1.xyz;
  r0.xyz = cb2[6].www * r0.xyz + r1.xyz;
  r1.xyz = cb2[7].yzw + -r0.xyz;
  r0.xyz = cb2[7].xxx * r1.xyz + r0.xyz;
  o0.xyz = max(float3(0, 0, 0), r0.xyz);
  o0.w = 0;

  RenderIntermediateFromSRGB(o0.rgb);

  return;
}