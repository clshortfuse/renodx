cmake_minimum_required(VERSION 3.17.2)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

project(renodx VERSION 0.1.0 LANGUAGES C CXX)

include(CTest)
enable_testing()



# Use executable to convert resources to .h files for embedding
add_executable(embedfile embedfile.c)

if(NOT CMAKE_WINDOWS_KITS_10_DIR)
  set(CMAKE_WINDOWS_KITS_10_DIR "C:/Program Files (x86)/Windows Kits/10")
endif()

function(inspect_hlsl_imports FILE VARIABLE)
  file(STRINGS ${FILE} HLSL_IMPORTS REGEX "^#include \"([^\"]+)\"")
  foreach(IMPORT_LINE ${HLSL_IMPORTS})
    string(REGEX MATCH "^#include \"([^\"]+)\"" _ ${IMPORT_LINE})
    cmake_path(GET FILE PARENT_PATH FILE_DIRECTORY)
    cmake_path(ABSOLUTE_PATH CMAKE_MATCH_1 BASE_DIRECTORY ${FILE_DIRECTORY} OUTPUT_VARIABLE  HLSL_PATH )
    cmake_path(NORMAL_PATH HLSL_PATH)
    list(APPEND LIST ${HLSL_PATH})
    # recursive
    inspect_hlsl_imports(${HLSL_PATH} LIST)
  endforeach()
  # update in parent scope
  set(${VARIABLE} ${LIST} PARENT_SCOPE)
endfunction()

function(build_shader_target)
  string(LENGTH ${CMAKE_CURRENT_SOURCE_DIR}/src/ PATH_LENGTH)

  file(GLOB SHADER_FILES ${CMAKE_CURRENT_SOURCE_DIR}/src/games/**/*.hlsl)
  foreach(FILE ${SHADER_FILES})
    cmake_path(GET FILE FILENAME FILENAME)
    string(REGEX MATCH "(0x[0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F])\.([^.]+)\.hlsl$" _ ${FILENAME} )
    set(SHADER_HASH ${CMAKE_MATCH_1})
    set(SHADER_TARGET ${CMAKE_MATCH_2})
    
    if (SHADER_HASH AND SHADER_TARGET) 
      STRING(SUBSTRING ${SHADER_TARGET} 3 1 SHADER_TARGET_MAJOR)
      set(SHADER_BINARY "fxc.exe")
      if (SHADER_TARGET_MAJOR EQUAL "6")
        set(SHADER_BINARY "dxc.exe")
      else()
        set(SHADER_FLAGS "/Gec") # Compatibility mode
      endif()

      set(HLSL_DEPENDENCIES "")
      set(HLSL_CHILD_DEPENDENCIES "")
      list(APPEND HLSL_DEPENDENCIES ${FILE})
      inspect_hlsl_imports(${FILE} HLSL_CHILD_DEPENDENCIES)
      list(APPEND HLSL_DEPENDENCIES ${HLSL_CHILD_DEPENDENCIES})
      add_custom_command(
        OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/embed/${SHADER_HASH}.cso
        COMMAND ${CMAKE_WINDOWS_KITS_10_DIR}/bin/${CMAKE_VS_WINDOWS_TARGET_PLATFORM_VERSION}/x64/${SHADER_BINARY} ${FILE} -T ${SHADER_TARGET} ${SHADER_FLAGS} /Qstrip_reflect -E main -Fo ${CMAKE_CURRENT_BINARY_DIR}/embed/${SHADER_HASH}.cso
        DEPENDS ${HLSL_DEPENDENCIES}
      )
      add_custom_command(
        OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/embed/include/embed/${SHADER_HASH}.h
        COMMAND embedfile ${CMAKE_BINARY_DIR}/embed/${SHADER_HASH}.cso ${SHADER_HASH}
        DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/embed/${SHADER_HASH}.cso
      )

      list(APPEND SHADER_HEADER_FILES ${CMAKE_CURRENT_BINARY_DIR}/embed/include/embed/${SHADER_HASH}.h)
    endif()
  endforeach()
  LIST(JOIN SHADER_HEADER_FILES " " SHADER_HEADER_FILE_ITEMS)
  add_custom_target(shaders DEPENDS ${SHADER_HEADER_FILES})
endfunction()

build_shader_target()

set(TARGET_SUFFIX ".addon64")
if(CMAKE_GENERATOR_PLATFORM STREQUAL "Win32")
  set(TARGET_SUFFIX ".addon32")
endif()

file(GLOB ADDON_FILES ${CMAKE_CURRENT_SOURCE_DIR}/src/games/**/addon.cpp)
list(APPEND ADDON_FILES ${CMAKE_CURRENT_SOURCE_DIR}/src/devkit/addon.cpp)
foreach(FILE ${ADDON_FILES})
  cmake_path(GET FILE PARENT_PATH ADDON_PATH)
  cmake_path(GET ADDON_PATH FILENAME ADDON) # treat as filename

  add_library(${ADDON} MODULE ${FILE})
  add_dependencies(${ADDON} shaders)
  target_include_directories(${ADDON} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/external/reshade)
  target_include_directories(${ADDON} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/include)
  target_include_directories(${ADDON} PRIVATE ${CMAKE_CURRENT_BINARY_DIR}/embed/include)
  target_compile_definitions(${ADDON} PRIVATE _UNICODE)
  set_target_properties(${ADDON}
    PROPERTIES
      PREFIX "renodx-"
      SUFFIX ${TARGET_SUFFIX}
  )
endforeach()

set(CPACK_PROJECT_NAME ${PROJECT_NAME})
set(CPACK_PROJECT_VERSION ${PROJECT_VERSION})

include(CPack)
