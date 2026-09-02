#include "../shared.h"

Texture2D<float4> __tex_input_texture0 : register(t0);

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

cbuffer c0 : register(b1) {
  float4 world_view_proj[4] : packoffset(c000.x);
  float2 output_target_size : packoffset(c004.x);
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
  uint _17;
  uint _26;
  uint _30;
  uint _33;
  float _38;
  float _41;
  _9 = __tex_input_texture0.Sample(__samp_input_texture0,
                                   float2(TEXCOORD.x, TEXCOORD.y));
  _17 = uint(SV_Position.x);
  _26 = (((int)(((int)(uint(frame_number + 2.0f)) * _17) +
                uint(output_target_size.x))) *
         (int)(uint(SV_Position.y))) +
        _17;
  _30 = ((_26 ^ 61) ^ ((uint)(_26) >> 16)) * 9;
  _33 = (((uint)(_30) >> 4) ^ _30) * 668265261;
  _38 = (float((uint)((uint)(((uint)(_33) >> 15) ^ _33))) *
         9.130612932395366e-13f) +
        -0.0019607841968536377f;
  _41 = 2.200000047683716f / gamma;
  SV_Target.x = saturate(_38 + (pow(_9.x, _41)));
  SV_Target.y = saturate(_38 + (pow(_9.y, _41)));
  SV_Target.z = saturate(_38 + (pow(_9.z, _41)));
  SV_Target.w = _9.w;

  SV_Target.rgb = _9.rgb;
  return SV_Target;
}