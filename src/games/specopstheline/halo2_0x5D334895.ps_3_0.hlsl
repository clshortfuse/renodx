struct PS_IN
{
	float2 texcoord : TEXCOORD;
	float2 texcoord1 : TEXCOORD1;
};

float4 main(PS_IN i) : COLOR
{
  clip(-1.0);
  return float4(0.0, 0.0, 0.0, 0.0);
}
