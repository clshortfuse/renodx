Texture2D<float4> t12 : register(t12);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s12_s : register(s12);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[16];
}

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
  r1.xyzw = v1.xyzw * r0.xyzw;
  r0.x = dot(r0.xyz, float3(0.300000012,0.589999974,0.109999999));
  r0.x = saturate(4 * r0.x);
  r2.xyz = r1.xyz + r1.xyz;
  r2.w = 1;
  r3.x = dot(r2.xyzw, cb0[3].xyzw);
  r3.y = dot(r2.xyzw, cb0[4].xyzw);
  r3.z = dot(r2.xyzw, cb0[5].xyzw);
  r0.yzw = -r1.xyz * float3(2,2,2) + r3.xyz;
  r3.xyzw = t1.Sample(s1_s, v0.xy).xyzw;
  r0.yzw = r3.xxx * r0.yzw + r2.xyz;
  r1.x = dot(r2.xyzw, cb0[6].xyzw);
  r1.y = dot(r2.xyzw, cb0[7].xyzw);
  r1.z = dot(r2.xyzw, cb0[8].xyzw);
  r1.xyz = r1.xyz + -r0.yzw;
  r2.xyz = r3.yyy * r1.xyz + r0.yzw;
  r2.w = 1;
  r1.x = dot(r2.xyzw, cb0[9].xyzw);
  r1.y = dot(r2.xyzw, cb0[10].xyzw);
  r1.z = dot(r2.xyzw, cb0[11].xyzw);
  r0.yzw = r1.xyz + -r2.xyz;
  r0.yzw = r3.zzz * r0.yzw + r2.xyz;
  r1.x = dot(r2.xyzw, cb0[12].xyzw);
  r1.y = dot(r2.xyzw, cb0[13].xyzw);
  r1.z = dot(r2.xyzw, cb0[14].xyzw);
  r1.xyz = r1.xyz + -r0.yzw;
  r0.yzw = r3.www * r1.xyz + r0.yzw;
  r0.xyz = r0.yzw * r0.xxx;
  r1.xy = cb0[1].xx + v3.xy;
  r1.xy = cb0[0].xy * r1.xy;
  r0.w = t12.Sample(s12_s, r1.xy).x;
  r0.w = r0.w * cb0[0].w + -cb0[0].z;
  r0.w = -w0.x + r0.w;
  r0.w = saturate(r0.w / cb0[15].x);
  r1.x = r0.w * -2 + 3;
  r0.w = r0.w * r0.w;
  r0.w = r1.x * r0.w;
  r0.w = r1.w * r0.w;
  r0.xyz = r0.xyz * r0.www;
  o0.w = r0.w;
  r0.w = 1 + -v2.w;
  o0.xyz = r0.xyz * r0.www;
  o0 = saturate(o0);
  return;
}