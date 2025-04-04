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

project(renodx VERSION 0.1.0 LANGUAGES C CXX)

include(CTest)
enable_testing()

# Define the required version for dxcompiler.dll validation
set(REQUIRED_DXC_VERSION "1.8.2502")

# Define the expected paths for all files in the build directory
set(EXPECTED_DXC_DLL_PATH "${CMAKE_BINARY_DIR}/dxcompiler.dll")
set(EXPECTED_DXC_EXE_PATH "${CMAKE_BINARY_DIR}/dxc.exe")
set(EXPECTED_DXC_LIB_PATH "${CMAKE_BINARY_DIR}/dxcompiler.lib")

# Check if all files exist
if(EXISTS ${EXPECTED_DXC_DLL_PATH} AND EXISTS ${EXPECTED_DXC_EXE_PATH} AND EXISTS ${EXPECTED_DXC_LIB_PATH})
  message(STATUS "Found dxcompiler.dll, dxc.exe, and dxcompiler.lib. Checking version of dxcompiler.dll...")

  execute_process(
    COMMAND powershell -Command "(Get-Item ${EXPECTED_DXC_DLL_PATH}).VersionInfo.FileVersion"
    OUTPUT_VARIABLE DLL_VERSION
    OUTPUT_STRIP_TRAILING_WHITESPACE
  )
  message(STATUS "File Version: ${DLL_VERSION}")

  # Check if the file version starts with the required version
  string(FIND "${DLL_VERSION}" "${REQUIRED_DXC_VERSION}" VERSION_POSITION)
  if(VERSION_POSITION EQUAL 0)
    set(DOWNLOAD_REQUIRED FALSE)
    message(STATUS "Valid dxcompiler.dll version: ${DLL_VERSION}")
  else()
    message(FATAL_ERROR "Invalid dxcompiler.dll version: ${DLL_VERSION}. Required: ${REQUIRED_DXC_VERSION} (prefix match).")
    set(DOWNLOAD_REQUIRED TRUE)
  endif()
else()
  message(STATUS "One or more required files are missing. Proceeding to download and extract...")
  set(DOWNLOAD_REQUIRED TRUE)
endif()

# Download and extract if necessary
if(DOWNLOAD_REQUIRED)
  # Define the URL and paths for the ZIP file
  set(DXC_ZIP_URL "https://github.com/microsoft/DirectXShaderCompiler/releases/download/v1.8.2502/dxc_2025_02_20.zip")
  set(DXC_ZIP_PATH "${CMAKE_BINARY_DIR}/dxc_2025_02_20.zip")
  set(DXC_EXTRACT_DIR "${CMAKE_BINARY_DIR}/dxc_extracted")

  # Download the ZIP file
  if(NOT EXISTS ${DXC_ZIP_PATH})
    message(STATUS "Downloading dxcompiler ZIP from ${DXC_ZIP_URL}...")
    file(DOWNLOAD ${DXC_ZIP_URL} ${DXC_ZIP_PATH} SHOW_PROGRESS)
    message(STATUS "Downloaded dxcompiler ZIP to ${DXC_ZIP_PATH}.")
  else()
    message(STATUS "dxcompiler ZIP already exists at ${DXC_ZIP_PATH}. Skipping download.")
  endif()

  # Create the extraction directory if it doesn't exist
  file(MAKE_DIRECTORY ${DXC_EXTRACT_DIR})

  # Extract the ZIP file
  execute_process(
    COMMAND powershell -Command "Expand-Archive -Path '${DXC_ZIP_PATH}' -DestinationPath '${DXC_EXTRACT_DIR}' -Force"
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
  )
  message(STATUS "Extracted dxcompiler ZIP to ${DXC_EXTRACT_DIR}.")

  # Define paths to the extracted files
  set(EXTRACTED_DXC_DLL_PATH "${DXC_EXTRACT_DIR}/bin/x64/dxcompiler.dll")
  set(EXTRACTED_DXC_EXE_PATH "${DXC_EXTRACT_DIR}/bin/x64/dxc.exe")
  set(EXTRACTED_DXC_LIB_PATH "${DXC_EXTRACT_DIR}/lib/x64/dxcompiler.lib")

  # Verify all extracted files exist
  if(NOT EXISTS ${EXTRACTED_DXC_DLL_PATH} OR NOT EXISTS ${EXTRACTED_DXC_EXE_PATH} OR NOT EXISTS ${EXTRACTED_DXC_LIB_PATH})
    message(FATAL_ERROR "Failed to find dxcompiler.dll, dxc.exe, or dxcompiler.lib after extraction!")
  endif()

  # Copy the extracted files to the expected locations
  file(COPY ${EXTRACTED_DXC_DLL_PATH} DESTINATION ${CMAKE_BINARY_DIR})
  file(COPY ${EXTRACTED_DXC_EXE_PATH} DESTINATION ${CMAKE_BINARY_DIR})
  file(COPY ${EXTRACTED_DXC_LIB_PATH} DESTINATION ${CMAKE_BINARY_DIR})
  message(STATUS "Copied dxcompiler.dll, dxc.exe, and dxcompiler.lib to ${CMAKE_BINARY_DIR}.")
