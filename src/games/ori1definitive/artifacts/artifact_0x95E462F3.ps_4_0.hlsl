// ---- Created with 3Dmigoto v1.4.1 on Sat Apr  5 00:32:57 2025
Texture2D<float4> t6 : register(t6);

Texture2D<float4> t5 : register(t5);

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s6_s : register(s6);

SamplerState s5_s : register(s5);

SamplerState s4_s : register(s4);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[78];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  float4 v4 : TEXCOORD3,
  float4 v5 : TEXCOORD4,
  float4 v6 : COLOR0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb0[40].xy + -v4.xy;
  r0.x = dot(r0.xy, r0.xy);
  r0.x = sqrt(r0.x);
  r0.y = cb0[69].y * cb0[40].z;
  r0.x = saturate(r0.x / r0.y);
  r0.x = -1 + r0.x;
  r0.x = cb0[40].w * r0.x;
  r0.x = cb0[69].x * r0.x + 1;
  r0.y = 0;
  r0.xyzw = t4.Sample(s4_s, r0.xy).xyzw;
  r0.y = 1 + -r0.x;
  r0.y = r0.y + -r0.x;
  r0.x = cb0[69].w * r0.y + r0.x;
  r0.y = cb0[70].w + -r0.x;
  r0.x = cb0[71].x * r0.y + r0.x;
  r0.x = -1 + r0.x;
  r0.xy = cb0[70].yx * r0.xx + float2(1,1);
  r0.z = cb0[76].w * r0.x + -1;
  r0.z = saturate(-6.66666794 * r0.z);
  r0.w = r0.z * -2 + 3;
  r0.z = r0.z * r0.z;
  r0.z = r0.w * r0.z;
  r0.x = -cb0[76].w * r0.x + 1;
  r1.xyzw = t5.Sample(s6_s, v5.xy).xyzw;
  r1.xy = r1.zw * float2(2,2) + float2(-1,-1);
  r1.xy = r1.xy * cb0[77].xy + v3.zw;
  r1.xyzw = t6.Sample(s5_s, r1.xy).xyzw;
  r0.x = saturate(-r1.w * 0.930000007 + r0.x);
  r0.w = 1 + -r1.w;
  r0.w = r0.w * 0.930000007 + 0.0700000003;
  r0.w = cb0[77].z * r0.w;
  r0.w = 0.5 * r0.w;
  r0.x = r0.x / r0.w;
  r0.z = r0.x * r0.z;
  r0.x = 1 + -r0.x;
  r0.z = log2(r0.z);
  r0.w = 1 / cb0[77].w;
  r0.z = r0.w * r0.z;
  r0.z = exp2(r0.z);
  r1.xyzw = t0.Sample(s1_s, v2.xy).xyzw;
  r1.xy = r1.wz * float2(2,2) + float2(-1,-1);
  r1.xy = cb0[32].yx * r1.xy;
  r2.xyzw = t1.Sample(s2_s, v2.zw).xyzw;
  r1.xy = r1.xy * r2.ww + v1.yx;
  r1.xy = frac(r1.xy);
  r1.xy = -cb0[20].yx + r1.xy;
  r1.xy = saturate(r1.xy / cb0[20].wz);
  r1.zw = cb0[7].yy * r1.xy;
  r0.w = 1 + -cb0[7].y;
  r1.xy = r1.yx * r0.ww + r1.zw;
  r1.xy = r1.xy * cb0[19].zw + cb0[19].xy;
  r1.xyzw = t2.Sample(s0_s, r1.xy).xyzw;
  r0.w = saturate(dot(r1.xyzw, cb0[8].xyzw));
  r1.xyzw = r0.wwww * cb0[9].xyzw + r1.xyzw;
  r1.xyz = r1.xyz / r1.www;
  r1.xyzw = cb0[21].xyzw * r1.xyzw;
  r1.xyzw = r1.xyzw + r1.xyzw;
  o0.xyz = cb0[76].xyz * r0.zzz + r1.xyz;
  r2.xyzw = t3.Sample(s3_s, v3.xy).xyzw;
  r0.z = -1 + r2.w;
  r0.z = cb0[39].x * r0.z + 1;
  r0.z = r1.w * r0.z;
  r0.y = r0.z * r0.y;
  o0.w = r0.y * r0.x;

o0 = saturate(o0);

  return;
}