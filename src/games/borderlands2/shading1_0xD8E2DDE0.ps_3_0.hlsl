#include "./shared.h"

float4 HFilterAxisCoeff : register( c9 );
float4 HFilterDiagCoeff : register( c8 );
float4 VFilterAxisCoeff : register( c11 );
float4 VFilterDiagCoeff : register( c10 );
sampler2D SceneColorTexture : register( s0 );

struct PS_IN
{
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord3 : TEXCOORD3;
	float2 texcoord4 : TEXCOORD4;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	float4 r4;
	float4 r5;
	float4 r6;

  if (CELL_SHADING == 0) {
	clip(-1.0);
	return float4(0.0, 0.0, 0.0, 0.0);
  } else {		
	r0 = float4(1, 1, 0, 0) * i.texcoord2.xyxx;
	r0 = tex2Dlod(SceneColorTexture, r0);
	r0.x = r0.w;
	r1.x = 1 / sqrt(abs(r0.x));
	r1.x = 1 / r1.x;
	r2 = float4(1, 1, 0, 0) * i.texcoord2.zwxx;
	r2 = tex2Dlod(SceneColorTexture, r2);
	r0.y = r2.w;
	r2.x = 1 / sqrt(abs(r0.y));
	r1.y = 1 / r2.x;
	r2 = float4(1, 1, 0, 0) * i.texcoord3.xyxx;
	r2 = tex2Dlod(SceneColorTexture, r2);
	r0.z = r2.w;
	r2.x = 1 / sqrt(abs(r0.z));
	r1.z = 1 / r2.x;
	r2 = float4(1, 1, 0, 0) * i.texcoord3.zwxx;
	r2 = tex2Dlod(SceneColorTexture, r2);
	r0.w = r2.w;
	r2.x = 1 / sqrt(abs(r0.w));
	r1.w = 1 / r2.x;
	r2 = r1 * 8192;
	r1 = r1 * 32;
	r0 = (-r0 >= 0) ? r1 : r2;
	r1 = float4(1, 1, 0, 0) * i.texcoord4.xyxx;
	r1 = tex2Dlod(SceneColorTexture, r1);
	r1.x = 1 / sqrt(abs(r1.w));
	r1.x = 1 / r1.x;
	r1.xy = r1.x * float2(8192, 32);
	r1.x = (-r1.w >= 0) ? r1.y : r1.x;
	r2 = max(r0, r1.x);
	r0.x = 1 / r1.x;
	r2 = r2 * r0.x + -1;
	r3 = r2 * VFilterAxisCoeff;
	r2 = r2 * HFilterAxisCoeff;
	r4 = float4(1, 1, 0, 0) * i.texcoord.xyxx;
	r4 = tex2Dlod(SceneColorTexture, r4);
	r4.x = r4.w;
	r0.y = 1 / sqrt(abs(r4.x));
	r5.x = 1 / r0.y;
	r6 = float4(1, 1, 0, 0) * i.texcoord.zwxx;
	r6 = tex2Dlod(SceneColorTexture, r6);
	r4.y = r6.w;
	r0.y = 1 / sqrt(abs(r4.y));
	r5.y = 1 / r0.y;
	r6 = float4(1, 1, 0, 0) * i.texcoord1.xyxx;
	r6 = tex2Dlod(SceneColorTexture, r6);
	r4.z = r6.w;
	r0.y = 1 / sqrt(abs(r4.z));
	r5.z = 1 / r0.y;
	r6 = float4(1, 1, 0, 0) * i.texcoord1.zwxx;
	r6 = tex2Dlod(SceneColorTexture, r6);
	r4.w = r6.w;
	r0.y = 1 / sqrt(abs(r4.w));
	r5.w = 1 / r0.y;
	r6 = r5 * 8192;
	r5 = r5 * 32;
	r4 = (-r4 >= 0) ? r5 : r6;
	r5 = max(r4, r1.x);
	r0 = r5 * r0.x + -1;
	r1 = r0 * VFilterDiagCoeff + r3;
	r0 = r0 * HFilterDiagCoeff + r2;
	r0.x = dot(r0, 1);
	r0.y = dot(r1, 1);
	r0.y = r0.y * r0.y;
	r0.x = r0.x * r0.x + r0.y;
	r0.x = 1 / sqrt(r0.x);
	r0.x = 1 / r0.x;
	r0.x = r0.x + -0.100000001;
	r0.x = saturate(r0.x * 1.11111116);
	r0.y = r0.x * -2 + 3;
	r0.x = r0.x * r0.x;
	r0.xyz = r0.y * -r0.x + 1;
	r0.w = -r0.z + 0.956862748;
	o.xyz = r0.xyz;
	o.w = (r0.w >= 0) ? 1 : 0;
	return o;
  }
}
