Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[7];
}
cbuffer cb0 : register(b0){
  float4 cb0[4];
}

#define cmp -

void main(
  float4 v0 : TEXCOORD2,
  float4 v1 : TEXCOORD1,
  float4 v2 : SV_POSITION0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  // These samples drive the CRT ghost mask, not scene color. UNORM history bounded them and turned NaN into 0;
  // float history keeps NaN pixels that feed back every frame (a black band over the inventory).
  r0.xyzw = t1.Sample(s1_s, v1.xy).xyzw;
  r0.xyz = saturate(r0.xyz);
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r1.xyz = saturate(r1.xyz);
  r0.x = -r1.x + r0.x;
  r0.x = r0.x + r0.y;
  r0.x = r0.x + -r1.y;
  r0.x = r0.x + r0.z;
  r0.x = r0.x + -r1.z;
  r0.x = 0.333333343 * abs(r0.x);
  r0.y = cmp(r0.x < cb0[2].z);
  r0.x = r0.y ? 0 : r0.x;
  r0.xyz = r1.xyz * r0.xxx;
  r0.xyz = -r0.xyz * cb0[2].xxx + float3(1,1,1);
  r1.xyzw = t2.Sample(s2_s, v1.xy).xyzw;
  r2.x = 1 / cb1[6].x;
  r2.y = 0;
  r2.zw = v1.xy + r2.xy;
  r2.xy = v1.xy + -r2.xy;
  r3.xyzw = t2.Sample(s2_s, r2.xy).xyzw;
  r2.xyzw = t2.Sample(s2_s, r2.zw).xyzw;
  r1.xyz = saturate(r2.xyz) + saturate(r1.xyz);
  r1.xyz = r1.xyz + saturate(r3.xyz);
  r1.xyz = float3(0.333333343,0.333333343,0.333333343) * r1.xyz;
  r1.xyz = -r1.xyz * cb0[2].yyy + float3(1,1,1);
  r0.xyz = -r0.xyz * r1.xyz + float3(1,1,1);
  o0.xyz = saturate(cb0[3].xyz * r0.xyz);
  o0.w = 1;
  return;
}
