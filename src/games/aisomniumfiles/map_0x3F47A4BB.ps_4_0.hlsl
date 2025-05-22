// ---- Created with 3Dmigoto v1.3.16 on Thu May 22 15:10:43 2025
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1)
{
  float4 cb1[1];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[12];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cmp(0.5 < cb0[9].z);
  r0.y = r0.x ? cb0[5].x : cb0[5].y;
  r0.x = cb0[5].x;
  r0.zw = v1.xy * r0.xy;
  r0.zw = floor(r0.zw);
  r0.zw = r0.zw / r0.xy;
  r0.xy = float2(0.5,0.5) / r0.xy;
  r1.xy = r0.zw + r0.xy;
  r0.xy = r1.xy + r0.xy;
  r0.xy = r0.xy + -r0.zw;
  r0.xy = cb0[6].zw * r0.xy + r0.zw;
  r0.zw = float2(-0.5,-0.5) + r1.xy;
  r1.xyzw = t0.Sample(s1_s, r1.xy).xyzw;
  r1.x = -0.5 + r1.x;
  r1.y = dot(r0.zw, r0.zw);
  r1.y = sqrt(r1.y);
  r1.y = 1.41421354 * r1.y;
  r1.y = min(1, r1.y);
  r1.y = 1 + -r1.y;
  r1.z = 6.28318024 * cb0[7].x;
  sincos(r1.z, r2.x, r3.x);
  r3.y = -r2.x;
  r1.z = max(abs(r3.x), abs(r2.x));
  r0.z = dot(r0.zw, r3.xy);
  r0.z = saturate(r0.z * r1.z + 0.5);
  r0.w = r1.y + -r0.z;
  r0.z = cb0[7].y * r0.w + r0.z;
  r0.w = 1 + -r0.z;
  r1.y = cmp(0.5 < cb0[8].w);
  r0.z = r1.y ? r0.w : r0.z;
  r0.w = 1 + -r0.z;
  r1.y = cmp(0.5 < cb0[10].w);
  r0.w = r1.y ? r0.w : r0.z;
  r1.y = cb0[10].z * r1.x;
  r1.y = cb0[10].z * r1.y;
  r1.y = 10 * r1.y;
  r1.z = cb1[0].y * cb0[10].y;
  r1.y = r1.z * 3 + r1.y;
  r1.y = frac(r1.y);
  r1.z = -0.5 + r1.y;
  r1.y = 1 + -r1.y;
  r1.z = r1.x + r1.z;
  r1.w = cb0[8].z + cb0[8].z;
  r1.z = r1.z * r1.w;
  r2.x = cb0[8].y * 15 + 1;
  r2.y = 1 / r2.x;
  r0.w = r1.z * r2.y + r0.w;
  r0.w = r0.w + -r1.y;
  r0.w = r2.x * r0.w + r1.y;
  r1.y = r1.y * 3 + -1;
  r0.w = -r1.y + r0.w;
  r0.w = min(1, abs(r0.w));
  r0.w = 1 + -r0.w;
  r0.w = cb0[10].x * r0.w;
  r1.y = -0.5 + cb0[8].x;
  r1.x = r1.x + r1.y;
  r1.x = r1.x * r1.w;
  r0.z = r1.x * r2.y + r0.z;
  r1.x = 1 + -cb0[8].x;
  r0.z = -r1.x + r0.z;
  r0.z = r2.x * r0.z + r1.x;
  r1.x = r1.x * 2 + -1;
  r0.z = saturate(-r1.x + r0.z);
  r0.z = 1 + -r0.z;
  r1.x = r0.z * r0.z;
  r0.z = saturate(r0.z * r1.x + r0.w);
  r0.w = -r1.x * r1.x + 1;
  r1.xy = r0.zz * cb0[6].xy + float2(1,1);
  r0.z = cb0[9].y * r0.z;
  r1.zw = saturate(cb0[6].zw);
  r0.xy = -r1.zw + r0.xy;
  r0.xy = cb0[11].xx * r0.xy + r1.zw;
  r1.zw = v1.xy + -r0.xy;
  r0.xy = r1.zw * r1.xy + r0.xy;
  r0.xy = r0.xy * cb0[4].xy + cb0[4].zw;
  r1.xyzw = t1.Sample(s0_s, r0.xy).xyzw;
  r1.xyzw = r1.xyzw * r0.wwww;
  r2.xyzw = cb0[3].xyzw + -cb0[2].xyzw;
  r2.xyzw = r0.zzzz * r2.xyzw + cb0[2].xyzw;
  r0.x = 10 * r0.z;
  r0.x = r0.x * r0.w + 1;
  r1.xyzw = r2.xyzw * r1.xyzw;
  r0.xyz = r1.xyz * r0.xxx;
  r1.w = max(0, r1.w);
  r0.xyz = r1.www * r0.xyz;
  r0.w = cb0[9].x * cb0[9].x;
  r0.w = r0.w * 16 + 1;
  r1.xyz = r0.xyz * r0.www;
  
  //o0.xyzw = saturate(r1.xyzw);
  o0.xyzw = (r1.xyzw);
  
  return;
}