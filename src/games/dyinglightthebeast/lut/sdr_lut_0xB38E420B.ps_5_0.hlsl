#include "./colorgradinglut.hlsli"

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture3D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[3];
}

void main(
    float4 v0: SV_POSITION0,
    float4 v1: TEXCOORD0,
    float4 v2: TEXCOORD1,
    float4 v3: TEXCOORD2,
    out float4 o0: SV_TARGET0) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t2.Sample(s2_s, v2.xy).xyzw;
  r0.xyzw = r0.xyzw * float4(2, 2, 2, 2) + float4(-1, -1, -1, -1);
  r1.xyzw = t3.Sample(s2_s, v2.zw).xyzw;
  r0.xyzw = r1.xyzw * float4(2, 2, 2, 2) + r0.xyzw;
  r0.xyzw = cb0[1].zzzz + r0.xyzw;
  r0.xyzw = frac(r0.xyzw);
  r0.xyzw = r0.xyzw * float4(2, 2, 2, 2) + float4(-1, -1, -1, -1);
  r0.xyzw = saturate(abs(r0.xyzw) * float4(5, 5, 5, 5) + float4(-1, -1, -1, -1));
  r0.xyzw = float4(1, 1, 1, 1) + -r0.xyzw;
  r0.xyzw = r0.xyzw * cb0[1].wwww + cb0[1].xxxx;
  r0.xyz = r0.xyz + -r0.www;
  r0.xyz = cb0[1].yyy * r0.xyz + r0.www;
  r1.xy = -abs(v3.zw) * abs(v3.zw) + float2(1, 1);
  r0.w = saturate(-r1.x * r1.y + 1);
  r0.w = r0.w * 1.5 + -0.5;
  r0.w = max(0, r0.w);
  r1.xyzw = -v3.xyxy + v1.xyzw;
  r1.xyzw = r0.wwww * r1.xyzw + v3.xyxy;
  r2.x = t0.SampleLevel(s1_s, r1.xy, 0).x;
  r2.z = t0.SampleLevel(s1_s, r1.zw, 0).z;
  r1.xy = (uint2)v0.xy;
  r1.zw = float2(0, 0);
  r2.y = t0.Load(r1.xyz).y;
  r0.w = saturate(dot(float3(0.212500006, 0.715399981, 0.0720999986), r2.xyz));
  r0.w = sqrt(r0.w);
  r0.w = sqrt(r0.w);
  r0.xyz = r0.xyz * r0.www;
  r1.xyz = r0.xyz * r0.xyz;
  r0.xyz = cmp(r0.xyz >= float3(0, 0, 0));
  r0.xyz = r0.xyz ? r1.xyz : -r1.xyz;
  r0.xyz = saturate(r0.xyz + r2.xyz);
#if 0

  // srgb encode
  r1.xyz = log2(r0.xyz);
  r1.xyz = float3(0.416666657, 0.416666657, 0.416666657) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.xyz = r1.xyz * float3(1.05499995, 1.05499995, 1.05499995) + float3(-0.0549999997, -0.0549999997, -0.0549999997);
  r2.xyz = float3(12.9200001, 12.9200001, 12.9200001) * r0.xyz;
  r0.xyz = cmp(float3(0.00313080009, 0.00313080009, 0.00313080009) >= r0.xyz);
  r0.xyz = r0.xyz ? r2.xyz : r1.xyz;
  r0.xyz = r0.xyz * float3(0.96875, 0.96875, 0.96875) + float3(0.015625, 0.015625, 0.015625);

  // sample LUT
  r0.xyz = t1.SampleLevel(s0_s, r0.xyz, 0).xyz;

  // srgb decode
  r1.xyz = r0.xyz * float3(0.947867274, 0.947867274, 0.947867274) + float3(0.0521326996, 0.0521326996, 0.0521326996);
  r1.xyz = log2(abs(r1.xyz));
  r1.xyz = float3(2.4000001, 2.4000001, 2.4000001) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r2.xyz = float3(0.0773993805, 0.0773993805, 0.0773993805) * r0.xyz;
  r0.xyz = cmp(float3(0.0404499993, 0.0404499993, 0.0404499993) >= r0.xyz);
  r0.xyz = r0.xyz ? r2.xyz : r1.xyz;
#else
  r0.rgb = SampleLUTSRGBInSRGBOut(r0.rgb, t1, s0_s);

#endif
  r0.w = dot(r0.xyz, float3(0.212599993, 0.715200007, 0.0722000003));
  r1.x = -1000 + cb0[2].y;
  r1.x = saturate(-0.00100000005 * r1.x);
  r1.y = r1.x * -2 + 3;
  r1.x = r1.x * r1.x;
  r1.x = r1.y * r1.x;
  r1.y = cmp(6500 >= cb0[2].y);
  r2.xyz = r1.yyy ? float3(0, 1669.58032, 2575.28271) : float3(-2666.34741, -2173.10132, 2575.28271);
  r2.xyz = cb0[2].yyy + r2.xyz;
  r3.xyz = r1.yyy ? float3(0, -2902.19556, -8257.7998) : float3(1745.04248, 1216.61682, -8257.7998);
  r1.yzw = r1.yyy ? float3(1, 1.33026743, 1.89937544) : float3(0.509953916, 0.703812003, 1.89937544);
  r2.xyz = r3.xyz / r2.xyz;
  r1.yzw = saturate(r2.xyz + r1.yzw);
  r2.xyz = float3(1, 1, 1) + -r1.yzw;
  r1.xyz = r1.xxx * r2.xyz + r1.yzw;
  r1.xyz = r1.xyz * r0.xyz;
  r1.w = dot(r1.xyz, float3(0.212599993, 0.715200007, 0.0722000003));
  r1.w = max(9.99999975e-05, r1.w);
  r0.w = r0.w / r1.w;
  r1.xyz = r1.xyz * r0.www;
  r0.w = cmp(cb0[2].y != 6500.000000);
  r0.xyz = r0.www ? r1.xyz : r0.xyz;
  r1.xyz = saturate(r0.xyz);
  r2.xyz = r1.xyz * float3(-2, -2, -2) + float3(3, 3, 3);
  r1.xyz = r1.xyz * r1.xyz;
  r1.xyz = r2.xyz * r1.xyz + -r0.xyz;
  r0.xyz = cb0[0].www * r1.xyz + r0.xyz;
  r0.w = saturate(dot(float3(0.212500006, 0.715399981, 0.0720999986), r0.xyz));
  r0.xyz = r0.xyz + -r0.www;
  r0.xyz = cb0[2].xxx * r0.xyz + r0.www;
  r1.xy = cmp(cb0[0].yx < abs(v3.wz));
  r0.w = (int)r1.y | (int)r1.x;
  r1.xyz = r0.www ? float3(0, 0, 0) : r0.xyz;
  r0.w = cmp(0 < cb0[0].z);
  o0.xyz = r0.www ? r1.xyz : r0.xyz;
  o0.w = 1;

  // o0.rgb *= 2.f;

  return;
}
