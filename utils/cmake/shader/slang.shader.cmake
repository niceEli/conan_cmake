## Build Shaders

find_program(SLANG_VALIDATOR slangc HINTS 
/bin
/usr/bin 
/usr/local/bin 
$ENV{VULKAN_SDK}/Bin/ 
$ENV{VULKAN_SDK}/Bin32/
)

message(STATUS "Slang Compiler (NEEDS VULKAN SDK 1.3.296.0 OR LATER): ${SLANG_VALIDATOR}")

set(SHADER_SOURCE_DIR "${PROJECT_SOURCE_DIR}/shaders")

# get all .vert and .frag files in shaders directory
file(GLOB_RECURSE SLANG_SOURCE_FILES
CONFIGURE_DEPENDS
"${SHADER_SOURCE_DIR}/*.slang"
)

message(STATUS "SLANG_SOURCE_FILES: ${SLANG_SOURCE_FILES}")

if(EXISTS "${PROJECT_SOURCE_DIR}/build/Shaders")
  file(REMOVE_RECURSE "${PROJECT_SOURCE_DIR}/build/Shaders")
endif()
set(SHADER_OUTPUT_DIR "${PROJECT_SOURCE_DIR}/build/Shaders")
file(MAKE_DIRECTORY ${SHADER_OUTPUT_DIR})

foreach(SLANG_FILE ${SLANG_SOURCE_FILES})
  get_filename_component(FILENAME ${SLANG_FILE} NAME)
  
  if(APPLE)
    set(OUTPUT_FILE "${SHADER_OUTPUT_DIR}/${FILENAME}.metallib")
    set(COMPILE_COMMAND ${SLANG_VALIDATOR} ${SLANG_FILE} -o ${OUTPUT_FILE})
  else()
    set(OUTPUT_FILE "${SHADER_OUTPUT_DIR}/${FILENAME}.spv")
    set(COMPILE_COMMAND ${SLANG_VALIDATOR} ${SLANG_FILE} -o ${OUTPUT_FILE})
  endif()
  
  add_custom_command(
    OUTPUT ${OUTPUT_FILE}
    COMMAND ${COMPILE_COMMAND}
    DEPENDS ${SLANG_FILE}
    COMMENT "Compiling shader ${SLANG_FILE} to ${OUTPUT_FILE}"
    VERBATIM
  )
  list(APPEND SPV_FILES ${OUTPUT_FILE})
endforeach()

add_custom_target(slang_shaders ALL DEPENDS ${SPV_FILES})
add_dependencies(${PROJECT_NAME} slang_shaders)

## end of build shaders