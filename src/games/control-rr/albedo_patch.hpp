/*
 * Copyright (C) 2026 speedlemur
 * SPDX-License-Identifier: MIT
 */

#pragma once

// control-rr: DXBC bytecode patch that makes Control's material pixel
// shaders also write their diffuse albedo to SV_Target1.
//
// Why patch bytecode instead of the usual RenoDX shader replacement: there
// are too many material shaders. Every material, setting and permutation
// is its own variant, and finding, decompiling and maintaining a
// replacement for each one isn't practical. Adding one output to the
// game's own shaders covers them all.
//
// Control is a light-pre-pass renderer: the material pass computes
//     scene = LightBufferDiffuse * albedo + LightBufferSpecular
// per pixel, where albedo = vColorMultiplier * ColorMap(uv). That albedo is
// never stored anywhere — it exists only in a temp register right before
// that multiply. This patch inserts `mov o1.xyz, <albedo>` in front of the
// multiply and declares SV_Target1, leaving every other instruction
// byte-identical. Any instruction writing o0.w is duplicated to o1.w so
// alpha-blended variants (decals) blend the albedo target coherently.
//
// The shader is identified by its reflection data (a texture binding named
// exactly g_tLightBufferDiffuse) AND by the instruction pattern (a `ld`
// from that texture followed by a 3-lane `mad` that multiplies the loaded
// RGB). Anything that fails either gate is left untouched.
//
// Pure byte manipulation, no D3D or ReShade dependencies, so it can be
// verified offline against the on-disk shader set (all 1275 DX12 material
// variants — 148 unique blobs — match, and the outputs disassemble
// cleanly). The checksum is the DXBC MD5 variant; it reproduces the
// game's own checksums on 3844 shipped blobs.

#include <cmath>
#include <cstdint>
#include <cstring>
#include <string>
#include <vector>

