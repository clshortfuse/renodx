#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Thu Feb 06 03:59:15 2025
Texture2D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s4_s : register(s4);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1)
{
  float4 cb1[7];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[17];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  float2 v2 : TEXCOORD2,
  float2 w2 : TEXCOORD3,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s1_s, v1.xy).xyzw;
  r0.yz = v1.xy * float2(2,2) + float2(-1,-1);
  r0.w = dot(r0.yz, r0.yz);
  r0.yz = r0.yz * r0.ww;
  r0.yz = cb0[7].xx * r0.yz;
  r1.xy = cb0[2].zw * -r0.yz;
  r1.xy = float2(0.5,0.5) * r1.xy;
  r0.w = dot(r1.xy, r1.xy);
  r0.w = sqrt(r0.w);
  r0.w = (int)r0.w;
  r0.w = max(3, (int)r0.w);
  r0.w = min(16, (int)r0.w);
  r1.x = (int)r0.w;
  r0.yz = -r0.yz / r1.xx;
  r2.yw = float2(0,0);
  r1.yzw = float3(0,0,0);
  r4.xy = v1.xy;
  r3.xyzw = float4(0,0,0,0);
  while (true) {
    r4.z = cmp((int)r3.w >= (int)r0.w);
    if (r4.z != 0) break;
    r4.z = (int)r3.w;
    r4.z = 0.5 + r4.z;
    r2.x = r4.z / r1.x;
    r4.zw = r4.xy * cb0[3].xy + cb0[3].zw;
    r5.xyzw = t1.SampleLevel(s0_s, r4.zw, 0).xyzw;
    r6.xyzw = t2.SampleLevel(s2_s, r2.xy, 0).xyzw;
    r1.yzw = r5.zxy * r6.zxy + r1.yzw;
    r3.xyz = r6.zxy + r3.xyz;
    r4.xy = r4.xy + r0.yz;
    r3.w = (int)r3.w + 1;
  }
  r0.yzw = r1.yzw / r3.xyz;
  r1.xyzw = float4(1,1,-1,0) * cb0[10].xyxy;

  // r3.xyzw = -r1.xywy * cb0[11].xxxx + w2.xyzw; //3dmigoto error
  r3.xyzw = -r1.xywy * cb0[11].xxxx + w2.xyxy;

  r4.xyzw = t3.Sample(s3_s, r3.xy).xyzw;
  r3.xyzw = t3.Sample(s3_s, r3.zw).xyzw;
  r3.xyz = r3.zxy * float3(2,2,2) + r4.zxy;
  r2.xy = -r1.zy * cb0[11].xx + w2.xy;
  r4.xyzw = t3.Sample(s3_s, r2.xy).xyzw;
  r3.xyz = r4.zxy + r3.xyz;

  //r4.xyzw = r1.zwxw * cb0[11].xxxx + w2.xyzw;  //3dmigoto error
  r4.xyzw = r1.zwxw * cb0[11].xxxx + w2.xyxy;

  r5.xyzw = t3.Sample(s3_s, r4.xy).xyzw;
  r3.xyz = r5.zxy * float3(2,2,2) + r3.xyz;
  r5.xyzw = t3.Sample(s3_s, w2.xy).xyzw;
  r3.xyz = r5.zxy * float3(4,4,4) + r3.xyz;
  r4.xyzw = t3.Sample(s3_s, r4.zw).xyzw;
  r3.xyz = r4.zxy * float3(2,2,2) + r3.xyz;

  //r4.xyzw = r1.zywy * cb0[11].xxxx + w2.xyzw;  // 3dmigoto error
  r4.xyzw = r1.zywy * cb0[11].xxxx + w2.xyxy;

  r5.xyzw = t3.Sample(s3_s, r4.xy).xyzw;
  r3.xyz = r5.zxy + r3.xyz;
  r4.xyzw = t3.Sample(s3_s, r4.zw).xyzw;
  r3.xyz = r4.zxy * float3(2,2,2) + r3.xyz;
  r1.xy = r1.xy * cb0[11].xx + w2.xy;
  r1.xyzw = t3.Sample(s3_s, r1.xy).xyzw;
  r1.xyz = r3.xyz + r1.zxy;
  r1.xyz = cb0[11].yyy * r1.xyz;
  r1.xyz = float3(0.0625,0.0625,0.0625) * r1.xyz;
  r0.xyz = r0.yzw * r0.xxx + r1.xyz;
  r1.xy = -cb0[15].xy + v1.xy;
  r1.xy = cb0[16].xx * abs(r1.xy);
  r0.w = cb1[6].x / cb1[6].y;
  r0.w = -1 + r0.w;
  r0.w = cb0[16].w * r0.w + 1;
  r0.w = r1.x * r0.w;
  r2.x = log2(r0.w);
  r2.y = log2(r1.y);
  r1.xy = cb0[16].zz * r2.xy;
  r1.xy = exp2(r1.xy);
  r0.w = dot(r1.xy, r1.xy);
  r0.w = 1 + -r0.w;
  r0.w = max(0, r0.w);
  r0.w = log2(r0.w);
  r0.w = cb0[16].y * r0.w;
  r0.w = exp2(r0.w);
  r1.xyz = float3(1,1,1) + -cb0[14].zxy;
  r1.xyz = r0.www * r1.xyz + cb0[14].zxy;
  r0.xyz = r1.xyz * r0.xyz;
  r0.xyz = cb0[12].www * r0.xyz;

  float3 untonemapped = r0.gbr;

  //linear to log
  r0.xyz = r0.xyz * float3(5.55555582,5.55555582,5.55555582) + float3(0.0479959995,0.0479959995,0.0479959995);
  r0.xyz = log2(r0.xyz);
  r0.xyz = saturate(r0.xyz * float3(0.0734997839,0.0734997839,0.0734997839) + float3(0.386036009,0.386036009,0.386036009));

  r0.yzw = cb0[12].zzz * r0.xyz;
  r0.y = floor(r0.y);
  r1.xy = float2(0.5,0.5) * cb0[12].xy;
  r1.yz = r0.zw * cb0[12].xy + r1.xy;
  r1.x = r0.y * cb0[12].y + r1.y;
  r3.xyzw = t4.Sample(s4_s, r1.xz).xyzw;
  r2.z = cb0[12].y;
  r0.zw = r1.xz + r2.zw;
  r1.xyzw = t4.Sample(s4_s, r0.zw).xyzw;
  r0.x = r0.x * cb0[12].z + -r0.y;
  r0.yzw = r1.xyz + -r3.xyz;

  o0.xyz = saturate(r0.xxx * r0.yzw + r3.xyz);
  //o0.xyz = r0.xxx * r0.yzw + r3.xyz;

  o0.w = 1;

  float3 tonemapped_bt709 = o0.rgb;

  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.lut_sampler = s4_s;
  lut_config.strength = CUSTOM_LUT_STRENGTH;
  lut_config.scaling = CUSTOM_LUT_SCALING;
  lut_config.precompute = cb0[12].xyz;
  lut_config.tetrahedral = CUSTOM_LUT_TETRAHEDRAL == 1.f;
  lut_config.type_input = renodx::lut::config::type::ARRI_C1000_NO_CUT;
  lut_config.type_output = renodx::lut::config::type::LINEAR;

  float3 outputColor;
  // if (RENODX_TONE_MAP_TYPE == 0.f) {
  //   outputColor = saturate(tonemapped_bt709);
  // } else {
  //   if (CUSTOM_TONE_MAP_CONFIGURATION == 1.f) {
  //     outputColor = renodx::draw::ToneMapPass(
  //         untonemapped,
  //         tonemapped_bt709);
  //   }
  //   else {
  //     outputColor = renodx::draw::ToneMapPass(untonemapped, saturate(tonemapped_bt709));
  //   }
  // }

  if (RENODX_TONE_MAP_TYPE == 0.f) {
    outputColor = tonemapped_bt709;
  } else {
    outputColor = renodx::draw::ToneMapPass(
        untonemapped,
        renodx::lut::Sample(
            renodx::tonemap::renodrt::NeutralSDR(untonemapped),
            lut_config,
            t4));
  }

  o0.rgb = renodx::draw::RenderIntermediatePass(outputColor);
  return;
}