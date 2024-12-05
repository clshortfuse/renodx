cmake_minimum_required(VERSION 3.27)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

if(NOT CMAKE_WINDOWS_KITS_10_DIR)
  set(CMAKE_WINDOWS_KITS_10_DIR "C:/Program Files (x86)/Windows Kits/10")
endif()

find_program(FXC_BIN fxc.exe
  HINTS ${CMAKE_WINDOWS_KITS_10_DIR}/bin/${CMAKE_SYSTEM_VERSION}/x64/
  REQUIRED)
message("FXC_BIN: " ${FXC_BIN})

find_program(DXC_BIN dxc.exe
  HINTS ${CMAKE_WINDOWS_KITS_10_DIR}/bin/${CMAKE_SYSTEM_VERSION}/x64/
  REQUIRED)
message("DXC_BIN: " ${DXC_BIN})

project(renodx VERSION 0.1.0 LANGUAGES CXX)

include(CTest)
enable_testing()

# Use executable to convert resources to .h files for embedding
add_executable(embedfile embedfile.cpp)
add_executable(decomp ./src/decompiler/cli.cpp)

function(inspect_hlsl_imports FILE VARIABLE)
  file(STRINGS ${FILE} HLSL_IMPORTS REGEX "^#include \"([^\"]+)\"")
  foreach(IMPORT_LINE ${HLSL_IMPORTS})
    string(REGEX MATCH "^#include \"([^\"]+)\"" _ ${IMPORT_LINE})
    cmake_path(GET FILE PARENT_PATH FILE_DIRECTORY)
    cmake_path(ABSOLUTE_PATH CMAKE_MATCH_1 BASE_DIRECTORY ${FILE_DIRECTORY} OUTPUT_VARIABLE HLSL_PATH)
    cmake_path(NORMAL_PATH HLSL_PATH)
    list(APPEND LIST ${HLSL_PATH})
    # recursive
    inspect_hlsl_imports(${HLSL_PATH} LIST)
  endforeach()
  # update in parent scope
  set(${VARIABLE} ${LIST} PARENT_SCOPE)
endfunction()

