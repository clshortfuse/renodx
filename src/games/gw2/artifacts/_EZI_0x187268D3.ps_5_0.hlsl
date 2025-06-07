Texture2D<float4> t12 : register(t12);
Texture2D<float4> t0 : register(t0);
SamplerState s12_s : register(s12);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[11];
}

void main(
  float2 v0 : TEXCOORD0,
  float2 w0 : TEXCOORD2,
  float3 v1 : TEXCOORD1,
  float4 v2 : COLOR0,
  float4 v3 : SV_POSITION0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = dot(v1.xyz, v1.xyz);
  r0.x = rsqrt(r0.x);
  r0.y = -v1.z * r0.x + 1;
  r0.xzw = v1.xyz * r0.xxx;
  r1.x = 1 + -r0.y;
  r0.y = cb0[9].z * r1.x + r0.y;
  r1.x = dot(cb0[9].xyz, r0.xzw);
  r1.x = r1.x * 0.25 + 0.75;
  r1.x = r1.x * r1.x;
  r0.y = r1.x * r0.y;
  r1.xyz = -r0.xzw;
  r1.w = 1;
  r2.x = dot(r1.xyzw, cb0[2].xyzw);
  r2.y = dot(r1.xyzw, cb0[3].xyzw);
  r2.z = dot(r1.xyzw, cb0[4].xyzw);
  r1.xyz = cb0[10].xyz + -r2.xyz;
  r1.xyz = r0.yyy * r1.xyz + r2.xyz;
  r0.w = t0.Sample(s0_s, v0.xy).w;
  r0.w = -0.5 + r0.w;
  r0.w = cb0[8].x * r0.w;
  r0.xz = r0.ww * r0.xz + v0.xy;
  r2.xyzw = t0.Sample(s0_s, r0.xz).xyzw;
  r0.xzw = r2.xyz + r1.xyz;
  r1.xyz = r2.xyz * r1.xyz;
  r0.xzw = r1.xyz * float3(-2,-2,-2) + r0.xzw;
  r1.w = dot(r2.xyz, float3(0.300000012,0.589999974,0.109999999));
  r1.w = r1.w * r1.w;
  r0.xzw = r1.www * r0.xzw + r1.xyz;
  r1.xyz = r0.xzw + -r2.xyz;
  r1.xyz = r1.xyz * float3(0.5,0.5,0.5) + r2.xyz;
  r0.xzw = -r1.xyz + r0.xzw;
  r0.xyz = r0.yyy * r0.xzw + r1.xyz;
  r0.xyz = r0.xyz + -r2.xyz;
  r0.xyz = cb0[10].www * r0.xyz + r2.xyz;
  r1.xyz = cb0[0].xyz + -r0.xyz;
  r0.xyz = v2.yyy * r1.xyz + r0.xyz;
  o0.xyz = cb0[7].www * r0.xyz;
  r0.x = cb0[8].y * v2.x;
  r0.x = r2.w * r0.x;
  r0.yz = cb0[5].xx + v3.xy;
  r0.yz = cb0[1].xy * r0.yz;
  r0.y = t12.Sample(s12_s, r0.yz).x;
  r0.y = r0.y * cb0[1].w + -cb0[1].z;
  r0.y = -w0.x + r0.y;
  r0.y = saturate(r0.y / cb0[8].w);
  r0.z = r0.y * -2 + 3;
  r0.y = r0.y * r0.y;
  r0.y = r0.z * r0.y;
  r0.x = r0.x * r0.y;
  o0.w = w0.y * r0.x;
  o0 = max(0, o0);
  return;
}