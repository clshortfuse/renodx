#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.4.1 on Thu Mar 27 16:53:06 2025
Texture2D<float4> t7 : register(t7);

Texture2D<float4> t6 : register(t6);

Texture2D<float4> t5 : register(t5);

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s7_s : register(s7);

SamplerState s6_s : register(s6);

SamplerState s5_s : register(s5);

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
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s1_s, v1.xy).xyzw;
  r0.yz = v1.xy * float2(2,2) + float2(-1,-1);
  r0.w = dot(r0.yz, r0.yz);
  r0.yz = r0.yz * r0.ww;
  r0.yz = cb0[7].xx * r0.yz;

  r0.yz *= CUSTOM_CHROMATIC_ABERRATION;

  r1.xy = cb0[2].zw * -r0.yz;
  r1.xy = float2(0.5,0.5) * r1.xy;
  r0.w = dot(r1.xy, r1.xy);
  r0.w = sqrt(r0.w);
  r0.w = (int)r0.w;
  r0.w = max(3, (int)r0.w);
  r0.w = min(16, (int)r0.w);
  r1.w = (int)r0.w;
  r2.xy = -r0.yz / r1.ww;
  r0.y = cmp(cb0[2].y < 0);
  r3.x = -r2.y;
  r3.y = 1 + -v1.y;
  r2.z = v1.y;
  r0.yz = r0.yy ? r3.xy : r2.yz;
  r2.z = cb0[2].y + cb0[2].y;
  r3.x = 1 / r2.z;
  r4.yw = float2(0,0);
  r5.w = 1;
  r2.w = r0.y;
  r6.xyzw = float4(0,0,0,0);
  r3.yzw = float3(0,0,0);
  r1.xyz = float3(0,0,0);
  r7.xy = v1.xy;
  r8.x = v1.x;
  r8.y = r0.z;
  r0.y = 0;
  r7.z = 0;
  while (true) {
    r7.w = cmp((int)r7.z >= (int)r0.w);
    if (r7.w != 0) break;
    r7.w = (int)r7.z;
    r7.w = 0.5 + r7.w;
    r4.x = r7.w / r1.w;
    r8.zw = r7.xy * cb0[3].xy + cb0[3].zw;
    r9.xyzw = t1.SampleLevel(s0_s, r8.zw, 0).xyzw;
    r10.xyzw = t2.SampleLevel(s2_s, r4.xy, 0).xyzw;
    r3.yzw = r9.zxy * r10.zxy + r3.yzw;
    r1.xyz = r10.xyz + r1.xyz;
    r7.xy = r7.xy + r2.xy;
    r8.zw = r8.xy * cb0[3].xy + cb0[3].zw;
    r9.xyzw = t3.SampleLevel(s3_s, r8.zw, 0).xyzw;
    r11.xyzw = t4.SampleLevel(s4_s, r8.zw, 0).xyzw;
    r4.x = -0.5 + r11.x;
    r4.x = r4.x + r4.x;
    r5.xyz = r10.xyz;
    r6.xyzw = r9.xyzw * r5.xyzw + r6.xyzw;
    r4.x = r4.x * cb0[9].z + -r2.z;
    r4.x = saturate(r4.x * r3.x);
    r5.x = r4.x * -2 + 3;
    r4.x = r4.x * r4.x;
    r0.y = r5.x * r4.x + r0.y;
    r8.xy = r8.xy + r2.xw;
    r7.z = (int)r7.z + 1;
  }
  r2.xyz = r3.yzw / r1.zxy;
  r3.xyzw = r6.xyzw / r1.xyzw;
  r0.y = r0.y / r1.w;
  r1.xyz = r2.xyz * r0.xxx;
  r0.z = r0.y + r3.w;
  r0.y = -r0.y * r3.w + r0.z;
  r0.xzw = r3.zxy * r0.xxx + -r1.xyz;
  //r0.xyz = r0.yyy * r0.xzw + r1.xyz;

  r0.xyz = r0.yyy * r0.xzw * CUSTOM_DOF + r1.xyz;

  r1.xyzw = float4(1,1,-1,0) * cb0[10].xyxy;
  r2.xyzw = -r1.xywy * cb0[11].xxxx + w2.xyxy;
  r3.xyzw = t5.Sample(s5_s, r2.xy).xyzw;
  r2.xyzw = t5.Sample(s5_s, r2.zw).xyzw;
  r2.xyz = r2.zxy * float3(2,2,2) + r3.zxy;
  r3.xy = -r1.zy * cb0[11].xx + w2.xy;
  r3.xyzw = t5.Sample(s5_s, r3.xy).xyzw;
  r2.xyz = r3.zxy + r2.xyz;
  r3.xyzw = r1.zwxw * cb0[11].xxxx + w2.xyxy;
  r5.xyzw = t5.Sample(s5_s, r3.xy).xyzw;
  r2.xyz = r5.zxy * float3(2,2,2) + r2.xyz;
  r5.xyzw = t5.Sample(s5_s, w2.xy).xyzw;
  r2.xyz = r5.zxy * float3(4,4,4) + r2.xyz;
  r3.xyzw = t5.Sample(s5_s, r3.zw).xyzw;
  r2.xyz = r3.zxy * float3(2,2,2) + r2.xyz;
  r3.xyzw = r1.zywy * cb0[11].xxxx + w2.xyxy;
  r5.xyzw = t5.Sample(s5_s, r3.xy).xyzw;
  r2.xyz = r5.zxy + r2.xyz;
  r3.xyzw = t5.Sample(s5_s, r3.zw).xyzw;
  r2.xyz = r3.zxy * float3(2,2,2) + r2.xyz;
  r1.xy = r1.xy * cb0[11].xx + w2.xy;
  r1.xyzw = t5.Sample(s5_s, r1.xy).xyzw;
  r1.xyz = r2.xyz + r1.zxy;
  r1.xyz = cb0[11].yyy * r1.xyz;

  r1.xyz *= CUSTOM_BLOOM;

  r2.xyz = float3(0.0625,0.0625,0.0625) * r1.xyz;
  r0.xyz = r1.xyz * float3(0.0625,0.0625,0.0625) + r0.xyz;
  r1.xyzw = t6.Sample(s6_s, v2.xy).xyzw;
  r1.xyz = cb0[11].zzz * r1.zxy;
  r0.xyz = r2.xyz * r1.xyz + r0.xyz;
  r1.xy = -cb0[15].xy + v1.xy;
  r1.xy = cb0[16].xx * abs(r1.xy);
  r0.w = cb1[6].x / cb1[6].y;
  r0.w = -1 + r0.w;
  r0.w = cb0[16].w * r0.w + 1;
  r0.w = r1.x * r0.w;
  r2.x = log2(r0.w);
  r2.y = log2(r1.y);
  r1.xy = cb0[16].zz * r2.xy;

  r1.xy /= CUSTOM_VIGNETTE;

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

  float3 untonemapped = r0.yzx;

  //linear to log
  r0.xyz = r0.xyz * float3(5.55555582,5.55555582,5.55555582) + float3(0.0479959995,0.0479959995,0.0479959995);
  r0.xyz = log2(r0.xyz);
  r0.xyz = saturate(r0.xyz * float3(0.0734997839,0.0734997839,0.0734997839) + float3(0.386036009,0.386036009,0.386036009));

  //tonemapping
  r0.yzw = cb0[12].zzz * r0.xyz;
  r0.y = floor(r0.y);
  r1.xy = float2(0.5,0.5) * cb0[12].xy;
  r1.yz = r0.zw * cb0[12].xy + r1.xy;
  r1.x = r0.y * cb0[12].y + r1.y;
  r2.xyzw = t7.Sample(s7_s, r1.xz).xyzw;
  r4.z = cb0[12].y;
  r0.zw = r1.xz + r4.zw;
  r1.xyzw = t7.Sample(s7_s, r0.zw).xyzw;
  r0.x = r0.x * cb0[12].z + -r0.y;
  r0.yzw = r1.xyz + -r2.xyz;
  //o0.xyz = saturate(r0.xxx * r0.yzw + r2.xyz);
  o0.xyz = r0.xxx * r0.yzw + r2.xyz;
  o0.w = 1;

  float3 tonemapped_bt709 = o0.xyz;

  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.lut_sampler = s7_s;
  lut_config.strength = CUSTOM_LUT_STRENGTH;
  lut_config.scaling = CUSTOM_LUT_SCALING;
  lut_config.precompute = cb0[12].xyz;
  lut_config.tetrahedral = CUSTOM_LUT_TETRAHEDRAL == 1.f;
  lut_config.type_input = renodx::lut::config::type::ARRI_C1000_NO_CUT;
  lut_config.type_output = renodx::lut::config::type::LINEAR;

  o0.rgb = CustomTonemap(untonemapped, tonemapped_bt709, lut_config, t7);
  return;
}