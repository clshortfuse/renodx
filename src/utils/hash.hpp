/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <cstdio>
#include <utility>

namespace renodx::utils::hash {

struct HashPair {
  /// https://chromium.googlesource.com/chromium/+/02456cb7f063e2d2f6ee3c7cbacbfc239b171ac3/cc/hash_pair.h
  template <class T1, class T2>
  size_t operator()(const std::pair<T1, T2> value) const {
    const uint32_t short_random1 = 842304669U;
    const uint32_t short_random2 = 619063811U;
    const uint32_t short_random3 = 937041849U;
    const uint32_t short_random4 = 3309708029U;

    const auto value1 = static_cast<uint64_t>(value.first);
    const auto value2 = static_cast<uint64_t>(value.second);
    const auto value1a = static_cast<uint32_t>(value1 & 0xffffffff);
    const auto value1b = static_cast<uint32_t>((value1 >> 32) & 0xffffffff);
    const auto value2a = static_cast<uint32_t>(value2 & 0xffffffff);
    const auto value2b = static_cast<uint32_t>((value2 >> 32) & 0xffffffff);

    const uint64_t product1 = static_cast<uint64_t>(value1a) * short_random1;
    const uint64_t product2 = static_cast<uint64_t>(value1b) * short_random2;
    const uint64_t product3 = static_cast<uint64_t>(value2a) * short_random3;
    const uint64_t product4 = static_cast<uint64_t>(value2b) * short_random4;

    uint64_t hash64 = product1 + product2 + product3 + product4;

    if (sizeof(std::size_t) >= sizeof(uint64_t)) {
      return static_cast<std::size_t>(hash64);
    }

    const uint64_t odd_random = 1578233944LL << 32 | 194370989LL;
    const uint32_t shift_random = 20591U << 16;

    hash64 = hash64 * odd_random + shift_random;
    const auto high_bits = static_cast<std::size_t>(hash64 >> (sizeof(uint64_t) - sizeof(std::size_t)));
    return high_bits;
  }
};
}  // namespace renodx::utils::hash