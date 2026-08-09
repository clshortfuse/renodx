#include "../common.hlsl"

TextureCube<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s4_s : register(s4);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[1];
}
cbuffer cb0 : register(b0){
  float4 cb0[29];
}

#define cmp -

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
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s4_s, v2.xy).xyzw;
  r0.x = -v3.x + r0.w;
  r0.y = v3.z + -r0.w;
  r0.x = cmp(r0.x < 0);
  if (r0.x != 0) discard;
  r0.x = cb0[6].z + v3.w;
  r1.xy = float2(0.5,0.5) / cb0[27].zw;
  r1.z = 0;
  r2.xyzw = v2.xyxy + -r1.xzzy;
  r1.xyzw = v2.xyxy + r1.xzzy;
  r3.xyzw = t0.Sample(s4_s, r2.xy).wxyz;
  r2.xyzw = t0.Sample(s4_s, r2.zw).xyzw;
  r3.z = r2.w;
  r2.xyzw = t0.Sample(s4_s, r1.xy).xyzw;
  r1.xyzw = t0.Sample(s4_s, r1.zw).xyzw;
  r3.w = r1.w;
  r3.y = r2.w;
  r1.xyzw = r3.xyzw + r0.xxxx;
  r1.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + r1.xyzw;
  r0.x = cb0[6].x + cb0[6].w;
  r0.x = max(0.00999999978, r0.x);
  r1.xyzw = r1.xyzw / r0.xxxx;
  r0.x = cb0[6].y * r0.x;
  r0.x = cb0[28].x * r0.x;
  r0.x = -2 * r0.x;
  r1.xyzw = saturate(float4(0.5,0.5,0.5,0.5) + r1.xyzw);
  r2.xyzw = r1.xyzw * float4(2,2,2,2) + float4(-1,-1,-1,-1);
  r2.xyzw = float4(1,1,1,1) + -abs(r2.xyzw);
  r0.z = 0.5 * cb0[22].x;
  r0.w = cmp(r0.z >= -r0.z);
  r0.z = frac(abs(r0.z));
  r0.z = r0.w ? r0.z : -r0.z;
  r0.z = cmp(r0.z >= 0.5);
  r1.xyzw = r0.zzzz ? r2.xyzw : r1.xyzw;
  r2.xyzw = float4(1.57079601,1.57079601,1.57079601,1.57079601) * r1.xyzw;
  r2.xyzw = sin(r2.xyzw);
  r2.xyzw = r2.xyzw + -r1.xyzw;
  r1.xyzw = cb0[7].yyyy * r2.xyzw + r1.xyzw;
  r0.z = 1 + -cb0[7].x;
  r1.xyzw = min(r1.xyzw, r0.zzzz);
  r0.zw = r1.xz * r0.xx;
  r1.yz = r1.wy * r0.xx + -r0.wz;
  r1.xw = float2(-1,1);
  r0.x = dot(r1.xy, r1.xy);
  r0.x = rsqrt(r0.x);
  r0.z = dot(r1.zw, r1.zw);
  r0.z = rsqrt(r0.z);
  r2.x = r1.z * r0.z;
  r2.yz = float2(1,0) * r0.zz;
  r1.z = 0;
  r0.xzw = r1.xyz * r0.xxx;
  r1.xyz = r2.xyz * r0.xzw;
  r0.xzw = r2.zxy * r0.zwx + -r1.xyz;
  r1.xy = cb0[2].xy * cb1[0].yy + v6.xy;
  r2.xyzw = t3.Sample(s2_s, r1.xy).xyzw;
  r1.xyzw = t1.Sample(s0_s, r1.xy).xyzw;
  r2.x = r2.x * r2.w;
  r2.xy = r2.xy * float2(2,2) + float2(-1,-1);
  r2.w = dot(r2.xy, r2.xy);
  r2.w = min(1, r2.w);
  r2.w = 1 + -r2.w;
  r2.z = sqrt(r2.w);
  r2.w = cb0[7].z + -cb0[7].w;
  r3.x = cb0[22].w * cb0[6].x;
  r3.x = v3.y * r3.x;
  r3.y = 0.5 * r3.x;
  r3.x = min(1, r3.x);
  r3.x = sqrt(r3.x);
  r3.z = saturate(r0.y * v3.y + r3.y);
  r3.y = r0.y * v3.y + -r3.y;
  r0.y = v3.y * r0.y;
  r2.w = r3.z * r2.w + cb0[7].w;
  r0.xzw = -r2.xyz * r2.www + r0.xzw;
  r2.x = dot(r0.xzw, r0.xzw);
  r2.x = rsqrt(r2.x);
  r0.xzw = r2.xxx * r0.xzw;
  r2.x = dot(v5.xyz, -r0.xzw);
  r2.x = r2.x + r2.x;
  r2.xyz = r0.xzw * r2.xxx + v5.xyz;
  r2.xyzw = t4.Sample(s3_s, r2.xyz).xyzw;
  r4.xyz = cb0[9].xyz + -cb0[8].xyz;
  r4.xyz = r3.zzz * r4.xyz + cb0[8].xyz;
  r2.w = r3.z * r3.x;
  r2.xyz = r4.xyz * r2.xyz;
  r4.xyz = v1.xyz;
  r4.w = 1;
  r4.xyzw = cb0[3].xyzw * r4.xyzw;
  r4.xyzw = float4(2,2,2,1) * r4.xyzw;
  r1.xyzw = r4.xyzw * r1.xyzw;
  r1.xyz = r1.xyz * r1.www;
  r3.xz = cb0[4].zw * cb1[0].yy + v6.zw;
  r4.xyzw = t2.Sample(s1_s, r3.xz).xyzw;
  r4.xyzw = cb0[5].xyzw * r4.xyzw;
  r4.xyz = r4.xyz * r4.www;
  r4.xyzw = r4.xyzw + -r1.xyzw;
  r1.xyzw = r2.wwww * r4.xyzw + r1.xyzw;
  r2.w = cb0[22].w * cb0[4].y;
  r3.x = v3.y * r2.w;
  r2.w = r2.w * v3.y + 1;
  r3.x = r3.x * 0.5 + r3.y;
  r2.w = saturate(r3.x / r2.w);
  r2.w = 1 + -r2.w;
  r1.xyzw = r2.wwww * r1.xyzw;
  r2.xyz = r2.xyz * r1.www;
  sincos(cb0[16].x, r3.x, r4.x);
  r3.y = r4.x;
  r3.z = -1;
  r2.w = dot(r3.xyz, r3.xyz);
  r2.w = rsqrt(r2.w);
  r3.xyz = r3.xyz * r2.www;
  r0.x = dot(r0.xzw, r3.xyz);
  r0.z = r0.w * r0.w;
  r0.w = max(0, r0.x);
  r0.x = -r0.x * cb0[16].w + 1;
  r0.w = log2(r0.w);
  r0.w = cb0[16].z * r0.w;
  r0.w = exp2(r0.w);
  r3.xyz = cb0[15].xyz * r0.www;
  r3.xyz = cb0[16].yyy * r3.xyz;
  r3.xyz = r3.xyz * r1.www + r1.xyz;
  r3.xyz = r3.xyz * r0.xxx;
  r0.x = 1 + -cb0[17].x;
  r0.x = r0.z * r0.x + cb0[17].x;
  r0.xzw = r3.xyz * r0.xxx + r2.xyz;
  r2.x = cb0[23].x * cb0[21].x;
  r2.x = 0.5 * r2.x;
  r0.y = -r2.x * v3.y + r0.y;
  r2.x = cmp(r0.y >= 0);
  r2.x = r2.x ? 1.000000 : 0;
  r2.y = cb0[21].y * cb0[23].x + -cb0[21].z;
  r2.x = r2.x * r2.y + cb0[21].z;
  r2.x = 0.5 * r2.x;
  r2.y = r2.x * v3.y + 1;
  r2.x = v3.y * r2.x;
  r2.x = min(1, r2.x);
  r2.x = sqrt(r2.x);
  r0.y = r0.y / r2.y;
  r0.y = min(1, abs(r0.y));
  r0.y = log2(r0.y);
  r0.y = cb0[21].w * r0.y;
  r0.y = exp2(r0.y);
  r0.y = 1 + -r0.y;
  r0.y = r0.y * r2.x;
  r0.y = saturate(dot(cb0[20].ww, r0.yy));
  r0.y = 5 * r0.y;
  r2.xyz = float3(5,5,5) * cb0[20].xyz;
  r1.xyz = r2.xyz * r0.yyy + r0.xzw;
  o0.xyzw = v1.wwww * r1.xyzw;
  if(injectedData.rolloffUI == 1.f){
    o0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(o0.xyz) : o0.xyz;
    o0.xyz = rolloff(o0.xyz, 0.85f, true);
    o0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(o0.xyz) : o0.xyz;
  } else if(injectedData.rolloffUI == 2.f){
    o0.xyz = saturate(o0.xyz);
  }
  return;
}