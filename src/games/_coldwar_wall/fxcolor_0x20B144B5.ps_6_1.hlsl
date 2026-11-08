// wall probe: solid tint to identify fx draws
float4 main(float4 pos : SV_Position) : SV_Target
{
    return float4(0.50, 0.00, 1.00, 0.6);
}
