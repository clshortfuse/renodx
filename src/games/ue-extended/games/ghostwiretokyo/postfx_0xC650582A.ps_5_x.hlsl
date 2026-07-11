// Ghostwire tokyo etc post effect
// Game render needs to go PQ to sRGB, and then output back to PQ

#include "../postfx.hlsli"

// ---- Created with 3Dmigoto v1.3.16 on Sun Apr 12 00:28:15 2026
Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2) {
  float4 cb2[36];
}

cbuffer cb1 : register(b1) {
  float4 cb1[143];
}

cbuffer cb0 : register(b0) {
  float4 cb0[39];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float4 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4, r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = asuint(cb0[37].xy);
  r0.xy = v0.xy + -r0.xy;
  r0.zw = cb0[38].zw * r0.xy;
  r1.xy = r0.zw * cb0[5].xy + cb0[4].xy;
  r1.xyz = t3.Sample(s3_s, r1.xy).xyz;  // Game Render

  if (PROCESSING_PATH == 0.f) {
    // Convert PQ -> sRGB
    r1.rgb = ConvertPQToSRGB(r1.rgb);
  }

  r1.w = cb2[17].z * cb1[142].z;
  r1.w = cb2[17].w * r1.w;
  r1.w = floor(r1.w);
  r1.w = r1.w / cb2[17].w;
  r2.xy = cb2[18].xy * r0.zw;
  r2.xy = ceil(r2.xy);
  r2.xy = r2.xy / cb2[18].xy;
  r3.x = r2.x * cb2[18].z + r1.w;
  r1.w = cb2[18].w * cb1[142].z;
  r1.w = cb2[17].w * r1.w;
  r1.w = floor(r1.w);
  r1.w = r1.w / cb2[17].w;
  r3.y = r2.y * cb2[19].x + r1.w;
  r1.w = t0.Sample(s0_s, r3.xy).x;
  r2.zw = cb2[19].yz * cb1[142].zz;
  r2.zw = float2(6.28318548, 6.28318548) * r2.zw;
  r2.zw = sin(r2.zw);
  r2.z = r2.z * r2.w;
  r2.z = max(0, r2.z);
  r2.z = cmp(r2.z >= cb2[20].y);
  r2.z = r2.z ? cb2[19].w : cb2[20].x;
  r1.w = -cb2[20].z * r2.z + r1.w;
  r1.w = saturate(cb2[20].w + r1.w);
  r3.xy = cb2[21].xz * cb1[142].zz;
  r3.xy = cb2[17].ww * r3.xy;
  r3.xy = floor(r3.xy);
  r3.xy = r3.xy / cb2[17].ww;
  r2.xy = r2.xy * cb2[21].yw + r3.xy;
  r2.x = t1.Sample(s1_s, r2.xy).x;
  r2.x = -cb2[20].z * r2.z + r2.x;
  r1.w = r2.x * r1.w;
  r2.x = r1.w * cb2[22].z + r0.z;
  r2.y = r1.w * cb2[23].x + r0.w;
  r1.w = -2 + cb2[23].w;
  r1.w = cb2[23].z * r1.w + 2;
  r2.z = -1.10000002 + cb2[24].x;
  r2.z = cb2[23].z * r2.z + 1.10000002;
  r0.xy = r0.xy * cb0[38].zw + float2(-0.5, -0.5);
  r0.xy = cb2[2].xy * r0.xy;
  r0.x = dot(r0.xy, r0.xy);
  r0.x = sqrt(r0.x);
  r0.x = r0.x + -r1.w;
  r0.y = r2.z + -r1.w;
  r0.x = saturate(r0.x / r0.y);
  r0.y = r0.x * r0.x;
  r0.x = -r0.x * 2 + 3;
  r0.x = r0.y * r0.x;
  r0.x = min(1, r0.x);
  r2.zw = float2(-0.5, -0.5) + r2.xy;
  r0.y = -1 + cb2[26].y;
  r3.xyz = float3(0, 0, 0);
  r1.w = 0;
  while (true) {
    r3.w = (int)r1.w;
    r4.x = cmp(r3.w >= cb2[26].y);
    if (r4.x != 0) break;
    r3.w = r3.w / r0.y;
    r4.xyzw = cb2[5].yyww * r3.wwww + cb2[5].yyzz;
    r3.w = cb2[6].y * r3.w + cb2[6].x;
    r4.xyzw = r2.zwzw * r4.xyzw + float4(0.5, 0.5, 0.5, 0.5);
    r5.xyzw = -r4.xyzw + r2.xyxy;
    r4.xyzw = r0.xxxx * r5.xyzw + r4.xyzw;
    r5.xy = r2.zw * r3.ww + float2(0.5, 0.5);
    r5.zw = -r5.xy + r2.xy;
    r5.xy = r0.xx * r5.zw + r5.xy;
    r4.xyzw = r4.xyzw * cb0[5].xyxy + cb0[4].xyxy;

    // The scene's channel's get sampled individually
    // But the math is spread out
    // So we sample every ch individually, create a float3
    // Convert the float3 from PQ to sRGB
    // And then swap out the samples with our sRGB color

    float wide_render_x = t3.Sample(s3_s, r4.xy).x;
    float wide_render_y = t3.Sample(s3_s, r4.zw).y;
    float wide_render_z = t3.Sample(s3_s, r4.xy).z;
    float3 wide_render = float3(wide_render_x, wide_render_y, wide_render_z);

    if (PROCESSING_PATH == 0.f) {
      // Convert PQ -> sRGB
      wide_render = ConvertPQToSRGB(wide_render);
    }

    // r3.w = t3.Sample(s3_s, r4.xy).x;  // Wide Game Render (single ch)
    r3.w = wide_render.x;

    r3.x = r3.x + r3.w;

    // r3.w = t3.Sample(s3_s, r4.zw).y;  // Wide Game Render (single ch)
    r3.w = wide_render.y;

    r3.y = r3.y + r3.w;
    r4.xy = r5.xy * cb0[5].xy + cb0[4].xy;

    // r3.w = t3.Sample(s3_s, r4.xy).z;  // Wide Game Render (single ch)
    r3.w = wide_render.z;

    r3.z = r3.z + r3.w;
    r1.w = (int)r1.w + 1;
  }
  r2.xyz = r3.xyz / cb2[26].yyy;
  r0.y = cb2[26].z * cb1[142].z;
  r3.xy = float2(8, 0.300000012) * r0.yy;
  r3.xy = floor(r3.xy);
  r3.xy = r3.xy / cb2[26].zz;
  r0.yz = r0.zw * float2(8, 6) + r3.xy;
  r0.yzw = t2.Sample(s2_s, r0.yz).xyz;
  r0.yzw = float3(-1, -1, -1) + r0.yzw;
  r0.yzw = cb2[26].www * r0.yzw + float3(1, 1, 1);
  r0.yzw = r2.xyz * r0.yzw;
  r0.yzw = cb2[8].xyz * r0.yzw;
  r0.yzw = cb2[27].xxx * r0.yzw;
  r0.x = -cb2[27].y + r0.x;
  r0.x = saturate(cb2[27].z * r0.x);
  r0.x = -1 + r0.x;
  r0.x = cb2[27].w * r0.x + 1;
  r0.xyz = r0.yzw * r0.xxx + -cb2[28].xxx;
  r0.xyz = r0.xyz / cb2[28].zzz;
  r0.xyz = r0.xyz * cb2[29].xxx + cb2[28].www;
  r0.x = r0.x * cb2[29].y + cb2[29].z;
  r0.x = cb2[30].y * r0.x;
  r0.w = cmp(0 >= r0.x);
  r0.x = log2(r0.x);
  r0.x = cb2[30].z * r0.x;
  r0.x = exp2(r0.x);
  r2.x = r0.w ? 0 : r0.x;
  r0.x = r0.y * cb2[30].w + cb2[31].x;
  r0.x = cb2[31].z * r0.x;
  r0.y = cmp(0 >= r0.x);
  r0.x = log2(r0.x);
  r0.x = cb2[31].w * r0.x;
  r0.x = exp2(r0.x);
  r2.y = r0.y ? 0 : r0.x;
  r0.x = r0.z * cb2[32].x + cb2[32].y;
  r0.x = cb2[32].w * r0.x;
  r0.y = cmp(0 >= r0.x);
  r0.x = log2(r0.x);
  r0.x = cb2[33].x * r0.x;
  r0.x = exp2(r0.x);
  r2.z = r0.y ? 0 : r0.x;
  r0.xyz = cb2[33].yyy + -cb2[13].xyz;
  r0.xyz = saturate(r2.xyz * r0.xyz + cb2[13].xyz);
  r2.xyz = r2.xyz + -r0.xyz;
  r0.xyz = cb2[33].zzz * r2.xyz + r0.xyz;
  r0.w = dot(r0.xyz, float3(0.300000012, 0.589999974, 0.109999999));
  r2.xyz = r0.www + -r0.xyz;
  r0.xyz = cb2[33].www * r2.xyz + r0.xyz;
  r2.xyz = -cb2[15].xyz + cb1[67].xyz;
  r0.w = dot(-r2.xyz, -r2.xyz);
  r0.w = sqrt(r0.w);
  r1.w = cb2[34].z + -cb2[34].x;
  r0.w = -cb2[34].x + r0.w;
  r1.w = 1 / r1.w;
  r0.w = saturate(r1.w * r0.w);
  r1.w = r0.w * -2 + 3;
  r0.w = r0.w * r0.w;
  r0.w = r1.w * r0.w;
  r1.w = -cb2[35].x + cb2[34].w;
  r0.w = r0.w * r1.w + cb2[35].x;
  r0.w = cb2[35].y * r0.w;
  r0.xyz = r0.xyz + -r1.xyz;
  r0.xyz = r0.www * r0.xyz + r1.xyz;
  r1.xyz = cb2[16].xyz + -r0.xyz;
  r0.xyz = cb2[35].zzz * r1.xyz + r0.xyz;
  // o0.xyz = max(float3(0, 0, 0), r0.xyz);
  o0.xyz = r0.xyz;

  o0.w = 1;

  // Back to PQ
  if (PROCESSING_PATH == 0.f) {
    o0.xyz = ConvertSRGBtoPQ(o0.xyz);
  }

  return;
}
