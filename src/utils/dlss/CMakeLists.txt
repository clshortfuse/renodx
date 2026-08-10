find_package(Vulkan REQUIRED)

set(RENODX_DLSS_SDK_ROOT "${PROJECT_SOURCE_DIR}/external/DLSS")
if(NOT EXISTS "${RENODX_DLSS_SDK_ROOT}/include/nvsdk_ngx_vk.h")
  message(FATAL_ERROR
    "renodx_dlss_vulkan requires ${RENODX_DLSS_SDK_ROOT}/include/nvsdk_ngx_vk.h")
endif()

add_library(renodx_dlss_vulkan STATIC
  ngx_vulkan.cpp
  ngx_vulkan.hpp
  feature_lifetime.hpp
  vulkan_barriers.hpp
)
target_compile_features(renodx_dlss_vulkan PUBLIC cxx_std_20)
target_compile_definitions(renodx_dlss_vulkan PRIVATE VK_NO_PROTOTYPES)
target_include_directories(renodx_dlss_vulkan
  PUBLIC
    "${PROJECT_SOURCE_DIR}/src"
    "${RENODX_DLSS_SDK_ROOT}/include"
)
target_link_libraries(renodx_dlss_vulkan PUBLIC Vulkan::Vulkan)
