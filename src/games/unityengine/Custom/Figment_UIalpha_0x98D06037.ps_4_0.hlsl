Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[5];
}

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float4 v2 : TEXCOORD0,
  float4 v3 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = step(cb0[4].xy, v3.xy);
  r0.zw = step(v3.xy, cb0[4].zw);
  r0.xy = r0.xy * r0.zw;
  r0.x = r0.x * r0.y;
  r1.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  r0.y = cb0[3].w + r1.w;
  r0.y = v1.w * r0.y;
  r0.x = r0.y * r0.x;
  r0.yzw = float3(-1,-1,-1) + v1.xyz;
  r0.xyz = r0.xxx * r0.yzw + float3(1,1,1);
  r0.w = 1 + -v1.w;
  o0.xyz = r0.xyz + r0.www;
  o0.xyz = saturate(o0.xyz);
  o0.w = 0;
  return;
}