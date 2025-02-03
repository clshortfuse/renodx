Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0) {
  float4 cb0[29];
}

#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    float2 w1: TEXCOORD1,
    float4 v2: TEXCOORD2,
    float4 v3: TEXCOORD3,
    float4 v4: TEXCOORD4,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4, r5, r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r0.y = cmp(0 < r0.y);
  if (r0.y != 0) {
    r0.y = cmp(0 < r0.x);
    if (r0.y != 0) {
      r1.xy = float2(-1, 1) * cb0[28].xy;
      r1.z = 1;
      r2.xy = v1.xy;
      r3.x = 0;
      r2.z = -1;
      r4.x = 1;
      while (true) {
        r0.y = cmp(r2.z < 7);
        r0.z = cmp(0.899999976 < r4.x);
        r0.y = r0.z ? r0.y : 0;
        if (r0.y == 0) break;
        r2.xyz = r2.xyz + r1.xyz;
        r3.xyzw = t0.SampleLevel(s0_s, r2.xy, 0).yxzw;
        r4.x = dot(r3.yx, float2(0.5, 0.5));
      }
      r0.y = cmp(0.899999976 < r3.x);
      r0.y = r0.y ? 1.000000 : 0;
      r1.x = r2.z + r0.y;
    } else {
      r1.x = 0;
      r4.x = 0;
    }
    r0.yz = float2(1, -1) * cb0[28].xy;
    r0.w = 1;
    r2.yz = v1.xy;
    r2.xw = float2(-1, 1);
    while (true) {
      r3.x = cmp(r2.x < 7);
      r3.y = cmp(0.899999976 < r2.w);
      r3.x = r3.y ? r3.x : 0;
      if (r3.x == 0) break;
      r2.xyz = r2.xyz + r0.wyz;
      r3.xyzw = t0.SampleLevel(s0_s, r2.yz, 0).xyzw;
      r2.w = dot(r3.xy, float2(0.5, 0.5));
    }
    r4.y = r2.w;
    r0.y = r2.x + r1.x;
    r0.y = cmp(2 < r0.y);
    if (r0.y != 0) {
      r1.y = 0.25 + -r1.x;
      r1.zw = r2.xx * float2(1, -1) + float2(0, -0.25);
      r2.xyzw = r1.yxzw * cb0[28].xyxy + v1.xyxy;
      r3.xyzw = t0.SampleLevel(s0_s, r2.xy, 0, int2(0, 0)).xyzw;
      r2.xyzw = t0.SampleLevel(s0_s, r2.zw, 0, int2(0, 0)).xyzw;
      r3.z = r2.x;
      r0.yz = r3.xz * float2(5, 5) + float2(-3.75, -3.75);
      r0.yz = r3.xz * abs(r0.yz);
      r0.yz = round(r0.yz);
      r1.y = round(r3.y);
      r1.w = round(r2.y);
      r0.yz = r1.yw * float2(2, 2) + r0.yz;
      r1.yw = cmp(r4.xy >= float2(0.899999976, 0.899999976));
      r0.yz = r1.yw ? float2(0, 0) : r0.yz;
      r0.yz = r0.yz * float2(20, 20) + r1.xz;
      r0.yz = r0.yz * float2(0.00625000009, 0.0017857143) + float2(0.503125012, 0.000892857148);
      r1.xyzw = t1.SampleLevel(s0_s, r0.yz, 0).xyzw;
    } else {
      r1.xy = float2(0, 0);
    }
    r0.y = cb0[28].x * 0.25 + v1.x;
    r2.xy = -cb0[28].xy;
    r2.z = 1;
    r3.y = r0.y;
    r3.z = v1.y;
    r3.xw = float2(1, -1);
    while (true) {
      r0.z = cmp(r3.w < 7);
      r0.w = cmp(0.899999976 < r3.x);
      r0.z = r0.w ? r0.z : 0;
      if (r0.z == 0) break;
      r3.yzw = r3.yzw + r2.xyz;
      r4.xyzw = t0.SampleLevel(s0_s, r3.yz, 0).xyzw;
      r0.z = r4.x * 5 + -3.75;
      r0.z = r4.x * abs(r0.z);
      r5.x = round(r0.z);
      r5.y = round(r4.y);
      r3.x = dot(r5.xy, float2(0.5, 0.5));
    }
    r2.x = r3.w;
    r4.xyzw = t0.SampleLevel(s0_s, v1.xy, 0, int2(0, 0)).xyzw;
    r0.z = cmp(0 < r4.x);
    if (r0.z != 0) {
      r4.xy = cb0[28].xy;
      r4.z = 1;
      r5.x = r0.y;
      r5.y = v1.y;
      r0.z = 0;
      r5.z = -1;
      r3.y = 1;
      while (true) {
        r1.z = cmp(r5.z < 7);
        r1.w = cmp(0.899999976 < r3.y);
        r1.z = r1.w ? r1.z : 0;
        if (r1.z == 0) break;
        r5.xyz = r5.xyz + r4.xyz;
        r6.xyzw = t0.SampleLevel(s0_s, r5.xy, 0).xyzw;
        r1.z = r6.x * 5 + -3.75;
        r1.z = r6.x * abs(r1.z);
        r0.w = round(r1.z);
        r0.z = round(r6.y);
        r3.y = dot(r0.wz, float2(0.5, 0.5));
      }
      r0.y = cmp(0.899999976 < r0.z);
      r0.y = r0.y ? 1.000000 : 0;
      r2.z = r5.z + r0.y;
    } else {
      r2.z = 0;
      r3.y = 0;
    }
    r0.y = r2.x + r2.z;
    r0.y = cmp(2 < r0.y);
    if (r0.y != 0) {
      r2.y = -r2.x;
      r4.xyzw = r2.yyzz * cb0[28].xyxy + v1.xyxy;
      r5.xyzw = t0.SampleLevel(s0_s, r4.xy, 0, int2(0, 0)).xyzw;
      r6.xyzw = t0.SampleLevel(s0_s, r4.xy, 0, int2(0, 0)).yzxw;
      r4.xyzw = t0.SampleLevel(s0_s, r4.zw, 0, int2(0, 0)).xyzw;
      r6.x = r5.y;
      r6.yw = r4.yx;
      r0.yz = r6.xy * float2(2, 2) + r6.zw;
      r1.zw = cmp(r3.xy >= float2(0.899999976, 0.899999976));
      r0.yz = r1.zw ? float2(0, 0) : r0.yz;
      r0.yz = r0.yz * float2(20, 20) + r2.xz;
      r0.yz = r0.yz * float2(0.00625000009, 0.0017857143) + float2(0.503125012, 0.000892857148);
      r2.xyzw = t1.SampleLevel(s0_s, r0.yz, 0).xyzw;
      r1.xy = r2.yx + r1.xy;
    }
    r0.y = cmp(-r1.y == r1.x);
    if (r0.y != 0) {
      r2.xy = v2.xy;
      r2.z = 1;
      r3.x = 0;
      while (true) {
        r0.y = cmp(v4.x < r2.x);
        r0.z = cmp(0.828100026 < r2.z);
        r0.y = r0.z ? r0.y : 0;
        r0.z = cmp(r3.x == 0.000000);
        r0.y = r0.z ? r0.y : 0;
        if (r0.y == 0) break;
        r3.xyzw = t0.SampleLevel(s0_s, r2.xy, 0).xyzw;
        r2.xy = cb0[28].xy * float2(-2, -0) + r2.xy;
        r2.z = r3.y;
      }
      r3.yz = r2.xz;
      r0.yz = r3.xz * float2(0.5, -2) + float2(0.0078125, 2.03125);
      r2.xyzw = t2.SampleLevel(s0_s, r0.yz, 0).xyzw;
      r0.y = r2.w * -2.00787401 + 3.25;
      r2.x = cb0[28].x * r0.y + r3.y;
      r2.y = v3.y;
      r3.xyzw = t0.SampleLevel(s0_s, r2.xy, 0).xyzw;
      r4.xy = v2.zw;
      r4.z = 1;
      r5.x = 0;
      while (true) {
        r0.y = cmp(r4.x < v4.y);
        r0.z = cmp(0.828100026 < r4.z);
        r0.y = r0.z ? r0.y : 0;
        r0.z = cmp(r5.x == 0.000000);
        r0.y = r0.z ? r0.y : 0;
        if (r0.y == 0) break;
        r5.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
        r4.xy = cb0[28].xy * float2(2, 0) + r4.xy;
        r4.z = r5.y;
      }
      r5.yz = r4.xz;
      r0.yz = r5.xz * float2(0.5, -2) + float2(0.5234375, 2.03125);
      r4.xyzw = t2.SampleLevel(s0_s, r0.yz, 0).xyzw;
      r0.y = r4.w * -2.00787401 + 3.25;
      r2.z = -cb0[28].x * r0.y + r5.y;
      r4.xyzw = cb0[28].zzzz * r2.zxzx + -w1.xxxx;
      r4.xyzw = round(r4.xyzw);
      r0.yz = sqrt(abs(r4.wz));
      r5.xyzw = t0.SampleLevel(s0_s, r2.zy, 0, int2(0, 0)).yxzw;
      r5.x = r3.x;
      r1.zw = float2(4, 4) * r5.xy;
      r1.zw = round(r1.zw);
      r0.yz = r1.zw * float2(16, 16) + r0.yz;
      r0.yz = r0.yz * float2(0.00625000009, 0.0017857143) + float2(0.00312500005, 0.000892857148);
      r3.xyzw = t1.SampleLevel(s0_s, r0.yz, 0).xyzw;
      r4.xyzw = cmp(abs(r4.xyzw) >= abs(r4.wzwz));
      r4.xyzw = r4.xyzw ? float4(1, 1, 0.75, 0.75) : 0;
      r0.y = r4.x + r4.y;
      r0.yz = r4.zw / r0.yy;
      r2.w = v1.y;
      r4.xyzw = t0.SampleLevel(s0_s, r2.xw, 0, int2(0, 0)).xyzw;
      r0.w = -r0.y * r4.x + 1;
      r4.xyzw = t0.SampleLevel(s0_s, r2.zw, 0, int2(0, 0)).xyzw;
      r4.x = -r0.z * r4.x + r0.w;
      r5.xyzw = t0.SampleLevel(s0_s, r2.xw, 0, int2(0, 0)).xyzw;
      r0.y = -r0.y * r5.x + 1;
      r2.xyzw = t0.SampleLevel(s0_s, r2.zw, 0, int2(0, 0)).xyzw;
      r4.y = -r0.z * r2.x + r0.y;
      o0.xy = r4.xy * r3.xy;
    } else {
      o0.xy = r1.xy;
      r0.x = 0;
    }
  } else {
    o0.xy = float2(0, 0);
  }
  r0.x = cmp(0 < r0.x);
  if (r0.x != 0) {
    r0.xy = v3.xy;
    r0.z = 1;
    r1.x = 0;
    while (true) {
      r0.w = cmp(v4.z < r0.y);
      r2.x = cmp(0.828100026 < r0.z);
      r0.w = r0.w ? r2.x : 0;
      r2.x = cmp(r1.x == 0.000000);
      r0.w = r0.w ? r2.x : 0;
      if (r0.w == 0) break;
      r1.xyzw = t0.SampleLevel(s0_s, r0.xy, 0).yxzw;
      r0.xy = cb0[28].xy * float2(-0, -2) + r0.xy;
      r0.z = r1.y;
    }
    r1.yz = r0.yz;
    r0.xy = r1.xz * float2(0.5, -2) + float2(0.0078125, 2.03125);
    r0.xyzw = t2.SampleLevel(s0_s, r0.xy, 0).xyzw;
    r0.x = r0.w * -2.00787401 + 3.25;
    r0.x = cb0[28].y * r0.x + r1.y;
    r0.y = v2.x;
    r1.xyzw = t0.SampleLevel(s0_s, r0.yx, 0).xyzw;
    r2.xy = v3.zw;
    r2.z = 1;
    r3.x = 0;
    while (true) {
      r1.x = cmp(r2.y < v4.w);
      r1.z = cmp(0.828100026 < r2.z);
      r1.x = r1.z ? r1.x : 0;
      r1.z = cmp(r3.x == 0.000000);
      r1.x = r1.z ? r1.x : 0;
      if (r1.x == 0) break;
      r3.xyzw = t0.SampleLevel(s0_s, r2.xy, 0).yxzw;
      r2.xy = cb0[28].xy * float2(0, 2) + r2.xy;
      r2.z = r3.y;
    }
    r3.yz = r2.yz;
    r1.xz = r3.xz * float2(0.5, -2) + float2(0.5234375, 2.03125);
    r2.xyzw = t2.SampleLevel(s0_s, r1.xz, 0).xyzw;
    r1.x = r2.w * -2.00787401 + 3.25;
    r0.z = -cb0[28].y * r1.x + r3.y;
    r2.xyzw = cb0[28].wwww * r0.zxzx + -w1.yyyy;
    r2.xyzw = round(r2.xyzw);
    r1.xz = sqrt(abs(r2.wz));
    r3.xyzw = t0.SampleLevel(s0_s, r0.yz, 0, int2(0, 0)).xyzw;
    r3.x = r1.y;
    r1.yw = float2(4, 4) * r3.xy;
    r1.yw = round(r1.yw);
    r1.xy = r1.yw * float2(16, 16) + r1.xz;
    r1.xy = r1.xy * float2(0.00625000009, 0.0017857143) + float2(0.00312500005, 0.000892857148);
    r1.xyzw = t1.SampleLevel(s0_s, r1.xy, 0).xyzw;
    r2.xyzw = cmp(abs(r2.xyzw) >= abs(r2.wzwz));
    r2.xyzw = r2.xyzw ? float4(1, 1, 0.75, 0.75) : 0;
    r0.y = r2.x + r2.y;
    r1.zw = r2.zw / r0.yy;
    r0.w = v1.x;
    r2.xyzw = t0.SampleLevel(s0_s, r0.wx, 0, int2(0, 0)).xyzw;
    r0.y = -r1.z * r2.y + 1;
    r2.xyzw = t0.SampleLevel(s0_s, r0.wz, 0, int2(0, 0)).xyzw;
    r2.z = -r1.w * r2.y + r0.y;
    r3.xyzw = t0.SampleLevel(s0_s, r0.wx, 0, int2(0, 0)).xyzw;
    r0.x = -r1.z * r3.y + 1;
    r3.xyzw = t0.SampleLevel(s0_s, r0.wz, 0, int2(0, 0)).xyzw;
    r2.w = -r1.w * r3.y + r0.x;
    o0.zw = r2.zw * r1.xy;
  } else {
    o0.zw = float2(0, 0);
  }
  return;
}
