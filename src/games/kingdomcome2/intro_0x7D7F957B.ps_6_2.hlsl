Texture2D<float4> TexCb : register(t2);

Texture2D<float4> TexCr : register(t1);

Texture2D<float4> TexY : register(t0);

cbuffer CBYCrCbDecode : register(b0, space1) {
  float CBYCrCbDecode_000x : packoffset(c000.x);
  float CBYCrCbDecode_000y : packoffset(c000.y);
  float CBYCrCbDecode_000z : packoffset(c000.z);
  float CBYCrCbDecode_000w : packoffset(c000.w);
  float CBYCrCbDecode_001x : packoffset(c001.x);
  float CBYCrCbDecode_001y : packoffset(c001.y);
  float CBYCrCbDecode_001z : packoffset(c001.z);
  float CBYCrCbDecode_001w : packoffset(c001.w);
  float CBYCrCbDecode_002x : packoffset(c002.x);
  float CBYCrCbDecode_002y : packoffset(c002.y);
  float CBYCrCbDecode_002z : packoffset(c002.z);
  float CBYCrCbDecode_002w : packoffset(c002.w);
  float CBYCrCbDecode_004x : packoffset(c004.x);
};

SamplerState SampStateWrap : register(s3);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float4 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  SV_Target.x = (exp2(((log2(((mad((CBYCrCbDecode_000z), (((float4)(TexCb.Sample(SampStateWrap, float2((TEXCOORD.x), (TEXCOORD.y))))).x), (mad((CBYCrCbDecode_000y), (((float4)(TexCr.Sample(SampStateWrap, float2((TEXCOORD.x), (TEXCOORD.y))))).x), ((CBYCrCbDecode_000x) * (((float4)(TexY.Sample(SampStateWrap, float2((TEXCOORD.x), (TEXCOORD.y))))).x)))))) + (CBYCrCbDecode_000w)))) * (CBYCrCbDecode_004x))));
  SV_Target.y = (exp2(((log2(((mad((CBYCrCbDecode_001z), (((float4)(TexCb.Sample(SampStateWrap, float2((TEXCOORD.x), (TEXCOORD.y))))).x), (mad((CBYCrCbDecode_001y), (((float4)(TexCr.Sample(SampStateWrap, float2((TEXCOORD.x), (TEXCOORD.y))))).x), ((CBYCrCbDecode_001x) * (((float4)(TexY.Sample(SampStateWrap, float2((TEXCOORD.x), (TEXCOORD.y))))).x)))))) + (CBYCrCbDecode_001w)))) * (CBYCrCbDecode_004x))));
  SV_Target.z = (exp2(((log2(((mad((CBYCrCbDecode_002z), (((float4)(TexCb.Sample(SampStateWrap, float2((TEXCOORD.x), (TEXCOORD.y))))).x), (mad((CBYCrCbDecode_002y), (((float4)(TexCr.Sample(SampStateWrap, float2((TEXCOORD.x), (TEXCOORD.y))))).x), ((CBYCrCbDecode_002x) * (((float4)(TexY.Sample(SampStateWrap, float2((TEXCOORD.x), (TEXCOORD.y))))).x)))))) + (CBYCrCbDecode_002w)))) * (CBYCrCbDecode_004x))));
  SV_Target.w = 0.0f;
  SV_Target = saturate(SV_Target);
  return SV_Target;
}
