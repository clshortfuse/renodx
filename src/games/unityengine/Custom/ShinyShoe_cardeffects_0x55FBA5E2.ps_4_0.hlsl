
Texture2D<float4> t13 : register(t13);
Texture2D<float4> t12 : register(t12);
Texture2D<float4> t11 : register(t11);
Texture2D<float4> t10 : register(t10);
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
SamplerState s13_s : register(s13);
SamplerState s12_s : register(s12);
SamplerState s11_s : register(s11);
SamplerState s10_s : register(s10);
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
cbuffer cb1 : register(b1){
  float4 cb1[1];
}
cbuffer cb0 : register(b0){
  float4 cb0[49];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  float4 v4 : TEXCOORD3,
  float4 v5 : TEXCOORD4,
  float4 v6 : TEXCOORD5,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cmp(v2.xy >= cb0[48].xy);
  r0.zw = cmp(cb0[48].zw >= v2.xy);
  r0.xyzw = r0.xyzw ? float4(1,1,1,1) : 0;
  r0.xy = r0.xy * r0.zw;
  r0.z = cmp(cb0[48].z < 0);
  r0.x = r0.x * r0.y + -0.00100000005;
  r0.x = cmp(r0.x < 0);
  r0.x = r0.z ? 0 : r0.x;
  if (r0.x != 0) discard;
  r0.xyzw = t0.Sample(s1_s, v1.xy).xyzw;
  r1.xyzw = t1.Sample(s0_s, v1.xy).xyzw;
  r0.xyzw = r1.xyzw * r0.xxxx;
  r1.xyzw = cb0[3].xyzw * r0.xyzw;
  r2.xy = cmp(float2(0,0) != cb0[14].zy);
  if (r2.x != 0) {
    r2.x = cmp(cb0[8].w == 1.000000);
    if (r2.x != 0) {
      r3.xyzw = t2.Sample(s4_s, v3.xy).xyzw;
      r4.xyzw = t3.Sample(s2_s, v3.xy).xyzw;
      r3.xyzw = r4.xyzw * r3.xxxx;
      r3.xyzw = cb0[9].xyzw * r3.xyzw;
    } else {
      r2.x = cmp(cb0[8].w == 2.000000);
      if (r2.x != 0) {
        r2.xz = cb1[0].xx + v3.xy;
        r4.xyzw = t4.Sample(s3_s, r2.xz).xyzw;
        r2.xz = float2(-0.5,-0.5) + r4.xy;
        r4.xyzw = t2.Sample(s4_s, v3.xy).xyzw;
        r2.xz = r2.xz * float2(0.0500000007,0.0500000007) + v3.xy;
        r5.xyzw = t3.Sample(s2_s, r2.xz).xyzw;
        r3.xyzw = r5.xyzw * r4.xxxx;
      } else {
        r2.x = cmp(cb0[8].w == 3.000000);
        if (r2.x != 0) {
          r4.xyzw = t4.Sample(s3_s, v3.xy).xyzw;
          r2.xz = max(float2(0.00100000005,0.00100000005), r4.xy);
          r2.xz = min(float2(0.999000013,0.999000013), r2.xz);
          r4.xy = cb0[13].xy * r2.xz;
          r4.z = -cb1[0].x * cb0[10].w + r4.y;
          r5.xyzw = t2.Sample(s4_s, v3.xy).xyzw;
          r6.xyzw = t3.Sample(s2_s, r4.xz).xyzw;
          r2.x = r6.x * r4.w;
          r2.x = r2.x * r5.x;
          r3.w = cb0[9].w * r2.x;
          r3.xyz = cb0[9].xyz;
        } else {
          r2.x = cmp(cb0[8].w == 4.000000);
          if (r2.x != 0) {
            r4.xyzw = t2.Sample(s4_s, v3.xy).xyzw;
            r5.xyzw = t3.Sample(s2_s, v3.zw).xyzw;
            r4.xyzw = r5.xyzw * r4.xxxx;
            r3.xyzw = cb0[9].xyzw * r4.xyzw;
          } else {
            r2.x = cmp(cb0[8].w == 5.000000);
            if (r2.x != 0) {
              r4.xyzw = t2.Sample(s4_s, v3.xy).xyzw;
              r5.xyzw = t4.Sample(s3_s, v3.xy).xyzw;
              r2.x = -cb0[10].x + r5.x;
              r2.zw = cmp(r2.xx < cb0[11].yx);
              r4.y = cmp(0 < cb0[10].x);
              r2.zw = r2.zw ? r4.yy : 0;
              r4.y = cb0[11].y + -r2.x;
              r4.y = r4.y / cb0[11].y;
              r4.y = 1 + -r4.y;
              r2.z = r2.z ? r4.y : 1;
              r5.xyzw = t3.Sample(s2_s, v3.xy).xyzw;
              r5.xyzw = r5.xyzw * r4.xxxx;
              r5.xyzw = r5.xyzw * r2.zzzz;
              r4.xyzw = cb0[9].xyzw * r4.xxxx;
              r4.xyzw = r4.xyzw * r2.zzzz;
              r4.xyzw = r2.wwww ? r4.xyzw : r5.xyzw;
              r2.x = cmp(r2.x < 0);
              r3.xyzw = r2.xxxx ? float4(0,0,0,0) : r4.xyzw;
            } else {
              r2.x = cmp(cb0[8].w == 6.000000);
              if (r2.x != 0) {
                r4.xyzw = t2.Sample(s4_s, v3.xy).xyzw;
                r2.x = cb0[10].z * cb1[0].x + cb0[10].x;
                r2.z = r2.x + r2.x;
                r2.z = cmp(r2.z >= -r2.z);
                r2.zw = r2.zz ? float2(2,0.5) : float2(-2,-0.5);
                r2.x = r2.x * r2.w;
                r2.x = frac(r2.x);
                r2.x = r2.z * r2.x + -1;
                r5.xyzw = t3.Sample(s2_s, v3.xy).xyzw;
                r5.xyzw = cb0[9].xyzw * r5.xyzw;
                r4.xyzw = r5.xyzw * r4.xxxx;
                r3.xyzw = r4.xyzw * abs(r2.xxxx);
              } else {
                r3.xyzw = float4(0,0,0,0);
              }
            }
          }
        }
      }
    }
  } else {
    r3.xyzw = float4(0,0,0,0);
  }
  r4.xyzw = r3.xyzw * r3.wwww;
  r5.xyzw = r0.xyzw * cb0[3].xyzw + r4.xyzw;
  r0.x = 1 + -r3.w;
  r4.xyz = r1.xyz * r0.xxx + r4.xyz;
  r4.w = r0.w * cb0[3].w + r3.w;
  r0.xyzw = r2.yyyy ? r5.xyzw : r4.xyzw;
  r1.x = cmp(r1.w < 0.00100000005);
  r0.xyzw = r1.xxxx ? r3.xyzw : r0.xyzw;
  r1.xy = cmp(float2(0,0) != cb0[24].zy);
  if (r1.x != 0) {
    r1.x = cmp(cb0[18].x == 1.000000);
    if (r1.x != 0) {
      r2.xyzw = t5.Sample(s7_s, v4.xy).xyzw;
      r3.xyzw = t6.Sample(s5_s, v4.xy).xyzw;
      r2.xyzw = r3.xyzw * r2.xxxx;
      r2.xyzw = cb0[19].xyzw * r2.xyzw;
    } else {
      r1.x = cmp(cb0[18].x == 2.000000);
      if (r1.x != 0) {
        r1.xz = cb1[0].xx + v4.xy;
        r3.xyzw = t7.Sample(s6_s, r1.xz).xyzw;
        r1.xz = float2(-0.5,-0.5) + r3.xy;
        r3.xyzw = t5.Sample(s7_s, v4.xy).xyzw;
        r1.xz = r1.xz * float2(0.0500000007,0.0500000007) + v4.xy;
        r4.xyzw = t6.Sample(s5_s, r1.xz).xyzw;
        r2.xyzw = r4.xyzw * r3.xxxx;
      } else {
        r1.x = cmp(cb0[18].x == 3.000000);
        if (r1.x != 0) {
          r3.xyzw = t7.Sample(s6_s, v4.xy).xyzw;
          r1.xz = max(float2(0.00100000005,0.00100000005), r3.xy);
          r1.xz = min(float2(0.999000013,0.999000013), r1.xz);
          r3.xy = cb0[23].xy * r1.xz;
          r3.z = -cb1[0].x * cb0[20].w + r3.y;
          r4.xyzw = t5.Sample(s7_s, v4.xy).xyzw;
          r5.xyzw = t6.Sample(s5_s, r3.xz).xyzw;
          r1.x = r5.x * r3.w;
          r1.x = r1.x * r4.x;
          r2.w = cb0[19].w * r1.x;
          r2.xyz = cb0[19].xyz;
        } else {
          r1.x = cmp(cb0[18].x == 4.000000);
          if (r1.x != 0) {
            r3.xyzw = t5.Sample(s7_s, v4.xy).xyzw;
            r4.xyzw = t6.Sample(s5_s, v4.zw).xyzw;
            r3.xyzw = r4.xyzw * r3.xxxx;
            r2.xyzw = cb0[19].xyzw * r3.xyzw;
          } else {
            r1.x = cmp(cb0[18].x == 5.000000);
            if (r1.x != 0) {
              r3.xyzw = t5.Sample(s7_s, v4.xy).xyzw;
              r4.xyzw = t7.Sample(s6_s, v4.xy).xyzw;
              r1.x = -cb0[20].x + r4.x;
              r1.zw = cmp(r1.xx < cb0[21].yx);
              r3.y = cmp(0 < cb0[20].x);
              r1.zw = r1.zw ? r3.yy : 0;
              r3.y = cb0[21].y + -r1.x;
              r3.y = r3.y / cb0[21].y;
              r3.y = 1 + -r3.y;
              r1.z = r1.z ? r3.y : 1;
              r4.xyzw = t6.Sample(s5_s, v4.xy).xyzw;
              r4.xyzw = r4.xyzw * r3.xxxx;
              r4.xyzw = r4.xyzw * r1.zzzz;
              r3.xyzw = cb0[19].xyzw * r3.xxxx;
              r3.xyzw = r3.xyzw * r1.zzzz;
              r3.xyzw = r1.wwww ? r3.xyzw : r4.xyzw;
              r1.x = cmp(r1.x < 0);
              r2.xyzw = r1.xxxx ? float4(0,0,0,0) : r3.xyzw;
            } else {
              r1.x = cmp(cb0[18].x == 6.000000);
              if (r1.x != 0) {
                r3.xyzw = t5.Sample(s7_s, v4.xy).xyzw;
                r1.x = cb0[20].z * cb1[0].x + cb0[20].x;
                r1.z = r1.x + r1.x;
                r1.z = cmp(r1.z >= -r1.z);
                r1.zw = r1.zz ? float2(2,0.5) : float2(-2,-0.5);
                r1.x = r1.x * r1.w;
                r1.x = frac(r1.x);
                r1.x = r1.z * r1.x + -1;
                r4.xyzw = t6.Sample(s5_s, v4.xy).xyzw;
                r4.xyzw = cb0[19].xyzw * r4.xyzw;
                r3.xyzw = r4.xyzw * r3.xxxx;
                r2.xyzw = r3.xyzw * abs(r1.xxxx);
              } else {
                r2.xyzw = float4(0,0,0,0);
              }
            }
          }
        }
      }
    }
  } else {
    r2.xyzw = float4(0,0,0,0);
  }
  r1.xzw = r2.xyz * r2.www;
  r3.xyzw = r2.xyzw * r2.wwww + r0.xyzw;
  r2.x = 1 + -r2.w;
  r4.xyz = r0.xyz * r2.xxx + r1.xzw;
  r4.w = r2.w + r0.w;
  r0.xyzw = r1.yyyy ? r3.xyzw : r4.xyzw;
  r1.xy = cmp(float2(0,0) != cb0[34].zy);
  if (r1.x != 0) {
    r1.x = cmp(cb0[28].x == 1.000000);
    if (r1.x != 0) {
      r2.xyzw = t8.Sample(s10_s, v5.xy).xyzw;
      r3.xyzw = t9.Sample(s8_s, v5.xy).xyzw;
      r2.xyzw = r3.xyzw * r2.xxxx;
      r2.xyzw = cb0[29].xyzw * r2.xyzw;
    } else {
      r1.x = cmp(cb0[28].x == 2.000000);
      if (r1.x != 0) {
        r1.xz = cb1[0].xx + v5.xy;
        r3.xyzw = t10.Sample(s9_s, r1.xz).xyzw;
        r1.xz = float2(-0.5,-0.5) + r3.xy;
        r3.xyzw = t8.Sample(s10_s, v5.xy).xyzw;
        r1.xz = r1.xz * float2(0.0500000007,0.0500000007) + v5.xy;
        r4.xyzw = t9.Sample(s8_s, r1.xz).xyzw;
        r2.xyzw = r4.xyzw * r3.xxxx;
      } else {
        r1.x = cmp(cb0[28].x == 3.000000);
        if (r1.x != 0) {
          r3.xyzw = t10.Sample(s9_s, v5.xy).xyzw;
          r1.xz = max(float2(0.00100000005,0.00100000005), r3.xy);
          r1.xz = min(float2(0.999000013,0.999000013), r1.xz);
          r3.xy = cb0[33].xy * r1.xz;
          r3.z = -cb1[0].x * cb0[30].w + r3.y;
          r4.xyzw = t8.Sample(s10_s, v5.xy).xyzw;
          r5.xyzw = t9.Sample(s8_s, r3.xz).xyzw;
          r1.x = r5.x * r3.w;
          r1.x = r1.x * r4.x;
          r2.w = cb0[29].w * r1.x;
          r2.xyz = cb0[29].xyz;
        } else {
          r1.x = cmp(cb0[28].x == 4.000000);
          if (r1.x != 0) {
            r3.xyzw = t8.Sample(s10_s, v5.xy).xyzw;
            r4.xyzw = t9.Sample(s8_s, v5.zw).xyzw;
            r3.xyzw = r4.xyzw * r3.xxxx;
            r2.xyzw = cb0[29].xyzw * r3.xyzw;
          } else {
            r1.x = cmp(cb0[28].x == 5.000000);
            if (r1.x != 0) {
              r3.xyzw = t8.Sample(s10_s, v5.xy).xyzw;
              r4.xyzw = t10.Sample(s9_s, v5.xy).xyzw;
              r1.x = -cb0[30].x + r4.x;
              r1.zw = cmp(r1.xx < cb0[31].yx);
              r3.y = cmp(0 < cb0[30].x);
              r1.zw = r1.zw ? r3.yy : 0;
              r3.y = cb0[31].y + -r1.x;
              r3.y = r3.y / cb0[31].y;
              r3.y = 1 + -r3.y;
              r1.z = r1.z ? r3.y : 1;
              r4.xyzw = t9.Sample(s8_s, v5.xy).xyzw;
              r4.xyzw = r4.xyzw * r3.xxxx;
              r4.xyzw = r4.xyzw * r1.zzzz;
              r3.xyzw = cb0[29].xyzw * r3.xxxx;
              r3.xyzw = r3.xyzw * r1.zzzz;
              r3.xyzw = r1.wwww ? r3.xyzw : r4.xyzw;
              r1.x = cmp(r1.x < 0);
              r2.xyzw = r1.xxxx ? float4(0,0,0,0) : r3.xyzw;
            } else {
              r1.x = cmp(cb0[28].x == 6.000000);
              if (r1.x != 0) {
                r3.xyzw = t8.Sample(s10_s, v5.xy).xyzw;
                r1.x = cb0[30].z * cb1[0].x + cb0[30].x;
                r1.z = r1.x + r1.x;
                r1.z = cmp(r1.z >= -r1.z);
                r1.zw = r1.zz ? float2(2,0.5) : float2(-2,-0.5);
                r1.x = r1.x * r1.w;
                r1.x = frac(r1.x);
                r1.x = r1.z * r1.x + -1;
                r4.xyzw = t9.Sample(s8_s, v5.xy).xyzw;
                r4.xyzw = cb0[29].xyzw * r4.xyzw;
                r3.xyzw = r4.xyzw * r3.xxxx;
                r2.xyzw = r3.xyzw * abs(r1.xxxx);
              } else {
                r2.xyzw = float4(0,0,0,0);
              }
            }
          }
        }
      }
    }
  } else {
    r2.xyzw = float4(0,0,0,0);
  }
  r1.xzw = r2.xyz * r2.www;
  r3.xyzw = r2.xyzw * r2.wwww + r0.xyzw;
  r2.x = 1 + -r2.w;
  r4.xyz = r0.xyz * r2.xxx + r1.xzw;
  r4.w = r2.w + r0.w;
  r0.xyzw = r1.yyyy ? r3.xyzw : r4.xyzw;
  r1.xy = cmp(float2(0,0) != cb0[44].zy);
  if (r1.x != 0) {
    r1.x = cmp(cb0[38].x == 1.000000);
    if (r1.x != 0) {
      r2.xyzw = t11.Sample(s13_s, v6.xy).xyzw;
      r3.xyzw = t12.Sample(s11_s, v6.xy).xyzw;
      r2.xyzw = r3.xyzw * r2.xxxx;
      r2.xyzw = cb0[39].xyzw * r2.xyzw;
    } else {
      r1.x = cmp(cb0[38].x == 2.000000);
      if (r1.x != 0) {
        r1.xz = cb1[0].xx + v6.xy;
        r3.xyzw = t13.Sample(s12_s, r1.xz).xyzw;
        r1.xz = float2(-0.5,-0.5) + r3.xy;
        r3.xyzw = t11.Sample(s13_s, v6.xy).xyzw;
        r1.xz = r1.xz * float2(0.0500000007,0.0500000007) + v6.xy;
        r4.xyzw = t12.Sample(s11_s, r1.xz).xyzw;
        r2.xyzw = r4.xyzw * r3.xxxx;
      } else {
        r1.x = cmp(cb0[38].x == 3.000000);
        if (r1.x != 0) {
          r3.xyzw = t13.Sample(s12_s, v6.xy).xyzw;
          r1.xz = max(float2(0.00100000005,0.00100000005), r3.xy);
          r1.xz = min(float2(0.999000013,0.999000013), r1.xz);
          r3.xy = cb0[43].xy * r1.xz;
          r3.z = -cb1[0].x * cb0[40].w + r3.y;
          r4.xyzw = t11.Sample(s13_s, v6.xy).xyzw;
          r5.xyzw = t12.Sample(s11_s, r3.xz).xyzw;
          r1.x = r5.x * r3.w;
          r1.x = r1.x * r4.x;
          r2.w = cb0[39].w * r1.x;
          r2.xyz = cb0[39].xyz;
        } else {
          r1.x = cmp(cb0[38].x == 4.000000);
          if (r1.x != 0) {
            r3.xyzw = t11.Sample(s13_s, v6.xy).xyzw;
            r4.xyzw = t12.Sample(s11_s, v6.zw).xyzw;
            r3.xyzw = r4.xyzw * r3.xxxx;
            r2.xyzw = cb0[39].xyzw * r3.xyzw;
          } else {
            r1.x = cmp(cb0[38].x == 5.000000);
            if (r1.x != 0) {
              r3.xyzw = t11.Sample(s13_s, v6.xy).xyzw;
              r4.xyzw = t13.Sample(s12_s, v6.xy).xyzw;
              r1.x = -cb0[40].x + r4.x;
              r1.zw = cmp(r1.xx < cb0[41].yx);
              r3.y = cmp(0 < cb0[40].x);
              r1.zw = r1.zw ? r3.yy : 0;
              r3.y = cb0[41].y + -r1.x;
              r3.y = r3.y / cb0[41].y;
              r3.y = 1 + -r3.y;
              r1.z = r1.z ? r3.y : 1;
              r4.xyzw = t12.Sample(s11_s, v6.xy).xyzw;
              r4.xyzw = r4.xyzw * r3.xxxx;
              r4.xyzw = r4.xyzw * r1.zzzz;
              r3.xyzw = cb0[39].xyzw * r3.xxxx;
              r3.xyzw = r3.xyzw * r1.zzzz;
              r3.xyzw = r1.wwww ? r3.xyzw : r4.xyzw;
              r1.x = cmp(r1.x < 0);
              r2.xyzw = r1.xxxx ? float4(0,0,0,0) : r3.xyzw;
            } else {
              r1.x = cmp(cb0[38].x == 6.000000);
              if (r1.x != 0) {
                r3.xyzw = t11.Sample(s13_s, v6.xy).xyzw;
                r1.x = cb0[40].z * cb1[0].x + cb0[40].x;
                r1.z = r1.x + r1.x;
                r1.z = cmp(r1.z >= -r1.z);
                r1.zw = r1.zz ? float2(2,0.5) : float2(-2,-0.5);
                r1.x = r1.x * r1.w;
                r1.x = frac(r1.x);
                r1.x = r1.z * r1.x + -1;
                r4.xyzw = t12.Sample(s11_s, v6.xy).xyzw;
                r4.xyzw = cb0[39].xyzw * r4.xyzw;
                r3.xyzw = r4.xyzw * r3.xxxx;
                r2.xyzw = r3.xyzw * abs(r1.xxxx);
              } else {
                r2.xyzw = float4(0,0,0,0);
              }
            }
          }
        }
      }
    }
  } else {
    r2.xyzw = float4(0,0,0,0);
  }
  r1.xzw = r2.xyz * r2.www;
  r3.xyzw = r2.xyzw * r2.wwww + r0.xyzw;
  r2.x = 1 + -r2.w;
  r4.xyz = r0.xyz * r2.xxx + r1.xzw;
  r4.w = r2.w + r0.w;
  o0.xyzw = r1.yyyy ? r3.xyzw : r4.xyzw;
  o0.w = saturate(o0.w);
  return;
}