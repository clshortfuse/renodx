Texture2D<float4> global_texture2D[] : register(t0, space2);

Texture2D<float4> __tex_linear_depth : register(t0);

Texture2D<float4> __tex_hdr0_rgb_mip6 : register(t1);

RWBuffer<uint> global_feedback_buffers[] : register(u0, space31);

cbuffer global_viewport : register(b0) {
  float3 camera_unprojection : packoffset(c000.x);
  float3 camera_pos : packoffset(c001.x);
  float4 camera_view[4] : packoffset(c002.x);
  float4 camera_inv_view[4] : packoffset(c006.x);
  float4 camera_world[4] : packoffset(c010.x);
  float4 camera_last_world[4] : packoffset(c014.x);
  float4 camera_last_view[4] : packoffset(c018.x);
  float4 camera_last_inv_view[4] : packoffset(c022.x);
  float4 camera_projection[4][2] : packoffset(c026.x);
  float4 camera_inv_projection[4][2] : packoffset(c034.x);
  float4 camera_last_projection[4][2] : packoffset(c042.x);
  float4 camera_last_inv_projection[4][2] : packoffset(c050.x);
  float4 camera_last_view_projection[4][2] : packoffset(c058.x);
  float4 camera_last_inv_view_projection[4][2] : packoffset(c066.x);
  float4 camera_view_projection[4][2] : packoffset(c074.x);
  float4 camera_inv_view_projection[4][2] : packoffset(c082.x);
  float time : packoffset(c090.x);
  float delta_time : packoffset(c090.y);
  float2 streamer_write_feedback_threshold : packoffset(c090.z);
  float2 sampler_lod_bias : packoffset(c091.x);
  float frame_number : packoffset(c091.z);
  float2 back_buffer_size : packoffset(c092.x);
  float2 output_rt_size : packoffset(c092.z);
  float4 hdr_content_to_monitor_rec[4] : packoffset(c093.x);
  float taa_enabled : packoffset(c097.x);
  float jitter_enabled : packoffset(c097.y);
  float upscaling_enabled : packoffset(c097.z);
  float debug_rendering : packoffset(c097.w);
  float gamma : packoffset(c098.x);
  float lens_quality_color_fringe_enabled : packoffset(c098.y);
  float lens_quality_distortion_enabled : packoffset(c098.z);
  float volumetric_reprojection_amount : packoffset(c098.w);
  float volumetric_volumes_enabled : packoffset(c099.x);
  float sun_shadows : packoffset(c099.y);
  float capture_cubemap : packoffset(c099.z);
  float capture_ddgi : packoffset(c099.w);
  float hair_wrapped_diffuse : packoffset(c100.x);
  float4 viewport : packoffset(c101.x);
  float is_editor : packoffset(c102.x);
  float2 mouse_uv : packoffset(c102.y);
  float rt_reflections_enabled : packoffset(c102.w);
  float rt_particle_reflections_enabled : packoffset(c103.x);
  float rt_relax_denoiser_enabled : packoffset(c103.y);
  float dlss_rr_enabled : packoffset(c103.z);
  float gtao_enabled : packoffset(c103.w);
  float cacao_enabled : packoffset(c104.x);
  float rt_mixed_reflections : packoffset(c104.y);
  float rt_shadow_ray_multiplier : packoffset(c104.z);
  float rtxgi_enabled : packoffset(c104.w);
  float baked_ddgi : packoffset(c105.x);
  float dxr : packoffset(c105.y);
  float rt_checkerboard_reflections : packoffset(c105.z);
  float3 camera_near_far : packoffset(c106.x);
  float direct_diffuse_enabled : packoffset(c106.w);
  float direct_specular_enabled : packoffset(c107.x);
  float indirect_diffuse_enabled : packoffset(c107.y);
  float indirect_specular_enabled : packoffset(c107.z);
  float occlusion_debug_opacity : packoffset(c107.w);
  float occlusion_debug_far : packoffset(c108.x);
  float occlusion_debug_near : packoffset(c108.y);
  float occluder_debug_opacity : packoffset(c108.z);
  float occluder_debug_far : packoffset(c108.w);
  float hdr_paper_white_nits : packoffset(c109.x);
  float debug_hdr_compare : packoffset(c109.y);
  float reverse_z : packoffset(c109.z);
  float terrain_displacement_min_distance : packoffset(c109.w);
  float terrain_displacement_max_distance : packoffset(c110.x);
  float terrain_tesselation_min_distance : packoffset(c110.y);
  float terrain_tesselation_max_distance : packoffset(c110.z);
};

cbuffer c_material_exports : register(b1) {
  uint __BINDLESS_SAMPLER_texture_map_04b5ef46 : packoffset(c000.x);
  uint2 __BINDLESS_TEX2D_texture_map_04b5ef46 : packoffset(c000.y);
  uint2 __BINDLESS_MINLOD_texture_map_04b5ef46 : packoffset(c001.x);
  float particle_min_size : packoffset(c001.z);
  float material_variable_7e5cce0f : packoffset(c001.w);
  float material_variable : packoffset(c002.x);
};

