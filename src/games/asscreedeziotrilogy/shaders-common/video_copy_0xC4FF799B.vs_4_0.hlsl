cbuffer cb2 : register(b2) {
  float4 cb2[1];
}

struct VSOutput {
  float4 position : SV_POSITION0;
  float2 texcoord : TEXCOORD0;
};

VSOutput main(uint vertex_id : SV_VertexID) {
  VSOutput output;

  // dgVoodoo's HDR path can leave this copy pass with only one visible
  // triangle. Emit a canonical fullscreen triangle and normalized TEXCOORD0
  // so the paired pixel shader can sample with filtering.
  if (vertex_id == 0u) {
    output.position = float4(-1.f, 1.f, 0.f, 1.f);
    output.texcoord = float2(0.f, 0.f);
  } else if (vertex_id == 1u) {
    output.position = float4(3.f, 1.f, 0.f, 1.f);
    output.texcoord = float2(2.f, 0.f);
  } else {
    output.position = float4(-1.f, -3.f, 0.f, 1.f);
    output.texcoord = float2(0.f, 2.f);
  }

  return output;
}
