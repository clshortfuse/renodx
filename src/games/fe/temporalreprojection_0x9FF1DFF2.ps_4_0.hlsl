#include "./common.hlsl"

Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[2];
}
cbuffer cb0 : register(b0){
  float4 cb0[11];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0,
  out float4 o1 : SV_Target1)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(1,0);
  r1.x = 0;
  r2.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r1.z = r2.x;
  r3.xy = float2(-1,0);
  r4.xy = float2(1,-1);
  r5.xy = float2(0,-1);
  r6.x = -1;
  r7.x = 0;
  r7.y = cb0[2].y;
  r7.w = cb0[3].y;
  r8.xyzw = v1.xyxy + -r7.xyxw;
  r7.xyzw = v1.xyxy + r7.xyxw;
  r9.xyzw = t0.Sample(s0_s, r8.xy).xyzw;
  r5.z = r9.x;
  r10.x = cb0[2].x;
  r10.yw = float2(0,0);
  r1.yw = -r10.xy + r8.xy;
  r11.xyzw = t0.Sample(s0_s, r1.yw).xyzw;
  r6.z = r11.x;
  r2.yzw = (r9.x < r11.x) ? r5.xyz : r6.xxz;
  r1.yw = r10.xy + r8.xy;
  r5.xyzw = t0.Sample(s0_s, r1.yw).xyzw;
  r4.z = r5.x;
  r2.yzw = (r5.x < r2.w) ? r4.xyz : r2.yzw;
  r1.yw = v1.xy + -r10.xy;
  r4.xyzw = t0.Sample(s0_s, r1.yw).xyzw;
  r3.z = r4.x;
  r2.yzw = (r4.x < r2.w) ? r3.xyz : r2.yzw;
  r1.xyz = (r2.x < r2.w) ? r1.xxz : r2.yzw;
  r2.xy = v1.xy + r10.xy;
  r2.xyzw = t0.Sample(s0_s, r2.xy).xyzw;
  r0.z = r2.x;
  r0.xyz = (r2.x < r1.z) ? r0.xyz : r1.xyz;
  r1.xy = -r10.xy + r7.xy;
  r1.zw = r10.xy + r7.xy;
  r2.xyzw = t0.Sample(s0_s, r1.zw).xyzw;
  r1.xyzw = t0.Sample(s0_s, r1.xy).yzxw;
  r1.xy = float2(-1,1);
  r0.xyz = (r1.z < r0.z) ? r1.xyz : r0.xyz;
  r1.xyzw = t0.Sample(s0_s, r7.xy).yzxw;
  r1.xy = float2(0,1);
  r0.xyz = (r1.z < r0.z) ? r1.xyz : r0.xyz;
  r0.xy = (r2.x < r0.z) ? float2(1,1) : r0.xy;
  r0.xy = cb0[2].xy * r0.xy + v1.xy;
  r0.xyzw = t1.Sample(s2_s, r0.xy).xyzw;
  r0.xy = v1.xy + -r0.xy;
  r0.xyzw = t3.Sample(s3_s, r0.xy).xyzw;
  r10.z = cb0[3].x;
  r1.xy = r10.zw + r8.zw;
  r1.xyzw = t2.Sample(s1_s, r1.xy).xyzw;
  r2.xy = -r10.zw + r8.zw;
  r3.xyzw = t2.Sample(s1_s, r8.zw).xyzw;
  r2.xyzw = t2.Sample(s1_s, r2.xy).xyzw;
  r4.x = r2.w + r3.w;
  r4.x = r4.x + r1.w;
  r4.yz = v1.xy + -r10.zw;
  r5.xyzw = t2.Sample(s1_s, r4.yz).xyzw;
  r4.x = r5.w + r4.x;
  r6.xyzw = t2.Sample(s1_s, v1.xy).xyzw;
  r4.x = r6.w + r4.x;
  r4.yz = v1.xy + r10.zw;
  r8.xyzw = t2.Sample(s1_s, r4.yz).xyzw;
  r4.x = r8.w + r4.x;
  r4.yz = -r10.zw + r7.zw;
  r7.xy = r10.zw + r7.zw;
  r9.xyzw = t2.Sample(s1_s, r7.zw).xyzw;
  r7.xyzw = t2.Sample(s1_s, r7.xy).xyzw;
  r10.xyzw = t2.Sample(s1_s, r4.yz).xyzw;
  r4.x = r10.w + r4.x;
  r4.x = r4.x + r9.w;
  r4.x = r4.x + r7.w;
  r4.y = r5.w + r3.w;
  r4.y = r4.y + r6.w;
  r4.y = r4.y + r8.w;
  r4.y = r4.y + r9.w;
  r4.y = 0.2 * r4.y;
  r4.x = r4.x * (1.0 / 9.0) + r4.y;
  r4.x = 0.5 * r4.x;
  r11.xyzw = min(r9.xyzw, r7.xyzw);
  r7.xyzw = max(r9.xyzw, r7.xyzw);
  r7.xyzw = max(r10.xyzw, r7.xyzw);
  r10.xyzw = min(r11.xyzw, r10.xyzw);
  r10.xyzw = min(r10.xyzw, r8.xyzw);
  r10.xyzw = min(r10.xyzw, r6.xyzw);
  r10.xyzw = min(r10.xyzw, r5.xyzw);
  r10.xyzw = min(r10.xyzw, r1.xyzw);
  r10.xyzw = min(r10.xyzw, r3.xyzw);
  r10.xyzw = min(r10.xyzw, r2.xyzw);
  r7.xyzw = max(r8.xyzw, r7.xyzw);
  r7.xyzw = max(r7.xyzw, r6.xyzw);
  r7.xyzw = max(r7.xyzw, r5.xyzw);
  r1.xyzw = max(r7.xyzw, r1.xyzw);
  r1.xyzw = max(r3.xyzw, r1.xyzw);
  r1.xyzw = max(r2.xyzw, r1.xyzw);
  r2.xyzw = min(r9.xyzw, r8.xyzw);
  r7.xyzw = max(r9.xyzw, r8.xyzw);
  r7.xyzw = max(r7.xyzw, r6.xyzw);
  r2.xyzw = min(r6.xyzw, r2.xyzw);
  r2.xyzw = min(r5.xyzw, r2.xyzw);
  r5.xyzw = max(r7.xyzw, r5.xyzw);
  r5.xyzw = max(r5.xyzw, r3.xyzw);
  r2.xyzw = min(r3.xyzw, r2.xyzw);
  r2.xyzw = r10.xyzw + r2.xyzw;
  r2.xyzw = float4(0.5,0.5,0.5,0.5) * r2.xyzw;
  r1.xyzw = r5.xyzw + r1.xyzw;
  r2.w = max(r4.x, r2.w);
  r1.w = 0.5 * r1.w;
  r3.w = min(r2.w, r1.w);
  r4.xyz = r1.xyz * float3(0.5,0.5,0.5) + r2.xyz;
  r1.xyz = r1.xyz * float3(0.5,0.5,0.5) + -r2.xyz;
  r1.xyz = float3(0.5,0.5,0.5) * r1.xyz;
  r3.xyz = float3(0.5,0.5,0.5) * r4.xyz;
  r2.xyzw = -r3.xyzw + r0.xyzw;
  r1.xyz = r2.xyz / r1.xyz;
  r1.y = max(abs(r1.y), abs(r1.z));
  r1.x = max(abs(r1.x), r1.y);
  r2.xyzw = r2.xyzw / r1.xxxx;
  r2.xyzw = r3.xyzw + r2.xyzw;
  r0.xyzw = (r1.x > 1) ? r2.xyzw : r0.xyzw;
  r1.x = dot(r0.xyz, float3(0.219999999,0.707000017,0.0710000023));
  r1.y = max(0.2, r1.x);
  r1.zw = -cb0[5].xy * cb0[3].xy + v1.xy;
  r2.xyzw = t2.Sample(s1_s, r1.zw).xyzw;
  r1.z = dot(r2.xyz, float3(0.219999999,0.707000017,0.0710000023));
  r1.y = max(r1.z, r1.y);
  r1.x = r1.z + -r1.x;
  r1.x = abs(r1.x) / r1.y;
  r1.x = 1 + -r1.x;
  r1.x = r1.x * r1.x;
  r1.y = cb0[10].y + -cb0[10].x;
  r1.x = r1.x * r1.y + cb0[10].x;
  r0.xyzw = -r2.xyzw + r0.xyzw;
  r0.xyzw = r1.xxxx * r0.xyzw + r2.xyzw;
  r1.xy = cb1[1].xx + v1.xy;
  r1.xy = float2(0.695917428,0.695917428) + r1.xy;
  r1.x = dot(r1.xy, float2(12.9898005,78.2330017));
  r1.x = sin(r1.x);
  r1.xyzw = float4(43758.5469,28001.8379,50849.4141,12996.8896) * r1.xxxx;
  r1.xyzw = frac(r1.xyzw);
  r1.xyzw = r1.xyzw * float4(2,2,2,2) + float4(-1,-1,-1,-1);
  r0.xyzw = r1.xyzw * float4(0.00196078443, 0.00196078443, 0.00196078443, 0.00196078443) + r0.xyzw;
  if (injectedData.toneMapType == 0.f) {
    r0 = saturate(r0);
  }
  o0.xyzw = r0.xyzw;
  o1.xyzw = r0.xyzw;
  return;
}