Texture2D<float4> __tex_normal_map : register(t0);

Texture2D<float4> __tex_diffuse_map : register(t1);

cbuffer c_per_object : register(b0) {
  float4 view_proj[4] : packoffset(c000.x);
  float4 world_view_proj[4] : packoffset(c004.x);
  float4 world[4] : packoffset(c008.x);
  float4 dev_wireframe_color : packoffset(c012.x);
  float video_type : packoffset(c013.x);
};

SamplerState __samp_normal_map : register(s0);

SamplerState __samp_diffuse_map : register(s1);

// Just so we switch colorspace early
float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 CUSTOM : CUSTOM
) : SV_Target {
  float4 SV_Target;
  float4 _8 = __tex_diffuse_map.Sample(__samp_diffuse_map, float2(CUSTOM.x, CUSTOM.y));
  float4 _10 = __tex_normal_map.Sample(__samp_normal_map, float2(CUSTOM.x, CUSTOM.y));
  float _44;
  float _45;
  float _46;
  if (video_type == 1.0f) {
    float _17 = _8.x * 255.0f;
    float _20 = (_10.y * 255.0f) + -128.0f;
    float _21 = (_10.x * 255.0f) + -128.0f;
    _44 = (mad(_21, 1.4025249481201172f, _17) * 0.003921568859368563f);
    _45 = (mad(_21, -0.7144010066986084f, mad(_20, -0.34373000264167786f, _17)) * 0.003921568859368563f);
    _46 = (mad(_21, 1.2999999853491317e-05f, mad(_20, 1.7699049711227417f, _17)) * 0.003921568859368563f);
  } else {
    float _32 = (_8.x + -0.0625f) * 1.1642999649047852f;
    float _33 = _10.x + -0.5f;
    float _34 = _10.y + -0.5f;
    _44 = ((_34 * 1.5958000421524048f) + _32);
    _45 = ((_32 - (_33 * 0.39173001050949097f)) - (_34 * 0.8129000067710876f));
    _46 = ((_33 * 2.0169999599456787f) + _32);
  }
  SV_Target.x = _44;
  SV_Target.y = _45;
  SV_Target.z = _46;
  SV_Target.w = 1.0f;
  return SV_Target;
}
