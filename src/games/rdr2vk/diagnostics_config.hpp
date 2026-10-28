/*
 * Copyright (C) 2026 Musa Haji
 * SPDX-License-Identifier: MIT
 */

#pragma once

// Gate diagnostic includes AND argument preparation at every rendering call site.
// Enabling observations never authorizes changing or suppressing native calls.
#ifndef RDR2VK_ENABLE_LIFETIME_DIAGNOSTICS
#define RDR2VK_ENABLE_LIFETIME_DIAGNOSTICS 0
#endif

#if RDR2VK_ENABLE_LIFETIME_DIAGNOSTICS != 0 && RDR2VK_ENABLE_LIFETIME_DIAGNOSTICS != 1
#error RDR2VK_ENABLE_LIFETIME_DIAGNOSTICS must be 0 or 1
#endif

static_assert(RDR2VK_ENABLE_LIFETIME_DIAGNOSTICS == 0 || RDR2VK_ENABLE_LIFETIME_DIAGNOSTICS == 1,
              "RDR2VK_ENABLE_LIFETIME_DIAGNOSTICS must be 0 or 1");