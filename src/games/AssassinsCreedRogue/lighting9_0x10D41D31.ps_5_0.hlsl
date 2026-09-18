// ---- Created with 3Dmigoto v1.3.16 on Sat Jul 04 18:23:48 2026
Texture2D<float4> t9 : register(t9);

SamplerState s9_s : register(s9);

cbuffer cb0 : register(b0)
{
  float4 cb0[135];
}


float3 EncodeSRGBOutput(float3 c)
{
#if MANUAL_SRGB_RT_ENCODE
  c = LinearToSRGB(max(c, 0.0));
#endif
  return c;
}

// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : COLOR0,
  float4 v3 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v0.xy * cb0[19].xy + cb0[19].zw;
  r0.zw = r0.xy * cb0[15].xy + cb0[15].zw;
  r0.x = t9.SampleLevel(s9_s, r0.xy, 0).x;
  r0.x = cb0[20].z + r0.x;
  r1.z = cb0[20].w / r0.x;
  r1.xy = r1.zz * r0.zw;
  r0.x = dot(r1.xyz, r1.xyz);
  r0.yzw = -cb0[133].xyz + r1.xyz;
  r0.y = dot(r0.yzw, cb0[134].xyz);
  r0.x = sqrt(r0.x);
  r0.x = r0.x * cb0[132].y + -cb0[37].x;
  r0.z = cb0[37].y + -cb0[37].x;
  r0.x = saturate(r0.x / r0.z);
  r0.x = 1 + -r0.x;
  r0.x = r0.x * r0.x;
  r0.x = -r0.x * r0.x + 1;
  r0.z = cb0[40].z + cb0[37].z;
  r0.y = r0.y + -r0.z;
  r0.z = 1 / cb0[37].w;
  r0.z = cb0[37].x + r0.z;
  r0.w = dot(v3.xyz, v3.xyz);
  r0.w = rsqrt(r0.w);
  r1.xyz = v3.xyz * r0.www;
  r0.z = -r1.z * r0.z + -cb0[37].z;
  r0.w = dot(r1.xy, cb0[11].xy);
  r0.w = r0.w * 0.5 + 0.5;
  r0.y = min(r0.y, r0.z);
  r0.y = saturate(-r0.y * cb0[37].w + 1);
  o0.w = r0.y * r0.x;
  r0.xyz = cb0[61].xyz + -cb0[60].xyz;
  o0.xyz = r0.www * r0.xyz + cb0[60].xyz;
    o0.xyz = EncodeSRGBOutput(o0.xyz);
  return;
}