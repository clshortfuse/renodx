#include "./common.hlsl"

Texture2D<float4> __tex_input_texture0 : register(t0);

Texture2D<float4> __tex_input_texture1 : register(t1);

Texture2D<float4> __tex_input_texture2 : register(t2);

Texture2D<float4> __tex_input_texture3 : register(t3);

Texture3D<float4> __tex_virtual_color_grading : register(t4);

Texture2D<float> current_exposure : register(t5);

Texture2D<float4> __tex_linear_depth : register(t6);

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
};

cbuffer global_environment_settings : register(b1) {
  float minion_rimlight : packoffset(c000.x);
  float minion_glowing_eyes : packoffset(c000.y);
  float minion_environment_mask : packoffset(c000.z);
  float emissive_intensity : packoffset(c000.w);
  float global_roughness_multiplier : packoffset(c001.x);
  float metallic_roughness_multiplier : packoffset(c001.y);
  float non_metallic_roughness_multiplier : packoffset(c001.z);
  float global_reflectance_multiplier : packoffset(c001.w);
  float reflection_boost : packoffset(c002.x);
  float reflection_smooth_bias : packoffset(c002.y);
  float ambient_enabled : packoffset(c002.z);
  float3 global_ambient_tint : packoffset(c003.x);
  float3 local_ambient_tint : packoffset(c004.x);
  float ambient_depth_occlusion_enabled : packoffset(c004.w);
  float ambient_normal_weight_enabled : packoffset(c005.x);
  float2 specular_ao_intensity : packoffset(c005.y);
  float specular_ao_horizon_occlusion : packoffset(c005.w);
  float sun_enabled : packoffset(c006.x);
  float3 sun_direction : packoffset(c006.y);
  float3 sun_color : packoffset(c007.x);
  float sun_disk_enabled : packoffset(c007.w);
  float sun_disk_size : packoffset(c008.x);
  float3 local_shadow_map_bias : packoffset(c008.y);
  float3 sun_shadow_map_bias : packoffset(c009.x);
  float3 ssm_shadow_map_bias : packoffset(c010.x);
  float sun_shadows_enabled : packoffset(c010.w);
  float ssm_enabled : packoffset(c011.x);
  float skydome_u_offset : packoffset(c011.y);
  float skydome_intensity : packoffset(c011.z);
  float3 skydome_tint_color : packoffset(c012.x);
  float3 skydome_flow_direction : packoffset(c013.x);
  float skydome_flow_speed : packoffset(c013.w);
  float skydome_flow_tiling : packoffset(c014.x);
  float2 skydome_cloud_speed_scale : packoffset(c014.y);
  float3 wind_amount : packoffset(c015.x);
  float eye_intensity : packoffset(c015.w);
  float fog_enabled : packoffset(c016.x);
  float3 fog_color : packoffset(c016.y);
  float3 fog0_settings : packoffset(c017.x);
  float3 fog1_settings : packoffset(c018.x);
  float2 skydome_fog_height_falloff : packoffset(c019.x);
  float volumetric_lighting_enabled : packoffset(c019.z);
  float volumetric_global_light_multiplier : packoffset(c019.w);
  float volumetric_local_light_multiplier : packoffset(c020.x);
  float volumetric_distance : packoffset(c020.y);
  float volumetric_phase : packoffset(c020.z);
  float volumetric_extinction : packoffset(c020.w);
  float volumetric_ambient_multiplier : packoffset(c021.x);
  float world_interaction_window_size : packoffset(c021.y);
  float world_interaction_water_window_size : packoffset(c021.z);
  float tonemap_use_custom : packoffset(c021.w);
  float tonemap_slope : packoffset(c022.x);
  float tonemap_toe : packoffset(c022.y);
  float tonemap_shoulder : packoffset(c022.z);
  float tonemap_black_clip : packoffset(c022.w);
  float tonemap_white_clip : packoffset(c023.x);
  float pathtraced_accumulation_frames : packoffset(c023.y);
  float4 ies_atlas_size : packoffset(c024.x);
};

