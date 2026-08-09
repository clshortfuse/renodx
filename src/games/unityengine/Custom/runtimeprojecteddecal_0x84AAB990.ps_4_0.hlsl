Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb2 : register(b2){
  float4 cb2[2];
}
cbuffer cb1 : register(b1){
  float4 cb1[8];
}
cbuffer cb0 : register(b0){
  float4 cb0[1355];
}

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  float4 v4 : TEXCOORD3,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = cb0[1352].xyw * v1.yyy;
  r0.xyz = cb0[1351].xyw * v1.xxx + r0.xyz;
  r0.xyz = cb0[1353].xyw * v1.zzz + r0.xyz;
  r0.xyz = cb0[1354].xyw + r0.xyz;
  r0.y = cb0[1302].x * r0.y;
  r1.xzw = float3(0.5,0.5,0.5) * r0.xzy;
  r0.xy = r1.xw + r1.zz;
  r0.xy = r0.xy / r0.zz;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r0.x = cb0[1304].z * r0.x + cb0[1304].w;
  r0.x = 1 / r0.x;
  r0.yzw = cb1[5].xyz * cb0[1349].yyy;
  r0.yzw = cb1[4].xyz * cb0[1349].xxx + r0.yzw;
  r0.yzw = cb1[6].xyz * cb0[1349].zzz + r0.yzw;
  r0.yzw = cb1[7].xyz * cb0[1349].www + r0.yzw;
  r1.xyz = cb1[1].xyz * r0.zzz;
  r1.xyz = cb1[0].xyz * r0.yyy + r1.xyz;
  r0.yzw = cb1[2].xyz * r0.www + r1.xyz;
  r1.xyz = -cb0[1301].xyz + v1.xyz;
  r1.w = dot(r1.xyz, r1.xyz);
  r1.w = rsqrt(r1.w);
  r1.xyz = r1.xyz * r1.www;
  r0.y = dot(r1.xyz, -r0.yzw);
  r0.x = r0.x / r0.y;
  r0.xyz = r1.xyz * r0.xxx + cb0[1301].xyz;
  r1.xyz = cb1[5].xyz * r0.yyy;
  r0.xyw = cb1[4].xyz * r0.xxx + r1.xyz;
  r0.xyz = cb1[6].xyz * r0.zzz + r0.xyw;
  r0.xyz = cb1[7].xyz + r0.xyz;
  r0.y = abs(r0.y) * -2 + 1;
  r0.xz = saturate(float2(0.5,0.5) + r0.xz);
  r1.xyzw = t1.Sample(s1_s, r0.xz).xyzw;
  r0.x = sqrt(r0.y);
  r0.xyz = r0.xxx * r1.xyz;
  o0.xyz = cb2[0].xyz * r0.xyz;
  o0.w = cb2[1].w;
  o0.xyz = max(0.f, o0.xyz);
  return;
}