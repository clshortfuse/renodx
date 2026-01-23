cmake_minimum_required(VERSION 3.27)

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

find_program(SLANGC_BIN slangc.exe
  HINTS
  ${CMAKE_CURRENT_SOURCE_DIR}/bin/
  REQUIRED)
message("SLANGC_BIN: " ${SLANGC_BIN})

project(renodx VERSION 0.1.0 LANGUAGES CXX)

include(CTest)
enable_testing()

# Use executable to convert resources to .h files for embedding
add_executable(embed_file src/embed_file.cpp)
# Helper executable that analyzes HLSL #include dependencies and outputs .d files
add_executable(analyze_hlsl_deps src/analyze_hlsl_deps.cpp)
add_executable(decomp ./src/decompiler/cli.cpp)

# DEPRECATED: inspect_hlsl_imports is no longer used - dependencies are tracked at build time via DEPFILE
# Keeping for reference during transition
function(inspect_hlsl_imports FILE VARIABLE REQUESTING_FILE)
  unset(CACHE_ENTRY)
  set(HLSL_CACHE_VAR HLSL_CACHE_${FILE})
  get_property(CACHE_ENTRY GLOBAL PROPERTY ${HLSL_CACHE_VAR})
  # message(${FILE} " - Preparing " ${VARIABLE})
  if(CACHE_ENTRY)
    # message(${FILE} " - Using cache")
  else()
    # message(${FILE} " - Check known zero-dependency " HLSL_CACHE_EMPTY_${FILE})
    get_property(EMPTY_CACHE_ENTRY GLOBAL PROPERTY HLSL_CACHE_EMPTY_${FILE})
    unset(CACHE_ENTRY)
    if(EMPTY_CACHE_ENTRY)
      # message(${FILE} " - Is zero dependency file")
    elseif(EXISTS ${FILE})
      # message(${FILE} " - EMPTY_CACHE_ENTRY Result: " ${EMPTY_CACHE_ENTRY})
      file(STRINGS ${FILE} HLSL_IMPORTS REGEX "^#include \"([^\"]+)\"")
      foreach(IMPORT_LINE ${HLSL_IMPORTS})
        string(REGEX MATCH "^#include \"([^\"]+)\"" _ ${IMPORT_LINE})
        cmake_path(GET FILE PARENT_PATH FILE_DIRECTORY)
        cmake_path(ABSOLUTE_PATH CMAKE_MATCH_1 BASE_DIRECTORY ${FILE_DIRECTORY} OUTPUT_VARIABLE HLSL_PATH)
        cmake_path(NORMAL_PATH HLSL_PATH)
        # message(${FILE} " - Direct dependency: " ${HLSL_PATH})
        list(FIND CACHE_ENTRY "${HLSL_PATH}" _found_idx)
        if(NOT _found_idx EQUAL -1)
          # message(${FILE} " - Already in list: " ${HLSL_PATH})
          continue()
        endif()
        list(APPEND CACHE_ENTRY ${HLSL_PATH})
        #message(${FILE} " - Added: " ${HLSL_PATH})
        # message(${FILE} " - List: " ${CACHE_ENTRY})
        # recursive
        inspect_hlsl_imports(${HLSL_PATH} CHILD_DEPENDENCIES ${FILE})
        # message(${FILE} " - Adding children from " ${HLSL_PATH} ": " ${TEMP_CACHE_ENTRY})
        list(APPEND CACHE_ENTRY ${CHILD_DEPENDENCIES})
        # message(${FILE} " - Added children from " ${HLSL_PATH} ": " ${CACHE_ENTRY})
      endforeach()
      if(CACHE_ENTRY)
        set_property(GLOBAL PROPERTY ${HLSL_CACHE_VAR} ${CACHE_ENTRY})
        # message(${FILE} " - Caching " ${CACHE_ENTRY})
      else()
        set_property(GLOBAL PROPERTY HLSL_CACHE_EMPTY_${FILE} "TRUE")
        # message(${FILE} " -Marking zero dependency")
      endif()
    else()
      message(FATAL_ERROR "Failed to parse " ${REQUESTING_FILE} " " ${FILE} " does not exist.")
    endif()
  endif()

  # update in parent scope
  set(${VARIABLE} ${CACHE_ENTRY} PARENT_SCOPE)

