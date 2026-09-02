#include "./common.hlsli"

float3 ColorScale : register(c0);
float4 OverlayColor : register(c4);
float InverseGamma : register(c5);
sampler2D SceneColorTexture : register(s0);

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r0;
	float3 r1;
	float3 r2;
	
	r0 = tex2D(SceneColorTexture, texcoord);            
	r1.xyz = r0.xyz * ColorScale.xyz;                   
	r2.xyz = ColorScale.xyz;                            
	r0.xyz = r0.xyz * -r2.xyz + OverlayColor.xyz;       
	o.w = r0.w;                                         
	if (RENODX_TONE_MAP_TYPE == 0) {
    r0.xyz = saturate(OverlayColor.w * r0.xyz + r1.xyz);
  } else {
    r0.xyz = max(0, OverlayColor.w * r0.xyz + r1.xyz);
  }
  r1.xyz = max(r0.xyz, 0);             
  r0.x = log2(r1.x);                                  
  r0.y = log2(r1.y);
  r0.z = log2(r1.z);
  r0.xyz = r0.xyz * InverseGamma.x;                
  o.x = exp2(r0.x);                                  
  o.y = exp2(r0.y);
  o.z = exp2(r0.z);

  o.rgb = renodx::color::srgb::DecodeSafe(o.rgb);
  o.rgb = renodx::draw::RenderIntermediatePass(o.rgb);
  
	return o;
}
