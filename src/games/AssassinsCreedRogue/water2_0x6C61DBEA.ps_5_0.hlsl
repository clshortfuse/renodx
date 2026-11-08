// ---- Created with 3Dmigoto v1.3.16 on Mon May 18 13:09:31 2026
Texture2D<float4> t13 : register(t13);

Texture2D<float4> t12 : register(t12);

Texture2D<float4> t11 : register(t11);

Texture2D<float4> t10 : register(t10);

Texture2D<float4> t9 : register(t9);

Texture2D<float4> t8 : register(t8);

Texture2D<float4> t7 : register(t7);

Texture2D<float4> t5 : register(t5);

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s13_s : register(s13);

SamplerState s12_s : register(s12);

SamplerState s11_s : register(s11);

SamplerState s10_s : register(s10);

SamplerState s9_s : register(s9);

SamplerState s8_s : register(s8);

SamplerState s7_s : register(s7);

SamplerState s5_s : register(s5);

SamplerState s4_s : register(s4);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb5 : register(b5)
{
  float4 cb5[31];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[173];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : COLOR0,
  float4 v4 : COLOR1,
  float4 v5 : TEXCOORD2,
  float4 v6 : TEXCOORD3,
  float4 v7 : TEXCOORD4,
  float4 v8 : TEXCOORD5,
  float4 v9 : TEXCOORD6,
  float3 v10 : TEXCOORD7,
  out float4 o0 : SV_Target0,
  out float2 o1 : SV_Target1)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v0.xy * cb0[19].xy + cb0[19].zw;
  r0.z = dot(v6.xyz, v6.xyz);
  r0.z = rsqrt(r0.z);
  r1.xyz = v6.xyz * r0.zzz;
  r0.z = dot(v7.xyz, v7.xyz);
  r0.z = rsqrt(r0.z);
  r2.xyz = v7.xyz * r0.zzz;
  r0.z = dot(v8.xyz, v8.xyz);
  r0.z = rsqrt(r0.z);
  r3.xyz = v8.xyz * r0.zzz;
  r0.zw = v5.xy * cb0[143].xy + cb0[143].zw;
  r4.xyz = t5.Sample(s5_s, r0.zw).xyz;
  r0.zw = cb0[140].xy * v2.xy;
  r5.xy = ddx_coarse(r0.zw);
  r0.zw = ddy_coarse(r0.zw);
  r0.zw = r0.zw * r0.zw;
  r0.zw = r5.xy * r5.xy + r0.zw;
  r0.zw = sqrt(r0.zw);
  r0.z = max(r0.z, r0.w);
  r0.z = log2(r0.z);
  r0.z = min(cb0[140].z, r0.z);
  r5.xy = cb0[141].xy + v2.xy;
  r5.xyz = t0.SampleLevel(s0_s, r5.xy, r0.z).xyz;
  r5.xyz = r5.xyz * float3(2,2,2) + float3(-1,-1,-1);
  r6.x = v3.x;
  r6.z = 1;
  r5.xyz = r6.xxz * r5.xyz;
  r2.xyz = r5.yyy * r2.xyz;
  r1.xyz = r5.xxx * r1.xyz + r2.xyz;
  r1.xyz = r5.zzz * r3.xyz + r1.xyz;
  r0.z = dot(r1.xyz, r1.xyz);
  r0.z = rsqrt(r0.z);
  r2.xyz = r1.xyz * r0.zzz;
  r1.xyw = cb0[40].xyz + -v5.xyz;
  r0.w = dot(r1.xyw, r1.xyw);
  r3.x = rsqrt(r0.w);
  r3.yzw = r3.xxx * r1.xyw;
  r5.xyzw = cb0[130].xxzz * r2.xyxy;
  r6.x = 1;
  r6.z = v3.x * 0.850000024 + 0.150000006;
  r5.xyzw = r5.xyzw * r6.xxzz + r0.xyxy;
  r5.xyzw = float4(0,0,0,0.0149999997) + r5.xyzw;
  r6.xyz = t7.SampleLevel(s7_s, r5.zw, 0).xyz;

  // Typeless-upgrade safety:
  // Reflection was authored as SDR/gamma-like data. Clamp before squaring
  // so R8G8B8A8_TYPELESS -> R16G16B16A16_FLOAT upgrades do not create fireflies.
  r6.xyz = saturate(r6.xyz);
  r6.xyz = r6.xyz * r6.xyz;
  r6.xyz = cb0[130].yyy * r6.xyz;
  r6.xyz = saturate(r6.xyz * cb0[161].xyz + cb0[162].xyz);
  r5.zw = r0.xy * float2(2,-2) + float2(-1,1);
  r7.xy = v10.xy / v10.zz;
  r5.zw = -r7.xy + r5.zw;
  o1.xy = saturate(r5.zw * float2(4,4) + float2(0.497999996,0.497999996));
  r5.zw = v9.zw * cb0[144].xy + cb0[144].zw;
  r5.zw = t4.Sample(s4_s, r5.zw).yz;
  r4.y = saturate(r4.y + r4.y);
  r4.w = v3.z * r5.w + v4.w;
  r5.z = cb0[134].x * r5.z;
  r7.xyz = t2.Sample(s2_s, v2.zw).xyz;
  r8.x = r5.z * r4.y + r4.w;
  r8.y = 0;
  r8.xyz = t1.Sample(s1_s, r8.xy).xyz;
  r7.xyz = r8.xyz * r7.xyz;
  r4.y = saturate(dot(r7.xyz, float3(1,1,1)));
  r7.xyz = cb0[135].xyz * r4.yyy;
  r8.xyz = cb0[172].xyz + -cb0[142].xyz;
  r8.xyz = r4.xxx * r8.xyz + cb0[142].xyz;
  r4.w = t8.SampleLevel(s8_s, r5.xy, 0).x;
  r4.w = cb0[20].z + r4.w;
  r9.z = cb0[20].w / r4.w;
  r5.zw = cb0[21].xy + float2(-1,1);
  r10.xy = r5.xy * float2(2,-2) + r5.zw;
  r10.xy = cb0[20].xy * r10.xy;
  r9.xy = r10.xy * r9.zz;
  r9.w = 1;
  r10.z = dot(r9.xyzw, cb0[24].xyzw);
  r4.w = -v1.w + -r9.z;
  r4.w = cmp(0 >= r4.w);
  r4.w = r4.w ? 1.000000 : 0;
  r11.xy = -r5.xy + r0.xy;
  r11.xy = r4.ww * r11.xy + r5.xy;
  r11.xyz = t12.Sample(s12_s, r11.xy).xyz;

  // Typeless-upgrade safety:
  // Refraction was authored as SDR/gamma-like data. Clamp before squaring
  // to avoid bright/black/red speckles from out-of-range upgraded values.
  r11.xyz = saturate(r11.xyz);
  r11.xyz = r11.xyz * r11.xyz;
  r6.w = t8.SampleLevel(s8_s, r0.xy, 0).x;
  r6.w = cb0[20].z + r6.w;
  r12.z = cb0[20].w / r6.w;
  r0.xy = r0.xy * float2(2,-2) + r5.zw;
  r0.xy = cb0[20].xy * r0.xy;
  r12.xy = r0.xy * r12.zz;
  r12.w = 1;
  r13.x = dot(r12.xyzw, cb0[22].xyzw);
  r13.y = dot(r12.xyzw, cb0[23].xyzw);
  r13.z = dot(r12.xyzw, cb0[24].xyzw);
  r0.x = -v1.w + -r12.z;
  r0.y = r13.z + -r10.z;
  r0.y = r4.w * r0.y + r10.z;
  r12.xyz = -cb0[40].xyz + r13.xyz;
  r0.y = cb0[40].z + -r0.y;
  r0.y = r0.x * r0.y;
  r4.w = dot(r12.xyz, r12.xyz);
  r4.w = rsqrt(r4.w);
  r0.y = r4.w * r0.y;
  r12.x = cb0[138].x * r0.y;
  r12.y = 1 + -r4.x;
  r12.xyzw = t3.Sample(s3_s, r12.xy).xyzw;
  r0.y = 1 + -r12.w;
  r0.y = max(v3.y, r0.y);
  r4.x = r0.x / cb0[129].x;
  r13.w = saturate(max(r4.x, r0.y));
  r8.xyz = -cb0[132].xyz + r8.xyz;
  r4.xzw = r4.zzz * r8.xyz + cb0[132].xyz;
  r8.xyz = r12.xyz * r11.xyz;
  r0.y = 1 + -r13.w;
  r13.xyz = r4.xzw * r13.www + r7.xyz;
  r4.x = cmp(9.99999975e-005 < cb5[27].w);
  if (r4.x != 0) {
    r0.w = sqrt(r0.w);
    r4.xz = cb5[21].xy + v9.zw;
    r0.z = saturate(r1.z * r0.z + -0.100000001);
    r0.z = dot(r0.zz, r0.zz);
    r0.z = min(1, r0.z);
    r1.z = 1 / cb5[27].x;
    r5.zw = r4.xz * r1.zz;
    r7.xw = r4.xz * r1.zz + -cb5[26].xy;
    r7.yz = r5.wz;
    r1.z = t13.Sample(s13_s, r7.xy).x;
    r4.w = t13.Sample(s13_s, r7.zw).x;
    r7.yz = cb5[28].ww * r4.zx;
    r7.xw = r4.xz * cb5[28].ww + -cb5[26].xy;
    r4.x = t13.Sample(s13_s, r7.xy).x;
    r4.z = t13.Sample(s13_s, r7.zw).x;
    r7.xy = float2(0.0500000007,0.0399999991) * r0.ww;
    r7.xy = min(float2(1,1), r7.xy);
    r0.w = r4.x + -r1.z;
    r11.x = r7.x * r0.w + r1.z;
    r0.w = r4.z + -r4.w;
    r11.y = r7.x * r0.w + r4.w;
    r4.xz = r5.zw * cb5[29].xy + cb5[30].xy;
    r0.w = t9.Sample(s9_s, r4.xz).x;
    r0.w = cb5[29].z + r0.w;
    r1.z = 1 + -r7.y;
    r0.w = r1.z * r0.w;
    r1.z = r13.w * -0.400000006 + 0.800000012;
    r0.w = r1.z * r0.w;
    r11.z = 1;
    r4.xzw = r11.xyz * r0.zzz;
    r4.xzw = cb5[27].www * r4.xzw;
    r4.xzw = r4.xzw * r0.www + r2.xyz;
    r0.z = dot(r4.xzw, r4.xzw);
    r0.z = rsqrt(r0.z);
    r2.xyz = r4.xzw * r0.zzz;
  }
  r0.x = abs(r0.x) * cb0[139].x + cb0[139].y;
  r0.z = cb0[139].z * r4.y;
  r0.w = 1 + -r0.x;
  o0.w = r0.z * r0.w + r0.x;
  r0.x = 1 + -r4.y;
  r0.z = dot(r3.yzw, r2.xyz);
  r0.z = 1 + -r0.z;
  r0.z = min(1, abs(r0.z));
  r0.z = log2(r0.z);
  r0.w = log2(r0.x);
  r0.z = r0.z * cb0[133].x + r0.w;
  r0.z = exp2(r0.z);
  r0.x = v3.w * r0.x;
  r3.yzw = r0.xxx * cb0[136].xyz + v4.xyz;
  r3.yzw = r8.xyz * r0.yyy + r3.yzw;
  r0.x = dot(cb0[151].xyz, cb0[151].xyz);
  r0.x = cmp(r0.x == 0.000000);
  if (r0.x != 0) {
    r4.xyzw = float4(0,0,0,0);
  }
  if (r0.x == 0) {
    r10.x = dot(r9.xyzw, cb0[22].xyzw);
    r10.y = dot(r9.xyzw, cb0[23].xyzw);
    r10.w = dot(r9.xyzw, cb0[25].xyzw);
    r7.x = dot(r10.xyzw, cb0[152].xyzw);
    r7.y = dot(r10.xyzw, cb0[153].xyzw);
    r0.xw = r7.xy / cb0[149].zw;
    r1.z = saturate(abs(r10.z) / cb0[149].x);
    r1.z = 1 + -r1.z;
    r5.z = 1 + -r1.z;
    r5.z = cb0[150].x * r5.z;
    r5.z = round(r5.z);
    r7.xy = cb5[30].xy + r0.xw;
    r7.xyz = t10.SampleLevel(s10_s, r7.xy, r5.z).xyz;
    r5.xyz = t11.Sample(s11_s, r5.xy).xyz;
    r5.xyz = r5.xyz * float3(2,2,2) + float3(-1,-1,-1);
    r5.x = dot(r5.xyz, r5.xyz);
    r5.x = rsqrt(r5.x);
    r5.x = r5.z * r5.x;
    r0.xw = r0.xw * cb5[29].xy + cb5[30].xy;
    r0.x = t9.Sample(s9_s, r0.xw).x;
    r0.x = cb5[29].z + r0.x;
    r0.w = abs(r5.x) * abs(r5.x);
    r0.w = r0.w * r0.w;
    r0.w = r0.w * r0.w;
    r5.xyz = r7.xyz * r0.www;
    r0.w = abs(r10.z) * cb0[158].x + cb0[158].y;
    r0.w = r1.z * r0.w;
    r5.xyz = r5.xyz * r0.www;
    r0.w = dot(r9.xyz, r9.xyz);
    r0.w = sqrt(r0.w);
    r0.w = saturate(r0.w / cb0[149].y);
    r0.w = 1 + -r0.w;
    r5.xyz = r5.xyz * r0.www;
    r5.xyz = cb0[150].yyy * r5.xyz;
    r5.xyz = r5.xyz * r0.xxx;
    r4.xyz = cb0[151].xyz * r5.xyz;
    r4.w = 0;
  }
  r4.xyzw = r4.xyzw * r0.yyyy;
  r4.xyzw = r4.xyzw * r12.xyzw + r13.xyzw;
  // Typeless-upgrade safety:
  // The original shader squares this water/caustic composite, so keep it
  // in SDR range first to avoid amplified float spikes.
  r4.xyz = saturate(r4.xyz);
  r0.xyw = r4.xyz * r4.xyz;
  r1.xyz = r1.xyw * r3.xxx + cb5[22].xyz;
  r1.w = dot(r1.xyz, r1.xyz);
  r1.w = rsqrt(r1.w);
  r1.xyz = r1.xyz * r1.www;
  r4.x = cb0[128].x;
  r4.z = 1;
  r4.xyz = r4.xxz * r2.xyz;
  r1.w = dot(r4.xyz, r4.xyz);
  r1.w = rsqrt(r1.w);
  r4.xyz = r4.xyz * r1.www;
  r1.w = saturate(dot(r4.xyz, r1.xyz));
  r3.x = saturate(dot(r4.xyz, cb5[22].xyz));
  r1.x = dot(cb5[22].xyz, r1.xyz);
  r1.x = 1 + -r1.x;
  r1.y = r1.x * r1.x;
  r1.y = r1.y * r1.y;
  r1.x = r1.x * r1.y;
  r1.x = r1.x * 0.980000019 + 0.0199999996;
  r1.w = max(r1.w, 1e-6);
  r1.y = log2(r1.w);
  r1.y = cb0[147].x * r1.y;
  r1.y = exp2(r1.y);
  r1.y = r3.x * r1.y;
  r1.y = cb0[147].y * r1.y;
  r1.x = r1.y * r1.x;
  r1.y = saturate(dot(r2.xyz, cb0[11].xyz));
  r1.yzw = cb0[10].xyz * r1.yyy;
  r1.yzw = r1.yzw * r0.xyw;
  r1.xyz = cb0[148].xyz * r1.xxx + r1.yzw;
  r4.xyz = r6.xyz + -r1.xyz;
  r1.xyz = r0.zzz * r4.xyz + r1.xyz;
  r2.w = 1;
  r4.x = saturate(dot(cb0[0].xyzw, r2.xyzw));
  r4.y = saturate(dot(cb0[1].xyzw, r2.xyzw));
  r4.z = saturate(dot(cb0[2].xyzw, r2.xyzw));
  r0.xyz = r4.xyz * r0.xyw;
  r0.xyz = r0.xyz * r4.www + r1.xyz;
  r0.xyz = r0.xyz + r3.yzw;
  // Final typeless-upgrade safety before Rogue's original sqrt output encoding.
  r0.xyz = max(r0.xyz, float3(0.0, 0.0, 0.0));

  // Cap before sqrt to prevent fireflies/invalid pixels from upgraded typeless buffers.
  // 16.0 before sqrt still allows up to 4.0 after sqrt, so highlights are not forced SDR.
  r0.xyz = min(r0.xyz, float3(16.0, 16.0, 16.0));

  o0.xyz = sqrt(r0.xyz);
  o0.w = saturate(o0.w);
  return;
}