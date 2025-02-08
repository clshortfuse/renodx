Texture2D<float4> mergedChartTex : register(t0);

cbuffer PER_BATCH : register(b0, space1) {
  float PER_BATCH_003x : packoffset(c003.x);
  float PER_BATCH_003y : packoffset(c003.y);
  float PER_BATCH_003z : packoffset(c003.z);
  float PER_BATCH_003w : packoffset(c003.w);
  float PER_BATCH_004x : packoffset(c004.x);
  float PER_BATCH_004y : packoffset(c004.y);
  float PER_BATCH_004z : packoffset(c004.z);
  float PER_BATCH_004w : packoffset(c004.w);
  float PER_BATCH_005x : packoffset(c005.x);
  float PER_BATCH_005y : packoffset(c005.y);
  float PER_BATCH_005z : packoffset(c005.z);
  float PER_BATCH_005w : packoffset(c005.w);
  float PER_BATCH_006x : packoffset(c006.x);
  float PER_BATCH_006y : packoffset(c006.y);
  float PER_BATCH_006z : packoffset(c006.z);
  float PER_BATCH_006w : packoffset(c006.w);
  float PER_BATCH_007x : packoffset(c007.x);
};

SamplerState mergedChartSampler : register(s1);

#define LUT_SIZE 16.f
#define LUT_MAX (LUT_SIZE - 1.f)

float4 main(noperspective float4 SV_Position : SV_Position, linear float2 TEXCOORD : TEXCOORD, linear float3 TEXCOORD_1 : TEXCOORD1) : SV_Target
{
	float gamma = 1.f / PER_BATCH_006y; // Probably 1/2.2
	float _21 = PER_BATCH_006z - PER_BATCH_006x;
	float _37 = PER_BATCH_007x - PER_BATCH_006w;
	float lutTexelSize = 1.f / LUT_SIZE;
	float lutHalfTexelSize = 0.5f / LUT_SIZE;
	float3 lutInputColor = ((pow(max((((TEXCOORD_1.xyz * 255.f) - PER_BATCH_006x) / _21), 0.f), gamma) * _37) + PER_BATCH_006w) * 0.003921568859368563f;
	float coordY = ((saturate((dot(float4(lutInputColor, 1.f), float4(PER_BATCH_004x, PER_BATCH_004y, PER_BATCH_004z, PER_BATCH_004w))))) * (1.f - lutTexelSize)) + lutHalfTexelSize;
	float coordX = (saturate((dot(float4(lutInputColor, 1.f), float4(PER_BATCH_005x, PER_BATCH_005y, PER_BATCH_005z, PER_BATCH_005w))))) * LUT_MAX;
	float fracZ = frac(coordX);
	float coordXModulo = (((((saturate((dot(float4(lutInputColor, 1.f), float4(PER_BATCH_003x, PER_BATCH_003y, PER_BATCH_003z, PER_BATCH_003w))))) * (1.f - lutTexelSize)) + lutHalfTexelSize) - fracZ) + coordX) * lutTexelSize;
	float3 slice1 = mergedChartTex.Sample(mergedChartSampler, float2(coordXModulo, coordY)).rgb;
	float3 slice2 = mergedChartTex.Sample(mergedChartSampler, float2(coordXModulo + lutTexelSize, coordY)).rgb;
	float4 outColor;
	outColor.rgb = lerp(slice1, slice2, fracZ);
	outColor.a = 1.f;
	return outColor;
}
