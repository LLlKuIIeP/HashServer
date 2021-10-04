include(${CMAKE_CURRENT_LIST_DIR}/compiler_flags.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/custom_error_exception.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/custom_warning_exception.cmake)

get_filename_component(ABSOLUTE_PATH_GENERAL_CMAKE ${CMAKE_CURRENT_LIST_DIR} ABSOLUTE)
get_filename_component(ABSOLUTE_PATH_CMAKE_UTILS ${CMAKE_CURRENT_LIST_DIR} ABSOLUTE)


function(directory_source_group)
  # по всем директориям
  foreach(dirs IN ITEMS ${ARGN})

    # проверка на абсолютный/относительный путь
    if (IS_ABSOLUTE "${dirs}")
      set(path ${dirs})
    else ()
      set(path ${CMAKE_CURRENT_SOURCE_DIR}/${dirs})
    endif ()

    # рекурсивно обходит директорию ${path}
    file(GLOB_RECURSE files
      "${path}/*.[hc]"
      "${path}/*.[hc]pp"
      "${path}/*.ui"
      "${path}/*.qrc"
    )
    # поочередно закидивая каждый файл
    foreach(source IN ITEMS ${files})
      source_group(TREE "${path}" FILES "${source}")
    endforeach()
  endforeach()

  # группа для файлов сгенерированных автоматически
  source_group ("generated_files" REGULAR_EXPRESSION "(.*qrc_.*\\.cpp|.*mocs_.*\\.cpp)")
endfunction(directory_source_group)


