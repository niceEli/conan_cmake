file(GLOB_RECURSE src
  RELATIVE ${PROJECT_SOURCE_DIR}
  CONFIGURE_DEPENDS
  "./src/*.h"
  "./src/*.c"
  "./src/*.hpp"
  "./src/*.cpp"
)

list(REMOVE_ITEM src "./src/main.cpp")

add_executable (${PROJECT_NAME} "./src/main.cpp" ${src})