cbuffer c0 : register(b2) {
  float4 world_view_proj[4] : packoffset(c000.x);
  float3 bloom_threshold_offset_falloff : packoffset(c004.x);
  float3 vignette_scale_falloff_opacity : packoffset(c005.x);
  float3 vignette_color : packoffset(c006.x);
  float bloom_enabled : packoffset(c006.w);
  float bloom_glare_enabled : packoffset(c007.x);
  float2 bloom_glare_settings : packoffset(c007.y);
  float light_shafts_enabled : packoffset(c007.w);
  float sun_flare_enabled : packoffset(c008.x);
  float tone_mapping_enabled : packoffset(c008.y);
  float amd_lpm_tone_mapping_enabled : packoffset(c008.z);
  float vignette_enabled : packoffset(c008.w);
  float color_grading_enabled : packoffset(c009.x);
  float grey_scale_enabled : packoffset(c009.y);
  float grey_scale_amount : packoffset(c009.z);
  float3 grey_scale_weights : packoffset(c010.x);
  float mirror_uv : packoffset(c010.w);
  float2 input_texture1_size : packoffset(c011.x);
  uint4 amd_lpm[24] : packoffset(c012.x);
};

SamplerState __samp_input_texture0 : register(s0);

SamplerState __samp_input_texture1 : register(s1);

SamplerState __samp_input_texture2 : register(s2);

SamplerState __samp_input_texture3 : register(s3);

SamplerState __samp_virtual_color_grading : register(s4);

