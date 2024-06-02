# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file LICENCE.txt or https://cmake.org/licensing for details.

function(add_metal_shader_library TARGET)
    cmake_parse_arguments(PARSE_ARGV 1 _amsl
        ""
        "" #TODO: support "STANDARD"
        ""
    )

    add_library(${TARGET} MODULE ${_amsl_UNPARSED_ARGUMENTS})

    set_target_properties(${TARGET} PROPERTIES
        XCODE_PRODUCT_TYPE com.apple.product-type.metal-library
        XCODE_ATTRIBUTE_MTL_FAST_MATH "YES"
        XCODE_ATTRIBUTE_MTL_ENABLE_DEBUG_INFO[variant=Debug] "INCLUDE_SOURCE"
        XCODE_ATTRIBUTE_MTL_ENABLE_DEBUG_INFO[variant=RelWithDebInfo] "INCLUDE_SOURCE"
    )
endfunction()

function(target_embed_metal_shader_libraries TARGET)
    cmake_parse_arguments(PARSE_ARGV 1 _temsl
        ""
        ""
        ""
    )

    if(${CMAKE_VERSION} VERSION_GREATER_EQUAL 3.28 AND ${CMAKE_GENERATOR} STREQUAL "Xcode")
        set_target_properties(${TARGET} PROPERTIES
            XCODE_EMBED_RESOURCES ${_temsl_UNPARSED_ARGUMENTS}
        )
    else()
        foreach(SHADERLIB IN LISTS _temsl_UNPARSED_ARGUMENTS)
            add_custom_command(TARGET ${TARGET} POST_BUILD
                DEPENDS ${SHADERLIB}
                COMMAND ${CMAKE_COMMAND} -E copy "$<TARGET_FILE:${SHADERLIB}>" "$<TARGET_BUNDLE_CONTENT_DIR:${TARGET}>/Resources/$<TARGET_FILE_NAME:${SHADERLIB}>"
                VERBATIM
            )
        endforeach()
    endif()
endfunction()