SamplerState global_samplers[] : register(s0, space2);

SamplerState static_minlod_sampler : register(s0, space31);

SamplerState __samp_linear_depth : register(s0);

SamplerState __samp_hdr0_rgb_mip6 : register(s1);

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }
uint firstbithigh_msb(uint value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }

float4 main(
  precise noperspective float4 SV_Position : SV_Position,
  linear float3 TEXCOORD_15 : TEXCOORD15,
  linear float CUSTOM_4 : CUSTOM4,
  linear float2 CUSTOM : CUSTOM,
  linear float2 CUSTOM_2 : CUSTOM2,
  linear float4 CUSTOM_1 : CUSTOM1,
  linear float2 CUSTOM_3 : CUSTOM3
) : SV_Target {
  float4 SV_Target;
  float _21;
  float _22;
  float _23;
  float _24;
  int _55;
  float4 _63;
  float _70;
  int _79;
  int _102;
  float _107;
  float _108;
  float _109;
  float _111;
  float _137;
  float4 _144;
  _21 = 1.0f / output_rt_size.x;
  _22 = 1.0f / output_rt_size.y;
  _23 = _21 * SV_Position.x;
  _24 = _22 * SV_Position.y;
  _55 = (uint)((uint)(__BINDLESS_MINLOD_texture_map_04b5ef46.y)) >> 16;
  _63 = global_texture2D[((uint)(__BINDLESS_TEX2D_texture_map_04b5ef46.x) + 0u)].Sample(global_samplers[((uint)(__BINDLESS_SAMPLER_texture_map_04b5ef46) + 0u)], float2(CUSTOM.x, CUSTOM.y), int2(0, 0), ((((float4)(global_texture2D[((uint)(__BINDLESS_MINLOD_texture_map_04b5ef46.x) + 0u)].Sample(static_minlod_sampler, float2(CUSTOM.x, CUSTOM.y)))).x) * 32.0f));
  _70 = frac(time);
  _79 = -int((bool)(int)(frac(cos(dot(float2((_70 + CUSTOM.x), (_70 + CUSTOM.y)), float2(23.14069175720215f, 2.665144205093384f))) * 157.3247833251953f) < streamer_write_feedback_threshold.x));
  if (((((QuadReadAcrossX(_79) | QuadReadAcrossY(_79)) | QuadReadAcrossDiagonal(_79)) | _79) & 1) != 0) {
    InterlockedMin(global_feedback_buffers[(((uint)(__BINDLESS_MINLOD_texture_map_04b5ef46.x) + 1u) + 0u)][((int)(((int)(uint(frac(CUSTOM.y) * ((float)((uint)((uint)(__BINDLESS_MINLOD_texture_map_04b5ef46.y & 65535)))))) * _55) + uint(frac(CUSTOM.x) * ((float)((uint)_55)))))], (int)(uint((global_texture2D[((uint)(__BINDLESS_TEX2D_texture_map_04b5ef46.x) + 0u)].CalculateLevelOfDetailUnclamped(global_samplers[((uint)(__BINDLESS_SAMPLER_texture_map_04b5ef46) + 0u)], float2(CUSTOM.x, CUSTOM.y))) * 8.0f)), _102);
  }
  _107 = (_63.x * 2.0f) + -1.0f;
  _108 = (_63.y * 2.0f) + -1.0f;
  _109 = (_63.z * 2.0f) + -1.0f;
  _111 = rsqrt(dot(float3(_107, _108, _109), float3(_107, _108, _109)));
  if (!((!(CUSTOM_2.x == 0.0f)) || (!(CUSTOM_2.y == 0.0f)))) {
    if (true) discard;
  }
  _137 = saturate((_63.w * CUSTOM_1.x) * saturate((asfloat((asint((((float4)(__tex_linear_depth.Sample(__samp_linear_depth, float2(_23, _24)))).x)) & 2147483647)) - dot(float3((-0.0f - ((camera_world[0].w) - TEXCOORD_15.x)), (-0.0f - ((camera_world[1].w) - TEXCOORD_15.y)), (-0.0f - ((camera_world[2].w) - TEXCOORD_15.z))), float3((camera_world[0].y), (camera_world[1].y), (camera_world[2].y)))) / material_variable_7e5cce0f));
  _144 = __tex_hdr0_rgb_mip6.Sample(__samp_hdr0_rgb_mip6, float2((((_21 * CUSTOM_2.x) * ((((_63.x * 4.0f) + -2.0f) * _111) + -1.0f)) + _23), (((_22 * CUSTOM_2.y) * ((((_63.y * 4.0f) + -2.0f) * _111) + -1.0f)) + _24)));
  SV_Target.x = (_144.x * _137);
  SV_Target.y = (_144.y * _137);
  SV_Target.z = (_144.z * _137);

  // Fixes black smoke, it draws onto rg11b10 texture
  SV_Target.rgb = max(0, SV_Target.rgb);
  SV_Target.w = _137;
  return SV_Target;
}