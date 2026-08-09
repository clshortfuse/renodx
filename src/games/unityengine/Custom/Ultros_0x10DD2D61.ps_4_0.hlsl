Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[9];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float4 v2 : TEXCOORD0,
  float3 v3 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb0[4].wz * v2.yx;
  r0.xy = floor(r0.xy);
  r0.xy = r0.xy / cb0[4].wz;
  r0.zw = float2(1,1) + -r0.xy;
  r0.xy = float2(-0.5,-0.5) + r0.xy;
  r0.zw = cb0[5].zy * r0.zw;
  r0.z = r0.z + r0.w;
  r0.x = abs(r0.x) * cb0[6].y + r0.z;
  r0.x = abs(r0.y) * cb0[6].x + r0.x;
  r1.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  r0.x = r1.x * cb0[6].z + r0.x;
  r0.x = r1.y * cb0[6].w + r0.x;
  r0.x = r1.z * cb0[7].x + r0.x;
  r0.y = 0.100000001 + cb0[4].y;
  r0.y = cmp(r0.x < r0.y);
  r0.x = cmp(r0.x < cb0[4].y);
  r2.xy = -cb0[3].xy + v3.xy;
  r2.z = 1.77777779 * r2.x;
  r0.zw = r2.zy / cb0[3].zz;
  r0.z = dot(r0.zw, r0.zw);
  r0.z = sqrt(r0.z);
  r0.z = 0.5 + -r0.z;
  r0.z = -r0.z * r0.z + 1;
  r0.w = r0.z * r0.z;
  r0.w = r0.w * r0.w;
  r0.z = r0.w * r0.z;
  r2.xyz = v1.xyz * r1.xyz;
  r2.xyz = r2.xyz * r0.zzz;
  r2.xyz = r0.yyy ? cb0[8].xyz : r2.xyz;
  r3.w = 0;
  r3.xyz = r1.xyz;
  r2.w = r1.w;
  r0.xyzw = r0.xxxx ? r3.xyzw : r2.xyzw;
  o0.xyz = r0.xyz * r0.www;
  o0.w = r0.w;
  o0 = max(0, o0);
  return;
}