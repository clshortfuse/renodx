Replacement shaders (all permutations of PostProcessCombineLUTs) compiled through a blank UE 5.5.4 project and dumped from the editor.

Edits done in PostProcessCombineLUTs.usf:
```diff
+#include "LumaIncludes.ush"

// ...

float3 ColorCorrect( float3 WorkingColor,
	float4 ColorSaturation,
	float4 ColorContrast,
	float4 ColorGamma,
	float4 ColorGain,
	float4 ColorOffset )
{
	// TODO optimize
	float Luma = dot( WorkingColor, AP1_RGB2Y );
	WorkingColor = max( 0, lerp( Luma.xxx, WorkingColor, ColorSaturation.xyz*ColorSaturation.w ) );
	WorkingColor = pow( WorkingColor * (1.0 / 0.18), ColorContrast.xyz*ColorContrast.w ) * 0.18;
	WorkingColor = pow( WorkingColor, 1.0 / (ColorGamma.xyz*ColorGamma.w) );
-	WorkingColor = WorkingColor * (ColorGain.xyz * ColorGain.w) + (ColorOffset.xyz + ColorOffset.w);  // original code
+	WorkingColor = mul(FixColorFade(mul(WorkingColor * (ColorGain.xyz * ColorGain.w), AP1_TO_BT709_MAT), mul(ColorOffset.xyz + ColorOffset.w, AP1_TO_BT709_MAT)), BT709_TO_AP1_MAT); // haze fix

	return WorkingColor;
}
```
