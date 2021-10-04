###  GENETAL
set(MSVC_GENERAL_FLAGS "/MP /EHsc")
set(GCC_GENERAL_FLAGS "-Wall -Wextra -Wunused-parameter -Wno-long-long -pedantic")
set(CLANG_GENERAL_FLAGS "-Wall -pedantic")
###  CDASH
set(GCC_CTEST_FLAGS "${GCC_GENERAL_FLAGS} -Werror=return-type")
set(CLANG_CTEST_FLAGS "${CLANG_GENERAL_FLAGS} -Wextra")
set(CLANG_ANALYZER_FLAGS "-Wno-unused-command-line-argument --analyze")
set(CLANG_TIDY_CHECKS
  "-*,"
  "bugprone-*,"
  "clang-analyzer-core.uninitialized.CapturedBlockVariable,"
  "clang-analyzer-cplusplus.InnerPointer,"
  "clang-analyzer-nullability.NullableReturnedFromNonnull,"
  "clang-analyzer-optin.osx.OSObjectCStyleCast,"
  "clang-analyzer-optin.performance.Padding,"
  "concurrency-mt-unsafe,"
  "cppcoreguidelines-avoid-goto,"
  "cppcoreguidelines-avoid-non-const-global-variables,"
  "cppcoreguidelines-init-variables,"
  "cppcoreguidelines-interfaces-global-init,"
  "cppcoreguidelines-macro-usage,"
  "cppcoreguidelines-narrowing-conversions,"
  "cppcoreguidelines-no-malloc,"
  "cppcoreguidelines-pro-type-const-cast,"
  "cppcoreguidelines-pro-type-cstyle-cast,"
  "cppcoreguidelines-pro-type-member-init,"
  "cppcoreguidelines-pro-type-union-access,"
  "cppcoreguidelines-slicing,"
  "cppcoreguidelines-special-member-functions,"
  "darwin-*,"
  "fuchsia-trailing-return,"
  "google-build-explicit-make-pair,"
  "google-build-using-namespace,"
  "google-explicit-constructor,"
  "google-global-names-in-headers,"
  "google-readability-casting,"
  "google-runtime-operator,"
  "hicpp-multiway-paths-covered,"
  "hicpp-no-assemblyr,"
  "hicpp-signed-bitwise,"
  "llvm-include-order,"
  "llvm-namespace-comment,"
  "misc-definitions-in-headers,"
  "misc-misplaced-const,"
  "misc-new-delete-overloads,"
  "misc-redundant-expression,"
  "misc-throw-by-value-catch-by-reference,"
  "misc-unconventional-assign-operator,"
  "misc-uniqueptr-reset-release,"
  "misc-unused-alias-decls,"
  "misc-unused-parameters,"
  "performance-faster-string-find,"
  "performance-for-range-copy,"
  "performance-inefficient-string-concatenation,"
  "performance-implicit-conversion-in-loop,"
  "performance-inefficient-algorithm,"
  "performance-inefficient-vector-operation,"
  "performance-move-const-arg,"
  "performance-no-automatic-move,"
  "performance-no-int-to-ptr,"
  "performance-noexcept-move-constructor,"
  "performance-trivially-destructible,"
  "performance-type-promotion-in-math-fn,"
  "performance-unnecessary-copy-initialization,"
  "performance-unnecessary-value-param,"
  "readability-avoid-const-params-in-decls,"
  "readability-const-return-type,"
  "readability-container-size-empty,"
  "readability-convert-member-functions-to-static,"
  "readability-delete-null-pointer,"
  "readability-deleted-default,"
  "readability-else-after-return,"
  "readability-implicit-bool-conversion,"
  "readability-inconsistent-declaration-parameter-name,"
  "readability-isolate-declaration,"
  "readability-make-member-function-const,"
  "readability-misleading-indentation,"
  "readability-misplaced-array-index,"
  "readability-named-parameter,"
  "readability-non-const-parameter,"
  "readability-qualified-auto,"
  "readability-redundant-access-specifiers,"
  "readability-redundant-control-flow,"
  "readability-redundant-declaration,"
  "readability-redundant-function-ptr-dereference,"
  "readability-redundant-member-init,"
  "readability-redundant-preprocessor,"
  "readability-redundant-smartptr-get,"
  "readability-redundant-string-cstr,"
  "readability-redundant-string-init,"
  "readability-static-definition-in-anonymous-namespace,"
  "readability-string-compare,"
  "readability-uniqueptr-delete-release,"
  "cert-dcl21-cpp,"
  "cert-dcl50-cpp,"
  "cert-dcl58-cpp,"
  "cert-err34-c,"
  "cert-err52-cpp,"
  "cert-err58-cpp,"
  "cert-oop58-cpp"
)


