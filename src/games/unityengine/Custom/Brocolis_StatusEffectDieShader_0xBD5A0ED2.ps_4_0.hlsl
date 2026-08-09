Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[11];
}
cbuffer cb0 : register(b0){
  float4 cb0[20];
}

void main(
  float2 v0 : TEXCOORD0,
  float2 w0 : TEXCOORD1,
  float4 v1 : TEXCOORD2,
  float4 v2 : TEXCOORD3,
  float4 v3 : TEXCOORD6,
  float4 v4 : SV_POSITION0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cb0[11].y / cb1[8].x;
  r0.xy = v0.xy + r0.xx;
  r0.xy = r0.xy + r0.xy;
  r0.xyzw = t0.SampleBias(s0_s, r0.xy, cb0[19].x).xyzw;
  r0.w = dot(v2.xyz, v2.xyz);
  r0.w = rsqrt(r0.w);
  r1.xyz = v2.xyz * r0.www;
  r2.xyz = cb0[16].xyz + -v1.xyz;
  r0.w = dot(r2.xyz, r2.xyz);
  r0.w = max(1.17549435e-38, r0.w);
  r0.w = rsqrt(r0.w);
  r2.xyz = r2.xyz * r0.www;
  r0.w = dot(r1.xyz, r2.xyz);
  r1.xy = r2.xy / cb1[2].xx;
  r1.xyzw = t1.SampleBias(s1_s, r1.xy, cb0[19].x).xyzw;
  r0.w = 1 + -r0.w;
  r0.w = log2(r0.w);
  r1.w = cb1[8].y * r0.w;
  r1.w = exp2(r1.w);
  r2.xyz = cb1[7].xyz * r1.www;
  r0.xyz = r2.xyz * r0.xyz;
  r1.w = cb0[11].y / cb1[10].x;
  r2.xy = v0.xy + r1.ww;
  r2.xyzw = t0.SampleBias(s0_s, r2.xy, cb0[19].x).xyzw;
  r1.w = cb1[10].y * r0.w;
  r0.w = cb1[6].y * r0.w;
  r0.w = exp2(r0.w);
  r0.w = r0.w * r0.w;
  r0.w = 100 * r0.w;
  r1.w = exp2(r1.w);
  r1.w = r1.w * r1.w;
  r3.xyz = cb1[9].xyz * r1.www;
  r0.xyz = r2.xyz * r3.xyz + r0.xyz;
  r1.w = cb1[9].w * cb1[7].w;
  r1.w = 4 * r1.w;
  r0.xyz = r1.www * r0.xyz;
  r1.w = cb0[11].y / cb1[6].x;
  r2.xy = v0.xy + r1.ww;
  r2.xy = r2.xy + r2.xy;
  r2.xyzw = t0.SampleBias(s0_s, r2.xy, cb0[19].x).xyzw;
  r3.xyz = cb1[5].xyz * cb1[5].xyz;
  r3.xyz = r3.xyz * r0.www;
  r0.xyz = r2.xyz * r3.xyz + r0.xyz;
  o0.xyz = r1.xyz * cb1[3].xyz + r0.xyz;
  o0.w = 1;
  o0.xyz = saturate(o0.xyz);
  return;
}