macro(set_project_settings name)

  include_guard(DIRECTORY)

  project(${name} LANGUAGES CXX)

  set(CMAKE_CXX_STANDARD 17)
  set(CMAKE_CXX_STANDARD_REQUIRED ON)


  if (("${CDASH_PROJECT}" STREQUAL "") AND ("${CDASH_TOKEN}" STREQUAL ""))
    if (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
      general_msvc_flags()
    elseif (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
      general_gcc_flags()
    elseif (CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
      general_clang_flags()
    endif ()
  else () ### --- CDASH
    if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
      #cdash_gcc_flags()
    elseif (CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
      cdash_clang_flags()
      if (CLANG_ANALYZER)
        cdash_clang_analyzer_flags()
      elseif (CMAKE_CXX_CLANG_TIDY)
        cdash_clang_tidy_flags()
      endif ()
    endif()
  endif ()


  ### --- SANITIZE
  if (SANITIZE)
    if (SANITIZE STREQUAL "address")
      address_sanitizer_flags()
    elseif (SANITIZE STREQUAL "thread")
      thread_sanitizer_flags()
    elseif (SANITIZE STREQUAL "memory")
      set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fsanitize=memory -fno-omit-frame-pointer -fsanitize-memory-track-origins -fsanitize-blacklist=${ABSOLUTE_PATH_GENERAL_CMAKE}/blacklist_memory_sanitizer.txt")
    elseif (SANITIZE STREQUAL "undefined")
      undefined_sanitizer_flags()
    elseif (SANITIZE STREQUAL "leak")
      leak_sanitizer_flags()
    endif()
  endif ()

enable_testing()
include(CTest)

endmacro()



macro(copy_ctest_files)

if (("${CDASH_PROJECT}" STRGREATER "") AND ("${CDASH_TOKEN}" STRGREATER ""))

get_filename_component(PROJECT_ROOT_PATH ${ROOT_PATH} ABSOLUTE)
get_filename_component(CMAKE_SOURCE_DIR_ABSOLUTE ${CMAKE_SOURCE_DIR} ABSOLUTE)
get_filename_component(CMAKE_BINARY_DIR_ABSOLUTE ${CMAKE_BINARY_DIR} ABSOLUTE)

if (${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION} VERSION_LESS "3.19")
  if (NOT WIN32)
    string(ASCII 27 Esc)
    set(ColourReset "${Esc}[m")
    set(ColourBold  "${Esc}[1m")
    set(Red         "${Esc}[31m")
    set(Green       "${Esc}[32m")
    set(Yellow      "${Esc}[33m")
    set(Blue        "${Esc}[34m")
    set(Magenta     "${Esc}[35m")
    set(Cyan        "${Esc}[36m")
    set(White       "${Esc}[37m")
    set(BoldRed     "${Esc}[1;31m")
    set(BoldGreen   "${Esc}[1;32m")
    set(BoldYellow  "${Esc}[1;33m")
    set(BoldBlue    "${Esc}[1;34m")
    set(BoldMagenta "${Esc}[1;35m")
    set(BoldCyan    "${Esc}[1;36m")
    set(BoldWhite   "${Esc}[1;37m")
    message(FATAL_ERROR "${Red}Current CMake is ${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION} and need not less 3.19${ColourReset}\n")
  elseif ()
    message(FATAL_ERROR "Current CMake is ${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION} and need not less 3.19\n")
  endif ()
endif ()

### --- Generate CTestConfig.cmake
configure_file(${ABSOLUTE_PATH_CMAKE_UTILS}/CTestConfig.cmake.in ${CMAKE_SOURCE_DIR}/CTestConfig.cmake NEWLINE_STYLE UNIX)


set(CTEST_BUILD_NAME "${CMAKE_HOST_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_PROCESSOR}-${CMAKE_CXX_COMPILER_ID}")
## -- Build name and generator
### --- MSVC
if (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
  if (${MSVC_TOOLSET_VERSION} EQUAL 141)
    set(CTEST_BUILD_NAME "${CTEST_BUILD_NAME}-2017")
  elseif (${MSVC_TOOLSET_VERSION} EQUAL 142)
    set(CTEST_BUILD_NAME "${CTEST_BUILD_NAME}-2019")
  endif()
### --- GNU or Clang
elseif (CMAKE_CXX_COMPILER_ID STREQUAL "GNU" OR CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
  set(CTEST_BUILD_NAME "${CTEST_BUILD_NAME}-${CMAKE_CXX_COMPILER_VERSION}")
endif ()

set(CTEST_CMAKE_GENERATOR "Ninja")

### --- STATIC ANALYZER
### --- CppCheck
if (CMAKE_CXX_CPPCHECK)
  set(CTEST_BUILD_NAME "${CTEST_BUILD_NAME}-CppCheck")
### --- Clang-tidy
elseif (CMAKE_CXX_CLANG_TIDY)
  set(CTEST_BUILD_NAME "${CTEST_BUILD_NAME}-Clang-tidy")
### --- Clazy
elseif (CMAKE_CXX_COMPILER MATCHES "clazy")
  set(CTEST_BUILD_NAME "${CTEST_BUILD_NAME}-clazy")
  set(CMAKE_EXPORT_COMPILE_COMMANDS "level1;no-clazy-qproperty-without-notify;no-clazy-qcolor-from-literal,no-clazy-non-pod-global-static")
### --- Clang Analyzer
elseif (CLANG_ANALYZER)
  set(CTEST_BUILD_NAME "${CTEST_BUILD_NAME}-Analyzer")
endif ()


### --- Custom Error Exception
qt_custom_error_exception()
thirdparty_custom_error_exception()
### --- CppCheck
if (CMAKE_CXX_CPPCHECK)
  cppcheck_custom_error_exception()
### --- Clang-tidy
elseif (CMAKE_CXX_CLANG_TIDY)
  clang_tidy_custom_error_exception()
### --- Clazy
elseif (CMAKE_CXX_COMPILER MATCHES "clazy")
  clazy_custom_error_exception()
endif ()
string(REPLACE ";" "\"\n  \"" CTEST_CUSTOM_ERROR_EXCEPTION "${CTEST_CUSTOM_ERROR_EXCEPTION}")
### --- баг с (.*) https://gitlab.kitware.com/cmake/cmake/-/issues/18884
string(REGEX REPLACE "^(.+)$" "\"\\1\"" CTEST_CUSTOM_ERROR_EXCEPTION "${CTEST_CUSTOM_ERROR_EXCEPTION}")

### --- Custom Warning Exception
qt_custom_warning_exception()
thirdparty_custom_warning_exception()
### --- CppCheck
if (CMAKE_CXX_CPPCHECK)
  cppcheck_custom_warning_exception()
### --- Clang-tidy
elseif (CMAKE_CXX_CLANG_TIDY)
  clang_tidy_custom_warning_exception()
### --- Clazy
elseif (CMAKE_CXX_COMPILER MATCHES "clazy")
  clazy_custom_warning_exception()
endif ()
string(REPLACE ";" "\"\n  \"" CTEST_CUSTOM_WARNING_EXCEPTION "${CTEST_CUSTOM_WARNING_EXCEPTION}")
string(REGEX REPLACE "^(.+)$" "\"\\1\"" CTEST_CUSTOM_WARNING_EXCEPTION "${CTEST_CUSTOM_WARNING_EXCEPTION}")


### --- Generate CTestCustom.cmake
configure_file(${ABSOLUTE_PATH_CMAKE_UTILS}/CTestCustom.cmake.in ${CMAKE_BINARY_DIR}/CTestCustom.cmake NEWLINE_STYLE UNIX)


### --- вытащить hash коммита
find_package(Git)
if (GIT_FOUND)
  message("git found: ${GIT_EXECUTABLE}")
  execute_process(COMMAND "${GIT_EXECUTABLE}" rev-parse --short HEAD
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    OUTPUT_VARIABLE GIT_SHORT_HASH
    RESULT_VARIABLE GIT_SHORT_HASH_RES
  ERROR_QUIET)
  execute_process(COMMAND "${GIT_EXECUTABLE}" branch --show-current
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    OUTPUT_VARIABLE GIT_BRANCH_NAME
    RESULT_VARIABLE GIT_BRANCH_NAME_RES
  ERROR_QUIET)
  if ((NOT ${GIT_SHORT_HASH_RES} EQUAL 0) OR (NOT ${GIT_BRANCH_NAME_RES} EQUAL 0))
    message(FATAL_ERROR "Need update git\n")
  endif ()
  
  if (WIN32)
    ### -- branch name
    string(REPLACE "\n" "" GIT_BRANCH_NAME ${GIT_BRANCH_NAME})
    string(REPLACE "\r" "" GIT_BRANCH_NAME ${GIT_BRANCH_NAME})
    ### --- hash commit
    string(REPLACE "\n" "" GIT_SHORT_HASH ${GIT_SHORT_HASH})
    string(REPLACE "\r" "" GIT_SHORT_HASH ${GIT_SHORT_HASH})
  elseif (UNIX)
    ### -- branch name
    string(REPLACE "\n" "" GIT_BRANCH_NAME ${GIT_BRANCH_NAME})
    ### --- hash commit
    string(REPLACE "\n" "" GIT_SHORT_HASH ${GIT_SHORT_HASH})
  endif ()
endif ()


### --- Generate CTestDashboard.cmake
if (SANITIZE)
  if (SANITIZE STREQUAL "address")
    set(CTEST_MEMORYCHECK_TYPE "AddressSanitizer")
  elseif (SANITIZE STREQUAL "thread")
    set(CTEST_MEMORYCHECK_TYPE "ThreadSanitizer")
  elseif (SANITIZE STREQUAL "memory")
    set(CTEST_MEMORYCHECK_TYPE "MemorySanitizer")
  elseif (SANITIZE STREQUAL "undefined")
    set(CTEST_MEMORYCHECK_TYPE "UndefinedBehaviorSanitizer")
  elseif (SANITIZE STREQUAL "leak")
    set(CTEST_MEMORYCHECK_TYPE "LeakSanitizer")
  endif ()

  set(CTEST_BUILD_NAME "${CTEST_BUILD_NAME}-${GIT_BRANCH_NAME}-${CTEST_MEMORYCHECK_TYPE}-${GIT_SHORT_HASH}")
  configure_file(${ABSOLUTE_PATH_CMAKE_UTILS}/CTestDashboardSanitizer.cmake.in ${CMAKE_BINARY_DIR}/CTestDashboard.cmake @ONLY NEWLINE_STYLE UNIX)
else ()
  set(CTEST_BUILD_NAME "${CTEST_BUILD_NAME}-${GIT_BRANCH_NAME}-${GIT_SHORT_HASH}")
  configure_file(${ABSOLUTE_PATH_CMAKE_UTILS}/CTestDashboard.cmake.in ${CMAKE_BINARY_DIR}/CTestDashboard.cmake @ONLY NEWLINE_STYLE UNIX)
endif ()

endif ()

endmacro()
