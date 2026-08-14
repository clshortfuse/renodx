set(RENODX_DXC_MIN_VERSION "1.9.2602")
set(RENODX_SLANG_MIN_VERSION "2026.14.1")
set(RENODX_GLSLANG_MIN_VERSION "16.5.0")
set(RENODX_THREEDMIGOTO_MIN_VERSION "1.3.16")

set(RENODX_DXC_VERSION_REGEX
  "dxcompiler\\.dll:.* - ([0-9]+\\.[0-9]+\\.[0-9]+(\\.[0-9]+)?)")
set(RENODX_SLANG_VERSION_REGEX
  "([0-9]+\\.[0-9]+\\.[0-9]+(\\.[0-9]+)?)")
set(RENODX_GLSLANG_VERSION_REGEX
  "Glslang Version: [0-9]+:([0-9]+\\.[0-9]+\\.[0-9]+(\\.[0-9]+)?)")

function(renodx_check_minimum_tool_version TOOL_NAME TOOL_PATH MIN_VERSION VERSION_REGEX)
  execute_process(
    COMMAND "${TOOL_PATH}" ${ARGN}
    RESULT_VARIABLE TOOL_VERSION_RESULT
    OUTPUT_VARIABLE TOOL_VERSION_STDOUT
    ERROR_VARIABLE TOOL_VERSION_STDERR)

  if(NOT TOOL_VERSION_RESULT EQUAL 0)
    message(WARNING "Failed to query ${TOOL_NAME} version from ${TOOL_PATH}")
    return()
  endif()

  string(REGEX MATCH "${VERSION_REGEX}" TOOL_VERSION_MATCH "${TOOL_VERSION_STDOUT}\n${TOOL_VERSION_STDERR}")
  if(NOT TOOL_VERSION_MATCH)
    message(WARNING "Could not parse ${TOOL_NAME} version from ${TOOL_PATH}")
    return()
  endif()

  set(TOOL_VERSION "${CMAKE_MATCH_1}")
  if(TOOL_VERSION VERSION_LESS MIN_VERSION)
    message(WARNING
      "${TOOL_NAME} ${TOOL_VERSION} is older than the recommended minimum ${MIN_VERSION}: ${TOOL_PATH}\n"
      "Run scripts/setup-dev-env.ps1 -Update to install the configured tool versions.")
    return()
  endif()

  message(STATUS "${TOOL_NAME}: ${TOOL_VERSION} (minimum ${MIN_VERSION})")
endfunction()

if("${CMAKE_SCRIPT_MODE_FILE}" STREQUAL "${CMAKE_CURRENT_LIST_FILE}")
  foreach(TOOL_NAME IN ITEMS DXC SLANG GLSLANG THREEDMIGOTO)
    execute_process(COMMAND "${CMAKE_COMMAND}" -E echo
      "RENODX_${TOOL_NAME}_MIN_VERSION=${RENODX_${TOOL_NAME}_MIN_VERSION}")
  endforeach()
endif()