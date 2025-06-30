// ---- Created with 3Dmigoto v1.4.1 on Wed Jan 29 15:53:29 2025
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[9];
}




// 3Dmigoto declarations
#define cmp -

void main(
    // r4 is image color info

  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  float2 v2 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb0[2].xy / cb0[8].xx;
  r1.xy = v2.xy + -r0.xy;
  r1.xyzw = t0.Sample(s1_s, r1.xy).xyzw;
  r1.yzw = r1.yzw * float3(2,2,2) + float3(-1,-1,-1);
  r2.xyzw = t0.Sample(s1_s, v2.xy).xyzw;
  r2.yzw = r2.yzw * float3(2,2,2) + float3(-1,-1,-1);
  r1.y = dot(r2.yzw, r1.yzw);
  r1.y = -0.800000012 + r1.y;
  r1.y = saturate(5.00000048 * r1.y);
  r1.z = r1.y * -2 + 3;
  r1.y = r1.y * r1.y;
  r1.y = r1.z * r1.y;
  r1.x = r1.x * r1.y + r2.x;
  r0.zw = -r0.yx;
  r3.xyzw = v2.xyxy + r0.xzwy;
  r0.xy = v2.xy + r0.xy;
  r0.xyzw = t0.Sample(s1_s, r0.xy).xyzw;
  r4.xyzw = t0.Sample(s1_s, r3.xy).xyzw;
  r3.xyzw = t0.Sample(s1_s, r3.zw).xyzw;
  r4.yzw = r4.yzw * float3(2,2,2) + float3(-1,-1,-1);
  r1.z = dot(r2.yzw, r4.yzw);
  r1.z = -0.800000012 + r1.z;
  r1.z = saturate(5.00000048 * r1.z);
  r1.w = r1.z * -2 + 3;
  r1.z = r1.z * r1.z;
  r2.x = r1.w * r1.z;
  r1.y = r1.w * r1.z + r1.y;
  r1.x = r4.x * r2.x + r1.x;
  r3.yzw = r3.yzw * float3(2,2,2) + float3(-1,-1,-1);
  r1.z = dot(r2.yzw, r3.yzw);
  r1.z = -0.800000012 + r1.z;
  r1.z = saturate(5.00000048 * r1.z);
  r1.w = r1.z * -2 + 3;
  r1.z = r1.z * r1.z;
  r2.x = r1.w * r1.z;
  r1.y = r1.w * r1.z + r1.y;
  r1.x = r3.x * r2.x + r1.x;
  r0.yzw = r0.yzw * float3(2,2,2) + float3(-1,-1,-1);
  r0.y = dot(r2.yzw, r0.yzw);
  r0.y = -0.800000012 + r0.y;
  r0.y = saturate(5.00000048 * r0.y);
  r0.z = r0.y * -2 + 3;
  r0.y = r0.y * r0.y;
  r0.w = r0.z * r0.y;
  r0.y = r0.z * r0.y + r1.y;
  r0.y = 1 + r0.y;
  r0.x = r0.x * r0.w + r1.x;
  r0.x = r0.x / r0.y;
  r0.x = 1 + -r0.x;
  r1.xyzw = t1.Sample(s0_s, v2.xy).xyzw;
  o0.xyz = r1.xyz * r0.xxx;
  o0.w = r1.w;
  return;
}