cbuffer cb2 : register(b2) {
  float4 cb2[1];
}

struct VSOutput {
  float4 position : SV_POSITION0;
  float2 texcoord : TEXCOORD0;
};

VSOutput main(uint vertex_id : SV_VertexID) {
  VSOutput output;

  const float2 size = max(cb2[0].xy, 1.f);

  // dgVoodoo's HDR path can leave this copy pass with only one visible
  // triangle. Emit a canonical fullscreen triangle and keep TEXCOORD0 in
  // pixel units because the paired pixel shader uses Texture2D.Load().
  if (vertex_id == 0u) {
    output.position = float4(-1.f, 1.f, 0.f, 1.f);
    output.texcoord = float2(0.f, 0.f);
  } else if (vertex_id == 1u) {
    output.position = float4(3.f, 1.f, 0.f, 1.f);
    output.texcoord = float2(size.x * 2.f, 0.f);
  } else {
    output.position = float4(-1.f, -3.f, 0.f, 1.f);
    output.texcoord = float2(0.f, size.y * 2.f);
  }

  return output;
}
