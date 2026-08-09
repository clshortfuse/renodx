#include "../../tonemap.hlsl"

Texture2D<float4> t8 : register(t8);
Texture2D<float4> t7 : register(t7);
Texture2D<float4> t6 : register(t6);
Texture2D<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s8_s : register(s8);
SamplerState s7_s : register(s7);
SamplerState s6_s : register(s6);
SamplerState s5_s : register(s5);
SamplerState s4_s : register(s4);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb2 : register(b2){
  float4 cb2[9];
}
cbuffer cb1 : register(b1){
  float4 cb1[9];
}
cbuffer cb0 : register(b0){
  float4 cb0[24];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r1.xyzw = t1.Sample(s1_s, v1.xy).xyzw;
  r2.xyzw = t2.Sample(s6_s, v1.xy).xyzw;
  r3.xyzw = t3.Sample(s7_s, v1.xy).xyzw;
  r0.w = 1 + -r3.x;
  r1.w = cb1[5].y * cb1[5].z;
  r2.yz = cb1[5].yz + -cb1[5].zy;
  r2.yz = r0.ww * r2.yz + cb1[5].zy;
  r0.w = r1.w / r2.y;
  r1.w = r2.z + -r0.w;
  r0.w = cb1[8].w * r1.w + r0.w;
  r2.yz = v1.xy * float2(2,2) + float2(-1,-1);
  r2.yz = -cb2[8].xy + r2.yz;
  r3.x = r2.y / cb2[6].x;
  r3.y = r2.z / cb2[7].y;
  r1.w = 1 + -r0.w;
  r1.w = cb1[8].w * r1.w + r0.w;
  r2.yz = r3.xy * r1.ww;
  r3.xyz = cb0[6].xyz * r2.zzz;
  r2.yzw = cb0[5].xyz * r2.yyy + r3.xyz;
  r2.yzw = cb0[7].xyz * -r0.www + r2.yzw;
  r2.yzw = cb0[8].xyz + r2.yzw;
  //r0.w = cmp(0 < r2.x);
  if (r2.x > 0) {
    r3.xy = r2.yw + r2.zz;
    r3.zw = float2(0.05,0.05) * r3.xy;
    r0.w = 0.1 * cb1[0].x;
    r0.w = cos(r0.w);
    r4.xy = r3.xy * float2(0.05,0.05) + r0.ww;
    r4.xyzw = t4.Sample(s3_s, r4.xy).xyzw;
    r3.xy = r3.xy * float2(0.05,0.05) + -r0.ww;
    r5.xyzw = t5.Sample(s2_s, r3.xy).xyzw;
    r1.w = r5.x + r4.x;
    r3.x = 1 + -r2.x;
    r3.y = -r0.w * 0.1 + cb0[16].y;
    r3.x = r3.x + -r3.y;
    r3.y = 0.05 * cb0[10].x;
    r3.y = cos(r3.y);
    r3.y = -r3.y * 0.1 + cb0[16].x;
    r3.x = r3.x * r3.y;
    r3.x = r1.w * 0.5 + r3.x;
    r3.y = 0;
    r4.xyzw = t6.Sample(s5_s, r3.xy).xyzw;
    r4.x = saturate(r4.x);
    r3.xy = r3.zw / cb0[16].zz;
    r3.xy = r3.xy + r0.ww;
    r5.xyzw = t5.Sample(s2_s, r3.xy).xyzw;
    r4.yzw = cb0[18].xyz + -cb0[17].xyz;
    r4.yzw = r5.xxx * r4.yzw + cb0[17].xyz;
    r5.xyz = float3(1,1,1) + -cb0[19].xyz;
    r0.w = 1 + -r4.x;
    r5.xyz = -r5.xyz * r0.www + float3(1,1,1);
    r6.xyz = r5.xyz * r4.yzw;
    r3.xyzw = t7.Sample(s4_s, r3.zw).xyzw;
    r7.xyz = r6.xyz + r6.xyz;
    r8.xyz = -r6.xyz * float3(2,2,2) + float3(1,1,1);
    r9.xyz = r3.xyz * r3.xyz;
    r3.xyz = r7.xyz * r3.xyz;
    r3.xyz = r8.xyz * r9.xyz + r3.xyz;
    r3.xyz = -r5.xyz * r4.yzw + r3.xyz;
    r3.xyz = cb0[16].www * r3.xyz + r6.xyz;
    r3.xyz = r3.xyz * r2.xxx;
    r0.xyz = r3.xyz * float3(0.85,0.85,0.85) + r0.xyz;
  }
  //r0.w = cmp(cb0[14].x != 10000.000000);
  if (cb0[14].x != 10000.0) {
    r3.xy = -cb0[15].xz + cb0[14].xz;
    r0.w = dot(r3.xy, r3.xy);
    r0.w = rsqrt(r0.w);
    r3.xy = r3.xy * r0.ww;
    r3.zw = -cb0[15].xz + r2.yw;
    r0.w = dot(r3.zw, r3.zw);
    r1.w = rsqrt(r0.w);
    r3.zw = r3.zw * r1.ww;
    r1.w = dot(r3.zw, r3.xy);
    r1.w = r1.w * abs(r1.w);
    //r1.w = cmp(r1.w >= 0.999);
    if (r1.w >= 0.999) {
      /*r1.xzw = cmp(r1.xyz == float3(0,0,0));
      r1.x = r1.z ? r1.x : 0;
      r1.x = r1.w ? r1.x : 0;*/
      //r1.x = r1.y == 0 ? r1.x == 0 : 0;
      //r1.x = r1.z == 0 ? r1.x : 0;
      bool something = r1.z == 0 ? (r1.y == 0 ? r1.x == 0 : false) : false;
      r0.w = sqrt(r0.w);
      r1.z = -cb0[23].z * 0.2 + 0.3;
      r0.w = saturate(r1.z * r0.w);
      r0.w = 1 + -r0.w;
      r0.w = r0.w * 1.3 + 1;
      r3.xyz = r0.xyz * r0.www;
      //r0.xyz = r1.xxx ? r3.xyz : r0.xyz;
      r0.xyz = something ? r3.xyz : r0.xyz;
    }
  }
  //r0.w = cmp(0 < cb0[20].y);
  r1.x = saturate(1 + -cb0[20].y);
  r1.xzw = r1.xxx * r0.xyz;
  r1.xzw = float3(0.3,0.3,0.3) * r1.xzw;
  r1.xzw = r0.xyz * float3(0.7,0.7,0.7) + r1.xzw;
  r0.xyz = cb0[20].y > 0 ? r1.xzw : r0.xyz;
  //r0.w = cmp(0 < cb0[21].x);
  //r1.x = cmp(cb0[23].y == 0.000000);
  bool something = cb0[21].x > 0 ? cb0[23].y == 0.0 : false;
  r1.x = -3 + cb0[22].y;
  r3.xz = cb0[22].xz + -r2.yw;
  r3.y = r1.x + -r2.z;
  r1.x = dot(r3.xyz, r3.xyz);
  r1.x = sqrt(r1.x);
  r1.x = r1.x / cb0[21].y;
  r1.z = r1.x * r1.x;
  r1.w = r1.z * r1.z;
  r2.x = r1.w * r1.w;
  r1.w = r2.x * r1.w;
  r1.z = r1.z * r1.w;
  r1.x = saturate(r1.z * r1.x);
  r1.z = -cb0[21].x * 0.3 + 1;
  r1.y = 1 + -r1.y;
  r1.y = cb0[21].x * r1.y;
  r1.x = r1.y * r1.x;
  r2.xyz = r0.xyz * r1.zzz + -r0.xyz;
  r2.xyz = r1.xxx * r2.xyz + r0.xyz;
  //r1.y = cmp(cb0[21].z == 2.000000);
  r1.x = 0.05 * r1.x;
  r3.xyz = r1.zzz * float3(1.0, 0.7, 0.0) + -r2.xyz;
  r1.xzw = r1.xxx * r3.xyz + r2.xyz;
  r1.xyz = cb0[21].z == 2.0 ? r1.xzw : r2.xyz;
  r0.xyz = something ? r1.xyz : r0.xyz;
  r0.xyz = float3(-0.5,-0.5,-0.5) + r0.xyz;
  r0.xyz = r0.xyz * float3(1.01,1.01,1.01) + float3(0.5,0.5,0.5);
  r0.w = 0;
  if(injectedData.toneMapType == 0.f){
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(0.952381015,0.952381015,0.952381015) * r0.xyz;
  r0.xyzw = exp2(r0.xyzw);
  } else {
    r0.xyz = renodx::math::SignPow(r0.xyz, 1.f / 1.05f);
  }
  r1.xyzw = t8.Sample(s8_s, v1.xy).xyzw;
  o0.xyzw = r1.xxxx * r0.xyzw;
  if(injectedData.gammaSpace != 0.f){
    o0.xyz = renodx::color::srgb::DecodeSafe(o0.xyz);
  }
  if (injectedData.tonemapCheck == 1.f && (injectedData.count2Old == injectedData.count2New)) {
  o0.xyz = applyUserNoTonemap(o0.xyz);
  }
  if (injectedData.countOld == injectedData.countNew) {
  o0.xyz = PostToneMapScale(o0.xyz, injectedData.gammaSpace != 0.f);
  } else if(injectedData.gammaSpace != 0.f){
    o0.xyz = renodx::color::srgb::EncodeSafe(o0.xyz);
  }
  return;
}