#include "../../common.hlsl"

Texture3D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2DArray<float4> t1 : register(t1);
Texture2DArray<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
RWTexture2DArray<float4> u0 : register(u0);
cbuffer cb1 : register(b1){
  float4 cb1[13];
}
cbuffer cb0 : register(b0){
  float4 cb0[51];
}

#define cmp -

[numthreads(8, 8, 1)]
void main(uint3 vThreadID: SV_DispatchThreadID) {
  float4 r0,r1,r2,r3,r4,r5,r6,r7;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = (uint3)vThreadID.xyz;
  r1.xy = float2(0.5,0.5) + r0.xy;
  r1.xy = cb0[47].zw * r1.xy;
  r1.zw = r1.xy * float2(2,2) + float2(-1,-1);
  r0.w = dot(r1.zw, r1.zw);
  r1.zw = r1.zw * r0.ww;
  r1.zw = cb1[0].xx * r1.zw * injectedData.fxCA;
  r2.xy = cb0[47].xy * -r1.zw;
  r2.xy = float2(0.5,0.5) * r2.xy;
  r0.w = dot(r2.xy, r2.xy);
  r0.w = sqrt(r0.w);
  r0.w = (int)r0.w;
  r2.x = (int)cb1[0].y;
  r0.w = max(3, (int)r0.w);
  r0.w = min((int)r0.w, (int)r2.x);
  r2.x = (int)r0.w;
  r1.zw = -r1.zw / r2.xx;
  r2.yz = -cb0[47].zw * float2(0.5,0.5) + float2(1,1);
  r3.y = 0;
  r4.xyz = float3(0,0,0);
  r5.xyz = float3(0,0,0);
  r3.zw = r1.xy;
  r2.w = 0;
  while (true) {
    r4.w = cmp((int)r2.w >= (int)r0.w);
    if (r4.w != 0) break;
    r4.w = (int)r2.w;
    r4.w = 0.5 + r4.w;
    r3.x = r4.w / r2.x;
    r6.xy = min(r3.zw, r2.yz);
    r0.xy = cb0[50].xy * r6.xy;
    r6.xyz = t0.SampleLevel(s0_s, r0.xyz, 0).xyz;
    r7.xyz = t3.SampleLevel(s1_s, r3.xy, 0).xyz;
    r4.xyz = r6.xyz * r7.xyz + r4.xyz;
    r5.xyz = r7.xyz + r5.xyz;
    r3.zw = r3.zw + r1.zw;
    r2.w = (int)r2.w + 1;
  }
  r2.xyz = r4.xyz / r5.xyz;
  if (cb1[7].z != 0) {
    r1.zw = cb0[50].xy * r1.xy;
    r1.zw = r1.zw * cb1[11].xy + float2(0.5,0.5);
    r3.xy = floor(r1.zw);
    r1.zw = frac(r1.zw);
    r4.xyzw = -r1.zwzw * float4(0.5,0.5,0.166666672,0.166666672) + float4(0.5,0.5,0.5,0.5);
    r4.xyzw = r1.zwzw * r4.xyzw + float4(0.5,0.5,-0.5,-0.5);
    r3.zw = r1.zw * float2(0.5,0.5) + float2(-1,-1);
    r5.xy = r1.zw * r1.zw;
    r3.zw = r5.xy * r3.zw + float2(0.666666687,0.666666687);
    r4.xyzw = r1.zwzw * r4.xyzw + float4(0.166666672,0.166666672,0.166666672,0.166666672);
    r1.zw = float2(1,1) + -r3.zw;
    r1.zw = r1.zw + -r4.xy;
    r1.zw = r1.zw + -r4.zw;
    r4.zw = r4.zw + r3.zw;
    r4.xy = r4.xy + r1.zw;
    r5.xy = rcp(r4.zw);
    r5.zw = r3.zw * r5.xy + float2(-1,-1);
    r3.zw = rcp(r4.xy);
    r5.xy = r1.zw * r3.zw + float2(1,1);
    r6.xyzw = r5.zwxw + r3.xyxy;
    r6.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + r6.xyzw;
    r6.xyzw = cb1[11].zwzw * r6.xyzw;
    r0.xy = min(cb0[50].xy, r6.xy);
    r7.xyz = t1.SampleLevel(s0_s, r0.xyz, 0).xyz;
    r0.xy = min(cb0[50].xy, r6.zw);
    r6.xyz = t1.SampleLevel(s0_s, r0.xyz, 0).xyz;
    r6.xyz = r6.xyz * r4.xxx;
    r6.xyz = r4.zzz * r7.xyz + r6.xyz;
    r3.xyzw = r5.zyxy + r3.xyxy;
    r3.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + r3.xyzw;
    r3.xyzw = cb1[11].zwzw * r3.xyzw;
    r0.xy = min(cb0[50].xy, r3.xy);
    r5.xyz = t1.SampleLevel(s0_s, r0.xyz, 0).xyz;
    r0.xy = min(cb0[50].xy, r3.zw);
    r0.xyz = t1.SampleLevel(s0_s, r0.xyz, 0).xyz;
    r0.xyz = r4.xxx * r0.xyz;
    r0.xyz = r4.zzz * r5.xyz + r0.xyz;
    r0.xyz = r4.yyy * r0.xyz;
    r0.xyz = r4.www * r6.xyz + r0.xyz;
    r0.w = max(r2.x, r2.y);
    r0.w = max(r0.w, r2.z);
    r1.zw = -cb1[8].yx + r0.ww;
    r1.z = max(0, r1.z);
    r1.z = min(cb1[8].z, r1.z);
    r1.z = r1.z * r1.z;
    r1.z = cb1[8].w * r1.z;
    r1.z = max(r1.z, r1.w);
    r0.w = max(9.99999975e-05, r0.w);
    r0.w = r1.z / r0.w;
    r3.xyz = -r2.xyz * r0.www + r2.xyz;
    r3.xyz = r0.xyz * cb1[9].xyz + r3.xyz;
    r3.xyz = r3.xyz + -r2.xyz;
    r2.xyz = cb1[7].xxx * r3.xyz * injectedData.fxBloom + r2.xyz;
    if (cb1[7].w != 0) {
      r1.xy = r1.xy * cb1[10].xy + cb1[10].zw;
      r1.xyz = t2.SampleLevel(s0_s, r1.xy, 0).xyz;
      r0.xyz = r1.xyz * r0.xyz;
      r2.xyz = r0.xyz * cb1[7].yyy * injectedData.fxLens + r2.xyz;
    }
  }
  if (cb1[12].x != 0) {
    r0.xyz = lutShaper(r2.xyz);
  } else {
    r1.xyz = cb1[6].zzz * r2.xyz;
    r1.xyz = lutShaper(r1.xyz);
    if (injectedData.colorGradeLUTSampling == 0.f) {
    r1.xyz = cb1[6].yyy * r1.xyz;
    r0.w = 0.5 * cb1[6].x;
    r1.xyz = r1.xyz * cb1[6].xxx + r0.www;
    r0.xyz = t4.SampleLevel(s2_s, r1.xyz, 0).xyz;
    } else {
      r0.xyz = renodx::lut::SampleTetrahedral(t4, r1.xyz, 1 / cb1[6].x);
    }
  }
  u0[vThreadID] = r0.xyzx;
  return;
}