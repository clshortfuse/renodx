cbuffer ConstBuf_constantsUBO : register(b0, space0) {
  float4 ConstBuf_constants_m0[15] : packoffset(c0);
};

// Don't declare _9, _13, _17

static uint3 gl_GlobalInvocationID;
struct SPIRV_Cross_Input {
  uint3 gl_GlobalInvocationID : SV_DispatchThreadID;
};

void comp_main() {
  float _46 = ConstBuf_constants_m0[14u].y * (float(gl_GlobalInvocationID.x) + 0.5f);
  float _47 = (float(gl_GlobalInvocationID.y) + 0.5f) * ConstBuf_constants_m0[14u].z;
  uint4 _52 = asuint(ConstBuf_constants_m0[13u]);
  uint _53 = _52.y;
  uint _57 = _52.x;
  uint _outIndex = _52.w;

  Texture2D<float4> tex = ResourceDescriptorHeap[_53];
  SamplerState sampler = ResourceDescriptorHeap[_57];
  RWTexture2D<float4> outTex = ResourceDescriptorHeap[_outIndex];

  float2 uv = float2(_46, _47);
  float4 _66 = tex.SampleLevel(sampler, uv, 0.0f, int2(-2, -2));
  float4 _76 = tex.SampleLevel(sampler, uv, 0.0f, int2(-2, 0));
  float4 _84 = tex.SampleLevel(sampler, uv, 0.0f, int2(-2, 2));
  float4 _91 = tex.SampleLevel(sampler, uv, 0.0f, int2(0, -2));
  float4 _98 = tex.SampleLevel(sampler, uv, 0.0f);
  float4 _104 = tex.SampleLevel(sampler, uv, 0.0f, int2(0, 2));
  float4 _111 = tex.SampleLevel(sampler, uv, 0.0f, int2(2, -2));
  float4 _118 = tex.SampleLevel(sampler, uv, 0.0f, int2(2, 0));
  float4 _125 = tex.SampleLevel(sampler, uv, 0.0f, int2(2, 2));
  float4 _133 = tex.SampleLevel(sampler, uv, 0.0f, int2(-1, -1));
  float4 _141 = tex.SampleLevel(sampler, uv, 0.0f, int2(-1, 1));
  float4 _148 = tex.SampleLevel(sampler, uv, 0.0f, int2(1, -1));
  float4 _155 = tex.SampleLevel(sampler, uv, 0.0f, int2(1, 1));

  float4 result;
  result.r = (((((_91.x + _76.x) + _104.x) + _118.x) * 0.0625f) + (((((_133.x + _98.x) + _141.x) + _148.x) + _155.x) * 0.125f)) + ((((_84.x + _66.x) + _111.x) + _125.x) * 0.03125f);
  result.g = (((((_91.y + _76.y) + _104.y) + _118.y) * 0.0625f) + (((((_133.y + _98.y) + _141.y) + _148.y) + _155.y) * 0.125f)) + ((((_84.y + _66.y) + _111.y) + _125.y) * 0.03125f);
  result.b = (((((_91.z + _76.z) + _104.z) + _118.z) * 0.0625f) + (((((_133.z + _98.z) + _141.z) + _148.z) + _155.z) * 0.125f)) + ((((_84.z + _66.z) + _111.z) + _125.z) * 0.03125f);
  result.a = (((((_91.w + _76.w) + _104.w) + _118.w) * 0.0625f) + (((((_133.w + _98.w) + _141.w) + _148.w) + _155.w) * 0.125f)) + ((((_84.w + _66.w) + _111.w) + _125.w) * 0.03125f);

  outTex[gl_GlobalInvocationID.xy] = result;
}

[numthreads(8, 8, 1)]
void main(SPIRV_Cross_Input stage_input) {
  gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
  comp_main();
}
