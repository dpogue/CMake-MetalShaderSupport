# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file LICENCE.txt or https://cmake.org/licensing for details.

set(ShaderBase_HEADERS
    AAPLShaderTypes.h
)

set(ShaderBase_SOURCES
    AAPLShaders.metal
)

add_library(ShaderBase MODULE
    ${ShaderBase_SOURCES}
    ${ShaderBase_HEADERS}
)

set_target_properties(ShaderBase PROPERTIES
    XCODE_PRODUCT_TYPE com.apple.product-type.metal-library
    #XCODE_ATTRIBUTE_MTL_LANGUAGE_REVISION Metal21
    XCODE_ATTRIBUTE_MTL_FAST_MATH "YES"
    XCODE_ATTRIBUTE_MTL_ENABLE_DEBUG_INFO[variant=Debug] "INCLUDE_SOURCE"
    XCODE_ATTRIBUTE_MTL_ENABLE_DEBUG_INFO[variant=RelWithDebInfo] "INCLUDE_SOURCE"
)
