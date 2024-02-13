function(target_embed_files TARGET_NAME)
    set(OPTIONS)
    set(SINGLE_VALUE)
    set(MULTIPLE_VALUE FILES)

    cmake_parse_arguments(
        EF
        "${OPTIONS}"
        "${SINGLE_VALUE}"
        "${MULTIPLE_VALUE}"
        ${ARGN}
    )

    string(TOUPPER "${TARGET_NAME}" TARGET_NAME_UPPER)
    string(MAKE_C_IDENTIFIER "${TARGET_NAME_UPPER}" TARGET_NAME_UPPER)

    string(TOLOWER "${TARGET_NAME}" TARGET_NAME_LOWER)
    string(MAKE_C_IDENTIFIER "${TARGET_NAME_LOWER}" TARGET_NAME_LOWER)

    set(GENERATE_HEADER_LOCATION "${CMAKE_BINARY_DIR}/embed/include")
    set(EMBED_HEADERS_LOCATION "${GENERATE_HEADER_LOCATION}/embed")
    set(HEADER_FILENAME "${TARGET_NAME_LOWER}.h")
    set(ARRAY_DECLARATIONS)

    foreach(INPUT_FILE IN LISTS EF_FILES)
        get_filename_component(FILENAME "${INPUT_FILE}" NAME_WE)
        string(TOLOWER "${FILENAME}" FILENAME)
        string(MAKE_C_IDENTIFIER "${FILENAME}" FILENAME)

        file(READ "${INPUT_FILE}" BYTES HEX)
        string(REGEX REPLACE "(..)" "0x\\1, " BYTES "${BYTES}")

        string(CONFIGURE "const std::uint8_t ${FILENAME}[] = { ${BYTES} }\;" CURRENT_DECLARATION)

        list(APPEND ARRAY_DECLARATIONS "${CURRENT_DECLARATION}")
    endforeach()

    string(JOIN "\n" ARRAY_DECLARATIONS ${ARRAY_DECLARATIONS})

    set(BASIC_HEADER "\
#ifndef ${TARGET_NAME_UPPER}_EMBED_FILES
#define ${TARGET_NAME_UPPER}_EMBED_FILES

#include <cstdint>

${ARRAY_DECLARATIONS}

#endif
    ")

    string(CONFIGURE "${BASIC_HEADER}" BASIC_HEADER)

    file(WRITE "${EMBED_HEADERS_LOCATION}/${HEADER_FILENAME}" "${BASIC_HEADER}")
    target_include_directories(${TARGET_NAME} PUBLIC "${GENERATE_HEADER_LOCATION}")
endfunction()