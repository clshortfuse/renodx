#pragma once

/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#include <algorithm>
#include <cassert>
#include <cstddef>
#include <iterator>
#include <memory>
#include <span>
#include <type_traits>
#include <utility>
#include <vector>

#include "flagged_array.hpp"

// NOLINTBEGIN(readability-identifier-naming)
namespace renodx::utils {

// Small indexed storage: no heap allocation for the first BlockSize slots.
// Clearing changes membership only; overflow blocks and their values are retained.
template <typename T, typename Allocator, std::size_t BlockSize = 64u>
class FlaggedVector {
  static_assert(BlockSize != 0u);
  using Block = FlaggedArray<T, BlockSize>;
  using BlockAllocator = typename std::allocator_traits<Allocator>::template rebind_alloc<Block>;

 public:
  FlaggedVector() = default;
  explicit FlaggedVector(const Allocator& allocator) : overflow_(BlockAllocator{allocator}) {}
  FlaggedVector(const FlaggedVector&) = default;
  FlaggedVector& operator=(const FlaggedVector&) = default;
  FlaggedVector(FlaggedVector&& other) noexcept(std::is_nothrow_move_constructible_v<Block> && std::is_nothrow_move_constructible_v<std::vector<Block, BlockAllocator>>)
      : inline_(std::move(other.inline_)), overflow_(std::move(other.overflow_)), size_(other.size_) {
    other.clear();
  }
  FlaggedVector& operator=(FlaggedVector&& other) noexcept(std::is_nothrow_move_assignable_v<Block> && std::is_nothrow_move_assignable_v<std::vector<Block, BlockAllocator>>) {
    if (this == &other) return *this;
    overflow_ = std::move(other.overflow_);
    inline_ = std::move(other.inline_);
    size_ = other.size_;
    other.clear();
    return *this;
  }
  template <typename U>
  void set(std::size_t index, U&& value) {
    const auto block = index / BlockSize;
    if (block > overflow_.size()) {
      overflow_.resize(block);
    }
    getBlock(block).set(index % BlockSize, std::forward<U>(value));
    size_ = std::max(size_, index + 1u);
  }
  void setRange(std::size_t first, std::span<const T> values) {
    if (values.empty()) return;
    const auto end = first + values.size();
    const auto blocks = (end - 1u) / BlockSize;
    if (blocks > overflow_.size()) {
      overflow_.resize(blocks);
    }
    while (!values.empty()) {
      const auto take = std::min(values.size(), BlockSize - (first % BlockSize));
      getBlock(first / BlockSize).setRange(first % BlockSize, values.first(take));
      first += take;
      values = values.subspan(take);
    }
    size_ = std::max(size_, end);
  }
  bool has(std::size_t index) const {
    return index < size_ && getBlock(index / BlockSize).has(index % BlockSize);
  }
  T& get(std::size_t index) {
    assert(has(index));
    return getBlock(index / BlockSize).get(index % BlockSize);
  }
  const T& get(std::size_t index) const {
    assert(has(index));
    return getBlock(index / BlockSize).get(index % BlockSize);
  }
  void clear() {
    inline_.clear();
    for (auto& block : overflow_) block.clear();
    size_ = 0u;
  }
  void clear(std::size_t first, std::size_t count = 1u) {
    assert(first <= size_ && count <= size_ - first);
    while (count != 0u) {
      const auto take = std::min(count, BlockSize - (first % BlockSize));
      getBlock(first / BlockSize).clear(first % BlockSize, take);
      first += take;
      count -= take;
    }
  }
  void reset(std::size_t index) { clear(index); }
  std::size_t size() const { return size_; }
  bool empty() const { return size_ == 0u; }

  class IndexIterator {
   public:
    explicit IndexIterator(const FlaggedVector* owner) : owner_(owner), index_(owner->inline_.indexes().begin()) { skipEmptyBlocks(); }
    std::size_t operator*() const { return (block_ * BlockSize) + *index_; }
    IndexIterator& operator++() {
      ++index_;
      skipEmptyBlocks();
      return *this;
    }
    bool operator==([[maybe_unused]] std::default_sentinel_t sentinel) const { return index_ == std::default_sentinel; }

   private:
    void skipEmptyBlocks() {
      while (index_ == std::default_sentinel && (block_ + 1u) * BlockSize < owner_->size_) {
        index_ = owner_->getBlock(++block_).indexes().begin();
      }
    }
    const FlaggedVector* owner_;
    std::size_t block_ = 0u;
    decltype(std::declval<const Block&>().indexes().begin()) index_;
  };
  struct IndexRange {
    const FlaggedVector* owner;
    IndexIterator begin() const { return IndexIterator{owner}; }
    std::default_sentinel_t end() const { return {}; }
  };
  IndexRange indexes() const& { return {.owner = this}; }
  auto indexes() const&& = delete;
  auto entries() & { return flagged_array::Range<FlaggedVector, true>{this}; }
  auto entries() const& { return flagged_array::Range<const FlaggedVector, true>{this}; }
  auto values() & { return flagged_array::Range<FlaggedVector, false>{this}; }
  auto values() const& { return flagged_array::Range<const FlaggedVector, false>{this}; }
  auto entries() && = delete;
  auto entries() const&& = delete;
  auto values() && = delete;
  auto values() const&& = delete;
  bool isEmpty() const { return indexes().begin() == std::default_sentinel; }

  // Dense read-only projection for indexed queries and copied snapshots.
  // An absent slot reads as T{} without modifying its retained value.
  T operator[](std::size_t index) const {
    assert(index < size_);
    return has(index) ? get(index) : T{};
  }
  class Iterator {
   public:
    using value_type = T;
    using reference = T;
    using pointer = void;
    using difference_type = std::ptrdiff_t;
    using iterator_category = std::input_iterator_tag;
    Iterator() = default;
    Iterator(const FlaggedVector* owner, std::size_t index) : owner_(owner), index_(index) {}
    T operator*() const { return (*owner_)[index_]; }
    Iterator& operator++() {
      ++index_;
      return *this;
    }
    Iterator operator++(int) {
      auto previous = *this;
      ++*this;
      return previous;
    }
    bool operator==(const Iterator&) const = default;

   private:
    const FlaggedVector* owner_ = nullptr;
    std::size_t index_ = 0u;
  };
  Iterator begin() const& { return {this, 0u}; }
  Iterator end() const& { return {this, size_}; }
  Iterator begin() const&& = delete;
  Iterator end() const&& = delete;
  template <typename InputIterator>
  void assign(InputIterator first, InputIterator last) {
    clear();
    for (; first != last; ++first) set(size_, *first);
  }

 private:
  Block& getBlock(std::size_t index) { return index == 0u ? inline_ : overflow_[index - 1u]; }
  const Block& getBlock(std::size_t index) const { return index == 0u ? inline_ : overflow_[index - 1u]; }
  Block inline_;
  std::vector<Block, BlockAllocator> overflow_;
  std::size_t size_ = 0u;
};

}  // namespace renodx::utils
// NOLINTEND(readability-identifier-naming)