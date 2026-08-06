find_package(Python3 REQUIRED COMPONENTS Interpreter)

set(DETROIT_TEST_SOURCE_DIR
    "${RENODX_TEST_REPO_ROOT}/src/games/detroitbecomehuman")
set(DETROIT_GENERATED_EMBED_DIR
    "${CMAKE_BINARY_DIR}/detroitbecomehuman.include/embed")
set(DETROIT_SPIRV_VAL
    "${RENODX_TEST_REPO_ROOT}/bin/spirv-val.exe")
set(DETROIT_SPIRV_CROSS
    "${RENODX_TEST_REPO_ROOT}/bin/spirv-cross.exe")

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
  NAME detroitbecomehuman_tonemap_variants
  COMMAND ${Python3_EXECUTABLE}
          ${CMAKE_CURRENT_SOURCE_DIR}/test_tonemap_variants.py
          --source-dir ${DETROIT_TEST_SOURCE_DIR}
)
set_tests_properties(detroitbecomehuman_tonemap_variants PROPERTIES
  LABELS "detroitbecomehuman;unit;cpu;hdr;tonemap"
)

add_test(
  NAME detroitbecomehuman_detroit_drt
  COMMAND ${Python3_EXECUTABLE}
          ${CMAKE_CURRENT_SOURCE_DIR}/test_detroit_drt.py
          --source-dir ${DETROIT_TEST_SOURCE_DIR}
)
set_tests_properties(detroitbecomehuman_detroit_drt PROPERTIES
  LABELS "detroitbecomehuman;unit;cpu;hdr;tonemap"
)

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
  ${CMAKE_CURRENT_SOURCE_DIR}/test_hdr_cas_gates.py
  ${CMAKE_CURRENT_SOURCE_DIR}/test_ui_brightness_gates.py
  ${CMAKE_CURRENT_SOURCE_DIR}/test_tonemap_variants.py
  ${CMAKE_CURRENT_SOURCE_DIR}/test_detroit_drt.py
  ${CMAKE_CURRENT_SOURCE_DIR}/verify_shader_contract.py
)
add_dependencies(renodx_test_suites detroitbecomehuman_test_sources)

add_subdirectory(gpu_tonemap_probe)
