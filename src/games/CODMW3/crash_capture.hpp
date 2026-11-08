#pragma once
#include <Windows.h>
#include <DbgHelp.h>
#include <cstdio>
#include <cstring>

// Diagnostic-only, one stack-overflow capture per process. No draw/API detours.
// The recorder is process-lifetime and its containing DLL is pinned. Never wait
// for the worker or load DbgHelp from DllMain. In-process dumps are best-effort:
// a loader/heap deadlock can still prevent a dump; the handler wait is bounded.
namespace mw3_crash_capture {
inline HANDLE requested = nullptr, finished = nullptr;
inline volatile LONG claimed = 0, ready = 0;
inline EXCEPTION_RECORD record{};
inline CONTEXT context{};
inline EXCEPTION_POINTERS pointers{&record, &context};
inline DWORD fault_thread = 0;
inline wchar_t directory[MAX_PATH]{};

inline void ReserveStack() {
  const DWORD error = GetLastError();
  ULONG bytes = 32 * 1024;
  SetThreadStackGuarantee(&bytes);
  SetLastError(error);
}

inline LONG CALLBACK Capture(EXCEPTION_POINTERS* exception) {
  if (exception->ExceptionRecord->ExceptionCode != EXCEPTION_STACK_OVERFLOW ||
      InterlockedCompareExchange(&claimed, 1, 0) != 0)
    return EXCEPTION_CONTINUE_SEARCH;
  // No allocation, logging, formatting, stack walking or DbgHelp on this stack.
  memcpy(&record, exception->ExceptionRecord, sizeof(record));
  record.ExceptionRecord = nullptr;
  memcpy(&context, exception->ContextRecord, sizeof(context));
  fault_thread = GetCurrentThreadId();
  if (SetEvent(requested)) WaitForSingleObject(finished, 8000);
  return EXCEPTION_CONTINUE_SEARCH;
}

inline DWORD WINAPI Worker(void*) {
  wchar_t path[MAX_PATH]{};
  const DWORD length = GetEnvironmentVariableW(L"LOCALAPPDATA", path, MAX_PATH);
  if (!length || length > MAX_PATH - 90) return 1;
  swprintf_s(directory, L"%s\\RenoDX", path);
  if (!CreateDirectoryW(directory, nullptr) && GetLastError() != ERROR_ALREADY_EXISTS) return 2;
  swprintf_s(directory, L"%s\\RenoDX\\MW3-crashes", path);
  if (!CreateDirectoryW(directory, nullptr) && GetLastError() != ERROR_ALREADY_EXISTS) return 3;
  const UINT system_length = GetSystemDirectoryW(path, MAX_PATH);
  if (!system_length || system_length > MAX_PATH - 14) return 4;
  wcscat_s(path, L"\\dbghelp.dll");
  const HMODULE dbghelp = LoadLibraryW(path);
  if (!dbghelp) return 5;
  const auto dump = reinterpret_cast<decltype(&MiniDumpWriteDump)>(
      GetProcAddress(dbghelp, "MiniDumpWriteDump"));
  if (!dump) return 6;
  if (!AddVectoredExceptionHandler(1, Capture)) return 7;
  InterlockedExchange(&ready, 1);
  if (WaitForSingleObject(requested, INFINITE) != WAIT_OBJECT_0) return 8;

  SYSTEMTIME time{};
  GetLocalTime(&time);
  wchar_t stem[MAX_PATH]{};
  swprintf_s(stem, L"%s\\MW3-%04u%02u%02u-%02u%02u%02u-%lu",
             directory, time.wYear, time.wMonth, time.wDay,
             time.wHour, time.wMinute, time.wSecond, GetCurrentProcessId());
  swprintf_s(path, L"%s.dmp", stem);
  HANDLE file = CreateFileW(path, GENERIC_WRITE, FILE_SHARE_READ, nullptr,
                            CREATE_NEW, FILE_ATTRIBUTE_NORMAL, nullptr);
  BOOL success = FALSE;
  DWORD error = GetLastError();
  if (file != INVALID_HANDLE_VALUE) {
    MINIDUMP_EXCEPTION_INFORMATION info{fault_thread, &pointers, FALSE};
    success = dump(GetCurrentProcess(), GetCurrentProcessId(), file,
                  static_cast<MINIDUMP_TYPE>(MiniDumpNormal | MiniDumpWithThreadInfo |
                                            MiniDumpWithUnloadedModules),
                  &info, nullptr, nullptr);
    error = success ? ERROR_SUCCESS : GetLastError();
    CloseHandle(file);
  }
  swprintf_s(path, L"%s.txt", stem);
  file = CreateFileW(path, GENERIC_WRITE, FILE_SHARE_READ, nullptr,
                    CREATE_NEW, FILE_ATTRIBUTE_NORMAL, nullptr);
  if (file != INVALID_HANDLE_VALUE) {
    char text[512]{};
    const int size = sprintf_s(text,
        "MW3 automatic stack-overflow capture v1\r\n"
        "Exception: 0x%08lX\r\nThread: %lu\r\nAddress: %p\r\n"
        "Dump saved: %s\r\nDump error: %lu\r\n"
        "First-chance capture; normal exception handling continues.\r\n",
        record.ExceptionCode, fault_thread, record.ExceptionAddress,
        success ? "yes" : "no", error);
    DWORD written = 0;
    if (size > 0) WriteFile(file, text, static_cast<DWORD>(size), &written, nullptr);
    CloseHandle(file);
  }
  SetEvent(finished);
  return 0;
}

inline bool Start() {
  ReserveStack();
  HMODULE pinned = nullptr;
  if (!GetModuleHandleExW(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS |
                         GET_MODULE_HANDLE_EX_FLAG_PIN,
                         reinterpret_cast<LPCWSTR>(&Worker), &pinned)) return false;
  requested = CreateEventW(nullptr, FALSE, FALSE, nullptr);
  finished = CreateEventW(nullptr, TRUE, FALSE, nullptr);
  if (!requested || !finished) {
    if (requested) CloseHandle(requested);
    if (finished) CloseHandle(finished);
    requested = finished = nullptr;
    return false;
  }
  HANDLE thread = CreateThread(nullptr, 0, Worker, nullptr, 0, nullptr);
  if (!thread) {
    CloseHandle(requested); CloseHandle(finished);
    requested = finished = nullptr;
    return false;
  }
  CloseHandle(thread);
  return true;
}
}  // namespace mw3_crash_capture