endfunction()

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

        # Add dependencies
        unset(HLSL_DEPENDENCIES)
        unset(HLSL_CHILD_DEPENDENCIES)
        list(APPEND HLSL_DEPENDENCIES ${FILE})
        inspect_hlsl_imports(${FILE} HLSL_CHILD_DEPENDENCIES ".")
        list(APPEND HLSL_DEPENDENCIES ${HLSL_CHILD_DEPENDENCIES})

        #DX11
        set(SHADER_COMPILER ${FXC_BIN})
        unset(SHADER_FLAGS)
        set(SHADER_FLAGS ${SHADER_FLAGS} /D __SHADER_TARGET_MAJOR=${SHADER_TARGET_MAJOR})
        set(SHADER_FLAGS ${SHADER_FLAGS} /D __SHADER_TARGET_MINOR=0)
        set(SHADER_FLAGS ${SHADER_FLAGS} /Gec)

        if(SHADER_HASH)
          set(DEPFILE_DX11 ${CMAKE_CURRENT_BINARY_DIR}/${ADDON}/${SHADER_HASH}_dx11.d)
          add_custom_command(
            OUTPUT ${EMBED_FOLDER}/${SHADER_HASH}_dx11.cso
            COMMAND $<TARGET_FILE:analyze_hlsl_deps> ${FILE} ${EMBED_FOLDER}/${SHADER_HASH}_dx11.cso ${DEPFILE_DX11}
            COMMAND ${SHADER_COMPILER} ${FILE} -T ${SHADER_TARGET_TYPE}_5_0 ${SHADER_FLAGS} /nologo /O3 /Qstrip_reflect -E main -Fo ${EMBED_FOLDER}/${SHADER_HASH}_dx11.cso
            DEPENDS ${FILE} analyze_hlsl_deps
            DEPFILE ${DEPFILE_DX11}
          )
          list(APPEND SHADER_BINARIES ${EMBED_FOLDER}/${SHADER_HASH}_dx11.cso)
        else()
          set(DEPFILE_DX11 ${CMAKE_CURRENT_BINARY_DIR}/${ADDON}/${SHADER_NAME}_dx11.d)
          add_custom_command(
            OUTPUT ${EMBED_FOLDER}/${SHADER_NAME}_dx11.cso
            COMMAND $<TARGET_FILE:analyze_hlsl_deps> ${FILE} ${EMBED_FOLDER}/${SHADER_NAME}_dx11.cso ${DEPFILE_DX11}
            COMMAND ${SHADER_COMPILER} ${FILE} -T ${SHADER_TARGET_TYPE}_5_0 ${SHADER_FLAGS} /nologo /O3 /Qstrip_reflect -E main -Fo ${EMBED_FOLDER}/${SHADER_NAME}_dx11.cso
            DEPENDS ${FILE} analyze_hlsl_deps
            DEPFILE ${DEPFILE_DX11}
          )
          list(APPEND SHADER_BINARIES ${EMBED_FOLDER}/${SHADER_NAME}_dx11.cso)
        endif()

        #DX12
        unset(SHADER_FLAGS)
        set(SHADER_FLAGS ${SHADER_FLAGS} /D __SHADER_TARGET_MAJOR=${SHADER_TARGET_MAJOR})
        set(SHADER_FLAGS ${SHADER_FLAGS} /D __SHADER_TARGET_MINOR=1)

        if(SHADER_HASH)
          set(DEPFILE_DX12 ${CMAKE_CURRENT_BINARY_DIR}/${ADDON}/${SHADER_HASH}_dx12.d)
          add_custom_command(
            OUTPUT ${EMBED_FOLDER}/${SHADER_HASH}_dx12.cso
            COMMAND $<TARGET_FILE:analyze_hlsl_deps> ${FILE} ${EMBED_FOLDER}/${SHADER_HASH}_dx12.cso ${DEPFILE_DX12}
            COMMAND ${SHADER_COMPILER} ${FILE} -T ${SHADER_TARGET_TYPE}_5_1 ${SHADER_FLAGS} /nologo /O3 /Qstrip_reflect -E main -Fo ${EMBED_FOLDER}/${SHADER_HASH}_dx12.cso
            DEPENDS ${FILE} analyze_hlsl_deps
            DEPFILE ${DEPFILE_DX12}
          )
          list(APPEND SHADER_BINARIES ${EMBED_FOLDER}/${SHADER_HASH}_dx12.cso)
        else()
          set(DEPFILE_DX12 ${CMAKE_CURRENT_BINARY_DIR}/${ADDON}/${SHADER_NAME}_dx12.d)
          add_custom_command(
            OUTPUT ${EMBED_FOLDER}/${SHADER_NAME}_dx12.cso
            COMMAND $<TARGET_FILE:analyze_hlsl_deps> ${FILE} ${EMBED_FOLDER}/${SHADER_NAME}_dx12.cso ${DEPFILE_DX12}
            COMMAND ${SHADER_COMPILER} ${FILE} -T ${SHADER_TARGET_TYPE}_5_1 ${SHADER_FLAGS} /nologo /O3 /Qstrip_reflect -E main -Fo ${EMBED_FOLDER}/${SHADER_NAME}_dx12.cso
            DEPENDS ${FILE} analyze_hlsl_deps
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
          if(SHADER_TARGET_MINOR GREATER_EQUAL "2")
            set(SHADER_FLAGS ${SHADER_FLAGS} /enable-16bit-types)
          endif()
        else()
          set(SHADER_FLAGS ${SHADER_FLAGS} /D __SHADER_TARGET_MAJOR=${SHADER_TARGET_MAJOR})
          set(SHADER_FLAGS ${SHADER_FLAGS} /D __SHADER_TARGET_MINOR=${SHADER_TARGET_MINOR})
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
            COMMAND $<TARGET_FILE:analyze_hlsl_deps> ${FILE} ${EMBED_FOLDER}/${SHADER_HASH}.cso ${DEPFILE}
            COMMAND ${SHADER_COMPILER} ${FILE} -T ${SHADER_TARGET} ${SHADER_FLAGS} /nologo /O3 /Qstrip_reflect -E main -Fo ${EMBED_FOLDER}/${SHADER_HASH}.cso
            DEPENDS ${FILE} analyze_hlsl_deps
            DEPFILE ${DEPFILE}
          )
          list(APPEND SHADER_BINARIES ${EMBED_FOLDER}/${SHADER_HASH}.cso)
        else()
          set(DEPFILE ${CMAKE_CURRENT_BINARY_DIR}/${ADDON}/${SHADER_NAME}.d)
          add_custom_command(
            OUTPUT ${EMBED_FOLDER}/${SHADER_NAME}.cso
            COMMAND $<TARGET_FILE:analyze_hlsl_deps> ${FILE} ${EMBED_FOLDER}/${SHADER_NAME}.cso ${DEPFILE}
            COMMAND ${SHADER_COMPILER} ${FILE} -T ${SHADER_TARGET} ${SHADER_FLAGS} /nologo /O3 /Qstrip_reflect -E main -Fo ${EMBED_FOLDER}/${SHADER_NAME}.cso
            DEPENDS ${FILE} analyze_hlsl_deps
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
        # Add dependencies
        unset(HLSL_DEPENDENCIES)
        unset(HLSL_CHILD_DEPENDENCIES)
        list(APPEND HLSL_DEPENDENCIES ${FILE})
        inspect_hlsl_imports(${FILE} HLSL_CHILD_DEPENDENCIES ".")
        list(APPEND HLSL_DEPENDENCIES ${HLSL_CHILD_DEPENDENCIES})

        unset(SHADER_STAGE)
        if(SHADER_TARGET STREQUAL "frag")
          set(SHADER_STAGE "fragment")
        elseif(SHADER_TARGET STREQUAL "vert")
          set(SHADER_STAGE "vertex")
        elseif(SHADER_TARGET STREQUAL "comp")
          set(SHADER_STAGE "compute")
        endif()

        if(SHADER_HASH)
          add_custom_command(
            OUTPUT ${EMBED_FOLDER}/${SHADER_HASH}.spv
            COMMAND ${SHADER_COMPILER} ${FILE} -stage ${SHADER_STAGE} ${SHADER_FLAGS} -target spirv -o ${EMBED_FOLDER}/${SHADER_HASH}.spv
            DEPENDS ${HLSL_DEPENDENCIES}
          )
          list(APPEND SHADER_BINARIES ${EMBED_FOLDER}/${SHADER_HASH}.spv)
        else()
          add_custom_command(
            OUTPUT ${EMBED_FOLDER}/${SHADER_NAME}.spv
            COMMAND ${SHADER_COMPILER} ${FILE} -stage ${SHADER_STAGE} ${SHADER_FLAGS} -target spirv -o ${EMBED_FOLDER}/${SHADER_NAME}.spv
            DEPENDS ${HLSL_DEPENDENCIES}
          )
          list(APPEND SHADER_BINARIES ${EMBED_FOLDER}/${SHADER_NAME}.spv)
        endif()
      else()
        string(SUBSTRING ${SHADER_TARGET} 3 1 SHADER_TARGET_MAJOR)
        string(SUBSTRING ${SHADER_TARGET} 5 1 SHADER_TARGET_MINOR)
        if(SHADER_TARGET_MAJOR STREQUAL "5" AND SHADER_TARGET_MINOR STREQUAL "x")

          string(SUBSTRING ${SHADER_TARGET} 0 2 SHADER_TARGET_TYPE)

          # Add dependencies
          unset(HLSL_DEPENDENCIES)
          unset(HLSL_CHILD_DEPENDENCIES)
          list(APPEND HLSL_DEPENDENCIES ${FILE})
          inspect_hlsl_imports(${FILE} HLSL_CHILD_DEPENDENCIES ".")
          list(APPEND HLSL_DEPENDENCIES ${HLSL_CHILD_DEPENDENCIES})

          if(SHADER_HASH)
            add_custom_command(
              OUTPUT ${EMBED_FOLDER}/${SHADER_HASH}_dx11.cso
              COMMAND ${SHADER_COMPILER} ${FILE} -profile ${SHADER_TARGET_TYPE}_5_0 ${SHADER_FLAGS} -target dxbc -o ${EMBED_FOLDER}/${SHADER_HASH}_dx11.cso
              DEPENDS ${HLSL_DEPENDENCIES}
            )
            list(APPEND SHADER_BINARIES ${EMBED_FOLDER}/${SHADER_HASH}_dx11.cso)
          else()
            add_custom_command(
              OUTPUT ${EMBED_FOLDER}/${SHADER_NAME}_dx11.cso
              COMMAND ${SHADER_COMPILER} ${FILE} -profile ${SHADER_TARGET_TYPE}_5_0 ${SHADER_FLAGS} -target dxbc -o ${EMBED_FOLDER}/${SHADER_NAME}_dx11.cso
              DEPENDS ${HLSL_DEPENDENCIES}
            )
            list(APPEND SHADER_BINARIES ${EMBED_FOLDER}/${SHADER_NAME}_dx11.cso)
          endif()

          if(SHADER_HASH)
            add_custom_command(
              OUTPUT ${EMBED_FOLDER}/${SHADER_HASH}_dx12.cso
              COMMAND ${SHADER_COMPILER} ${FILE} -profile ${SHADER_TARGET_TYPE}_5_1 ${SHADER_FLAGS} -target dxbc -o ${EMBED_FOLDER}/${SHADER_HASH}_dx12.cso
              DEPENDS ${HLSL_DEPENDENCIES}
            )
            list(APPEND SHADER_BINARIES ${EMBED_FOLDER}/${SHADER_HASH}_dx12.cso)
          else()
            add_custom_command(
              OUTPUT ${EMBED_FOLDER}/${SHADER_NAME}_dx12.cso
              COMMAND ${SHADER_COMPILER} ${FILE} -profile ${SHADER_TARGET_TYPE}_5_1 ${SHADER_FLAGS} -target dxbc -o ${EMBED_FOLDER}/${SHADER_NAME}_dx12.cso
              DEPENDS ${HLSL_DEPENDENCIES}
            )
            list(APPEND SHADER_BINARIES ${EMBED_FOLDER}/${SHADER_NAME}_dx12.cso)
          endif()

        else()
          # Add dependencies
          unset(HLSL_DEPENDENCIES)
          unset(HLSL_CHILD_DEPENDENCIES)
          list(APPEND HLSL_DEPENDENCIES ${FILE})
          inspect_hlsl_imports(${FILE} HLSL_CHILD_DEPENDENCIES ".")
          list(APPEND HLSL_DEPENDENCIES ${HLSL_CHILD_DEPENDENCIES})

          if(SHADER_HASH)
            # message("Registering: " ${FILE} " => " ${EMBED_FOLDER}/${SHADER_HASH}.cso)
            add_custom_command(
              OUTPUT ${EMBED_FOLDER}/${SHADER_HASH}.cso
              COMMAND ${SHADER_COMPILER} ${FILE} -profile ${SHADER_TARGET} ${SHADER_FLAGS} -target dxil -o ${EMBED_FOLDER}/${SHADER_HASH}.cso
              DEPENDS ${HLSL_DEPENDENCIES}
            )
            list(APPEND SHADER_BINARIES ${EMBED_FOLDER}/${SHADER_HASH}.cso)
          else()
            add_custom_command(
              OUTPUT ${EMBED_FOLDER}/${SHADER_NAME}.cso
              COMMAND ${SHADER_COMPILER} ${FILE} -profile ${SHADER_TARGET} ${SHADER_FLAGS} -target dxil -o ${EMBED_FOLDER}/${SHADER_NAME}.cso
              DEPENDS ${HLSL_DEPENDENCIES}
            )
            list(APPEND SHADER_BINARIES ${EMBED_FOLDER}/${SHADER_NAME}.cso)
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

  file(GLOB_RECURSE SHADER_SPV_FILES CONFIGURE_DEPENDS ${ADDON_PATH}/*.spv)
  foreach(FILE ${SHADER_SPV_FILES})
    cmake_path(GET FILE FILENAME FILENAME)
    cmake_path(GET FILE PARENT_PATH TARGET_PATH)
    string(REGEX MATCH "(.*)\\.(frag|vert|comp)\\.spv$" _ ${FILENAME})
    set(SHADER_NAME ${CMAKE_MATCH_1})
    set(SHADER_TARGET ${CMAKE_MATCH_2})
    if(SHADER_NAME)
      string(REGEX MATCH "(0x[0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f])$" _ ${SHADER_NAME})
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

  set(SHADERS_H_OUTPUT "#pragma once\n")
  list(LENGTH SHADER_BINARIES SHADER_BINARIES_LENGTH)
  if(SHADER_BINARIES_LENGTH GREATER 0)


    set(ANY_VERSION_SHADERS)
    set(DX11_SHADERS)
    set(DX12_SHADERS)

    foreach(FILE ${SHADER_BINARIES})
      cmake_path(GET FILE STEM LAST_ONLY FILENAME)
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
  target_include_directories(${ADDON} SYSTEM PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/external/frozen/include)
  target_include_directories(${ADDON} SYSTEM PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/external/gtl/include)
  target_include_directories(${ADDON} SYSTEM PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/external/Streamline/include)
  target_include_directories(${ADDON} SYSTEM PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/external/DLSS/include)
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
