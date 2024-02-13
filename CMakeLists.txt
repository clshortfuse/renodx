cmake_minimum_required(VERSION 3.17.2)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

project(renodx VERSION 0.1.0 LANGUAGES C CXX)

include(CTest)
enable_testing()

add_executable(embedfile embedfile.c)

add_custom_command(
  OUTPUT embed/0x71f27445.cso
  COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/bin/dxc.exe ${CMAKE_CURRENT_SOURCE_DIR}/src/shaders/cs_0x71f27445.hlsl -WX -T cs_6_0 -E main -Fo embed/0x71f27445.cso
  DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/src/shaders/cs_0x71f27445.hlsl
)
add_custom_command(
  OUTPUT embed/0x97cA5A85.cso
  COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/bin/dxc.exe ${CMAKE_CURRENT_SOURCE_DIR}/src/shaders/cs_0x97cA5A85.hlsl -WX -T cs_6_0 -E main -Fo embed/0x97cA5A85.cso
  DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/src/shaders/cs_0x97cA5A85.hlsl
)
add_custom_command(
  OUTPUT embed/include/embed/0x97cA5A85.h
  COMMAND embedfile ${CMAKE_BINARY_DIR}/embed/0x97cA5A85.cso 0x97cA5A85
  DEPENDS embed/0x97cA5A85.cso
)

add_custom_command(
  OUTPUT embed/include/embed/0x71f27445.h
  COMMAND embedfile ${CMAKE_BINARY_DIR}/embed/0x71f27445.cso 0x71f27445
  DEPENDS embed/0x71f27445.cso
)

add_custom_target(shaders
  DEPENDS
    embed/include/embed/0x71f27445.h
    embed/include/embed/0x97cA5A85.h
)

add_library(cp2077 MODULE src/cp2077/addon.cpp)
add_dependencies( cp2077 shaders )
target_include_directories(cp2077 PRIVATE ${CMAKE_BINARY_DIR}/embed/include)
target_include_directories(cp2077 PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/include)
target_compile_definitions(cp2077 PRIVATE _UNICODE)
set_target_properties(cp2077
  PROPERTIES
    PREFIX "renodx-"
    SUFFIX ".addon64"
)






set(CPACK_PROJECT_NAME ${PROJECT_NAME})
set(CPACK_PROJECT_VERSION ${PROJECT_VERSION})

include(CPack)
