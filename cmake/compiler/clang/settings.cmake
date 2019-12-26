#todo: minimal version?

# Set build-directive (used in core to tell which buildtype we used)
target_compile_definitions(trinity-compile-option-interface
   INTERFACE
     -D_BUILD_DIRECTIVE="${CMAKE_BUILD_TYPE}")

if(WITH_WARNINGS)
  target_compile_options(trinity-warning-interface
    INTERFACE
        -W
        -Wall
        -Wextra
        -Winit-self
        -Wfatal-errors
        -Wno-mismatched-tags
        -Woverloaded-virtual)
 
  message(STATUS "Clang: All warnings enabled")
endif()

if(WITH_COREDEBUG)
  target_compile_options(trinity-compile-option-interface
    INTERFACE
        -g3)
	  
  message(STATUS "Clang: Debug-flags set (-g3)")
endif()

if(ASAN)
  target_compile_options(trinity-compile-option-interface
    INTERFACE
      -fno-omit-frame-pointer
      -fsanitize=address
      -fsanitize-recover=address
      -fsanitize-address-use-after-scope)

  target_link_options(trinity-compile-option-interface
    INTERFACE
      -fno-omit-frame-pointer
      -fsanitize=address
      -fsanitize-recover=address
      -fsanitize-address-use-after-scope)

  message(STATUS "Clang: Enabled Address Sanitizer")
endif()

# -Wno-narrowing needed to suppress a warning in g3d
# -Wno-deprecated-register is needed to suppress 185 gsoap warnings on Unix systems.
# -Wno-switch because I find this warning useless
target_compile_options(trinity-compile-option-interface
  INTERFACE
    -Wno-narrowing
    -Wno-deprecated-register)

if (BUILD_SHARED_LIBS)
  # -fPIC is needed to allow static linking in shared libs.
  target_compile_options(trinity-compile-option-interface
    INTERFACE
        -fPIC)

   # -fvisibility=hidden sets the default visibility to hidden to prevent exporting of all symbols.
   target_compile_options(trinity-hidden-symbols-interface
     INTERFACE
         -fvisibility=hidden)

  # --no-undefined to throw errors when there are undefined symbols
  # (caused through missing TRINITY_*_API macros).
  set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} --no-undefined")

  message(STATUS "Clang: Disallow undefined symbols")
endif()

if(USE_GPERFTOOLS)
#NOTE: When compiling with programs with gcc, that you plan to link
#with libtcmalloc, it's safest to pass in the flags
# -fno-builtin-malloc -fno-builtin-calloc -fno-builtin-realloc -fno-builtin-free
#when compiling.  gcc makes some optimizations assuming it is using its
#own, built-in malloc; that assumption obviously isn't true with
#tcmalloc.  In practice, we haven't seen any problems with this, but
#the expected risk is highest for users who register their own malloc
##hooks with tcmalloc (using gperftools/malloc_hook.h).  The risk is
#lowest for folks who use tcmalloc_minimal (or, of course, who pass in
#the above flags :-) ).
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-builtin-malloc -fno-builtin-calloc -fno-builtin-realloc -fno-builtin-free")
endif()
