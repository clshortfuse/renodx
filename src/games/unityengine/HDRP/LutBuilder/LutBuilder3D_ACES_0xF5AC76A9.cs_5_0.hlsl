#include "../../tonemap.hlsl"

Texture2D<float4> t7 : register(t7);
Texture2D<float4> t6 : register(t6);
Texture2D<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
RWTexture3D<float4> u0 : register(u0);
cbuffer cb0 : register(b0) {
  float4 cb0[18];
}

#define cmp -

[numthreads(4, 4, 4)]
void main(uint3 vThreadID: SV_DispatchThreadID) {
  float4 r0, r1, r2, r3, r4, r5, r6, r7;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = (uint3)vThreadID.xyz;
  float3 preCG;
  if (cb0[17].x > 0) {
    r1.xyz = r0.xyz * cb0[0].yyy;
    r1.rgb = lutShaper(r1.rgb, true);
    preCG = r1.rgb;
    // white balance
    r2.x = dot(float3(0.390405,0.549941,0.00892632), r1.xyz);
    r2.y = dot(float3(0.0708416,0.963172,0.00135775), r1.xyz);
    r2.z = dot(float3(0.0231082,0.128021,0.936245), r1.xyz);
    r1.xyz = cb0[2].xyz * r2.xyz;
    r2.x = dot(float3(2.85847,-1.62879,-0.0248910), r1.xyz);
    r2.y = dot(float3(-0.210182,1.15820,0.000324281), r1.xyz);
    r2.z = dot(float3(-0.0418120,-0.118169,1.06867), r1.xyz);
    // unity_to_ACES
    r1.x = dot(float3(0.4397010, 0.3829780, 0.1773350), r2.xyz);
    r1.y = dot(float3(0.0897923, 0.8134230, 0.0967616), r2.xyz);
    r1.z = dot(float3(0.0175440, 0.1115440, 0.8707040), r2.xyz);
    // to acescc
    r1.xyz = acesccEncode(r1.xyz);
    // contrast
    r1.xyz = float3(-0.4135884, -0.4135884, -0.4135884) + r1.xyz;
    r1.xyz = r1.xyz * cb0[7].zzz + float3(0.4135884, 0.4135884, 0.4135884);
    // ACEScc_to_ACES
    r4.rgb = acescc::Decode(r1.rgb);
    // ap0 to ap1
    r1.rgb = mul(ACES_to_ACEScg_MAT, r4.rgb);
    // color filter
    r1.xyz = cb0[3].xyz * r1.xyz;
    r1.xyz = max(float3(0, 0, 0), r1.xyz);
    // split toning
    r1.xyz = pow(r1.xyz, 1.f / 2.2f);
    r2.xyz = min(float3(1, 1, 1), r1.xyz);
    r0.w = dot(r2.xyz, float3(0.272228986, 0.674081981, 0.0536894985));
    r0.w = saturate(cb0[15].w + r0.w);
    r1.w = 1 + -r0.w;
    r2.xyz = float3(-0.5, -0.5, -0.5) + cb0[15].xyz;
    r2.xyz = r1.www * r2.xyz + float3(0.5, 0.5, 0.5);
    r3.xyz = float3(-0.5, -0.5, -0.5) + cb0[16].xyz;
    r3.xyz = r0.www * r3.xyz + float3(0.5, 0.5, 0.5);
    r4.xyz = r1.xyz + r1.xyz;
    r5.xyz = r1.xyz * r1.xyz;
    r6.xyz = -r2.xyz * float3(2, 2, 2) + float3(1, 1, 1);
    r5.xyz = r6.xyz * r5.xyz;
    r5.xyz = r4.xyz * r2.xyz + r5.xyz;
    r1.xyz = sqrt(r1.xyz);
    r6.xyz = r2.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
    r7.xyz = float3(1, 1, 1) + -r2.xyz;
    r4.xyz = r7.xyz * r4.xyz;
    r1.xyz = r1.xyz * r6.xyz + r4.xyz;
    r4.xyz = step(0.5, r2.xyz);
    r2.xyz = 1.0 - r4.xyz;
    r2.xyz = r2.xyz * r5.xyz;
    r1.xyz = r1.xyz * r4.xyz + r2.xyz;
    r2.xyz = r1.xyz + r1.xyz;
    r4.xyz = r1.xyz * r1.xyz;
    r5.xyz = -r3.xyz * float3(2, 2, 2) + float3(1, 1, 1);
    r4.xyz = r5.xyz * r4.xyz;
    r4.xyz = r2.xyz * r3.xyz + r4.xyz;
    r1.xyz = sqrt(r1.xyz);
    r5.xyz = r3.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
    r6.xyz = float3(1, 1, 1) + -r3.xyz;
    r2.xyz = r6.xyz * r2.xyz;
    r1.xyz = r1.xyz * r5.xyz + r2.xyz;
    r3.xyz = step(0.5, r3.xyz);
    r2.xyz = 1.0 - r3.xyz;
    r2.xyz = r2.xyz * r4.xyz;
    r1.xyz = r1.xyz * r3.xyz + r2.xyz;
    r1.xyz = pow(abs(r1.xyz), 2.2f);
    // channel mixing
    r2.x = dot(r1.xyz, cb0[4].xyz);
    r2.y = dot(r1.xyz, cb0[5].xyz);
    r2.z = dot(r1.xyz, cb0[6].xyz);
    // Shadows, midtones, highlights
    r0.w = dot(r2.xyz, float3(0.272228986, 0.674081981, 0.0536894985));
    r1.xy = cb0[14].yw + -cb0[14].xz;
    r1.zw = -cb0[14].xz + r0.ww;
    r1.xy = float2(1, 1) / r1.xy;
    r1.xy = saturate(r1.zw * r1.xy);
    r1.zw = r1.xy * float2(-2, -2) + float2(3, 3);
    r1.xy = r1.xy * r1.xy;
    r0.w = r1.w * r1.y;
    r1.x = -r1.z * r1.x + 1;
    r1.z = 1 + -r1.x;
    r1.y = -r1.w * r1.y + r1.z;
    r3.xyz = cb0[11].xyz * r2.xyz;
    r4.xyz = cb0[12].xyz * r2.xyz;
    r1.yzw = r4.xyz * r1.yyy;
    r1.xyz = r3.xyz * r1.xxx + r1.yzw;
    r2.xyz = cb0[13].xyz * r2.xyz;
    r1.xyz = r2.xyz * r0.www + r1.xyz;
    // Lift, gamma, gain
    float3 preLGG = r1.xyz;
    r1.xyz = r1.xyz * cb0[10].xyz + cb0[8].xyz;
    r3.xyz = sign(r1.xyz) * pow(abs(r1.xyz), cb0[9].xyz);
    r3.xyz = liftGammaGainScaling(r3.xyz, preLGG, cb0[8].xyz, cb0[9].xyz, cb0[10].xyz);
    // HSV
    r0.w = step(r3.z, r3.y);
    r4.xy = r3.zy;
    r4.zw = float2(-1.0, 2.0 / 3.0);
    r1.xy = r3.yz + -r4.xy;
    r1.zw = float2(1, -1);
    r1.xyzw = r0.wwww * r1.xyzw + r4.xyzw;
    r0.w = step(r1.x, r3.x);
    r2.xyz = r1.xyw;
    r2.w = r3.x;
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
    r2.yw = float2(0, 0);
    r0.w = t5.SampleLevel(s0_s, r2.xy, 0).x;
    r0.w = saturate(r0.w);
    r0.w = r0.w + r0.w;
    r1.y = t6.SampleLevel(s0_s, r2.zw, 0).x;
    r1.y = saturate(r1.y);
    r1.y = r1.y + r1.y;
    r0.w = r1.y * r0.w;
    r3.x = dot(r3.xyz, float3(0.212672904, 0.715152204, 0.0721750036));
    r3.yw = float2(0, 0);
    r1.y = t7.SampleLevel(s0_s, r3.xy, 0).x;
    r1.y = saturate(r1.y);
    r1.y = r1.y + r1.y;
    r0.w = r1.y * r0.w;
    r3.z = cb0[7].x + r2.x;
    r1.y = t4.SampleLevel(s0_s, r3.zw, 0).x;
    r1.y = saturate(r1.y);
    r1.y = r1.y + r3.z;
    r1.yzw = float3(-0.5, 0.5, -1.5) + r1.yyy;
    float value = r1.y;
    r1.y = (value > 1) ? r1.w : r1.y;
    r1.y = (value < 0) ? r1.z : r1.y;
    // HsvToRgb
    r1.yzw = float3(1.0, 2.0 / 3.0, 1.0 / 3.0) + r1.yyy;
    r1.yzw = frac(r1.yzw);
    r1.yzw = r1.yzw * float3(6, 6, 6) + float3(-3, -3, -3);
    r1.yzw = saturate(float3(-1, -1, -1) + abs(r1.yzw));
    r1.yzw = float3(-1, -1, -1) + r1.yzw;
    r1.yzw = r2.zzz * r1.yzw + float3(1, 1, 1);
    r2.xyz = r1.xxx * r1.yzw;
    // Global sat
    r2.x = dot(r2.xyz, float3(0.272228986, 0.674081981, 0.0536894985));
    r0.w = cb0[7].y * r0.w;
    r1.xyz = r1.xxx * r1.yzw + -r2.xxx;
    r1.xyz = r0.www * r1.xyz + r2.xxx;
    // curves
    r0.w = max(r1.x, r1.y);
    r0.w = max(r0.w, r1.z);
    r0.w = 1 + r0.w;
    r0.w = rcp(r0.w);
    r1.xyz = r1.xyz * r0.www + float3(0.00390625, 0.00390625, 0.00390625);
    r1.w = 0;
    r2.x = t0.SampleLevel(s0_s, r1.xw, 0).x;
    r2.x = saturate(r2.x);
    r2.y = t0.SampleLevel(s0_s, r1.yw, 0).x;
    r2.y = saturate(r2.y);
    r2.z = t0.SampleLevel(s0_s, r1.zw, 0).x;
    r2.z = saturate(r2.z);
    r1.xyz = float3(0.00390625, 0.00390625, 0.00390625) + r2.xyz;
    r1.w = 0;
    r2.x = t1.SampleLevel(s0_s, r1.xw, 0).x;
    r2.x = saturate(r2.x);
    r2.y = t2.SampleLevel(s0_s, r1.yw, 0).x;
    r2.y = saturate(r2.y);
    r2.z = t3.SampleLevel(s0_s, r1.zw, 0).x;
    r2.z = saturate(r2.z);
    r0.w = max(r2.x, r2.y);
    r0.w = max(r0.w, r2.z);
    r0.w = 1 + -r0.w;
    r0.w = rcp(r0.w);
    r1.xyz = r2.xyz * r0.www;
    r1.xyz = max(float3(0, 0, 0), r1.xyz);
  } else {
    r0.xyz = r0.xyz * cb0[0].yyy;
    r1.rgb = lutShaper(r0.rgb, true);
  }
  r0.xyz = max(float3(0, 0, 0), r1.xyz);
  // Ap1 to ap0
  r1.y = dot(float3(0.695452213, 0.140678704, 0.163869068), r0.xyz);
  r1.z = dot(float3(0.0447945632, 0.859671116, 0.0955343172), r0.xyz);
  r1.w = dot(float3(-0.00552588282, 0.00402521016, 1.00150073), r0.xyz);
  r0.x = dot(float3(2.52169, -1.13413, -0.38756), r1.yzw);
  r0.y = dot(float3(-0.27648, 1.37272, -0.09624), r1.yzw);
  r0.z = dot(float3(-0.01538, -0.15298, 1.16835), r1.yzw);
  r0.xyz = lerp(preCG, r0.xyz, injectedData.colorGradeInternalLUTStrength);
  r0.xyz = applyUserTonemapACES(r0.xyz, 2);
  r0.w = 1;
  u0[vThreadID] = r0;
  return;
}
