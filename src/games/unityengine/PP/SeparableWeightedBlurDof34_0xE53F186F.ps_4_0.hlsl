Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  float4 v4 : TEXCOORD3,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v2.zw).xwyz;
  r1.xyz = r0.xzw * r0.yyy;
  r2.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  r2.xyz = r2.xyz * r2.www;
  r0.x = r2.w;
  r2.xyz = float3(0.75,0.75,0.75) * r2.xyz;
  r3.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r2.xyz = r3.xyz * r3.www + r2.xyz;
  r1.xyz = r1.xyz * float3(0.75,0.75,0.75) + r2.xyz;
  r2.xyzw = t0.Sample(s0_s, v3.xy).xyzw;
  r2.xyz = r2.xyz * r2.www;
  r0.z = r2.w;
  r1.xyz = r2.xyz * float3(0.5,0.5,0.5) + r1.xyz;
  r2.xyzw = t0.Sample(s0_s, v3.zw).xyzw;
  r2.xyz = r2.xyz * r2.www;
  r0.w = r2.w;
  r0.x = dot(float4(0.75,0.75,0.5,0.5), r0.xyzw);
  r0.x = r3.w + r0.x;
  o0.w = r3.w;
  r0.yzw = r2.xyz * float3(0.5,0.5,0.5) + r1.xyz;
  o0.xyz = r0.yzw / r0.xxx;
  o0 = max(0.f, o0);
  return;
}