#include "./shared.h"

float3 fColorCorrectGamma : register(c9);
float4 fHermiteParam[8] : register(c1);

static const float kSRGBLinearThreshold = 0.003131;
static const float kSRGBEncodeScale = 12.92;
static const float kSRGBEncodeGamma = 1.0 / 2.4;
static const float kSRGBEncodeA = 1.055;
static const float kSRGBEncodeB = -0.055;
static const float kEpsilon = 1e-6;

float3 LinearToSRGB(float3 c) {
  float3 linear_segment = c * kSRGBEncodeScale;
  float3 power_segment = pow(max(c, 0.0), kSRGBEncodeGamma) * kSRGBEncodeA + kSRGBEncodeB;
  return float3(
    c.x <= kSRGBLinearThreshold ? linear_segment.x : power_segment.x,
    c.y <= kSRGBLinearThreshold ? linear_segment.y : power_segment.y,
    c.z <= kSRGBLinearThreshold ? linear_segment.z : power_segment.z);
}

float4 main(float texcoord : TEXCOORD) : COLOR {
  float4 o;

  float4 r0;
  float4 r1;
  float4 r2;
  float4 r3;
  float4 r4;
  float4 r5;
  float4 r6;
  float4 r7;

  r0.x = fHermiteParam[5].x;
  r0.y = fHermiteParam[6].y;
  r0.z = fHermiteParam[7].y;
  r0.w = -fHermiteParam[7].x + texcoord.x;
  r0.xyz = (r0.w >= 0) ? 0 : r0.xyz;

  r1.x = fHermiteParam[4].x;
  r1.y = fHermiteParam[5].y;
  r1.z = fHermiteParam[6].y;
  r1.w = -fHermiteParam[6].x + texcoord.x;
  r0.xyz = (r1.w >= 0) ? r0.xyz : r1.xyz;

  r1.x = fHermiteParam[3].x;
  r1.y = fHermiteParam[4].y;
  r1.z = fHermiteParam[5].y;
  r2.x = -fHermiteParam[5].x + texcoord.x;
  r0.xyz = (r2.x >= 0) ? r0.xyz : r1.xyz;

  r1.x = fHermiteParam[2].x;
  r1.y = fHermiteParam[3].y;
  r1.z = fHermiteParam[4].y;
  r2.y = -fHermiteParam[4].x + texcoord.x;
  r0.xyz = (r2.y >= 0) ? r0.xyz : r1.xyz;

  r1.x = fHermiteParam[1].x;
  r1.y = fHermiteParam[2].y;
  r1.z = fHermiteParam[3].y;
  r2.z = -fHermiteParam[3].x + texcoord.x;
  r0.xyz = (r2.z >= 0) ? r0.xyz : r1.xyz;

  r1.x = fHermiteParam[0].x;
  r1.y = fHermiteParam[1].y;
  r1.z = fHermiteParam[2].y;
  r2.w = -fHermiteParam[2].x + texcoord.x;
  r0.xyz = (r2.w >= 0) ? r0.xyz : r1.xyz;

  r1.x = -fHermiteParam[1].x + texcoord.x;
  r0.x = (r1.x >= 0) ? -r0.x : -0;

  r3.y = fHermiteParam[7].x;
  r3.xw = fHermiteParam[6].x;
  r1.yz = (r0.w >= 0) ? float2(0, 0) : float2(fHermiteParam[6].x, fHermiteParam[7].x);

  r3.yz = fHermiteParam[5].x;
  r1.yz = (r1.w >= 0) ? r1.yz : float2(fHermiteParam[5].x, fHermiteParam[6].x);

  r3.xw = fHermiteParam[4].x;
  r1.yz = (r2.x >= 0) ? r1.yz : float2(fHermiteParam[4].x, fHermiteParam[5].x);

  r3.yz = fHermiteParam[3].x;
  r1.yz = (r2.y >= 0) ? r1.yz : float2(fHermiteParam[3].x, fHermiteParam[4].x);

  r3.xw = fHermiteParam[2].x;
  r1.yz = (r2.z >= 0) ? r1.yz : float2(fHermiteParam[2].x, fHermiteParam[3].x);

  r3.z = fHermiteParam[1].x;
  r1.yz = (r2.w >= 0) ? r1.yz : float2(fHermiteParam[1].x, fHermiteParam[2].x);

  r3.xz = fHermiteParam[0].xy;
  r3.yw = fHermiteParam[1].xy;
  r1.yz = (r1.x >= 0) ? r1.yz : float2(fHermiteParam[0].x, fHermiteParam[1].x);
  r0.yz = (r1.x >= 0) ? r0.yz : float2(fHermiteParam[0].y, fHermiteParam[1].y);

  r0.x = r0.x + r1.y;
  r0.x = 1 / r0.x;
  r3.x = -r1.y + r1.z;
  r0.x = r3.x * -r0.x + 1;

  r4 = float4(0, 1, 6, 5);

  r5 = fHermiteParam[5].y * r4.xyxx + r4.xxxz;
  r5 = (r0.w >= 0) ? float4(0, 0, 0, 0) : r5;

  r6.xzw = float3(fHermiteParam[7].x, fHermiteParam[7].y, 5);
  r6.y = fHermiteParam[4].y;
  r5 = (r1.w >= 0) ? r5 : r6;

  r6 = float4(1, 0, 4, 3);
  r7.xzw = float3(fHermiteParam[6].x, fHermiteParam[6].y, 4);
  r7.y = fHermiteParam[3].y;
  r5 = (r2.x >= 0) ? r5 : r7;

  r6.xzw = float3(fHermiteParam[5].x, fHermiteParam[5].y, 3);
  r6.y = fHermiteParam[2].y;
  r5 = (r2.y >= 0) ? r5 : r6;

  r2.xy = fHermiteParam[4].xy;
  r6.xzw = float3(fHermiteParam[4].x, fHermiteParam[4].y, 2);
  r6.y = fHermiteParam[1].y;
  r5 = (r2.z >= 0) ? r5 : r6;

  r6.xzw = float3(fHermiteParam[3].x, fHermiteParam[3].y, 1);
  r6.y = fHermiteParam[0].y;
  r2 = (r2.w >= 0) ? r5 : r6;

  r4 = float4(fHermiteParam[2].x, 0, fHermiteParam[2].y, 0);
  r2 = (r1.x >= 0) ? r2 : r4;

  r1.x = lerp(r2.y, r0.y, r0.x);
  r0.x = r0.z + -r1.x;
  r0.x = r0.x * 0.5;
  r0.w = -r0.y + r0.z;
  r0.x = (-r2.w >= 0) ? r0.w : r0.x;
  r1.x = r0.y + r0.y;
  r1.x = r0.z * -2 + r1.x;
  r1.x = r0.x + r1.x;

  r1.w = -r1.z + r2.x;
  r1.w = 1 / r1.w;
  r1.w = r1.w * r3.x;
  r2.x = 1 / r3.x;
  r3.x = lerp(r0.z, r2.z, r1.w);
  r1.w = -r0.y + r3.x;
  r1.w = r1.w * 0.5;
  r1.z = r1.z + -1;
  r1.y = -r1.y + texcoord.x;
  r1.y = r2.x * r1.y;
  r0.w = (-abs(r1.z) >= 0) ? r0.w : r1.w;
  r1.x = r0.w + r1.x;
  r1.z = r0.x * -2;

  r0.z = dot(r0.yz, float2(-3, 3)) + r1.z;
  r0.z = -r0.w + r0.z;

  r0.w = r1.y * r1.y;
  r0.z = r0.w * r0.z;
  r0.w = r0.w * r1.y;
  r0.z = r1.x * r0.w + r0.z;
  r0.x = r0.x * r1.y + r0.z;
  r0.x = saturate(r0.y + r0.x);

  o.w = r0.x;

  float base_linear = max(r0.x, kEpsilon);
  float3 gamma_linear = exp2(log2(base_linear) * fColorCorrectGamma.xyz);
  o.xyz = LinearToSRGB(gamma_linear);

  return o;
}
