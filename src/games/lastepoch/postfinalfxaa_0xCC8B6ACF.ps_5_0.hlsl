#include "./common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0) {
  float4 cb0[30];
}

#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    float2 w1: TEXCOORD1,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4, r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = saturate(v1.xy);
  r0.xy = cb0[26].xx * r0.xy;
  r1.xyzw = t1.SampleLevel(s1_s, r0.xy, 0).xyzw;
  r0.z = t1.SampleLevel(s1_s, r0.xy, 0, int2(0, 1)).w;
  r0.w = t1.SampleLevel(s1_s, r0.xy, 0, int2(1, 0)).w;
  r2.x = t1.SampleLevel(s1_s, r0.xy, 0, int2(0, -1)).w;
  r2.y = t1.SampleLevel(s1_s, r0.xy, 0, int2(-1, 0)).w;
  r2.z = max(r0.z, r1.w);
  r2.w = min(r0.z, r1.w);
  r2.z = max(r2.z, r0.w);
  r2.w = min(r2.w, r0.w);
  r3.x = max(r2.x, r2.y);
  r3.y = min(r2.x, r2.y);
  r2.z = max(r3.x, r2.z);
  r2.w = min(r3.y, r2.w);
  r3.x = 0.063000001 * r2.z;
  r2.z = r2.z + -r2.w;
  r2.w = max(0.0311999992, r3.x);
  r2.w = cmp(r2.z >= r2.w);
  if (r2.w != 0) {
    r2.w = t1.SampleLevel(s1_s, r0.xy, 0, int2(-1, -1)).w;
    r3.x = t1.SampleLevel(s1_s, r0.xy, 0, int2(1, 1)).w;
    r3.y = t1.SampleLevel(s1_s, r0.xy, 0, int2(1, -1)).w;
    r0.x = t1.SampleLevel(s1_s, r0.xy, 0, int2(-1, 1)).w;
    r0.y = r2.x + r0.z;
    r3.z = r2.y + r0.w;
    r2.z = 1 / r2.z;
    r3.w = r3.z + r0.y;
    r0.y = r1.w * -2 + r0.y;
    r3.z = r1.w * -2 + r3.z;
    r4.x = r3.y + r3.x;
    r3.y = r3.y + r2.w;
    r4.y = r0.w * -2 + r4.x;
    r3.y = r2.x * -2 + r3.y;
    r2.w = r2.w + r0.x;
    r0.x = r0.x + r3.x;
    r0.y = abs(r0.y) * 2 + abs(r4.y);
    r3.x = abs(r3.z) * 2 + abs(r3.y);
    r3.y = r2.y * -2 + r2.w;
    r0.x = r0.z * -2 + r0.x;
    r0.y = abs(r3.y) + r0.y;
    r0.x = abs(r0.x) + r3.x;
    r2.w = r2.w + r4.x;
    r0.x = cmp(r0.y >= r0.x);
    r0.y = r3.w * 2 + r2.w;
    r2.x = r0.x ? r2.x : r2.y;
    r0.z = r0.x ? r0.z : r0.w;
    r0.w = r0.x ? cb0[29].y : cb0[29].x;
    r0.y = r0.y * 0.0833333358 + -r1.w;
    r2.y = r2.x + -r1.w;
    r2.w = r0.z + -r1.w;
    r2.x = r2.x + r1.w;
    r0.z = r0.z + r1.w;
    r3.x = cmp(abs(r2.y) >= abs(r2.w));
    r2.y = max(abs(r2.y), abs(r2.w));
    r0.w = r3.x ? -r0.w : r0.w;
    r0.y = saturate(abs(r0.y) * r2.z);
    r2.z = r0.x ? cb0[29].x : 0;
    r2.w = r0.x ? 0 : cb0[29].y;
    r3.yz = r0.ww * float2(0.5, 0.5) + v1.xy;
    r3.y = r0.x ? v1.x : r3.y;
    r3.z = r0.x ? r3.z : v1.y;
    r4.xy = r3.yz + -r2.zw;
    r5.xy = r3.yz + r2.zw;
    r3.y = r0.y * -2 + 3;
    r3.zw = saturate(r4.xy);
    r3.zw = cb0[26].xx * r3.zw;
    r3.z = t1.SampleLevel(s1_s, r3.zw, 0).w;
    r0.y = r0.y * r0.y;
    r4.zw = saturate(r5.xy);
    r4.zw = cb0[26].xx * r4.zw;
    r3.w = t1.SampleLevel(s1_s, r4.zw, 0).w;
    r0.z = r3.x ? r2.x : r0.z;
    r2.x = 0.25 * r2.y;
    r2.y = -r0.z * 0.5 + r1.w;
    r0.y = r3.y * r0.y;
    r2.y = cmp(r2.y < 0);
    r3.x = -r0.z * 0.5 + r3.z;
    r3.y = -r0.z * 0.5 + r3.w;
    r3.zw = cmp(abs(r3.xy) >= r2.xx);
    r4.z = -r2.z * 1.5 + r4.x;
    r4.x = r3.z ? r4.x : r4.z;
    r4.w = -r2.w * 1.5 + r4.y;
    r4.z = r3.z ? r4.y : r4.w;
    r4.yw = ~(int2)r3.zw;
    r4.y = (int)r4.w | (int)r4.y;
    r4.w = r2.z * 1.5 + r5.x;
    r5.x = r3.w ? r5.x : r4.w;
    r4.w = r2.w * 1.5 + r5.y;
    r5.z = r3.w ? r5.y : r4.w;
    if (r4.y != 0) {
      if (r3.z == 0) {
        r4.yw = saturate(r4.xz);
        r4.yw = cb0[26].xx * r4.yw;
        r3.x = t1.SampleLevel(s1_s, r4.yw, 0).w;
      }
      if (r3.w == 0) {
        r4.yw = saturate(r5.xz);
        r4.yw = cb0[26].xx * r4.yw;
        r3.y = t1.SampleLevel(s1_s, r4.yw, 0).w;
      }
      r4.y = -r0.z * 0.5 + r3.x;
      r3.x = r3.z ? r3.x : r4.y;
      r3.z = -r0.z * 0.5 + r3.y;
      r3.y = r3.w ? r3.y : r3.z;
      r3.zw = cmp(abs(r3.xy) >= r2.xx);
      r4.y = -r2.z * 2 + r4.x;
      r4.x = r3.z ? r4.x : r4.y;
      r4.y = -r2.w * 2 + r4.z;
      r4.z = r3.z ? r4.z : r4.y;
      r4.yw = ~(int2)r3.zw;
      r4.y = (int)r4.w | (int)r4.y;
      r4.w = r2.z * 2 + r5.x;
      r5.x = r3.w ? r5.x : r4.w;
      r4.w = r2.w * 2 + r5.z;
      r5.z = r3.w ? r5.z : r4.w;
      if (r4.y != 0) {
        if (r3.z == 0) {
          r4.yw = saturate(r4.xz);
          r4.yw = cb0[26].xx * r4.yw;
          r3.x = t1.SampleLevel(s1_s, r4.yw, 0).w;
        }
        if (r3.w == 0) {
          r4.yw = saturate(r5.xz);
          r4.yw = cb0[26].xx * r4.yw;
          r3.y = t1.SampleLevel(s1_s, r4.yw, 0).w;
        }
        r4.y = -r0.z * 0.5 + r3.x;
        r3.x = r3.z ? r3.x : r4.y;
        r3.z = -r0.z * 0.5 + r3.y;
        r3.y = r3.w ? r3.y : r3.z;
        r3.zw = cmp(abs(r3.xy) >= r2.xx);
        r4.y = -r2.z * 2 + r4.x;
        r4.x = r3.z ? r4.x : r4.y;
        r4.y = -r2.w * 2 + r4.z;
        r4.z = r3.z ? r4.z : r4.y;
        r4.yw = ~(int2)r3.zw;
        r4.y = (int)r4.w | (int)r4.y;
        r4.w = r2.z * 2 + r5.x;
        r5.x = r3.w ? r5.x : r4.w;
        r4.w = r2.w * 2 + r5.z;
        r5.z = r3.w ? r5.z : r4.w;
        if (r4.y != 0) {
          if (r3.z == 0) {
            r4.yw = saturate(r4.xz);
            r4.yw = cb0[26].xx * r4.yw;
            r3.x = t1.SampleLevel(s1_s, r4.yw, 0).w;
          }
          if (r3.w == 0) {
            r4.yw = saturate(r5.xz);
            r4.yw = cb0[26].xx * r4.yw;
            r3.y = t1.SampleLevel(s1_s, r4.yw, 0).w;
          }
          r4.y = -r0.z * 0.5 + r3.x;
          r3.x = r3.z ? r3.x : r4.y;
          r3.z = -r0.z * 0.5 + r3.y;
          r3.y = r3.w ? r3.y : r3.z;
          r3.zw = cmp(abs(r3.xy) >= r2.xx);
          r4.y = -r2.z * 2 + r4.x;
          r4.x = r3.z ? r4.x : r4.y;
          r4.y = -r2.w * 2 + r4.z;
          r4.z = r3.z ? r4.z : r4.y;
          r4.yw = ~(int2)r3.zw;
          r4.y = (int)r4.w | (int)r4.y;
          r4.w = r2.z * 2 + r5.x;
          r5.x = r3.w ? r5.x : r4.w;
          r4.w = r2.w * 2 + r5.z;
          r5.z = r3.w ? r5.z : r4.w;
          if (r4.y != 0) {
            if (r3.z == 0) {
              r4.yw = saturate(r4.xz);
              r4.yw = cb0[26].xx * r4.yw;
              r3.x = t1.SampleLevel(s1_s, r4.yw, 0).w;
            }
            if (r3.w == 0) {
              r4.yw = saturate(r5.xz);
              r4.yw = cb0[26].xx * r4.yw;
              r3.y = t1.SampleLevel(s1_s, r4.yw, 0).w;
            }
            r4.y = -r0.z * 0.5 + r3.x;
            r3.x = r3.z ? r3.x : r4.y;
            r3.z = -r0.z * 0.5 + r3.y;
            r3.y = r3.w ? r3.y : r3.z;
            r3.zw = cmp(abs(r3.xy) >= r2.xx);
            r4.y = -r2.z * 2 + r4.x;
            r4.x = r3.z ? r4.x : r4.y;
            r4.y = -r2.w * 2 + r4.z;
            r4.z = r3.z ? r4.z : r4.y;
            r4.yw = ~(int2)r3.zw;
            r4.y = (int)r4.w | (int)r4.y;
            r4.w = r2.z * 2 + r5.x;
            r5.x = r3.w ? r5.x : r4.w;
            r4.w = r2.w * 2 + r5.z;
            r5.z = r3.w ? r5.z : r4.w;
            if (r4.y != 0) {
              if (r3.z == 0) {
                r4.yw = saturate(r4.xz);
                r4.yw = cb0[26].xx * r4.yw;
                r3.x = t1.SampleLevel(s1_s, r4.yw, 0).w;
              }
              if (r3.w == 0) {
                r4.yw = saturate(r5.xz);
                r4.yw = cb0[26].xx * r4.yw;
                r3.y = t1.SampleLevel(s1_s, r4.yw, 0).w;
              }
              r4.y = -r0.z * 0.5 + r3.x;
              r3.x = r3.z ? r3.x : r4.y;
              r3.z = -r0.z * 0.5 + r3.y;
              r3.y = r3.w ? r3.y : r3.z;
              r3.zw = cmp(abs(r3.xy) >= r2.xx);
              r4.y = -r2.z * 2 + r4.x;
              r4.x = r3.z ? r4.x : r4.y;
              r4.y = -r2.w * 2 + r4.z;
              r4.z = r3.z ? r4.z : r4.y;
              r4.yw = ~(int2)r3.zw;
              r4.y = (int)r4.w | (int)r4.y;
              r4.w = r2.z * 2 + r5.x;
              r5.x = r3.w ? r5.x : r4.w;
              r4.w = r2.w * 2 + r5.z;
              r5.z = r3.w ? r5.z : r4.w;
              if (r4.y != 0) {
                if (r3.z == 0) {
                  r4.yw = saturate(r4.xz);
                  r4.yw = cb0[26].xx * r4.yw;
                  r3.x = t1.SampleLevel(s1_s, r4.yw, 0).w;
                }
                if (r3.w == 0) {
                  r4.yw = saturate(r5.xz);
                  r4.yw = cb0[26].xx * r4.yw;
                  r3.y = t1.SampleLevel(s1_s, r4.yw, 0).w;
                }
                r4.y = -r0.z * 0.5 + r3.x;
                r3.x = r3.z ? r3.x : r4.y;
                r3.z = -r0.z * 0.5 + r3.y;
                r3.y = r3.w ? r3.y : r3.z;
                r3.zw = cmp(abs(r3.xy) >= r2.xx);
                r4.y = -r2.z * 2 + r4.x;
                r4.x = r3.z ? r4.x : r4.y;
                r4.y = -r2.w * 2 + r4.z;
                r4.z = r3.z ? r4.z : r4.y;
                r4.yw = ~(int2)r3.zw;
                r4.y = (int)r4.w | (int)r4.y;
                r4.w = r2.z * 2 + r5.x;
                r5.x = r3.w ? r5.x : r4.w;
                r4.w = r2.w * 2 + r5.z;
                r5.z = r3.w ? r5.z : r4.w;
                if (r4.y != 0) {
                  if (r3.z == 0) {
                    r4.yw = saturate(r4.xz);
                    r4.yw = cb0[26].xx * r4.yw;
                    r3.x = t1.SampleLevel(s1_s, r4.yw, 0).w;
                  }
                  if (r3.w == 0) {
                    r4.yw = saturate(r5.xz);
                    r4.yw = cb0[26].xx * r4.yw;
                    r3.y = t1.SampleLevel(s1_s, r4.yw, 0).w;
                  }
                  r4.y = -r0.z * 0.5 + r3.x;
                  r3.x = r3.z ? r3.x : r4.y;
                  r3.z = -r0.z * 0.5 + r3.y;
                  r3.y = r3.w ? r3.y : r3.z;
                  r3.zw = cmp(abs(r3.xy) >= r2.xx);
                  r4.y = -r2.z * 2 + r4.x;
                  r4.x = r3.z ? r4.x : r4.y;
                  r4.y = -r2.w * 2 + r4.z;
                  r4.z = r3.z ? r4.z : r4.y;
                  r4.yw = ~(int2)r3.zw;
                  r4.y = (int)r4.w | (int)r4.y;
                  r4.w = r2.z * 2 + r5.x;
                  r5.x = r3.w ? r5.x : r4.w;
                  r4.w = r2.w * 2 + r5.z;
                  r5.z = r3.w ? r5.z : r4.w;
                  if (r4.y != 0) {
                    if (r3.z == 0) {
                      r4.yw = saturate(r4.xz);
                      r4.yw = cb0[26].xx * r4.yw;
                      r3.x = t1.SampleLevel(s1_s, r4.yw, 0).w;
                    }
                    if (r3.w == 0) {
                      r4.yw = saturate(r5.xz);
                      r4.yw = cb0[26].xx * r4.yw;
                      r3.y = t1.SampleLevel(s1_s, r4.yw, 0).w;
                    }
                    r4.y = -r0.z * 0.5 + r3.x;
                    r3.x = r3.z ? r3.x : r4.y;
                    r3.z = -r0.z * 0.5 + r3.y;
                    r3.y = r3.w ? r3.y : r3.z;
                    r3.zw = cmp(abs(r3.xy) >= r2.xx);
                    r4.y = -r2.z * 4 + r4.x;
                    r4.x = r3.z ? r4.x : r4.y;
                    r4.y = -r2.w * 4 + r4.z;
                    r4.z = r3.z ? r4.z : r4.y;
                    r4.yw = ~(int2)r3.zw;
                    r4.y = (int)r4.w | (int)r4.y;
                    r4.w = r2.z * 4 + r5.x;
                    r5.x = r3.w ? r5.x : r4.w;
                    r4.w = r2.w * 4 + r5.z;
                    r5.z = r3.w ? r5.z : r4.w;
                    if (r4.y != 0) {
                      if (r3.z == 0) {
                        r4.yw = saturate(r4.xz);
                        r4.yw = cb0[26].xx * r4.yw;
                        r3.x = t1.SampleLevel(s1_s, r4.yw, 0).w;
                      }
                      if (r3.w == 0) {
                        r4.yw = saturate(r5.xz);
                        r4.yw = cb0[26].xx * r4.yw;
                        r3.y = t1.SampleLevel(s1_s, r4.yw, 0).w;
                      }
                      r4.y = -r0.z * 0.5 + r3.x;
                      r3.x = r3.z ? r3.x : r4.y;
                      r0.z = -r0.z * 0.5 + r3.y;
                      r3.y = r3.w ? r3.y : r0.z;
                      r3.zw = cmp(abs(r3.xy) >= r2.xx);
                      r0.z = -r2.z * 8 + r4.x;
                      r4.x = r3.z ? r4.x : r0.z;
                      r0.z = -r2.w * 8 + r4.z;
                      r4.z = r3.z ? r4.z : r0.z;
                      r0.z = r2.z * 8 + r5.x;
                      r5.x = r3.w ? r5.x : r0.z;
                      r0.z = r2.w * 8 + r5.z;
                      r5.z = r3.w ? r5.z : r0.z;
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
    r2.z = v1.y + -r4.z;
    r0.z = r0.x ? r0.z : r2.z;
    r2.xz = -v1.xy + r5.xz;
    r2.x = r0.x ? r2.x : r2.z;
    r2.zw = cmp(r3.xy < float2(0, 0));
    r3.x = r2.x + r0.z;
    r2.yz = cmp((int2)r2.yy != (int2)r2.zw);
    r2.w = 1 / r3.x;
    r3.x = cmp(r0.z < r2.x);
    r0.z = min(r2.x, r0.z);
    r2.x = r3.x ? r2.y : r2.z;
    r0.y = r0.y * r0.y;
    r0.z = r0.z * -r2.w + 0.5;
    r0.z = (int)r0.z & (int)r2.x;
    r0.y = max(r0.z, r0.y);
    r0.yz = r0.yy * r0.ww + v1.xy;
    r2.x = saturate(r0.x ? v1.x : r0.y);
    r2.y = saturate(r0.x ? r0.z : v1.y);
    r0.xy = cb0[26].xx * r2.xy;
    r1.xyz = t1.SampleLevel(s1_s, r0.xy, 0).xyz;
  }
  if (injectedData.fxFilmGrain > 0.f) {
    r1.rgb = applyFilmGrain(r1.rgb, v1, injectedData.fxFilmGrainType != 0.f);
  }
  if (injectedData.fxNoise > 0.f) {
    r0.xy = v1.xy * cb0[28].xy + cb0[28].zw;
    r0.x = t0.Sample(s0_s, r0.xy).w;
    r0.x = r0.x * 2 + -1;
    r0.y = saturate(r0.x * 3.40282347e+38 + 0.5);
    r0.y = r0.y * 2 + -1;
    r0.x = 1 + -abs(r0.x);
    r0.x = sqrt(r0.x);
    r0.x = 1 + -r0.x;
    r0.x = r0.y * r0.x;
    r1.rgb = renodx::color::srgb::EncodeSafe(r1.rgb);
    r1.rgb = r0.rrr * float3(0.00392156886, 0.00392156886, 0.00392156886) * injectedData.fxNoise + r1.rgb;
    r1.rgb = renodx::color::srgb::DecodeSafe(r1.rgb);
  }
  r1.rgb = PostToneMapScale(r1.rgb);
  o0.rgb = r1.rgb;
  o0.w = r1.w;
  return;
}
