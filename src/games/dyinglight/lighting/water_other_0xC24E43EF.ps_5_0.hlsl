#include "./lighting.hlsli"

// ---- Created with 3Dmigoto v1.4.1 on Wed Jul  2 02:45:45 2025
Texture2D<float4> t10 : register(t10);

Texture2D<float4> t9 : register(t9);

Texture2D<float4> t8 : register(t8);

Texture2D<float4> t7 : register(t7);

Texture2D<float4> t6 : register(t6);

Texture2D<float4> t5 : register(t5);

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s12_s : register(s12);

SamplerState s11_s : register(s11);

SamplerState s10_s : register(s10);

SamplerState s9_s : register(s9);

SamplerState s8_s : register(s8);

SamplerState s7_s : register(s7);

SamplerState s5_s : register(s5);

SamplerState s4_s : register(s4);

SamplerState s3_s : register(s3);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2) {
  float4 cb2[13];
}

cbuffer cb0 : register(b0) {
  float4 cb0[28];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float4 v1: TEXCOORD0,
    float4 v2: TEXCOORD1,
    float4 v3: TEXCOORD2,
    float4 v4: TEXCOORD3,
    float4 v5: TEXCOORD4,
    float4 v6: TEXCOORD5,
    float4 v7: TEXCOORD6,
    float4 v8: TEXCOORD7,
    float4 v9: TEXCOORD8,
    float4 v10: TEXCOORD9,
    float4 v11: TEXCOORD10,
    out float4 o0: SV_TARGET0) {
  float4 r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = t6.Sample(s7_s, v6.zw).yw;
  r0.xy = r0.yx * float2(2, 2) + float2(-1, -1);
  r1.x = dot(r0.xy, cb0[12].xy);
  r1.z = dot(r0.yx, cb0[12].xz);
  r0.xy = t7.Sample(s8_s, v5.xy).yw;
  r0.xy = r0.yx * float2(2, 2) + float2(-1, -1);
  r2.x = dot(r0.xy, cb0[13].xy);
  r2.z = dot(r0.yx, cb0[13].xz);
  r0.xy = r2.xz + r1.xz;
  r0.zw = t8.Sample(s9_s, v5.zw).yw;
  r0.zw = r0.wz * float2(2, 2) + float2(-1, -1);
  r1.x = dot(r0.zw, cb0[14].xy);
  r1.z = dot(r0.wz, cb0[14].xz);
  r0.xy = r1.xz + r0.xy;
  r0.zw = t9.Sample(s10_s, v6.xy).yw;
  r0.zw = r0.wz * float2(2, 2) + float2(-1, -1);
  r1.x = dot(r0.zw, cb0[15].xy);
  r1.z = dot(r0.wz, cb0[15].xz);
  r0.xy = r1.xz + r0.xy;
  r0.zw = v0.xy * cb2[7].xy + cb2[7].zw;
  r1.xy = t10.SampleLevel(s11_s, r0.zw, 0).xy;
  r0.xy = r1.xy * float2(2, 2) + r0.xy;
  r0.xy = float2(-1, -1) + r0.xy;
  r1.x = t0.SampleLevel(s12_s, r0.zw, 0).x;
  r1.xy = r1.xx * cb2[8].xy + cb2[8].zw;
  r1.x = r1.x / -r1.y;
  r2.x = -abs(r1.x);
  r1.yz = v0.xy * cb2[9].xy + cb2[9].zw;
  r2.yz = r1.yz * abs(r1.xx);
  r3.xyz = ddx_coarse(r2.zxy);
  r4.xyz = ddy_coarse(r2.xyz);
  r1.x = dot(r2.xyz, r2.xyz);
  r1.x = sqrt(r1.x);
  r2.xyz = r4.xyz * r3.xyz;
  r2.xyz = r4.zxy * r3.yzx + -r2.xyz;
  r1.w = dot(r2.xyz, r2.xyz);
  r1.w = rsqrt(r1.w);
  r2.xyz = r2.xyz * r1.www;
  r3.y = dot(r2.xyz, cb2[11].xyz);
  r3.x = dot(r2.xyz, cb2[10].xyz);
  r3.z = dot(r2.xyz, cb2[12].xyz);
  r1.w = dot(r3.xyz, r3.xyz);
  r1.w = rsqrt(r1.w);
  r2.xy = r3.xz * r1.ww;
  r1.w = dot(v8.xy, cb0[10].xy);
  r2.z = t4.Sample(s4_s, v7.zw).y;
  r2.w = t4.Sample(s4_s, v7.xy).y;
  r3.x = dot(v2.xyz, v2.xyz);
  r3.y = sqrt(r3.x);
  r1.x = -r3.y + r1.x;
  r3.z = saturate(cb0[11].z * r1.x);
  r1.x = saturate(cb0[5].w * r1.x);
  r3.w = r3.z * cb0[11].y + cb0[11].x;
  r2.w = r2.w * cb0[6].w + r3.w;
  r2.z = r2.z * cb0[6].w + r2.w;
  r1.w = -r1.w * cb0[8].w + r2.z;
  r2.zw = t5.Sample(s5_s, r1.ww).yw;
  r2.zw = r2.zw * float2(2, 2) + float2(-1, -1);
  r1.w = 1 + -r3.z;
  r1.w = r2.z * r1.w;
  r2.zw = float2(1, 2) * r2.ww;
  r1.w = cb0[9].w * r1.w;
  r0.xy = r2.xy * r1.ww + r0.xy;
  r2.xy = r2.xy * r1.ww;
  r4.xz = r3.zz * r0.xy + -r2.xy;
  r0.x = cb0[11].y * r3.z;
  r0.xy = r0.xx * float2(2, 15) + r2.zw;
  r0.xy = saturate(float2(-1, -2) + r0.xy);
  r4.y = 1;
  r1.w = dot(r4.xyz, r4.xyz);
  r1.w = rsqrt(r1.w);
  r2.xyz = r4.xyz * r1.www;
  r4.x = dot(r2.xyz, cb2[0].xyz);
  r4.y = dot(r2.xyz, cb2[1].xyz);
  r5.x = cb2[0].y;
  r5.y = cb2[1].y;
  r3.zw = -r5.xy + r4.xy;
  r1.w = cb0[5].z / r3.y;
  r1.x = r1.w * r1.x;
  r1.xw = r3.zw * r1.xx;
  r1.xw = r1.xw * r0.xx + r0.zw;
  r0.z = t2.SampleLevel(s1_s, r0.zw, 0).x;
  r0.w = t0.SampleLevel(s12_s, r1.xw, 0).x;
  r4.xyzw = t1.Sample(s0_s, r1.xw).xyzw;
  r1.xw = r0.ww * cb2[8].xy + cb2[8].zw;
  r0.w = r1.x / -r1.w;
  r1.xy = r1.yz * abs(r0.ww);
  r1.z = -abs(r0.w);
  r0.w = dot(r1.xyz, r1.xyz);
  r0.w = sqrt(r0.w);
  r0.w = r0.w + -r3.y;
  r1.xyz = cb0[24].xyz * r3.yyy;
  r1.xyz = exp2(r1.xyz);
  r0.w = max(0, r0.w);
  r3.yzw = cb0[3].xyz * -r0.www;
  r5.xyz = cb0[2].xyz * -r0.www;
  r5.xyz = exp2(r5.xyz);
  r3.yzw = exp2(r3.yzw);
  r6.w = 1;
  r0.w = rsqrt(r3.x);
  r7.xy = r2.xz * r3.xx;
  r7.xz = r7.xy * cb0[5].yy + v4.xz;
  r6.xyz = v2.xyz * r0.www;
  r8.xyz = -v2.xyz * r0.www + cb0[7].xyz;
  r9.x = dot(cb0[16].xyzw, r6.xyzw);
  r9.y = dot(cb0[17].xyzw, r6.xyzw);
  r9.z = dot(cb0[18].xyzw, r6.xyzw);
  r10.xyzw = r6.xyzz * r6.yzzx;
  r11.x = dot(cb0[19].xyzw, r10.xyzw);
  r11.y = dot(cb0[20].xyzw, r10.xyzw);
  r11.z = dot(cb0[21].xyzw, r10.xyzw);
  r9.xyz = r11.xyz + r9.xyz;
  r0.w = r6.y * r6.y;
  r0.w = r6.x * r6.x + -r0.w;
  r9.xyz = cb0[22].xyz * r0.www + r9.xyz;
  r9.xyz = cb0[1].xyz + r9.xyz;
  r9.xyz = cb0[0].xyz * r9.xyz;
  r3.xyz = -r9.xyz * r3.yzw + r9.xyz;
  r3.xyz = r4.xyz * r5.xyz + r3.xyz;
  o0.w = r4.w;
  r7.y = v4.y;
  r7.w = 1;
  r4.x = dot(r7.xyzw, cb2[0].xyzw);
  r4.y = dot(r7.xyzw, cb2[1].xyzw);
  r0.w = dot(r7.xyzw, cb2[3].xyzw);
  r4.xy = r4.xy / r0.ww;
  r4.xy = r4.xy * float2(0.5, -0.5) + float2(0.5, 0.5);
  r4.xyz = t3.SampleLevel(s3_s, r4.xy, 0).xyz;
  r4.xyz = r4.xyz + -r3.xyz;
  r5.z = dot(-r6.xyz, r2.xyz);
  r0.w = saturate(dot(r6.xyz, cb0[6].xyz));
  r1.w = saturate(r5.z);
  r1.w = -8.65616989 * r1.w;
  r1.w = exp2(r1.w);
  r1.w = saturate(cb0[4].w * r1.w + cb0[3].w);
  r1.w = r1.w * r0.x;
  r3.xyz = r1.www * r4.xyz + r3.xyz;
  r1.w = dot(r8.xyz, r8.xyz);
  r1.w = rsqrt(r1.w);
  r4.xyz = r8.xyz * r1.www;
  r5.x = dot(r2.xyz, r4.xyz);
  r5.y = dot(cb0[7].xyz, r4.xyz);
  r5.w = dot(cb0[7].xyz, r2.xyz);
  r2.xyzw = max(float4(0.00999999978, 0.00999999978, 0.00999999978, 0.00999999978), r5.xyzw);
  r2.zw = r2.zw * cb0[4].yy + cb0[4].xx;
  r1.w = r2.z * r2.w;
  r2.x = r2.x * r2.x;
  r2.y = -8.65616989 * r2.y;
  r2.y = exp2(r2.y);
  r2.y = saturate(cb0[4].z * r2.y + cb0[3].w);
  r2.x = r2.x * cb0[0].w + 1;
  r2.x = r2.x * r2.x;
  r2.x = 4 * r2.x;
  r1.w = r2.x * r1.w;
  r1.w = cb0[1].w / r1.w;
  r1.w = r2.y * r1.w;
  r1.w = ApplyCustomClampWaterSpecular(r1.w * r5.w);  // remove clamp on specular intensity
  r1.w = r1.w * r0.x;
  r0.x = r0.x + r0.y;
  r0.x = min(1, r0.x);
  r0.y = r1.w * r0.z;
  r2.xyz = r0.yyy * cb0[8].xyz + r3.xyz;
  r3.xyz = saturate(r2.xyz * cb0[23].xyz + r1.xyz);
  r0.y = cb0[26].w * r0.w + cb0[27].x;
  r0.z = r0.w * r0.w;
  r0.z = r0.z * 0.238732412 + 0.238732412;
  r0.y = sqrt(r0.y);
  r0.w = r0.y * r0.y;
  r0.y = r0.w * r0.y;
  r4.xyz = cb0[26].xyz / r0.yyy;
  r0.yzw = cb0[25].xyz * r0.zzz + r4.xyz;
  r0.yzw = -r0.yzw * r1.xyz + r0.yzw;
  r0.yzw = r2.xyz * r3.xyz + r0.yzw;
  r0.yzw = r0.yzw + -r2.xyz;
  o0.xyz = r0.xxx * r0.yzw + r2.xyz;
  return;
}
