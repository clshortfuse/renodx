Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb2 : register(b2){
  float4 cb2[1];
}
cbuffer cb1 : register(b1){
  float4 cb1[5];
}
cbuffer cb0 : register(b0){
  float4 cb0[9];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float3 v2 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = dot(cb2[0].xyz, cb2[0].xyz);
  r0.x = rsqrt(r0.x);
  r0.xyz = cb2[0].xyz * r0.xxx;
  r1.xyz = cb1[4].xyz + -v1.xyz;
  r0.w = dot(r1.xyz, r1.xyz);
  r0.w = rsqrt(r0.w);
  r2.xyz = r1.xyz * r0.www + r0.xyz;
  r1.xyz = r1.xyz * r0.www;
  r0.w = dot(r2.xyz, r2.xyz);
  r0.w = rsqrt(r0.w);
  r2.xyz = r2.xyz * r0.www;
  r0.w = dot(v2.xyz, v2.xyz);
  r0.w = rsqrt(r0.w);
  r3.xyz = v2.xyz * r0.www;
  r0.w = saturate(dot(r3.xyz, r2.xyz));
  r1.w = saturate(dot(r0.xyz, r2.xyz));
  r0.x = dot(r3.xyz, r0.xyz);
  r0.y = dot(r3.xyz, r1.xyz);
  r0.z = r0.w * r0.w;
  r0.z = r0.z * -0.9375 + 1;
  r0.z = r0.z * r0.z + 1.00000001e-007;
  r0.w = abs(r0.y) * 0.75 + 0.25;
  r1.x = max(0, r0.x);
  r1.y = min(1, r1.x);
  r1.z = r1.y * 0.75 + 0.25;
  r1.z = r1.z * abs(r0.y);
  r0.y = 1 + -abs(r0.y);
  r0.w = r1.y * r0.w + r1.z;
  r0.w = 9.99999975e-006 + r0.w;
  r0.zw = float2(0.0198943671,0.5) / r0.zw;
  r0.z = r0.w * r0.z;
  r0.z = 3.14159274 * r0.z;
  r0.z = max(9.99999975e-005, r0.z);
  r0.z = sqrt(r0.z);
  r0.z = r0.z * r1.y;
  r2.xyz = float3(-0.220916301,-0.220916301,-0.220916301) + cb0[4].xyz;
  r2.xyz = cb0[6].xxx * r2.xyz + float3(0.220916301,0.220916301,0.220916301);
  r0.w = dot(r2.xyz, r2.xyz);
  r0.w = cmp(r0.w != 0.000000);
  r0.w = r0.w ? 1.000000 : 0;
  r0.z = r0.z * r0.w;
  r3.xyz = cb0[2].xyz * r0.zzz;
  r0.z = 1 + -r1.w;
  r0.w = r0.z * r0.z;
  r0.w = r0.w * r0.w;
  r0.z = r0.w * r0.z;
  r4.xyz = float3(1,1,1) + -r2.xyz;
  r2.xyz = r4.xyz * r0.zzz + r2.xyz;
  r2.xyz = r3.xyz * r2.xyz;
  r0.z = r0.y * r0.y;
  r0.z = r0.z * r0.z;
  r0.y = r0.z * r0.y;
  r0.z = r1.w + r1.w;
  r0.z = r0.z * r1.w;
  r0.z = r0.z * 0.5 + -0.5;
  r0.y = r0.z * r0.y + 1;
  r0.w = -cb0[8].y * 0.5 + 1;
  r1.y = -r0.x * r0.w + 1;
  r0.x = r0.x * r0.w;
  r0.x = cb0[8].y * 0.5 + r0.x;
  r0.x = max(0, r0.x);
  r0.x = log2(r0.x);
  r0.x = cb0[8].x * r0.x;
  r0.x = exp2(r0.x);
  r0.w = r1.y * r1.y;
  r0.w = r0.w * r0.w;
  r0.w = r0.w * r1.y;
  r0.z = r0.z * r0.w + 1;
  r0.y = r0.z * r0.y;
  r0.x = r0.y * r1.x + r0.x;
  r0.xyz = cb0[2].xyz * r0.xxx;
  r0.w = -cb0[6].x * 0.779083729 + 0.779083729;
  r1.xyz = cb0[4].xyz * r0.www;
  r0.xyz = r0.xyz * r1.xyz + r2.xyz;
  o0.xyz = cb0[7].xyz + r0.xyz;
  r0.xy = cb1[0].xx * cb0[6].zw + v1.xy;
  r0.xy = r0.xy * cb0[5].xy + cb0[5].zw;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r0.x = r0.x * 0.200000003 + 0.5;
  r0.y = v1.z / cb0[8].z;
  r0.y = 1 + r0.y;
  r0.y = cb0[6].y * r0.y;
  o0.w = r0.y * r0.x;
  // The depth-based fog factor is unbounded and the lighting sum can go negative. UNORM targets clamped both before
  // blending; float targets blend them as-is and produce dark or inverted fog patches.
  o0.xyz = max(0, o0.xyz);
  o0.w = saturate(o0.w);
  return;
}
