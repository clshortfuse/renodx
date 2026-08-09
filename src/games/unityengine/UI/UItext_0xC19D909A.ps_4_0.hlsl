#include "../common.hlsl"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[1];
}
cbuffer cb0 : register(b0){
  float4 cb0[24];
}

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float4 v2 : TEXCOORD0,
  float4 v3 : TEXCOORD1,
  float4 v4 : TEXCOORD2,
  float4 v5 : TEXCOORD3,
  float4 v6 : TEXCOORD5,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s2_s, v2.xy).xyzw;
  r0.x = -v3.x + r0.w;
  r0.y = v3.z + -r0.w;
  if (r0.x < 0) discard;
  r0.xz = cb0[4].zw * cb1[0].yy + v6.zw;
  r1.xyzw = t2.Sample(s1_s, r0.xz).xyzw;
  r1.xyzw = cb0[5].xyzw * r1.xyzw;
  r1.xyz = r1.xyz * r1.www;
  r0.xzw = cb0[3].xyz * v1.xyz;
  r2.xy = cb0[2].xy * cb1[0].yy + v6.xy;
  r2.xyzw = t1.Sample(s0_s, r2.xy).xyzw;
  r0.xzw = r2.xyz * r0.xzw;
  r2.w = cb0[3].w * r2.w;
  r2.xyz = r2.www * r0.xzw;
  r1.xyzw = -r2.xyzw + r1.xyzw;
  r0.x = cb0[22].w * cb0[6].x;
  r0.x = v3.y * r0.x;
  r0.z = min(1, r0.x);
  r0.x = 0.5 * r0.x;
  r0.z = sqrt(r0.z);
  r0.w = saturate(r0.y * v3.y + r0.x);
  r0.x = r0.y * v3.y + -r0.x;
  r0.z = r0.w * r0.z;
  r1.xyzw = r0.zzzz * r1.xyzw + r2.xyzw;
  r0.z = cb0[22].w * cb0[4].y;
  r0.yw = v3.yy * r0.yz;
  r0.z = r0.z * v3.y + 1;
  r0.x = r0.w * 0.5 + r0.x;
  r0.x = saturate(r0.x / r0.z);
  r0.x = 1 + -r0.x;
  r1.xyzw = r1.xyzw * r0.xxxx;
  r0.x = cb0[23].x * cb0[21].x;
  r0.x = 0.5 * r0.x;
  r0.x = -r0.x * v3.y + r0.y;
  r0.y = step(0.0, r0.x);
  r0.z = cb0[21].y * cb0[23].x + -cb0[21].z;
  r0.y = r0.y * r0.z + cb0[21].z;
  r0.y = 0.5 * r0.y;
  r0.z = r0.y * v3.y + 1;
  r0.y = v3.y * r0.y;
  r0.y = min(1, r0.y);
  r0.y = sqrt(r0.y);
  r0.x = r0.x / r0.z;
  r0.x = min(1, abs(r0.x));
  r0.x = log2(r0.x);
  r0.x = cb0[21].w * r0.x;
  r0.x = exp2(r0.x);
  r0.x = 1 + -r0.x;
  r0.x = r0.x * r0.y;
  r0.x = saturate(dot(cb0[20].ww, r0.xx));
  r1.xyz = cb0[20].xyz * r0.xxx + r1.xyz;
  o0.xyzw = v1.wwww * r1.xyzw;
  if(injectedData.rolloffUI == 1.f){
    o0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(o0.xyz) : o0.xyz;
    o0.xyz = rolloff(o0.xyz, 0.85f, true);
    o0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(o0.xyz) : o0.xyz;
  } else if(injectedData.rolloffUI == 2.f){
    o0.xyz = saturate(o0.xyz);
  }
  o0.w = saturate(o0.w);
  return;
}