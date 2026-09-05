#include "../shared.h"

// ============================================================================
// SKYBOX / SKY RENDERING SHADER
// ============================================================================
// Textures:
//   t0: 3D LUT for volumetric fog/scattering
//   t1: Environment/fallback sky cubemap lookup
//   t2: Main skybox texture (4096x2048 equirectangular)
//   t3: Reflection probe 1 texture
//   t4: Reflection probe 2 texture
//   t5: Reflection probe 1 detail/tint
//   t6: Reflection probe 2 detail/tint
// ============================================================================

Texture2D<float4> t7 : register(t7);

Texture2D<float4> t6 : register(t6);

Texture2D<float4> t5 : register(t5);

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture3D<float4> t0 : register(t0);

SamplerState s6_s : register(s6);

SamplerState s5_s : register(s5);

SamplerState s4_s : register(s4);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2)
{
  float4 cb2[45];
}

cbuffer cb1 : register(b1)
{
  float4 cb1[105];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[45];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float3 v1 : TEXCOORD0,
  float2 v2 : TEXCOORD1,
  float3 v3 : TEXCOORD2,
  float3 v4 : TEXCOORD3,
  float3 v5 : TEXCOORD4,
  out float4 o0 : SV_Target0,
  out float4 o1 : SV_Target1)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10;
  uint4 bitmask, uiDest;
  float4 fDest;

  // ==========================================================================
  // VIEW DIRECTION CALCULATION
  // ==========================================================================
  r0.xyz = -cb0[44].xyz + v1.xyz;
  r0.w = dot(r0.xyz, r0.xyz);
  r1.x = max(9.99999994e-009, r0.w);
  r1.x = rsqrt(r1.x);
  r1.yzw = r1.xxx * r0.xyz;
  r2.x = r1.x * r0.w;
  // ==========================================================================
  // OCTAHEDRAL / CUBEMAP UV MAPPING FOR t1 (fallback environment)
  // ==========================================================================
  r2.y = dot(abs(r1.yzw), float3(1,1,1));
  r2.y = 1 / r2.y;
  r2.zw = r2.yy * r1.yw;
  r2.z = r2.z + r2.w;
  r2.y = r1.y * r2.y + -r2.w;
  r3.xy = float2(1,1) + r2.zy;
  r2.yz = float2(0.5,0.5) * r3.xy;
  r2.yzw = t1.SampleLevel(s0_s, r2.yz, 0).xyz;
  r3.x = saturate(r1.z * 10 + 1);
  // ==========================================================================
  // PROCEDURAL SUN DISK CALCULATION
  // ==========================================================================
  // cb2[44].xyz = sun direction
  // cb2[43].x = sun size/falloff exponent
  // cb2[42].xyz = sun color, cb2[42].w = sun intensity
  r3.y = saturate(dot(-cb2[44].xyz, -r1.yzw));  // Sun-view alignment (1 = looking at sun)
  r3.y = log2(r3.y);
  // Sun size adjustment: multiply exponent to shrink disk (5.0 = ~80% smaller)
  float sunSizeMultiplier = (SUN_INTENSITY > 0.5f) ? 5.0f : 1.0f;
  r3.y = cb2[43].x * sunSizeMultiplier * r3.y;   // Apply sun size exponent
  r3.y = exp2(r3.y);
  r3.z = r3.y * r3.y + 1;    // Soft falloff numerator
  r3.y = -r3.y * 1.98000002 + 1.98010004;  // Soft falloff denominator
  r3.w = log2(cb2[42].w);     // Sun intensity
  r3.zw = float2(0.0100164423,0.649999976) * r3.zw;
  r3.w = exp2(r3.w);
  r3.w = 8 * r3.w;
  r3.y = log2(r3.y);
  r3.y = r3.w * r3.y;
  r3.y = exp2(r3.y);
  r3.y = max(9.99999975e-005, r3.y);
  r3.y = r3.z / r3.y;        // Final sun disk intensity
  // ==========================================================================
  // EQUIRECTANGULAR SKYBOX UV CALCULATION (for t2: 4096x2048)
  // ==========================================================================
  r3.z = r1.y / r1.w;
  r3.w = cmp(abs(r3.z) < 1);
  r4.x = 1 / abs(r3.z);
  r4.x = r3.w ? abs(r3.z) : r4.x;
  r4.y = r4.x * r4.x;
  r4.z = r4.y * 0.0872929022 + -0.301894993;
  r4.y = r4.z * r4.y + 1;
  r4.z = r4.y * r4.x;
  r4.x = -r4.y * r4.x + 1.57079637;
  r3.w = r3.w ? r4.z : r4.x;
  r4.x = abs(r1.z) * 0.0468878001 + -0.203471005;
  r4.x = r4.x * abs(r1.z) + 1.57079601;
  r4.y = 1 + -abs(r1.z);
  r4.y = sqrt(r4.y);
  r4.z = r4.x * r4.y;
  r3.z = cmp(r3.z < 0);
  r3.z = r3.z ? -r3.w : r3.w;
  r5.xy = cmp(r1.yz >= float2(0,0));
  r3.w = r5.x ? 3.1415925 : -3.1415925;
  r4.w = cmp(r1.w < 0);
  r4.w = r4.w ? 1.000000 : 0;
  r6.x = r3.w * r4.w + r3.z;
  r3.z = -r4.x * r4.y + 3.14159274;
  r3.z = r5.y ? r4.z : r3.z;
  r6.y = 1.57079637 + -r3.z;
  r3.zw = r6.xy * float2(0.159099996,0.318300009) + float2(0.5,0.5);
  r3.z = -cb2[41].w * 0.00277777785 + r3.z;
  r4.x = 1 + r3.z;
  r4.y = r3.w * 2 + -1;
  // ==========================================================================
  // SKYBOX TEXTURE SAMPLE (t2: 4096x2048 equirectangular)
  // ==========================================================================
  r4.xyzw = t2.SampleBias(s1_s, r4.xy, cb1[26].x).xyzw;
  r5.xzw = float3(-0.5,-0.5,-0.5) + r4.xyz;
  r4.xyz = r5.xzw * cb2[40].yyy + float3(0.5,0.5,0.5);
  r6.xyzw = cb2[38].xyzw * r4.xyzw;
  r3.z = max(r6.x, r6.y);
  r4.xyzw = -r4.xyzw * cb2[38].xyzw + r3.zzzz;
  r4.xyzw = cb2[40].xxxx * r4.xyzw + r6.xyzw;
  r4.xyzw = cb2[39].xyzw * r4.xyzw;
  r3.z = r5.y ? 1.000000 : 0;
  r5.x = r4.w * r3.z;
  r5.x = saturate(r5.x);
  // ==========================================================================
  // SUN DISK BLENDING
  // ==========================================================================
  // Smoothstep for sun edge falloff
  r3.w = -0.5 + r3.y;
  r3.w = saturate(r3.w + r3.w);
  r4.w = r3.w * -2 + 3;
  r3.w = r3.w * r3.w;
  r3.w = r4.w * r3.w;
  r4.w = r3.w * r3.y;
  r3.y = -r3.w * r3.y + r3.y;
  r3.y = cb2[43].y * r3.y + r4.w;  // Sun brightness
  r5.yzw = cb2[42].xyz * r3.yyy;    // Apply sun color
  r5.yzw = cb2[43].www * r5.yzw;   // Sun intensity multiplier
  r5.yzw = cb2[44].www * r5.yzw;   // Sun shadow/occlusion
  r5.yzw = max(float3(0,0,0), r5.yzw);
  // HDR Sun toggle
  if (SUN_INTENSITY > 0.5f) {
    // Calculate sun-view alignment (1 = looking directly at sun center)
    float sunDot = saturate(dot(-cb2[44].xyz, -r1.yzw));

    // === HORIZON REDDENING ===
    // Sun direction Y component indicates height (-1 = below, 0 = horizon, 1 = zenith)
    float sunHeight = saturate(cb2[44].y + 0.1f);  // Shift so effect starts slightly above horizon

    // Warm shift when sun is low (more red/orange near horizon)
    float3 horizonTint = lerp(float3(1.0f, 0.6f, 0.3f),   // Low sun: warm orange
                              float3(1.0f, 0.95f, 0.9f),   // High sun: nearly white
                              sunHeight);

    // === LIMB DARKENING ===
    // Real stars appear darker at edges due to optical depth through atmosphere
    // Use a soft power curve - center is brightest, edges darken
    float limbDarkening = pow(sunDot, 0.4f);  // Subtle darkening toward edges

    // === CHROMATIC SUN EDGE ===
    // Core is white-hot, edges transition to yellow/orange
    float3 sunCoreColor = float3(1.0f, 1.0f, 1.0f);       // White-hot center
    float3 sunEdgeColor = float3(1.0f, 0.85f, 0.6f);      // Warm yellow edge

    // Blend from edge color to core color based on how centered we are
    float coreFactor = pow(sunDot, 3.0f);  // Sharp transition to white core
    float3 chromaticColor = lerp(sunEdgeColor, sunCoreColor, coreFactor);

    // === COMBINE SUN DISK ===
    // Apply limb darkening and chromatic color to base sun
    r5.yzw = r5.yzw * limbDarkening * chromaticColor * horizonTint;

    // Boost the sun intensity for HDR
    r5.yzw = r5.yzw * 5.0f;

    // === CORONA GLOW ===
    // Inner corona (tight glow)
    float coronaInner = pow(sunDot, 64.0f);
    // Outer corona (wide soft glow)
    float coronaOuter = pow(sunDot, 8.0f);

    // Corona colors - also affected by horizon
    float3 coronaColorInner = lerp(float3(1.0f, 0.5f, 0.2f),   // Warm inner at horizon
                                   float3(1.0f, 0.7f, 0.3f),    // Normal inner
                                   sunHeight);
    float3 coronaColorOuter = lerp(float3(1.0f, 0.3f, 0.1f),   // Deep orange at horizon
                                   float3(1.0f, 0.5f, 0.2f),    // Normal outer
                                   sunHeight);

    float3 corona = coronaInner * coronaColorInner * 2.0f
                  + coronaOuter * coronaColorOuter * 0.5f;

    // Modulate corona by sun color/intensity from game
    corona *= cb2[42].xyz * cb2[42].w;
    corona *= cb2[44].w;  // Sun shadow/occlusion

    // Add corona to sun
    r5.yzw += corona;

    // === DESATURATE SUN (50%) ===
    float sunLuma = dot(r5.yzw, float3(0.2126f, 0.7152f, 0.0722f));
    r5.yzw = lerp(r5.yzw, float3(sunLuma, sunLuma, sunLuma), 0.5f);

    // === BLOOM BOOST ===
    r5.yzw *= 10.0f;

  } else {
    // Vanilla clamp
    r5.yzw = min(float3(3,3,3), r5.yzw);
  }

  // Blend environment + sun + skybox
  r2.yzw = r2.yzw * r3.xxx + r5.yzw;
  r3.xyw = r4.xyz * r3.zzz + -r2.yzw;
  r2.yzw = r5.xxx * r3.xyw + r2.yzw;
  // ==========================================================================
  // REFLECTION PROBE 1 (cb2[0].x enables this)
  // ==========================================================================
  r3.xy = cmp(float2(0.75,0.75) < cb2[0].xy);
  if (r3.x != 0) {
    r3.x = rsqrt(r0.w);
    r5.yzw = r3.xxx * r0.yxz;
    r3.x = dot(r5.zyw, cb2[15].xyz);
    r3.w = cb2[19].x * cb2[19].x + -1;
    r3.w = r3.x * r3.x + r3.w;
    r4.w = max(0, r3.w);
    r4.w = sqrt(r4.w);
    r3.x = -r4.w + r3.x;
    r6.xyz = r5.zyw * r3.xxx + -cb2[15].xyz;
    r6.xyz = r6.xyz / cb2[19].xxx;
    r3.x = dot(cb2[15].xyz, cb2[15].xyz);
    r3.x = rsqrt(r3.x);
    r7.xyz = cb2[15].xyz * r3.xxx;
    r3.x = saturate(dot(r5.zyw, r7.xyz));
    r3.x = r3.w * r3.x;
    r3.x = max(0, r3.x);
    r3.x = cmp(0 < r3.x);
    r3.w = r3.x ? 1.000000 : 0;
    r4.w = dot(cb2[21].xyz, cb2[15].xyz);
    r6.w = dot(cb2[21].yxz, r5.yzw);
    r4.w = abs(r4.w) / abs(r6.w);
    r7.xyz = r5.zyw * r4.www + -cb2[15].xyz;
    r4.w = dot(r7.xyz, r7.xyz);
    r4.w = sqrt(r4.w);
    r8.xyz = r7.xyz / r4.www;
    r6.w = dot(cb2[21].xyz, r7.xyz);
    r6.w = cmp(abs(r6.w) < 0.00100000005);
    r6.w = r6.w ? 1.000000 : 0;
    r6.w = r6.w * r4.w;
    r7.y = r6.w * cb2[19].z + cb2[19].w;
    r6.w = dot(r6.xyz, cb2[21].xyz);
    r9.xyz = -cb2[21].xyz * r6.www + r6.xyz;
    r7.z = dot(r9.xyz, r9.xyz);
    r7.z = rsqrt(r7.z);
    r9.xyz = r9.xyz * r7.zzz;
    r7.z = dot(r9.xyz, cb2[25].xyz);
    r7.w = cmp(0 < r7.z);
    r7.z = cmp(r7.z < 0);
    r7.z = (int)-r7.w + (int)r7.z;
    r7.z = (int)r7.z;
    r7.w = saturate(-r7.z);
    r8.w = dot(r9.xyz, cb2[23].xyz);
    r9.x = 1 + -abs(r8.w);
    r9.x = sqrt(r9.x);
    r9.y = abs(r8.w) * -0.0187292993 + 0.0742610022;
    r9.y = r9.y * abs(r8.w) + -0.212114394;
    r9.y = r9.y * abs(r8.w) + 1.57072878;
    r9.z = r9.y * r9.x;
    r9.z = r9.z * -2 + 3.14159274;
    r8.w = cmp(r8.w < -r8.w);
    r8.w = r8.w ? r9.z : 0;
    r8.w = r9.y * r9.x + r8.w;
    r7.z = r8.w * r7.z;
    r9.x = r7.z * 0.159154937 + r7.w;
    r7.z = r6.w * r6.w;
    r7.z = r7.z * -0.222222224 + -0.277777791;
    r9.y = r7.z * -r6.w + 0.50000006;
    r10.xyzw = t3.SampleBias(s2_s, r9.xy, cb1[26].x).xyzw;
    r6.x = saturate(dot(cb2[17].xyz, r6.xyz));
    r6.x = saturate(r6.x * cb2[1].x + cb2[1].z);
    r6.yzw = t5.SampleBias(s4_s, r9.xy, cb1[26].x).xyz;
    r6.yzw = cb2[9].xyz * r6.yzw;
    r10.xyz = r10.xyz * r6.xxx + r6.yzw;
    r6.xyzw = r10.xyzw * r3.wwww;
    r7.z = saturate(1 + -r7.y);
    r7.z = r7.z * r7.y;
    r7.w = cmp(0 < r7.z);
    r7.z = cmp(r7.z < 0);
    r7.z = (int)-r7.w + (int)r7.z;
    r7.z = (int)r7.z;
    r7.z = saturate(r7.z);
    r5.z = dot(r5.zyw, r8.xyz);
    r5.w = cmp(0 < -r5.z);
    r5.z = cmp(-r5.z < 0);
    r5.z = (int)-r5.w + (int)r5.z;
    r5.z = (int)r5.z;
    r5.yz = saturate(r5.yz);
    r5.z = -1 + r5.z;
    r3.w = r3.w * r5.z + 1;
    r3.w = r7.z * r3.w;
    r5.z = dot(r8.xyz, cb2[25].xyz);
    r5.w = cmp(0 < r5.z);
    r5.z = cmp(r5.z < 0);
    r5.z = (int)-r5.w + (int)r5.z;
    r5.z = (int)r5.z;
    r5.w = dot(cb2[17].xyz, r8.xyz);
    r5.w = saturate(-r5.w);
    r7.z = saturate(-r5.z);
    r7.w = dot(r8.xyz, cb2[23].xyz);
    r8.x = 1 + -abs(r7.w);
    r8.x = sqrt(r8.x);
    r8.y = abs(r7.w) * -0.0187292993 + 0.0742610022;
    r8.y = r8.y * abs(r7.w) + -0.212114394;
    r8.y = r8.y * abs(r7.w) + 1.57072878;
    r8.z = r8.y * r8.x;
    r8.z = r8.z * -2 + 3.14159274;
    r7.w = cmp(r7.w < -r7.w);
    r7.w = r7.w ? r8.z : 0;
    r7.w = r8.y * r8.x + r7.w;
    r5.z = r7.w * r5.z;
    r7.x = r5.z * 0.159154937 + r7.z;
    r7.xyzw = t7.SampleBias(s6_s, r7.xy, cb1[26].x).xyzw;
    r7.xyzw = cb2[7].xyzw * r7.xyzw;
    r5.z = -r5.w * r5.w + 1;
    r5.z = sqrt(r5.z);
    r4.w = -r4.w * r5.z + cb2[19].x;
    r4.w = cb2[19].y * r4.w;
    r4.w = r4.w / cb2[0].z;
    r4.w = saturate(1 + r4.w);
    r4.w = 1 + -r4.w;
    r5.z = dot(cb2[17].xyz, cb2[21].xyz);
    r5.z = 0.400000006 + abs(r5.z);
    r5.z = min(1, r5.z);
    r4.w = r5.z * r4.w;
    r7.xyzw = r7.xyzw * r4.wwww;
    r7.xyz = r7.xyz * r7.www;
    r7.xyz = r7.xyz * r3.www;
    r8.xyz = r6.xyz * r10.www + r7.xyz;
    r3.w = r7.w * r3.w;
    r3.x = r3.x ? 0 : 1;
    r8.w = r3.w * r3.x + r6.w;
    r6.xyzw = cb2[5].xyzw * r8.xyzw;
    r3.x = -1 + r5.y;
    r3.x = cb2[29].w * r3.x + 1;
    r7.xyzw = r6.xyzw * r3.xxxx;
    r3.w = cmp(cb2[2].x >= 0.5);
    r3.w = r3.w ? 1.000000 : 0;
    r5.yz = cmp(float2(1.5,0.5) >= cb2[2].xx);
    r5.yz = r5.yz ? float2(1,1) : 0;
    r3.w = -r3.w * r5.y + 1;
    r3.w = -r7.w * r3.w + 1;
    r4.w = dot(r7.xyz, float3(0.212672904,0.715152204,0.0721750036));
    r6.xyz = r6.xyz * r3.xxx + -r4.www;
    r6.xyz = cb1[104].www * r6.xyz + r4.www;
    r6.xyz = cb1[104].xyz * r6.xyz;
    r3.x = -r6.w * r3.x + 1;
    r3.x = -r3.x * r5.z + 1;
    r5.yzw = r6.xyz * r3.xxx;
    r2.yzw = r2.yzw * r3.www + r5.yzw;
  }
  // ==========================================================================
  // REFLECTION PROBE 2 (cb2[0].y enables this)
  // ==========================================================================
  if (r3.y != 0) {
    r3.x = rsqrt(r0.w);
    r3.xyw = r3.xxx * r0.yxz;
    r0.x = dot(r3.yxw, cb2[16].xyz);
    r0.z = cb2[20].x * cb2[20].x + -1;
    r0.z = r0.x * r0.x + r0.z;
    r4.w = max(0, r0.z);
    r4.w = sqrt(r4.w);
    r0.x = -r4.w + r0.x;
    r5.yzw = r3.yxw * r0.xxx + -cb2[16].xyz;
    r5.yzw = r5.yzw / cb2[20].xxx;
    r0.x = dot(r5.yzw, cb2[22].xyz);
    r6.xyz = -cb2[22].xyz * r0.xxx + r5.yzw;
    r4.w = dot(r6.xyz, r6.xyz);
    r4.w = rsqrt(r4.w);
    r6.xyz = r6.xyz * r4.www;
    r4.w = dot(r6.xyz, cb2[26].xyz);
    r6.w = cmp(0 < r4.w);
    r4.w = cmp(r4.w < 0);
    r4.w = (int)-r6.w + (int)r4.w;
    r4.w = (int)r4.w;
    r6.w = saturate(-r4.w);
    r6.x = dot(r6.xyz, cb2[24].xyz);
    r6.y = 1 + -abs(r6.x);
    r6.y = sqrt(r6.y);
    r6.z = abs(r6.x) * -0.0187292993 + 0.0742610022;
    r6.z = r6.z * abs(r6.x) + -0.212114394;
    r6.z = r6.z * abs(r6.x) + 1.57072878;
    r7.x = r6.z * r6.y;
    r7.x = r7.x * -2 + 3.14159274;
    r6.x = cmp(r6.x < -r6.x);
    r6.x = r6.x ? r7.x : 0;
    r6.x = r6.z * r6.y + r6.x;
    r4.w = r6.x * r4.w;
    r6.x = r4.w * 0.159154937 + r6.w;
    r4.w = r0.x * r0.x;
    r4.w = r4.w * -0.222222224 + -0.277777791;
    r6.y = r4.w * -r0.x + 0.50000006;
    r7.xyzw = t4.SampleBias(s3_s, r6.xy, cb1[26].x).xyzw;
    r0.x = saturate(dot(cb2[18].xyz, r5.yzw));
    r0.x = saturate(r0.x * cb2[1].y + cb2[1].w);
    r5.yzw = t6.SampleBias(s5_s, r6.xy, cb1[26].x).xyz;
    r5.yzw = cb2[10].xyz * r5.yzw;
    r7.xyz = r7.xyz * r0.xxx + r5.yzw;
    r0.x = dot(cb2[16].xyz, cb2[16].xyz);
    r0.x = rsqrt(r0.x);
    r5.yzw = cb2[16].xyz * r0.xxx;
    r0.x = saturate(dot(r3.yxw, r5.yzw));
    r0.x = r0.z * r0.x;
    r0.x = max(0, r0.x);
    r0.x = cmp(0 < r0.x);
    r0.x = r0.x ? 1.000000 : 0;
    r6.xyzw = r7.xyzw * r0.xxxx;
    r6.xyz = r6.xyz * r7.www;
    r6.xyzw = cb2[6].xyzw * r6.xyzw;
    r3.x = saturate(r3.x);
    r0.x = -1 + r3.x;
    r0.x = cb2[32].w * r0.x + 1;
    r7.xyzw = r6.xyzw * r0.xxxx;
    r0.z = cmp(cb2[2].y >= 0.5);
    r0.z = r0.z ? 1.000000 : 0;
    r3.xy = cmp(float2(1.5,0.5) >= cb2[2].yy);
    r3.xy = r3.xy ? float2(1,1) : 0;
    r0.z = -r0.z * r3.x + 1;
    r0.z = -r7.w * r0.z + 1;
    r0.x = -r6.w * r0.x + 1;
    r0.x = -r0.x * r3.y + 1;
    r3.xyw = r7.xyz * r0.xxx;
    r2.yzw = r2.yzw * r0.zzz + r3.xyw;
  }
  // Final skybox blend
  r3.xyz = r4.xyz * r3.zzz + -r2.yzw;
  r2.yzw = r5.xxx * r3.xyz + r2.yzw;
  // ==========================================================================
  // ATMOSPHERIC FOG / SCATTERING (Height-based exponential fog)
  // ==========================================================================
  r0.x = v1.y * cb1[74].w + cb1[75].w;
  r0.z = r2.x * cb1[72].w + -cb1[71].w;
  r0.xz = max(float2(0.00999999978,0), r0.xz);
  r3.x = -1.44269502 * r0.x;
  r3.x = exp2(r3.x);
  r3.x = 1 + -r3.x;
  r0.x = r3.x / r0.x;
  r3.x = v1.y * cb1[74].w + cb1[76].w;
  r3.x = 1.44269502 * r3.x;
  r3.x = exp2(r3.x);
  r0.x = r3.x * r0.x;
  r0.x = -r0.z * r0.x;
  r3.xyz = cb1[73].xyz * r0.xxx;
  r3.xyz = float3(1.44269502,1.44269502,1.44269502) * r3.xyz;
  r3.xyz = exp2(r3.xyz);
  r0.x = dot(r1.yzw, cb1[72].xyz);
  r0.z = cb1[73].w * cb1[73].w + 1;
  r3.w = dot(r0.xx, cb1[73].ww);
  r0.z = -r3.w + r0.z;
  // ==========================================================================
  // VOLUMETRIC FOG SAMPLING (t0: 3D fog volume)
  // ==========================================================================
  r3.w = cmp(0 < cb1[83].z);
  if (r3.w != 0) {
    r4.xy = (uint2)v0.xy;
    r4.z = 7 & asint(cb1[26].w);
    r5.xyz = mad((int3)r4.xyz, int3(0x19660d,0x19660d,0x19660d), int3(0x3c6ef35f,0x3c6ef35f,0x3c6ef35f));
    r3.w = mad((int)r5.y, (int)r5.z, (int)r5.x);
    r4.z = mad((int)r5.z, (int)r3.w, (int)r5.y);
    r4.w = mad((int)r3.w, (int)r4.z, (int)r5.z);
    r5.x = mad((int)r4.z, (int)r4.w, (int)r3.w);
    r6.x = -cb0[0].z;
    r6.y = -cb0[1].z;
    r6.z = -cb0[2].z;
    r3.w = dot(r1.yzw, r6.xyz);
    r5.z = cmp(5.96046448e-008 < r3.w);
    r3.w = 1 / r3.w;
    r3.w = r5.z ? r3.w : 0;
    r3.w = cb1[83].w * r3.w;
    r5.z = 1 / r2.x;
    r5.w = r5.z * r3.w;
    r6.x = r5.w * r0.y + cb0[44].y;
    r5.w = -r5.w * r0.y + r0.y;
    r3.w = -r3.w * r5.z + 1;
    r5.z = r3.w * r2.x;
    r6.y = cb1[77].z * r5.w;
    r5.w = cb1[80].x * r5.w;
    r5.w = max(-127, r5.w);
    r6.z = -cb1[77].x + r6.x;
    r6.z = cb1[77].z * r6.z;
    r6.yz = max(float2(-127,-127), r6.yz);
    r6.z = exp2(-r6.z);
    r6.z = cb1[77].y * r6.z;
    r6.w = cmp(5.96046448e-008 < abs(r6.y));
    r7.x = exp2(-r6.y);
    r7.x = 1 + -r7.x;
    r7.x = r7.x / r6.y;
    r6.y = -r6.y * 0.240226507 + 0.693147182;
    r6.y = r6.w ? r7.x : r6.y;
    r6.x = -cb1[80].z + r6.x;
    r6.x = cb1[80].x * r6.x;
    r6.x = max(-127, r6.x);
    r6.x = exp2(-r6.x);
    r6.x = cb1[80].y * r6.x;
    r6.w = cmp(5.96046448e-008 < abs(r5.w));
    r7.x = exp2(-r5.w);
    r7.x = 1 + -r7.x;
    r7.x = r7.x / r5.w;
    r5.w = -r5.w * 0.240226507 + 0.693147182;
    r5.w = r6.w ? r7.x : r5.w;
    r5.w = r6.x * r5.w;
    r5.w = r6.z * r6.y + r5.w;
    r6.xy = saturate(r2.xx * cb1[78].wy + cb1[78].zx);
    r5.z = r5.w * r5.z;
    r5.z = exp2(-r5.z);
    r5.z = min(1, r5.z);
    r5.z = max(cb1[79].w, r5.z);
    r5.z = r5.z + r6.y;
    r5.z = r5.z + r6.x;
    r5.z = min(1, r5.z);
    r5.y = mad((int)r4.w, (int)r5.x, (int)r4.z);
    r4.zw = (uint2)r5.xy >> int2(16,16);
    r4.xyzw = (uint4)r4.xyzw;
    r4.zw = r4.zw * float2(3.05180438e-005,3.05180438e-005) + float2(-1,-1);
    r4.xy = r4.zw * cb1[87].ww + r4.xy;
    r4.xy = cb1[85].xy * r4.xy;
    r4.w = v0.w * cb1[84].x + cb1[84].y;
    r4.w = log2(r4.w);
    r4.w = cb1[84].z * r4.w;
    r4.z = r4.w / cb1[83].z;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xyz, 0).xyzw;
    r5.x = -cb1[86].z + v0.w;
    r5.x = saturate(1000000 * r5.x);
    r4.xyzw = float4(-0,-0,-0,-1) + r4.xyzw;
    r4.xyzw = r5.xxxx * r4.xyzw + float4(0,0,0,1);
    r5.x = 1 + -r5.z;
    r5.y = saturate(dot(-r1.yzw, cb1[81].xyz));
    r5.y = log2(r5.y);
    r5.y = cb1[82].w * r5.y;
    r5.y = exp2(r5.y);
    r6.yzw = cb1[82].xyz * r5.yyy;
    r3.w = r3.w * r2.x + -cb1[81].w;
    r3.w = max(0, r3.w);
    r3.w = r5.w * r3.w;
    r3.w = exp2(-r3.w);
    r3.w = min(1, r3.w);
    r3.w = 1 + -r3.w;
    r6.yzw = r6.yzw * r3.www;
    r3.w = 1 + -r6.x;
    r6.xyz = r6.yzw * r3.www;
    r5.xyw = cb1[79].xyz * r5.xxx + r6.xyz;
    r4.xyz = r5.xyw * r4.www + r4.xyz;
    r3.w = r4.w * r5.z;
  } else {
    r4.w = cb1[77].z * r0.y;
    r4.w = max(-127, r4.w);
    r0.y = cb1[80].x * r0.y;
    r0.y = max(-127, r0.y);
    r5.x = -cb1[77].x + cb0[44].y;
    r5.x = cb1[77].z * r5.x;
    r5.x = max(-127, r5.x);
    r5.x = exp2(-r5.x);
    r5.x = cb1[77].y * r5.x;
    r5.y = cmp(5.96046448e-008 < abs(r4.w));
    r5.z = exp2(-r4.w);
    r5.z = 1 + -r5.z;
    r5.z = r5.z / r4.w;
    r4.w = -r4.w * 0.240226507 + 0.693147182;
    r4.w = r5.y ? r5.z : r4.w;
    r5.y = -cb1[80].z + cb0[44].y;
    r5.y = cb1[80].x * r5.y;
    r5.y = max(-127, r5.y);
    r5.y = exp2(-r5.y);
    r5.y = cb1[80].y * r5.y;
    r5.z = cmp(5.96046448e-008 < abs(r0.y));
    r5.w = exp2(-r0.y);
    r5.w = 1 + -r5.w;
    r5.w = r5.w / r0.y;
    r0.y = -r0.y * 0.240226507 + 0.693147182;
    r0.y = r5.z ? r5.w : r0.y;
    r0.y = r5.y * r0.y;
    r0.y = r5.x * r4.w + r0.y;
    r5.xy = saturate(r2.xx * cb1[78].wy + cb1[78].zx);
    r2.x = r0.y * r2.x;
    r2.x = exp2(-r2.x);
    r2.x = min(1, r2.x);
    r2.x = max(cb1[79].w, r2.x);
    r2.x = r2.x + r5.y;
    r2.x = r2.x + r5.x;
    r3.w = min(1, r2.x);
    r2.x = 1 + -r3.w;
    r1.y = saturate(dot(-r1.yzw, cb1[81].xyz));
    r1.y = log2(r1.y);
    r1.y = cb1[82].w * r1.y;
    r1.y = exp2(r1.y);
    r1.yzw = cb1[82].xyz * r1.yyy;
    r0.w = r0.w * r1.x + -cb1[81].w;
    r0.w = max(0, r0.w);
    r0.y = r0.y * r0.w;
    r0.y = exp2(-r0.y);
    r0.y = min(1, r0.y);
    r0.y = 1 + -r0.y;
    r1.xyz = r1.yzw * r0.yyy;
    r0.y = 1 + -r5.x;
    r1.xyz = r1.xyz * r0.yyy;
    r4.xyz = cb1[79].xyz * r2.xxx + r1.xyz;
  }
  // ==========================================================================
  // FINAL COLOR GRADING
  // ==========================================================================
  // Desaturation based on luminance
  r0.y = dot(r2.yzw, float3(0.212672904,0.715152204,0.0721750036));  // Luminance
  r1.xyz = r2.yzw + -r0.yyy;
  r1.xyz = cb1[104].www * r1.xyz + r0.yyy;  // Saturation control
  r1.xyz = cb1[104].xyz * r1.xyz;  // Color tint/exposure
  r2.xyz = r3.xyz * r3.www;
  r0.x = r0.x * r0.x + 1;
  r0.x = 0.0596831031 * r0.x;
  r0.xyw = cb1[74].xyz * r0.xxx + cb1[76].xyz;
  r1.w = -cb1[73].w * cb1[73].w + 1;
  r2.w = 12.566371 * r0.z;
  r0.z = sqrt(r0.z);
  r0.z = r2.w * r0.z;
  r0.z = max(0.00100000005, r0.z);
  r0.z = r1.w / r0.z;
  r0.xyz = saturate(cb1[75].xyz * r0.zzz + r0.xyw);
  r0.xyz = float3(255,255,255) * r0.xyz;
  r3.xyz = float3(1,1,1) + -r3.xyz;
  r0.xyz = r3.xyz * r0.xyz;
  r0.xyz = r0.xyz * r3.www + r4.xyz;
  o0.xyz = r1.xyz * r2.xyz + r0.xyz;

  // ==========================================================================
  // SKYBOX DESATURATION (50%) - Tech Test Look
  // ==========================================================================
  if (TECH_TEST_LOOK > 0.5f) {
    float skyboxLuma = dot(o0.xyz, float3(0.2126f, 0.7152f, 0.0722f));
    o0.xyz = lerp(o0.xyz, float3(skyboxLuma, skyboxLuma, skyboxLuma), 0.5f);
  }

  // ==========================================================================
  // VELOCITY BUFFER OUTPUT (for motion blur / TAA)
  // ==========================================================================
  r0.x = max(9.99999994e-009, v3.z);
  r0.xy = v3.xy / r0.xx;
  r0.z = max(9.99999994e-009, v4.z);
  r0.zw = v4.xy / r0.zz;
  r0.xy = r0.xy + -r0.zw;
  r1.xy = float2(0.5,-0.5) * r0.xy;
  r1.xy = sqrt(abs(r1.xy));
  r1.xy = sqrt(r1.xy);
  r0.z = -r0.y;
  r0.yw = cmp(float2(0,0) < r0.xz);
  r0.xz = cmp(r0.xz < float2(0,0));
  r0.xy = (int2)-r0.yw + (int2)r0.xz;
  r0.xy = (int2)r0.xy;
  r0.xy = r1.xy * r0.xy;
  o1.xy = r0.xy * float2(0.5,0.5) + float2(0.5,0.5);
  o0.w = 1;
  o1.zw = float2(0,0);
  return;
}
