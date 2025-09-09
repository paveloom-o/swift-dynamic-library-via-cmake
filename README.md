<!--
Copyright 2025 Pavel Sobolev

This file is part of the Swift Dynamic Library via CMake project,
located at either of the following mirrors:

    https://codeberg.org/paveloom-o/swift-dynamic-library-via-cmake
    https://github.com/paveloom-o/swift-dynamic-library-via-cmake
    https://gitlab.com/paveloom-g/other/swift-dynamic-library-via-cmake

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

SPDX-License-Identifier: Apache-2.0
-->

# Swift Dynamic Library via CMake

This repository provides an example of using CMake to build and distribute a dynamic library written in Swift on Linux systems.

Git mirrors:

- [Codeberg](https://codeberg.org/paveloom-o/swift-dynamic-library-via-cmake)
- [GitHub](https://github.com/paveloom-o/swift-dynamic-library-via-cmake)
- [GitLab](https://gitlab.com/paveloom-g/other/swift-dynamic-library-via-cmake)

## Instructions

There are two targets that are installed separately:

- The Library target that provides some code
- The Application target that makes use of that code, while loading the Library dynamically

To build both targets, run [`./scripts/rebuild_all.bash`](./scripts/rebuild_all.bash).

This is the expected result:

```console
$ tree -a prefix
prefix
├── application
│   └── usr
│       └── bin
│           └── Application
└── library
    └── usr
        ├── include
        │   └── Library-1
        │       ├── Library.swiftdoc
        │       └── Library.swiftinterface
        └── lib64
            ├── cmake
            │   └── Library-1
            │       ├── LibraryConfig.cmake
            │       ├── LibraryConfigVersion.cmake
            │       ├── LibraryTargets.cmake
            │       └── LibraryTargets-noconfig.cmake
            └── Library-1
                ├── libLibrary.so -> libLibrary.so.1
                ├── libLibrary.so.1 -> libLibrary.so.1.0.0
                └── libLibrary.so.1.0.0

12 directories, 10 files
```

Here's the list of dynamic libraries the built Application depends upon:

```console
$ objdump -p prefix/application/usr/bin/Application | grep NEEDED
  NEEDED               libLibrary.so.1
  NEEDED               libswiftSwiftOnoneSupport.so
  NEEDED               libswiftCore.so
  NEEDED               libswift_Concurrency.so
  NEEDED               libswift_StringProcessing.so
  NEEDED               libswift_RegexParser.so
  NEEDED               libc.so.6
```

The `libLibrary.so.1` entry is the Library.

To run the application with correct `LD_LIBRARY_PATH` set, run [`./scripts/run_application.bash`](./scripts/run_application.bash):

```console
$ ./scripts/run_application.bash
Hello there!
$ ./scripts/run_application.bash Pavel
Hello there, Pavel!
```

Experiment with changing the Library code and rebuilding the Library target via [`./scripts/rebuild_library.bash`](./scripts/rebuild_library.bash). This should make the Application reflect the changes made without rebuilding it, assuming the changes don't break [binary compatibility](https://github.com/swiftlang/swift/blob/main/docs/LibraryEvolution.rst#supported-evolution).

## Flags

Essential `swiftc` flags for preparing a dynamic library for consumption:

- `-emit-module-interface`: Output module interface file
- `-enable-library-evolution`: Build the module to allow binary-compatible library evolution

See also:

- [Swift Blog: Library Evolution](https://www.swift.org/blog/library-evolution/)

## Output files

Besides the dynamic library file (`.so`) and CMake package files (`.cmake`), other files are distributed with the library.

The `.swiftinterface` file is akin to a header file (`.h`) in C. It represents the module's public interface, with implementation code omitted. To avoid the cost of loading these files, the compiler keeps a cache of module abstract syntax trees it has seen, serialized in a binary format (`.swiftmodule`). You can see those in the CMake's build directories.

The `.swiftdoc` file is a binary file that contains serialized documentation information for Swift modules. This is where documentation strings can be pulled from by language servers (e.g., [SourceKit-LSP](https://github.com/swiftlang/sourcekit-lsp/)) to aid in writing code.

See also:

- [Swift Forums: Plan for module stability](https://forums.swift.org/t/plan-for-module-stability/14551)
- [Swift Forums: Update on Module Stability and Module Interface Files](https://forums.swift.org/t/update-on-module-stability-and-module-interface-files/23337)
