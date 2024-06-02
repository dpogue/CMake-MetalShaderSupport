# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file LICENCE.txt or https://cmake.org/licensing for details.

enable_language(OBJC)

set(ExampleApp_SOURCES
    AAPLAppDelegate.m
    AAPLRenderer.m
    AAPLViewController.m
    main.m
)

set(ExampleApp_HEADERS
    AAPLAppDelegate.h
    AAPLRenderer.h
    AAPLViewController.h
)

set(ExampleApp_RESOURCES
    Main.storyboard
)

add_executable(ExampleApp MACOSX_BUNDLE
    ${ExampleApp_SOURCES} ${ExampleApp_HEADERS} ${ExampleApp_RESOURCES}
)

set_target_properties(ExampleApp PROPERTIES
    MACOSX_BUNDLE_INFO_PLIST "${CMAKE_CURRENT_SOURCE_DIR}/Info.plist"
    MACOSX_BUNDLE_GUI_IDENTIFIER ca.dpogue.metaltest.example
    XCODE_ATTRIBUTE_PRODUCT_BUNDLE_IDENTIFIER ca.dpogue.metaltest.example
)

target_embed_metal_shader_libraries(ExampleApp
    ShaderBase
)

if(${CMAKE_GENERATOR} STREQUAL "Xcode")
    set_target_properties(ExampleApp PROPERTIES
        RESOURCE ${ExampleApp_RESOURCES}
    )
else()
    find_program(IBTOOL ibtool HINTS "/usr/bin" "${OSX_DEVELOPER_ROOT}/usr/bin")
    add_custom_command(TARGET ExampleApp POST_BUILD
        COMMAND ${IBTOOL} --output-format human-readable-text --compile "$<TARGET_BUNDLE_CONTENT_DIR:ExampleApp>/Resources/Main.storyboardc" "${CMAKE_CURRENT_SOURCE_DIR}/Main.storyboard"
        COMMENT "Compiling Main.storyboard to Main.storyboardc"
        VERBATIM
    )
endif()

target_link_libraries(ExampleApp
    PRIVATE
    "-framework Cocoa"
    "-framework Metal"
)

target_include_directories(ExampleApp
    PRIVATE
    ../ShaderBase
)
