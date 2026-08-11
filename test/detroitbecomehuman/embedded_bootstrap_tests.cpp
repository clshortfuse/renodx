/*
 * SPDX-License-Identifier: MIT
 */

#include <cstdlib>
#include <iostream>
#include <string>
#include <vector>

#include "src/games/detroitbecomehuman/dlss/embedded_bootstrap.hpp"

namespace embedded =
    renodx::games::detroitbecomehuman::dlss::embedded;

namespace {

void Expect(bool condition, const char* message) {
  if (condition) return;
  std::cerr << "FAIL: " << message << '\n';
  std::exit(EXIT_FAILURE);
}

}  // namespace

int main() {
  struct FakeDispatchable {
    void* dispatch = nullptr;
    std::uintptr_t payload = 0u;
  };
  int parent_dispatch = 1;
  int downstream_dispatch = 2;
  FakeDispatchable parent = {&parent_dispatch, 0x1234u};
  FakeDispatchable child = {&downstream_dispatch, 0x5678u};
  Expect(
      embedded::RestoreVulkanLayerDispatchPointer(&parent, &child),
      "private Vulkan command buffer dispatch repair must succeed");
  Expect(
      child.dispatch == parent.dispatch && child.payload == 0x5678u,
      "dispatch repair must copy only the parent layer dispatch pointer");
  Expect(
      !embedded::RestoreVulkanLayerDispatchPointer(nullptr, &child)
          && !embedded::RestoreVulkanLayerDispatchPointer(&parent, nullptr),
      "dispatch repair must fail closed for null handles");
  parent.dispatch = nullptr;
  Expect(
      !embedded::RestoreVulkanLayerDispatchPointer(&parent, &child),
      "dispatch repair must reject a null parent dispatch table");

  Expect(
      !embedded::NeedsRuntimeCommandTracking(DETROIT_DLSS_MODE_NATIVE, false),
      "Native TAA with non-Retinal DOF must use the command-tracking fast path");
  Expect(
      embedded::kDlssRuntimeEnabled,
      "targeted DLAA runtime must be enabled");
  Expect(
      embedded::NeedsRuntimeCommandTracking(DETROIT_DLSS_MODE_DLAA, false),
      "DLAA must enable targeted command-bind tracking");
  Expect(
      embedded::NeedsEmbeddedBridge(DETROIT_DLSS_MODE_NATIVE, false)
          && embedded::NeedsEmbeddedBridge(DETROIT_DLSS_MODE_DLAA, false),
      "Native TAA and DLAA must load the embedded Vulkan bridge");
  Expect(
      embedded::NeedsRuntimeCommandTracking(DETROIT_DLSS_MODE_NATIVE, true),
      "Retinal DOF must enable runtime command tracking in Native TAA mode");

  std::vector<std::string> entries = {
      "third-party.addon64",
      "subdir\\another.addon64",
  };
  Expect(
      embedded::MergeLoadFromDllMainEntry(
          &entries, "renodx-detroitbecomehuman.addon64"),
      "first insertion must modify the list");
  Expect(entries.size() == 3u, "foreign LoadFromDllMain entries must be preserved");
  Expect(
      !embedded::MergeLoadFromDllMainEntry(
          &entries, "RENODX-DETROITBECOMEHUMAN.ADDON64"),
      "case-insensitive duplicate must be ignored");
  Expect(entries.size() == 3u, "idempotent insertion must not add duplicates");

  embedded::ExtensionCache cache = {
      .schema_version = embedded::kCacheSchemaVersion,
      .ready = true,
      .executable_sha256 = std::string(embedded::kSupportedExecutableSha256),
      .instance_extensions = "VK_KHR_get_physical_device_properties2",
      .device_extensions = "VK_KHR_buffer_device_address;VK_EXT_buffer_device_address",
  };
  Expect(embedded::IsValidCache(cache), "known-good extension cache must validate");
  Expect(
      embedded::CanAttachEarlyHooks(cache),
      "only a known-good cache may enable early Vulkan hooks");
  cache.ready = false;
  Expect(!embedded::IsValidCache(cache), "ready flag is the cache commit marker");
  Expect(
      !embedded::CanAttachEarlyHooks(cache),
      "first-run setup must not attach Vulkan hooks without a committed cache");
  cache.ready = true;
  cache.schema_version += 1u;
  Expect(!embedded::IsValidCache(cache), "unknown cache schema must fail closed");
  cache.schema_version = embedded::kCacheSchemaVersion;
  cache.executable_sha256[0] = '0';
  Expect(!embedded::IsValidCache(cache), "wrong executable hash must fail closed");
  cache.executable_sha256 = std::string(embedded::kSupportedExecutableSha256);
  cache.device_extensions = "VK_EXT_one;VK_EXT_one";
  Expect(!embedded::IsValidCache(cache), "duplicate extension names must be rejected");
  cache.device_extensions = "VK_EXT_one;;VK_EXT_two";
  Expect(!embedded::IsValidCache(cache), "empty extension names must be rejected");

  std::cout << "PASS\n";
  return EXIT_SUCCESS;
}
