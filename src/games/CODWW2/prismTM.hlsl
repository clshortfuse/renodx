//MIT License

//Copyright (c) 2026 Musa Haji
//Copyright (c) 2026 OopyDoopy / KickFister / Jon

//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:

//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.

//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.

#ifndef SRC_GAMES_CODWW2_PRISMTM_HLSL_
#define SRC_GAMES_CODWW2_PRISMTM_HLSL_

#include "./shared.h"

// Imported from the supplied prismTM.hlsl. hdr.hlsli provides the shared
// NaN-safe reinhardPiecewiseSmooth overloads before including this file.

static const float prismAnchor = 0.18f;

// ----------------------------------------------------------------- matrices

static const float3x3 prismInset = float3x3(
    0.726346493f, 0.166654825f, 0.106998682f,
    0.134236977f, 0.700138867f, 0.165624142f,
    0.072639547f, 0.060120508f, 0.867239952f);

static const float3x3 prismOutset = float3x3(
    1.450212359f, -0.335329264f, -0.114883065f,
    -0.253468722f, 1.510707617f, -0.257238865f,
    -0.103896290f, -0.076639965f, 1.180536270f);

// --------------------------------------------------------------------- main

float3 prism(float3 color, float peak) {
  color = mul(prismInset, color);
  color = reinhardPiecewiseSmooth(color, peak, prismAnchor);
  color = mul(prismOutset, color);

  return color;
}

#endif  // SRC_GAMES_CODWW2_PRISMTM_HLSL_
