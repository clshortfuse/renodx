#include "../../common.hlsl"

Texture2D<float4> t6 : register(t6);
Texture2D<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s6_s : register(s6);
SamplerState s5_s : register(s5);
SamplerState s4_s : register(s4);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[7];
}
cbuffer cb0 : register(b0){
  float4 cb0[15];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cb0[11].y * cb0[6].w;
  r0.xyzw = -r0.xxxx * float4(0.2,0.4,0.6,0.8) + float4(1,1,1,1);
  r1.xy = float2(-0.5,-0.5) + v1.xy;
  r2.xyzw = r1.xyxy * r0.xxyy + float4(0.5,0.5,0.5,0.5);
  r0.xyzw = r1.xyxy * r0.zzww + float4(0.5,0.5,0.5,0.5);
  r3.xyzw = t0.Sample(s0_s, r2.xy).xyzw;
  r2.xyzw = t0.Sample(s0_s, r2.zw).xyzw;
  r2.xyzw = r3.xyzw + r2.xyzw;
  r3.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r0.xyzw = t0.Sample(s0_s, r0.zw).xyzw;
  r2.xyzw = r3.xyzw + r2.xyzw;
  r0.xyzw = r2.xyzw + r0.xyzw;
  r1.z = -cb0[11].y * cb0[6].w + 1;
  r1.zw = r1.xy * r1.zz + float2(0.5,0.5);
  r1.xy = r1.xy + r1.xy;
  r2.xyzw = t0.Sample(s0_s, r1.zw).xyzw;
  r0.xyzw = r2.xyzw + r0.xyzw;
  r0.xyzw = float4(0.2,0.2,0.2,0.2) * r0.xyzw;
  r1.z = dot(r1.xy, r1.xy);
  r1.w = cb0[7].y * r1.z;
  r2.xyzw = r1.wwww * r0.xyzw;
  r0.xyzw = cb0[8].wwww * r0.xyzw;
  r3.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r1.w = -r1.z * cb0[7].y + 1;
  r2.xyzw = r1.wwww * r3.xyzw + r2.xyzw;
  r3.xyz = cb0[13].xxx * float3(0.001,0.001,0.001) + v1.xyx;
  r4.xyzw = t0.Sample(s0_s, r3.xy).xyzw;
  r2.xyzw = r4.xyzw + r2.xyzw;
  r3.w = -cb0[13].x * 0.001 + v1.y;
  r3.xyzw = t0.Sample(s0_s, r3.zw).xyzw;
  r2.xyzw = r3.xyzw + r2.xyzw;
  r3.y = cb0[13].x * 0.001 + v1.y;
  r3.xzw = -cb0[13].xxx * float3(0.001,0.001,0.001) + v1.xxy;
  r4.xyzw = t0.Sample(s0_s, r3.xy).xyzw;
  r3.xyzw = t0.Sample(s0_s, r3.zw).xyzw;
  r2.xyzw = r4.xyzw + r2.xyzw;
  r2.xyzw = r2.xyzw + r3.xyzw;
  r3.xyzw = cb1[0].zzzz * cb0[9].xyzw;
  r3.xyzw = (r3.xyzw >= -r3.xyzw) ? frac(abs(r3.xyzw)) : -frac(abs(r3.xyzw));
  r3.xyzw = r3.xyzw * float4(9,9,9,9) + float4(-4,-4,-4,-4);
  r3.xyzw = r1.zzzz * cb0[7].yyyy + -r3.xyzw;
  r3.xyzw = r3.xyzw * r3.xyzw;
  r3.xyzw = saturate(r3.xyzw * -cb0[8].zzzz + float4(1,1,1,1));
  r4.xyzw = t2.Sample(s3_s, v1.xy).xyzw;
  r4.xyz = cb0[6].www * r4.xyz;
  r3.xy = r4.xy * r3.xy;
  r1.w = r3.x + r3.y;
  r1.w = r4.z * r3.z + r1.w;
  r4.xyzw = r1.wwww * r0.xyzw;
  r2.xyzw = r2.xyzw * float4(0.25,0.25,0.25,0.25) + r4.xyzw;
  r4.xyzw = cb1[0].zzzz * cb0[10].xyzw;
  r4.xyzw = (r4.xyzw >= -r4.xyzw) ? frac(abs(r4.xyzw)) : -frac(abs(r4.xyzw));
  r4.xyzw = r4.xyzw * float4(9,9,9,9) + float4(-4,-4,-4,-4);
  r4.xyzw = r1.zzzz * cb0[7].yyyy + -r4.xyzw;
  r4.xyzw = r4.xyzw * r4.xyzw;
  r4.xyzw = saturate(r4.xyzw * -cb0[8].zzzz + float4(1,1,1,1));
  r5.xyzw = t3.Sample(s4_s, v1.xy).xyzw;
  r3.xyz = cb0[6].www * r5.xyz;
  r1.w = r3.y * r4.x;
  r1.w = r3.x * r3.w + r1.w;
  r1.w = r3.z * r4.y + r1.w;
  r2.xyzw = r0.xyzw * r1.wwww + r2.xyzw;
  r1.w = cb1[0].z * cb0[11].x;
  r1.w = (r1.w >= -r1.w) ? frac(abs(r1.w)) : -frac(abs(r1.w));
  r1.w = r1.w * 9 + -4;
  r1.w = r1.z * cb0[7].y + -r1.w;
  r1.w = r1.w * r1.w;
  r1.w = saturate(r1.w * -cb0[8].z + 1);
  r3.xyzw = t4.Sample(s5_s, v1.xy).xyzw;
  r3.xyz = cb0[6].www * r3.xyz;
  r3.xy = r3.xy * r4.zw;
  r3.x = r3.x + r3.y;
  r1.w = r3.z * r1.w + r3.x;
  r0.xyzw = r0.xyzw * r1.wwww + r2.xyzw;
  r2.xyzw = cb0[12].xyzw + -r0.xyzw;
  r1.w = cb0[6].w * cb0[7].w + cb0[7].z;
  r1.z = -r1.z * r1.w + 1;
  r1.z = 1 + -r1.z;
  r1.z = cb0[12].w * r1.z;
  r0.xyzw = r1.zzzz * r2.xyzw + r0.xyzw;
  if(injectedData.toneMapType == 0.f){
    r0.xyz = saturate(r0.xyz);
  }
  if(injectedData.fxFilmGrainType == 0.f){
  r2.xyz = float3(-0.5,-0.5,-0.5) + r0.xyz;
  r2.xyz = -r2.xyz * float3(2,2,2) + float3(1,1,1);
  r3.xyzw = float4(10,5,5,10) * cb1[0].xxxx;
  r3.xyzw = frac(r3.xyzw);
  r3.xyzw = v1.xyxy + r3.xyzw;
  r4.xyzw = t1.Sample(s2_s, r3.zw).xyzw;
  r3.xyzw = t1.Sample(s2_s, r3.xy).xyzw;
  r3.xyz = float3(-0.5,-0.5,-0.5) + r3.xyz;
  r4.xyw = cb0[3].xyz * r4.xyz;
  r1.zw = r4.xx + r4.yw;
  r1.w = r4.y * r1.w;
  r1.z = r4.z * cb0[3].z + r1.z;
  r1.w = sqrt(r1.w);
  r1.w = dot(cb0[3].ww, r1.ww);
  r1.z = r1.z + r1.w;
  r1.z = cb0[13].z * r1.z * injectedData.fxFilmGrain;
  r3.xyz = r1.zzz * r3.xyz + float3(0.5,0.5,0.5);
  r4.xyz = float3(1,1,1) + -r3.xyz;
  r2.xyz = -r2.xyz * r4.xyz + float3(1,1,1);
  r4.xyz = r0.xyz + r0.xyz;
  r4.xyz = r0.xyz >= (0.5).xxx ? float3(0,0,0) : r4.xyz;
  r5.xyz = r0.xyz >= (0.5).xxx ? float3(1,1,1) : 0;
  r3.xyz = r4.xyz * r3.xyz;
  r0.xyz = r5.xyz * r2.xyz + r3.xyz;
  } else {
    r0.xyz = applyFilmGrain(r0.xyz, v1);
  }
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  r1.z = cb1[6].x / cb1[6].y;
  r1.x = r1.x * r1.z;
  r1.xy = r1.xy / cb0[7].xx;
  r2.xy = float2(0.5,0.5) + r1.xy;
  r1.xyzw = t5.Sample(s1_s, r2.xy).xyzw;
  r2.xyzw = r1.xyzw + -r0.xyzw;
  r0.xyzw = r1.wwww * r2.xyzw + r0.xyzw;
  r1.x = -1 + cb1[0].y;
  r1.y = saturate(cb0[13].w + -r1.x);
  r1.xzw = saturate(cb0[14].zyx + -r1.xxx);
  r2.xyzw = t6.Sample(s6_s, v1.xy).xyzw;
  r1.x = r2.y * r1.x;
  r1.x = r2.x * r1.y + r1.x;
  r1.x = r2.z * r1.z + r1.x;
  r1.x = r2.w * r1.w + r1.x;
  r1.x = 2 * r1.x;
  r1.yzw = float3(0,0,0);
  r0.xyzw = r1.xyzw + r0.xyzw;
  r1.x = -1 + cb0[13].y;
  r1.x = 0.007 * r1.x;
  r1.x = max(0, r1.x);
  r1.x = min(0.01, r1.x);
  o0.xyzw = r0.xyzw * cb0[13].yyyy + r1.xxxx;
  return;
}