endif()

set(DXC_BIN ${CMAKE_BINARY_DIR}/dxc.exe)

# Use executable to convert resources to .h files for embedding
add_executable(embedfile embedfile.cpp)
add_executable(decomp ./src/decompiler/cli.cpp)

# External project for DirectXShaderCompiler

if(${CMAKE_BUILD_TYPE} MATCHES "Release")
  include(ExternalProject)
  set(IS_CLANG_CL $<STREQUAL:${CMAKE_CXX_COMPILER},clang-cl.exe>)
  ExternalProject_Add(
    DirectXShaderCompiler
    SOURCE_DIR ${CMAKE_SOURCE_DIR}/external/DirectXShaderCompiler
    BINARY_DIR ${CMAKE_BINARY_DIR}/builddxc # Specify the binary direct
    CONFIGURE_COMMAND ${CMAKE_COMMAND} -C ${CMAKE_SOURCE_DIR}/external/DirectXShaderCompiler/cmake/caches/PredefinedParams.cmake -DHLSL_INCLUDE_TESTS=OFF -DSPIRV_BUILD_TESTS=OFF -DSPIRV_SKIP_TESTS=ON -DSPIRV_SKIP_EXECUTABLES=ON -DSPIRV_WERROR=OFF -DLLVM_HOST_TRIPLE=x86_64 -DLLVM_INCLUDE_TESTS=OFF -DCLANG_INCLUDE_TESTS=OFF -DHLSL_DISABLE_SOURCE_GENERATION=ON -DCMAKE_CXX_STANDARD=20 -DCLANG_CL=${IS_CLANG_CL} -DLLVM_ENABLE_WERROR=OFF ${CMAKE_SOURCE_DIR}/external/DirectXShaderCompiler
    CMAKE_CACHE_ARGS
    -DHLSL_INCLUDE_TESTS:BOOL=OFF
    -DSPIRV_BUILD_TESTS:BOOL=OFF
    -DSPIRV_SKIP_TESTS:BOOL=ON
    -DSPIRV_SKIP_EXECUTABLES:BOOL=ON
    -DSPIRV_WERROR:BOOL=OFF
    -DLLVM_HOST_TRIPLE:STRING=x86_64
    -DLLVM_INCLUDE_TESTS:BOOL=OFF
    -DCLANG_INCLUDE_TESTS:BOOL=OFF
    -DHLSL_DISABLE_SOURCE_GENERATION:BOOL=ON
    -DCMAKE_CXX_STANDARD:STRING=20
    -DCLANG_CL:BOOL=${IS_CLANG_CL}
    -DLLVM_ENABLE_WERROR:BOOL=OFF
    -DCMAKE_BUILD_TYPE:STRING=Release
    BUILD_COMMAND ${CMAKE_COMMAND} --build ${CMAKE_BINARY_DIR}/builddxc --config Release --target install-dxcompiler
    BUILD_BYPRODUCTS <BINARY_DIR>/lib/dxcompiler.lib
  )
  add_dependencies(decomp DirectXShaderCompiler)
  target_include_directories(decomp PRIVATE ${CMAKE_BINARY_DIR}/builddxc/include)
  target_link_directories(decomp PRIVATE ${CMAKE_BINARY_DIR}/builddxc/lib)
  target_link_libraries(decomp PRIVATE dxcompiler)
