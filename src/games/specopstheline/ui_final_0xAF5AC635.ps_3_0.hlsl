#include "./shared.h"

float3 ColorScale : register( c0 );
float4 OverlayColor : register(c4);
float InverseGamma : register(c5);
sampler2D SceneColorTexture : register( s0 );

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r0;
	float3 r1;
	float3 r2;
	
	r0 = tex2D(SceneColorTexture, texcoord);            // texld_pp r0, v0, s0
	r1.xyz = r0.xyz * ColorScale.xyz;                   // mul_pp r1.xyz, r0.xyz, c0.xyz
	r2.xyz = ColorScale.xyz;                            // mov_pp r2.xyz, c0.xyz
	r0.xyz = r0.xyz * -r2.xyz + OverlayColor.xyz;       // mad_pp r0.xyz, r0.xyz, -r2.xyz, c4.xyz
	o.w = r0.w;                                         // mov_pp oC0.w, r0.w
	if (RENODX_TONE_MAP_TYPE == 0) {
    r0.xyz = saturate(OverlayColor.w * r0.xyz + r1.xyz);  // mad_sat_pp r0.xyz, c4.w, r0.xyz, r1.xyz
  } else {
    r0.xyz = OverlayColor.w * r0.xyz + r1.xyz;
  }
  // r1.xyz = max(r0.xyz, 9.99999997e-007);              // max r1.xyz, r0.xyz, c1.x
  // r0.x = log2(r1.x);                                  // log r0.x, r1.x
  // r0.y = log2(r1.y);                                  // log r0.y, r1.y
  // r0.z = log2(r1.z);                                  // log r0.z, r1.z
  // r0.xyz = r0.xyz * InverseGamma.x;                   // mul r0.xyz, r0.xyz, c5.x
  // o.x = exp2(r0.x);                                   // exp oC0.x, r0.x
  // o.y = exp2(r0.y);                                   // exp oC0.y, r0.y
  // o.z = exp2(r0.z);                                   // exp oC0.z, r0.z
  o.rgb = renodx::color::srgb::EncodeSafe(r0.rgb);
  
	return o;
}
