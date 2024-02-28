cmake_minimum_required(VERSION 3.17.2)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

project(renodx VERSION 0.1.0 LANGUAGES C CXX)

include(CTest)
enable_testing()


# MOD LIST HERE
list(APPEND ADDON_LIST cp2077)
list(APPEND ADDON_LIST seaofthieves)
list(APPEND ADDON_LIST devkit)


# Use executable to convert resources to .h files for embedding
add_executable(embedfile embedfile.c)

function(build_shader_target)
  string(LENGTH ${CMAKE_CURRENT_SOURCE_DIR}/src/shaders/ PATH_LENGTH)


  file(GLOB SHADER_FILES ${CMAKE_CURRENT_SOURCE_DIR}/src/shaders/**/*.hlsl)
  foreach(FILE ${SHADER_FILES})
    string(SUBSTRING ${FILE} ${PATH_LENGTH} -1 FILENAME)
    string(REGEX MATCH "(0x[0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F])\.([^.]+)\.hlsl$" _ ${FILENAME} )
    set(SHADER_HASH ${CMAKE_MATCH_1})
    set(SHADER_TARGET ${CMAKE_MATCH_2})
    STRING(SUBSTRING ${SHADER_TARGET} 3 1 SHADER_TARGET_MAJOR)
    set(SHADER_BINARY "dxc.exe")
    if (SHADER_TARGET_MAJOR EQUAL "5")
      set(SHADER_BINARY "fxc.exe")
      set(SHADER_FLAGS "/Gec") # Compatibility mode
    endif()

    add_custom_command(
      OUTPUT embed/${SHADER_HASH}.cso
      COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/bin/${SHADER_BINARY} ${FILE} -T ${SHADER_TARGET} ${SHADER_FLAGS} /Qstrip_reflect -E main -Fo ${CMAKE_BINARY_DIR}/embed/${SHADER_HASH}.cso
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

foreach(ADDON ${ADDON_LIST})
  add_library(${ADDON} MODULE src/${ADDON}/addon.cpp)
  add_dependencies(${ADDON} shaders)
  target_include_directories(${ADDON} PRIVATE ${CMAKE_BINARY_DIR}/embed/include)
  target_include_directories(${ADDON} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/include)
  target_compile_definitions(${ADDON} PRIVATE _UNICODE)
  set_target_properties(${ADDON}
    PROPERTIES
      PREFIX "renodx-"
      SUFFIX ".addon64"
  )
endforeach()

set(CPACK_PROJECT_NAME ${PROJECT_NAME})
set(CPACK_PROJECT_VERSION ${PROJECT_VERSION})

include(CPack)
