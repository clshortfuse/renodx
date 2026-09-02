add_renodx_runtime_addon(shader_injection_behavior_addon addon.cpp)

add_renodx_runtime_executable(
  shader_injection_behavior_dx12_app
  dx12_app.cpp
  d3d12
  dxgi
)
add_renodx_runtime_executable(shader_injection_behavior_tests tests.cpp)
add_dependencies(shader_injection_behavior_tests
  shader_injection_behavior_addon
  shader_injection_behavior_dx12_app
  renodx_test_reshade_runtime
)
add_dependencies(renodx_test_suites shader_injection_behavior_tests)

add_test(
  NAME shader_injection_behavior_d3d12
  COMMAND shader_injection_behavior_tests
    root-signature
    $<TARGET_FILE:shader_injection_behavior_dx12_app>
    $<TARGET_FILE:shader_injection_behavior_addon>
    ${RENODX_TEST_RESHADE_DIR}
)
set_tests_properties(shader_injection_behavior_d3d12 PROPERTIES
  LABELS "shader_injection;root_signature;runtime;d3d12"
  TIMEOUT 60
)

add_test(
  NAME descriptor_range_ownership_d3d12
  COMMAND shader_injection_behavior_tests
    descriptor-ownership
    $<TARGET_FILE:shader_injection_behavior_dx12_app>
    $<TARGET_FILE:shader_injection_behavior_addon>
    ${RENODX_TEST_RESHADE_DIR}
)
set_tests_properties(descriptor_range_ownership_d3d12 PROPERTIES
  LABELS "shader_injection;descriptor;ownership;runtime;d3d12"
  TIMEOUT 60
)