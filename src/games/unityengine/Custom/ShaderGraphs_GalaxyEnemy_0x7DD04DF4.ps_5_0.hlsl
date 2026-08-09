Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[10];
}
cbuffer cb0 : register(b0){
  float4 cb0[20];
}

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : INTERP0,
  float3 v2 : INTERP1,
  float3 v3 : INTERP2,
  float3 v4 : INTERP3,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = dot(v3.xyz, v3.xyz);
  r0.x = sqrt(r0.x);
  r0.x = 1 / r0.x;
  r0.xyz = v3.xyz * r0.xxx;
  r0.w = dot(r0.xyz, r0.xyz);
  r0.w = rsqrt(r0.w);
  r0.xyz = r0.xyz * r0.www;
  r0.w = dot(v4.xyz, v4.xyz);
  r0.w = rsqrt(r0.w);
  r1.xyz = v4.xyz * r0.www;
  r0.x = saturate(dot(r0.xyz, r1.xyz));
  r0.yz = cb1[2].xx * r1.xy;
  r0.yzw = t1.SampleBias(s1_s, r0.yz, cb0[19].x).xyz;
  r0.yzw = float3(-0.217637643,-0.217637643,-0.217637643) + r0.yzw;
  r0.yzw = r0.yzw * float3(1.05,1.05,1.05) + float3(0.217637643,0.217637643,0.217637643);
  r0.x = 1 + -r0.x;
  r0.x = log2(r0.x);
  r1.xy = cb1[9].xy * r0.xx;
  r0.x = cb1[5].y * r0.x;
  r0.x = exp2(r0.x);
  r0.x = 1 + -r0.x;
  r0.x = log2(abs(r0.x));
  r0.x = cb1[5].z * r0.x;
  r0.x = exp2(r0.x);
  o0.w = cb1[5].w * r0.x;
  r1.xy = exp2(r1.xy);
  r2.xyz = float3(0.0980392173,0.0980392173,0.0980392173) + cb1[8].xyz;
  r1.xzw = r2.xyz * r1.xxx;
  r2.xyz = cb1[8].xyz * r1.yyy;
  r1.xyz = cb1[9].zzz * r1.xzw;
  r3.xy = float2(2,1.5) + cb0[15].yy;
  r0.x = r3.x * 0.333333343 + 0.5;
  r1.w = 0.461538494 * r3.y;
  r3.xyz = r2.xyz * r0.xxx + -r1.xyz;
  r2.xyz = r2.xyz * r0.xxx;
  r1.xyz = r2.xyz * r3.xyz + r1.xyz;
  r2.xyz = cb1[4].xyz + -r0.yzw;
  r2.xyz = cb1[5].xxx * r2.xyz + r0.yzw;
  r0.xyz = r0.yzw * cb1[3].xyz + r2.xyz;
  r2.xy = cb0[15].xx * float2(0.025,0.025) + v1.xy;
  r2.xyz = t0.SampleBias(s0_s, r2.xy, cb0[19].x).xyz;
  r2.xyz = r2.xyz * cb1[6].xyz + float3(-0.217637643,-0.217637643,-0.217637643);
  r2.xyz = r2.xyz * cb1[7].xxx + float3(0.217637643,0.217637643,0.217637643);
  r0.xyz = r2.xyz * r1.www + r0.xyz;
  o0.xyz = r1.xyz * float3(3,3,3) + r0.xyz;
  o0.w = saturate(o0.w);
  return;
}