### --- Sanitizer
set(ADDRESS_SANITIZER_FLAGS "-fno-omit-frame-pointer -fsanitize=address")
set(THREAD_SANITIZER_FLAGS "-fsanitize=thread")
set(MEMORY_SANITIZER_FLAGS "-fsanitize=memory")
set(UNDEFINED_SANITIZER_FLAGS "-fsanitize=undefined")
set(LEAK_SANITIZER_FLAGS "-fsanitize=leak")

### GENETAL
macro(general_msvc_flags)
  string(FIND "${CMAKE_CXX_FLAGS}" "${MSVC_GENERAL_FLAGS}" res_find_flags)
  if (${res_find_flags} EQUAL -1)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${MSVC_GENERAL_FLAGS}")
  endif ()
  # Force to always compile with W4
  if (CMAKE_CXX_FLAGS MATCHES "/W[0-4]")
    string(REGEX REPLACE "/W[0-4]" "/W4" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
  else ()
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /W4")
  endif ()
endmacro()

macro(general_gcc_flags)
  string(FIND "${CMAKE_CXX_FLAGS}" "${GCC_GENERAL_FLAGS}" res_find_flags)
  if (${res_find_flags} EQUAL -1)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${GCC_GENERAL_FLAGS}")
  endif ()
endmacro()

macro(general_clang_flags)
  string(FIND "${CMAKE_CXX_FLAGS}" "${CLANG_GENERAL_FLAGS}" res_find_flags)
  if (${res_find_flags} EQUAL -1)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${CLANG_GENERAL_FLAGS}")
  endif ()
endmacro()
### --------------------------------------------------------------------


### CDASH
macro(cdash_gcc_flags)
  string(FIND "${CMAKE_CXX_FLAGS}" "${GCC_CTEST_FLAGS}" res_find_flags)
  if (${res_find_flags} EQUAL -1)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${GCC_CTEST_FLAGS}")
  endif ()
endmacro()

macro(cdash_clang_flags)
  string(FIND "${CMAKE_CXX_FLAGS}" "${CLANG_CTEST_FLAGS}" res_find_flags)
  if (${res_find_flags} EQUAL -1)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${CLANG_CTEST_FLAGS}")
  endif ()
endmacro()

macro(cdash_clang_analyzer_flags)
  string(FIND "${CMAKE_CXX_FLAGS}" "${CLANG_ANALYZER_FLAGS}" res_find_flags)
  if (CLANG_ANALYZER AND ${res_find_flags} EQUAL -1)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${CLANG_ANALYZER_FLAGS}")
  endif ()
endmacro()

macro(cdash_clang_tidy_flags)
  ### --- лайфак, чтобы собрать все строки в одну
  string(REPLACE "" "" CLANG_TIDY_CHECKS ${CLANG_TIDY_CHECKS})
  set(CMAKE_CXX_CLANG_TIDY "${CMAKE_CXX_CLANG_TIDY};-checks=${CLANG_TIDY_CHECKS};-header-filter='${PROJECT_ROOT_PATH}/*'")
endmacro()


### --- SANITIZER
macro(address_sanitizer_flags)
  string(FIND "${CMAKE_CXX_FLAGS}" "${ADDRESS_SANITIZER_FLAGS}" res_find_flags)
  if (${res_find_flags} EQUAL -1)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${ADDRESS_SANITIZER_FLAGS}")
  endif ()
endmacro()

macro(thread_sanitizer_flags)
  string(FIND "${CMAKE_CXX_FLAGS}" "${THREAD_SANITIZER_FLAGS}" res_find_flags)
  if (${res_find_flags} EQUAL -1)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${THREAD_SANITIZER_FLAGS}")
  endif ()
endmacro()

macro(memory_sanitizer_flags)
  string(FIND "${CMAKE_CXX_FLAGS}" "${MEMORY_SANITIZER_FLAGS}" res_find_flags)
  if (${res_find_flags} EQUAL -1)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${MEMORY_SANITIZER_FLAGS}")
  endif ()
endmacro()

macro(undefined_sanitizer_flags)
  string(FIND "${CMAKE_CXX_FLAGS}" "${UNDEFINED_SANITIZER_FLAGS}" res_find_flags)
  if (${res_find_flags} EQUAL -1)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${UNDEFINED_SANITIZER_FLAGS}")
  endif ()
endmacro()

macro(leak_sanitizer_flags)
  string(FIND "${CMAKE_CXX_FLAGS}" "${LEAK_SANITIZER_FLAGS}" res_find_flags)
  if (${res_find_flags} EQUAL -1)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${LEAK_SANITIZER_FLAGS}")
  endif ()
endmacro()
### --------------------------------------------------------------------
