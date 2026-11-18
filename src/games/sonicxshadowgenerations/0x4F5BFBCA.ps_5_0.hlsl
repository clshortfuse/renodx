#include "./shared.h" // RenoDX
// ---- Created with 3Dmigoto v1.3.16 on Wed Nov 18 12:43:26 2026

cbuffer cbTAA : register(b10)
{
  float4 u_taa_parameter[2] : packoffset(c0);
  float4 u_texture_info[2] : packoffset(c2);
  row_major float4x4 u_proj_matrix : packoffset(c4);
  row_major float4x4 u_reprojection_matrix : packoffset(c8);
  float4 u_gauss_kernel_2x2 : packoffset(c12);
  float4 u_gauss_kernel_3x3[3] : packoffset(c13);
  float4 u_debug : packoffset(c16);
}

SamplerState s_GBuffer4_sampler_s : register(s0);
SamplerState s_Scene_sampler_s : register(s1);
SamplerState s_Accumulate_sampler_s : register(s2);
SamplerState s_Depth_sampler_s : register(s3);
SamplerState s_Velocity_sampler_s : register(s4);
Texture2D<float4> s_GBuffer4_NedSmpignorenametexture : register(t0);
Texture2D<float4> s_Scene_NedSmpignorenametexture : register(t1);
Texture2D<float4> s_Accumulate : register(t2);
Texture2D<float4> s_Depth : register(t3);
Texture2D<float4> s_Velocity : register(t4);
Texture2D<uint2> s_Stencil : register(t5);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = -u_texture_info[1].xyxy + v1.xyxy;
  r1.xw = float2(0,0);
  r1.yz = u_texture_info[0].wz;
  r1.xy = r1.xy + r0.zw;
  r1.xy = r1.xy + r1.zw;
  r1.xyzw = s_Depth.Gather(s_Depth_sampler_s, r1.xy).xyzw;
  r2.x = cmp(r1.y < r1.x);
  r3.x = 1;
  r3.z = r1.y;
  r4.xy = float2(-1,1);
  r4.z = r1.x;
  r2.xyz = r2.xxx ? r3.xxz : r4.xyz;
  r2.w = cmp(r1.z < r2.z);
  r1.xy = float2(1,-1);
  r1.xyz = r2.www ? r1.xyz : r2.xyz;
  r1.z = cmp(r1.w < r1.z);
  r1.xy = r1.zz ? float2(-1,-1) : r1.xy;
  r1.xy = u_texture_info[0].zw * r1.xy + r0.zw;
  r1.zw = s_GBuffer4_NedSmpignorenametexture.Sample(s_GBuffer4_sampler_s, r1.xy).xy;
  r2.xyzw = s_Velocity.Gather(s_Velocity_sampler_s, r1.xy).xyzw;
  r1.x = r2.x + r2.y;
  r1.x = r1.x + r2.z;
  r1.x = r1.x + r2.w;
  r2.xyzw = -r1.xxxx * float4(0.25,0.25,0.25,0.25) + r2.xyzw;
  r1.x = dot(r2.xyzw, r2.xyzw);
  r1.x = r1.x * 0.25 + -u_taa_parameter[1].x;
  r1.x = saturate(r1.x / u_taa_parameter[1].z);
  r1.y = -u_taa_parameter[1].w + u_taa_parameter[0].z;
  r1.y = r1.x * r1.y + u_taa_parameter[1].w;
  r2.xy = u_texture_info[0].zw * r1.zw;
  r2.xy = v1.xy * u_texture_info[1].zw + -r2.xy;
  r3.xyz = s_Scene_NedSmpignorenametexture.Sample(s_Scene_sampler_s, r0.zw).xyz;
  r2.zw = float2(0.25,0.5) * r3.xy;
  r2.z = r2.z + r2.w;
  r4.x = r3.z * 0.25 + r2.z;
  r2.z = 0.5 * r3.z;
  r4.y = r3.x * 0.5 + -r2.z;
  r2.z = r3.x * -0.25 + r2.w;
  r4.z = -r3.z * 0.25 + r2.z;
  r2.xyzw = s_Accumulate.Sample(s_Accumulate_sampler_s, r2.xy).xyzw;
  r3.xy = float2(0.25,0.5) * r2.xy;
  r2.y = r3.x + r3.y;
  r5.x = r2.z * 0.25 + r2.y;
  r2.y = 0.5 * r2.z;
  r5.y = r2.x * 0.5 + -r2.y;
  r2.x = r2.x * -0.25 + r3.y;
  r5.z = -r2.z * 0.25 + r2.x;
  r2.xy = -u_texture_info[0].zw + r0.zw;
  r2.xyz = s_Scene_NedSmpignorenametexture.Sample(s_Scene_sampler_s, r2.xy).xyz;
  r3.xy = float2(0.25,0.5) * r2.xy;
  r2.y = r3.x + r3.y;
  r6.x = r2.z * 0.25 + r2.y;
  r2.y = 0.5 * r2.z;
  r6.y = r2.x * 0.5 + -r2.y;
  r2.x = r2.x * -0.25 + r3.y;
  r6.z = -r2.z * 0.25 + r2.x;
  r3.xyzw = u_texture_info[0].zwzw * float4(0,-1,1,-1) + r0.zwzw;
  r2.xyz = s_Scene_NedSmpignorenametexture.Sample(s_Scene_sampler_s, r3.xy).xyz;
  r3.xy = float2(0.25,0.5) * r2.xy;
  r2.y = r3.x + r3.y;
  r7.x = r2.z * 0.25 + r2.y;
  r2.y = 0.5 * r2.z;
  r7.y = r2.x * 0.5 + -r2.y;
  r2.x = r2.x * -0.25 + r3.y;
  r7.z = -r2.z * 0.25 + r2.x;
  r2.xyz = s_Scene_NedSmpignorenametexture.Sample(s_Scene_sampler_s, r3.zw).xyz;
  r3.xy = float2(0.25,0.5) * r2.xy;
  r2.y = r3.x + r3.y;
  r8.x = r2.z * 0.25 + r2.y;
  r2.y = 0.5 * r2.z;
  r8.y = r2.x * 0.5 + -r2.y;
  r2.x = r2.x * -0.25 + r3.y;
  r8.z = -r2.z * 0.25 + r2.x;
  r3.xyzw = u_texture_info[0].zwzw * float4(-1,0,1,0) + r0.zwzw;
  r2.xyz = s_Scene_NedSmpignorenametexture.Sample(s_Scene_sampler_s, r3.xy).xyz;
  r3.xy = float2(0.25,0.5) * r2.xy;
  r2.y = r3.x + r3.y;
  r9.x = r2.z * 0.25 + r2.y;
  r2.y = 0.5 * r2.z;
  r9.y = r2.x * 0.5 + -r2.y;
  r2.x = r2.x * -0.25 + r3.y;
  r9.z = -r2.z * 0.25 + r2.x;
  r2.xyz = s_Scene_NedSmpignorenametexture.Sample(s_Scene_sampler_s, r3.zw).xyz;
  r3.xy = float2(0.25,0.5) * r2.xy;
  r2.y = r3.x + r3.y;
  r10.x = r2.z * 0.25 + r2.y;
  r2.y = 0.5 * r2.z;
  r10.y = r2.x * 0.5 + -r2.y;
  r2.x = r2.x * -0.25 + r3.y;
  r10.z = -r2.z * 0.25 + r2.x;
  r3.xyzw = u_texture_info[0].zwzw * float4(-1,1,0,1) + r0.zwzw;
  r2.xyz = s_Scene_NedSmpignorenametexture.Sample(s_Scene_sampler_s, r3.xy).xyz;
  r3.xy = float2(0.25,0.5) * r2.xy;
  r2.y = r3.x + r3.y;
  r11.x = r2.z * 0.25 + r2.y;
  r2.y = 0.5 * r2.z;
  r11.y = r2.x * 0.5 + -r2.y;
  r2.x = r2.x * -0.25 + r3.y;
  r11.z = -r2.z * 0.25 + r2.x;
  r2.xyz = s_Scene_NedSmpignorenametexture.Sample(s_Scene_sampler_s, r3.zw).xyz;
  r3.xy = float2(0.25,0.5) * r2.xy;
  r2.y = r3.x + r3.y;
  r12.x = r2.z * 0.25 + r2.y;
  r2.y = 0.5 * r2.z;
  r12.y = r2.x * 0.5 + -r2.y;
  r2.x = r2.x * -0.25 + r3.y;
  r12.z = -r2.z * 0.25 + r2.x;
  r2.xy = u_texture_info[0].zw + r0.zw;
  r2.xyz = s_Scene_NedSmpignorenametexture.Sample(s_Scene_sampler_s, r2.xy).xyz;
  r3.xy = float2(0.25,0.5) * r2.xy;
  r2.y = r3.x + r3.y;
  r13.x = r2.z * 0.25 + r2.y;
  r2.y = 0.5 * r2.z;
  r13.y = r2.x * 0.5 + -r2.y;
  r2.x = r2.x * -0.25 + r3.y;
  r13.z = -r2.z * 0.25 + r2.x;
  r2.xyz = r9.xyz + r7.xyz;
  r2.xyz = r2.xyz + r10.xyz;
  r2.xyz = r2.xyz + r12.xyz;
  r2.xyz = float3(0.125,0.125,0.125) * r2.xyz;
  r2.xyz = r4.xyz * float3(0.25,0.25,0.25) + r2.xyz;
  r3.xyz = r8.xyz + r6.xyz;
  r3.xyz = r3.xyz + r11.xyz;
  r3.xyz = r3.xyz + r13.xyz;
  r2.xyz = r3.xyz * float3(0.0625,0.0625,0.0625) + r2.xyz;
  r3.xyz = r7.xyz + r6.xyz;
  r3.xyz = r3.xyz + r8.xyz;
  r3.xyz = r3.xyz + r9.xyz;
  r3.xyz = r3.xyz + r4.xyz;
  r3.xyz = r3.xyz + r10.xyz;
  r3.xyz = r3.xyz + r11.xyz;
  r3.xyz = r3.xyz + r12.xyz;
  r3.xyz = r3.xyz + r13.xyz;
  r6.xyz = -r3.xyz * float3(0.111111112,0.111111112,0.111111112) + r6.xyz;
  r7.xyz = -r3.xyz * float3(0.111111112,0.111111112,0.111111112) + r7.xyz;
  r8.xyz = -r3.xyz * float3(0.111111112,0.111111112,0.111111112) + r8.xyz;
  r9.xyz = -r3.xyz * float3(0.111111112,0.111111112,0.111111112) + r9.xyz;
  r14.xyz = -r3.xyz * float3(0.111111112,0.111111112,0.111111112) + r4.xyz;
  r10.xyz = -r3.xyz * float3(0.111111112,0.111111112,0.111111112) + r10.xyz;
  r11.xyz = -r3.xyz * float3(0.111111112,0.111111112,0.111111112) + r11.xyz;
  r12.xyz = -r3.xyz * float3(0.111111112,0.111111112,0.111111112) + r12.xyz;
  r13.xyz = -r3.xyz * float3(0.111111112,0.111111112,0.111111112) + r13.xyz;
  r7.xyz = r7.xyz * r7.xyz;
  r6.xyz = r6.xyz * r6.xyz + r7.xyz;
  r6.xyz = r8.xyz * r8.xyz + r6.xyz;
  r6.xyz = r9.xyz * r9.xyz + r6.xyz;
  r6.xyz = r14.xyz * r14.xyz + r6.xyz;
  r6.xyz = r10.xyz * r10.xyz + r6.xyz;
  r6.xyz = r11.xyz * r11.xyz + r6.xyz;
  r6.xyz = r12.xyz * r12.xyz + r6.xyz;
  r6.xyz = r13.xyz * r13.xyz + r6.xyz;
  r6.xyz = float3(0.111111112,0.111111112,0.111111112) * r6.xyz;
  r6.xyz = sqrt(r6.xyz);
  r6.xyz = r6.xyz * r1.yyy;
  r7.xyz = r3.xyz * float3(0.111111112,0.111111112,0.111111112) + -r6.xyz;
  r3.xyz = r3.xyz * float3(0.111111112,0.111111112,0.111111112) + r6.xyz;
  r6.xyz = r3.xyz + r7.xyz;
  r6.xyz = float3(0.5,0.5,0.5) * r6.xyz;
  r3.xyz = r3.xyz + -r7.xyz;
  r3.xyz = float3(0.5,0.5,0.5) * r3.xyz;
  r6.w = 1;
  r5.w = r2.w;
  r7.xyzw = -r6.xyzw + r5.xyzw;
  r3.xyz = r7.xyz / r3.xyz;
  r1.y = max(abs(r3.y), abs(r3.z));
  r1.y = max(abs(r3.x), r1.y);
  r2.w = cmp(1 < r1.y);
  r3.xyzw = r7.xyzw / r1.yyyy;
  r3.xyzw = r6.xyzw + r3.xyzw;
  r3.xyzw = r2.wwww ? r3.xyzw : r5.xyzw;
  r5.xy = r0.zw / u_texture_info[0].zw;
  r5.xy = (uint2)r5.xy;
  r1.y = (uint)u_taa_parameter[0].w;
  r5.zw = float2(0,0);
  r2.w = s_Stencil.Load(r5.xyz).y;
  r2.w = cmp((int)r1.y != (int)r2.w);
  if (r2.w != 0) {
    r5.xy = (uint2)r5.xy;
    r5.zw = float2(1,1) + r5.xy;
    r6.xy = (uint2)r5.zw;
    r6.zw = float2(0,0);
    r2.w = s_Stencil.Load(r6.xyz).y;
    r2.w = cmp((int)r1.y != (int)r2.w);
    if (r2.w != 0) {
      r5.zw = float2(-1,1) + r5.xy;
      r6.xy = (uint2)r5.zw;
      r6.zw = float2(0,0);
      r2.w = s_Stencil.Load(r6.xyz).y;
      r2.w = cmp((int)r1.y != (int)r2.w);
      if (r2.w != 0) {
        r5.zw = float2(1,-1) + r5.xy;
        r6.xy = (uint2)r5.zw;
        r6.zw = float2(0,0);
        r2.w = s_Stencil.Load(r6.xyz).y;
        r2.w = cmp((int)r1.y != (int)r2.w);
        if (r2.w != 0) {
          r5.xy = float2(-1,-1) + r5.xy;
          r5.xy = (uint2)r5.xy;
          r5.zw = float2(0,0);
          r2.w = s_Stencil.Load(r5.xyz).y;
          r1.y = cmp((int)r1.y == (int)r2.w);
        } else {
          r1.y = -1;
        }
      } else {
        r1.y = -1;
      }
    } else {
      r1.y = -1;
    }
  } else {
    r1.y = -1;
  }
  if (r1.y != 0) {
    r5.xyzw = u_texture_info[0].zwzw * float4(-1.5,-1.5,1.5,-1.5) + r0.zwzw;
    r5.xy = s_Velocity.SampleLevel(s_Accumulate_sampler_s, r5.xy, 0).xy;
    r5.zw = s_Velocity.SampleLevel(s_Accumulate_sampler_s, r5.zw, 0).xy;
    r0.xyzw = u_texture_info[0].zwzw * float4(-1.5,1.5,1.5,1.5) + r0.xyzw;
    r0.xy = s_Velocity.SampleLevel(s_Accumulate_sampler_s, r0.xy, 0).xy;
    r0.zw = s_Velocity.SampleLevel(s_Accumulate_sampler_s, r0.zw, 0).xy;
    r1.z = dot(r1.zw, r1.zw);
    r1.w = dot(r5.xy, r5.xy);
    r2.w = dot(r5.zw, r5.zw);
    r1.w = max(r2.w, r1.w);
    r0.x = dot(r0.xy, r0.xy);
    r0.y = dot(r0.zw, r0.zw);
    r0.x = max(r0.x, r0.y);
    r0.x = max(r1.w, r0.x);
    r0.x = max(r1.z, r0.x);
    r0.x = sqrt(r0.x);
    r0.x = 0.5 * r0.x;
    r0.x = min(1, r0.x);
    r0.yzw = r2.xyz + -r4.xyz;
    r4.xyz = r0.xxx * r0.yzw + r4.xyz;
  } else {
    r0.x = saturate(r1.x * u_taa_parameter[0].y + u_taa_parameter[0].x);
    r0.yzw = -r3.xyz + r2.xyz;
    r3.xyz = r3.www * r0.yzw + r3.xyz;
  }
  r0.yzw = r4.xyz + -r3.xyz;
  r0.xyz = r0.xxx * r0.yzw + r3.xyz;
  // The original writes the bit pattern of 1.0 as the history weight.
  o0.w = asfloat((int)r1.y & 0x3f800000);
  r1.yz = r0.xx + r0.yz;
  r1.x = r1.y + -r0.z;
  r0.x = r0.x + -r0.y;
  r1.w = r0.x + -r0.z;
  o0.xyz = max(0, r1.xzw); // RenoDX: was saturate (10-bit UNORM clamp)
  return;
}
