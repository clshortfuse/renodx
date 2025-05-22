#include "./common.hlsl"

Texture2DArray<float4> t1 : register(t1);
Texture2DArray<float4> t0 : register(t0);
cbuffer cb1 : register(b1){
  float4 cb1[49];
}
cbuffer cb0 : register(b0){
  float4 cb0[16];
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
  r1.xy = v1.xy * cb0[6].xy + cb0[6].zw;
  r1.xy = cb0[7].xy * r1.xy;
  r0.xyz = applySharpen(t0, int2(r1.xy));
  /*r1.xy = (uint2)r1.xy;
  r2.xyzw = (int4)r1.xyxy + int4(0,-1,-1,0);
  r0.xy = r2.zw;
  r0.xyz = t0.Load(r0.xyzw).xyz;
  r3.xyzw = (int4)r1.xyxy + int4(0,1,1,0);
  r4.xy = r3.zw;
  r4.zw = float2(0,0);
  r4.xyz = t0.Load(r4.xyzw).xyz;
  r5.xyz = min(r4.xyz, r0.xyz);
  r2.zw = float2(0,0);
  r2.xyz = t0.Load(r2.xyzw).xyz;
  r5.xyz = min(r2.xyz, r5.xyz);
  r3.zw = float2(0,0);
  r3.xyz = t0.Load(r3.xyzw).xyz;
  r5.xyz = min(r5.xyz, r3.xyz);
  r6.xyz = r5.xyz * float3(4,4,4) + float3(-4,-4,-4);
  r6.xyz = rcp(r6.xyz);
  r7.xyz = max(r4.xyz, r0.xyz);
  r7.xyz = max(r7.xyz, r2.xyz);
  r7.xyz = max(r7.xyz, r3.xyz);
  r1.zw = float2(0,0);
  r1.xyz = t0.Load(r1.xyzw).xyz;
  r8.xyz = max(r7.xyz, r1.xyz);
  r7.xyz = float3(4,4,4) * r7.xyz;
  r7.xyz = rcp(r7.xyz);
  r8.xyz = float3(1,1,1) + -r8.xyz;
  r6.xyz = r8.xyz * r6.xyz;
  r5.xyz = min(r5.xyz, r1.xyz);
  r5.xyz = r5.xyz * r7.xyz;
  r5.xyz = max(-r5.xyz, r6.xyz);
  r0.w = max(r5.y, r5.z);
  r0.w = max(r5.x, r0.w);
  r0.w = min(0, r0.w);
  r0.w = max(-0.1875, r0.w);
  r0.w = cb0[15].x * r0.w;
  r0.xyz = r0.www * r0.xyz;
  r0.xyz = r0.www * r2.xyz + r0.xyz;
  r0.xyz = r0.www * r3.xyz + r0.xyz;
  r0.xyz = r0.www * r4.xyz + r0.xyz;
  r0.w = r0.w * 4 + 1;
  r0.xyz = r0.xyz + r1.xyz;
  r1.x = (int)-r0.w + 0x7ef19fff;
  r0.w = -r1.x * r0.w + 2;
  r0.w = r1.x * r0.w;
  r0.xyz = r0.xyz * r0.www;*/
  if (injectedData.fxFilmGrain > 0.f) {
    r0.rgb = applyFilmGrain(r0.rgb, v1, injectedData.fxFilmGrainType != 0.f);
  }
  o0.rgb = PostToneMapScale(r0.rgb);
  r0.xy = cb1[48].xy * v1.xy;
  r0.xy = (uint2)r0.xy;
  r0.xy = (uint2)r0.xy;
  r0.zw = float2(-1,-1) + cb1[48].xy;
  r0.zw = cb0[6].zw * r0.zw;
  r0.xy = r0.xy * cb0[6].xy + r0.zw;
  r0.xy = (uint2)r0.xy;
  r0.zw = float2(0,0);
  r0.x = t1.Load(r0.xyzw).x;
  o0.w = cb0[8].x == 1.0 ? r0.x : 1;
  return;
}