# CMake script searches for clang-tidy sets the following variables:
#
# CLANG_TIDY_PATH    : Fully-qualified path to the clang-tidy executable

# Check for Clang Tidy
set(CLANG_TIDY_PATH "NOTSET" CACHE STRING
  "Absolute path to the clang-tidy executable")

if("${CLANG_TIDY_PATH}" STREQUAL "NOTSET")
  find_program(CLANG_TIDY NAMES
  clang-tidy39 clang-tidy-3.9
  clang-tidy38 clang-tidy-3.8
  clang-tidy37 clang-tidy-3.7
  clang-tidy36 clang-tidy-3.6
  clang-tidy35 clang-tidy-3.5
  clang-tidy34 clang-tidy-3.4
  clang-tidy)
  if("${CLANG_TIDY}" STREQUAL "CLANG_TIDY-NOTFOUND")
    message(WARNING
      "Could not find 'clang-tidy' please set CLANG_TIDY_PATH:STRING")
  else()
    set(CLANG_TIDY_PATH ${CLANG_TIDY})
    message(STATUS "Found: ${CLANG_TIDY_PATH}")
  endif()
else()
  if(NOT EXISTS ${CLANG_TIDY_PATH})
    message(WARNING "Could not find clang-tidy: ${CLANG_TIDY_PATH}")
  else()
    message(STATUS "Found: ${CLANG_TIDY_PATH}")
  endif()
endif()
