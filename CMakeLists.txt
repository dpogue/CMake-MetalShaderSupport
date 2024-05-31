cmake_minimum_required(VERSION 3.12)

set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH};${CMAKE_SOURCE_DIR}/cmake")
include(CheckLanguage)

check_language(Metal)
if(CMAKE_Metal_COMPILER)
    enable_language(Metal)
endif()
project(metaltest)

add_library(metaltest MODULE
    shader.metal
)
