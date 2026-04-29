#pragma once

#include <limits>

#include <include/reshade.hpp>

#include "./logging.hpp"

namespace alienisolation::aliasisolation::resource_view_sanitizer {

inline bool logged_texture_3d_default_view = false;

inline bool OnCreateResourceView(
    reshade::api::device* device,
    reshade::api::resource resource,
    reshade::api::resource_usage usage_type,
    reshade::api::resource_view_desc& desc) {
  if (device == nullptr || resource.handle == 0u) return false;
  if (desc.type != reshade::api::resource_view_type::unknown) return false;

  const auto resource_desc = device->get_resource_desc(resource);
  if (resource_desc.type != reshade::api::resource_type::texture_3d) return false;

  desc.type = reshade::api::resource_view_type::texture_3d;
  if (desc.format == reshade::api::format::unknown) {
    desc.format = resource_desc.texture.format;
  }
  desc.texture.first_level = 0u;
  desc.texture.level_count = usage_type == reshade::api::resource_usage::unordered_access ? 1u : UINT32_MAX;
  desc.texture.first_layer = 0u;
  desc.texture.layer_count = UINT32_MAX;

  if (!logged_texture_3d_default_view) {
    logged_texture_3d_default_view = true;
    logging::Info("populated default Texture3D resource view before resource upgrade hook resource=", logging::Hex(resource.handle),
                  " format=", static_cast<uint32_t>(desc.format),
                  " usage=", static_cast<uint32_t>(usage_type));
  }

  return true;
}

}  // namespace alienisolation::aliasisolation::resource_view_sanitizer
