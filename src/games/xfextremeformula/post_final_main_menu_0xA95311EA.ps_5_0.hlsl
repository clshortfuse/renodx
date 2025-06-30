#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Sat Feb 08 00:38:14 2025
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[30];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = saturate(v1.xy);
  r0.xy = cb0[26].xx * r0.xy;
  r1.xyz = t1.SampleLevel(s1_s, r0.xy, 0).xyz;
  r0.z = t1.SampleLevel(s1_s, r0.xy, 0, int2(0, 1)).y;
  r0.w = t1.SampleLevel(s1_s, r0.xy, 0, int2(1, 0)).y;
  r1.w = t1.SampleLevel(s1_s, r0.xy, 0, int2(0, -1)).y;
  r2.x = t1.SampleLevel(s1_s, r0.xy, 0, int2(-1, 0)).y;
  r2.y = max(r0.z, r1.y);
  r2.z = min(r0.z, r1.y);
  r2.y = max(r2.y, r0.w);
  r2.z = min(r2.z, r0.w);
  r2.w = max(r2.x, r1.w);
  r3.x = min(r2.x, r1.w);
  r2.y = max(r2.w, r2.y);
  r2.z = min(r3.x, r2.z);
  r2.w = 0.063000001 * r2.y;
  r2.y = r2.y + -r2.z;
  r2.z = max(0.0311999992, r2.w);
  r2.z = cmp(r2.y >= r2.z);
  if (r2.z != 0) {
    r2.z = t1.SampleLevel(s1_s, r0.xy, 0, int2(-1, -1)).y;
    r2.w = t1.SampleLevel(s1_s, r0.xy, 0, int2(1, 1)).y;
    r3.x = t1.SampleLevel(s1_s, r0.xy, 0, int2(1, -1)).y;
    r0.x = t1.SampleLevel(s1_s, r0.xy, 0, int2(-1, 1)).y;
    r0.y = r1.w + r0.z;
    r3.y = r2.x + r0.w;
    r2.y = 1 / r2.y;
    r3.z = r3.y + r0.y;
    r0.y = r1.y * -2 + r0.y;
    r3.y = r1.y * -2 + r3.y;
    r3.w = r3.x + r2.w;
    r3.x = r3.x + r2.z;
    r4.x = r0.w * -2 + r3.w;
    r3.x = r1.w * -2 + r3.x;
    r2.z = r2.z + r0.x;
    r0.x = r0.x + r2.w;
    r0.y = abs(r0.y) * 2 + abs(r4.x);
    r2.w = abs(r3.y) * 2 + abs(r3.x);
    r3.x = r2.x * -2 + r2.z;
    r0.x = r0.z * -2 + r0.x;
    r0.y = abs(r3.x) + r0.y;
    r0.x = abs(r0.x) + r2.w;
    r2.z = r2.z + r3.w;
    r0.x = cmp(r0.y >= r0.x);
    r0.y = r3.z * 2 + r2.z;
    r1.w = r0.x ? r1.w : r2.x;
    r0.z = r0.x ? r0.z : r0.w;
    r0.w = r0.x ? cb0[29].y : cb0[29].x;
    r0.y = r0.y * 0.0833333358 + -r1.y;
    r2.x = r1.w + -r1.y;
    r2.z = r0.z + -r1.y;
    r1.w = r1.w + r1.y;
    r0.z = r0.z + r1.y;
    r2.w = cmp(abs(r2.x) >= abs(r2.z));
    r2.x = max(abs(r2.x), abs(r2.z));
    r0.w = r2.w ? -r0.w : r0.w;
    r0.y = saturate(abs(r0.y) * r2.y);
    r2.y = r0.x ? cb0[29].x : 0;
    r2.z = r0.x ? 0 : cb0[29].y;
    r3.xy = r0.ww * float2(0.5,0.5) + v1.xy;
    r3.x = r0.x ? v1.x : r3.x;
    r3.y = r0.x ? r3.y : v1.y;
    r4.xy = r3.xy + -r2.yz;
    r5.xy = r3.xy + r2.yz;
    r3.x = r0.y * -2 + 3;
    r3.yz = saturate(r4.xy);
    r3.yz = cb0[26].xx * r3.yz;
    r3.y = t1.SampleLevel(s1_s, r3.yz, 0).y;
    r0.y = r0.y * r0.y;
    r3.zw = saturate(r5.xy);
    r3.zw = cb0[26].xx * r3.zw;
    r3.z = t1.SampleLevel(s1_s, r3.zw, 0).y;
    r0.z = r2.w ? r1.w : r0.z;
    r1.w = 0.25 * r2.x;
    r2.x = -r0.z * 0.5 + r1.y;
    r0.y = r3.x * r0.y;
    r2.x = cmp(r2.x < 0);
    r3.x = -r0.z * 0.5 + r3.y;
    r3.y = -r0.z * 0.5 + r3.z;
    r3.zw = cmp(abs(r3.xy) >= r1.ww);
    r2.w = -r2.y * 1.5 + r4.x;
    r4.x = r3.z ? r4.x : r2.w;
    r2.w = -r2.z * 1.5 + r4.y;
    r4.z = r3.z ? r4.y : r2.w;
    r4.yw = ~(int2)r3.zw;
    r2.w = (int)r4.w | (int)r4.y;
    r4.y = r2.y * 1.5 + r5.x;
    r4.y = r3.w ? r5.x : r4.y;
    r5.x = r2.z * 1.5 + r5.y;
    r4.w = r3.w ? r5.y : r5.x;
    if (r2.w != 0) {
      if (r3.z == 0) {
        r5.xy = saturate(r4.xz);
        r5.xy = cb0[26].xx * r5.xy;
        r3.x = t1.SampleLevel(s1_s, r5.xy, 0).y;
      }
      if (r3.w == 0) {
        r5.xy = saturate(r4.yw);
        r5.xy = cb0[26].xx * r5.xy;
        r3.y = t1.SampleLevel(s1_s, r5.xy, 0).y;
      }
      r2.w = -r0.z * 0.5 + r3.x;
      r3.x = r3.z ? r3.x : r2.w;
      r2.w = -r0.z * 0.5 + r3.y;
      r3.y = r3.w ? r3.y : r2.w;
      r3.zw = cmp(abs(r3.xy) >= r1.ww);
      r2.w = -r2.y * 2 + r4.x;
      r4.x = r3.z ? r4.x : r2.w;
      r2.w = -r2.z * 2 + r4.z;
      r4.z = r3.z ? r4.z : r2.w;
      r5.xy = ~(int2)r3.zw;
      r2.w = (int)r5.y | (int)r5.x;
      r5.x = r2.y * 2 + r4.y;
      r4.y = r3.w ? r4.y : r5.x;
      r5.x = r2.z * 2 + r4.w;
      r4.w = r3.w ? r4.w : r5.x;
      if (r2.w != 0) {
        if (r3.z == 0) {
          r5.xy = saturate(r4.xz);
          r5.xy = cb0[26].xx * r5.xy;
          r3.x = t1.SampleLevel(s1_s, r5.xy, 0).y;
        }
        if (r3.w == 0) {
          r5.xy = saturate(r4.yw);
          r5.xy = cb0[26].xx * r5.xy;
          r3.y = t1.SampleLevel(s1_s, r5.xy, 0).y;
        }
        r2.w = -r0.z * 0.5 + r3.x;
        r3.x = r3.z ? r3.x : r2.w;
        r2.w = -r0.z * 0.5 + r3.y;
        r3.y = r3.w ? r3.y : r2.w;
        r3.zw = cmp(abs(r3.xy) >= r1.ww);
        r2.w = -r2.y * 2 + r4.x;
        r4.x = r3.z ? r4.x : r2.w;
        r2.w = -r2.z * 2 + r4.z;
        r4.z = r3.z ? r4.z : r2.w;
        r5.xy = ~(int2)r3.zw;
        r2.w = (int)r5.y | (int)r5.x;
        r5.x = r2.y * 2 + r4.y;
        r4.y = r3.w ? r4.y : r5.x;
        r5.x = r2.z * 2 + r4.w;
        r4.w = r3.w ? r4.w : r5.x;
        if (r2.w != 0) {
          if (r3.z == 0) {
            r5.xy = saturate(r4.xz);
            r5.xy = cb0[26].xx * r5.xy;
            r3.x = t1.SampleLevel(s1_s, r5.xy, 0).y;
          }
          if (r3.w == 0) {
            r5.xy = saturate(r4.yw);
            r5.xy = cb0[26].xx * r5.xy;
            r3.y = t1.SampleLevel(s1_s, r5.xy, 0).y;
          }
          r2.w = -r0.z * 0.5 + r3.x;
          r3.x = r3.z ? r3.x : r2.w;
          r2.w = -r0.z * 0.5 + r3.y;
          r3.y = r3.w ? r3.y : r2.w;
          r3.zw = cmp(abs(r3.xy) >= r1.ww);
          r2.w = -r2.y * 2 + r4.x;
          r4.x = r3.z ? r4.x : r2.w;
          r2.w = -r2.z * 2 + r4.z;
          r4.z = r3.z ? r4.z : r2.w;
          r5.xy = ~(int2)r3.zw;
          r2.w = (int)r5.y | (int)r5.x;
          r5.x = r2.y * 2 + r4.y;
          r4.y = r3.w ? r4.y : r5.x;
          r5.x = r2.z * 2 + r4.w;
          r4.w = r3.w ? r4.w : r5.x;
          if (r2.w != 0) {
            if (r3.z == 0) {
              r5.xy = saturate(r4.xz);
              r5.xy = cb0[26].xx * r5.xy;
              r3.x = t1.SampleLevel(s1_s, r5.xy, 0).y;
            }
            if (r3.w == 0) {
              r5.xy = saturate(r4.yw);
              r5.xy = cb0[26].xx * r5.xy;
              r3.y = t1.SampleLevel(s1_s, r5.xy, 0).y;
            }
            r2.w = -r0.z * 0.5 + r3.x;
            r3.x = r3.z ? r3.x : r2.w;
            r2.w = -r0.z * 0.5 + r3.y;
            r3.y = r3.w ? r3.y : r2.w;
            r3.zw = cmp(abs(r3.xy) >= r1.ww);
            r2.w = -r2.y * 2 + r4.x;
            r4.x = r3.z ? r4.x : r2.w;
            r2.w = -r2.z * 2 + r4.z;
            r4.z = r3.z ? r4.z : r2.w;
            r5.xy = ~(int2)r3.zw;
            r2.w = (int)r5.y | (int)r5.x;
            r5.x = r2.y * 2 + r4.y;
            r4.y = r3.w ? r4.y : r5.x;
            r5.x = r2.z * 2 + r4.w;
            r4.w = r3.w ? r4.w : r5.x;
            if (r2.w != 0) {
              if (r3.z == 0) {
                r5.xy = saturate(r4.xz);
                r5.xy = cb0[26].xx * r5.xy;
                r3.x = t1.SampleLevel(s1_s, r5.xy, 0).y;
              }
              if (r3.w == 0) {
                r5.xy = saturate(r4.yw);
                r5.xy = cb0[26].xx * r5.xy;
                r3.y = t1.SampleLevel(s1_s, r5.xy, 0).y;
              }
              r2.w = -r0.z * 0.5 + r3.x;
              r3.x = r3.z ? r3.x : r2.w;
              r2.w = -r0.z * 0.5 + r3.y;
              r3.y = r3.w ? r3.y : r2.w;
              r3.zw = cmp(abs(r3.xy) >= r1.ww);
              r2.w = -r2.y * 2 + r4.x;
              r4.x = r3.z ? r4.x : r2.w;
              r2.w = -r2.z * 2 + r4.z;
              r4.z = r3.z ? r4.z : r2.w;
              r5.xy = ~(int2)r3.zw;
              r2.w = (int)r5.y | (int)r5.x;
              r5.x = r2.y * 2 + r4.y;
              r4.y = r3.w ? r4.y : r5.x;
              r5.x = r2.z * 2 + r4.w;
              r4.w = r3.w ? r4.w : r5.x;
              if (r2.w != 0) {
                if (r3.z == 0) {
                  r5.xy = saturate(r4.xz);
                  r5.xy = cb0[26].xx * r5.xy;
                  r3.x = t1.SampleLevel(s1_s, r5.xy, 0).y;
                }
                if (r3.w == 0) {
                  r5.xy = saturate(r4.yw);
                  r5.xy = cb0[26].xx * r5.xy;
                  r3.y = t1.SampleLevel(s1_s, r5.xy, 0).y;
                }
                r2.w = -r0.z * 0.5 + r3.x;
                r3.x = r3.z ? r3.x : r2.w;
                r2.w = -r0.z * 0.5 + r3.y;
                r3.y = r3.w ? r3.y : r2.w;
                r3.zw = cmp(abs(r3.xy) >= r1.ww);
                r2.w = -r2.y * 2 + r4.x;
                r4.x = r3.z ? r4.x : r2.w;
                r2.w = -r2.z * 2 + r4.z;
                r4.z = r3.z ? r4.z : r2.w;
                r5.xy = ~(int2)r3.zw;
                r2.w = (int)r5.y | (int)r5.x;
                r5.x = r2.y * 2 + r4.y;
                r4.y = r3.w ? r4.y : r5.x;
                r5.x = r2.z * 2 + r4.w;
                r4.w = r3.w ? r4.w : r5.x;
                if (r2.w != 0) {
                  if (r3.z == 0) {
                    r5.xy = saturate(r4.xz);
                    r5.xy = cb0[26].xx * r5.xy;
                    r3.x = t1.SampleLevel(s1_s, r5.xy, 0).y;
                  }
                  if (r3.w == 0) {
                    r5.xy = saturate(r4.yw);
                    r5.xy = cb0[26].xx * r5.xy;
                    r3.y = t1.SampleLevel(s1_s, r5.xy, 0).y;
                  }
                  r2.w = -r0.z * 0.5 + r3.x;
                  r3.x = r3.z ? r3.x : r2.w;
                  r2.w = -r0.z * 0.5 + r3.y;
                  r3.y = r3.w ? r3.y : r2.w;
                  r3.zw = cmp(abs(r3.xy) >= r1.ww);
                  r2.w = -r2.y * 2 + r4.x;
                  r4.x = r3.z ? r4.x : r2.w;
                  r2.w = -r2.z * 2 + r4.z;
                  r4.z = r3.z ? r4.z : r2.w;
                  r5.xy = ~(int2)r3.zw;
                  r2.w = (int)r5.y | (int)r5.x;
                  r5.x = r2.y * 2 + r4.y;
                  r4.y = r3.w ? r4.y : r5.x;
                  r5.x = r2.z * 2 + r4.w;
                  r4.w = r3.w ? r4.w : r5.x;
                  if (r2.w != 0) {
                    if (r3.z == 0) {
                      r5.xy = saturate(r4.xz);
                      r5.xy = cb0[26].xx * r5.xy;
                      r3.x = t1.SampleLevel(s1_s, r5.xy, 0).y;
                    }
                    if (r3.w == 0) {
                      r5.xy = saturate(r4.yw);
                      r5.xy = cb0[26].xx * r5.xy;
                      r3.y = t1.SampleLevel(s1_s, r5.xy, 0).y;
                    }
                    r2.w = -r0.z * 0.5 + r3.x;
                    r3.x = r3.z ? r3.x : r2.w;
                    r2.w = -r0.z * 0.5 + r3.y;
                    r3.y = r3.w ? r3.y : r2.w;
                    r3.zw = cmp(abs(r3.xy) >= r1.ww);
                    r2.w = -r2.y * 4 + r4.x;
                    r4.x = r3.z ? r4.x : r2.w;
                    r2.w = -r2.z * 4 + r4.z;
                    r4.z = r3.z ? r4.z : r2.w;
                    r5.xy = ~(int2)r3.zw;
                    r2.w = (int)r5.y | (int)r5.x;
                    r5.x = r2.y * 4 + r4.y;
                    r4.y = r3.w ? r4.y : r5.x;
                    r5.x = r2.z * 4 + r4.w;
                    r4.w = r3.w ? r4.w : r5.x;
                    if (r2.w != 0) {
                      if (r3.z == 0) {
                        r5.xy = saturate(r4.xz);
                        r5.xy = cb0[26].xx * r5.xy;
                        r3.x = t1.SampleLevel(s1_s, r5.xy, 0).y;
                      }
                      if (r3.w == 0) {
                        r5.xy = saturate(r4.yw);
                        r5.xy = cb0[26].xx * r5.xy;
                        r3.y = t1.SampleLevel(s1_s, r5.xy, 0).y;
                      }
                      r2.w = -r0.z * 0.5 + r3.x;
                      r3.x = r3.z ? r3.x : r2.w;
                      r0.z = -r0.z * 0.5 + r3.y;
                      r3.y = r3.w ? r3.y : r0.z;
                      r3.zw = cmp(abs(r3.xy) >= r1.ww);
                      r0.z = -r2.y * 8 + r4.x;
                      r4.x = r3.z ? r4.x : r0.z;
                      r0.z = -r2.z * 8 + r4.z;
                      r4.z = r3.z ? r4.z : r0.z;
                      r0.z = r2.y * 8 + r4.y;
                      r4.y = r3.w ? r4.y : r0.z;
                      r0.z = r2.z * 8 + r4.w;
                      r4.w = r3.w ? r4.w : r0.z;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    r0.z = v1.x + -r4.x;
    r1.w = -v1.x + r4.y;
    r2.y = v1.y + -r4.z;
    r0.z = r0.x ? r0.z : r2.y;
    r2.y = -v1.y + r4.w;
    r1.w = r0.x ? r1.w : r2.y;
    r2.yz = cmp(r3.xy < float2(0,0));
    r2.w = r1.w + r0.z;
    r2.xy = cmp((int2)r2.xx != (int2)r2.yz);
    r2.z = 1 / r2.w;
    r2.w = cmp(r0.z < r1.w);
    r0.z = min(r1.w, r0.z);
    r1.w = r2.w ? r2.x : r2.y;
    r0.y = r0.y * r0.y;
    r0.z = r0.z * -r2.z + 0.5;
    r0.z = (int)r0.z & (int)r1.w;
    r0.y = max(r0.z, r0.y);
    r0.yz = r0.yy * r0.ww + v1.xy;
    r2.x = saturate(r0.x ? v1.x : r0.y);
    r2.y = saturate(r0.x ? r0.z : v1.y);
    r0.xy = cb0[26].xx * r2.xy;
    r1.xyz = t1.SampleLevel(s1_s, r0.xy, 0).xyz;
  }
  r0.x = t1.Sample(s1_s, w1.xy).w;
  r0.yz = v1.xy * cb0[28].xy + cb0[28].zw;
  r0.y = t0.Sample(s0_s, r0.yz).w;
  r0.y = r0.y * 2 + -1;
  r0.z = saturate(r0.y * 3.40282347e+038 + 0.5);
  r0.z = r0.z * 2 + -1;
  r0.y = 1 + -abs(r0.y);
  r0.y = sqrt(r0.y);
  r0.y = 1 + -r0.y;
  r0.y = r0.z * r0.y;
  r2.xyz = float3(12.9200001,12.9200001,12.9200001) * r1.xyz;
  r3.xyz = max(float3(1.1920929e-007,1.1920929e-007,1.1920929e-007), abs(r1.xyz));
  r3.xyz = log2(r3.xyz);
  r3.xyz = float3(0.416666657,0.416666657,0.416666657) * r3.xyz;
  r3.xyz = exp2(r3.xyz);
  r3.xyz = r3.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  r1.xyz = cmp(float3(0.00313080009,0.00313080009,0.00313080009) >= r1.xyz);
  r1.xyz = r1.xyz ? r2.xyz : r3.xyz;
  r0.yzw = r0.yyy * float3(0.00392156886,0.00392156886,0.00392156886) + r1.xyz;
  r1.xyz = float3(0.0773993805,0.0773993805,0.0773993805) * r0.yzw;
  r2.xyz = float3(0.0549999997,0.0549999997,0.0549999997) + r0.yzw;
  r2.xyz = float3(0.947867334,0.947867334,0.947867334) * r2.xyz;
  r2.xyz = max(float3(1.1920929e-007,1.1920929e-007,1.1920929e-007), abs(r2.xyz));
  r2.xyz = log2(r2.xyz);
  r2.xyz = float3(2.4000001,2.4000001,2.4000001) * r2.xyz;
  r2.xyz = exp2(r2.xyz);
  r0.yzw = cmp(float3(0.0404499993,0.0404499993,0.0404499993) >= r0.yzw);
  o0.xyz = r0.yzw ? r1.xyz : r2.xyz;
  o0.w = r0.x;

  o0.rgb = renodx::draw::RenderIntermediatePass(o0.rgb);
  return;
}