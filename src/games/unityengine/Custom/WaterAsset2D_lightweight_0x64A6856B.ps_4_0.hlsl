Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[10];
}
cbuffer cb0 : register(b0){
  float4 cb0[80];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : INTERP0,
  float4 v2 : INTERP1,
  float3 v3 : INTERP2,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cb0[77].w * v3.y;
  r0.x = cb0[76].w * v3.x + r0.x;
  r0.x = cb0[78].w * v3.z + r0.x;
  r0.x = cb0[79].w + r0.x;
  r1.xyzw = t1.SampleBias(s1_s, v1.xy, cb0[5].x).xyzw;
  r0.y = r0.x / cb1[9].y;
  r0.y = r0.y * -cb1[9].x + cb1[9].x;
  r0.y = r1.w * r0.y;
  if (r0.y == 0.0) discard;
  r2.xyz = float3(1,1,1) + -r1.xyz;
  r2.xyz = r2.xyz + r2.xyz;
  r3.xyz = float3(1,1,1) + -cb1[8].xyz;
  r2.xyz = -r2.xyz * r3.xyz + float3(1,1,1);
  r3.xyz = r1.xyz + r1.xyz;
  r3.xyz = cb1[8].xyz * r3.xyz;
  r4.xyz = cmp(float3(0.5,0.5,0.5) >= r1.xyz);
  r5.xyz = r4.xyz ? float3(1,1,1) : 0;
  r4.xyz = r4.xyz ? float3(0,0,0) : float3(1,1,1);
  r2.xyz = r4.xyz * r2.xyz;
  r2.xyz = r3.xyz * r5.xyz + r2.xyz;
  r2.xyz = r2.xyz + -r1.xyz;
  r2.xyz = r2.xyz * float3(4,4,4) + r1.xyz;
  r0.z = saturate(r0.x / cb1[7].z);
  r1.xyz = -r2.xyz + r1.xyz;
  r1.xyz = r0.zzz * r1.xyz + r2.xyz;
  r1.xyz = cb1[2].xyz * r1.xyz;
  r0.z = cb1[3].x * cb0[19].x;
  r0.zw = v3.xz * cb1[5].xx + r0.zz;
  r2.xyzw = t0.SampleBias(s0_s, r0.zw, cb0[5].x).xyzw;
  r2.xyz = cb1[3].yyy * r2.xyz;
  r2.xyz = -r2.xyz * cb1[4].xyz + float3(1,1,1);
  r3.xyz = r2.xyz * r1.xyz;
  r0.z = cb1[7].y + -cb1[7].x;
  r0.w = -cb1[7].x + r0.x;
  r0.z = 1 / r0.z;
  r0.z = saturate(r0.w * r0.z);
  r0.w = r0.z * -2 + 3;
  r0.z = r0.z * r0.z;
  r0.z = r0.w * r0.z;
  r0.x = r0.x * r0.z;
  r0.x = r0.x / cb1[5].y;
  r0.x = max(0, r0.x);
  r0.x = min(0.899999976, r0.x);
  r1.xyz = -r1.xyz * r2.xyz + cb1[6].xyz;
  r0.xzw = r0.xxx * r1.xyz + r3.xyz;
  o0.xyz = v2.xyz + r0.xzw;
  o0.w = v2.w * r0.y;
  o0.w = saturate(o0.w);
  return;
}