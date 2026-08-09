Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[4];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float4 v2 : TEXCOORD0,
  float4 v3 : TEXCOORD1,
  float4 v4 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t1.Sample(s0_s, v4.xy).xyzw;
  r0.x = r0.x + r0.z;
  r0.x = r0.x + r0.y;
  r0.x = cmp(0.00999999978 < r0.x);
  if (r0.x != 0) discard;
  r0.xyzw = t0.Sample(s1_s, v2.xy).xyzw;
  r0.xyzw = v1.xyzw * r0.xyzw;
  r1.xy = -cb0[3].xy + v3.xy;
  r1.z = 1.77777779 * r1.x;
  r1.xy = r1.zy / cb0[3].zz;
  r1.x = dot(r1.xy, r1.xy);
  r1.x = sqrt(r1.x);
  r1.x = 0.5 + -r1.x;
  r1.x = -r1.x * r1.x + 1;
  r1.y = r1.x * r1.x;
  r1.y = r1.y * r1.y;
  r1.x = r1.y * r1.x;
  r0.xyz = r1.xxx * r0.xyz;
  o0.xyz = r0.xyz * r0.www;
  o0.w = r0.w;
  o0 = max(o0, 0);
  return;
}