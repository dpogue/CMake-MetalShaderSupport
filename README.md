Metal Shader support for CMake
==============================

This project aims to allow compiling, linking, and embedding Apple Metal shader libraries in projects using CMake, without the need to write custom build steps or be restricted to only using the Xcode project generator.

The **MetalShaderSupport** module provides helper functions to create Metal shader library targets and embed shaders within application bundles.

Project Setup
-------------

1. Copy the files from the `cmake` folder of this repo into a top-level `cmake` folder in your project.

2. Add that `cmake` folder to the `CMAKE_MODULE_PATH` of your project:

    ```cmake
    # In the top-level CMakeLists.txt file for your project:
    set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH};${CMAKE_SOURCE_DIR}/cmake")

    include(MetalShaderSupport)
    ```

3. Enable the Metal language for your project:

    ```cmake
    enable_language(Metal)
    ```

    If you want to conditionally detect whether Metal can be supported, you can use `check_language`:

    ```cmake
    include(CheckLanguage)

    check_language(Metal)
    if(CMAKE_Metal_COMPILER)
        enable_language(Metal)

        message(STATUS "Metal is supported")
    else()
        message(WARNING "Metal is not supported")
    endif()
    ```


Shader Library Setup
--------------------

> [!IMPORTANT]
> **Shaders must be in their own CMake target!**  
> You cannot mix them  with C++ or Objective-C code sources in a library or executable target.

Your final shader library will need to be a `.metallib` file that can be included in your application as a resource. Use the `add_metal_shader_library` function (from the MetalShaderSupport module) to set up the library target containing your shader sources:

```cmake
add_metal_shader_library(MyShaders
    shader1.metal
    shader2.metal
)
```

You can specify a Metal language version with the `STANDARD` attribute:

```cmake
add_metal_shader_library(MyShaders
    STANDARD macos-metal2.3
    shader1.metal
    shader2.metal
)
```

<details>
<summary><h3>Implementation Details</h3></summary>

The `add_metal_shader_library` helper creates a `MODULE` library containing the sources, and also sets up some Xcode-specific properties to ensure everything works with the Xcode project generator. Effectively, it implements the following:

```cmake
add_library(MyShaders MODULE
    shader1.metal
    shader2.metal
)

set_target_properties(MyShaders PROPERTIES
    XCODE_PRODUCT_TYPE com.apple.product-type.metal-library
    XCODE_ATTRIBUTE_MTL_FAST_MATH "YES"
    XCODE_ATTRIBUTE_MTL_ENABLE_DEBUG_INFO[variant=Debug] "INCLUDE_SOURCE"
    XCODE_ATTRIBUTE_MTL_ENABLE_DEBUG_INFO[variant=RelWithDebInfo] "INCLUDE_SOURCE"
)

# If a target language version is provided:
target_compile_options(MyShaders
    PRIVATE "-std=macos-metal2.3"
)

set_target_properties(MyShaders PROPERTIES
    XCODE_ATTRIBUTE_MTL_LANGUAGE_REVISION "Metal23"
)
```

</details>


Embedding Shaders
-----------------

As a final step to make your shader library available to your application, you will need to ensure that it gets embedded as a resource. Use the `target_embed_metal_shader_libraries` function (from the MetalShaderSupport module) to list the shader targets to be included as resources.

```cmake
add_executable(MyApp MACOSX_BUNDLE)

target_embed_metal_shader_libraries(MyApp
    MyShaders
)
```

<details>
<summary><h3>Implementation Details</h3></summary>

The `target_embed_metal_shader_libraries` helper adds the shader library as a dependency of the target executable, and tells CMake to ensure each shader target's `.metallib` is included in the application bundle as a resource.

If you are using CMake 3.28 or newer with the Xcode generator, the shader targets can be referred to directly:

```cmake
set_target_properties(MyApp PROPERTIES
    XCODE_EMBED_RESOURCES MyShaders
)
```

Otherwise, a custom post-build step is used to copy the resulting `.metallib` into the Resources folder of the target app bundle.

```cmake
add_custom_command(TARGET MyApp POST_BUILD
    DEPENDS MyShaders
    COMMAND ${CMAKE_COMMAND} -E copy "$<TARGET_FILE:MyShaders>" "$<TARGET_BUNDLE_CONTENT_DIR:MyApp>/Resources/$<TARGET_FILE_NAME:MyShaders>"
    VERBATIM
)
```

</details>


Remaining Work
--------------

* Handling the SDK and min-version parameters
* Testing that this works with the Windows version of the Metal tools


Licence
-------

CMake files are distributed under the OSI-approved BSD 3-clause License. See [LICENCE.txt][1] for details.  
Copyright © 2024 Darryl Pogue and Contributors.

The example project is based on sample code from Apple, under its own licence. See [LICENSE.txt][2] in the example folder for details.


[1]: ./LICENCE.txt
[2]: ./example/LICENSE.txt
