add_renodx_runtime_addon(resource_upgrade_transfer_addon addon.cpp)

add_renodx_runtime_executable(
  resource_upgrade_transfer_dx12_app
  dx12_app.cpp
  d3d12
  dxgi
)
add_renodx_runtime_executable(resource_upgrade_transfer_tests tests.cpp)
add_dependencies(resource_upgrade_transfer_tests
  resource_upgrade_transfer_addon
  resource_upgrade_transfer_dx12_app
  renodx_test_reshade_runtime
)
add_dependencies(renodx_test_suites resource_upgrade_transfer_tests)

foreach(format IN ITEMS rgba8 rgb10a2)
  add_test(
    NAME resource_upgrade_transfer_d3d12_${format}
    COMMAND resource_upgrade_transfer_tests
      ${format}
      $<TARGET_FILE:resource_upgrade_transfer_dx12_app>
      $<TARGET_FILE:resource_upgrade_transfer_addon>
      ${RENODX_TEST_RESHADE_DIR}
  )
  set_tests_properties(resource_upgrade_transfer_d3d12_${format} PROPERTIES
    LABELS "resource_upgrade;transfer;runtime;d3d12"
    TIMEOUT 60
  )
endforeach()