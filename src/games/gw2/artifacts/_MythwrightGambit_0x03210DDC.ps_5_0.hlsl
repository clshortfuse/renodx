Texture2D<float4> t12 : register(t12);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s12_s : register(s12);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[10];
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

  r0.xy = cb0[2].xx + v4.xy;
  r0.xy = cb0[0].xy * r0.xy;
  r0.x = t12.Sample(s12_s, r0.xy).x;
  r0.x = r0.x * cb0[0].w + -cb0[0].z;
  r0.x = -w0.x + r0.x;
  r0.x = saturate(r0.x / cb0[9].x);
  r0.y = r0.x * -2 + 3;
  r0.x = r0.x * r0.x;
  r0.x = r0.y * r0.x;
  r0.yz = cb0[8].zw * cb0[1].xx;
  r0.yz = frac(r0.yz);
  r0.yz = v0.xy * cb0[8].xy + r0.yz;
  r0.yz = t0.Sample(s0_s, r0.yz).xw;
  r0.x = r0.z * r0.x;
  r0.z = dot(v2.xyz, v1.xyz);
  r0.z = abs(r0.z);
  r0.z = t2.Sample(s2_s, r0.zz).x;
  r0.x = r0.x * r0.z;
  r0.zw = cb0[5].zw * cb0[1].xx;
  r0.zw = frac(r0.zw);
  r0.zw = cb0[5].xy * v0.xy + r0.zw;
  r1.xyzw = t1.Sample(s1_s, r0.zw).xyzw;
  r0.zw = cb0[6].zw * cb0[1].xx;
  r0.zw = frac(r0.zw);
  r0.zw = v0.xy * cb0[6].xy + r0.zw;
  r2.xyzw = t1.Sample(s1_s, r0.zw).xyzw;
  r1.xyzw = r2.xyzw + r1.xyzw;
  r2.xyzw = cb0[4].xyzw * r1.xyzw;
  r1.xyzw = -cb0[4].xyzw * r1.xyzw + cb0[7].xyzw;
  r1.xyzw = r0.yyyy * r1.xyzw + r2.xyzw;
  r0.x = r1.w * r0.x;
  r0.yzw = r1.xyz * r0.xxx;
  o0.w = r0.x;
  r0.x = 1 + -v3.w;
  o0.xyz = r0.yzw * r0.xxx;
  o0.rgb = saturate(o0.rgb);
  return;
}