find_package(Vulkan QUIET)

if(NOT Vulkan_FOUND)
  message(STATUS "Skipping Detroit DLSS bootstrap: Vulkan SDK was not found")
  return()
endif()

set(DETROIT_DLSS_SDK_ROOT "${PROJECT_SOURCE_DIR}/external/DLSS")
set(DETROIT_DLSS_NGX_LIB_DIR "${DETROIT_DLSS_SDK_ROOT}/lib/Windows_x86_64/khr/x64")
set(DETROIT_DLSS_NGX_DLL "${DETROIT_DLSS_SDK_ROOT}/lib/Windows_x86_64/rel/nvngx_dlss.dll")

foreach(DETROIT_DLSS_REQUIRED_FILE IN ITEMS
    "${DETROIT_DLSS_SDK_ROOT}/include/nvsdk_ngx_vk.h"
    "${DETROIT_DLSS_NGX_LIB_DIR}/nvsdk_ngx_khr_s.lib"
    "${DETROIT_DLSS_NGX_LIB_DIR}/nvsdk_ngx_khr_s_dbg.lib"
    "${DETROIT_DLSS_NGX_DLL}")
  if(NOT EXISTS "${DETROIT_DLSS_REQUIRED_FILE}")
    message(STATUS
      "Skipping Detroit DLSS bootstrap: missing ${DETROIT_DLSS_REQUIRED_FILE}")
    return()
  endif()
endforeach()

add_library(detroitbecomehuman_dlss_layer SHARED
  vulkan_layer.cpp
  adapter_runtime.cpp
  adapter_runtime.hpp
  adapter_shaders.cpp
  adapter_shaders.hpp
  rgb9e5_adapter.hpp
)
build_shader_target(
  detroitbecomehuman_dlss_layer
  "${CMAKE_CURRENT_SOURCE_DIR}/shaders"
)
add_dependencies(
  detroitbecomehuman_dlss_layer
  detroitbecomehuman_dlss_layer-shaders
)
if(TARGET renodx_test_suites)
  add_dependencies(
    renodx_test_suites
    detroitbecomehuman_dlss_layer-shaders
  )
endif()
if(TARGET detroitbecomehuman_rgb9e5_adapter_tests)
  target_sources(
    detroitbecomehuman_rgb9e5_adapter_tests
    PRIVATE adapter_shaders.cpp
  )
  target_include_directories(
    detroitbecomehuman_rgb9e5_adapter_tests
    PRIVATE "${CMAKE_CURRENT_BINARY_DIR}/detroitbecomehuman_dlss_layer.include"
  )
  add_dependencies(
    detroitbecomehuman_rgb9e5_adapter_tests
    detroitbecomehuman_dlss_layer-shaders
  )
endif()
target_compile_definitions(detroitbecomehuman_dlss_layer PRIVATE NOMINMAX WIN32_LEAN_AND_MEAN)
target_include_directories(detroitbecomehuman_dlss_layer PRIVATE
  "${DETROIT_DLSS_SDK_ROOT}/include"
  "${CMAKE_CURRENT_SOURCE_DIR}/.."
  "${CMAKE_CURRENT_BINARY_DIR}/detroitbecomehuman_dlss_layer.include"
)
target_link_libraries(detroitbecomehuman_dlss_layer PRIVATE
  Vulkan::Vulkan
  bcrypt
  "$<$<CONFIG:Debug>:${DETROIT_DLSS_NGX_LIB_DIR}/nvsdk_ngx_khr_s_dbg.lib>"
  "$<$<NOT:$<CONFIG:Debug>>:${DETROIT_DLSS_NGX_LIB_DIR}/nvsdk_ngx_khr_s.lib>"
)
target_link_options(detroitbecomehuman_dlss_layer PRIVATE
  "/EXPORT:vkNegotiateLoaderLayerInterfaceVersion"
)
set_target_properties(detroitbecomehuman_dlss_layer PROPERTIES
  PREFIX ""
  OUTPUT_NAME "renodx-detroit-dlss-layer"
)

