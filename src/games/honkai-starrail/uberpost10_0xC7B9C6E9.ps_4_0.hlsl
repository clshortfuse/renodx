#include "./common.hlsl"
// ---- Created with 3Dmigoto v1.4.1 on Sat Feb 15 00:40:36 2025
Texture2D<float4> t6 : register(t6);

Texture2D<float4> t5 : register(t5);

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1)
{
  float4 cb1[1];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[412];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cb0[410].w;
  r0.z = cb0[411].x;
  r0.xyz = v1.xxy + -r0.xxz;
  r0.w = -cb0[411].x + v1.y;
  r1.x = min(abs(r0.x), abs(r0.w));
  r1.y = max(abs(r0.x), abs(r0.w));
  r1.y = 1 / r1.y;
  r1.x = r1.x * r1.y;
  r1.y = r1.x * r1.x;
  r1.z = r1.y * 0.0208350997 + -0.0851330012;
  r1.z = r1.y * r1.z + 0.180141002;
  r1.z = r1.y * r1.z + -0.330299497;
  r1.y = r1.y * r1.z + 0.999866009;
  r1.z = r1.x * r1.y;
  r1.w = cmp(abs(r0.w) < abs(r0.x));
  r1.z = r1.z * -2 + 1.57079637;
  r1.z = r1.w ? r1.z : 0;
  r1.x = r1.x * r1.y + r1.z;
  r1.y = cmp(r0.w < -r0.w);
  r1.y = r1.y ? -3.141593 : 0;
  r1.x = r1.x + r1.y;
  r1.y = min(r0.x, r0.w);
  r1.z = max(r0.x, r0.w);
  r1.y = cmp(r1.y < -r1.y);
  r1.z = cmp(r1.z >= -r1.z);
  r1.y = r1.z ? r1.y : 0;
  r1.x = r1.y ? -r1.x : r1.x;
  r1.x = r1.x * 0.159154937 + 0.5;
  r0.x = dot(r0.xw, r0.xw);
  r0.x = sqrt(r0.x);
  r0.w = cb0[408].y * r1.x;
  r0.w = 400 * r0.w;
  r0.w = floor(r0.w);
  r1.y = 400 * cb0[408].y;
  r0.w = r0.w / r1.y;
  r1.z = 12345.5645 * r0.w;
  r1.z = sin(r1.z);
  r1.z = 7658.75977 * r1.z;
  r1.z = frac(r1.z);
  r1.x = r1.x + -r0.w;
  r1.x = r1.y * r1.x;
  r1.w = max(0.00999999978, cb0[408].z);
  r1.z = r1.z / r1.w;
  r0.x = r1.z + r0.x;
  r1.z = cb0[408].z * r0.x;
  r1.z = floor(r1.z);
  r1.z = r1.z / cb0[408].z;
  r0.x = -r1.z + r0.x;
  r1.y = cb0[408].z * r0.x;
  r2.xy = float2(-1,-1) + r1.xy;
  r2.xy = saturate(float2(-1.42857146,-3.33333325) * r2.xy);
  r2.zw = r2.xy * float2(-2,-2) + float2(3,3);
  r2.xy = r2.xy * r2.xy;
  r2.xy = r2.zw * r2.xy;
  r1.xy = saturate(float2(1.42857146,3.33333325) * r1.xy);
  r2.zw = r1.xy * float2(-2,-2) + float2(3,3);
  r1.xy = r1.xy * r1.xy;
  r1.xy = r2.zw * r1.xy;
  r1.xy = r2.xy * r1.xy;
  r1.xy = r1.xy * float2(2,2) + float2(-1,-1);
  r1.xy = cb0[410].zz * r1.xy + float2(1,1);
  r2.x = cb0[408].y * r0.w;
  r0.x = cb1[0].x * cb0[410].x + cb0[408].w;
  r2.y = r0.x + r1.z;
  r2.xyzw = t6.Sample(s2_s, r2.xy).xyzw;
  r0.x = 1 + -cb0[409].z;
  r0.w = 1 + -r0.x;
  r0.x = r2.x + -r0.x;
  r0.w = 1 / r0.w;
  r0.x = saturate(r0.x * r0.w);
  r0.w = r0.x * -2 + 3;
  r0.x = r0.x * r0.x;
  r0.y = dot(r0.yz, r0.yz);
  r0.y = sqrt(r0.y);
  r0.z = cb0[409].y + -cb0[409].x;
  r0.y = r0.y * r2.z + -cb0[409].x;
  r0.z = 1 / r0.z;
  r0.y = saturate(r0.y * r0.z);
  r0.z = r0.y * -2 + 3;
  r0.y = r0.y * r0.y;
  r0.xy = r0.wz * r0.xy;
  r0.z = cb0[408].x * 2 + -1;
  r0.z = r2.y + r0.z;
  r0.x = r0.x * r0.y;
  r0.y = cmp(cb0[407].w == 0.000000);
  r0.z = cmp(0.5 < r0.z);
  r0.y = (int)r0.z | (int)r0.y;
  r0.y = r0.y ? 1 : -1;
  r0.x = r0.x * r0.y;
  r0.x = r0.x * r1.y;
  r0.x = r0.x * r1.x;
  r0.yzw = cb0[409].www * cb0[407].zxy;
  r1.x = cb0[410].y * r0.x;
  r1.x = -r1.x * 0.100000001 + 1;
  r1.yz = float2(-0.5,-0.5) + v1.xy;
  r1.xy = r1.yz * r1.xx + float2(0.5,0.5);
  r2.xyzw = r1.xyxy * float4(2,2,2,2) + float4(-1,-1,-1,-1);
  r1.z = dot(r2.zw, r2.zw);
  r2.xyzw = r2.xyzw * r1.zzzz;
  r2.xyzw = cb0[398].zzzz * r2.xyzw;
  r2.xyzw = r2.xyzw * float4(-0.333333343,-0.333333343,-0.666666687,-0.666666687) + r1.xyxy;
  r3.xyzw = t0.SampleLevel(s0_s, r1.xy, 0).xyzw;
  //r3.xyz = max(float3(0,0,0), r3.xyz);
  r4.xyzw = t0.SampleLevel(s0_s, r2.xy, 0).xyzw;
  //r4.xyz = max(float3(0,0,0), r4.xyz);
  r5.xyzw = t0.SampleLevel(s0_s, r2.zw, 0).xyzw;
  //r5.xyz = max(float3(0,0,0), r5.xyz);
  r6.xyzw = t2.Sample(s0_s, r1.xy).xyzw;
  r7.xyzw = t2.Sample(s0_s, r2.xy).xyzw;
  r2.xyzw = t2.Sample(s0_s, r2.zw).xyzw;
  r6.xyz = r6.xyz + -r3.xyz;
  r3.xyz = r6.www * r6.xyz + r3.xyz;
  r6.xyz = r7.xyz + -r4.xyz;
  r4.xyz = r7.www * r6.xyz + r4.xyz;
  r2.xyz = r2.xyz + -r5.xyz;
  r2.xyz = r2.www * r2.xyz + r5.xyz;
  r4.xyz = cb0[400].xyz * r4.xyz;
  r3.xyz = r3.xyz * cb0[399].xyz + r4.xyz;
  r2.xyz = r2.xyz * cb0[401].xyz + r3.xyz;
  r3.xyz = cb0[400].xyz + cb0[399].xyz;
  r3.xyz = cb0[401].xyz + r3.xyz;
  r2.xyz = r2.xyz / r3.xyz;
  r3.xyzw = t1.SampleLevel(s0_s, v1.xy, 0).xyzw;
  r2.xyz = r3.xyz * cb0[117].xxx + r2.xyz;
  r3.xyzw = t3.SampleLevel(s1_s, v1.xy, 0).xyzw;
  r2.xyz = r3.xyz + r2.xyz;
  r1.z = cmp(0 < cb0[110].x);
  if (r1.z != 0) {
    r3.xyzw = t5.SampleLevel(s0_s, v1.xy, 0).xyzw;
    r3.xyz = cb0[110].xxx * r3.xyz;
    r2.xyz = max(r3.xyz, r2.xyz);
  }
  r1.z = cmp(0 != cb0[32].y);
  if (r1.z != 0) {
    r1.xy = -cb0[406].xy + r1.xy;
    r1.yz = cb0[406].zz * abs(r1.xy);
    r1.x = cb0[405].w * r1.y;
    r1.x = dot(r1.xz, r1.xz);
    r1.x = 1 + -r1.x;
    r1.x = max(0, r1.x);
    r1.x = log2(r1.x);
    r1.x = cb0[406].w * r1.x;
    r1.x = exp2(r1.x);
    r1.yzw = float3(1,1,1) + -cb0[405].xyz;
    r1.xyz = r1.xxx * r1.yzw + cb0[405].xyz;
    r1.w = dot(v0.xy, float2(0.0671105608,0.00583714992));
    r1.w = frac(r1.w);
    r1.w = 52.9829178 * r1.w;
    r1.w = frac(r1.w);
    r1.w = 5 * r1.w;
    r1.w = floor(r1.w);
    r1.w = -2 + r1.w;
    r3.x = r1.w * 0.00392156886 + r1.x;
    r4.xyzw = float4(2.08299994,4.8670001,4.16599989,9.73400021) + v0.xyxy;
    r1.x = dot(r4.xy, float2(0.0671105608,0.00583714992));
    r1.x = frac(r1.x);
    r1.x = 52.9829178 * r1.x;
    r1.x = frac(r1.x);
    r1.x = 5 * r1.x;
    r1.x = floor(r1.x);
    r1.x = -2 + r1.x;
    r3.y = r1.x * 0.00392156886 + r1.y;
    r1.x = dot(r4.zw, float2(0.0671105608,0.00583714992));
    r1.x = frac(r1.x);
    r1.x = 52.9829178 * r1.x;
    r1.x = frac(r1.x);
    r1.x = 5 * r1.x;
    r1.x = floor(r1.x);
    r1.x = -2 + r1.x;
    r3.z = r1.x * 0.00392156886 + r1.z;
    r2.xyz = r3.xyz * r2.xyz;
  }
  
  float3 untonemapped = r2.rgb;

  float3 output = applyUserTonemap(untonemapped);
  renodx::lut::Config lut_config = renodx::lut::config::Create(
      s0_s, 1.f, 0.f,
      renodx::lut::config::type::ARRI_C1000_NO_CUT,
      renodx::lut::config::type::LINEAR);

  float3 sampled = renodx::lut::Sample(t4, lut_config, untonemapped);
  output = renodx::tonemap::UpgradeToneMap(output, saturate(output), sampled, 1.f);

  o0.rgb = output;
  o0.rgb = renodx::color::bt709::clamp::AP1(o0.rgb);
  o0.rgb = PostToneMapScale(o0.rgb);

  o0.w = 1;
  return;
  r0.xyz = r0.xxx * r0.yzw + r2.zxy;
  r0.xyz = r0.xyz * float3(5.55555582,5.55555582,5.55555582) + float3(0.0479959995,0.0479959995,0.0479959995);
  r0.xyz = log2(r0.xyz);
  r0.xyz = saturate(r0.xyz * float3(0.0734997839,0.0734997839,0.0734997839) + float3(0.386036009,0.386036009,0.386036009));
  r0.yzw = cb0[42].zzz * r0.xyz;
  r0.y = floor(r0.y);
  r1.xy = float2(0.5,0.5) * cb0[42].xy;
  r1.yz = r0.zw * cb0[42].xy + r1.xy;
  r1.x = r0.y * cb0[42].y + r1.y;
  r2.xyzw = t4.SampleLevel(s0_s, r1.xz, 0).xyzw;
  r3.x = cb0[42].y;
  r3.y = 0;
  r0.zw = r3.xy + r1.xz;
  r1.xyzw = t4.SampleLevel(s0_s, r0.zw, 0).xyzw;
  r0.x = r0.x * cb0[42].z + -r0.y;
  r0.yzw = r1.xyz + -r2.xyz;
  r0.xyz = r0.xxx * r0.yzw + r2.xyz;
  r1.xyz = saturate(r0.xyz);
  o0.w = dot(r1.xyz, float3(0.212672904,0.715152204,0.0721750036));
  r1.xyz = cmp(float3(0,0,0) < r0.xyz);
  r2.xyz = cmp(r0.xyz < float3(0,0,0));
  r1.xyz = (int3)-r1.xyz + (int3)r2.xyz;
  r1.xyz = (int3)r1.xyz;
  r2.xyz = float3(12.9200001,12.9200001,12.9200001) * abs(r0.xyz);
  r3.xyz = log2(abs(r0.xyz));
  r3.xyz = float3(0.416666657,0.416666657,0.416666657) * r3.xyz;
  r3.xyz = exp2(r3.xyz);
  r3.xyz = r3.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  r0.xyz = cmp(float3(0.00313080009,0.00313080009,0.00313080009) >= abs(r0.xyz));
  r0.xyz = r0.xyz ? r2.xyz : r3.xyz;
  o0.xyz = r1.xyz * r0.xyz;
  return;
}