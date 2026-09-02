#include "./tonemap.hlsli"

// ---- Created with 3Dmigoto v1.4.1 on Mon Jun 22 00:51:51 2026
Texture3D<float4> t1 : register(t1);

Texture3D<float4> t0 : register(t0);

RWTexture3D<float4> u0 : register(u0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[11];
}

// 3Dmigoto declarations
#define cmp -

[numthreads(33, 3, 1)]
void main(uint3 vThreadID: SV_DispatchThreadID) {
  const float4 icb[] = { { -4.000000, -0.718548, 0, 0 },
                         { -4.000000, 2.081031, 0, 0 },
                         { -3.157377, 3.668124, 0, 0 },
                         { -0.485250, 4.000000, 0, 0 },
                         { 1.847733, 4.000000, 0, 0 },
                         { 1.847733, 4.000000, 0, 0 } };
  float4 r0, r1, r2, r3, r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = (float3)vThreadID.xyz;
  r0.xyz = float3(0.03125, 0.03125, 0.03125) * r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(0.0126833133, 0.0126833133, 0.0126833133) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r1.xyz = float3(-0.8359375, -0.8359375, -0.8359375) + r0.xyz;
  r1.xyz = max(float3(0, 0, 0), r1.xyz);
  r0.xyz = -r0.xyz * float3(18.6875, 18.6875, 18.6875) + float3(18.8515625, 18.8515625, 18.8515625);
  r0.xyz = r1.xyz / r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(6.27739477, 6.27739477, 6.27739477) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = float3(100, 100, 100) * r0.xyz;
  r1.x = dot(float3(0.412391007, 0.357584, 0.180481002), r0.xyz);
  r1.y = dot(float3(0.212639004, 0.715169013, 0.0721919984), r0.xyz);
  r1.z = dot(float3(0.0193310007, 0.119194999, 0.950532019), r0.xyz);
  r0.x = dot(float2(1.04981101, -9.74845025e-05), r1.xz);
  r0.y = dot(float3(-0.495903015, 1.37331307, 0.0982400328), r1.xyz);
  r0.z = r1.z;
  r0.xyz = float3(0.00999999978, 0.00999999978, 0.00991251972) * r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(0.159301758, 0.159301758, 0.159301758) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r1.xyz = r0.xyz * float3(18.8515625, 18.8515625, 18.8515625) + float3(0.8359375, 0.8359375, 0.8359375);
  r0.xyz = r0.xyz * float3(18.6875, 18.6875, 18.6875) + float3(1, 1, 1);
  r0.xyz = r1.xyz / r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(78.84375, 78.84375, 78.84375) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = min(float3(1, 1, 1), r0.xyz);
  r0.xyz = r0.xyz * float3(0.969696999, 0.969696999, 0.969696999) + float3(0.0151515156, 0.0151515156, 0.0151515156);
  r0.w = 1 + -r0.y;
  r1.xyz = t0.SampleLevel(s0_s, r0.xwz, 0).xyz;
  r0.xyz = t1.SampleLevel(s0_s, r0.xwz, 0).xyz;
  r0.xyz = r0.xyz + -r1.xyz;
  r0.xyz = cb0[10].xyz * r0.xyz + r1.xyz;
  r0.w = 1;
  r1.y = dot(r0.xyzw, cb0[0].xyzw);
  r1.z = dot(r0.xyzw, cb0[1].xyzw);
  r1.w = dot(r0.xyzw, cb0[2].xyzw);
  r0.x = cmp(cb0[5].w != 0.000000);
  if (r0.x != 0) {
    r0.xyz = min(cb0[5].www, r1.yzw);
    r0.xyz = r0.xyz / cb0[5].www;
    r2.xyz = float3(1, 1, 1) + -cb0[5].xyz;
    r0.xyz = r0.xyz * r2.xyz + cb0[5].xyz;
  } else {
    r0.xyz = cb0[5].xyz;
  }
  r1.xyz = max(float3(0, 0, 0), r1.yzw);
  r1.xyz = log2(r1.xyz);
  r0.xyz = r1.xyz * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.w = -1 + cb0[6].x;
  r0.xyz = r0.www * cb0[6].zzz + r0.xyz;
  r0.xyz = max(float3(0, 0, 0), r0.xyz);
  r0.xyz = log2(r0.xyz);
  r0.xyz = cb0[6].yyy * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.w = cb0[6].x * cb0[6].w;
  r0.w = min(1, r0.w);
  r0.xyz = r0.xyz * r0.www;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(0.0126833133, 0.0126833133, 0.0126833133) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r1.xyz = float3(-0.8359375, -0.8359375, -0.8359375) + r0.xyz;
  r1.xyz = max(float3(0, 0, 0), r1.xyz);
  r0.xyz = -r0.xyz * float3(18.6875, 18.6875, 18.6875) + float3(18.8515625, 18.8515625, 18.8515625);
  r0.xyz = r1.xyz / r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(6.27739477, 6.27739477, 6.27739477) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r1.xyz = float3(100, 100, 100) * r0.xyz;
  r0.w = max(r1.x, r1.y);
  r0.w = max(r0.w, r1.z);
  r1.w = min(r1.x, r1.y);
  r1.w = min(r1.w, r1.z);
  r2.xy = max(float2(1.00000001e-10, 0.00999999978), r0.ww);
  r0.w = max(1.00000001e-10, r1.w);
  r0.w = r2.x + -r0.w;
  r0.w = r0.w / r2.y;
  r2.xyz = r0.zyx * float3(100, 100, 100) + -r1.yxz;
  r0.yz = r2.xy * r1.zy;
  r0.y = r0.y + r0.z;
  r0.y = r1.x * r2.z + r0.y;
  r0.y = max(0, r0.y);
  r0.y = sqrt(r0.y);
  r0.z = r1.z + r1.y;
  r0.x = r0.x * 100 + r0.z;
  r0.x = r0.y * 1.75 + r0.x;
  r0.y = -0.400000006 + r0.w;
  r0.z = 2.5 * r0.y;
  r0.z = 1 + -abs(r0.z);
  r0.z = max(0, r0.z);
  r1.w = cmp(0 < r0.y);
  r0.y = cmp(r0.y < 0);
  r0.y = (int)-r1.w + (int)r0.y;
  r0.y = (int)r0.y;
  r0.z = -r0.z * r0.z + 1;
  r0.y = r0.y * r0.z + 1;
  r0.y = 0.0250000004 * r0.y;
  r0.z = cmp(0.159999996 >= r0.x);
  if (r0.z == 0) {
    r0.z = cmp(r0.x >= 0.479999989);
    if (r0.z != 0) {
      r0.y = 0;
    } else {
      r0.x = 0.333333343 * r0.x;
      r0.x = 0.0799999982 / r0.x;
      r0.x = -0.5 + r0.x;
      r0.y = r0.y * r0.x;
    }
  }
  r0.x = 1 + r0.y;
  r2.yzw = r1.xyz * r0.xxx;
  r0.yz = cmp(r2.zw == r2.yz);
  r0.y = (r0.z != 0) ? r0.y : 0;
  if (r0.y != 0) {
    r0.y = 0;
  } else {
    r0.z = r1.y * r0.x + -r2.w;
    r0.z = 1.73205078 * r0.z;
    r1.y = r2.y * 2 + -r2.z;
    r1.y = -r1.z * r0.x + r1.y;
    r1.z = min(abs(r1.y), abs(r0.z));
    r1.w = max(abs(r1.y), abs(r0.z));
    r1.w = 1 / r1.w;
    r1.z = r1.z * r1.w;
    r1.w = r1.z * r1.z;
    r3.x = r1.w * 0.0208350997 + -0.0851330012;
    r3.x = r1.w * r3.x + 0.180141002;
    r3.x = r1.w * r3.x + -0.330299497;
    r1.w = r1.w * r3.x + 0.999866009;
    r3.x = r1.z * r1.w;
    r3.y = cmp(abs(r1.y) < abs(r0.z));
    r3.x = r3.x * -2 + 1.57079637;
    r3.x = (r3.y != 0) ? r3.x : 0;
    r1.z = r1.z * r1.w + r3.x;
    r1.w = cmp(r1.y < -r1.y);
    r1.w = (r1.w != 0) ? -3.141593 : 0;
    r1.z = r1.z + r1.w;
    r1.w = min(r1.y, r0.z);
    r0.z = max(r1.y, r0.z);
    r1.y = cmp(r1.w < -r1.w);
    r0.z = cmp(r0.z >= -r0.z);
    r0.z = (r0.z != 0) ? r1.y : 0;
    r0.z = (r0.z != 0) ? -r1.z : r1.z;
    r0.y = 57.2957802 * r0.z;
  }
  r0.z = cmp(r0.y < 0);
  if (r0.z != 0) {
    r0.y = 360 + r0.y;
  }
  r0.z = cmp(r0.y < -180);
  if (r0.z != 0) {
    r0.y = 360 + r0.y;
  } else {
    r0.z = cmp(180 < r0.y);
    if (r0.z != 0) {
      r0.y = -360 + r0.y;
    }
  }
  r0.z = cmp(-67.5 < r0.y);
  r1.y = cmp(r0.y < 67.5);
  r0.z = (r0.z != 0) ? r1.y : 0;
  if (r0.z != 0) {
    r0.y = 67.5 + r0.y;
    r0.z = 0.0296296291 * r0.y;
    r1.y = (int)r0.z;
    r0.z = trunc(r0.z);
    r0.y = r0.y * 0.0296296291 + -r0.z;
    r0.z = r0.y * r0.y;
    r1.z = r0.z * r0.y;
    r1.w = cmp((int)r1.y == 3);
    if (r1.w != 0) {
      r1.w = 0.5 * r0.z;
      r1.w = r1.z * -0.166666672 + r1.w;
      r1.w = r0.y * -0.5 + r1.w;
      r1.w = 0.166666672 + r1.w;
    } else {
      r3.x = cmp((int)r1.y == 2);
      if (r3.x != 0) {
        r3.x = r1.z * 0.5 + -r0.z;
        r1.w = 0.666666687 + r3.x;
      } else {
        r3.x = cmp((int)r1.y == 1);
        if (r3.x != 0) {
          r0.z = 0.5 * r0.z;
          r0.z = r1.z * -0.5 + r0.z;
          r0.y = r0.y * 0.5 + r0.z;
          r1.w = 0.166666672 + r0.y;
        } else {
          if (r1.y == 0) {
            r1.w = 0.166666672 * r1.z;
          } else {
            r1.w = 0;
          }
        }
      }
    }
  } else {
    r1.w = 0;
  }
  r0.y = r1.w * r0.w;
  r0.y = 1.5 * r0.y;
  r0.x = -r1.x * r0.x + 0.0299999993;
  r0.x = r0.y * r0.x;
  r2.x = r0.x * 0.180000007 + r2.y;
  r0.x = dot(float3(1.45143926, -0.236510754, -0.214928567), r2.xzw);
  r0.y = dot(float3(-0.0765537769, 1.17622972, -0.0996759236), r2.xzw);
  r0.z = dot(float3(0.00831614807, -0.00603244966, 0.997716308), r2.xzw);
  r0.xyz = max(float3(0, 0, 0), r0.xyz);
  r0.xyz = min(float3(65504, 65504, 65504), r0.xyz);
  r0.w = dot(float3(0.970889151, 0.0269632842, 0.00214758189), r0.xyz);
  r1.x = dot(float3(0.0108891549, 0.986963272, 0.00214758189), r0.xyz);
  r0.x = dot(float3(0.0108891549, 0.0269632842, 0.962147534), r0.xyz);

  // SSTS begin
  float3 untonemapped_ap1 = float3(r0.w, r1.x, r0.x);

  if (TONE_MAP_TYPE != 0.f) {
    r1.rgb = ApplyToneMap(untonemapped_ap1);
  } else {
    r0.xy = max(float2(5.9605e-08, 5.9605e-08), r0.xw);
    r0.y = log2(r0.y);
    r0.z = cmp(-18.5941105 >= r0.y);
    if (r0.z != 0) {
      r0.z = -4;
    } else {
      r0.w = cmp(r0.y < -3.59411049);
      if (r0.w != 0) {
        r0.w = r0.y * 0.30103001 + 5.59738493;
        r1.y = 0.664385557 * r0.w;
        r1.z = (int)r1.y;
        r1.y = trunc(r1.y);
        r2.y = r0.w * 0.664385557 + -r1.y;
        r1.yw = (int2)r1.zz + int2(1, 2);
        r2.x = r2.y * r2.y;
        r3.x = icb[(int)r1.z + 0].x;
        r3.y = icb[(int)r1.y + 0].x;
        r3.z = icb[(int)r1.w + 0].x;
        r4.x = dot(float3(0.5, -1, 0.5), r3.xyz);
        r4.y = dot(float2(-1, 1), r3.xy);
        r4.z = dot(float2(0.5, 0.5), r3.xy);
        r2.z = 1;
        r0.z = dot(r2.xyz, r4.xyz);
      } else {
        r0.w = cmp(r0.y < 14.4214821);
        if (r0.w != 0) {
          r0.y = r0.y * 0.30103001 + 1.08193505;
          r0.w = 0.553175509 * r0.y;
          r1.y = (int)r0.w;
          r0.w = trunc(r0.w);
          r2.y = r0.y * 0.553175509 + -r0.w;
          r0.yw = (int2)r1.yy + int2(1, 2);
          r2.x = r2.y * r2.y;
          r3.x = icb[(int)r1.y + 0].y;
          r3.y = icb[(int)r0.y + 0].y;
          r3.z = icb[(int)r0.w + 0].y;
          r4.x = dot(float3(0.5, -1, 0.5), r3.xyz);
          r4.y = dot(float2(-1, 1), r3.xy);
          r4.z = dot(float2(0.5, 0.5), r3.xy);
          r2.z = 1;
          r0.z = dot(r2.xyz, r4.xyz);
        } else {
          r0.z = 4;
        }
      }
    }
    r0.y = 3.32192802 * r0.z;
    r0.y = exp2(r0.y);
    r0.z = max(5.9605e-08, r1.x);
    r0.z = log2(r0.z);
    r0.w = cmp(-18.5941105 >= r0.z);
    if (r0.w != 0) {
      r0.w = -4;
    } else {
      r1.x = cmp(r0.z < -3.59411049);
      if (r1.x != 0) {
        r1.x = r0.z * 0.30103001 + 5.59738493;
        r1.y = 0.664385557 * r1.x;
        r1.z = (int)r1.y;
        r1.y = trunc(r1.y);
        r2.y = r1.x * 0.664385557 + -r1.y;
        r1.xy = (int2)r1.zz + int2(1, 2);
        r2.x = r2.y * r2.y;
        r3.x = icb[(int)r1.z + 0].x;
        r3.y = icb[(int)r1.x + 0].x;
        r3.z = icb[(int)r1.y + 0].x;
        r1.x = dot(float3(0.5, -1, 0.5), r3.xyz);
        r1.y = dot(float2(-1, 1), r3.xy);
        r1.z = dot(float2(0.5, 0.5), r3.xy);
        r2.z = 1;
        r0.w = dot(r2.xyz, r1.xyz);
      } else {
        r1.x = cmp(r0.z < 14.4214821);
        if (r1.x != 0) {
          r0.z = r0.z * 0.30103001 + 1.08193505;
          r1.x = 0.553175509 * r0.z;
          r1.y = (int)r1.x;
          r1.x = trunc(r1.x);
          r2.y = r0.z * 0.553175509 + -r1.x;
          r1.xz = (int2)r1.yy + int2(1, 2);
          r2.x = r2.y * r2.y;
          r3.x = icb[(int)r1.y + 0].y;
          r3.y = icb[(int)r1.x + 0].y;
          r3.z = icb[(int)r1.z + 0].y;
          r1.x = dot(float3(0.5, -1, 0.5), r3.xyz);
          r1.y = dot(float2(-1, 1), r3.xy);
          r1.z = dot(float2(0.5, 0.5), r3.xy);
          r2.z = 1;
          r0.w = dot(r2.xyz, r1.xyz);
        } else {
          r0.w = 4;
        }
      }
    }
    r0.z = 3.32192802 * r0.w;
    r0.z = exp2(r0.z);
    r0.x = log2(r0.x);
    r0.w = cmp(-18.5941105 >= r0.x);
    if (r0.w != 0) {
      r0.w = -4;
    } else {
      r1.x = cmp(r0.x < -3.59411049);
      if (r1.x != 0) {
        r1.x = r0.x * 0.30103001 + 5.59738493;
        r1.y = 0.664385557 * r1.x;
        r1.z = (int)r1.y;
        r1.y = trunc(r1.y);
        r2.y = r1.x * 0.664385557 + -r1.y;
        r1.xy = (int2)r1.zz + int2(1, 2);
        r2.x = r2.y * r2.y;
        r3.x = icb[(int)r1.z + 0].x;
        r3.y = icb[(int)r1.x + 0].x;
        r3.z = icb[(int)r1.y + 0].x;
        r1.x = dot(float3(0.5, -1, 0.5), r3.xyz);
        r1.y = dot(float2(-1, 1), r3.xy);
        r1.z = dot(float2(0.5, 0.5), r3.xy);
        r2.z = 1;
        r0.w = dot(r2.xyz, r1.xyz);
      } else {
        r1.x = cmp(r0.x < 14.4214821);
        if (r1.x != 0) {
          r0.x = r0.x * 0.30103001 + 1.08193505;
          r1.x = 0.553175509 * r0.x;
          r1.y = (int)r1.x;
          r1.x = trunc(r1.x);
          r2.y = r0.x * 0.553175509 + -r1.x;
          r1.xz = (int2)r1.yy + int2(1, 2);
          r2.x = r2.y * r2.y;
          r3.x = icb[(int)r1.y + 0].y;
          r3.y = icb[(int)r1.x + 0].y;
          r3.z = icb[(int)r1.z + 0].y;
          r1.x = dot(float3(0.5, -1, 0.5), r3.xyz);
          r1.y = dot(float2(-1, 1), r3.xy);
          r1.z = dot(float2(0.5, 0.5), r3.xy);
          r2.z = 1;
          r0.w = dot(r2.xyz, r1.xyz);
        } else {
          r0.w = 4;
        }
      }
    }
    r0.x = 3.32192802 * r0.w;
    r0.x = exp2(r0.x);
    r0.xy = float2(-9.99999975e-05, -9.99999975e-05) + r0.xy;
    r1.x = 9.99999975e-05 * r0.y;
    r0.y = -9.99999975e-05 + r0.z;
    r1.yz = float2(9.99999975e-05, 9.99999975e-05) * r0.yx;
  }

  r0.x = dot(float3(0.662454188, 0.134004205, 0.156187683), r1.xyz);
  r0.y = dot(float3(0.272228718, 0.674081743, 0.0536895171), r1.xyz);
  r0.z = dot(float3(-0.00557464967, 0.0040607336, 1.01033914), r1.xyz);
  r1.x = dot(float3(0.987223983, -0.00611326983, 0.0159533005), r0.xyz);
  r1.y = dot(float3(-0.00759836007, 1.00186002, 0.0053300201), r0.xyz);
  r1.z = dot(float3(0.00307257008, -0.00509594986, 1.08168006), r0.xyz);
  r0.x = dot(float3(3.24045491, -1.53713882, -0.49853155), r1.xyz);
  r0.y = dot(float3(-0.969266415, 1.87601089, 0.0415560827), r1.xyz);
  r0.z = dot(float3(0.0556434207, -0.20402585, 1.05722511), r1.xyz);
  if (TONE_MAP_TYPE == 0.f) {
    r0.xyz = max(float3(0, 0, 0), r0.xyz);
  }
  r0.xyz = min(float3(65504, 65504, 65504), r0.xyz);
  r0.w = 1;
  u0[vThreadID.xyz] = r0.xyzw;
  return;
}