endif()

#target_link_libraries(decomp PRIVATE ${EXPECTED_DXC_LIB_PATH})

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

function(build_shader_target ADDON ADDON_PATH)
  set(EMBED_FOLDER ${CMAKE_CURRENT_BINARY_DIR}/${ADDON}.include/embed)
  unset(SHADER_BINARIES)

  file(GLOB_RECURSE SHADER_SOURCES ${ADDON_PATH}/*.hlsl)
  foreach(FILE ${SHADER_SOURCES})
    cmake_path(GET FILE FILENAME FILENAME)
    cmake_path(GET FILE PARENT_PATH TARGET_PATH)
    string(REGEX MATCH "(.*)\\.([pcv]s_[0-9]_[0-9x])\\.hlsl$" _ ${FILENAME})
    set(SHADER_NAME ${CMAKE_MATCH_1})
    set(SHADER_TARGET ${CMAKE_MATCH_2})
    if(SHADER_NAME)
      string(REGEX MATCH "(0x[0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F])$" _ ${SHADER_NAME})
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
          add_custom_command(
            OUTPUT ${EMBED_FOLDER}/${SHADER_HASH}_dx11.cso
            COMMAND ${SHADER_COMPILER} ${FILE} -T ${SHADER_TARGET_TYPE}_5_0 ${SHADER_FLAGS} /nologo /O3 /Qstrip_reflect -E main -Fo ${EMBED_FOLDER}/${SHADER_HASH}_dx11.cso
            DEPENDS ${HLSL_DEPENDENCIES}
          )
          list(APPEND SHADER_BINARIES ${EMBED_FOLDER}/${SHADER_HASH}_dx11.cso)
        else()
          add_custom_command(
            OUTPUT ${EMBED_FOLDER}/${SHADER_NAME}_dx11.cso
            COMMAND ${SHADER_COMPILER} ${FILE} -T ${SHADER_TARGET_TYPE}_5_0 ${SHADER_FLAGS} /nologo /O3 /Qstrip_reflect -E main -Fo ${EMBED_FOLDER}/${SHADER_NAME}_dx11.cso
            DEPENDS ${HLSL_DEPENDENCIES}
          )
          list(APPEND SHADER_BINARIES ${EMBED_FOLDER}/${SHADER_NAME}_dx11.cso)
        endif()

        #DX12
        unset(SHADER_FLAGS)
        set(SHADER_FLAGS ${SHADER_FLAGS} /D __SHADER_TARGET_MAJOR=${SHADER_TARGET_MAJOR})
        set(SHADER_FLAGS ${SHADER_FLAGS} /D __SHADER_TARGET_MINOR=1)

        if(SHADER_HASH)
          add_custom_command(
            OUTPUT ${EMBED_FOLDER}/${SHADER_HASH}_dx12.cso
            COMMAND ${SHADER_COMPILER} ${FILE} -T ${SHADER_TARGET_TYPE}_5_1 ${SHADER_FLAGS} /nologo /O3 /Qstrip_reflect -E main -Fo ${EMBED_FOLDER}/${SHADER_HASH}_dx12.cso
            DEPENDS ${HLSL_DEPENDENCIES}
          )
          list(APPEND SHADER_BINARIES ${EMBED_FOLDER}/${SHADER_HASH}_dx12.cso)
        else()
          add_custom_command(
            OUTPUT ${EMBED_FOLDER}/${SHADER_NAME}_dx12.cso
            COMMAND ${SHADER_COMPILER} ${FILE} -T ${SHADER_TARGET_TYPE}_5_1 ${SHADER_FLAGS} /nologo /O3 /Qstrip_reflect -E main -Fo ${EMBED_FOLDER}/${SHADER_NAME}_dx12.cso
            DEPENDS ${HLSL_DEPENDENCIES}
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

        unset(HLSL_DEPENDENCIES)
        unset(HLSL_CHILD_DEPENDENCIES)
        list(APPEND HLSL_DEPENDENCIES ${FILE})
        # message("Building HLSL dependencies for " ${FILE})
        inspect_hlsl_imports(${FILE} HLSL_CHILD_DEPENDENCIES ".")
        list(APPEND HLSL_DEPENDENCIES ${HLSL_CHILD_DEPENDENCIES})
        if(SHADER_HASH)
          # message("Registering: " ${FILE} " => " ${EMBED_FOLDER}/${SHADER_HASH}.cso)
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
    endif()
  endforeach()


  file(GLOB_RECURSE SHADER_CSO_FILES ${ADDON_PATH}/*.cso)
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

  file(GLOB_RECURSE SHADER_SPV_FILES ${ADDON_PATH}/*.spv)
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

  unset(SHADERS_H_OUTPUT)
  foreach(FILE ${SHADER_BINARIES})
    cmake_path(GET FILE STEM LAST_ONLY FILENAME)
    add_custom_command(
      OUTPUT ${EMBED_FOLDER}/${FILENAME}.h
      COMMAND embedfile ${FILE} ${EMBED_FOLDER}/${FILENAME}.h
      DEPENDS ${FILE}
    )
    list(APPEND SHADER_HEADER_FILES ${EMBED_FOLDER}/${FILENAME}.h)
    string(APPEND SHADERS_H_OUTPUT "#include \"./${FILENAME}.h\"\n")
  endforeach()


  list(JOIN SHADER_HEADER_FILES " " SHADER_HEADER_FILE_ITEMS)
  add_custom_target(${ADDON}-shaders DEPENDS ${SHADER_HEADER_FILES})

  if(SHADERS_H_OUTPUT)
    file(GENERATE OUTPUT ${EMBED_FOLDER}/shaders.h CONTENT "${SHADERS_H_OUTPUT}")
  endif()
endfunction()

if(CMAKE_GENERATOR_PLATFORM STREQUAL "Win32" OR CMAKE_EXE_LINKER_FLAGS MATCHES "/machine:X86")
  message("Building 32" ${CMAKE_GENERATOR_PLATFORM} ${CMAKE_EXE_LINKER_FLAGS})
  set(TARGET_SUFFIX ".addon32")
else()
  set(TARGET_SUFFIX ".addon64")
endif()

file(GLOB ADDON_FILES ${CMAKE_CURRENT_SOURCE_DIR}/src/games/**/addon.cpp)
list(APPEND ADDON_FILES ${CMAKE_CURRENT_SOURCE_DIR}/src/devkit/addon.cpp)
foreach(FILE ${ADDON_FILES})
  cmake_path(GET FILE PARENT_PATH ADDON_PATH)
  cmake_path(GET ADDON_PATH FILENAME ADDON) # treat as filename
  add_compile_options(/bigobj)
  add_library(${ADDON} MODULE ${FILE})
  build_shader_target(${ADDON} ${CMAKE_CURRENT_SOURCE_DIR}/src/games/${ADDON})
  add_dependencies(${ADDON} ${ADDON}-shaders)
  target_include_directories(${ADDON} SYSTEM PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/external/reshade)
  target_include_directories(${ADDON} SYSTEM PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)
  target_include_directories(${ADDON} PRIVATE ${CMAKE_CURRENT_BINARY_DIR}/${ADDON}.include)
  target_link_libraries(${ADDON} PRIVATE ${EXPECTED_DXC_LIB_PATH})
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
