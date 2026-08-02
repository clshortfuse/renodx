add_renodx_runtime_addon(render_pass_behavior_addon addon.cpp d3dcompiler)

add_renodx_runtime_executable(
  render_pass_behavior_dx12_app
  dx12_app.cpp
  d3d12
  dxgi
)
add_renodx_runtime_executable(render_pass_behavior_tests tests.cpp)
add_dependencies(render_pass_behavior_tests
  render_pass_behavior_addon
  render_pass_behavior_dx12_app
  renodx_test_reshade_runtime
)
add_dependencies(renodx_test_suites render_pass_behavior_tests)

add_test(
  NAME render_pass_behavior_d3d12
  COMMAND render_pass_behavior_tests
    $<TARGET_FILE:render_pass_behavior_dx12_app>
    $<TARGET_FILE:render_pass_behavior_addon>
    ${RENODX_TEST_RESHADE_DIR}
)
set_tests_properties(render_pass_behavior_d3d12 PROPERTIES
  LABELS "render_pass;runtime;d3d12"
  TIMEOUT 60
)