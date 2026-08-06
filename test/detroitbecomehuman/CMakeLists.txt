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
    "Optional DetroitBecomeHuman.exe Build 12158144 for ultrawide signature validation")

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
  ${CMAKE_CURRENT_SOURCE_DIR}/test_hdr_cas_gates.py
  ${CMAKE_CURRENT_SOURCE_DIR}/test_ui_brightness_gates.py
  ${CMAKE_CURRENT_SOURCE_DIR}/ultrawide_patch_tests.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/verify_ultrawide_exe.py
  ${CMAKE_CURRENT_SOURCE_DIR}/verify_shader_contract.py
)
add_dependencies(renodx_test_suites detroitbecomehuman_test_sources)
