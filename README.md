CMakeStarter
============
This attempts to be a good starting place for a
CMake built project that uses some commonly used
(at least stuff I use) third party packages.

Include directories are referenced from the root
of the project, no extra include directories are
referenced.  Package headers are edited as
necessary to fit.

GTest
------------
All required files are included.  Changed header
file #includes to use
third\_party/gtest/include/gtest/... instead
of gtest/...

See codelab/testing

Proto Buffers
-------------
Code not included, Install as directed:
https://code.google.com/p/protobuf/downloads/list

See codelab/protobuf
