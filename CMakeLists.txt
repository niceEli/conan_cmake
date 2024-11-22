# Initialize CMake And The Build System
cmake_minimum_required(VERSION 3.15)
project(conan-cmake CXX) # Change "conan-cmake" to your project name

# Internals
include("${PROJECT_SOURCE_DIR}/utils/cmake/internal/msvc.internal.cmake")
include("${PROJECT_SOURCE_DIR}/utils/cmake/internal/source_files.internal.cmake")
include("${PROJECT_SOURCE_DIR}/utils/cmake/internal/compile_options.internal.cmake")

# Packages
include("${PROJECT_SOURCE_DIR}/utils/cmake/packages/find.packages.cmake")
include("${PROJECT_SOURCE_DIR}/utils/cmake/packages/include.packages.cmake")

# Install (Internal)
include("${PROJECT_SOURCE_DIR}/utils/cmake/internal/install.internal.cmake")

# Shaders
include("${PROJECT_SOURCE_DIR}/utils/cmake/shader/glsl.shader.cmake")
include("${PROJECT_SOURCE_DIR}/utils/cmake/shader/slang.shader.cmake")

# Move Folders
include("${PROJECT_SOURCE_DIR}/utils/cmake/move_folders/public.move_folders.cmake")
include("${PROJECT_SOURCE_DIR}/utils/cmake/move_folders/shader.move_folders.cmake")

# idk but ill just tell the user that they are ready to build and make c stuff
message("All Ready!")
message("Build Now Available")