find_package(Vulkan QUIET)

if(Vulkan_FOUND)
  set(DETROIT_GPU_TONEMAP_PROBE_SHADER
      "${CMAKE_CURRENT_SOURCE_DIR}/probe.comp.slang")
  set(DETROIT_GPU_TONEMAP_PROBE_SPIRV
      "${CMAKE_CURRENT_BINARY_DIR}/probe.comp.spv")

  file(GLOB_RECURSE DETROIT_GPU_TONEMAP_PROBE_SHADER_DEPENDENCIES
       CONFIGURE_DEPENDS
       "${RENODX_TEST_REPO_ROOT}/src/shaders/*.hlsl")
  list(APPEND DETROIT_GPU_TONEMAP_PROBE_SHADER_DEPENDENCIES
       "${DETROIT_TEST_SOURCE_DIR}/tone_mappers.slang"
       "${DETROIT_TEST_SOURCE_DIR}/detroit_drt.slang")

  add_custom_command(
    OUTPUT "${DETROIT_GPU_TONEMAP_PROBE_SPIRV}"
    COMMAND "${SLANGC_BIN}"
            "${DETROIT_GPU_TONEMAP_PROBE_SHADER}"
            -stage compute
            -entry main
            -O3
            -g0
            -Wno-30056
            -Wno-15205
            -target spirv
            -o "${DETROIT_GPU_TONEMAP_PROBE_SPIRV}"
    COMMAND "${DETROIT_SPIRV_VAL}"
            --target-env vulkan1.3
            "${DETROIT_GPU_TONEMAP_PROBE_SPIRV}"
    DEPENDS
      "${DETROIT_GPU_TONEMAP_PROBE_SHADER}"
      ${DETROIT_GPU_TONEMAP_PROBE_SHADER_DEPENDENCIES}
    COMMENT "Compiling Detroit tone-mapper Vulkan GPU probe"
    VERBATIM
  )
  add_custom_target(detroitbecomehuman_gpu_tonemap_probe_shader
    DEPENDS "${DETROIT_GPU_TONEMAP_PROBE_SPIRV}")

  add_renodx_runtime_executable(
    detroitbecomehuman_gpu_tonemap_probe
    probe_runner.cpp
    Vulkan::Vulkan
  )
  add_dependencies(
    detroitbecomehuman_gpu_tonemap_probe
    detroitbecomehuman_gpu_tonemap_probe_shader
  )
  add_dependencies(
    renodx_test_suites
    detroitbecomehuman_gpu_tonemap_probe
  )

  add_test(
    NAME detroitbecomehuman_gpu_tonemap_probe
    COMMAND $<TARGET_FILE:detroitbecomehuman_gpu_tonemap_probe>
            "${DETROIT_GPU_TONEMAP_PROBE_SPIRV}"
  )
  set_tests_properties(detroitbecomehuman_gpu_tonemap_probe PROPERTIES
    LABELS "detroitbecomehuman;shader;spirv;runtime;vulkan;gpu;tonemap"
    TIMEOUT 60
  )
else()
  message(STATUS
    "Skipping Detroit tone-mapper GPU probe: Vulkan SDK was not found")
endif()
