Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[17];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float4 v2 : TEXCOORD0,
  float4 v3 : TEXCOORD1,
  float4 v4 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb0[14].xy + -cb0[8].xy;
  r0.xy = r0.xy * cb0[7].xy + v2.xy;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r1.xy = v2.xy * cb0[7].zw + -cb0[8].xy;
  r2.yz = cb0[8].zw * r1.xy;
  r1.x = r1.x * cb0[8].z + -1;
  r1.yz = cmp(r2.yz >= cb0[13].xy);
  r1.yz = r1.yz ? float2(1,1) : 0;
  r3.xy = cmp(cb0[13].zw >= r2.yz);
  r3.xy = r3.xy ? float2(1,1) : 0;
  r1.y = r3.x * r1.y;
  r1.y = r1.y * r1.z;
  r1.y = r1.y * r3.y;
  r1.z = r1.y * r0.w;
  r0.w = -r0.w * r1.y + 1;
  r0.xyz = r1.zzz * r0.xyz;
  r3.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  r3.xyzw = cb0[3].xyzw + r3.xyzw;
  r1.y = r3.w * r0.w;
  r0.w = r3.w * r0.w + r1.z;
  r0.xyz = r1.yyy * r3.xyz + r0.xyz;
  r0.xyz = r0.xyz / r0.www;
  r1.yz = cmp(r2.yz >= cb0[9].xy);
  r1.yz = r1.yz ? float2(1,1) : 0;
  r3.xy = cmp(cb0[9].zw >= r2.yz);
  r3.xy = r3.xy ? float2(1,1) : 0;
  r1.y = r3.x * r1.y;
  r1.y = r1.y * r1.z;
  r1.y = r1.y * r3.y;
  r1.zw = cb0[10].xy + -cb0[8].xy;
  r1.zw = r1.zw * cb0[7].xy + v2.xy;
  r3.xyzw = t0.Sample(s0_s, r1.zw).xyzw;
  r1.z = -r3.w * r1.y + 1;
  r1.y = r3.w * r1.y;
  r3.xyz = r3.xyz * r1.yyy;
  r1.y = r0.w * r1.z + r1.y;
  r0.w = r1.z * r0.w;
  r0.xyz = r0.www * r0.xyz + r3.xyz;
  r0.xyz = r0.xyz / r1.yyy;
  r1.zw = cmp(r2.yz >= cb0[11].xy);
  r1.zw = r1.zw ? float2(1,1) : 0;
  r3.xy = cmp(cb0[11].zw >= r2.yz);
  r3.xy = r3.xy ? float2(1,1) : 0;
  r0.w = r3.x * r1.z;
  r0.w = r0.w * r1.w;
  r0.w = r0.w * r3.y;
  r1.zw = cb0[12].xy + -cb0[8].xy;
  r1.zw = r1.zw * cb0[7].xy + v2.xy;
  r3.xyzw = t0.Sample(s0_s, r1.zw).xyzw;
  r1.z = -r3.w * r0.w + 1;
  r0.w = r3.w * r0.w;
  r3.xyz = r3.xyz * r0.www;
  r0.w = r1.y * r1.z + r0.w;
  r1.y = r1.y * r1.z;
  r0.xyz = r1.yyy * r0.xyz + r3.xyz;
  r0.xyz = r0.xyz / r0.www;
  r1.yz = cmp(r2.yz >= cb0[15].xy);
  r1.yz = r1.yz ? float2(1,1) : 0;
  r2.yw = cmp(cb0[15].zw >= r2.yz);
  r2.yw = r2.yw ? float2(1,1) : 0;
  r1.y = r2.y * r1.y;
  r1.y = r1.y * r1.z;
  r1.y = r1.y * r2.w;
  r1.zw = cb0[16].xy + -cb0[8].xy;
  r1.zw = r1.zw * cb0[7].xy + v2.xy;
  r3.xyzw = t0.Sample(s0_s, r1.zw).xyzw;
  r1.z = -r3.w * r1.y + 1;
  r1.y = r3.w * r1.y;
  r3.xyz = r3.xyz * r1.yyy;
  r1.y = r0.w * r1.z + r1.y;
  r0.w = r1.z * r0.w;
  r0.xyz = r0.www * r0.xyz + r3.xyz;
  r0.xyz = r0.xyz / r1.yyy;
  r0.w = cmp(r1.y >= 0.001);
  r0.w = r0.w ? 1.000000 : 0;
  r1.z = cmp(cb0[16].z >= 0);
  r1.z = r1.z ? 1.000000 : 0;
  r2.x = r1.x * cb0[16].z + r1.z;
  r2.xyzw = t1.Sample(s1_s, r2.xz).xyzw;
  r1.x = -r2.w * r0.w + 1;
  r0.w = r2.w * r0.w;
  r2.xyz = r2.xyz * r0.www;
  r3.w = r1.y * r1.x + r0.w;
  r0.w = r1.y * r1.x;
  r0.xyz = r0.www * r0.xyz + r2.xyz;
  r3.xyz = r0.xyz / r3.www;
  r0.xyzw = v1.xyzw * r3.xyzw;
  o0.xyz = r0.xyz * r0.www;
  o0.w = r0.w;
  o0 = max(0.f, o0);
  return;
}