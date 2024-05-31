# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file LICENCE.txt or https://cmake.org/licensing for details.

add_library(ShaderFull MODULE
    AAPLUserCompiledFunction.metal
)

target_link_libraries(ShaderFull
    PUBLIC
    ShaderBase
)
