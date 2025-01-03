#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Thu Jan  2 22:18:43 2025
Texture2D<float4> t3 : register(t3);

Texture3D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[43];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    float2 w1: TEXCOORD1,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t1.Sample(s1_s, v1.xy).xyzw;
  r1.xyzw = t0.Sample(s0_s, w1.xy).xyzw;
  r0.yzw = float3(0.0773993805, 0.0773993805, 0.0773993805) * r1.xyz;
  r2.xyz = float3(0.0549999997, 0.0549999997, 0.0549999997) + r1.xyz;
  r2.xyz = float3(0.947867334, 0.947867334, 0.947867334) * r2.xyz;
  r2.xyz = max(float3(1.1920929e-07, 1.1920929e-07, 1.1920929e-07), abs(r2.xyz));
  r2.xyz = log2(r2.xyz);
  r2.xyz = float3(2.4000001, 2.4000001, 2.4000001) * r2.xyz;
  r2.xyz = exp2(r2.xyz);
  r1.xyz = cmp(float3(0.0404499993, 0.0404499993, 0.0404499993) >= r1.xyz);
  r0.yzw = r1.xyz ? r0.yzw : r2.xyz;
  r0.xyz = r0.yzw * r0.xxx;
  r0.w = cmp(cb0[40].y < 0.5);
  if (r0.w != 0) {
    r1.xy = -cb0[38].xy + v1.xy;
    r1.yz = cb0[39].xx * abs(r1.yx) * min(1, injectedData.fxVignette);
    r0.w = cb0[22].x / cb0[22].y;
    r0.w = -1 + r0.w;
    r0.w = cb0[39].w * r0.w + 1;
    r1.x = r1.z * r0.w;
    r1.xy = saturate(r1.xy);
    r1.xy = log2(r1.xy);
    r1.xy = cb0[39].zz * r1.xy;
    r1.xy = exp2(r1.xy);
    r0.w = dot(r1.xy, r1.xy);
    r0.w = 1 + -r0.w;
    r0.w = max(0, r0.w);
    r0.w = log2(r0.w);
    r0.w = cb0[39].y * r0.w * max(1, injectedData.fxVignette);
    r0.w = exp2(r0.w);
    r1.xyz = float3(1, 1, 1) + -cb0[37].xyz;
    r1.xyz = r0.www * r1.xyz + cb0[37].xyz;
    r2.xyz = r1.xyz * r0.xyz;
    r1.x = -1 + r1.w;
    r2.w = r0.w * r1.x + 1;
  } else {
    r3.xyzw = t3.Sample(s3_s, v1.xy).xyzw;
    r1.xyz = float3(1, 1, 1) + -cb0[37].xyz;
    r1.xyz = r3.www * r1.xyz + cb0[37].xyz;
    r1.xyz = r0.xyz * r1.xyz + -r0.xyz;
    r2.xyz = cb0[40].xxx * r1.xyz + r0.xyz;
    r0.x = -1 + r1.w;
    r2.w = r3.w * r0.x + 1;
  }
  r0.xyzw = cb0[36].zzzz * r2.xyzw;

  float3 lutInput = lutShaper(r0.rgb);
  float3 lutColor = renodx::lut::Sample(t2, s2_s, lutInput);
  o0.rgb = lutColor;

  if (false) {
    r0.xyz = r0.xyz * float3(5.55555582, 5.55555582, 5.55555582) + float3(0.0479959995, 0.0479959995, 0.0479959995);
    r0.xyz = log2(r0.xyz);
    r0.xyz = saturate(r0.xyz * float3(0.0734997839, 0.0734997839, 0.0734997839) + float3(0.386036009, 0.386036009, 0.386036009));
    r0.xyz = cb0[36].yyy * r0.xyz;
    r1.x = 0.5 * cb0[36].x;
    r0.xyz = r0.xyz * cb0[36].xxx + r1.xxx;
    r1.xyzw = t2.Sample(s2_s, r0.xyz).xyzw;
    r0.x = cmp(0.5 < cb0[42].x);
    if (r0.x != 0) {
      r0.xyz = saturate(r1.xyz);
      o0.w = dot(r0.xyz, float3(0.212672904, 0.715152204, 0.0721750036));
    } else {
      o0.w = r0.w;
    }
    r0.xyz = float3(12.9200001, 12.9200001, 12.9200001) * r1.xyz;
    r2.xyz = max(float3(1.1920929e-07, 1.1920929e-07, 1.1920929e-07), abs(r1.xyz));
    r2.xyz = log2(r2.xyz);
    r2.xyz = float3(0.416666657, 0.416666657, 0.416666657) * r2.xyz;
    r2.xyz = exp2(r2.xyz);
    r2.xyz = r2.xyz * float3(1.05499995, 1.05499995, 1.05499995) + float3(-0.0549999997, -0.0549999997, -0.0549999997);
    r1.xyz = cmp(float3(0.00313080009, 0.00313080009, 0.00313080009) >= r1.xyz);
    o0.xyz = r1.xyz ? r0.xyz : r2.xyz;
  }

  if (injectedData.toneMapType == 0.f) {
    o0.rgb = saturate(o0.rgb);
  }
  o0.w = r0.w;

  return;
}
