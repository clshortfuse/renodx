#pragma once
#include <array>
#include <cmath>
#include <cstdint>
#include <cstring>
namespace balanced_filter {
struct Tap {float x,y,z,w;};
struct Entry {uint64_t material;int32_t taps;Tap tap[8];uint32_t padding;};
static_assert(sizeof(Entry)==0x90);
struct List {uint32_t count,padding;Entry entries[32];uint64_t source;uint32_t destination,flags;};
static_assert(sizeof(List)==0x1218);
// Native paired-sample Gaussian material: each offset samples +/- UV.
inline int Axis(const Entry& e,uint64_t material){
 if(!material || e.material!=material || e.taps!=8)return -1;
 bool x=false,y=false;double sum=0;
 for(const auto& t:e.tap){
  if(!std::isfinite(t.x)||!std::isfinite(t.y)||!std::isfinite(t.z)||!std::isfinite(t.w)||t.z!=0||t.w<0||t.w>0.5f||std::abs(t.x)>0.05f||std::abs(t.y)>0.05f)return -1;
  x|=t.x!=0;y|=t.y!=0;sum+=2.0*t.w;
 }
 if(std::abs(sum-1.0)>0.002 || x==y)return -1;
 return x?0:1;
}
inline bool Same(const Entry& a,const Entry& b){return std::memcmp(&a,&b,0x8c)==0;}
inline void Widen(Entry& e){for(auto& t:e.tap){t.x*=1.4142135623730951f;t.y*=1.4142135623730951f;}}
// Two repetitions of the same separable Gaussian have twice the variance.
// Widening one repetition by sqrt(2) retains that variance. Discrete samples,
// boundaries and HDR sanitization need in-game visual verification.
inline unsigned Compact(const List& in,List& out,uint64_t material){
 if(in.count<16 || in.count>32 || (in.destination!=8 && in.destination!=9))return 0;
 out=in;unsigned dst=0,removed=0;
 out.entries[dst++]=in.entries[0];
 for(unsigned i=1;i<in.count-1;){
  if(i+3<in.count-1 && Same(in.entries[i],in.entries[i+2]) && Same(in.entries[i+1],in.entries[i+3])){
   int a=Axis(in.entries[i],material),b=Axis(in.entries[i+1],material);
   if(a>=0 && b>=0 && a!=b){
    out.entries[dst]=in.entries[i];Widen(out.entries[dst++]);
    out.entries[dst]=in.entries[i+1];Widen(out.entries[dst++]);i+=4;removed+=2;continue;
   }
  }
  out.entries[dst++]=in.entries[i++];
 }
 out.entries[dst++]=in.entries[in.count-1];out.count=dst;return removed;
}
}
