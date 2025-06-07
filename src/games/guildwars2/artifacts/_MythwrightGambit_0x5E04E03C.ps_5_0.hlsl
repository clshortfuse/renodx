Texture2D<float4> t12 : register(t12);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s12_s : register(s12);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[12];
}

void main(
  float2 v0 : TEXCOORD0,
  float w0 : TEXCOORD3,
  float4 v1 : TEXCOORD1,
  float4 v2 : TEXCOORD2,
  float4 v3 : TEXCOORD4,
  float4 v4 : SV_POSITION0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb0[7].zw * cb0[1].xx;
  r0.xy = frac(r0.xy);
  r0.xy = cb0[7].xy * v0.xy + r0.xy;
  r0.x = t0.Sample(s0_s, r0.xy).w;
  r0.yz = cb0[8].zw * cb0[1].xx;
  r0.yz = frac(r0.yz);
  r0.yz = v0.xy * cb0[8].xy + r0.yz;
  r0.y = t0.Sample(s0_s, r0.yz).w;
  r0.x = r0.x + r0.y;
  r0.xyzw = cb0[6].xyzw * r0.xxxx;
  r1.xy = cb0[4].xx + v4.xy;
  r1.xy = cb0[0].xy * r1.xy;
  r1.x = t12.Sample(s12_s, r1.xy).x;
  r1.x = r1.x * cb0[0].w + -cb0[0].z;
  r1.x = -w0.x + r1.x;
  r1.x = saturate(r1.x / cb0[9].x);
  r1.y = r1.x * -2 + 3;
  r1.x = r1.x * r1.x;
  r1.z = r1.y * r1.x + -1;
  r1.x = r1.y * r1.x;
  r1.y = saturate(-1.42857146 * r1.z);
  r1.z = r1.y * -2 + 3;
  r1.y = r1.y * r1.y;
  r1.y = r1.z * r1.y;
  r1.z = 3.33333325 * r1.x;
  r1.z = min(1, r1.z);
  r1.w = r1.z * -2 + 3;
  r1.z = r1.z * r1.z;
  r1.z = r1.w * r1.z;
  r1.y = r1.y * r1.z;
  r1.z = dot(v2.xyz, v1.xyz);
  r1.z = abs(r1.z);
  r1.z = t1.Sample(s1_s, r1.zz).x;
  r2.xyzw = cb0[11].xyzw + -cb0[10].xyzw;
  r2.xyzw = r1.zzzz * r2.xyzw + cb0[10].xyzw;
  r2.xyzw = r1.yyyy * cb0[10].xyzw + r2.xyzw;
  r2.w = r2.w * r1.x;
  r0.xyzw = r0.xyzw * r1.xxxx + r2.xyzw;
  r1.x = r0.w * cb0[2].w + -cb0[3].x;
  r0.xyzw = cb0[2].xyzw * r0.xyzw;
  if (r1.x < 0) discard;
  r1.x = 1 + -v3.w;
  o0.xyz = r0.xyz * r1.xxx + v3.xyz;
  o0.w = r0.w;
  o0.a = saturate(o0.a);
  return;
}