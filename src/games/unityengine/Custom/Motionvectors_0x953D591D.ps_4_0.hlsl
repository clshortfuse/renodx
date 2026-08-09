Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[8];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, w1.xy).xyzw;
  r0.yz = v1.xy * float2(2,2) + float2(-1,-1);
  r1.xyz = cb0[4].xyw * r0.zzz;
  r1.xyz = cb0[3].xyw * r0.yyy + r1.xyz;
  r1.xyz = cb0[5].xyw * r0.xxx + r1.xyz;
  r1.xyz = cb0[6].xyw + r1.xyz;
  r0.xw = r1.xy / r1.zz;
  r0.xy = r0.yz + -r0.xw;
  r0.xy = cb0[7].xx * r0.xy;
  r0.z = dot(r0.xy, r0.xy);
  r0.z = sqrt(r0.z);
  r0.w = r0.z < cb0[7].y ? 0 : r0.z;
  r0.xy = r0.xy / r0.zz;
  o0.xy = r0.xy * float2(0.5,0.5) + float2(0.5,0.5);
  r0.x = min(cb0[7].z, r0.w);
  r0.x = -cb0[7].y + r0.x;
  r0.x = max(0, r0.x);
  o0.z = cb0[7].w * r0.x;
  o0.xy = max(0.f, o0.xy);
  o0.w = 0;
  return;
}