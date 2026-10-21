#pragma once

/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#include <array>
#include <cassert>
#include <cstddef>
#include <cstring>
#include <span>
#include <type_traits>
#include <utility>

#include "flagged_bits.hpp"

// NOLINTBEGIN(readability-identifier-naming)
namespace renodx::utils {

template <typename T, std::size_t Count>
class FlaggedArray {
 public:
  template <typename U>
  void set(std::size_t index, U&& value) {
    assert(index < Count);
    storage_[index] = std::forward<U>(value);
    flags_.set(index);
  }
  void setRange(std::size_t first, std::span<const T> values) {
    static_assert(std::is_trivially_copyable_v<T>);
    assert(first <= Count && values.size() <= Count - first);
    if (values.empty()) return;
    std::memmove(storage_.data() + first, values.data(), values.size_bytes());
    flags_.setRange(first, values.size());
  }
  template <typename Callback>
  void forEachRange(Callback&& callback) const {
    flags_.forEachRange([&](std::size_t first, std::size_t count) {
      callback(first, std::span<const T>{storage_.data() + first, count});
    });
  }
  bool has(std::size_t index) const { return index < Count && flags_[index]; }
  T& get(std::size_t index) {
    assert(has(index));
    return storage_[index];
  }
  const T& get(std::size_t index) const {
    assert(has(index));
    return storage_[index];
  }
  void reset(std::size_t index) { flags_.reset(index); }
  void clear() { flags_.reset(); }
  void clear(std::size_t first, std::size_t count = 1u) { flags_.reset(first, count); }
  bool isEmpty() const { return flags_.none(); }
  bool isComplete() const { return flags_.all(); }
  const FlaggedBits<Count>& flags() const { return flags_; }
  auto indexes() const& { return flags_.indexes(); }
  auto indexes() const&& = delete;
  auto values() & { return flagged_array::Range<FlaggedArray, false>{this}; }
  auto values() const& { return flagged_array::Range<const FlaggedArray, false>{this}; }
  auto entries() & { return flagged_array::Range<FlaggedArray, true>{this}; }
  auto entries() const& { return flagged_array::Range<const FlaggedArray, true>{this}; }
  auto values() && = delete;
  auto values() const&& = delete;
  auto entries() && = delete;
  auto entries() const&& = delete;

 private:
  std::array<T, Count> storage_{};
  FlaggedBits<Count> flags_{};
};

}  // namespace renodx::utils
// NOLINTEND(readability-identifier-naming)