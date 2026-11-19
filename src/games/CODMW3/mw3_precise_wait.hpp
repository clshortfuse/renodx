#pragma once
#include <Windows.h>
#include <algorithm>
#include <cstdint>
namespace mw3_precise_wait {
inline uint64_t Now(){LARGE_INTEGER q{};QueryPerformanceCounter(&q);return static_cast<uint64_t>(q.QuadPart);}
inline double Headroom(double error){return std::clamp(error+90.0,200.0,600.0);}
inline double UpdateError(double previous,double observed){return std::clamp(std::max(previous*0.92,observed),0.0,510.0);}
// Keep scheduling yields out of the final sub-millisecond deadline window.
// Longer waits use the existing high-resolution timer; late frames never wait.
inline void Until(double deadline,uint64_t frequency,HANDLE timer,double& wake_error){
 if(!frequency)return;
 const double ticks_per_us=static_cast<double>(frequency)/1000000.0;
 for(;;){
  const auto now=Now();const double remaining=(deadline-static_cast<double>(now))/ticks_per_us;
  if(remaining<=0.0)return;
  const double headroom=Headroom(wake_error);
  if(timer && remaining>headroom+100.0){
   const double wait_us=remaining-headroom;LARGE_INTEGER due{};
   due.QuadPart=-static_cast<LONGLONG>(wait_us*10.0);
   const auto before=Now();
   if(SetWaitableTimer(timer,&due,0,nullptr,nullptr,FALSE) && WaitForSingleObject(timer,INFINITE)==WAIT_OBJECT_0){
    const double error=std::max(0.0,static_cast<double>(Now()-before)/ticks_per_us-wait_us);
    wake_error=UpdateError(wake_error,error);continue;
   }
   timer=nullptr; // Avoid repeated failing timer calls during this deadline.
  }
  if(!timer && remaining>1000.0){SwitchToThread();continue;}
  YieldProcessor();
 }
}
}
