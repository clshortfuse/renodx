struct VertexOutput {
  float4 position : SV_Position;
};

VertexOutput main(uint vertex_id : SV_VertexID) {
  VertexOutput output;

  output.position = float4(
      vertex_id == 2u ? 3.f : -1.f,
      vertex_id == 1u ? 3.f : -1.f,
      0.f,
      1.f);

  return output;
}