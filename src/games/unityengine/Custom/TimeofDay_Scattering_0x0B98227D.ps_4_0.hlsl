#include "../common.hlsl"

Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[8];
}
cbuffer cb0 : register(b0){
  float4 cb0[51];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD2,
  float4 v2 : TEXCOORD3,
  float4 v3 : TEXCOORD4,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy * cb0[48].xy + cb0[48].zw;
  r0.xyzw = t0.Sample(s1_s, r0.xy).xyzw;
  r1.xy = w1.xy * cb0[50].xy + cb0[50].zw;
  r1.xyzw = t1.Sample(s3_s, r1.xy).xyzw;
  r1.x = cb1[7].x * r1.x + cb1[7].y;
  r1.x = 1 / r1.x;
  r2.xyz = v3.xyz * r1.xxx;
  r2.w = r1.x * v3.y + cb1[4].y;
  r3.xy = v1.xy * cb0[49].xy + cb0[49].zw;
  r3.xyzw = t2.Sample(s2_s, r3.xy).xyzw;
  r3.yzw = cb0[3].xyz * v3.yyy;
  r3.yzw = cb0[2].xyz * v3.xxx + r3.yzw;
  r3.yzw = cb0[4].xyz * v3.zzz + r3.yzw;
  r4.x = dot(r3.yzw, r3.yzw);
  r4.x = rsqrt(r4.x);
  r4.xyz = r4.xxx * r3.zyw;
  r4.w = max(0, r4.x);
  r3.y = dot(r4.yzw, r4.yzw);
  r3.y = rsqrt(r3.y);
  r3.yzw = r4.ywz * r3.yyy;
  r5.y = cb0[42].w + cb0[41].x;
  r5.w = r3.z * r3.z;
  r5.w = r5.w * cb0[41].y + cb0[41].w;
  r5.w = -cb0[41].y + r5.w;
  r5.w = sqrt(r5.w);
  r5.w = -cb0[41].x * r3.z + r5.w;
  r6.x = cb0[42].z * -cb0[42].w;
  r6.x = 1.44269502 * r6.x;
  r6.x = exp2(r6.x);
  r6.y = r5.y * r3.z;
  r6.y = r6.y / r5.y;
  r6.y = 1 + -r6.y;
  r6.z = r6.y * 5.25 + -6.80000019;
  r6.z = r6.y * r6.z + 3.82999992;
  r6.z = r6.y * r6.z + 0.458999991;
  r6.y = r6.y * r6.z + -0.00286999997;
  r6.y = 1.44269502 * r6.y;
  r6.y = exp2(r6.y);
  r6.x = r6.x * r6.y;
  r5.w = 0.5 * r5.w;
  r6.y = cb0[42].x * r5.w;
  r7.xyz = r5.www * r3.yzw;
  r5.xz = float2(0,0);
  r5.xyz = r7.xyz * float3(0.5,0.5,0.5) + r5.xyz;
  r7.xyz = cb0[40].xyz + cb0[40].www;
  r8.xyz = r5.xyz;
  r9.yzw = float3(0,0,0);
  r6.z = 0;
  while (true) {
    r6.w = cmp((int)r6.z >= 2);
    if (r6.w != 0) break;
    r6.w = dot(r8.xyz, r8.xyz);
    r6.w = sqrt(r6.w);
    r6.w = max(1, r6.w);
    r7.w = 1 / r6.w;
    r6.w = cb0[41].x + -r6.w;
    r6.w = cb0[42].z * r6.w;
    r6.w = 1.44269502 * r6.w;
    r6.w = exp2(r6.w);
    r8.w = r6.w * r6.y;
    r9.x = dot(r3.yzw, r8.xyz);
    r10.x = dot(cb0[24].xyz, r8.xyz);
    r10.x = -r10.x * r7.w + 1;
    r10.y = r10.x * 5.25 + -6.80000019;
    r10.y = r10.x * r10.y + 3.82999992;
    r10.y = r10.x * r10.y + 0.458999991;
    r10.x = r10.x * r10.y + -0.00286999997;
    r10.x = 1.44269502 * r10.x;
    r10.x = exp2(r10.x);
    r7.w = -r9.x * r7.w + 1;
    r9.x = r7.w * 5.25 + -6.80000019;
    r9.x = r7.w * r9.x + 3.82999992;
    r9.x = r7.w * r9.x + 0.458999991;
    r7.w = r7.w * r9.x + -0.00286999997;
    r7.w = 1.44269502 * r7.w;
    r7.w = exp2(r7.w);
    r7.w = 0.25 * r7.w;
    r7.w = r10.x * 0.25 + -r7.w;
    r6.w = r7.w * r6.w;
    r6.w = r6.x * 0.25 + r6.w;
    r10.xyz = -r6.www * r7.xyz;
    r10.xyz = float3(1.44269502,1.44269502,1.44269502) * r10.xyz;
    r10.xyz = exp2(r10.xyz);
    r9.yzw = r10.xyz * r8.www + r9.yzw;
    r8.xyz = r3.yzw * r5.www + r8.xyz;
    r6.z = (int)r6.z + 1;
  }
  r3.yzw = cb0[12].xyz * r9.yzw;
  r5.xyz = cb0[39].xyz * r3.yzw;
  r1.yzw = cb0[39].www * r3.yzw;
  r3.y = cmp(r1.x != 1.000000);
  r2.x = dot(r2.xyz, r2.xyz);
  r2.x = sqrt(r2.x);
  r2.xy = -cb0[37].wy + r2.xw;
  r2.z = cb1[4].y + -cb0[37].y;
  r2.yz = cb0[37].xx * r2.yz;
  r2.xyz = max(float3(0,0.00999999978,0.00999999978), r2.xyz);
  r2.w = -1.44269502 * r2.y;
  r2.w = exp2(r2.w);
  r3.z = -1.44269502 * r2.z;
  r3.z = exp2(r3.z);
  r3.w = 1 + -r2.w;
  r2.w = r3.w * r2.w;
  r2.y = r2.w / r2.y;
  r2.w = 1 + -r3.z;
  r2.w = r3.z * r2.w;
  r2.z = r2.w / r2.z;
  r2.y = r2.y + r2.z;
  r2.x = r2.y * r2.x;
  r2.x = cb0[37].z * r2.x;
  r2.x = 0.5 * r2.x;
  r2.x = min(10, r2.x);
  r2.x = -1.44269502 * r2.x;
  r2.x = exp2(r2.x);
  r2.x = 1 + -r2.x;
  r6.xyz = r2.xxx * r1.yzw;
  r2.yzw = r6.xyz * r3.xxx;
  r3.xzw = r5.xyz * r2.xxx;
  r3.xzw = r3.yyy ? r3.xzw : r5.xyz;
  r2.xyzw = r3.yyyy ? r2.xyzw : r1.xyzw;
  r1.y = dot(cb0[24].yxz, r4.xyz);
  r1.z = r1.y * r1.y;
  r1.w = -r4.w * 0.75 + 1;
  r3.y = dot(r4.yxz, cb0[25].xyz);
  r3.y = max(0, r3.y);
  r3.y = log2(r3.y);
  r3.y = cb0[27].z * r3.y;
  r3.y = exp2(r3.y);
  r4.yzw = cb0[28].xyz * r3.yyy;
  r4.yzw = cb0[13].xyz * r1.www + r4.yzw;
  r1.z = r1.z * 0.75 + 0.75;
  r3.xyz = r1.zzz * r3.xzw + r4.yzw;
  r1.z = r1.y * r1.y + 1;
  r1.z = cb0[38].x * r1.z;
  r1.y = cb0[38].z * r1.y + cb0[38].y;
  r1.y = log2(r1.y);
  r1.y = 1.5 * r1.y;
  r1.y = exp2(r1.y);
  r1.y = r1.z / r1.y;
  r1.yzw = r1.yyy * r2.yzw + r3.xyz;
  r4.x = saturate(-r4.x);
  r2.yzw = cb0[19].xyz + -r1.yzw;
  r1.yzw = r4.xxx * r2.yzw + r1.yzw;
  r2.yzw = cb0[18].xyz + -r1.yzw;
  r1.yzw = cb0[27].yyy * r2.yzw + r1.yzw;
  r1.yzw = cb0[27].xxx * r1.yzw;
  r1.yzw = log2(r1.yzw);
  r1.yzw = cb0[26].www * r1.yzw;
  r1.yzw = exp2(r1.yzw);
  r3.xyzw = t3.Sample(s0_s, v2.xy).xyzw;
  r1.yzw = r3.www * float3(0.0153846154,0.0153846154,0.0153846154) + r1.yzw;
  r1.x = cmp(r1.x == 1.000000);
  r2.yzw = r1.yzw + r0.xyz;
  r1.yzw = r1.yzw + -r0.xyz;
  r0.xyz = r2.xxx * r1.yzw + r0.xyz;
  o0.xyz = r1.xxx ? r2.yzw : r0.xyz;
  o0.w = r0.w;
  if (injectedData.countOld == injectedData.countNew) {
    o0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(o0.xyz) : o0.xyz;
    o0.xyz = PostToneMapScale(o0.xyz, injectedData.gammaSpace != 0.f);
  }
  return;
}