namespace control_albedo {

struct PatchResult {
  bool ok = false;
  std::string reason;  // failure reason, or a one-line summary on success
  std::vector<uint8_t> blob;
  uint32_t alpha_copies = 0;  // o0.w writers mirrored to o1.w
  uint32_t lbd_id = 0;        // resource id of g_tLightBufferDiffuse
  uint32_t nesting = 0;       // control-flow depth at the insertion point (0 = top level)
  bool sm51 = false;
};

namespace dxbc {

inline uint32_t Rd32(const uint8_t* p) {
  uint32_t v;
  memcpy(&v, p, 4);
  return v;
}
inline void Wr32(uint8_t* p, uint32_t v) { memcpy(p, &v, 4); }
inline uint32_t Rol(uint32_t x, uint32_t c) { return (x << c) | (x >> (32u - c)); }

// One MD5 block transform. The DXBC checksum is MD5 with a non-standard
// final block; the transform itself is stock.
inline void Md5Transform(uint32_t st[4], const uint8_t* blk) {
  static uint32_t K[64];
  static bool init = false;
  if (!init) {
    for (int i = 0; i < 64; ++i) {
      K[i] = static_cast<uint32_t>(std::fabs(std::sin(static_cast<double>(i + 1))) * 4294967296.0);
    }
    init = true;
  }
  static const uint32_t S[64] = {7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22,
                                 5, 9, 14, 20, 5, 9, 14, 20, 5, 9, 14, 20, 5, 9, 14, 20,
                                 4, 11, 16, 23, 4, 11, 16, 23, 4, 11, 16, 23, 4, 11, 16, 23,
                                 6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21};
  uint32_t M[16];
  for (int i = 0; i < 16; ++i) M[i] = Rd32(blk + 4 * i);
  uint32_t a = st[0], b = st[1], c = st[2], d = st[3];
  for (uint32_t i = 0; i < 64; ++i) {
    uint32_t f, g;
    if (i < 16) {
      f = (b & c) | (~b & d);
      g = i;
    } else if (i < 32) {
      f = (d & b) | (~d & c);
      g = (5 * i + 1) % 16;
    } else if (i < 48) {
      f = b ^ c ^ d;
      g = (3 * i + 5) % 16;
    } else {
      f = c ^ (b | ~d);
      g = (7 * i) % 16;
    }
    f = f + a + K[i] + M[g];
    a = d;
    d = c;
    c = b;
    b = b + Rol(f, S[i]);
  }
  st[0] += a;
  st[1] += b;
  st[2] += c;
  st[3] += d;
}

// DXBC container checksum over everything after the 20-byte prefix.
inline void Checksum(const uint8_t* blob, size_t size, uint8_t out[16]) {
  const uint8_t* data = blob + 20;
  const size_t n = size - 20;
  uint32_t st[4] = {0x67452301u, 0xefcdab89u, 0x98badcfeu, 0x10325476u};
  const size_t full = n & ~static_cast<size_t>(63);
  for (size_t i = 0; i < full; i += 64) Md5Transform(st, data + i);
  const uint8_t* left = data + full;
  const size_t left_len = n - full;
  const uint32_t nb = static_cast<uint32_t>(n * 8);
  const uint32_t nb2 = static_cast<uint32_t>(((n * 8) >> 2) | 1);
  uint8_t blk[64];
  if (left_len >= 56) {
    memset(blk, 0, 64);
    memcpy(blk, left, left_len);
    blk[left_len] = 0x80;
    Md5Transform(st, blk);
    memset(blk, 0, 64);
    Wr32(blk, nb);
    Wr32(blk + 60, nb2);
    Md5Transform(st, blk);
  } else {
    memset(blk, 0, 64);
    Wr32(blk, nb);
    memcpy(blk + 4, left, left_len);
    blk[4 + left_len] = 0x80;
    Wr32(blk + 60, nb2);
    Md5Transform(st, blk);
  }
  for (int i = 0; i < 4; ++i) Wr32(out + 4 * i, st[i]);
}

struct Chunk {
  uint32_t fourcc;
  const uint8_t* data;
  uint32_t size;
};

constexpr uint32_t FourCC(const char (&s)[5]) {
  return static_cast<uint32_t>(s[0]) | (static_cast<uint32_t>(s[1]) << 8)
         | (static_cast<uint32_t>(s[2]) << 16) | (static_cast<uint32_t>(s[3]) << 24);
}

inline bool ParseChunks(const uint8_t* blob, size_t size, std::vector<Chunk>& out) {
  if (size < 32 || memcmp(blob, "DXBC", 4) != 0) return false;
  const uint32_t total = Rd32(blob + 24);
  if (total > size) return false;
  const uint32_t count = Rd32(blob + 28);
  if (32 + 4 * static_cast<size_t>(count) > size) return false;
  for (uint32_t i = 0; i < count; ++i) {
    const uint32_t off = Rd32(blob + 32 + 4 * i);
    if (off + 8 > size) return false;
    Chunk c = {Rd32(blob + off), blob + off + 8, Rd32(blob + off + 4)};
    if (off + 8 + static_cast<size_t>(c.size) > size) return false;
    out.push_back(c);
  }
  return true;
}

// Looks up a texture binding by name in the RDEF chunk. For SM5.1 the
// value the bytecode uses to address the resource is the binding's range
// ID (last field of the 40-byte record); for SM5.0 it is the bind point.
inline bool FindTextureBinding(const Chunk& rdef, const char* name, uint32_t& out_id, bool& out_sm51) {
  if (rdef.size < 28) return false;
  const uint8_t* d = rdef.data;
  const uint32_t rb_count = Rd32(d + 8);
  const uint32_t rb_off = Rd32(d + 12);
  const uint8_t minor = d[16];
  const uint8_t major = d[17];
  out_sm51 = major > 5 || (major == 5 && minor >= 1);
  const uint32_t entry = out_sm51 ? 40u : 32u;
  const size_t name_len = strlen(name);
  for (uint32_t k = 0; k < rb_count; ++k) {
    const size_t e = rb_off + static_cast<size_t>(k) * entry;
    if (e + entry > rdef.size) return false;
    const uint32_t name_off = Rd32(d + e);
    const uint32_t type = Rd32(d + e + 4);
    if (type != 2u) continue;  // D3D_SIT_TEXTURE
    if (name_off + name_len + 1 > rdef.size) continue;
    if (memcmp(d + name_off, name, name_len + 1) != 0) continue;
    out_id = out_sm51 ? Rd32(d + e + 36) : Rd32(d + e + 20);
    return true;
  }
  return false;
}

// Operand types / opcodes used below (D3D10/11 tokenized program format).
enum : uint32_t {
  kTypeTemp = 0,
  kTypeOutput = 2,
  kTypeImm32 = 4,
  kTypeImm64 = 5,
  kTypeResource = 7,
  kOpElse = 18,
  kOpEndIf = 21,
  kOpEndLoop = 22,
  kOpEndSwitch = 23,
  kOpIf = 31,
  kOpImul = 38,
  kOpLd = 45,
  kOpLoop = 48,
  kOpMad = 50,
  kOpCustomData = 53,
  kOpMov = 54,
  kOpSwitch = 76,
  kOpSincos = 77,
  kOpUdiv = 78,
  kOpUmul = 81,
  kOpDclOutput = 101,
  kOpUaddc = 132,
  kOpUsubb = 133,
  kOpSwapc = 142,
};

inline bool IsDeclaration(uint32_t op) {
  return (op >= 88 && op <= 107) || (op >= 113 && op <= 116) || (op >= 143 && op <= 162) || op == 207;
}

struct Operand {
  uint32_t type = 0;
  uint32_t ncomp = 0;  // 0: none, 1: one, 2: four
  uint32_t sel = 0;    // 0: mask, 1: swizzle, 2: select-one
  uint32_t comp = 0;   // mask bits / swizzle byte / selected component
  uint32_t idim = 0;
  uint32_t idx[3] = {0, 0, 0};
  bool idx_valid[3] = {false, false, false};
  uint32_t idx_pos[3] = {0, 0, 0};  // token position of each immediate index
  uint32_t start = 0;               // first token
  uint32_t end = 0;                 // one past last token
};

// Parses one operand at token index i; returns false if it would run past n.
inline bool ParseOperand(const uint32_t* t, uint32_t n, uint32_t i, Operand& op) {
  if (i >= n) return false;
  const uint32_t tok = t[i];
  op.start = i;
  ++i;
  op.ncomp = tok & 3u;
  op.sel = (tok >> 2) & 3u;
  op.comp = (tok >> 4) & 0xFFu;
  op.type = (tok >> 12) & 0xFFu;
  op.idim = (tok >> 20) & 3u;
  uint32_t ext = tok >> 31;
  while (ext != 0u) {
    if (i >= n) return false;
    ext = t[i] >> 31;
    ++i;
  }
  if (op.type == kTypeImm32 || op.type == kTypeImm64) {
    uint32_t nvals = op.ncomp == 0 ? 0u : (op.ncomp == 1 ? 1u : 4u);
    if (op.type == kTypeImm64) nvals *= 2;
    i += nvals;
  }
  for (uint32_t dim = 0; dim < op.idim; ++dim) {
    const uint32_t rep = (tok >> (22 + 3 * dim)) & 7u;
    Operand rel;
    switch (rep) {
      case 0:
        if (i >= n) return false;
        op.idx[dim] = t[i];
        op.idx_valid[dim] = true;
        op.idx_pos[dim] = i;
        i += 1;
        break;
      case 1: i += 2; break;
      case 2:
        if (!ParseOperand(t, n, i, rel)) return false;
        i = rel.end;
        break;
      case 3:
        if (i >= n) return false;
        op.idx[dim] = t[i];
        op.idx_valid[dim] = true;
        op.idx_pos[dim] = i;
        i += 1;
        if (!ParseOperand(t, n, i, rel)) return false;
        i = rel.end;
        break;
      case 4:
        i += 2;
        if (!ParseOperand(t, n, i, rel)) return false;
        i = rel.end;
        break;
      default: return false;
    }
  }
  if (i > n) return false;
  op.end = i;
  return true;
}

struct Instr {
  uint32_t pos;     // opcode token index
  uint32_t len;     // total tokens
  uint32_t op;
  std::vector<Operand> ops;  // empty for declarations / custom data / unparseable
};

inline void ParseInstr(const uint32_t* t, uint32_t /*n*/, uint32_t i, Instr& ins) {
  const uint32_t tok = t[i];
  ins.pos = i;
  ins.op = tok & 0x7FFu;
  ins.len = ins.op == kOpCustomData ? t[i + 1] : ((tok >> 24) & 0x7Fu);
  ins.ops.clear();
  if (ins.len == 0) ins.len = 1;
  if (ins.op == kOpCustomData || IsDeclaration(ins.op)) return;
  uint32_t k = i;
  while ((t[k] >> 31) != 0u && k + 1 < i + ins.len) ++k;  // extended opcode tokens
  uint32_t j = k + 1;
  const uint32_t end = i + ins.len;
  while (j < end) {
    Operand o;
    if (!ParseOperand(t, end, j, o)) {
      ins.ops.clear();
      return;
    }
    ins.ops.push_back(o);
    j = o.end;
  }
}

inline uint32_t MaskLaneCount(uint32_t mask) {
  return (mask & 1u) + ((mask >> 1) & 1u) + ((mask >> 2) & 1u) + ((mask >> 3) & 1u);
}

}  // namespace dxbc

inline PatchResult PatchMaterialShader(const uint8_t* blob, size_t size) {
  using namespace dxbc;
  PatchResult r;
  std::vector<Chunk> chunks;
  if (!ParseChunks(blob, size, chunks)) {
    r.reason = "not a DXBC container";
    return r;
  }
  const Chunk* rdef = nullptr;
  const Chunk* shex = nullptr;
  const Chunk* osgn = nullptr;
  for (const auto& c : chunks) {
    if (c.fourcc == FourCC("RDEF")) rdef = &c;
    if (c.fourcc == FourCC("SHEX") || c.fourcc == FourCC("SHDR")) shex = &c;
    if (c.fourcc == FourCC("OSGN")) osgn = &c;
    if (c.fourcc == FourCC("OSG5") || c.fourcc == FourCC("OSG1")) {
      r.reason = "unsupported output signature chunk";
      return r;
    }
  }
  if (rdef == nullptr || shex == nullptr || osgn == nullptr) {
    r.reason = "missing RDEF/SHEX/OSGN chunk";
    return r;
  }

  uint32_t lbd_id = 0;
  bool sm51 = false;
  if (!FindTextureBinding(*rdef, "g_tLightBufferDiffuse", lbd_id, sm51)) {
    r.reason = "no g_tLightBufferDiffuse texture binding";
    return r;
  }
  r.lbd_id = lbd_id;
  r.sm51 = sm51;

  // --- tokenize SHEX ---
  const uint32_t n = shex->size / 4;
  if (n < 2 || shex->size % 4 != 0) {
    r.reason = "malformed SHEX";
    return r;
  }
  std::vector<uint32_t> t(n);
  memcpy(t.data(), shex->data, shex->size);
  const uint32_t version = t[0];
  if ((version >> 16) != 0u) {
    r.reason = "not a pixel shader";
    return r;
  }
  if (t[1] != n) {
    r.reason = "SHEX length token mismatch";
    return r;
  }

  // --- scan instructions ---
  bool have_ld = false;
  uint32_t ld_reg = 0;
  uint32_t ld_mask = 0;
  uint32_t ld_chan[4] = {0, 0, 0, 0};  // dst lane -> colour channel
  bool have_mad = false;
  uint32_t mad_pos = 0;
  std::vector<uint32_t> albedo_tokens;
  std::vector<uint32_t> o0_dcl;
  uint32_t dcl_out_end = 0;
  struct AlphaWriter {
    uint32_t pos, len, tok_pos, idx_pos;
  };
  std::vector<AlphaWriter> alpha_writers;
  uint32_t depth = 0;

  Instr ins;
  for (uint32_t i = 2; i < n; i += ins.len) {
    ParseInstr(t.data(), n, i, ins);
    if (i + ins.len > n) {
      r.reason = "instruction runs past SHEX end";
      return r;
    }
    if (ins.op == kOpDclOutput) {
      dcl_out_end = i + ins.len;
      Operand o;
      if (ParseOperand(t.data(), i + ins.len, i + 1, o) && o.type == kTypeOutput && o.idx_valid[0] && o.idx[0] == 0) {
        o0_dcl.assign(t.begin() + i, t.begin() + i + ins.len);
      }
      continue;
    }
    if (!have_mad) {
      if (ins.op == kOpIf || ins.op == kOpLoop || ins.op == kOpSwitch) ++depth;
      if ((ins.op == kOpEndIf || ins.op == kOpEndLoop || ins.op == kOpEndSwitch) && depth > 0) --depth;
    }
    if (ins.ops.empty()) continue;

    if (!have_ld) {
      if (ins.op == kOpLd && ins.ops.size() == 3) {
        const Operand& dst = ins.ops[0];
        const Operand& res = ins.ops[2];
        if (res.type == kTypeResource && res.idx_valid[0] && res.idx[0] == lbd_id && dst.type == kTypeTemp
            && dst.sel == 0 && dst.idx_valid[0]) {
          have_ld = true;
          ld_reg = dst.idx[0];
          ld_mask = dst.comp & 0xFu;
          for (uint32_t l = 0; l < 4; ++l) ld_chan[l] = (res.comp >> (2 * l)) & 3u;
        }
      }
    } else if (!have_mad) {
      // the multiply lands in a temp, or straight in o0 for the simplest variants
      if (ins.op == kOpMad && ins.ops.size() == 4 && (ins.ops[0].type == kTypeTemp || ins.ops[0].type == kTypeOutput)
          && ins.ops[0].sel == 0 && MaskLaneCount(ins.ops[0].comp & 0xFu) == 3) {
        uint32_t D[3];
        uint32_t nd = 0;
        for (uint32_t l = 0; l < 4; ++l) {
          if ((ins.ops[0].comp >> l) & 1u) D[nd++] = l;
        }
        for (uint32_t a = 1; a <= 2 && !have_mad; ++a) {
          const Operand& o = ins.ops[a];
          if (!(o.type == kTypeTemp && o.idx_valid[0] && o.idx[0] == ld_reg && o.sel == 1)) continue;
          uint32_t cols[3];
          bool okc = true;
          uint32_t seen = 0;
          for (uint32_t k = 0; k < 3; ++k) {
            const uint32_t s = (o.comp >> (2 * D[k])) & 3u;
            if (((ld_mask >> s) & 1u) == 0u) {
              okc = false;
              break;
            }
            cols[k] = ld_chan[s];
            seen |= 1u << cols[k];
          }
          if (!okc || seen != 0x7u) continue;
          const Operand& ab = ins.ops[3 - a];
          std::vector<uint32_t> tok(t.begin() + ab.start, t.begin() + ab.end);
          if (ab.type == kTypeTemp || ab.type == 3 /*indexable temp*/ || ab.type == 8 /*cbuffer*/ || ab.type == 1 /*input*/) {
            uint32_t asel[3];
            if (ab.sel == 1) {
              for (uint32_t k = 0; k < 3; ++k) asel[k] = (ab.comp >> (2 * D[k])) & 3u;
            } else if (ab.sel == 2) {
              for (uint32_t k = 0; k < 3; ++k) asel[k] = ab.comp & 3u;
            } else {
              r.reason = "albedo operand is a mask operand";
              return r;
            }
            uint32_t rgb[3];
            for (uint32_t c = 0; c < 3; ++c) {
              for (uint32_t k = 0; k < 3; ++k) {
                if (cols[k] == c) rgb[c] = asel[k];
              }
            }
            const uint32_t sw = rgb[0] | (rgb[1] << 2) | (rgb[2] << 4) | (rgb[0] << 6);
            tok[0] = (tok[0] & ~(0xFFu << 4)) | (sw << 4);
            tok[0] = (tok[0] & ~(3u << 2)) | (1u << 2);  // swizzle selection
          } else if (ab.type == kTypeImm32 && ab.ncomp == 2) {
            const size_t base = tok.size() - 4;
            uint32_t vals[4] = {tok[base], tok[base + 1], tok[base + 2], tok[base + 3]};
            uint32_t rgb[3];
            for (uint32_t c = 0; c < 3; ++c) {
              for (uint32_t k = 0; k < 3; ++k) {
                if (cols[k] == c) rgb[c] = vals[D[k]];
              }
            }
            tok[base] = rgb[0];
            tok[base + 1] = rgb[1];
            tok[base + 2] = rgb[2];
            tok[base + 3] = rgb[0];
          } else if (ab.type == kTypeImm32 && ab.ncomp == 1) {
            // scalar immediate broadcasts; copy verbatim
          } else {
            r.reason = "unsupported albedo operand type " + std::to_string(ab.type);
            return r;
          }
          albedo_tokens = tok;
          mad_pos = i;
          have_mad = true;
          r.nesting = depth;
        }
      }
      if (!have_mad) {
        // the light-buffer register must survive untouched until the multiply
        const uint32_t ndst = (ins.op == kOpSincos || ins.op == kOpUdiv || ins.op == kOpImul || ins.op == kOpUmul
                               || ins.op == kOpSwapc || ins.op == kOpUaddc || ins.op == kOpUsubb)
                                  ? 2u
                                  : 1u;
        for (uint32_t d = 0; d < ndst && d < ins.ops.size(); ++d) {
          const Operand& o = ins.ops[d];
          if (o.type == kTypeTemp && o.sel == 0 && o.idx_valid[0] && o.idx[0] == ld_reg && (o.comp & ld_mask) != 0u) {
            r.reason = "light buffer register clobbered before multiply";
            return r;
          }
        }
      }
    }

    // every o0.w write gets mirrored to o1.w
    const Operand& d0 = ins.ops[0];
    if (d0.type == kTypeOutput && d0.sel == 0 && d0.idx_valid[0] && d0.idx[0] == 0 && (d0.comp & 8u) != 0u) {
      alpha_writers.push_back({i, ins.len, d0.start, d0.idx_pos[0]});
    }
  }

  if (!have_ld) {
    r.reason = "no ld from g_tLightBufferDiffuse";
    return r;
  }
  if (!have_mad) {
    r.reason = "no albedo multiply after the light buffer load";
    return r;
  }
  if (o0_dcl.empty() || dcl_out_end == 0) {
    r.reason = "no dcl_output o0";
    return r;
  }

  // --- build the new instruction stream ---
  // mov o1.xyz, <albedo>
  std::vector<uint32_t> mov;
  mov.push_back(kOpMov | ((1u + 2u + static_cast<uint32_t>(albedo_tokens.size())) << 24));
  mov.push_back(2u | (0u << 2) | (0x7u << 4) | (kTypeOutput << 12) | (1u << 20));
  mov.push_back(1u);
  mov.insert(mov.end(), albedo_tokens.begin(), albedo_tokens.end());

  // dcl_output o1 (same mask as o0's declaration)
  std::vector<uint32_t> dcl = o0_dcl;
  {
    Operand o;
    ParseOperand(dcl.data(), static_cast<uint32_t>(dcl.size()), 1, o);
    dcl[o.idx_pos[0]] = 1u;
  }

  // insertions keyed by the token index they go in front of
  std::vector<std::pair<uint32_t, std::vector<uint32_t>>> inserts;
  auto insert_at = [&](uint32_t pos, const std::vector<uint32_t>& tokens, bool front) {
    for (auto& e : inserts) {
      if (e.first == pos) {
        if (front) {
          e.second.insert(e.second.begin(), tokens.begin(), tokens.end());
        } else {
          e.second.insert(e.second.end(), tokens.begin(), tokens.end());
        }
        return;
      }
    }
    inserts.emplace_back(pos, tokens);
  };
  insert_at(mad_pos, mov, false);
  for (const AlphaWriter& w : alpha_writers) {
    std::vector<uint32_t> copy(t.begin() + w.pos, t.begin() + w.pos + w.len);
    const uint32_t rel = w.tok_pos - w.pos;
    copy[rel] = (copy[rel] & ~(0xFu << 4)) | (0x8u << 4);
    copy[w.idx_pos - w.pos] = 1u;
    insert_at(w.pos + w.len, copy, false);
  }
  insert_at(dcl_out_end, dcl, true);

  std::vector<uint32_t> out;
  out.reserve(n + 64);
  for (uint32_t i = 0; i <= n; ++i) {
    for (const auto& e : inserts) {
      if (e.first == i) out.insert(out.end(), e.second.begin(), e.second.end());
    }
    if (i < n) out.push_back(t[i]);
  }
  out[1] = static_cast<uint32_t>(out.size());
  r.alpha_copies = static_cast<uint32_t>(alpha_writers.size());

  // --- OSGN: add SV_Target1 ---
  std::vector<uint8_t> nosgn;
  {
    const uint8_t* d = osgn->data;
    if (osgn->size < 8) {
      r.reason = "malformed OSGN";
      return r;
    }
    const uint32_t count = Rd32(d);
    const uint32_t unk = Rd32(d + 4);
    const size_t entries_end = 8 + 24 * static_cast<size_t>(count);
    if (entries_end > osgn->size) {
      r.reason = "malformed OSGN entries";
      return r;
    }
    std::vector<std::vector<uint8_t>> entries;
    int target0 = -1;
    for (uint32_t k = 0; k < count; ++k) {
      const uint8_t* e = d + 8 + 24 * k;
      entries.emplace_back(e, e + 24);
      if (target0 < 0 && Rd32(e + 16) == 0u) target0 = static_cast<int>(k);  // register 0 = SV_Target0
    }
    if (target0 < 0) {
      r.reason = "OSGN has no register-0 target";
      return r;
    }
    std::vector<uint8_t> e1 = entries[target0];
    Wr32(e1.data() + 4, 1u);   // semantic index
    Wr32(e1.data() + 16, 1u);  // register
    entries.push_back(e1);
    for (auto& e : entries) Wr32(e.data(), Rd32(e.data()) + 24u);
    nosgn.resize(8);
    Wr32(nosgn.data(), count + 1);
    Wr32(nosgn.data() + 4, unk);
    for (auto& e : entries) nosgn.insert(nosgn.end(), e.begin(), e.end());
    nosgn.insert(nosgn.end(), d + entries_end, d + osgn->size);
    while (nosgn.size() % 4 != 0) nosgn.push_back(0);
  }

  // --- rebuild the container ---
  std::vector<uint8_t>& nb = r.blob;
  const uint32_t nchunks = static_cast<uint32_t>(chunks.size());
  const uint32_t hdr = 32 + 4 * nchunks;
  nb.assign(blob, blob + 32);
  nb.resize(hdr, 0);
  std::vector<uint32_t> offsets;
  for (const auto& c : chunks) {
    offsets.push_back(static_cast<uint32_t>(nb.size()));
    const uint8_t* data = c.data;
    uint32_t csize = c.size;
    std::vector<uint8_t> shex_bytes;
    if (&c == shex) {
      shex_bytes.resize(out.size() * 4);
      memcpy(shex_bytes.data(), out.data(), shex_bytes.size());
      data = shex_bytes.data();
      csize = static_cast<uint32_t>(shex_bytes.size());
    } else if (&c == osgn) {
      data = nosgn.data();
      csize = static_cast<uint32_t>(nosgn.size());
    }
    uint8_t ch[8];
    Wr32(ch, c.fourcc);
    Wr32(ch + 4, csize);
    nb.insert(nb.end(), ch, ch + 8);
    nb.insert(nb.end(), data, data + csize);
  }
  Wr32(nb.data() + 24, static_cast<uint32_t>(nb.size()));
  Wr32(nb.data() + 28, nchunks);
  for (uint32_t i = 0; i < nchunks; ++i) Wr32(nb.data() + 32 + 4 * i, offsets[i]);
  Checksum(nb.data(), nb.size(), nb.data() + 4);

  r.ok = true;
  r.reason = "ok";
  return r;
}

}  // namespace control_albedo
