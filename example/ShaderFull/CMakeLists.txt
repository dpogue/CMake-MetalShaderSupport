# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file LICENCE.txt or https://cmake.org/licensing for details.

add_library(ShaderFull MODULE
    AAPLUserCompiledFunction.metal
)

target_link_libraries(ShaderFull
    PUBLIC
    ShaderBase
)

set_target_properties(ShaderFull PROPERTIES
    XCODE_PRODUCT_TYPE com.apple.product-type.metal-library
    XCODE_ATTRIBUTE_MTL_LANGUAGE_REVISION Metal21
    SUFFIX ".metallib"
    PREFIX ""
    XCODE_ATTRIBUTE_MTL_FAST_MATH "YES"
    XCODE_ATTRIBUTE_MTL_ENABLE_DEBUG_INFO[variant=Debug] "INCLUDE_SOURCE"
    XCODE_ATTRIBUTE_MTL_ENABLE_DEBUG_INFO[variant=RelWithDebInfo] "INCLUDE_SOURCE"
)
