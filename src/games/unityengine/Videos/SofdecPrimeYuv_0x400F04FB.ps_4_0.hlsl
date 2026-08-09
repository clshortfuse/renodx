Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).wxyz;
  r1.xyzw = t1.Sample(s1_s, w1.xy).xyzw;
  r0.y = r1.w;
  r1.xyzw = t2.Sample(s2_s, w1.xy).xyzw;
  r0.z = r1.w;
  r0.xyz = float3(-0.0627499968,-0.50195998,-0.50195998) + r0.xyz;
  o0.x = dot(float2(1.16437995,1.59603), r0.xz);
  o0.y = dot(float3(1.16437995,-0.391759992,-0.812969983), r0.xyz);
  o0.z = dot(float2(1.16437995,2.01723003), r0.xy);
  o0.xyz = max(0.f, o0.xyz);
  o0.w = 1;
  return;
}