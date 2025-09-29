#include "./common.hlsl"

cbuffer _Globals : register(b0){
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
SamplerState SceneColorTextureSampler_s : register(s0);
Texture2D<float4> SceneColorTexture : register(t0);

void main(
  float4 v0 : TEXCOORD0,
  float4 v1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = SceneColorTexture.SampleLevel(SceneColorTextureSampler_s, v0.xy, 0).xyzw;
  r1.xyz = SceneColorTexture.Gather(SceneColorTextureSampler_s, v0.xy).xyz;
  r2.xyz = SceneColorTexture.Gather(SceneColorTextureSampler_s, v0.xy, int2(-1, -1)).xzw;
  r1.w = max(r1.x, r0.w);
  r2.w = min(r1.x, r0.w);
  r1.w = max(r1.z, r1.w);
  r2.w = min(r2.w, r1.z);
  r3.x = max(r2.y, r2.x);
  r3.y = min(r2.y, r2.x);
  r1.w = max(r3.x, r1.w);
  r2.w = min(r3.y, r2.w);
  r3.x = fxaaQualityEdgeThreshold * r1.w;
  r1.w = -r2.w + r1.w;
  r2.w = max(fxaaQualityEdgeThresholdMin, r3.x);
  bool fxaaOn = r1.w >= r2.w;
  if (fxaaOn) {
    r2.w = SceneColorTexture.SampleLevel(SceneColorTextureSampler_s, v0.xy, 0, int2(1, -1)).w;
    r3.x = SceneColorTexture.SampleLevel(SceneColorTextureSampler_s, v0.xy, 0, int2(-1, 1)).w;
    r3.yz = r2.yx + r1.xz;
    r1.w = 1 / r1.w;
    r3.w = r3.y + r3.z;
    r3.yz = r0.ww * float2(-2,-2) + r3.yz;
    r4.x = r2.w + r1.y;
    r2.w = r2.z + r2.w;
    r4.y = r1.z * -2 + r4.x;
    r2.w = r2.y * -2 + r2.w;
    r2.z = r3.x + r2.z;
    r1.y = r3.x + r1.y;
    r3.x = abs(r3.y) * 2 + abs(r4.y);
    r2.w = abs(r3.z) * 2 + abs(r2.w);
    r3.y = r2.x * -2 + r2.z;
    r1.y = r1.x * -2 + r1.y;
    r3.x = abs(r3.y) + r3.x;
    r1.y = abs(r1.y) + r2.w;
    r2.z = r2.z + r4.x;
    bool isHorizontal = r3.x >= r1.y;
    r2.z = r3.w * 2 + r2.z;
    r2.x = isHorizontal ? r2.y : r2.x;
    r1.x = isHorizontal ? r1.x : r1.z;
    r1.z = isHorizontal ? fxaaQualityRcpFrame.y : fxaaQualityRcpFrame.x;
    r2.y = r2.z * 0.0833333358 + -r0.w;
    r2.z = r2.x + -r0.w;
    r2.w = r1.x + -r0.w;
    r2.x = r2.x + r0.w;
    r1.x = r1.x + r0.w;
    bool is1Steepest = abs(r2.z) >= abs(r2.w);
    r2.z = max(abs(r2.z), abs(r2.w));
    r1.z = is1Steepest ? -r1.z : r1.z;
    r1.w = saturate(abs(r2.y) * r1.w);
    r2.y = isHorizontal ? fxaaQualityRcpFrame.x : 0;
    r2.w = isHorizontal ? 0 : fxaaQualityRcpFrame.y;
    r3.yz = r1.zz * float2(0.5,0.5) + v0.xy;
    r3.y = isHorizontal ? v0.x : r3.y;
    r3.z = isHorizontal ? r3.z : v0.y;
    r4.xy = r3.yz + -r2.yw;
    r5.xy = r3.yz + r2.yw;
    r3.y = r1.w * -2 + 3;
    r3.z = SceneColorTexture.SampleLevel(SceneColorTextureSampler_s, r4.xy, 0).w;
    r1.w = r1.w * r1.w;
    r3.w = SceneColorTexture.SampleLevel(SceneColorTextureSampler_s, r5.xy, 0).w;
    r1.x = is1Steepest ? r2.x : r1.x;
    r2.x = 0.25 * r2.z;
    r0.w = -r1.x * 0.5 + r0.w;
    r1.w = r3.y * r1.w;
    bool isLumaCenterSmaller = r0.w < 0;
    r3.x = -r1.x * 0.5 + r3.z;
    r3.y = -r1.x * 0.5 + r3.w;
    bool reached1 = abs(r3.x) >= r2.x;
    bool reached2 = abs(r3.y) >= r2.x;
    r2.z = r4.x + -r2.y;
    r4.x = reached1 ? r4.x : r2.z;
    r2.z = r4.y + -r2.w;
    r4.z = reached1 ? r4.y : r2.z;
    bool notReachedBoth = !reached1 || !reached2;
    r4.y = r5.x + r2.y;
    r4.y = reached2 ? r5.x : r4.y;
    r5.x = r5.y + r2.w;
    r4.w = reached2 ? r5.y : r5.x;
    if (notReachedBoth) {
      if (!reached1) {
        r3.x = SceneColorTexture.SampleLevel(SceneColorTextureSampler_s, r4.xz, 0).w;
      }
      if (!reached2) {
        r3.y = SceneColorTexture.SampleLevel(SceneColorTextureSampler_s, r4.yw, 0).w;
      }
      r2.z = -r1.x * 0.5 + r3.x;
      r3.x = reached1 ? r3.x : r2.z;
      r2.z = -r1.x * 0.5 + r3.y;
      r3.y = reached2 ? r3.y : r2.z;
      reached1 = abs(r3.x) >= r2.x;
      reached2 = abs(r3.y) >= r2.x;
      r2.z = r4.x + -r2.y;
      r4.x = reached1 ? r4.x : r2.z;
      r2.z = r4.z + -r2.w;
      r4.z = reached1 ? r4.z : r2.z;
      notReachedBoth = !reached1 || !reached2;
      r5.x = r4.y + r2.y;
      r4.y = reached2 ? r4.y : r5.x;
      r5.x = r4.w + r2.w;
      r4.w = reached2 ? r4.w : r5.x;
      if (notReachedBoth) {
        if (!reached1) {
          r3.x = SceneColorTexture.SampleLevel(SceneColorTextureSampler_s, r4.xz, 0).w;
        }
        if (!reached2) {
          r3.y = SceneColorTexture.SampleLevel(SceneColorTextureSampler_s, r4.yw, 0).w;
        }
        r2.z = -r1.x * 0.5 + r3.x;
        r3.x = reached1 ? r3.x : r2.z;
        r2.z = -r1.x * 0.5 + r3.y;
        r3.y = reached2 ? r3.y : r2.z;
        reached1 = abs(r3.x) >= r2.x;
        reached2 = abs(r3.y) >= r2.x;
        r2.z = r4.x + -r2.y;
        r4.x = reached1 ? r4.x : r2.z;
        r2.z = r4.z + -r2.w;
        r4.z = reached1 ? r4.z : r2.z;
        notReachedBoth = !reached1 || !reached2;
        r5.x = r4.y + r2.y;
        r4.y = reached2 ? r4.y : r5.x;
        r5.x = r4.w + r2.w;
        r4.w = reached2 ? r4.w : r5.x;
        if (notReachedBoth) {
          if (!reached1) {
            r3.x = SceneColorTexture.SampleLevel(SceneColorTextureSampler_s, r4.xz, 0).w;
          }
          if (!reached2) {
            r3.y = SceneColorTexture.SampleLevel(SceneColorTextureSampler_s, r4.yw, 0).w;
          }
          r2.z = -r1.x * 0.5 + r3.x;
          r3.x = reached1 ? r3.x : r2.z;
          r2.z = -r1.x * 0.5 + r3.y;
          r3.y = reached2 ? r3.y : r2.z;
          reached1 = abs(r3.x) >= r2.x;
          reached2 = abs(r3.y) >= r2.x;
          r2.z = r4.x + -r2.y;
          r4.x = reached1 ? r4.x : r2.z;
          r2.z = r4.z + -r2.w;
          r4.z = reached1 ? r4.z : r2.z;
          notReachedBoth = !reached1 || !reached2;
          r5.x = r4.y + r2.y;
          r4.y = reached2 ? r4.y : r5.x;
          r5.x = r4.w + r2.w;
          r4.w = reached2 ? r4.w : r5.x;
          if (notReachedBoth) {
            if (!reached1) {
              r3.x = SceneColorTexture.SampleLevel(SceneColorTextureSampler_s, r4.xz, 0).w;
            }
            if (!reached2) {
              r3.y = SceneColorTexture.SampleLevel(SceneColorTextureSampler_s, r4.yw, 0).w;
            }
            r2.z = -r1.x * 0.5 + r3.x;
            r3.x = reached1 ? r3.x : r2.z;
            r2.z = -r1.x * 0.5 + r3.y;
            r3.y = reached2 ? r3.y : r2.z;
            reached1 = abs(r3.x) >= r2.x;
            reached2 = abs(r3.y) >= r2.x;
            r2.z = -r2.y * 1.5 + r4.x;
            r4.x = reached1 ? r4.x : r2.z;
            r2.z = -r2.w * 1.5 + r4.z;
            r4.z = reached1 ? r4.z : r2.z;
            notReachedBoth = !reached1 || !reached2;
            r5.x = r2.y * 1.5 + r4.y;
            r4.y = reached2 ? r4.y : r5.x;
            r5.x = r2.w * 1.5 + r4.w;
            r4.w = reached2 ? r4.w : r5.x;
            if (notReachedBoth) {
              if (!reached1) {
                r3.x = SceneColorTexture.SampleLevel(SceneColorTextureSampler_s, r4.xz, 0).w;
              }
              if (!reached2) {
                r3.y = SceneColorTexture.SampleLevel(SceneColorTextureSampler_s, r4.yw, 0).w;
              }
              r2.z = -r1.x * 0.5 + r3.x;
              r3.x = reached1 ? r3.x : r2.z;
              r2.z = -r1.x * 0.5 + r3.y;
              r3.y = reached2 ? r3.y : r2.z;
              reached1 = abs(r3.x) >= r2.x;
              reached2 = abs(r3.y) >= r2.x;
              r2.z = -r2.y * 2 + r4.x;
              r4.x = reached1 ? r4.x : r2.z;
              r2.z = -r2.w * 2 + r4.z;
              r4.z = reached1 ? r4.z : r2.z;
              notReachedBoth = !reached1 || !reached2;
              r5.x = r2.y * 2 + r4.y;
              r4.y = reached2 ? r4.y : r5.x;
              r5.x = r2.w * 2 + r4.w;
              r4.w = reached2 ? r4.w : r5.x;
              if (notReachedBoth) {
                if (!reached1) {
                  r3.x = SceneColorTexture.SampleLevel(SceneColorTextureSampler_s, r4.xz, 0).w;
                }
                if (!reached2) {
                  r3.y = SceneColorTexture.SampleLevel(SceneColorTextureSampler_s, r4.yw, 0).w;
                }
                r2.z = -r1.x * 0.5 + r3.x;
                r3.x = reached1 ? r3.x : r2.z;
                r2.z = -r1.x * 0.5 + r3.y;
                r3.y = reached2 ? r3.y : r2.z;
                reached1 = abs(r3.x) >= r2.x;
                reached2 = abs(r3.y) >= r2.x;
                r2.z = -r2.y * 2 + r4.x;
                r4.x = reached1 ? r4.x : r2.z;
                r2.z = -r2.w * 2 + r4.z;
                r4.z = reached1 ? r4.z : r2.z;
                notReachedBoth = !reached1 || !reached2;
                r5.x = r2.y * 2 + r4.y;
                r4.y = reached2 ? r4.y : r5.x;
                r5.x = r2.w * 2 + r4.w;
                r4.w = reached2 ? r4.w : r5.x;
                if (notReachedBoth) {
                  if (!reached1) {
                    r3.x = SceneColorTexture.SampleLevel(SceneColorTextureSampler_s, r4.xz, 0).w;
                  }
                  if (!reached2) {
                    r3.y = SceneColorTexture.SampleLevel(SceneColorTextureSampler_s, r4.yw, 0).w;
                  }
                  r2.z = -r1.x * 0.5 + r3.x;
                  r3.x = reached1 ? r3.x : r2.z;
                  r2.z = -r1.x * 0.5 + r3.y;
                  r3.y = reached2 ? r3.y : r2.z;
                  reached1 = abs(r3.x) >= r2.x;
                  reached2 = abs(r3.y) >= r2.x;
                  r2.z = -r2.y * 2 + r4.x;
                  r4.x = reached1 ? r4.x : r2.z;
                  r2.z = -r2.w * 2 + r4.z;
                  r4.z = reached1 ? r4.z : r2.z;
                  notReachedBoth = !reached1 || !reached2;
                  r5.x = r2.y * 2 + r4.y;
                  r4.y = reached2 ? r4.y : r5.x;
                  r5.x = r2.w * 2 + r4.w;
                  r4.w = reached2 ? r4.w : r5.x;
                  if (notReachedBoth) {
                    if (!reached1) {
                      r3.x = SceneColorTexture.SampleLevel(SceneColorTextureSampler_s, r4.xz, 0).w;
                    }
                    if (!reached2) {
                      r3.y = SceneColorTexture.SampleLevel(SceneColorTextureSampler_s, r4.yw, 0).w;
                    }
                    r2.z = -r1.x * 0.5 + r3.x;
                    r3.x = reached1 ? r3.x : r2.z;
                    r2.z = -r1.x * 0.5 + r3.y;
                    r3.y = reached2 ? r3.y : r2.z;
                    reached1 = abs(r3.x) >= r2.x;
                    reached2 = abs(r3.y) >= r2.x;
                    r2.z = -r2.y * 2 + r4.x;
                    r4.x = reached1 ? r4.x : r2.z;
                    r2.z = -r2.w * 2 + r4.z;
                    r4.z = reached1 ? r4.z : r2.z;
                    notReachedBoth = !reached1 || !reached2;
                    r5.x = r2.y * 2 + r4.y;
                    r4.y = reached2 ? r4.y : r5.x;
                    r5.x = r2.w * 2 + r4.w;
                    r4.w = reached2 ? r4.w : r5.x;
                    if (notReachedBoth) {
                      if (!reached1) {
                        r3.x = SceneColorTexture.SampleLevel(SceneColorTextureSampler_s, r4.xz, 0).w;
                      }
                      if (!reached2) {
                        r3.y = SceneColorTexture.SampleLevel(SceneColorTextureSampler_s, r4.yw, 0).w;
                      }
                      r2.z = -r1.x * 0.5 + r3.x;
                      r3.x = reached1 ? r3.x : r2.z;
                      r2.z = -r1.x * 0.5 + r3.y;
                      r3.y = reached2 ? r3.y : r2.z;
                      reached1 = abs(r3.x) >= r2.x;
                      reached2 = abs(r3.y) >= r2.x;
                      r2.z = -r2.y * 4 + r4.x;
                      r4.x = reached1 ? r4.x : r2.z;
                      r2.z = -r2.w * 4 + r4.z;
                      r4.z = reached1 ? r4.z : r2.z;
                      notReachedBoth = !reached1 || !reached2;
                      r5.x = r2.y * 4 + r4.y;
                      r4.y = reached2 ? r4.y : r5.x;
                      r5.x = r2.w * 4 + r4.w;
                      r4.w = reached2 ? r4.w : r5.x;
                      if (notReachedBoth) {
                        if (!reached1) {
                          r3.x = SceneColorTexture.SampleLevel(SceneColorTextureSampler_s, r4.xz, 0).w;
                        }
                        if (!reached2) {
                          r3.y = SceneColorTexture.SampleLevel(SceneColorTextureSampler_s, r4.yw, 0).w;
                        }
                        r2.z = -r1.x * 0.5 + r3.x;
                        r3.x = reached1 ? r3.x : r2.z;
                        r1.x = -r1.x * 0.5 + r3.y;
                        r3.y = reached2 ? r3.y : r1.x;
                        reached1 = abs(r3.x) >= r2.x;
                        reached2 = abs(r3.y) >= r2.x;
                        r1.x = -r2.y * 8 + r4.x;
                        r4.x = reached1 ? r4.x : r1.x;
                        r1.x = -r2.w * 8 + r4.z;
                        r4.z = reached1 ? r4.z : r1.x;
                        r1.x = r2.y * 8 + r4.y;
                        r4.y = reached2 ? r4.y : r1.x;
                        r1.x = r2.w * 8 + r4.w;
                        r4.w = reached2 ? r4.w : r1.x;
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
    r2.y = v0.y + -r4.z;
    r1.x = isHorizontal ? r1.x : r2.y;
    r2.xy = -v0.xy + r4.yw;
    r2.x = isHorizontal ? r2.x : r2.y;
    bool correctVariation1 = (r3.x < 0.0);
    bool correctVariation2 = (r3.y < 0.0);
    r2.w = r2.x + r1.x;
    correctVariation1 = correctVariation1 != isLumaCenterSmaller;
    correctVariation2 = correctVariation2 != isLumaCenterSmaller;
    r0.w = 1 / r2.w;
    bool isDirection1 = r1.x < r2.x;
    r1.x = min(r2.x, r1.x);
    bool correctVariation = isDirection1 ? correctVariation1 : correctVariation2;
    r1.w = r1.w * r1.w;
    r0.w = r1.x * -r0.w + 0.5;
    r1.x = fxaaQualitySubpix * r1.w;
    r0.w = correctVariation ? r0.w : 0.0;
    r0.w = max(r0.w, r1.x);
    r1.xz = r0.ww * r1.zz + v0.xy;
    r2.x = isHorizontal ? v0.x : r1.x;
    r2.y = isHorizontal ? r1.z : v0.y;
    r0.xyz = SceneColorTexture.SampleLevel(SceneColorTextureSampler_s, r2.xy, 0).xyz;
  }
  r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  r0.xyz = applyFilmGrain(r0.xyz, v0.xy);
  r0.xyz = PostToneMapScale(r0.xyz);
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}