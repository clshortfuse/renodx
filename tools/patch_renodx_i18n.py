#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
patch_renodx_i18n.py — 将新增中文翻译合并进 RenoDX for Wuthering Waves
(renodx-wutheringwaves.addon64) 的内嵌 zh-Hans 字典，输出补丁后的副本（不改动原文件）。

原理（详见《交接文档.md》）：
  * addon 内嵌一份 zh-Hans JSON 字典（英文 UI 文本 -> 中文），运行时按显示文本精确匹配翻译；
  * 字典以 C 字符串字面量存放于 .rdata，采用 CRLF + 2 空格缩进 JSON，字面量末尾紧跟
    "\\r\\nFailed to parse embedded zh-Hans translations." 报错文案（与 JSON 同一字面量）；
  * 该字面量在代码中只有一处引用：`lea rdx,[rip+disp32]`；
  * 合并后的 JSON 若放不进原字面量空间，则在文件尾新增 .zhdict 节存放，并把上述唯一
    LEA 的 disp32 重定位到新节；最后重算 PE 校验和；
  * 原字面量与报错文案原样保留（报错文案另有独立代码引用，不可破坏）。

用法：
  python patch_renodx_i18n.py <addon64> <additions.json> [-o OUTPUT] [--force]
  python patch_renodx_i18n.py <addon64> --dump-full OUT.json

说明：
  * 全部定位通过锚点搜索完成（报错文案字符串 + disp32 反查），不硬编码偏移，
    对同系列后续构建同样适用；任何锚点校验失败都会中止并给出原因。
  * 键已存在且译文一致 -> 跳过；译文不同 -> 报错（--force 覆盖）。
