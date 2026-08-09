#include "../tonemap.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[145];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.SampleBias(s0_s, v1.xy, cb0[5].x).xyzw;
  if (cb0[142].x > 0) {
    /*r1.xzw = saturate(r0.zxy);
    r2.xyz = cmp(float3(0.00313080009,0.00313080009,0.00313080009) >= r1.xzw);
    r3.xyz = float3(12.9232101,12.9232101,12.9232101) * r1.xzw;
    r1.xzw = log2(r1.xzw);
    r1.xzw = float3(0.416666657,0.416666657,0.416666657) * r1.xzw;
    r1.xzw = exp2(r1.xzw);
    r1.xzw = r1.xzw * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
    r1.xzw = r2.xyz ? r3.xyz : r1.xzw;
    r2.x = -1 + cb0[141].w;
    r2.yzw = r2.xxx * r1.xzw;
    r1.z = floor(r2.y);
    r3.xy = float2(0.5,0.5) * cb0[141].xy;
    r3.yz = r2.zw * cb0[141].xy + r3.xy;
    r3.x = r1.z * cb0[141].y + r3.y;
    r1.x = r1.x * r2.x + -r1.z;
    r2.xyzw = t1.SampleBias(s1_s, r3.xz, cb0[5].x).xyzw;
    r4.x = cb0[141].y;
    r4.y = 0;
    r1.zw = r4.xy + r3.xz;
    r3.xyzw = t1.SampleBias(s1_s, r1.zw, cb0[5].x).xyzw;
    r3.xyz = r3.xyz + -r2.xyz;
    r1.xzw = r1.xxx * r3.xyz + r2.xyz;
    r2.xyz = float3(0.0773993805,0.0773993805,0.0773993805) * r1.xzw;
    r3.xyz = float3(0.0549999997,0.0549999997,0.0549999997) + r1.xzw;
    r3.xyz = float3(0.947867334,0.947867334,0.947867334) * r3.xyz;
    r3.xyz = log2(abs(r3.xyz));
    r3.xyz = float3(2.4000001,2.4000001,2.4000001) * r3.xyz;
    r3.xyz = exp2(r3.xyz);
    r1.xzw = cmp(float3(0.0404499993,0.0404499993,0.0404499993) >= r1.xzw);
    r1.xzw = r1.xzw ? r2.xyz : r3.xyz;*/
    r1.xzw = handleUserLUT(r0.xyz, t1, s1_s, float3(cb0[141].xy, cb0[141].w - 1), 0, true);
    r1.xzw = r1.xzw + -r0.xyz;
    r0.xyz = cb0[142].xxx * r1.xzw + r0.xyz;
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
  r2.xyz = cb0[144].xyz * cb0[144].www;
  r3.xyz = cmp(float3(0,0,0) < r2.xyz);
  r4.xyz = cmp(r2.xyz < float3(0,0,0));
  r3.xyz = (int3)-r3.xyz + (int3)r4.xyz;
  r3.xyz = (int3)r3.xyz;
  r3.xyz = -r3.xyz * r1.www + float3(1,1,1);
  r2.xyz = r2.xyz * r3.xyz + float3(1,1,1);
  r3.xyz = -r1.zzz + r0.xyz;
  r2.xyz = r2.xyz * r3.xyz + r1.zzz;
  r0.xyz = cb0[144].w > 0 ? r2.xyz : r0.xyz;
  if (cb0[142].y > 0) {
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
    r0.xyz = cb0[142].yyy * r1.xyz + r0.xyz;
  }
  o0.xyzw = r0.xyzw;
  return;
}