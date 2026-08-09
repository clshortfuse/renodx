Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[8];
}

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float4 v2 : TEXCOORD0,
  float4 v3 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cb0[6].y;
  r0.y = 0;
  r1.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  r1.xyz = cb0[3].xyz + r1.xyz;
    r1.xyz = saturate(r1.xyz);
  r2.xyz = log2(r1.zxy);
  r2.xyz = float3(0.424199998,0.424199998,0.424199998) * r2.xyz;
  r2.xyz = exp2(r2.xyz);
  r0.z = -1 + cb0[6].w;
  r2.yzw = r2.xyz * r0.zzz;
  r0.w = floor(r2.y);
  r3.xy = float2(0.5,0.5) * cb0[6].xy;
  r3.yz = r2.zw * cb0[6].xy + r3.xy;
  r3.x = r0.w * cb0[6].y + r3.y;
  r0.z = r2.x * r0.z + -r0.w;
  r0.xy = r3.xz + r0.xy;
  r2.xyzw = t2.Sample(s1_s, r3.xz).xyzw;
  r3.xyzw = t2.Sample(s1_s, r0.xy).xyzw;
  r0.xyw = r3.xyz + -r2.xyz;
  r0.xyz = r0.zzz * r0.xyw + r2.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(2.20000005,2.20000005,2.20000005) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = r0.xyz + -r1.xyz;
  r0.xyz = cb0[7].xxx * r0.xyz + r1.xyz;
  r1.xyzw = t1.Sample(s2_s, v2.xy).xyzw;
  r1.xyz = float3(-1,-1,-1) + r1.xyz;
  r1.xyz = cb0[7].yyy * r1.xyz + float3(1,1,1);
  r0.xyz = r1.xyz * r0.xyz;
  o0.xyz = v1.xyz * r0.xyz;
  o0.w = v1.w;
  return;
}