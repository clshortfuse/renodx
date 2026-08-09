#include "../common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb2 : register(b2){
  float4 cb2[15];
}
cbuffer cb1 : register(b1){
  float4 cb1[8];
}
cbuffer cb0 : register(b0){
  float4 cb0[123];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb1[5].xy * v1.yy;
  r0.xy = cb1[4].xy * v1.xx + r0.xy;
  r0.xy = cb1[6].xy * v1.zz + r0.xy;
  r0.xy = cb1[7].xy + r0.xy;
  r0.xy = cb2[1].yz * r0.xy;
  r0.xy = floor(r0.xy);
  r0.xy = r0.xy / cb2[1].yz;
  r0.zw = cb2[3].xy * cb0[13].xx;
  r0.xz = r0.xy * cb2[3].zw + r0.zw;
  r0.y = 1 + -r0.y;
  r1.xyzw = t1.Sample(s1_s, r0.xz).xyzw;
  r0.x = cb2[12].w + -cb2[12].z;
  r0.x = cb2[4].x * r0.x + cb2[12].z;
  r0.x = cb2[4].y * 0.333333343 + r0.x;
  r0.z = -cb2[4].y + r0.x;
  r0.xw = cb2[4].zy + r0.xx;
  r1.w = r0.y + -r0.z;
  r0.z = r0.w + -r0.z;
  r0.z = 1 / r0.z;
  r0.z = saturate(r1.w * r0.z);
  r0.w = r0.z * -2 + 3;
  r0.z = r0.z * r0.z;
  r0.z = r0.w * r0.z;
  r1.xyz = r1.xyz * r0.zzz;
  r0.z = cb2[4].y + r0.x;
  r0.x = -cb2[4].y + r0.x;
  r0.z = r0.z + -r0.x;
  r0.x = r0.y + -r0.x;
  r0.y = 1 / r0.z;
  r0.x = saturate(r0.x * r0.y);
  r0.y = r0.x * -2 + 3;
  r0.x = r0.x * r0.x;
  r0.xyz = r0.yyy * r0.xxx + r1.xyz;
  r0.xyz = -cb2[5].xxx + r0.xyz;
  r0.w = cb2[5].y + -cb2[5].x;
  r0.w = 1 / r0.w;
  r0.xyz = saturate(r0.xyz * r0.www);
  r1.xyz = r0.xyz * float3(-2,-2,-2) + float3(3,3,3);
  r0.xyz = r0.xyz * r0.xyz;
  r2.xyz = -r1.xyz * r0.xyz + float3(1,1,1);
  r0.xyz = r1.xyz * r0.xyz;
  r1.xyz = log2(abs(cb2[6].xyz));
  r1.xyz = float3(0.416666657,0.416666657,0.416666657) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.xyz = r1.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  r3.xyz = float3(12.9200001,12.9200001,12.9200001) * cb2[6].xyz;
  r4.xyz = cmp(float3(0.00313080009,0.00313080009,0.00313080009) >= cb2[6].xyz);
  r1.xyz = r4.xyz ? r3.xyz : r1.xyz;
  r1.xyz = r1.xyz * r0.xyz;
  r3.xyz = log2(abs(cb2[8].xyz));
  r3.xyz = float3(0.416666657,0.416666657,0.416666657) * r3.xyz;
  r3.xyz = exp2(r3.xyz);
  r3.xyz = r3.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  r4.xyz = float3(12.9200001,12.9200001,12.9200001) * cb2[8].xyz;
  r5.xyz = cmp(float3(0.00313080009,0.00313080009,0.00313080009) >= cb2[8].xyz);
  r3.xyz = r5.xyz ? r4.xyz : r3.xyz;
  r1.xyz = r3.xyz * r2.xyz + r1.xyz;
  r3.xyz = log2(abs(cb2[7].xyz));
  r3.xyz = float3(0.416666657,0.416666657,0.416666657) * r3.xyz;
  r3.xyz = exp2(r3.xyz);
  r3.xyz = r3.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  r4.xyz = float3(12.9200001,12.9200001,12.9200001) * cb2[7].xyz;
  r5.xyz = cmp(float3(0.00313080009,0.00313080009,0.00313080009) >= cb2[7].xyz);
  r3.xyz = r5.xyz ? r4.xyz : r3.xyz;
  r3.xyz = r3.xyz * r0.xyz;
  r4.xyz = log2(abs(cb2[9].xyz));
  r4.xyz = float3(0.416666657,0.416666657,0.416666657) * r4.xyz;
  r4.xyz = exp2(r4.xyz);
  r4.xyz = r4.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  r5.xyz = float3(12.9200001,12.9200001,12.9200001) * cb2[9].xyz;
  r6.xyz = cmp(float3(0.00313080009,0.00313080009,0.00313080009) >= cb2[9].xyz);
  r4.xyz = r6.xyz ? r5.xyz : r4.xyz;
  r2.xyz = r4.xyz * r2.xyz + r3.xyz;
  r0.w = cmp(0 != cb2[1].x);
  r1.xyz = r0.www ? r1.xyz : r2.xyz;
  r2.xyz = cb2[14].xyz * cb2[13].xxx;
  r0.xyz = r2.xyz * r0.xyz + r1.xyz;
  r1.xyz = log2(abs(cb2[11].xyz));
  r1.xyz = float3(0.416666657,0.416666657,0.416666657) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.xyz = r1.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  r2.xyz = float3(12.9200001,12.9200001,12.9200001) * cb2[11].xyz;
  r3.xyz = cmp(float3(0.00313080009,0.00313080009,0.00313080009) >= cb2[11].xyz);
  r1.xyz = r3.xyz ? r2.xyz : r1.xyz;
  r2.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  r3.xyz = cmp(r2.xyz >= cb2[12].xxx);
  r3.xyz = r3.xyz ? float3(1,1,1) : 0;
  r1.xyz = r3.xyz * r1.xyz;
  r0.w = dot(r2.xyz, float3(0.212672904,0.715152204,0.0721750036));
  r3.xyz = r2.xyz + -r0.www;
  r3.xyz = cb2[10].xxx * r3.xyz + r0.www;
  r3.xyz = float3(-0.217637643,-0.217637643,-0.217637643) + r3.xyz;
  r1.xyz = r3.xyz * cb2[12].yyy + r1.xyz;
  r1.xyz = float3(0.217637643,0.217637643,0.217637643) + r1.xyz;
  r2.xyz = r1.xyz * r0.xyz;
  r0.xyzw = cb0[122].xyzw * v3.xyzw;
  o0.xyzw = r2.xyzw * r0.xyzw;
  if(injectedData.rolloffUI == 1.f){
    o0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(o0.xyz) : o0.xyz;
    o0.xyz = rolloff(o0.xyz, 0.85f, true);
    o0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(o0.xyz) : o0.xyz;
  } else if(injectedData.rolloffUI == 2.f){
    o0.xyz = saturate(o0.xyz);
  }
  return;
}