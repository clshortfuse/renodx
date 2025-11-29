// ---- Created with 3Dmigoto v1.4.1 on Tue Oct 14 22:37:26 2025

cbuffer ExFeaturesCB : register(b9)
{
  uint g_toon_enabled : packoffset(c0);
  uint g_retro_enabled : packoffset(c0.y);
  uint g_liq_crys_enabled : packoffset(c0.z);
  float3 g_pad : packoffset(c1);
}

SamplerState linear_wrap_sampler_s : register(s0);
TextureCube<float4> texture_0 : register(t0);


// 3Dmigoto declarations
#define cmp -


// Panorama/environment sampling pass with optional toon and retro overrides.
// 3Dmigoto emits register-style math, so we document the major branches instead of every op.
void main(
  float4 v0 : SV_POSITION0,
  float3 v1 : POSITION1,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  // Toon override: quantise intensity and push surface normal towards horizon for rim lighting.
  r0.x = cmp(g_toon_enabled == 1);
  if (r0.x != 0) {
    r0.xyz = texture_0.Sample(linear_wrap_sampler_s, v1.xyz).xyz;
    r1.xyz = cmp(r0.xyz < float3(0.0404499993,0.0404499993,0.0404499993));
    r2.xyz = float3(0.0773993805,0.0773993805,0.0773993805) * r0.xyz;
    r3.xyz = r0.xyz * float3(-0.537919998,-0.537919998,-0.537919998) + float3(1.27992404,1.27992404,1.27992404);
    r3.xyz = sqrt(r3.xyz);
    r3.xyz = float3(31.2429695,31.2429695,31.2429695) * r3.xyz;
    r0.xyz = r0.xyz * float3(-7.43604994,-7.43604994,-7.43604994) + -r3.xyz;
    r0.xyz = float3(35.3486404,35.3486404,35.3486404) + r0.xyz;
    r0.xyz = r1.xyz ? r2.xyz : r0.xyz;
    r0.w = dot(r0.xyz, float3(0.298999995,0.587000012,0.114));
    r0.w = 64 * r0.w;
    r0.w = floor(r0.w);
    r0.w = 0.015625 * r0.w;
    r0.xyz = float3(9.99999975e-06,9.99999975e-06,9.99999975e-06) + r0.xyz;
    r1.x = dot(r0.xyz, r0.xyz);
    r1.x = rsqrt(r1.x);
    r0.xyz = r1.xxx * r0.xyz;
    r0.xyz = max(float3(0,0,0), r0.xyz * r0.www); // Remove SDR clamp, allow HDR
    r0.w = dot(v1.xyz, v1.xyz);
    r0.w = rsqrt(r0.w);
    r0.w = v1.z * r0.w + 1;
    r0.w = saturate(0.833333313 * r0.w);
    r1.x = r0.w * -2 + 3;
    r0.w = r0.w * r0.w;
    r0.w = r1.x * r0.w;
    r0.xyz = r0.xyz * r0.www;
    o0.xyz = max(float3(0,0,0), r0.xyz); // Remove SDR clamp, allow HDR
    o0.w = 1;
    return;
  } else {
  // Retro override: coarse luminance posterisation to mimic low-bit consoles.
  r1.x = cmp(g_retro_enabled == 1);
    if (r1.x != 0) {
      r1.xyz = texture_0.Sample(linear_wrap_sampler_s, v1.xyz).xyz;
      r2.xyz = cmp(r1.xyz < float3(0.0404499993,0.0404499993,0.0404499993));
      r3.xyz = float3(0.0773993805,0.0773993805,0.0773993805) * r1.xyz;
      r4.xyz = r1.xyz * float3(-0.537919998,-0.537919998,-0.537919998) + float3(1.27992404,1.27992404,1.27992404);
      r4.xyz = sqrt(r4.xyz);
      r4.xyz = float3(31.2429695,31.2429695,31.2429695) * r4.xyz;
      r1.xyz = r1.xyz * float3(-7.43604994,-7.43604994,-7.43604994) + -r4.xyz;
      r1.xyz = float3(35.3486404,35.3486404,35.3486404) + r1.xyz;
      r1.xyz = r2.xyz ? r3.xyz : r1.xyz;
      r1.w = dot(r1.xyz, float3(0.298999995,0.587000012,0.114));
      r1.w = 0.100000001 * r1.w;
      r1.w = floor(r1.w);
      r1.w = 10 * r1.w;
      r2.xyz = r1.xyz * r1.www + -r1.xyz;
      o0.xyz = r2.xyz * float3(0.100000001,0.100000001,0.100000001) + r1.xyz;
      o0.w = 1;
      return;
    } else {
  // Default path: decode cube map texel and return HDR colour unchanged.
  r2.xyzw = texture_0.Sample(linear_wrap_sampler_s, v1.xyz).xyzw;
      r3.xyz = cmp(r2.xyz < float3(0.0404499993,0.0404499993,0.0404499993));
      r4.xyz = float3(0.0773993805,0.0773993805,0.0773993805) * r2.xyz;
      r5.xyz = r2.xyz * float3(-0.537919998,-0.537919998,-0.537919998) + float3(1.27992404,1.27992404,1.27992404);
      r5.xyz = sqrt(r5.xyz);
      r5.xyz = float3(31.2429695,31.2429695,31.2429695) * r5.xyz;
      r2.xyz = r2.xyz * float3(-7.43604994,-7.43604994,-7.43604994) + -r5.xyz;
      r2.xyz = float3(35.3486404,35.3486404,35.3486404) + r2.xyz;
      o0.xyz = r3.xyz ? r4.xyz : r2.xyz;
      o0.w = r2.w;
    }
  }
  return;
}