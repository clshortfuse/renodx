#include "./common.hlsl"

float4 gBlurParams : register( c0 );
float4 gFilmGrainParams : register( c6 );
sampler2D gLinearToGammaRamp : register( s1 );
sampler2D gLowResColor : register( s2 );
sampler2D gSceneColor : register( s0 );

struct PS_IN
{
	float2 texcoord : TEXCOORD;
	float2 texcoord3 : TEXCOORD3;
};

float4 Sample(sampler2D s, float3 color, float size) {
  color = saturate(color);

  const float max_index = size - 1.f;
  const float slice = 1.f / size;
  const float texel_size = slice * slice;

  float z_position = color.z * max_index;
  float z_integer = floor(z_position);
  float z_fraction = z_position - z_integer;

  const float x_offset = (color.r * max_index * texel_size) + (texel_size * 0.5f);
  const float y_offset = (color.g * max_index * slice) + (slice * 0.5f);
  const float z_offset = z_integer * slice;

  float2 uv = float2(z_offset + x_offset, y_offset);

  float4 color0 = tex2D(s, uv);
  uv.x += slice;
  float4 color1 = tex2D(s, uv);

  return lerp(color0, color1, z_fraction);
}

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	r0 = tex2D(gSceneColor, i.texcoord);

        //float3 untonemapped = r0.xyz;
        //r0.xyz = CustomSDRTonemap(untonemapped);

	r1.x = 256;
	r0.w = r0.w * r1.x + -gBlurParams.x;
        //r0.w = r0.w * gBlurParams.y;
        r0.w = saturate(r0.w * gBlurParams.y);
	r0.w = r0.w * gBlurParams.z;
	r1 = tex2D(gLowResColor, i.texcoord);
        r2.xyz = lerp(r0.xyz, r1.xyz, r0.w);

        float3 ungraded = r2.xyz;
        float3 ungraded_sdr = CustomSDRTonemap(ungraded);
        r2.xyz = ungraded_sdr;

        r0.x = rsqrt(r2.x);
        // r0.z = saturate(1 / r0.x);
        r0.z = 1 / r0.x;
        r0.x = rsqrt(r2.y);
        r1.x = rsqrt(r2.z);
        // r0.y = saturate(1 / r1.x);
        // r0.w = saturate(1 / r0.x);
        r0.y = 1 / r1.x;
        r0.w = 1 / r0.x;

        // r1.yzw = r0.xyz * float3(256, 14.9999, 15);
        // r1.yzw = r0.yzw * float3(256, 14.9999, 15);
        // r0.x = frac(r1.y);
        // r0.x = -r0.x + r1.y;
        // r0.z = max(r1.z, 0.1);
        // r1.y = min(r0.z, 14.9);
        // r1.x = r0.x * 16 + r1.y;
        // r0.x = r0.y * 14.9999 + -r0.x;
        // r1 = r1.xwxw + float4(0.5, 0.5, 16.5, 0.5);
        // r1 = r1 * float4(0.00390625, 0.0625, 0.00390625, 0.0625);
        // r2 = tex2D(gLinearToGammaRamp, r1);
        // r1 = tex2D(gLinearToGammaRamp, r1.zwzw);
        // r3 = lerp(r2, r1, r0.x);

    r3 = Sample(gLinearToGammaRamp, r0.zwy, 16);
    float3 graded = renodx::color::srgb::DecodeSafe(r3.xyz);
    r3.xyz = CustomUpgradeTonemap(ungraded, graded, ungraded_sdr);

    if (CUSTOM_FILM_GRAIN_TOGGLE == 1) {
      o.xyz = renodx::effects::ApplyFilmGrain(r3.xyz, i.texcoord, CUSTOM_RANDOM, CUSTOM_FILM_GRAIN_STRENGTH * 0.03f);
    }
    else {
      r0.xyz = frac(i.texcoord3.xyx);
      r0.xyz = r0.xyz * 128 + float3(-64.34062, -72.46562, -64.34062);
      r0.xyz = r0.xyy * r0.xyz;
      r0.x = dot(r0.xyz, float3(20.390625, 60.703125, 2.4281209));
      r0.x = frac(r0.x);
      r0.x = r0.x * gFilmGrainParams.x + gFilmGrainParams.y;
      o.xyz = r0.x + r3.xyz;
    }

    o.w = r3.w;

o.rgb = renodx::draw::RenderIntermediatePass(renodx::color::srgb::DecodeSafe(o.xyz));

return o;
}
