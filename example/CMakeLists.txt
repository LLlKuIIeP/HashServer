cmake_minimum_required(VERSION 3.20.0 FATAL_ERROR)

include(../cmake/general.cmake)
set(ROOT_PATH .)
enable_testing()
set_project_settings(main)

if (MSVC)
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG ${CMAKE_BINARY_DIR}/Debug)
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE ${CMAKE_BINARY_DIR}/Release)
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELWITHDEBINFO ${CMAKE_BINARY_DIR}/RelWithDebInfo)
endif ()

set(SOURCES
  ./main.cpp
)

add_executable(${PROJECT_NAME} ${SOURCES})

set_target_properties(${PROJECT_NAME} PROPERTIES OUTPUT_NAME "main")


add_subdirectory(${ROOT_PATH}/../ ${CMAKE_BINARY_DIR}/my_server)

target_link_libraries(${PROJECT_NAME}
    PRIVATE
    my_server
)
