#pragma once

#include <include/reshade.hpp>

namespace renodx::utils::device {

static bool IsDirectX(const reshade::api::device_api& device_api) {
  switch (device_api) {
    case reshade::api::device_api::d3d9:
    case reshade::api::device_api::d3d10:
    case reshade::api::device_api::d3d11:
    case reshade::api::device_api::d3d12:
      return true;
    default:
      return false;
  }
}

static bool IsDirectX(const reshade::api::device* device) {
  return IsDirectX(device->get_api());
}

static bool IsDXGI(const reshade::api::device_api& device_api) {
  switch (device_api) {
    case reshade::api::device_api::d3d10:
    case reshade::api::device_api::d3d11:
    case reshade::api::device_api::d3d12:
      return true;
    default:
      return false;
  }
}

static bool IsDXGI(const reshade::api::device* device) {
  return IsDXGI(device->get_api());
}

}  // namespace renodx::utils::device