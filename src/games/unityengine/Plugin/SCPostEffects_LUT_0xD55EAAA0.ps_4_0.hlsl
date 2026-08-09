#include "../common.hlsl"

Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[146];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.SampleBias(s0_s, v1.xy, cb0[5].x).xyzw;
  if (cb0[143].x > 0) {
    r2.xyzw = t1.SampleBias(s1_s, v1.xy, cb0[5].x).xyzw;
    /*r2.y = -1 + cb0[142].w;
    r3.xyz = r2.yyy * r1.xzw;
    r1.z = floor(r3.x);
    r2.zw = float2(0.5,0.5) * cb0[142].xy;
    r3.yz = r3.yz * cb0[142].xy + r2.zw;
    r3.x = r1.z * cb0[142].y + r3.y;
    r1.x = r1.x * r2.y + -r1.z;
    r4.xyzw = t2.SampleBias(s2_s, r3.xz, cb0[5].x).xyzw;
    r5.x = cb0[142].y;
    r5.y = 0;
    r1.zw = r5.xy + r3.xz;
    r5.xyzw = t2.SampleBias(s2_s, r1.zw, cb0[5].x).xyzw;
    r2.yzw = r5.xyz + -r4.xyz;
    r2.yzw = r1.xxx * r2.yzw + r4.xyz;*/
    r2.yzw = handleUserLUT(r0.xyz, t2, s2_s, float3(cb0[142].xy, cb0[142].w - 1), 0, true);
    /*r3.xyzw = t3.SampleBias(s3_s, r3.xz, cb0[5].x).xyzw;
    r4.xyzw = t3.SampleBias(s3_s, r1.zw, cb0[5].x).xyzw;
    r4.xyz = r4.xyz + -r3.xyz;
    r1.xzw = r1.xxx * r4.xyz + r3.xyz;*/
    r1.xzw = handleUserLUT(r0.xyz, t3, s3_s, float3(cb0[142].xy, cb0[142].w - 1), 0, true);
    r2.x = cb0[23].x * r2.x + cb0[23].y;
    r2.x = 1 / r2.x;
    r2.x = r2.x * cb0[21].z + -cb0[21].y;
    r3.x = 1 + -r2.x;
    r3.x = cb0[23].z * r3.x + cb0[23].w;
    r3.x = -r3.x * cb0[21].w + cb0[21].z;
    r3.x = r3.x + -r2.x;
    r2.x = cb0[24].w * r3.x + r2.x;
    r2.x = cb0[144].y + -r2.x;
    r3.x = cb0[144].y + -cb0[144].x;
    r2.x = saturate(r2.x / r3.x);
    r2.yzw = r2.yzw + -r1.xzw;
    r1.xzw = r2.xxx * r2.yzw + r1.xzw;
    r1.xzw = r1.xzw + -r0.xyz;
    r0.xyz = cb0[143].xxx * r1.xzw + r0.xyz;
  }
  if(injectedData.toneMapType == 0.f){
  r2.xyz = saturate(r0.xyz);
  } else {
    r2.xyz = r0.xyz;
  }
  r1.z = dot(r2.xyz, float3(0.212672904,0.715152204,0.0721750036));
  r1.w = max(r2.y, r2.z);
  r1.w = max(r2.x, r1.w);
  r2.y = min(r2.y, r2.z);
  r2.x = min(r2.x, r2.y);
  if(injectedData.toneMapType != 0.f){
    r2.x = max(0.f, r2.x);
  }
  r1.w = -r2.x + r1.w;
  r2.xyz = cb0[145].xyz * cb0[145].www;
  r3.xyz = cmp(float3(0,0,0) < r2.xyz);
  r4.xyz = cmp(r2.xyz < float3(0,0,0));
  r3.xyz = (int3)-r3.xyz + (int3)r4.xyz;
  r3.xyz = (int3)r3.xyz;
  r3.xyz = -r3.xyz * r1.www + float3(1,1,1);
  r2.xyz = r2.xyz * r3.xyz + float3(1,1,1);
  r3.xyz = -r1.zzz + r0.xyz;
  r2.xyz = r2.xyz * r3.xyz + r1.zzz;
  r0.xyz = cb0[145].w > 0 ? r2.xyz : r0.xyz;
  if (cb0[143].y > 0) {
    r1.xyzw = cmp(float4(0.00313080009,0.00313080009,0.00313080009,0.00313080009) >= r0.xxyz);
    r2.xyzw = float4(12.9232101,12.9232101,12.9232101,12.9232101) * r0.xxyz;
    r3.xyzw = log2(abs(r0.xxyz));
    r3.xyzw = float4(0.416666657,0.416666657,0.416666657,0.416666657) * r3.xyzw;
    r3.xyzw = exp2(r3.xyzw);
    r3.xyzw = r3.xyzw * float4(1.05499995,1.05499995,1.05499995,1.05499995) + float4(-0.0549999997,-0.0549999997,-0.0549999997,-0.0549999997);
    r1.xyzw = r1.xyzw ? r2.xyzw : r3.xyzw;
    r2.xyzw = float4(1,1.05499995,1,1) + -r1.xyzw;
    r3.xyzw = float4(0.0773993805,0.947867334,0.0773993805,0.0773993805) * r2.xyzw;
    r1.x = log2(abs(r3.y));
    r1.x = 2.4000001 * r1.x;
    r1.x = exp2(r1.x);
    r2.xyz = cmp(float3(0.0404499993,0.0404499993,0.0404499993) >= r2.xzw);
    r4.x = r2.x ? r3.x : r1.x;
    r1.xy = float2(1.05499995,1.05499995) + -r1.zw;
    r1.xy = float2(0.947867334,0.947867334) * r1.xy;
    r1.xy = log2(abs(r1.xy));
    r1.xy = float2(2.4000001,2.4000001) * r1.xy;
    r1.xy = exp2(r1.xy);
    r4.yz = r2.yz ? r3.zw : r1.xy;
    r1.xyz = r4.xyz + -r0.xyz;
    r0.xyz = cb0[143].yyy * r1.xyz + r0.xyz;
  }
  o0.xyzw = r0.xyzw;
  return;
}