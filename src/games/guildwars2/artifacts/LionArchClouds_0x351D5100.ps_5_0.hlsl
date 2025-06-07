Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[13];
}

void main(
  float4 v0 : TEXCOORD0,
  float3 v1 : TEXCOORD1,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb0[9].yw + -cb0[9].xz;
  r0.xy = v0.xy * r0.xy + cb0[9].xz;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r1.xy = cb0[8].yw + -cb0[8].xz;
  r1.xy = v0.xy * r1.xy + cb0[8].xz;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r0.xyzw = -r1.xyzw + r0.xyzw;
  r0.xyzw = cb0[10].xxxx * r0.xyzw + r1.xyzw;
  r1.x = r0.w * cb0[12].x + -cb0[5].x;
  if (r1.x < 0) discard;
  r1.x = dot(v1.xyz, v1.xyz);
  r1.x = rsqrt(r1.x);
  r1.x = v1.z * r1.x;
  r1.x = saturate(-r1.x);
  r1.x = -cb0[11].x + r1.x;
  r1.y = 1 / cb0[11].y;
  r1.x = saturate(r1.x * r1.y);
  r1.y = r1.x * -2 + 3;
  r1.x = r1.x * r1.x;
  r1.x = -r1.y * r1.x + 1;
  r1.x = saturate(r1.x * cb0[11].z + cb0[11].w);
  r1.yzw = cb0[0].xyz + -r0.xyz;
  r0.xyz = r1.xxx * r1.yzw + r0.xyz;
  r0.w = cb0[12].x * r0.w;
  o0.w = r0.w;
  o0.xyz = r0.xyz * cb0[12].yyy + cb0[1].xyz;
  o0 = saturate(o0);
  return;
}