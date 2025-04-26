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

  if (float(vThreadID.x) < cb0[0].x && float(vThreadID.y) < cb0[0].x && float(vThreadID.z) < cb0[0].x) {
    r0.xyz = float3(vThreadID) * cb0[0].yyy;
    // (start) ColorGrade
    // (start) LogGrade
    // Contrast(r0.rgb, ACEScc_MIDGRAY, cb0[3].b)
    float3 preContrast = r0.rgb;
    r0.xyz = r0.xyz + float3(-0.4135884,-0.4135884,-0.4135884);
    r0.xyz = r0.xyz * cb0[3].zzz + float3(0.4135884,0.4135884,0.4135884);
    r0.rgb = lerp(preContrast, r0.rgb, RENODX_COLOR_GRADE_STRENGTH);
    // custom arri logc c1000 decoding
    /*r0.xyz = r0.xyz + float3(-0.386036,-0.386036,-0.386036);
    r0.xyz = r0.xyz / float3(0.244161,0.244161,0.244161);
    r0.xyz = pow(10.f, r0.xyz);
    r0.xyz = float3(-0.047996,-0.047996,-0.047996) + r0.xyz;
    r0.xyz = r0.xyz / float3(5.555556,5.555556,5.555556);*/
    r0.rgb = renodx::color::arri::logc::c1000::Decode(r0.rgb);
    float3 preCG = r0.rgb;
    // (start) LinearGrade
    // WhiteBalance(r0.rgb, cb0[1].rgb)
    r1.x = dot(float3(0.390405,0.549941,0.00892632), r0.xyz);
    r1.y = dot(float3(0.0708416,0.963172,0.00135775), r0.xyz);
    r1.z = dot(float3(0.0231082,0.128021,0.936245), r0.xyz);
    r0.xyz = cb0[1].xyz * r1.xyz;
    r1.x = dot(float3(2.858470,-1.628790,-0.024891), r0.xyz);
    r1.y = dot(float3(-0.210182,1.158200,0.000324281), r0.xyz);
    r1.z = dot(float3(-0.041812,-0.118169,1.068670), r0.xyz);
    // ColorFilter
    r0.xyz = cb0[2].xyz * r1.xyz;
    // ChannelMixer(r0.rgb, cb0[4].rgb, cb0[5].rgb, cb0[6].rgb)
    r1.x = dot(r0.xyz, cb0[4].xyz);
    r1.y = dot(r0.xyz, cb0[5].xyz);
    r1.z = dot(r0.xyz, cb0[6].xyz);
    // LiftGammaGainHDR(r1.rgb, cb0[7].rgb, cb0[8].rgb, cb0[9].rgb)
    r0.xyz = r1.xyz * cb0[9].xyz + cb0[7].xyz;
    r1.rgb = saturate(r0.rgb * renodx::math::FLT_MAX + 0.5) * 2.0 - 1.0;
    r0.rgb = pow(abs(r0.rgb), cb0[8].xyz);
    r0.xyz = r1.xyz * r0.xyz;
    // Do NOT feed negative values to RgbToHsv or they'll wrap around
    r0.xyz = max(float3(0,0,0), r0.xyz);
    // RgbToHsv
    r0.w = step(r0.z, r0.y);
    r1.xy = r0.zy;
    r1.zw = float2(-1.0, 2.0 / 3.0);
    r2.xy = -r1.xy + r0.yz;
    r2.zw = float2(1,-1);
    r1.xyzw = r0.wwww * r2.xyzw + r1.xyzw;
    r0.w = step(r1.x, r0.x);
    r2.xyz = r1.xyw;
    r2.w = r0.x;
    r1.xyw = r2.wyx;
    r1.xyzw = r1.xyzw + -r2.xyzw;
    r1.xyzw = r0.wwww * r1.xyzw + r2.xyzw;
    r0.w = min(r1.w, r1.y);
    r0.w = r1.x + -r0.w;
    r1.y = r1.w + -r1.y;
    r1.w = r0.w * 6.0 + 0.0001;
    r1.y = r1.y / r1.w;
    r1.y = r1.z + r1.y;
    r2.x = abs(r1.y);
    r1.y = 0.0001 + r1.x;
    r2.z = r0.w / r1.y;
    // Hue Vs Sat
    r2.yw = float2(0.25,0.25);
    r0.w = t0.SampleLevel(s0_s, r2.xy, 0).y;
    r0.w = saturate(r0.w);
    r0.w = r0.w + r0.w;
    // Sat Vs Sat
    r1.y = t0.SampleLevel(s0_s, r2.zw, 0).z;
    r1.y = saturate(r1.y);
    r0.w = dot(r1.yy, r0.ww);
    // Lum Vs Sat
    r3.x = dot(r0.xyz, float3(0.2126729,0.7151522,0.0721750));
    r3.yw = float2(0.25,0.25);
    r0.x = t0.SampleLevel(s0_s, r3.xy, 0).w;
    r0.x = saturate(r0.x);
    r0.x = r0.x * r0.w;
    // Hue Vs Hue
    r3.z = cb0[3].x + r2.x;
    r0.y = t0.SampleLevel(s0_s, r3.zw, 0).x;
    r0.y = saturate(r0.y);
    r0.y = r0.y + r3.z;
    r0.yzw = float3(-0.5,0.5,-1.5) + r0.yyy;
    float value = r0.y;
    r0.y = (value > 1.0) ? r0.w : r0.y;
    r0.y = (value < 0.0) ? r0.z : r0.y;
    // HsvToRgb(r0.gba)
    r0.yzw = float3(1.0, 2.0 / 3.0, 1.0 / 3.0) + r0.yyy;
    r0.yzw = frac(r0.yzw);
    r0.yzw = r0.yzw * float3(6,6,6) + float3(-3,-3,-3);
    r0.yzw = saturate(float3(-1,-1,-1) + abs(r0.yzw));
    r0.yzw = float3(-1,-1,-1) + r0.yzw;
    r0.yzw = r2.zzz * r0.yzw + float3(1,1,1);
    // Saturation(r0.gba, cb0[3].g * r0.r)
    r1.yzw = r1.xxx * r0.yzw;
    r0.x = dot(cb0[3].yy, r0.xx);
    r1.y = dot(r1.yzw, float3(0.2126729,0.7151522,0.0721750));
    r0.yzw = r1.xxx * r0.yzw + -r1.yyy;
    r0.xyz = r0.xxx * r0.yzw + r1.yyy;
    r0.rgb = max(0, r0.rgb);
    r0.rgb = lerp(preCG, r0.rgb, RENODX_COLOR_GRADE_STRENGTH);
    r0.rgb = ApplyToneMapNeutral(r0.rgb);

    r0.a = 1;
    u0[vThreadID.xyz] = r0.rgba;
  }
  return;
}
