Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[3];
}

// Dark Light Survivor

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t1.Sample(s2_s, v1.xy).xyzw;
  r0.x = r0.x * r0.w;
  r0.xy = r0.xy * float2(2,2) + float2(-1,-1);
  r0.z = -1 + cb0[2].y;
  r0.z = 0.5 * r0.z;
  r0.w = cb0[2].x * 2 + -1;
  r1.xyzw = t0.Sample(s1_s, v1.xy).xyzw;
  r0.w = r1.w + r0.w;
  r1.w = saturate(r0.w * cb0[2].y + -r0.z);
  r0.xy = r1.ww * r0.xy;
  r0.xy = r0.xy * cb0[2].zz + v1.xy;
  r0.xyzw = t2.Sample(s0_s, r0.xy).xyzw;
  r0.w = sqrt(r0.w);
  r0.xyz = sign(r0.xyz) * sqrt(abs(r0.xyz));
  r2.xyz = float3(0.5,0.5,0.5) + r1.xyz;
  r2.xyz = r2.xyz * r0.xyz;
  r2.xyz = r2.xyz * float3(1.2,1.2,1.2) + -r1.xyz;
  r2.xyz = float3(0.3,0.3,0.3) * r2.xyz;
  r2.w = 0;
  r1.xyzw = r2.xyzw + r1.xyzw;
  r2.x = -r1.w * 0.5 + 1;
  r0.xyz = r2.xxx * r0.xyz;
  r2.xyzw = r1.xyzw + -r0.xyzw;
  r0.xyzw = r1.wwww * r2.xyzw + r0.xyzw;
  o0.w = r0.w * r0.w;
  o0.w = saturate(o0.w);
  o0.xyz = sign(r0.xyz) * r0.xyz * r0.xyz;
  return;
}