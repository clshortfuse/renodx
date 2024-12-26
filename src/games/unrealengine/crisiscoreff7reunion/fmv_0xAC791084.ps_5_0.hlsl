#include "../common.hlsl"

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1) {
  float4 cb1[4];
}

cbuffer cb0 : register(b0) {
  float4 cb0[5];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float4 v1: COLOR0,
    float4 v2: ORIGINAL_POSITION0,
    float4 v3: TEXCOORD0,
    float4 v4: TEXCOORD1,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v4.xy * v4.zw;
  r0.z = t2.Sample(s2_s, r0.xy).x;
  r0.z = -0.5 + r0.z;
  r0.zw = float2(1.59602702, -0.812968016) * r0.zz;
  r1.x = t1.Sample(s1_s, r0.xy).x;
  r1.x = -0.5 + r1.x;
  r0.w = r1.x * -0.391761988 + r0.w;
  r1.x = 2.01723194 * r1.x;
  r1.y = t0.Sample(s0_s, r0.xy).x;
  r0.x = t3.Sample(s3_s, r0.xy).x;
  r2.w = saturate(cb1[3].z * r0.x);
  r0.x = -0.0625 + r1.y;
  r0.y = r0.x * 1.16438305 + r0.w;
  r0.w = log2(r0.y);
  r0.y = cmp(0 >= r0.y);
  r0.w = cb1[2].x * r0.w;
  r0.w = exp2(r0.w);
  r0.w = cb1[2].w * r0.w;
  r3.y = r0.y ? 0 : r0.w;
  r0.y = r0.x * 1.16438305 + r0.z;
  r0.x = r0.x * 1.16438305 + r1.x;
  r0.z = log2(r0.y);
  r0.y = cmp(0 >= r0.y);
  r0.z = cb1[2].x * r0.z;
  r0.z = exp2(r0.z);
  r0.z = cb1[2].z * r0.z;
  r3.x = r0.y ? 0 : r0.z;
  r0.y = log2(r0.x);
  r0.x = cmp(0 >= r0.x);
  r0.y = cb1[2].x * r0.y;
  r0.y = exp2(r0.y);
  r0.y = cb1[3].x * r0.y;
  r3.z = r0.x ? 0 : r0.y;
  r0.xyz = cb1[1].xyz + -r3.xyz;
  r0.xyz = cb1[3].yyy * r0.xyz + r3.xyz;
  r2.xyz = max(float3(0, 0, 0), r0.xyz);
  r0.xyzw = v1.xyzw * r2.xyzw;
  r1.x = dot(float3(0.300000012, 0.589999974, 0.109999999), r0.xyz);
  r1.xyz = -r2.xyz * v1.xyz + r1.xxx;
  r1.xyz = r1.xyz * float3(0.800000012, 0.800000012, 0.800000012) + r0.xyz;
  r2.xyz = float3(-0.100000001, -0.100000001, -0.100000001) + r1.xyz;
  r1.w = dot(r2.xyz, r2.xyz);
  r1.w = sqrt(r1.w);
  r1.w = min(0.800000012, r1.w);
  r2.xyz = float3(0.100000001, 0.100000001, 0.100000001) + -r1.xyz;
  r1.xyz = r1.www * r2.xyz + r1.xyz;
  r1.w = cmp(cb0[4].x != 0.000000);
  r0.xyz = r1.www ? r1.xyz : r0.xyz;
  o0.w = r0.w;
  r1.xyz = float3(-0.25, -0.25, -0.25) + r0.xyz;
  r1.xyz = saturate(r1.xyz * cb0[2].www + float3(0.25, 0.25, 0.25));
  r2.xy = cmp(cb0[2].wy != float2(1, 1));
  r0.xyz = r2.xxx ? r1.xyz : r0.xyz;
  // r1.xyz = log2(r0.xyz);
  // r1.xyz = cb0[2].xxx * r1.xyz;
  // r2.xzw = float3(0.416666657, 0.416666657, 0.416666657) * r1.xyz;
  // r1.xyz = exp2(r1.xyz);
  // r2.xzw = exp2(r2.xzw);
  o0.rgb = r0.xyz;

  if (injectedData.toneMapType != 0.f) {
    float videoPeak =
        injectedData.toneMapPeakNits / (injectedData.toneMapGameNits / 203.f);

    // o0.rgb = renodx::color::gamma::Decode(o0.rgb, 2.4f);  // 2.4 for BT2446a
    o0.rgb = renodx::tonemap::inverse::bt2446a::BT709(o0.rgb, 100.f, videoPeak);
    o0.rgb /= videoPeak;                                                    // Normalize to 1.0f = peak;
    o0.rgb *= injectedData.toneMapPeakNits / injectedData.toneMapGameNits;  // 1.f = game nits
  }
  o0.rgb = PostToneMapScale(o0.rgb);  // Gamma Correct

  // r2.xzw = r2.xzw * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  // r3.xyz = float3(12.9200001,12.9200001,12.9200001) * r1.xyz;
  // r1.xyz = cmp(r1.xyz >= float3(0.00313066994,0.00313066994,0.00313066994));
  // r1.xyz = r1.xyz ? r2.xzw : r3.xyz;
  // o0.xyz = r2.yyy ? r1.xyz : r0.xyz;
  return;
}
