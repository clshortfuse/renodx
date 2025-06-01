// ---- Created with 3Dmigoto v1.4.1 on Fri May 30 01:02:59 2025

cbuffer GFD_PSCONST_SYSTEM : register(b0)
{
  float2 gfdResolution : packoffset(c0);
  float2 gfdResolutionRev : packoffset(c0.z);
  float4x4 gfdMtxInvView : packoffset(c1);
  float4 gfdInvProjParams : packoffset(c5);
}

cbuffer GFD_PSCONST_SMAA : register(b11)
{
  float4 subsampleIndices : packoffset(c0);
}

SamplerState LinearSampler_s : register(s0);
Texture2D<float4> edgesBuffer : register(t1);
Texture2D<float4> areaBuffer : register(t2);
Texture2D<float4> searchBuffer : register(t3);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  float4 v2 : TEXCOORD2,
  float4 v3 : TEXCOORD3,
  float4 v4 : TEXCOORD4,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = trunc(subsampleIndices.xyzw);
  r1.xy = edgesBuffer.Sample(LinearSampler_s, v1.xy).xy;
  r1.y = cmp(0 < r1.y);
  if (r1.y != 0) {
    r1.y = cmp(0 < r1.x);
    if (r1.y != 0) {
      r2.xy = float2(-1,1) * gfdResolutionRev.xy;
      r2.z = 1;
      r3.xy = v1.xy;
      r1.y = 0;
      r3.z = -1;
      r4.x = 1;
      while (true) {
        r1.w = cmp(r3.z < 15);
        r2.w = cmp(0.899999976 < r4.x);
        r1.w = r1.w ? r2.w : 0;
        if (r1.w == 0) break;
        r3.xyz = r3.xyz + r2.xyz;
        r1.yz = edgesBuffer.SampleLevel(LinearSampler_s, r3.xy, 0).yx;
        r4.x = dot(r1.zy, float2(0.5,0.5));
      }
      r1.y = cmp(0.899999976 < r1.y);
      r1.y = r1.y ? 1.000000 : 0;
      r2.x = r3.z + r1.y;
    } else {
      r2.x = 0;
      r4.x = 0;
    }
    r1.yz = float2(1,-1) * gfdResolutionRev.xy;
    r1.w = 1;
    r3.yz = v1.xy;
    r3.xw = float2(-1,1);
    while (true) {
      r4.z = cmp(r3.x < 15);
      r4.w = cmp(0.899999976 < r3.w);
      r4.z = r4.w ? r4.z : 0;
      if (r4.z == 0) break;
      r3.xyz = r3.xyz + r1.wyz;
      r4.zw = edgesBuffer.SampleLevel(LinearSampler_s, r3.yz, 0).xy;
      r3.w = dot(r4.zw, float2(0.5,0.5));
    }
    r4.y = r3.w;
    r1.y = r3.x + r2.x;
    r1.y = cmp(2 < r1.y);
    if (r1.y != 0) {
      r2.y = 0.25 + -r2.x;
      r2.zw = r3.xx * float2(1,-1) + float2(0,-0.25);
      r3.xyzw = r2.yxzw * gfdResolutionRev.xyxy + v1.xyxy;
      r1.yz = edgesBuffer.SampleLevel(LinearSampler_s, r3.xy, 0, int2(-1, 0)).xy;
      r2.yw = edgesBuffer.SampleLevel(LinearSampler_s, r3.zw, 0, int2(1, 0)).xy;
      r1.w = r2.y;
      r3.xy = r1.wy * float2(5,5) + float2(-3.75,-3.75);
      r1.yw = abs(r3.xy) * r1.wy;
      r1.yw = round(r1.yw);
      r3.y = round(r1.z);
      r3.w = round(r2.w);
      r1.yz = r3.wy * float2(2,2) + r1.yw;
      r2.yw = cmp(r4.yx >= float2(0.899999976,0.899999976));
      r1.yz = r2.yw ? float2(0,0) : r1.yz;
      r1.yz = r1.yz * float2(20,20) + r2.zx;
      r2.xy = r1.yz * float2(0.0017857143,0.00625000009) + float2(0.000892857148,0.503125012);
      r2.z = r0.z * 0.142857149 + r2.x;
      r1.yz = areaBuffer.SampleLevel(LinearSampler_s, r2.yz, 0).xy;
    } else {
      r1.yz = float2(0,0);
    }
    r0.z = gfdResolutionRev.x * 0.25 + v1.x;
    r2.xy = -gfdResolutionRev.xy;
    r2.z = 1;
    r3.y = r0.z;
    r3.z = v1.y;
    r3.xw = float2(1,-1);
    while (true) {
      r1.w = cmp(r3.w < 15);
      r2.w = cmp(0.899999976 < r3.x);
      r1.w = r1.w ? r2.w : 0;
      if (r1.w == 0) break;
      r3.yzw = r3.yzw + r2.xyz;
      r4.xy = edgesBuffer.SampleLevel(LinearSampler_s, r3.yz, 0).xy;
      r1.w = r4.x * 5 + -3.75;
      r1.w = r4.x * abs(r1.w);
      r5.x = round(r1.w);
      r5.y = round(r4.y);
      r3.x = dot(r5.xy, float2(0.5,0.5));
    }
    r2.x = r3.w;
    r1.w = edgesBuffer.SampleLevel(LinearSampler_s, v1.xy, 0, int2(1, 0)).x;
    r1.w = cmp(0 < r1.w);
    if (r1.w != 0) {
      r4.xy = gfdResolutionRev.xy;
      r4.z = 1;
      r5.x = r0.z;
      r5.y = v1.y;
      r5.z = -1;
      r3.yz = float2(1,0);
      while (true) {
        r1.w = cmp(r5.z < 15);
        r2.w = cmp(0.899999976 < r3.y);
        r1.w = r1.w ? r2.w : 0;
        if (r1.w == 0) break;
        r5.xyz = r5.xyz + r4.xyz;
        r6.xy = edgesBuffer.SampleLevel(LinearSampler_s, r5.xy, 0).xy;
        r1.w = r6.x * 5 + -3.75;
        r1.w = r6.x * abs(r1.w);
        r3.w = round(r1.w);
        r3.z = round(r6.y);
        r3.y = dot(r3.wz, float2(0.5,0.5));
      }
      r0.z = cmp(0.899999976 < r3.z);
      r0.z = r0.z ? 1.000000 : 0;
      r2.z = r5.z + r0.z;
    } else {
      r2.z = 0;
      r3.y = 0;
    }
    r0.z = r2.x + r2.z;
    r0.z = cmp(2 < r0.z);
    if (r0.z != 0) {
      r2.y = -r2.x;
      r4.xyzw = r2.yyzz * gfdResolutionRev.xyxy + v1.xyxy;
      r5.y = edgesBuffer.SampleLevel(LinearSampler_s, r4.xy, 0, int2(-1, 0)).y;
      r5.w = edgesBuffer.SampleLevel(LinearSampler_s, r4.xy, 0, int2(0, -1)).x;
      r5.xz = edgesBuffer.SampleLevel(LinearSampler_s, r4.zw, 0, int2(1, 0)).yx;
      r2.yw = r5.xy * float2(2,2) + r5.zw;
      r3.xy = cmp(r3.yx >= float2(0.899999976,0.899999976));
      r2.yw = r3.xy ? float2(0,0) : r2.yw;
      r2.xy = r2.yw * float2(20,20) + r2.zx;
      r2.xy = r2.xy * float2(0.0017857143,0.00625000009) + float2(0.000892857148,0.503125012);
      r2.z = r0.w * 0.142857149 + r2.x;
      r0.zw = areaBuffer.SampleLevel(LinearSampler_s, r2.yz, 0).xy;
      r1.yz = r1.yz + r0.wz;
    }
    r0.z = cmp(-r1.z == r1.y);
    if (r0.z != 0) {
      r2.xy = v2.xy;
      r2.z = 1;
      r3.x = 0;
      while (true) {
        r0.z = cmp(v4.x < r2.x);
        r0.w = cmp(0.828100026 < r2.z);
        r0.z = r0.w ? r0.z : 0;
        r0.w = cmp(r3.x == 0.000000);
        r0.z = r0.w ? r0.z : 0;
        if (r0.z == 0) break;
        r3.xy = edgesBuffer.SampleLevel(LinearSampler_s, r2.xy, 0).xy;
        r2.xy = gfdResolutionRev.xy * float2(-2,-0) + r2.xy;
        r2.z = r3.y;
      }
      r3.yz = r2.xz;
      r0.zw = r3.xz * float2(0.5,-2) + float2(0.0078125,2.03125);
      r0.z = searchBuffer.SampleLevel(LinearSampler_s, r0.zw, 0).x;
      r0.z = r0.z * -2.00787401 + 3.25;
      r2.x = gfdResolutionRev.x * r0.z + r3.y;
      r2.y = v3.y;
      r0.z = edgesBuffer.SampleLevel(LinearSampler_s, r2.xy, 0).x;
      r3.xy = v2.zw;
      r3.z = 1;
      r4.x = 0;
      while (true) {
        r1.w = cmp(r3.x < v4.y);
        r3.w = cmp(0.828100026 < r3.z);
        r1.w = r1.w ? r3.w : 0;
        r3.w = cmp(r4.x == 0.000000);
        r1.w = r1.w ? r3.w : 0;
        if (r1.w == 0) break;
        r4.xy = edgesBuffer.SampleLevel(LinearSampler_s, r3.xy, 0).xy;
        r3.xy = gfdResolutionRev.xy * float2(2,0) + r3.xy;
        r3.z = r4.y;
      }
      r4.yz = r3.xz;
      r3.xy = r4.xz * float2(0.5,-2) + float2(0.5234375,2.03125);
      r1.w = searchBuffer.SampleLevel(LinearSampler_s, r3.xy, 0).x;
      r1.w = r1.w * -2.00787401 + 3.25;
      r2.z = -gfdResolutionRev.x * r1.w + r4.y;
      r3.xyzw = gfdResolution.xxxx * r2.zxzx + -w1.rrrr;
      r3.xyzw = round(r3.xyzw);
      r4.xy = sqrt(abs(r3.wz));
      r0.w = edgesBuffer.SampleLevel(LinearSampler_s, r2.zy, 0, int2(1, 0)).x;
      r0.zw = float2(4,4) * r0.zw;
      r0.zw = round(r0.zw);
      r0.zw = r0.zw * float2(16,16) + r4.xy;
      r4.xy = r0.zw * float2(0.00625000009,0.0017857143) + float2(0.00312500005,0.000892857148);
      r4.z = r0.y * 0.142857149 + r4.y;
      r0.yz = areaBuffer.SampleLevel(LinearSampler_s, r4.xz, 0).xy;
      r3.xyzw = cmp(abs(r3.xyzw) >= abs(r3.wzwz));
      r3.xyzw = r3.xyzw ? float4(1,1,0.75,0.75) : 0;
      r0.w = r3.x + r3.y;
      r3.xy = r3.zw / r0.ww;
      r2.w = v1.y;
      r0.w = edgesBuffer.SampleLevel(LinearSampler_s, r2.xw, 0, int2(0, 1)).x;
      r0.w = -r3.x * r0.w + 1;
      r1.w = edgesBuffer.SampleLevel(LinearSampler_s, r2.zw, 0, int2(1, 1)).x;
      r4.x = saturate(-r3.y * r1.w + r0.w);
      r0.w = edgesBuffer.SampleLevel(LinearSampler_s, r2.xw, 0, int2(0, -2)).x;
      r0.w = -r3.x * r0.w + 1;
      r1.w = edgesBuffer.SampleLevel(LinearSampler_s, r2.zw, 0, int2(1, -2)).x;
      r4.y = saturate(-r3.y * r1.w + r0.w);
      o0.xy = r4.xy * r0.yz;
    } else {
      o0.xy = r1.yz;
      r1.x = 0;
    }
  } else {
    o0.xy = float2(0,0);
  }
  r0.y = cmp(0 < r1.x);
  if (r0.y != 0) {
    r1.xy = v3.xy;
    r1.z = 1;
    r2.x = 0;
    while (true) {
      r0.y = cmp(v4.z < r1.y);
      r0.z = cmp(0.828100026 < r1.z);
      r0.y = r0.z ? r0.y : 0;
      r0.z = cmp(r2.x == 0.000000);
      r0.y = r0.z ? r0.y : 0;
      if (r0.y == 0) break;
      r2.xy = edgesBuffer.SampleLevel(LinearSampler_s, r1.xy, 0).yx;
      r1.xy = gfdResolutionRev.xy * float2(-0,-2) + r1.xy;
      r1.z = r2.y;
    }
    r2.yz = r1.yz;
    r0.yz = r2.xz * float2(0.5,-2) + float2(0.0078125,2.03125);
    r0.y = searchBuffer.SampleLevel(LinearSampler_s, r0.yz, 0).x;
    r0.y = r0.y * -2.00787401 + 3.25;
    r1.x = gfdResolutionRev.y * r0.y + r2.y;
    r1.y = v2.x;
    r0.y = edgesBuffer.SampleLevel(LinearSampler_s, r1.yx, 0).y;
    r2.xy = v3.zw;
    r2.z = 1;
    r3.x = 0;
    while (true) {
      r0.w = cmp(r2.y < v4.w);
      r2.w = cmp(0.828100026 < r2.z);
      r0.w = r0.w ? r2.w : 0;
      r2.w = cmp(r3.x == 0.000000);
      r0.w = r0.w ? r2.w : 0;
      if (r0.w == 0) break;
      r3.xy = edgesBuffer.SampleLevel(LinearSampler_s, r2.xy, 0).yx;
      r2.xy = gfdResolutionRev.xy * float2(0,2) + r2.xy;
      r2.z = r3.y;
    }
    r3.yz = r2.yz;
    r2.xy = r3.xz * float2(0.5,-2) + float2(0.5234375,2.03125);
    r0.w = searchBuffer.SampleLevel(LinearSampler_s, r2.xy, 0).x;
    r0.w = r0.w * -2.00787401 + 3.25;
    r1.z = -gfdResolutionRev.y * r0.w + r3.y;
    r2.xyzw = gfdResolution.yyyy * r1.zxzx + -w1.gggg;
    r2.xyzw = round(r2.xyzw);
    r3.xy = sqrt(abs(r2.wz));
    r0.z = edgesBuffer.SampleLevel(LinearSampler_s, r1.yz, 0, int2(0, 1)).y;
    r0.yz = float2(4,4) * r0.yz;
    r0.yz = round(r0.yz);
    r0.yz = r0.yz * float2(16,16) + r3.xy;
    r3.xy = r0.yz * float2(0.00625000009,0.0017857143) + float2(0.00312500005,0.000892857148);
    r3.z = r0.x * 0.142857149 + r3.y;
    r0.xy = areaBuffer.SampleLevel(LinearSampler_s, r3.xz, 0).xy;
    r2.xyzw = cmp(abs(r2.xyzw) >= abs(r2.wzwz));
    r2.xyzw = r2.xyzw ? float4(1,1,0.75,0.75) : 0;
    r0.z = r2.x + r2.y;
    r0.zw = r2.zw / r0.zz;
    r1.w = v1.x;
    r1.y = edgesBuffer.SampleLevel(LinearSampler_s, r1.wx, 0, int2(1, 0)).y;
    r1.y = -r0.z * r1.y + 1;
    r2.x = edgesBuffer.SampleLevel(LinearSampler_s, r1.wz, 0, int2(1, 1)).y;
    r2.z = saturate(-r0.w * r2.x + r1.y);
    r1.x = edgesBuffer.SampleLevel(LinearSampler_s, r1.wx, 0, int2(-2, 0)).y;
    r0.z = -r0.z * r1.x + 1;
    r1.x = edgesBuffer.SampleLevel(LinearSampler_s, r1.wz, 0, int2(-2, 1)).y;
    r2.w = saturate(-r0.w * r1.x + r0.z);
    o0.zw = r2.zw * r0.xy;
  } else {
    o0.zw = float2(0,0);
  }
  return;
}