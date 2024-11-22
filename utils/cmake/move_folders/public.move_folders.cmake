# Define the source and destination directories
set(PUBLIC_DIR "${PROJECT_SOURCE_DIR}/public")

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
