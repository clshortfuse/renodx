#include "../common.hlsl"

Texture2D<float4> t0 : register(t0);
cbuffer cb0 : register(b0){
  float4 cb0[142];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.zw = float2(0,0);
  //r1.xy = cb0[132].xy * v1.xy;
  //r1.xy = (int2)r1.xy;
  //r2.xyzw = (int4)r1.xyxy + int4(0,-1,-1,0);
  //r0.xy = r2.zw;
  r0.xy = cb0[132].xy * v1.xy;
  //r0.xyz = t0.Load(r0.xyz).xyz;
  r0.rgb = applySharpen(t0, int2(r0.xy), cb0[141].x);
  /*r3.xyzw = (int4)r1.xyxy + int4(0,1,1,0);
  r4.xy = r3.zw;
  r4.zw = float2(0,0);
  r4.xyz = t0.Load(r4.xyz).xyz;
  r5.xyz = max(r4.xyz, r0.xyz);
  r2.zw = float2(0,0);
  r2.xyz = t0.Load(r2.xyz).xyz;
  r5.xyz = max(r2.xyz, r5.xyz);
  r3.zw = float2(0,0);
  r3.xyz = t0.Load(r3.xyz).xyz;
  r5.xyz = max(r5.xyz, r3.xyz);
  r1.zw = float2(0,0);
  r1.xyz = t0.Load(r1.xyz).xyz;
  r6.xyz = max(r5.xyz, r1.xyz);
  r5.xyz = float3(4,4,4) * r5.xyz;
  r5.xyz = rcp(r5.xyz);
  r6.xyz = float3(1,1,1) + -r6.xyz;
  r7.xyz = min(r4.xyz, r0.xyz);
  r7.xyz = min(r7.xyz, r2.xyz);
  r7.xyz = min(r7.xyz, r3.xyz);
  r8.xyz = r7.xyz * float3(4,4,4) + float3(-4,-4,-4);
  r7.xyz = min(r7.xyz, r1.xyz);
  r5.xyz = r7.xyz * r5.xyz;
  r7.xyz = rcp(r8.xyz);
  r6.xyz = r7.xyz * r6.xyz;
  r5.xyz = max(r6.xyz, -r5.xyz);
  r0.w = max(r5.y, r5.z);
  r0.w = max(r5.x, r0.w);
  r0.w = min(0, r0.w);
  r0.w = max(-0.1875, r0.w);
  r0.w = cb0[141].x * r0.w;
  r0.xyz = r0.www * r0.xyz;
  r0.xyz = r0.www * r2.xyz + r0.xyz;
  r0.xyz = r0.www * r3.xyz + r0.xyz;
  r0.xyz = r0.www * r4.xyz + r0.xyz;
  r0.w = r0.w * 4 + 1;
  r0.xyz = r0.xyz + r1.xyz;
  r1.x = (int)-r0.w + 0x7ef19fff;
  r0.w = -r1.x * r0.w + 2;
  r0.w = r1.x * r0.w;*/
  //o0.xyz = r0.xyz * r0.www;
  if (injectedData.fxFilmGrain > 0.f) {
    r0.rgb = applyFilmGrain(r0.rgb, v1, injectedData.fxFilmGrainType != 0.f);
  }
  o0.xyz = PostToneMapScale(r0.xyz);
  o0.w = 1;
  return;
}