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

// ...

if( GetOutputDevice() == TONEMAPPER_OUTPUT_sRGB)
{		
	// Convert from sRGB to specified output gamut	
	//float3 OutputGamutColor = mul( AP1_2_Output, mul( sRGB_2_AP1, FilmColor ) );

	// FIXME: Workaround for UE-29935, pushing all colors with a 0 component to black output
	// Default parameters seem to cancel out (sRGB->XYZ->AP1->XYZ->sRGB), so should be okay for a temp fix
	float3 OutputGamutColor = WorkingColorSpace.bIsSRGB ? FilmColor : mul( AP1_2_Output, mul( (float3x3)WorkingColorSpace.ToAP1, FilmColor ) );

	// Apply conversion to sRGB (this must be an exact sRGB conversion else darks are bad).
	// ==== changes
-	OutDeviceColor = LinearToSrgb( OutputGamutColor );
+	OutDeviceColor = pow( abs( OutputGamutColor ), 1.0 / 2.2 ) * sign( OutputGamutColor );  // fix: force gamma 2.2 instead, given that SDR only looked good with a gamma mismatch due to the fog raise
	// ====
}
```
