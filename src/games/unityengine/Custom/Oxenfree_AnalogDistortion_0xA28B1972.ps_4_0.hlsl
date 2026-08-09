Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[1];
}
cbuffer cb0 : register(b0){
  float4 cb0[6];
}

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  float4 v4 : TEXCOORD3,
  float4 v5 : TEXCOORD7,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = frac(cb1[0].yzw);
  r0.yw = sin(r0.xy);
  r0.yw = float2(2,2) + r0.yw;
  r0.xy = r0.yw + -r0.xz;
  r0.xy = v1.yy + r0.xy;
  r0.xyzw = t1.Sample(s1_s, r0.xy).xyzw;
  r0.x = dot(r0.xyz, float3(0.219999999,0.707000017,0.0710000023));
  r0.x = -cb0[4].x + r0.x;
  r0.y = 1 + -cb0[4].x;
  r0.x = saturate(r0.x / r0.y);
  r0.x = 6.28299999 * r0.x;
  r0.x = sin(r0.x);
  r0.y = r0.x * r0.x;
  r0.x = r0.y * r0.x;
  r0.x = cb0[4].y * r0.x;
  r0.y = 0;
  r0.yz = v1.zw + r0.xy;
  r0.x = abs(r0.x) * cb0[4].w + 1;
  r1.xyzw = t0.Sample(s0_s, r0.yz).xyzw;
  r0.y = dot(r1.xyz, float3(0.219999999,0.707000017,0.0710000023));
  r0.y = r1.w * r0.y;
  r1.xyz = r1.www * r1.xyz;
  r1.xyz = float3(3,3,3) * r1.xyz;
  r1.xyz = cb0[4].zzz * r1.xyz;
  r1.xyz = cb0[5].xyz * r1.xyz;
  o0.xyz = r1.xyz * r0.xxx;
  r0.y = 3 * r0.y;
  r0.y = cb0[4].z * r0.y;
  r0.z = dot(cb0[5].xyz, float3(0.219999999,0.707000017,0.0710000023));
  r0.y = r0.y * r0.z;
  o0.w = r0.y * r0.x;
  o0 = saturate(o0);
  return;
}