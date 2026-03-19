// ---- Created with 3Dmigoto v1.4.1 on Sat Jan 24 03:28:04 2026
// ============================================================================
// CAPSULE/TUBE LIGHT - SPHERICAL HARMONICS PROBE SHADER
// ============================================================================
// This shader computes spherical harmonics (SH) lighting contributions from
// capsule/tube shaped light sources. It ray-marches along the capsule and
// accumulates SH coefficients for indirect lighting.
//
// Textures:
//   t0: Depth buffer
//   t1: Light attenuation/falloff lookup texture (256x1 or similar)
//   t2: GBuffer normals (octahedral encoded)
//
// Constant Buffers:
//   cb0[24-27]: Inverse projection matrix for depth reconstruction
//   cb1[1]: SH coefficient scaling
//   cb1[4]: Screen parameters (xy = dimensions, zw = 1/dimensions)
//   cb2[n+1]: Capsule endpoint 1 (xyz) + radius (w)
//   cb2[n+2]: Capsule endpoint 2 (xyz) + influence radius (w)
//   cb2[n+3]: Capsule direction (xyz) + intensity (w)
// ============================================================================

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2)
{
  float4 cb2[385];
}

cbuffer cb1 : register(b1)
{
  float4 cb1[5];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[28];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  nointerpolation uint v3 : TEXCOORD2,  // Light/probe instance index
  out float4 o0 : SV_Target0)           // Output: Spherical Harmonics coefficients (L0 + L1)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9;
  uint4 bitmask, uiDest;
  float4 fDest;

  // ==========================================================================
  // SCREEN TO UV CONVERSION
  // ==========================================================================
  r0.xy = cb1[4].zw * v0.xy;              // Convert screen position to UV (0-1)
  r0.zw = r0.xy * float2(2,2) + float2(-1,-1);  // Convert to NDC (-1 to 1)
  
  // ==========================================================================
  // DEPTH BUFFER SAMPLING & WORLD POSITION RECONSTRUCTION
  // ==========================================================================
  r1.x = t0.SampleLevel(s0_s, r0.xy, 0).x;  // Sample depth buffer
  
  // Reconstruct view/world position from depth using inverse projection
  r2.xyzw = cb0[25].xyzw * -r0.wwww;        // Inverse projection row 2 * -NDC.y
  r2.xyzw = cb0[24].xyzw * r0.zzzz + r2.xyzw;  // + Inverse projection row 1 * NDC.x
  r1.xyzw = cb0[26].xyzw * r1.xxxx + r2.xyzw;  // + Inverse projection row 3 * depth
  r1.xyzw = cb0[27].xyzw + r1.xyzw;         // + Inverse projection row 4 (translation)
  r1.xyz = r1.xyz / r1.www;                 // Perspective divide -> world position
  
  // ==========================================================================
  // CAPSULE LIGHT SETUP
  // ==========================================================================
  r0.z = cb1[4].y * 0.5;                    // Half screen height
  r0.w = (int)v3.x * 3;                     // Light data offset (3 float4s per light)
  r0.z = cb2[r0.w+2].w * r0.z;              // Influence radius scaled by screen
  
  // Calculate capsule center (midpoint between endpoints)
  r2.xyz = cb2[r0.w+2].xyz + cb2[r0.w+1].xyz;  // endpoint1 + endpoint2
  r2.xyz = r2.xyz * float3(0.5,0.5,0.5) + -r1.xyz;  // Center - worldPos
  
  // Distance from pixel to capsule center
  r1.w = dot(r2.xyz, r2.xyz);
  r1.w = sqrt(r1.w);
  
  // ==========================================================================
  // EARLY OUT: CHECK IF PIXEL IS WITHIN INFLUENCE RADIUS
  // ==========================================================================
  r2.x = cmp(r0.z >= r1.w);                 // Is distance < influence radius?
  if (r2.x != 0) {
    // ========================================================================
    // GBUFFER NORMAL DECODING (Octahedral mapping)
    // ========================================================================
    r0.xy = t2.SampleLevel(s1_s, r0.xy, 0).xy;  // Sample encoded normal
    r0.xy = r0.xy * float2(2,2) + float2(-1,-1);  // Decode from 0-1 to -1 to 1
    
    // Octahedral normal decoding
    r2.x = dot(float2(1,1), abs(r0.xy));    // Sum of absolute values
    r2.y = 1 + -r2.x;                       // Z component estimation
    r2.w = cmp(r2.y < 0);                   // Check if on bottom hemisphere
    r3.xy = cmp(r0.xy >= float2(0,0));      // Sign of XY
    r3.zw = float2(1,1) + -abs(r0.yx);      // Reflected coordinates
    r3.xy = r3.xy ? float2(1,1) : float2(-1,-1);
    r3.xy = r3.zw * r3.xy;                  // Apply sign
    r2.xz = r2.ww ? r3.xy : r0.xy;          // Choose based on hemisphere
    
    // Normalize the decoded normal
    r0.x = dot(r2.xyz, r2.xyz);
    r0.x = rsqrt(r0.x);
    r2.xyz = r2.xyz * r0.xxx;               // Final world normal
    
    // ========================================================================
    // RAY MARCH SETUP ALONG CAPSULE
    // ========================================================================
    r0.x = cb1[4].x * 1.20000005;           // Step size base
    r0.y = cb2[r0.w+1].w * r0.x;            // Capsule radius * step size
    r2.w = cb2[r0.w+2].w / r0.y;            // Number of steps
    r2.w = ceil(r2.w);
    r2.w = (uint)r2.w;
    r2.w = (int)r2.w + -1;                  // Loop iteration count
    
    // Calculate step offset along capsule axis
    r0.x = r0.x * cb2[r0.w+1].w + -cb2[r0.w+1].w;
    r3.xyz = cb2[r0.w+3].xyz * r0.xxx + cb2[r0.w+1].xyz;  // Start position
    r0.x = cb2[r0.w+1].w + 9.99999975e-06;  // Radius + epsilon
    
    // ========================================================================
    // RAY MARCH LOOP - ACCUMULATE SPHERICAL HARMONICS
    // ========================================================================
    r4.y = 0.5;                             // V coordinate for attenuation LUT
    r5.xyzw = float4(0,0,0,0);              // Accumulated SH coefficients
    r6.xyz = r3.xyz;                        // Current sample position
    r3.w = 0;                               // Loop counter
    
    while (true) {
      r4.z = cmp((uint)r3.w >= (uint)r2.w);
      if (r4.z != 0) break;
      
      // --------------------------------------------------------------------
      // Calculate vector from world position to current sample point
      // --------------------------------------------------------------------
      r7.xyz = r6.xyz + -r1.xyz;            // Sample pos - world pos
      r4.z = dot(r7.xyz, r7.xyz);
      r4.z = sqrt(r4.z);                    // Distance to sample
      r4.w = dot(r7.xyz, r2.xyz);           // Project onto normal direction
      
      // Check capsule bounds
      r6.w = cb2[r0.w+1].w + r4.w;          // Distance + radius
      r7.w = cmp(0 >= r4.w);                // Behind surface?
      r8.x = cmp(0 >= r6.w);                // Outside capsule?
      r8.y = cmp(r4.z < r0.x);              // Within radius?
      r8.y = r7.w ? r8.y : 0;
      r8.x = (int)r8.y | (int)r8.x;
      
      if (r8.x == 0) {
        // ------------------------------------------------------------------
        // CAPSULE INTERSECTION & ATTENUATION CALCULATION
        // ------------------------------------------------------------------
        r8.x = cmp(cb2[r0.w+1].w >= abs(r4.w));  // Within capsule length?
        if (r8.x != 0) {
          // Calculate closest point on capsule surface
          r8.xyz = -r2.xyz * r4.www + r6.xyz;     // Clamp to capsule start
          r9.xyz = r2.xyz * cb2[r0.w+1].www + r6.xyz;  // Clamp to capsule end
          r9.xyz = r9.xyz + r8.xyz;
          r7.xyz = r9.xyz * float3(0.5,0.5,0.5) + -r1.xyz;  // Midpoint - worldPos
          
          // Soft falloff calculation
          if (r7.w != 0) {
            r4.w = abs(r4.w) * abs(r4.w);
            r4.w = cb2[r0.w+1].w * cb2[r0.w+1].w + -r4.w;
            r4.w = sqrt(r4.w);              // Perpendicular distance
            r8.xyz = -r8.xyz + r1.xyz;
            r7.w = dot(r8.xyz, r8.xyz);
            r7.w = sqrt(r7.w);
            r7.w = r7.w + -r4.w;
            r4.w = r7.w / r4.w;
            r4.w = min(1, r4.w);            // Clamp attenuation
          } else {
            r4.w = 1;
          }
          r4.w = r4.w * r6.w;
          r4.w = 0.5 * r4.w;                // Half contribution
          r6.w = dot(r7.xyz, r7.xyz);
          r4.z = sqrt(r6.w);                // Final distance
        } else {
          r4.w = cb2[r0.w+1].w;             // Use full radius
        }
        
        // ------------------------------------------------------------------
        // DIRECTION TO LIGHT SAMPLE (for SH projection)
        // ------------------------------------------------------------------
        r6.w = dot(r7.xyz, r7.xyz);
        r6.w = rsqrt(r6.w);
        r7.xyz = r7.yzx * r6.www;           // Normalized direction (YZX swizzle for SH)
        
        // Calculate attenuation based on distance
        r4.w = r4.w * r4.w;
        r4.w = r4.z * r4.z + -r4.w;
        r4.w = sqrt(r4.w);
        r4.z = r4.w / r4.z;
        r4.z = r4.z * 255 + 0.5;            // Scale to LUT range
        r4.x = 0.00390625 * r4.z;           // U coordinate (0-1)
        
        // ------------------------------------------------------------------
        // SAMPLE ATTENUATION LUT & COMPUTE SPHERICAL HARMONICS
        // ------------------------------------------------------------------
        r4.xz = t1.SampleLevel(s1_s, r4.xy, 0).zw;  // Sample attenuation LUT
        r8.xy = r4.xz * cb1[1].xy + cb1[1].zw;      // Scale and bias
        r8.yzw = r8.yyy * r7.xyz;           // Directional component * intensity
        
        // Spherical Harmonics basis coefficients:
        // L0 (constant):  Y_0^0 = 0.282094806 (1/(2*sqrt(pi)))
        // L1 (linear):    Y_1^-1, Y_1^0, Y_1^1 = ±0.488602489 (sqrt(3/(4*pi)))
        r7.xyzw = float4(0.282094806,-0.488602489,0.488602489,-0.488602489) * r8.xyzw;
      } else {
        r7.xyzw = float4(0,0,0,0);          // No contribution from this sample
      }
      
      // Accumulate SH coefficients
      r5.xyzw = r7.xyzw + r5.xyzw;
      
      // Move to next sample along capsule
      r6.xyz = cb2[r0.w+3].xyz * r0.yyy + r6.xyz;
      r3.w = (int)r3.w + 1;
    }
    
    // ========================================================================
    // DISTANCE FALLOFF & FINAL OUTPUT
    // ========================================================================
    r0.x = saturate(r1.w / r0.z);           // Normalized distance (0-1)
    r0.x = -0.300000012 + r0.x;             // Shift falloff start
    r0.x = 1.42857146 * r0.x;               // Scale falloff curve
    r0.x = max(0, r0.x);
    r0.x = 1 + -r0.x;                       // Invert (1 at center, 0 at edge)
    r0.x = cb2[r0.w+3].w * r0.x;            // Apply light intensity
    
    // Output accumulated SH coefficients scaled by intensity
    o0.xyzw = r5.xyzw * r0.xxxx;
  } else {
    // Outside influence radius - no contribution
    o0.xyzw = float4(0,0,0,0);
  }
  return;
}