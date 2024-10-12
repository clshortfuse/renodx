Replacement shaders (all permutations of PostProcessCombineLUTs) compiled through a blank UE5.1 project and dumped from the editor.

Edits done in PostProcessCombineLUTs.usf:
```diff
+struct ShaderInjectData {
+  float type;
+  float magicNumber;
+};
+
+cbuffer injectedBuffer : register(b0, space50) {
+  ShaderInjectData injectedData : packoffset(c0);
+}

// Nuke-style Color Correct
float3 ColorCorrectAll( float3 WorkingColor )
{
	float Luma = dot( WorkingColor, AP1_RGB2Y );

	// Shadow CC
+	float4 ShadowOffset = ColorOffsetShadows+ColorOffset;
+	float4 GammaOffset = 0;
+	float4 ContrastOffset = 0;
+	if (injectedData.type > 0) {
+		if (any(saturate(ShadowOffset))) 
+		{
+			ShadowOffset.xyz *= pow(saturate(WorkingColor.xyz), 1.f / 2.2f);
+			ShadowOffset.w *= pow(saturate(Luma), 1.f / 2.2f);
+			float4 OtherOffset = saturate((ColorOffsetShadows - ShadowOffset) * injectedData.magicNumber);
+			if (injectedData.type == 2) {
+				GammaOffset = OtherOffset;
+			} else if (injectedData.type == 3) {
+				ContrastOffset = -OtherOffset;
+			}
+		}
+	}
+	
	float3 CCColorShadows = ColorCorrect(WorkingColor, 
		ColorSaturationShadows*ColorSaturation, 
		ColorContrastShadows*ColorContrast + ContrastOffset, 
		ColorGammaShadows*ColorGamma + GammaOffset, 
		ColorGainShadows*ColorGain, 
-       ColorOffsetShadows - ShadowOffset);
+		ShadowOffset);
	float CCWeightShadows = 1- smoothstep(0, ColorCorrectionShadowsMax, Luma);
// ...
}
```
