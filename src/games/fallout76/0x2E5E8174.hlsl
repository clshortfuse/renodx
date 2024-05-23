// ---- Created with 3Dmigoto v1.3.16 on Sun May 12 21:52:50 2024
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2)
{
  float4 cb2[1];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = t1.Sample(s1_s, v1.xy).xy;
  r0.z = dot(r0.xy, r0.xy);
  r0.w = sqrt(r0.z);
  r1.xy = float2(-0.5,-0.5) + v1.xy;
  r1.x = dot(r1.xy, r1.xy);
  r1.x = sqrt(r1.x);
  r1.x = saturate(r1.x * 0.100000001 + -0.0179999992);
  r1.x = r1.x * r0.w;
  r1.y = cmp(r1.x < 0.00100000005);
  r0.z = rsqrt(r0.z);
  r0.xy = r0.xy * r0.zz;
  r0.z = min(cb2[0].y, r1.x);
  r0.xy = r0.xy * r0.zz;
  r0.xy = cb2[0].xx * r0.xy;
  r2.xyzw = r0.xyxy * float4(-0.5,-0.5,-0.25,-0.25) + v1.xyxy;
  r1.xz = t1.Sample(s1_s, r2.xy).xy;
  r3.xyz = t0.Sample(s0_s, r2.xy).xyz;
  r2.xy = t1.Sample(s1_s, r2.zw).xy;
  r4.xyz = t0.Sample(s0_s, r2.zw).xyz;
  r5.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r0.xy = r0.xy * float2(0.25,0.25) + v1.xy;
  r2.zw = t1.Sample(s1_s, r0.xy).xy;
  r0.xyz = t0.Sample(s0_s, r0.xy).xyz;
  if (r1.y != 0) {
    o0.xyzw = r5.xyzw;
    return;
  }
  r1.x = dot(r1.xz, r1.xz);
  r1.x = sqrt(r1.x);
  r1.x = -r1.x + r0.w;
  r1.x = saturate(-abs(r1.x) * cb2[0].z + 1);
  r1.y = dot(r2.xy, r2.xy);
  r1.y = sqrt(r1.y);
  r1.y = -r1.y + r0.w;
  r1.y = saturate(-abs(r1.y) * cb2[0].z + 1);
  r1.z = r1.x + r1.y;
  r4.xyz = r4.xyz * r1.yyy;
  r1.xyw = r3.xyz * r1.xxx + r4.xyz;
  r1.z = 1 + r1.z;
  r1.xyw = r1.xyw + r5.xyz;
  r2.x = dot(r2.zw, r2.zw);
  r2.x = sqrt(r2.x);
  r0.w = -r2.x + r0.w;
  r0.w = saturate(-abs(r0.w) * cb2[0].z + 1);
  r1.z = r1.z + r0.w;
  r0.xyz = r0.xyz * r0.www + r1.xyw;
  r0.w = 0.00100000005 + r1.z;
  o0.xyz = r0.xyz / r0.www;
  o0.w = 1;
  return;
}