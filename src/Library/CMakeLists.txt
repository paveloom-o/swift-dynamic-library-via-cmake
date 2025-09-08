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

set(TARGET_NAME Library)

add_library(${TARGET_NAME} SHARED
    Library.swift
)

set_target_properties(${TARGET_NAME} PROPERTIES
    VERSION ${PROJECT_VERSION}
    SOVERSION ${PROJECT_VERSION_MAJOR}
)

target_compile_options(${TARGET_NAME} PRIVATE
    -enable-library-evolution
    -emit-module-interface
    -emit-module-interface-path ${Swift_INTERFACE_DIRECTORY}/${TARGET_NAME}.swiftinterface
)

set(INSTALL_TARGETDIR ${TARGET_NAME}-${PROJECT_VERSION_MAJOR})
set(INSTALL_LIBDIR ${CMAKE_INSTALL_LIBDIR}/${INSTALL_TARGETDIR})
set(INSTALL_INCLUDEDIR ${CMAKE_INSTALL_INCLUDEDIR}/${INSTALL_TARGETDIR})
set(INSTALL_EXPORTDIR ${CMAKE_INSTALL_LIBDIR}/cmake/${INSTALL_TARGETDIR})

target_include_directories(${TARGET_NAME}
    INTERFACE
        $<INSTALL_INTERFACE:${INSTALL_INCLUDEDIR}>
)

install(TARGETS ${TARGET_NAME}
    EXPORT ${TARGET_NAME}
    LIBRARY DESTINATION ${INSTALL_LIBDIR}
)

install(DIRECTORY ${Swift_INTERFACE_DIRECTORY}/
    DESTINATION ${INSTALL_INCLUDEDIR}
)

install(EXPORT ${TARGET_NAME}
    FILE ${TARGET_NAME}Targets.cmake
    DESTINATION ${INSTALL_EXPORTDIR}
)

configure_package_config_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/cmake/${TARGET_NAME}Config.cmake.in
    ${CMAKE_CURRENT_BINARY_DIR}/cmake/${TARGET_NAME}Config.cmake
    INSTALL_DESTINATION ${INSTALL_EXPORTDIR}
    NO_SET_AND_CHECK_MACRO
    NO_CHECK_REQUIRED_COMPONENTS_MACRO
)

write_basic_package_version_file(
    ${CMAKE_CURRENT_BINARY_DIR}/cmake/${TARGET_NAME}ConfigVersion.cmake
    VERSION ${PROJECT_VERSION}
    COMPATIBILITY SameMajorVersion
)

install(FILES
    ${CMAKE_CURRENT_BINARY_DIR}/cmake/${TARGET_NAME}Config.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/cmake/${TARGET_NAME}ConfigVersion.cmake
    DESTINATION ${INSTALL_EXPORTDIR}
)
