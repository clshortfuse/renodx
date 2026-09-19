void main(
    uint vertex_id : SV_VERTEXID,
    out float4 position : SV_POSITION,
    out float2 uv : TEXCOORD0) {
  uv.x = vertex_id == 1u ? 2.f : 0.f;
  uv.y = vertex_id == 2u ? 2.f : 0.f;
  position = float4(uv * float2(2.f, -2.f) + float2(-1.f, 1.f), 0.f, 1.f);
}