#!/usr/bin/env bash

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

set -e

script_path="$(realpath -s "$0")"
export root_dir="${script_path%/*/*}"

export build_dir="$root_dir/build"
export prefix_dix="$root_dir/prefix"

export build_application_dir="$build_dir/application"
export prefix_application_dir="$prefix_dix/application"

export build_library_dir="$build_dir/library"
export prefix_library_dir="$prefix_dix/library"

build() {
    local build_target_dir="$1"
    local prefix_target_dir="$2"
    local cmake_flag="$3"

    rm -rf "$build_target_dir" "$prefix_target_dir"

    cmake -G Ninja -S "$root_dir" -B "$build_target_dir" "$cmake_flag"
    cmake --build "$build_target_dir" --verbose
    cmake --install "$build_target_dir" --prefix "$prefix_target_dir/usr"
}

build_application() {
    build "$build_application_dir" "$prefix_application_dir" -DBUILD_APPLICATION=yes
}

build_library() {
    build "$build_library_dir" "$prefix_library_dir" -DBUILD_LIBRARY=yes
}
