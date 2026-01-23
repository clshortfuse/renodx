// ---- Created with 3Dmigoto v1.4.1 on Thu Jan 22 13:20:49 2026

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

Texture2D<float4> t6 : register(t6);

Texture2D<float4> t5 : register(t5);

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture3D<float4> t0 : register(t0);

SamplerState s5_s : register(s5);

SamplerState s4_s : register(s4);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1)
{
  float4 cb1[52];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[185];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  float4 v4 : TEXCOORD3,
  float3 v5 : TEXCOORD4,
  out float4 o0 : SV_Target0,
  out float4 o1 : SV_Target1)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8;
  uint4 bitmask, uiDest;
  float4 fDest;

  // ==========================================================================
  // VIEW DIRECTION CALCULATION
  // ==========================================================================
  r0.xyz = -cb0[44].xyz + v1.xyz;
  r0.w = dot(r0.xyz, r0.xyz);
  r1.x = max(9.99999994e-09, r0.w);
  r1.x = rsqrt(r1.x);
  r1.yzw = r1.xxx * r0.xyz; 
  r1.x = r1.x * r0.w;       

  // ==========================================================================
  // OCTAHEDRAL / CUBEMAP UV MAPPING FOR t1 (fallback environment)
  // ==========================================================================
  r2.x = dot(abs(r1.yzw), float3(1,1,1));
  r2.x = 1 / r2.x;
  r2.yz = r2.xx * r1.yw;
  r2.y = r2.y + r2.z;
  r2.x = r1.y * r2.x + -r2.z;
  r3.xy = float2(1,1) + r2.yx;
  r2.xy = float2(0.5,0.5) * r3.xy;
  r2.xyz = t1.SampleLevel(s0_s, r2.xy, 0).xyz; 
  r2.w = saturate(r1.z * 10 + 1);
  // ==========================================================================
  // PROCEDURAL SUN DISK CALCULATION
  // ==========================================================================
  // cb1[11].xyz = sun direction
  // cb1[10].x = sun size/falloff exponent
  // cb1[9].xyz = sun color, cb1[9].w = sun intensity
  r3.x = saturate(dot(-cb1[11].xyz, -r1.yzw));  // Sun-view alignment (1 = looking at sun)
  r3.x = log2(r3.x);
  
  // Sun size adjustment: multiply exponent to shrink disk (5.0 = ~80% smaller)
  float sunSizeMultiplier = (SUN_INTENSITY > 0.5f) ? 5.0f : 1.0f;
  r3.x = cb1[10].x * sunSizeMultiplier * r3.x;   // Apply sun size exponent
  
  r3.x = exp2(r3.x);
  r3.y = r3.x * r3.x + 1;    // Soft falloff numerator
  r3.x = -r3.x * 1.98000002 + 1.98010004;  // Soft falloff denominator
  r3.z = log2(cb1[9].w);     // Sun intensity
  r3.yz = float2(0.0100164423,0.649999976) * r3.yz;
  r3.z = exp2(r3.z);
  r3.z = 8 * r3.z;
  r3.x = log2(r3.x);
  r3.x = r3.z * r3.x;
  r3.x = exp2(r3.x);
  r3.x = max(9.99999975e-05, r3.x);
  r3.x = r3.y / r3.x;        // Final sun disk intensity

  // ==========================================================================
  // EQUIRECTANGULAR SKYBOX UV CALCULATION (for t2: 4096x2048)
  // ==========================================================================
  r3.y = r1.y / r1.w;       
  r3.z = cmp(abs(r3.y) < 1);
  r3.w = 1 / abs(r3.y);
  r3.w = r3.z ? abs(r3.y) : r3.w;
  r4.x = r3.w * r3.w;
  r4.y = r4.x * 0.0872929022 + -0.301894993;
  r4.x = r4.y * r4.x + 1;
  r4.y = r4.x * r3.w;
  r3.w = -r4.x * r3.w + 1.57079637;
  r3.z = r3.z ? r4.y : r3.w;
  r3.w = abs(r1.z) * 0.0468878001 + -0.203471005;
  r3.w = r3.w * abs(r1.z) + 1.57079601;
  r4.x = 1 + -abs(r1.z);
  r4.x = sqrt(r4.x);
  r4.y = r4.x * r3.w;
  r3.y = cmp(r3.y < 0);
  r3.y = r3.y ? -r3.z : r3.z;
  r4.zw = cmp(r1.yz >= float2(0,0));
  r3.z = r4.z ? 3.1415925 : -3.1415925;
  r4.z = cmp(r1.w < 0);
  r4.z = r4.z ? 1.000000 : 0;
  r5.x = r3.z * r4.z + r3.y;
  r3.y = -r3.w * r4.x + 3.14159274;
  r3.y = r4.w ? r4.y : r3.y;
  r5.y = 1.57079637 + -r3.y;  
  r3.yz = r5.xy * float2(0.159099996,0.318300009) + float2(0.5,0.5);
  r3.y = -cb1[8].w * 0.00277777785 + r3.y;
  r4.x = 1 + r3.y;
  r4.y = r3.z * 2 + -1;

  // ==========================================================================
  // SKYBOX TEXTURE SAMPLE (t2: 4096x2048 equirectangular)
  // ==========================================================================
  r5.xyzw = t2.SampleBias(s1_s, r4.xy, cb0[108].x).xyzw;
  r3.yzw = float3(-0.5,-0.5,-0.5) + r5.xyz;
  r5.xyz = r3.yzw * cb1[7].yyy + float3(0.5,0.5,0.5);
  r6.xyzw = cb1[5].xyzw * r5.xyzw;
  r3.y = max(r6.x, r6.y);
  r5.xyzw = -r5.xyzw * cb1[5].xyzw + r3.yyyy;
  r5.xyzw = cb1[7].xxxx * r5.xyzw + r6.xyzw; 
  r5.xyzw = cb1[6].xyzw * r5.xyzw; 
  r3.y = r4.w ? 1.000000 : 0; 
  r4.x = r5.w * r3.y;
  r4.x = saturate(r4.x);

  // ==========================================================================
  // SUN DISK BLENDING
  // ==========================================================================
  // Smoothstep for sun edge falloff
  r3.z = -0.5 + r3.x;
  r3.z = saturate(r3.z + r3.z);
  r3.w = r3.z * -2 + 3;
  r3.z = r3.z * r3.z;
  r3.z = r3.w * r3.z;
  r3.w = r3.z * r3.x;
  r3.x = -r3.z * r3.x + r3.x;
  r3.x = cb1[10].y * r3.x + r3.w;  // Sun brightness
  r3.xzw = cb1[9].xyz * r3.xxx;    // Apply sun color
  r3.xzw = cb1[10].www * r3.xzw;   // Sun intensity multiplier
  r3.xzw = cb1[11].www * r3.xzw;   // Sun shadow/occlusion
  r3.xzw = max(float3(0,0,0), r3.xzw);
  
  // HDR Sun toggle
  if (SUN_INTENSITY > 0.5f) {
    // Calculate sun-view alignment (1 = looking directly at sun center)
    float sunDot = saturate(dot(-cb1[11].xyz, -r1.yzw)); 
    
    // === HORIZON REDDENING ===
    // Sun direction Y component indicates height (-1 = below, 0 = horizon, 1 = zenith)
    float sunHeight = saturate(cb1[11].y + 0.1f);  // Shift so effect starts slightly above horizon
    
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
    r3.xzw = r3.xzw * limbDarkening * chromaticColor * horizonTint;
    
    // Boost the sun intensity for HDR
    r3.xzw = r3.xzw * 5.0f;
    
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
    corona *= cb1[9].xyz * cb1[9].w;
    corona *= cb1[11].w;  // Sun shadow/occlusion
    
    // Add corona to sun
    r3.xzw += corona;
    
    // === DESATURATE SUN (50%) ===
    float sunLuma = dot(r3.xzw, float3(0.2126f, 0.7152f, 0.0722f));
    r3.xzw = lerp(r3.xzw, float3(sunLuma, sunLuma, sunLuma), 0.5f);
    
    // === BLOOM BOOST ===
    r3.xzw *= 10.0f;
    
  } else {
    // Vanilla clamp
    r3.xzw = min(float3(3,3,3), r3.xzw);
  }
  
  // Blend environment + sun + skybox
  r2.xyz = r2.xyz * r2.www + r3.xzw;
  r3.xzw = r5.xyz * r3.yyy + -r2.xyz;
  r2.xyz = r4.xxx * r3.xzw + r2.xyz;

  // ==========================================================================
  // REFLECTION PROBE 1 (cb1[20].x enables this)
  // ==========================================================================
  r3.xz = cmp(float2(0.5,0.5) < cb1[20].xy);
  if (r3.x != 0) {
    r2.w = rsqrt(r0.w);
    r4.yzw = r2.www * r0.yxz;
    r2.w = dot(r4.zyw, cb1[23].xyz); 
    r3.x = cb1[27].x * cb1[27].x + -1; 
    r3.x = r2.w * r2.w + r3.x;
    r3.w = max(0, r3.x);
    r3.w = sqrt(r3.w);
    r2.w = -r3.w + r2.w;
    r6.xyz = r4.zyw * r2.www + -cb1[23].xyz;
    r6.xyz = r6.xyz / cb1[27].xxx;
    r2.w = dot(r6.xyz, cb1[29].xyz);
    r7.xyz = -cb1[29].xyz * r2.www + r6.xyz;
    r3.w = dot(r7.xyz, r7.xyz);
    r3.w = rsqrt(r3.w);
    r7.xyz = r7.xyz * r3.www;
    r3.w = dot(r7.xyz, cb1[33].xyz);
    r5.w = cmp(0 < r3.w);
    r3.w = cmp(r3.w < 0);
    r3.w = (int)-r5.w + (int)r3.w;
    r3.w = (int)r3.w;
    r5.w = saturate(-r3.w);
    r6.w = dot(r7.xyz, cb1[31].xyz);
    r7.x = 1 + -abs(r6.w);
    r7.x = sqrt(r7.x);
    r7.y = abs(r6.w) * -0.0187292993 + 0.0742610022;
    r7.y = r7.y * abs(r6.w) + -0.212114394;
    r7.y = r7.y * abs(r6.w) + 1.57072878;
    r7.z = r7.y * r7.x;
    r7.z = r7.z * -2 + 3.14159274;
    r6.w = cmp(r6.w < -r6.w);
    r6.w = r6.w ? r7.z : 0;
    r6.w = r7.y * r7.x + r6.w;
    r3.w = r6.w * r3.w;
    r7.x = r3.w * 0.159154937 + r5.w;
    r3.w = r2.w * r2.w;
    r3.w = r3.w * -0.222222224 + -0.277777791;
    r7.y = r3.w * -r2.w + 0.50000006;
    r8.xyzw = t3.SampleBias(s2_s, r7.xy, cb0[108].x).xyzw;
    r2.w = saturate(dot(cb1[25].xyz, r6.xyz));
    r2.w = saturate(r2.w * cb1[45].x + cb1[45].z);
    r6.xyz = t5.SampleBias(s4_s, r7.xy, cb0[108].x).xyz;
    r6.xyz = cb1[41].xyz * r6.xyz; 
    r6.xyz = r8.xyz * r2.www + r6.xyz;
    r2.w = dot(cb1[23].xyz, cb1[23].xyz);
    r2.w = rsqrt(r2.w);
    r7.xyz = cb1[23].xyz * r2.www;
    r2.w = saturate(dot(r4.zyw, r7.xyz));
    r2.w = r3.x * r2.w;
    r2.w = max(0, r2.w);
    r2.w = cmp(0 < r2.w);
    r2.w = r2.w ? 1.000000 : 0;
    r6.xyz = r6.xyz * r2.www;
    r6.xyz = r6.xyz * r8.www;
    r6.xyz = cb1[37].xyz * r6.xyz;  
    r4.y = saturate(r4.y);
    r2.w = -1 + r4.y;
    r2.w = cb1[48].w * r2.w + 1;
    r4.yzw = r6.xyz * r2.www;
    r3.x = dot(r4.yzw, float3(0.212672904,0.715152204,0.0721750036));
    r4.yzw = r6.xyz * r2.www + -r3.xxx;
    r4.yzw = cb0[184].www * r4.yzw + r3.xxx; 
    r2.xyz = r4.yzw * cb0[184].xyz + r2.xyz;  
  }

  // ==========================================================================
  // REFLECTION PROBE 2 (cb1[20].y enables this)
  // ==========================================================================
  if (r3.z != 0) {
    r0.w = rsqrt(r0.w);
    r0.xzw = r0.yxz * r0.www;
    r2.w = dot(r0.zxw, cb1[24].xyz);  
    r3.x = cb1[28].x * cb1[28].x + -1; 
    r3.x = r2.w * r2.w + r3.x;
    r3.z = max(0, r3.x);
    r3.z = sqrt(r3.z);
    r2.w = -r3.z + r2.w;
    r4.yzw = r0.zxw * r2.www + -cb1[24].xyz;
    r4.yzw = r4.yzw / cb1[28].xxx;
    r2.w = dot(r4.yzw, cb1[30].xyz);
    r6.xyz = -cb1[30].xyz * r2.www + r4.yzw;
    r3.z = dot(r6.xyz, r6.xyz);
    r3.z = rsqrt(r3.z);
    r6.xyz = r6.xyz * r3.zzz;
    r3.z = dot(r6.xyz, cb1[34].xyz);
    r3.w = cmp(0 < r3.z);
    r3.z = cmp(r3.z < 0);
    r3.z = (int)-r3.w + (int)r3.z;
    r3.z = (int)r3.z;
    r3.w = saturate(-r3.z);
    r5.w = dot(r6.xyz, cb1[32].xyz);
    r6.x = 1 + -abs(r5.w);
    r6.x = sqrt(r6.x);
    r6.y = abs(r5.w) * -0.0187292993 + 0.0742610022;
    r6.y = r6.y * abs(r5.w) + -0.212114394;
    r6.y = r6.y * abs(r5.w) + 1.57072878;
    r6.z = r6.y * r6.x;
    r6.z = r6.z * -2 + 3.14159274;
    r5.w = cmp(r5.w < -r5.w);
    r5.w = r5.w ? r6.z : 0;
    r5.w = r6.y * r6.x + r5.w;
    r3.z = r5.w * r3.z;
    r6.x = r3.z * 0.159154937 + r3.w;
    r3.z = r2.w * r2.w;
    r3.z = r3.z * -0.222222224 + -0.277777791;
    r6.y = r3.z * -r2.w + 0.50000006;
    r7.xyzw = t4.SampleBias(s3_s, r6.xy, cb0[108].x).xyzw;
    r2.w = saturate(dot(cb1[26].xyz, r4.yzw));
    r2.w = saturate(r2.w * cb1[45].y + cb1[45].w);
    r4.yzw = t6.SampleBias(s5_s, r6.xy, cb0[108].x).xyz;
    r4.yzw = cb1[42].xyz * r4.yzw;
    r4.yzw = r7.xyz * r2.www + r4.yzw;
    r2.w = dot(cb1[24].xyz, cb1[24].xyz);
    r2.w = rsqrt(r2.w);
    r6.xyz = cb1[24].xyz * r2.www;
    r0.z = saturate(dot(r0.zxw, r6.xyz));
    r0.z = r3.x * r0.z;
    r0.z = max(0, r0.z);
    r0.z = cmp(0 < r0.z);
    r0.z = r0.z ? 1.000000 : 0;
    r3.xzw = r4.yzw * r0.zzz;
    r3.xzw = r3.xzw * r7.www;
    r3.xzw = cb1[38].xyz * r3.xzw;
    r0.x = saturate(r0.x);
    r0.x = -1 + r0.x;
    r0.x = cb1[51].w * r0.x + 1;
    r2.xyz = r3.xzw * r0.xxx + r2.xyz; 
  }
  
  // Final skybox blend
  r0.xzw = r5.xyz * r3.yyy + -r2.xyz;
  r0.xzw = r4.xxx * r0.xzw + r2.xyz;

  // ==========================================================================
  // ATMOSPHERIC FOG / SCATTERING (Height-based exponential fog)
  // ==========================================================================
  r2.x = v1.y * cb0[156].w + cb0[157].w;
  r2.y = r1.x * cb0[154].w + -cb0[153].w;
  r2.xy = max(float2(0.00999999978,0), r2.xy);
  r2.z = -1.44269502 * r2.x;
  r2.z = exp2(r2.z);
  r2.z = 1 + -r2.z;
  r2.x = r2.z / r2.x;
  r2.z = v1.y * cb0[156].w + cb0[158].w;
  r2.z = 1.44269502 * r2.z;
  r2.z = exp2(r2.z);
  r2.x = r2.x * r2.z;
  r2.x = -r2.y * r2.x;
  r2.xyz = cb0[155].xyz * r2.xxx;
  r2.xyz = float3(1.44269502,1.44269502,1.44269502) * r2.xyz;
  r2.xyz = exp2(r2.xyz);
  
  r2.w = dot(r1.yzw, cb0[154].xyz);
  r3.x = cb0[155].w * cb0[155].w + 1;
  r3.y = dot(r2.ww, cb0[155].ww);
  r3.x = r3.x + -r3.y;

  // ==========================================================================
  // VOLUMETRIC FOG SAMPLING (t0: 3D fog volume)
  // ==========================================================================
  r3.y = cmp(0 < cb0[163].z); 
  if (r3.y != 0) {
    r4.xy = (uint2)v0.xy;
    r4.z = 7 & asint(cb0[108].w);
    r3.yzw = mad((int3)r4.xyz, int3(0x19660d,0x19660d,0x19660d), int3(0x3c6ef35f,0x3c6ef35f,0x3c6ef35f));
    r3.y = mad((int)r3.z, (int)r3.w, (int)r3.y);
    r3.z = mad((int)r3.w, (int)r3.y, (int)r3.z);
    r3.w = mad((int)r3.y, (int)r3.z, (int)r3.w);
    r5.x = mad((int)r3.z, (int)r3.w, (int)r3.y);
    r6.x = -cb0[0].z;
    r6.y = -cb0[1].z;
    r6.z = -cb0[2].z;
    r1.y = dot(r1.yzw, r6.xyz);
    r1.z = cmp(5.96046448e-08 < r1.y);
    r1.y = 1 / r1.y;
    r1.y = r1.z ? r1.y : 0;
    r1.y = cb0[163].w * r1.y;
    r1.z = 1 / r1.x;
    r1.w = r1.y * r1.z;
    r3.y = r1.w * r0.y + cb0[44].y;
    r1.w = -r1.w * r0.y + r0.y;
    r4.z = cb0[159].z * r1.w;
    r1.w = cb0[162].x * r1.w;
    r1.w = max(-127, r1.w);
    r4.w = -cb0[159].x + r3.y;
    r4.w = cb0[159].z * r4.w;
    r4.zw = max(float2(-127,-127), r4.zw);
    r4.w = exp2(-r4.w);
    r4.w = cb0[159].y * r4.w;
    r5.z = cmp(5.96046448e-08 < abs(r4.z));
    r5.w = exp2(-r4.z);
    r5.w = 1 + -r5.w;
    r5.w = r5.w / r4.z;
    r4.z = -r4.z * 0.240226507 + 0.693147182;
    r4.z = r5.z ? r5.w : r4.z;
    r3.y = -cb0[162].z + r3.y;
    r3.y = cb0[162].x * r3.y;
    r3.y = max(-127, r3.y);
    r3.y = exp2(-r3.y);
    r3.y = cb0[162].y * r3.y;
    r5.z = cmp(5.96046448e-08 < abs(r1.w));
    r5.w = exp2(-r1.w);
    r5.w = 1 + -r5.w;
    r5.w = r5.w / r1.w;
    r1.w = -r1.w * 0.240226507 + 0.693147182;
    r1.w = r5.z ? r5.w : r1.w;
    r1.w = r3.y * r1.w;
    r1.w = r4.w * r4.z + r1.w;
    r1.y = -r1.y * r1.z + 1;
    r1.y = r1.y * r1.x;
    r1.y = r1.w * r1.y;
    r1.y = exp2(-r1.y);
    r1.y = min(1, r1.y);
    r1.y = max(cb0[161].w, r1.y);
    r1.zw = saturate(r1.xx * cb0[160].yw + cb0[160].xz);
    r1.y = r1.y + r1.z;
    r1.y = r1.y + r1.w;
    r1.y = min(1, r1.y);
    r1.zw = (uint2)r4.xy;
    r5.y = mad((int)r3.w, (int)r5.x, (int)r3.z);
    r3.yz = (uint2)r5.xy >> int2(16,16);
    r3.yz = (uint2)r3.yz;
    r3.yz = r3.yz * float2(3.05180438e-05,3.05180438e-05) + float2(-1,-1);
    r1.zw = r3.yz * cb0[167].ww + r1.zw;
    r4.xy = cb0[165].xy * r1.zw;
    r1.z = v0.w * cb0[164].x + cb0[164].y;
    r1.z = log2(r1.z);
    r1.z = cb0[164].z * r1.z;
    r4.z = r1.z / cb0[163].z;
    r4.xyzw = t0.SampleLevel(s0_s, r4.xyz, 0).xyzw;
    r1.z = -cb0[166].z + v0.w;
    r1.z = saturate(1000000 * r1.z);
    r4.xyzw = float4(-0,-0,-0,-1) + r4.xyzw;
    r4.xyzw = r1.zzzz * r4.xyzw + float4(0,0,0,1);
    r1.z = 1 + -r1.y;
    r3.yzw = cb0[161].xyz * r1.zzz;
    r3.yzw = r3.yzw * r4.www + r4.xyz;
    r1.y = r4.w * r1.y;
  } else {
    r1.z = cb0[159].z * r0.y;
    r0.y = cb0[162].x * r0.y;
    r0.y = max(-127, r0.y);
    r1.w = -cb0[159].x + cb0[44].y;
    r1.w = cb0[159].z * r1.w;
    r1.zw = max(float2(-127,-127), r1.zw);
    r1.w = exp2(-r1.w);
    r1.w = cb0[159].y * r1.w;
    r4.x = cmp(5.96046448e-08 < abs(r1.z));
    r4.y = exp2(-r1.z);
    r4.y = 1 + -r4.y;
    r4.y = r4.y / r1.z;
    r1.z = -r1.z * 0.240226507 + 0.693147182;
    r1.z = r4.x ? r4.y : r1.z;
    r4.x = -cb0[162].z + cb0[44].y;
    r4.x = cb0[162].x * r4.x;
    r4.x = max(-127, r4.x);
    r4.x = exp2(-r4.x);
    r4.x = cb0[162].y * r4.x;
    r4.y = cmp(5.96046448e-08 < abs(r0.y));
    r4.z = exp2(-r0.y);
    r4.z = 1 + -r4.z;
    r4.z = r4.z / r0.y;
    r0.y = -r0.y * 0.240226507 + 0.693147182;
    r0.y = r4.y ? r4.z : r0.y;
    r0.y = r4.x * r0.y;
    r0.y = r1.w * r1.z + r0.y;
    r0.y = r0.y * r1.x;
    r0.y = exp2(-r0.y);
    r0.y = min(1, r0.y);
    r0.y = max(cb0[161].w, r0.y);
    r1.xz = saturate(r1.xx * cb0[160].yw + cb0[160].xz);
    r0.y = r1.x + r0.y;
    r0.y = r0.y + r1.z;
    r1.y = min(1, r0.y);
    r0.y = 1 + -r1.y;
    r3.yzw = cb0[161].xyz * r0.yyy;  
  }

  // ==========================================================================
  // FINAL COLOR GRADING
  // ==========================================================================
  // Desaturation based on luminance
  r0.y = dot(r0.xzw, float3(0.212672904,0.715152204,0.0721750036));  // Luminance
  r0.xzw = r0.xzw + -r0.yyy;
  r0.xyz = cb0[184].www * r0.xzw + r0.yyy;  // Saturation control
  r0.xyz = cb0[184].xyz * r0.xyz;  // Color tint/exposure
  r1.xzw = r2.xyz * r1.yyy; 
  r0.w = r2.w * r2.w + 1;
  r0.w = 0.0596831031 * r0.w;
  r4.xyz = cb0[156].xyz * r0.www + cb0[158].xyz;
  r0.w = -cb0[155].w * cb0[155].w + 1;
  r2.w = 12.566371 * r3.x;
  r3.x = sqrt(r3.x);
  r2.w = r3.x * r2.w;
  r2.w = max(0.00100000005, r2.w);
  r0.w = r0.w / r2.w;
  r4.xyz = saturate(cb0[157].xyz * r0.www + r4.xyz);
  r4.xyz = float3(255,255,255) * r4.xyz; 
  r2.xyz = float3(1,1,1) + -r2.xyz;
  r2.xyz = r4.xyz * r2.xyz;
  r2.xyz = r2.xyz * r1.yyy + r3.yzw; 
  o0.xyz = r0.xyz * r1.xzw + r2.xyz;

  // ==========================================================================
  // VELOCITY BUFFER OUTPUT (for motion blur / TAA)
  // ==========================================================================
  r0.x = max(9.99999994e-09, v3.z);
  r0.xy = v3.xy / r0.xx;
  r0.z = max(9.99999994e-09, v4.z);
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