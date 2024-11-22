## Build Shaders

find_program(GLSL_VALIDATOR glslangValidator HINTS 
${Vulkan_GLSLANG_VALIDATOR_EXECUTABLE} 
/bin
/usr/bin 
/usr/local/bin 
$ENV{VULKAN_SDK}/Bin/ 
$ENV{VULKAN_SDK}/Bin32/
)

message(STATUS "GLSL Compiler: ${GLSL_VALIDATOR}")

set(SHADER_SOURCE_DIR "${PROJECT_SOURCE_DIR}/shaders")

# get all .vert and .frag files in shaders directory
file(GLOB_RECURSE GLSL_SOURCE_FILES
CONFIGURE_DEPENDS
"${SHADER_SOURCE_DIR}/*.frag"
"${SHADER_SOURCE_DIR}/*.vert"
"${SHADER_SOURCE_DIR}/*.comp"
"${SHADER_SOURCE_DIR}/*.glsl"
"${SHADER_SOURCE_DIR}/*.comp"
"${SHADER_SOURCE_DIR}/*.mesh"
)

message(STATUS "GLSL_SOURCE_FILES: ${GLSL_SOURCE_FILES}")

if(EXISTS "${PROJECT_SOURCE_DIR}/build/Shaders")
  file(REMOVE_RECURSE "${PROJECT_SOURCE_DIR}/build/Shaders")
endif()
set(SHADER_OUTPUT_DIR "${PROJECT_SOURCE_DIR}/build/Shaders")
file(MAKE_DIRECTORY ${SHADER_OUTPUT_DIR})

foreach(GLSL_FILE ${GLSL_SOURCE_FILES})
  get_filename_component(FILENAME ${GLSL_FILE} NAME)
  set(SPV_FILE "${SHADER_OUTPUT_DIR}/${FILENAME}.spv")
  
  add_custom_command(
    OUTPUT ${SPV_FILE}
    COMMAND ${GLSL_VALIDATOR} ${GLSL_FILE} -V -o ${SPV_FILE}
    DEPENDS ${GLSL_FILE}
    COMMENT "Compiling shader ${GLSL_FILE} to ${SPV_FILE}"
    VERBATIM
  )
  list(APPEND SPV_FILES ${SPV_FILE})
endforeach()

add_custom_target(shaders ALL DEPENDS ${SPV_FILES})
add_dependencies(${PROJECT_NAME} shaders)

## end of build shaders