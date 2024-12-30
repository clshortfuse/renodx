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
        inspect_hlsl_imports(${HLSL_PATH} CHILD_DEPENDENCIES, ${FILE})
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
    string(REGEX MATCH "(.*)\\.([pcv]s_[0-9]_[0-9])\\.hlsl$" _ ${FILENAME})
    set(SHADER_NAME ${CMAKE_MATCH_1})
    set(SHADER_TARGET ${CMAKE_MATCH_2})
    if(SHADER_NAME)
      string(REGEX MATCH "(0x[0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F])$" _ ${SHADER_NAME})
      set(SHADER_HASH ${CMAKE_MATCH_1})
    endif()


    if(SHADER_TARGET AND (SHADER_HASH OR SHADER_NAME))
      string(SUBSTRING ${SHADER_TARGET} 3 1 SHADER_TARGET_MAJOR)
      string(SUBSTRING ${SHADER_TARGET} 5 1 SHADER_TARGET_MINOR)
      set(SHADER_COMPILER ${FXC_BIN})
      unset(SHADER_FLAGS)
      if(SHADER_TARGET_MAJOR GREATER_EQUAL "6")
        set(SHADER_COMPILER ${DXC_BIN})
        set(SHADER_FLAGS "/HV 2021") # Ovewrite flags
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
  add_library(${ADDON} MODULE ${FILE})
  build_shader_target(${ADDON} ${CMAKE_CURRENT_SOURCE_DIR}/src/games/${ADDON})
  add_dependencies(${ADDON} ${ADDON}-shaders)
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
