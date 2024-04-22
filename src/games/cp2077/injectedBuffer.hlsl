#ifndef SRC_CP2077_INJECTEDBUFFER_HLSL
#define SRC_CP2077_INJECTEDBUFFER_HLSL

#include "./cp2077.h"

cbuffer injectedBuffer : register(b14, space0) {
  ShaderInjectData injectedData : packoffset(c0);
}

#endif