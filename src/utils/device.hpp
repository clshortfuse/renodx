#pragma once

#include <include/reshade.hpp>

#include "./directx.hpp"

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

[[nodiscard]] static bool IsD3D9ExDevice(reshade::api::device* device) {
  if (device == nullptr || device->get_api() != reshade::api::device_api::d3d9) return false;
  auto* native_device =
      reinterpret_cast<IDirect3DDevice9*>(device->get_native());  // NOLINT(performance-no-int-to-ptr)
  return renodx::utils::directx::IsD3D9ExDevice(native_device);
}

}  // namespace renodx::utils::device