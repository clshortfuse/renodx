Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[6];
}
cbuffer cb0 : register(b0){
  float4 cb0[3];
}

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : COLOR0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = v3.xyz * float3(0.305306017,0.305306017,0.305306017) + float3(0.682171106,0.682171106,0.682171106);
  r0.xyz = v3.xyz * r0.xyz + float3(0.0125228781,0.0125228781,0.0125228781);
  r0.xyz = v3.xyz * r0.xyz;
  r1.xy = v2.xy * cb0[2].xy + cb0[2].zw;
  r1.xyzw = t1.Sample(s1_s, r1.xy).xyzw;
  r0.xyz = r1.xyz * r0.xyz;
  r0.w = 0;
  r0.xyzw = max(float4(9.99999975e-06,9.99999975e-06,9.99999975e-06,9.99999975e-06), r0.xyzw);
  r1.x = 0.5 * v1.w;
  r1.y = -v1.w * 0.5 + v1.y;
  r1.y = -r1.y * cb1[5].x + r1.x;
  r1.x = v1.x;
  r1.xy = r1.xy / v1.ww;
  r2.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r0.xyzw = r2.xyzw / r0.xyzw;
  r0.xyzw = r0.xyzw * r1.wwww;
  r0.xyzw = r0.xyzw * v3.wwww + -r2.xyzw;
  o0.xyzw = r1.wwww * r0.xyzw + r2.xyzw;
  o0.w = saturate(o0.w);
  return;
}