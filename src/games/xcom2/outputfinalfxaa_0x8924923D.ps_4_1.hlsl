#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Thu Oct  2 17:43:01 2025

cbuffer _Globals : register(b0)
{
  float2 fxaaQualityRcpFrame : packoffset(c0);
  float4 fxaaConstDir : packoffset(c1) = {1,-1,0.25,-0.25};
  float4 fxaaConsoleRcpFrameOpt : packoffset(c2);
  float4 fxaaConsoleRcpFrameOpt2 : packoffset(c3);
  float4 fxaaConsole360RcpFrameOpt2 : packoffset(c4);
  float fxaaQualitySubpix : packoffset(c5);
  float fxaaQualityEdgeThreshold : packoffset(c5.y);
  float fxaaQualityEdgeThresholdMin : packoffset(c5.z);
  float fxaaConsoleEdgeSharpness : packoffset(c5.w);
  float fxaaConsoleEdgeThreshold : packoffset(c6);
  float fxaaConsoleEdgeThresholdMin : packoffset(c6.y);
  float4 fxaaConsole360ConstDir : packoffset(c7);
}

SamplerState SceneColorTexture_s : register(s0);
Texture2D<float4> SceneColorTexture : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : TEXCOORD0,
  float4 v1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;
  r0.xyzw = SceneColorTexture.SampleLevel(SceneColorTexture_s, v0.xy, 0).xyzw;
  r1.xyzw = fxaaQualityRcpFrame.xyxy * float4(0,1,1,0) + v0.xyxy;
  r1.x = SceneColorTexture.SampleLevel(SceneColorTexture_s, r1.xy, 0).w;
  r1.y = SceneColorTexture.SampleLevel(SceneColorTexture_s, r1.zw, 0).w;
  r2.xyzw = fxaaQualityRcpFrame.xyxy * float4(0,-1,-1,0) + v0.xyxy;
  r1.z = SceneColorTexture.SampleLevel(SceneColorTexture_s, r2.xy, 0).w;
  r1.w = SceneColorTexture.SampleLevel(SceneColorTexture_s, r2.zw, 0).w;
  r2.x = max(r1.x, r0.w);
  r2.y = min(r1.x, r0.w);
  r2.x = max(r2.x, r1.y);
  r2.y = min(r2.y, r1.y);
  r2.z = max(r1.z, r1.w);
  r2.w = min(r1.z, r1.w);
  r2.x = max(r2.z, r2.x);
  r2.y = min(r2.w, r2.y);
  r2.z = fxaaQualityEdgeThreshold * r2.x;
  r2.x = r2.x + -r2.y;
  r2.y = max(fxaaQualityEdgeThresholdMin, r2.z);
  r2.y = cmp(r2.x >= r2.y);
  if (r2.y != 0) {
    r2.yz = -fxaaQualityRcpFrame.xy + v0.xy;
    r2.y = SceneColorTexture.SampleLevel(SceneColorTexture_s, r2.yz, 0).w;
    r2.zw = fxaaQualityRcpFrame.xy + v0.xy;
    r2.z = SceneColorTexture.SampleLevel(SceneColorTexture_s, r2.zw, 0).w;
    r3.xyzw = fxaaQualityRcpFrame.xyxy * float4(1,-1,-1,1) + v0.xyxy;
    r2.w = SceneColorTexture.SampleLevel(SceneColorTexture_s, r3.xy, 0).w;
    r3.x = SceneColorTexture.SampleLevel(SceneColorTexture_s, r3.zw, 0).w;
    r3.yz = r1.zw + r1.xy;
    r2.x = 1 / r2.x;
    r3.w = r3.y + r3.z;
    r3.y = r0.w * -2 + r3.y;
    r3.z = r0.w * -2 + r3.z;
    r4.x = r2.w + r2.z;
    r2.w = r2.y + r2.w;
    r4.y = r1.y * -2 + r4.x;
    r2.w = r1.z * -2 + r2.w;
    r2.y = r3.x + r2.y;
    r2.z = r3.x + r2.z;
    r3.x = abs(r3.y) * 2 + abs(r4.y);
    r2.w = abs(r3.z) * 2 + abs(r2.w);
    r3.y = r1.w * -2 + r2.y;
    r2.z = r1.x * -2 + r2.z;
    r3.x = abs(r3.y) + r3.x;
    r2.z = abs(r2.z) + r2.w;
    r2.y = r2.y + r4.x;
    r2.z = cmp(r3.x >= r2.z);
    r2.y = r3.w * 2 + r2.y;
    r1.xz = r2.zz ? r1.xz : r1.yw;
    r1.y = r2.z ? fxaaQualityRcpFrame.y : fxaaQualityRcpFrame.x;
    r1.w = r2.y * 0.0833333358 + -r0.w;
    r2.yw = r1.zx + -r0.ww;
    r1.xz = r1.xz + r0.ww;
    r3.x = cmp(abs(r2.y) >= abs(r2.w));
    r2.y = max(abs(r2.y), abs(r2.w));
    r1.y = r3.x ? -r1.y : r1.y;
    r1.w = saturate(abs(r1.w) * r2.x);
    r2.x = r2.z ? fxaaQualityRcpFrame.x : 0;
    r2.w = r2.z ? 0 : fxaaQualityRcpFrame.y;
    r3.yz = r1.yy * float2(0.5,0.5) + v0.xy;
    r3.y = r2.z ? v0.x : r3.y;
    r3.z = r2.z ? r3.z : v0.y;
    r4.xy = r3.yz + -r2.xw;
    r5.xy = r3.yz + r2.xw;
    r3.y = r1.w * -2 + 3;
    r3.z = SceneColorTexture.SampleLevel(SceneColorTexture_s, r4.xy, 0).w;
    r1.w = r1.w * r1.w;
    r3.w = SceneColorTexture.SampleLevel(SceneColorTexture_s, r5.xy, 0).w;
    r1.x = r3.x ? r1.z : r1.x;
    r1.z = 0.25 * r2.y;
    r2.y = -r1.x * 0.5 + r0.w;
    r1.w = r3.y * r1.w;
    r2.y = cmp(r2.y < 0);
    r3.x = -r1.x * 0.5 + r3.z;
    r3.y = -r1.x * 0.5 + r3.w;
    r3.zw = cmp(abs(r3.xy) >= r1.zz);
    r4.zw = r4.xy + -r2.xw;
    r4.x = r3.z ? r4.x : r4.z;
    r4.z = r3.z ? r4.y : r4.w;
    r4.yw = ~(int2)r3.zw;
    r4.y = (int)r4.w | (int)r4.y;
    r4.w = r5.x + r2.x;
    r5.x = r3.w ? r5.x : r4.w;
    r4.w = r5.y + r2.w;
    r5.z = r3.w ? r5.y : r4.w;
    if (r4.y != 0) {
      if (r3.z == 0) {
        r3.x = SceneColorTexture.SampleLevel(SceneColorTexture_s, r4.xz, 0).w;
      }
      if (r3.w == 0) {
        r3.y = SceneColorTexture.SampleLevel(SceneColorTexture_s, r5.xz, 0).w;
      }
      r4.y = -r1.x * 0.5 + r3.x;
      r3.x = r3.z ? r3.x : r4.y;
      r3.z = -r1.x * 0.5 + r3.y;
      r3.y = r3.w ? r3.y : r3.z;
      r3.zw = cmp(abs(r3.xy) >= r1.zz);
      r4.y = r4.x + -r2.x;
      r4.x = r3.z ? r4.x : r4.y;
      r4.y = r4.z + -r2.w;
      r4.z = r3.z ? r4.z : r4.y;
      r4.yw = ~(int2)r3.zw;
      r4.y = (int)r4.w | (int)r4.y;
      r4.w = r5.x + r2.x;
      r5.x = r3.w ? r5.x : r4.w;
      r4.w = r5.z + r2.w;
      r5.z = r3.w ? r5.z : r4.w;
      if (r4.y != 0) {
        if (r3.z == 0) {
          r3.x = SceneColorTexture.SampleLevel(SceneColorTexture_s, r4.xz, 0).w;
        }
        if (r3.w == 0) {
          r3.y = SceneColorTexture.SampleLevel(SceneColorTexture_s, r5.xz, 0).w;
        }
        r4.y = -r1.x * 0.5 + r3.x;
        r3.x = r3.z ? r3.x : r4.y;
        r3.z = -r1.x * 0.5 + r3.y;
        r3.y = r3.w ? r3.y : r3.z;
        r3.zw = cmp(abs(r3.xy) >= r1.zz);
        r4.y = r4.x + -r2.x;
        r4.x = r3.z ? r4.x : r4.y;
        r4.y = r4.z + -r2.w;
        r4.z = r3.z ? r4.z : r4.y;
        r4.yw = ~(int2)r3.zw;
        r4.y = (int)r4.w | (int)r4.y;
        r4.w = r5.x + r2.x;
        r5.x = r3.w ? r5.x : r4.w;
        r4.w = r5.z + r2.w;
        r5.z = r3.w ? r5.z : r4.w;
        if (r4.y != 0) {
          if (r3.z == 0) {
            r3.x = SceneColorTexture.SampleLevel(SceneColorTexture_s, r4.xz, 0).w;
          }
          if (r3.w == 0) {
            r3.y = SceneColorTexture.SampleLevel(SceneColorTexture_s, r5.xz, 0).w;
          }
          r4.y = -r1.x * 0.5 + r3.x;
          r3.x = r3.z ? r3.x : r4.y;
          r3.z = -r1.x * 0.5 + r3.y;
          r3.y = r3.w ? r3.y : r3.z;
          r3.zw = cmp(abs(r3.xy) >= r1.zz);
          r4.y = r4.x + -r2.x;
          r4.x = r3.z ? r4.x : r4.y;
          r4.y = r4.z + -r2.w;
          r4.z = r3.z ? r4.z : r4.y;
          r4.yw = ~(int2)r3.zw;
          r4.y = (int)r4.w | (int)r4.y;
          r4.w = r5.x + r2.x;
          r5.x = r3.w ? r5.x : r4.w;
          r4.w = r5.z + r2.w;
          r5.z = r3.w ? r5.z : r4.w;
          if (r4.y != 0) {
            if (r3.z == 0) {
              r3.x = SceneColorTexture.SampleLevel(SceneColorTexture_s, r4.xz, 0).w;
            }
            if (r3.w == 0) {
              r3.y = SceneColorTexture.SampleLevel(SceneColorTexture_s, r5.xz, 0).w;
            }
            r4.y = -r1.x * 0.5 + r3.x;
            r3.x = r3.z ? r3.x : r4.y;
            r3.z = -r1.x * 0.5 + r3.y;
            r3.y = r3.w ? r3.y : r3.z;
            r3.zw = cmp(abs(r3.xy) >= r1.zz);
            r4.y = -r2.x * 1.5 + r4.x;
            r4.x = r3.z ? r4.x : r4.y;
            r4.y = -r2.w * 1.5 + r4.z;
            r4.z = r3.z ? r4.z : r4.y;
            r4.yw = ~(int2)r3.zw;
            r4.y = (int)r4.w | (int)r4.y;
            r4.w = r2.x * 1.5 + r5.x;
            r5.x = r3.w ? r5.x : r4.w;
            r4.w = r2.w * 1.5 + r5.z;
            r5.z = r3.w ? r5.z : r4.w;
            if (r4.y != 0) {
              if (r3.z == 0) {
                r3.x = SceneColorTexture.SampleLevel(SceneColorTexture_s, r4.xz, 0).w;
              }
              if (r3.w == 0) {
                r3.y = SceneColorTexture.SampleLevel(SceneColorTexture_s, r5.xz, 0).w;
              }
              r4.y = -r1.x * 0.5 + r3.x;
              r3.x = r3.z ? r3.x : r4.y;
              r3.z = -r1.x * 0.5 + r3.y;
              r3.y = r3.w ? r3.y : r3.z;
              r3.zw = cmp(abs(r3.xy) >= r1.zz);
              r4.y = -r2.x * 2 + r4.x;
              r4.x = r3.z ? r4.x : r4.y;
              r4.y = -r2.w * 2 + r4.z;
              r4.z = r3.z ? r4.z : r4.y;
              r4.yw = ~(int2)r3.zw;
              r4.y = (int)r4.w | (int)r4.y;
              r4.w = r2.x * 2 + r5.x;
              r5.x = r3.w ? r5.x : r4.w;
              r4.w = r2.w * 2 + r5.z;
              r5.z = r3.w ? r5.z : r4.w;
              if (r4.y != 0) {
                if (r3.z == 0) {
                  r3.x = SceneColorTexture.SampleLevel(SceneColorTexture_s, r4.xz, 0).w;
                }
                if (r3.w == 0) {
                  r3.y = SceneColorTexture.SampleLevel(SceneColorTexture_s, r5.xz, 0).w;
                }
                r4.y = -r1.x * 0.5 + r3.x;
                r3.x = r3.z ? r3.x : r4.y;
                r3.z = -r1.x * 0.5 + r3.y;
                r3.y = r3.w ? r3.y : r3.z;
                r3.zw = cmp(abs(r3.xy) >= r1.zz);
                r4.y = -r2.x * 2 + r4.x;
                r4.x = r3.z ? r4.x : r4.y;
                r4.y = -r2.w * 2 + r4.z;
                r4.z = r3.z ? r4.z : r4.y;
                r4.yw = ~(int2)r3.zw;
                r4.y = (int)r4.w | (int)r4.y;
                r4.w = r2.x * 2 + r5.x;
                r5.x = r3.w ? r5.x : r4.w;
                r4.w = r2.w * 2 + r5.z;
                r5.z = r3.w ? r5.z : r4.w;
                if (r4.y != 0) {
                  if (r3.z == 0) {
                    r3.x = SceneColorTexture.SampleLevel(SceneColorTexture_s, r4.xz, 0).w;
                  }
                  if (r3.w == 0) {
                    r3.y = SceneColorTexture.SampleLevel(SceneColorTexture_s, r5.xz, 0).w;
                  }
                  r4.y = -r1.x * 0.5 + r3.x;
                  r3.x = r3.z ? r3.x : r4.y;
                  r3.z = -r1.x * 0.5 + r3.y;
                  r3.y = r3.w ? r3.y : r3.z;
                  r3.zw = cmp(abs(r3.xy) >= r1.zz);
                  r4.y = -r2.x * 2 + r4.x;
                  r4.x = r3.z ? r4.x : r4.y;
                  r4.y = -r2.w * 2 + r4.z;
                  r4.z = r3.z ? r4.z : r4.y;
                  r4.yw = ~(int2)r3.zw;
                  r4.y = (int)r4.w | (int)r4.y;
                  r4.w = r2.x * 2 + r5.x;
                  r5.x = r3.w ? r5.x : r4.w;
                  r4.w = r2.w * 2 + r5.z;
                  r5.z = r3.w ? r5.z : r4.w;
                  if (r4.y != 0) {
                    if (r3.z == 0) {
                      r3.x = SceneColorTexture.SampleLevel(SceneColorTexture_s, r4.xz, 0).w;
                    }
                    if (r3.w == 0) {
                      r3.y = SceneColorTexture.SampleLevel(SceneColorTexture_s, r5.xz, 0).w;
                    }
                    r4.y = -r1.x * 0.5 + r3.x;
                    r3.x = r3.z ? r3.x : r4.y;
                    r3.z = -r1.x * 0.5 + r3.y;
                    r3.y = r3.w ? r3.y : r3.z;
                    r3.zw = cmp(abs(r3.xy) >= r1.zz);
                    r4.y = -r2.x * 2 + r4.x;
                    r4.x = r3.z ? r4.x : r4.y;
                    r4.y = -r2.w * 2 + r4.z;
                    r4.z = r3.z ? r4.z : r4.y;
                    r4.yw = ~(int2)r3.zw;
                    r4.y = (int)r4.w | (int)r4.y;
                    r4.w = r2.x * 2 + r5.x;
                    r5.x = r3.w ? r5.x : r4.w;
                    r4.w = r2.w * 2 + r5.z;
                    r5.z = r3.w ? r5.z : r4.w;
                    if (r4.y != 0) {
                      if (r3.z == 0) {
                        r3.x = SceneColorTexture.SampleLevel(SceneColorTexture_s, r4.xz, 0).w;
                      }
                      if (r3.w == 0) {
                        r3.y = SceneColorTexture.SampleLevel(SceneColorTexture_s, r5.xz, 0).w;
                      }
                      r4.y = -r1.x * 0.5 + r3.x;
                      r3.x = r3.z ? r3.x : r4.y;
                      r3.z = -r1.x * 0.5 + r3.y;
                      r3.y = r3.w ? r3.y : r3.z;
                      r3.zw = cmp(abs(r3.xy) >= r1.zz);
                      r4.y = -r2.x * 4 + r4.x;
                      r4.x = r3.z ? r4.x : r4.y;
                      r4.y = -r2.w * 4 + r4.z;
                      r4.z = r3.z ? r4.z : r4.y;
                      r4.yw = ~(int2)r3.zw;
                      r4.y = (int)r4.w | (int)r4.y;
                      r4.w = r2.x * 4 + r5.x;
                      r5.x = r3.w ? r5.x : r4.w;
                      r4.w = r2.w * 4 + r5.z;
                      r5.z = r3.w ? r5.z : r4.w;
                      if (r4.y != 0) {
                        if (r3.z == 0) {
                          r3.x = SceneColorTexture.SampleLevel(SceneColorTexture_s, r4.xz, 0).w;
                        }
                        if (r3.w == 0) {
                          r3.y = SceneColorTexture.SampleLevel(SceneColorTexture_s, r5.xz, 0).w;
                        }
                        r4.y = -r1.x * 0.5 + r3.x;
                        r3.x = r3.z ? r3.x : r4.y;
                        r1.x = -r1.x * 0.5 + r3.y;
                        r3.y = r3.w ? r3.y : r1.x;
                        r1.xz = cmp(abs(r3.xy) >= r1.zz);
                        r3.z = -r2.x * 8 + r4.x;
                        r4.x = r1.x ? r4.x : r3.z;
                        r3.z = -r2.w * 8 + r4.z;
                        r4.z = r1.x ? r4.z : r3.z;
                        r1.x = r2.x * 8 + r5.x;
                        r5.x = r1.z ? r5.x : r1.x;
                        r1.x = r2.w * 8 + r5.z;
                        r5.z = r1.z ? r5.z : r1.x;
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
    r1.x = v0.x + -r4.x;
    r1.z = -v0.x + r5.x;
    r2.x = v0.y + -r4.z;
    r1.x = r2.z ? r1.x : r2.x;
    r2.x = -v0.y + r5.z;
    r1.z = r2.z ? r1.z : r2.x;
    r2.xw = cmp(r3.xy < float2(0,0));
    r3.x = r1.z + r1.x;
    r2.xy = cmp((int2)r2.xw != (int2)r2.yy);
    r2.w = 1 / r3.x;
    r3.x = cmp(r1.x < r1.z);
    r1.x = min(r1.x, r1.z);
    r1.z = r3.x ? r2.x : r2.y;
    r1.w = r1.w * r1.w;
    r1.x = r1.x * -r2.w + 0.5;
    r1.w = fxaaQualitySubpix * r1.w;
    r1.x = (int)r1.x & (int)r1.z;
    r1.x = max(r1.x, r1.w);
    r1.xy = r1.xx * r1.yy + v0.xy;
    r2.x = r2.z ? v0.x : r1.x;
    r2.y = r2.z ? r1.y : v0.y;
    r0.xyz = SceneColorTexture.SampleLevel(SceneColorTexture_s, r2.xy, 0).xyz;
  }
  o0.xyzw = r0.xyzw;
  return;
}