#include "../../common/aces.hlsl"
#include "../../common/color.hlsl"

Texture3D<float4> luminanceLUT : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float3> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

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

  const float userPeakNits = cb0[37].x;

  const float3 bloomColor = t2.Sample(s2_s, v0.xy).xyz;

  // Random
  float grain = grainFromUV(v2.zw);

  r0.y = t1.Sample(s1_s, v3.zw).x;
  r0.z = t1.Sample(s1_s, v3.xy).y;
  r0.w = t1.Sample(s1_s, v0.xy).z;

  r1.xyz = bloomColor.rgb;

  float2 texture0Coords = v0.zw * float2(0.5, -0.5) + float2(0.5, 0.5);
  const float3 texture0Color = t0.Sample(s0_s, texture0Coords).xyz;

  r2.xyz = texture0Color.rgb * cb1[0].xyz + cb0[33].xyz;

  r1.xyz = r2.xyz * bloomColor.rgb;
  r0.yzw = r0.yzw * cb0[32].xyz + r1.xyz;
  r1.xyz = v1.xxx * r0.yzw;

  // half3 ColorLookupTable( half3 LinearColor )
  // LUTEncodedColor = LinToLog( LinearColor + LogToLin( 0 ) );

  r2.xy = cb0[34].z * v1.yz;

  // Bloom stretcher?
  r1.w = dot(r2.xy, r2.xy);
  r1.w = 1 + r1.w;
  r1.w = rcp(r1.w);
  r1.w = r1.w * r1.w;

  r2.xyz = r1.xyz * r1.www;
  const float3 linearColor = r2.xyz;
  r2.xyz = LinToLog(r2.xyz);

  // half3 ColorLookupTable( half3 LinearColor )
  const float lutSize = 32.f;
  float3 lutScale = (lutSize - 1.f) / lutSize;
  float3 lutOffset = 1.f / (2.f * lutSize);
  float lutCoords = r2.xyz * lutScale + lutOffset;
  const float3 texture3Color = luminanceLUT.Sample(s3_s, lutCoords).rgb;
  r2.xyz = texture3Color.rgb;
  r3.xyz = r2.xyz * 1.05f;
  const float3 luminanceFromLUT = r3.xyz;

  if (cb0[37].y != 0) {  // Tonemap by luminance?
    float inputLuminance = yFromBT601(r1.xyz);
    r1.w = yFromBT601(r1.xyz);

    float3 logColor = LinToLog(r1.xyz);
    r4.rgb = LinToLog(r1.xyz);
    lutCoords = logColor * lutScale + lutOffset;
    r4.rgb = luminanceLUT.Sample(s3_s, lutCoords).xyz;
    r4.rgb = saturate(1.05f * r4.rgb);

    r4.rgb = pow(r4.rgb, 2.2f);

    r2.w = yFromBT601(r4.xyz);
    r3.w = cmp(r2.w < 9.99999975e-05);
    r1.w = inputLuminance / r2.w;
    r1.w = -1 + r1.w;
    r1.w = r2.w * r1.w + 1;
    r1.w = r3.w ? 1 : r1.w;
    r4.xyz = r4.rgb * r1.www;
  }
  r3.w = yFromBT601(r3.xyz);
  r0.x = grain * 0.00390625 - 0.001953125;

  r2.xyz = r2.xyz * 1.05f + r0.x;

  r0.x = cmp(v0.x < 0.5);
  r5.xyzw = cmp(asint(cb0[37].yyyy) == int4(2, 1, 3, 4));
  r1.w = (int)r5.z | (int)r5.y;
  r1.w = (int)r5.w | (int)r1.w;
  r0.x = r0.x ? r1.w : 0;
  r0.x = (int)r0.x | (int)r5.x;
  if (r0.x != 0) {
    r6.xyz = saturate(r2.xyz);
    r6.xyz = log2(r6.xyz);
    r6.xyz = float3(2.20000005, 2.20000005, 2.20000005) * r6.xyz;
    r6.xyz = exp2(r6.xyz);
    r7.x = dot(float3(0.627403975, 0.329281986, 0.0433136001), r6.xyz);
    r7.y = dot(float3(0.0690969974, 0.919539988, 0.0113612004), r6.xyz);
    r7.z = dot(float3(0.0163915996, 0.088013202, 0.895595014), r6.xyz);
    r6.xyz = float3(0.0599999987, 0.0599999987, 0.0599999987) * r7.xyz;
    r6.xyz = log2(r6.xyz);
    r6.xyz = float3(0.159301758, 0.159301758, 0.159301758) * r6.xyz;
    r6.xyz = exp2(r6.xyz);
    r7.xyz = r6.xyz * float3(18.8515625, 18.8515625, 18.8515625) + float3(0.8359375, 0.8359375, 0.8359375);
    r6.xyz = r6.xyz * float3(18.6875, 18.6875, 18.6875) + float3(1, 1, 1);
    r6.xyz = r7.xyz / r6.xyz;
    r6.xyz = log2(r6.xyz);
    r6.xyz = float3(78.84375, 78.84375, 78.84375) * r6.xyz;
    r6.xyz = exp2(r6.xyz);
    r3.xyz = min(float3(1, 1, 1), r6.xyz);
  } else {
    r0.x = cmp(asint(cb0[37].y) == 5);
    r0.x = (int)r0.x | (int)r5.w;
    r1.w = cmp(0.5 < v0.y);
    r1.w = r1.w ? r5.z : 0;
    r0.x = (int)r0.x | (int)r1.w;
    if (r0.x != 0) {
      r5.x = dot(float3(0.627403975, 0.329281986, 0.0433136001), r4.xyz);
      r5.y = dot(float3(0.0690969974, 0.919539988, 0.0113612004), r4.xyz);
      r5.z = dot(float3(0.0163915996, 0.088013202, 0.895595014), r4.xyz);
      r0.x = 0.000199999995 * userPeakNits;
      r4.xyz = float3(5.55555534, 5.55555534, 5.55555534) * r5.xyz;
      r4.xyz = log2(r4.xyz);
      r4.xyz = cb0[38].yyy * r4.xyz;
      r4.xyz = exp2(r4.xyz);
      r4.xyz = cb0[37].www * r4.xyz;
      r5.xyz = float3(0.180000007, 0.180000007, 0.180000007) * r4.xyz;
      r6.xyz = r4.xyz * float3(0.451800019, 0.451800019, 0.451800019) + float3(0.300000012, 0.300000012, 0.300000012);
      r6.xyz = r6.xyz * r5.xyz;
      r4.xyz = r4.xyz * float3(0.448200017, 0.448200017, 0.448200017) + float3(0.589999974, 0.589999974, 0.589999974);
      r4.xyz = r5.xyz * r4.xyz + float3(0.400000006, 0.400000006, 0.400000006);
      r4.xyz = saturate(r6.xyz / r4.xyz);
      r4.xyz = r4.xyz * r0.xxx;
      r4.xyz = cb0[38].xxx * r4.xyz;
    } else {
      r0.xyz = -r0.yzw * v1.xxx + cb0[40].xyz;
      r0.xyz = cb0[40].www * r0.xyz + r1.xyz;

      r1.xyz = mul(BT709_2_BT2020_MAT, r0.xyz);

      r0.x = 0.000199999995 * userPeakNits;
      r0.yzw = float3(5.55555534, 5.55555534, 5.55555534) * r1.xyz;
      r0.yzw = log2(r0.yzw);
      r0.yzw = cb0[38].yyy * r0.yzw;
      r0.yzw = exp2(r0.yzw);
      r0.yzw = cb0[37].www * r0.yzw;
      r1.xyz = float3(0.180000007, 0.180000007, 0.180000007) * r0.yzw;
      r5.xyz = r0.yzw * float3(0.451800019, 0.451800019, 0.451800019) + float3(0.0299999993, 0.0299999993, 0.0299999993);
      r5.xyz = r5.xyz * r1.xyz;
      r0.yzw = r0.yzw * float3(0.437400043, 0.437400043, 0.437400043) + float3(0.589999974, 0.589999974, 0.589999974);
      r0.yzw = r1.xyz * r0.yzw + float3(0.400000006, 0.400000006, 0.400000006);
      r0.yzw = saturate(r5.xyz / r0.yzw);
      r0.xyz = r0.yzw * r0.xxx;
      r4.xyz = cb0[38].xxx * r0.xyz;
    }
    r0.xyz = log2(r4.xyz);
    r0.xyz = float3(0.159301758, 0.159301758, 0.159301758) * r0.xyz;
    r0.xyz = exp2(r0.xyz);
    r1.xyz = r0.xyz * float3(18.8515625, 18.8515625, 18.8515625) + float3(0.8359375, 0.8359375, 0.8359375);
    r0.xyz = r0.xyz * float3(18.6875, 18.6875, 18.6875) + float3(1, 1, 1);
    r0.xyz = r1.xyz / r0.xyz;
    r0.xyz = log2(r0.xyz);
    r0.xyz = float3(78.84375, 78.84375, 78.84375) * r0.xyz;
    r0.xyz = exp2(r0.xyz);
    r3.xyz = min(float3(1, 1, 1), r0.xyz);
  }

  psOutput.o0.xyzw = r3.xyzw;
  psOutput.o1.w = r3.w;
  psOutput.o1.xyz = r2.xyz;

  // TEST

  float3 testColor = aces_rrt_odt(
                       linearColor,
                       0.0001,
                       48.f * (userPeakNits / 203.f),
                       AP1_2_BT2020_MAT
                     )
                   * userPeakNits;

  // testColor = mul(BT709_2_BT2020_MAT, texture3Color);
  // testColor *= userPeakNits;
  testColor /= 10000.f;  // Scale for PQ
  testColor = max(0, testColor);
  testColor = pqFromLinear(testColor);
  psOutput.o0.rgb = testColor.rgb;

  return psOutput;
}
