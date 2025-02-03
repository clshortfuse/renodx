Texture2D<float4> t9 : register(t9);
Texture2D<float4> t8 : register(t8);
Texture2D<float4> t7 : register(t7);
Texture2D<float4> t6 : register(t6);
Texture2D<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s9_s : register(s9);
SamplerState s8_s : register(s8);
SamplerState s7_s : register(s7);
SamplerState s6_s : register(s6);
SamplerState s5_s : register(s5);
SamplerState s4_s : register(s4);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[20];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float4 v2 : TEXCOORD0,
  nointerpolation float4 v3 : TEXCOORD1,
  nointerpolation float4 v4 : TEXCOORD3,
  float4 v5 : TEXCOORD4,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cmp(v3.w >= 2);
  r0.y = -2 + v3.w;
  r0.y = r0.x ? r0.y : v3.w;
  r0.z = cmp(v3.x == 1.000000);
  if (r0.z != 0) {
    r0.z = cmp(0 != r0.y);
    if (r0.z != 0) {
      r0.zw = cmp(float2(-9999,-9999) < v5.xz);
      if (r0.z != 0) {
        r0.z = dot(v5.xy, v5.xy);
        r0.z = sqrt(r0.z);
        r0.z = -1 + r0.z;
        r1.x = ddx(r0.z);
        r1.y = ddy(r0.z);
        r1.x = dot(r1.xy, r1.xy);
        r1.x = sqrt(r1.x);
        r0.z = r0.z / r1.x;
        r0.z = saturate(0.5 + -r0.z);
      } else {
        r0.z = 1;
      }
      if (r0.w != 0) {
        r0.w = dot(v5.zw, v5.zw);
        r0.w = sqrt(r0.w);
        r0.w = -1 + r0.w;
        r1.x = ddx(r0.w);
        r1.y = ddy(r0.w);
        r1.x = dot(r1.xy, r1.xy);
        r1.x = sqrt(r1.x);
        r0.w = r0.w / r1.x;
        r0.w = saturate(0.5 + -r0.w);
        r0.w = 1 + -r0.w;
        r0.z = r0.z * r0.w;
      }
    } else {
      r0.z = 1;
    }
    o0.xyz = v1.xyz;
    r1.x = v1.w;
  } else {
    r0.w = cmp(v3.x == 3.000000);
    if (r0.w != 0) {
      r0.w = cmp(v3.y < 4);
      if (r0.w != 0) {
        r0.w = cmp(v3.y < 2);
        if (r0.w != 0) {
          r0.w = cmp(v3.y < 1);
          if (r0.w != 0) {
            r2.xyzw = t0.Sample(s2_s, v2.xy).xyzw;
          } else {
            r2.xyzw = t1.Sample(s3_s, v2.xy).xyzw;
          }
        } else {
          r0.w = cmp(v3.y < 3);
          if (r0.w != 0) {
            r2.xyzw = t2.Sample(s4_s, v2.xy).xyzw;
          } else {
            r2.xyzw = t3.Sample(s5_s, v2.xy).xyzw;
          }
        }
      } else {
        r0.w = cmp(v3.y < 6);
        if (r0.w != 0) {
          r0.w = cmp(v3.y < 5);
          if (r0.w != 0) {
            r2.xyzw = t4.Sample(s6_s, v2.xy).xyzw;
          } else {
            r2.xyzw = t5.Sample(s7_s, v2.xy).xyzw;
          }
        } else {
          r0.w = cmp(v3.y < 7);
          if (r0.w != 0) {
            r2.xyzw = t6.Sample(s8_s, v2.xy).xyzw;
          } else {
            r2.xyzw = t7.Sample(s9_s, v2.xy).xyzw;
          }
        }
      }
      r1.xyzw = v1.wxyz * r2.wxyz;
      r0.y = cmp(0 != r0.y);
      if (r0.y != 0) {
        r0.yw = cmp(float2(-9999,-9999) < v5.xz);
        if (r0.y != 0) {
          r0.y = dot(v5.xy, v5.xy);
          r0.y = sqrt(r0.y);
          r0.y = -1 + r0.y;
          r2.x = ddx(r0.y);
          r2.y = ddy(r0.y);
          r2.x = dot(r2.xy, r2.xy);
          r2.x = sqrt(r2.x);
          r0.y = r0.y / r2.x;
          r0.z = saturate(0.5 + -r0.y);
        } else {
          r0.z = 1;
        }
        if (r0.w != 0) {
          r0.y = dot(v5.zw, v5.zw);
          r0.y = sqrt(r0.y);
          r0.y = -1 + r0.y;
          r2.x = ddx(r0.y);
          r2.y = ddy(r0.y);
          r0.w = dot(r2.xy, r2.xy);
          r0.w = sqrt(r0.w);
          r0.y = r0.y / r0.w;
          r0.y = saturate(0.5 + -r0.y);
          r0.y = 1 + -r0.y;
          r0.z = r0.z * r0.y;
        }
      } else {
        r0.z = 1;
      }
      o0.xyz = r1.yzw;
    } else {
      r0.y = cmp(v3.x == 2.000000);
      if (r0.y != 0) {
        r0.y = cmp(v3.y < 4);
        if (r0.y != 0) {
          r0.w = cmp(v3.y < 2);
          if (r0.w != 0) {
            r0.w = cmp(v3.y < 1);
            if (r0.w != 0) {
              r2.xyzw = t0.Sample(s2_s, v2.xy).wxyz;
            } else {
              r2.xyzw = t1.Sample(s3_s, v2.xy).wxyz;
            }
          } else {
            r0.w = cmp(v3.y < 3);
            if (r0.w != 0) {
              r2.xyzw = t2.Sample(s4_s, v2.xy).wxyz;
            } else {
              r2.xyzw = t3.Sample(s5_s, v2.xy).wxyz;
            }
          }
        } else {
          r0.w = cmp(v3.y < 6);
          if (r0.w != 0) {
            r0.w = cmp(v3.y < 5);
            if (r0.w != 0) {
              r2.xyzw = t4.Sample(s6_s, v2.xy).wxyz;
            } else {
              r2.xyzw = t5.Sample(s7_s, v2.xy).wxyz;
            }
          } else {
            r0.w = cmp(v3.y < 7);
            if (r0.w != 0) {
              r2.xyzw = t6.Sample(s8_s, v2.xy).wxyz;
            } else {
              r2.xyzw = t7.Sample(s9_s, v2.xy).wxyz;
            }
          }
        }
        r0.w = v3.y + v3.y;
        r0.w = (uint)r0.w;
        r3.xyzw = float4(0.5,3.5,0.5,1.5) + v4.xyxy;
        r3.xyzw = cb0[3].xyxy * r3.xyzw;
        r4.xyzw = t8.SampleLevel(s1_s, r3.xy, 0).xyzw;
        r4.xyzw = cb0[r0.w+4].wwww * r4.xyzw;
        r5.y = 0.25 * r4.w;
        r2.z = v3.y * 2 + 1;
        r2.z = (uint)r2.z;
        r3.xy = r4.xy * cb0[r0.w+4].yy + v2.xy;
        if (r0.y != 0) {
          r0.y = cmp(v3.y < 2);
          if (r0.y != 0) {
            r0.y = cmp(v3.y < 1);
            if (r0.y != 0) {
              r6.xyzw = t0.Sample(s2_s, r3.xy).xyzw;
              r2.y = r6.w;
            } else {
              r6.xyzw = t1.Sample(s3_s, r3.xy).xyzw;
              r2.y = r6.w;
            }
          } else {
            r0.y = cmp(v3.y < 3);
            if (r0.y != 0) {
              r6.xyzw = t2.Sample(s4_s, r3.xy).xyzw;
              r2.y = r6.w;
            } else {
              r6.xyzw = t3.Sample(s5_s, r3.xy).xyzw;
              r2.y = r6.w;
            }
          }
        } else {
          r0.y = cmp(v3.y < 6);
          if (r0.y != 0) {
            r0.y = cmp(v3.y < 5);
            if (r0.y != 0) {
              r6.xyzw = t4.Sample(s6_s, r3.xy).xyzw;
              r2.y = r6.w;
            } else {
              r6.xyzw = t5.Sample(s7_s, r3.xy).xyzw;
              r2.y = r6.w;
            }
          } else {
            r0.y = cmp(v3.y < 7);
            if (r0.y != 0) {
              r6.xyzw = t6.Sample(s8_s, r3.xy).xyzw;
              r2.y = r6.w;
            } else {
              r6.xyzw = t7.Sample(s9_s, r3.xy).xyzw;
              r2.y = r6.w;
            }
          }
        }
        r5.x = -r5.y;
        r5.z = 0;
        r5.xyz = v5.xxx + r5.xyz;
        r0.y = ddx(v2.y);
        r2.w = ddy(v2.y);
        r0.y = abs(r2.w) + abs(r0.y);
        r2.xyw = float3(-0.5,-0.5,-0.5) + r2.xxy;
        r2.xyw = r2.xyw * cb0[r0.w+4].www + r5.xyz;
        r2.xyw = r2.xyw + r2.xyw;
        r4.xy = float2(0,0);
        r4.xyz = cb0[r2.z+4].yyy * r0.yyy + r4.xyz;
        r2.xyz = r2.xyw / r4.xyz;
        r2.xyz = saturate(float3(0.5,0.5,0.5) + r2.xyz);
        if (r0.x != 0) {
          r0.xy = float2(0.5,0.5) + v4.xy;
          r0.xy = cb0[3].xy * r0.xy;
          r4.xyzw = t8.SampleLevel(s1_s, r0.xy, 0).xyzw;
          r5.w = v3.z * r4.w;
        } else {
          r4.xyz = v1.xyz;
          r5.w = v1.w;
        }
        r5.xyz = r5.www * r4.xyz;
        r3.xyzw = t8.SampleLevel(s1_s, r3.zw, 0).xyzw;
        r4.w = v3.z * r3.w;
        r4.xyz = r4.www * r3.xyz;
        r0.xy = float2(1,1) + -r2.xy;
        r3.xyzw = r4.xyzw * r0.xxxx;
        r3.xyzw = r3.xyzw * r2.yyyy;
        r3.xyzw = r5.xyzw * r2.xxxx + r3.xyzw;
        r2.xy = float2(0.5,2.5) + v4.xy;
        r2.xy = cb0[3].xy * r2.xy;
        r4.xyzw = t8.SampleLevel(s1_s, r2.xy, 0).xyzw;
        r0.w = v3.z * r4.w;
        r2.w = r0.w * r2.z;
        r2.xyz = r4.xyz * r2.www;
        r2.xyzw = r2.xyzw * r0.xxxx;
        r1.xyzw = r2.wxyz * r0.yyyy + r3.wxyz;
        r0.x = cmp(0 < r1.x);
        r0.x = r0.x ? r1.x : 1;
        o0.xyz = r1.yzw / r0.xxx;
      } else {
        r0.x = v3.y + v3.y;
        r0.x = (uint)r0.x;
        r2.xw = float2(0.5,0);
        r2.y = 0.5 + v3.z;
        r0.yw = cb0[2].xy * r2.xy;
        r3.xyzw = t9.SampleLevel(s0_s, r0.yw, 0).xyzw;
        r3.x = cmp(0 < r3.x);
        r3.zw = float2(-0.5,-0.5) + r3.zw;
        r3.zw = r3.zw + r3.zw;
        r4.xy = float2(-0.5,-0.5) + v2.xy;
        r4.xy = r4.xy * float2(2,2) + -r3.zw;
        r4.z = dot(r4.xy, r4.xy);
        r4.z = rsqrt(r4.z);
        r4.zw = r4.xy * r4.zz;
        r5.x = dot(-r3.zw, r4.zw);
        r3.z = dot(r3.zw, r3.zw);
        r3.z = -r5.x * r5.x + r3.z;
        r3.z = 1 + -r3.z;
        r3.z = sqrt(r3.z);
        r3.w = r5.x + -r3.z;
        r3.z = r5.x + r3.z;
        r5.x = min(r3.w, r3.z);
        r5.y = cmp(r5.x < 0);
        r3.z = max(r3.w, r3.z);
        r3.z = r5.y ? r3.z : r5.x;
        r3.zw = r4.zw * r3.zz;
        r4.z = cmp(9.99999975e-05 >= abs(r3.z));
        r4.w = cmp(9.99999975e-05 < abs(r3.w));
        r3.zw = r4.xy / r3.zw;
        r3.w = r4.w ? r3.w : 0;
        r4.y = r4.z ? r3.w : r3.z;
        r4.z = 0;
        r4.yz = r3.xx ? r4.yz : v2.xy;
        r3.x = 255 * r3.y;
        r3.x = round(r3.x);
        r3.x = (int)r3.x;
        r3.y = cmp(r4.y >= -r4.y);
        r3.z = frac(abs(r4.y));
        r3.y = r3.y ? r3.z : -r3.z;
        r3.y = r3.x ? r4.y : r3.y;
        r3.xz = cmp((int2)r3.xx == int2(1,2));
        r3.w = saturate(r3.y);
        r3.x = r3.x ? r3.w : r3.y;
        r3.y = 0.5 * r3.x;
        r3.w = cmp(r3.y >= -r3.y);
        r3.y = frac(abs(r3.y));
        r3.y = r3.w ? r3.y : -r3.y;
        r3.w = r3.y + r3.y;
        r3.y = cmp(0.5 < r3.y);
        r4.y = cmp(r3.w >= -r3.w);
        r4.w = frac(abs(r3.w));
        r4.y = r4.y ? r4.w : -r4.w;
        r4.y = 1 + -r4.y;
        r3.y = r3.y ? r4.y : r3.w;
        r4.x = r3.z ? r3.y : r3.x;
        r2.z = cb0[2].x;
        r2.xy = r2.xy * cb0[2].xy + r2.zw;
        r3.xyzw = t9.SampleLevel(s0_s, r2.xy, 0).xyzw;
        r3.xyzw = float4(255,255,65025,65025) * r3.ywxz;
        r2.xy = r3.zw + r3.xy;
        r3.xy = float2(0.5,0.5) + r2.xy;
        r0.yw = r2.zw * float2(2,2) + r0.yw;
        r2.xyzw = t9.SampleLevel(s0_s, r0.yw, 0).xyzw;
        r2.xyzw = float4(255,255,65025,65025) * r2.ywxz;
        r3.zw = r2.zw + r2.xy;
        r2.xyzw = cb0[r0.x+4].yzyz * r3.xyzw;
        r0.xy = r4.xz * r2.zw + r2.xy;
        r0.w = cmp(v3.y < 4);
        if (r0.w != 0) {
          r0.w = cmp(v3.y < 2);
          if (r0.w != 0) {
            r0.w = cmp(v3.y < 1);
            if (r0.w != 0) {
              r2.xyzw = t0.Sample(s2_s, r0.xy).xyzw;
            } else {
              r2.xyzw = t1.Sample(s3_s, r0.xy).xyzw;
            }
          } else {
            r0.w = cmp(v3.y < 3);
            if (r0.w != 0) {
              r2.xyzw = t2.Sample(s4_s, r0.xy).xyzw;
            } else {
              r2.xyzw = t3.Sample(s5_s, r0.xy).xyzw;
            }
          }
        } else {
          r0.w = cmp(v3.y < 6);
          if (r0.w != 0) {
            r0.w = cmp(v3.y < 5);
            if (r0.w != 0) {
              r2.xyzw = t4.Sample(s6_s, r0.xy).xyzw;
            } else {
              r2.xyzw = t5.Sample(s7_s, r0.xy).xyzw;
            }
          } else {
            r0.w = cmp(v3.y < 7);
            if (r0.w != 0) {
              r2.xyzw = t6.Sample(s8_s, r0.xy).xyzw;
            } else {
              r2.xyzw = t7.Sample(s9_s, r0.xy).xyzw;
            }
          }
        }
        r1.xyzw = v1.wxyz * r2.wxyz;
        o0.xyz = r1.yzw;
      }
      r0.z = 1;
    }
  }
  r0.xy = cmp(abs(v2.zw) < float2(1.00010002,1.00010002));
  r0.x = r0.x ? r0.y : 0;
  r0.x = r0.x ? 1.000000 : 0;
  r0.y = r0.z * r0.x;
  r0.x = r0.z * r0.x + -0.00300000003;
  r0.x = cmp(r0.x < 0);
  if (r0.x != 0) discard;
  o0.w = r1.x * r0.y;
    o0 = saturate(o0);
  return;
}