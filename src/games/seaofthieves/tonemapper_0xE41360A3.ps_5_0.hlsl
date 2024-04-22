#include "../../shaders/aces.hlsl"
#include "../../shaders/color.hlsl"

#define RENODX_SOT_ACES_TONEMAPPER 1

Texture2D<float4> textureBlackDummy : register(t0);
Texture2D<float3> textureToneMap : register(t1);
Texture2D<float4> textureSceneColorHalfRes : register(t2);
Texture3D<float4> textureCombineLUTs : register(t3);

SamplerState s0_s : register(s0);
SamplerState s1_s : register(s1);
SamplerState s2_s : register(s2);
SamplerState s3_s : register(s3);

cbuffer cb0 : register(b0) {
  float4 cb0[41];
}

cbuffer cb1 : register(b1) {
  float4 cb1[1];
}

// 3Dmigoto declarations
#define cmp -

struct PS_INPUT {
  float4 v0 : TEXCOORD0;
  float3 v1 : TEXCOORD1;
  float4 v2 : TEXCOORD2;
  float4 v3 : TEXCOORD3;
};

struct PS_OUTPUT {
  float4 o0 : SV_Target0;
  float4 o1 : SV_Target1;
};

// From Unreal
half grainFromUV(float2 GrainUV) {
  return frac(sin(GrainUV.x + GrainUV.y * 543.31) * 493013.0);
}

float3 LinToLog(float3 LinearColor) {
  const float LinearRange = 14;
  const float LinearGrey = 0.18;
  const float ExposureGrey = 444;

  // Using stripped down, 'pure log', formula. Parameterized by grey points and dynamic range covered.
  float3 LogColor = log2(LinearColor) / LinearRange - log2(LinearGrey) / LinearRange + ExposureGrey / 1023.0;  // scalar: 3log2 3mad
  //float3 LogColor = (log2(LinearColor) - log2(LinearGrey)) / LinearRange + ExposureGrey / 1023.0;
  //float3 LogColor = log2( LinearColor / LinearGrey ) / LinearRange + ExposureGrey / 1023.0;
  //float3 LogColor = (0.432699 * log10(0.5 * LinearColor + 0.037584) + 0.616596) + 0.03;	// SLog
  //float3 LogColor = ( 300 * log10( LinearColor * (1 - .0108) + .0108 ) + 685 ) / 1023;	// Cineon
  LogColor = saturate(LogColor);

  return LogColor;
}

