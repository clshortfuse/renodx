#include "./ui_white.hlsli"

cbuffer MapConstants : register(b0) {
  float4 g_SelectionOverlayCol : packoffset(c49);
  float4 ConstantColor_1 : packoffset(c128);
  float4 ConstantTileOffset_2 : packoffset(c129);
  float4 ConstantTileRatio_3 : packoffset(c130);
  float Fogalpha_4 : packoffset(c131);
  float AlphaMul_5 : packoffset(c132);
  float SolidColorBlend_6 : packoffset(c133);
}

SamplerState BaseTexture_0_s : register(s0);
SamplerState AlphaTexture_1_s : register(s1);
SamplerState WaterTexture_2_s : register(s2);
SamplerState FOGTexture_3_s : register(s3);
Texture2D<float4> BaseTexture_0 : register(t0);
Texture2D<float4> AlphaTexture_1 : register(t1);
Texture2D<float4> WaterTexture_2 : register(t2);
Texture2D<float4> FOGTexture_3 : register(t3);


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : COLOR0,
  uint v3 : SV_IsFrontFace0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;

  r0.xyzw = float4(0.00374999992,-0.00374999992,-0.00374999992,0.00374999992) + v1.xyxy;
  r0.z = BaseTexture_0.Sample(BaseTexture_0_s, r0.zw).w;
  r0.x = BaseTexture_0.Sample(BaseTexture_0_s, r0.xy).w;
  r0.y = r0.z + -r0.x;
  r0.x = r0.y * 0.5 + r0.x;
  r1.xyzw = float4(0.00374999992,0.00374999992,-0.00374999992,-0.00374999992) + v1.xyxy;
  r0.y = BaseTexture_0.Sample(BaseTexture_0_s, r1.zw).w;
  r0.z = BaseTexture_0.Sample(BaseTexture_0_s, r1.xy).w;
  r0.y = r0.y + -r0.z;
  r0.y = r0.y * 0.5 + r0.z;
  r0.x = r0.x + -r0.y;
  r0.x = r0.x * 0.5 + r0.y;
  r1.xyzw = float4(0.00249999994,-0.00249999994,-0.00249999994,0.00249999994) + v1.xyxy;
  r0.y = BaseTexture_0.Sample(BaseTexture_0_s, r1.zw).w;
  r0.z = BaseTexture_0.Sample(BaseTexture_0_s, r1.xy).w;
  r0.y = r0.y + -r0.z;
  r0.y = r0.y * 0.5 + r0.z;
  r1.xyzw = float4(0.00249999994,0.00249999994,-0.00249999994,-0.00249999994) + v1.xyxy;
  r0.z = BaseTexture_0.Sample(BaseTexture_0_s, r1.zw).w;
  r0.w = BaseTexture_0.Sample(BaseTexture_0_s, r1.xy).w;
  r0.z = r0.z + -r0.w;
  r0.z = r0.z * 0.5 + r0.w;
  r0.y = r0.y + -r0.z;
  r0.y = r0.y * 0.5 + r0.z;
  r0.x = r0.x + -r0.y;
  r0.x = r0.x * 0.5 + r0.y;
  r0.y = r0.x * 0.149985 + 0.349999994;
  r0.z = 0.999899983 * r0.x;
  r0.w = log2(abs(r0.z));
  r0.w = 10 * r0.w;
  r0.w = exp2(r0.w);
  r0.x = r0.x * 0.999899983 + -r0.w;
  r0.x = sqrt(r0.x);
  r0.x = min(1, r0.x);
  r0.w = FOGTexture_3.Sample(FOGTexture_3_s, v1.xy).y;
  r1.xyzw = BaseTexture_0.Sample(BaseTexture_0_s, v1.xy).xyzw;
  r2.x = 1 + -r1.w;
  r2.x = 0.300000012 * r2.x;
  r0.w = r0.w * r1.w + r2.x;
  r0.x = r0.w * 0.600000024 + r0.x;
  r0.y = r0.y + -r0.x;
  r2.xy = v1.xy * float2(1,-1) + float2(0,1);
  r2.zw = r2.xy * ConstantTileRatio_3.xy + ConstantTileOffset_2.xy;
  r0.w = AlphaTexture_1.Sample(AlphaTexture_1_s, r2.zw).w;
  r2.z = Fogalpha_4 * r0.w;
  r0.x = r2.z * r0.y + r0.x;
  r0.x = r1.w * 0.100000001 + r0.x;
  r0.y = 0.400000006 + -r0.x;
  r0.x = SolidColorBlend_6 * r0.y + r0.x;
  o0.w = AlphaMul_5 * r0.x;
  r0.xy = ConstantTileRatio_3.xy * r2.xy;
  r0.xy = r2.xy * float2(1.25,1.25) + r0.xy;
  r2.xyz = WaterTexture_2.Sample(WaterTexture_2_s, r0.xy).xyz;
  r3.xyz = ConstantColor_1.xyz * v2.xyz;
  r1.xyz = r3.xyz * r1.xyz + -r2.xyz;
  r0.xyz = r0.zzz * r1.xyz + r2.xyz;
  r0.xyz = float3(-0.49019599,-0.564706028,-0.709803998) + r0.xyz;
  r0.xyz = r0.www * r0.xyz + -r2.xyz;
  r0.xyz = float3(0.49019599,0.564706028,0.709803998) + r0.xyz;
  r0.xyz = r1.www * r0.xyz + r2.xyz;
  r1.xyz = float3(1,1,1) + -r0.xyz;
  r0.xyz = SolidColorBlend_6 * r1.xyz + r0.xyz;
  o0.xyz = ScaleRogueUI(g_SelectionOverlayCol.xyz + r0.xyz);
  return;
}