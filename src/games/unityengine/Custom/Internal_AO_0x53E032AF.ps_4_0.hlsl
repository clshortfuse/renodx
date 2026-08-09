Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[58];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  float2 v2 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb0[52].xy / cb0[57].zz;
  r1.xy = v2.xy + -r0.xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.yzw = r1.yzw * float3(2,2,2) + float3(-1,-1,-1);
  r2.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  r2.yzw = r2.yzw * float3(2,2,2) + float3(-1,-1,-1);
  r1.y = dot(r2.yzw, r1.yzw);
  r1.y = -0.8 + r1.y;
  r1.y = saturate(5.0 * r1.y);
  r1.z = r1.y * -2 + 3;
  r1.y = r1.y * r1.y;
  r1.y = r1.z * r1.y;
  r1.x = r1.x * r1.y + r2.x;
  r0.zw = -r0.yx;
  r3.xyzw = v2.xyxy + r0.xzwy;
  r0.xy = v2.xy + r0.xy;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r4.xyzw = t0.Sample(s0_s, r3.xy).xyzw;
  r3.xyzw = t0.Sample(s0_s, r3.zw).xyzw;
  r4.yzw = r4.yzw * float3(2,2,2) + float3(-1,-1,-1);
  r1.z = dot(r2.yzw, r4.yzw);
  r1.z = -0.8 + r1.z;
  r1.z = saturate(5.0 * r1.z);
  r1.w = r1.z * -2 + 3;
  r1.z = r1.z * r1.z;
  r2.x = r1.w * r1.z;
  r1.y = r1.w * r1.z + r1.y;
  r1.x = r4.x * r2.x + r1.x;
  r3.yzw = r3.yzw * float3(2,2,2) + float3(-1,-1,-1);
  r1.z = dot(r2.yzw, r3.yzw);
  r1.z = -0.8 + r1.z;
  r1.z = saturate(5.0 * r1.z);
  r1.w = r1.z * -2 + 3;
  r1.z = r1.z * r1.z;
  r2.x = r1.w * r1.z;
  r1.y = r1.w * r1.z + r1.y;
  r1.x = r3.x * r2.x + r1.x;
  r0.yzw = r0.yzw * float3(2,2,2) + float3(-1,-1,-1);
  r0.y = dot(r2.yzw, r0.yzw);
  r0.y = -0.8 + r0.y;
  r0.y = saturate(5.0 * r0.y);
  r0.z = r0.y * -2 + 3;
  r0.y = r0.y * r0.y;
  r0.w = r0.z * r0.y;
  r0.y = r0.z * r0.y + r1.y;
  r0.y = 1 + r0.y;
  r0.x = r0.x * r0.w + r1.x;
  r0.x = r0.x / r0.y;
  o0.xyzw = float4(1,1,1,1) + -r0.xxxx;
  o0.w = saturate(o0.w);
  return;
}