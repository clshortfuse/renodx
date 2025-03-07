Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
cbuffer cb1 : register(b1){
  float4 cb1[1];
}
cbuffer cb0 : register(b0){
  float4 cb0[17];
}

#define cmp -

void main(
  float4 v0 : SV_Position0,
  float4 v1 : COLOR0,
  float2 v2 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = ddx_coarse(v2.xy);
  r0.zw = ddy_coarse(v2.xy);
  r0.xy = r0.xy + r0.zw;
  r1.xy = -r0.xy * float2(0.354000002,0.354000002) + v2.xy;
  r1.zw = r0.xy * float2(0.354000002,0.354000002) + v2.xy;
  r0.x = t0.SampleLevel(s2_s, r1.xy, 0).x;
  r0.y = t0.SampleLevel(s2_s, r1.zw, 0).x;
  r0.x = r0.x + r0.y;
  r0.y = t0.SampleLevel(s2_s, r1.xw, 0).x;
  r0.z = t0.SampleLevel(s2_s, r1.zy, 0).x;
  r0.x = r0.x + r0.y;
  r0.x = r0.x + r0.z;
  r0.y = t0.SampleLevel(s2_s, v2.xy, 0).x;
  r0.x = r0.x * 0.5 + r0.y;
  r0.y = 0.333333343 * r0.x;
  r1.x = ddx_coarse(r0.y);
  r1.y = ddy_coarse(r0.y);
  r0.y = dot(r1.xy, r1.xy);
  r0.y = sqrt(r0.y);
  r0.z = r0.y * 0.699999988 + cb1[0].z;
  r0.y = -r0.y * 0.699999988 + cb1[0].z;
  r0.z = r0.z + -r0.y;
  r0.x = r0.x * 0.333333343 + -r0.y;
  r0.y = 1 / r0.z;
  r0.x = saturate(r0.x * r0.y);
  r0.y = r0.x * -2 + 3;
  r0.x = r0.x * r0.x;
  r0.z = r0.y * r0.x + -0.00999999978;
  r0.x = r0.y * r0.x;
  o0.w = v1.w * r0.x;
  r0.x = cmp(r0.z < 0);
  if (r0.x != 0) discard;
  o0.xyz = v1.xyz;
  return;
}