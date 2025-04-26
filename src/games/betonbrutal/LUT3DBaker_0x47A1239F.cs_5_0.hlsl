#include "./common.hlsl"

// https://github.com/Unity-Technologies/Graphics/blob/e42df452b62857a60944aed34f02efa1bda50018/com.unity.postprocessing/PostProcessing/Shaders/Builtins/Lut3DBaker.compute
// KGenLUT3D_AcesTonemap

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
RWTexture3D<float4> u0 : register(u0);
cbuffer cb0 : register(b0){
  float4 cb0[10];
}

[numthreads(4, 4, 4)] void main(uint3 vThreadID : SV_DispatchThreadID) {

  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;
  
if (float(vThreadID.x) < cb0[0].x && float(vThreadID.y) < cb0[0].x && float(vThreadID.z) < cb0[0].x) {
    r0.xyz = float3(vThreadID) * cb0[0].yyy;
    r0.rgb = lutShaper(r0.rgb, true);
    float3 preCG = r0.rgb;
    // (start) ColorGrade
    // unity_to_ACES(r0.rgb)
    r1.x = dot(float3(0.4397010, 0.3829780, 0.1773350), r0.xyz);
    r1.y = dot(float3(0.0897923, 0.8134230, 0.0967616), r0.xyz);
    r1.z = dot(float3(0.0175440, 0.1115440, 0.8707040), r0.xyz);
  // ACEScc (log) space
    // ACES_to_ACEScc(r1.rgb)
    r0.xyz = max(float3(0,0,0), r1.xyz);
    r0.xyz = min(float3(65504,65504,65504), r0.xyz);
    r1.xyz = r0.xyz;
    r2.xyz = r0.xyz * float3(0.5,0.5,0.5) + float3(0.0000152587800,0.0000152587800,0.0000152587800);
    r2.xyz = log2(r2.xyz);
    r2.xyz = r2.xyz + float3(9.72,9.72,9.72);
    r2.xyz = r2.xyz / float3(17.52,17.52,17.52);
    r0.xyz = log2(r0.xyz);
    r0.xyz = r0.xyz + float3(9.72,9.72,9.72);
    r0.xyz = r0.xyz / float3(17.52,17.52,17.52);
    r0.xyz = (r1.xyz < 0.00003051757) ? r2.xyz : r0.xyz;
    // (start) LogGrade
    // Contrast(r0.rgb, ACEScc_MIDGRAY, cb0[3].b)
    r0.xyz = r0.xyz + float3(-0.4135884,-0.4135884,-0.4135884);
    r0.xyz = r0.xyz * cb0[3].zzz + float3(0.4135884,0.4135884,0.4135884);
    // ACEScc_to_ACES(r0.rgb)
    r3.rgb = acescc::Decode(r0.rgb);
    //  ACES_to_ACEScg
    r0.x = dot(float3(1.4514393161,-0.2365107469,-0.2149285693), r3.xyz);
    r0.y = dot(float3(-0.0765537734,1.1762296998,-0.0996759264), r3.xyz);
    r0.z = dot(float3(0.0083161484,-0.0060324498,0.9977163014), r3.xyz);
    // (start) LinearGrade
      // WhiteBalance(r0.rgb, cb0[1].rgb)
    r1.x = dot(float3(0.390405,0.549941,0.00892632), r0.xyz);
    r1.y = dot(float3(0.0708416,0.963172,0.00135775), r0.xyz);
    r1.z = dot(float3(0.0231082,0.128021,0.936245), r0.xyz);
    r0.xyz = cb0[1].xyz * r1.xyz;
    r1.x = dot(float3(2.85847,-1.62879,-0.0248910), r0.xyz);
    r1.y = dot(float3(-0.210182,1.15820,0.000324281), r0.xyz);
    r1.z = dot(float3(-0.0418120,-0.118169,1.06867), r0.xyz);
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
    r1.zw = float2(-1, 2.0 / 3.0);
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
    r3.x = dot(r0.xyz, float3(0.2126729, 0.7151522, 0.0721750));
    r3.yw = float2(0.25,0.25);
    r0.x = t0.SampleLevel(s0_s, r3.xy, 0).w;
    r0.x = saturate(r0.x);
    r0.x = r0.x * r0.w;
    // Hue Vs Hue
    r3.z = cb0[3].x + r2.x;
    r0.y = t0.SampleLevel(s0_s, r3.zw, 0).x;
    r0.y = saturate(r0.y);
    r0.y = -0.5 + r0.y;
    r0.y = r3.z + r0.y;
    r1.yz = float2(1,-1) + r0.yy;
    float value = r0.y;
    r0.y = (value > 1.0) ? r1.z : r0.y;
    r0.y = (value < 0.0) ? r1.y : r0.y;
    // HsvToRgb(r0.gba)
    r0.yzw = float3(1, 2.0 / 3.0, 1.0 / 3.0) + r0.yyy;
    r0.yzw = frac(r0.yzw);
    r0.yzw = r0.yzw * float3(6,6,6) + float3(-3,-3,-3);
    r0.yzw = saturate(float3(-1,-1,-1) + abs(r0.yzw));
    r0.yzw = float3(-1,-1,-1) + r0.yzw;
    r0.yzw = r2.zzz * r0.yzw + float3(1,1,1);
    // Saturation(r0.gba, cb0[3].g * r0.r)
    r1.yzw = r1.xxx * r0.yzw;
    r0.x = dot(cb0[3].yy, r0.xx);
    r1.y = dot(r1.yzw, float3(0.2126729, 0.7151522, 0.0721750));
    r0.yzw = r1.xxx * r0.yzw + -r1.yyy;
    r0.xyz = r0.xxx * r0.yzw + r1.yyy;
    // (end) LinearGrade
    r1.y = dot(float3(0.6954522414,0.1406786965,0.1638690622), r0.xyz);
    r1.z = dot(float3(0.0447945634,0.8596711185,0.0955343182), r0.xyz);
    r1.w = dot(float3(-0.0055258826,0.0040252103,1.0015006723), r0.xyz);
    r0.rgb = mul(ACES_to_SRGB_MAT, r1.gba);
    r0.rgb = lerp(preCG, r0.rgb, injectedData.colorGradeLUTStrength);
    r0.rgb = applyUserTonemap(r0.rgb);   
    r0.a = 1;
    u0[vThreadID.xyz] = r0.rgba;
  }
return;
}