PS_OUTPUT main(PS_INPUT psInput) {
  PS_OUTPUT psOutput;
  float4 v0 = psInput.v0;
  float3 v1 = psInput.v1;
  float4 v2 = psInput.v2;
  float4 v3 = psInput.v3;

  float4 r0, r1, r2, r3, r4, r5, r6, r7;
  uint4 bitmask, uiDest;
  float4 fDest;

  float3 testColor = 1.f;

  const float userPeakNits = cb0[37].x;
  const float colorContrastGain = cb0[37].w;
  const float colorContrast = cb0[38].y;
  const float finalGain = cb0[38].x;  // Usually 1.f

  // Random
  float grain = grainFromUV(v2.zw) / 256.f - (1.f / 512.f);

  float3 inputColor;
  inputColor.r = textureToneMap.Sample(s1_s, v3.zw).r;
  inputColor.g = textureToneMap.Sample(s1_s, v3.xy).g;
  inputColor.b = textureToneMap.Sample(s1_s, v0.xy).b;

  const float3 bloomColor = textureSceneColorHalfRes.Sample(s2_s, v0.xy).xyz;

  r1.rgb = bloomColor.rgb;

  float2 texture0Coords = v0.zw * float2(0.5, -0.5) + float2(0.5, 0.5);
  const float3 texture0Color = textureBlackDummy.Sample(s0_s, texture0Coords).xyz;

  r2.xyz = texture0Color.rgb * cb1[0].xyz + cb0[33].xyz;  // Gain mask?

  r1.rgb = r2.xyz * bloomColor.rgb;

  inputColor = inputColor * cb0[32].xyz + r1.rgb;

  r1.rgb = v1.xxx * inputColor;
  float3 bloomedColor = r1.rgb;

  // half3 ColorLookupTable( half3 LinearColor )
  // LUTEncodedColor = LinToLog( LinearColor + LogToLin( 0 ) );

  r2.xy = cb0[34].z * v1.yz;

  // Vignette?
  float vignette = 1.f + dot(r2.xy, r2.xy);
  vignette = rcp(vignette);
  vignette = vignette * vignette;

  float3 vignettedColor = bloomedColor * vignette;
  // half3 ColorLookupTable( half3 LinearColor )
  float3 lutLookupColor = LinToLog(vignettedColor);
  const float lutSize = 32.f;
  float3 lutScale = (lutSize - 1.f) / lutSize;
  float3 lutOffset = 1.f / (2.f * lutSize);
  float3 lutCoords = lutLookupColor * lutScale + lutOffset;
  const float3 lutColor = textureCombineLUTs.Sample(s3_s, lutCoords).rgb;
  const float3 colorGradedColor = lutColor.rgb * 1.05f;

  if (cb0[37].y != 0) {  // Tonemap by luminance?
    float inputLuminance = yFromBT601(bloomedColor);
    r1.w = yFromBT601(bloomedColor);

    float3 logColor = LinToLog(bloomedColor);
    r4.rgb = LinToLog(bloomedColor);
    lutCoords = logColor * lutScale + lutOffset;
    r4.rgb = textureCombineLUTs.Sample(s3_s, lutCoords).xyz;
    r4.rgb = saturate(1.05f * r4.rgb);

    r4.rgb = pow(r4.rgb, 2.2f);

    r2.w = yFromBT601(r4.xyz);
    r3.w = cmp(r2.w < 9.99999975e-05);
    r1.w = inputLuminance / r2.w;
    r1.w = -1 + r1.w;
    r1.w = r2.w * r1.w + 1;
    r1.w = r3.w ? 1 : r1.w;
    r4.rgb = r4.rgb * r1.www;
  }
  r3.w = yFromBT601(colorGradedColor);

  float3 grainedColor = colorGradedColor + grain;

  r0.x = cmp(v0.x < 0.5);

  // Probably LUT output type in switch statement
  r5.xyzw = cmp(asint(cb0[37].yyyy) == int4(2, 1, 3, 4));
  r1.w = (int)r5.z | (int)r5.y;  // type = 1 || 3
  r1.w = (int)r5.w | (int)r1.w;  // type = 1 || 3 || 4
  r0.x = r0.x ? r1.w : 0;        // (v0.x < 0.5) && (1 || 3 || 4)
  r0.x = (int)r0.x | (int)r5.x;  // above || 2
  if (r0.x != 0) {
    // SDR LUT, scale to 600 nits?
    r6.rgb = saturate(grainedColor);           // Clamp SDR LUT output?
    r6.rgb = pow(r6.rgb, 2.2f);                // 2.2 Gamma
    r7.rgb = mul(BT709_2_BT2020_MAT, r6.rgb);  // PQ color space
    r6.rgb = r7.rgb * 600 / 10000.f;           // Stretch to 600 nits
    r6.rgb = pqFromLinear(r6.rgb);             // PQ
    r3.rgb = min(r6.rgb, 1.f);                 // Clamp (again?)
  } else {
    r0.x = cmp(asint(cb0[37].y) == 5);  // type == 5
    r0.x = (int)r0.x | (int)r5.w;       // type == 5 or 4
    r1.w = cmp(0.5 < v0.y);             //
    r1.w = r1.w ? r5.z : 0;             // (v0.y >= 0.5) && (type == 3)
    r0.x = (int)r0.x | (int)r1.w;       // (5 or 4) || above
    if (r0.x != 0) {
      r5.rgb = mul(BT709_2_BT2020_MAT, r4.rgb);

      r4.rgb = pow(r5.rgb / 0.18f, colorContrast) * colorContrastGain;
      r5.rgb = 0.18f * r4.rgb;

      r6.rgb = r4.rgb * 0.4518f + 0.3f;
      r6.rgb = r6.rgb * r5.rgb;

      r4.rgb = r4.rgb * 0.4482f + 0.59f;
      r4.rgb = r5.rgb * r4.rgb + 0.4f;
      r4.rgb = saturate(r6.rgb / r4.rgb);
      float newPeak = (2 * userPeakNits) / 10000.f;  // Maybe to stretch contrast?
      r4.rgb = r4.rgb * newPeak;
      r4.rgb = finalGain * r4.rgb;
    } else {
      // Default (0) case

      r0.rgb = lerp(bloomedColor, cb0[40].rgb, cb0[40].w);
      r1.rgb = mul(BT709_2_BT2020_MAT, r0.rgb);

      r0.yzw = r1.rgb / 0.18f;
      r0.yzw = pow(r0.yzw, colorContrast) * colorContrastGain;
      r1.rgb = 0.18f * r0.yzw;

#if RENODX_SOT_ACES_TONEMAPPER
      r1.rgb *= 8.f;  // Scale up close to SDR;

      float hdrBrightness = pow(finalGain, 0.25f);  // 0-2
      float userPaperWhite = 200.f * hdrBrightness;

      float3 ap0Color = mul(BT2020_2_AP0_MAT, r1.rgb);
      float3 tonemappedColor = aces_odt(
        aces_rrt(ap0Color),
        0.0001f,  // minY
        48.f * (userPeakNits / userPaperWhite),
        AP1_2_BT2020_MAT
      );
      r4.rgb = tonemappedColor.rgb * userPeakNits / 10000.f;
#else

      r5.rgb = r0.yzw * 0.4518f + 0.03f;
      r5.rgb = r5.rgb * r1.rgb;
      r0.yzw = r0.yzw * 0.4374f + 0.59f;
      r0.yzw = r1.rgb * r0.yzw + 0.4f;
      r0.yzw = saturate(r5.rgb / r0.yzw);

      float newPeak = (2 * userPeakNits) / 10000.f;  // Maybe to stretch contrast?
      r0.rgb = r0.yzw * newPeak;

      r4.rgb = finalGain * r0.rgb;
#endif
    }
    r3.rgb = pqFromLinear(r4.rgb);
    r3.rgb = min(r3.rgb, 1.f);
  }

  psOutput.o0.rgba = r3.rgba;
  psOutput.o1.rgba = float4(grainedColor.rgb, r3.a);

  // TEST
  testColor = mul(BT709_2_BT2020_MAT, inputColor);
  testColor *= 80;
  testColor /= 10000.f;  // Scale for PQ
  testColor = max(0, testColor);
  testColor = pqFromLinear(testColor);
  // psOutput.o0.rgb = testColor.rgb;

  return psOutput;
}
