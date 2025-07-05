/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <cstdint>

#include <gtl/phmap.hpp>

#include <include/reshade.hpp>

namespace renodx::utils::data {

static const uint32_t THREAD_COUNT = 4;

template <typename Key, typename Value, typename Mutex = gtl::NullMutex>
using ParallelNodeHashMap = gtl::parallel_node_hash_map<
    Key,
    Value,
    gtl::Hash<Key>,
    gtl::EqualTo<Key>,
    std::allocator<std::pair<const Key, Value>>,
    THREAD_COUNT,
    Mutex>;

template <typename Key, typename Value, typename Mutex = gtl::NullMutex>
using ParallelFlatHashMap = gtl::parallel_flat_hash_map<
    Key,
    Value,
    gtl::Hash<Key>,
    gtl::EqualTo<Key>,
    std::allocator<std::pair<const Key, Value>>,
    THREAD_COUNT,
    Mutex>;

template <typename T>
inline T* Get(const reshade::api::api_object* api_object) {
  uint64_t res;
  api_object->get_private_data(reinterpret_cast<const uint8_t*>(&__uuidof(T)), &res);
  return reinterpret_cast<T*>(static_cast<uintptr_t>(res));
}

template <typename T, typename... Args>
inline T* Create(reshade::api::api_object* api_object, Args&&... args) {
  uint64_t res;
  res = reinterpret_cast<uintptr_t>(new T(static_cast<Args&&>(args)...));
  api_object->set_private_data(reinterpret_cast<const uint8_t*>(&__uuidof(T)), res);
  return reinterpret_cast<T*>(static_cast<uintptr_t>(res));
}

template <typename T, typename... Args>
inline bool CreateOrGet(reshade::api::api_object* api_object, T*& private_data, Args&&... args) {
  uint64_t res;
  api_object->get_private_data(reinterpret_cast<const uint8_t*>(&__uuidof(T)), &res);
  if (res == 0) {
    res = reinterpret_cast<uintptr_t>(new T(static_cast<Args&&>(args)...));
    api_object->set_private_data(reinterpret_cast<const uint8_t*>(&__uuidof(T)), res);
    private_data = reinterpret_cast<T*>(static_cast<uintptr_t>(res));
    // modelled after insert_or_assign()
    return true;
  }
  private_data = reinterpret_cast<T*>(static_cast<uintptr_t>(res));
  return false;
}

template <typename T>
inline void Delete(reshade::api::api_object* api_object, T* private_data) {
  delete private_data;
  api_object->set_private_data(reinterpret_cast<const uint8_t*>(&__uuidof(T)), 0);
}

template <typename T>
inline void Delete(reshade::api::api_object* api_object) {
  Delete(api_object, api_object->get_private_data<T>());
}

}  // namespace renodx::utils::data