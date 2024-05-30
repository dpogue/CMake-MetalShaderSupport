#  CMake(LANG)Information.cmake  -> set up rule variables for LANG :
#    CMAKE_(LANG)_CREATE_SHARED_LIBRARY
#    CMAKE_(LANG)_CREATE_SHARED_MODULE
#    CMAKE_(LANG)_CREATE_STATIC_LIBRARY
#    CMAKE_(LANG)_COMPILE_OBJECT
#    CMAKE_(LANG)_LINK_EXECUTABLE

include (CMakeCommonLanguageInclude)

set(CMAKE_INCLUDE_FLAG_Metal "-I ")


# now define the following rule variables

# CMAKE_Metal_CREATE_SHARED_LIBRARY
# CMAKE_Metal_CREATE_SHARED_MODULE
# CMAKE_Metal_COMPILE_OBJECT
# CMAKE_Metal_LINK_EXECUTABLE

# variables supplied by the generator at use time
# <TARGET>
# <TARGET_BASE> the target without the suffix
# <OBJECTS>
# <OBJECT>
# <LINK_LIBRARIES>
# <FLAGS>
# <LINK_FLAGS>

# Metal compiler information
# <CMAKE_Metal_COMPILER>
# <CMAKE_SHARED_LIBRARY_CREATE_Metal_FLAGS>
# <CMAKE_SHARED_MODULE_CREATE_Metal_FLAGS>
# <CMAKE_Metal_LINK_FLAGS>

if(NOT CMAKE_Metal_COMPILE_OBJECT)
  set(CMAKE_Metal_COMPILE_OBJECT
      "<CMAKE_Metal_COMPILER> <DEFINES> <INCLUDES> <FLAGS> -c -o <OBJECT> <SOURCE>")
endif()

if(NOT CMAKE_Metal_CREATE_STATIC_LIBRARY)
    set(CMAKE_Metal_CREATE_STATIC_LIBRARY "${CMAKE_Metal_COMPILER_AR} crs <TARGET> <OBJECTS>")
endif()

if(NOT CMAKE_Metal_CREATE_SHARED_LIBRARY)
    set(CMAKE_Metal_CREATE_SHARED_LIBRARY "${CMAKE_Metal_COMPILER_LINKER} <CMAKE_SHARED_LIBRARY_Metal_FLAGS> <LINK_FLAGS> -o <TARGET> <OBJECTS> <LINK_LIBRARIES>")
endif()

if(NOT CMAKE_Metal_CREATE_SHARED_MODULE)
    set(CMAKE_Metal_CREATE_SHARED_MODULE "${CMAKE_Metal_CREATE_SHARED_LIBRARY}")
endif()

if(NOT CMAKE_Metal_LINK_EXECUTABLE)
    # Metal shaders don't really have "executables", but we need this for the try_compile to work properly, so we'll just have it output a metallib file (identical to the "shared library" configuration)
    set(CMAKE_Metal_LINK_EXECUTABLE "${CMAKE_Metal_CREATE_SHARED_LIBRARY}")
endif()

set(CMAKE_Metal_INFORMATION_LOADED 1)
