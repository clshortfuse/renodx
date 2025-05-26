float4 BloomTintAndScreenBlendThreshold : register(c0);
float4 ImageAdjustments2 : register(c8);
float4 ImageAdjustments3 : register(c9);
float4 HalfResMaskRect : register(c10);
sampler SceneColorTexture : register(s0);
sampler FilterColor1Texture : register(s1);
sampler ColorGradingLUT : register(s2);
sampler LowResPostProcessBuffer : register(s3);


struct PS_IN {
  float4 texcoord : TEXCOORD;
  float4 texcoord1 : TEXCOORD1;
};

float4 main(PS_IN i) : COLOR {
  float4 o;

  float4 r0;
  float4 r1;
  float4 r2;
  float4 r3;
  r0 = float4(1, 1, 0, 0) * i.texcoord1.xyxx;
  r0 = tex2Dlod(SceneColorTexture, r0);
  return r0;
  r1.xy = max(i.texcoord1.zw, HalfResMaskRect.xy);
  r2.xy = min(HalfResMaskRect.zw, r1.xy);
  r1 = tex2D(LowResPostProcessBuffer, r2.xy);
  r0.xyz = r1.xyz * -4 + r0.xyz;
  r1.xyz = r1.xyz * 4;
  r0.xyz = r1.www * r0.xyz + r1.xyz;
  r1.xyz = min(r0.xyz, 65503);
  r0.x = dot(r1.xyz, 0.3);
  r0.x = r0.x * -3;
  r0.x = exp2(r0.x);
  r0.x = r0.x * BloomTintAndScreenBlendThreshold.w;
  r2 = tex2D(FilterColor1Texture, i.texcoord.zw);
  r0.yzw = r2.xyz * BloomTintAndScreenBlendThreshold.xyz;
  r0.yzw = r0.yzw * 4;
  r0.xyz = r0.yzw * r0.xxx + r1.xyz;
  r1.xyz = r0.xyz + ImageAdjustments2.xxx;
  r2.z = 1 / abs(r1.x);
  r2.w = 1 / abs(r1.y);
  r2.xy = 1 / abs(r1.zz);
  r1 = r0.zzxy * r2;
  r2.xyz = r0.xyz * ImageAdjustments2.www;
  r0 = r0.zzxy + -ImageAdjustments2.z;
  r0 = r0 * 10000;

  r3.x = log2(r2.x);
  r3.y = log2(r2.y);
  r3.z = log2(r2.z);
  r2.xyz = r3.xyz * 0.45454547;
  r3.z = exp2(r2.x);
  r3.w = exp2(r2.y);
  r3.xy = exp2(r2.zz);

  float3 untonemapped = r3.zwx;
  

  r2 = r1.yyzw * ImageAdjustments2.y + -r3.yyzw;
  r0 = r0 * r2 + r3;
  r1 = r1 * ImageAdjustments2.y + -r0.yyzw;
  r0 = saturate(ImageAdjustments3.x * r1 + r0);

  return float4(untonemapped, 1);

  r1.xyw = r0.xwz * float3(14.9999, 0.9375, 0.9375);
  r0.x = frac(r1.x);
  r0.x = -r0.x + r1.x;
  r1.x = r0.x * 0.0625 + r1.w;
  r0.x = r0.y * 15 + -r0.x;
  r1 = r1.xyxy + float4(0.001953125, 0.03125, 0.064453125, 0.03125);
  r2 = tex2D(ColorGradingLUT, r1.xy);
  r1 = tex2D(ColorGradingLUT, r1.zw);
  r3.xyz = lerp(r1.xyz, r2.xyz, r0.xxx);
  o.w = dot(r3.xyz, 0.299);
  o.xyz = r3.xyz;


  return o;
}
