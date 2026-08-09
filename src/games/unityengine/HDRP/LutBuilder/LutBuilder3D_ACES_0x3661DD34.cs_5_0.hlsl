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
cbuffer cb0 : register(b0){
  float4 cb0[18];
}

#define cmp -

[numthreads(4, 4, 4)]
void main(uint3 vThreadID: SV_DispatchThreadID) {
  const float4 icb[] = { { -4.000000, -0.718548, -1.698970, 0.515439},
                              { -4.000000, 2.081031, -1.698970, 0.847044},
                              { -3.157377, 3.668124, -1.477900, 1.135800},
                              { -0.485250, 4.000000, -1.229100, 1.380200},
                              { 1.847732, 4.000000, -0.864800, 1.519700},
                              { 1.847732, 4.000000, -0.448000, 1.598500},
                              { 0, 0, 0.005180, 1.646700},
                              { 0, 0, 0.451108, 1.674609},
                              { 0, 0, 0.911374, 1.687873},
                              { 0, 0, 0.911374, 1.687873} };
  float4 r0,r1,r2,r3,r4,r5,r6,r7;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = (uint3)vThreadID.xyz;
  float3 ungraded;
  if (cb0[17].x > 0) {
    r1.xyz = r0.xyz * cb0[0].yyy;
    r1.xyz = lutShaper(r1.xyz, true);
    ungraded = r1.xyz;
    r2.x = dot(float3(0.390405,0.549941,0.00892632), r1.xyz);
    r2.y = dot(float3(0.0708416,0.963172,0.00135775), r1.xyz);
    r2.z = dot(float3(0.0231082,0.128021,0.936245), r1.xyz);
    r1.xyz = cb0[2].xyz * r2.xyz;
    r2.x = dot(float3(2.85847,-1.62879,-0.0248910), r1.xyz);
    r2.y = dot(float3(-0.210182,1.15820,0.000324281), r1.xyz);
    r2.z = dot(float3(-0.0418120,-0.118169,1.06867), r1.xyz);
    // uni to aces
    r1.x = dot(float3(0.4397010, 0.3829780, 0.1773350), r2.xyz);
    r1.y = dot(float3(0.0897923, 0.8134230, 0.0967616), r2.xyz);
    r1.z = dot(float3(0.0175440, 0.1115440, 0.8707040), r2.xyz);
    r1.xyz = acesccEncode(r1.xyz);
    // contrast
    r1.xyz = float3(-0.4135884, -0.4135884, -0.4135884) + r1.xyz;
    r1.xyz = r1.xyz * cb0[7].zzz + float3(0.4135884, 0.4135884, 0.4135884);
    r4.rgb = acescc::Decode(r1.rgb);
    // ap0 to ap1
    r1.rgb = mul(ACES_to_ACEScg_MAT, r4.rgb);
    r1.xyz = cb0[3].xyz * r1.xyz;
    r1.xyz = max(float3(0,0,0), r1.xyz);
    r1.xyz = pow(r1.xyz, 1.f / 2.2f);
    r2.xyz = min(float3(1,1,1), r1.xyz);
    r0.w = dot(r2.xyz, float3(0.272228986,0.674081981,0.0536894985));
    r0.w = saturate(cb0[15].w + r0.w);
    r1.w = 1 + -r0.w;
    r2.xyz = float3(-0.5,-0.5,-0.5) + cb0[15].xyz;
    r2.xyz = r1.www * r2.xyz + float3(0.5,0.5,0.5);
    r3.xyz = float3(-0.5,-0.5,-0.5) + cb0[16].xyz;
    r3.xyz = r0.www * r3.xyz + float3(0.5,0.5,0.5);
    r4.xyz = r1.xyz + r1.xyz;
    r5.xyz = r1.xyz * r1.xyz;
    r6.xyz = -r2.xyz * float3(2,2,2) + float3(1,1,1);
    r5.xyz = r6.xyz * r5.xyz;
    r5.xyz = r4.xyz * r2.xyz + r5.xyz;
    r1.xyz = sqrt(r1.xyz);
    r6.xyz = r2.xyz * float3(2,2,2) + float3(-1,-1,-1);
    r7.xyz = float3(1,1,1) + -r2.xyz;
    r4.xyz = r7.xyz * r4.xyz;
    r1.xyz = r1.xyz * r6.xyz + r4.xyz;
    r4.xyz = step(0.5, r2.xyz);
    r2.xyz = 1.0 - r4.xyz;
    r2.xyz = r2.xyz * r5.xyz;
    r1.xyz = r1.xyz * r4.xyz + r2.xyz;
    r2.xyz = r1.xyz + r1.xyz;
    r4.xyz = r1.xyz * r1.xyz;
    r5.xyz = -r3.xyz * float3(2,2,2) + float3(1,1,1);
    r4.xyz = r5.xyz * r4.xyz;
    r4.xyz = r2.xyz * r3.xyz + r4.xyz;
    r1.xyz = sqrt(r1.xyz);
    r5.xyz = r3.xyz * float3(2,2,2) + float3(-1,-1,-1);
    r6.xyz = float3(1,1,1) + -r3.xyz;
    r2.xyz = r6.xyz * r2.xyz;
    r1.xyz = r1.xyz * r5.xyz + r2.xyz;
    r3.xyz = step(0.5, r3.xyz);
    r2.xyz = 1.0 - r3.xyz;
    r2.xyz = r2.xyz * r4.xyz;
    r1.xyz = r1.xyz * r3.xyz + r2.xyz;
    r1.xyz = pow(abs(r1.xyz), 2.2f);
    r2.x = dot(r1.xyz, cb0[4].xyz);
    r2.y = dot(r1.xyz, cb0[5].xyz);
    r2.z = dot(r1.xyz, cb0[6].xyz);
    r0.w = dot(r2.xyz, float3(0.272228986,0.674081981,0.0536894985));
    r1.xy = cb0[14].yw + -cb0[14].xz;
    r1.zw = -cb0[14].xz + r0.ww;
    r1.xy = float2(1,1) / r1.xy;
    r1.xy = saturate(r1.zw * r1.xy);
    r1.zw = r1.xy * float2(-2,-2) + float2(3,3);
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
    float3 preLGG = r1.xyz;
    r1.xyz = r1.xyz * cb0[10].xyz + cb0[8].xyz;
    r3.xyz = sign(r1.xyz) * pow(abs(r1.xyz), cb0[9].xyz);
    r3.xyz = liftGammaGainScaling(r3.xyz, preLGG, cb0[8].xyz, cb0[9].xyz, cb0[10].xyz);
    r0.w = step(r3.z, r3.y);
    r4.xy = r3.zy;
    r4.zw = float2(-1.0, 2.0 / 3.0);
    r1.xy = r3.yz + -r4.xy;
    r1.zw = float2(1,-1);
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
    r2.yw = float2(0,0);
    r0.w = t5.SampleLevel(s0_s, r2.xy, 0).x;
    r0.w = saturate(r0.w);
    r0.w = r0.w + r0.w;
    r1.y = t6.SampleLevel(s0_s, r2.zw, 0).x;
    r1.y = saturate(r1.y);
    r1.y = r1.y + r1.y;
    r0.w = r1.y * r0.w;
    r3.x = dot(r3.xyz, float3(0.212672904,0.715152204,0.0721750036));
    r3.yw = float2(0,0);
    r1.y = t7.SampleLevel(s0_s, r3.xy, 0).x;
    r1.y = saturate(r1.y);
    r1.y = r1.y + r1.y;
    r0.w = r1.y * r0.w;
    r3.z = cb0[7].x + r2.x;
    r1.y = t4.SampleLevel(s0_s, r3.zw, 0).x;
    r1.y = saturate(r1.y);
    r1.y = r1.y + r3.z;
    r1.yzw = float3(-0.5,0.5,-1.5) + r1.yyy;
    float value = r1.y;
    r1.y = (value > 1) ? r1.w : r1.y;
    r1.y = (value < 0) ? r1.z : r1.y;
    r1.yzw = float3(1.0, 2.0 / 3.0, 1.0 / 3.0) + r1.yyy;
    r1.yzw = frac(r1.yzw);
    r1.yzw = r1.yzw * float3(6,6,6) + float3(-3,-3,-3);
    r1.yzw = saturate(float3(-1,-1,-1) + abs(r1.yzw));
    r1.yzw = float3(-1,-1,-1) + r1.yzw;
    r1.yzw = r2.zzz * r1.yzw + float3(1,1,1);
    r2.xyz = r1.xxx * r1.yzw;
    r2.x = dot(r2.xyz, float3(0.272228986,0.674081981,0.0536894985));
    r0.w = cb0[7].y * r0.w;
    r1.xyz = r1.xxx * r1.yzw + -r2.xxx;
    r1.xyz = r0.www * r1.xyz + r2.xxx;
    r0.w = max(r1.x, r1.y);
    r0.w = max(r0.w, r1.z);
    r0.w = 1 + r0.w;
    r0.w = rcp(r0.w);
    r1.xyz = r1.xyz * r0.www + float3(0.00390625,0.00390625,0.00390625);
    r1.w = 0;
    r2.x = t0.SampleLevel(s0_s, r1.xw, 0).x;
    r2.x = saturate(r2.x);
    r2.y = t0.SampleLevel(s0_s, r1.yw, 0).x;
    r2.y = saturate(r2.y);
    r2.z = t0.SampleLevel(s0_s, r1.zw, 0).x;
    r2.z = saturate(r2.z);
    r1.xyz = float3(0.00390625,0.00390625,0.00390625) + r2.xyz;
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
    r1.xyz = max(float3(0,0,0), r1.xyz);
  } else {
    r0.xyz = r0.xyz * cb0[0].yyy;
    r1.rgb = lutShaper(r0.rgb, true);
  }
  r0.xyz = max(float3(0,0,0), r1.xyz);
  r1.y = dot(float3(0.695452213,0.140678704,0.163869068), r0.xyz);
  r1.z = dot(float3(0.0447945632,0.859671116,0.0955343172), r0.xyz);
  r1.w = dot(float3(-0.00552588282,0.00402521016,1.00150073), r0.xyz);
  r0.x = dot(float3(2.52169, -1.13413, -0.38756), r1.yzw);
  r0.y = dot(float3(-0.27648, 1.37272, -0.09624), r1.yzw);
  r0.z = dot(float3(-0.01538, -0.15298, 1.16835), r1.yzw);
  r0.xyz = lerp(ungraded, r0.xyz, injectedData.colorGradeInternalLUTStrength);
  if(injectedData.toneMapType == 0.f){
    r1.y = dot(float3(0.4397010,0.3829780,0.1773350), r0.xyz);
    r1.z = dot(float3(0.0897923,0.8134230,0.0967616), r0.xyz);
    r1.w = dot(float3(0.0175440,0.1115440,0.8707040), r0.xyz);
  r0.x = min(r1.y, r1.z);
  r0.x = min(r0.x, r1.w);
  r0.y = max(r1.y, r1.z);
  r0.y = max(r0.y, r1.w);
  r0.xyz = max(float3(9.99999975e-05,9.99999975e-05,0.00999999978), r0.xyy);
  r0.x = r0.y + -r0.x;
  r0.x = r0.x / r0.z;
  r0.yzw = r1.wzy + -r1.zyw;
  r0.yz = r1.wz * r0.yz;
  r0.y = r0.y + r0.z;
  r0.y = r1.y * r0.w + r0.y;
  r0.y = max(0, r0.y);
  r0.y = sqrt(r0.y);
  r0.z = r1.w + r1.z;
  r0.z = r0.z + r1.y;
  r0.y = r0.y * 1.75 + r0.z;
  r0.w = -0.400000006 + r0.x;
  r1.x = 2.5 * r0.w;
  r1.x = 1 + -abs(r1.x);
  r1.x = max(0, r1.x);
  r0.w = cmp(r0.w >= 0);
  r0.w = r0.w ? 1 : -1;
  r1.x = -r1.x * r1.x + 1;
  r0.w = r0.w * r1.x + 1;
  r0.zw = float2(0.333333343,0.0250000004) * r0.yw;
  r1.x = cmp(0.159999996 >= r0.y);
  r0.y = cmp(r0.y >= 0.479999989);
  r0.z = 0.0799999982 / r0.z;
  r0.z = -0.5 + r0.z;
  r0.z = r0.w * r0.z;
  r0.y = r0.y ? 0 : r0.z;
  r0.y = r1.x ? r0.w : r0.y;
  r0.y = 1 + r0.y;
  r2.yzw = r1.yzw * r0.yyy;
  r0.zw = cmp(r2.zw == r2.yz);
  r0.z = r0.w ? r0.z : 0;
  r0.w = r1.z * r0.y + -r2.w;
  r0.w = 1.73205078 * r0.w;
  r1.x = r2.y * 2 + -r2.z;
  r1.x = -r1.w * r0.y + r1.x;
  r1.z = min(abs(r1.x), abs(r0.w));
  r1.w = max(abs(r1.x), abs(r0.w));
  r1.w = 1 / r1.w;
  r1.z = r1.z * r1.w;
  r1.w = r1.z * r1.z;
  r3.x = r1.w * 0.0208350997 + -0.0851330012;
  r3.x = r1.w * r3.x + 0.180141002;
  r3.x = r1.w * r3.x + -0.330299497;
  r1.w = r1.w * r3.x + 0.999866009;
  r3.x = r1.z * r1.w;
  r3.y = cmp(abs(r1.x) < abs(r0.w));
  r3.x = r3.x * -2 + 1.57079637;
  r3.x = r3.y ? r3.x : 0;
  r1.z = r1.z * r1.w + r3.x;
  r1.w = cmp(r1.x < -r1.x);
  r1.w = r1.w ? -3.141593 : 0;
  r1.z = r1.z + r1.w;
  r1.w = min(r1.x, r0.w);
  r0.w = max(r1.x, r0.w);
  r1.x = cmp(r1.w < -r1.w);
  r0.w = cmp(r0.w >= -r0.w);
  r0.w = r0.w ? r1.x : 0;
  r0.w = r0.w ? -r1.z : r1.z;
  r0.w = 57.2957802 * r0.w;
  r0.z = r0.z ? 0 : r0.w;
  r0.w = cmp(r0.z < 0);
  r1.x = 360 + r0.z;
  r0.z = r0.w ? r1.x : r0.z;
  r0.w = cmp(r0.z < -180);
  r1.x = cmp(180 < r0.z);
  r1.zw = float2(360,-360) + r0.zz;
  r0.z = r1.x ? r1.w : r0.z;
  r0.z = r0.w ? r1.z : r0.z;
  r0.z = 0.0148148146 * r0.z;
  r0.z = 1 + -abs(r0.z);
  r0.z = max(0, r0.z);
  r0.w = r0.z * -2 + 3;
  r0.z = r0.z * r0.z;
  r0.z = r0.w * r0.z;
  r0.z = r0.z * r0.z;
  r0.x = r0.z * r0.x;
  r0.y = -r1.y * r0.y + 0.0299999993;
  r0.x = r0.x * r0.y;
  r2.x = r0.x * 0.180000007 + r2.y;
  r0.xyz = max(float3(0,0,0), r2.xzw);
  r0.xyz = min(float3(65504,65504,65504), r0.xyz);
  r1.x = dot(float3(1.45143926,-0.236510754,-0.214928567), r0.xyz);
  r1.y = dot(float3(-0.0765537769,1.17622972,-0.0996759236), r0.xyz);
  r1.z = dot(float3(0.00831614807,-0.00603244966,0.997716308), r0.xyz);
  r0.xyz = max(float3(0,0,0), r1.xyz);
  r0.xyz = min(float3(65504,65504,65504), r0.xyz);
  r0.w = dot(r0.xyz, float3(0.272228986,0.674081981,0.0536894985));
  r0.xyz = r0.xyz + -r0.www;
  r0.xyz = r0.xyz * float3(0.959999979,0.959999979,0.959999979) + r0.www;
  r1.xyz = cmp(float3(0,0,0) >= r0.xyz);
  r0.xyz = log2(r0.xyz);
  r0.xyz = r1.xyz ? float3(-14,-14,-14) : r0.xyz;
  r1.xyz = cmp(float3(-17.4739323,-17.4739323,-17.4739323) >= r0.xyz);
  if (r1.x != 0) {
    r0.w = -4;
  } else {
    r1.x = cmp(r0.x < -2.47393107);
    if (r1.x != 0) {
      r1.x = r0.x * 0.30103001 + 5.26017761;
      r1.w = 0.664385557 * r1.x;
      r2.x = (int)r1.w;
      r1.w = trunc(r1.w);
      r3.y = r1.x * 0.664385557 + -r1.w;
      r1.xw = (int2)r2.xx + int2(1,2);
      r3.x = r3.y * r3.y;
      r2.x = icb[r2.x+0].x;
      r2.y = icb[r1.x+0].x;
      r2.z = icb[r1.w+0].x;
      r4.x = dot(float3(0.5,-1,0.5), r2.xyz);
      r4.y = dot(float2(-1,1), r2.xy);
      r4.z = dot(float2(0.5,0.5), r2.xy);
      r3.z = 1;
      r0.w = dot(r3.xyz, r4.xyz);
    } else {
      r1.x = cmp(r0.x < 15.5260687);
      if (r1.x != 0) {
        r0.x = r0.x * 0.30103001 + 0.744727492;
        r1.x = 0.553654671 * r0.x;
        r1.w = (int)r1.x;
        r1.x = trunc(r1.x);
        r2.y = r0.x * 0.553654671 + -r1.x;
        r3.xy = (int2)r1.ww + int2(1,2);
        r2.x = r2.y * r2.y;
        r4.x = icb[r1.w+0].y;
        r4.y = icb[r3.x+0].y;
        r4.z = icb[r3.y+0].y;
        r3.x = dot(float3(0.5,-1,0.5), r4.xyz);
        r3.y = dot(float2(-1,1), r4.xy);
        r3.z = dot(float2(0.5,0.5), r4.xy);
        r2.z = 1;
        r0.w = dot(r2.xyz, r3.xyz);
      } else {
        r0.w = 4;
      }
    }
  }
  r0.x = 3.32192802 * r0.w;
  r2.x = exp2(r0.x);
  if (r1.y != 0) {
    r0.x = -4;
  } else {
    r0.w = cmp(r0.y < -2.47393107);
    if (r0.w != 0) {
      r0.w = r0.y * 0.30103001 + 5.26017761;
      r1.x = 0.664385557 * r0.w;
      r1.y = (int)r1.x;
      r1.x = trunc(r1.x);
      r3.y = r0.w * 0.664385557 + -r1.x;
      r1.xw = (int2)r1.yy + int2(1,2);
      r3.x = r3.y * r3.y;
      r4.x = icb[r1.y+0].x;
      r4.y = icb[r1.x+0].x;
      r4.z = icb[r1.w+0].x;
      r5.x = dot(float3(0.5,-1,0.5), r4.xyz);
      r5.y = dot(float2(-1,1), r4.xy);
      r5.z = dot(float2(0.5,0.5), r4.xy);
      r3.z = 1;
      r0.x = dot(r3.xyz, r5.xyz);
    } else {
      r0.w = cmp(r0.y < 15.5260687);
      if (r0.w != 0) {
        r0.y = r0.y * 0.30103001 + 0.744727492;
        r0.w = 0.553654671 * r0.y;
        r1.x = (int)r0.w;
        r0.w = trunc(r0.w);
        r3.y = r0.y * 0.553654671 + -r0.w;
        r0.yw = (int2)r1.xx + int2(1,2);
        r3.x = r3.y * r3.y;
        r4.x = icb[r1.x+0].y;
        r4.y = icb[r0.y+0].y;
        r4.z = icb[r0.w+0].y;
        r5.x = dot(float3(0.5,-1,0.5), r4.xyz);
        r5.y = dot(float2(-1,1), r4.xy);
        r5.z = dot(float2(0.5,0.5), r4.xy);
        r3.z = 1;
        r0.x = dot(r3.xyz, r5.xyz);
      } else {
        r0.x = 4;
      }
    }
  }
  r0.x = 3.32192802 * r0.x;
  r2.y = exp2(r0.x);
  if (r1.z != 0) {
    r0.x = -4;
  } else {
    r0.y = cmp(r0.z < -2.47393107);
    if (r0.y != 0) {
      r0.y = r0.z * 0.30103001 + 5.26017761;
      r0.w = 0.664385557 * r0.y;
      r1.x = (int)r0.w;
      r0.w = trunc(r0.w);
      r3.y = r0.y * 0.664385557 + -r0.w;
      r0.yw = (int2)r1.xx + int2(1,2);
      r3.x = r3.y * r3.y;
      r1.x = icb[r1.x+0].x;
      r1.y = icb[r0.y+0].x;
      r1.z = icb[r0.w+0].x;
      r4.x = dot(float3(0.5,-1,0.5), r1.xyz);
      r4.y = dot(float2(-1,1), r1.xy);
      r4.z = dot(float2(0.5,0.5), r1.xy);
      r3.z = 1;
      r0.x = dot(r3.xyz, r4.xyz);
    } else {
      r0.y = cmp(r0.z < 15.5260687);
      if (r0.y != 0) {
        r0.y = r0.z * 0.30103001 + 0.744727492;
        r0.z = 0.553654671 * r0.y;
        r0.w = (int)r0.z;
        r0.z = trunc(r0.z);
        r1.y = r0.y * 0.553654671 + -r0.z;
        r0.yz = (int2)r0.ww + int2(1,2);
        r1.x = r1.y * r1.y;
        r3.x = icb[r0.w+0].y;
        r3.y = icb[r0.y+0].y;
        r3.z = icb[r0.z+0].y;
        r4.x = dot(float3(0.5,-1,0.5), r3.xyz);
        r4.y = dot(float2(-1,1), r3.xy);
        r4.z = dot(float2(0.5,0.5), r3.xy);
        r1.z = 1;
        r0.x = dot(r1.xyz, r4.xyz);
      } else {
        r0.x = 4;
      }
    }
  }
  r0.x = 3.32192802 * r0.x;
  r2.z = exp2(r0.x);
  r0.x = dot(float3(0.695452213,0.140678704,0.163869068), r2.xyz);
  r0.y = dot(float3(0.0447945632,0.859671116,0.0955343172), r2.xyz);
  r0.z = dot(float3(-0.00552588282,0.00402521016,1.00150073), r2.xyz);
  r0.w = dot(float3(1.45143926,-0.236510754,-0.214928567), r0.xyz);
  r1.x = dot(float3(-0.0765537769,1.17622972,-0.0996759236), r0.xyz);
  r0.x = dot(float3(0.00831614807,-0.00603244966,0.997716308), r0.xyz);
  r0.y = cmp(0 >= r0.w);
  r0.z = log2(r0.w);
  r0.y = r0.y ? -13.2877121 : r0.z;
  r0.z = cmp(-8.43976784 >= r0.y);
  if (r0.z != 0) {
    r0.z = -1.69896996;
  } else {
    r0.w = cmp(-8.43976784 < r0.y);
    r1.y = cmp(r0.y < 2.26303458);
    r0.w = r0.w ? r1.y : 0;
    if (r0.w != 0) {
      r0.w = r0.y * 0.30103001 + 2.54062319;
      r1.y = 2.17265511 * r0.w;
      r1.z = (int)r1.y;
      r1.y = trunc(r1.y);
      r2.y = r0.w * 2.17265511 + -r1.y;
      r1.yw = (int2)r1.zz + int2(1,2);
      r2.x = r2.y * r2.y;
      r3.x = icb[r1.z+0].z;
      r3.y = icb[r1.y+0].z;
      r3.z = icb[r1.w+0].z;
      r4.x = dot(float3(0.5,-1,0.5), r3.xyz);
      r4.y = dot(float2(-1,1), r3.xy);
      r4.z = dot(float2(0.5,0.5), r3.xy);
      r2.z = 1;
      r0.z = dot(r2.xyz, r4.xyz);
    } else {
      r0.w = cmp(r0.y >= 2.26303458);
      r1.y = cmp(r0.y < 9.97401142);
      r0.w = r0.w ? r1.y : 0;
      if (r0.w != 0) {
        r0.w = r0.y * 0.30103001 + -0.681241274;
        r1.y = 3.01563549 * r0.w;
        r1.z = (int)r1.y;
        r1.y = trunc(r1.y);
        r2.y = r0.w * 3.01563549 + -r1.y;
        r1.yw = (int2)r1.zz + int2(1,2);
        r2.x = r2.y * r2.y;
        r3.x = icb[r1.z+0].w;
        r3.y = icb[r1.y+0].w;
        r3.z = icb[r1.w+0].w;
        r4.x = dot(float3(0.5,-1,0.5), r3.xyz);
        r4.y = dot(float2(-1,1), r3.xy);
        r4.z = dot(float2(0.5,0.5), r3.xy);
        r2.z = 1;
        r0.z = dot(r2.xyz, r4.xyz);
      } else {
        r0.z = r0.y * 0.0120412 + 1.56114209;
      }
    }
  }
  r0.y = 3.32192802 * r0.z;
  r2.x = exp2(r0.y);
  r0.y = cmp(0 >= r1.x);
  r0.z = log2(r1.x);
  r0.y = r0.y ? -13.2877121 : r0.z;
  r0.z = cmp(-8.43976784 >= r0.y);
  if (r0.z != 0) {
    r0.z = -1.69896996;
  } else {
    r0.w = cmp(-8.43976784 < r0.y);
    r1.x = cmp(r0.y < 2.26303458);
    r0.w = r0.w ? r1.x : 0;
    if (r0.w != 0) {
      r0.w = r0.y * 0.30103001 + 2.54062319;
      r1.x = 2.17265511 * r0.w;
      r1.y = (int)r1.x;
      r1.x = trunc(r1.x);
      r3.y = r0.w * 2.17265511 + -r1.x;
      r1.xz = (int2)r1.yy + int2(1,2);
      r3.x = r3.y * r3.y;
      r4.x = icb[r1.y+0].z;
      r4.y = icb[r1.x+0].z;
      r4.z = icb[r1.z+0].z;
      r1.x = dot(float3(0.5,-1,0.5), r4.xyz);
      r1.y = dot(float2(-1,1), r4.xy);
      r1.z = dot(float2(0.5,0.5), r4.xy);
      r3.z = 1;
      r0.z = dot(r3.xyz, r1.xyz);
    } else {
      r0.w = cmp(r0.y >= 2.26303458);
      r1.x = cmp(r0.y < 9.97401142);
      r0.w = r0.w ? r1.x : 0;
      if (r0.w != 0) {
        r0.w = r0.y * 0.30103001 + -0.681241274;
        r1.x = 3.01563549 * r0.w;
        r1.y = (int)r1.x;
        r1.x = trunc(r1.x);
        r3.y = r0.w * 3.01563549 + -r1.x;
        r1.xz = (int2)r1.yy + int2(1,2);
        r3.x = r3.y * r3.y;
        r4.x = icb[r1.y+0].w;
        r4.y = icb[r1.x+0].w;
        r4.z = icb[r1.z+0].w;
        r1.x = dot(float3(0.5,-1,0.5), r4.xyz);
        r1.y = dot(float2(-1,1), r4.xy);
        r1.z = dot(float2(0.5,0.5), r4.xy);
        r3.z = 1;
        r0.z = dot(r3.xyz, r1.xyz);
      } else {
        r0.z = r0.y * 0.0120412 + 1.56114209;
      }
    }
  }
  r0.y = 3.32192802 * r0.z;
  r2.y = exp2(r0.y);
  r0.y = cmp(0 >= r0.x);
  r0.x = log2(r0.x);
  r0.x = r0.y ? -13.2877121 : r0.x;
  r0.y = cmp(-8.43976784 >= r0.x);
  if (r0.y != 0) {
    r0.y = -1.69896996;
  } else {
    r0.z = cmp(-8.43976784 < r0.x);
    r0.w = cmp(r0.x < 2.26303458);
    r0.z = r0.w ? r0.z : 0;
    if (r0.z != 0) {
      r0.z = r0.x * 0.30103001 + 2.54062319;
      r0.w = 2.17265511 * r0.z;
      r1.x = (int)r0.w;
      r0.w = trunc(r0.w);
      r3.y = r0.z * 2.17265511 + -r0.w;
      r0.zw = (int2)r1.xx + int2(1,2);
      r3.x = r3.y * r3.y;
      r1.x = icb[r1.x+0].z;
      r1.y = icb[r0.z+0].z;
      r1.z = icb[r0.w+0].z;
      r4.x = dot(float3(0.5,-1,0.5), r1.xyz);
      r4.y = dot(float2(-1,1), r1.xy);
      r4.z = dot(float2(0.5,0.5), r1.xy);
      r3.z = 1;
      r0.y = dot(r3.xyz, r4.xyz);
    } else {
      r0.z = cmp(r0.x >= 2.26303458);
      r0.w = cmp(r0.x < 9.97401142);
      r0.z = r0.w ? r0.z : 0;
      if (r0.z != 0) {
        r0.z = r0.x * 0.30103001 + -0.681241274;
        r0.w = 3.01563549 * r0.z;
        r1.x = (int)r0.w;
        r0.w = trunc(r0.w);
        r3.y = r0.z * 3.01563549 + -r0.w;
        r0.zw = (int2)r1.xx + int2(1,2);
        r3.x = r3.y * r3.y;
        r1.x = icb[r1.x+0].w;
        r1.y = icb[r0.z+0].w;
        r1.z = icb[r0.w+0].w;
        r4.x = dot(float3(0.5,-1,0.5), r1.xyz);
        r4.y = dot(float2(-1,1), r1.xy);
        r4.z = dot(float2(0.5,0.5), r1.xy);
        r3.z = 1;
        r0.y = dot(r3.xyz, r4.xyz);
      } else {
        r0.y = r0.x * 0.0120412 + 1.56114209;
      }
    }
  }
  r0.x = 3.32192802 * r0.y;
  r2.z = exp2(r0.x);
  r0.xyz = float3(-0.0199999996,-0.0199999996,-0.0199999996) + r2.xyz;
  r0.xyz = float3(0.0208420176,0.0208420176,0.0208420176) * r0.xyz;
  r1.x = dot(float3(0.662454188,0.134004205,0.156187683), r0.xyz);
  r1.y = dot(float3(0.272228718,0.674081743,0.0536895171), r0.xyz);
  r1.z = dot(float3(-0.00557464967,0.0040607336,1.01033914), r0.xyz);
  r0.x = dot(r1.xyz, float3(1,1,1));
  r0.x = max(9.99999975e-05, r0.x);
  r0.xy = r1.xy / r0.xx;
  r0.w = max(0, r1.y);
  r0.w = min(65504, r0.w);
  r0.w = log2(r0.w);
  r0.w = 0.981100023 * r0.w;
  r1.y = exp2(r0.w);
  r0.w = max(9.99999975e-05, r0.y);
  r0.w = r1.y / r0.w;
  r1.w = 1 + -r0.x;
  r0.z = r1.w + -r0.y;
  r1.xz = r0.xz * r0.ww;
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
  r1.x = saturate(dot(float3(3.2409699,-1.5373832,-0.498610765), r0.xyz));
  r1.y = saturate(dot(float3(-0.969243646,1.8759675,0.0415550582), r0.xyz));
  r1.z = saturate(dot(float3(0.0556300804,-0.203976959,1.05697155), r0.xyz));
  } else {
    r1.xyz = r0.xyz;
  }
  r1.xyz = applyUserTonemapACES(r1.xyz, 3);
  r1.w = 1;
  u0[vThreadID] = r1;
  return;
}