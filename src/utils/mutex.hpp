#pragma once

#include <shared_mutex>

namespace renodx::utils::mutex {

inline std::shared_mutex global_mutex;

}  // namespace renodx::utils::mutex
