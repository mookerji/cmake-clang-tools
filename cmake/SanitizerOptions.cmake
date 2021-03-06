# Compiler options for enabling runtime analysis with Clang sanitization
# features.

option(ENABLE_SANITIZERS "Enable sanitizers." OFF)

option(ANALYZE_ADDRESS "Enable address sanitizer." OFF)
option(ANALYZE_DATAFLOW "Enable dataflow sanitizer." OFF)
option(ANALYZE_LEAK "Enable leak sanitizer." OFF)
option(ANALYZE_MEMORY "Enable memory sanitizer." OFF)
option(ANALYZE_THREAD "Enable thread sanitizer." OFF)
option(ANALYZE_UNDEFINED "Enable undefined behavior sanitizer." OFF)

if (ENABLE_SANITIZERS)
  # Some sanitizers can't be used simultaneously.
  if (ANALYZE_ADDRESS AND ANALYZE_MEMORY )
    message(WARNING "Can't -fsanitize address/memory simultaneously.")
  endif ()
  if (ANALYZE_MEMORY AND ANALYZE_THREAD )
    message(WARNING "Can't -fsanitize memory/thread simultaneously.")
  endif ()
  if (ANALYZE_ADDRESS AND ANALYZE_THREAD )
    message(WARNING "Can't -fsanitize address/thread simultaneously.")
  endif ()
  set(SANITIZE_FLAGS "")
  if (CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    set(SANITIZE_FLAGS  "-g -O0 -fno-omit-frame-pointer")
    if (ANALYZE_ADDRESS)
      message(STATUS "Enabling Clang address sanitizer (ASan).")
      set(SANITIZE_FLAGS  "${SANITIZE_FLAGS} -fsanitize=address")
      set(SANITIZE_FLAGS  "${SANITIZE_FLAGS} -fno-optimize-sibling-calls")
    elseif (ANALYZE_MEMORY)
      message(STATUS "Enabling Clang memory sanitizer (MSan).")
      set(SANITIZE_FLAGS  "${SANITIZE_FLAGS} -fsanitize=memory")
      set(SANITIZE_FLAGS  "${SANITIZE_FLAGS} -fno-optimize-sibling-calls")
      set(SANITIZE_FLAGS  "${SANITIZE_FLAGS} -fsanitize-memory-track-origins=2")
      set(SANITIZE_FLAGS  "${SANITIZE_FLAGS} -fsanitize-memory-use-after-dtor")
    elseif (ANALYZE_THREAD)
      message(STATUS "Enabling Clang thread sanitizer (TSan).")
      set(SANITIZE_FLAGS  "${SANITIZE_FLAGS} -fsanitize=thread")
    endif ()
    if (ANALYZE_LEAK)
      message(STATUS "Enabling Clang leak sanitizer (LSan).")
      set(SANITIZE_FLAGS  "${SANITIZE_FLAGS} -fsanitize=leak")
    endif ()
    if (ANALYZE_UNDEFINED)
      message(STATUS "Enabling Clang undefined behavior sanitizer (UBSan).")
      set(SANITIZE_FLAGS  "${SANITIZE_FLAGS} -fsanitize=undefined -fno-sanitize=vptr")
    endif ()
  else ()
    message(FATAL_ERROR "This compiler is not supported!")
  endif ()
  set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} ${SANITIZE_FLAGS}")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${SANITIZE_FLAGS}")
endif ()