function(build_shader_target ADDON ADDON_PATH)
  set(EMBED_FOLDER ${CMAKE_CURRENT_BINARY_DIR}/${ADDON}.include/embed)
  unset(SHADER_BINARIES)

  file(GLOB SHADER_SOURCES ${ADDON_PATH}/*.hlsl)
  foreach(FILE ${SHADER_SOURCES})
    cmake_path(GET FILE FILENAME FILENAME)
    cmake_path(GET FILE PARENT_PATH TARGET_PATH)
    string(REGEX MATCH "(.*)\\.([pcv]s_[0-9]_[0-9])\\.hlsl$" _ ${FILENAME})
    set(SHADER_NAME ${CMAKE_MATCH_1})
    set(SHADER_TARGET ${CMAKE_MATCH_2})
    if(SHADER_NAME)
      string(REGEX MATCH "(0x[0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F])$" _ ${SHADER_NAME})
      set(SHADER_HASH ${CMAKE_MATCH_1})
    endif()
    

    if(SHADER_TARGET AND (SHADER_HASH OR SHADER_NAME))
      string(SUBSTRING ${SHADER_TARGET} 3 1 SHADER_TARGET_MAJOR)
      set(SHADER_COMPILER ${FXC_BIN})
      if(SHADER_TARGET_MAJOR EQUAL "6")
        set(SHADER_COMPILER ${DXC_BIN})
        set(SHADER_FLAGS "/HV 2021")
      elseif(SHADER_TARGET_MAJOR EQUAL "5")
        if(SHADER_TARGET_MINOR EQUAL "0")
          set(SHADER_FLAGS "/Gec")
        endif()
      else()
        set(SHADER_FLAGS "/Gec") # Compatibility mode
      endif()

      set(HLSL_DEPENDENCIES "")
      set(HLSL_CHILD_DEPENDENCIES "")
      list(APPEND HLSL_DEPENDENCIES ${FILE})
      inspect_hlsl_imports(${FILE} HLSL_CHILD_DEPENDENCIES)
      list(APPEND HLSL_DEPENDENCIES ${HLSL_CHILD_DEPENDENCIES})
      if(SHADER_HASH)
        add_custom_command(
          OUTPUT ${EMBED_FOLDER}/${SHADER_HASH}.cso
          COMMAND ${SHADER_COMPILER} ${FILE} -T ${SHADER_TARGET} ${SHADER_FLAGS} /nologo /O3 /Qstrip_reflect -E main -Fo ${EMBED_FOLDER}/${SHADER_HASH}.cso
          DEPENDS ${HLSL_DEPENDENCIES}
        )
        list(APPEND SHADER_BINARIES ${EMBED_FOLDER}/${SHADER_HASH}.cso)
      else()
        add_custom_command(
          OUTPUT ${EMBED_FOLDER}/${SHADER_NAME}.cso
          COMMAND ${SHADER_COMPILER} ${FILE} -T ${SHADER_TARGET} ${SHADER_FLAGS} /nologo /O3 /Qstrip_reflect -E main -Fo ${EMBED_FOLDER}/${SHADER_NAME}.cso
          DEPENDS ${HLSL_DEPENDENCIES}
        )
        list(APPEND SHADER_BINARIES ${EMBED_FOLDER}/${SHADER_NAME}.cso)
      endif()



    endif()
  endforeach()


  file(GLOB SHADER_CSO_FILES ${ADDON_PATH}/*.cso)
  foreach(FILE ${SHADER_CSO_FILES})
    cmake_path(GET FILE FILENAME FILENAME)
    cmake_path(GET FILE PARENT_PATH TARGET_PATH)
    string(REGEX MATCH "(.*)\\.?([pcv]s_[0-9]_[0-9])?\\.cso$" _ ${FILENAME})
    set(SHADER_NAME ${CMAKE_MATCH_1})
    set(SHADER_TARGET ${CMAKE_MATCH_2})
    if(SHADER_NAME)
      string(REGEX MATCH "(0x[0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F])$" _ ${SHADER_NAME})
      set(SHADER_HASH ${CMAKE_MATCH_1})
    endif()

    if(SHADER_HASH)
      configure_file(${FILE} ${EMBED_FOLDER}/${SHADER_HASH}.cso COPYONLY)
      list(APPEND SHADER_BINARIES ${EMBED_FOLDER}/${SHADER_HASH}.cso)
    elseif(SHADER_NAME)
      configure_file(${FILE} ${EMBED_FOLDER}/${SHADER_NAME}.cso COPYONLY)
      list(APPEND SHADER_BINARIES ${EMBED_FOLDER}/${SHADER_NAME}.cso)
    endif()
  endforeach()

  file(GLOB SHADER_SPV_FILES ${ADDON_PATH}/*.spv)
  foreach(FILE ${SHADER_SPV_FILES})
    cmake_path(GET FILE FILENAME FILENAME)
    cmake_path(GET FILE PARENT_PATH TARGET_PATH)
    string(REGEX MATCH "(.*)\\.(frag|vert)\\.spv$" _ ${FILENAME})
    set(SHADER_NAME ${CMAKE_MATCH_1})
    set(SHADER_TARGET ${CMAKE_MATCH_2})
    if(SHADER_NAME)
      string(REGEX MATCH "(0x[0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F])$" _ ${SHADER_NAME})
      set(SHADER_HASH ${CMAKE_MATCH_1})
    endif()

    if(SHADER_HASH)
      configure_file(${FILE} ${EMBED_FOLDER}/${SHADER_HASH}.spv COPYONLY)
      list(APPEND SHADER_BINARIES ${EMBED_FOLDER}/${SHADER_HASH}.spv)
    elseif(SHADER_NAME)
      configure_file(${FILE} ${EMBED_FOLDER}/${SHADER_NAME}.spv COPYONLY)
      list(APPEND SHADER_BINARIES ${EMBED_FOLDER}/${SHADER_NAME}.spv)
    endif()
  endforeach()

  foreach(FILE ${SHADER_BINARIES})
    cmake_path(GET FILE STEM LAST_ONLY FILENAME)
    add_custom_command(
      OUTPUT ${EMBED_FOLDER}/${FILENAME}.h
      COMMAND embedfile ${FILE} ${EMBED_FOLDER}/${FILENAME}.h
      DEPENDS ${FILE}
    )
    list(APPEND SHADER_HEADER_FILES ${EMBED_FOLDER}/${FILENAME}.h)
  endforeach()


  LIST(JOIN SHADER_HEADER_FILES " " SHADER_HEADER_FILE_ITEMS)
  add_custom_target(${ADDON}-shaders DEPENDS ${SHADER_HEADER_FILES})
  
  if(SHADER_HEADER_FILES)
    add_custom_target(${ADDON}-shaders-packed DEPENDS ${EMBED_FOLDER}/shaders.h)
    add_custom_command(
      OUTPUT ${EMBED_FOLDER}/shaders.h
      COMMAND ${CMAKE_COMMAND} -E cat ${SHADER_HEADER_FILES} > ${EMBED_FOLDER}/shaders.h
      DEPENDS ${ADDON}-shaders
    )
  else()
    add_custom_target(${ADDON}-shaders-packed)
  endif()
endfunction()

if(CMAKE_GENERATOR_PLATFORM STREQUAL "Win32" OR CMAKE_EXE_LINKER_FLAGS MATCHES "/machine:X86")
  set(TARGET_SUFFIX ".addon32")
else()
  set(TARGET_SUFFIX ".addon64")
endif()

file(GLOB ADDON_FILES ${CMAKE_CURRENT_SOURCE_DIR}/src/games/**/addon.cpp)
list(APPEND ADDON_FILES ${CMAKE_CURRENT_SOURCE_DIR}/src/devkit/addon.cpp)
foreach(FILE ${ADDON_FILES})
  cmake_path(GET FILE PARENT_PATH ADDON_PATH)
  cmake_path(GET ADDON_PATH FILENAME ADDON) # treat as filename
  add_library(${ADDON} MODULE ${FILE})
  build_shader_target(${ADDON} ${CMAKE_CURRENT_SOURCE_DIR}/src/games/${ADDON})
  add_dependencies(${ADDON} ${ADDON}-shaders)
  add_dependencies(${ADDON} ${ADDON}-shaders-packed)
  target_include_directories(${ADDON} SYSTEM PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/external/reshade)
  target_include_directories(${ADDON} SYSTEM PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)
  target_include_directories(${ADDON} PRIVATE ${CMAKE_CURRENT_BINARY_DIR}/${ADDON}.include)
  #target_compile_definitions(${ADDON} PRIVATE _UNICODE)
  set_target_properties(${ADDON}
    PROPERTIES
    PREFIX "renodx-"
    SUFFIX ${TARGET_SUFFIX}
  )
endforeach()

set(CPACK_PROJECT_NAME ${PROJECT_NAME})
set(CPACK_PROJECT_VERSION ${PROJECT_VERSION})

include(CPack)
