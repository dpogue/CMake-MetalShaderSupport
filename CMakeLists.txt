# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file LICENCE.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.12)

set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH};${CMAKE_SOURCE_DIR}/cmake")
include(CheckLanguage)

project(MetalTest)

check_language(Metal)
if(CMAKE_Metal_COMPILER)
    enable_language(Metal)
endif()

add_subdirectory(example)
