Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[4];
}

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float4 v2 : TEXCOORD0,
  float3 v3 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = -cb0[3].xy + v3.xy;
  r0.z = 1.77777779 * r0.x;
  r0.xy = r0.zy / cb0[3].zz;
  r0.x = dot(r0.xy, r0.xy);
  r0.x = sqrt(r0.x);
  r0.x = 0.5 + -r0.x;
  r0.x = -r0.x * r0.x + 1;
  r0.y = r0.x * r0.x;
  r0.y = r0.y * r0.y;
  r0.x = r0.y * r0.x;
  r1.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  r1.xyzw = v1.xyzw * r1.xyzw;
  r0.xyz = r1.xyz * r0.xxx;
  o0.xyz = r0.xyz * r1.www;
  o0.w = r1.w;
  o0 = max(0, o0);
  return;
}