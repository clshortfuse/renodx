
#include <dxgi1_6.h>
#include <optional>
#include <vector>

namespace renodx::utils::platform {

std::vector<DISPLAYCONFIG_PATH_INFO> GetPathInfos() {
  for (LONG result = ERROR_INSUFFICIENT_BUFFER;
       result == ERROR_INSUFFICIENT_BUFFER;) {
    uint32_t path_elements;
    uint32_t mode_elements;
    if (GetDisplayConfigBufferSizes(QDC_ONLY_ACTIVE_PATHS, &path_elements,
                                    &mode_elements)
        != ERROR_SUCCESS) {
      return {};
    }
    std::vector<DISPLAYCONFIG_PATH_INFO> path_infos(path_elements);
    std::vector<DISPLAYCONFIG_MODE_INFO> mode_infos(mode_elements);
    result = QueryDisplayConfig(QDC_ONLY_ACTIVE_PATHS, &path_elements,
                                path_infos.data(), &mode_elements,
                                mode_infos.data(), nullptr);
    if (result == ERROR_SUCCESS) {
      path_infos.resize(path_elements);
      return path_infos;
    }
  }
  return {};
}

std::optional<DISPLAYCONFIG_PATH_INFO> GetPathInfo(HMONITOR monitor) {
  // Get the monitor name.
  MONITORINFOEX monitor_info = {};
  monitor_info.cbSize = sizeof(monitor_info);
  if (!GetMonitorInfo(monitor, &monitor_info)) return std::nullopt;

  // Look for a path info with a matching name.
  std::vector<DISPLAYCONFIG_PATH_INFO> path_infos = GetPathInfos();
  for (const auto& info : path_infos) {
    DISPLAYCONFIG_SOURCE_DEVICE_NAME device_name = {};
    device_name.header.type = DISPLAYCONFIG_DEVICE_INFO_GET_SOURCE_NAME;
    device_name.header.size = sizeof(device_name);
    device_name.header.adapterId = info.sourceInfo.adapterId;
    device_name.header.id = info.sourceInfo.id;
    if (DisplayConfigGetDeviceInfo(&device_name.header) != ERROR_SUCCESS) continue;
    wchar_t sz_device_wide[32];
    size_t out_size;
    if (mbstowcs_s(&out_size, sz_device_wide, monitor_info.szDevice, 32) != ERROR_SUCCESS) continue;
    if (out_size == 0) continue;
    if (wcscmp(sz_device_wide, device_name.viewGdiDeviceName) != 0) continue;

    return info;
  }
  return std::nullopt;
}

}  // namespace renodx::utils::platform