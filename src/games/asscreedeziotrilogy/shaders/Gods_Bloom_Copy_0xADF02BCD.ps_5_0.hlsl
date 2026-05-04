cbuffer cb3 : register(b3) {
  uint4 cb3[77];
}

cbuffer cb4 : register(b4) {
  float4 cb4[236];
}

SamplerState s0_s : register(s0);
SamplerState s1_s : register(s1);
SamplerState s2_s : register(s2);
SamplerState s3_s : register(s3);

Texture2D<float4> t0 : register(t0);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t3 : register(t3);

float SafeRcp(float x) {
  return abs(x) > 0.f ? rcp(x) : 0.f;
}

float3 SafeNormalize(float3 v) {
  float len2 = dot(v, v);
  return len2 > 0.f ? v * rsqrt(len2) : 0.f;
}

float4 BitNorm(float4 value, uint4 bit_and, uint4 bit_or) {
  return asfloat((asuint(value) & bit_and) | bit_or);
}

// This is not a plain blur/copy shader.
//
// It builds a directional grayscale bloom contribution for the "gods" effect:
// 1. t1/t3 provide two signed 2D shape fields plus intensity masks.
// 2. t2.z blends one of those fields toward a forward-facing vector.
// 3. v7/v8/v9 provide a local basis used to reconstruct a 3D direction.
// 4. The result is compared against the view/object-to-center direction.
// 5. t0.a and v2.a provide the actual bloom magnitude, then a pulse/gate is
//    applied and the shader outputs a grayscale bloom scalar.
//
// The parts most likely to cause FP16 trouble are:
// - the reciprocal radial terms (`radial_*_rcp`)
// - the `focus = exp(log(abs(facing)) * 0.3)` shaping
// - the hard pulse override to 12.0 below
void main(
    float4 v0 : SV_POSITION0,
    float4 v1 : TEXCOORD8,
    float4 v2 : COLOR0,
    float4 v3 : COLOR1,
    float4 v4 : TEXCOORD9,
    float4 v5 : TEXCOORD0,
    float4 v6 : TEXCOORD1,
    float4 v7 : TEXCOORD2,
    float4 v8 : TEXCOORD3,
    float4 v9 : TEXCOORD4,
    float4 v10 : TEXCOORD5,
    float4 v11 : TEXCOORD6,
    float4 v12 : TEXCOORD7,
    out float4 o0 : SV_TARGET0) {
  // Animated UV scale for the first shape/mask texture.
  float2 uv_anim = cb4[136].x * v5.xy;
  float4 sample_a = BitNorm(t1.Sample(s1_s, uv_anim), cb3[46], cb3[47]);

  // First signed 2D bloom shape:
  // - x/a define a mask/intensity term
  // - xy are re-centered into [-1, 1]
  // - radial_a_rcp is later used as a pseudo-height/depth term
  float mask_a = max(sample_a.w * sample_a.x, 0.f);
  float2 centered_a = (sample_a.xy - 0.5f) * 2.f;
  float radial_a = saturate(1.f - dot(centered_a, centered_a));
  float radial_a_rcp = min(SafeRcp(radial_a), 1.f);

  // Control texture; z blends shape A toward a fixed forward vector.
  float4 control = BitNorm(t2.Sample(s2_s, v5.xy), cb3[48], cb3[49]);
  float3 mixed_a = control.z * float3(centered_a, -1.f) + float3(0.f, 0.f, 1.f);

  // Second signed 2D bloom shape, built the same way as A.
  float4 sample_b = BitNorm(t3.Sample(s3_s, v5.xy), cb3[50], cb3[51]);
  float mask_b = max(sample_b.w * sample_b.x, 0.f);
  float2 centered_b = (sample_b.xy - 0.5f) * 2.f;
  float radial_b = saturate(1.f - dot(centered_b, centered_b));
  float radial_b_rcp = min(SafeRcp(radial_b), 1.f);

  // Combine the two shapes into a 3D-ish direction vector.
  // z is downscaled so the effect stays flatter than a true sphere.
  float3 mixed = float3(centered_b, radial_b_rcp) + mixed_a;
  mixed *= float3(1.f, 1.f, 0.7f);

  // Reconstruct the final direction in the local basis carried in v7/v8/v9.
  float3 mixed_n = SafeNormalize(mixed);
  float3 dir8 = SafeNormalize(v8.xyz);
  float3 dir7 = SafeNormalize(v7.xyz);
  float3 dir9 = SafeNormalize(v9.xyz);

  float3 combined = mixed_n.x * dir7 + mixed_n.y * dir8 + mixed_n.z * dir9;
  float3 combined_n = SafeNormalize(combined);

  // Compare the reconstructed glow direction against the object-to-center /
  // view-ish direction. This is the main "is the bloom facing us?" term.
  float3 to_center = cb4[20].xyz - v6.xyz;
  to_center.y += 0.5f;
  float3 to_center_n = SafeNormalize(to_center);

  float facing = saturate(dot(to_center_n, combined_n));
  // Soft nonlinear focus shaping. The original behaves like pow(facing, 0.3),
  // which lifts tiny positive values a lot. Multiply by facing once more so
  // weak directional matches don't turn into visible FP16 noise.
  float focus = saturate(exp(log(max(facing, 1e-4f)) * 0.3f) * facing);

  // A separate stepped pulse seed derived from facing.
  float pulse = facing * facing * 16.f;
  float4 base = BitNorm(t0.Sample(s0_s, v5.xy), cb3[44], cb3[45]);

  // Base bloom magnitude comes from t0.a * vertex alpha, then focus-scaled.
  float intensity = base.w * v2.w;
  intensity *= focus;
  intensity *= cb4[137].x;
  intensity = max(intensity, 0.f);

  // Object-space animated sine wave. This is effectively a temporal gate.
  float phase = frac(v6.z * 111.408455f + 0.5f);
  phase = phase * 6.283185f - 3.141593f;
  float wave = sin(phase) * cb4[138].x;

  // If the wave flips sign, the original shader can force intensity to a hard
  // 12.0 before it is multiplied by base.w and cb4[139].x. That throws away
  // the earlier focus/intensity shaping entirely, so keep the pulse behavior
  // but apply it as a boost to the authored intensity instead.
  float wave_frac = frac(wave);
  float wave_gate = saturate(wave - wave_frac);
  float wave_boost = (-wave >= 0.f) ? lerp(1.f, 12.f, focus) : 1.f;
  intensity *= wave_boost;
  intensity *= max(base.w, 0.f);
  intensity *= cb4[139].x;
  intensity = max(intensity, 0.f);

  // Convert the pulse seed into a stepped gain between cb4[140].x and
  // cb4[141].x, then apply it to intensity.
  float pulse_frac = frac(pulse);
  float pulse_scaled = (pulse - pulse_frac) * 0.0625f;
  float pulse_span = cb4[141].x - cb4[140].x;
  float pulse_gain = pulse_scaled * pulse_span + cb4[140].x;
  pulse_gain = max(pulse_gain, 0.f);
  float bloom = intensity * pulse_gain;

  // Alpha-test style discard based on the final bloom scalar.
  uint alpha_u8 = (uint)(bloom * 255.f + 0.0001f);
  if (alpha_u8 < cb3[8].z) discard;

  // Output is grayscale bloom replicated to all channels.
    float bloom_out = 1.f - exp2(-max(bloom, 0.f));
    o0 = bloom_out.xxxx;
/*   o0.rgb = bloom.xxx;
  o0.a = bloom; */
}