"""

import argparse
import hashlib
import json
import re
import struct
import sys

ERRMSG = b"Failed to parse embedded zh-Hans translations."
NEW_SECTION_NAME = b".zhdict"
IMG_SCN_CNT_INITIALIZED_DATA = 0x00000040
IMG_SCN_MEM_READ = 0x40000000
LEA_RDX_RIP = re.compile(rb"\x48\x8d\x15(....)", re.S)


def die(msg):
    print("[错误] " + msg)
    sys.exit(1)


def align_up(v, a):
    return (v + a - 1) // a * a


# ---------------------------------------------------------------- PE 基础解析

def parse_pe(data):
    if data[:2] != b"MZ":
        die("输入不是 PE 文件（缺少 MZ 头）")
    e_lfanew = struct.unpack_from("<I", data, 0x3C)[0]
    if data[e_lfanew:e_lfanew + 4] != b"PE\x00\x00":
        die("PE 签名缺失")
    nsec = struct.unpack_from("<H", data, e_lfanew + 6)[0]
    optsize = struct.unpack_from("<H", data, e_lfanew + 20)[0]
    opt = e_lfanew + 24
    if struct.unpack_from("<H", data, opt)[0] != 0x20B:
        die("仅支持 PE32+ (x64) 镜像")
    sect_align, file_align = struct.unpack_from("<II", data, opt + 32)
    size_of_image = struct.unpack_from("<I", data, opt + 56)[0]
    table = opt + optsize
    secs = []
    for i in range(nsec):
        b = table + 40 * i
        name = data[b:b + 8].rstrip(b"\x00").decode("ascii", "replace")
        vsize, vaddr, rsize, roff = struct.unpack_from("<IIII", data, b + 8)
        secs.append({"name": name, "vsize": vsize, "vaddr": vaddr,
                     "rawsize": rsize, "raw": roff, "hdr": b})
    return {"e_lfanew": e_lfanew, "nsec": nsec, "opt": opt, "table": table,
            "sect_align": sect_align, "file_align": file_align,
            "size_of_image": size_of_image, "secs": secs}


def file_rva(pe, off):
    for s in pe["secs"]:
        if s["raw"] <= off < s["raw"] + s["rawsize"]:
            return s["vaddr"] + (off - s["raw"])
    return None


def sec_by_rva(pe, rva):
    for s in pe["secs"]:
        if s["vaddr"] <= rva < s["vaddr"] + max(s["vsize"], 1):
            return s
    return None


# ---------------------------------------------------------- 内嵌字典与其引用

def find_json_literal(data):
    """定位内嵌 zh-Hans JSON 字面量。返回 (start, json_end, lit_end, obj, text)。"""
    for m in re.finditer(re.escape(ERRMSG), data):
        start = data.rfind(b"\x00", 0, m.start()) + 1
        blob = data[start:m.start()]
        try:
            obj, used = json.JSONDecoder().raw_decode(blob.decode("utf-8"))
        except Exception:
            continue
        if isinstance(obj, dict) and "Preset #1" in obj:
            text = blob[:used].decode("utf-8")
            lit_end = data.find(b"\x00", start)
            return start, start + len(text.encode("utf-8")), lit_end, obj, text
    die("未找到内嵌 zh-Hans 翻译 JSON（构建版本可能不兼容）")


def find_lea_refs(data, pe, target_rva):
    """查找 disp32 结尾且 RIP 相对目标为 target_rva 的 `lea rdx,[rip+disp]`。"""
    hits = []
    for m in LEA_RDX_RIP.finditer(data):
        q = m.start() + 3                 # disp32 起始文件偏移
        end_rva = file_rva(pe, q + 4)     # 指令结束（下一条指令）RVA
        if end_rva is None:
            continue
        disp = struct.unpack("<i", m.group(1))[0]
        if end_rva + disp == target_rva:
            hits.append((q, end_rva))
    return hits


def pe_checksum(data):
    if len(data) % 2:
        data += b"\x00"
    s = 0
    for (w,) in struct.iter_unpack("<H", data):
        s += w
        s = (s & 0xFFFF) + (s >> 16)
    s = (s & 0xFFFF) + (s >> 16)
    return (s + len(data)) & 0xFFFFFFFF


# ---------------------------------------------------------------------- 主流程

def main():
    ap = argparse.ArgumentParser(description="RenoDX WuWa 内嵌 zh-Hans 字典汉化补丁")
    ap.add_argument("addon", help="renodx-wutheringwaves.addon64 路径")
    ap.add_argument("additions", nargs="?", help="新增翻译 JSON（英文键 -> 中文值）")
    ap.add_argument("-o", "--output", help="输出路径（默认 <addon>.patched）")
    ap.add_argument("--force", action="store_true", help="允许覆盖已有键的不同译文")
    ap.add_argument("--dump-full", metavar="OUT_JSON",
                    help="仅导出当前内嵌完整字典到 OUT_JSON 后退出")
    args = ap.parse_args()

    data = bytearray(open(args.addon, "rb").read())
    pe = parse_pe(data)
    start, json_end, lit_end, orig, orig_text = find_json_literal(data)
    print(f"[1/6] 定位内嵌字典: 文件偏移 {start:#x}-{lit_end:#x}，{len(orig)} 条")

    if args.dump_full:
        with open(args.dump_full, "w", encoding="utf-8") as f:
            json.dump(orig, f, ensure_ascii=False, indent=2)
        print(f"已导出 {len(orig)} 条 -> {args.dump_full}")
        return

    if not args.additions:
        die("缺少 additions JSON 参数")
    with open(args.additions, "rb") as f:
        additions = json.loads(f.read().decode("utf-8-sig"))
    if not isinstance(additions, dict) or not additions:
        die("additions JSON 必须是非空对象")

    skipped = 0
    for k, v in additions.items():
        if not isinstance(k, str) or not isinstance(v, str) or not v:
            die(f"非法条目: {k!r}")
        if k in orig:
            if orig[k] == v:
                skipped += 1
            elif not args.force:
                die(f"键已存在且译文不同（--force 可覆盖）: {k[:60]!r}")
    merged = dict(orig)
    merged.update(additions)

    new_json = json.dumps(merged, ensure_ascii=False, indent=2).replace("\n", "\r\n")
    new_blob = new_json.encode("utf-8")
    print(f"[2/6] 合并字典: {len(orig)} + {len(additions) - skipped} 条新增"
          f"（{skipped} 条已存在跳过）= {len(merged)} 条，{len(new_blob)} 字节")

    # 原字面量尾部（\r\n + 报错文案）必须原样保留（另有独立代码引用）。
    tail = bytes(data[json_end:lit_end])
    lit_span = lit_end - start
    in_place = len(new_blob) + len(tail) + 1 <= lit_span

    json_rva = file_rva(pe, start)
    leas = find_lea_refs(data, pe, json_rva)
    if len(leas) != 1:
        die(f"字典 LEA 引用数异常（{len(leas)} 处，应为 1），中止")
    lea_q, lea_end_rva = leas[0]
    print(f"[3/6] 字典引用: LEA @ 文件偏移 {lea_q - 3:#x}（RVA {lea_end_rva - 7:#x}）-> RVA {json_rva:#x}")

    if in_place:
        print("[4/6] 放置方式: 原地重写（容量足够）")
        room = lit_span - len(new_blob) - len(tail) - 1
        data[start:lit_end] = new_blob + tail + b"\x00" + b"\x00" * room
    else:
        print("[4/6] 放置方式: 新增 .zhdict 节 + 重定位 LEA")
        hdr_slot = pe["table"] + pe["nsec"] * 40
        first_raw = min(s["raw"] for s in pe["secs"] if s["rawsize"])
        if hdr_slot + 40 > first_raw:
            die("节表无空闲头部槽位，无法新增节")
        new_raw = align_up(max(s["raw"] + s["rawsize"] for s in pe["secs"]), pe["file_align"])
        if new_raw != len(data):
            print(f"      注意: 文件存在尾部数据（{len(data) - new_raw} 字节），新节接在其后")
        new_rva = align_up(max(s["vaddr"] + s["vsize"] for s in pe["secs"]), pe["sect_align"])
        content = new_blob + b"\x00"
        padded = content + b"\x00" * (align_up(len(content), pe["file_align"]) - len(content))

        data[hdr_slot:hdr_slot + 40] = (
            NEW_SECTION_NAME.ljust(8, b"\x00")
            + struct.pack("<IIII", len(content), new_rva, len(padded), new_raw)
            + struct.pack("<II", 0, 0)          # PointerToRelocations / Linenumbers
            + struct.pack("<HH", 0, 0)          # NumberOfRelocations / Linenumbers
            + struct.pack("<I", IMG_SCN_CNT_INITIALIZED_DATA | IMG_SCN_MEM_READ)
        )
        struct.pack_into("<H", data, pe["e_lfanew"] + 6, pe["nsec"] + 1)
        struct.pack_into("<I", data, pe["opt"] + 56,
                         new_rva + align_up(len(content), pe["sect_align"]))
        data += padded
        struct.pack_into("<i", data, lea_q, new_rva - lea_end_rva)
        print(f"      新节: RVA {new_rva:#x}  文件偏移 {new_raw:#x}  "
              f"{len(padded):#x} 字节；LEA disp32 已重写")

    tmp = bytearray(data)
    struct.pack_into("<I", tmp, pe["opt"] + 64, 0)
    struct.pack_into("<I", data, pe["opt"] + 64, pe_checksum(bytes(tmp)))
    out_path = args.output or (args.addon + ".patched")
    with open(out_path, "wb") as f:
        f.write(data)
    print(f"[5/6] 已写入: {out_path}")

    # ------------------------------------------------------------- 自校验
    if in_place:
        blob2 = data[start:data.find(b"\x00", start)]
    else:
        disp = struct.unpack_from("<i", data, lea_q)[0]
        target = lea_end_rva + disp
        sec = sec_by_rva(parse_pe(bytes(data)), target)
        if sec is None:
            die("自校验失败：重定位后的 LEA 指向无效地址")
        off = sec["raw"] + (target - sec["vaddr"])
        blob2 = data[off:data.find(b"\x00", off)]
    try:
        obj2 = json.loads(blob2.decode("utf-8"))
    except Exception as e:
        die(f"自校验失败：输出中的字典无法解析: {e}")
    if obj2 != merged:
        die("自校验失败：输出中的字典与合并结果不一致")
    for k, v in orig.items():
        if obj2.get(k) != v:
            die(f"自校验失败：原有条目被改动: {k[:60]!r}")
    print(f"[6/6] 自校验通过: {len(obj2)} 条，原有 {len(orig)} 条逐字节保留")
    print(f"      输出 SHA-256: {hashlib.sha256(data).hexdigest()}")
    print("完成。请在游戏中选择 Chinese 语言，检查 光线追踪 分类 / 简洁界面模式 / 关于页构建版本 行。")


if __name__ == "__main__":
    main()
