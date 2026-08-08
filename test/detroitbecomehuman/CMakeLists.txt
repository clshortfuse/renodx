find_package(Python3 REQUIRED COMPONENTS Interpreter)

set(DETROIT_TEST_SOURCE_DIR
    "${RENODX_TEST_REPO_ROOT}/src/games/detroitbecomehuman")
set(DETROIT_GENERATED_EMBED_DIR
    "${CMAKE_BINARY_DIR}/detroitbecomehuman.include/embed")
set(DETROIT_SPIRV_VAL
    "${RENODX_TEST_REPO_ROOT}/bin/spirv-val.exe")
set(DETROIT_SPIRV_CROSS
    "${RENODX_TEST_REPO_ROOT}/bin/spirv-cross.exe")

set(DETROIT_BECOME_HUMAN_EXE "" CACHE FILEPATH
    "Optional DetroitBecomeHuman.exe Build 12158144 for executable contract validation")

foreach(DETROIT_SPIRV_TOOL IN ITEMS DETROIT_SPIRV_VAL DETROIT_SPIRV_CROSS)
  if(NOT EXISTS "${${DETROIT_SPIRV_TOOL}}")
    message(FATAL_ERROR
      "Detroit shader contract requires repo-local tool: ${${DETROIT_SPIRV_TOOL}}")
  endif()
endforeach()

add_test(
  NAME detroitbecomehuman_hdr_cas_gates
  COMMAND ${Python3_EXECUTABLE}
          ${CMAKE_CURRENT_SOURCE_DIR}/test_hdr_cas_gates.py
          --source-dir ${DETROIT_TEST_SOURCE_DIR}
)
set_tests_properties(detroitbecomehuman_hdr_cas_gates PROPERTIES
  LABELS "detroitbecomehuman;unit;cpu;hdr;cas"
)

add_test(
  NAME detroitbecomehuman_ui_brightness_gates
  COMMAND ${Python3_EXECUTABLE}
          ${CMAKE_CURRENT_SOURCE_DIR}/test_ui_brightness_gates.py
          --source-dir ${DETROIT_TEST_SOURCE_DIR}
)
set_tests_properties(detroitbecomehuman_ui_brightness_gates PROPERTIES
  LABELS "detroitbecomehuman;unit;cpu;hdr;ui"
)

add_test(
  NAME detroitbecomehuman_psychov_contract
  COMMAND ${Python3_EXECUTABLE}
          ${CMAKE_CURRENT_SOURCE_DIR}/test_psychov_contract.py
          --source-dir ${DETROIT_TEST_SOURCE_DIR}
)
set_tests_properties(detroitbecomehuman_psychov_contract PROPERTIES
  LABELS "detroitbecomehuman;unit;cpu;hdr;psychov"
)

add_test(
  NAME detroitbecomehuman_dof_contract
  COMMAND ${Python3_EXECUTABLE}
          ${CMAKE_CURRENT_SOURCE_DIR}/test_dof_contract.py
          --source-dir ${DETROIT_TEST_SOURCE_DIR}
)
set_tests_properties(detroitbecomehuman_dof_contract PROPERTIES
  LABELS "detroitbecomehuman;contract;cpu;dof;vulkan"
)

add_renodx_runtime_executable(
  detroitbecomehuman_ultrawide_patch_tests
  ultrawide_patch_tests.cpp
)
add_dependencies(renodx_test_suites detroitbecomehuman_ultrawide_patch_tests)

add_test(
  NAME detroitbecomehuman_ultrawide_patch
  COMMAND detroitbecomehuman_ultrawide_patch_tests
)
set_tests_properties(detroitbecomehuman_ultrawide_patch PROPERTIES
  LABELS "detroitbecomehuman;unit;cpu;ultrawide"
)

add_renodx_runtime_executable(
  detroitbecomehuman_dlss_bridge_contract_tests
  dlss_bridge_contract_tests.cpp
)
add_dependencies(
  renodx_test_suites
  detroitbecomehuman_dlss_bridge_contract_tests
)

add_test(
  NAME detroitbecomehuman_dlss_bridge_contract
  COMMAND detroitbecomehuman_dlss_bridge_contract_tests
)

add_renodx_runtime_executable(
  detroitbecomehuman_embedded_bootstrap_tests
  embedded_bootstrap_tests.cpp
)
add_dependencies(renodx_test_suites detroitbecomehuman_embedded_bootstrap_tests)
add_test(
  NAME detroitbecomehuman_embedded_bootstrap
  COMMAND detroitbecomehuman_embedded_bootstrap_tests
)
set_tests_properties(detroitbecomehuman_embedded_bootstrap PROPERTIES
  LABELS "detroitbecomehuman;unit;cpu;dlss;bootstrap;fallback"
)

