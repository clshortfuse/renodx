// ---- Created with 3Dmigoto v1.4.1 on Tue Aug 12 13:03:53 2025
Texture2D<float4> t7 : register(t7);

Texture2D<float4> t6 : register(t6);

Texture2D<float4> t5 : register(t5);

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<uint4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s6_s : register(s6);

SamplerState s5_s : register(s5);

SamplerState s4_s : register(s4);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2)
{
  float4 cb2[24];
}

cbuffer cb1 : register(b1)
{
  float4 cb1[136];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[39];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = asuint(cb0[37].xy);
  r0.xy = v0.xy + -r0.xy;
  r0.zw = cb0[38].zw * r0.xy;
  r1.xy = r0.zw * cb0[5].xy + cb0[4].xy;
  r2.xyz = t7.Sample(s6_s, r1.xy).xyz;
  r1.xyz = t7.Sample(s5_s, r1.xy).xyz;
  r3.xyz = float3(1,1,1) + -r1.xyz;
  r4.xy = r0.xy * cb0[38].zw + cb2[1].yz;
  r0.xy = r0.xy * cb0[38].zw + -r4.xy;
  r5.x = dot(r0.xy, cb2[3].yz);
  r5.y = dot(r0.xy, cb2[4].xy);
  r0.xy = r5.xy + r4.xy;
  r0.xy = cb2[5].xy + r0.xy;
  r4.xy = r0.xy * cb2[5].ww + float2(0.5,0.5);
  r4.xy = saturate(-cb2[6].xx + r4.xy);
  r4.xy = float2(-0.5,-0.5) + r4.xy;
  r1.w = cb1[22].y + cb1[22].z;
  r1.w = cb1[22].x + r1.w;
  r1.w = 100 * r1.w;
  r2.w = cb2[6].z * r1.w;
  r2.w = 6.28318548 * r2.w;
  sincos(r2.w, r5.x, r6.x);
  r7.x = -r5.x;
  r7.y = r6.x;
  r6.x = dot(r4.yx, r7.xy);
  r7.z = r5.x;
  r6.y = dot(r4.yx, r7.yz);
  r4.xy = float2(0.5,0.5) + r6.xy;
  r4.xyz = t3.Sample(s1_s, r4.xy).xyz;
  r4.xyz = cb2[8].xyz * r4.xyz;
  r5.xy = r0.xy * cb2[9].yy + float2(0.5,0.5);
  r5.xy = saturate(-cb2[9].zz + r5.xy);
  r5.xy = float2(-0.5,-0.5) + r5.xy;
  r2.w = cb2[10].x * r1.w;
  r2.w = 6.28318548 * r2.w;
  sincos(r2.w, r6.x, r7.x);
  r8.x = -r6.x;
  r8.y = r7.x;
  r7.x = dot(r5.yx, r8.xy);
  r8.z = r6.x;
  r7.y = dot(r5.yx, r8.yz);
  r5.xy = float2(0.5,0.5) + r7.xy;
  r5.xyz = t4.Sample(s2_s, r5.xy).xyz;
  r5.xyz = cb2[12].xyz * r5.xyz;
  r0.xy = r0.xy * cb2[13].yy + float2(0.5,0.5);
  r0.xy = saturate(-cb2[13].zz + r0.xy);
  r0.xy = float2(-0.5,-0.5) + r0.xy;
  r1.w = cb2[14].x * r1.w;
  r1.w = 6.28318548 * r1.w;
  sincos(r1.w, r6.x, r7.x);
  r8.x = -r6.x;
  r8.y = r7.x;
  r7.x = dot(r0.yx, r8.xy);
  r8.z = r6.x;
  r7.y = dot(r0.yx, r8.yz);
  r0.xy = float2(0.5,0.5) + r7.xy;
  r6.xyz = t5.Sample(s3_s, r0.xy).xyz;
  r6.xyz = cb2[16].xyz * r6.xyz;
  r6.xyz = cb2[16].www * r6.xyz;
  r5.xyz = r5.xyz * cb2[12].www + r6.xyz;
  r4.xyz = r4.xyz * cb2[8].www + r5.xyz;
  r4.xyz = -r4.xyz * cb2[17].yyy + float3(1,1,1);
  r4.xyz = -r3.xyz * r4.xyz + float3(1,1,1);
  r0.xy = r0.zw * cb1[129].xy + cb1[128].xy;
  r0.xy = cb1[132].zw * r0.xy;
  r1.w = t1.SampleLevel(s0_s, r0.xy, 0).x;
  r2.w = r1.w * cb1[71].x + cb1[71].y;
  r1.w = r1.w * cb1[71].z + -cb1[71].w;
  r1.w = 1 / r1.w;
  r1.w = r2.w + r1.w;
  r5.xy = cb1[132].xy * r0.xy;
  r5.xy = cb1[135].xy * r5.xy;
  r5.xy = trunc(r5.xy);
  r5.xy = (int2)r5.xy;
  r5.zw = float2(0,0);
  r2.w = t2.Load(r5.xyz).y;
  r2.w = (uint)r2.w;
  r0.x = t0.SampleLevel(s0_s, r0.xy, 0).x;
  r0.y = r0.x * cb1[71].x + cb1[71].y;
  r0.x = r0.x * cb1[71].z + -cb1[71].w;
  r0.x = 1 / r0.x;
  r0.x = r0.y + r0.x;
  r0.y = -cb2[17].w + r2.w;
  r0.y = cmp(9.99999975e-06 < abs(r0.y));
  r0.y = r0.y ? -0 : -r0.x;
  r0.y = r1.w + r0.y;
  r1.w = r1.w + -r0.x;
  r5.xy = cmp(float2(9.99999975e-06,9.99999975e-06) < abs(cb2[18].xy));
  r5.zw = cmp(cb2[18].xy >= float2(0,0));
  r0.y = r5.z ? r0.y : r1.w;
  r0.y = r5.x ? r0.y : r1.w;
  r0.y = saturate(ceil(r0.y));
  r0.y = 1 + -r0.y;
  r6.xyz = r4.xyz + -r1.xyz;
  r6.xyz = r0.yyy * r6.xyz + r1.xyz;
  r5.xzw = r5.www ? r6.xyz : r4.xyz;
  r4.xyz = r5.yyy ? r5.xzw : r4.xyz;
  r5.xyz = r3.xyz / r4.xyz;
  r5.xyz = float3(1,1,1) + -r5.xyz;
  r0.y = cmp(cb2[18].z != 1.000000);
  if (r0.y != 0) {
    r6.xyz = float3(1,1,1) + -r4.xyz;
    r7.xyz = r1.xyz / r6.xyz;
    r0.y = cmp(cb2[18].z == 2.000000);
    r5.xyz = r0.yyy ? r7.xyz : r5.xyz;
    if (r0.y == 0) {
      r7.xyz = -r4.xyz + r1.xyz;
      r0.y = cmp(cb2[18].z == 3.000000);
      r5.xyz = r0.yyy ? abs(r7.xyz) : r5.xyz;
      if (r0.y == 0) {
        r7.xyz = float3(-0.5,-0.5,-0.5) + r1.xyz;
        r8.xyz = float3(-0.5,-0.5,-0.5) + r4.xyz;
        r7.xyz = r8.xyz * r7.xyz;
        r7.xyz = -r7.xyz * float3(2,2,2) + float3(0.5,0.5,0.5);
        r0.y = cmp(cb2[18].z == 4.000000);
        r5.xyz = r0.yyy ? r7.xyz : r5.xyz;
        if (r0.y == 0) {
          r7.xyz = r8.xyz + r8.xyz;
          r8.xyz = -r8.xyz * float3(2,2,2) + float3(1,1,1);
          r8.xyz = -r3.xyz * r8.xyz + float3(1,1,1);
          r9.xyz = r4.xyz + r4.xyz;
          r10.xyz = r9.xyz * r1.xyz;
          r11.xyz = cmp(r4.xyz >= float3(0.5,0.5,0.5));
          r8.xyz = r11.xyz ? r8.xyz : r10.xyz;
          r0.y = cmp(cb2[18].z == 5.000000);
          r5.xyz = r0.yyy ? abs(r8.xyz) : r5.xyz;
          if (r0.y == 0) {
            r8.xyz = r4.xyz + r1.xyz;
            r10.xyz = float3(-1,-1,-1) + r8.xyz;
            r0.y = cmp(cb2[18].z == 6.000000);
            r5.xyz = r0.yyy ? r10.xyz : r5.xyz;
            if (r0.y == 0) {
              r0.y = cmp(cb2[18].z == 7.000000);
              r5.xyz = r0.yyy ? r8.xyz : r5.xyz;
              if (r0.y == 0) {
                r8.xyz = float3(-0.125,-0.125,-0.125) + r4.xyz;
                r8.xyz = r8.xyz * float3(1.25,1.25,1.25) + r1.xyz;
                r10.xyz = float3(-0.25,-0.25,-0.25) + r4.xyz;
                r10.xyz = r10.xyz * float3(2,2,2) + r1.xyz;
                r8.xyz = r11.xyz ? r8.xyz : r10.xyz;
                r0.y = cmp(cb2[18].z == 8.000000);
                r5.xyz = r0.yyy ? r8.xyz : r5.xyz;
                if (r0.y == 0) {
                  r7.xyz = max(r7.xyz, r1.xyz);
                  r8.xyz = min(r9.xyz, r1.xyz);
                  r7.xyz = r11.xyz ? r7.xyz : r8.xyz;
                  r0.y = cmp(cb2[18].z == 9.000000);
                  r5.xyz = r0.yyy ? r7.xyz : r5.xyz;
                  if (r0.y == 0) {
                    r7.xyz = -r4.xyz * float3(2,2,2) + float3(1,1,1);
                    r7.xyz = -r7.xyz * r3.xyz + float3(1,1,1);
                    r7.xyz = r7.xyz * r1.xyz;
                    r8.xyz = -r1.xyz * r9.xyz + float3(1,1,1);
                    r8.xyz = -r3.xyz * r8.xyz + float3(1,1,1);
                    r7.xyz = r11.xyz ? r7.xyz : r8.xyz;
                    r0.y = cmp(cb2[18].z == 10.000000);
                    r5.xyz = r0.yyy ? r7.xyz : r5.xyz;
                    if (r0.y == 0) {
                      r7.xyz = r6.xyz * r3.xyz;
                      r3.xyz = -r3.xyz * r6.xyz + float3(1,1,1);
                      r0.y = cmp(cb2[18].z == 11.000000);
                      r5.xyz = r0.yyy ? r3.xyz : r5.xyz;
                      if (r0.y == 0) {
                        r3.xyz = max(r4.xyz, r1.xyz);
                        r0.y = cmp(cb2[18].z == 12.000000);
                        r5.xyz = r0.yyy ? r3.xyz : r5.xyz;
                        if (r0.y == 0) {
                          r3.xyz = min(r4.xyz, r1.xyz);
                          r0.y = cmp(cb2[18].z == 13.000000);
                          r5.xyz = r0.yyy ? r3.xyz : r5.xyz;
                          if (r0.y == 0) {
                            r3.xyz = cmp(r1.xyz < float3(0.5,0.5,0.5));
                            r6.xyz = r4.xyz * r1.xyz;
                            r8.xyz = r6.xyz + r6.xyz;
                            r7.xyz = -r7.xyz * float3(2,2,2) + float3(1,1,1);
                            r3.xyz = r3.xyz ? r8.xyz : r7.xyz;
                            r0.y = cmp(cb2[18].z == 14.000000);
                            r5.xyz = r0.yyy ? r3.xyz : r5.xyz;
                            if (r0.y == 0) {
                              r0.y = cmp(cb2[18].z == 15.000000);
                              r5.xyz = r0.yyy ? r6.xyz : r5.xyz;
                              if (r0.y == 0) {
                                r0.y = cmp(cb2[18].z != 16.000000);
                                if (r0.y != 0) {
                                  r3.xyzw = cmp(cb2[18].zzzz == float4(17,18,19,20));
                                  r0.y = (int)r3.y | (int)r3.x;
                                  r6.xyz = r0.yyy ? float3(0,0,0) : r5.xyz;
                                  r0.y = (int)r3.z | (int)r0.y;
                                  r7.xyz = r0.yyy ? float3(0,0,0) : r5.xyz;
                                  r0.y = (int)r3.w | (int)r0.y;
                                  r8.xyz = r0.yyy ? float3(0,0,0) : r5.xyz;
                                  r4.xyz = r3.www ? r8.xyz : r4.xyz;
                                  r4.xyz = r3.zzz ? r7.xyz : r4.xyz;
                                  r3.yzw = r3.yyy ? r6.xyz : r4.xyz;
                                  r5.xyz = r3.xxx ? float3(0,0,0) : r3.yzw;
                                } else {
                                  r5.xyz = float3(0,0,0);
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
  r3.xyz = r5.xyz + -r1.xyz;
  r3.xyz = cb2[18].www * r3.xyz;
  r0.yz = r0.zw * cb2[20].xy + float2(0.5,0.5);
  r0.yz = -cb2[20].zw + r0.yz;
  r0.y = t6.Sample(s4_s, r0.yz).x;
  r0.yzw = r0.yyy * r3.xyz;
  r0.x = cb2[21].z * r0.x;
  r1.w = cmp(0 >= r0.x);
  r0.x = log2(r0.x);
  r0.x = cb2[21].w * r0.x;
  r0.x = exp2(r0.x);
  r0.x = min(1, r0.x);
  r0.x = r1.w ? 0 : r0.x;
  r1.w = 1 + -r0.x;
  r2.w = cmp(9.99999975e-06 < abs(cb2[22].x));
  r3.x = cmp(cb2[22].x >= 0);
  r1.w = r3.x ? r1.w : r0.x;
  r0.x = r2.w ? r1.w : r0.x;
  r0.xyz = r0.xxx * r0.yzw + r1.xyz;
  r0.xyz = r0.xyz + -r2.xyz;
  r0.xyz = cb2[22].yyy * r0.xyz + r2.xyz;
  r1.xyz = cb2[23].xyz + -r0.xyz;
  r0.xyz = cb2[22].zzz * r1.xyz + r0.xyz;
  o0.xyz = max(float3(0,0,0), r0.xyz);
  o0.w = 0;
  return;
}