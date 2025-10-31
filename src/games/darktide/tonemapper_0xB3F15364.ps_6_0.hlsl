#include "./common.hlsl"

Texture2D<float4> __tex_input_texture0 : register(t0);

Texture3D<float4> __tex_virtual_color_grading : register(t1);

Texture2D<float> current_exposure : register(t2);

cbuffer global_environment_settings : register(b0) {
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

cbuffer c0 : register(b1) {
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
  float color_filter_enabled : packoffset(c011.x);
  float4 color_filter_opacity : packoffset(c012.x);
  uint4 amd_lpm[24] : packoffset(c013.x);
};

SamplerState __samp_input_texture0 : register(s0);

SamplerState __samp_virtual_color_grading : register(s1);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD,
  linear float4 TEXCOORD_1 : TEXCOORD1
) : SV_Target {
  float4 SV_Target;
  float4 _10 = __tex_input_texture0.Sample(__samp_input_texture0, float2(TEXCOORD.x, TEXCOORD.y));
  float _15 = current_exposure.Load(int3(0, 0, 0));
  float _17 = _15.x * _10.x;
  float _18 = _15.x * _10.y;
  float _19 = _15.x * _10.z;
  float3 untonemapped_bt709 = float3(_17, _18, _19);  // After exposure

  float _219;
  float _252;
  float _266;
  float _323;
  float _478;
  float _479;
  float _480;
  float _555;
  float _556;
  float _557;
  float _579;
  float _580;
  float _581;
  float _608;
  float _609;
  float _610;
  [branch]
  if (!(tone_mapping_enabled == 0.0f)) {
    if (!(amd_lpm_tone_mapping_enabled == 0.0f)) {
      float _27 = max(0.0f, _17);
      float _28 = max(0.0f, _18);
      float _29 = max(0.0f, _19);
      float _49 = asfloat((amd_lpm[2].y));
      float _50 = asfloat((amd_lpm[2].z));
      float _51 = asfloat((amd_lpm[2].w));
      float _61 = asfloat((amd_lpm[1].z));
      float _62 = asfloat((amd_lpm[1].w));
      float _63 = asfloat((amd_lpm[2].x));
      float _66 = 1.0f / max(_27, max(_28, _29));
      float _72 = exp2(log2(_66 * _27) * asfloat((amd_lpm[0].x)));
      float _75 = exp2(log2(_66 * _28) * asfloat((amd_lpm[0].y)));
      float _78 = exp2(log2(_66 * _29) * asfloat((amd_lpm[0].z)));
      float _86 = exp2(log2(((_62 * _28) + (_61 * _27)) + (_63 * _29)) * asfloat((amd_lpm[0].w)));
      float _90 = (1.0f / ((_86 * asfloat((amd_lpm[1].x))) + asfloat((amd_lpm[1].y)))) * _86;
      float _98 = saturate(_90 * (1.0f / (((_75 * _62) + (_72 * _61)) + (_78 * _63))));
      float _100 = saturate(_98 * _72);
      float _102 = saturate(_98 * _75);
      float _104 = saturate(_98 * _78);
      float _106 = _49 - (_100 * _49);
      float _108 = _50 - (_102 * _50);
      float _110 = _51 - (_104 * _51);
      float _124 = (1.0f / (((_108 * _62) + (_106 * _61)) + (_110 * _63))) * saturate(((_90 - (_100 * _61)) - (_102 * _62)) - (_104 * _63));
      float _127 = saturate((_124 * _106) + _100);
      float _130 = saturate((_124 * _108) + _102);
      float _133 = saturate((_124 * _110) + _104);
      float _140 = saturate(((_90 - (_127 * _61)) - (_130 * _62)) - (_133 * _63));
      _478 = saturate((_140 * asfloat((amd_lpm[3].x))) + _127);
      _479 = saturate((_140 * asfloat((amd_lpm[3].y))) + _130);
      _480 = saturate((_140 * asfloat((amd_lpm[3].z))) + _133);
    } else {
      if (!(tonemap_use_custom == 0.0f)) {
        float _164 = mad(0.16386905312538147f, _19, mad(0.14067868888378143f, _18, (_17 * 0.6954522132873535f)));
        float _167 = mad(0.0955343246459961f, _19, mad(0.8596711158752441f, _18, (_17 * 0.044794581830501556f)));
        float _170 = mad(1.0015007257461548f, _19, mad(0.004025210160762072f, _18, (_17 * -0.005525882821530104f)));
        float _174 = max(max(_164, _167), _170);
        float _179 = (max(_174, 1.000000013351432e-10f) - max(min(min(_164, _167), _170), 1.000000013351432e-10f)) / max(_174, 0.009999999776482582f);
        float _192 = ((_167 + _164) + _170) + (sqrt((((_170 - _167) * _170) + ((_167 - _164) * _167)) + ((_164 - _170) * _164)) * 1.75f);
        float _193 = _192 * 0.3333333432674408f;
        float _194 = _179 + -0.4000000059604645f;
        float _195 = _194 * 5.0f;
        float _199 = max((1.0f - abs(_194 * 2.5f)), 0.0f);
        float _210 = ((float((int)(((int)(uint)((bool)(_195 > 0.0f))) - ((int)(uint)((bool)(_195 < 0.0f))))) * (1.0f - (_199 * _199))) + 1.0f) * 0.02500000037252903f;
        do {
          if (!(_193 <= 0.0533333346247673f)) {
            if (!(_193 >= 0.1599999964237213f)) {
              _219 = (((0.23999999463558197f / _192) + -0.5f) * _210);
            } else {
              _219 = 0.0f;
            }
          } else {
            _219 = _210;
          }
          float _220 = _219 + 1.0f;
          float _221 = _220 * _164;
          float _222 = _220 * _167;
          float _223 = _220 * _170;
          do {
            if (!((bool)(_221 == _222) && (bool)(_222 == _223))) {
              float _230 = ((_221 * 2.0f) - _222) - _223;
              float _233 = ((_167 - _170) * 1.7320507764816284f) * _220;
              float _235 = atan(_233 / _230);
              bool _238 = (_230 < 0.0f);
              bool _239 = (_230 == 0.0f);
              bool _240 = (_233 >= 0.0f);
              bool _241 = (_233 < 0.0f);
              _252 = select((_240 && _239), 90.0f, select((_241 && _239), -90.0f, (select((_241 && _238), (_235 + -3.1415927410125732f), select((_240 && _238), (_235 + 3.1415927410125732f), _235)) * 57.295780181884766f)));
            } else {
              _252 = 0.0f;
            }
            float _257 = min(max(select((_252 < 0.0f), (_252 + 360.0f), _252), 0.0f), 360.0f);
            do {
              if (_257 < -180.0f) {
                _266 = (_257 + 360.0f);
              } else {
                if (_257 > 180.0f) {
                  _266 = (_257 + -360.0f);
                } else {
                  _266 = _257;
                }
              }
              float _270 = saturate(1.0f - abs(_266 * 0.014814814552664757f));
              float _274 = (_270 * _270) * (3.0f - (_270 * 2.0f));
              float _280 = ((_274 * _274) * ((_179 * 0.18000000715255737f) * (0.029999999329447746f - _221))) + _221;
              float _290 = max(0.0f, mad(-0.21492856740951538f, _223, mad(-0.2365107536315918f, _222, (_280 * 1.4514392614364624f))));
              float _291 = max(0.0f, mad(-0.09967592358589172f, _223, mad(1.17622971534729f, _222, (_280 * -0.07655377686023712f))));
              float _292 = max(0.0f, mad(0.9977163076400757f, _223, mad(-0.006032449658960104f, _222, (_280 * 0.008316148072481155f))));
              float _293 = dot(float3(_290, _291, _292), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
              float _303 = 1.0f - tonemap_toe;
              float _304 = _303 + tonemap_black_clip;
              float _306 = (1.0f - tonemap_shoulder) + tonemap_white_clip;
              do {
                if (tonemap_toe > 0.800000011920929f) {
                  _323 = (((0.8199999928474426f - tonemap_toe) / tonemap_slope) + -0.7447274923324585f);
                } else {
                  float _314 = (tonemap_black_clip + 0.18000000715255737f) / _304;
                  _323 = (-0.7447274923324585f - ((log2(_314 / (2.0f - _314)) * 0.3465735912322998f) * (_304 / tonemap_slope)));
                }
                float _325 = (_303 / tonemap_slope) - _323;
                float _327 = (tonemap_shoulder / tonemap_slope) - _325;
                float _331 = log2(lerp(_293, _290, 0.9599999785423279f)) * 0.3010300099849701f;
                float _332 = log2(lerp(_293, _291, 0.9599999785423279f)) * 0.3010300099849701f;
                float _333 = log2(lerp(_293, _292, 0.9599999785423279f)) * 0.3010300099849701f;
                float _337 = (_331 + _325) * tonemap_slope;
                float _338 = (_332 + _325) * tonemap_slope;
                float _339 = (_333 + _325) * tonemap_slope;
                float _340 = _304 * 2.0f;
                float _342 = (tonemap_slope * -2.0f) / _304;
                float _343 = _331 - _323;
                float _344 = _332 - _323;
                float _345 = _333 - _323;
                float _364 = tonemap_white_clip + 1.0f;
                float _365 = _306 * 2.0f;
                float _367 = (tonemap_slope * 2.0f) / _306;
                float _392 = select((_331 < _323), ((_340 / (exp2((_343 * 1.4426950216293335f) * _342) + 1.0f)) - tonemap_black_clip), _337);
                float _393 = select((_332 < _323), ((_340 / (exp2((_344 * 1.4426950216293335f) * _342) + 1.0f)) - tonemap_black_clip), _338);
                float _394 = select((_333 < _323), ((_340 / (exp2((_342 * 1.4426950216293335f) * _345) + 1.0f)) - tonemap_black_clip), _339);
                float _401 = _327 - _323;
                float _405 = saturate(_343 / _401);
                float _406 = saturate(_344 / _401);
                float _407 = saturate(_345 / _401);
                bool _408 = (_327 < _323);
                float _412 = select(_408, (1.0f - _405), _405);
                float _413 = select(_408, (1.0f - _406), _406);
                float _414 = select(_408, (1.0f - _407), _407);
                float _433 = (((_412 * _412) * (select((_331 > _327), (_364 - (_365 / (exp2(((_331 - _327) * 1.4426950216293335f) * _367) + 1.0f))), _337) - _392)) * (3.0f - (_412 * 2.0f))) + _392;
                float _434 = (((_413 * _413) * (select((_332 > _327), (_364 - (_365 / (exp2(((_332 - _327) * 1.4426950216293335f) * _367) + 1.0f))), _338) - _393)) * (3.0f - (_413 * 2.0f))) + _393;
                float _435 = (((_414 * _414) * (select((_333 > _327), (_364 - (_365 / (exp2(((_333 - _327) * 1.4426950216293335f) * _367) + 1.0f))), _339) - _394)) * (3.0f - (_414 * 2.0f))) + _394;
                float _436 = dot(float3(_433, _434, _435), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                _478 = max(0.0f, (lerp(_436, _433, 0.9300000071525574f)));
                _479 = max(0.0f, (lerp(_436, _434, 0.9300000071525574f)));
                _480 = max(0.0f, (lerp(_436, _435, 0.9300000071525574f)));
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } else {
        _478 = saturate((((_17 * 2.509999990463257f) + 0.029999999329447746f) * _17) / ((((_17 * 2.430000066757202f) + 0.5899999737739563f) * _17) + 0.14000000059604645f));
        _479 = saturate((((_18 * 2.509999990463257f) + 0.029999999329447746f) * _18) / ((((_18 * 2.430000066757202f) + 0.5899999737739563f) * _18) + 0.14000000059604645f));
        _480 = saturate((((_19 * 2.509999990463257f) + 0.029999999329447746f) * _19) / ((((_19 * 2.430000066757202f) + 0.5899999737739563f) * _19) + 0.14000000059604645f));
      }
    }
  } else {
    _478 = _17;
    _479 = _18;
    _480 = _19;
  }
  float _487 = (pow(_478, 0.4545454680919647f));
  float _488 = (pow(_479, 0.4545454680919647f));
  float _489 = (pow(_480, 0.4545454680919647f));
  float _490 = TEXCOORD.x + -0.5f;
  float _491 = TEXCOORD.y + -0.5f;
  float _498 = (vignette_scale_falloff_opacity.y * 1.4427000284194946f) + 1.4427000284194946f;
  float _511 = 1.0f - saturate(exp2((_498 * (1.0f - dot(float2(_490, _491), float2(_490, _491)))) - _498) * vignette_scale_falloff_opacity.x);
  float _520 = vignette_enabled * vignette_scale_falloff_opacity.z;
  float _530 = ((((1.0f - ((1.0f - vignette_color.x) * _511)) * _487) - _487) * _520) + _487;
  float _531 = ((((1.0f - ((1.0f - vignette_color.y) * _511)) * _488) - _488) * _520) + _488;
  float _532 = ((((1.0f - ((1.0f - vignette_color.z) * _511)) * _489) - _489) * _520) + _489;
  [branch]
  if (!(color_filter_enabled == 0.0f)) {
    _555 = ((((color_filter_opacity.y * _530) - _530) * color_filter_opacity.x) + _530);
    _556 = ((((color_filter_opacity.z * _531) - _531) * color_filter_opacity.x) + _531);
    _557 = ((((color_filter_opacity.w * _532) - _532) * color_filter_opacity.x) + _532);
  } else {
    _555 = _530;
    _556 = _531;
    _557 = _532;
  }
  [branch]
  if (!(grey_scale_enabled == 0.0f)) {
    float _568 = max(dot(float3(_555, _556, _557), float3(grey_scale_weights.x, grey_scale_weights.y, grey_scale_weights.z)), 0.0f);
    _579 = (lerp(_555, _568, grey_scale_amount));
    _580 = (lerp(_556, _568, grey_scale_amount));
    _581 = (lerp(_557, _568, grey_scale_amount));
  } else {
    _579 = _555;
    _580 = _556;
    _581 = _557;
  }
  [branch]
  if (!(color_grading_enabled == 0.0f)) {
    float4 _594 = __tex_virtual_color_grading.SampleLevel(__samp_virtual_color_grading, float3(((saturate(_579) * 0.9375f) + 0.03125f), ((saturate(_580) * 0.9375f) + 0.03125f), ((saturate(_581) * 0.9375f) + 0.03125f)), 0.0f);
    _608 = (lerp(_579, _594.x, color_grading_enabled));
    _609 = (lerp(_580, _594.y, color_grading_enabled));
    _610 = (lerp(_581, _594.z, color_grading_enabled));
  } else {
    _608 = _579;
    _609 = _580;
    _610 = _581;
  }
  SV_Target.x = _608;
  SV_Target.y = _609;
  SV_Target.z = _610;

  SV_Target.rgb = Tonemap(untonemapped_bt709, SV_Target.rgb);

  SV_Target.w = _10.w;
  return SV_Target;
}
