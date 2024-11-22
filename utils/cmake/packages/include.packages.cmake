set(TARGET_LIBRARIES
  fmt::fmt
  glfw
  vulkan-headers::vulkan-headers
)

target_link_libraries(${PROJECT_NAME} ${TARGET_LIBRARIES})