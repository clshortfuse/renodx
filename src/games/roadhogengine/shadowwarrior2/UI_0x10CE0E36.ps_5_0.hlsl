Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
cbuffer cb1 : register(b1){
  float4 cb1[8];
}
cbuffer cb0 : register(b0){
  float4 cb0[17];
}

#define cmp -

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = 0.142857149 * cb1[3].w;
  r0.yz = float2(-0.5,-0.5) + v1.xy;
  r0.xw = r0.yz * r0.xx;
  r1.x = dot(r0.wx, cb1[5].zw);
  r1.zw = float2(-1,1) * cb1[5].zw;
  r1.y = dot(r0.xw, r1.zw);
  r0.xw = cb1[7].zw + r1.xy;
  r0.xw = float2(0.5,0.5) + r0.xw;
  r1.xy = cmp(float2(1,1) < r0.xw);
  r2.xy = cmp(r0.xw < float2(0,0));
  r0.x = t1.Sample(s2_s, r0.xw).x;
  r0.w = (int)r1.x | (int)r2.x;
  r0.w = (int)r1.y | (int)r0.w;
  r0.w = (int)r2.y | (int)r0.w;
  r1.xy = cb1[3].ww * r0.yz;
  r0.y = dot(r0.yz, r0.yz);
  r0.y = sqrt(r0.y);
  r0.y = -0.300000012 + r0.y;
  r0.y = saturate(6.25 * r0.y);
  r2.y = dot(r1.xy, r1.zw);
  r2.x = dot(r1.yx, cb1[5].zw);
  r1.xy = cb1[7].xy + r2.xy;
  r1.xy = cb1[4].xy + r1.xy;
  r1.zw = float2(-1,1) * cb1[6].xy;
  r2.y = dot(r1.xy, r1.zw);
  r2.x = dot(r1.yx, cb1[6].xy);
  r1.xy = float2(0.5,0.5) + r2.xy;
  r1.zw = cmp(float2(1,1) < r1.xy);
  r2.xy = cmp(r1.xy < float2(0,0));
  r0.z = (int)r1.z | (int)r2.x;
  r0.z = (int)r1.w | (int)r0.z;
  r0.z = (int)r2.y | (int)r0.z;
  r0.w = (int)r0.w | (int)r0.z;
  r0.x = r0.w ? 1 : r0.x;
  r2.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r1.xyzw = t0.Sample(s2_s, r1.xy).xyzw;
  r2.xyzw = r2.xyzw + -r1.xyzw;
  r0.w = saturate(cb1[6].z);
  r1.xyzw = r0.wwww * r2.xyzw + r1.xyzw;
  r1.xyzw = r0.zzzz ? float4(0,0,0,0) : r1.xyzw;
  r1.xyzw = r1.xyzw * r0.xxxx;
  r0.x = cb1[4].w * r1.w;
  o0.xyz = r1.xyz;
  r0.z = r0.y * -2 + 3;
  r0.y = r0.y * r0.y;
  r0.y = -r0.z * r0.y + 1;
  o0.w = r0.x * r0.y;
  return;
}