#include "./shared.h"

SamplerState ColorYSamplerSmp : register(s0);
SamplerState ColorUSamplerSmp : register(s1);
SamplerState ColorVSamplerSmp : register(s2);
Texture2D<float4> ColorYSampler : register(t0); // 
Texture2D<float4> ColorUSampler : register(t1); // 
Texture2D<float4> ColorVSampler : register(t2); // 
cbuffer Params : register(b0) {
  float  FilterType;
  float3 UVScaleYUV; 
}

// This is probably not great
float3 YUVtoRGB(float Y, float Cr, float Cb, uint type = 0)
{
  float V = Cr;
  float U = Cb;

	float3 color = 0.0;
  if (type == 0) { // Rec.709 full range
    color.r = (Y - 0.790487825870513916015625f) + (Cr * 1.5748f);
    color.g = (Y + 0.329009473323822021484375f) - (Cr * 0.46812427043914794921875f) - (Cb * 0.18732427060604095458984375f);
    color.b = (Y - 0.931438446044921875f)       + (Cb * 1.8556f);
  } else if (type == 1) { // Rec.709 limited range
    Y *= 1.16438353f;
    color.r = (Y - 0.972945094f) + (Cr * 1.79274106f);
    color.g = (Y + 0.301482677f) - (Cr * 0.532909333f) - (Cb * 0.213248610f);
    color.b = (Y - 1.13340222f)  + (Cb * 2.11240172f);
  } else if (type == 2) { // Rec.601 full range
    color += Cr * float3(1.59579468, -0.813476563, 0.0); 
    color += Y * 1.16412354;
    color += Cb * float3(0,-0.391448975, 2.01782227);
    color += float3(-0.87065506, 0.529705048, -1.08166885); // Bias offsets
    color = color * 0.858823538 + 0.0627451017; // limited to full range
  } else { // Rec.601 limited range
    Y *= 1.16412353515625f;
    color.r = (Y - 0.870655059814453125f) + (Cr * 1.595794677734375f);
    color.g = (Y + 0.529705047607421875f) - (Cr * 0.8134765625f) - (Cb * 0.391448974609375f);
    color.b = (Y - 1.081668853759765625f) + (Cb * 2.017822265625f);
  }
  return color;
}


void main(
  float2 v0 : TEXCOORD0, // RENDER
  out float4 o0 : SV_TARGET0)
{
  float4 r0; // UV
  // float3 r1; // COLOR
  // float3 r2; // COLOR
  r0.xy = v0.xy * UVScaleYUV.xy; //0 
  
  float3 outputColor;

  float y; 
  float Cr;
  float Cb; 

  y = ColorYSampler.Sample(ColorYSamplerSmp, r0.xy).w;
  Cb = ColorUSampler.Sample(ColorUSamplerSmp, r0.xy).w;
  Cr = ColorVSampler.Sample(ColorVSamplerSmp, r0.xy).w; 

  if (FilterType == 1.0){
    outputColor.rgb = YUVtoRGB(y, Cr, Cb, 0);
  }
  else {
    outputColor.rgb = YUVtoRGB(y, Cr, Cb, 3);
  }

  if (RENODX_TONE_MAP_TYPE ) {
    // outputColor = renodx::draw::ToneMapPass(outputColor); // Sadly this shader is used in game as well and not just the title screen
  }

  // outputColor = renodx::draw::RenderIntermediatePass(outputColor); // Sadly this shader is used in game as well and not just the title screen
  o0.rgb = outputColor;
  o0.w = float(1.0);
}

