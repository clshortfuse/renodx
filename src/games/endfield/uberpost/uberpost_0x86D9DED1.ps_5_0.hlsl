// ---- Created with 3Dmigoto v1.3.16 on Thu Jul 16 20:38:41 2026
#include "../common.hlsl"
Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1)
{
  float4 cb1[26];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[27];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  const float4 icb[] = { { 0.500000, 0, 0, 0},
                              { 1.000000, 0, 0, 0},
                              { 1.500000, 0, 0, 0},
                              { 2.000000, 0, 0, 0},
                              { 2.500000, 0, 0, 0} };
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.SampleLevel(s1_s, v1.xy, 0).xyzw;
  r1.xy = -cb1[0].xy + v1.xy;
  r1.z = dot(r1.xy, r1.xy);
  r1.z = sqrt(r1.z);
  r1.w = log2(r1.z);
  r1.w = cb1[0].w * r1.w;
  r1.w = exp2(r1.w);
  r1.xy = r1.xy * r1.ww;
  r1.z = max(0.00999999978, r1.z);
  r1.z = 1 / r1.z;
  r1.z = -1 + r1.z;
  r1.z = cb1[25].z * r1.z + 1;
  r1.xy = r1.xy * r1.zz;
  r2.xyz = r0.zxy;
  r1.z = 0;
  while (true) {
    r1.w = cmp((int)r1.z >= 5);
    if (r1.w != 0) break;
    r1.w = icb[r1.z+0].x * cb1[0].z;
    r3.xy = -r1.xy * r1.ww + v1.xy;
    r3.xyz = t0.SampleLevel(s1_s, r3.xy, 0).xyz;
    r3.xyz = r3.xyz + r2.yzx;
    r1.w = (int)r1.z + 1;
    r2.xyz = r3.zxy;
    r1.z = r1.w;
    continue;
  }
  r0.xyz = float3(0.166666672,0.166666672,0.166666672) * r2.xyz;
  r1.xyzw = t1.SampleLevel(s1_s, v1.xy, 0).xyzw;
  r2.w = -cb1[9].z + 1;
  r3.xyz = r2.www * r1.zxy;
  r3.xyz = cmp(float3(0.300000012,0.300000012,0.300000012) < r3.xyz);
  r4.xyz = log2(r1.zxy);
  r4.xyz = float3(0.330000013,0.330000013,0.330000013) * r4.xyz;
  r4.xyz = exp2(r4.xyz);
  r4.xyz = r4.xyz * float3(1.49380004,1.49380004,1.49380004) + float3(-0.699999988,-0.699999988,-0.699999988);
  r2.w = max(r0.y, r0.z);
  r2.w = max(r2.w, r0.x);
  r5.xy = -cb1[10].yx + r2.ww;
  r3.w = max(0, r5.x);
  r3.w = min(cb1[10].z, r3.w);
  r3.w = r3.w * r3.w;
  r3.w = cb1[10].w * r3.w;
  r3.w = max(r3.w, r5.y);
  r2.w = max(9.99999975e-005, r2.w);
  r2.w = r3.w / r2.w;
  r5.xyz = r2.www * r0.xyz;
  r5.xyz = -r5.xyz * cb1[9].zzz + r0.xyz;
  r1.xyz = r3.xyz ? r4.xyz : r1.zxy;
  r1.xyz = r1.xyz * cb1[11].zxy + r5.xyz;
  r1.xyz = -r2.xyz * float3(0.166666672,0.166666672,0.166666672) + r1.xyz;
  r0.xyz = cb1[9].xxx * r1.xyz + r0.xyz;
  o0.w = saturate(r1.w + r0.w);
  r0.w = cb1[16].z + cb1[16].x;
  r1.x = dot(cb1[16].xx, cb1[16].zz);
  r0.w = -r1.x + r0.w;
  r1.xy = -cb1[17].xy + v1.xy;
  r1.xy = float2(-0.5,-0.5) + r1.xy;
  r1.z = r1.x / r1.y;
  r1.w = cmp(abs(r1.z) < 1);
  r2.x = 1 / abs(r1.z);
  r2.x = r1.w ? abs(r1.z) : r2.x;
  r2.y = r2.x * r2.x;
  r2.z = r2.y * 0.0872929022 + -0.301894993;
  r2.y = r2.z * r2.y + 1;
  r2.z = r2.y * r2.x;
  r2.x = -r2.y * r2.x + 1.57079637;
  r1.w = r1.w ? r2.z : r2.x;
  r2.xyz = cb1[7].www * r0.xyz;
  /* Original Code
  r2.xyz = r2.xyz * float3(5.55555582,5.55555582,5.55555582) + float3(0.0479959995,0.0479959995,0.0479959995);
  r2.xyz = max(float3(0,0,0), r2.xyz);
  r2.xyz = log2(r2.xyz);
  r2.xyz = saturate(r2.xyz * float3(0.0734997839,0.0734997839,0.0734997839) + float3(0.386036009,0.386036009,0.386036009));
  r2.yzw = cb1[7].zzz * r2.xyz;
  r0.x = floor(r2.y);
  r3.xy = cb1[7].xy * float2(0.5,0.5);
  r3.yz = r2.zw * cb1[7].xy + r3.xy;
  r3.x = r0.x * cb1[7].y + r3.y;
  r2.yzw = t2.SampleLevel(s1_s, r3.xz, 0).xyz;
  r4.x = cb1[7].y;
  r4.y = 0;
  r3.xy = r4.xy + r3.xz;
  r3.xyz = t2.SampleLevel(s1_s, r3.xy, 0).xyz;
  r0.x = r2.x * cb1[7].z + -r0.x;
  r3.xyz = r3.xyz + -r2.yzw;
  r2.xyz = r0.xxx * r3.xyz + r2.yzw;
  r3.xyz = float3(12.9200001,12.9200001,12.9200001) * r2.xyz;
  r4.xyz = log2(abs(r2.xyz));
  r4.xyz = float3(0.416666657,0.416666657,0.416666657) * r4.xyz;
  r4.xyz = exp2(r4.xyz);
  r4.xyz = r4.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  r2.xyz = cmp(float3(0.00313080009,0.00313080009,0.00313080009) >= r2.xyz);
  */
  LUTSampleResult lut_sample = LUTSAMPLE(s1_s, cb1[7].xyz, t2, r2.yzx);
  float3 graded_linear;
  [branch]
  if (shader_injection.tone_map_type == 0.f) {
    graded_linear = SDRGRADE(lut_sample);
  } else {
    graded_linear = HDRGRADE(lut_sample);
  }
  float3 graded_encoded = renodx::color::srgb::EncodeSafe(graded_linear);
  r0.x = 1 + -r0.w;
  r0.xz = -cb1[16].yy + r0.xw;
  r0.w = cmp(r1.z < 0);
  r0.w = r0.w ? -r1.w : r1.w;
  r1.z = cmp(r1.x >= 0);
  r1.z = r1.z ? 3.1415925 : -3.1415925;
  r1.w = cmp(r1.y < 0);
  r1.w = r1.w ? 1.000000 : 0;
  r0.w = r1.z * r1.w + r0.w;
  r0.w = 3.14159274 + r0.w;
  r5.x = cb1[18].x * r0.w;
  r0.w = dot(r1.xy, r1.xy);
  r0.w = sqrt(r0.w);
  r5.y = cb1[18].y * r0.w;
  r1.xy = r5.xy * float2(0.159154937,2) + cb1[18].zw;
  r1.xy = cb1[17].zw * cb0[20].yy + r1.xy;
  r0.w = t3.SampleBias(s0_s, r1.xy, cb0[26].x).x;
  r0.w = r0.y * r0.w;
  r0.y = cb1[20].y * r0.y;
  r0.y = saturate(r0.w * cb1[20].x + r0.y);
  r0.z = r0.z + -r0.x;
  r0.x = r0.y + -r0.x;
  r0.y = 1 / r0.z;
  r0.x = saturate(r0.x * r0.y);
  r0.y = r0.x * -2 + 3;
  r0.x = r0.x * r0.x;
  r0.z = r0.y * r0.x;
  r1.xyz = graded_encoded;
  r0.x = -r0.y * r0.x + 1;
  r0.xyw = cb1[22].xyz * r0.xxx;
  r0.xyz = cb1[21].xyz * r0.zzz + r0.xyw;
  r0.xyz = r0.xyz + -r1.xyz;
  o0.xyz = cb1[20].www * r0.xyz + r1.xyz;
  o0.xyz = renodx::color::srgb::DecodeSafe(o0.xyz);
  if (CUSTOM_GRAIN_STRENGTH > 0) {
    o0.xyz = renodx::effects::ApplyFilmGrain(
        o0.xyz,
        v1.xy,
        CUSTOM_RANDOM,
        CUSTOM_GRAIN_STRENGTH * 0.03f);
  }
  o0.xyz = renodx::draw::RenderIntermediatePass(o0.xyz);
  return;
}