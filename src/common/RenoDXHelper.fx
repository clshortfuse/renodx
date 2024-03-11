#include "ReShade.fxh"

float3 main(float4 pos : SV_Position, float2 texcoord : TexCoord ) : COLOR
{
	float3 inputColor = tex2D(ReShade::BackBuffer, texcoord ).rgb;
	float3 outputColor = inputColor;
	outputColor = sign(outputColor) * pow(abs(outputColor), 2.2f);
	return outputColor * 203.f/80.f;
	
}

technique RenoDXHelper
{
	pass
	{
		VertexShader = PostProcessVS;
		PixelShader = main;
	}
}