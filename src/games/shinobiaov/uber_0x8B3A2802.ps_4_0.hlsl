#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Sun Aug 31 15:39:50 2025
Texture3D<float4> t6 : register(t6);

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

cbuffer cb0 : register(b0) {
  float4 cb0[37];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    float2 w1: TEXCOORD1,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4, r5, r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = v1.xyxy * float4(2, 2, 2, 2) + float4(-1, -1, -1, -1);
  r1.x = dot(r0.zw, r0.zw);
  r0.xyzw = r1.xxxx * r0.xyzw;
  r0.xyzw = cb0[35].wwww * r0.xyzw;
  r0.xyzw = saturate(r0.xyzw * float4(-0.333333343, -0.333333343, -0.666666687, -0.666666687) + v1.xyxy);
  r0.xyzw = cb0[26].xxxx * r0.xyzw;
  r1.xyzw = t1.SampleLevel(s1_s, r0.zw, 0).xyzw;
  r0.xyzw = t1.SampleLevel(s1_s, r0.xy, 0).xyzw;
  r2.w = 1;
  r3.xyzw = t5.SampleLevel(s5_s, float2(0.5, 0), 0).xyzw;
  r2.xyz = r3.xyz;
  r0.xyzw = r2.xyzw * r0.xyzw;
  r3.xy = saturate(v1.xy);
  r3.xy = cb0[26].xx * r3.xy;
  r4.xyzw = t1.SampleLevel(s1_s, r3.xy, 0).xyzw;
  r3.xyzw = t3.Sample(s3_s, r3.xy).xyzw;
  r5.w = 1;
  r6.xyzw = t5.SampleLevel(s5_s, float2(0.166666999, 0), 0).xyzw;
  r5.xyz = r6.xyz;
  r2.xyz = r5.xyz + r2.xyz;
  r0.xyzw = r4.xyzw * r5.xyzw + r0.xyzw;
  r4.w = 1;
  r5.xyzw = t5.SampleLevel(s5_s, float2(0.833333015, 0), 0).xyzw;
  r4.xyz = r5.xyz;
  r2.xyz = r4.xyz + r2.xyz;
  r0.xyzw = r1.xyzw * r4.xyzw + r0.xyzw;
  r2.w = 3;
  r0.xyzw = r0.xyzw / r2.xyzw;
  r1.xyz = float3(0.0549999997, 0.0549999997, 0.0549999997) + r0.xyz;
  r1.xyz = float3(0.947867334, 0.947867334, 0.947867334) * r1.xyz;
  r1.xyz = max(float3(1.1920929e-07, 1.1920929e-07, 1.1920929e-07), abs(r1.xyz));
  r1.xyz = log2(r1.xyz);
  r1.xyz = float3(2.4000001, 2.4000001, 2.4000001) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r2.xyz = float3(0.0773993805, 0.0773993805, 0.0773993805) * r0.xyz;
  r4.xyz = cmp(float3(0.0404499993, 0.0404499993, 0.0404499993) >= r0.xyz);
  r1.xyz = r4.xyz ? r2.xyz : r1.xyz;
  r2.xyzw = t2.Sample(s2_s, v1.xy).xyzw;
  r0.xyz = r2.xxx * r1.xyz;
  r1.xyzw = float4(1, 1, -1, 0) * cb0[32].xyxy;
  r2.xyzw = saturate(-r1.xywy * cb0[34].xxxx + v1.xyxy);
  r2.xyzw = cb0[26].xxxx * r2.xyzw;
  r4.xyzw = t3.Sample(s3_s, r2.xy).xyzw;
  r2.xyzw = t3.Sample(s3_s, r2.zw).xyzw;
  r2.xyzw = r2.xyzw * float4(2, 2, 2, 2) + r4.xyzw;
  r4.xy = saturate(-r1.zy * cb0[34].xx + v1.xy);
  r4.xy = cb0[26].xx * r4.xy;
  r4.xyzw = t3.Sample(s3_s, r4.xy).xyzw;
  r2.xyzw = r4.xyzw + r2.xyzw;
  r4.xyzw = saturate(r1.zwxw * cb0[34].xxxx + v1.xyxy);
  r4.xyzw = cb0[26].xxxx * r4.xyzw;
  r5.xyzw = t3.Sample(s3_s, r4.xy).xyzw;
  r4.xyzw = t3.Sample(s3_s, r4.zw).xyzw;
  r2.xyzw = r5.xyzw * float4(2, 2, 2, 2) + r2.xyzw;
  r2.xyzw = r3.xyzw * float4(4, 4, 4, 4) + r2.xyzw;
  r2.xyzw = r4.xyzw * float4(2, 2, 2, 2) + r2.xyzw;
  r3.xyzw = saturate(r1.zywy * cb0[34].xxxx + v1.xyxy);
  r1.xy = saturate(r1.xy * cb0[34].xx + v1.xy);
  r1.xy = cb0[26].xx * r1.xy;
  r1.xyzw = t3.Sample(s3_s, r1.xy).xyzw;
  r3.xyzw = cb0[26].xxxx * r3.xyzw;
  r4.xyzw = t3.Sample(s3_s, r3.xy).xyzw;
  r3.xyzw = t3.Sample(s3_s, r3.zw).xyzw;
  r2.xyzw = r4.xyzw + r2.xyzw;
  r2.xyzw = r3.xyzw * float4(2, 2, 2, 2) + r2.xyzw;
  r1.xyzw = r2.xyzw + r1.xyzw;
  r1.xyzw = cb0[34].yyyy * r1.xyzw;
  r2.xyzw = float4(0.0625, 0.0625, 0.0625, 1) * r1.xyzw;
  r1.xyzw = float4(0.0625, 0.0625, 0.0625, 0.0625) * r1.xyzw;
  r3.xyz = cb0[35].xyz * r2.xyz;
  r3.w = 0.0625 * r2.w;
  r0.xyzw = r3.xyzw + r0.xyzw;
  r2.xy = v1.xy * cb0[33].xy + cb0[33].zw;
  r2.xyzw = t4.Sample(s4_s, r2.xy).xyzw;
  r2.xyz = cb0[34].zzz * r2.xyz;
  r2.w = 0;
  r0.xyzw = r2.xyzw * r1.xyzw + r0.xyzw;
  r0.xyzw = cb0[36].zzzz * r0.xyzw;
  r0.xyz = r0.xyz * float3(5.55555582, 5.55555582, 5.55555582) + float3(0.0479959995, 0.0479959995, 0.0479959995);
  o0.w = r0.w;
  r0.xyz = log2(r0.xyz);
  r0.xyz = saturate(r0.xyz * float3(0.0734997839, 0.0734997839, 0.0734997839) + float3(0.386036009, 0.386036009, 0.386036009));
  r0.xyz = cb0[36].yyy * r0.xyz;
  r0.w = 0.5 * cb0[36].x;
  r0.xyz = r0.xyz * cb0[36].xxx + r0.www;
  r0.xyzw = t6.Sample(s6_s, r0.xyz).xyzw;
  r1.xyz = max(float3(1.1920929e-07, 1.1920929e-07, 1.1920929e-07), abs(r0.xyz));
  r1.xyz = log2(r1.xyz);
  r1.xyz = float3(0.416666657, 0.416666657, 0.416666657) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.xyz = r1.xyz * float3(1.05499995, 1.05499995, 1.05499995) + float3(-0.0549999997, -0.0549999997, -0.0549999997);
  r2.xyz = float3(12.9200001, 12.9200001, 12.9200001) * r0.xyz;
  r0.xyz = cmp(float3(0.00313080009, 0.00313080009, 0.00313080009) >= r0.xyz);
  r0.xyz = r0.xyz ? r2.xyz : r1.xyz;
  r1.xy = v1.xy * cb0[30].xy + cb0[30].zw;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r0.w = r1.w * 2 + -1;
  r1.x = 1 + -abs(r0.w);
  r0.w = saturate(r0.w * 3.40282347e+38 + 0.5);
  r0.w = r0.w * 2 + -1;
  r1.x = sqrt(r1.x);
  r1.x = 1 + -r1.x;
  r0.w = r1.x * r0.w;
  o0.xyz = r0.www * float3(0.00392156886, 0.00392156886, 0.00392156886) + r0.xyz;

  o0.rgb = ApplyTonemapScaling(o0.rgb);

  return;
}
