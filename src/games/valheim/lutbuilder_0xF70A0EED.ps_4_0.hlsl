#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.4.1 on Mon Sep  8 09:20:54 2025
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[18];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.yz = -cb0[17].yz + v1.xy;
  r1.x = cb0[17].x * r0.y;
  r0.x = frac(r1.x);
  r1.x = r0.x / cb0[17].x;
  r0.w = -r1.x + r0.y;
  // r0.xyz = r0.xzw * cb0[17].www + float3(-0.386036009,-0.386036009,-0.386036009);
  r0.xyz = r0.xzw * cb0[17].www;

  r0.xyz = LutDecode(r0.xyz); //switch to PQ

  // arri decode start
  // r0.xyz = r0.xyz + float3(-0.386036009, -0.386036009, -0.386036009);
  // r0.xyz = float3(13.6054821, 13.6054821, 13.6054821) * r0.xyz;
  // r0.xyz = exp2(r0.xyz);
  // r0.xyz = float3(-0.0479959995, -0.0479959995, -0.0479959995) + r0.xyz;
  // r0.xyz = float3(0.179999992, 0.179999992, 0.179999992) * r0.xyz;
  // arri decode end

  //bt709 to ap0
  r1.x = dot(float3(0.439700991, 0.382977992, 0.177334994), r0.xyz);
  r1.y = dot(float3(0.0897922963, 0.813422978, 0.0967615992), r0.xyz);
  r1.z = dot(float3(0.0175439995, 0.111543998, 0.870703995), r0.xyz);

  r0.xyz = max(float3(0,0,0), r1.xyz);
  r0.xyz = min(float3(65504,65504,65504), r0.xyz);
  r1.xyz = r0.xyz * float3(0.5,0.5,0.5) + float3(1.525878e-05,1.525878e-05,1.525878e-05);
  r1.xyz = log2(r1.xyz);
  r1.xyz = float3(9.72000027,9.72000027,9.72000027) + r1.xyz;
  r1.xyz = float3(0.0570776239,0.0570776239,0.0570776239) * r1.xyz;
  r2.xyz = log2(r0.xyz);
  r0.xyz = cmp(r0.xyz < float3(3.05175708e-05,3.05175708e-05,3.05175708e-05));
  r2.xyz = float3(9.72000027,9.72000027,9.72000027) + r2.xyz;
  r2.xyz = float3(0.0570776239,0.0570776239,0.0570776239) * r2.xyz;
  r0.xyz = r0.xyz ? r1.xyz : r2.xyz;
  r0.xyz = r0.xyz * cb0[10].xyz + cb0[8].xyz;
  r1.xyz = log2(r0.xyz);
  r1.xyz = cb0[9].xyz * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r2.xyz = cmp(float3(0,0,0) < r0.xyz);
  r0.xyz = r2.xyz ? r1.xyz : r0.xyz;
  r0.w = cmp(r0.y >= r0.z);
  r0.w = r0.w ? 1.000000 : 0;
  r1.xy = r0.zy;
  r2.xy = -r1.xy + r0.yz;
  r1.zw = float2(-1,0.666666687);
  r2.zw = float2(1,-1);
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
  r2.yw = float2(0.25,0.25);
  r1.xyzw = t0.Sample(s0_s, r2.xy).yxzw;
  r2.xyzw = t0.Sample(s0_s, r2.zw).zxyw;
  r2.x = saturate(r2.x);
  r0.w = r2.x + r2.x;
  r1.x = saturate(r1.x);
  r1.x = r1.x + r1.x;
  r0.w = r1.x * r0.w;
  r1.x = dot(r0.xyz, float3(0.212599993,0.715200007,0.0722000003));
  r0.xyz = -r1.xxx + r0.xyz;
  r1.yw = float2(0.25,0.25);
  r2.xyzw = t0.Sample(s0_s, r1.xy).wxyz;
  r2.x = saturate(r2.x);
  r1.y = r2.x + r2.x;
  r0.w = r1.y * r0.w;
  r0.w = cb0[11].x * r0.w;
  r0.xyz = r0.www * r0.xyz + r1.xxx;
  r0.xyz = float3(-0.413588405,-0.413588405,-0.413588405) + r0.xyz;
  r0.xyz = r0.xyz * cb0[11].yyy + float3(0.413588405,0.413588405,0.413588405);
  r2.xyzw = cmp(r0.xxyy < float4(-0.301369876,1.46799636,-0.301369876,1.46799636));
  r0.xyw = r0.xyz * float3(17.5200005,17.5200005,17.5200005) + float3(-9.72000027,-9.72000027,-9.72000027);
  r1.xy = cmp(r0.zz < float2(-0.301369876,1.46799636));
  r0.xyz = exp2(r0.xyw);
  r2.yw = r2.yw ? r0.xy : float2(65504,65504);
  r0.xyw = float3(-1.52587891e-05,-1.52587891e-05,-1.52587891e-05) + r0.xyz;
  r0.z = r1.y ? r0.z : 65504;
  r0.xyw = r0.xyw + r0.xyw;
  r2.xy = r2.xz ? r0.xy : r2.yw;
  r2.z = r1.x ? r0.w : r0.z;
  r0.x = dot(float3(1.45143926,-0.236510754,-0.214928567), r2.xyz);
  r0.y = dot(float3(-0.0765537769,1.17622972,-0.0996759236), r2.xyz);
  r0.z = dot(float3(0.00831614807,-0.00603244966,0.997716308), r2.xyz);
  r2.x = dot(float3(0.390404999,0.549941003,0.00892631989), r0.xyz);
  r2.y = dot(float3(0.070841603,0.963172019,0.00135775004), r0.xyz);
  r2.z = dot(float3(0.0231081992,0.128021002,0.936245024), r0.xyz);
  r0.xyz = cb0[4].xyz * r2.xyz;
  r2.x = dot(float3(2.85846996,-1.62879002,-0.0248910002), r0.xyz);
  r2.y = dot(float3(-0.210181996,1.15820003,0.000324280991), r0.xyz);
  r2.z = dot(float3(-0.0418119989,-0.118169002,1.06867003), r0.xyz);
  r0.xyz = float3(1,1,1) + -cb0[5].xyz;
  r0.xyz = cb0[7].xyz * r0.xyz;
  r3.xyz = cb0[7].xyz * cb0[5].xyz;
  r0.xyz = r2.xyz * r0.xyz + r3.xyz;
  r2.xyz = log2(r0.xyz);
  r2.xyz = cb0[6].xyz * r2.xyz;
  r2.xyz = exp2(r2.xyz);
  r3.xyz = cmp(float3(0,0,0) < r0.xyz);
  r0.xyz = r3.xyz ? r2.xyz : r0.xyz;
  r0.xyw = max(float3(0,0,0), r0.yzx);
  r1.x = cmp(r0.x >= r0.y);
  r1.x = r1.x ? 1.000000 : 0;
  r2.xy = r0.yx;
  r3.xy = -r2.xy + r0.xy;
  r2.zw = float2(-1,0.666666687);
  r3.zw = float2(1,-1);
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
  r1.yz = float2(1,-1) + r0.yy;
  r0.z = r0.z ? r1.z : r0.y;
  r0.y = cmp(r0.y < 0);
  r0.y = r0.y ? r1.y : r0.z;
  r0.yzw = float3(1,0.666666687,0.333333343) + r0.yyy;
  r0.yzw = frac(r0.yzw);
  r0.yzw = r0.yzw * float3(6,6,6) + float3(-3,-3,-3);
  r0.yzw = saturate(float3(-1,-1,-1) + abs(r0.yzw));
  r0.yzw = float3(-1,-1,-1) + r0.yzw;
  r1.y = 9.99999975e-05 + r0.x;
  r1.x = r1.x / r1.y;
  r0.yzw = r1.xxx * r0.yzw + float3(1,1,1);
  r0.xyz = r0.xxx * r0.yzw;
  r1.x = dot(r0.xyz, cb0[12].xyz);
  r1.y = dot(r0.xyz, cb0[13].xyz);
  r1.z = dot(r0.xyz, cb0[14].xyz);

  float3 untonemappedap1 = r1.xyz;
  float3 untonemapped = renodx::color::bt709::from::AP1(r1.xyz);

  r0.y = dot(float3(0.695452213,0.140678704,0.163869068), r1.xyz);
  r0.z = dot(float3(0.0447945632,0.859671116,0.0955343172), r1.xyz);
  r0.w = dot(float3(-0.00552588282,0.00402521016,1.00150073), r1.xyz);
  r1.xyz = r0.wzy + -r0.zyw;
  r1.xy = r1.xy * r0.wz;
  r0.x = r1.x + r1.y;
  r0.x = r0.y * r1.z + r0.x;
  r0.x = sqrt(r0.x);
  r1.x = r0.w + r0.z;
  r1.x = r1.x + r0.y;
  r0.x = r0.x * 1.75 + r1.x;
  r1.x = 0.333333343 * r0.x;
  r1.x = 0.0799999982 / r1.x;
  r1.y = min(r0.z, r0.w);
  r1.y = min(r1.y, r0.y);
  r1.z = max(r0.z, r0.w);
  r1.z = max(r1.z, r0.y);
  r1.yzw = max(float3(1.00000001e-10,1.00000001e-10,0.00999999978), r1.yzz);
  r1.y = r1.z + -r1.y;
  r1.y = r1.y / r1.w;
  r1.xz = float2(-0.5,-0.400000006) + r1.xy;
  r1.w = cmp(0 < r1.z);
  r2.x = cmp(r1.z < 0);
  r1.z = 2.5 * r1.z;
  r1.z = 1 + -abs(r1.z);
  r1.z = max(0, r1.z);
  r1.z = -r1.z * r1.z + 1;
  r1.w = (int)-r1.w + (int)r2.x;
  r1.w = (int)r1.w;
  r1.z = r1.w * r1.z + 1;
  r1.z = 0.0250000004 * r1.z;
  r1.x = r1.z * r1.x;
  r1.w = cmp(r0.x >= 0.479999989);
  r0.x = cmp(0.159999996 >= r0.x);
  r1.x = r1.w ? 0 : r1.x;
  r0.x = r0.x ? r1.z : r1.x;
  r0.x = 1 + r0.x;
  r2.yzw = r0.yzw * r0.xxx;
  r0.y = -r0.y * r0.x + 0.0299999993;
  r0.z = r0.z * r0.x + -r2.w;
  r0.z = 1.73205078 * r0.z;
  r1.x = r2.y * 2 + -r2.z;
  r0.x = -r0.w * r0.x + r1.x;
  r0.w = max(abs(r0.z), abs(r0.x));
  r0.w = 1 / r0.w;
  r1.x = min(abs(r0.z), abs(r0.x));
  r0.w = r1.x * r0.w;
  r1.x = r0.w * r0.w;
  r1.z = r1.x * 0.0208350997 + -0.0851330012;
  r1.z = r1.x * r1.z + 0.180141002;
  r1.z = r1.x * r1.z + -0.330299497;
  r1.x = r1.x * r1.z + 0.999866009;
  r1.z = r1.x * r0.w;
  r1.z = r1.z * -2 + 1.57079637;
  r1.w = cmp(abs(r0.x) < abs(r0.z));
  r1.z = r1.w ? r1.z : 0;
  r0.w = r0.w * r1.x + r1.z;
  r1.x = cmp(r0.x < -r0.x);
  r1.x = r1.x ? -3.141593 : 0;
  r0.w = r1.x + r0.w;
  r1.x = min(r0.z, r0.x);
  r0.x = max(r0.z, r0.x);
  r0.x = cmp(r0.x >= -r0.x);
  r0.z = cmp(r1.x < -r1.x);
  r0.x = r0.x ? r0.z : 0;
  r0.x = r0.x ? -r0.w : r0.w;
  r0.x = 57.2957802 * r0.x;
  r0.zw = cmp(r2.zw == r2.yz);
  r0.z = r0.w ? r0.z : 0;
  r0.x = r0.z ? 0 : r0.x;
  r0.z = cmp(r0.x < 0);
  r0.w = 360 + r0.x;
  r0.x = r0.z ? r0.w : r0.x;
  r0.z = cmp(180 < r0.x);
  r1.xz = float2(360,-360) + r0.xx;
  r0.z = r0.z ? r1.z : r0.x;
  r0.x = cmp(r0.x < -180);
  r0.x = r0.x ? r1.x : r0.z;
  r0.x = 0.0148148146 * r0.x;
  r0.x = 1 + -abs(r0.x);
  r0.x = max(0, r0.x);
  r0.z = r0.x * -2 + 3;
  r0.x = r0.x * r0.x;
  r0.x = r0.z * r0.x;
  r0.x = r0.x * r0.x;
  r0.x = r0.x * r1.y;
  r0.x = r0.x * r0.y;
  r2.x = r0.x * 0.180000007 + r2.y;
  r0.x = dot(float3(1.45143926,-0.236510754,-0.214928567), r2.xzw);
  r0.y = dot(float3(-0.0765537769,1.17622972,-0.0996759236), r2.xzw);
  r0.z = dot(float3(0.00831614807,-0.00603244966,0.997716308), r2.xzw);
  r0.xyz = max(float3(0,0,0), r0.xyz);
  r0.w = dot(r0.xyz, float3(0.272228986,0.674081981,0.0536894985));
  r0.xyz = r0.xyz + -r0.www;
  r0.xyz = r0.xyz * float3(0.959999979,0.959999979,0.959999979) + r0.www;
  r1.xyz = r0.xyz * float3(278.508514,278.508514,278.508514) + float3(10.7771997,10.7771997,10.7771997);
  r1.xyz = r1.xyz * r0.xyz;
  r2.xyz = r0.xyz * float3(293.604492,293.604492,293.604492) + float3(88.7121964,88.7121964,88.7121964);
  r0.xyz = r0.xyz * r2.xyz + float3(80.6889038,80.6889038,80.6889038);
  r0.xyz = r1.xyz / r0.xyz;
  r1.x = dot(float3(0.662454188,0.134004205,0.156187683), r0.xyz);
  r1.z = dot(float3(-0.00557464967,0.0040607336,1.01033914), r0.xyz);
  r1.y = dot(float3(0.272228718,0.674081743,0.0536895171), r0.xyz);
  r0.x = dot(r1.xyz, float3(1,1,1));
  r0.x = max(9.99999975e-05, r0.x);
  r0.xy = r1.xy / r0.xx;
  r0.w = max(0, r1.y);
  r0.w = min(65504, r0.w);
  r0.w = log2(r0.w);
  r0.w = 0.981100023 * r0.w;
  r1.y = exp2(r0.w);
  r0.w = 1 + -r0.x;
  r0.z = r0.w + -r0.y;
  r0.y = max(9.99999975e-05, r0.y);
  r0.y = r1.y / r0.y;
  r1.xz = r0.xz * r0.yy;
  r0.x = dot(float3(1.6410234,-0.324803293,-0.236424699), r1.xyz);
  r0.y = dot(float3(-0.663662851,1.61533165,0.0167563483), r1.xyz);
  r0.z = dot(float3(0.0117218941,-0.00828444213,0.988394856), r1.xyz);
  r0.w = dot(r0.xyz, float3(0.272228986,0.674081981,0.0536894985));
  r0.xyz = r0.xyz + -r0.www;
  r0.xyz = r0.xyz * float3(0.930000007,0.930000007,0.930000007) + r0.www;
  r1.x = dot(float3(0.662454188,0.134004205,0.156187683), r0.xyz);
  r1.y = dot(float3(0.272228718,0.674081743,0.0536895171), r0.xyz);
  r1.z = dot(float3(-0.00557464967,0.0040607336,1.01033914), r0.xyz);
  r0.x = dot(float3(0.987223983,-0.00611326983,0.0159533005), r1.xyz);
  r0.y = dot(float3(-0.00759836007,1.00186002,0.00533019984), r1.xyz);
  r0.z = dot(float3(0.00307257008,-0.00509594986,1.08168006), r1.xyz);
  r1.x = dot(float3(3.2409699,-1.5373832,-0.498610765), r0.xyz);
  r1.y = dot(float3(-0.969243646,1.8759675,0.0415550582), r0.xyz);
  r1.z = dot(float3(0.0556300804,-0.203976959,1.05697155), r0.xyz);

  float3 tonemapped_bt709 = r1.rgb;

  // r1.rgb = CustomPerChannelCorrection(untonemapped, tonemapped_bt709);
  // r1.rgb = UpgradeTonemap(untonemapped, tonemapped_bt709);

  r0.xyz = float3(0.00390625,0.00390625,0.00390625) + r1.xyz;
  r0.w = 0.75;
  r1.xyzw = t0.Sample(s0_s, r0.xw).wxyz;
  r1.x = saturate(r1.x);
  r2.xyzw = t0.Sample(s0_s, r0.yw).xyzw;
  r0.xyzw = t0.Sample(s0_s, r0.zw).xyzw;
  r1.z = saturate(r0.w);
  r1.y = saturate(r2.w);
  r0.xyz = float3(0.00390625,0.00390625,0.00390625) + r1.xyz;
  r0.w = 0.75;
  r1.xyzw = t0.Sample(s0_s, r0.xw).xyzw;
  o0.x = saturate(r1.x);
  r1.xyzw = t0.Sample(s0_s, r0.yw).xyzw;
  r0.xyzw = t0.Sample(s0_s, r0.zw).xyzw;
  o0.z = saturate(r0.z);
  o0.y = saturate(r1.y);
  o0.w = 1;
  return;
}