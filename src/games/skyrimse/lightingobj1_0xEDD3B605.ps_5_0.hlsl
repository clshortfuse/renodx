// ---- Created with 3Dmigoto v1.3.16 on Thu Mar 12 11:31:42 2026
Texture2D<float4> t14 : register(t14);
Texture2D<float4> t6 : register(t6);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);

SamplerState s14_s : register(s14);
SamplerState s6_s : register(s6);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2)
{
  float4 cb2[30];
}

cbuffer cb1 : register(b1)
{
  float4 cb1[9];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[3];
}

cbuffer cb12 : register(b12)
{
  float4 cb12[45];
}

#define cmp -

bool IsWindowTexture() {
  float w, h;
  t0.GetDimensions(w, h);
  if (w != 2048.f || h != 2048.f) return false;

 

  return true;
}
void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD4,
  float4 v3 : TEXCOORD1,
  float4 v4 : TEXCOORD2,
  float4 v5 : TEXCOORD3,
  float4 v6 : TEXCOORD5,
  float4 v7 : TEXCOORD8,
  float4 v8 : TEXCOORD9,
  float3 v9 : TEXCOORD10,
  float4 v10 : POSITION1,
  float4 v11 : POSITION2,
  float4 v12 : COLOR0,
  float4 v13 : COLOR1,
  out float4 o0 : SV_Target0,
  out float4 o1 : SV_Target1,
  out float4 o2 : SV_Target2)
{
  const float4 icb[] = { { 1.000000, 0, 0, 0},
                              { 0, 1.000000, 0, 0},
                              { 0, 0, 1.000000, 0},
                              { 0, 0, 0, 1.000000} };
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = dot(v6.xyz, v6.xyz);
  r0.x = rsqrt(r0.x);
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r2.xyzw = t1.Sample(s1_s, v1.xy).xyzw;
  r0.yzw = r2.xyz * float3(2,2,2) + float3(-1,-1,-1);
  r2.x = min(7, cb2[29].x);
  r3.x = dot(v3.xyz, r0.yzw);
  r3.y = dot(v4.xyz, r0.yzw);
  r3.z = dot(v5.xyz, r0.yzw);
  r2.y = dot(r3.xyz, r3.xyz);
  r2.y = rsqrt(r2.y);
  r3.xyz = r3.xyz * r2.yyy;
  r2.yz = cb12[44].xy * v0.xy;
  r2.yz = r2.yz * cb0[2].xy + cb0[2].zw;
  r2.yz = cb12[43].xy * r2.yz;
  r2.yz = max(float2(0,0), r2.yz);
  r4.x = min(cb12[44].z, r2.y);
  r4.y = min(cb12[43].y, r2.z);
  r4.xyzw = t14.Sample(s14_s, r4.xy).xyzw;
  r5.xyz = cb2[1].xyz * r4.xxx;
  r2.y = saturate(dot(r3.xyz, cb2[0].xyz));
  r6.xyz = r5.xyz * r2.yyy;
  r7.xyz = v6.xyz * r0.xxx + cb2[0].xyz;
  r2.y = dot(r7.xyz, r7.xyz);
  r2.y = rsqrt(r2.y);
  r7.xyz = r7.xyz * r2.yyy;
  r2.y = saturate(dot(r7.xyz, r3.xyz));
  r2.y = log2(r2.y);
  r2.y = cb1[4].w * r2.y;
  r2.y = exp2(r2.y);
  r5.xyz = r5.xyz * r2.yyy;
  r2.y = cmp(0 < r2.x);
  if (r2.y != 0) {
    r2.y = min(4, cb2[29].y);
    r7.xyz = r6.xyz;
    r8.xyz = r5.xyz;
    r2.z = 0;
    while (true) {
      r5.w = cmp(r2.z >= r2.x);
      if (r5.w != 0) break;
      r5.w = cmp(r2.z < r2.y);
      if (r5.w != 0) {
        r5.w = (uint)r2.z;
        r5.w = dot(cb2[2].xyzw, icb[r5.w+0].xyzw);
        r5.w = (uint)r5.w;
        r5.w = dot(r4.xyzw, icb[r5.w+0].xyzw);
      } else {
        r5.w = 1;
      }
      r6.w = (int)r2.z;
      r9.xyz = cb2[r6.w+15].xyz + -v2.xyz;
      r7.w = dot(r9.xyz, r9.xyz);
      r8.w = sqrt(r7.w);
      r8.w = saturate(r8.w / cb2[r6.w+15].w);
      r8.w = -r8.w * r8.w + 1;
      r10.xyz = cb2[r6.w+22].xyz * r5.www;
      r5.w = rsqrt(r7.w);
      r9.xyz = r9.xyz * r5.www;
      r5.w = saturate(dot(r3.xyz, r9.xyz));
      r11.xyz = r10.xyz * r5.www;
      r9.xyz = v6.xyz * r0.xxx + r9.xyz;
      r5.w = dot(r9.xyz, r9.xyz);
      r5.w = rsqrt(r5.w);
      r9.xyz = r9.xyz * r5.www;
      r5.w = saturate(dot(r9.xyz, r3.xyz));
      r5.w = log2(r5.w);
      r5.w = cb1[4].w * r5.w;
      r5.w = exp2(r5.w);
      r9.xyz = r10.xyz * r5.www;
      r8.xyz = r9.xyz * r8.www + r8.xyz;
      r7.xyz = r11.xyz * r8.www + r7.xyz;
      r2.z = 1 + r2.z;
    }
    r6.xyz = r7.xyz;
    r5.xyz = r8.xyz;
  }
  r2.xyz = t6.Sample(s6_s, v1.xy).xyz;
  r3.w = 1;
  r4.x = dot(cb2[11].xyzw, r3.xyzw);
  r4.y = dot(cb2[12].xyzw, r3.xyzw);
  r4.z = dot(cb2[13].xyzw, r3.xyzw);
  r2.xyz = cb2[4].yzw * r2.xyz + r4.xyz;
  r2.xyz = r2.xyz + r6.xyz;
  r2.xyz = cb1[8].yzw * cb1[8].xxx + r2.xyz;
  r1.xyz = r2.xyz * r1.xyz;
  r2.xyz = v12.xyz * r1.xyz;
  r3.x = dot(cb12[12].xyzw, v10.xyzw);
  r3.y = dot(cb12[13].xyzw, v10.xyzw);
  r0.x = dot(cb12[15].xyzw, v10.xyzw);
  r3.xy = r3.xy / r0.xx;
  r4.x = dot(cb12[16].xyzw, v11.xyzw);
  r4.y = dot(cb12[17].xyzw, v11.xyzw);
  r0.x = dot(cb12[19].xyzw, v11.xyzw);
  r3.zw = r4.xy / r0.xx;
  r3.xy = r3.xy + -r3.zw;
  r3.xy = float2(-0.5,0.5) * r3.xy;
  r4.xyz = r5.xyz * r2.www;
  r4.xyz = cb2[3].yyy * r4.xyz;
  r1.xyz = -r1.xyz * v12.xyz + v13.xyz;
  r1.xyz = v13.www * r1.xyz + r2.xyz;
  r1.xyz = -r1.xyz * cb0[0].www + r2.xyz;
  r1.xyz = r1.xyz * cb12[42].yyy + cb0[1].xxx;
  r1.xyz = min(r2.xyz, r1.xyz);
  r1.xyz = r4.xyz * cb1[4].xyz + r1.xyz;
  r2.xyz = v13.xyz + -r1.xyz;
  r2.xyz = v13.www * r2.xyz + r1.xyz;
  r2.xyz = -r2.xyz * cb0[0].www + r1.xyz;
  r4.xyz = cb12[42].yyy * r2.xyz;
  r2.xyz = r2.xyz * cb12[42].yyy + cb0[1].zzz;
  r1.xyz = min(r2.xyz, r1.xyz);
  r0.x = cb2[3].z * r1.w;
  o0.w = v12.w * r0.x;

  // Original final color output (reconstructed)
  o0.xyz = -r4.xyz * cb12[42].zzz + r1.xyz;
  if (!IsWindowTexture()) {
    float3 color = o0.xyz;
    float lum = dot(color, float3(0.2125f, 0.7154f, 0.0721f));
    float boost = lerp(3.0f, 20.0f, saturate(lum));

    // Boost luminance only, preserve saturation
    float3 boosted = color * (boost * lum) / max(lum, 0.001f);

    // Blend between full-color boost and lum-only boost
    o0.xyz = lerp(color * boost, boosted, 0.3f);
    o0.xyz = o0.xyz / (1.0f + o0.xyz * 0.15f);
}
  r0.x = cmp(9.99999975e-006 < cb2[7].z);
  o1.xy = r0.xx ? float2(1,0) : r3.xy;
  r1.x = dot(v7.xyz, r0.yzw);
  r1.y = dot(v8.xyz, r0.yzw);
  r1.z = dot(v9.xyz, r0.yzw);
  r0.x = dot(r1.xyz, r1.xyz);
  r0.x = rsqrt(r0.x);
  r0.xyz = r1.xyz * r0.xxx;
  r0.w = -9.99999975e-006 + cb2[7].x;
  r1.x = cb2[7].y + -r0.w;
  r0.w = r2.w + -r0.w;
  r1.x = 1 / r1.x;
  r0.w = saturate(r1.x * r0.w);
  r1.x = r0.w * -2 + 3;
  r0.w = r0.w * r0.w;
  r0.w = r1.x * r0.w;
  o2.w = cb2[7].w * r0.w;
  r0.z = r0.z * -8 + 8;
  r0.z = sqrt(r0.z);
  r0.z = max(0.00100000005, r0.z);
  r0.xy = r0.xy / r0.zz;
  o2.xy = float2(0.5,0.5) + r0.xy;
  o1.zw = float2(0,1);
  o2.z = 0;
  return;
}