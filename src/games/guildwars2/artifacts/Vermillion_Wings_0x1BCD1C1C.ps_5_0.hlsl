Texture2D<float4> t12 : register(t12);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s12_s : register(s12);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[16];
}

#define cmp -

void main(
  float2 v0 : TEXCOORD0,
  float w0 : TEXCOORD1,
  float4 v1 : TEXCOORD2,
  float4 v2 : TEXCOORD3,
  float4 v3 : SV_POSITION0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  r0.xyzw = v1.xyzw * r0.xyzw;
  r1.xyz = r0.xyz + r0.xyz;
  r1.w = 1;
  r2.x = dot(r1.xyzw, cb0[3].xyzw);
  r2.y = dot(r1.xyzw, cb0[4].xyzw);
  r2.z = dot(r1.xyzw, cb0[5].xyzw);
  r0.xyz = -r0.xyz * float3(2,2,2) + r2.xyz;
  r2.xyzw = t1.Sample(s1_s, v0.xy).xyzw;
  r0.xyz = r2.xxx * r0.xyz + r1.xyz;
  r3.x = dot(r1.xyzw, cb0[6].xyzw);
  r3.y = dot(r1.xyzw, cb0[7].xyzw);
  r3.z = dot(r1.xyzw, cb0[8].xyzw);
  r1.xyz = r3.xyz + -r0.xyz;
  r1.xyz = r2.yyy * r1.xyz + r0.xyz;
  r1.w = 1;
  r0.x = dot(r1.xyzw, cb0[9].xyzw);
  r0.y = dot(r1.xyzw, cb0[10].xyzw);
  r0.z = dot(r1.xyzw, cb0[11].xyzw);
  r0.xyz = r0.xyz + -r1.xyz;
  r0.xyz = r2.zzz * r0.xyz + r1.xyz;
  r2.x = dot(r1.xyzw, cb0[12].xyzw);
  r2.y = dot(r1.xyzw, cb0[13].xyzw);
  r2.z = dot(r1.xyzw, cb0[14].xyzw);
  r1.xyz = r2.xyz + -r0.xyz;
  r0.xyz = r2.www * r1.xyz + r0.xyz;
  r1.xy = cb0[1].xx + v3.xy;
  r1.xy = cb0[0].xy * r1.xy;
  r1.x = t12.Sample(s12_s, r1.xy).x;
  r1.x = r1.x * cb0[0].w + -cb0[0].z;
  r1.x = -w0.x + r1.x;
  r1.x = saturate(r1.x / cb0[15].x);
  r1.y = r1.x * -2 + 3;
  r1.x = r1.x * r1.x;
  r1.x = r1.y * r1.x;
  r0.w = r1.x * r0.w;
  r0.xyz = r0.xyz * r0.www;
  o0.w = r0.w;
  r0.w = 1 + -v2.w;
  o0.xyz = r0.xyz * r0.www;
  o0 = max(0.f, o0);
  return;
}