#include <iostream>

#include <d3dcompiler.h>

inline std::ostream& operator<<(std::ostream& stream, D3D_INCLUDE_TYPE type) {
  return stream << static_cast<int>(type);
}

#include "src/utils/shader_compiler_watcher.hpp"

int main() {
  namespace watcher = renodx::utils::shader::compiler::watcher;

  watcher::internal::shared_compile_pending.store(false);
  watcher::internal::shared_device_api.store(static_cast<int>(reshade::api::device_api::d3d11));
  watcher::SetDeviceApi(reshade::api::device_api::vulkan);

  const bool api_changed = watcher::internal::shared_device_api.load()
                           == static_cast<int>(reshade::api::device_api::vulkan);
  const bool compile_queued = watcher::internal::shared_compile_pending.load();
  watcher::internal::shared_compile_pending.store(false);
  watcher::SetDeviceApi(reshade::api::device_api::vulkan);
  const bool redundant_compile_queued = watcher::internal::shared_compile_pending.load();
  const bool passed = api_changed && compile_queued && !redundant_compile_queued;
  std::cout << (passed ? "PASS\n" : "FAIL\n")
            << "api_changed=" << api_changed << '\n'
            << "compile_queued=" << compile_queued << '\n'
            << "redundant_compile_queued=" << redundant_compile_queued << '\n';
  return passed ? 0 : 1;
}