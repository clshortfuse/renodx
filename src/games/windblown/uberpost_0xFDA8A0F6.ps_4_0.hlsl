#include "./common.hlsl"

Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[146];
}

#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4, r5, r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = v1.xyxy * float4(2, 2, 2, 2) + float4(-1, -1, -1, -1);
  r1.x = dot(r0.zw, r0.zw);
  r0.xyzw = r1.xxxx * r0.xyzw;
  r0.xyzw = cb0[140].xxxx * r0.xyzw;
  r1.xyzw = t0.SampleBias(s0_s, v1.xy, cb0[5].x).xyzw;
  r0.xyzw = r0.xyzw * float4(-0.333333343, -0.333333343, -0.666666687, -0.666666687) + v1.xyxy;
  r2.xyzw = t0.SampleBias(s0_s, r0.xy, cb0[5].x).xyzw;
  r0.xyzw = t0.SampleBias(s0_s, r0.zw, cb0[5].x).xyzw;
  r1.yz = v1.xy * cb0[145].zw + float2(0.5, 0.5);
  r2.xz = floor(r1.yz);
  r1.yz = frac(r1.yz);
  r3.xyzw = -r1.yzyz * float4(0.5, 0.5, 0.166666672, 0.166666672) + float4(0.5, 0.5, 0.5, 0.5);
  r3.xyzw = r1.yzyz * r3.xyzw + float4(0.5, 0.5, -0.5, -0.5);
  r4.xy = r1.yz * float2(0.5, 0.5) + float2(-1, -1);
  r4.zw = r1.yz * r1.yz;
  r4.xy = r4.zw * r4.xy + float2(0.666666687, 0.666666687);
  r3.xyzw = r1.yzyz * r3.xyzw + float4(0.166666672, 0.166666672, 0.166666672, 0.166666672);
  r1.yz = float2(1, 1) + -r4.xy;
  r1.yz = r1.yz + -r3.xy;
  r1.yz = r1.yz + -r3.zw;
  r3.zw = r3.zw + r4.xy;
  r3.xy = r3.xy + r1.yz;
  r4.zw = float2(1, 1) / r3.zw;
  r4.zw = r4.xy * r4.zw + float2(-1, -1);
  r5.xy = float2(1, 1) / r3.xy;
  r4.xy = r1.yz * r5.xy + float2(1, 1);
  r5.xyzw = r4.zwxw + r2.xzxz;
  r5.xyzw = float4(-0.5, -0.5, -0.5, -0.5) + r5.xyzw;
  r5.xyzw = cb0[145].xyxy * r5.xyzw;
  r5.xyzw = min(float4(1, 1, 1, 1), r5.xyzw);
  r6.xyzw = t1.SampleLevel(s0_s, r5.xy, 0).xyzw;
  r5.xyzw = t1.SampleLevel(s0_s, r5.zw, 0).xyzw;
  r5.xyzw = r5.xyzw * r3.xxxx;
  r5.xyzw = r3.zzzz * r6.xyzw + r5.xyzw;
  r4.xyzw = r4.zyxy + r2.xzxz;
  r4.xyzw = float4(-0.5, -0.5, -0.5, -0.5) + r4.xyzw;
  r4.xyzw = cb0[145].xyxy * r4.xyzw;
  r4.xyzw = min(float4(1, 1, 1, 1), r4.xyzw);
  r6.xyzw = t1.SampleLevel(s0_s, r4.xy, 0).xyzw;
  r4.xyzw = t1.SampleLevel(s0_s, r4.zw, 0).xyzw;
  r4.xyzw = r4.xyzw * r3.xxxx;
  r4.xyzw = r3.zzzz * r6.xyzw + r4.xyzw;
  r4.xyzw = r4.xyzw * r3.yyyy;
  r3.xyzw = r3.wwww * r5.xyzw + r4.xyzw;
  if (cb0[135].x > 0) {
    r1.yzw = r3.xyz * r3.www;
    r3.xyz = float3(8, 8, 8) * r1.yzw;
  }
  r1.yzw = cb0[134].xxx * r3.xyz * injectedData.fxBloom;
  r0.x = r1.x;
  r0.y = r2.y;
  r0.xyz = r1.yzw * cb0[134].yzw + r0.xyz;
  if (cb0[142].z > 0) {
    r1.xy = -cb0[142].xy + v1.xy;
    r1.yz = cb0[142].zz * abs(r1.xy);
    r1.x = cb0[141].w * r1.y;
    r0.w = dot(r1.xz, r1.xz);
    r0.w = 1 + -r0.w;
    r0.w = max(0, r0.w);
    r0.w = log2(r0.w);
    r0.w = cb0[142].w * r0.w;
    r0.w = exp2(r0.w);
    r1.xyz = float3(1, 1, 1) + -cb0[141].xyz;
    r1.xyz = r0.www * r1.xyz + cb0[141].xyz;
    r0.xyz = r1.xyz * r0.xyz;
  }
  if (injectedData.fxVignette > 0.f) {
    r0.rgb = applyVignette(r0.rgb, v1, injectedData.fxVignette);
  }
  r0.xyz = cb0[132].www * r0.xyz;
  r1.rgb = applyUserTonemap(r0.rgb);
  if (cb0[133].w > 0) {
    r0.xyz = cmp(float3(0.00313080009, 0.00313080009, 0.00313080009) >= r1.xyz);
    r2.xyz = float3(12.9232101, 12.9232101, 12.9232101) * r1.xyz;
    r3.xyz = log2(r1.xyz);
    r3.xyz = float3(0.416666657, 0.416666657, 0.416666657) * r3.xyz;
    r3.xyz = exp2(r3.xyz);
    r3.xyz = r3.xyz * float3(1.05499995, 1.05499995, 1.05499995) + float3(-0.0549999997, -0.0549999997, -0.0549999997);
    r0.xyz = r0.xyz ? r2.xyz : r3.xyz;
    r2.xyz = cb0[133].zzz * r0.zxy;
    r0.w = floor(r2.x);
    r2.xw = float2(0.5, 0.5) * cb0[133].xy;
    r2.yz = r2.yz * cb0[133].xy + r2.xw;
    r2.x = r0.w * cb0[133].y + r2.y;
    r3.xyzw = t3.SampleLevel(s0_s, r2.xz, 0).xyzw;
    r4.x = cb0[133].y;
    r4.y = 0;
    r2.xy = r4.xy + r2.xz;
    r2.xyzw = t3.SampleLevel(s0_s, r2.xy, 0).xyzw;
    r0.w = r0.z * cb0[133].z + -r0.w;
    r2.xyz = r2.xyz + -r3.xyz;
    r2.xyz = r0.www * r2.xyz + r3.xyz;
    r2.xyz = r2.xyz + -r0.xyz;
    r0.xyz = cb0[133].www * r2.xyz + r0.xyz;
    r2.xyz = float3(0.0773993805, 0.0773993805, 0.0773993805) * r0.xyz;
    r3.xyz = float3(0.0549999997, 0.0549999997, 0.0549999997) + r0.xyz;
    r3.xyz = float3(0.947867334, 0.947867334, 0.947867334) * r3.xyz;
    r3.xyz = log2(abs(r3.xyz));
    r3.xyz = float3(2.4000001, 2.4000001, 2.4000001) * r3.xyz;
    r3.xyz = exp2(r3.xyz);
    r0.xyz = cmp(float3(0.0404499993, 0.0404499993, 0.0404499993) >= r0.xyz);
    r1.xyz = r0.xyz ? r2.xyz : r3.xyz;
  }
  float3 preLUT = r1.rgb;
  if (injectedData.colorGradeLUTStrength > 0.f) {
  if (injectedData.toneMapType != 0.f) {
    r1.rgb = lutShaper(r1.rgb);
  }
  if (injectedData.colorGradeLUTSampling == 0.f) {
  r0.xyz = cb0[132].zzz * r1.zxy;
  r0.x = floor(r0.x);
  r1.xy = float2(0.5, 0.5) * cb0[132].xy;
  r2.yz = r0.yz * cb0[132].xy + r1.xy;
  r2.x = r0.x * cb0[132].y + r2.y;
  r3.xyzw = t2.SampleLevel(s0_s, r2.xz, 0).xyzw;
  r1.x = cb0[132].y;
  r1.y = 0;
  r0.yz = r2.xz + r1.xy;
  r2.xyzw = t2.SampleLevel(s0_s, r0.yz, 0).xyzw;
  r0.x = r1.z * cb0[132].z + -r0.x;
  r0.yzw = r2.xyz + -r3.xyz;
  r1.xyz = r0.xxx * r0.yzw + r3.xyz;
  } else {
    r1.xyz = renodx::lut::SampleTetrahedral(t2, r1.rgb, cb0[132].z + 1u);
  }
  if (injectedData.colorGradeLUTScaling > 0.f) {
    float3 minBlack = renodx::lut::Sample(t2, s0_s, float3(0, 0, 0), cb0[132].xyz);
    float lutMinY = renodx::color::y::from::BT709(abs(minBlack));
    if (lutMinY > 0) {
      float3 correctedBlack = renodx::lut::CorrectBlack(preLUT, r1.rgb, lutMinY, 0.f);
      r1.rgb = lerp(r1.rgb, correctedBlack, injectedData.colorGradeLUTScaling);
    }
  }
  r1.rgb = lerp(preLUT, r1.rgb, injectedData.colorGradeLUTStrength);
  }
  if (!injectedData.postfinal_check) {
  if (injectedData.fxFilmGrain > 0.f) {
    r1.rgb = applyFilmGrain(r1.rgb, v1, injectedData.fxFilmGrainType != 0);
  }
  r1.rgb = PostToneMapScale(r1.rgb);
  }
  o0.rgb = r1.rgb;
  o0.w = 1;
  return;
}
