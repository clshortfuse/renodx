struct PS_IN
{
	float2 texcoord : TEXCOORD;
	float4 texcoord4 : TEXCOORD4;
};

float4 main(PS_IN i) : COLOR
{
  clip(-1.0);
  return float4(0.0, 0.0, 0.0, 0.0);
}
