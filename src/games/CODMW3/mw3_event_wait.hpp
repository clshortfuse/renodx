#pragma once
#include <Windows.h>
namespace mw3_event_wait {
inline DWORD Wait(HANDLE event,HANDLE timer,DWORD requested_ms) {
  HANDLE objects[2]={event,timer};
  // Retain real event priority. A late/cancelled timer cannot turn a finite
  // engine poll into an unbounded wait. Scheduling can still overshoot timeout.
  return ::WaitForMultipleObjects(2,objects,FALSE,requested_ms);
}
}
