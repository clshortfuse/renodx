#include "./colorgradinglut.hlsli"

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[3];
}

void main(
    float4 v0: SV_POSITION0,
    float4 v1: TEXCOORD0,
    float4 v2: TEXCOORD1,
    out float4 o0: SV_TARGET0) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = -1000 + cb0[2].y;
  r0.x = saturate(-0.00100000005 * r0.x);
  r0.y = r0.x * -2 + 3;
  r0.x = r0.x * r0.x;
  r0.x = r0.y * r0.x;
  r0.y = cmp(6500 >= cb0[2].y);
  r1.xyz = r0.yyy ? float3(0, 1669.58032, 2575.28271) : float3(-2666.34741, -2173.10132, 2575.28271);
  r1.xyz = cb0[2].yyy + r1.xyz;
  r2.xyz = r0.yyy ? float3(0, -2902.19556, -8257.7998) : float3(1745.04248, 1216.61682, -8257.7998);
  r0.yzw = r0.yyy ? float3(1, 1.33026743, 1.89937544) : float3(0.509953916, 0.703812003, 1.89937544);
  r1.xyz = r2.xyz / r1.xyz;
  r0.yzw = saturate(r1.xyz + r0.yzw);
  r1.xyz = float3(1, 1, 1) + -r0.yzw;
  r0.xyz = r0.xxx * r1.xyz + r0.yzw;
  r1.xyzw = t1.Sample(s0_s, v1.xy).xyzw;
  r1.xyzw = r1.xyzw * float4(2, 2, 2, 2) + float4(-1, -1, -1, -1);
  r2.xyzw = t2.Sample(s0_s, v1.zw).xyzw;
  r1.xyzw = r2.xyzw * float4(2, 2, 2, 2) + r1.xyzw;
  r1.xyzw = cb0[1].zzzz + r1.xyzw;
  r1.xyzw = frac(r1.xyzw);
  r1.xyzw = r1.xyzw * float4(2, 2, 2, 2) + float4(-1, -1, -1, -1);
  r1.xyzw = saturate(abs(r1.xyzw) * float4(5, 5, 5, 5) + float4(-1, -1, -1, -1));
  r1.xyzw = float4(1, 1, 1, 1) + -r1.xyzw;
  r1.xyzw = r1.xyzw * cb0[1].wwww + cb0[1].xxxx;
  r1.xyz = r1.xyz + -r1.www;
  r1.xyz = cb0[1].yyy * r1.xyz + r1.www;
  r2.xyzw = t0.SampleLevel(s1_s, v2.xy, 0).xyzw;
  r0.w = saturate(dot(float3(0.212500006, 0.715399981, 0.0720999986), r2.xyz));
  r0.w = sqrt(r0.w);
  r0.w = sqrt(r0.w);
  r1.xyz = r1.xyz * r0.www;
  r3.xyz = r1.xyz * r1.xyz;
  r1.xyz = cmp(r1.xyz >= float3(0, 0, 0));
  r1.xyz = r1.xyz ? r3.xyz : -r3.xyz;
  r1.xyz = saturate(r1.xyz + r2.xyz);
  o0.w = r2.w;
  r0.xyz = r1.xyz * r0.xyz;
  r0.w = dot(r0.xyz, float3(0.212599993, 0.715200007, 0.0722000003));
  r0.w = max(9.99999975e-05, r0.w);
  r1.w = dot(r1.xyz, float3(0.212599993, 0.715200007, 0.0722000003));
  r0.w = r1.w / r0.w;
  r0.xyz = r0.xyz * r0.www;
  r0.w = cmp(cb0[2].y != 6500.000000);
  r0.xyz = r0.www ? r0.xyz : r1.xyz;
  r1.xyz = min(float3(1, 1, 1), r0.xyz);
  r2.xyz = r1.xyz * float3(-2, -2, -2) + float3(3, 3, 3);
  r1.xyz = r1.xyz * r1.xyz;
  r1.xyz = r2.xyz * r1.xyz + -r0.xyz;
  r0.xyz = cb0[0].www * r1.xyz + r0.xyz;
  r0.w = saturate(dot(float3(0.212500006, 0.715399981, 0.0720999986), r0.xyz));
  r0.xyz = r0.xyz + -r0.www;
  r0.xyz = cb0[2].xxx * r0.xyz + r0.www;
  r1.xy = cmp(cb0[0].yx < abs(v2.wz));
  r0.w = (int)r1.y | (int)r1.x;
  r1.xyz = r0.www ? float3(0, 0, 0) : r0.xyz;
  r0.w = cmp(0 < cb0[0].z);
  o0.xyz = r0.www ? r1.xyz : r0.xyz;
  return;
}
