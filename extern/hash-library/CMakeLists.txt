cmake_minimum_required(VERSION 3.20.0 FATAL_ERROR)

include(../../general_cmake/general.cmake)
set(ROOT_PATH .)

set_project_settings(hash-library)

set(CMAKE_POSITION_INDEPENDENT_CODE ON)


set(HEADERS
  ./hash-library/crc32.h
  ./hash-library/hash.h
  ./hash-library/hmac.h
  ./hash-library/keccak.h
  ./hash-library/md5.h
  ./hash-library/sha1.h
  ./hash-library/sha3.h
  ./hash-library/sha256.h
)

set(SOURCES
  ./hash-library/crc32.cpp
  ./hash-library/digest.cpp
  ./hash-library/keccak.cpp
  ./hash-library/md5.cpp
  ./hash-library/sha1.cpp
  ./hash-library/sha3.cpp
  ./hash-library/sha256.cpp
)

directory_source_group(./)

add_library(${PROJECT_NAME} STATIC ${HEADERS} ${SOURCES})

target_include_directories(${PROJECT_NAME} PUBLIC ./hash-library)
