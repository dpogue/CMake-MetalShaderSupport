cmake_minimum_required(VERSION 3.12)

set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH};${CMAKE_SOURCE_DIR}/cmake")

enable_language(Metal)
project(metaltest)

add_library(metaltest 
    shader.metal
)
