// ---- Created with 3Dmigoto v1.3.16 on Wed Jul 17 22:45:07 2024

#include "./shared.h"
#include "./tonemapper.hlsl"

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb9 : register(b9)
{
  float4 cb9[4];
}




// 3Dmigoto declarations
#define cmp -


void main(
  linear noperspective float4 v0 : TEXCOORD0,
  float4 v1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.SampleLevel(s0_s, v0.xy, 0).xyzw;
  //o0 = r0;
  //o0 *= 999.f;
  //return;
  r1.xyz = t0.Gather(s0_s, v0.xy).xyz;
  r2.xyz = t0.Gather(s0_s, v0.xy, int2(-1, -1)).xzw;
  r1.w = max(r1.x, r0.w);
  r2.w = min(r1.x, r0.w);
  r1.w = max(r1.z, r1.w);
  r2.w = min(r2.w, r1.z);
  r3.x = max(r2.y, r2.x);
  r3.y = min(r2.y, r2.x);
  r1.w = max(r3.x, r1.w);
  r2.w = min(r3.y, r2.w);
  r3.x = cb9[3].y * r1.w;
  r1.w = -r2.w + r1.w;
  r2.w = max(cb9[3].z, r3.x);
  r2.w = cmp(r1.w >= r2.w);
  if (r2.w != 0) {
    r2.w = t0.SampleLevel(s0_s, v0.xy, 0, int2(1, -1)).w;
    r3.x = t0.SampleLevel(s0_s, v0.xy, 0, int2(-1, 1)).w;
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
    r1.y = cmp(r3.x >= r1.y);
    r2.z = r3.w * 2 + r2.z;
    r2.x = r1.y ? r2.y : r2.x;
    r1.x = r1.y ? r1.x : r1.z;
    r1.z = r1.y ? cb9[0].y : cb9[0].x;
    r2.y = r2.z * 0.0833333358 + -r0.w;
    r2.z = r2.x + -r0.w;
    r2.w = r1.x + -r0.w;
    r2.x = r2.x + r0.w;
    r1.x = r1.x + r0.w;
    r3.x = cmp(abs(r2.z) >= abs(r2.w));
    r2.z = max(abs(r2.z), abs(r2.w));
    r1.z = r3.x ? -r1.z : r1.z;
    r1.w = saturate(abs(r2.y) * r1.w);
    r2.y = r1.y ? cb9[0].x : 0;
    r2.w = r1.y ? 0 : cb9[0].y;
    r3.yz = r1.zz * float2(0.5,0.5) + v0.xy;
    r3.y = r1.y ? v0.x : r3.y;
    r3.z = r1.y ? r3.z : v0.y;
    r4.xy = r3.yz + -r2.yw;
    r5.xy = r3.yz + r2.yw;
    r3.y = r1.w * -2 + 3;
    r3.z = t0.SampleLevel(s0_s, r4.xy, 0).w;
    r1.w = r1.w * r1.w;
    r3.w = t0.SampleLevel(s0_s, r5.xy, 0).w;
    r1.x = r3.x ? r2.x : r1.x;
    r2.x = 0.25 * r2.z;
    r0.w = -r1.x * 0.5 + r0.w;
    r1.w = r3.y * r1.w;
    r0.w = cmp(r0.w < 0);
    r3.x = -r1.x * 0.5 + r3.z;
    r3.y = -r1.x * 0.5 + r3.w;
    r3.zw = cmp(abs(r3.xy) >= r2.xx);
    r2.z = r4.x + -r2.y;
    r4.x = r3.z ? r4.x : r2.z;
    r2.z = r4.y + -r2.w;
    r4.z = r3.z ? r4.y : r2.z;
    r4.yw = ~(int2)r3.zw;
    r2.z = (int)r4.w | (int)r4.y;
    r4.y = r5.x + r2.y;
    r4.y = r3.w ? r5.x : r4.y;
    r5.x = r5.y + r2.w;
    r4.w = r3.w ? r5.y : r5.x;
    if (r2.z != 0) {
      if (r3.z == 0) {
        r3.x = t0.SampleLevel(s0_s, r4.xz, 0).w;
      }
      if (r3.w == 0) {
        r3.y = t0.SampleLevel(s0_s, r4.yw, 0).w;
      }
      r2.z = -r1.x * 0.5 + r3.x;
      r3.x = r3.z ? r3.x : r2.z;
      r2.z = -r1.x * 0.5 + r3.y;
      r3.y = r3.w ? r3.y : r2.z;
      r3.zw = cmp(abs(r3.xy) >= r2.xx);
      r2.z = r4.x + -r2.y;
      r4.x = r3.z ? r4.x : r2.z;
      r2.z = r4.z + -r2.w;
      r4.z = r3.z ? r4.z : r2.z;
      r5.xy = ~(int2)r3.zw;
      r2.z = (int)r5.y | (int)r5.x;
      r5.x = r4.y + r2.y;
      r4.y = r3.w ? r4.y : r5.x;
      r5.x = r4.w + r2.w;
      r4.w = r3.w ? r4.w : r5.x;
      if (r2.z != 0) {
        if (r3.z == 0) {
          r3.x = t0.SampleLevel(s0_s, r4.xz, 0).w;
        }
        if (r3.w == 0) {
          r3.y = t0.SampleLevel(s0_s, r4.yw, 0).w;
        }
        r2.z = -r1.x * 0.5 + r3.x;
        r3.x = r3.z ? r3.x : r2.z;
        r2.z = -r1.x * 0.5 + r3.y;
        r3.y = r3.w ? r3.y : r2.z;
        r3.zw = cmp(abs(r3.xy) >= r2.xx);
        r2.z = r4.x + -r2.y;
        r4.x = r3.z ? r4.x : r2.z;
        r2.z = r4.z + -r2.w;
        r4.z = r3.z ? r4.z : r2.z;
        r5.xy = ~(int2)r3.zw;
        r2.z = (int)r5.y | (int)r5.x;
        r5.x = r4.y + r2.y;
        r4.y = r3.w ? r4.y : r5.x;
        r5.x = r4.w + r2.w;
        r4.w = r3.w ? r4.w : r5.x;
        if (r2.z != 0) {
          if (r3.z == 0) {
            r3.x = t0.SampleLevel(s0_s, r4.xz, 0).w;
          }
          if (r3.w == 0) {
            r3.y = t0.SampleLevel(s0_s, r4.yw, 0).w;
          }
          r2.z = -r1.x * 0.5 + r3.x;
          r3.x = r3.z ? r3.x : r2.z;
          r2.z = -r1.x * 0.5 + r3.y;
          r3.y = r3.w ? r3.y : r2.z;
          r3.zw = cmp(abs(r3.xy) >= r2.xx);
          r2.z = r4.x + -r2.y;
          r4.x = r3.z ? r4.x : r2.z;
          r2.z = r4.z + -r2.w;
          r4.z = r3.z ? r4.z : r2.z;
          r5.xy = ~(int2)r3.zw;
          r2.z = (int)r5.y | (int)r5.x;
          r5.x = r4.y + r2.y;
          r4.y = r3.w ? r4.y : r5.x;
          r5.x = r4.w + r2.w;
          r4.w = r3.w ? r4.w : r5.x;
          if (r2.z != 0) {
            if (r3.z == 0) {
              r3.x = t0.SampleLevel(s0_s, r4.xz, 0).w;
            }
            if (r3.w == 0) {
              r3.y = t0.SampleLevel(s0_s, r4.yw, 0).w;
            }
            r2.z = -r1.x * 0.5 + r3.x;
            r3.x = r3.z ? r3.x : r2.z;
            r2.z = -r1.x * 0.5 + r3.y;
            r3.y = r3.w ? r3.y : r2.z;
            r3.zw = cmp(abs(r3.xy) >= r2.xx);
            r2.z = -r2.y * 1.5 + r4.x;
            r4.x = r3.z ? r4.x : r2.z;
            r2.z = -r2.w * 1.5 + r4.z;
            r4.z = r3.z ? r4.z : r2.z;
            r5.xy = ~(int2)r3.zw;
            r2.z = (int)r5.y | (int)r5.x;
            r5.x = r2.y * 1.5 + r4.y;
            r4.y = r3.w ? r4.y : r5.x;
            r5.x = r2.w * 1.5 + r4.w;
            r4.w = r3.w ? r4.w : r5.x;
            if (r2.z != 0) {
              if (r3.z == 0) {
                r3.x = t0.SampleLevel(s0_s, r4.xz, 0).w;
              }
              if (r3.w == 0) {
                r3.y = t0.SampleLevel(s0_s, r4.yw, 0).w;
              }
              r2.z = -r1.x * 0.5 + r3.x;
              r3.x = r3.z ? r3.x : r2.z;
              r2.z = -r1.x * 0.5 + r3.y;
              r3.y = r3.w ? r3.y : r2.z;
              r3.zw = cmp(abs(r3.xy) >= r2.xx);
              r2.z = -r2.y * 2 + r4.x;
              r4.x = r3.z ? r4.x : r2.z;
              r2.z = -r2.w * 2 + r4.z;
              r4.z = r3.z ? r4.z : r2.z;
              r5.xy = ~(int2)r3.zw;
              r2.z = (int)r5.y | (int)r5.x;
              r5.x = r2.y * 2 + r4.y;
              r4.y = r3.w ? r4.y : r5.x;
              r5.x = r2.w * 2 + r4.w;
              r4.w = r3.w ? r4.w : r5.x;
              if (r2.z != 0) {
                if (r3.z == 0) {
                  r3.x = t0.SampleLevel(s0_s, r4.xz, 0).w;
                }
                if (r3.w == 0) {
                  r3.y = t0.SampleLevel(s0_s, r4.yw, 0).w;
                }
                r2.z = -r1.x * 0.5 + r3.x;
                r3.x = r3.z ? r3.x : r2.z;
                r2.z = -r1.x * 0.5 + r3.y;
                r3.y = r3.w ? r3.y : r2.z;
                r3.zw = cmp(abs(r3.xy) >= r2.xx);
                r2.z = -r2.y * 2 + r4.x;
                r4.x = r3.z ? r4.x : r2.z;
                r2.z = -r2.w * 2 + r4.z;
                r4.z = r3.z ? r4.z : r2.z;
                r5.xy = ~(int2)r3.zw;
                r2.z = (int)r5.y | (int)r5.x;
                r5.x = r2.y * 2 + r4.y;
                r4.y = r3.w ? r4.y : r5.x;
                r5.x = r2.w * 2 + r4.w;
                r4.w = r3.w ? r4.w : r5.x;
                if (r2.z != 0) {
                  if (r3.z == 0) {
                    r3.x = t0.SampleLevel(s0_s, r4.xz, 0).w;
                  }
                  if (r3.w == 0) {
                    r3.y = t0.SampleLevel(s0_s, r4.yw, 0).w;
                  }
                  r2.z = -r1.x * 0.5 + r3.x;
                  r3.x = r3.z ? r3.x : r2.z;
                  r2.z = -r1.x * 0.5 + r3.y;
                  r3.y = r3.w ? r3.y : r2.z;
                  r3.zw = cmp(abs(r3.xy) >= r2.xx);
                  r2.z = -r2.y * 2 + r4.x;
                  r4.x = r3.z ? r4.x : r2.z;
                  r2.z = -r2.w * 2 + r4.z;
                  r4.z = r3.z ? r4.z : r2.z;
                  r5.xy = ~(int2)r3.zw;
                  r2.z = (int)r5.y | (int)r5.x;
                  r5.x = r2.y * 2 + r4.y;
                  r4.y = r3.w ? r4.y : r5.x;
                  r5.x = r2.w * 2 + r4.w;
                  r4.w = r3.w ? r4.w : r5.x;
                  if (r2.z != 0) {
                    if (r3.z == 0) {
                      r3.x = t0.SampleLevel(s0_s, r4.xz, 0).w;
                    }
                    if (r3.w == 0) {
                      r3.y = t0.SampleLevel(s0_s, r4.yw, 0).w;
                    }
                    r2.z = -r1.x * 0.5 + r3.x;
                    r3.x = r3.z ? r3.x : r2.z;
                    r2.z = -r1.x * 0.5 + r3.y;
                    r3.y = r3.w ? r3.y : r2.z;
                    r3.zw = cmp(abs(r3.xy) >= r2.xx);
                    r2.z = -r2.y * 2 + r4.x;
                    r4.x = r3.z ? r4.x : r2.z;
                    r2.z = -r2.w * 2 + r4.z;
                    r4.z = r3.z ? r4.z : r2.z;
                    r5.xy = ~(int2)r3.zw;
                    r2.z = (int)r5.y | (int)r5.x;
                    r5.x = r2.y * 2 + r4.y;
                    r4.y = r3.w ? r4.y : r5.x;
                    r5.x = r2.w * 2 + r4.w;
                    r4.w = r3.w ? r4.w : r5.x;
                    if (r2.z != 0) {
                      if (r3.z == 0) {
                        r3.x = t0.SampleLevel(s0_s, r4.xz, 0).w;
                      }
                      if (r3.w == 0) {
                        r3.y = t0.SampleLevel(s0_s, r4.yw, 0).w;
                      }
                      r2.z = -r1.x * 0.5 + r3.x;
                      r3.x = r3.z ? r3.x : r2.z;
                      r2.z = -r1.x * 0.5 + r3.y;
                      r3.y = r3.w ? r3.y : r2.z;
                      r3.zw = cmp(abs(r3.xy) >= r2.xx);
                      r2.z = -r2.y * 4 + r4.x;
                      r4.x = r3.z ? r4.x : r2.z;
                      r2.z = -r2.w * 4 + r4.z;
                      r4.z = r3.z ? r4.z : r2.z;
                      r5.xy = ~(int2)r3.zw;
                      r2.z = (int)r5.y | (int)r5.x;
                      r5.x = r2.y * 4 + r4.y;
                      r4.y = r3.w ? r4.y : r5.x;
                      r5.x = r2.w * 4 + r4.w;
                      r4.w = r3.w ? r4.w : r5.x;
                      if (r2.z != 0) {
                        if (r3.z == 0) {
                          r3.x = t0.SampleLevel(s0_s, r4.xz, 0).w;
                        }
                        if (r3.w == 0) {
                          r3.y = t0.SampleLevel(s0_s, r4.yw, 0).w;
                        }
                        r2.z = -r1.x * 0.5 + r3.x;
                        r3.x = r3.z ? r3.x : r2.z;
                        r1.x = -r1.x * 0.5 + r3.y;
                        r3.y = r3.w ? r3.y : r1.x;
                        r2.xz = cmp(abs(r3.xy) >= r2.xx);
                        r1.x = -r2.y * 8 + r4.x;
                        r4.x = r2.x ? r4.x : r1.x;
                        r1.x = -r2.w * 8 + r4.z;
                        r4.z = r2.x ? r4.z : r1.x;
                        r1.x = r2.y * 8 + r4.y;
                        r4.y = r2.z ? r4.y : r1.x;
                        r1.x = r2.w * 8 + r4.w;
                        r4.w = r2.z ? r4.w : r1.x;
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
    r1.x = r1.y ? r1.x : r2.y;
    r2.xy = -v0.xy + r4.yw;
    r2.x = r1.y ? r2.x : r2.y;
    r2.yz = cmp(r3.xy < float2(0,0));
    r2.w = r2.x + r1.x;
    r2.yz = cmp((int2)r0.ww != (int2)r2.yz);
    r0.w = 1 / r2.w;
    r2.w = cmp(r1.x < r2.x);
    r1.x = min(r2.x, r1.x);
    r2.x = r2.w ? r2.y : r2.z;
    r1.w = r1.w * r1.w;
    r0.w = r1.x * -r0.w + 0.5;
    r1.x = cb9[3].x * r1.w;
    r0.w = (int)r0.w & (int)r2.x;
    r0.w = max(r0.w, r1.x);
    r1.xz = r0.ww * r1.zz + v0.xy;
    r2.x = r1.y ? v0.x : r1.x;
    r2.y = r1.y ? r1.z : v0.y;
    r0.xyz = t0.SampleLevel(s0_s, r2.xy, 0).xyz;
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
    
    //Apply RenoDX
    o0.rgb = applyUserTonemap(o0.rgb);
    //o0.rgb = renodx::math::SafePow(o0.rgb, 1.f/2.2f); //back to inverse gamma
  
  
  return;
}