add_test(
  NAME detroitbecomehuman_embedded_hook_contract
  COMMAND ${Python3_EXECUTABLE}
          ${CMAKE_CURRENT_SOURCE_DIR}/test_embedded_hook_contract.py
          --source-dir ${DETROIT_TEST_SOURCE_DIR}
)
set_tests_properties(detroitbecomehuman_embedded_hook_contract PROPERTIES
  LABELS "detroitbecomehuman;contract;cpu;dlss;vulkan;hook"
)
set_tests_properties(detroitbecomehuman_dlss_bridge_contract PROPERTIES
  LABELS "detroitbecomehuman;unit;cpu;dlss;abi"
)

add_renodx_runtime_executable(
  detroitbecomehuman_dlss_policy_tests
  dlss_policy_tests.cpp
)
add_dependencies(
  renodx_test_suites
  detroitbecomehuman_dlss_policy_tests
)

add_test(
  NAME detroitbecomehuman_dlss_policy
  COMMAND detroitbecomehuman_dlss_policy_tests
)
set_tests_properties(detroitbecomehuman_dlss_policy PROPERTIES
  LABELS "detroitbecomehuman;unit;cpu;dlss;policy;fallback"
)

add_renodx_runtime_executable(
  detroitbecomehuman_dof_runtime_tests
  dof_runtime_tests.cpp
)
add_dependencies(renodx_test_suites detroitbecomehuman_dof_runtime_tests)

add_test(
  NAME detroitbecomehuman_dof_runtime
  COMMAND detroitbecomehuman_dof_runtime_tests
)
set_tests_properties(detroitbecomehuman_dof_runtime PROPERTIES
  LABELS "detroitbecomehuman;unit;cpu;dof;fallback"
)

add_renodx_runtime_executable(
  detroitbecomehuman_dlss_scale_transition_tests
  dlss_scale_transition_tests.cpp
)
add_dependencies(
  renodx_test_suites
  detroitbecomehuman_dlss_scale_transition_tests
)

add_test(
  NAME detroitbecomehuman_dlss_scale_transition
  COMMAND detroitbecomehuman_dlss_scale_transition_tests
)
set_tests_properties(detroitbecomehuman_dlss_scale_transition PROPERTIES
  LABELS "detroitbecomehuman;unit;cpu;dlss;resolution_scaling;fallback"
)

add_renodx_runtime_executable(
  detroitbecomehuman_feature_lifetime_tests
  feature_lifetime_tests.cpp
)
add_dependencies(
  renodx_test_suites
  detroitbecomehuman_feature_lifetime_tests
)

add_test(
  NAME detroitbecomehuman_feature_lifetime
  COMMAND detroitbecomehuman_feature_lifetime_tests
)
set_tests_properties(detroitbecomehuman_feature_lifetime PROPERTIES
  LABELS "detroitbecomehuman;unit;cpu;dlss;vulkan;lifetime"
)

add_renodx_runtime_executable(
  detroitbecomehuman_taa_contract_tests
  taa_contract_tests.cpp
)
add_dependencies(renodx_test_suites detroitbecomehuman_taa_contract_tests)

add_test(
  NAME detroitbecomehuman_taa_contract
  COMMAND detroitbecomehuman_taa_contract_tests
)
set_tests_properties(detroitbecomehuman_taa_contract PROPERTIES
  LABELS "detroitbecomehuman;unit;cpu;taa;spirv;contract"
)

add_renodx_runtime_executable(
  detroitbecomehuman_rgb9e5_adapter_tests
  rgb9e5_adapter_tests.cpp
)
add_dependencies(renodx_test_suites detroitbecomehuman_rgb9e5_adapter_tests)

add_test(
  NAME detroitbecomehuman_rgb9e5_adapter
  COMMAND detroitbecomehuman_rgb9e5_adapter_tests
)
set_tests_properties(detroitbecomehuman_rgb9e5_adapter PROPERTIES
  LABELS "detroitbecomehuman;unit;cpu;dlss;shader;rgb9e5"
)

add_renodx_runtime_executable(
  detroitbecomehuman_resolution_scaling_tests
  resolution_scaling_tests.cpp
)
add_dependencies(renodx_test_suites detroitbecomehuman_resolution_scaling_tests)

add_test(
  NAME detroitbecomehuman_resolution_scaling
  COMMAND detroitbecomehuman_resolution_scaling_tests
)
set_tests_properties(detroitbecomehuman_resolution_scaling PROPERTIES
  LABELS "detroitbecomehuman;unit;cpu;dlss;resolution_scaling"
)

