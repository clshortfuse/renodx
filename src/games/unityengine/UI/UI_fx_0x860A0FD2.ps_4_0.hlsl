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
  float4 cb0[13];
}

//#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float2 v2 : TEXCOORD0,
  float2 w2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  float4 v4 : TEXCOORD3,
  float4 v5 : TEXCOORD4,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r1.xyzw = cb0[9].z == 0 ? float4(0,0,0,0) : v4.xyzw;
  r0.x = cb1[0].y * cb0[11].z;
  r0.x = 0.174532786 * r0.x;
  sincos(r0.x, r0.x, r2.x);
  r3.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + w2.xyxy;
  r4.x = -r0.x;
  r4.y = r2.x;
  r2.x = dot(r3.yx, r4.xy);
  r4.z = r0.x;
  r2.y = dot(r3.yx, r4.yz);
  r0.xz = float2(0.5,0.5) + r2.xy;
  r0.xz = -cb1[0].yy * cb0[11].xy + r0.xz;
  r2.xyzw = t0.Sample(s1_s, r0.xz).xyzw;
  r0.x = r2.x * 2 + -1;
  r0.z = cb0[11].w + r1.y;
  r0.w = r0.x * r0.z;
  r1.y = cb1[0].y * cb0[10].z;
  r1.y = 0.174532786 * r1.y;
  sincos(r1.y, r2.x, r3.x);
  r4.x = -r2.x;
  r4.y = r3.x;
  r3.x = dot(r3.wz, r4.xy);
  r4.z = r2.x;
  r3.y = dot(r3.wz, r4.yz);
  r2.xy = float2(0.5,0.5) + r3.xy;
  r2.xy = r0.ww * float2(0.5,0.5) + r2.xy;
  r2.xy = -cb1[0].yy * cb0[10].xy + r2.xy;
  r2.xyzw = t1.Sample(s0_s, r2.xy).xyzw;
  r1.yz = cb1[0].yy * cb0[12].xy + r1.zw;
  r1.yz = v3.xy + r1.yz;
  r1.yz = v3.xy * cb0[12].zw + r1.yz;
  r3.xyzw = t2.Sample(s2_s, r1.yz).xyzw;
  if (cb0[9].w == 0) {
    r4.w = v1.w * r3.x;
    r5.xyzw = r2.xyzw * cb0[4].xyzw + cb0[10].wwww;
    r5.xyzw = v1.wwww * r5.xyzw;
    r4.xyz = r2.xyz;
    r4.xyzw = r5.xyzw * r4.xyzw;
    o0.xyzw = v1.xyzw * r4.xyzw;
  if(injectedData.rolloffUI == 1.f){
    o0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(o0.xyz) : o0.xyz;
    o0.xyz = rolloff(o0.xyz, 0.85f, true);
    o0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(o0.xyz) : o0.xyz;
  } else if(injectedData.rolloffUI == 2.f){
    o0.xyz = saturate(o0.xyz);
  }
  o0.w = saturate(o0.w);
    return;
  } else {
    r0.x = -r0.x * r0.z + r3.x;
    r0.y = cb0[9].x + r1.x;
    r0.y = step(r0.y, r0.x);
    r1.xyzw = cb0[4].xyzw * r2.xyzw;
    r0.z = 1 + cb0[10].w;
    r1.xyzw = r1.xyzw * r0.zzzz;
    r0.z = v1.w * r2.w;
    r1.xyzw = r1.xyzw * r0.zzzz;
    r0.x = (r0.x > cb0[9].y) ? 2 : 1;
    r1.xyzw = r1.xyzw * r0.xxxx;
    r0.xyzw = r1.xyzw * r0.yyyy;
    o0.xyzw = v1.xyzw * r0.xyzw;
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
  return;
}