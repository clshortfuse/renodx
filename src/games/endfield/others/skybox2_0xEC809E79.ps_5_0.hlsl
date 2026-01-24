// ---- Created with 3Dmigoto v1.4.1 on Sat Jan 24 03:07:27 2026

#include "../shared.h"

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
  float4 v0 : SV_Position0,      // Screen position
  float4 v1 : TEXCOORD0,          // World position
  float4 v2 : TEXCOORD1,          // Unused
  float4 v3 : TEXCOORD2,          // Motion vector data 1
  float4 v4 : TEXCOORD3,          // Motion vector data 2
  float3 v5 : TEXCOORD4,          // Unused
  out float4 o0 : SV_Target0,     // Final color output
  out float4 o1 : SV_Target1)     // Motion vectors output
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,r16;
  uint4 bitmask, uiDest;
  float4 fDest;

  // ============================================================================
  // VIEW DIRECTION AND DISTANCE CALCULATION
  // ============================================================================
  r0.xyz = -cb0[44].xyz + v1.xyz;
  r0.w = dot(r0.xyz, r0.xyz);         
  r1.x = max(9.99999994e-09, r0.w);   
  r1.x = rsqrt(r1.x);                 
  r1.yzw = r1.xxx * r0.xyz;            
  r1.x = r1.x * r0.w;                  
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
  r3.y = r3.x * r3.x + 1;
  r3.x = -r3.x * 1.98000002 + 1.98010004;
  r3.z = log2(cb1[9].w);
  r3.yz = float2(0.0100164423,0.649999976) * r3.yz;
  r3.z = exp2(r3.z);
  r3.z = 8 * r3.z;
  r3.x = log2(r3.x);
  r3.x = r3.z * r3.x;
  r3.x = exp2(r3.x);
  r3.x = max(9.99999975e-05, r3.x);
  r3.x = r3.y / r3.x;
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
  
  // ============================================================================
  // CLOUD/ATMOSPHERE TEXTURE SAMPLING
  // ============================================================================
  r4.x = 1 + r3.y;
  r4.y = r3.z * 2 + -1;
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
  
  // ============================================================================
  // SUN SPECULAR HIGHLIGHT WITH SMOOTHSTEP
  // ============================================================================
  r3.z = -0.5 + r3.x;                       
  r3.z = saturate(r3.z + r3.z);             
  r3.w = r3.z * -2 + 3;                  
  r3.z = r3.z * r3.z;
  r3.z = r3.w * r3.z;                      
  r3.w = r3.z * r3.x;                     
  r3.x = -r3.z * r3.x + r3.x;               
  r3.x = cb1[10].y * r3.x + r3.w;         
  r3.xzw = cb1[9].xyz * r3.xxx;            
  r3.xzw = cb1[10].www * r3.xzw;            
  r3.xzw = cb1[11].www * r3.xzw;            
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
  
  // Combine skybox, sun specular, and clouds
  r2.xyz = r2.xyz * r2.www + r3.xzw;        
  r3.xzw = r5.xyz * r3.yyy + -r2.xyz;      
  r2.xyz = r4.xxx * r3.xzw + r2.xyz;       
  
  // ============================================================================
  // VOLUMETRIC LIGHT SHAFT SYSTEM 1 (conditional)
  // ============================================================================
  r3.xz = cmp(float2(0.5,0.5) < cb1[20].xy);  
  if (r3.x != 0) {  
    r2.w = 1 / cb1[46].x;  
    r3.x = cb1[46].w + cb1[46].x;  
    r3.w = rsqrt(r0.w);
    r4.yzw = r3.www * r0.xyz; 
    
    // ============================================================================
    // SPHERICAL LIGHT SOURCE INTERSECTION (cb1[23] = light position)
    // ============================================================================
    r3.w = dot(r4.yzw, cb1[23].xyz);
    r5.w = cb1[27].x * cb1[27].x + -1;  
    r5.w = r3.w * r3.w + r5.w;
    r6.x = max(0, r5.w);
    r6.x = sqrt(r6.x);
    r3.w = -r6.x + r3.w;  
    r6.xyz = r4.yzw * r3.www + -cb1[23].xyz;  
    r6.xyz = r6.xyz / cb1[27].xxx;  
    r3.w = dot(cb1[23].xyz, cb1[23].xyz);
    r3.w = rsqrt(r3.w);
    r7.xyz = cb1[23].xyz * r3.www;
    r3.w = saturate(dot(r4.yzw, r7.xyz));
    r3.w = r5.w * r3.w;
    r3.w = max(0, r3.w);
    r3.w = cmp(0 < r3.w);
    r3.w = r3.w ? 1.000000 : 0;
    r5.w = dot(cb1[29].xyz, cb1[23].xyz);
    r6.w = dot(cb1[29].xyz, r4.yzw);
    r5.w = abs(r5.w) / abs(r6.w);
    r7.xyz = r4.yzw * r5.www + -cb1[23].xyz;
    r5.w = dot(r7.xyz, r7.xyz);
    r5.w = sqrt(r5.w);
    r8.xyz = r7.xyz / r5.www;
    r6.w = dot(cb1[29].xyz, r7.xyz);
    r6.w = cmp(abs(r6.w) < 0.00100000005);
    r6.w = r6.w ? 1.000000 : 0;
    r6.w = r6.w * r5.w;
    r7.y = r6.w * cb1[27].z + cb1[27].w;
    r6.w = dot(r6.xyz, cb1[29].xyz);
    r9.xyz = -cb1[29].xyz * r6.www + r6.xyz;
    r7.z = dot(r9.xyz, r9.xyz);
    r7.z = rsqrt(r7.z);
    r9.xyz = r9.xyz * r7.zzz;
    r7.z = dot(r9.xyz, cb1[33].xyz);
    r7.w = cmp(0 < r7.z);
    r7.z = cmp(r7.z < 0);
    r7.z = (int)-r7.w + (int)r7.z;
    r7.z = (int)r7.z;
    r7.w = saturate(-r7.z);
    r8.w = dot(r9.xyz, cb1[31].xyz);
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
    r10.xyzw = t3.SampleBias(s2_s, r9.xy, cb0[108].x).xyzw;
    r6.x = saturate(dot(cb1[25].xyz, r6.xyz));
    r6.x = saturate(r6.x * cb1[45].x + cb1[45].z);
    r6.yzw = t5.SampleBias(s4_s, r9.xy, cb0[108].x).xyz;
    r6.yzw = cb1[41].xyz * r6.yzw;
    r6.yzw = r10.xyz * r6.xxx + r6.yzw;
    r6.yzw = r6.yzw * r3.www;
    r7.z = dot(r8.xyz, cb1[33].xyz);
    r7.w = cmp(0 < r7.z);
    r7.z = cmp(r7.z < 0);
    r7.z = (int)-r7.w + (int)r7.z;
    r7.z = (int)r7.z;
    r7.w = dot(cb1[25].xyz, r8.xyz);
    r7.w = saturate(-r7.w);
    r8.w = saturate(-r7.z);
    r9.x = dot(r8.xyz, cb1[31].xyz);
    r9.y = 1 + -abs(r9.x);
    r9.y = sqrt(r9.y);
    r9.z = abs(r9.x) * -0.0187292993 + 0.0742610022;
    r9.z = r9.z * abs(r9.x) + -0.212114394;
    r9.z = r9.z * abs(r9.x) + 1.57072878;
    r9.w = r9.z * r9.y;
    r9.w = r9.w * -2 + 3.14159274;
    r9.x = cmp(r9.x < -r9.x);
    r9.x = r9.x ? r9.w : 0;
    r9.x = r9.z * r9.y + r9.x;
    r7.z = r9.x * r7.z;
    r7.x = r7.z * 0.159154937 + r8.w;
    r9.xyzw = t7.SampleBias(s6_s, r7.xy, cb0[108].x).xyzw;
    r9.xyzw = cb1[39].xyzw * r9.xyzw;
    r7.x = -r7.w * r7.w + 1;
    r7.x = sqrt(r7.x);
    r5.w = -r5.w * r7.x + cb1[27].x;
    r5.w = cb1[27].y * r5.w;
    r5.w = r5.w / cb1[20].z;
    r5.w = saturate(1 + r5.w);
    r5.w = 1 + -r5.w;
    r7.x = dot(cb1[25].xyz, cb1[29].xyz);
    r7.x = 0.400000006 + abs(r7.x);
    r7.x = min(1, r7.x);
    r5.w = r7.x * r5.w;
    r9.xyzw = r9.xyzw * r5.wwww;
    r7.xzw = r9.xyz * r9.www;
    r5.w = saturate(1 + -r7.y);
    r5.w = r5.w * r7.y;
    r7.y = cmp(0 < r5.w);
    r5.w = cmp(r5.w < 0);
    r5.w = (int)-r7.y + (int)r5.w;
    r5.w = (int)r5.w;
    r5.w = saturate(r5.w);
    r7.y = dot(r4.yzw, r8.xyz);
    r8.x = cmp(0 < -r7.y);
    r7.y = cmp(-r7.y < 0);
    r7.y = (int)-r8.x + (int)r7.y;
    r7.y = (int)r7.y;
    r7.y = saturate(r7.y);
    r7.y = -1 + r7.y;
    r3.w = r3.w * r7.y + 1;
    r3.w = r5.w * r3.w;
    r7.xyz = r7.xzw * r3.www;
    r6.yzw = r6.yzw * r10.www + r7.xyz;
    r3.w = saturate(r4.z);
    r3.w = -1 + r3.w;
    r3.w = cb1[48].w * r3.w + 1;
    r5.w = dot(r4.yzw, r4.yzw);
    r5.w = max(1.17549435e-38, r5.w);
    r5.w = rsqrt(r5.w);
    r4.yzw = r5.www * r4.yzw;
    r5.w = dot(cb1[25].xyz, cb1[25].xyz);
    r5.w = max(1.17549435e-38, r5.w);
    r5.w = rsqrt(r5.w);
    r7.xyz = cb1[25].xyz * r5.www;
    r8.xyz = -cb1[21].xyz + cb0[44].xyz;
    r5.w = dot(r4.yzw, r8.xyz);
    r7.w = dot(r8.xyz, r8.xyz);
    r8.x = -r3.x * r3.x + r7.w;
    r8.x = r5.w * r5.w + -r8.x;
    r8.y = cmp(0 < r8.x);
    r8.x = sqrt(r8.x);
    r8.z = -r8.x + -r5.w;
    r9.x = max(0, r8.z);
    r8.x = r8.x + -r5.w;
    r9.y = r8.x + -r9.x;
    r8.xz = r8.yy ? r9.xy : 0;
    if (r8.y != 0) {
      r7.w = -cb1[46].w * cb1[46].w + r7.w;
      r7.w = r5.w * r5.w + -r7.w;
      r8.y = cmp(0 < r7.w);
      r7.w = sqrt(r7.w);
      r5.w = -r7.w + -r5.w;
      r5.w = max(0, r5.w);
      r5.w = r8.y ? r5.w : 0;
      r7.w = cmp(0 < r5.w);
      r5.w = r5.w + -r8.x;
      r5.w = min(r8.z, r5.w);
      r5.w = r7.w ? r5.w : r8.z;
      r5.w = r8.y ? r5.w : r8.z;
      r7.w = cmp(0 < r5.w);
      if (r7.w != 0) {
        r5.w = r5.w / cb1[46].y;
        r7.w = dot(-r4.yzw, r7.xyz);
        r8.yzw = cb1[46].zzz * float3(0.000244140625,0.0012673497,0.00266802101);
        r9.xyz = r4.yzw * r8.xxx + cb0[44].xyz;
        r10.xyz = r5.www * r4.yzw;
        r9.xyz = r10.xyz * float3(0.5,0.5,0.5) + r9.xyz;
        r10.xyz = float3(0.5,0.5,0.5) * r7.xyz;
        r11.xyz = r9.xyz;
        r12.xyz = float3(0,0,0);
        r8.x = 0;
        r9.w = 0;
        while (true) {
          r10.w = (int)r9.w;
          r10.w = cmp(r10.w >= cb1[46].y);
          if (r10.w != 0) break;
          r13.xyz = -cb1[21].xyz + r11.xyz;
          r10.w = dot(r13.xyz, r13.xyz);
          r11.w = sqrt(r10.w);
          r11.w = -cb1[46].w + r11.w;
          r11.w = r11.w * r2.w;
          r11.w = cb1[47].y * -r11.w;
          r11.w = 1.44269502 * r11.w;
          r11.w = exp2(r11.w);
          r11.w = r11.w * r5.w;
          r11.w = min(3.40282347e+38, r11.w);
          r8.x = r11.w + r8.x;
          r12.w = dot(r7.xyz, r13.xyz);
          r10.w = -r3.x * r3.x + r10.w;
          r10.w = r12.w * r12.w + -r10.w;
          r13.x = cmp(0 < r10.w);
          r10.w = sqrt(r10.w);
          r13.y = -r12.w + r10.w;
          r10.w = -r12.w + -r10.w;
          r10.w = max(0, r10.w);
          r10.w = r13.y + -r10.w;
          r10.w = r13.x ? r10.w : 0;
          r10.w = r10.w / cb1[47].x;
          r13.xyz = r10.xyz * r10.www + r11.xyz;
          r14.xyz = r13.xyz;
          r12.w = 0;
          r13.w = 0;
          while (true) {
            r14.w = (int)r13.w;
            r14.w = cmp(r14.w >= cb1[47].x);
            if (r14.w != 0) break;
            r15.xyz = -cb1[21].xyz + r14.xyz;
            r16.xyz = r7.xyz * r10.www + r14.xyz;
            r14.w = dot(r15.xyz, r15.xyz);
            r14.w = sqrt(r14.w);
            r14.w = -cb1[46].w + r14.w;
            r14.w = max(0, r14.w);
            r14.w = r14.w * r2.w;
            r14.w = cb1[47].y * -r14.w;
            r14.w = 1.44269502 * r14.w;
            r14.w = exp2(r14.w);
            r14.w = r14.w + r12.w;
            r15.x = (int)r13.w + 1;
            r14.xyz = r16.xyz;
            r12.w = r14.w;
            r13.w = r15.x;
            continue;
          }
          r10.w = r12.w * r10.w + r8.x;
          r13.xyz = r10.www * r8.yzw;
          r13.xyz = float3(-1.44269502,-1.44269502,-1.44269502) * r13.xyz;
          r13.xyz = exp2(r13.xyz);
          r12.xyz = r13.xyz * r11.www + r12.xyz;
          r11.xyz = r4.yzw * r5.www + r11.xyz;
          r9.w = (int)r9.w + 1;
        }
        r2.w = r7.w * r7.w + 1;
        r2.w = 0.0596831031 * r2.w;
        r4.yzw = r12.xyz * r2.www;
        r4.yzw = r4.yzw * r8.yzw;
      } else {
        r4.yzw = float3(0,0,0);
      }
    } else {
      r4.yzw = float3(0,0,0);
    }
    r7.xyw = cb1[47].zzz * r4.zwy;
    r2.w = cmp(r7.x >= r7.y);
    r2.w = r2.w ? 1.000000 : 0;
    r8.xy = r7.yx;
    r8.zw = float2(-1,0.666666687);
    r9.xy = r4.zw * cb1[47].zz + -r8.xy;
    r9.zw = float2(1,-1);
    r8.xyzw = r2.wwww * r9.xyzw + r8.xyzw;
    r2.w = cmp(r7.w >= r8.x);
    r2.w = r2.w ? 1.000000 : 0;
    r7.xyz = r8.xyw;
    r8.xyw = r7.wyx;
    r8.xyzw = r8.xyzw + -r7.xyzw;
    r7.xyzw = r2.wwww * r8.xyzw + r7.xyzw;
    r2.w = min(r7.w, r7.y);
    r2.w = r7.x + -r2.w;
    r3.x = r7.w + -r7.y;
    r4.y = r2.w * 6 + 9.99999975e-05;
    r3.x = r3.x / r4.y;
    r3.x = r7.z + r3.x;
    r3.x = cb1[47].w + abs(r3.x);
    r4.yzw = float3(1,0.666666687,0.333333343) + r3.xxx;
    r4.yzw = frac(r4.yzw);
    r4.yzw = r4.yzw * float3(6,6,6) + float3(-3,-3,-3);
    r4.yzw = saturate(float3(-1,-1,-1) + abs(r4.yzw));
    r3.x = 9.99999975e-05 + r7.x;
    r2.w = r2.w / r3.x;
    r4.yzw = float3(-1,-1,-1) + r4.yzw;
    r4.yzw = r2.www * r4.yzw + float3(1,1,1);
    r7.yzw = r4.yzw * r7.xxx;
    r6.yzw = cb1[37].xyz * r6.yzw;
    r7.yzw = r7.yzw * r6.xxx;
    r4.yzw = r4.yzw * r7.xxx + -r7.yzw;
    r4.yzw = cb1[48].yyy * r4.yzw + r7.yzw;
    r4.yzw = r4.yzw * r3.www;
    r4.yzw = r6.yzw * r3.www + r4.yzw;
    r2.w = dot(r4.yzw, float3(0.212672904,0.715152204,0.0721750036));
    r4.yzw = r4.yzw + -r2.www;
    r4.yzw = cb0[184].www * r4.yzw + r2.www;
    r2.xyz = r4.yzw * cb0[184].xyz + r2.xyz;
  }
  if (r3.z != 0) {
    r2.w = 1 / cb1[49].x;
    r3.x = cb1[49].w + cb1[49].x;
    r0.w = rsqrt(r0.w);
    r0.xzw = r0.xyz * r0.www;
    r3.z = dot(r0.xzw, cb1[24].xyz);
    r3.w = cb1[28].x * cb1[28].x + -1;
    r3.w = r3.z * r3.z + r3.w;
    r4.y = max(0, r3.w);
    r4.y = sqrt(r4.y);
    r3.z = -r4.y + r3.z;
    r4.yzw = r0.xzw * r3.zzz + -cb1[24].xyz;
    r4.yzw = r4.yzw / cb1[28].xxx;
    r3.z = dot(r4.yzw, cb1[30].xyz);
    r6.xyz = -cb1[30].xyz * r3.zzz + r4.yzw;
    r5.w = dot(r6.xyz, r6.xyz);
    r5.w = rsqrt(r5.w);
    r6.xyz = r6.xyz * r5.www;
    r5.w = dot(r6.xyz, cb1[34].xyz);
    r6.w = cmp(0 < r5.w);
    r5.w = cmp(r5.w < 0);
    r5.w = (int)-r6.w + (int)r5.w;
    r5.w = (int)r5.w;
    r6.w = saturate(-r5.w);
    r6.x = dot(r6.xyz, cb1[32].xyz);
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
    r5.w = r6.x * r5.w;
    r6.x = r5.w * 0.159154937 + r6.w;
    r5.w = r3.z * r3.z;
    r5.w = r5.w * -0.222222224 + -0.277777791;
    r6.y = r5.w * -r3.z + 0.50000006;
    r7.xyzw = t4.SampleBias(s3_s, r6.xy, cb0[108].x).xyzw;
    r3.z = saturate(dot(cb1[26].xyz, r4.yzw));
    r3.z = saturate(r3.z * cb1[45].y + cb1[45].w);
    r4.yzw = t6.SampleBias(s5_s, r6.xy, cb0[108].x).xyz;
    r4.yzw = cb1[42].xyz * r4.yzw;
    r4.yzw = r7.xyz * r3.zzz + r4.yzw;
    r5.w = dot(cb1[24].xyz, cb1[24].xyz);
    r5.w = rsqrt(r5.w);
    r6.xyz = cb1[24].xyz * r5.www;
    r5.w = saturate(dot(r0.xzw, r6.xyz));
    r3.w = r5.w * r3.w;
    r3.w = max(0, r3.w);
    r3.w = cmp(0 < r3.w);
    r3.w = r3.w ? 1.000000 : 0;
    r4.yzw = r4.yzw * r3.www;
    r4.yzw = r4.yzw * r7.www;
    r3.w = saturate(r0.z);
    r3.w = -1 + r3.w;
    r3.w = cb1[51].w * r3.w + 1;
    r5.w = dot(r0.xzw, r0.xzw);
    r5.w = max(1.17549435e-38, r5.w);
    r5.w = rsqrt(r5.w);
    r0.xzw = r5.www * r0.xzw;
    r5.w = dot(cb1[26].xyz, cb1[26].xyz);
    r5.w = max(1.17549435e-38, r5.w);
    r5.w = rsqrt(r5.w);
    r6.xyz = cb1[26].xyz * r5.www;
    r7.xyz = -cb1[22].xyz + cb0[44].xyz;
    r5.w = dot(r0.xzw, r7.xyz);
    r6.w = dot(r7.xyz, r7.xyz);
    r7.x = -r3.x * r3.x + r6.w;
    r7.x = r5.w * r5.w + -r7.x;
    r7.y = cmp(0 < r7.x);
    r7.x = sqrt(r7.x);
    r7.z = -r7.x + -r5.w;
    r8.x = max(0, r7.z);
    r7.x = r7.x + -r5.w;
    r8.y = r7.x + -r8.x;
    r7.xz = r7.yy ? r8.xy : 0;
    if (r7.y != 0) {
      r6.w = -cb1[49].w * cb1[49].w + r6.w;
      r6.w = r5.w * r5.w + -r6.w;
      r7.y = cmp(0 < r6.w);
      r6.w = sqrt(r6.w);
      r5.w = -r6.w + -r5.w;
      r5.w = max(0, r5.w);
      r5.w = r7.y ? r5.w : 0;
      r6.w = cmp(0 < r5.w);
      r5.w = r5.w + -r7.x;
      r5.w = min(r7.z, r5.w);
      r5.w = r6.w ? r5.w : r7.z;
      r5.w = r7.y ? r5.w : r7.z;
      r6.w = cmp(0 < r5.w);
      if (r6.w != 0) {
        r5.w = r5.w / cb1[49].y;
        r6.w = dot(-r0.xzw, r6.xyz);
        r7.yzw = cb1[49].zzz * float3(0.000244140625,0.0012673497,0.00266802101);
        r8.xyz = r0.xzw * r7.xxx + cb0[44].xyz;
        r9.xyz = r5.www * r0.xzw;
        r8.xyz = r9.xyz * float3(0.5,0.5,0.5) + r8.xyz;
        r9.xyz = float3(0.5,0.5,0.5) * r6.xyz;
        r10.xyz = r8.xyz;
        r11.xyz = float3(0,0,0);
        r7.x = 0;
        r8.w = 0;
        while (true) {
          r9.w = (int)r8.w;
          r9.w = cmp(r9.w >= cb1[49].y);
          if (r9.w != 0) break;
          r12.xyz = -cb1[22].xyz + r10.xyz;
          r9.w = dot(r12.xyz, r12.xyz);
          r10.w = sqrt(r9.w);
          r10.w = -cb1[49].w + r10.w;
          r10.w = r10.w * r2.w;
          r10.w = cb1[50].y * -r10.w;
          r10.w = 1.44269502 * r10.w;
          r10.w = exp2(r10.w);
          r10.w = r10.w * r5.w;
          r10.w = min(3.40282347e+38, r10.w);
          r7.x = r10.w + r7.x;
          r11.w = dot(r6.xyz, r12.xyz);
          r9.w = -r3.x * r3.x + r9.w;
          r9.w = r11.w * r11.w + -r9.w;
          r12.x = cmp(0 < r9.w);
          r9.w = sqrt(r9.w);
          r12.y = -r11.w + r9.w;
          r9.w = -r11.w + -r9.w;
          r9.w = max(0, r9.w);
          r9.w = r12.y + -r9.w;
          r9.w = r12.x ? r9.w : 0;
          r9.w = r9.w / cb1[50].x;
          r12.xyz = r9.xyz * r9.www + r10.xyz;
          r13.xyz = r12.xyz;
          r11.w = 0;
          r12.w = 0;
          while (true) {
            r13.w = (int)r12.w;
            r13.w = cmp(r13.w >= cb1[50].x);
            if (r13.w != 0) break;
            r14.xyz = -cb1[22].xyz + r13.xyz;
            r15.xyz = r6.xyz * r9.www + r13.xyz;
            r13.w = dot(r14.xyz, r14.xyz);
            r13.w = sqrt(r13.w);
            r13.w = -cb1[49].w + r13.w;
            r13.w = max(0, r13.w);
            r13.w = r13.w * r2.w;
            r13.w = cb1[50].y * -r13.w;
            r13.w = 1.44269502 * r13.w;
            r13.w = exp2(r13.w);
            r13.w = r13.w + r11.w;
            r14.x = (int)r12.w + 1;
            r13.xyz = r15.xyz;
            r11.w = r13.w;
            r12.w = r14.x;
            continue;
          }
          r9.w = r11.w * r9.w + r7.x;
          r12.xyz = r9.www * r7.yzw;
          r12.xyz = float3(-1.44269502,-1.44269502,-1.44269502) * r12.xyz;
          r12.xyz = exp2(r12.xyz);
          r11.xyz = r12.xyz * r10.www + r11.xyz;
          r10.xyz = r0.xzw * r5.www + r10.xyz;
          r8.w = (int)r8.w + 1;
        }
        r0.x = r6.w * r6.w + 1;
        r0.x = 0.0596831031 * r0.x;
        r0.xzw = r11.xyz * r0.xxx;
        r0.xzw = r0.xzw * r7.yzw;
      } else {
        r0.xzw = float3(0,0,0);
      }
    } else {
      r0.xzw = float3(0,0,0);
    }
    r6.xyw = cb1[50].zzz * r0.zwx;
    r0.x = cmp(r6.x >= r6.y);
    r0.x = r0.x ? 1.000000 : 0;
    r7.xy = r6.yx;
    r7.zw = float2(-1,0.666666687);
    r8.xy = r0.zw * cb1[50].zz + -r7.xy;
    r8.zw = float2(1,-1);
    r7.xyzw = r0.xxxx * r8.xyzw + r7.xyzw;
    r0.x = cmp(r6.w >= r7.x);
    r0.x = r0.x ? 1.000000 : 0;
    r6.xyz = r7.xyw;
    r7.xyw = r6.wyx;
    r7.xyzw = r7.xyzw + -r6.xyzw;
    r6.xyzw = r0.xxxx * r7.xyzw + r6.xyzw;
    r0.x = min(r6.w, r6.y);
    r0.x = r6.x + -r0.x;
    r0.z = r6.w + -r6.y;
    r0.w = r0.x * 6 + 9.99999975e-05;
    r0.z = r0.z / r0.w;
    r0.z = r6.z + r0.z;
    r0.z = cb1[50].w + abs(r0.z);
    r6.yzw = float3(1,0.666666687,0.333333343) + r0.zzz;
    r6.yzw = frac(r6.yzw);
    r6.yzw = r6.yzw * float3(6,6,6) + float3(-3,-3,-3);
    r6.yzw = saturate(float3(-1,-1,-1) + abs(r6.yzw));
    r0.z = 9.99999975e-05 + r6.x;
    r0.x = r0.x / r0.z;
    r6.yzw = float3(-1,-1,-1) + r6.yzw;
    r0.xzw = r0.xxx * r6.yzw + float3(1,1,1);
    r6.yzw = r0.xzw * r6.xxx;
    r4.yzw = cb1[38].xyz * r4.yzw;
    r6.yzw = r6.yzw * r3.zzz;
    r0.xzw = r0.xzw * r6.xxx + -r6.yzw;
    r0.xzw = cb1[51].yyy * r0.xzw + r6.yzw;
    r0.xzw = r0.xzw * r3.www;
    r0.xzw = r4.yzw * r3.www + r0.xzw;
    r2.xyz = r2.xyz + r0.xzw;
  }
  r0.xzw = r5.xyz * r3.yyy + -r2.xyz;
  r0.xzw = r4.xxx * r0.xzw + r2.xyz;
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
  r0.y = dot(r0.xzw, float3(0.212672904,0.715152204,0.0721750036));
  r0.xzw = r0.xzw + -r0.yyy;
  r0.xyz = cb0[184].www * r0.xzw + r0.yyy;
  r0.xyz = cb0[184].xyz * r0.xyz;
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