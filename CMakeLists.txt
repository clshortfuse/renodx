include(embed.cmake)

cmake_minimum_required(VERSION 3.17.2)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

project(renodx VERSION 0.1.0 LANGUAGES C CXX)

include(CTest)
enable_testing()

add_library(cp2077 MODULE src/cp2077-mod.cpp)

target_compile_definitions(cp2077 PRIVATE _UNICODE)

set_target_properties(cp2077
  PROPERTIES
    PREFIX "renodx-"
    SUFFIX ".addon64"
)

target_embed_files(cp2077 FILES embed/0x71F27445.cso)

set(CPACK_PROJECT_NAME ${PROJECT_NAME})
set(CPACK_PROJECT_VERSION ${PROJECT_VERSION})

include(CPack)
