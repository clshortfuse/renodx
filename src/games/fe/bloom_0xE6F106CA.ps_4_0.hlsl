Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[7];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = cb0[2].xyxy * cb0[5].xxxx + v1.xyxy;
  r1.xyzw = -cb0[2].xxxy * float4(1,0,0,1) + r0.zwzw;
  r2.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.xyzw = t0.Sample(s0_s, r1.zw).xyzw;
  r2 = saturate(r2);
  r1 = saturate(r1);
  r1.xyz = min(float3(65000,65000,65000), r1.xyz);
  r2.xyz = min(float3(65000,65000,65000), r2.xyz);
  r3.xyzw = t0.Sample(s0_s, r0.zw).xyzw;
  r3 = saturate(r3);
  r0.xyzw = cb0[2].xxxy * float4(1,0,0,1) + r0.xyzw;
  r3.xyz = min(float3(65000,65000,65000), r3.xyz);
  r4.xyz = r3.xyz + r2.xyz;
  r5.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r5 = saturate(r5);
  r0.xyzw = t0.Sample(s0_s, r0.zw).xyzw;
  r0 = saturate(r0);
  r0.xyz = min(float3(65000,65000,65000), r0.xyz);
  r5.xyz = min(float3(65000,65000,65000), r5.xyz);
  r4.xyz = r5.xyz + r4.xyz;
  r6.xyz = min(r3.xyz, r2.xyz);
  r2.xyz = max(r3.xyz, r2.xyz);
  r2.xyz = max(r2.xyz, r5.xyz);
  r3.xyz = min(r6.xyz, r5.xyz);
  r3.xyz = r4.xyz + -r3.xyz;
  r2.xyz = r3.xyz + -r2.xyz;
  r3.xyz = r2.xyz + r1.xyz;
  r3.xyz = r3.xyz + r0.xyz;
  r4.xyz = min(r2.xyz, r1.xyz);
  r1.xyz = max(r2.xyz, r1.xyz);
  r1.xyz = max(r1.xyz, r0.xyz);
  r0.xyz = min(r4.xyz, r0.xyz);
  r0.xyz = r3.xyz + -r0.xyz;
  r0.xyz = r0.xyz + -r1.xyz;
  r1.xyz = r0.xyz * float3(0.305306,0.305306,0.305306) + float3(0.682171,0.682171,0.682171);
  r1.xyz = r0.xyz * r1.xyz + float3(0.012523,0.012523,0.012523);
  r0.xyz = r1.xyz * r0.xyz;
  r0.w = max(r0.x, r0.y);
  r0.w = max(r0.w, r0.z);
  r1.x = -cb0[6].x + r0.w;
  r1.x = max(0, r1.x);
  r1.x = min(cb0[6].y, r1.x);
  r1.x = r1.x * r1.x;
  r1.x = cb0[6].z * r1.x;
  r1.y = -cb0[5].y + r0.w;
  r0.w = max(0.00001, r0.w);
  r1.x = max(r1.x, r1.y);
  r0.w = r1.x / r0.w;
  o0.xyz = r0.xyz * r0.www;
  o0.w = 0;
  return;
}