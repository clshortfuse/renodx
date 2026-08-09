Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[6];
}
cbuffer cb0 : register(b0){
  float4 cb0[126];
}

void main(
  float4 v0 : SV_POSITION0,
  float3 v1 : INTERP0,
  float4 v2 : INTERP1,
  float4 v3 : INTERP2,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(-0.5,-0.5) + v2.xy;
  r0.x = dot(r0.xy, r0.xy);
  r0.x = sqrt(r0.x);
  r0.x = cb1[5].w * r0.x;
  r1.xyzw = t2.SampleBias(s2_s, v2.xy, cb0[19].x).xyzw;
  r0.xyz = r1.xyz * r0.xxx;
  r1.xyzw = t0.SampleBias(s0_s, v2.xy, cb0[19].x).xyzw;
  r1.xyz = float3(-0.217637643,-0.217637643,-0.217637643) + r1.xyz;
  r2.xyzw = t1.SampleBias(s1_s, v2.xy, cb0[19].x).xyzw;
  r1.xyz = r1.xyz * float3(2,2,2) + r2.xyz;
  r1.xyz = float3(0.217637643,0.217637643,0.217637643) + r1.xyz;
  r0.xyz = r0.xyz * r1.xyz + float3(-0.217637643,-0.217637643,-0.217637643);
  r0.xyz = r0.xyz * cb1[5].xxx + float3(0.217637643,0.217637643,0.217637643);
  r0.w = max(cb1[5].y, cb1[3].x);
  r0.w = min(cb1[5].z, r0.w);
  r0.xyzw = -cb1[3].yyyy + r0.xyzw;
  r0.w = 1 / r0.w;
  r0.xyz = saturate(r0.xyz * r0.www);
  r1.xyz = r0.xyz * float3(-2,-2,-2) + float3(3,3,3);
  r0.xyz = r0.xyz * r0.xyz;
  r2.xyz = r1.xyz * r0.xyz;
  r0.xyz = -r1.xyz * r0.xyz + float3(1,1,1);
  r0.xyz = r0.xyz * float3(2,2,2) + float3(-0.217637643,-0.217637643,-0.217637643);
  r0.w = max(0, cb1[3].x);
  r0.w = min(1.29999995, r0.w);
  r1.xyz = r0.www * -r2.xyz + r2.xyz;
  r1.xyz = float3(1,1,1) + -r1.xyz;
  r0.xyz = r0.xyz * float3(2,2,2) + r1.xyz;
  r0.xyz = float3(0.217637643,0.217637643,0.217637643) + r0.xyz;
  r0.x = dot(r0.xyz, float3(0.212672904,0.715152204,0.0721750036));
  r1.xyzw = cb0[125].xyzw * v3.xyzw;
  o0.w = r1.w * r0.x;
  o0.xyz = cb1[4].xyz * r1.xyz;
  o0.w = saturate(o0.w);
  return;
}