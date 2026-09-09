#pragma once
#include <cstdint>
#include <cstddef>
namespace mw3_gpu_sample {
enum class Result { Ready, Pending, Invalid };
template<class Read> Result Resolve(size_t count, Read read, uint64_t* values) {
  for (size_t i=0; i<count; ++i) {
    const Result result=read(i,values[i]);
    if (result!=Result::Ready) return result;
    if (i && values[i]<values[i-1]) return Result::Invalid;
  }
  return Result::Ready;
}
inline bool Milliseconds(uint64_t start, uint64_t end, uint64_t frequency,
                         bool disjoint, double& ms) {
  if (disjoint || !frequency || end<start) return false;
  ms=static_cast<double>(end-start)*1000.0/static_cast<double>(frequency);
  return true;
}
}
