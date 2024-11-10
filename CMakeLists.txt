cmake_minimum_required(VERSION 3.15)
project(conan-cmake CXX)

if (POLICY CMP0141)
  cmake_policy(SET CMP0141 NEW)
  set(CMAKE_MSVC_DEBUG_INFORMATION_FORMAT "$<IF:$<AND:$<C_COMPILER_ID:MSVC>,$<CXX_COMPILER_ID:MSVC>>,$<$<CONFIG:Debug,RelWithDebInfo>:EditAndContinue>,$<$<CONFIG:Debug,RelWithDebInfo>:ProgramDatabase>>")
endif()

file(GLOB_RECURSE src
  RELATIVE ${CMAKE_SOURCE_DIR}
  CONFIGURE_DEPENDS
  "./src/*.h"
  "./src/*.c"
  "./src/*.hpp"
  "./src/*.cpp"
)

list(REMOVE_ITEM src "./src/main.cpp")

add_executable (${PROJECT_NAME} "./src/main.cpp" ${src})

set_property(TARGET ${PROJECT_NAME} PROPERTY CXX_STANDARD 23)

# Packages Finding Start

find_package(fmt REQUIRED)
find_package(glfw3 REQUIRED)
find_package(VulkanHeaders REQUIRED)

# Packages Finding End
##########################
# Packages Linking Start

target_link_libraries(${PROJECT_NAME} fmt::fmt glfw vulkan-headers::vulkan-headers)

# Packages Linking End

install(TARGETS conan-cmake DESTINATION "."
  RUNTIME DESTINATION bin
  ARCHIVE DESTINATION lib
  LIBRARY DESTINATION lib
  )

## Build Shaders

find_program(GLSL_VALIDATOR glslangValidator HINTS 
${Vulkan_GLSLANG_VALIDATOR_EXECUTABLE} 
/bin
/usr/bin 
/usr/local/bin 
$ENV{VULKAN_SDK}/Bin/ 
$ENV{VULKAN_SDK}/Bin32/
)

message(STATUS "glslangValidator: ${GLSL_VALIDATOR}")

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

if(EXISTS "${CMAKE_SOURCE_DIR}/build/Shaders")
  file(REMOVE_RECURSE "${CMAKE_SOURCE_DIR}/build/Shaders")
endif()
set(SHADER_OUTPUT_DIR "${CMAKE_SOURCE_DIR}/build/Shaders")
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

# Define the source and destination directories
set(PUBLIC_DIR "${CMAKE_SOURCE_DIR}/public")

# Public Folder
add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
  COMMAND ${CMAKE_COMMAND} -E copy_directory
  ${PUBLIC_DIR}
  $<TARGET_FILE_DIR:${PROJECT_NAME}>
)

# Remove .gitkeep file from the public folder
add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
  COMMAND ${CMAKE_COMMAND} -E rm -f "$<TARGET_FILE_DIR:${PROJECT_NAME}>/.gitkeep"
)

# Shaders Folder
add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
  COMMAND ${CMAKE_COMMAND} -E copy_directory
  "${CMAKE_SOURCE_DIR}/build/Shaders"
  "$<TARGET_FILE_DIR:${PROJECT_NAME}>/shaders"
)
