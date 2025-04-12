#include "./tonemap.hlsli"

// https://github.com/Unity-Technologies/Graphics/blob/e42df452b62857a60944aed34f02efa1bda50018/com.unity.postprocessing/PostProcessing/Shaders/Builtins/Lut3DBaker.compute
// KGenLUT3D_NeutralTonemap

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

  r0.rgb = (uint3)vThreadID.rgb;
  r1.rgb = cmp(r0.rgb < cb0[0].rrr);
  r0.a = r1.g ? r1.r : 0;
  r0.a = r1.b ? r0.a : 0;
  if (r0.a != 0) {
    // (start) ColorGrade
    // (start) LogGrade
    // Contrast(r0.rgb, ACEScc_MIDGRAY, cb0[3].b)
    r0.rgb = r0.rgb * cb0[0].ggg;
    float3 preContrast = r0.rgb;
    r0.rgb = r0.rgb + float3(-0.413588405, -0.413588405, -0.413588405);
    r0.rgb = r0.rgb * cb0[3].bbb + float3(0.413588405, 0.413588405, 0.413588405);
    r0.rgb = lerp(preContrast, r0.rgb, RENODX_COLOR_GRADE_STRENGTH);
    r0.rgb = renodx::color::arri::logc::c1000::Decode(r0.rgb);
    float3 preCG = r0.rgb;
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
    r0.g = r3.b + r0.g;
    r0.gba = r0.ggg + float3(-0.5, 0.5, -1.5);
    r1.g = cmp(r0.g < 0);
    r1.b = cmp(1 < r0.g);
    r0.g = r1.b ? r0.a : r0.g;
    r0.g = r1.g ? r0.b : r0.g;
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
    r0.rgb = max(0, r0.rgb);
    r0.rgb = lerp(preCG, r0.rgb, RENODX_COLOR_GRADE_STRENGTH);
    r0.rgb = ApplyToneMapNeutral(r0.rgb);

    r0.a = 1;
    u0[vThreadID.xyz] = r0.rgba;
  }
  return;
}
