[shader("vertex")]
void main(uint id: SV_VertexID, out float4 position: SV_Position,
          [[vk::location(0)]] out float2 uv: TEXCOORD0) {
  uv = float2((id == 1) ? 2.f : 0.f, (id == 2) ? 2.f : 0.f);
  position = float4(uv * float2(2.f, -2.f) + float2(-1.f, 1.f), 0.f, 1.f);
}
