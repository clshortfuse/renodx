// ---- Created with 3Dmigoto v1.4.1 on Sat Jan 24 04:33:32 2026
Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2)
{
  float4 cb2[36];
}

cbuffer cb1 : register(b1)
{
  float4 cb1[1];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[85];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float o0 : SV_Target0)
{
  const float4 icb[] = { { 1.000000, 0, 0, 0},
                              { 0, 1.000000, 0, 0},
                              { 0, 0, 1.000000, 0},
                              { 0, 0, 0, 1.000000},
                              { -1, -1, -0.942016, -0.399062},
                              { -1, 1, 0.945586, -0.768907},
                              { 1, -1, -0.094184, -0.929389},
                              { 1, 1, 0.344959, 0.293878},
                              { 0, 0, -0.915886, 0.457714},
                              { 0, 0, -0.815442, -0.879125},
                              { 0, 0, -0.382775, 0.276768},
                              { 0, 0, 0.974844, 0.756484},
                              { 0, 0, 0.443233, -0.975116},
                              { 0, 0, 0.537430, -0.473734},
                              { 0, 0, -0.264969, -0.418930},
                              { 0, 0, 0.791975, 0.190902},
                              { 0, 0, -0.241888, 0.997065},
                              { 0, 0, -0.814100, 0.914376},
                              { 0, 0, 0.199841, 0.786414},
                              { 0, 0, 0.143832, -0.141008} };
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  float4 x0[16];
  r0.xy = (uint2)v0.xy;
  r0.zw = (uint2)r0.xy << int2(2,2);
  r0.zw = (uint2)r0.zw;
  r0.zw = cb0[82].zw * r0.zw;
  r1.xyzw = t0.Gather(s0_s, r0.zw).xyzw;
  r1.xyzw = cb0[84].zzzz * r1.wzxy + cb0[84].wwww;
  r1.xyzw = float4(1,1,1,1) / r1.xyzw;
  x0[0].x = r1.x;
  x0[4].x = r1.y;
  x0[1].x = r1.z;
  x0[5].x = r1.w;
  bitmask.x = ((~(-1 << 30)) << 2) & 0xffffffff;  r1.x = (((uint)r0.x << 2) & bitmask.x) | ((uint)0 & ~bitmask.x);
  bitmask.y = ((~(-1 << 30)) << 2) & 0xffffffff;  r1.y = (((uint)r0.y << 2) & bitmask.y) | ((uint)2 & ~bitmask.y);
  bitmask.z = ((~(-1 << 30)) << 2) & 0xffffffff;  r1.z = (((uint)r0.x << 2) & bitmask.z) | ((uint)2 & ~bitmask.z);
  bitmask.w = ((~(-1 << 30)) << 2) & 0xffffffff;  r1.w = (((uint)r0.y << 2) & bitmask.w) | ((uint)0 & ~bitmask.w);
  r1.xyzw = (uint4)r1.xyzw;
  r1.xyzw = cb0[82].zwzw * r1.xyzw;
  r2.xyzw = t0.Gather(s0_s, r1.xy).xyzw;
  r2.xyzw = cb0[84].zzzz * r2.wzxy + cb0[84].wwww;
  r2.xyzw = float4(1,1,1,1) / r2.xyzw;
  x0[2].x = r2.x;
  x0[6].x = r2.y;
  x0[3].x = r2.z;
  x0[7].x = r2.w;
  r1.xyzw = t0.Gather(s0_s, r1.zw).xyzw;
  r1.xyzw = cb0[84].zzzz * r1.wzxy + cb0[84].wwww;
  r1.xyzw = float4(1,1,1,1) / r1.xyzw;
  x0[8].x = r1.x;
  x0[12].x = r1.y;
  x0[9].x = r1.z;
  x0[13].x = r1.w;
  bitmask.x = ((~(-1 << 30)) << 2) & 0xffffffff;  r0.x = (((uint)r0.x << 2) & bitmask.x) | ((uint)2 & ~bitmask.x);
  bitmask.y = ((~(-1 << 30)) << 2) & 0xffffffff;  r0.y = (((uint)r0.y << 2) & bitmask.y) | ((uint)2 & ~bitmask.y);
  r0.xy = (uint2)r0.xy;
  r0.zw = cb0[82].zw * r0.xy;
  r1.xyzw = t0.Gather(s0_s, r0.zw).xyzw;
  r1.xyzw = cb0[84].zzzz * r1.wzxy + cb0[84].wwww;
  r1.xyzw = float4(1,1,1,1) / r1.xyzw;
  x0[10].x = r1.x;
  x0[14].x = r1.y;
  x0[11].x = r1.z;
  x0[15].x = r1.w;
  r1.z = -1;
  r2.xyzw = float4(0,0,0,0);
  r1.xyw = float3(0,0,1.40129846e-45);
  while (true) {
    r3.x = cmp((int)r1.w < 3);
    if (r3.x != 0) {
      r3.x = (uint)r1.w << 2;
      r3.yz = float2(0,0);
      r4.xy = r1.yx;
      r3.w = r2.x;
      r4.z = r2.y;
      r4.w = 1;
      while (true) {
        r5.x = cmp((int)r4.w < 3);
        if (r5.x != 0) {
          r5.x = (int)r3.x + (int)r4.w;
          r5.x = x0[r5.x+0].x;
          r6.xy = r3.yz;
          r6.z = 0;
          while (true) {
            r5.y = cmp((int)r6.z < 4);
            if (r5.y != 0) {
              r5.y = (int)r4.w + (int)icb[r6.z+4].y;
              r5.z = cmp((uint)r6.z < 2);
              r5.z = r5.z ? -1 : 1;
              r5.z = (int)r1.w + (int)r5.z;
              r5.z = (uint)r5.z << 2;
              r5.y = (int)r5.y + (int)r5.z;
              r5.y = x0[r5.y+0].x;
              r5.y = r5.x + -r5.y;
              r5.y = cmp(5 < abs(r5.y));
              if (r5.y != 0) {
                r6.xy = float2(-1,0.5);
                break;
              }
              r6.z = (int)r6.z + 1;
              continue;
            } else {
              r6.xy = r4.yx;
              break;
            }
          }
          r4.xy = r6.yx;
          if (r4.y != 0) {
            r3.w = -1;
            r4.z = r4.x;
            break;
          }
          r4.w = (int)r4.w + 1;
          r3.yz = r4.yx;
          continue;
        } else {
          r3.w = r4.y;
          r4.z = r4.x;
          break;
        }
      }
      r1.x = r3.w;
      r1.y = r4.z;
      if (r1.x != 0) {
        r2.zw = r1.yz;
        break;
      }
      r1.w = (int)r1.w + 1;
      r2.xy = r1.xy;
      continue;
    } else {
      r2.zw = r1.yx;
      break;
    }
  }
  if (r2.w == 0) {
    r1.x = (int)cb2[35].x;
    r1.x = cmp(0 < (int)r1.x);
    if (r1.x != 0) {
      r1.xy = r0.zw * float2(2,2) + float2(-1,-1);
      r1.zw = float2(0.5,0.5) + r0.xy;
      r1.zw = cb0[82].zw * r1.zw;
      r1.z = t0.SampleLevel(s0_s, r1.zw, 0).x;
      r3.xyzw = cb0[25].xyzw * -r1.yyyy;
      r3.xyzw = cb0[24].xyzw * r1.xxxx + r3.xyzw;
      r1.xyzw = cb0[26].xyzw * r1.zzzz + r3.xyzw;
      r1.xyzw = cb0[27].xyzw + r1.xyzw;
      r1.xyz = r1.xyz / r1.www;
      r0.zw = t2.SampleLevel(s1_s, r0.zw, 0).xy;
      r2.xyw = ddy_coarse(r1.zxy);
      r3.xyz = ddx_coarse(r1.yzx);
      r4.xyz = r3.xyz * r2.xyw;
      r2.xyw = r2.wxy * r3.yzx + -r4.xyz;
      r1.w = dot(r2.xyw, r2.xyw);
      r1.w = max(1.17549435e-38, r1.w);
      r1.w = rsqrt(r1.w);
      r2.xyw = r2.xyw * r1.www;
      r3.xyz = -cb2[20].xyz + r1.xyz;
      r4.xyz = -cb2[21].xyz + r1.xyz;
      r5.xyz = -cb2[22].xyz + r1.xyz;
      r6.xyz = -cb2[23].xyz + r1.xyz;
      r3.x = dot(r3.xyz, r3.xyz);
      r3.y = dot(r4.xyz, r4.xyz);
      r3.z = dot(r5.xyz, r5.xyz);
      r3.w = dot(r6.xyz, r6.xyz);
      r4.x = cmp(r3.x < cb2[20].w);
      r4.y = cmp(r3.y < cb2[21].w);
      r4.z = cmp(r3.z < cb2[22].w);
      r4.w = cmp(r3.w < cb2[23].w);
      r5.xyzw = r4.xyzw ? float4(1,1,1,1) : 0;
      r4.xyz = r4.xyz ? float3(-1,-1,-1) : float3(-0,-0,-0);
      r4.xyz = r5.yzw + r4.xyz;
      r5.yzw = max(float3(0,0,0), r4.xyz);
      r1.w = dot(r5.xyzw, float4(4,3,2,1));
      r1.w = 4 + -r1.w;
      r1.w = max(0, r1.w);
      r1.w = min(3, r1.w);
      r4.x = 1 + r1.w;
      r4.x = min(3, r4.x);
      r4.x = (uint)r4.x;
      r4.y = dot(r3.yzw, icb[r4.x+0].yzw);
      r4.x = r4.y / cb2[r4.x+20].w;
      r4.y = cmp(r4.x >= 0);
      r4.x = cmp(1 >= r4.x);
      r4.x = r4.x ? r4.y : 0;
      if (r4.x != 0) {
        r4.x = (uint)r1.w;
        r0.xy = float2(2.08299994,4.8670001) + r0.xy;
        r0.x = dot(r0.xy, float2(0.0671105608,0.00583714992));
        r0.x = frac(r0.x);
        r0.x = 52.9829178 * r0.x;
        r0.x = frac(r0.x);
        r0.y = dot(r3.xyzw, icb[r4.x+0].xyzw);
        r0.y = r0.y / cb2[r4.x+20].w;
        r0.y = sqrt(r0.y);
        r0.y = -0.899999976 + r0.y;
        r0.y = 12 * r0.y;
        r0.x = cmp(r0.y >= r0.x);
        r0.x = r0.x ? 1.000000 : 0;
        r1.w = r1.w + r0.x;
      }
      r0.x = dot(r2.xyw, cb1[0].xyz);
      r0.x = max(0, r0.x);
      r0.x = min(0.899999976, r0.x);
      r0.x = 1 + -r0.x;
      r0.y = (uint)r1.w;
      r3.x = (uint)r0.y << 2;
      r0.xy = cb2[r0.y+24].xy * r0.xx;
      r0.z = cmp(r0.z >= 0.999989986);
      r0.z = r0.z ? 1.000000 : 0;
      r0.z = r0.z * r0.w;
      r0.z = 4 * r0.z;
      r0.x = max(r0.x, r0.z);
      r0.xzw = -cb1[0].xyz * r0.xxx + r1.xyz;
      r0.xyz = r2.xyw * r0.yyy + r0.xzw;
      r1.xyz = cb2[r3.x+1].xyz * r0.yyy;
      r0.xyw = cb2[r3.x+0].xyz * r0.xxx + r1.xyz;
      r0.xyz = cb2[r3.x+2].xyz * r0.zzz + r0.xyw;
      r0.xyz = cb2[r3.x+3].xyz + r0.xyz;
      r1.xyz = cmp(float3(0,0,0) >= r0.xyz);
      r2.xyw = cmp(r0.xyz >= float3(1,1,1));
      r1.xyz = (int3)r1.xyz | (int3)r2.xyw;
      r0.w = (int)r1.y | (int)r1.x;
      r0.w = (int)r1.z | (int)r0.w;
      r0.w = cmp((int)r0.w == 0);
      r1.x = (int)r0.z & 0x7fffffff;
      r1.x = cmp(0x7f800000 < (uint)r1.x);
      r0.w = (int)r0.w | (int)r1.x;
      if (r0.w != 0) {
        r0.w = (int)r1.w;
        r0.xy = r0.xy * cb2[r0.w+28].zw + cb2[r0.w+28].xy;
        r0.w = dot(cb2[33].xyzw, icb[r0.w+0].xyzw);
        r1.xyz = float3(0,0,0);
        while (true) {
          r1.w = cmp((uint)r1.z >= 16);
          if (r1.w != 0) break;
          r2.x = dot(icb[r1.z+4].zw, float2(-0.313973814,0.949431717));
          r2.y = dot(icb[r1.z+4].zw, float2(-0.949431717,-0.313973814));
          r2.xy = r2.xy * r0.ww + r0.xy;
          r3.xyzw = t1.Gather(s1_s, r2.xy).xyzw;
          r3.xyzw = r3.xyzw + -r0.zzzz;
          r4.xyzw = cmp(r3.xyzw >= float4(0,0,0,0));
          r4.xyzw = r4.xyzw ? float4(1,1,1,1) : 0;
          r1.w = dot(r4.xyzw, float4(1,1,1,1));
          r2.x = r1.x + r1.w;
          r1.w = dot(r3.xyzw, r4.xyzw);
          r2.y = r1.y + r1.w;
          r1.w = (int)r1.z + 1;
          r1.xy = r2.xy;
          r1.xyz = r1.xyw;
          continue;
        }
        r0.x = r1.x * 0.03125 + -1;
        r0.y = cmp(0 < r0.x);
        r0.w = cmp(r0.x < 0);
        r0.y = (int)-r0.y + (int)r0.w;
        r0.y = (int)r0.y;
        r0.x = -r0.y * r0.x + 1;
        r0.w = r0.x * r0.x;
        r1.z = r0.w * r0.x;
        r1.x = 1 / r1.x;
        r1.x = r1.y * r1.x;
        r0.z = 1 / r0.z;
        r0.z = saturate(r1.x * r0.z);
        r0.x = -r0.w * r0.x + r0.x;
        r0.x = r0.z * r0.x + r1.z;
        r0.x = 1 + -r0.x;
        r0.x = r0.x * r0.y;
        o0.x = -r0.x * 0.5 + 0.5;
      } else {
        o0.x = 1;
      }
    } else {
      o0.x = cb2[35].z;
    }
  } else {
    o0.x = r2.z;
  }
  return;
}