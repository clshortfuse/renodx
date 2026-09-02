find_package(Python3 REQUIRED COMPONENTS Interpreter)

set(DOOM2016_SOURCE_DIR
    "${RENODX_TEST_REPO_ROOT}/src/games/doom2016")
set(DOOM2016_GENERATED_EMBED_DIR
    "${CMAKE_BINARY_DIR}/doom2016.include/embed")
set(DOOM2016_SPIRV_VAL
    "${RENODX_TEST_REPO_ROOT}/bin/spirv-val.exe")
set(DOOM2016_SPIRV_CROSS
    "${RENODX_TEST_REPO_ROOT}/bin/spirv-cross.exe")
set(DOOM2016_SPIRV_DIS
    "${RENODX_TEST_REPO_ROOT}/bin/spirv-dis.exe")
set(DOOM2016_EXE "" CACHE FILEPATH
    "Optional verified GOG DOOMx64vk.exe for executable SHA-256 validation")

foreach(DOOM2016_SPIRV_TOOL IN ITEMS
    DOOM2016_SPIRV_VAL
    DOOM2016_SPIRV_CROSS
    DOOM2016_SPIRV_DIS)
  if(NOT EXISTS "${${DOOM2016_SPIRV_TOOL}}")
    message(FATAL_ERROR
      "DOOM 2016 shader contract requires repo-local tool: ${${DOOM2016_SPIRV_TOOL}}")
  endif()
endforeach()

add_test(
  NAME doom2016_source_contract
  COMMAND ${Python3_EXECUTABLE}
          ${CMAKE_CURRENT_SOURCE_DIR}/test_source_contract.py
          --source-dir ${DOOM2016_SOURCE_DIR}
)
set_tests_properties(doom2016_source_contract PROPERTIES
  LABELS "doom2016;contract;cpu;hdr;psychov;provenance"
)

add_test(
  NAME doom2016_shader_contract
  COMMAND ${Python3_EXECUTABLE}
          ${CMAKE_CURRENT_SOURCE_DIR}/verify_shader_contract.py
          --expected ${CMAKE_CURRENT_SOURCE_DIR}/expected_shader_interfaces.json
          --embed-dir ${DOOM2016_GENERATED_EMBED_DIR}
          --spirv-val ${DOOM2016_SPIRV_VAL}
          --spirv-cross ${DOOM2016_SPIRV_CROSS}
          --spirv-dis ${DOOM2016_SPIRV_DIS}
)
set_tests_properties(doom2016_shader_contract PROPERTIES
  LABELS "doom2016;shader;spirv;vulkan;abi"
)

add_test(
  NAME doom2016_metadata_contract
  COMMAND ${Python3_EXECUTABLE}
          ${CMAKE_CURRENT_SOURCE_DIR}/verify_metadata.py
          --metadata ${DOOM2016_SOURCE_DIR}/metadata.json
          --schema ${RENODX_TEST_REPO_ROOT}/renodx-metadata-schema.json
)
set_tests_properties(doom2016_metadata_contract PROPERTIES
  LABELS "doom2016;contract;metadata;gog;vulkan"
)

if(DOOM2016_EXE)
  add_test(
    NAME doom2016_executable_contract
    COMMAND ${Python3_EXECUTABLE}
            ${CMAKE_CURRENT_SOURCE_DIR}/verify_executable.py
            --exe ${DOOM2016_EXE}
  )
  set_tests_properties(doom2016_executable_contract PROPERTIES
    LABELS "doom2016;contract;exe;gog"
  )
endif()

find_package(Vulkan QUIET)
if(Vulkan_FOUND)
  set(DOOM2016_MATH_MODES
      psychov17
      psychov22
      psychov24
      psychov25
      psychov30
      renodrt)
  set(DOOM2016_MATH_SPIRV)
  foreach(DOOM2016_MATH_MODE IN LISTS DOOM2016_MATH_MODES)
    set(DOOM2016_MATH_SOURCE
        "${CMAKE_CURRENT_SOURCE_DIR}/shaders/math_${DOOM2016_MATH_MODE}.comp.slang")
    set(DOOM2016_MATH_OUTPUT
        "${CMAKE_CURRENT_BINARY_DIR}/math_${DOOM2016_MATH_MODE}.spv")
    add_custom_command(
      OUTPUT ${DOOM2016_MATH_OUTPUT}
      COMMAND ${SLANGC_BIN}
              ${DOOM2016_MATH_SOURCE}
              -stage compute
              -O3
              -g0
              -entry main
              -Wno-30056
              -Wno-15205
              -target spirv
              -o ${DOOM2016_MATH_OUTPUT}
      COMMAND ${DOOM2016_SPIRV_VAL}
              --target-env vulkan1.3
              ${DOOM2016_MATH_OUTPUT}
      DEPENDS
              ${DOOM2016_MATH_SOURCE}
              ${CMAKE_CURRENT_SOURCE_DIR}/shaders/math_common.hlsli
              ${DOOM2016_SOURCE_DIR}/psychov_test24.hlsli
              ${DOOM2016_SOURCE_DIR}/psychov_test25.hlsli
              ${DOOM2016_SOURCE_DIR}/psychov_test25_nrg.hlsli
              ${DOOM2016_SOURCE_DIR}/psychov_test30.hlsli
      VERBATIM
    )
    list(APPEND DOOM2016_MATH_SPIRV ${DOOM2016_MATH_OUTPUT})
  endforeach()

  add_custom_target(doom2016_tonemap_math_shaders
    DEPENDS ${DOOM2016_MATH_SPIRV})
  add_executable(
    doom2016_tonemap_math_vulkan
    tonemap_math_vulkan.cpp)
  target_compile_features(
    doom2016_tonemap_math_vulkan PRIVATE cxx_std_20)
  target_link_libraries(
    doom2016_tonemap_math_vulkan PRIVATE Vulkan::Vulkan)
  add_dependencies(
    doom2016_tonemap_math_vulkan
    doom2016_tonemap_math_shaders)
  add_dependencies(
    renodx_test_suites
    doom2016_tonemap_math_vulkan)

  add_test(
    NAME doom2016_tonemap_math_vulkan
    COMMAND doom2016_tonemap_math_vulkan
            ${DOOM2016_MATH_SPIRV}
  )
  set_tests_properties(doom2016_tonemap_math_vulkan PROPERTIES
    LABELS "doom2016;runtime;gpu;vulkan;hdr;psychov;math"
    TIMEOUT 60
  )
endif()

add_custom_target(doom2016_test_sources SOURCES
  CMakeLists.txt
  expected_shader_interfaces.json
  test_source_contract.py
  verify_shader_contract.py
  verify_metadata.py
  verify_executable.py
  tonemap_math_vulkan.cpp
  shaders/math_common.hlsli
  shaders/math_psychov17.comp.slang
  shaders/math_psychov22.comp.slang
  shaders/math_psychov24.comp.slang
  shaders/math_psychov25.comp.slang
  shaders/math_psychov30.comp.slang
  shaders/math_renodrt.comp.slang
)
add_dependencies(renodx_test_suites doom2016_test_sources)
