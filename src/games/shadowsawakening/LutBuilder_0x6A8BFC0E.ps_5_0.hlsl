#include "./common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0) {
  float4 cb0[18];
}
// https://github.com/sebastianstarke/AI4Animation/blob/master/AI4Animation/SIGGRAPH_2018/Unity/Assets/Palette/PostProcessing/PostProcessing/Resources/Shaders/LutGen.shader

#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    float2 w1: TEXCOORD1,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.yz = -cb0[17].yz + v1.xy;
  r1.x = cb0[17].x * r0.y;
  r0.x = frac(r1.x);
  r1.x = r0.x / cb0[17].x;
  r0.w = -r1.x + r0.y;
  r0.xyz = r0.xzw * cb0[17].www;
  r0.rgb = lutShaper(r0.rgb, true);
  // unity to aces
  r1.x = dot(float3(0.439700991, 0.382977992, 0.177334994), r0.xyz);
  r1.y = dot(float3(0.0897922963, 0.813422978, 0.0967615992), r0.xyz);
  r1.z = dot(float3(0.0175439995, 0.111543998, 0.870703995), r0.xyz);
  // aces to acescc
  r0.xyz = max(float3(0, 0, 0), r1.xyz);
  r0.xyz = min(float3(65504, 65504, 65504), r0.xyz);
  r1.xyz = r0.xyz * float3(0.5, 0.5, 0.5) + float3(1.525878e-05, 1.525878e-05, 1.525878e-05);
  r1.xyz = log2(r1.xyz);
  r1.xyz = float3(9.72000027, 9.72000027, 9.72000027) + r1.xyz;
  r1.xyz = float3(0.0570776239, 0.0570776239, 0.0570776239) * r1.xyz;
  r2.xyz = log2(r0.xyz);
  r0.xyz = cmp(r0.xyz < float3(3.05175708e-05, 3.05175708e-05, 3.05175708e-05));
  r2.xyz = float3(9.72000027, 9.72000027, 9.72000027) + r2.xyz;
  r2.xyz = float3(0.0570776239, 0.0570776239, 0.0570776239) * r2.xyz;
  r0.xyz = r0.xyz ? r1.xyz : r2.xyz;
  // Offset, Power, Slope
  r0.xyz = r0.xyz * cb0[10].xyz + cb0[8].xyz;
  r1.xyz = log2(r0.xyz);
  r1.xyz = cb0[9].xyz * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r2.xyz = cmp(float3(0, 0, 0) < r0.xyz);
  r0.xyz = r2.xyz ? r1.xyz : r0.xyz;
  // HSV
  r0.w = cmp(r0.y >= r0.z);
  r0.w = r0.w ? 1.000000 : 0;
  r1.xy = r0.zy;
  r2.xy = -r1.xy + r0.yz;
  r1.zw = float2(-1, 0.666666687);
  r2.zw = float2(1, -1);
  r1.xyzw = r0.wwww * r2.xywz + r1.xywz;
  r0.w = cmp(r0.x >= r1.x);
  r0.w = r0.w ? 1.000000 : 0;
  r2.z = r1.w;
  r1.w = r0.x;
  r2.xyw = r1.wyx;
  r2.xyzw = r2.xyzw + -r1.xyzw;
  r1.xyzw = r0.wwww * r2.xyzw + r1.xyzw;
  r0.w = min(r1.w, r1.y);
  r0.w = r1.x + -r0.w;
  r2.x = r0.w * 6 + 9.99999975e-05;
  r1.y = r1.w + -r1.y;
  r1.y = r1.y / r2.x;
  r1.y = r1.z + r1.y;
  r1.x = 9.99999975e-05 + r1.x;
  r2.z = r0.w / r1.x;
  r2.x = abs(r1.y);
  r2.yw = float2(0.25, 0.25);
  r1.xyzw = t0.Sample(s0_s, r2.xy).yxzw;
  r2.xyzw = t0.Sample(s0_s, r2.zw).zxyw;
  r2.x = saturate(r2.x);
  r0.w = r2.x + r2.x;
  r1.x = saturate(r1.x);
  r1.x = r1.x + r1.x;
  r0.w = r1.x * r0.w;
  r1.x = dot(r0.xyz, float3(0.212599993, 0.715200007, 0.0722000003));
  r0.xyz = -r1.xxx + r0.xyz;
  r1.yw = float2(0.25, 0.25);
  r2.xyzw = t0.Sample(s0_s, r1.xy).wxyz;
  r2.x = saturate(r2.x);
  r1.y = r2.x + r2.x;
  r0.w = r1.y * r0.w;
  r0.w = cb0[11].x * r0.w;
  r0.xyz = r0.www * r0.xyz + r1.xxx;
  // contrast
  r0.xyz = float3(-0.413588405, -0.413588405, -0.413588405) + r0.xyz;
  r0.xyz = r0.xyz * cb0[11].yyy + float3(0.413588405, 0.413588405, 0.413588405);
  // acescc to aces
  r2.xyzw = cmp(r0.xxyy < float4(-0.301369876, 1.46799636, -0.301369876, 1.46799636));
  r0.xyw = r0.xyz * float3(17.5200005, 17.5200005, 17.5200005) + float3(-9.72000027, -9.72000027, -9.72000027);
  r1.xy = cmp(r0.zz < float2(-0.301369876, 1.46799636));
  r0.xyz = exp2(r0.xyw);
  r2.yw = r2.yw ? r0.xy : float2(65504, 65504);
  r0.xyw = float3(-1.52587891e-05, -1.52587891e-05, -1.52587891e-05) + r0.xyz;
  r0.z = r1.y ? r0.z : 65504;
  r0.xyw = r0.xyw + r0.xyw;
  r2.xy = r2.xz ? r0.xy : r2.yw;
  r2.z = r1.x ? r0.w : r0.z;
  // aces to ap1
  r0.x = dot(float3(1.45143926, -0.236510754, -0.214928567), r2.xyz);
  r0.y = dot(float3(-0.0765537769, 1.17622972, -0.0996759236), r2.xyz);
  r0.z = dot(float3(0.00831614807, -0.00603244966, 0.997716308), r2.xyz);
  // white balance
  r2.x = dot(float3(0.390404999, 0.549941003, 0.00892631989), r0.xyz);
  r2.y = dot(float3(0.070841603, 0.963172019, 0.00135775004), r0.xyz);
  r2.z = dot(float3(0.0231081992, 0.128021002, 0.936245024), r0.xyz);
  r0.xyz = cb0[4].xyz * r2.xyz;
  r2.x = dot(float3(2.85846996, -1.62879002, -0.0248910002), r0.xyz);
  r2.y = dot(float3(-0.210181996, 1.15820003, 0.000324280991), r0.xyz);
  r2.z = dot(float3(-0.0418119989, -0.118169002, 1.06867003), r0.xyz);
  r0.xyz = float3(1, 1, 1) + -cb0[5].xyz;
  r0.xyz = cb0[7].xyz * r0.xyz;
  r3.xyz = cb0[7].xyz * cb0[5].xyz;
  r0.xyz = r2.xyz * r0.xyz + r3.xyz;
  r2.xyz = log2(r0.xyz);
  r2.xyz = cb0[6].xyz * r2.xyz;
  r2.xyz = exp2(r2.xyz);
  // HSV
  r3.xyz = cmp(float3(0, 0, 0) < r0.xyz);
  r0.xyz = r3.xyz ? r2.xyz : r0.xyz;
  r0.xyw = max(float3(0, 0, 0), r0.yzx);
  r1.x = cmp(r0.x >= r0.y);
  r1.x = r1.x ? 1.000000 : 0;
  r2.xy = r0.yx;
  r3.xy = -r2.xy + r0.xy;
  r2.zw = float2(-1, 0.666666687);
  r3.zw = float2(1, -1);
  r2.xyzw = r1.xxxx * r3.xyzw + r2.xyzw;
  r1.x = cmp(r0.w >= r2.x);
  r1.x = r1.x ? 1.000000 : 0;
  r0.xyz = r2.xyw;
  r2.xyw = r0.wyx;
  r2.xyzw = r2.xyzw + -r0.xyzw;
  r0.xyzw = r1.xxxx * r2.xyzw + r0.xyzw;
  r1.x = min(r0.w, r0.y);
  r1.x = -r1.x + r0.x;
  r1.y = r1.x * 6 + 9.99999975e-05;
  r0.y = r0.w + -r0.y;
  r0.y = r0.y / r1.y;
  r0.y = r0.z + r0.y;
  r1.z = cb0[10].w + abs(r0.y);
  r2.xyzw = t0.Sample(s0_s, r1.zw).xyzw;
  r2.x = saturate(r2.x);
  r0.y = -0.5 + r2.x;
  r0.y = r1.z + r0.y;
  r0.z = cmp(1 < r0.y);
  r1.yz = float2(1, -1) + r0.yy;
  r0.z = r0.z ? r1.z : r0.y;
  r0.y = cmp(r0.y < 0);
  r0.y = r0.y ? r1.y : r0.z;
  // HsvToRgb
  r0.yzw = float3(1, 0.666666687, 0.333333343) + r0.yyy;
  r0.yzw = frac(r0.yzw);
  r0.yzw = r0.yzw * float3(6, 6, 6) + float3(-3, -3, -3);
  r0.yzw = saturate(float3(-1, -1, -1) + abs(r0.yzw));
  r0.yzw = float3(-1, -1, -1) + r0.yzw;
  r1.y = 9.99999975e-05 + r0.x;
  r1.x = r1.x / r1.y;
  r0.yzw = r1.xxx * r0.yzw + float3(1, 1, 1);
  r0.xyz = r0.xxx * r0.yzw;
  // Channel mixing
  r1.x = dot(r0.xyz, cb0[12].xyz);
  r1.y = dot(r0.xyz, cb0[13].xyz);
  r1.z = dot(r0.xyz, cb0[14].xyz);
  r0.rgb = r1.rgb;
  // FastTonemap
  r0.a = max(r0.r, r0.g);
  r0.a = max(r0.a, r0.b);
  r0.a = 1 + r0.a;
  r0.a = rcp(r0.a);
  r0.rgb *= r0.aaa;
  // curves stuff
  r0.xyz = float3(0.00390625, 0.00390625, 0.00390625) + r0.xyz;
  r0.w = 0.75;
  r1.xyzw = t0.Sample(s0_s, r0.xw).wxyz;
  r1.x = saturate(r1.x);
  r2.xyzw = t0.Sample(s0_s, r0.yw).xyzw;
  r0.xyzw = t0.Sample(s0_s, r0.zw).xyzw;
  r1.z = saturate(r0.w);
  r1.y = saturate(r2.w);
  r0.xyz = float3(0.00390625, 0.00390625, 0.00390625) + r1.xyz;
  r0.w = 0.75;
  r1.xyzw = t0.Sample(s0_s, r0.xw).xyzw;
  o0.x = saturate(r1.x);
  r1.xyzw = t0.Sample(s0_s, r0.yw).xyzw;
  r0.xyzw = t0.Sample(s0_s, r0.zw).xyzw;
  o0.z = saturate(r0.z);
  o0.y = saturate(r1.y);
  // FastTonemapInvert
  r0.a = max(o0.r, o0.g);
  r0.a = max(r0.a, o0.b);
  r0.a = 1 + -r0.a;
  r0.a = rcp(r0.a);
  r1.rgb = o0.rgb * r0.aaa;
  // AP1_to_sRGB
  o0.x = dot(float3(1.70504999, -0.621789992, -0.0832599998), r1.xyz);
  o0.y = dot(float3(-0.130260006, 1.1408, -0.0105499998), r1.xyz);
  o0.z = dot(float3(-0.0240000002, -0.128969997, 1.15296996), r1.xyz);
  o0.w = 1;
  return;
}
