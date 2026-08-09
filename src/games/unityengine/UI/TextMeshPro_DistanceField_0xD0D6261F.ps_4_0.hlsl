#include "../common.hlsl"

Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb2 : register(b2){
  float4 cb2[4];
}
cbuffer cb1 : register(b1){
  float4 cb1[1];
}
cbuffer cb0 : register(b0){
  float4 cb0[91];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float4 v2 : TEXCOORD0,
  float4 v3 : TEXCOORD1,
  float4 v4 : TEXCOORD2,
  float4 v5 : TEXCOORD3,
  float4 v6 : TEXCOORD5,
  float4 v7 : TEXCOORD6,
  float4 v8 : TEXCOORD7,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cb0[22].w * cb0[6].x;
  r0.y = cb0[22].w * cb0[4].y;
  r0.xz = v3.yy * r0.xy;
  r1.xyz = cb0[3].xyz * v1.xyz;
  r2.xy = cb0[2].xy * cb1[0].yy + v6.xy;
  r2.xyzw = t1.Sample(s0_s, r2.xy).xyzw;
  r1.xyz = r2.xyz * r1.xyz;
  r2.w = cb0[3].w * r2.w;
  r3.xy = cb0[4].zw * cb1[0].yy + v6.zw;
  r3.xyzw = t2.Sample(s1_s, r3.xy).xyzw;
  r3.xyzw = cb0[5].xyzw * r3.xyzw;
  r0.w = 0.5 * r0.x;
  r0.y = r0.y * v3.y + 1;
  r0.x = min(1, r0.x);
  r0.x = sqrt(r0.x);
  r2.xyz = r2.www * r1.xyz;
  r3.xyz = r3.xyz * r3.www;
  r1.xyzw = r3.xyzw + -r2.xyzw;
  r3.xyzw = cb2[1].xyzw * v8.yyyy;
  r3.xyzw = cb2[0].xyzw * v8.xxxx + r3.xyzw;
  r3.xyzw = cb2[2].xyzw * v8.zzzz + r3.xyzw;
  r3.xyzw = cb2[3].xyzw * v8.wwww + r3.xyzw;
  r4.xyzw = cb0[88].xyzw * r3.yyyy;
  r4.xyzw = cb0[87].xyzw * r3.xxxx + r4.xyzw;
  r4.xyzw = cb0[89].xyzw * r3.zzzz + r4.xyzw;
  r3.xyzw = cb0[90].xyzw * r3.wwww + r4.xyzw;
  r4.xy = cb0[72].xy * r3.yy;
  r4.xy = cb0[71].xy * r3.xx + r4.xy;
  r4.xy = cb0[73].xy * r3.zz + r4.xy;
  r4.yz = saturate(cb0[74].xy * r3.ww + r4.xy);
  r4.w = cmp(v7.x < -3);
  r5.xy = cb0[80].xy * r3.yy;
  r3.xy = cb0[79].xy * r3.xx + r5.xy;
  r3.xy = cb0[81].xy * r3.zz + r3.xy;
  r3.yz = saturate(cb0[82].xy * r3.ww + r3.xy);
  r3.x = 4 + v7.x;
  r4.x = v7.x;
  r3.xyz = r4.www ? r3.xyz : r4.xyz;
  r3.w = cmp(r3.x < 0);
  r4.x = r3.w ? 2.000000 : 0;
  r3.x = r4.x + r3.x;
  r4.xyzw = t0.Sample(s2_s, v2.xy).xyzw;
  r4.x = cmp(r4.w >= v3.x);
  r4.x = r4.x ? 1.000000 : 0;
  r4.x = -r4.w * r4.x + v3.z;
  r4.y = r4.x * v3.y + -r0.w;
  r0.z = r0.z * 0.5 + r4.y;
  r0.y = saturate(r0.z / r0.y);
  r0.y = 1 + -r0.y;
  r0.z = saturate(r4.x * v3.y + r0.w);
  r0.x = r0.z * r0.x;
  r1.xyzw = r0.xxxx * r1.xyzw + r2.xyzw;
  r0.xyzw = r1.xyzw * r0.yyyy;
  r1.x = cmp(v2.x >= r3.x);
  r1.x = r1.x ? 1.000000 : 0;
  r0.xyzw = r1.xxxx * r0.xyzw;
  r1.xy = cmp(v7.zw >= v2.xy);
  r1.xy = r1.xy ? float2(1,1) : 0;
  r0.xyzw = r1.xxxx * r0.xyzw;
  r1.x = cmp(v2.y >= v7.y);
  r1.x = r1.x ? 1.000000 : 0;
  r0.xyzw = r1.xxxx * r0.xyzw;
  r0.xyzw = r0.xyzw * r1.yyyy;
  r1.xy = r3.yz * cb0[63].xy + cb0[63].zw;
  r1.xy = cb1[0].yy * cb0[64].xy + r1.xy;
  r1.xyzw = t3.Sample(s3_s, r1.xy).xyzw;
  r1.xyzw = cb0[62].xyzw * r1.xyzw;
  r1.w = cb0[60].z * r1.w;
  r2.xyz = r1.xyz * r0.www + -r0.xyz;
  r2.w = 0;
  r0.xyzw = r1.wwww * r2.xyzw + r0.xyzw;
  if (r3.w != 0) {
    r1.x = asint(cb0[57].x);
    r1.y = cmp(asint(cb0[55].w) == 1);
    if (r1.y != 0) {
      r0.xyz = cb0[56].xyz * r0.xyz;
    } else {
      r1.y = cmp(asint(cb0[55].w) == 2);
      if (r1.y != 0) {
        r0.xyz = cb0[56].xyz * r0.www + r0.xyz;
      } else {
        r1.y = cmp(asint(cb0[55].w) == 3);
        if (r1.y != 0) {
          r0.xyz = -cb0[56].xyz * r0.www + r0.xyz;
        } else {
          r1.y = cmp(asint(cb0[55].w) == 4);
          if (r1.y != 0) {
            r0.xyz = cb0[56].xyz * r0.www;
          } else {
            r1.y = cmp(asint(cb0[55].w) == 5);
            if (r1.y != 0) {
              r1.y = dot(r0.xyz, float3(0.219999999,0.707000017,0.0710000023));
              r1.y = 1 + r1.y;
              r1.yzw = cb0[56].xyz * r1.yyy;
              r1.yzw = float3(0.5,0.5,0.5) * r1.yzw;
              r0.xyz = r1.yzw * r0.www;
            } else {
              r1.yzw = float3(1,1,1) + cb0[56].xyz;
              r2.xyz = r1.yzw * r0.xyz;
              r1.z = cmp(r0.y >= r0.z);
              r1.z = r1.z ? 1.000000 : 0;
              r3.xy = r0.zy;
              r3.zw = float2(-1,0.666666687);
              r4.xy = -r3.xy + r0.yz;
              r4.zw = float2(1,-1);
              r3.xyzw = r1.zzzz * r4.xyzw + r3.xyzw;
              r1.z = cmp(r0.x >= r3.x);
              r1.z = r1.z ? 1.000000 : 0;
              r4.xyz = r3.xyw;
              r4.w = r0.x;
              r3.xyw = r4.wyx;
              r3.xyzw = r3.xyzw + -r4.xyzw;
              r3.xyzw = r1.zzzz * r3.yzxw + r4.yzxw;
              r1.z = min(r3.w, r3.x);
              r1.z = r3.z + -r1.z;
              r1.w = r3.w + -r3.x;
              r3.w = r1.z * 6 + 9.99999975e-05;
              r1.w = r1.w / r3.w;
              r1.w = r3.y + r1.w;
              r3.x = abs(r1.w);
              r1.w = 9.99999975e-05 + r3.z;
              r3.y = r1.z / r1.w;
              r3.xyz = cb0[56].xyz + r3.xyz;
              r4.xyz = float3(1,0.666666687,0.333333343) + r3.xxx;
              r4.xyz = frac(r4.xyz);
              r4.xyz = r4.xyz * float3(6,6,6) + float3(-3,-3,-3);
              r4.xyz = saturate(float3(-1,-1,-1) + abs(r4.xyz));
              r4.xyz = float3(-1,-1,-1) + r4.xyz;
              r3.xyw = r3.yyy * r4.xyz + float3(1,1,1);
              r3.xyz = r3.zzz * r3.xyw;
              r3.xyz = r3.xyz * r0.www;
              r3.xyz = cb0[56].www * r3.xyz;
              r4.w = cb0[56].w * r0.w;
              r5.xyz = cmp(asint(cb0[55].www) == int3(6,7,8));
              r6.xyz = float3(-0.5,-0.5,-0.5) + r0.xyz;
              r1.yzw = r6.xyz * r1.yyy + float3(0.5,0.5,0.5);
              r1.yzw = cb0[56].yyy * float3(1.5,1.5,1.5) + r1.yzw;
              r1.yzw = r1.yzw * r0.www;
              r4.xyz = cb0[56].www * r1.yzw;
              r6.xyzw = r5.zzzz ? r4.xyzw : r0.xyzw;
              r3.w = r4.w;
              r3.xyzw = r5.yyyy ? r3.xyzw : r6.xyzw;
              r2.w = r0.w;
              r0.xyzw = r5.xxxx ? r2.xyzw : r3.xyzw;
            }
          }
        }
      }
    }
    r1.y = cmp(0 < asint(cb0[55].w));
    r1.x = 1 + -r1.x;
    r2.w = r1.x * r0.w;
    r2.xyz = r0.xyz;
    r1.xyzw = r1.yyyy ? r2.xyzw : r0.xyzw;
  } else {
    r2.x = asint(cb0[46].y);
    r2.y = cmp(asint(cb0[44].y) == 1);
    if (r2.y != 0) {
      r3.xyz = cb0[45].xyz * r0.xyz;
      r3.w = r0.w;
    } else {
      r2.y = cmp(asint(cb0[44].y) == 2);
      if (r2.y != 0) {
        r3.xyz = cb0[45].xyz * r0.www + r0.xyz;
        r3.w = r0.w;
      } else {
        r2.y = cmp(asint(cb0[44].y) == 3);
        if (r2.y != 0) {
          r3.xyz = -cb0[45].xyz * r0.www + r0.xyz;
          r3.w = r0.w;
        } else {
          r2.y = cmp(asint(cb0[44].y) == 4);
          if (r2.y != 0) {
            r3.xyz = cb0[45].xyz * r0.www;
            r3.w = r0.w;
          } else {
            r2.y = cmp(asint(cb0[44].y) == 5);
            if (r2.y != 0) {
              r2.y = dot(r0.xyz, float3(0.219999999,0.707000017,0.0710000023));
              r2.y = 1 + r2.y;
              r2.yzw = cb0[45].xyz * r2.yyy;
              r2.yzw = float3(0.5,0.5,0.5) * r2.yzw;
              r3.xyz = r2.yzw * r0.www;
              r3.w = r0.w;
            } else {
              r2.yzw = float3(1,1,1) + cb0[45].xyz;
              r4.xyz = r2.yzw * r0.xyz;
              r2.z = cmp(r0.y >= r0.z);
              r2.z = r2.z ? 1.000000 : 0;
              r5.xy = r0.zy;
              r5.zw = float2(-1,0.666666687);
              r6.xy = -r5.xy + r0.yz;
              r6.zw = float2(1,-1);
              r5.xyzw = r2.zzzz * r6.xyzw + r5.xyzw;
              r2.z = cmp(r0.x >= r5.x);
              r2.z = r2.z ? 1.000000 : 0;
              r6.xyz = r5.xyw;
              r6.w = r0.x;
              r5.xyw = r6.wyx;
              r5.xyzw = r5.xyzw + -r6.xyzw;
              r5.xyzw = r2.zzzz * r5.yzxw + r6.yzxw;
              r2.z = min(r5.w, r5.x);
              r2.z = r5.z + -r2.z;
              r2.w = r5.w + -r5.x;
              r5.w = r2.z * 6 + 9.99999975e-05;
              r2.w = r2.w / r5.w;
              r2.w = r5.y + r2.w;
              r5.x = abs(r2.w);
              r2.w = 9.99999975e-05 + r5.z;
              r5.y = r2.z / r2.w;
              r5.xyz = cb0[45].xyz + r5.xyz;
              r6.xyz = float3(1,0.666666687,0.333333343) + r5.xxx;
              r6.xyz = frac(r6.xyz);
              r6.xyz = r6.xyz * float3(6,6,6) + float3(-3,-3,-3);
              r6.xyz = saturate(float3(-1,-1,-1) + abs(r6.xyz));
              r6.xyz = float3(-1,-1,-1) + r6.xyz;
              r5.xyw = r5.yyy * r6.xyz + float3(1,1,1);
              r5.xyz = r5.zzz * r5.xyw;
              r5.xyz = r5.xyz * r0.www;
              r5.xyz = cb0[45].www * r5.xyz;
              r6.w = cb0[45].w * r0.w;
              r7.xyz = cmp(asint(cb0[44].yyy) == int3(6,7,8));
              r8.xyz = float3(-0.5,-0.5,-0.5) + r0.xyz;
              r2.yzw = r8.xyz * r2.yyy + float3(0.5,0.5,0.5);
              r2.yzw = cb0[45].yyy * float3(1.5,1.5,1.5) + r2.yzw;
              r2.yzw = r2.yzw * r0.www;
              r6.xyz = cb0[45].www * r2.yzw;
              r8.xyzw = r7.zzzz ? r6.xyzw : r0.xyzw;
              r5.w = r6.w;
              r5.xyzw = r7.yyyy ? r5.xyzw : r8.xyzw;
              r4.w = r0.w;
              r3.xyzw = r7.xxxx ? r4.xyzw : r5.xyzw;
            }
          }
        }
      }
    }
    r2.y = cmp(0 < asint(cb0[44].y));
    r4.xyzw = r3.xyzw + -r0.xyzw;
    r0.xyzw = cb0[46].xxxx * r4.xyzw + r0.xyzw;
    r2.x = -r2.x * cb0[46].x + 1;
    r0.w = r2.x * r0.w;
    r1.xyzw = r2.yyyy ? r0.xyzw : r3.xyzw;
  }
  o0.xyzw = v1.wwww * r1.xyzw;
  if(injectedData.rolloffUI == 1.f){
    o0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(o0.xyz) : o0.xyz;
    o0.xyz = rolloff(o0.xyz, 0.85f, true);
    o0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(o0.xyz) : o0.xyz;
  } else if(injectedData.rolloffUI == 2.f){
    o0.xyz = saturate(o0.xyz);
  }
  o0.w = saturate(o0.w);
  return;
}