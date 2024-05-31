# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file LICENCE.txt or https://cmake.org/licensing for details.


if(CMAKE_Metal_COMPILER)
    add_subdirectory(ShaderBase)
    #add_subdirectory(ShaderFull)

    if(APPLE)
        add_subdirectory(ExampleApp)
    endif()
else()
    message(FATAL_ERROR "This example can only be built if Metal compilation is supported")
endif()
