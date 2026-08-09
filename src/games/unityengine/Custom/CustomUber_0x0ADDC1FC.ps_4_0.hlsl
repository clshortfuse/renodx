Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[8];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float4 v2 : COLOR0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cb0[7].z + cb0[5].x;
  r0.yz = cb0[6].xy + -v1.xy;
  r1.x = cb0[4].x / cb0[4].y;
  r1.y = 1;
  r0.yz = r1.xy * r0.yz;
  r0.y = dot(r0.yz, r0.yz);
  r0.y = sqrt(r0.y);
  r0.z = -cb0[7].z + cb0[5].x;
  r0.xz = cmp(r0.xy >= r0.yz);
  r0.x = r0.z ? r0.x : 0;
  r0.z = cmp(0.1 < r0.y);
  r0.y = -cb0[5].x + r0.y;
  r0.x = r0.z ? r0.x : 0;
  r0.z = cb0[7].y * r0.y;
  r0.z = log2(abs(r0.z));
  r0.z = cb0[7].x * r0.z;
  r0.z = exp2(r0.z);
  r0.z = 1 + -r0.z;
  r0.y = r0.y * r0.z;
  r0.zw = -cb0[6].xy + v1.xy;
  r1.x = dot(r0.zw, r0.zw);
  r1.x = rsqrt(r1.x);
  r0.zw = r1.xx * r0.zw;
  r0.yz = r0.zw * r0.yy + v1.xy;
  r0.xy = r0.xx ? r0.yz : v1.xy;
  o0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  o0.w = saturate(o0.w);
  return;
}