#include "../../common.hlsli"

Texture2D<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s5_s : register(s5);
SamplerState s4_s : register(s4);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[20];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = -cb0[3].xy + v1.xy;
  r0.xyzw = t1.SampleLevel(s2_s, r0.xy, 0).xyzw;
  r1.xyzw = cb0[3].xyxy * float4(-1,0,-1,1) + v1.xyxy;
  r2.xyzw = t1.SampleLevel(s2_s, r1.xy, 0).xyzw;
  r1.xyzw = t1.SampleLevel(s2_s, r1.zw, 0).xyzw;
  r2.xyz = float3(0.125,0.125,0.125) * r2.xyz;
  r0.xyz = r0.xyz * float3(0.0625,0.0625,0.0625) + r2.xyz;
  r0.xyz = r1.xyz * float3(0.0625,0.0625,0.0625) + r0.xyz;
  r1.xyzw = cb0[3].xyxy * float4(0,-1,0,1) + v1.xyxy;
  r2.xyzw = t1.SampleLevel(s2_s, r1.xy, 0).xyzw;
  r1.xyzw = t1.SampleLevel(s2_s, r1.zw, 0).xyzw;
  r0.xyz = r2.xyz * float3(0.125,0.125,0.125) + r0.xyz;
  r2.xyzw = t1.SampleLevel(s2_s, v1.xy, 0).xyzw;
  r0.xyz = r2.xyz * float3(0.25,0.25,0.25) + r0.xyz;
  r0.xyz = r1.xyz * float3(0.125,0.125,0.125) + r0.xyz;
  r1.xyzw = cb0[3].xyxy * float4(1,-1,1,0) + v1.xyxy;
  r2.xyzw = t1.SampleLevel(s2_s, r1.xy, 0).xyzw;
  r1.xyzw = t1.SampleLevel(s2_s, r1.zw, 0).xyzw;
  r0.xyz = r2.xyz * float3(0.0625,0.0625,0.0625) + r0.xyz;
  r0.xyz = r1.xyz * float3(0.125,0.125,0.125) + r0.xyz;
  r1.xy = cb0[3].xy + v1.xy;
  r1.xyzw = t1.SampleLevel(s2_s, r1.xy, 0).xyzw;
  r0.xyz = r1.xyz * float3(0.0625,0.0625,0.0625) + r0.xyz;
  r0.xyz = cb0[14].zzz * r0.xyz * CUSTOM_BLOOM;
  r1.xyzw = t0.SampleLevel(s1_s, v1.xy, 0).xyzw;
  r2.xyz = r0.xyz * cb0[15].yyy + -r1.xyz;
  r0.xyz = r0.xyz * cb0[14].yyy + -r1.xyz;
  r0.xyz = cb0[14].xxx * r0.xyz + r1.xyz;
  r3.xyzw = t2.Sample(s3_s, v1.xy).xyzw;
  r1.xyz = r3.xyz * r2.xyz + r1.xyz;
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = cb0[15].xxx * r1.xyz + r0.xyz;
  r1.xy = v1.xy * cb0[19].zz + cb0[19].ww;
  r1.xy = float2(-0.5,-0.5) + r1.xy;
  r0.w = cb0[19].y * r1.y;
  r0.w = cb0[19].x * r1.x + -r0.w;
  r1.x = dot(cb0[19].yx, r1.xy);
  r1.y = 0.5 + r1.x;
  r1.x = 0.5 + r0.w;
  r1.xyzw = t3.SampleLevel(s5_s, r1.xy, 0).xyzw;
  r2.xyzw = t4.SampleLevel(s4_s, v1.xy, 0).xyzw;
  r1.xyz = r2.xyz * r1.xyz;
  r2.xyz = cb0[15].www * r1.xyz;
  r2.xyz = r2.xyz * r3.xyz + -r1.xyz;
  r1.xyz = cb0[15].zzz * r2.xyz + r1.xyz;
  r0.xyz = r1.xyz + r0.xyz;
  r1.xyz = cb0[17].xyz * r0.xyz;
  r0.xyz = -cb0[17].xyz * r0.xyz + r0.xyz;
  r2.xy = v1.xy * float2(2,2) + float2(-1,-1);
  r2.xy = cb0[16].zz * r2.xy;
  r0.w = dot(r2.xy, r2.xy);
  r0.w = 1 + -r0.w;
  r0.w = max(0, r0.w);
  r0.w = r0.w * r0.w + -1;
  r0.w = cb0[16].y * r0.w + 1;
  r0.xyz = r0.www * r0.xyz + r1.xyz;
  r0.w = v1.y * 541.169983 + v1.x;
  r0.w = cb0[18].x + r0.w;
  r0.w = sin(r0.w);
  r0.w = r0.w * 273351.5 + -cb0[18].x;
  r0.w = frac(r0.w);
  r0.w = r0.w * 2 + -1;
  r0.w = cb0[16].x * r0.w;
  r0.xyz = r0.www * r0.xyz + r0.xyz;
  r1.xyzw = t5.SampleLevel(s0_s, float2(0.5,0.5), 0).xyzw;
  r0.xyz = r1.xxx * r0.xyz;
  r0.xyz = Uncharted2Tonemap(r0.xyz, 0.22, 0.3, 0.1, 0.2, 0.01, 0.3, uncharted2GetLinearWhite(cb0[18].y, 0.22, 0.3, 0.1, 0.2, 0.01, 0.3));
  if (CUSTOM_COUNT_OLD == CUSTOM_COUNT_NEW) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}