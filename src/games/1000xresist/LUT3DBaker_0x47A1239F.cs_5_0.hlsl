#include "./common.hlsl"

// https://github.com/Unity-Technologies/Graphics/blob/e42df452b62857a60944aed34f02efa1bda50018/com.unity.postprocessing/PostProcessing/Shaders/Builtins/Lut3DBaker.compute
// KGenLUT3D_AcesTonemap

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

RWTexture3D<float4> u0 : register(u0);

cbuffer cb0 : register(b0) {
  float4 cb0[10];
}

#define cmp -

[numthreads(4, 4, 4)]
void main(uint3 vThreadID: SV_DispatchThreadID) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;
  float3 sanity;
  r0.rgb = (uint3)vThreadID.rgb;
  r1.rgb = cmp(r0.rgb < cb0[0].rrr);
  r0.a = r1.g ? r1.r : 0;
  r0.a = r1.b ? r0.a : 0;
  if (r0.a != 0) {
    // (start) ColorGrade
    r0.rgb = r0.rgb * cb0[0].ggg;

    r0.rgb = lutShaper(r0.rgb, true);
    sanity = r0.rgb;

    // unity_to_ACES(r0.rgb)
    r1.r = dot(float3(0.439701, 0.382978, 0.177335), r0.rgb);
    r1.g = dot(float3(0.0897922963, 0.813423, 0.0967615992), r0.rgb);
    r1.b = dot(float3(0.017544, 0.111544, 0.870704), r0.rgb);

    float3 preCG = mul(renodx::color::AP0_TO_AP1_MAT, r1.rgb);

    // ACEScc (log) space
    // ACES_to_ACEScc(r1.rgb)
    r0.rgb = max(0, r1.rgb);
    r0.rgb = min(r0.rgb, 65504);
    r1.rgb = cmp(r0.rgb < float3(0.0000305175708, 0.0000305175708, 0.0000305175708));
    r2.rgb = r0.rgb * float3(0.5, 0.5, 0.5) + float3(0.0000152587800, 0.0000152587800, 0.0000152587800);
    r2.rgb = log2(r2.rgb);
    r2.rgb = r2.rgb + float3(9.72, 9.72, 9.72);
    r2.rgb = r2.rgb * float3(0.0570776239, 0.0570776239, 0.0570776239);
    r0.rgb = log2(r0.rgb);
    r0.rgb = r0.rgb + float3(9.72, 9.72, 9.72);
    r0.rgb = r0.rgb * float3(0.0570776239, 0.0570776239, 0.0570776239);
    r0.rgb = r1.rgb ? r2.rgb : r0.rgb;

    // (start) LogGrade
    // Contrast(r0.rgb, ACEScc_MIDGRAY, cb0[3].b)
    r0.rgb = r0.rgb + float3(-0.413588405, -0.413588405, -0.413588405);  // ACEScc_MIDGRAY = 0.4135884
    r0.rgb = r0.rgb * cb0[3].bbb + float3(0.413588405, 0.413588405, 0.413588405);

    // ACEScc_to_ACES(r0.rgb)
    r1.rgb = r0.rgb * float3(17.52, 17.52, 17.52) + float3(-9.72, -9.72, -9.72);
    r1.rgb = exp2(r1.rgb);
    r2.rgb = r1.rgb + float3(-0.0000152587891, -0.0000152587891, -0.0000152587891);
    r2.rgb = r2.rgb + r2.rgb;
    r3.rgba = cmp(r0.rrgg < float4(-0.301369876, 1.46799636, -0.301369876, 1.46799636));
    r0.rg = r3.ga ? r1.rg : float2(65504, 65504);
    r3.rg = r3.rb ? r2.rg : r0.rg;
    r0.rg = cmp(r0.bb < float2(-0.301369876, 1.46799636));
    r0.g = r0.g ? r1.b : 65504;
    r3.b = r0.r ? r2.b : r0.g;

    r0.rgb = mul(renodx::color::AP0_TO_AP1_MAT, r3.rgb);
    // (start) LinearGrade
    // WhiteBalance(r0.rgb, cb0[1].rgb)
    r1.r = dot(float3(0.390405, 0.549941, 0.00892631989), r0.rgb);
    r1.g = dot(float3(0.0708416030, 0.963172, 0.00135775004), r0.rgb);
    r1.b = dot(float3(0.0231081992, 0.128021, 0.936245), r0.rgb);
    r0.rgb = r1.rgb * cb0[1].rgb;
    r1.r = dot(float3(2.858470, -1.628790, -0.024891), r0.rgb);
    r1.g = dot(float3(-0.210182, 1.158200, 0.000324280991), r0.rgb);
    r1.b = dot(float3(-0.041812, -0.118169, 1.068670), r0.rgb);
    // ColorFilter
    r0.rgb = r1.rgb * cb0[2].rgb;
    // ChannelMixer(r0.rgb, cb0[4].rgb, cb0[5].rgb, cb0[6].rgb)
    r1.r = dot(r0.rgb, cb0[4].rgb);
    r1.g = dot(r0.rgb, cb0[5].rgb);
    r1.b = dot(r0.rgb, cb0[6].rgb);
    // LiftGammaGainHDR(r1.rgb, cb0[7].rgb, cb0[8].rgb, cb0[9].rgb)
    r0.rgb = r1.rgb * cb0[9].rgb + cb0[7].rgb;
    r1.rgb = saturate(r1.rgb * renodx::math::FLT_MAX + 0.5) * 2.0 - 1.0;
    r0.rgb = pow(abs(r0.rgb), cb0[8].rgb);
    r0.rgb = r0.rgb * r1.rgb;
    // Do NOT feed negative values to RgbToHsv or they'll wrap around
    r0.rgb = max(0, r0.rgb);
    // RgbToHsv
    r0.a = cmp(r0.g >= r0.b);
    r0.a = r0.a ? 1.00000 : 0;
    r1.rg = r0.bg;
    r1.ba = float2(-1, 0.666666687);
    r2.rg = r0.gb + -r1.rg;
    r2.ba = float2(1, -1);
    r1.rgba = r0.aaaa * r2.rgba + r1.rgba;
    r0.a = cmp(r0.r >= r1.r);
    r0.a = r0.a ? 1.00000 : 0;
    r2.rgb = r1.rga;
    r2.a = r0.r;
    r1.rga = r2.agr;
    r1.rgba = -r2.rgba + r1.rgba;
    r1.rgba = r0.aaaa * r1.rgba + r2.rgba;
    r0.a = min(r1.g, r1.a);
    r0.a = -r0.a + r1.r;
    r1.g = -r1.g + r1.a;
    r1.a = r0.a * 6 + 0.0001;
    r1.g = r1.g / r1.a;
    r1.g = r1.g + r1.b;
    r2.r = abs(r1.g);
    r1.g = r1.r + 0.0001;
    r2.b = r0.a / r1.g;
    // Hue Vs Sat
    r2.ga = float2(0.25, 0.25);
    r0.a = t0.SampleLevel(s0_s, r2.rg, 0).g;
    r0.a = saturate(r0.a);
    r0.a = r0.a + r0.a;
    // Sat Vs Sat
    r1.g = t0.SampleLevel(s0_s, r2.ba, 0).b;
    r1.g = saturate(r1.g);
    r0.a = dot(r1.gg, r0.aa);
    // Lum Vs Sat
    r3.r = dot(r0.rgb, float3(0.212672904, 0.715152204, 0.072175));
    r3.ga = float2(0.25, 0.25);
    r0.r = t0.SampleLevel(s0_s, r3.rg, 0).a;
    r0.r = saturate(r0.r);
    r0.r = r0.a * r0.r;
    // Hue Vs Hue
    r3.b = r2.r + cb0[3].r;
    r0.g = t0.SampleLevel(s0_s, r3.ba, 0).r;
    r0.g = saturate(r0.g);
    r0.g = r0.g + -0.5f;
    r0.g = r0.g + r3.b;
    r0.b = cmp(r0.g < 0);
    r0.a = cmp(1 < r0.g);
    r1.gb = r0.gg + float2(1, -1);
    r0.g = r0.a ? r1.b : r0.g;
    r0.g = r0.b ? r1.g : r0.g;
    // HsvToRgb(r0.gba)
    r0.gba = r0.ggg + float3(1, 0.666666687, 0.333333343);
    r0.gba = frac(r0.gba);
    r0.gba = r0.gba * float3(6, 6, 6) + float3(-3, -3, -3);
    r0.gba = saturate(abs(r0.gba) + float3(-1, -1, -1));
    r0.gba = r0.gba + float3(-1, -1, -1);
    r0.gba = r2.bbb * r0.gba + float3(1, 1, 1);

    // Saturation(r0.gba, cb0[3].g * r0.r)
    r1.gba = r0.gba * r1.rrr;
    r0.r = dot(cb0[3].gg, r0.rr);
    r1.g = dot(r1.gba, float3(0.212672904, 0.715152204, 0.072175));
    r0.gba = r1.rrr * r0.gba + -r1.ggg;
    r0.rgb = r0.rrr * r0.gba + r1.ggg;
    // (end) LinearGrade
    r0.rgb = lerp(preCG, r0.rgb, injectedData.colorGradeLUTStrength);

    if (injectedData.toneMapType == 0.f) {  // We just display map for now
      r3.rgb = mul(renodx::color::AP1_TO_AP0_MAT, r0.rgb);

      r3.rgb = renodx::tonemap::aces::RRT(r3.rgb);

      float a = 278.5085;
      float b = 10.7772;
      float c = 293.6045;
      float d = 88.7122;
      float e = 80.6889;
      r3.rgb = (r3.rgb * (a * r3.rgb + b)) / (r3.rgb * (c * r3.rgb + d) + e);
      r3.rgb = renodx::tonemap::aces::DarkToDim(r3.rgb);

      half3 AP1_RGB2Y = half3(0.272229, 0.674082, 0.0536895);
      r3.rgb = lerp(dot(r3.rgb, AP1_RGB2Y).rrr, r3.rgb, 0.93);
      r3.rgb = mul(renodx::color::AP1_TO_XYZ_MAT, r3.rgb);
      r3.rgb = mul(renodx::color::D60_TO_D65_MAT, r3.rgb);
      r3.rgb = mul(renodx::color::XYZ_TO_BT709_MAT, r3.rgb);
      r0.rgb = max(0, r3.rgb);
    } else {  // if(not vanilla){only do color grading, skip tonemapping}
      r3.rgb = mul(renodx::color::AP1_TO_XYZ_MAT, r0.rgb);
      r0.rgb = mul(renodx::color::XYZ_TO_BT709_MAT, r3.rgb);
      r0.rgb = applyUserTonemap(r0.rgb);
    }
    r0.a = 1;
    u0[vThreadID.xyz] = r0.rgba;
  }
  return;
}
