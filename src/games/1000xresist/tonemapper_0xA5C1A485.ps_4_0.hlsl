#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.4.1 on Thu May  8 16:30:41 2025
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

cbuffer cb0 : register(b0) {
  float4 cb0[41];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    float2 w1: TEXCOORD1,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4, r5, r6, r7, r8, r9;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(-0.5, -0.5) + v1.xy;
  r0.zw = r0.xy * cb0[28].zz + float2(0.5, 0.5);
  r0.xy = r0.xy * cb0[28].zz + -cb0[29].xy;
  r0.xy = cb0[29].zw * r0.xy;
  r1.x = dot(r0.xy, r0.xy);
  r1.x = sqrt(r1.x);
  r1.y = cmp(0 < cb0[28].w);
  if (r1.y != 0) {
    r1.zw = cb0[28].xy * r1.xx;
    sincos(r1.z, r2.x, r3.x);
    r1.z = r2.x / r3.x;
    r1.w = 1 / r1.w;
    r1.z = r1.z * r1.w + -1;
    r1.zw = r0.xy * r1.zz + r0.zw;
  } else {
    r2.x = 1 / r1.x;
    r2.x = cb0[28].x * r2.x;
    r1.x = cb0[28].y * r1.x;
    r2.y = min(1, abs(r1.x));
    r2.z = max(1, abs(r1.x));
    r2.z = 1 / r2.z;
    r2.y = r2.y * r2.z;
    r2.z = r2.y * r2.y;
    r2.w = r2.z * 0.0208350997 + -0.0851330012;
    r2.w = r2.z * r2.w + 0.180141002;
    r2.w = r2.z * r2.w + -0.330299497;
    r2.z = r2.z * r2.w + 0.999866009;
    r2.w = r2.y * r2.z;
    r3.x = cmp(1 < abs(r1.x));
    r2.w = r2.w * -2 + 1.57079637;
    r2.w = r3.x ? r2.w : 0;
    r2.y = r2.y * r2.z + r2.w;
    r1.x = min(1, r1.x);
    r1.x = cmp(r1.x < -r1.x);
    r1.x = r1.x ? -r2.y : r2.y;
    r1.x = r2.x * r1.x + -1;
    r1.zw = r0.xy * r1.xx + r0.zw;
  }
  r0.xyzw = t2.Sample(s2_s, v1.xy).xyzw;
  r0.yz = v1.xy * float2(2, 2) + float2(-1, -1);
  r0.w = dot(r0.yz, r0.yz);
  r0.yz = r0.yz * r0.ww;
  r0.yz = cb0[35].ww * r0.yz * injectedData.fxChroma;
  r2.xy = cb0[31].zw * -r0.yz;
  r2.xy = float2(0.5, 0.5) * r2.xy;
  r0.w = dot(r2.xy, r2.xy);
  r0.w = sqrt(r0.w);
  r0.w = (int)r0.w;
  r0.w = max(3, (int)r0.w);
  r0.w = min(16, (int)r0.w);
  r1.x = (int)r0.w;
  r0.yz = -r0.yz / r1.xx;
  r2.y = 0;
  r3.w = 1;
  r4.xyzw = float4(0, 0, 0, 0);
  r5.xyzw = float4(0, 0, 0, 0);
  r2.zw = v1.xy;
  r6.x = 0;
  while (true) {
    r6.y = cmp((int)r6.x >= (int)r0.w);
    if (r6.y != 0) break;
    r6.y = (int)r6.x;
    r6.y = 0.5 + r6.y;
    r2.x = r6.y / r1.x;
    r6.yz = float2(-0.5, -0.5) + r2.zw;
    r7.xy = r6.yz * cb0[28].zz + float2(0.5, 0.5);
    r6.yz = r6.yz * cb0[28].zz + -cb0[29].xy;
    r6.yz = cb0[29].zw * r6.yz;
    r6.w = dot(r6.yz, r6.yz);
    r6.w = sqrt(r6.w);
    if (r1.y != 0) {
      r7.zw = cb0[28].xy * r6.ww;
      sincos(r7.z, r8.x, r9.x);
      r7.z = r8.x / r9.x;
      r7.w = 1 / r7.w;
      r7.z = r7.z * r7.w + -1;
      r7.zw = r6.yz * r7.zz + r7.xy;
    } else {
      r8.x = 1 / r6.w;
      r8.x = cb0[28].x * r8.x;
      r6.w = cb0[28].y * r6.w;
      r8.y = min(1, abs(r6.w));
      r8.z = max(1, abs(r6.w));
      r8.z = 1 / r8.z;
      r8.y = r8.y * r8.z;
      r8.z = r8.y * r8.y;
      r8.w = r8.z * 0.0208350997 + -0.0851330012;
      r8.w = r8.z * r8.w + 0.180141002;
      r8.w = r8.z * r8.w + -0.330299497;
      r8.z = r8.z * r8.w + 0.999866009;
      r8.w = r8.y * r8.z;
      r9.x = cmp(1 < abs(r6.w));
      r8.w = r8.w * -2 + 1.57079637;
      r8.w = r9.x ? r8.w : 0;
      r8.y = r8.y * r8.z + r8.w;
      r6.w = min(1, r6.w);
      r6.w = cmp(r6.w < -r6.w);
      r6.w = r6.w ? -r8.y : r8.y;
      r6.w = r8.x * r6.w + -1;
      r7.zw = r6.yz * r6.ww + r7.xy;
    }
    r7.zw = saturate(r7.zw);
    r6.yz = cb0[26].xx * r7.zw;
    r7.xyzw = t1.SampleLevel(s1_s, r6.yz, 0).xyzw;
    r8.xyzw = t5.SampleLevel(s5_s, r2.xy, 0).xyzw;
    r3.xyz = r8.xyz;
    r4.xyzw = r7.xyzw * r3.xyzw + r4.xyzw;
    r5.xyzw = r5.xyzw + r3.xyzw;
    r2.zw = r2.zw + r0.yz;
    r6.x = (int)r6.x + 1;
  }
  r2.xyzw = r4.xyzw / r5.xyzw;
  r2.xyz = r2.xyz * r0.xxx;
  r0.xyzw = float4(1, 1, -1, 0) * cb0[32].xyxy;
  r3.xyzw = saturate(-r0.xywy * cb0[34].xxxx + r1.zwzw);
  r3.xyzw = cb0[26].xxxx * r3.xyzw;
  r4.xyzw = t3.Sample(s3_s, r3.xy).xyzw;
  r3.xyzw = t3.Sample(s3_s, r3.zw).xyzw;
  r3.xyzw = r3.xyzw * float4(2, 2, 2, 2) + r4.xyzw;
  r1.xy = saturate(-r0.zy * cb0[34].xx + r1.zw);
  r1.xy = cb0[26].xx * r1.xy;
  r4.xyzw = t3.Sample(s3_s, r1.xy).xyzw;
  r3.xyzw = r4.xyzw + r3.xyzw;
  r4.xyzw = saturate(r0.zwxw * cb0[34].xxxx + r1.zwzw);
  r4.xyzw = cb0[26].xxxx * r4.xyzw;
  r5.xyzw = t3.Sample(s3_s, r4.xy).xyzw;
  r3.xyzw = r5.xyzw * float4(2, 2, 2, 2) + r3.xyzw;
  r1.xy = saturate(r1.zw);
  r1.xy = cb0[26].xx * r1.xy;
  r5.xyzw = t3.Sample(s3_s, r1.xy).xyzw;
  r3.xyzw = r5.xyzw * float4(4, 4, 4, 4) + r3.xyzw;
  r4.xyzw = t3.Sample(s3_s, r4.zw).xyzw;
  r3.xyzw = r4.xyzw * float4(2, 2, 2, 2) + r3.xyzw;
  r4.xyzw = saturate(r0.zywy * cb0[34].xxxx + r1.zwzw);
  r4.xyzw = cb0[26].xxxx * r4.xyzw;
  r5.xyzw = t3.Sample(s3_s, r4.xy).xyzw;
  r3.xyzw = r5.xyzw + r3.xyzw;
  r4.xyzw = t3.Sample(s3_s, r4.zw).xyzw;
  r3.xyzw = r4.xyzw * float4(2, 2, 2, 2) + r3.xyzw;
  r0.xy = saturate(r0.xy * cb0[34].xx + r1.zw);
  r0.xy = cb0[26].xx * r0.xy;
  r0.xyzw = t3.Sample(s3_s, r0.xy).xyzw;
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = cb0[34].yyyy * r0.xyzw * injectedData.fxBloom;
  r1.xy = r1.zw * cb0[33].xy + cb0[33].zw;
  r3.xyzw = t4.Sample(s4_s, r1.xy).xyzw;
  r4.xyz = float3(0.0625, 0.0625, 0.0625) * r0.xyz;
  r3.xyz = cb0[34].zzz * r3.xyz;
  r0.xyzw = float4(0.0625, 0.0625, 0.0625, 1) * r0.xyzw;
  r5.xyz = cb0[35].xyz * r0.xyz;
  r5.w = 0.0625 * r0.w;
  r0.xyzw = r5.xyzw + r2.xyzw;
  r2.xyz = r3.xyz * r4.xyz;
  r2.w = 0;
  r0.xyzw = r2.xyzw + r0.xyzw;
  r1.x = cmp(cb0[40].y < 0.5);
  if (r1.x != 0) {
    r1.xy = -cb0[38].xy + r1.zw;
    r2.yz = cb0[39].xx * abs(r1.yx) * min(1, injectedData.fxVignette);
    r1.x = cb0[22].x / cb0[22].y;
    r1.x = -1 + r1.x;
    r1.x = cb0[39].w * r1.x + 1;
    r2.x = r2.z * r1.x;
    r2.xy = saturate(r2.xy);
    r1.xy = log2(r2.xy);
    r1.xy = cb0[39].zz * r1.xy;
    r1.xy = exp2(r1.xy);
    r1.x = dot(r1.xy, r1.xy);
    r1.x = 1 + -r1.x;
    r1.x = max(0, r1.x);
    r1.x = log2(r1.x);
    r1.x = cb0[39].y * r1.x * max(1, injectedData.fxVignette);
    r1.x = exp2(r1.x);
    r2.xyz = float3(1, 1, 1) + -cb0[37].xyz;
    r2.xyz = r1.xxx * r2.xyz + cb0[37].xyz;
    r2.xyz = r2.xyz * r0.xyz;
    r1.y = -1 + r0.w;
    r2.w = r1.x * r1.y + 1;
  } else {
    r1.xyzw = t7.Sample(s7_s, r1.zw).xyzw;
    r1.y = 0.0549999997 + r1.w;
    r1.xy = float2(0.0773993805, 0.947867334) * r1.wy;
    r1.y = max(1.1920929e-07, abs(r1.y));
    r1.y = log2(r1.y);
    r1.y = 2.4000001 * r1.y;
    r1.y = exp2(r1.y);
    r1.z = cmp(0.0404499993 >= r1.w);
    r1.x = r1.z ? r1.x : r1.y;
    r1.yzw = float3(1, 1, 1) + -cb0[37].xyz;
    r1.yzw = r1.xxx * r1.yzw + cb0[37].xyz;
    r1.yzw = r0.xyz * r1.yzw + -r0.xyz;
    r2.xyz = cb0[40].xxx * r1.yzw + r0.xyz;
    r0.x = -1 + r0.w;
    r2.w = r1.x * r0.x + 1;
  }
  r0.xyzw = cb0[36].zzzz * r2.xyzw;
  r0.rgb = lutShaper(r0.rgb);

  /* r0.xyz = r0.xyz * float3(5.55555582, 5.55555582, 5.55555582) + float3(0.0479959995, 0.0479959995, 0.0479959995);
  r0.xyz = log2(r0.xyz);
  r0.xyz = saturate(r0.xyz * float3(0.0734997839, 0.0734997839, 0.0734997839) + float3(0.386036009, 0.386036009, 0.386036009)); */
  r0.xyz = cb0[36].yyy * r0.xyz;
  r1.x = 0.5 * cb0[36].x;
  r0.xyz = r0.xyz * cb0[36].xxx + r1.xxx;
  r1.xyzw = t6.Sample(s6_s, r0.xyz).xyzw;
  r0.xy = v1.xy * cb0[30].xy + cb0[30].zw;
  r2.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r0.x = r2.w * 2 + -1;
  r0.y = saturate(r0.x * 3.40282347e+38 + 0.5);
  r0.y = r0.y * 2 + -1;
  r0.x = 1 + -abs(r0.x);
  r0.x = sqrt(r0.x);
  r0.x = 1 + -r0.x;
  r0.x = r0.y * r0.x;
  /* r2.xyz = float3(12.9200001, 12.9200001, 12.9200001) * r1.xyz;
  r3.xyz = max(float3(1.1920929e-07, 1.1920929e-07, 1.1920929e-07), abs(r1.xyz));
  r3.xyz = log2(r3.xyz);
  r3.xyz = float3(0.416666657, 0.416666657, 0.416666657) * r3.xyz;
  r3.xyz = exp2(r3.xyz);
  r3.xyz = r3.xyz * float3(1.05499995, 1.05499995, 1.05499995) + float3(-0.0549999997, -0.0549999997, -0.0549999997);
  r1.xyz = cmp(float3(0.00313080009, 0.00313080009, 0.00313080009) >= r1.xyz);
  r1.xyz = r1.xyz ? r2.xyz : r3.xyz;
  r0.xyz = r0.xxx * float3(0.00392156886, 0.00392156886, 0.00392156886) + r1.xyz;
  r1.xyz = float3(0.0773993805, 0.0773993805, 0.0773993805) * r0.xyz;
  r2.xyz = float3(0.0549999997, 0.0549999997, 0.0549999997) + r0.xyz;
  r2.xyz = float3(0.947867334, 0.947867334, 0.947867334) * r2.xyz;
  r2.xyz = max(float3(1.1920929e-07, 1.1920929e-07, 1.1920929e-07), abs(r2.xyz));
  r2.xyz = log2(r2.xyz);
  r2.xyz = float3(2.4000001, 2.4000001, 2.4000001) * r2.xyz;
  r2.xyz = exp2(r2.xyz);
  r0.xyz = cmp(float3(0.0404499993, 0.0404499993, 0.0404499993) >= r0.xyz);
  o0.xyz = r0.xyz ? r1.xyz : r2.xyz; */
  o0.w = r0.w;
  r1.rgb = renodx::color::srgb::EncodeSafe(r1.rgb);
  r0.xyz = r0.xxx * float3(0.00392156886, 0.00392156886, 0.00392156886) * injectedData.fxNoise + r1.xyz;
  o0.rgb = renodx::color::srgb::DecodeSafe(r0.rgb);
  o0.rgb = renodx::color::bt709::clamp::AP1(o0.rgb);
  if (injectedData.fxFilmGrain > 0.f) {
    o0.rgb = applyFilmGrain(o0.rgb, w1);
  }
  o0.rgb = PostToneMapScale(o0.rgb);
  return;
}
