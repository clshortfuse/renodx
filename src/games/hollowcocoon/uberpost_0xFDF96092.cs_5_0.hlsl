#include "./common.hlsl"

Texture2D<float4> t5 : register(t5);
Texture3D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2DArray<float4> t1 : register(t1);
Texture2DArray<float4> t0 : register(t0);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
RWTexture2DArray<float4> u0 : register(u0);
cbuffer cb1 : register(b1) {
  float4 cb1[14];
}
cbuffer cb0 : register(b0) {
  float4 cb0[44];
}

#define cmp -

[numthreads(8, 8, 1)]
void main(uint3 vThreadID: SV_DispatchThreadID) {
  float4 r0, r1, r2, r3, r4, r5, r6, r7, r8;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = (uint3)vThreadID.xyz;
  r1.xy = float2(0.5, 0.5) + r0.xy;
  r1.zw = cb0[42].zw * r1.xy;
  r2.xy = r1.zw * float2(2, 2) + float2(-1, -1);
  r0.w = dot(r2.xy, r2.xy);
  r2.xy = r2.xy * r0.ww;
  r2.xy = cb1[0].xx * r2.xy * injectedData.fxChroma;
  r2.zw = cb0[42].xy * -r2.xy;
  r2.zw = float2(0.5, 0.5) * r2.zw;
  r0.w = dot(r2.zw, r2.zw);
  r0.w = sqrt(r0.w);
  r0.w = (int)r0.w;
  r2.z = (int)cb1[0].y;
  r0.w = max(3, (int)r0.w);
  r0.w = min((int)r0.w, (int)r2.z);
  r2.z = (int)r0.w;
  r2.xy = -r2.xy / r2.zz;
  r3.xy = -cb0[42].zw * float2(0.5, 0.5) + float2(1, 1);
  r4.y = 0;
  r5.xyz = float3(0, 0, 0);
  r6.xyz = float3(0, 0, 0);
  r3.zw = r1.zw;
  r2.w = 0;
  while (true) {
    r4.z = cmp((int)r2.w >= (int)r0.w);
    if (r4.z != 0) break;
    r4.z = (int)r2.w;
    r4.z = 0.5 + r4.z;
    r4.x = r4.z / r2.z;
    r4.zw = min(r3.zw, r3.xy);
    r0.xy = cb0[43].xy * r4.zw;
    r7.xyz = t0.SampleLevel(s0_s, r0.xyz, 0).xyz;
    r4.xzw = t3.SampleLevel(s1_s, r4.xy, 0).xyz;
    r5.xyz = r7.xyz * r4.xzw + r5.xyz;
    r6.xyz = r6.xyz + r4.xzw;
    r3.zw = r3.zw + r2.xy;
    r2.w = (int)r2.w + 1;
  }
  r2.xyz = r5.xyz / r6.xyz;
  r3.xy = min(r3.xy, r1.zw);
  r0.xy = cb0[43].xy * r3.xy;
  r3.xyzw = t0.SampleLevel(s0_s, r0.xyz, 0).xyzw;
  r0.w = cmp(0 != cb1[7].z);
  if (r0.w != 0) {
    r4.xy = cb0[43].xy * r1.zw;
    r4.xy = r4.xy * cb1[11].xy + float2(0.5, 0.5);
    r4.zw = floor(r4.xy);
    r4.xy = frac(r4.xy);
    r5.xyzw = -r4.xyxy * float4(0.5, 0.5, 0.166666672, 0.166666672) + float4(0.5, 0.5, 0.5, 0.5);
    r5.xyzw = r4.xyxy * r5.xyzw + float4(0.5, 0.5, -0.5, -0.5);
    r6.xy = r4.xy * float2(0.5, 0.5) + float2(-1, -1);
    r6.zw = r4.xy * r4.xy;
    r6.xy = r6.zw * r6.xy + float2(0.666666687, 0.666666687);
    r5.xyzw = r4.xyxy * r5.xyzw + float4(0.166666672, 0.166666672, 0.166666672, 0.166666672);
    r4.xy = float2(1, 1) + -r6.xy;
    r4.xy = r4.xy + -r5.xy;
    r4.xy = r4.xy + -r5.zw;
    r5.zw = r5.zw + r6.xy;
    r5.xy = r5.xy + r4.xy;
    r6.zw = rcp(r5.zw);
    r6.zw = r6.xy * r6.zw + float2(-1, -1);
    r7.xy = rcp(r5.xy);
    r6.xy = r4.xy * r7.xy + float2(1, 1);
    r7.xyzw = r6.zwxw + r4.zwzw;
    r7.xyzw = float4(-0.5, -0.5, -0.5, -0.5) + r7.xyzw;
    r7.xyzw = cb1[11].zwzw * r7.xyzw;
    r0.xy = min(cb0[43].xy, r7.xy);
    r8.xyz = t1.SampleLevel(s0_s, r0.xyz, 0).xyz;
    r0.xy = min(cb0[43].xy, r7.zw);
    r7.xyz = t1.SampleLevel(s0_s, r0.xyz, 0).xyz;
    r7.xyz = r7.xyz * r5.xxx;
    r7.xyz = r5.zzz * r8.xyz + r7.xyz;
    r4.xyzw = r6.zyxy + r4.zwzw;
    r4.xyzw = float4(-0.5, -0.5, -0.5, -0.5) + r4.xyzw;
    r4.xyzw = cb1[11].zwzw * r4.xyzw;
    r0.xy = min(cb0[43].xy, r4.xy);
    r6.xyz = t1.SampleLevel(s0_s, r0.xyz, 0).xyz;
    r0.xy = min(cb0[43].xy, r4.zw);
    r0.xyz = t1.SampleLevel(s0_s, r0.xyz, 0).xyz;
    r0.xyz = r5.xxx * r0.xyz;
    r0.xyz = r5.zzz * r6.xyz + r0.xyz;
    r0.xyz = r5.yyy * r0.xyz;
    r0.xyz = r5.www * r7.xyz + r0.xyz;
    r0.w = max(r2.x, r2.y);
    r0.w = max(r0.w, r2.z);
    r4.xy = -cb1[8].yx + r0.ww;
    r2.w = max(0, r4.x);
    r2.w = min(cb1[8].z, r2.w);
    r2.w = r2.w * r2.w;
    r2.w = cb1[8].w * r2.w;
    r2.w = max(r2.w, r4.y);
    r0.w = max(9.99999975e-05, r0.w);
    r0.w = r2.w / r0.w;
    r4.xyz = -r2.xyz * r0.www + r2.xyz;
    r4.xyz = r0.xyz * cb1[9].xyz + r4.xyz;
    r4.xyz = r4.xyz + -r2.xyz;
    r3.xyz = cb1[7].xxx * r4.xyz * injectedData.fxBloom + r2.xyz;
    r0.w = cmp(0 != cb1[7].w);
    if (r0.w != 0) {
      r4.xy = r1.zw * cb1[10].xy + cb1[10].zw;
      r4.xyz = t2.SampleLevel(s0_s, r4.xy, 0).xyz;
      r0.xyz = r4.xyz * r0.xyz;
      r3.xyz = r0.xyz * cb1[7].yyy + r3.xyz;
    }
    r2.xyz = r3.xyz;
  }
  r0.x = (uint)cb1[1].z;
  if (r0.x == 0) {
    r0.xy = r1.xy * cb0[42].zw + -cb1[1].xy;
    r0.yz = cb1[2].xx * abs(r0.yx) * min(1, injectedData.fxVignette);
    r0.w = cb0[42].x / cb0[42].y;
    r0.w = -1 + r0.w;
    r0.w = cb1[2].w * r0.w + 1;
    r0.x = r0.z * r0.w;
    r0.xy = saturate(r0.xy);
    r0.xy = log2(r0.xy);
    r0.xy = cb1[2].zz * r0.xy;
    r0.xy = exp2(r0.xy);
    r0.x = dot(r0.xy, r0.xy);
    r0.x = 1 + -r0.x;
    r0.x = max(0, r0.x);
    r0.x = log2(r0.x);
    r0.x = cb1[2].y * r0.x * max(1, injectedData.fxVignette);
    r0.x = exp2(r0.x);
    r0.yzw = float3(1, 1, 1) + -cb1[3].xyz;
    r0.xyz = r0.xxx * r0.yzw + cb1[3].xyz;
    r0.xyz = r2.xyz * r0.xyz;
  } else {
    r0.w = t5.SampleLevel(s3_s, r1.zw, 0).w;
    r1.x = r0.w * 0.305306017 + 0.682171106;
    r1.x = r0.w * r1.x + 0.0125228781;
    r0.w = r1.x * r0.w;
    r1.xyz = float3(1, 1, 1) + -cb1[3].xyz;
    r1.xyz = r0.www * r1.xyz + cb1[3].xyz;
    r1.xyz = r2.xyz * r1.xyz + -r2.xyz;
    r0.xyz = cb1[3].www * r1.xyz + r2.xyz;
  }
  r0.w = cmp(0 != cb1[12].x);
  if (r0.w != 0) {
    r1.rgb = lutShaper(r0.rgb);
  } else {
    r0.xyz = cb1[6].zzz * r0.xyz;
    r0.rgb = lutShaper(r0.rgb);
    if (injectedData.colorGradeLUTSampling == 0.f) {
    r0.xyz = cb1[6].yyy * r0.xyz;
    r0.w = 0.5 * cb1[6].x;
    r0.xyz = r0.xyz * cb1[6].xxx + r0.www;
    r1.xyz = t4.SampleLevel(s2_s, r0.xyz, 0).xyz;
    } else {
      r1.rgb = renodx::lut::SampleTetrahedral(t4, r0.rgb, 1 / cb1[6].x);
    }
  }
  r0.x = saturate(r3.w * cb1[13].x + cb1[13].y);
  r0.yzw = r1.xyz + -r3.xyz;
  r3.xyz = r0.xxx * r0.yzw + r3.xyz;
  u0[vThreadID.xyz] = r3.xyzw;
  return;
}