configure_file(
  VK_LAYER_RENODX_detroit_dlss.json.in
  "${CMAKE_CURRENT_BINARY_DIR}/VK_LAYER_RENODX_detroit_dlss.json"
  @ONLY
)
add_custom_target(detroitbecomehuman_dlss_manifest
  COMMAND ${CMAKE_COMMAND} -E copy_if_different
    "${CMAKE_CURRENT_BINARY_DIR}/VK_LAYER_RENODX_detroit_dlss.json"
    "$<TARGET_FILE_DIR:detroitbecomehuman_dlss_layer>/VK_LAYER_RENODX_detroit_dlss.json"
)
add_dependencies(detroitbecomehuman_dlss_layer detroitbecomehuman_dlss_manifest)
add_custom_command(TARGET detroitbecomehuman_dlss_layer POST_BUILD
  COMMAND ${CMAKE_COMMAND} -E copy_if_different
    "${DETROIT_DLSS_NGX_DLL}"
    "$<TARGET_FILE_DIR:detroitbecomehuman_dlss_layer>/nvngx_dlss.dll"
)

add_executable(detroitbecomehuman_dlss_launcher WIN32 launcher.cpp)
target_compile_definitions(detroitbecomehuman_dlss_launcher PRIVATE NOMINMAX WIN32_LEAN_AND_MEAN)
target_include_directories(detroitbecomehuman_dlss_launcher PRIVATE
  "${DETROIT_DLSS_SDK_ROOT}/include"
  "${CMAKE_CURRENT_SOURCE_DIR}/.."
)
target_link_libraries(detroitbecomehuman_dlss_launcher PRIVATE
  Vulkan::Vulkan
  bcrypt
  shell32
  "$<$<CONFIG:Debug>:${DETROIT_DLSS_NGX_LIB_DIR}/nvsdk_ngx_khr_s_dbg.lib>"
  "$<$<NOT:$<CONFIG:Debug>>:${DETROIT_DLSS_NGX_LIB_DIR}/nvsdk_ngx_khr_s.lib>"
)
set_target_properties(detroitbecomehuman_dlss_launcher PROPERTIES
  OUTPUT_NAME "DetroitDLSSLauncher"
)
add_dependencies(detroitbecomehuman_dlss_launcher detroitbecomehuman_dlss_layer)

if(RENODX_BUILD_TESTS)
  add_executable(
    detroitbecomehuman_dlss_launcher_fallback_tests
    launcher_fallback_tests.cpp
  )
  target_compile_definitions(
    detroitbecomehuman_dlss_launcher_fallback_tests
    PRIVATE NOMINMAX WIN32_LEAN_AND_MEAN
  )
  target_include_directories(
    detroitbecomehuman_dlss_launcher_fallback_tests
    PRIVATE
      "${DETROIT_DLSS_SDK_ROOT}/include"
      "${CMAKE_CURRENT_SOURCE_DIR}/.."
  )
  target_link_libraries(
    detroitbecomehuman_dlss_launcher_fallback_tests
    PRIVATE
      Vulkan::Vulkan
      bcrypt
      shell32
      "$<$<CONFIG:Debug>:${DETROIT_DLSS_NGX_LIB_DIR}/nvsdk_ngx_khr_s_dbg.lib>"
      "$<$<NOT:$<CONFIG:Debug>>:${DETROIT_DLSS_NGX_LIB_DIR}/nvsdk_ngx_khr_s.lib>"
  )
  add_test(
    NAME detroitbecomehuman_dlss_launcher_fallback
    COMMAND detroitbecomehuman_dlss_launcher_fallback_tests
  )
  set_tests_properties(
    detroitbecomehuman_dlss_launcher_fallback
    PROPERTIES LABELS "detroitbecomehuman;unit;cpu;dlss;launcher;fallback"
  )
  if(TARGET renodx_test_suites)
    add_dependencies(
      renodx_test_suites
      detroitbecomehuman_dlss_launcher_fallback_tests
    )
  endif()
endif()
