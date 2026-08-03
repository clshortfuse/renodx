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

find_package(Vulkan QUIET)
if(Vulkan_FOUND)
  add_renodx_runtime_executable(
    resource_upgrade_transfer_vulkan_app
    vulkan_app.cpp
    Vulkan::Vulkan
  )
  add_renodx_runtime_executable(resource_upgrade_transfer_vulkan_tests vulkan_tests.cpp)
  add_dependencies(resource_upgrade_transfer_vulkan_tests
    resource_upgrade_transfer_addon
    resource_upgrade_transfer_vulkan_app
    renodx_test_reshade_runtime
  )
  add_dependencies(renodx_test_suites resource_upgrade_transfer_vulkan_tests)

  foreach(format IN ITEMS rgba8 rgb10a2)
    add_test(
      NAME resource_upgrade_transfer_vulkan_${format}
      COMMAND resource_upgrade_transfer_vulkan_tests
        ${format}
        $<TARGET_FILE:resource_upgrade_transfer_vulkan_app>
        $<TARGET_FILE:resource_upgrade_transfer_addon>
        ${RENODX_TEST_RESHADE_DIR}
    )
    set_tests_properties(resource_upgrade_transfer_vulkan_${format} PROPERTIES
      LABELS "resource_upgrade;transfer;runtime;vulkan"
      TIMEOUT 60
    )

    add_test(
      NAME resource_upgrade_transfer_vulkan_baseline_${format}
      COMMAND resource_upgrade_transfer_vulkan_tests
        baseline-${format}
        $<TARGET_FILE:resource_upgrade_transfer_vulkan_app>
        $<TARGET_FILE:resource_upgrade_transfer_addon>
        ${RENODX_TEST_RESHADE_DIR}
    )
    set_tests_properties(resource_upgrade_transfer_vulkan_baseline_${format} PROPERTIES
      LABELS "resource_upgrade;transfer;runtime;vulkan;control"
      TIMEOUT 60
    )

    add_test(
      NAME resource_upgrade_transfer_vulkan_upgraded_texels_${format}
      COMMAND resource_upgrade_transfer_vulkan_tests
        inspect-${format}
        $<TARGET_FILE:resource_upgrade_transfer_vulkan_app>
        $<TARGET_FILE:resource_upgrade_transfer_addon>
        ${RENODX_TEST_RESHADE_DIR}
    )
    set_tests_properties(resource_upgrade_transfer_vulkan_upgraded_texels_${format} PROPERTIES
      LABELS "resource_upgrade;transfer;runtime;vulkan;upgraded_texels"
      TIMEOUT 60
    )

    add_test(
      NAME resource_upgrade_transfer_vulkan_bridge_fallback_${format}
      COMMAND resource_upgrade_transfer_vulkan_tests
        direct-${format}
        $<TARGET_FILE:resource_upgrade_transfer_vulkan_app>
        $<TARGET_FILE:resource_upgrade_transfer_addon>
        ${RENODX_TEST_RESHADE_DIR}
    )
    set_tests_properties(resource_upgrade_transfer_vulkan_bridge_fallback_${format} PROPERTIES
      LABELS "resource_upgrade;transfer;runtime;vulkan;bridge_fallback"
      TIMEOUT 60
    )

    add_test(
      NAME resource_upgrade_transfer_vulkan_clone_copy_usage_${format}
      COMMAND resource_upgrade_transfer_vulkan_tests
        limited-${format}
        $<TARGET_FILE:resource_upgrade_transfer_vulkan_app>
        $<TARGET_FILE:resource_upgrade_transfer_addon>
        ${RENODX_TEST_RESHADE_DIR}
    )
    set_tests_properties(resource_upgrade_transfer_vulkan_clone_copy_usage_${format} PROPERTIES
      LABELS "resource_upgrade;transfer;runtime;vulkan;copy_usage;limited_usage"
      TIMEOUT 60
    )

    add_test(
      NAME resource_upgrade_transfer_vulkan_clone_bridge_fallback_${format}
      COMMAND resource_upgrade_transfer_vulkan_tests
        preserve-limited-${format}
        $<TARGET_FILE:resource_upgrade_transfer_vulkan_app>
        $<TARGET_FILE:resource_upgrade_transfer_addon>
        ${RENODX_TEST_RESHADE_DIR}
    )
    set_tests_properties(resource_upgrade_transfer_vulkan_clone_bridge_fallback_${format} PROPERTIES
      LABELS "resource_upgrade;transfer;runtime;vulkan;bridge_fallback;limited_usage"
      TIMEOUT 60
    )
  endforeach()
endif()