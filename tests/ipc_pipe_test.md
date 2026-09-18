# Windows pipe regression test

Run from a Visual Studio x64 developer command prompt at the repository root:

```bat
clang-cl /std:c++20 /EHsc /MT /O2 /DNDEBUG /DNOMINMAX /Iexternal/json/include /Iexternal/reshade tests/ipc_pipe_test.cpp /Febuild/ipc_pipe_test.exe /Fobuild/ipc_pipe_test.obj /link advapi32.lib
build\ipc_pipe_test.exe
```

The standalone test exercises real Win32 and LOCAL named pipes, bridge discovery preserving full names, reconnects, framed request/response, listener shutdown, synchronous failure reporting, security-descriptor diagnostics, and retry after startup failure. It includes the bridge translation unit with a renamed entry point so discovery tests execute the production implementation.

This is not an AppContainer integration test. For that, load the Release DevKit into an AppContainer game, verify the reported LOCAL endpoint and absence of transport errors in ReShade.log, and connect using the rebuilt Release bridge. Confirm repeated calls and reconnects. Capture any reported GetLastError value; do not infer an error code from a stopped overlay or assume a successful desktop test proves UWP behavior.
