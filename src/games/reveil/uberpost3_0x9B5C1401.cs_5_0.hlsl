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
  float4 cb0[51];
}

#define cmp -

[numthreads(8, 8, 1)]
void main(uint3 vThreadID: SV_DispatchThreadID) {
  float4 r0, r1, r2, r3, r4, r5, r6, r7, r8, r9;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = (uint3)vThreadID.xyz;
  r1.xy = float2(0.5, 0.5) + r0.xy;
  r1.zw = cb0[47].zw * r1.xy;
  r1.xy = r1.xy * cb0[47].zw + float2(-0.5, -0.5);
  r2.xy = r1.xy * cb1[5].zz + float2(0.5, 0.5);
  r1.xy = r1.xy * cb1[5].zz + -cb1[4].xy;
  r1.xy = cb1[4].zw * r1.xy;
  r0.w = dot(r1.xy, r1.xy);
  r0.w = sqrt(r0.w);
  r2.z = cmp(0 < cb1[5].w);
  if (r2.z != 0) {
    r3.xy = cb1[5].xy * r0.ww;
    sincos(r3.x, r3.x, r4.x);
    r2.w = r3.x / r4.x;
    r3.x = rcp(r3.y);
    r2.w = r2.w * r3.x + -1;
    r3.xy = r1.xy * r2.ww + r2.xy;
  } else {
    r2.w = rcp(r0.w);
    r2.w = cb1[5].x * r2.w;
    r0.w = cb1[5].y * r0.w;
    r3.z = min(1, abs(r0.w));
    r3.w = max(1, abs(r0.w));
    r3.w = 1 / r3.w;
    r3.z = r3.z * r3.w;
    r3.w = r3.z * r3.z;
    r4.x = r3.w * 0.0208350997 + -0.0851330012;
    r4.x = r3.w * r4.x + 0.180141002;
    r4.x = r3.w * r4.x + -0.330299497;
    r3.w = r3.w * r4.x + 0.999866009;
    r4.x = r3.z * r3.w;
    r4.y = cmp(1 < abs(r0.w));
    r4.x = r4.x * -2 + 1.57079637;
    r4.x = r4.y ? r4.x : 0;
    r3.z = r3.z * r3.w + r4.x;
    r0.w = min(1, r0.w);
    r0.w = cmp(r0.w < -r0.w);
    r0.w = r0.w ? -r3.z : r3.z;
    r0.w = r2.w * r0.w + -1;
    r3.xy = r1.xy * r0.ww + r2.xy;
  }
  r1.xy = r1.zw * float2(2, 2) + float2(-1, -1);
  r0.w = dot(r1.xy, r1.xy);
  r1.xy = r1.xy * r0.ww;
  r1.xy = cb1[0].xx * r1.xy * injectedData.fxChroma;
  r2.xy = cb0[47].xy * -r1.xy;
  r2.xy = float2(0.5, 0.5) * r2.xy;
  r0.w = dot(r2.xy, r2.xy);
  r0.w = sqrt(r0.w);
  r0.w = (int)r0.w;
  r2.x = (int)cb1[0].y;
  r0.w = max(3, (int)r0.w);
  r0.w = min((int)r0.w, (int)r2.x);
  r2.x = (int)r0.w;
  r1.xy = -r1.xy / r2.xx;
  r2.yw = -cb0[47].zw * float2(0.5, 0.5) + float2(1, 1);
  r4.y = 0;
  r5.xyz = float3(0, 0, 0);
  r6.xyz = float3(0, 0, 0);
  r3.zw = r1.zw;
  r4.z = 0;
  while (true) {
    r4.w = cmp((int)r4.z >= (int)r0.w);
    if (r4.w != 0) break;
    r4.w = (int)r4.z;
    r4.w = 0.5 + r4.w;
    r4.x = r4.w / r2.x;
    r7.xy = float2(-0.5, -0.5) + r3.zw;
    r7.zw = r7.xy * cb1[5].zz + float2(0.5, 0.5);
    r7.xy = r7.xy * cb1[5].zz + -cb1[4].xy;
    r7.xy = cb1[4].zw * r7.xy;
    r4.w = dot(r7.xy, r7.xy);
    r4.w = sqrt(r4.w);
    if (r2.z != 0) {
      r8.xy = cb1[5].xy * r4.ww;
      sincos(r8.x, r8.x, r9.x);
      r5.w = r8.x / r9.x;
      r6.w = rcp(r8.y);
      r5.w = r5.w * r6.w + -1;
      r8.xy = r7.xy * r5.ww + r7.zw;
    } else {
      r5.w = rcp(r4.w);
      r5.w = cb1[5].x * r5.w;
      r4.w = cb1[5].y * r4.w;
      r6.w = min(1, abs(r4.w));
      r8.z = max(1, abs(r4.w));
      r8.z = 1 / r8.z;
      r6.w = r8.z * r6.w;
      r8.z = r6.w * r6.w;
      r8.w = r8.z * 0.0208350997 + -0.0851330012;
      r8.w = r8.z * r8.w + 0.180141002;
      r8.w = r8.z * r8.w + -0.330299497;
      r8.z = r8.z * r8.w + 0.999866009;
      r8.w = r8.z * r6.w;
      r9.x = cmp(1 < abs(r4.w));
      r8.w = r8.w * -2 + 1.57079637;
      r8.w = r9.x ? r8.w : 0;
      r6.w = r6.w * r8.z + r8.w;
      r4.w = min(1, r4.w);
      r4.w = cmp(r4.w < -r4.w);
      r4.w = r4.w ? -r6.w : r6.w;
      r4.w = r5.w * r4.w + -1;
      r8.xy = r7.xy * r4.ww + r7.zw;
    }
    r7.xy = min(r8.xy, r2.yw);
    r0.xy = cb0[50].xy * r7.xy;
    r7.xyz = t0.SampleLevel(s0_s, r0.xyz, 0).xyz;
    r8.xyz = t3.SampleLevel(s1_s, r4.xy, 0).xyz;
    r5.xyz = r7.xyz * r8.xyz + r5.xyz;
    r6.xyz = r8.xyz + r6.xyz;
    r3.zw = r3.zw + r1.xy;
    r4.z = (int)r4.z + 1;
  }
  r1.xyz = r5.xyz / r6.xyz;
  r2.xy = min(r3.xy, r2.yw);
  r0.xy = cb0[50].xy * r2.xy;
  r2.xyzw = t0.SampleLevel(s0_s, r0.xyz, 0).xyzw;
  r0.w = cmp(0 != cb1[7].z);
  if (r0.w != 0) {
    r3.zw = cb0[50].xy * r3.xy;
    r3.zw = r3.zw * cb1[11].xy + float2(0.5, 0.5);
    r4.xy = floor(r3.zw);
    r3.zw = frac(r3.zw);
    r5.xyzw = -r3.zwzw * float4(0.5, 0.5, 0.166666672, 0.166666672) + float4(0.5, 0.5, 0.5, 0.5);
    r5.xyzw = r3.zwzw * r5.xyzw + float4(0.5, 0.5, -0.5, -0.5);
    r4.zw = r3.zw * float2(0.5, 0.5) + float2(-1, -1);
    r6.xy = r3.zw * r3.zw;
    r4.zw = r6.xy * r4.zw + float2(0.666666687, 0.666666687);
    r5.xyzw = r3.zwzw * r5.xyzw + float4(0.166666672, 0.166666672, 0.166666672, 0.166666672);
    r3.zw = float2(1, 1) + -r4.zw;
    r3.zw = r3.zw + -r5.xy;
    r3.zw = r3.zw + -r5.zw;
    r5.zw = r5.zw + r4.zw;
    r5.xy = r5.xy + r3.zw;
    r6.xy = rcp(r5.zw);
    r6.zw = r4.zw * r6.xy + float2(-1, -1);
    r4.zw = rcp(r5.xy);
    r6.xy = r3.zw * r4.zw + float2(1, 1);
    r7.xyzw = r6.zwxw + r4.xyxy;
    r7.xyzw = float4(-0.5, -0.5, -0.5, -0.5) + r7.xyzw;
    r7.xyzw = cb1[11].zwzw * r7.xyzw;
    r0.xy = min(cb0[50].xy, r7.xy);
    r8.xyz = t1.SampleLevel(s0_s, r0.xyz, 0).xyz;
    r0.xy = min(cb0[50].xy, r7.zw);
    r7.xyz = t1.SampleLevel(s0_s, r0.xyz, 0).xyz;
    r7.xyz = r7.xyz * r5.xxx;
    r7.xyz = r5.zzz * r8.xyz + r7.xyz;
    r4.xyzw = r6.zyxy + r4.xyxy;
    r4.xyzw = float4(-0.5, -0.5, -0.5, -0.5) + r4.xyzw;
    r4.xyzw = cb1[11].zwzw * r4.xyzw;
    r0.xy = min(cb0[50].xy, r4.xy);
    r6.xyz = t1.SampleLevel(s0_s, r0.xyz, 0).xyz;
    r0.xy = min(cb0[50].xy, r4.zw);
    r0.xyz = t1.SampleLevel(s0_s, r0.xyz, 0).xyz;
    r0.xyz = r5.xxx * r0.xyz;
    r0.xyz = r5.zzz * r6.xyz + r0.xyz;
    r0.xyz = r5.yyy * r0.xyz;
    r0.xyz = r5.www * r7.xyz + r0.xyz;
    r0.w = max(r1.x, r1.y);
    r0.w = max(r0.w, r1.z);
    r3.zw = -cb1[8].yx + r0.ww;
    r1.w = max(0, r3.z);
    r1.w = min(cb1[8].z, r1.w);
    r1.w = r1.w * r1.w;
    r1.w = cb1[8].w * r1.w;
    r1.w = max(r1.w, r3.w);
    r0.w = max(9.99999975e-05, r0.w);
    r0.w = r1.w / r0.w;
    r4.xyz = -r1.xyz * r0.www + r1.xyz;
    r4.xyz = r0.xyz * cb1[9].xyz + r4.xyz;
    r4.xyz = r4.xyz + -r1.xyz;
    r2.xyz = cb1[7].xxx * r4.xyz * injectedData.fxBloom + r1.xyz;
    r0.w = cmp(0 != cb1[7].w);
    if (r0.w != 0) {
      r3.zw = r3.xy * cb1[10].xy + cb1[10].zw;
      r4.xyz = t2.SampleLevel(s0_s, r3.zw, 0).xyz;
      r0.xyz = r4.xyz * r0.xyz;
      r2.xyz = r0.xyz * cb1[7].yyy + r2.xyz;
    }
    r1.xyz = r2.xyz;
  }
  r0.x = (uint)cb1[1].z;
  if (r0.x == 0) {
    r0.xy = -cb1[1].xy + r3.xy;
    r0.yz = cb1[2].xx * abs(r0.yx) * min(1, injectedData.fxVignette);
    r0.w = cb0[47].x / cb0[47].y;
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
    r0.xyz = r1.xyz * r0.xyz;
  } else {
    r0.w = t5.SampleLevel(s3_s, r3.xy, 0).w;
    r1.w = r0.w * 0.305306017 + 0.682171106;
    r1.w = r0.w * r1.w + 0.0125228781;
    r0.w = r1.w * r0.w;
    r3.xyz = float3(1, 1, 1) + -cb1[3].xyz;
    r3.xyz = r0.www * r3.xyz + cb1[3].xyz;
    r3.xyz = r1.xyz * r3.xyz + -r1.xyz;
    r0.xyz = cb1[3].www * r3.xyz + r1.xyz;
  }
  r0.w = cmp(0 != cb1[12].x);
  if (r0.w != 0) {
    r0.rgb = lutShaper(r0.rgb);
  } else {
    r0.w = cmp(0 != cb1[6].w);
    if (r0.w != 0) {
      r1.xyz = cb1[6].zzz * r0.xyz;
      float3 preCG = r1.rgb;
      r1.rgb = lutShaper(r1.rgb);
      r1.xyz = cb1[6].yyy * r1.xyz;
      r0.w = 0.5 * cb1[6].x;
      r1.xyz = r1.xyz * cb1[6].xxx + r0.www;
      r0.xyz = t4.SampleLevel(s2_s, r1.xyz, 0).xyz;
      r0.rgb = lerp(preCG, r0.rgb, injectedData.colorGradeLUTStrength);
    }
  }
  r0.rgb = applyUserTonemap(r0.rgb);
  r0.w = cmp(cb1[12].w == 0.000000);
  r1.x = saturate(r2.w * cb1[13].x + cb1[13].y);
  r1.yzw = r0.xyz + -r2.xyz;
  r1.xyz = r1.xxx * r1.yzw + r2.xyz;
  r2.xyz = r0.www ? r1.xyz : r0.xyz;
  u0[vThreadID.xyz] = r2.xyzw;
  return;
}
