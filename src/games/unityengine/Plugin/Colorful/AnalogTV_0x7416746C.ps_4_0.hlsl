Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[8];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(-0.5,-0.5) + v1.xy;
  r0.z = dot(r0.xy, r0.xy);
  r0.w = sqrt(r0.z);
  r0.w = cb0[7].z * r0.w + cb0[7].y;
  r0.z = r0.z * r0.w + 1;
  r0.z = cb0[7].w * r0.z;
  r0.xy = r0.zz * r0.xy + float2(0.5,0.5);
  r0.zw = cb0[7].xx * r0.xy;
  r0.z = dot(r0.zw, float2(12.9898005,78.2330017));
  r0.z = sin(r0.z);
  r0.z = 43758.5469 * r0.z;
  r0.z = frac(r0.z);
  r0.w = 100 * r0.z;
  r0.w = floor(r0.w);
  r0.z = -r0.w * 0.01 + r0.z;
  r0.z = saturate(r0.z * 100 + 0.1);
  r1.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r0.x = r0.y * cb0[6].z + cb0[6].w;
  sincos(r0.x, r0.x, r2.x);
  r0.yzw = r1.xyz * r0.zzz + r1.xyz;
  r3.xz = r0.xx;
  r3.y = r2.x;
  r2.xyz = r3.xyz * r1.xyz;
  r0.xyz = r2.xyz * cb0[6].yyy + r0.yzw;
  r0.xyz = r0.xyz + -r1.xyz;
  r0.w = saturate(cb0[6].x);
  o0.xyz = r0.www * r0.xyz + r1.xyz;
  o0.w = r1.w;
  o0 = max(0.f, o0);
  return;
}