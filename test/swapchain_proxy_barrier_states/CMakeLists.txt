find_package(Vulkan QUIET)
if(NOT Vulkan_FOUND)
  return()
endif()

find_program(RENODX_TEST_GLSLANG
  NAMES glslang.exe glslangValidator.exe
  HINTS $ENV{VULKAN_SDK}/Bin
)
find_program(RENODX_TEST_VKCUBE
  NAMES vkcube.exe
  HINTS $ENV{VULKAN_SDK}/Bin
)
if(NOT RENODX_TEST_GLSLANG OR NOT RENODX_TEST_VKCUBE)
  message(STATUS "Skipping swapchain proxy Vulkan test: glslang and vkcube are required")
  return()
endif()

get_filename_component(RENODX_TEST_VULKAN_LAYER_DIR ${RENODX_TEST_VKCUBE} DIRECTORY)

set(SWAPCHAIN_PROXY_VERTEX_SPV
  ${CMAKE_CURRENT_BINARY_DIR}/swap_chain_proxy_vertex_shader.spv)
set(SWAPCHAIN_PROXY_PIXEL_SPV
  ${CMAKE_CURRENT_BINARY_DIR}/swap_chain_proxy_pixel_shader.spv)
add_custom_command(
  OUTPUT ${SWAPCHAIN_PROXY_VERTEX_SPV}
  COMMAND ${RENODX_TEST_GLSLANG}
    -V --target-env vulkan1.1 -S vert
    -o ${SWAPCHAIN_PROXY_VERTEX_SPV}
    ${CMAKE_CURRENT_SOURCE_DIR}/swap_chain_proxy_vertex_shader.vert.vk.glsl
  DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/swap_chain_proxy_vertex_shader.vert.vk.glsl
  VERBATIM
)
add_custom_command(
  OUTPUT ${SWAPCHAIN_PROXY_PIXEL_SPV}
  COMMAND ${RENODX_TEST_GLSLANG}
    -V --target-env vulkan1.1 -S frag
    -o ${SWAPCHAIN_PROXY_PIXEL_SPV}
    ${CMAKE_CURRENT_SOURCE_DIR}/swap_chain_proxy_pixel_shader.frag.vk.glsl
  DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/swap_chain_proxy_pixel_shader.frag.vk.glsl
  VERBATIM
)
add_custom_target(swapchain_proxy_barrier_states_shaders DEPENDS
  ${SWAPCHAIN_PROXY_VERTEX_SPV}
  ${SWAPCHAIN_PROXY_PIXEL_SPV}
)

add_renodx_runtime_addon(swapchain_proxy_barrier_states_addon addon.cpp)
target_compile_options(swapchain_proxy_barrier_states_addon PRIVATE /bigobj)
add_dependencies(
  swapchain_proxy_barrier_states_addon
  swapchain_proxy_barrier_states_shaders
)

add_renodx_runtime_executable(swapchain_proxy_barrier_states_tests tests.cpp)
add_dependencies(swapchain_proxy_barrier_states_tests
  swapchain_proxy_barrier_states_addon
  swapchain_proxy_barrier_states_shaders
  renodx_test_reshade_runtime
)
add_dependencies(renodx_test_suites swapchain_proxy_barrier_states_tests)

add_test(
  NAME swapchain_proxy_barrier_states_vulkan
  COMMAND swapchain_proxy_barrier_states_tests
    ${RENODX_TEST_VKCUBE}
    $<TARGET_FILE:swapchain_proxy_barrier_states_addon>
    ${SWAPCHAIN_PROXY_VERTEX_SPV}
    ${SWAPCHAIN_PROXY_PIXEL_SPV}
    ${RENODX_TEST_RESHADE_DIR}
    ${RENODX_TEST_REPO_ROOT}/external/reshade/setup/ReShade64.json
    ${RENODX_TEST_VULKAN_LAYER_DIR}
)
set_tests_properties(swapchain_proxy_barrier_states_vulkan PROPERTIES
  LABELS "swapchain;proxy;barrier;runtime;vulkan"
  TIMEOUT 60
)