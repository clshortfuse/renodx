cmake_minimum_required(VERSION 3.27)

include(${CMAKE_CURRENT_LIST_DIR}/cmake/tool-versions.cmake)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

if(NOT CMAKE_WINDOWS_KITS_10_DIR)
  set(CMAKE_WINDOWS_KITS_10_DIR "C:/Program Files (x86)/Windows Kits/10")
endif()

find_program(FXC_BIN fxc.exe
  HINTS
  ${CMAKE_CURRENT_SOURCE_DIR}/bin/
  ${CMAKE_WINDOWS_KITS_10_DIR}/bin/${CMAKE_SYSTEM_VERSION}/x64/
  REQUIRED)
message("FXC_BIN: " ${FXC_BIN})

find_program(DXC_BIN dxc.exe
  HINTS
  ${CMAKE_CURRENT_SOURCE_DIR}/bin/
  ${CMAKE_WINDOWS_KITS_10_DIR}/bin/${CMAKE_SYSTEM_VERSION}/x64/
  REQUIRED)
message("DXC_BIN: " ${DXC_BIN})
renodx_check_minimum_tool_version(
  "DirectX Shader Compiler" "${DXC_BIN}" "${RENODX_DXC_MIN_VERSION}"
  "${RENODX_DXC_VERSION_REGEX}"
  --version)

find_program(SLANGC_BIN slangc.exe
  HINTS
  ${CMAKE_CURRENT_SOURCE_DIR}/bin/
  REQUIRED)
message("SLANGC_BIN: " ${SLANGC_BIN})
renodx_check_minimum_tool_version(
  "Slang" "${SLANGC_BIN}" "${RENODX_SLANG_MIN_VERSION}"
  "${RENODX_SLANG_VERSION_REGEX}"
  -version)

set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")

set(SHADER_NDEBUG_FLAG "")
if(CMAKE_CONFIGURATION_TYPES)
  set(SHADER_NDEBUG_FLAG "$<$<NOT:$<CONFIG:Debug>>:/DNDEBUG>")
elseif(NOT CMAKE_BUILD_TYPE STREQUAL "Debug")
  set(SHADER_NDEBUG_FLAG /DNDEBUG)
endif()

project(renodx VERSION 0.1.0 LANGUAGES CXX)

option(RENODX_BUILD_TESTS "Build D3D12 regression tests" OFF)
if(RENODX_BUILD_TESTS)
  enable_testing()
  add_subdirectory(test)
endif()

# Use executable to convert resources to .h files for embedding
add_executable(embed_file src/embed_file.cpp)
# Helper executable that analyzes shader #include dependencies and outputs .d files
add_executable(analyze_shader_deps src/analyze_shader_deps.cpp)
add_executable(decomp ./src/decompiler/cli.cpp)
add_executable(mcp_bridge src/apps/mcp_bridge/main.cpp)

target_include_directories(mcp_bridge SYSTEM PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/external/json/include)
target_include_directories(mcp_bridge SYSTEM PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/external/reshade)
target_compile_definitions(mcp_bridge PRIVATE NOMINMAX)
set_target_properties(mcp_bridge PROPERTIES OUTPUT_NAME "renodx-mcp-bridge")

