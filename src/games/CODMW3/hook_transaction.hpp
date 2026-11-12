#pragma once
#include <Windows.h>
#include <TlHelp32.h>
#include <detours.h>
#include <array>
#include <cstdint>
// Suspend/enlist only after Attach has allocated its trampolines; keep handles
// alive until commit/abort resumes them. Refuse to relocate a live prologue.
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
// One transaction per add-on. Do not block a render thread behind an installer,
// and do not create a large dynamically initialized TLS object inside a hook.
inline Threads threads;
inline volatile LONG owner = 0;
inline std::array<uintptr_t, 32> targets{};
inline size_t target_count = 0;
inline LONG Begin() {
  if(InterlockedCompareExchange(&owner, static_cast<LONG>(GetCurrentThreadId()), 0) != 0)
    return ERROR_BUSY;
  LONG result=DetourTransactionBegin();
  if(result==NO_ERROR) { threads.active=true; target_count=0; }
  else InterlockedExchange(&owner, 0);
  return result;
}
inline LONG Attach(PVOID* original, PVOID replacement) {
  if(InterlockedCompareExchange(&owner, 0, 0) != static_cast<LONG>(GetCurrentThreadId()) || !threads.active)
    return ERROR_INVALID_OPERATION;
  if(!original || !*original || !replacement || *original == replacement || target_count==targets.size())
    return ERROR_INVALID_PARAMETER;
  auto* target = DetourCodeFromPointer(*original, nullptr);
  if(!target || target == DetourCodeFromPointer(replacement, nullptr)) return ERROR_INVALID_PARAMETER;
  for(size_t i=0;i<target_count;++i) if(targets[i]==reinterpret_cast<uintptr_t>(target)) return ERROR_INVALID_PARAMETER;
  const LONG result=DetourAttach(original, replacement);
  if(result==NO_ERROR) targets[target_count++]=reinterpret_cast<uintptr_t>(target);
  return result;
}
inline LONG Abort() {
  if(InterlockedCompareExchange(&owner, 0, 0) != static_cast<LONG>(GetCurrentThreadId()) || !threads.active)
    return ERROR_INVALID_OPERATION;
  LONG result=DetourTransactionAbort(); threads.active=false; threads.Close();
  InterlockedExchange(&owner, 0); return result;
}
inline LONG Commit() {
  if(InterlockedCompareExchange(&owner, 0, 0) != static_cast<LONG>(GetCurrentThreadId()) || !threads.active)
    return ERROR_INVALID_OPERATION;
  // Take a fresh snapshot after trampoline allocation, immediately before
  // enlistment. Any failure aborts the entire transaction without patching.
  LONG result=threads.Collect();
  for(size_t i=0;result==NO_ERROR && i<threads.count;++i) result=DetourUpdateThread(threads.handles[i]);
  // Avoid resuming a thread at a translated instruction inside a trampoline.
  // 64 bytes conservatively covers the x64 entry patch and nearby prologue.
  for(size_t i=0;result==NO_ERROR && i<threads.count;++i) {
    CONTEXT context{}; context.ContextFlags=CONTEXT_CONTROL;
    if(!GetThreadContext(threads.handles[i], &context)) { result=GetLastError(); break; }
    for(size_t j=0;j<target_count;++j)
      if(context.Rip>=targets[j] && context.Rip-targets[j]<64) { result=ERROR_BUSY; break; }
  }
  if(result!=NO_ERROR) { Abort(); return result; }
  result=DetourTransactionCommit(); threads.active=false; threads.Close();
  InterlockedExchange(&owner, 0); return result;
}
}
