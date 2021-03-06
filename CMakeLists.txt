cmake_minimum_required(VERSION 3.20.0 FATAL_ERROR)

include(./cmake/general.cmake)
set(ROOT_PATH .)

set_project_settings(my_server)

set(CMAKE_CXX_VISIBILITY_PRESET hidden)
set(CMAKE_VISIBILITY_INLINES_HIDDEN 1)

find_package(Poco REQUIRED Net)

if (MSVC)
  set(BUILD_SHARED_LIBS TRUE)
  add_definitions(-DBUILDING_DLL=ON)
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG ${CMAKE_BINARY_DIR}/Debug)
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE ${CMAKE_BINARY_DIR}/Release)
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELWITHDEBINFO ${CMAKE_BINARY_DIR}/RelWithDebInfo)
endif ()

set(PUBLIC_H ./)
set(PRIVATE_H ./include)

set(HEADERS
### PUBLIC
  ./hash_server.h
### PRIVATE
  ./include/md5_connection.h
  ./include/sha1_connection.h
)

set(SOURCES
  ./src/hash_server.cpp
  ./src/md5_connection.cpp
  ./src/sha1_connection.cpp
)


add_library(${PROJECT_NAME} SHARED ${HEADERS} ${SOURCES})

add_subdirectory(${ROOT_PATH}/extern/hash-library ${CMAKE_BINARY_DIR}/${PROJECT_NAME}/hash-library)


### видные хедеры
target_include_directories(${PROJECT_NAME} PUBLIC ./)
### спрятанные хедеры
target_include_directories(${PROJECT_NAME} PRIVATE ./include/)

target_link_libraries(
  ${PROJECT_NAME}
  PRIVATE
  Poco::Net
  hash-library
)


### тесты
if (BUILD_TESTING)
  set(RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/tests)
  add_subdirectory(${ROOT_PATH}/extern/Catch2 ${CMAKE_BINARY_DIR}/${PROJECT_NAME}/Catch2)
  set(SOURCES_TEST
    ./tests/thread.cpp
    ./tests/md5.cpp
    ./tests/sha1.cpp
  )

  foreach(SRC_TST IN ITEMS ${SOURCES_TEST})
    string(REPLACE "./tests/" "test_" TEST_NAME ${SRC_TST})
    string(REPLACE ".cpp" "" TEST_NAME ${TEST_NAME})

    add_executable(${TEST_NAME} ${SRC_TST})
    target_include_directories(${TEST_NAME} PRIVATE ${PUBLIC_H} ${PRIVATE_H})
    target_link_libraries(
      ${TEST_NAME}
      PRIVATE
      ${PROJECT_NAME}
      Poco::Net
      Catch2
    )

    set_target_properties(${TEST_NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/tests")

    add_test(NAME "${TEST_NAME}" COMMAND "${TEST_NAME}")

  endforeach()

#  add_custom_target(copy_tests_files ALL
#    COMMAND ${CMAKE_COMMAND}
#    -E copy_directory
#    ${CMAKE_CURRENT_SOURCE_DIR}/tests/data
#    ${CMAKE_BINARY_DIR}/tests/data
#  )

endif()
