Texture3D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[1];
}
cbuffer cb0 : register(b0){
  float4 cb0[11];
}

void main(
  float2 v0 : TEXCOORD0,
  float4 v1 : SV_POSITION0,
  float4 v2 : TEXCOORD1,
  float3 v3 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = -cb0[9].x + v3.z;
  r0.y = cb0[9].y + -cb0[9].x;
  r0.x = r0.x / r0.y;
  r0.x = 1 + -r0.x;
  r0.x = max(9.99999997e-07, r0.x);
  r0.x = log2(r0.x);
  r0.x = cb0[8].y * r0.x;
  r0.x = exp2(r0.x);
  r0.z = 1 + -r0.x;
  r0.xy = v3.xy;
  r0.xyzw = t2.Sample(s0_s, r0.xyz).xyzw;
  r1.xy = cb1[0].yy * cb0[10].yy + v0.xy;
  r1.xy = float2(1.0 / 12.0,1.0 / 12.0) * r1.xy;
  r1.xyzw = t1.Sample(s2_s, r1.xy).xyzw;
  r2.xy = v2.xy / v2.ww;
  r2.xyzw = t0.Sample(s1_s, r2.xy).xyzw;
  r1.xyzw = -r2.xyzw + r1.xyzw;
  r1.xyzw = cb0[10].xxxx * r1.xyzw + r2.xyzw;
  o0.xyz = r1.xyz * r0.www + r0.xyz;
  o0.w = max(0, r1.w);
  return;
}