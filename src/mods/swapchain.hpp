/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include "./swapchain_v1.hpp"
#include "./swapchain_v2.hpp"

namespace renodx::mods::swapchain {

#ifndef RENODX_MODS_SWAPCHAIN_VERSION
#define RENODX_MODS_SWAPCHAIN_VERSION 1
#endif

#if RENODX_MODS_SWAPCHAIN_VERSION == 1
using namespace v1;
#else
using namespace v2;
#endif

}  // namespace renodx::mods::swapchain
