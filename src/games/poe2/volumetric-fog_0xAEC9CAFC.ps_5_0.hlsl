// ---- Created with 3Dmigoto v1.4.1 on Sun Dec  7 11:02:58 2025
Buffer<uint4> t10 : register(t10);

Texture2D<uint4> t9 : register(t9);

Texture2D<float4> t8 : register(t8);

Texture2D<float4> t7 : register(t7);

Texture2D<float4> t6 : register(t6);

Texture2D<float4> t5 : register(t5);

struct t4_t {
  float val[16];
};
StructuredBuffer<t4_t> t4 : register(t4);

struct t3_t {
  float val[44];
};
StructuredBuffer<t3_t> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

TextureCube<float4> t1 : register(t1);

TextureCube<float4> t0 : register(t0);

SamplerComparisonState s15_s : register(s15);

SamplerState s8_s : register(s8);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2)
{
  float4 cb2[337];
}

cbuffer cb1 : register(b1)
{
  float4 cb1[12];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[100];
}




// 3Dmigoto declarations
#define cmp -


// Volumetric fog gather pass. Reconstructs world-space rays, marches through atmospheric volumes,
// samples blue-noise + shadow maps, and accumulates colored fog per pixel.
void main(
  nointerpolation uint v0 : INSTANCEID0,
  float4 v1 : SV_POSITION0,
  float4 v2 : TEXCOORD0,
  float4 v3 : TEXCOORD1,
  float4 v4 : TEXCOORD5,
  float4 v5 : TEXCOORD6,
  float3 v6 : TEXCOORD7,
  out float4 o0 : SV_TARGET0)
{
  const float4 icb[] = { { 1.000000, 0, 0, 0},
                              { 0, 1.000000, 0, 0},
                              { 0, 0, 1.000000, 0},
                              { 0, 0, 0, 1.000000},
                              { 8, 0.866000, 0, 0.500000},
                              { 2, 0.866000, 0, -0.500000},
                              { 10, 0, 0, -1.000000},
                              { 12, -0.866000, 0, -0.500000},
                              { 4, -0.866000, 0, 0.500000},
                              { 14, 0, 0, 0},
                              { 6, 0, 0, 0},
                              { 3, 0, 0, 0},
                              { 11, 0, 0, 0},
                              { 1, 0, 0, 0},
                              { 9, 0, 0, 0},
                              { 15, 0, 0, 0},
                              { 7, 0, 0, 0},
                              { 13, 0, 0, 0},
                              { 5, 0, 0, 0} };
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,r16,r17,r18,r19,r20,r21,r22,r23,r24,r25,r26,r27,r28,r29,r30,r31,r32,r33,r34,r35,r36,r37,r38,r39,r40,r41,r42,r43,r44,r45,r46,r47,r48,r49,r50,r51,r52,r53,r54,r55,r56,r57,r58,r59,r60,r61,r62,r63,r64,r65,r66,r67,r68,r69,r70,r71,r72,r73,r74,r75,r76,r77,r78,r79,r80,r81;
  uint4 bitmask, uiDest;
  float4 fDest;

  // Early exit if this fog sample is masked out by the global enable flag.
  r0.x = 1.00100005 + -cb1[0].y;
  r0.x = cmp(r0.x < 0);
  if (r0.x != 0) discard;
  // Select per-instance blend/exposure parameters (either override or global default).
  r0.x = cb1[6].z ? cb0[94].y : cb1[11].y;
  r0.yz = float2(0.100000001,1) * cb0[94].xx;
  r0.yz = cb1[6].zz ? r0.yz : cb1[6].xy;
  r1.xyzw = cb1[6].zzzz ? cb0[73].xyzw : cb1[1].xyzw;
  r2.xyzw = cb1[2].xyzw * cb0[73].xyzw;
  r2.xyzw = cb1[6].zzzz ? r2.xyzw : cb1[3].xyzw;
  // Build a 4x4 tile index (later used for blue-noise jitter addressing).
  r3.xy = float2(0.25,0.25) * v1.xy;
  r3.xy = frac(r3.xy);
  r3.xy = r3.xy * float2(4,4) + float2(-0.5,-0.5);
  r0.w = r3.y * 4 + r3.x;
  r0.w = 0.5 + r0.w;
  r0.w = (uint)r0.w;
  r0.w = min(15, (uint)r0.w);
  r0.w = (int)icb[r0.w+3].x;
  r0.w = 0.5 + r0.w;
  r3.xyz = cb1[10].wxy * cb0[96].www;
  r4.xy = float2(0.5,0.5) + cb0[67].xy;
  r4.xy = (uint2)r4.xy;
  uiDest.xy = (uint2)r4.xy / asuint(cb0[97].zz);
  r4.xy = uiDest.xy;
  r4.zw = (uint2)r4.xy;
  r4.zw = r4.zw * cb0[68].xy + float2(0.5,0.5);
  r4.zw = trunc(r4.zw);
  r5.xy = v1.xy / r4.zw;
  r4.xy = (int2)r4.xy;
  r4.xy = r4.zw / r4.xy;
  r4.xy = r5.xy * r4.xy;
  // Sample the low-res density field to modulate the ray scale.
  r3.w = t6.SampleLevel(s1_s, r4.xy, -0.5).x;
  r4.x = r5.x * 2 + -1;
  r4.y = 1 + -r5.y;
  r4.y = r4.y * 2 + -1;
  r5.xyzw = cb0[25].xyzw * r4.yyyy;
  r5.xyzw = r4.xxxx * cb0[24].xyzw + r5.xyzw;
  r5.xyzw = r3.wwww * cb0[26].xyzw + r5.xyzw;
  r5.xyzw = cb0[27].xyzw + r5.xyzw;
  r5.xyzw = r5.zxyz / r5.wwww;
  r5.xyzw = -cb0[85].zxyz + r5.xyzw;
  r3.w = cmp(1.00000001e-07 < abs(r5.x));
  r4.x = 1 / r5.x;
  r3.w = r3.w ? r4.x : 10000000;
  r4.xy = -cb1[7].xy + -cb0[85].zz;
  r4.xy = r4.xy * r3.ww;
  r3.w = max(1, asint(cb1[10].z));
  r5.x = (int)r3.w;
  r3.x = r3.x * r5.x + 0.5;
  r6.x = floor(r3.x);
  r6.x = (int)r6.x;
  r6.x = -(int)r6.x;
  r3.x = frac(r3.x);
  r5.x = 1 / r5.x;
  r6.y = cb1[7].y + -cb1[7].x;
  r6.y = abs(r6.y) * r5.x;
  r1.xyzw = -r2.xyzw + r1.xyzw;
  r0.z = r0.z + -r0.y;
  uiDest.z = (uint)v0.x / asuint(cb2[0].x);
  r6.z = uiDest.z;
  r6.z = (int)r6.z * 21;
  r7.xy = -cb1[9].xy + cb1[8].xy;
  r6.w = cmp(0 < abs(cb1[9].w));
  r7.z = cb2[r6.z+19].w * cb1[8].z;
  // Prefetch blue-noise reference sample (used later for temporal reprojection).
  r8.xyzw = t8.SampleLevel(s0_s, float2(0.5,0.5), 10).xyzw;
  // Fetch light/cluster indices from the structured buffers for this instance.
  r9.xyzw = (uint4)cb2[r6.z+17].xyzw;
  r7.w = t3[r9.x].val[112/4];
  r7.w = (uint)r7.w;
  r10.x = t3[r9.y].val[112/4];
  r10.y = t3[r9.z].val[112/4];
  r10.z = t3[r9.w].val[112/4];
  r10.xyz = (uint3)r10.xyz;
  r10.w = t3[r9.x].val[160/4];
  r10.w = cmp(0 < r10.w);
  r11.x = t3[r9.y].val[160/4];
  r12.x = t3[r9.x].val[0/4];
  r12.y = t3[r9.x].val[0/4+1];
  r12.z = t3[r9.x].val[0/4+2];
  r12.w = t3[r9.x].val[0/4+3];
  r13.x = t3[r9.x].val[16/4];
  r13.y = t3[r9.x].val[16/4+1];
  r13.z = t3[r9.x].val[16/4+2];
  r13.w = t3[r9.x].val[16/4+3];
  r14.x = t3[r9.x].val[32/4];
  r14.y = t3[r9.x].val[32/4+1];
  r14.z = t3[r9.x].val[32/4+2];
  r14.w = t3[r9.x].val[32/4+3];
  r15.x = t3[r9.x].val[48/4];
  r15.y = t3[r9.x].val[48/4+1];
  r15.z = t3[r9.x].val[48/4+2];
  r15.w = t3[r9.x].val[48/4+3];
  r11.y = t3[r9.x].val[128/4];
  r11.z = t3[r9.x].val[128/4+1];
  r11.w = t3[r9.x].val[128/4+2];
  r16.x = t3[r9.x].val[144/4];
  r16.y = t3[r9.x].val[144/4+1];
  r16.z = t3[r9.x].val[144/4+2];
  r16.w = t3[r9.x].val[144/4+3];
  r11.x = cmp(0 < r11.x);
  // Build an orthonormal 2D basis from the camera right/up vectors (used for wind/projected texture math).
  r17.x = dot(cb0[70].xy, cb0[70].xy);
  r17.y = sqrt(r17.x);
  r17.z = cmp(0.100000001 < r17.y);
  r17.x = rsqrt(r17.x);
  r17.xw = cb0[70].xy * r17.xx;
  r18.xy = r17.zz ? r17.xw : float2(1,0);
  r18.zw = -r18.yy;
  r17.x = dot(r18.xz, r18.xw);
  r17.x = rsqrt(r17.x);
  r17.zw = float2(-1,1) * r18.yx;
  r17.xz = r17.zw * r17.xx;
  r19.x = r12.z;
  r19.y = r13.z;
  r18.zw = r19.xy / r14.zz;
  r12.z = 0.00100000005 * cb0[99].w;
  r20.x = cb0[96].w * r17.y;
  r20.y = 0;
  r13.z = 1 + -cb0[98].w;
  r13.z = max(0.00100000005, r13.z);
  r13.z = 2 / r13.z;
  r17.y = 1 + -cb0[99].y;
  r17.w = saturate(r17.y);
  r20.zw = float2(-1,-2) + r13.zz;
  r13.z = log2(r17.w);
  r13.z = -r20.w * r13.z;
  r13.z = exp2(r13.z);
  r17.w = saturate(cb0[99].y);
  r17.w = log2(r17.w);
  r17.w = -r20.w * r17.w;
  r17.w = exp2(r17.w);
  r20.w = t3[r9.z].val[160/4];
  r21.x = t3[r9.y].val[0/4];
  r21.y = t3[r9.y].val[0/4+1];
  r21.z = t3[r9.y].val[0/4+2];
  r21.w = t3[r9.y].val[0/4+3];
  r22.x = t3[r9.y].val[16/4];
  r22.y = t3[r9.y].val[16/4+1];
  r22.z = t3[r9.y].val[16/4+2];
  r22.w = t3[r9.y].val[16/4+3];
  r23.x = t3[r9.y].val[32/4];
  r23.y = t3[r9.y].val[32/4+1];
  r23.z = t3[r9.y].val[32/4+2];
  r23.w = t3[r9.y].val[32/4+3];
  r24.x = t3[r9.y].val[48/4];
  r24.y = t3[r9.y].val[48/4+1];
  r24.z = t3[r9.y].val[48/4+2];
  r24.w = t3[r9.y].val[48/4+3];
  r25.x = t3[r9.y].val[128/4];
  r25.y = t3[r9.y].val[128/4+1];
  r25.z = t3[r9.y].val[128/4+2];
  r26.x = t3[r9.y].val[144/4];
  r26.y = t3[r9.y].val[144/4+1];
  r26.z = t3[r9.y].val[144/4+2];
  r26.w = t3[r9.y].val[144/4+3];
  r20.w = cmp(0 < r20.w);
  r27.x = r21.z;
  r27.y = r22.z;
  r28.xy = r27.xy / r23.zz;
  r21.z = t3[r9.w].val[160/4];
  r29.x = t3[r9.z].val[0/4];
  r29.y = t3[r9.z].val[0/4+1];
  r29.z = t3[r9.z].val[0/4+2];
  r29.w = t3[r9.z].val[0/4+3];
  r30.x = t3[r9.z].val[16/4];
  r30.y = t3[r9.z].val[16/4+1];
  r30.z = t3[r9.z].val[16/4+2];
  r30.w = t3[r9.z].val[16/4+3];
  r31.x = t3[r9.z].val[32/4];
  r31.y = t3[r9.z].val[32/4+1];
  r31.z = t3[r9.z].val[32/4+2];
  r31.w = t3[r9.z].val[32/4+3];
  r32.x = t3[r9.z].val[48/4];
  r32.y = t3[r9.z].val[48/4+1];
  r32.z = t3[r9.z].val[48/4+2];
  r32.w = t3[r9.z].val[48/4+3];
  r33.x = t3[r9.z].val[128/4];
  r33.y = t3[r9.z].val[128/4+1];
  r33.z = t3[r9.z].val[128/4+2];
  r34.x = t3[r9.z].val[144/4];
  r34.y = t3[r9.z].val[144/4+1];
  r34.z = t3[r9.z].val[144/4+2];
  r34.w = t3[r9.z].val[144/4+3];
  r21.z = cmp(0 < r21.z);
  r35.x = r29.z;
  r35.y = r30.z;
  r28.zw = r35.xy / r31.zz;
  r36.x = t3[r9.x].val[64/4+3];
  r36.y = t3[r9.x].val[64/4];
  r36.z = t3[r9.x].val[64/4+1];
  r36.w = t3[r9.x].val[64/4+2];
  r37.x = t3[r9.w].val[0/4];
  r37.y = t3[r9.w].val[0/4+1];
  r37.z = t3[r9.w].val[0/4+2];
  r37.w = t3[r9.w].val[0/4+3];
  r38.x = t3[r9.w].val[16/4];
  r38.y = t3[r9.w].val[16/4+1];
  r38.z = t3[r9.w].val[16/4+2];
  r38.w = t3[r9.w].val[16/4+3];
  r39.x = t3[r9.w].val[32/4];
  r39.y = t3[r9.w].val[32/4+1];
  r39.z = t3[r9.w].val[32/4+2];
  r39.w = t3[r9.w].val[32/4+3];
  r40.x = t3[r9.w].val[48/4];
  r40.y = t3[r9.w].val[48/4+1];
  r40.z = t3[r9.w].val[48/4+2];
  r40.w = t3[r9.w].val[48/4+3];
  r41.x = t3[r9.w].val[128/4];
  r41.y = t3[r9.w].val[128/4+1];
  r41.z = t3[r9.w].val[128/4+2];
  r42.x = t3[r9.w].val[144/4];
  r42.y = t3[r9.w].val[144/4+1];
  r42.z = t3[r9.w].val[144/4+2];
  r42.w = t3[r9.w].val[144/4+3];
  r43.x = t3[r9.x].val[80/4];
  r43.y = t3[r9.x].val[80/4+1];
  r43.z = t3[r9.x].val[80/4+2];
  r43.w = t3[r9.x].val[80/4+3];
  r44.x = r37.z;
  r44.y = r38.z;
  r45.xy = r44.xy / r39.zz;
  r46.x = t3[r9.x].val[96/4];
  r46.y = t3[r9.x].val[96/4+1];
  r46.z = t3[r9.x].val[96/4+2];
  r46.w = t3[r9.x].val[96/4+3];
  r45.zw = cmp((int2)r7.ww == int2(1,2));
  r9.x = -r43.w + r36.x;
  r47.x = t3[r9.y].val[64/4+3];
  r47.y = t3[r9.y].val[64/4];
  r47.z = t3[r9.y].val[64/4+1];
  r47.w = t3[r9.y].val[64/4+2];
  r22.z = dot(abs(r46.xyz), float3(1,1,1));
  r22.z = 2 * r22.z;
  r22.z = sqrt(r22.z);
  r22.z = r46.w * r22.z;
  r36.x = saturate(r36.x);
  r25.w = r36.x * 92.9289322 + 7.07106781;
  r29.z = r25.w * r25.w;
  r29.z = 0.200000003 * r29.z;
  r25.w = r46.w / r25.w;
  r48.x = t3[r9.y].val[80/4];
  r48.y = t3[r9.y].val[80/4+1];
  r48.z = t3[r9.y].val[80/4+2];
  r48.w = t3[r9.y].val[80/4+3];
  r49.x = t3[r9.y].val[96/4];
  r49.y = t3[r9.y].val[96/4+1];
  r49.z = t3[r9.y].val[96/4+2];
  r49.w = t3[r9.y].val[96/4+3];
  r9.y = -r48.w + r47.x;
  r51.x = t3[r9.z].val[64/4+3];
  r51.y = t3[r9.z].val[64/4];
  r51.z = t3[r9.z].val[64/4+1];
  r51.w = t3[r9.z].val[64/4+2];
  r30.z = dot(abs(r49.xyz), float3(1,1,1));
  r30.z = 2 * r30.z;
  r30.z = sqrt(r30.z);
  r30.z = r49.w * r30.z;
  r47.x = saturate(r47.x);
  r33.w = r47.x * 92.9289322 + 7.07106781;
  r36.x = r33.w * r33.w;
  r36.x = 0.200000003 * r36.x;
  r33.w = r49.w / r33.w;
  r52.x = t3[r9.z].val[80/4];
  r52.y = t3[r9.z].val[80/4+1];
  r52.z = t3[r9.z].val[80/4+2];
  r52.w = t3[r9.z].val[80/4+3];
  r53.x = t3[r9.z].val[96/4];
  r53.y = t3[r9.z].val[96/4+1];
  r53.z = t3[r9.z].val[96/4+2];
  r53.w = t3[r9.z].val[96/4+3];
  r50.xyzw = cmp((int4)r10.xxyy == int4(1,2,1,2));
  r9.z = -r52.w + r51.x;
  r54.x = t3[r9.w].val[64/4+3];
  r54.y = t3[r9.w].val[64/4];
  r54.z = t3[r9.w].val[64/4+1];
  r54.w = t3[r9.w].val[64/4+2];
  r37.z = dot(abs(r53.xyz), float3(1,1,1));
  r37.z = 2 * r37.z;
  r37.z = sqrt(r37.z);
  r37.z = r53.w * r37.z;
  r51.x = saturate(r51.x);
  r38.z = r51.x * 92.9289322 + 7.07106781;
  r41.w = r38.z * r38.z;
  r41.w = 0.200000003 * r41.w;
  r38.z = r53.w / r38.z;
  r55.x = t3[r9.w].val[80/4];
  r55.y = t3[r9.w].val[80/4+1];
  r55.z = t3[r9.w].val[80/4+2];
  r55.w = t3[r9.w].val[80/4+3];
  r56.x = t3[r9.w].val[96/4];
  r56.y = t3[r9.w].val[96/4+1];
  r56.z = t3[r9.w].val[96/4+2];
  r56.w = t3[r9.w].val[96/4+3];
  r57.xy = cmp((int2)r10.zz == int2(1,2));
  r9.w = -r55.w + r54.x;
  r47.x = dot(abs(r56.xyz), float3(1,1,1));
  r47.x = 2 * r47.x;
  r47.x = sqrt(r47.x);
  r47.x = r56.w * r47.x;
  r54.x = saturate(r54.x);
  r51.x = r54.x * 92.9289322 + 7.07106781;
  r54.x = r51.x * r51.x;
  r54.x = 0.200000003 * r54.x;
  r51.x = r56.w / r51.x;
  // Ambient lighting that fills the fog once all punctual lights are applied.
  r58.xyz = t0.SampleLevel(s1_s, float3(0,1,0), 10).xyz;
  r59.xyz = t1.SampleLevel(s1_s, float3(0,1,0), 10).xyz;
  r59.xyz = cb0[50].xxx * r59.xyz;
  r58.xyz = r58.xyz * cb0[50].xxx + r59.xyz;
  r57.z = asint(cb1[10].z) + -1;
  r59.xyz = float3(1,1,1);
  r60.zw = float2(0,0);
  r61.z = 0;
  r62.w = 1;
  r63.x = r12.x;
  r63.y = r13.x;
  r63.z = r14.x;
  r63.w = r15.x;
  r64.x = r12.y;
  r64.y = r13.y;
  r64.z = r14.y;
  r64.w = r15.y;
  r19.z = r14.z;
  r19.w = r15.z;
  r15.x = r12.w;
  r15.y = r13.w;
  r15.z = r14.w;
  r14.w = 1;
  r65.w = 1;
  r66.x = r21.x;
  r66.y = r22.x;
  r66.z = r23.x;
  r66.w = r24.x;
  r67.x = r21.y;
  r67.y = r22.y;
  r67.z = r23.y;
  r67.w = r24.y;
  r27.z = r23.z;
  r27.w = r24.z;
  r24.x = r21.w;
  r24.y = r22.w;
  r24.z = r23.w;
  r23.w = 1;
  r68.w = 1;
  r69.x = r29.x;
  r69.y = r30.x;
  r69.z = r31.x;
  r69.w = r32.x;
  r70.x = r29.y;
  r70.y = r30.y;
  r70.z = r31.y;
  r70.w = r32.y;
  r35.z = r31.z;
  r35.w = r32.z;
  r32.x = r29.w;
  r32.y = r30.w;
  r32.z = r31.w;
  r31.w = 1;
  r71.w = 1;
  r72.x = r37.x;
  r72.y = r38.x;
  r72.z = r39.x;
  r72.w = r40.x;
  r73.x = r37.y;
  r73.y = r38.y;
  r73.z = r39.y;
  r73.w = r40.y;
  r44.z = r39.z;
  r44.w = r40.z;
  r40.x = r37.w;
  r40.y = r38.w;
  r40.z = r39.w;
  r39.w = 1;
  r74.z = 0;
  r75.w = 0;
  r76.y = r3.x;
  r76.xz = r6.xy;
  r76.w = r4.x;
  r12.xyw = float3(0,0,0);
  r13.x = r4.y;
  r13.y = r5.x;
  r13.w = r3.w;
  r21.xyw = float3(0,0,1);
  // Main volumetric march: advance along the stochastic ray, gather lighting, and accumulate fog color.
  while (true) {
    r22.x = cmp((uint)r21.x >= (uint)r13.w);
    if (r22.x != 0) break;
    r22.x = (int)r76.x + (int)r21.y;
    r22.y = (int)r21.y;
    r22.y = r22.y + r76.y;
    r22.w = r22.y * r13.y;
    r22.y = r22.y * r13.y + -r13.y;
    r29.x = r13.x + -r76.w;
    r29.y = saturate(r22.w * r29.x + r76.w);
    r22.y = saturate(r22.y * r29.x + r76.w);
    r62.xyz = r5.yzw * r29.yyy + cb0[85].xyz;
    r14.xyz = r5.yzw * r22.yyy + cb0[85].xyz;
    r29.xyw = r62.xyz + -r14.xyz;
    r22.y = dot(r29.xyw, r29.xyw);
    r22.y = sqrt(r22.y);
    r22.y = r22.y / r76.z;
    r77.xyzw = r22.wwww * r1.xyzw + r2.xyzw;
    r29.x = r22.w * r0.z + r0.y;
    r29.yw = -cb2[r6.z+20].xy + r62.xy;
    r29.y = dot(r29.yw, r29.yw);
    r29.y = sqrt(r29.y);
    r29.w = cmp(0 < abs(r29.x));
    r29.x = r29.y / r29.x;
    r29.x = r29.w ? r29.x : 0;
    r29.x = saturate(r29.x);
    r29.x = 1 + -r29.x;
    r78.x = mad((int)r22.x, 0x0019660d, 0xd17070a0);
    r78.y = mad(0x3c6ef35f, (int)r78.x, 0x3c6ef35f);
    r78.z = mad((int)r78.x, (int)r78.y, 0x3c6ef35f);
    r30.xyw = (uint3)r78.xyz >> int3(16,16,16);
    r30.xyw = (int3)r30.xyw ^ (int3)r78.xyz;
    r29.y = mad((int)r30.y, (int)r30.w, (int)r30.x);
    r29.w = mad((int)r30.w, (int)r29.y, (int)r30.y);
    r30.x = mad((int)r29.y, (int)r29.w, (int)r30.w);
    r29.y = (uint)r29.y >> 9;
    r29.y = (int)r29.y + 0x3f800000;
    r37.x = -1 + r29.y;
    r29.y = (uint)r29.w >> 9;
    r29.y = (int)r29.y + 0x3f800000;
    r37.y = -1 + r29.y;
    r29.y = (uint)r30.x >> 9;
    r29.y = (int)r29.y + 0x3f800000;
    r29.y = -1 + r29.y;
    r29.y = cb0[96].w * cb1[9].w + r29.y;
    r30.xy = r22.ww * r7.xy + cb1[9].xy;
    r38.xy = cb1[9].zz * r62.xy;
    r37.xy = r38.xy * float2(0.00100000005,0.00100000005) + r37.xy;
    r37.xy = t7.Sample(s0_s, r37.xy).xy;
    r37.xy = r37.xy * float2(2,2) + float2(-1,-1);
    r37.xy = cb1[8].ww * r37.xy;
    r37.xy = r37.xy / cb1[9].ww;
    r37.xy = r6.ww ? r37.xy : 0;
    r30.xy = r37.xy + r30.xy;
    r30.xy = cb2[r6.z+19].xy * r7.zz + r30.xy;
    r37.xy = cb1[7].ww * r62.xy;
    r37.xy = r37.xy * float2(0.00100000005,0.00100000005) + r3.yz;
    r61.y = (int)r22.x;
    r22.xw = r29.yy * float2(0.5,0.5) + float2(0.5,0);
    r29.yw = frac(r22.xw);
    r22.xw = floor(r22.xw);
    r22.xw = r22.xw * float2(2,2) + float2(0,1);
    r38.xy = float2(1,1) + -r29.yw;
    r38.xy = min(r38.xy, r29.yw);
    r38.xy = float2(2,2) * r38.xy;
    r78.xyzw = float4(0,0,0,0);
    r30.w = 0;
    r37.w = 0;
    while (true) {
      r38.w = cmp((int)r37.w >= 2);
      if (r38.w != 0) break;
      r61.x = dot(r22.xw, icb[r37.w+0].xy);
      r79.xyz = float3(0.103100002,0.103,0.0973000005) * r61.xyz;
      r79.xyz = frac(r79.xyz);
      r61.xw = float2(19.1900005,19.1900005) + r79.yx;
      r38.w = dot(r79.xy, r61.xw);
      r79.xyz = r79.xyz + r38.www;
      r61.xw = r79.xx + r79.yx;
      r61.xw = r61.xw * r79.zy;
      r61.xw = frac(r61.xw);
      r61.xw = r61.xw + r37.xy;
      r38.w = dot(r29.yw, icb[r37.w+0].xy);
      r38.w = r38.w * 2 + -1;
      r61.xw = r30.xy * r38.ww + r61.xw;
      r79.xyzw = t8.SampleLevel(s0_s, r61.xw, 0).xyzw;
      r38.w = dot(r38.xy, icb[r37.w+0].xy);
      r30.w = r38.w * r38.w + r30.w;
      r78.xyzw = r79.xyzw * r38.wwww + r78.xyzw;
      r37.w = (int)r37.w + 1;
    }
    r79.xyzw = r78.xyzw + -r8.xyzw;
    r22.x = sqrt(r30.w);
    r79.xyzw = r79.xyzw / r22.xxxx;
    r79.xyzw = r79.xyzw + r8.xyzw;
    r22.x = saturate(dot(r79.xyzw, cb1[4].xyzw));
    r59.w = saturate(-r0.x * r29.x + r22.x);
    r77.xyzw = r77.xyzw * r59.xyzw;
    r22.x = cb1[7].z * r77.w;
    r29.xyw = cb0[21].xyw * r62.yyy;
    r29.xyw = r62.xxx * cb0[20].xyw + r29.xyw;
    r29.xyw = r62.zzz * cb0[22].xyw + r29.xyw;
    r29.xyw = cb0[23].xyw + r29.xyw;
    r29.xy = r29.xy / r29.ww;
    r79.xy = r29.xy * float2(0.5,0.5) + float2(0.5,0.5);
    r79.z = 1 + -r79.y;
    r29.xy = r79.xz * r4.zw;
    if (r10.w != 0) {
      r79.x = dot(r62.xyzw, r63.xyzw);
      r79.y = dot(r62.xyzw, r64.xyzw);
      r30.x = dot(r62.xyzw, r19.xyzw);
      r79.w = dot(r62.xyzw, r15.xyzw);
      r80.x = dot(r14.xyzw, r63.xyzw);
      r80.y = dot(r14.xyzw, r64.xyzw);
      r30.y = dot(r14.xyzw, r19.xyzw);
      r80.w = dot(r14.xyzw, r15.xyzw);
      r37.xy = r30.xy * r11.ww + float2(1,1);
      r22.w = r37.x / r79.w;
      r38.x = r30.x + -r22.w;
      r22.w = r37.y / r80.w;
      r38.y = r30.y + -r22.w;
      r30.xy = r7.ww ? r38.xy : r30.xy;
      r79.z = r30.x;
      r79.xyzw = r79.xyzw / r79.wwww;
      r80.z = r30.y;
      r80.xyzw = r80.xyzw / r80.wwww;
      r80.xyzw = r80.xyzw + -r79.xyzw;
      r22.w = 0;
      r29.w = 0;
      while (true) {
        r30.x = cmp((int)r29.w >= 7);
        if (r30.x != 0) break;
        r30.x = (int)r29.w;
        r30.x = r0.w * 0.0625 + r30.x;
        r30.x = 0.142857149 * r30.x;
        r81.xyzw = r30.xxxx * r80.xyzw + r79.xyzw;
        if (r7.w == 0) {
          r30.xy = icb[r29.w+2].wy * r11.yz + r81.xy;
        } else {
          r30.xy = icb[r29.w+2].wy * float2(0.00300000003,0.00300000003) + r81.xy;
        }
        r30.xy = saturate(r30.xy);
        r30.xy = r30.xy * r16.zw + r16.xy;
        r30.xy = r30.xy / r81.ww;
        r37.x = r81.z / r81.w;
        r30.x = t5.SampleCmpLevelZero(s15_s, r30.xy, r37.x).x;
        r22.w = r30.x + r22.w;
        r29.w = (int)r29.w + 1;
      }
      if (r7.w == 0) {
        r30.xy = cb0[48].xy + -r62.xy;
        r29.w = dot(r30.xy, r30.xy);
        r29.w = sqrt(r29.w);
        r29.w = r29.w / cb0[98].z;
        r29.w = saturate(1 + -r29.w);
        r30.x = r29.w * -2 + 3;
        r29.w = r29.w * r29.w;
        r29.w = r30.x * r29.w;
        r30.xy = -r18.zw * float2(1000,1000) + r62.xy;
        r37.x = dot(r18.xy, r30.xy);
        r37.y = dot(r17.xz, r30.xy);
        r30.xy = r37.xy + r20.xy;
        r30.xy = r30.xy * r12.zz;
        r30.x = t2.SampleLevel(s8_s, r30.xy, 0).w;
        r30.x = saturate(r29.w * cb0[98].y + r30.x);
        r30.y = max(cb0[99].y, r30.x);
        r30.y = 1 + -r30.y;
        r30.y = max(0, r30.y);
        r30.y = log2(r30.y);
        r30.y = r30.y * r20.z;
        r30.y = exp2(r30.y);
        r30.x = min(cb0[99].y, r30.x);
        r30.x = max(0, r30.x);
        r30.x = log2(r30.x);
        r30.x = r30.x * r20.z;
        r30.x = exp2(r30.x);
        r30.x = r30.x * r17.w;
        r30.x = -r30.y * r13.z + r30.x;
        r30.x = saturate(r30.x + r17.y);
        r29.w = saturate(r29.w * cb0[97].w + r30.x);
        r29.w = -1 + r29.w;
        r29.w = cb0[99].z * r29.w + 1;
        r22.w = r29.w * r22.w;
      }
      r29.w = 0.142857149 * r22.w;
    } else {
      r29.w = 1;
    }
    if (r11.x != 0) {
      r65.xyz = r62.xyz;
      r79.x = dot(r65.xyzw, r66.xyzw);
      r79.y = dot(r65.xyzw, r67.xyzw);
      r30.x = dot(r65.xyzw, r27.xyzw);
      r79.w = dot(r65.xyzw, r24.xyzw);
      r23.xyz = r14.xyz;
      r80.x = dot(r23.xyzw, r66.xyzw);
      r80.y = dot(r23.xyzw, r67.xyzw);
      r30.y = dot(r23.xyzw, r27.xyzw);
      r80.w = dot(r23.xyzw, r24.xyzw);
      r23.xy = r30.xy * r25.zz + float2(1,1);
      r23.x = r23.x / r79.w;
      r37.x = r30.x + -r23.x;
      r23.x = r23.y / r80.w;
      r37.y = r30.y + -r23.x;
      r23.xy = r10.xx ? r37.xy : r30.xy;
      r79.z = r23.x;
      r79.xyzw = r79.xyzw / r79.wwww;
      r80.z = r23.y;
      r80.xyzw = r80.xyzw / r80.wwww;
      r80.xyzw = r80.xyzw + -r79.xyzw;
      r23.xy = float2(0,0);
      while (true) {
        r23.z = cmp((int)r23.y >= 7);
        if (r23.z != 0) break;
        r23.z = (int)r23.y;
        r23.z = r0.w * 0.0625 + r23.z;
        r23.z = 0.142857149 * r23.z;
        r81.xyzw = r23.zzzz * r80.xyzw + r79.xyzw;
        if (r10.x == 0) {
          r30.xy = icb[r23.y+2].wy * r25.xy + r81.xy;
        } else {
          r30.xy = icb[r23.y+2].wy * float2(0.00300000003,0.00300000003) + r81.xy;
        }
        r30.xy = saturate(r30.xy);
        r30.xy = r30.xy * r26.zw + r26.xy;
        r30.xy = r30.xy / r81.ww;
        r23.z = r81.z / r81.w;
        r23.z = t5.SampleCmpLevelZero(s15_s, r30.xy, r23.z).x;
        r23.x = r23.x + r23.z;
        r23.y = (int)r23.y + 1;
      }
      if (r10.x == 0) {
        r23.yz = cb0[48].xy + -r62.xy;
        r23.y = dot(r23.yz, r23.yz);
        r23.y = sqrt(r23.y);
        r23.y = r23.y / cb0[98].z;
        r23.y = saturate(1 + -r23.y);
        r23.z = r23.y * -2 + 3;
        r23.y = r23.y * r23.y;
        r23.y = r23.z * r23.y;
        r30.xy = -r28.xy * float2(1000,1000) + r62.xy;
        r37.x = dot(r18.xy, r30.xy);
        r37.y = dot(r17.xz, r30.xy);
        r30.xy = r37.xy + r20.xy;
        r30.xy = r30.xy * r12.zz;
        r23.z = t2.SampleLevel(s8_s, r30.xy, 0).w;
        r23.z = saturate(r23.y * cb0[98].y + r23.z);
        r30.x = max(cb0[99].y, r23.z);
        r30.x = 1 + -r30.x;
        r30.x = max(0, r30.x);
        r30.x = log2(r30.x);
        r30.x = r30.x * r20.z;
        r30.x = exp2(r30.x);
        r23.z = min(cb0[99].y, r23.z);
        r23.z = max(0, r23.z);
        r23.z = log2(r23.z);
        r23.z = r23.z * r20.z;
        r23.z = exp2(r23.z);
        r23.z = r23.z * r17.w;
        r23.z = -r30.x * r13.z + r23.z;
        r23.z = saturate(r23.z + r17.y);
        r23.y = saturate(r23.y * cb0[97].w + r23.z);
        r23.y = -1 + r23.y;
        r23.y = cb0[99].z * r23.y + 1;
        r23.x = r23.x * r23.y;
      }
      r23.y = 0.142857149 * r23.x;
    } else {
      r23.y = 1;
    }
    if (r20.w != 0) {
      r68.xyz = r62.xyz;
      r79.x = dot(r68.xyzw, r69.xyzw);
      r79.y = dot(r68.xyzw, r70.xyzw);
      r30.x = dot(r68.xyzw, r35.xyzw);
      r79.w = dot(r68.xyzw, r32.xyzw);
      r31.xyz = r14.xyz;
      r80.x = dot(r31.xyzw, r69.xyzw);
      r80.y = dot(r31.xyzw, r70.xyzw);
      r30.y = dot(r31.xyzw, r35.xyzw);
      r80.w = dot(r31.xyzw, r32.xyzw);
      r31.xy = r30.xy * r33.zz + float2(1,1);
      r23.z = r31.x / r79.w;
      r37.x = r30.x + -r23.z;
      r23.z = r31.y / r80.w;
      r37.y = r30.y + -r23.z;
      r30.xy = r10.yy ? r37.xy : r30.xy;
      r79.z = r30.x;
      r79.xyzw = r79.xyzw / r79.wwww;
      r80.z = r30.y;
      r80.xyzw = r80.xyzw / r80.wwww;
      r80.xyzw = r80.xyzw + -r79.xyzw;
      r23.z = 0;
      r30.x = 0;
      while (true) {
        r30.y = cmp((int)r30.x >= 7);
        if (r30.y != 0) break;
        r30.y = (int)r30.x;
        r30.y = r0.w * 0.0625 + r30.y;
        r30.y = 0.142857149 * r30.y;
        r81.xyzw = r30.yyyy * r80.xyzw + r79.xyzw;
        if (r10.y == 0) {
          r31.xy = icb[r30.x+2].wy * r33.xy + r81.xy;
        } else {
          r31.xy = icb[r30.x+2].wy * float2(0.00300000003,0.00300000003) + r81.xy;
        }
        r31.xy = saturate(r31.xy);
        r31.xy = r31.xy * r34.zw + r34.xy;
        r31.xy = r31.xy / r81.ww;
        r30.y = r81.z / r81.w;
        r30.y = t5.SampleCmpLevelZero(s15_s, r31.xy, r30.y).x;
        r23.z = r30.y + r23.z;
        r30.x = (int)r30.x + 1;
      }
      if (r10.y == 0) {
        r30.xy = cb0[48].xy + -r62.xy;
        r30.x = dot(r30.xy, r30.xy);
        r30.x = sqrt(r30.x);
        r30.x = r30.x / cb0[98].z;
        r30.x = saturate(1 + -r30.x);
        r30.y = r30.x * -2 + 3;
        r30.x = r30.x * r30.x;
        r30.x = r30.y * r30.x;
        r31.xy = -r28.zw * float2(1000,1000) + r62.xy;
        r37.x = dot(r18.xy, r31.xy);
        r37.y = dot(r17.xz, r31.xy);
        r31.xy = r37.xy + r20.xy;
        r31.xy = r31.xy * r12.zz;
        r30.y = t2.SampleLevel(s8_s, r31.xy, 0).w;
        r30.y = saturate(r30.x * cb0[98].y + r30.y);
        r31.x = max(cb0[99].y, r30.y);
        r31.x = 1 + -r31.x;
        r31.x = max(0, r31.x);
        r31.x = log2(r31.x);
        r31.x = r31.x * r20.z;
        r31.x = exp2(r31.x);
        r30.y = min(cb0[99].y, r30.y);
        r30.y = max(0, r30.y);
        r30.y = log2(r30.y);
        r30.y = r30.y * r20.z;
        r30.y = exp2(r30.y);
        r30.y = r30.y * r17.w;
        r30.y = -r31.x * r13.z + r30.y;
        r30.y = saturate(r30.y + r17.y);
        r30.x = saturate(r30.x * cb0[97].w + r30.y);
        r30.x = -1 + r30.x;
        r30.x = cb0[99].z * r30.x + 1;
        r23.z = r30.x * r23.z;
      }
      r30.x = 0.142857149 * r23.z;
    } else {
      r30.x = 1;
    }
    if (r21.z != 0) {
      r71.xyz = r62.xyz;
      r79.x = dot(r71.xyzw, r72.xyzw);
      r79.y = dot(r71.xyzw, r73.xyzw);
      r31.x = dot(r71.xyzw, r44.xyzw);
      r79.w = dot(r71.xyzw, r40.xyzw);
      r39.xyz = r14.xyz;
      r80.x = dot(r39.xyzw, r72.xyzw);
      r80.y = dot(r39.xyzw, r73.xyzw);
      r31.y = dot(r39.xyzw, r44.xyzw);
      r80.w = dot(r39.xyzw, r40.xyzw);
      r14.xy = r31.xy * r41.zz + float2(1,1);
      r14.x = r14.x / r79.w;
      r37.x = r31.x + -r14.x;
      r14.x = r14.y / r80.w;
      r37.y = r31.y + -r14.x;
      r14.xy = r10.zz ? r37.xy : r31.xy;
      r79.z = r14.x;
      r79.xyzw = r79.xyzw / r79.wwww;
      r80.z = r14.y;
      r80.xyzw = r80.xyzw / r80.wwww;
      r80.xyzw = r80.xyzw + -r79.xyzw;
      r14.xy = float2(0,0);
      while (true) {
        r14.z = cmp((int)r14.y >= 7);
        if (r14.z != 0) break;
        r14.z = (int)r14.y;
        r14.z = r0.w * 0.0625 + r14.z;
        r14.z = 0.142857149 * r14.z;
        r81.xyzw = r14.zzzz * r80.xyzw + r79.xyzw;
        if (r10.z == 0) {
          r31.xy = icb[r14.y+2].wy * r41.xy + r81.xy;
        } else {
          r31.xy = icb[r14.y+2].wy * float2(0.00300000003,0.00300000003) + r81.xy;
        }
        r31.xy = saturate(r31.xy);
        r31.xy = r31.xy * r42.zw + r42.xy;
        r31.xy = r31.xy / r81.ww;
        r14.z = r81.z / r81.w;
        r14.z = t5.SampleCmpLevelZero(s15_s, r31.xy, r14.z).x;
        r14.x = r14.x + r14.z;
        r14.y = (int)r14.y + 1;
      }
      if (r10.z == 0) {
        r14.yz = cb0[48].xy + -r62.xy;
        r14.y = dot(r14.yz, r14.yz);
        r14.y = sqrt(r14.y);
        r14.y = r14.y / cb0[98].z;
        r14.y = saturate(1 + -r14.y);
        r14.z = r14.y * -2 + 3;
        r14.y = r14.y * r14.y;
        r14.y = r14.z * r14.y;
        r31.xy = -r45.xy * float2(1000,1000) + r62.xy;
        r37.x = dot(r18.xy, r31.xy);
        r37.y = dot(r17.xz, r31.xy);
        r31.xy = r37.xy + r20.xy;
        r31.xy = r31.xy * r12.zz;
        r14.z = t2.SampleLevel(s8_s, r31.xy, 0).w;
        r14.z = saturate(r14.y * cb0[98].y + r14.z);
        r30.y = max(cb0[99].y, r14.z);
        r30.y = 1 + -r30.y;
        r30.y = max(0, r30.y);
        r30.y = log2(r30.y);
        r30.y = r30.y * r20.z;
        r30.y = exp2(r30.y);
        r14.z = min(cb0[99].y, r14.z);
        r14.z = max(0, r14.z);
        r14.z = log2(r14.z);
        r14.z = r20.z * r14.z;
        r14.z = exp2(r14.z);
        r14.z = r14.z * r17.w;
        r14.z = -r30.y * r13.z + r14.z;
        r14.z = saturate(r17.y + r14.z);
        r14.y = saturate(r14.y * cb0[97].w + r14.z);
        r14.y = -1 + r14.y;
        r14.y = cb0[99].z * r14.y + 1;
        r14.x = r14.x * r14.y;
      }
      r14.y = 0.142857149 * r14.x;
    } else {
      r14.y = 1;
    }
    if (r7.w == 0) {
      r31.xyz = r46.xyz;
    } else {
      r31.xyz = float3(0,0,0);
    }
    if (r45.z != 0) {
      r37.xyw = -r62.xyz + r36.yzw;
      r14.z = dot(r37.xyw, r37.xyw);
      r14.z = sqrt(r14.z);
      r37.xyw = r37.xyw / r14.zzz;
      r14.z = saturate(r14.z / r46.w);
      r14.z = 1 + -r14.z;
      r30.y = dot(-r43.xyz, r37.xyw);
      r30.y = r30.y + -r43.w;
      r30.y = saturate(r30.y / r9.x);
      r14.z = r30.y * r14.z;
      r31.xyz = r46.xyz * r14.zzz;
    }
    if (r45.w != 0) {
      r37.xyw = -r62.xyz + r36.yzw;
      r14.z = dot(r37.xyw, r37.xyw);
      r14.z = sqrt(r14.z);
      r30.y = r14.z / r25.w;
      r30.y = 1 + r30.y;
      r14.z = r14.z / r22.z;
      r14.z = r14.z * r14.z;
      r14.z = saturate(-r14.z * r14.z + 1);
      r14.z = r14.z * r14.z;
      r14.z = r29.z * r14.z;
      r30.y = r30.y * r30.y;
      r14.z = r14.z / r30.y;
      r14.z = min(10, r14.z);
      r31.xyz = r46.xyz * r14.zzz;
    }
    if (r10.x == 0) {
      r37.xyw = r49.xyz;
    } else {
      r37.xyw = float3(0,0,0);
    }
    if (r50.x != 0) {
      r38.xyw = -r62.xyz + r47.yzw;
      r14.z = dot(r38.xyw, r38.xyw);
      r14.z = sqrt(r14.z);
      r38.xyw = r38.xyw / r14.zzz;
      r14.z = saturate(r14.z / r49.w);
      r14.z = 1 + -r14.z;
      r30.y = dot(-r48.xyz, r38.xyw);
      r30.y = r30.y + -r48.w;
      r30.y = saturate(r30.y / r9.y);
      r14.z = r30.y * r14.z;
      r37.xyw = r49.xyz * r14.zzz;
    }
    if (r50.y != 0) {
      r38.xyw = -r62.xyz + r47.yzw;
      r14.z = dot(r38.xyw, r38.xyw);
      r14.z = sqrt(r14.z);
      r30.y = r14.z / r33.w;
      r30.y = 1 + r30.y;
      r14.z = r14.z / r30.z;
      r14.z = r14.z * r14.z;
      r14.z = saturate(-r14.z * r14.z + 1);
      r14.z = r14.z * r14.z;
      r14.z = r36.x * r14.z;
      r30.y = r30.y * r30.y;
      r14.z = r14.z / r30.y;
      r14.z = min(10, r14.z);
      r37.xyw = r49.xyz * r14.zzz;
    }
    r37.xyw = r37.xyw * r23.yyy;
    r31.xyz = r31.xyz * r29.www + r37.xyw;
    if (r10.y == 0) {
      r37.xyw = r53.xyz;
    } else {
      r37.xyw = float3(0,0,0);
    }
    if (r50.z != 0) {
      r38.xyw = -r62.xyz + r51.yzw;
      r14.z = dot(r38.xyw, r38.xyw);
      r14.z = sqrt(r14.z);
      r38.xyw = r38.xyw / r14.zzz;
      r14.z = saturate(r14.z / r53.w);
      r14.z = 1 + -r14.z;
      r23.y = dot(-r52.xyz, r38.xyw);
      r23.y = r23.y + -r52.w;
      r23.y = saturate(r23.y / r9.z);
      r14.z = r23.y * r14.z;
      r37.xyw = r53.xyz * r14.zzz;
    }
    if (r50.w != 0) {
      r38.xyw = -r62.xyz + r51.yzw;
      r14.z = dot(r38.xyw, r38.xyw);
      r14.z = sqrt(r14.z);
      r23.y = r14.z / r38.z;
      r23.y = 1 + r23.y;
      r14.z = r14.z / r37.z;
      r14.z = r14.z * r14.z;
      r14.z = saturate(-r14.z * r14.z + 1);
      r14.z = r14.z * r14.z;
      r14.z = r41.w * r14.z;
      r23.y = r23.y * r23.y;
      r14.z = r14.z / r23.y;
      r14.z = min(10, r14.z);
      r37.xyw = r53.xyz * r14.zzz;
    }
    r31.xyz = r37.xyw * r30.xxx + r31.xyz;
    if (r10.z == 0) {
      r37.xyw = r56.xyz;
    } else {
      r37.xyw = float3(0,0,0);
    }
    if (r57.x != 0) {
      r38.xyw = -r62.xyz + r54.yzw;
      r14.z = dot(r38.xyw, r38.xyw);
      r14.z = sqrt(r14.z);
      r38.xyw = r38.xyw / r14.zzz;
      r14.z = saturate(r14.z / r56.w);
      r14.z = 1 + -r14.z;
      r23.y = dot(-r55.xyz, r38.xyw);
      r23.y = r23.y + -r55.w;
      r23.y = saturate(r23.y / r9.w);
      r14.z = r23.y * r14.z;
      r37.xyw = r56.xyz * r14.zzz;
    }
    if (r57.y != 0) {
      r38.xyw = -r62.xyz + r54.yzw;
      r14.z = dot(r38.xyw, r38.xyw);
      r14.z = sqrt(r14.z);
      r23.y = r14.z / r51.x;
      r23.y = 1 + r23.y;
      r14.z = r14.z / r47.x;
      r14.z = r14.z * r14.z;
      r14.z = saturate(-r14.z * r14.z + 1);
      r14.z = r14.z * r14.z;
      r14.z = r54.x * r14.z;
      r23.y = r23.y * r23.y;
      r14.z = r14.z / r23.y;
      r14.z = min(10, r14.z);
      r37.xyw = r56.xyz * r14.zzz;
    }
    r31.xyz = r37.xyw * r14.yyy + r31.xyz;
    r14.yz = (int2)r29.xy;
    r14.yz = (int2)r14.yz * asint(cb0[97].zz);
    r60.xy = (uint2)r14.yz >> int2(6,6);
    r14.yz = t9.Load(r60.xyz).xy;
    r29.xyw = float3(0,0,0);
    r23.y = r14.y;
    r30.x = 0;
    while (true) {
      r30.y = cmp((uint)r30.x >= (uint)r14.z);
      if (r30.y != 0) break;
      r30.y = (int)r23.y + 1;
      r37.x = t10.Load(r23.y).x;
      r79.x = t4[r37.x].val[0/4];
      r79.y = t4[r37.x].val[0/4+1];
      r79.z = t4[r37.x].val[0/4+2];
      r79.w = t4[r37.x].val[0/4+3];
      r37.y = cmp(-0.5 < r79.w);
      r38.xyw = cmp(r79.www >= float3(2.5,1.5,0.5));
      r74.xy = r38.ww ? float2(0,1) : float2(1,0);
      r75.xyz = r38.yyy ? float3(0,0,1) : r74.xyz;
      r80.xyzw = r38.xxxx ? float4(0,0,0,1) : r75.xyzw;
      r80.xyzw = r37.yyyy ? r80.xyzw : 0;
      r37.y = dot(float4(1,1,1,1), r80.xyzw);
      r37.w = t4[r37.x].val[12/4];
      r80.x = t4[r37.x].val[32/4];
      r80.y = t4[r37.x].val[32/4+1];
      r80.z = t4[r37.x].val[32/4+2];
      r80.w = t4[r37.x].val[32/4+3];
      r38.xyw = r79.xyz + -r62.xyz;
      r37.x = dot(r38.xyw, r38.xyw);
      r37.x = sqrt(r37.x);
      r38.x = dot(abs(r80.xyz), float3(1,1,1));
      r38.x = 2 * r38.x;
      r38.x = sqrt(r38.x);
      r38.x = r80.w * r38.x;
      r37.w = saturate(r37.w);
      r37.w = r37.w * 92.9289322 + 7.07106781;
      r38.y = r37.w * r37.w;
      r38.y = 0.200000003 * r38.y;
      r37.w = r80.w / r37.w;
      r37.w = r37.x / r37.w;
      r37.w = 1 + r37.w;
      r37.x = r37.x / r38.x;
      r37.xw = r37.xw * r37.xw;
      r37.x = saturate(-r37.x * r37.x + 1);
      r37.x = r37.x * r37.x;
      r37.x = r38.y * r37.x;
      r37.x = r37.x / r37.w;
      r37.x = min(10, r37.x);
      r38.xyw = r80.xyz * r37.xxx;
      r29.xyw = r37.yyy * r38.xyw + r29.xyw;
      r30.x = (int)r30.x + 1;
      r23.y = r30.y;
    }
    r31.xyz = r31.xyz + r29.xyw;
    r31.xyz = r58.xyz * cb1[5].www + r31.xyz;
    r31.xyz = cb1[5].xyz + r31.xyz;
    r31.xyz = r77.xyz * r31.xyz;
    // Weight this sample into the running temporal accumulation based on jitter/step count.
    r14.y = 2 * r76.y;
    r14.y = min(1, r14.y);
    r14.y = r21.y ? 1 : r14.y;
    r14.z = cmp((int)r57.z == (int)r21.y);
    r23.y = 1 + -r76.y;
    r23.y = 2 * r23.y;
    r23.y = min(1, r23.y);
    r23.y = r23.y * r14.y;
    r14.y = r14.z ? r23.y : r14.y;
    r14.y = -r22.x * r14.y;
    r14.y = r14.y * r22.y;
    r14.y = 1.44269502 * r14.y;
    r14.y = exp2(r14.y);
    r14.z = 1 + -r14.y;
    r31.xyz = r31.xyz * r14.zzz;
    r12.xyw = r12.xyw * r14.yyy + r31.xyz;
    r21.w = r21.w * r14.y;
    r21.xy = (int2)r21.xy + int2(1,1);
  }
  // Normalize accumulated color by the surviving alpha and output premultiplied fog.
  r0.x = 1 + -r21.w;
  r0.y = max(9.99999975e-05, r0.x);
  o0.xyz = r12.xyw / r0.yyy;
  o0.w = r0.x;
  return;
}