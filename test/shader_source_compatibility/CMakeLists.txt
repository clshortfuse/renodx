add_renodx_runtime_executable(shader_source_compatibility_tests tests.cpp)
add_dependencies(renodx_test_suites shader_source_compatibility_tests)
if(TARGET shader_source_compatibility-shaders)
  add_dependencies(shader_source_compatibility_tests shader_source_compatibility-shaders)
endif()

if(NOT DEFINED RENODX_SHADER_SOURCE_COMPATIBILITY_BUILD_DIR)
  set(RENODX_SHADER_SOURCE_COMPATIBILITY_BUILD_DIR ${CMAKE_BINARY_DIR})
endif()

add_test(
  NAME shader_source_compatibility
  COMMAND shader_source_compatibility_tests
    ${CMAKE_CURRENT_SOURCE_DIR}/plain_0xA0A0A0A0.frag.glsl
    ${RENODX_SHADER_SOURCE_COMPATIBILITY_BUILD_DIR}/shader_source_compatibility.include/embed/0xA0A0A0A0.glsl
    ${RENODX_SHADER_SOURCE_COMPATIBILITY_BUILD_DIR}/shader_source_compatibility.include/embed/0xB0B0B0B0.spv
    ${RENODX_SHADER_SOURCE_COMPATIBILITY_BUILD_DIR}/shader_source_compatibility.include/embed/shaders.h
)
set_tests_properties(shader_source_compatibility PROPERTIES
  LABELS "compatibility;glsl;main;initial_pr;vulkan;opengl"
)