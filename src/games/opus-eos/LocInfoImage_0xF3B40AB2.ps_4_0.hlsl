// ---- Created with 3Dmigoto v1.4.1 on Tue Apr 15 02:25:31 2025
Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1) {
  float4 cb1[7];
}

cbuffer cb0 : register(b0) {
  float4 cb0[17];
}

// Eye-searingly bright UI Elements

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float4 v1: COLOR0,
    float4 v2: TEXCOORD0,
    float4 v3: TEXCOORD1,
    float4 v4: TEXCOORD2,
    float4 v5: TEXCOORD3,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4, r5, r6, r7, r8;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cb1[0].y * cb0[6].x;
  r0.x = 100 * r0.x;
  r0.y = cb1[6].y * r0.x;
  r0.y = cmp(r0.y >= -r0.y);
  r0.y = r0.y ? cb1[6].y : -cb1[6].y;
  r0.z = 1 / r0.y;
  r0.x = r0.x * r0.z;
  r0.x = frac(r0.x);
  r0.x = r0.y * r0.x + v4.y;
  r0.y = dot(v3.xy, float2(12.9898005, 78.2330017));
  r0.y = sin(r0.y);
  r0.y = 43758.5469 * r0.y;
  r0.y = frac(r0.y);
  r0.y = r0.y * 2 + -1;
  r0.y = cb0[5].y * r0.y;
  r0.x = r0.y * 0.00100000005 + r0.x;
  r0.y = cb1[0].y * cb0[7].x + r0.y;
  r0.y = v2.y * cb0[6].z + r0.y;
  r0.y = sin(r0.y);
  r0.y = cb0[6].y * r0.y;
  r0.y = cb0[12].x * r0.y;
  r1.x = cb0[6].w * r0.y;
  r0.y = 0.00499999989 * cb1[6].y;
  r0.y = cb0[5].z * r0.y;
  r0.y = floor(r0.y);
  r0.x = r0.x / r0.y;
  r0.x = (int)r0.x;
  r0.y = (int)r0.x & 0x80000000;
  r0.x = max((int)-r0.x, (int)r0.x);
  r0.x = (int)r0.x & 1;
  r0.z = -(int)r0.x;
  r0.x = r0.y ? r0.z : r0.x;
  r0.y = dot(v2.xx, float2(12.9898005, 78.2330017));
  r0.y = sin(r0.y);
  r0.y = 43758.5469 * r0.y;
  r0.y = frac(r0.y);
  r0.y = r0.y * 2 + -1;
  r0.z = cb1[0].x * cb0[9].x;
  r2.xyz = asint(cb0[4].zww);
  r0.w = r2.x * r2.y;
  r0.z = r0.z * r0.w;
  r0.z = floor(r0.z);
  r0.z = r0.z / r0.w;
  r3.xyz = float3(91.2228012, 65.2432022, -91.2228012) * r0.zzz;
  r0.z = sin(r0.z);
  r0.z = r0.z * 0.5 + 0.5;
  r0.z = cmp(0.899999976 >= r0.z);
  r3.xyz = sin(r3.xyz);
  r3.xyz = float3(43758.5469, 43758.5469, 43758.5469) * r3.xyz;
  r3.xyz = frac(r3.xyz);
  r0.w = r3.x * 5 + 1;
  r0.w = 4 * r0.w;
  r1.zw = v2.xy * r0.ww;
  r1.zw = floor(r1.zw);
  r1.zw = r1.zw / r0.ww;
  r0.w = dot(r1.zw, float2(12.9898005, 78.2330017));
  r0.w = sin(r0.w);
  r0.w = 43758.5469 * r0.w;
  r0.w = frac(r0.w);
  r4.xyzw = t0.Sample(s1_s, r0.ww).xyzw;
  r0.w = dot(r4.yz, r4.yz);
  r0.w = rsqrt(r0.w);
  r1.zw = r4.yz * r0.ww;
  r0.w = 0.5 * cb0[8].y;
  r1.zw = r1.zw * cb0[8].yy + -r0.ww;
  r4.xy = r1.zw * float2(0.00999999978, 0.00999999978) + v2.xy;
  r0.y = cmp(r4.y >= r0.y);
  r0.yz = r0.yz ? float2(1, 1) : 0;
  r0.y = r0.y * r3.x;
  r1.zw = float2(-0.5, -0.5) + r3.zy;
  r0.y = cb0[9].y * r0.y;
  r0.y = r0.y * r0.z;
  r0.z = 0.5 + -r4.y;
  r4.z = r0.y * r0.z + r4.y;
  r2.w = asint(cb0[5].x);
  r0.yz = r2.xx * r2.zw;
  r2.xy = r4.xz * r0.yz;
  r2.xy = floor(r2.xy);
  r0.yz = r2.xy / r0.yz;
  r2.xy = float2(0.5, 0.5) + v3.xy;
  r2.xy = float2(12.9898005, 78.2330017) * r2.xy;
  r0.w = r2.x + r2.y;
  r0.w = sin(r0.w);
  r0.w = 43758.5469 * r0.w;
  r0.w = frac(r0.w);
  r0.w = r0.w * 2 + -1;
  r0.w = cb0[5].y * r0.w;
  r0.w = cb1[0].x * cb0[8].x + r0.w;
  r0.w = v2.x * cb0[7].z + r0.w;
  r0.w = cos(r0.w);
  r0.w = cb0[7].y * r0.w;
  r0.w = cb0[12].y * r0.w;
  r1.y = cb0[7].w * r0.w;
  r0.yz = r1.xy + r0.yz;
  r1.xy = cb0[12].xx * cb0[3].xx + r0.yz;
  r2.xyzw = t1.Sample(s0_s, r1.xy).xyzw;
  r1.xy = -cb0[12].xx * cb0[3].xx + r0.yz;
  r3.xyzw = t1.Sample(s0_s, r1.xy).xyzw;
  r0.w = cb0[12].x * cb0[3].x;
  r4.xyzw = r0.wwww * float4(-1, 0, -1, 1) + r0.yzyz;
  r5.xyzw = t1.Sample(s0_s, r4.xy).xyzw;
  r4.xyzw = t1.Sample(s0_s, r4.zw).xyzw;
  r1.x = -r5.w * 2 + -r3.w;
  r1.x = r1.x + -r4.w;
  r5.xyzw = r0.wwww * float4(0, -1, 1, -1) + r0.yzyz;
  r6.xyzw = t1.Sample(s0_s, r5.zw).xyzw;
  r5.xyzw = t1.Sample(s0_s, r5.xy).xyzw;
  r1.y = -r5.w * 2 + -r3.w;
  r1.y = r1.y + -r6.w;
  r1.x = r6.w + r1.x;
  r1.y = r1.y + r4.w;
  r3.xyzw = r0.wwww * float4(1, 0, 0, 1) + r0.yzyz;
  r4.xyzw = t1.Sample(s0_s, r3.xy).xyzw;
  r3.xyzw = t1.Sample(s0_s, r3.zw).xyzw;
  r1.y = r3.w * 2 + r1.y;
  r1.x = r4.w * 2 + r1.x;
  r1.xy = r1.xy + r2.ww;
  r1.x = r1.x * r1.x;
  r1.x = r1.y * r1.y + r1.x;
  r1.x = sqrt(r1.x);
  r2.xyzw = t1.Sample(s0_s, r0.yz).xyzw;
  r1.y = dot(r2.xyz, float3(0.300000012, 0.589999974, 0.109999999));
  r3.x = cmp(r1.y >= cb0[3].y);
  r3.x = r3.x ? 1.000000 : 0;
  r3.x = r3.x + -r1.y;
  r1.y = cb0[3].z * r3.x + r1.y;
  r3.w = r1.y * r2.w + r1.x;
  r3.xyz = float3(1, 1, 1);
  r3.xyzw = r3.xyzw + -r2.xyzw;
  r3.xyzw = cb0[4].xxxx * r3.xyzw + r2.xyzw;
  r4.xyz = r3.xyz;
  r4.w = cb0[5].w * r3.w;
  r3.xyzw = r0.xxxx ? r4.xyzw : r3.xyzw;
  r2.xyz = -r3.xyz + r2.xyz;
  r2.xyz = cb0[3].www * r2.xyz + r3.xyz;
  r3.xyz = cb0[4].yyy + r2.xyz;
  r1.xy = r1.zw * cb0[8].zz + r0.yz;
  r2.xyzw = r1.wzzz * cb0[8].zzzz + r0.yzyz;
  r1.xyzw = t1.Sample(s0_s, r1.xy).xyzw;
  r4.xyzw = t1.Sample(s0_s, r2.xy).xyzw;
  r2.xyzw = t1.Sample(s0_s, r2.zw).xyzw;
  r0.x = r4.w + r2.w;
  r1.x = r4.x;
  r1.y = r2.y;
  r0.x = r0.x + r1.w;
  r1.w = 0.333333343 * r0.x;
  r1.xyzw = r1.xyzw + -r3.xyzw;
  r0.x = dot(cb1[0].zw, float2(12.9898005, 78.2330017));
  r0.x = sin(r0.x);
  r0.x = 43758.5469 * r0.x;
  r0.x = frac(r0.x);
  r0.y = 1 + -cb0[8].w;
  r0.x = cmp(r0.x >= r0.y);
  r0.x = r0.x ? 1.000000 : 0;
  r1.xyzw = r0.xxxx * r1.xyzw + r3.xyzw;
  r2.xyzw = v1.xyzw * r1.xyzw;
  r0.x = cb1[0].y * cb0[11].x;
  r0.x = 4 * r0.x;
  r0.x = floor(r0.x);
  r0.x = 0.25 * r0.x;
  sincos(r0.x, r0.x, r3.x);
  r4.xyzw = float4(0.100000001, 0.100000001, 0.200000003, 2) * v2.xyxy;
  r0.yz = floor(r4.xy);
  r0.z = r0.z * 10 + r3.x;
  r0.x = r0.y * 10 + r0.x;
  r0.yz = float2(78.2330017, 12.9898005) * r0.zz;
  r0.xy = r0.xx * float2(12.9898005, 78.2330017) + r0.yz;
  r0.xy = sin(r0.xy);
  r0.xy = float2(43758.5469, 43758.5469) * r0.xy;
  r0.xy = frac(r0.xy);
  r0.xy = float2(-0.5, -0.5) + r0.xy;
  r0.xy = r0.xy * float2(2, 2) + r4.zw;
  r3.xyzw = t2.Sample(s2_s, r0.xy).xyzw;
  r0.xy = -cb0[12].xx * cb0[3].xx + r3.xy;
  r4.xyzw = t1.Sample(s0_s, r0.xy).xyzw;
  r5.xyzw = r0.wwww * float4(-1, 0, -1, 1) + r3.xyxy;
  r6.xyzw = t1.Sample(s0_s, r5.xy).xyzw;
  r5.xyzw = t1.Sample(s0_s, r5.zw).xyzw;
  r0.x = -r6.w * 2 + -r4.w;
  r0.x = r0.x + -r5.w;
  r6.xyzw = r0.wwww * float4(0, -1, 1, -1) + r3.xyxy;
  r7.xyzw = r0.wwww * float4(1, 0, 0, 1) + r3.xyxy;
  r8.xyzw = t1.Sample(s0_s, r6.zw).xyzw;
  r6.xyzw = t1.Sample(s0_s, r6.xy).xyzw;
  r0.y = -r6.w * 2 + -r4.w;
  r0.y = r0.y + -r8.w;
  r0.x = r8.w + r0.x;
  r0.y = r0.y + r5.w;
  r4.xyzw = t1.Sample(s0_s, r7.xy).xyzw;
  r5.xyzw = t1.Sample(s0_s, r7.zw).xyzw;
  r0.y = r5.w * 2 + r0.y;
  r0.x = r4.w * 2 + r0.x;
  r0.zw = cb0[12].xx * cb0[3].xx + r3.xy;
  r3.xyzw = t1.Sample(s0_s, r3.xy).xyzw;
  r4.xyzw = t1.Sample(s0_s, r0.zw).xyzw;
  r0.xy = r4.ww + r0.xy;
  r0.x = r0.x * r0.x;
  r0.x = r0.y * r0.y + r0.x;
  r0.x = sqrt(r0.x);
  r0.y = dot(r3.xyz, float3(0.300000012, 0.589999974, 0.109999999));
  r0.z = cmp(r0.y >= cb0[3].y);
  r0.z = r0.z ? 1.000000 : 0;
  r0.z = r0.z + -r0.y;
  r0.y = cb0[3].z * r0.z + r0.y;
  r0.w = r0.y * r3.w + r0.x;
  r0.xyz = float3(1, 1, 1);
  r0.xyzw = r0.xyzw + -r3.xyzw;
  r0.xyzw = cb0[4].xxxx * r0.xyzw + r3.xyzw;
  r3.xyz = r3.xyz + -r0.xyz;
  r3.xyz = cb0[3].www * r3.xyz + r0.xyz;
  r0.xyz = cb0[4].yyy + r3.xyz;
  r3.xyzw = cb0[10].xyzw * r0.xyzw;
  r3.w = r3.w * r2.w;
  r1.xyzw = -r1.xyzw * v1.xyzw + r3.xyzw;
  r0.xyzw = r1.xyzw * r0.wwww;
  r0.xyzw = cb0[11].yyyy * r0.xyzw + r2.xyzw;
  r1.xy = cmp(v5.xy >= cb0[16].xy);
  r1.zw = cmp(cb0[16].zw >= v5.xy);
  r1.xyzw = r1.xyzw ? float4(1, 1, 1, 1) : 0;
  r1.xy = r1.xy * r1.zw;
  r1.x = r1.x * r1.y;
  o0.w = r1.x * r0.w;
  o0.w = min(o0.w, 1.0);
  o0.xyz = min(r0.rgb, float3(1.0, 1.0, 1.0));
  o0.xyz = saturate(o0.rgb);  // Added saturate()

  return;
}
