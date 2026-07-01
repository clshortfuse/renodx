Texture2D<float4> __tex_input_texture0 : register(t0);

cbuffer c0 : register(b0) {
  float4 world_view_proj[4] : packoffset(c000.x);
  float2 output_target_size : packoffset(c004.x);
  float2 input_texture0_size : packoffset(c004.z);
  float2 inv_input_texture0_size : packoffset(c005.x);
  uint input_mip_level : packoffset(c005.z);
  uint output_mip_level : packoffset(c005.w);
};

SamplerState __samp_input_texture0 : register(s0);

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) {
  return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}
uint firstbithigh_msb(uint value) {
  return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}

float4 main(precise noperspective float4 SV_Position : SV_Position,
            linear float2 TEXCOORD : TEXCOORD)
    : SV_Target {
  float4 SV_Target;
  float4 _9;
  _9 = __tex_input_texture0.SampleLevel(
      __samp_input_texture0, float2(TEXCOORD.x, TEXCOORD.y),
      ((float)((uint)(uint)(input_mip_level))));
  SV_Target.x = _9.x;
  SV_Target.y = _9.y;
  SV_Target.z = _9.z;
  SV_Target.rgb = max(0, SV_Target.rgb);

  SV_Target.w = _9.w;
  return SV_Target;
}