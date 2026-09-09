Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[3];
}
cbuffer cb0 : register(b0){
  float4 cb0[81];
}

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : INTERP0,
  float4 v2 : INTERP1,
  float4 v3 : INTERP2,
  float4 v4 : INTERP3,
  float3 v5 : INTERP4,
  float3 v6 : INTERP5,
  out float4 o0 : SV_Target0,
  out float4 o1 : SV_Target1)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.y = cb0[61].y + -v0.y;
  r0.y = cb0[58].x < 0 ? r0.y : v0.y;
  r0.x = v0.x;
  r0.xy = r0.xy / cb0[61].xy;
  r0.z = 1 + -r0.y;
  r0.xy = r0.xz * float2(2,2) + float2(-1,-1);
  r0.z = 9.99999975e-005 * cb0[80].x;
  r0.z = frac(r0.z);
  r0.z = 1000 * r0.z;
  r0.zw = r0.zz * cb1[2].xy + cb1[1].zw;
  r1.x = cb0[61].x / cb0[61].y;
  r1.y = 1;
  r0.xy = r0.xy * r1.xy + r0.zw;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r0.yzw = v4.xyz * r0.xyz;
  r0.x = r0.x * -0.75 + 0.75;
  r1.xy = v1.xy * float2(0.899999976,0.899999976) + float2(0.0500000007,0.0500000007);
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.x = v4.w * r1.w;
  r1.y = -r1.w * v4.w + 1;
  r0.x = -r1.y * r0.x + r1.x;
  r0.x = 4 * r0.x;
  o0.xyz = r0.yzw * r0.xxx;
  o0.w = r0.x;
  o0 = max(0.f, o0);
  return;
}