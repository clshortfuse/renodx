cmake_minimum_required(VERSION 3.17.2)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

project(renodx VERSION 0.1.0 LANGUAGES C CXX)

include(CTest)
enable_testing()

# Use executable to convert resources to .h files for embedding
add_executable(embedfile embedfile.c)

function(build_shader_target)
  string(LENGTH ${CMAKE_CURRENT_SOURCE_DIR}/src/shaders/ PATH_LENGTH)


  file(GLOB SHADER_FILES ${CMAKE_CURRENT_SOURCE_DIR}/src/shaders/*.hlsl)
  foreach(FILE ${SHADER_FILES})
    string(SUBSTRING ${FILE} ${PATH_LENGTH} -1 FILENAME)
    string(REGEX MATCH "(0x[0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F])\.([^.]+)\.hlsl$" _ ${FILENAME} )
    set(SHADER_HASH ${CMAKE_MATCH_1})
    set(SHADER_TARGET ${CMAKE_MATCH_2})

    add_custom_command(
      OUTPUT embed/${SHADER_HASH}.cso
      COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/bin/dxc.exe ${FILE} -WX -T ${SHADER_TARGET}_6_0 -E main -Fo ${CMAKE_BINARY_DIR}/embed/${SHADER_HASH}.cso
      DEPENDS ${FILE}
    )
    add_custom_command(
      OUTPUT embed/include/embed/${SHADER_HASH}.h
      COMMAND embedfile ${CMAKE_BINARY_DIR}/embed/${SHADER_HASH}.cso ${SHADER_HASH}
      DEPENDS embed/${SHADER_HASH}.cso
    )

    list(APPEND SHADER_HEADER_FILES embed/include/embed/${SHADER_HASH}.h)
  endforeach()
  LIST(JOIN SHADER_HEADER_FILES " " SHADER_HEADER_FILE_ITEMS)
  add_custom_target(shaders DEPENDS ${SHADER_HEADER_FILES})
endfunction()

build_shader_target()

add_library(cp2077 MODULE src/cp2077/addon.cpp)
add_dependencies(cp2077 shaders)
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
