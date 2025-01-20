// ---- Created with 3Dmigoto v1.3.16 on Tue Sep 03 06:54:16 2024

cbuffer GammaBuffer : register(b10) {
  float g_GammaValue : packoffset(c0);
  float g_HdrUiBrightness : packoffset(c0.y);
  float g_sdrLutSize : packoffset(c0.z);
  float g_hdrLutSize : packoffset(c0.w);
  float g_BrightnessCorrection : packoffset(c1);
  uint g_calibrationShowGamma : packoffset(c1.y);
  uint g_calibrationShowNits : packoffset(c1.z);
  uint GammaBuffer_pad2 : packoffset(c1.w);
  float2 g_calibrationImageLowerUV : packoffset(c2);
  float2 g_calibrationImageUpperUV : packoffset(c2.z);

  // clang-format off
  struct
  {
    float P;
    float a;
    float m;
    float l;
    float c;
    float b;
  } gtParams: packoffset(c3);
  // clang-format on
}

RWTexture3D<float4> ACESLut : register(u0);

// 3Dmigoto declarations
#define cmp -

[numthreads(4, 4, 4)]
void main(uint3 vThreadID: SV_DispatchThreadID) {
  const float4 icb[] = { { -4.000000, -0.718548, 0, 0 },
                         { -4.000000, 2.081031, 0, 0 },
                         { -3.157377, 3.668124, 0, 0 },
                         { -0.485250, 4.000000, 0, 0 },
                         { 1.847732, 4.000000, 0, 0 },
                         { 1.847732, 4.000000, 0, 0 } };
  // Needs manual fix for instruction:
  // unknown dcl_: dcl_uav_typed_texture3d (float,float,float,float) u0
  float4 r0, r1, r2, r3, r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  // resinfo_indexable(texture3d)(float,float,float,float) r0.xyz, l(0), u0.xyzw
  ACESLut.GetDimensions(uiDest.x, uiDest.y, uiDest.z);  //   tx.GetDimensions(0, uiDest.x, uiDest.y, uiDest.z);
  r0.xyz = uiDest.xyz;  // rx = uiDest;
  // state = 0, constZero.eType = 4, returnType = 0, texture.eType = 7, afImmediates[0] = 0.000000
  r1.xyz = (uint3)vThreadID.xyz;
  r0.xyz = float3(-1, -1, -1) + r0.xyz;
  r0.xyz = r1.xyz / r0.xyz;
  r0.xyz = r0.xyz * r0.xyz;
  r0.xyz = r0.xyz * r0.xyz;
  r0.xyz = float3(1000, 1000, 1000) * r0.xyz;

  // BT.709 -> XYZ
  r1.x = dot(float3(0.412390888, 0.357584298, 0.180480838), r0.xyz);
  r1.y = dot(float3(0.212639064, 0.715168595, 0.0721923336), r0.xyz);
  r1.z = dot(float3(0.0193308201, 0.119194724, 0.950532317), r0.xyz);

  // D65 -> D60
  // chromatic adaptation method: von Kries
  // chromatic adaptation transform: Bradford
  r0.x = dot(float3(1.01303494, 0.00610530004, -0.0149709601), r1.xyz);
  r0.y = dot(float3(0.00769822998, 0.998164833, -0.0050321999), r1.xyz);
  r0.z = dot(float3(-0.00284131011, 0.00468514999, 0.924506664), r1.xyz);

  // XYZ -> AP0
  r1.y = dot(float2(1.04981101, -9.74799987e-005), r0.xz);
  r1.z = dot(float3(-0.495902956, 1.37331295, 0.0982400328), r0.xyz);
  r1.w = dot(float2(3.99999998e-008, 0.991252124), r0.xz);

  r0.x = min(r1.y, r1.z);
  r0.x = min(r0.x, r1.w);
  r0.y = max(r1.y, r1.z);
  r0.y = max(r0.y, r1.w);
  r0.xyz = max(float3(1.00000001e-010, 1.00000001e-010, 0.00999999978), r0.xyy);
  r0.x = r0.y + -r0.x;
  r0.x = r0.x / r0.z;
  r0.yzw = r1.wzy + -r1.zyw;
  r0.yz = r1.wz * r0.yz;
  r0.y = r0.y + r0.z;
  r0.y = r1.y * r0.w + r0.y;
  r0.y = sqrt(r0.y);
  r0.z = r1.w + r1.z;
  r0.z = r0.z + r1.y;
  r0.y = r0.y * 1.75 + r0.z;
  r0.w = -0.400000006 + r0.x;
  r1.x = 2.5 * r0.w;
  r1.x = 1 + -abs(r1.x);
  r1.x = max(0, r1.x);
  r2.x = cmp(0 < r0.w);
  r0.w = cmp(r0.w < 0);
  r0.w = (int)-r2.x + (int)r0.w;
  r0.w = (int)r0.w;
  r1.x = -r1.x * r1.x + 1;
  r0.w = r0.w * r1.x + 1;
  r0.zw = float2(0.333333343, 0.0250000004) * r0.yw;
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
  r1.zw = float2(360, -360) + r0.zz;
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
  r0.xyz = max(float3(0, 0, 0), r2.xzw);
  r0.xyz = min(float3(65504, 65504, 65504), r0.xyz);

  // AP0 => AP1
  r1.x = dot(float3(1.45143926, -0.236510754, -0.214928567), r0.xyz);
  r1.y = dot(float3(-0.0765537769, 1.17622972, -0.0996759236), r0.xyz);
  r1.z = dot(float3(0.00831614807, -0.00603244966, 0.997716308), r0.xyz);
  r0.xyz = max(float3(0, 0, 0), r1.xyz);
  r0.xyz = min(float3(65504, 65504, 65504), r0.xyz);

  // RRT SAT MATRIX
  r0.w = dot(float3(0.970888972, 0.0269632991, 0.00214758003), r0.xyz);
  r1.x = dot(float3(0.0108891996, 0.986962974, 0.00214758003), r0.xyz);
  r0.x = dot(float3(0.0108891996, 0.0269632991, 0.962148011), r0.xyz);

  r0.y = cmp(0 >= r0.w);
  r0.z = log2(r0.w);
  r0.y = r0.y ? -14 : r0.z;
  r0.z = cmp(-17.4739323 >= r0.y);
  if (r0.z != 0) {
    r0.z = -4;
  } else {
    r0.w = cmp(r0.y < -2.47393107);
    if (r0.w != 0) {
      r0.w = r0.y * 0.30103001 + 5.26017761;
      r1.y = 0.664385557 * r0.w;
      r1.z = (int)r1.y;
      r1.y = trunc(r1.y);
      r2.y = r0.w * 0.664385557 + -r1.y;
      r1.yw = (int2)r1.zz + int2(1, 2);
      r2.x = r2.y * r2.y;
      r3.x = icb[r1.z + 0].x;
      r3.y = icb[r1.y + 0].x;
      r3.z = icb[r1.w + 0].x;
      r4.x = dot(float3(0.5, -1, 0.5), r3.xyz);
      r4.y = dot(float2(-1, 1), r3.xy);
      r4.z = dot(float2(0.5, 0.5), r3.xy);
      r2.z = 1;
      r0.z = dot(r2.xyz, r4.xyz);
    } else {
      r0.w = cmp(r0.y < 15.5260687);
      if (r0.w != 0) {
        r0.y = r0.y * 0.30103001 + 0.744727492;
        r0.w = 0.553654671 * r0.y;
        r1.y = (int)r0.w;
        r0.w = trunc(r0.w);
        r2.y = r0.y * 0.553654671 + -r0.w;
        r0.yw = (int2)r1.yy + int2(1, 2);
        r2.x = r2.y * r2.y;
        r3.x = icb[r1.y + 0].y;
        r3.y = icb[r0.y + 0].y;
        r3.z = icb[r0.w + 0].y;
        r4.x = dot(float3(0.5, -1, 0.5), r3.xyz);
        r4.y = dot(float2(-1, 1), r3.xy);
        r4.z = dot(float2(0.5, 0.5), r3.xy);
        r2.z = 1;
        r0.z = dot(r2.xyz, r4.xyz);
      } else {
        r0.z = 4;
      }
    }
  }
  r0.y = 3.32192802 * r0.z;
  r2.x = exp2(r0.y);
  r0.y = cmp(0 >= r1.x);
  r0.z = log2(r1.x);
  r0.y = r0.y ? -14 : r0.z;
  r0.z = cmp(-17.4739323 >= r0.y);
  if (r0.z != 0) {
    r0.z = -4;
  } else {
    r0.w = cmp(r0.y < -2.47393107);
    if (r0.w != 0) {
      r0.w = r0.y * 0.30103001 + 5.26017761;
      r1.x = 0.664385557 * r0.w;
      r1.y = (int)r1.x;
      r1.x = trunc(r1.x);
      r3.y = r0.w * 0.664385557 + -r1.x;
      r1.xz = (int2)r1.yy + int2(1, 2);
      r3.x = r3.y * r3.y;
      r4.x = icb[r1.y + 0].x;
      r4.y = icb[r1.x + 0].x;
      r4.z = icb[r1.z + 0].x;
      r1.x = dot(float3(0.5, -1, 0.5), r4.xyz);
      r1.y = dot(float2(-1, 1), r4.xy);
      r1.z = dot(float2(0.5, 0.5), r4.xy);
      r3.z = 1;
      r0.z = dot(r3.xyz, r1.xyz);
    } else {
      r0.w = cmp(r0.y < 15.5260687);
      if (r0.w != 0) {
        r0.y = r0.y * 0.30103001 + 0.744727492;
        r0.w = 0.553654671 * r0.y;
        r1.x = (int)r0.w;
        r0.w = trunc(r0.w);
        r3.y = r0.y * 0.553654671 + -r0.w;
        r0.yw = (int2)r1.xx + int2(1, 2);
        r3.x = r3.y * r3.y;
        r1.x = icb[r1.x + 0].y;
        r1.y = icb[r0.y + 0].y;
        r1.z = icb[r0.w + 0].y;
        r4.x = dot(float3(0.5, -1, 0.5), r1.xyz);
        r4.y = dot(float2(-1, 1), r1.xy);
        r4.z = dot(float2(0.5, 0.5), r1.xy);
        r3.z = 1;
        r0.z = dot(r3.xyz, r4.xyz);
      } else {
        r0.z = 4;
      }
    }
  }
  r0.y = 3.32192802 * r0.z;
  r2.y = exp2(r0.y);
  r0.y = cmp(0 >= r0.x);
  r0.x = log2(r0.x);
  r0.x = r0.y ? -14 : r0.x;
  r0.y = cmp(-17.4739323 >= r0.x);
  if (r0.y != 0) {
    r0.y = -4;
  } else {
    r0.z = cmp(r0.x < -2.47393107);
    if (r0.z != 0) {
      r0.z = r0.x * 0.30103001 + 5.26017761;
      r0.w = 0.664385557 * r0.z;
      r1.x = (int)r0.w;
      r0.w = trunc(r0.w);
      r3.y = r0.z * 0.664385557 + -r0.w;
      r0.zw = (int2)r1.xx + int2(1, 2);
      r3.x = r3.y * r3.y;
      r1.x = icb[r1.x + 0].x;
      r1.y = icb[r0.z + 0].x;
      r1.z = icb[r0.w + 0].x;
      r4.x = dot(float3(0.5, -1, 0.5), r1.xyz);
      r4.y = dot(float2(-1, 1), r1.xy);
      r4.z = dot(float2(0.5, 0.5), r1.xy);
      r3.z = 1;
      r0.y = dot(r3.xyz, r4.xyz);
    } else {
      r0.z = cmp(r0.x < 15.5260687);
      if (r0.z != 0) {
        r0.x = r0.x * 0.30103001 + 0.744727492;
        r0.z = 0.553654671 * r0.x;
        r0.w = (int)r0.z;
        r0.z = trunc(r0.z);
        r1.y = r0.x * 0.553654671 + -r0.z;
        r0.xz = (int2)r0.ww + int2(1, 2);
        r1.x = r1.y * r1.y;
        r3.x = icb[r0.w + 0].y;
        r3.y = icb[r0.x + 0].y;
        r3.z = icb[r0.z + 0].y;
        r4.x = dot(float3(0.5, -1, 0.5), r3.xyz);
        r4.y = dot(float2(-1, 1), r3.xy);
        r4.z = dot(float2(0.5, 0.5), r3.xy);
        r1.z = 1;
        r0.y = dot(r1.xyz, r4.xyz);
      } else {
        r0.y = 4;
      }
    }
  }
  r0.x = 3.32192802 * r0.y;
  r2.z = exp2(r0.x);

  // AP1 => AP0
  r0.x = dot(float3(0.695452213, 0.140678704, 0.163869068), r2.xyz);
  r0.y = dot(float3(0.0447945632, 0.859671116, 0.0955343172), r2.xyz);
  r0.z = dot(float3(-0.00552588282, 0.00402521016, 1.00150073), r2.xyz);

  // AP0 => AP1
  r0.w = dot(float3(1.45143926, -0.236510754, -0.214928567), r0.xyz);
  r1.x = dot(float3(-0.0765537769, 1.17622972, -0.0996759236), r0.xyz);
  r0.x = dot(float3(0.00831614807, -0.00603244966, 0.997716308), r0.xyz);

  r0.yz = gtParams.P * gtParams.l;
  r0.y = r0.y / gtParams.a;
  r1.y = -gtParams.P * gtParams.l + gtParams.P;
  r0.z = r0.z / r1.y;
  r0.z = -r0.z / gtParams.P;
  r1.z = cmp(r0.w >= r0.y);
  r1.w = r1.z ? 1.000000 : 0;
  r1.z = r1.z ? 0 : 1;
  r2.x = r0.w + -r0.y;
  r2.x = r2.x * r0.z;
  r2.x = 1.44269502 * r2.x;
  r2.x = exp2(r2.x);
  r2.x = -r1.y * r2.x + gtParams.P;
  r0.w = gtParams.a * r0.w;
  r1.w = r2.x * r1.w;
  r2.x = r0.w * r1.z + r1.w;
  r0.w = cmp(r1.x >= r0.y);
  r1.z = r0.w ? 1.000000 : 0;
  r0.w = r0.w ? 0 : 1;
  r1.w = r1.x + -r0.y;
  r1.w = r1.w * r0.z;
  r1.w = 1.44269502 * r1.w;
  r1.w = exp2(r1.w);
  r1.w = -r1.y * r1.w + gtParams.P;
  r1.x = gtParams.a * r1.x;
  r1.z = r1.w * r1.z;
  r2.y = r1.x * r0.w + r1.z;
  r0.w = cmp(r0.x >= r0.y);
  r1.x = r0.w ? 1.000000 : 0;
  r0.w = r0.w ? 0 : 1;
  r0.y = r0.x + -r0.y;
  r0.y = r0.z * r0.y;
  r0.y = 1.44269502 * r0.y;
  r0.y = exp2(r0.y);
  r0.y = -r1.y * r0.y + gtParams.P;
  r0.x = gtParams.a * r0.x;
  r0.y = r0.y * r1.x;
  r2.z = r0.x * r0.w + r0.y;

  // AP1 -> XYZ
  r0.x = dot(float3(0.662454188, 0.134004205, 0.156187683), r2.xyz);
  r0.y = dot(float3(0.272228718, 0.674081743, 0.0536895171), r2.xyz);
  r0.z = dot(float3(-0.00557464967, 0.0040607336, 1.01033914), r2.xyz);

  // D60 -> D65
  r1.x = dot(float3(0.987223983, -0.00611326983, 0.0159533005), r0.xyz);
  r1.y = dot(float3(-0.00759836007, 1.00186002, 0.00533019984), r0.xyz);
  r1.z = dot(float3(0.00307257008, -0.00509594986, 1.08168006), r0.xyz);

  // XYZ -> BT.2020
  r0.x = dot(float3(1.7166512, -0.35567078, -0.253366292), r1.xyz);
  r0.y = dot(float3(-0.66668433, 1.61648118, 0.0157685466), r1.xyz);
  r0.z = dot(float3(0.0176398568, -0.042770613, 0.942103148), r1.xyz);

  // Linear -> PQ
  r0.xyz = saturate(float3(9.99999975e-005, 9.99999975e-005, 9.99999975e-005) * r0.xyz);
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(0.159301758, 0.159301758, 0.159301758) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r1.xyz = r0.xyz * float3(18.8515625, 18.8515625, 18.8515625) + float3(0.8359375, 0.8359375, 0.8359375);
  r0.xyz = r0.xyz * float3(18.6875, 18.6875, 18.6875) + float3(1, 1, 1);
  r0.xyz = r1.xyz / r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(78.84375, 78.84375, 78.84375) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.w = 1;
  // No code for instruction (needs manual fix):
  // store_uav_typed u0.xyzw, vThreadID.xyzz, r0.xyzw
  ACESLut[vThreadID] = r0;
  return;
}
