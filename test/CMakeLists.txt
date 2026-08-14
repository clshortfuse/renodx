set(RENODX_TEST_REPO_ROOT ${CMAKE_CURRENT_SOURCE_DIR}/..)
set(RENODX_TEST_RESHADE_DIR ${CMAKE_CURRENT_BINARY_DIR}/reshade)
set(RENODX_TEST_RESHADE_DLL ${RENODX_TEST_RESHADE_DIR}/ReShade64.dll)

add_custom_command(
  OUTPUT ${RENODX_TEST_RESHADE_DLL}
  COMMAND ${CMAKE_COMMAND}
    -DRENODX_TEST_RESHADE_SOURCE=${RENODX_TEST_REPO_ROOT}/bin/ReShade64.dll
    -DRENODX_TEST_RESHADE_DIR=${RENODX_TEST_RESHADE_DIR}
    -P ${CMAKE_CURRENT_SOURCE_DIR}/download_reshade.cmake
  DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/download_reshade.cmake
  COMMENT "Preparing ReShade 6.7.3 for runtime tests"
  VERBATIM
)
add_custom_target(renodx_test_reshade_runtime DEPENDS ${RENODX_TEST_RESHADE_DLL})
add_custom_target(renodx_test_suites)

function(add_renodx_runtime_addon target_name source_file)
  add_library(${target_name} MODULE ${source_file})
  target_compile_features(${target_name} PRIVATE cxx_std_20)
  target_compile_definitions(${target_name} PRIVATE NOMINMAX WIN32_LEAN_AND_MEAN)
  target_include_directories(${target_name} PRIVATE
    ${RENODX_TEST_REPO_ROOT}
    ${RENODX_TEST_REPO_ROOT}/external/reshade
    ${RENODX_TEST_REPO_ROOT}/external/gtl/include
    ${RENODX_TEST_REPO_ROOT}/external/frozen/include
  )
  target_link_libraries(${target_name} PRIVATE version ${ARGN})
  set_target_properties(${target_name} PROPERTIES
    PREFIX ""
    SUFFIX ".addon64"
  )
endfunction()

function(add_renodx_runtime_executable target_name source_file)
  add_executable(${target_name} ${source_file})
  target_compile_features(${target_name} PRIVATE cxx_std_20)
  target_compile_definitions(${target_name} PRIVATE NOMINMAX WIN32_LEAN_AND_MEAN)
  target_include_directories(${target_name} PRIVATE
    ${RENODX_TEST_REPO_ROOT}
    ${RENODX_TEST_REPO_ROOT}/external/reshade
    ${RENODX_TEST_REPO_ROOT}/external/gtl/include
    ${RENODX_TEST_REPO_ROOT}/external/frozen/include
  )
  target_link_libraries(${target_name} PRIVATE ${ARGN})
endfunction()

add_subdirectory(render_pass_behavior)
add_subdirectory(resource_upgrade_transfer)
add_subdirectory(shader_injection_behavior)
add_subdirectory(descriptor_cache_race)
add_subdirectory(shader_compiler_watcher_api_change)
add_subdirectory(swapchain_change_detection)
add_subdirectory(swapchain_proxy_barrier_states)
add_subdirectory(api_compatibility)
add_subdirectory(shader_source_compatibility)
