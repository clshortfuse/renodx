cbuffer cb0 : register(b0) {
  float4 cb0[1];
}

struct VSOutput {
  float4 position : SV_POSITION0;
  float3 texcoord : TEXCOORD0;
};

VSOutput main(uint vertex_id : SV_VertexID) {
  VSOutput output;

  const float2 size = max(cb0[0].xy, 1.f);

  // In this replacement path SV_VertexID is local to the draw even though the
  // game call reports first_vertex=8. Emit a stable fullscreen triangle; this
  // was the closest variant and avoids the collapsed wedge from game POSITION.
  if (vertex_id == 0u) {
    output.position = float4(-1.f, 1.f, 0.f, 1.f);
    output.texcoord = float3(0.f, 0.f, 0.f);
  } else if (vertex_id == 1u) {
    output.position = float4(3.f, 1.f, 0.f, 1.f);
    output.texcoord = float3(size.x * 2.f, 0.f, 0.f);
  } else {
    output.position = float4(-1.f, -3.f, 0.f, 1.f);
    output.texcoord = float3(0.f, size.y * 2.f, 0.f);
  }

  return output;
}