function(generate_resource_rc ADDON)

  string(TIMESTAMP VERSION_FALLBACK "0,%Y,%m%d,%H%M" UTC)
  string(REPLACE "," "." VERSION_STRING_FALLBACK "${VERSION_FALLBACK}")

  # llvm-rc will parse leading zeros as octet
  # Strip leading zeros in each comma-delimited value of VERSION_FALLBACK
  string(REPLACE "," ";" VERSION_LIST "${VERSION_FALLBACK}")

  set(STRIPPED_VERSION_LIST "")
  foreach(V IN LISTS VERSION_LIST)
    # Remove leading zeros, but keep "0" if the value is zero
    string(REGEX REPLACE "^0*([1-9][0-9]*|0)$" "\\1" V_STRIPPED "${V}")
    list(APPEND STRIPPED_VERSION_LIST "${V_STRIPPED}")
  endforeach()
  list(JOIN STRIPPED_VERSION_LIST "," VERSION_FALLBACK)

  set(RESOURCE_RC_CONTENT "
#include <winver.h>

#ifndef VER_FILEVERSION
#define VER_FILEVERSION ${VERSION_FALLBACK}
#endif

#ifndef VER_FILEVERSION_STR
#define VER_FILEVERSION_STR \"${VERSION_STRING_FALLBACK}\\0\"
#endif

#ifndef DEBUG
#define VER_DEBUG 0
#else
#define VER_DEBUG VS_FF_DEBUG
#endif

1 VERSIONINFO
FILEVERSION VER_FILEVERSION
FILETYPE VFT_DLL
FILEFLAGS VER_DEBUG
BEGIN
  BLOCK \"StringFileInfo\"
  BEGIN
    BLOCK \"040904b0\"
    BEGIN
      VALUE \"OriginalFilename\", \"renodx-${ADDON}${TARGET_SUFFIX}\\0\"
      VALUE \"FileVersion\", VER_FILEVERSION_STR
    END
  END
  BLOCK \"VarFileInfo\"
  BEGIN
    VALUE \"Translation\", 0x409, 1200
  END
END

")

  # Write the content to the resource file
  file(GENERATE OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${ADDON}.include/resource.rc CONTENT "${RESOURCE_RC_CONTENT}")

  # Add the generated resource.rc to the addon compilation
  target_sources(${ADDON} PRIVATE ${CMAKE_CURRENT_BINARY_DIR}/${ADDON}.include/resource.rc)

endfunction()

function(build_shader_target ADDON ADDON_PATH)
  set(EMBED_FOLDER ${CMAKE_CURRENT_BINARY_DIR}/${ADDON}.include/embed)
  unset(SHADER_BINARIES)
  macro(add_stage_spirv_shader OUTPUT_STEM)
    list(FIND SHADER_BINARIES ${EMBED_FOLDER}/${OUTPUT_STEM}.spv SHADER_BINARY_INDEX)
    if(SHADER_BINARY_INDEX EQUAL -1)
      set(DEPFILE_SPV ${CMAKE_CURRENT_BINARY_DIR}/${ADDON}/${OUTPUT_STEM}.spv.d)
      add_custom_command(
        OUTPUT ${EMBED_FOLDER}/${OUTPUT_STEM}.spv
        COMMAND $<TARGET_FILE:analyze_shader_deps> ${FILE} ${EMBED_FOLDER}/${OUTPUT_STEM}.spv ${DEPFILE_SPV}
        COMMAND ${SPIRV_COMPILE_COMMAND}
        DEPENDS ${FILE} analyze_shader_deps
        DEPFILE ${DEPFILE_SPV}
      )
      list(APPEND SHADER_BINARIES ${EMBED_FOLDER}/${OUTPUT_STEM}.spv)
    endif()
  endmacro()
  macro(add_slang_shader OUTPUT_STEM SHADER_PROFILE BINARY_TARGET)
    set(DEPFILE_SLANG ${CMAKE_CURRENT_BINARY_DIR}/${ADDON}/${OUTPUT_STEM}.d)
    add_custom_command(
      OUTPUT ${EMBED_FOLDER}/${OUTPUT_STEM}.cso
      COMMAND $<TARGET_FILE:analyze_shader_deps> ${FILE} ${EMBED_FOLDER}/${OUTPUT_STEM}.cso ${DEPFILE_SLANG}
      COMMAND ${SHADER_COMPILER} ${FILE} -profile ${SHADER_PROFILE} ${SHADER_FLAGS} -target ${BINARY_TARGET} -o ${EMBED_FOLDER}/${OUTPUT_STEM}.cso
      DEPENDS ${FILE} analyze_shader_deps
      DEPFILE ${DEPFILE_SLANG}
    )
    list(APPEND SHADER_BINARIES ${EMBED_FOLDER}/${OUTPUT_STEM}.cso)
  endmacro()
  file(GLOB_RECURSE SHADER_HLSL_SOURCES CONFIGURE_DEPENDS ${ADDON_PATH}/*.hlsl)
  foreach(FILE ${SHADER_HLSL_SOURCES})
    cmake_path(GET FILE FILENAME FILENAME)
    cmake_path(GET FILE PARENT_PATH TARGET_PATH)

    cmake_path(GET TARGET_PATH FILENAME FOLDER_NAME)
    # If the folder name starts with a dot, skip
    if(FOLDER_NAME MATCHES "^\\.")
      continue()
    endif()

    string(REGEX MATCH "(.*)\\.([pcv]s_[0-9]_[0-9x])\\.hlsl$" _ ${FILENAME})
    set(SHADER_NAME ${CMAKE_MATCH_1})
    set(SHADER_TARGET ${CMAKE_MATCH_2})
    if(SHADER_NAME)
      string(REGEX MATCH "(0x[0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f])$" _ ${SHADER_NAME})
      set(SHADER_HASH ${CMAKE_MATCH_1})
    endif()


    if(SHADER_TARGET AND (SHADER_HASH OR SHADER_NAME))
      string(SUBSTRING ${SHADER_TARGET} 3 1 SHADER_TARGET_MAJOR)
      string(SUBSTRING ${SHADER_TARGET} 5 1 SHADER_TARGET_MINOR)
      if(SHADER_TARGET_MAJOR STREQUAL "5" AND SHADER_TARGET_MINOR STREQUAL "x")

        string(SUBSTRING ${SHADER_TARGET} 0 2 SHADER_TARGET_TYPE)

        #DX11
        set(SHADER_COMPILER ${FXC_BIN})
        unset(SHADER_FLAGS)
        set(SHADER_FLAGS ${SHADER_FLAGS} /D __SHADER_TARGET_MAJOR=${SHADER_TARGET_MAJOR})
        set(SHADER_FLAGS ${SHADER_FLAGS} /D __SHADER_TARGET_MINOR=0)
        if(SHADER_NDEBUG_FLAG)
          set(SHADER_FLAGS ${SHADER_FLAGS} ${SHADER_NDEBUG_FLAG})
        endif()
        set(SHADER_FLAGS ${SHADER_FLAGS} /Gec)

        if(SHADER_HASH)
          set(DEPFILE_DX11 ${CMAKE_CURRENT_BINARY_DIR}/${ADDON}/${SHADER_HASH}_dx11.d)
          add_custom_command(
            OUTPUT ${EMBED_FOLDER}/${SHADER_HASH}_dx11.cso
            COMMAND $<TARGET_FILE:analyze_shader_deps> ${FILE} ${EMBED_FOLDER}/${SHADER_HASH}_dx11.cso ${DEPFILE_DX11}
            COMMAND ${SHADER_COMPILER} ${FILE} -T ${SHADER_TARGET_TYPE}_5_0 ${SHADER_FLAGS} /nologo /O3 /Qstrip_reflect -E main -Fo ${EMBED_FOLDER}/${SHADER_HASH}_dx11.cso
            DEPENDS ${FILE} analyze_shader_deps
            DEPFILE ${DEPFILE_DX11}
          )
          list(APPEND SHADER_BINARIES ${EMBED_FOLDER}/${SHADER_HASH}_dx11.cso)
        else()
          set(DEPFILE_DX11 ${CMAKE_CURRENT_BINARY_DIR}/${ADDON}/${SHADER_NAME}_dx11.d)
          add_custom_command(
            OUTPUT ${EMBED_FOLDER}/${SHADER_NAME}_dx11.cso
            COMMAND $<TARGET_FILE:analyze_shader_deps> ${FILE} ${EMBED_FOLDER}/${SHADER_NAME}_dx11.cso ${DEPFILE_DX11}
            COMMAND ${SHADER_COMPILER} ${FILE} -T ${SHADER_TARGET_TYPE}_5_0 ${SHADER_FLAGS} /nologo /O3 /Qstrip_reflect -E main -Fo ${EMBED_FOLDER}/${SHADER_NAME}_dx11.cso
            DEPENDS ${FILE} analyze_shader_deps
            DEPFILE ${DEPFILE_DX11}
          )
          list(APPEND SHADER_BINARIES ${EMBED_FOLDER}/${SHADER_NAME}_dx11.cso)
        endif()

        #DX12
        unset(SHADER_FLAGS)
        set(SHADER_FLAGS ${SHADER_FLAGS} /D __SHADER_TARGET_MAJOR=${SHADER_TARGET_MAJOR})
        set(SHADER_FLAGS ${SHADER_FLAGS} /D __SHADER_TARGET_MINOR=1)
        if(SHADER_NDEBUG_FLAG)
          set(SHADER_FLAGS ${SHADER_FLAGS} ${SHADER_NDEBUG_FLAG})
        endif()

        if(SHADER_HASH)
          set(DEPFILE_DX12 ${CMAKE_CURRENT_BINARY_DIR}/${ADDON}/${SHADER_HASH}_dx12.d)
          add_custom_command(
            OUTPUT ${EMBED_FOLDER}/${SHADER_HASH}_dx12.cso
            COMMAND $<TARGET_FILE:analyze_shader_deps> ${FILE} ${EMBED_FOLDER}/${SHADER_HASH}_dx12.cso ${DEPFILE_DX12}
            COMMAND ${SHADER_COMPILER} ${FILE} -T ${SHADER_TARGET_TYPE}_5_1 ${SHADER_FLAGS} /nologo /O3 /Qstrip_reflect -E main -Fo ${EMBED_FOLDER}/${SHADER_HASH}_dx12.cso
            DEPENDS ${FILE} analyze_shader_deps
            DEPFILE ${DEPFILE_DX12}
          )
          list(APPEND SHADER_BINARIES ${EMBED_FOLDER}/${SHADER_HASH}_dx12.cso)
        else()
          set(DEPFILE_DX12 ${CMAKE_CURRENT_BINARY_DIR}/${ADDON}/${SHADER_NAME}_dx12.d)
          add_custom_command(
            OUTPUT ${EMBED_FOLDER}/${SHADER_NAME}_dx12.cso
            COMMAND $<TARGET_FILE:analyze_shader_deps> ${FILE} ${EMBED_FOLDER}/${SHADER_NAME}_dx12.cso ${DEPFILE_DX12}
            COMMAND ${SHADER_COMPILER} ${FILE} -T ${SHADER_TARGET_TYPE}_5_1 ${SHADER_FLAGS} /nologo /O3 /Qstrip_reflect -E main -Fo ${EMBED_FOLDER}/${SHADER_NAME}_dx12.cso
            DEPENDS ${FILE} analyze_shader_deps
            DEPFILE ${DEPFILE_DX12}
          )
          list(APPEND SHADER_BINARIES ${EMBED_FOLDER}/${SHADER_NAME}_dx12.cso)
        endif()

      else()
        set(SHADER_COMPILER ${FXC_BIN})
        unset(SHADER_FLAGS)
        if(SHADER_TARGET_MAJOR GREATER_EQUAL "6")
          set(SHADER_COMPILER ${DXC_BIN})
          set(SHADER_FLAGS "/HV 2021") # Overwrite flags
          if(SHADER_NDEBUG_FLAG)
            set(SHADER_FLAGS ${SHADER_FLAGS} ${SHADER_NDEBUG_FLAG})
          endif()
          if(SHADER_TARGET_MINOR GREATER_EQUAL "2")
            set(SHADER_FLAGS ${SHADER_FLAGS} /enable-16bit-types)
          endif()
        else()
          set(SHADER_FLAGS ${SHADER_FLAGS} /D __SHADER_TARGET_MAJOR=${SHADER_TARGET_MAJOR})
          set(SHADER_FLAGS ${SHADER_FLAGS} /D __SHADER_TARGET_MINOR=${SHADER_TARGET_MINOR})
          if(SHADER_NDEBUG_FLAG)
            set(SHADER_FLAGS ${SHADER_FLAGS} ${SHADER_NDEBUG_FLAG})
          endif()
          if(SHADER_TARGET_MAJOR EQUAL "5")
            if(SHADER_TARGET_MINOR EQUAL "0")
              set(SHADER_FLAGS ${SHADER_FLAGS} /Gec)
            endif()
          else()
            set(SHADER_FLAGS ${SHADER_FLAGS} /Gec)
          endif()
        endif()

        if(SHADER_HASH)
          # message("Registering: " ${FILE} " => " ${EMBED_FOLDER}/${SHADER_HASH}.cso)
          set(DEPFILE ${CMAKE_CURRENT_BINARY_DIR}/${ADDON}/${SHADER_HASH}.d)
          add_custom_command(
            OUTPUT ${EMBED_FOLDER}/${SHADER_HASH}.cso
            COMMAND $<TARGET_FILE:analyze_shader_deps> ${FILE} ${EMBED_FOLDER}/${SHADER_HASH}.cso ${DEPFILE}
            COMMAND ${SHADER_COMPILER} ${FILE} -T ${SHADER_TARGET} ${SHADER_FLAGS} /nologo /O3 /Qstrip_reflect -E main -Fo ${EMBED_FOLDER}/${SHADER_HASH}.cso
            DEPENDS ${FILE} analyze_shader_deps
            DEPFILE ${DEPFILE}
          )
          list(APPEND SHADER_BINARIES ${EMBED_FOLDER}/${SHADER_HASH}.cso)
        else()
          set(DEPFILE ${CMAKE_CURRENT_BINARY_DIR}/${ADDON}/${SHADER_NAME}.d)
          add_custom_command(
            OUTPUT ${EMBED_FOLDER}/${SHADER_NAME}.cso
            COMMAND $<TARGET_FILE:analyze_shader_deps> ${FILE} ${EMBED_FOLDER}/${SHADER_NAME}.cso ${DEPFILE}
            COMMAND ${SHADER_COMPILER} ${FILE} -T ${SHADER_TARGET} ${SHADER_FLAGS} /nologo /O3 /Qstrip_reflect -E main -Fo ${EMBED_FOLDER}/${SHADER_NAME}.cso
            DEPENDS ${FILE} analyze_shader_deps
            DEPFILE ${DEPFILE}
          )
          list(APPEND SHADER_BINARIES ${EMBED_FOLDER}/${SHADER_NAME}.cso)
        endif()
      endif()
    endif()
  endforeach()

  file(GLOB_RECURSE SHADER_SLANG_SOURCES CONFIGURE_DEPENDS ${ADDON_PATH}/*.slang)
  foreach(FILE ${SHADER_SLANG_SOURCES})
    cmake_path(GET FILE FILENAME FILENAME)
    cmake_path(GET FILE PARENT_PATH TARGET_PATH)
    string(REGEX MATCH "(.*)\\.([^.]+)\\.slang$" _ ${FILENAME})
    set(SHADER_NAME ${CMAKE_MATCH_1})
    set(SHADER_TARGET ${CMAKE_MATCH_2})

    if(SHADER_NAME)
      string(REGEX MATCH "(0x[0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f])$" _ ${SHADER_NAME})
      set(SHADER_HASH ${CMAKE_MATCH_1})
    endif()

    set(SHADER_COMPILER ${SLANGC_BIN})
    unset(SHADER_FLAGS)
    set(SHADER_FLAGS ${SHADER_FLAGS} -O3)
    set(SHADER_FLAGS ${SHADER_FLAGS} -g0)
    set(SHADER_FLAGS ${SHADER_FLAGS} -entry main)
    set(SHADER_FLAGS ${SHADER_FLAGS} -Wno-30056)
    set(SHADER_FLAGS ${SHADER_FLAGS} -Wno-15205)

    if(SHADER_TARGET AND (SHADER_HASH OR SHADER_NAME))
      if(SHADER_TARGET STREQUAL "frag" OR SHADER_TARGET STREQUAL "vert" OR SHADER_TARGET STREQUAL "comp")
        unset(SHADER_STAGE)
        if(SHADER_TARGET STREQUAL "frag")
          set(SHADER_STAGE "fragment")
        elseif(SHADER_TARGET STREQUAL "vert")
          set(SHADER_STAGE "vertex")
        elseif(SHADER_TARGET STREQUAL "comp")
          set(SHADER_STAGE "compute")
        endif()
        set(SPIRV_COMPILE_COMMAND
          ${SHADER_COMPILER} ${FILE} -stage ${SHADER_STAGE} ${SHADER_FLAGS} -target spirv -o ${EMBED_FOLDER}/${SHADER_HASH}.spv)

        if(SHADER_HASH)
          add_stage_spirv_shader(${SHADER_HASH})
        else()
          set(SPIRV_COMPILE_COMMAND
            ${SHADER_COMPILER} ${FILE} -stage ${SHADER_STAGE} ${SHADER_FLAGS} -target spirv -o ${EMBED_FOLDER}/${SHADER_NAME}.spv)
          add_stage_spirv_shader(${SHADER_NAME})
        endif()
      else()
        string(SUBSTRING ${SHADER_TARGET} 3 1 SHADER_TARGET_MAJOR)
        string(SUBSTRING ${SHADER_TARGET} 5 1 SHADER_TARGET_MINOR)
        if(SHADER_TARGET_MAJOR STREQUAL "5" AND SHADER_TARGET_MINOR STREQUAL "x")

          string(SUBSTRING ${SHADER_TARGET} 0 2 SHADER_TARGET_TYPE)

          if(SHADER_HASH)
            add_slang_shader(${SHADER_HASH}_dx11 ${SHADER_TARGET_TYPE}_5_0 dxbc)
          else()
            add_slang_shader(${SHADER_NAME}_dx11 ${SHADER_TARGET_TYPE}_5_0 dxbc)
          endif()

          if(SHADER_HASH)
            add_slang_shader(${SHADER_HASH}_dx12 ${SHADER_TARGET_TYPE}_5_1 dxbc)
          else()
            add_slang_shader(${SHADER_NAME}_dx12 ${SHADER_TARGET_TYPE}_5_1 dxbc)
          endif()

        else()
          if(SHADER_HASH)
            # message("Registering: " ${FILE} " => " ${EMBED_FOLDER}/${SHADER_HASH}.cso)
            add_slang_shader(${SHADER_HASH} ${SHADER_TARGET} dxil)
          else()
            add_slang_shader(${SHADER_NAME} ${SHADER_TARGET} dxil)
          endif()
        endif()
      endif()
    else()
      #message(WARNING "Skipping shader file: " ${FILE} " - Invalid target or name.")
    endif()
  endforeach()

  file(GLOB_RECURSE SHADER_CSO_FILES CONFIGURE_DEPENDS ${ADDON_PATH}/*.cso)
  foreach(FILE ${SHADER_CSO_FILES})
    cmake_path(GET FILE FILENAME FILENAME)
    cmake_path(GET FILE PARENT_PATH TARGET_PATH)
    string(REGEX MATCH "(.*)\\.?([pcv]s_[0-9]_[0-9])?\\.cso$" _ ${FILENAME})
    set(SHADER_NAME ${CMAKE_MATCH_1})
    set(SHADER_TARGET ${CMAKE_MATCH_2})
    if(SHADER_NAME)
      string(REGEX MATCH "(0x[0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f])$" _ ${SHADER_NAME})
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

  file(GLOB_RECURSE SHADER_GLSL_FILES CONFIGURE_DEPENDS ${ADDON_PATH}/*.glsl)
  unset(GLSL_OUTPUT_STEMS)
  foreach(FILE ${SHADER_GLSL_FILES})
    cmake_path(GET FILE FILENAME FILENAME)
    cmake_path(GET FILE PARENT_PATH TARGET_PATH)
    cmake_path(GET TARGET_PATH FILENAME FOLDER_NAME)
    # If the folder name starts with a dot, skip
    if(FOLDER_NAME MATCHES "^\\.")
      continue()
    endif()

    unset(SHADER_NAME)
    unset(SHADER_TARGET)
    unset(SHADER_HASH)
    unset(GLSL_BACKEND)
    unset(GLSL_OUTPUT_STEM)
    string(REGEX MATCH "(.*)\\.(frag|vert|comp)\\.(gl|vk)\\.glsl$" _ ${FILENAME})
    set(SHADER_NAME ${CMAKE_MATCH_1})
    set(SHADER_TARGET ${CMAKE_MATCH_2})
    set(GLSL_BACKEND ${CMAKE_MATCH_3})
    if(NOT SHADER_TARGET)
      string(REGEX MATCH "(.*)\\.(frag|vert|comp)\\.glsl$" _ ${FILENAME})
      set(SHADER_NAME ${CMAKE_MATCH_1})
      set(SHADER_TARGET ${CMAKE_MATCH_2})
    endif()
    if(SHADER_NAME)
      string(REGEX MATCH "(0x[0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f])$" _ ${SHADER_NAME})
      set(SHADER_HASH ${CMAKE_MATCH_1})
    endif()

    unset(SHADER_STAGE)
    if(SHADER_TARGET STREQUAL "frag")
      set(SHADER_STAGE "frag")
    elseif(SHADER_TARGET STREQUAL "vert")
      set(SHADER_STAGE "vert")
    elseif(SHADER_TARGET STREQUAL "comp")
      set(SHADER_STAGE "comp")
    endif()
    if(SHADER_HASH)
      set(GLSL_OUTPUT_STEM ${SHADER_HASH})
    else()
      set(GLSL_OUTPUT_STEM ${SHADER_NAME})
    endif()

    if(NOT SHADER_STAGE OR NOT GLSL_OUTPUT_STEM)
      continue()
    endif()

    list(FIND GLSL_OUTPUT_STEMS ${GLSL_OUTPUT_STEM} GLSL_OUTPUT_INDEX)
    if(NOT GLSL_OUTPUT_INDEX EQUAL -1)
      message(FATAL_ERROR "Multiple GLSL implementations found for ${GLSL_OUTPUT_STEM} in ${ADDON}")
    endif()
    list(APPEND GLSL_OUTPUT_STEMS ${GLSL_OUTPUT_STEM})

    if(GLSL_BACKEND AND NOT GLSLANG_BIN)
      find_program(GLSLANG_BIN
        NAMES glslang.exe glslangValidator.exe
        HINTS
        ${CMAKE_CURRENT_SOURCE_DIR}/bin/
        $ENV{VULKAN_SDK}/Bin
        REQUIRED)
      message("GLSLANG_BIN: " ${GLSLANG_BIN})
      renodx_check_minimum_tool_version(
        "glslang" "${GLSLANG_BIN}" "${RENODX_GLSLANG_MIN_VERSION}"
        "${RENODX_GLSLANG_VERSION_REGEX}"
        --version)
    endif()

    if(GLSL_BACKEND STREQUAL "vk")
      set(SPIRV_COMPILE_COMMAND
        ${GLSLANG_BIN} -V --target-env vulkan1.3 -S ${SHADER_STAGE} -o ${EMBED_FOLDER}/${GLSL_OUTPUT_STEM}.spv ${FILE})
      add_stage_spirv_shader(${GLSL_OUTPUT_STEM})
    else()
      if(GLSL_BACKEND STREQUAL "gl")
        set(SPIRV_COMPILE_COMMAND
          ${GLSLANG_BIN} -G -S ${SHADER_STAGE} -o ${EMBED_FOLDER}/${GLSL_OUTPUT_STEM}.spv ${FILE})
        add_stage_spirv_shader(${GLSL_OUTPUT_STEM})
      else()
        configure_file(${FILE} ${EMBED_FOLDER}/${GLSL_OUTPUT_STEM}.glsl COPYONLY)
        list(APPEND SHADER_BINARIES ${EMBED_FOLDER}/${GLSL_OUTPUT_STEM}.glsl)
      endif()
    endif()
  endforeach()

  file(GLOB_RECURSE SHADER_SPV_FILES CONFIGURE_DEPENDS ${ADDON_PATH}/*.spv)
  foreach(FILE ${SHADER_SPV_FILES})
    cmake_path(GET FILE FILENAME FILENAME)
    cmake_path(GET FILE PARENT_PATH TARGET_PATH)
    unset(SHADER_NAME)
    unset(SHADER_TARGET)
    unset(SHADER_HASH)
    unset(SPV_OUTPUT_STEM)
    string(REGEX MATCH "(.*)\\.(frag|vert|comp)\\.spv$" _ ${FILENAME})
    set(SHADER_NAME ${CMAKE_MATCH_1})
    set(SHADER_TARGET ${CMAKE_MATCH_2})
    if(SHADER_NAME)
      string(REGEX MATCH "(0x[0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f])$" _ ${SHADER_NAME})
      set(SHADER_HASH ${CMAKE_MATCH_1})
    endif()

    if(SHADER_HASH)
      set(SPV_OUTPUT_STEM ${SHADER_HASH})
    elseif(SHADER_NAME)
      set(SPV_OUTPUT_STEM ${SHADER_NAME})
    else()
      continue()
    endif()

    list(FIND SHADER_BINARIES ${EMBED_FOLDER}/${SPV_OUTPUT_STEM}.spv SHADER_BINARY_INDEX)
    if(NOT SHADER_BINARY_INDEX EQUAL -1)
      continue()
    endif()

    add_custom_command(
      OUTPUT ${EMBED_FOLDER}/${SPV_OUTPUT_STEM}.spv
      COMMAND ${CMAKE_COMMAND} -E copy_if_different ${FILE} ${EMBED_FOLDER}/${SPV_OUTPUT_STEM}.spv
      DEPENDS ${FILE}
    )
    list(APPEND SHADER_BINARIES ${EMBED_FOLDER}/${SPV_OUTPUT_STEM}.spv)
  endforeach()

  list(REMOVE_DUPLICATES SHADER_BINARIES)

  set(SHADERS_H_OUTPUT "#pragma once\n")
  list(LENGTH SHADER_BINARIES SHADER_BINARIES_LENGTH)
  if(SHADER_BINARIES_LENGTH GREATER 0)


    set(ANY_VERSION_SHADERS)
    set(DX11_SHADERS)
    set(DX12_SHADERS)
    set(SHADER_STEMS)

    foreach(FILE ${SHADER_BINARIES})
      cmake_path(GET FILE STEM LAST_ONLY FILENAME)
      list(FIND SHADER_STEMS ${FILENAME} SHADER_STEM_INDEX)
      if(NOT SHADER_STEM_INDEX EQUAL -1)
        continue()
      endif()
      list(APPEND SHADER_STEMS ${FILENAME})
      add_custom_command(
        OUTPUT ${EMBED_FOLDER}/${FILENAME}.h
        COMMAND $<TARGET_FILE:embed_file> ${FILE} ${EMBED_FOLDER}/${FILENAME}.h
        DEPENDS ${FILE}
      )
      list(APPEND SHADER_HEADER_FILES ${EMBED_FOLDER}/${FILENAME}.h)
      string(APPEND SHADERS_H_OUTPUT "#include \"./${FILENAME}.h\"\n")

      if(FILENAME MATCHES "^0x[0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f]$")
        list(APPEND ANY_VERSION_SHADERS ${FILENAME})
      elseif(FILENAME MATCHES "^0x[0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f]_dx11$")
        list(APPEND DX11_SHADERS ${FILENAME})
      elseif(FILENAME MATCHES "^0x[0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f]_dx12$")
        list(APPEND DX12_SHADERS ${FILENAME})
      endif()

    endforeach()

    list(LENGTH ANY_VERSION_SHADERS ANY_VERSION_SHADERS_LENGTH)
    if(ANY_VERSION_SHADERS_LENGTH GREATER 0)
      string(APPEND SHADERS_H_OUTPUT "#define __CUSTOM_SHADER_ENTRIES \\\n")
      math(EXPR LAST_INDEX "${ANY_VERSION_SHADERS_LENGTH} - 1")
      foreach(INDEX RANGE 0 ${LAST_INDEX})
        list(GET ANY_VERSION_SHADERS ${INDEX} FILENAME)
        if(INDEX EQUAL LAST_INDEX)
          string(APPEND SHADERS_H_OUTPUT "  CustomShaderEntry(${FILENAME})\n")
        else()
          string(APPEND SHADERS_H_OUTPUT "  CustomShaderEntry(${FILENAME}), \\\n")
        endif()
      endforeach()
    endif()

    set(DX11_DX12_INTERSECT)
    foreach(FILENAME ${DX11_SHADERS})
      string(REGEX REPLACE "_dx11$" "" BASE_NAME ${FILENAME})
      list(FIND DX12_SHADERS "${BASE_NAME}_dx12" IDX)
      if(NOT IDX EQUAL -1)
        list(APPEND DX11_DX12_INTERSECT ${BASE_NAME})
      endif()
    endforeach()

    list(LENGTH DX11_DX12_INTERSECT DX11_DX12_INTERSECT_LENGTH)
    if(DX11_DX12_INTERSECT_LENGTH GREATER 0)
      string(APPEND SHADERS_H_OUTPUT "#define __CUSTOM_DIRECTX_SHADERS \\\n")
      math(EXPR LAST_INDEX "${DX11_DX12_INTERSECT_LENGTH} - 1")
      foreach(INDEX RANGE 0 ${LAST_INDEX})
        list(GET DX11_DX12_INTERSECT ${INDEX} BASE_NAME)
        if(INDEX EQUAL LAST_INDEX)
          string(APPEND SHADERS_H_OUTPUT "  CustomDirectXShaders(${BASE_NAME})\n")
        else()
          string(APPEND SHADERS_H_OUTPUT "  CustomDirectXShaders(${BASE_NAME}), \\\n")
        endif()
      endforeach()
    endif()

    if(ANY_VERSION_SHADERS_LENGTH GREATER 0 OR DX11_DX12_INTERSECT_LENGTH GREATER 0)
      string(APPEND SHADERS_H_OUTPUT "#define __ALL_CUSTOM_SHADERS \\\n")
      if(ANY_VERSION_SHADERS_LENGTH GREATER 0 AND DX11_DX12_INTERSECT_LENGTH GREATER 0)
        string(APPEND SHADERS_H_OUTPUT "  __CUSTOM_SHADER_ENTRIES, \\\n  __CUSTOM_DIRECTX_SHADERS\n")
      elseif(ANY_VERSION_SHADERS_LENGTH GREATER 0)
        string(APPEND SHADERS_H_OUTPUT "  __CUSTOM_SHADER_ENTRIES\n")
      elseif(DX11_DX12_INTERSECT_LENGTH GREATER 0)
        string(APPEND SHADERS_H_OUTPUT "  __CUSTOM_DIRECTX_SHADERS\n")
      endif()
    endif()

  endif()


  set(SHADERS_H_FILE ${EMBED_FOLDER}/shaders.h)
  file(GENERATE OUTPUT ${SHADERS_H_FILE} CONTENT "${SHADERS_H_OUTPUT}")

  add_custom_target(${ADDON}-shaders DEPENDS ${SHADER_HEADER_FILES})

endfunction()

if(RENODX_BUILD_TESTS)
  build_shader_target(shader_source_compatibility ${CMAKE_CURRENT_SOURCE_DIR}/test/shader_source_compatibility)
  add_dependencies(shader_source_compatibility_tests shader_source_compatibility-shaders)
endif()

if(CMAKE_SIZEOF_VOID_P EQUAL 8)
  message(STATUS "Detected 64-bit build")
  set(DETOURS_ARCH "X64")
  set(VCVARS_ARG "x64")
  set(TARGET_SUFFIX ".addon64")
else()
  message(STATUS "Detected 32-bit build")
  set(VCVARS_ARG "x86")
  set(DETOURS_ARCH "X86")
  set(TARGET_SUFFIX ".addon32")
endif()

find_program(
  VSWHERE_EXECUTABLE
  NAMES vswhere.exe
  HINTS "C:/Program Files (x86)/Microsoft Visual Studio/Installer"
  PATHS ENV PATH)

if(VSWHERE_EXECUTABLE)
  execute_process(
    COMMAND ${VSWHERE_EXECUTABLE} -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath
    OUTPUT_VARIABLE VS_INSTALL_PATH
    OUTPUT_STRIP_TRAILING_WHITESPACE)
else()
  set(VS_INSTALL_PATH "C:/Program Files (x86)/Microsoft Visual Studio/2022/Community")
endif()

set(VCVARS_BAT "${VS_INSTALL_PATH}/VC/Auxiliary/Build/vcvarsall.bat")

add_custom_command(
  OUTPUT ${CMAKE_CURRENT_SOURCE_DIR}/external/Detours/lib.${DETOURS_ARCH}/detours.lib
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/external/Detours/src
  COMMAND ${CMAKE_COMMAND} -E echo "Invoking vcvarsall: ${VCVARS_BAT} ${VCVARS_ARG}"
  COMMAND cmd.exe /C \"call \"${VCVARS_BAT}\" ${VCVARS_ARG} && nmake ARCH=${DETOURS_ARCH}\"
  DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/external/Detours/src/detours.cpp
)

add_library(detours STATIC IMPORTED GLOBAL)
set_target_properties(detours PROPERTIES
  IMPORTED_LOCATION ${CMAKE_CURRENT_SOURCE_DIR}/external/Detours/lib.${DETOURS_ARCH}/detours.lib
)
add_custom_target(detours_build DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/external/Detours/lib.${DETOURS_ARCH}/detours.lib)
add_dependencies(detours detours_build)


file(GLOB ADDON_FILES CONFIGURE_DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/src/**/**/addon.cpp)
foreach(FILE ${ADDON_FILES})
  cmake_path(GET FILE PARENT_PATH ADDON_PATH)
  cmake_path(GET ADDON_PATH FILENAME ADDON) # treat as filename
  add_compile_options(/bigobj)
  add_compile_definitions(NOMINMAX)
  add_library(${ADDON} MODULE ${FILE})
  build_shader_target(${ADDON} ${ADDON_PATH})
  generate_resource_rc(${ADDON})
  add_dependencies(${ADDON} ${ADDON}-shaders)
  add_dependencies(${ADDON} detours)
  target_link_libraries(${ADDON} PRIVATE detours)
  target_include_directories(${ADDON} SYSTEM PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/external/Detours/include)
  target_include_directories(${ADDON} SYSTEM PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/external/json/include)
  target_include_directories(${ADDON} SYSTEM PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/external/frozen/include)
  target_include_directories(${ADDON} SYSTEM PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/external/gtl/include)
  target_include_directories(${ADDON} SYSTEM PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/external/Streamline/include)
  target_include_directories(${ADDON} SYSTEM PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/external/DLSS/include)
  target_include_directories(${ADDON} SYSTEM PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/external/reshade)
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

