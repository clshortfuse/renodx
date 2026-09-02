add_renodx_runtime_addon(descriptor_cache_race_addon addon.cpp)

add_renodx_runtime_executable(
  descriptor_cache_race_dx12_app
  dx12_app.cpp
  d3d12
  dxgi
)
add_renodx_runtime_executable(descriptor_cache_race_tests tests.cpp)
add_dependencies(descriptor_cache_race_tests
  descriptor_cache_race_addon
  descriptor_cache_race_dx12_app
  renodx_test_reshade_runtime
)
add_dependencies(renodx_test_suites descriptor_cache_race_tests)

add_test(
  NAME descriptor_cache_race_d3d12
  COMMAND descriptor_cache_race_tests
    $<TARGET_FILE:descriptor_cache_race_dx12_app>
    $<TARGET_FILE:descriptor_cache_race_addon>
    ${RENODX_TEST_RESHADE_DIR}
)
set_tests_properties(descriptor_cache_race_d3d12 PROPERTIES
  LABELS "descriptor;cache;race;runtime;d3d12"
  TIMEOUT 60
)