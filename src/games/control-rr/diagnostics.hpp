/*
 * Copyright (C) 2026 speedlemur
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <windows.h>
#include <atomic>
#include <cstdint>
#include <cstdio>
#include <cstring>

// Persistent flight recorder for intermittent crashes. Fixed-size writes avoid
// render-thread file flushing and retain the last 32768 operations after exit.
namespace control_diag {
#if defined(CONTROL_RR_DEV) || defined(CONTROL_RR_DIAGNOSTICS)
struct Record {
  LONG64 sequence;
  ULONGLONG milliseconds;
  DWORD thread;
  DWORD reserved;
  uint64_t first;
  uint64_t second;
  char operation[88];
};
static_assert(sizeof(Record) == 128);
constexpr size_t kCount = 32768;
struct Journal {
  LONG64 next;
  char header[120];
  Record records[kCount];
};
inline Journal* journal = nullptr;
inline HANDLE file = INVALID_HANDLE_VALUE;
inline HANDLE mapping = nullptr;

inline void Mark(const char* operation, uint64_t first = 0, uint64_t second = 0) {
  if (journal == nullptr) return;
  const LONG64 sequence = InterlockedIncrement64(&journal->next);
  auto& record = journal->records[(sequence - 1) % kCount];
  InterlockedExchange64(&record.sequence, 0);
  record.milliseconds = GetTickCount64();
  record.thread = GetCurrentThreadId();
  record.first = first;
  record.second = second;
  strncpy_s(record.operation, operation, _TRUNCATE);
  InterlockedExchange64(&record.sequence, sequence);
}

struct Scope {
  const char* operation;
  explicit Scope(const char* name) : operation(name) { Mark(name, 1); }
  ~Scope() { Mark(operation, 0); }
};

inline LONG CALLBACK OnException(EXCEPTION_POINTERS* exception) {
  const DWORD code = exception->ExceptionRecord->ExceptionCode;
  if (code == EXCEPTION_ACCESS_VIOLATION || code == EXCEPTION_ILLEGAL_INSTRUCTION
      || code == EXCEPTION_IN_PAGE_ERROR || code == EXCEPTION_STACK_OVERFLOW
      || code == 0xC0000409u) {
    // First-chance evidence, not a claim that the exception was fatal.
    Mark("exception.first_chance", code,
         reinterpret_cast<uint64_t>(exception->ExceptionRecord->ExceptionAddress));
    if (exception->ExceptionRecord->NumberParameters >= 2) {
      Mark("exception.access", exception->ExceptionRecord->ExceptionInformation[0],
           exception->ExceptionRecord->ExceptionInformation[1]);
    }
    MEMORY_BASIC_INFORMATION memory = {};
    if (VirtualQuery(exception->ExceptionRecord->ExceptionAddress, &memory, sizeof(memory))) {
      char module[MAX_PATH] = {};
      GetModuleFileNameA(static_cast<HMODULE>(memory.AllocationBase), module, MAX_PATH);
      const char* name = strrchr(module, '\\');
      Mark(name != nullptr ? name + 1 : module, reinterpret_cast<uint64_t>(memory.AllocationBase),
           reinterpret_cast<uint64_t>(exception->ExceptionRecord->ExceptionAddress)
               - reinterpret_cast<uint64_t>(memory.AllocationBase));
    }
    FlushViewOfFile(journal, 0);
  }
  return EXCEPTION_CONTINUE_SEARCH;
}

inline void Init(HMODULE module) {
  wchar_t path[MAX_PATH] = {};
  GetModuleFileNameW(nullptr, path, MAX_PATH);
  const auto* executable = wcsrchr(path, L'\\');
  if (executable == nullptr || _wcsicmp(executable + 1, L"Control_DX12.exe") != 0) return;
  GetModuleFileNameW(module, path, MAX_PATH);
  auto* name = wcsrchr(path, L'\\');
  if (name == nullptr) return;
  SYSTEMTIME time;
  GetLocalTime(&time);
  swprintf_s(name + 1, MAX_PATH - (name + 1 - path),
             L"control-rr-trace-%04u%02u%02u-%02u%02u%02u-%lu.bin",
             time.wYear, time.wMonth, time.wDay, time.wHour, time.wMinute,
             time.wSecond, GetCurrentProcessId());
  file = CreateFileW(path, GENERIC_READ | GENERIC_WRITE, FILE_SHARE_READ,
                     nullptr, CREATE_NEW, FILE_ATTRIBUTE_NORMAL, nullptr);
  if (file == INVALID_HANDLE_VALUE) {
    reshade::log::message(reshade::log::level::error, "control-rr: flight recorder file creation FAILED");
    return;
  }
  mapping = CreateFileMappingW(file, nullptr, PAGE_READWRITE, 0, sizeof(Journal), nullptr);
  if (mapping != nullptr) journal = static_cast<Journal*>(MapViewOfFile(mapping, FILE_MAP_WRITE, 0, 0, sizeof(Journal)));
  if (journal == nullptr) {
    reshade::log::message(reshade::log::level::error, "control-rr: flight recorder mapping FAILED");
    return;
  }
  strcpy_s(journal->header, "Control RR trace v1; record=128; entry first=1 exit first=0; " __DATE__ " " __TIME__);
  Mark("process.attach", GetCurrentProcessId(), reinterpret_cast<uint64_t>(module));
  AddVectoredExceptionHandler(1, OnException);
  reshade::log::message(reshade::log::level::info,
      "control-rr: diagnostic build " __DATE__ " " __TIME__ "; persistent control-rr-trace-*.bin enabled");
}
#else
inline void Mark(const char*, uint64_t = 0, uint64_t = 0) {}
struct Scope {
  explicit Scope(const char*) {}
};
inline void Init(HMODULE) {}
#endif
}  // namespace control_diag
