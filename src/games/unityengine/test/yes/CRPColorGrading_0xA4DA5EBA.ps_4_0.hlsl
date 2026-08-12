#include "../../tonemap.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2DArray<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[7];
}
cbuffer cb0 : register(b0){
  float4 cb0[3];
}

// Approximately Up

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t1.SampleLevel(s0_s, v1.xy, 0).xyzw;
  o0.w = r0.w;
  /*r1.y = dot(float3(0.439700991,0.382977992,0.177334994), r0.xyz);
  r1.z = dot(float3(0.0897922963,0.813422978,0.0967615992), r0.xyz);
  r1.x = min(r1.y, r1.z);
  r1.w = dot(float3(0.0175439995,0.111543998,0.870703995), r0.xyz);
  r0.x = min(r1.x, r1.w);
  r0.y = max(r1.y, r1.z);
  r0.y = max(r0.y, r1.w);
  r0.xyz = max(float3(9.99999975e-005,9.99999975e-005,0.00999999978), r0.xyy);
  r0.x = r0.y + -r0.x;
  r0.x = r0.x / r0.z;
  r0.y = -0.400000006 + r0.x;
  r0.z = 2.5 * r0.y;
  r0.y = saturate(r0.y * 1.#INF + 0.5);
  r0.y = r0.y * 2 + -1;
  r0.z = 1 + -abs(r0.z);
  r0.z = max(0, r0.z);
  r0.z = -r0.z * r0.z + 1;
  r0.y = r0.y * r0.z + 1;
  r2.xyz = r1.wzy + -r1.zyw;
  r0.zw = r2.xy * r1.wz;
  r0.z = r0.z + r0.w;
  r0.z = r1.y * r2.z + r0.z;
  r0.z = sqrt(r0.z);
  r0.w = r1.w + r1.z;
  r0.w = r0.w + r1.y;
  r0.z = r0.z * 1.75 + r0.w;
  r0.yw = float2(0.0250000004,0.333333343) * r0.yz;
  r0.w = 0.0799999982 / r0.w;
  r0.w = -0.5 + r0.w;
  r0.w = r0.y * r0.w;
  r1.x = cmp(r0.z >= 0.479999989);
  r0.z = cmp(0.159999996 >= r0.z);
  r0.w = r1.x ? 0 : r0.w;
  r0.y = r0.z ? r0.y : r0.w;
  r0.y = 1 + r0.y;
  r2.yzw = r1.yzw * r0.yyy;
  r0.z = -r1.y * r0.y + 0.0299999993;
  r0.w = r1.z * r0.y + -r2.w;
  r0.w = 1.73205078 * r0.w;
  r1.x = r2.y * 2 + -r2.z;
  r0.y = -r1.w * r0.y + r1.x;
  r1.x = max(abs(r0.w), abs(r0.y));
  r1.x = 1 / r1.x;
  r1.y = min(abs(r0.w), abs(r0.y));
  r1.x = r1.y * r1.x;
  r1.y = r1.x * r1.x;
  r1.z = r1.y * 0.0208350997 + -0.0851330012;
  r1.z = r1.y * r1.z + 0.180141002;
  r1.z = r1.y * r1.z + -0.330299497;
  r1.y = r1.y * r1.z + 0.999866009;
  r1.z = r1.x * r1.y;
  r1.z = r1.z * -2 + 1.57079637;
  r1.w = cmp(abs(r0.y) < abs(r0.w));
  r1.z = r1.w ? r1.z : 0;
  r1.x = r1.x * r1.y + r1.z;
  r1.y = cmp(r0.y < -r0.y);
  r1.y = r1.y ? -3.141593 : 0;
  r1.x = r1.x + r1.y;
  r1.y = min(r0.w, r0.y);
  r0.y = max(r0.w, r0.y);
  r0.y = cmp(r0.y >= -r0.y);
  r0.w = cmp(r1.y < -r1.y);
  r0.y = r0.y ? r0.w : 0;
  r0.y = r0.y ? -r1.x : r1.x;
  r0.y = 57.2957802 * r0.y;
  r1.xy = cmp(r2.zw == r2.yz);
  r0.w = r1.y ? r1.x : 0;
  r0.y = r0.w ? 0 : r0.y;
  r0.w = cmp(r0.y < 0);
  r1.x = 360 + r0.y;
  r0.y = r0.w ? r1.x : r0.y;
  r0.w = cmp(180 < r0.y);
  r1.xy = float2(360,-360) + r0.yy;
  r0.w = r0.w ? r1.y : r0.y;
  r0.y = cmp(r0.y < -180);
  r0.y = r0.y ? r1.x : r0.w;
  r0.y = 0.0148148146 * r0.y;
  r0.y = 1 + -abs(r0.y);
  r0.y = max(0, r0.y);
  r0.w = r0.y * -2 + 3;
  r0.y = r0.y * r0.y;
  r0.y = r0.w * r0.y;
  r0.y = r0.y * r0.y;
  r0.x = r0.y * r0.x;
  r0.x = r0.x * r0.z;
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
  r1.z = dot(float3(-0.00557464967,0.0040607336,1.01033914), r0.xyz);
  r1.x = dot(float3(0.662454188,0.134004205,0.156187683), r0.xyz);
  r1.y = dot(float3(0.272228718,0.674081743,0.0536895171), r0.xyz);
  r0.x = dot(r1.xyz, float3(1,1,1));
  r0.x = max(9.99999975e-005, r0.x);
  r0.xy = r1.xy / r0.xx;
  r0.w = max(0, r1.y);
  r0.w = min(65504, r0.w);
  r0.w = log2(r0.w);
  r0.w = 0.981100023 * r0.w;
  r1.y = exp2(r0.w);
  r0.w = 1 + -r0.x;
  r0.z = r0.w + -r0.y;
  r0.y = max(9.99999975e-005, r0.y);
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
  r1.z = dot(float3(0.0556300804,-0.203976959,1.05697155), r0.xyz);*/
  r1.xyz = applyUserTonemapACES(r0.xyz);
  r0.xyz = float3(255,255,255) * r1.xyz;
  r0.xyz = floor(r0.xyz);
  r1.xyz = r1.xyz * float3(255,255,255) + -r0.xyz;
  r2.xy = cb1[6].xy * v1.xy;
  r2.xy = float2(0.03125,0.03125) * r2.xy;
  r0.w = asint(cb0[2].x) & 63;
  r2.z = (uint)r0.w;
  r2.xyzw = t0.SampleLevel(s1_s, r2.xyz, 0).xyzw;
  r1.xyz = r2.xyz < r1.xyz ? float3(1,1,1) : 0;
  r0.xyz = r1.xyz + r0.xyz;
  r0.xyz = float3(0.00392156886, 0.00392156886, 0.00392156886) * r0.xyz;
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  return;
}