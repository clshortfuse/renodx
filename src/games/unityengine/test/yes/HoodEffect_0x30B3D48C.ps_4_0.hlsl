Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[32];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy * float2(1,-1) + float2(0,1);
  r1.xyzw = t1.Sample(s1_s, r0.xy).xyzw;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r2.xyz = -cb0[29].xxx + r0.xyz;
  r2.xyz = saturate(float3(5,5,5) * r2.xyz);
  r1.xyz = r2.xyz * r1.xyz;
  r1.xyz = r1.xyz * cb0[28].xyz + float3(1,1,1);
  r2.xyz = r0.xyz * r1.xyz + -cb0[31].xxx;
  r0.xyz = r1.xyz * r0.xyz;
  r1.xyz = saturate(float3(10,10,10) * r2.xyz);
  r1.xyz = cb0[29].yyy * r1.xyz;
  r0.w = r0.x * 0.5 + 0.75;
  r2.xyz = cb0[30].xyz * r0.www + -r0.xyz;
  r0.xyz = r1.xyz * r2.xyz + r0.xyz;
  r0.w = r0.x + r0.y;
  r0.w = r0.w + r0.z;
  r0.w = r0.w * 0.333333343 + 0.2;
  r0.w = r0.w * r0.w;
  r0.w = min(1, r0.w);
  r1.xy = float2(0.5,0.75) * r0.ww;
  r2.xy = float2(0.4,-0.5) + r0.ww;
  r0.w = r2.x * r2.x;
  r1.w = saturate(5 * r2.y);
  r1.z = r0.w * r0.w;
  r2.xyz = r0.xxx * float3(0.9,0.9,0.9) + -r1.xyz;
  r1.xyz = r1.www * r2.xyz + r1.xyz;
  r1.xyz = r1.xyz + -r0.xyz;
  r0.w = 0.5 * cb0[31].z;
  r0.xyz = r0.www * r1.xyz + r0.xyz;
  r1.xyz = sign(r0.xyz) * pow(r0.xyz, cb0[31].y);
  r0.w = 2 + -cb0[31].y;
  r0.xyz = r0.xyz * r0.www;
  o0.xyz = cb0[31].y > 1 ? r1.xyz : r0.xyz;
  o0.w = 1;
  return;
}