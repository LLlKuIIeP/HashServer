macro(set_project_settings name)

  include_guard(DIRECTORY)

  project(${name} LANGUAGES CXX)

  set(CMAKE_CXX_STANDARD 17)
  set(CMAKE_CXX_STANDARD_REQUIRED ON)


  if (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
    set(MSVC_GENERAL_FLAGS "/MP /EHsc")
    string(FIND "${CMAKE_CXX_FLAGS}" "${MSVC_GENERAL_FLAGS}" res_find_flags)
    if (${res_find_flags} EQUAL -1)
      set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${MSVC_GENERAL_FLAGS}")
    endif ()
    if (CMAKE_CXX_FLAGS MATCHES "/W[0-4]")
      string(REGEX REPLACE "/W[0-4]" "/W4" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
    else ()
      set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /W4")
    endif ()
  elseif (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    set(GCC_GENERAL_FLAGS "-Wall -Wextra -Wunused-parameter -Wno-long-long -Werror=return-type -pedantic")
    string(FIND "${CMAKE_CXX_FLAGS}" "${GCC_GENERAL_FLAGS}" res_find_flags)
    if (${res_find_flags} EQUAL -1)
      set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${GCC_GENERAL_FLAGS}")
    endif ()
  elseif (CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
    set(CLANG_GENERAL_FLAGS "-Wall -Wextra -pedantic")
    string(FIND "${CMAKE_CXX_FLAGS}" "${CLANG_GENERAL_FLAGS}" res_find_flags)
    if (${res_find_flags} EQUAL -1)
      set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${CLANG_GENERAL_FLAGS}")
    endif ()
  endif ()


enable_testing()
include(CTest)

endmacro()
