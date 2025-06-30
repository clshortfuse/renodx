#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.4.1 on Wed Apr  2 17:31:23 2025
Texture3D<float4> t5 : register(t5);

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s5_s : register(s5);

SamplerState s4_s : register(s4);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[43];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t1.Sample(s1_s, v1.xy).xyzw;
  r0.yz = v1.xy * float2(2,2) + float2(-1,-1);
  r0.w = dot(r0.yz, r0.yz);
  r0.yz = r0.yz * r0.ww;
  r0.yz = cb0[35].ww * r0.yz;
  r1.xy = cb0[31].zw * -r0.yz;
  r1.xy = float2(0.5,0.5) * r1.xy;
  r0.w = dot(r1.xy, r1.xy);
  r0.w = sqrt(r0.w);
  r0.w = (int)r0.w;
  r0.w = max(3, (int)r0.w);
  r0.w = min(16, (int)r0.w);
  r1.x = (int)r0.w;
  r0.yz = -r0.yz / r1.xx;
  r2.y = 0;
  r3.w = 1;
  r4.xyzw = float4(0,0,0,0);
  r5.xyzw = float4(0,0,0,0);
  r1.yz = v1.xy;
  r1.w = 0;
  while (true) {
    r2.z = cmp((int)r1.w >= (int)r0.w);
    if (r2.z != 0) break;
    r2.z = (int)r1.w;
    r2.z = 0.5 + r2.z;
    r2.x = r2.z / r1.x;
    r2.zw = saturate(r1.yz);
    r2.zw = cb0[26].xx * r2.zw;
    r6.xyzw = t0.SampleLevel(s0_s, r2.zw, 0).xyzw;
    r7.xyzw = t4.SampleLevel(s4_s, r2.xy, 0).xyzw;
    r3.xyz = r7.xyz;
    r4.xyzw = r6.xyzw * r3.xyzw + r4.xyzw;
    r5.xyzw = r5.xyzw + r3.xyzw;
    r1.yz = r1.yz + r0.yz;
    r1.w = (int)r1.w + 1;
  }
  r1.xyzw = r4.xyzw / r5.xyzw;
  r1.xyz = r1.xyz * r0.xxx;
  r0.xyzw = float4(-1,-1,1,1) * cb0[32].xyxy;
  r2.x = 0.5 * cb0[34].x;
  r3.xyzw = saturate(r0.xyzy * r2.xxxx + v1.xyxy);
  r3.xyzw = cb0[26].xxxx * r3.xyzw;
  r4.xyzw = t2.Sample(s2_s, r3.xy).xyzw;
  r3.xyzw = t2.Sample(s2_s, r3.zw).xyzw;
  r3.xyzw = r4.xyzw + r3.xyzw;
  r0.xyzw = saturate(r0.xwzw * r2.xxxx + v1.xyxy);
  r0.xyzw = cb0[26].xxxx * r0.xyzw;
  r2.xyzw = t2.Sample(s2_s, r0.xy).xyzw;
  r2.xyzw = r3.xyzw + r2.xyzw;
  r0.xyzw = t2.Sample(s2_s, r0.zw).xyzw;
  r0.xyzw = r2.xyzw + r0.xyzw;
  r0.xyzw = cb0[34].yyyy * r0.xyzw;

  r0.xyz *= CUSTOM_BLOOM;

  r2.xy = v1.xy * cb0[33].xy + cb0[33].zw;
  r2.xyzw = t3.Sample(s3_s, r2.xy).xyzw;
  r3.xyz = float3(0.25,0.25,0.25) * r0.xyz;
  r2.xyz = cb0[34].zzz * r2.xyz;
  r0.xyzw = float4(0.25,0.25,0.25,1) * r0.xyzw;
  r4.xyz = cb0[35].xyz * r0.xyz;
  r4.w = 0.25 * r0.w;
  r0.xyzw = r4.xyzw + r1.xyzw;
  r1.xyz = r2.xyz * r3.xyz;
  r1.w = 0;
  r0.xyzw = r1.xyzw + r0.xyzw;
  r0.xyzw = cb0[36].zzzz * r0.xyzw;

  float3 untonemapped = r0.rgb;

  //linear to log
  r0.xyz = r0.xyz * float3(5.55555582,5.55555582,5.55555582) + float3(0.0479959995,0.0479959995,0.0479959995);
  r0.xyz = log2(r0.xyz);
  r0.xyz = saturate(r0.xyz * float3(0.0734997839,0.0734997839,0.0734997839) + float3(0.386036009,0.386036009,0.386036009));
  r0.xyz = cb0[36].yyy * r0.xyz;
  r1.x = 0.5 * cb0[36].x;
  r0.xyz = r0.xyz * cb0[36].xxx + r1.xxx;
  r1.xyzw = t5.Sample(s5_s, r0.xyz).wxyz;
  r0.x = cmp(0.5 < cb0[42].x);
  if (r0.x != 0) {
    r0.xyz = saturate(r1.yzw);
    r1.x = dot(r0.xyz, float3(0.212672904,0.715152204,0.0721750036));
  } else {
    r1.x = r0.w;
  }
  o0.xyzw = r1.yzwx;

  float3 tonemapped_bt709 = o0.rgb;

  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.lut_sampler = s5_s;
  lut_config.strength = CUSTOM_LUT_STRENGTH;
  lut_config.scaling = CUSTOM_LUT_SCALING;
  lut_config.precompute = cb0[36].xyz;
  lut_config.tetrahedral = CUSTOM_LUT_TETRAHEDRAL == 1.f;
  lut_config.type_input = renodx::lut::config::type::ARRI_C1000_NO_CUT;
  lut_config.type_output = renodx::lut::config::type::LINEAR;

  o0.rgb = CustomTonemap(untonemapped, tonemapped_bt709, lut_config, t5);

  return;
}