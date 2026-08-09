Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[7];
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
  r0.yz = v2.xy * cb0[5].xy + cb0[5].zw;
  r1.xyzw = t0.Sample(s0_s, r0.yz).xyzw;
  r1.xyzw = cb0[6].xxxx * r1.xyzw;
  r1.xyzw = v1.xyzw * r1.xyzw;
  r0.y = r1.w * r0.x + -0.001;
  r0.x = r1.w * r0.x;
  o0.xyz = r1.xyz;
  o0.w = r0.x;
  o0.w = saturate(o0.w);
  if (r0.y < 0) discard;
  return;
}