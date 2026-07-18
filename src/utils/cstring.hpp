/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <cstdlib>
#include <cstring>
#include <new>

namespace renodx::utils {

static char* CloneCString(const char* s) {
  if (s == nullptr) {
    return nullptr;
  }

  const size_t len = std::strlen(s) + 1;

  auto* copy = static_cast<char*>(std::malloc(len));
  if (copy == nullptr) {
    throw std::bad_alloc{};
  }

  std::memcpy(copy, s, len);
  return copy;
}

}  // namespace renodx::utils