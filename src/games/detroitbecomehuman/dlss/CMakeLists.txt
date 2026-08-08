find_package(Vulkan REQUIRED)

set(DETROIT_DLSS_SDK_ROOT "${PROJECT_SOURCE_DIR}/external/DLSS")
set(DETROIT_DLSS_NGX_LIB_DIR "${DETROIT_DLSS_SDK_ROOT}/lib/Windows_x86_64/khr/x64")
set(DETROIT_DLSS_NGX_DLL "${DETROIT_DLSS_SDK_ROOT}/lib/Windows_x86_64/rel/nvngx_dlss.dll")

foreach(DETROIT_DLSS_REQUIRED_FILE IN ITEMS
    "${DETROIT_DLSS_SDK_ROOT}/include/nvsdk_ngx_vk.h"
    "${DETROIT_DLSS_NGX_LIB_DIR}/nvsdk_ngx_khr_s.lib"
    "${DETROIT_DLSS_NGX_LIB_DIR}/nvsdk_ngx_khr_s_dbg.lib"
    "${DETROIT_DLSS_NGX_DLL}")
  if(NOT EXISTS "${DETROIT_DLSS_REQUIRED_FILE}")
    message(FATAL_ERROR "Embedded Detroit DLSS bootstrap requires ${DETROIT_DLSS_REQUIRED_FILE}")
  endif()
endforeach()

target_sources(detroitbecomehuman PRIVATE
  vulkan_layer.cpp
  extension_probe.cpp
  embedded_bootstrap.hpp
  adapter_runtime.cpp
  adapter_runtime.hpp
  adapter_shaders.cpp
  adapter_shaders.hpp
  rgb9e5_adapter.hpp
)
build_shader_target(
  detroitbecomehuman_dlss_embedded
  "${CMAKE_CURRENT_SOURCE_DIR}/shaders"
)
add_dependencies(detroitbecomehuman detroitbecomehuman_dlss_embedded-shaders)
if(TARGET renodx_test_suites)
  add_dependencies(renodx_test_suites detroitbecomehuman_dlss_embedded-shaders)
endif()

target_compile_definitions(detroitbecomehuman PRIVATE NOMINMAX WIN32_LEAN_AND_MEAN)
target_include_directories(detroitbecomehuman PRIVATE
  "${DETROIT_DLSS_SDK_ROOT}/include"
  "${CMAKE_CURRENT_SOURCE_DIR}/.."
  "${CMAKE_CURRENT_BINARY_DIR}/detroitbecomehuman_dlss_embedded.include"
)
target_link_libraries(detroitbecomehuman PRIVATE
  Vulkan::Vulkan
  bcrypt
  "$<$<CONFIG:Debug>:${DETROIT_DLSS_NGX_LIB_DIR}/nvsdk_ngx_khr_s_dbg.lib>"
  "$<$<NOT:$<CONFIG:Debug>>:${DETROIT_DLSS_NGX_LIB_DIR}/nvsdk_ngx_khr_s.lib>"
)
add_custom_target(detroitbecomehuman_dlss_runtime_copy
  COMMAND ${CMAKE_COMMAND} -E copy_if_different
    "${DETROIT_DLSS_NGX_DLL}"
    "$<TARGET_FILE_DIR:detroitbecomehuman>/nvngx_dlss.dll"
)
add_dependencies(detroitbecomehuman detroitbecomehuman_dlss_runtime_copy)

if(TARGET detroitbecomehuman_rgb9e5_adapter_tests)
  target_sources(detroitbecomehuman_rgb9e5_adapter_tests PRIVATE adapter_shaders.cpp)
  target_include_directories(detroitbecomehuman_rgb9e5_adapter_tests PRIVATE
    "${CMAKE_CURRENT_BINARY_DIR}/detroitbecomehuman_dlss_embedded.include"
  )
  add_dependencies(
    detroitbecomehuman_rgb9e5_adapter_tests
    detroitbecomehuman_dlss_embedded-shaders
  )
endif()
