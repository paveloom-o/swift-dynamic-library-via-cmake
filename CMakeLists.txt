# Copyright 2025 Pavel Sobolev
#
# This file is part of the Swift Dynamic Library via CMake project,
# located at either of the following mirrors:
#
#     https://codeberg.org/paveloom-o/swift-dynamic-library-via-cmake
#     https://github.com/paveloom-o/swift-dynamic-library-via-cmake
#     https://gitlab.com/paveloom-g/other/swift-dynamic-library-via-cmake
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# SPDX-License-Identifier: Apache-2.0

cmake_minimum_required(VERSION 4.0)

# C is added because of the usage of GNUInstallDirs below
#
# See https://gitlab.kitware.com/cmake/cmake/-/issues/26649
project(Example LANGUAGES Swift C VERSION 1.0.0)

set(CMAKE_Swift_LANGUAGE_VERSION 6)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

include(CMakePackageConfigHelpers)
include(GNUInstallDirs)

option(BUILD_APPLICATION "Build the Application target")
option(BUILD_LIBRARY "Build the Library target")

add_subdirectory(src)