if(DETROIT_BECOME_HUMAN_EXE)
  add_test(
    NAME detroitbecomehuman_ultrawide_production_contract
    COMMAND detroitbecomehuman_ultrawide_patch_tests
            --exe ${DETROIT_BECOME_HUMAN_EXE}
  )
  set_tests_properties(detroitbecomehuman_ultrawide_production_contract PROPERTIES
    LABELS "detroitbecomehuman;contract;exe;ultrawide"
  )

  add_test(
    NAME detroitbecomehuman_ultrawide_exe_contract
    COMMAND ${Python3_EXECUTABLE}
            ${CMAKE_CURRENT_SOURCE_DIR}/verify_ultrawide_exe.py
            --exe ${DETROIT_BECOME_HUMAN_EXE}
  )
  set_tests_properties(detroitbecomehuman_ultrawide_exe_contract PROPERTIES
    LABELS "detroitbecomehuman;contract;exe;ultrawide"
  )

  add_test(
    NAME detroitbecomehuman_taa_exe_contract
    COMMAND ${Python3_EXECUTABLE}
            ${CMAKE_CURRENT_SOURCE_DIR}/verify_taa_exe.py
            --exe ${DETROIT_BECOME_HUMAN_EXE}
            --expected ${CMAKE_CURRENT_SOURCE_DIR}/expected_taa_interface.json
            --spirv-cross ${DETROIT_SPIRV_CROSS}
  )
  set_tests_properties(detroitbecomehuman_taa_exe_contract PROPERTIES
    LABELS "detroitbecomehuman;contract;exe;dlss;taa;spirv"
  )

  add_test(
    NAME detroitbecomehuman_resolution_scaling_exe_contract
    COMMAND ${Python3_EXECUTABLE}
            ${CMAKE_CURRENT_SOURCE_DIR}/verify_resolution_scaling_exe.py
            --exe ${DETROIT_BECOME_HUMAN_EXE}
  )
  set_tests_properties(detroitbecomehuman_resolution_scaling_exe_contract PROPERTIES
    LABELS "detroitbecomehuman;contract;exe;dlss;resolution_scaling"
  )
endif()

add_test(
  NAME detroitbecomehuman_shader_contract
  COMMAND ${Python3_EXECUTABLE}
          ${CMAKE_CURRENT_SOURCE_DIR}/verify_shader_contract.py
          --repo-root ${RENODX_TEST_REPO_ROOT}
          --embed-dir ${DETROIT_GENERATED_EMBED_DIR}
          --expected ${CMAKE_CURRENT_SOURCE_DIR}/expected_shader_interfaces.json
          --spirv-val ${DETROIT_SPIRV_VAL}
          --spirv-cross ${DETROIT_SPIRV_CROSS}
)
set_tests_properties(detroitbecomehuman_shader_contract PROPERTIES
  LABELS "detroitbecomehuman;shader;spirv;vulkan"
)

add_custom_target(detroitbecomehuman_test_sources SOURCES
  ${CMAKE_CURRENT_SOURCE_DIR}/expected_shader_interfaces.json
  ${CMAKE_CURRENT_SOURCE_DIR}/expected_taa_interface.json
  ${CMAKE_CURRENT_SOURCE_DIR}/dlss_bridge_contract_tests.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/embedded_bootstrap_tests.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/feature_lifetime_tests.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/dlss_policy_tests.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/dof_runtime_tests.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/dlss_scale_transition_tests.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/rgb9e5_adapter_tests.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/resolution_scaling_tests.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/taa_contract_tests.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/test_hdr_cas_gates.py
  ${CMAKE_CURRENT_SOURCE_DIR}/test_dof_contract.py
  ${CMAKE_CURRENT_SOURCE_DIR}/test_embedded_hook_contract.py
  ${CMAKE_CURRENT_SOURCE_DIR}/test_psychov_contract.py
  ${CMAKE_CURRENT_SOURCE_DIR}/test_ui_brightness_gates.py
  ${CMAKE_CURRENT_SOURCE_DIR}/ultrawide_patch_tests.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/verify_ultrawide_exe.py
  ${CMAKE_CURRENT_SOURCE_DIR}/verify_shader_contract.py
  ${CMAKE_CURRENT_SOURCE_DIR}/verify_resolution_scaling_exe.py
  ${CMAKE_CURRENT_SOURCE_DIR}/verify_taa_exe.py
)
add_dependencies(renodx_test_suites detroitbecomehuman_test_sources)
