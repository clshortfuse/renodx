#include "../../common.hlsl"

Texture2D<float4> t7 : register(t7);
Texture3D<float4> t6 : register(t6);
Texture2D<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s7_s : register(s7);
SamplerState s6_s : register(s6);
SamplerState s5_s : register(s5);
SamplerState s4_s : register(s4);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[52];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + float4(v1, w1);
  r1.xyzw = r0.xyzw * cb0[32].zzzz + float4(0.5,0.5,0.5,0.5);
  r0.xyzw = r0.xyzw * cb0[32].zzzz + -cb0[33].xyxy;
  r0.xyzw = cb0[33].zwzw * r0.xyzw;
  r2.x = dot(r0.xy, r0.xy);
  r2.x = sqrt(r2.x);
  if (cb0[32].w > 0) {
    r2.zw = cb0[32].xy * r2.xx;
    sincos(r2.z, r3.x, r4.x);
    r2.z = r3.x / r4.x;
    r2.w = 1 / r2.w;
    r2.z = r2.z * r2.w + -1;
    r2.zw = r0.xy * r2.zz + r1.xy;
  } else {
    r3.x = 1 / r2.x;
    r3.x = cb0[32].x * r3.x;
    r2.x = cb0[32].y * r2.x;
    r3.y = min(1, abs(r2.x));
    r3.z = max(1, abs(r2.x));
    r3.z = 1 / r3.z;
    r3.y = r3.y * r3.z;
    r3.z = r3.y * r3.y;
    r3.w = r3.z * 0.0208350997 + -0.0851330012;
    r3.w = r3.z * r3.w + 0.180141002;
    r3.w = r3.z * r3.w + -0.330299497;
    r3.z = r3.z * r3.w + 0.999866009;
    r3.w = r3.y * r3.z;
    r3.w = r3.w * -2 + 1.57079637;
    r3.w = abs(r2.x) > 1 ? r3.w : 0;
    r3.y = r3.y * r3.z + r3.w;
    r2.x = min(1, r2.x);
    r2.x = (r2.x < -r2.x) ? -r3.y : r3.y;
    r2.x = r3.x * r2.x + -1;
    r2.zw = r0.xy * r2.xx + r1.xy;
  }
  r3.xyzw = float4(0.5,0.5,0.5,0.5) * r2.zwzw;
  r3.xyzw = frac(r3.xyzw);
  r3.xyzw = r3.xyzw * float4(2,2,2,2) + float4(-1,-1,-1,-1);
  r3.xyzw = float4(1,1,0.5,0.5) + -abs(r3.xyzw);
  r0.xy = r3.zw * cb0[32].zz + float2(0.5,0.5);
  r1.xy = r3.zw * cb0[32].zz + -cb0[33].xy;
  r1.xy = cb0[33].zw * r1.xy;
  r2.x = dot(r1.xy, r1.xy);
  r2.x = sqrt(r2.x);
  if (cb0[32].w > 0) {
    r2.zw = cb0[32].xy * r2.xx;
    sincos(r2.z, r4.x, r5.x);
    r2.z = r4.x / r5.x;
    r2.w = 1 / r2.w;
    r2.z = r2.z * r2.w + -1;
    r2.zw = r1.xy * r2.zz + r0.xy;
  } else {
    r3.z = 1 / r2.x;
    r3.z = cb0[32].x * r3.z;
    r2.x = cb0[32].y * r2.x;
    r3.w = min(1, abs(r2.x));
    r4.x = max(1, abs(r2.x));
    r4.x = 1 / r4.x;
    r3.w = r4.x * r3.w;
    r4.x = r3.w * r3.w;
    r4.y = r4.x * 0.0208350997 + -0.0851330012;
    r4.y = r4.x * r4.y + 0.180141002;
    r4.y = r4.x * r4.y + -0.330299497;
    r4.x = r4.x * r4.y + 0.999866009;
    r4.y = r4.x * r3.w;
    r4.y = r4.y * -2 + 1.57079637;
    r4.y = abs(r2.x) > 1 ? r4.y : 0;
    r3.w = r3.w * r4.x + r4.y;
    r2.x = min(1, r2.x);
    r2.x = (r2.x < -r2.x) ? -r3.w : r3.w;
    r2.x = r3.z * r2.x + -1;
    r2.zw = r1.xy * r2.xx + r0.xy;
  }
  r4.xyzw = float4(0.5,0.5,0.5,0.5) * r2.zwzw;
  r4.xyzw = frac(r4.xyzw);
  r4.xyzw = r4.xyzw * float4(2,2,2,2) + float4(-1,-1,-1,-1);
  r4.xyzw = float4(1,1,1,1) + -abs(r4.xyzw);
  r0.x = dot(r0.zw, r0.zw);
  r0.x = sqrt(r0.x);
  if (cb0[32].w > 0) {
    r1.xy = cb0[32].xy * r0.xx;
    sincos(r1.x, r1.x, r2.x);
    r0.y = r1.x / r2.x;
    r1.x = 1 / r1.y;
    r0.y = r0.y * r1.x + -1;
    r1.xy = r0.zw * r0.yy + r1.zw;
  } else {
    r0.y = 1 / r0.x;
    r0.y = cb0[32].x * r0.y;
    r0.x = cb0[32].y * r0.x;
    r2.x = min(1, abs(r0.x));
    r2.z = max(1, abs(r0.x));
    r2.z = 1 / r2.z;
    r2.x = r2.x * r2.z;
    r2.z = r2.x * r2.x;
    r2.w = r2.z * 0.0208350997 + -0.0851330012;
    r2.w = r2.z * r2.w + 0.180141002;
    r2.w = r2.z * r2.w + -0.330299497;
    r2.z = r2.z * r2.w + 0.999866009;
    r2.w = r2.x * r2.z;
    r2.w = r2.w * -2 + 1.57079637;
    r2.w = abs(r0.x) > 1 ? r2.w : 0;
    r2.x = r2.x * r2.z + r2.w;
    r0.x = min(1, r0.x);
    r0.x = (r0.x < -r0.x) ? -r2.x : r2.x;
    r0.x = r0.y * r0.x + -1;
    r1.xy = r0.zw * r0.xx + r1.zw;
  }
  r0.xy = float2(0.5,0.5) * r1.xy;
  r0.xy = frac(r0.xy);
  r0.xy = r0.xy * float2(2,2) + float2(-1,-1);
  r0.xy = float2(1,1) + -abs(r0.xy);
  r0.zw = float2(0.5,0.5) * w1.xy;
  r1.xyzw = t7.Sample(s7_s, r0.zw).xyzw;
  r0.zw = w1.xy * cb0[51].xy + cb0[51].zw;
  r5.xyzw = t7.Sample(s7_s, r0.zw).xyzw;
  r0.zw = float2(0.025,0.025) * r1.xy;
  r1.zw = r5.xy * r5.xy;
  r0.zw = r1.zw * float2(2,2) + r0.zw;
  r1.zw = float2(0.025,0.025) * r5.xy;
  r1.xy = r1.xy * float2(0.1,0.1) + r1.zw;
  r0.zw = r1.xy * cb0[40].ww + r0.zw;
  r0.zw = cb0[50].ww * r0.zw * injectedData.fxFilmGrain;
  r0.zw = r0.zw * float2(0.075,0.075) + v1.xy;
  r1.xyzw = t3.Sample(s3_s, v1.xy).xyzw;
  r0.zw = float2(-0.5,-0.5) + r0.zw;
  r1.yz = r0.zw * cb0[32].zz + float2(0.5,0.5);
  r0.zw = r0.zw * cb0[32].zz + -cb0[33].xy;
  r0.zw = cb0[33].zw * r0.zw;
  r1.w = dot(r0.zw, r0.zw);
  r1.w = sqrt(r1.w);
  if (cb0[32].w > 0) {
    r2.xy = cb0[32].xy * r1.ww;
    sincos(r2.x, r2.x, r6.x);
    r2.x = r2.x / r6.x;
    r2.y = 1 / r2.y;
    r2.x = r2.x * r2.y + -1;
    r2.xy = r0.zw * r2.xx + r1.yz;
  } else {
    r2.z = 1 / r1.w;
    r2.z = cb0[32].x * r2.z;
    r1.w = cb0[32].y * r1.w;
    r2.w = min(1, abs(r1.w));
    r3.z = max(1, abs(r1.w));
    r3.z = 1 / r3.z;
    r2.w = r3.z * r2.w;
    r3.z = r2.w * r2.w;
    r3.w = r3.z * 0.0208350997 + -0.0851330012;
    r3.w = r3.z * r3.w + 0.180141002;
    r3.w = r3.z * r3.w + -0.330299497;
    r3.z = r3.z * r3.w + 0.999866009;
    r3.w = r3.z * r2.w;
    r3.w = r3.w * -2 + 1.57079637;
    r3.w = abs(r1.w) > 1 ? r3.w : 0;
    r2.w = r2.w * r3.z + r3.w;
    r1.w = min(1, r1.w);
    r1.w = (r1.w < -r1.w) ? -r2.w : r2.w;
    r1.w = r2.z * r1.w + -1;
    r2.xy = r0.zw * r1.ww + r1.yz;
  }
  r2.xy = saturate(r2.xy);
  r0.zw = cb0[30].zz * r2.xy;
  r2.xyzw = t2.Sample(s2_s, r0.zw).xyzw;
  r0.xyzw = t1.Sample(s1_s, r0.xy).xyzw;
  r0.xyz = r0.xyz * r1.xxx;
  r1.yz = r5.xy * float2(0.15,0.15) + r3.xy;
  r3.xy = saturate(r1.yz);
  r3.xy = cb0[30].zz * r3.xy;
  r3.xyzw = t4.Sample(s4_s, r3.xy).xyzw;
  r6.xy = r1.yz * cb0[38].xy + cb0[38].zw;
  r6.xyzw = t5.Sample(s5_s, r6.xy).xyzw;
  r1.w = r6.x * 0.1 + 0.55;
  r7.xy = float2(0.5,0.5) + -r1.yz;
  r8.xyzw = float4(0.1,0.1,0.02,0.02) * r7.xyxy;
  r9.xyzw = r6.xyxy * r6.xyxy;
  r9.xyzw = r9.xyzw * float4(0.2,0.2,0.2,0.2) + float4(0.99,0.99,0.98,0.98);
  r9.xyzw = -r9.xyzw * float4(0.5,0.5,0.5,0.5) + r1.yzyz;
  r9.xyzw = saturate(float4(0.5,0.5,0.5,0.5) + r9.xyzw);
  r9.xyzw = cb0[30].zzzz * r9.xyzw;
  r10.xyzw = t4.Sample(s4_s, r9.xy).xyzw;
  r9.xyzw = t4.Sample(s4_s, r9.zw).xyzw;
  r10.xyzw = r3.xyzw * float4(0.75,0.75,0.75,0.75) + r10.xyzw;
  r9.xyzw = r10.xyzw + r9.xyzw;
  r9.xyzw = float4(4,4,4,4) * r9.xyzw;
  r9.xyzw = min(float4(0.2,0.2,0.2,0.2), r9.xyzw);
  r3.xyzw = r3.xyzw * float4(0.5,0.5,0.5,0.5) + r9.xyzw;
  r4.xy = r4.xy * float2(-0.5,0.8) + float2(1,0.1);
  r4.xy = saturate(r4.xy + r3.xy);
  r4.xy = cb0[30].zz * r4.xy;
  r9.xyzw = t4.Sample(s4_s, r4.xy).xyzw;
  r4.xy = r4.zw * float2(-0.5,-0.5) + r3.xy;
  r4.xy = saturate(float2(0.8,0.8) + r4.xy);
  r4.xy = cb0[30].zz * r4.xy;
  r4.xyzw = t4.Sample(s4_s, r4.xy).xyzw;
  r4.xyzw = r9.xyzw + r4.xyzw;
  r4.xyzw = min(float4(0.1,0.1,0.1,0.1), r4.xyzw);
  r3.xyzw = r4.xyzw + r3.xyzw;
  r4.x = dot(r8.xy, r8.xy);
  r4.x = rsqrt(r4.x);
  r4.xy = r8.xy * r4.xx;
  r4.zw = r4.xy * r1.ww;
  r4.zw = r4.zw * float2(0.9,0.9) + v1.xy;
  r4.zw = frac(r4.zw);
  r4.zw = float2(0.5,0.5) + -r4.zw;
  r4.z = dot(r4.zw, r4.zw);
  r4.z = sqrt(r4.z);
  r4.z = -r4.z * 3.25626826 + 1;
  r4.z = max(0, r4.z);
  r4.z = r4.z * r4.z;
  r1.yz = r4.xy * r1.ww + r1.yz;
  r4.xy = saturate(r1.yz);
  r4.xy = cb0[30].zz * r4.xy;
  r9.xyzw = t4.Sample(s4_s, r4.xy).xyzw;
  r4.xy = saturate(r8.zw * r6.xy + r1.yz);
  r4.xy = cb0[30].zz * r4.xy;
  r8.xyzw = t4.Sample(s4_s, r4.xy).xyzw;
  r4.xy = float2(0.04,0.04) * r7.xy;
  r1.yz = saturate(r4.xy * r6.xy + r1.yz);
  r1.yz = cb0[30].zz * r1.yz;
  r7.xyzw = t4.Sample(s4_s, r1.yz).xyzw;
  r8.xyzw = r9.xyzw + r8.xyzw;
  r7.xyzw = r8.xyzw + r7.xyzw;
  r7.xyzw = min(float4(5,5,5,5), r7.xyzw);
  r4.xyzw = r7.xyzw * r4.zzzz;
  r3.xyzw = r4.xyzw * float4(0.2,0.2,0.2,0.2) + r3.xyzw;
  r1.x = -1 + r1.x;
  r1.x = r1.x * 0.75 + 1;
  r1.x = cb0[39].y * r1.x * injectedData.fxBloom;
  r1.xyzw = r3.xyzw * r1.xxxx;
  r3.xyz = cb0[39].zzz * r6.xyz * injectedData.fxLens;
  r3.w = 0;
  r3.xyzw = float4(1,1,1,1) + r3.xyzw;
  r0.xyzw = r1.xyzw * r3.xyzw + r0.xyzw;
  r3.x = saturate(r2.w);
  r3.xy = float2(1.1,1.5) * r3.xx;
  r3.x = min(1, r3.x);
  r3.x = 1 + -r3.x;
  r4.xyzw = r3.xxxx * r0.xyzw;
  r2.xyzw = r2.xyzw + r2.xyzw;
  r1.xyzw = r1.xyzw * float4(0.25,0.25,0.25,0.25) + r2.xyzw;
  r0.xyzw = -r0.xyzw * r3.xxxx + r1.xyzw;
  r0.xyzw = r3.yyyy * r0.xyzw + r4.xyzw;
  r1.xyz = r0.xyz * r5.xyz;
  if(injectedData.fxFilmGrainType == 0.f){
  r1.xyz = r1.xyz * cb0[50].www * injectedData.fxFilmGrain + r0.xyz;
  } else {
    r1.xyz = applyFilmGrain(r0.xyz, v1);
  }
  r1.xyz = cb0[45].xxx * r1.xyz;
  r1.xyz = lutShaper(r1.xyz);
  if(injectedData.colorGradeLUTSampling == 0.f){
  r1.xyz = cb0[42].zzz * r1.xyz;
  r1.w = 0.5 * cb0[42].y;
  r1.xyz = r1.xyz * cb0[42].yyy + r1.www;
  r1.xyzw = t6.Sample(s6_s, r1.xyz).xyzw;
  } else {
    r1.xyz = renodx::lut::SampleTetrahedral(t6, r1.xyz, 1 / cb0[42].y);
  }
  if (cb0[50].y < 0.5) {
    r0.x = dot(r0.xyz, float3(0.272228986,0.674081981,0.0536894985));
    r0.yz = -cb0[48].xy + v1.xy;
    r2.yz = cb0[49].xx * abs(r0.zy) * min(1.f, injectedData.fxVignette);
    r0.y = cb0[26].x / cb0[26].y;
    r0.y = -1 + r0.y;
    r0.y = cb0[49].w * r0.y + 1;
    r2.x = r2.z * r0.y;
    r2.xy = saturate(r2.xy);
    r0.yz = log2(r2.xy);
    r0.yz = cb0[49].zz * r0.yz;
    r0.yz = exp2(r0.yz);
    r0.y = dot(r0.yz, r0.yz);
    r0.y = 1 + -r0.y;
    r0.y = max(0, r0.y);
    r0.y = log2(r0.y);
    r0.y = cb0[49].y * r0.y * max(1.f, injectedData.fxVignette);
    r0.y = exp2(r0.y);
    r0.z = r0.y * r0.y;
    r1.w = r0.z * r0.x;
    r2.xyz = -r0.zzz * r0.xxx + r1.xyz;
    r2.xyz = r0.yyy * r2.xyz + r1.www;
    r0.x = r0.w * cb0[45].x + -1;
    r0.w = r0.y * r0.x + 1;
  } else {
    r3.xyz = r1.xyz * cb0[47].xyz + -r1.xyz;
    r2.xyz = cb0[50].xxx * r3.xyz + r1.xyz;
    r0.w = 1;
  }
  r1.xy = v1.xy * cb0[35].xy + cb0[35].zw;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.x = r1.w * 2 + -1;
  r1.y = saturate(r1.x * renodx::math::FLT_MAX + 0.5);
  r1.y = r1.y * 2 + -1;
  r1.x = 1 + -abs(r1.x);
  r1.x = sqrt(r1.x);
  r1.x = 1 + -r1.x;
  r1.x = r1.y * r1.x;
  r0.xyz = applyDither(r2.xyz, r1.x * (1.0 / 64.0));
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyzw = r0.xyzw;
  return;
}