SamplerState __samp_linear_depth : register(s5);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD,
  linear float4 TEXCOORD_1 : TEXCOORD1
) : SV_Target {
  float4 SV_Target;
  float4 _19 = __tex_input_texture0.Sample(__samp_input_texture0, float2(TEXCOORD.x, TEXCOORD.y));
  float _24 = current_exposure.Load(int3(0, 0, 0));
  float _26 = _24.x * _19.x;
  float _27 = _24.x * _19.y;
  float _28 = _24.x * _19.z;
  float3 untonemapped_bt709 = float3(_26, _27, _28);  // After exposure

  float _289;
  float _290;
  float _291;
  float _622;
  float _655;
  float _669;
  float _726;
  float _881;
  float _882;
  float _883;
  float _957;
  float _958;
  float _959;
  float _986;
  float _987;
  float _988;
  [branch]
  if (!(bloom_glare_enabled == 0.0f)) {
    float4 _33 = __tex_linear_depth.Sample(__samp_linear_depth, float2(TEXCOORD.x, TEXCOORD.y));
    int _35 = asint(_33.x);
    float _37 = asfloat((_35 & 2147483647));
    bool _41 = ((uint)(uint(float((uint)((int)((uint)(_35) >> 31))))) == 0);
    float _53 = select(_41, TEXCOORD_1.w, TEXCOORD_1.w);
    float _80 = (camera_pos.x + ((select(_41, TEXCOORD_1.x, TEXCOORD_1.x) / _53) * _37)) - (((camera_world[0].y) * _37) * bloom_glare_settings.y);
    float _81 = (camera_pos.y + ((select(_41, TEXCOORD_1.y, TEXCOORD_1.y) / _53) * _37)) - (((camera_world[1].y) * _37) * bloom_glare_settings.y);
    float _82 = (camera_pos.z + ((select(_41, TEXCOORD_1.z, TEXCOORD_1.z) / _53) * _37)) - (((camera_world[2].y) * _37) * bloom_glare_settings.y);
    float _136 = mad(_82, select(_41, (camera_view_projection[1][1].z), (camera_view_projection[3][1].z)), mad(_81, select(_41, (camera_view_projection[1][1].y), (camera_view_projection[3][1].y)), (select(_41, (camera_view_projection[1][1].x), (camera_view_projection[3][1].x)) * _80))) + select(_41, (camera_view_projection[1][1].w), (camera_view_projection[3][1].w));
    float _139 = ((mad(_82, select(_41, (camera_view_projection[0][0].z), (camera_view_projection[2][0].z)), mad(_81, select(_41, (camera_view_projection[0][0].y), (camera_view_projection[2][0].y)), (select(_41, (camera_view_projection[0][0].x), (camera_view_projection[2][0].x)) * _80))) + select(_41, (camera_view_projection[0][0].w), (camera_view_projection[2][0].w))) / _136) * 0.5f;
    float _140 = ((mad(_82, select(_41, (camera_view_projection[0][1].z), (camera_view_projection[2][1].z)), mad(_81, select(_41, (camera_view_projection[0][1].y), (camera_view_projection[2][1].y)), (select(_41, (camera_view_projection[0][1].x), (camera_view_projection[2][1].x)) * _80))) + select(_41, (camera_view_projection[0][1].w), (camera_view_projection[2][1].w))) / _136) * -0.5f;
    float _146 = input_texture1_size.x * (_139 + 0.5f);
    float _147 = (_140 + 0.5f) * input_texture1_size.y;
    float _148 = 1.0f / input_texture1_size.x;
    float _149 = 1.0f / input_texture1_size.y;
    float _152 = floor(_146 + -0.5f);
    float _153 = floor(_147 + -0.5f);
    float _156 = _146 - (_152 + 0.5f);
    float _157 = _147 - (_153 + 0.5f);
    float _158 = _156 * _156;
    float _159 = _157 * _157;
    float _160 = _158 * _156;
    float _161 = _159 * _157;
    float _168 = mad(_158, -1.0f, (_160 * 0.5f)) + 0.6666666865348816f;
    float _172 = _160 * 0.1666666716337204f;
    float _179 = mad(_159, -1.0f, (_161 * 0.5f)) + 0.6666666865348816f;
    float _183 = _161 * 0.1666666716337204f;
    float _184 = (mad(_156, -0.5f, mad(_158, 0.5f, (_160 * -0.1666666716337204f))) + 0.1666666716337204f) + _168;
    float _185 = (mad(_157, -0.5f, mad(_159, 0.5f, (_161 * -0.1666666716337204f))) + 0.1666666716337204f) + _179;
    float _198 = ((_152 + -0.5f) + (_168 / _184)) * _148;
    float _199 = ((_153 + -0.5f) + (_179 / _185)) * _149;
    float _204 = ((_152 + 1.5f) + (_172 / ((_172 + 0.1666666716337204f) + mad(_156, 0.5f, mad(_158, 0.5f, (_160 * -0.5f)))))) * _148;
    float _205 = ((_153 + 1.5f) + (_183 / ((_183 + 0.1666666716337204f) + mad(_157, 0.5f, mad(_159, 0.5f, (_161 * -0.5f)))))) * _149;
    float4 _206 = __tex_input_texture1.Sample(__samp_input_texture1, float2(_198, _199));
    float4 _210 = __tex_input_texture1.Sample(__samp_input_texture1, float2(_204, _199));
    float4 _214 = __tex_input_texture1.Sample(__samp_input_texture1, float2(_198, _205));
    float4 _218 = __tex_input_texture1.Sample(__samp_input_texture1, float2(_204, _205));
    float _237 = ((_210.x - _218.x) * _185) + _218.x;
    float _238 = ((_210.y - _218.y) * _185) + _218.y;
    float _239 = ((_210.z - _218.z) * _185) + _218.z;
    float _246 = (((lerp(_214.x, _206.x, _185)) - _237) * _184) + _237;
    float _247 = (((lerp(_214.y, _206.y, _185)) - _238) * _184) + _238;
    float _248 = (((lerp(_214.z, _206.z, _185)) - _239) * _184) + _239;
    float _253 = max((bloom_threshold_offset_falloff.y - dot(float3(_246, _247, _248), float3(0.2126999944448471f, 0.7152000069618225f, 0.07209999859333038f))), 6.0999998822808266e-05f);
    float _265 = saturate((abs(-0.0f - _139) + -0.5f) * -3.3333332538604736f);
    float _266 = saturate((abs(-0.0f - _140) + -0.5f) * -3.3333332538604736f);
    float _272 = (_265 * _265) * (3.0f - (_265 * 2.0f));
    float _274 = (_266 * _266) * (3.0f - (_266 * 2.0f));
    _289 = ((((bloom_glare_settings.x * (_246 / _253)) * _272) * _274) + _26);
    _290 = ((((bloom_glare_settings.x * (_247 / _253)) * _272) * _274) + _27);
    _291 = ((((bloom_glare_settings.x * (_248 / _253)) * _272) * _274) + _28);
  } else {
    _289 = _26;
    _290 = _27;
    _291 = _28;
  }
  float _295 = input_texture1_size.x * TEXCOORD.x;
  float _296 = input_texture1_size.y * TEXCOORD.y;
  float _297 = 1.0f / input_texture1_size.x;
  float _298 = 1.0f / input_texture1_size.y;
  float _301 = floor(_295 + -0.5f);
  float _302 = floor(_296 + -0.5f);
  float _305 = _295 - (_301 + 0.5f);
  float _306 = _296 - (_302 + 0.5f);
  float _307 = _305 * _305;
  float _308 = _306 * _306;
  float _309 = _307 * _305;
  float _310 = _308 * _306;
  float _317 = mad(_307, -1.0f, (_309 * 0.5f)) + 0.6666666865348816f;
  float _321 = _309 * 0.1666666716337204f;
  float _328 = mad(_308, -1.0f, (_310 * 0.5f)) + 0.6666666865348816f;
  float _332 = _310 * 0.1666666716337204f;
  float _333 = (mad(_305, -0.5f, mad(_307, 0.5f, (_309 * -0.1666666716337204f))) + 0.1666666716337204f) + _317;
  float _334 = (mad(_306, -0.5f, mad(_308, 0.5f, (_310 * -0.1666666716337204f))) + 0.1666666716337204f) + _328;
  float _347 = ((_301 + -0.5f) + (_317 / _333)) * _297;
  float _348 = ((_302 + -0.5f) + (_328 / _334)) * _298;
  float _353 = ((_301 + 1.5f) + (_321 / ((_321 + 0.1666666716337204f) + mad(_305, 0.5f, mad(_307, 0.5f, (_309 * -0.5f)))))) * _297;
  float _354 = ((_302 + 1.5f) + (_332 / ((_332 + 0.1666666716337204f) + mad(_306, 0.5f, mad(_308, 0.5f, (_310 * -0.5f)))))) * _298;
  float4 _355 = __tex_input_texture1.Sample(__samp_input_texture1, float2(_347, _348));
  float4 _359 = __tex_input_texture1.Sample(__samp_input_texture1, float2(_353, _348));
  float4 _363 = __tex_input_texture1.Sample(__samp_input_texture1, float2(_347, _354));
  float4 _367 = __tex_input_texture1.Sample(__samp_input_texture1, float2(_353, _354));
  float _386 = ((_359.x - _367.x) * _334) + _367.x;
  float _387 = ((_359.y - _367.y) * _334) + _367.y;
  float _388 = ((_359.z - _367.z) * _334) + _367.z;
  float _395 = (((lerp(_363.x, _355.x, _334)) - _386) * _333) + _386;
  float _396 = (((lerp(_363.y, _355.y, _334)) - _387) * _333) + _387;
  float _397 = (((lerp(_363.z, _355.z, _334)) - _388) * _333) + _388;
  float _402 = max((bloom_threshold_offset_falloff.y - dot(float3(_395, _396, _397), float3(0.2126999944448471f, 0.7152000069618225f, 0.07209999859333038f))), 6.0999998822808266e-05f);
  float4 _409 = __tex_input_texture2.Sample(__samp_input_texture2, float2(TEXCOORD.x, TEXCOORD.y));
  float4 _416 = __tex_input_texture3.Sample(__samp_input_texture3, float2(TEXCOORD.x, TEXCOORD.y));
  float _420 = (((_395 / _402) + _289) + _409.x) + _416.x;
  float _421 = (((_396 / _402) + _290) + _409.y) + _416.y;
  float _422 = (((_397 / _402) + _291) + _409.z) + _416.z;
  [branch]
  if (!(tone_mapping_enabled == 0.0f)) {
    if (!(amd_lpm_tone_mapping_enabled == 0.0f)) {
      float _430 = max(0.0f, _420);
      float _431 = max(0.0f, _421);
      float _432 = max(0.0f, _422);
      float _452 = asfloat((amd_lpm[2].y));
      float _453 = asfloat((amd_lpm[2].z));
      float _454 = asfloat((amd_lpm[2].w));
      float _464 = asfloat((amd_lpm[1].z));
      float _465 = asfloat((amd_lpm[1].w));
      float _466 = asfloat((amd_lpm[2].x));
      float _469 = 1.0f / max(_430, max(_431, _432));
      float _475 = exp2(log2(_469 * _430) * asfloat((amd_lpm[0].x)));
      float _478 = exp2(log2(_469 * _431) * asfloat((amd_lpm[0].y)));
      float _481 = exp2(log2(_469 * _432) * asfloat((amd_lpm[0].z)));
      float _489 = exp2(log2(((_465 * _431) + (_464 * _430)) + (_466 * _432)) * asfloat((amd_lpm[0].w)));
      float _493 = (1.0f / ((_489 * asfloat((amd_lpm[1].x))) + asfloat((amd_lpm[1].y)))) * _489;
      float _501 = saturate(_493 * (1.0f / (((_478 * _465) + (_475 * _464)) + (_481 * _466))));
      float _503 = saturate(_501 * _475);
      float _505 = saturate(_501 * _478);
      float _507 = saturate(_501 * _481);
      float _509 = _452 - (_503 * _452);
      float _511 = _453 - (_505 * _453);
      float _513 = _454 - (_507 * _454);
      float _527 = (1.0f / (((_511 * _465) + (_509 * _464)) + (_513 * _466))) * saturate(((_493 - (_503 * _464)) - (_505 * _465)) - (_507 * _466));
      float _530 = saturate((_527 * _509) + _503);
      float _533 = saturate((_527 * _511) + _505);
      float _536 = saturate((_527 * _513) + _507);
      float _543 = saturate(((_493 - (_530 * _464)) - (_533 * _465)) - (_536 * _466));
      _881 = saturate((_543 * asfloat((amd_lpm[3].x))) + _530);
      _882 = saturate((_543 * asfloat((amd_lpm[3].y))) + _533);
      _883 = saturate((_543 * asfloat((amd_lpm[3].z))) + _536);
    } else {
      if (!(tonemap_use_custom == 0.0f)) {
        float _567 = mad(0.16386905312538147f, _422, mad(0.14067868888378143f, _421, (_420 * 0.6954522132873535f)));
        float _570 = mad(0.0955343246459961f, _422, mad(0.8596711158752441f, _421, (_420 * 0.044794581830501556f)));
        float _573 = mad(1.0015007257461548f, _422, mad(0.004025210160762072f, _421, (_420 * -0.005525882821530104f)));
        float _577 = max(max(_567, _570), _573);
        float _582 = (max(_577, 1.000000013351432e-10f) - max(min(min(_567, _570), _573), 1.000000013351432e-10f)) / max(_577, 0.009999999776482582f);
        float _595 = ((_570 + _567) + _573) + (sqrt((((_573 - _570) * _573) + ((_570 - _567) * _570)) + ((_567 - _573) * _567)) * 1.75f);
        float _596 = _595 * 0.3333333432674408f;
        float _597 = _582 + -0.4000000059604645f;
        float _598 = _597 * 5.0f;
        float _602 = max((1.0f - abs(_597 * 2.5f)), 0.0f);
        float _613 = ((float(((int)(uint)((bool)(_598 > 0.0f))) - ((int)(uint)((bool)(_598 < 0.0f)))) * (1.0f - (_602 * _602))) + 1.0f) * 0.02500000037252903f;
        if (!(_596 <= 0.0533333346247673f)) {
          if (!(_596 >= 0.1599999964237213f)) {
            _622 = (((0.23999999463558197f / _595) + -0.5f) * _613);
          } else {
            _622 = 0.0f;
          }
        } else {
          _622 = _613;
        }
        float _623 = _622 + 1.0f;
        float _624 = _623 * _567;
        float _625 = _623 * _570;
        float _626 = _623 * _573;
        if (!((bool)(_624 == _625) && (bool)(_625 == _626))) {
          float _633 = ((_624 * 2.0f) - _625) - _626;
          float _636 = ((_570 - _573) * 1.7320507764816284f) * _623;
          float _638 = atan(_636 / _633);
          bool _641 = (_633 < 0.0f);
          bool _642 = (_633 == 0.0f);
          bool _643 = (_636 >= 0.0f);
          bool _644 = (_636 < 0.0f);
          _655 = select((_643 && _642), 90.0f, select((_644 && _642), -90.0f, (select((_644 && _641), (_638 + -3.1415927410125732f), select((_643 && _641), (_638 + 3.1415927410125732f), _638)) * 57.295780181884766f)));
        } else {
          _655 = 0.0f;
        }
        float _660 = min(max(select((_655 < 0.0f), (_655 + 360.0f), _655), 0.0f), 360.0f);
        if (_660 < -180.0f) {
          _669 = (_660 + 360.0f);
        } else {
          if (_660 > 180.0f) {
            _669 = (_660 + -360.0f);
          } else {
            _669 = _660;
          }
        }
        float _673 = saturate(1.0f - abs(_669 * 0.014814814552664757f));
        float _677 = (_673 * _673) * (3.0f - (_673 * 2.0f));
        float _683 = ((_677 * _677) * ((_582 * 0.18000000715255737f) * (0.029999999329447746f - _624))) + _624;
        float _693 = max(0.0f, mad(-0.21492856740951538f, _626, mad(-0.2365107536315918f, _625, (_683 * 1.4514392614364624f))));
        float _694 = max(0.0f, mad(-0.09967592358589172f, _626, mad(1.17622971534729f, _625, (_683 * -0.07655377686023712f))));
        float _695 = max(0.0f, mad(0.9977163076400757f, _626, mad(-0.006032449658960104f, _625, (_683 * 0.008316148072481155f))));
        float _696 = dot(float3(_693, _694, _695), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
        float _706 = 1.0f - tonemap_toe;
        float _707 = _706 + tonemap_black_clip;
        float _709 = (1.0f - tonemap_shoulder) + tonemap_white_clip;
        if (tonemap_toe > 0.800000011920929f) {
          _726 = (((0.8199999928474426f - tonemap_toe) / tonemap_slope) + -0.7447274923324585f);
        } else {
          float _717 = (tonemap_black_clip + 0.18000000715255737f) / _707;
          _726 = (-0.7447274923324585f - ((log2(_717 / (2.0f - _717)) * 0.3465735912322998f) * (_707 / tonemap_slope)));
        }
        float _728 = (_706 / tonemap_slope) - _726;
        float _730 = (tonemap_shoulder / tonemap_slope) - _728;
        float _734 = log2(lerp(_696, _693, 0.9599999785423279f)) * 0.3010300099849701f;
        float _735 = log2(lerp(_696, _694, 0.9599999785423279f)) * 0.3010300099849701f;
        float _736 = log2(lerp(_696, _695, 0.9599999785423279f)) * 0.3010300099849701f;
        float _740 = (_734 + _728) * tonemap_slope;
        float _741 = (_735 + _728) * tonemap_slope;
        float _742 = (_736 + _728) * tonemap_slope;
        float _743 = _707 * 2.0f;
        float _745 = (tonemap_slope * -2.0f) / _707;
        float _746 = _734 - _726;
        float _747 = _735 - _726;
        float _748 = _736 - _726;
        float _767 = tonemap_white_clip + 1.0f;
        float _768 = _709 * 2.0f;
        float _770 = (tonemap_slope * 2.0f) / _709;
        float _795 = select((_734 < _726), ((_743 / (exp2((_746 * 1.4426950216293335f) * _745) + 1.0f)) - tonemap_black_clip), _740);
        float _796 = select((_735 < _726), ((_743 / (exp2((_747 * 1.4426950216293335f) * _745) + 1.0f)) - tonemap_black_clip), _741);
        float _797 = select((_736 < _726), ((_743 / (exp2((_745 * 1.4426950216293335f) * _748) + 1.0f)) - tonemap_black_clip), _742);
        float _804 = _730 - _726;
        float _808 = saturate(_746 / _804);
        float _809 = saturate(_747 / _804);
        float _810 = saturate(_748 / _804);
        bool _811 = (_730 < _726);
        float _815 = select(_811, (1.0f - _808), _808);
        float _816 = select(_811, (1.0f - _809), _809);
        float _817 = select(_811, (1.0f - _810), _810);
        float _836 = (((_815 * _815) * (select((_734 > _730), (_767 - (_768 / (exp2(((_734 - _730) * 1.4426950216293335f) * _770) + 1.0f))), _740) - _795)) * (3.0f - (_815 * 2.0f))) + _795;
        float _837 = (((_816 * _816) * (select((_735 > _730), (_767 - (_768 / (exp2(((_735 - _730) * 1.4426950216293335f) * _770) + 1.0f))), _741) - _796)) * (3.0f - (_816 * 2.0f))) + _796;
        float _838 = (((_817 * _817) * (select((_736 > _730), (_767 - (_768 / (exp2(((_736 - _730) * 1.4426950216293335f) * _770) + 1.0f))), _742) - _797)) * (3.0f - (_817 * 2.0f))) + _797;
        float _839 = dot(float3(_836, _837, _838), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
        _881 = max(0.0f, (lerp(_839, _836, 0.9300000071525574f)));
        _882 = max(0.0f, (lerp(_839, _837, 0.9300000071525574f)));
        _883 = max(0.0f, (lerp(_839, _838, 0.9300000071525574f)));
      } else {
        _881 = saturate((((_420 * 2.509999990463257f) + 0.029999999329447746f) * _420) / ((((_420 * 2.430000066757202f) + 0.5899999737739563f) * _420) + 0.14000000059604645f));
        _882 = saturate((((_421 * 2.509999990463257f) + 0.029999999329447746f) * _421) / ((((_421 * 2.430000066757202f) + 0.5899999737739563f) * _421) + 0.14000000059604645f));
        _883 = saturate((((_422 * 2.509999990463257f) + 0.029999999329447746f) * _422) / ((((_422 * 2.430000066757202f) + 0.5899999737739563f) * _422) + 0.14000000059604645f));
      }
    }
  } else {
    _881 = _420;
    _882 = _421;
    _883 = _422;
  }
  float3 lut_input_color = float3(_881, _882, _883);

  float _890 = (pow(_881, 0.4545454680919647f));
  float _891 = (pow(_882, 0.4545454680919647f));
  float _892 = (pow(_883, 0.4545454680919647f));
  float _893 = TEXCOORD.x + -0.5f;
  float _894 = TEXCOORD.y + -0.5f;
  float _901 = (vignette_scale_falloff_opacity.y * 1.4427000284194946f) + 1.4427000284194946f;
  float _914 = 1.0f - saturate(exp2((_901 * (1.0f - dot(float2(_893, _894), float2(_893, _894)))) - _901) * vignette_scale_falloff_opacity.x);
  float _923 = vignette_enabled * vignette_scale_falloff_opacity.z;
  float _933 = ((((1.0f - ((1.0f - vignette_color.x) * _914)) * _890) - _890) * _923) + _890;
  float _934 = ((((1.0f - ((1.0f - vignette_color.y) * _914)) * _891) - _891) * _923) + _891;
  float _935 = ((((1.0f - ((1.0f - vignette_color.z) * _914)) * _892) - _892) * _923) + _892;
  [branch]
  if (!(grey_scale_enabled == 0.0f)) {
    float _946 = max(dot(float3(_933, _934, _935), float3(grey_scale_weights.x, grey_scale_weights.y, grey_scale_weights.z)), 0.0f);
    _957 = (lerp(_933, _946, grey_scale_amount));
    _958 = (lerp(_934, _946, grey_scale_amount));
    _959 = (lerp(_935, _946, grey_scale_amount));
  } else {
    _957 = _933;
    _958 = _934;
    _959 = _935;
  }
  [branch]
  if (!(color_grading_enabled == 0.0f)) {
    float4 _972 = __tex_virtual_color_grading.SampleLevel(__samp_virtual_color_grading, float3(((saturate(_957) * 0.9375f) + 0.03125f), ((saturate(_958) * 0.9375f) + 0.03125f), ((saturate(_959) * 0.9375f) + 0.03125f)), 0.0f);
    _986 = (lerp(_957, _972.x, color_grading_enabled));
    _987 = (lerp(_958, _972.y, color_grading_enabled));
    _988 = (lerp(_959, _972.z, color_grading_enabled));
  } else {
    _986 = _957;
    _987 = _958;
    _988 = _959;
  }
  SV_Target.x = _986;
  SV_Target.y = _987;
  SV_Target.z = _988;

  SV_Target.rgb = Tonemap(untonemapped_bt709, SV_Target.rgb);

  SV_Target.w = _19.w;
  return SV_Target;
}
