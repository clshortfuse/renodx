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
  cache.ready = false;
  Expect(!embedded::IsValidCache(cache), "ready flag is the cache commit marker");
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
