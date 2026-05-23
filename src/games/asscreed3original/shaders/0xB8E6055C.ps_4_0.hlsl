// ---- Created with 3Dmigoto v1.3.16 on Wed May 13 19:42:27 2026

cbuffer _Globals : register(b0)
{
  float4 g_FogColor : packoffset(c16);
  float4 g_FogParams : packoffset(c17);
  float4 g_FogWeatherParams : packoffset(c90);
  float4 g_FogSunBackColor : packoffset(c31);
  float Exponent_1 : packoffset(c128);
  float3x3 Transform_2_matrix : packoffset(c129);
  float4 Color_3 : packoffset(c132);
  float NormalStrenght_4 : packoffset(c133);
  float Alpha_5 : packoffset(c134);
  float FalloutScale_6 : packoffset(c135);
  float UsePush_7 : packoffset(c136);
  float FalloutExponent_8 : packoffset(c137);
  float4 Height_9 : packoffset(c138);
  float UseOnFur_10 : packoffset(c139);
  float3x3 Operator122_11_matrix : packoffset(c140);
  float g_AlphaTestValue : packoffset(c113);
  float4 g_EyePosition : packoffset(c12);

  struct
  {
    float m_Alpha;
    float3 m_WorldNormal;
    float3 m_VertexWorldNormal;
    float3 m_TangentSpaceNormal;
    float3 m_WorldPosition;
  } c : packoffset(c143);

}

SamplerState Normal_0_s : register(s0);
SamplerState Patern_1_s : register(s1);
SamplerState Layer0Diffuse_2_s : register(s2);
Texture2D<float4> Normal_0 : register(t0);
Texture2D<float4> Patern_1 : register(t1);
Texture2D<float4> Layer0Diffuse_2 : register(t2);


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
  uint v9 : SV_IsFrontFace0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = v5.xyz;
  r0.w = 0;
  r0.xyzw = g_EyePosition.xyzw + -r0.xyzw;
  r0.w = dot(r0.xyzw, r0.xyzw);
  r0.w = rsqrt(r0.w);
  r0.xyz = r0.xyz * r0.www;
  r0.w = dot(v8.xyz, v8.xyz);
  r0.w = rsqrt(r0.w);
  r1.xyz = v8.xyz * r0.www;
  r0.x = dot(r1.xyz, r0.xyz);
  r0.x = 1 + -r0.x;
  r0.x = log2(abs(r0.x));
  r0.x = 1.5 * r0.x;
  r0.x = exp2(r0.x);
  r1.xyzw = Normal_0.Sample(Normal_0_s, v2.xy).xyzw;
  r0.yz = float2(-0.5,-0.5) + r1.xy;
  r0.yz = r0.yz * float2(2,2) + float2(-0.5,-0.5);
  r1.xyz = Height_9.xyz + -v4.xyz;
  r0.w = dot(r1.xyz, r1.xyz);
  r0.w = sqrt(r0.w);
  r0.w = saturate(FalloutScale_6 * r0.w);
  r0.yz = NormalStrenght_4 * r0.yz + r0.ww;
  r0.w = 1 + -r0.w;
  r0.w = log2(r0.w);
  r0.w = FalloutExponent_8 * r0.w;
  r0.w = exp2(r0.w);
  r0.w = Alpha_5 * r0.w;
  r1.xy = float2(0.5,0.5) + r0.yz;
  r1.z = 1;
  r2.x = dot(r1.xyz, Transform_2_matrix._m00_m10_m20);
  r2.y = dot(r1.xyz, Transform_2_matrix._m01_m11_m21);
  r1.xyzw = Patern_1.Sample(Patern_1_s, r2.xy).xyzw;
  r0.y = log2(abs(r1.y));
  r0.y = Exponent_1 * r0.y;
  r0.y = exp2(r0.y);
  r0.z = r0.y * r0.x;
  r0.x = -r0.y * r0.x + 1;
  r0.x = UsePush_7 * r0.x + r0.z;
  r0.x = r0.w * r0.x;
  r1.xy = v2.xy;
  r1.z = 1;
  r2.x = dot(r1.xyz, Operator122_11_matrix._m00_m10_m20);
  r2.y = dot(r1.xyz, Operator122_11_matrix._m01_m11_m21);
  r0.yz = v3.xy + -r2.xy;
  r0.yz = UseOnFur_10 * r0.yz + r2.xy;
  r1.xyzw = Layer0Diffuse_2.Sample(Layer0Diffuse_2_s, r0.yz).xyzw;
  r0.y = r1.x + -r1.w;
  r0.y = UseOnFur_10 * r0.y + r1.w;
  r0.z = r0.y * r0.x + -g_AlphaTestValue;
  r0.x = r0.y * r0.x;
  o0.w = r0.x;

  // clamp
  o0.w = saturate(o0.w);

  r0.x = cmp(r0.z < 0);
  if (r0.x != 0) discard;
  // This pass was authored for an UNORM render target. Keep the original
  // normalized output contract when the target is upgraded to FP16.
  o0.xyz = saturate(v1.zzz);
  return;
}
