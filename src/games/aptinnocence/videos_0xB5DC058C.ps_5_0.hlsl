#include "./common.hlsl"

cbuffer CBufferGlobalConstant_Z : register(b0){
  struct
  {
    float4 c[90];
  } Global : packoffset(c0);
}
cbuffer CBufferObjectConstant_Z : register(b1){
  struct
  {
    float4 c[32];
  } Object : packoffset(c0);
}

SamplerState sMaterialSampler_s : register(s0);
Texture2D<float4> sDiffuse : register(t0);
Texture2D<float4> sAddDiffuse : register(t1);
Texture2D<float4> sSpecular : register(t2);
Texture2DArray<float4> sBlueNoiseR8 : register(t3);

#define cmp -

void main(
  float4 v0 : SV_Position0,
  float4 v1 : COLOR0,
  float4 v2 : TEXCOORD0,
  float v3 : INSTANCE_COLOR0,
  uint2 v4 : INSTANCE_INDEXES0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = sDiffuse.Sample(sMaterialSampler_s, v2.xy).x;
  r0.y = sAddDiffuse.Sample(sMaterialSampler_s, v2.xy).x;
  r0.z = sSpecular.Sample(sMaterialSampler_s, v2.xy).x;
  r1.xyz = float3(1.59579468,-0.813476562,0) * r0.yyy;
  r0.xyw = r0.xxx * float3(1.16412354,1.16412354,1.16412354) + r1.xyz;
  r0.xyz = r0.zzz * float3(0,-0.391448975,2.01782227) + r0.xyw;
  r0.xyz = saturate(float3(-0.87065506,0.529705048,-1.08166885) + r0.xyz);
  r0.xyz = log2(r0.xyz);
  r0.xyz = Object.c[24].xxx * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r1.xyz = v1.xyz * r0.xyz;
  r0.w = (int)Global.c[1].x & 1;
  if (r0.w != 0) {
    r2.xyz = log2(r1.xyz);
    r2.xyz = floor(r2.xyz);
    r2.xyz = float3(-6,-6,-5) + r2.xyz;
    r2.xyz = exp2(r2.xyz);
    r3.xy = (uint2)v0.xy;
    r3.xy = (int2)r3.xy & int2(63,63);
    r3.zw = float2(0,0);
    r3.x = sBlueNoiseR8.Load(r3.xyzw).x;
    r3.yz = float2(1,-1);
    r4.xyz = r3.xyy * r2.xyz;
    r2.xyz = float3(1,0,0) * r2.xyz;
    r2.xyz = r3.zxx * r4.xyz + r2.xyz;
    r0.xyz = v1.xyz * r0.xyz + r2.xyz;
  } else {
    r2.xy = (uint2)v0.xy;
    r2.xy = (int2)r2.xy & int2(63,63);
    r2.zw = float2(0,0);
    r1.w = sBlueNoiseR8.Load(r2.xyzw).x;
    r2.x = r1.x;
    r2.yz = float2(0,0);
    r2.xyz = r1.www * float3(-0.00392156886,0.00392156886,0.00392156886) + r2.xyz;
    r1.x = 0.00392156886;
    r0.xyz = r1.xyz + r2.xyz;
  }
  r0.w = v1.w;
  o0.xyzw = r0.xyzw;
  o0.rgb = PostToneMapScale(o0.rgb);
  return;
}