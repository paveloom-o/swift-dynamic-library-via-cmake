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

set -ex

script_path="$(realpath -s "$0")"
root_dir="${script_path%/*/*}"

build_dir="$root_dir/build"
prefix_dix="$root_dir/prefix"

rm -rf "$build_dir" "$prefix_dix"

cmake -G Ninja -S "$root_dir" -B "$build_dir" -DBUILD_LIBRARY=yes
cmake --build "$build_dir" --verbose
cmake --install "$build_dir" --prefix "$prefix_dix/library/usr"

rm -rf "$build_dir"

cmake -G Ninja -S "$root_dir" -B "$build_dir" -DBUILD_APPLICATION=yes
cmake --build "$build_dir" --verbose
cmake --install "$build_dir" --prefix "$prefix_dix/application/usr"
