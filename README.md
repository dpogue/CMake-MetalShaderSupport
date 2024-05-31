:warning: INCOMPLETE! Metal Shader support for CMake
==============================

This project aims to allow compiling, linking, and embedding Apple Metal shader libraries in projects using CMake, without the need to write custom build steps or be restricted to only using the Xcode project generator.

Project Setup
-------------

1. Copy the files from the `cmake` folder of this repo into a top-level `cmake` folder in your project.

2. Add that `cmake` folder to the `CMAKE_MODULE_PATH` of your project:

    ```cmake
    # In the top-level CMakeLists.txt file for your project:
    set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH};${CMAKE_SOURCE_DIR}/cmake")
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

There are a few different ways to compose shader library targets, including some that allow sharing base definitions across multiple targets. It is recommended that your final shader libraries (the ones that should output `.metallib` files to be included as resources) use the `MODULE` library type.

> [!IMPORTANT]
> **Shaders must be in their own CMake target!**  
> You cannot mix them  with C++ or Objective-C code sources in a library or executable target.

### Object Files (.air)

You can compile shaders to a loose collection of `.air` bitcode files by defining an object library, and then include those shader objects as part of another Metal shader library.

```cmake
add_library(shader_base OBJECT
    shader1.metal
    shader2.metal
)
```

You can then reference those objects to be linked as part of another target:

```cmake
add_library(full_shader MODULE
    another_shader.metal
    $<TARGET_OBJECTS:shader_base>
)
```

> [!CAUTION]
> TODO: Test and prove that this actually works for linking them up in later targets


### Static Archives (.metal-ar)

You can also compile shaders to a static archive as a `.metal-ar` file that can be linked together with other archives and shaders into a Metal library.

```cmake
add_library(shader_base STATIC
    shader1.metal
    shader2.metal
)
```

You can then reference that archive as a link library for another target:

```cmake
add_library(full_shader MODULE
    another_shader.metal
)
target_link_libraries(full_shader
    PRIVATE
    shader_base
)
```

> [!CAUTION]
> TODO: Test and prove that this actually works for linking them up in later targets


### Metal Libraries (.metallib)

Your final shader library will need to be a `.metallib` file that can be included in your application as a resource. You should define these as `MODULE` libraries rather than `SHARED` libraries because they do not expose symbols that can be linked with other targets.

```cmake
add_library(full_shader MODULE
    shader1.metal
    shader2.metal
)
```


Embedding Shaders
-----------------

As a final step to make your shader library available to your application, you will need to ensure that it gets embedded as a resource.

1. First, you need to ensure that the shader library itself is built as a dependency of the application target.

    ```cmake
    add_executable(MyApp)
    add_dependencies(MyApp
        full_shader
    )
    ```

2. Then you'll need to include the shader libraries as resources:

    ```cmake
    set(MyApp_SHADER_RESOURCES
        $<TARGET_FILE:full_shader>
    )

    set_target_properties(MyApp PROPERTIES
        RESOURCES "${MyApp_SHADER_RESOURCES}"
    )
    ```

    If you are using CMake 3.28 or newer, you can refer to the shader targets directly:

    ```cmake
    set_target_properties(MyApp PROPERTIES
        XCODE_EMBED_RESOURCES full_shader
    )
    ```

> [!CAUTION]
> TODO: Test and prove that this actually works for linking them up in later targets
