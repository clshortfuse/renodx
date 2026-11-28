#pragma once
#include <Windows.h>
#include <TlHelp32.h>
#include <detours.h>
#include <array>
// Collect handles before preparing hooks. Suspend/enlist only after Attach has
// allocated its trampolines; keep handles alive until commit/abort resumes them.
namespace hook_transaction {
struct Threads {
  std::array<HANDLE, 2048> handles{};
  size_t count = 0;
  bool active = false;
  void Close() { for (size_t i=0;i<count;++i) CloseHandle(handles[i]); count=0; }
  LONG Collect() {
    HANDLE snap = CreateToolhelp32Snapshot(TH32CS_SNAPTHREAD, 0);
    if (snap == INVALID_HANDLE_VALUE) return GetLastError();
    THREADENTRY32 entry{}; entry.dwSize=sizeof(entry);
    LONG result=NO_ERROR;
    if (!Thread32First(snap,&entry)) result=GetLastError();
    else do {
      if (entry.th32OwnerProcessID!=GetCurrentProcessId() || entry.th32ThreadID==GetCurrentThreadId()) continue;
      if(count==handles.size()) { result=ERROR_TOO_MANY_TCBS; break; }
      HANDLE h=OpenThread(THREAD_SUSPEND_RESUME|THREAD_GET_CONTEXT|THREAD_SET_CONTEXT|THREAD_QUERY_INFORMATION,FALSE,entry.th32ThreadID);
      if(!h) { result=GetLastError(); break; }
      handles[count++]=h;
    } while(Thread32Next(snap,&entry));
    if(result==NO_ERROR && GetLastError()!=ERROR_NO_MORE_FILES) result=GetLastError();
    CloseHandle(snap);
    if(result!=NO_ERROR) Close();
    return result;
  }
};
inline thread_local Threads threads;
inline LONG Begin() {
  if(threads.active) return ERROR_INVALID_OPERATION;
  LONG result=threads.Collect(); if(result!=NO_ERROR) return result;
  result=DetourTransactionBegin();
  if(result==NO_ERROR) threads.active=true; else threads.Close();
  return result;
}
inline LONG Abort() {
  if(!threads.active) return ERROR_INVALID_OPERATION;
  LONG result=DetourTransactionAbort(); threads.active=false; threads.Close(); return result;
}
inline LONG Commit() {
  if(!threads.active) return ERROR_INVALID_OPERATION;
  LONG result=NO_ERROR;
  for(size_t i=0;result==NO_ERROR && i<threads.count;++i) result=DetourUpdateThread(threads.handles[i]);
  if(result!=NO_ERROR) { Abort(); return result; }
  result=DetourTransactionCommit(); threads.active=false; threads.Close(); return result;
}
}
