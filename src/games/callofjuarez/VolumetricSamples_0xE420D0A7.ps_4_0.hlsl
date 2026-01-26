
// Volumetric sampling shader
// Added Gradient Noise Dithering & Loop Unrolling
cbuffer _Globals : register(b0)
{
  float4 CONST_4 : packoffset(c0);
}

SamplerState samBackbuffer_s : register(s0);
Texture2D<float4> sBackbuffer : register(t0);

// 3Dmigoto declarations
#define cmp -
Texture1D<float4> IniParams : register(t120);
Texture2D<float4> StereoParams : register(t125);

// Noise function for dithering (Interleaved Gradient Noise)
// This creates a high-frequency pattern that TAA or the eye blends easily.
float InterleavedGradientNoise(float2 position_screen)
{
    float3 magic = float3(0.06711056, 0.00583715, 52.9829189);
    return frac(magic.z * frac(dot(position_screen, magic.xy)));
}

void main( 
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  float4 v4 : TEXCOORD3,
  float4 v5 : TEXCOORD4,
  float4 v6 : TEXCOORD5,
  float4 v7 : TEXCOORD6,
  float4 v8 : TEXCOORD7,
  float4 v9 : TEXCOORD8,
  float4 v10 : TEXCOORD9,
  float4 v11 : TEXCOORD10,
  float4 v12 : TEXCOORD11,
  float4 v13 : TEXCOORD12,
  float4 v14 : TEXCOORD13,
  float4 v15 : TEXCOORD14,
  out float4 o0 : SV_TARGET0)
/* Vanilla
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  float4 v[15] = { v0,v1,v2,v3,v4,v5,v6,v7,v8,v9,v10,v11,v12,v13,v14 };
  r0.xyzw = float4(0,0,0,0);
  r1.x = 0;
  while (true) {
    r1.y = (int)r1.x;
    r1.y = cmp(r1.y >= 15);
    if (r1.y != 0) break;
    r2.xyzw = sBackbuffer.Sample(samBackbuffer_s, v[r1.x+1].xy).xyzw;
    r2.xyzw = r2.xyzw + r0.xyzw;
    r3.xyzw = sBackbuffer.Sample(samBackbuffer_s, v[r1.x+1].zw).xyzw;
    r0.xyzw = r3.xyzw + r2.xyzw;
    r1.x = (int)r1.x + 1;
  }
  o0.xyzw = CONST_4.wwww * r0.xyzw;
  return;
}
*/

{
  float4 totalLight = float4(0, 0, 0, 0);
  float dither = InterleavedGradientNoise(v0.xy);
  float4 coords[15] = { v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15 };

  // Unrolled Loop with Jitter
  // We calculate the direction to the *next* sample and move our fetch 
  // along that line based on the dither value. This fills the gaps nicely.
  [unroll]
  for (int i = 0; i < 14; ++i)
  {
      // --- Process First Pair (.xy) ---
      float2 posA = coords[i].xy;
      float2 nextPosA = coords[i].zw; // The next sample is in .zw
      float2 dirA = nextPosA - posA;
      // Fetch at posA + (Step * Dither) to sample "between" the gaps
      totalLight += sBackbuffer.Sample(samBackbuffer_s, posA + dirA * dither);
      // --- Process Second Pair (.zw) ---
      float2 posB = coords[i].zw;
      float2 nextPosB = coords[i+1].xy; // The next sample is in the next float4
      float2 dirB = nextPosB - posB;
      totalLight += sBackbuffer.Sample(samBackbuffer_s, posB + dirB * dither);
  }
  // We treat the last sample separately to avoid array out-of-bounds on "nextPos".
  float2 posLast1 = coords[14].xy;
  float2 posLast2 = coords[14].zw;
  // For the 2nd-to-last sample, we can still calculate direction to the very last one
  float2 dirLast1 = posLast2 - posLast1;
  totalLight += sBackbuffer.Sample(samBackbuffer_s, posLast1 + dirLast1 * dither);
  // For the very last sample, we reuse the previous direction since we have no "next" point.
  totalLight += sBackbuffer.Sample(samBackbuffer_s, posLast2 + dirLast1 * dither);
  // Apply intensity
  o0 = totalLight * CONST_4.w;
  
  return;
}