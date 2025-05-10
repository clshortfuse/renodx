// ---- Created with 3Dmigoto v1.4.1 on Sun Apr 20 17:01:23 2025
Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2) {
  float4 cb2[2];
}

cbuffer cb1 : register(b1) {
  float4 cb1[1];
}

cbuffer cb0 : register(b0) {
  float4 cb0[7];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    float4 v2: COLOR0,
    float4 v3: TEXCOORD1,
    uint v4: SV_IsFrontFace0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4, r5, r6, r7, r8;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v3.xy / v3.ww;
  r1.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r0.z = dot(float3(0.219999999, 0.707000017, 0.0710000023), r1.xyz);
  r0.z = saturate(-cb2[1].x + r0.z);
  r0.w = r0.z * -2 + 3;
  r0.z = r0.z * r0.z;
  r0.z = r0.w * r0.z;
  r0.z = log2(r0.z);
  r0.z = cb2[1].y * r0.z;
  r0.z = exp2(r0.z);
  r2.xyzw = float4(0.5, 0.5, 0.5, 0.5) + -r0.xyxy;
  r0.w = dot(r2.zw, r2.zw);
  r0.w = rsqrt(r0.w);
  r2.xyzw = r2.xyzw * r0.wwww;
  r3.xyzw = float4(-40, -40, -30, -30) * r2.zwzw;
  r0.w = 0.0078125 * cb0[3].z;
  r4.xyzw = cb2[0].xyzw * v2.xyzw;
  r0.w = r4.w * r0.w;
  r0.w = r0.w * r0.w;
  r3.xyzw = r3.xyzw * r0.wwww;
  r5.xyz = float3(1, 1, 1) / cb0[3].xxy;
  r3.xyzw = r5.yzyz * r3.xyzw + r0.xyxy;
  r6.xyzw = t0.Sample(s0_s, r3.xy).xyzw;
  r3.xyzw = t0.Sample(s0_s, r3.zw).xyzw;
  r1.w = dot(float3(0.219999999, 0.707000017, 0.0710000023), r6.xyz);
  r6.xyz = r6.xyz + r1.xyz;
  r6.xyz = r6.xyz + r3.xyz;
  r3.x = dot(float3(0.219999999, 0.707000017, 0.0710000023), r3.xyz);
  r3.x = saturate(cb2[1].x + r3.x);
  r1.w = saturate(cb2[1].x + r1.w);
  r3.y = r1.w * -2 + 3;
  r1.w = r1.w * r1.w;
  r1.w = r3.y * r1.w;
  r1.w = log2(r1.w);
  r1.w = cb2[1].y * r1.w;
  r1.w = exp2(r1.w);
  r1.w = cb2[1].z * r1.w;
  r0.z = cb2[1].z * r0.z + r1.w;
  r1.w = r3.x * -2 + 3;
  r3.x = r3.x * r3.x;
  r1.w = r3.x * r1.w;
  r1.w = log2(r1.w);
  r1.w = cb2[1].y * r1.w;
  r1.w = exp2(r1.w);
  r0.z = cb2[1].z * r1.w + r0.z;
  r3.xyzw = float4(-25, -25, -15, -15) * r2.zwzw;
  r3.xyzw = r3.xyzw * r0.wwww;
  r3.xyzw = r5.yzyz * r3.xyzw + r0.xyxy;
  r7.xyzw = t0.Sample(s0_s, r3.xy).xyzw;
  r3.xyzw = t0.Sample(s0_s, r3.zw).xyzw;
  r1.w = dot(float3(0.219999999, 0.707000017, 0.0710000023), r7.xyz);
  r6.xyz = r7.xyz + r6.xyz;
  r6.xyz = r6.xyz + r3.xyz;
  r3.x = dot(float3(0.219999999, 0.707000017, 0.0710000023), r3.xyz);
  r3.x = saturate(cb2[1].x + r3.x);
  r1.w = saturate(cb2[1].x + r1.w);
  r3.y = r1.w * -2 + 3;
  r1.w = r1.w * r1.w;
  r1.w = r3.y * r1.w;
  r1.w = log2(r1.w);
  r1.w = cb2[1].y * r1.w;
  r1.w = exp2(r1.w);
  r0.z = cb2[1].z * r1.w + r0.z;
  r1.w = r3.x * -2 + 3;
  r3.x = r3.x * r3.x;
  r1.w = r3.x * r1.w;
  r1.w = log2(r1.w);
  r1.w = cb2[1].y * r1.w;
  r1.w = exp2(r1.w);
  r0.z = cb2[1].z * r1.w + r0.z;
  r3.xyzw = float4(-10, -10, -5, -5) * r2.zwzw;
  r3.xyzw = r3.xyzw * r0.wwww;
  r3.xyzw = r5.yzyz * r3.xyzw + r0.xyxy;
  r7.xyzw = t0.Sample(s0_s, r3.xy).xyzw;
  r3.xyzw = t0.Sample(s0_s, r3.zw).xyzw;
  r1.w = dot(float3(0.219999999, 0.707000017, 0.0710000023), r7.xyz);
  r6.xyz = r7.xyz + r6.xyz;
  r6.xyz = r6.xyz + r3.xyz;
  r3.x = dot(float3(0.219999999, 0.707000017, 0.0710000023), r3.xyz);
  r3.x = saturate(cb2[1].x + r3.x);
  r1.w = saturate(cb2[1].x + r1.w);
  r3.y = r1.w * -2 + 3;
  r1.w = r1.w * r1.w;
  r1.w = r3.y * r1.w;
  r1.w = log2(r1.w);
  r1.w = cb2[1].y * r1.w;
  r1.w = exp2(r1.w);
  r0.z = cb2[1].z * r1.w + r0.z;
  r1.w = r3.x * -2 + 3;
  r3.x = r3.x * r3.x;
  r1.w = r3.x * r1.w;
  r1.w = log2(r1.w);
  r1.w = cb2[1].y * r1.w;
  r1.w = exp2(r1.w);
  r0.z = cb2[1].z * r1.w + r0.z;
  r3.xyzw = float4(5, 5, 10, 10) * r2.zwzw;
  r3.xyzw = r3.xyzw * r0.wwww;
  r3.xyzw = r5.yzyz * r3.xyzw + r0.xyxy;
  r7.xyzw = t0.Sample(s0_s, r3.xy).xyzw;
  r3.xyzw = t0.Sample(s0_s, r3.zw).xyzw;
  r1.w = dot(float3(0.219999999, 0.707000017, 0.0710000023), r7.xyz);
  r6.xyz = r7.xyz + r6.xyz;
  r6.xyz = r6.xyz + r3.xyz;
  r3.x = dot(float3(0.219999999, 0.707000017, 0.0710000023), r3.xyz);
  r3.x = saturate(cb2[1].x + r3.x);
  r1.w = saturate(cb2[1].x + r1.w);
  r3.y = r1.w * -2 + 3;
  r1.w = r1.w * r1.w;
  r1.w = r3.y * r1.w;
  r1.w = log2(r1.w);
  r1.w = cb2[1].y * r1.w;
  r1.w = exp2(r1.w);
  r0.z = cb2[1].z * r1.w + r0.z;
  r1.w = r3.x * -2 + 3;
  r3.x = r3.x * r3.x;
  r1.w = r3.x * r1.w;
  r1.w = log2(r1.w);
  r1.w = cb2[1].y * r1.w;
  r1.w = exp2(r1.w);
  r0.z = cb2[1].z * r1.w + r0.z;
  r3.xyzw = float4(15, 15, 25, 25) * r2.zwzw;
  r2.xyzw = float4(30, 30, 40, 40) * r2.xyzw;
  r2.xyzw = r2.xyzw * r0.wwww;
  r3.xyzw = r3.xyzw * r0.wwww;
  r3.xyzw = r5.yzyz * r3.xyzw + r0.xyxy;
  r2.xyzw = r5.yzyz * r2.xyzw + r0.xyxy;
  r7.xyzw = t0.Sample(s0_s, r3.xy).xyzw;
  r3.xyzw = t0.Sample(s0_s, r3.zw).xyzw;
  r0.w = dot(float3(0.219999999, 0.707000017, 0.0710000023), r7.xyz);
  r6.xyz = r7.xyz + r6.xyz;
  r6.xyz = r6.xyz + r3.xyz;
  r1.w = dot(float3(0.219999999, 0.707000017, 0.0710000023), r3.xyz);
  r1.w = saturate(cb2[1].x + r1.w);
  r0.w = saturate(cb2[1].x + r0.w);
  r3.x = r0.w * -2 + 3;
  r0.w = r0.w * r0.w;
  r0.w = r3.x * r0.w;
  r0.w = log2(r0.w);
  r0.w = cb2[1].y * r0.w;
  r0.w = exp2(r0.w);
  r0.z = cb2[1].z * r0.w + r0.z;
  r0.w = r1.w * -2 + 3;
  r1.w = r1.w * r1.w;
  r0.w = r1.w * r0.w;
  r0.w = log2(r0.w);
  r0.w = cb2[1].y * r0.w;
  r0.w = exp2(r0.w);
  r0.z = cb2[1].z * r0.w + r0.z;
  r3.xyzw = t0.Sample(s0_s, r2.xy).xyzw;
  r2.xyzw = t0.Sample(s0_s, r2.zw).xyzw;
  r0.w = dot(float3(0.219999999, 0.707000017, 0.0710000023), r3.xyz);
  r3.xyz = r6.xyz + r3.xyz;
  r3.xyz = r3.xyz + r2.xyz;
  r1.w = dot(float3(0.219999999, 0.707000017, 0.0710000023), r2.xyz);
  r1.w = saturate(cb2[1].x + r1.w);
  r2.xyz = r3.xyz * float3(0.0769230798, 0.0769230798, 0.0769230798) + -r1.xyz;
  r2.xyz = r4.www * r2.xyz + r1.xyz;
  r0.w = saturate(cb2[1].x + r0.w);
  r2.w = r0.w * -2 + 3;
  r0.w = r0.w * r0.w;
  r0.w = r2.w * r0.w;
  r0.w = log2(r0.w);
  r0.w = cb2[1].y * r0.w;
  r0.w = exp2(r0.w);
  r0.z = cb2[1].z * r0.w + r0.z;
  r0.w = r1.w * -2 + 3;
  r1.w = r1.w * r1.w;
  r0.w = r1.w * r0.w;
  r0.w = log2(r0.w);
  r0.w = cb2[1].y * r0.w;
  r0.w = exp2(r0.w);
  r0.z = cb2[1].z * r0.w + r0.z;
  r0.z = 0.0769230798 * r0.z;
  r0.z = log2(r0.z);
  r0.z = r4.w * r0.z;
  r0.z = exp2(r0.z);
  r3.xyz = cb0[4].xyz * cb0[4].www;
  r3.xyz = r3.xyz * r4.www;
  r6.xyz = float3(50, 50, 50) * r3.xyz;
  r7.w = -r6.y * r5.z;
  r7.xyz = r6.yzz * r5.xyz;
  r5.xy = -r6.xx * r5.xz + r0.xy;
  r5.xyzw = t0.Sample(s0_s, r5.xy).xyzw;
  r6.xyzw = r7.xwyz + r0.xyxy;
  r7.xyzw = t1.Sample(s2_s, r0.xy).xyzw;
  r8.xyzw = t0.Sample(s0_s, r6.xy).xyzw;
  r6.xyzw = t0.Sample(s0_s, r6.zw).xyzw;
  r5.z = r6.z;
  r5.y = r8.y;
  r0.xyw = r3.xyz * float3(1.25, 1.25, 1.25) + r5.xyz;
  r0.xyw = r0.xyw + -r1.xyz;
  r0.xyw = r4.www * r0.xyw + r1.xyz;
  r0.xyw = r0.xyw + r2.xyz;
  r0.xyw = float3(0.5, 0.5, 0.5) * r0.xyw;
  r1.x = cb1[0].x * cb0[6].x;
  r1.xy = cb0[5].zw * r1.xx;
  r2.yz = sin(r1.xx);
  r2.x = cos(r1.y);
  r1.xyz = r2.xyz * float3(0.5, -0.5, 0.5) + float3(0.5, 0.5, 0.5);
  r1.xyz = r1.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
  r2.xy = float2(-0.5, -0.5) + v1.xy;
  r3.x = dot(r2.xy, r1.xz);
  r3.y = dot(r2.yx, r1.xy);
  r1.xy = float2(0.5, 0.5) + r3.xy;
  r1.z = dot(cb0[5].xy, cb0[5].xy);
  r1.z = rsqrt(r1.z);
  r1.zw = cb0[5].xy * r1.zz;
  r1.zw = cb1[0].xx * -r1.zw;
  r1.xy = r1.zw * cb0[6].xx + r1.xy;
  r1.xyzw = t2.Sample(s1_s, r1.xy).xyzw;
  r1.xyz = r1.xyz * r1.www;
  r1.xyz = r1.xyz * r0.xyw;
  r2.xyz = r1.xyz * r0.zzz;
  r1.xyz = -r1.xyz * r0.zzz + float3(1, 1, 1);
  r3.xyz = r0.xyw * r0.zzz;
  r5.xyzw = r4.xyzw * r4.wwww;
  r1.xyz = r5.www * r1.xyz + r2.xyz;
  r0.xyz = r5.xyz * r0.xyw;
  r2.xyz = r4.xyz * r4.www + -r0.xyz;
  r0.xyz = r4.www * r2.xyz + r0.xyz;
  r0.xyz = r0.xyz * r1.xyz + -r3.xyz;
  r0.xyz = r4.www * r0.xyz + r3.xyz;
  r0.w = r7.w * r4.w;
  r1.xyz = r0.xyz * r7.xyz + -r0.xyz;
  o0.xyz = r0.www * r1.xyz + r0.xyz;
  o0.xyz = max(0, o0.xyz);  // Added max(0,..)
  o0.w = 1;
  return;
}
