# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file LICENCE.txt or https://cmake.org/licensing for details.

set(ShaderBase_HEADERS
    AAPLShaderTypes.h
)

set(ShaderBase_SOURCES
    AAPLShaders.metal
)

add_metal_shader_library(ShaderBase
    ${ShaderBase_SOURCES}
    ${ShaderBase_HEADERS}
)
