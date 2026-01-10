#ifndef SRC_SHADERS_MATH_SELECT_HLSL_
#define SRC_SHADERS_MATH_SELECT_HLSL_

#include "./cross.hlsl"

START_NAMESPACE(renodx)
START_NAMESPACE(math)

#if __SHADER_TARGET_MAJOR >= 6 || defined(VULKAN)
#define SELECT_FUNCTION_GENERATOR_SCALAR(TYPE)                   \
  TYPE Select(bool condition, TYPE trueValue, TYPE falseValue) { \
    return select(condition, trueValue, falseValue);             \
  }

#define SELECT_FUNCTION_GENERATOR_VECTOR(TYPE, SIZE)                                     \
  TYPE##SIZE Select(bool condition, TYPE##SIZE trueValue, TYPE##SIZE falseValue) {       \
    return select(condition, trueValue, falseValue);                                     \
  }                                                                                      \
  TYPE##SIZE Select(bool condition, TYPE##SIZE trueValue, TYPE falseValue) {             \
    return select(condition, trueValue, falseValue);                                     \
  }                                                                                      \
  TYPE##SIZE Select(bool condition, TYPE trueValue, TYPE##SIZE falseValue) {             \
    return select(condition, trueValue, falseValue);                                     \
  }                                                                                      \
  TYPE##SIZE Select(bool##SIZE condition, TYPE##SIZE trueValue, TYPE##SIZE falseValue) { \
    return select(condition, trueValue, falseValue);                                     \
  }

#else
// Backport of select(t,a,b)
#define SELECT_FUNCTION_GENERATOR_SCALAR(TYPE)                   \
  TYPE Select(bool condition, TYPE trueValue, TYPE falseValue) { \
    [flatten]                                                    \
    if (condition) {                                             \
      return trueValue;                                          \
    } else {                                                     \
      return falseValue;                                         \
    }                                                            \
  }

#define SELECT_FUNCTION_GENERATOR_VECTOR(TYPE, SIZE)                                     \
  TYPE##SIZE Select(bool condition, TYPE##SIZE trueValue, TYPE##SIZE falseValue) {       \
    [flatten]                                                                            \
    if (condition) {                                                                     \
      return trueValue;                                                                  \
    } else {                                                                             \
      return falseValue;                                                                 \
    }                                                                                    \
  }                                                                                      \
  TYPE##SIZE Select(bool condition, TYPE##SIZE trueValue, TYPE falseValue) {             \
    [flatten]                                                                            \
    if (condition) {                                                                     \
      return trueValue;                                                                  \
    } else {                                                                             \
      return falseValue;                                                                 \
    }                                                                                    \
  }                                                                                      \
  TYPE##SIZE Select(bool condition, TYPE trueValue, TYPE##SIZE falseValue) {             \
    [flatten]                                                                            \
    if (condition) {                                                                     \
      return trueValue;                                                                  \
    } else {                                                                             \
      return falseValue;                                                                 \
    }                                                                                    \
  }                                                                                      \
  TYPE##SIZE Select(bool##SIZE condition, TYPE##SIZE trueValue, TYPE##SIZE falseValue) { \
    TYPE##SIZE result;                                                                   \
    [unroll]                                                                             \
    for (int i = 0; i < SIZE; ++i) {                                                     \
      [flatten]                                                                          \
      if (condition[i]) {                                                                \
        result[i] = trueValue[i];                                                        \
      } else {                                                                           \
        result[i] = falseValue[i];                                                       \
      }                                                                                  \
    }                                                                                    \
    return result;                                                                       \
  }

#endif

#define SELECT_FUNCTION_GENERATOR(TYPE)     \
  SELECT_FUNCTION_GENERATOR_SCALAR(TYPE)    \
  SELECT_FUNCTION_GENERATOR_VECTOR(TYPE, 2) \
  SELECT_FUNCTION_GENERATOR_VECTOR(TYPE, 3) \
  SELECT_FUNCTION_GENERATOR_VECTOR(TYPE, 4)

SELECT_FUNCTION_GENERATOR(float)
SELECT_FUNCTION_GENERATOR(uint)
SELECT_FUNCTION_GENERATOR(int)
SELECT_FUNCTION_GENERATOR(half)

#undef SELECT_FUNCTION_GENERATOR
#undef SELECT_FUNCTION_GENERATOR_SCALAR
#undef SELECT_FUNCTION_GENERATOR_VECTOR

END_NAMESPACE(math)
END_NAMESPACE(renodx)
#endif  // SRC_SHADERS_MATH_SELECT_HLSL_