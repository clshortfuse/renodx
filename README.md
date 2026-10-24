# 鸣潮 (Wuthering Waves) RenoDX HDR 模组汉化项目

## 一、项目概述

- **项目名称**：鸣潮 RenoDX HDR 模组简体中文版 (`renodx-wutheringwaves-CN`)
- **本仓库**：[XYZ-ZJ/renodx-HDR-CN](https://github.com/XYZ-ZJ/renodx-HDR-CN)
- **上游主仓**：[clshortfuse/renodx](https://github.com/clshortfuse/renodx)
- **项目目标**：针对《鸣潮》游戏使用的 RenoDX HDR ReShade Addon 进行 100% 完整深度的简体中文本地化，解决旧版截断、乱码及中英文夹杂问题，保持与上游官方最新代码同步，并实现 GitHub Actions 自动化云端极速编译与部署。

---

## 二、技术架构与演进方案

### 1. 早期方案缺陷与根因剖析
- **静态二进制原位修补缺陷**：
  - **乱码问号（`?`）**：UTF-8 汉字固定占用 3 字节，官方原版 `.rdata` 槽位固定（如 12、16 字节），译文稍长便会导致多字节截断，破坏 UTF-8 编码，使 ImGui 呈现乱码 `?`。
  - **中英拼接尾缀（如 `透city`、`高光wout`）**：编译器对短字符串执行了 SSO（Small String Optimization）内联优化，在 `.text` 机器码中包含立即数拼接指令，仅改数据段会导致代码段残留英文字符串。
  - **折叠栏分裂（如双重 `色调映射` 与 `Tone Mapping`）**：RenoDX 在检测到 `.section` 变更时会自动开启新折叠栏。若部分项翻译而后续项漏翻，会导致同一分类在界面上分裂为中英两个并列菜单。
- **源码级编译方案优势**：
  - 零槽位长度限制，译文完整且语义准确。
  - 编译器自动处理内存分配，彻底消灭 SSO 立即数覆盖与字符截断。
  - 全局折叠栏与通用设置（`Preset`、`On/Off`）统一汉化，界面整洁规范。

### 2. GitHub Actions 专属极速构建流水线
- **文件位置**：`.github/workflows/build-wuwa.yml`
- **优化机制**：
  - 官方默认的 `snapshot.yml` 每次全量编译 100 多个游戏，耗时 60~90 分钟。
  - 专属流水线配置 CMake 参数指定目标 `--target wutheringwaves`，仅编译鸣潮单个 Addon，利用 `sccache` 编译缓存与 Clang-cl，将构建时间大幅缩短至 **2~3 分钟**。
  - 编译完成后自动打包重命名为 `renodx-wutheringwaves-CN.addon64`、`renodx-wutheringwaves-CN.pdb` 及对应 zip 压缩包，自动上传 Artifacts 并发布 Release。

---

## 三、汉化范围与词条规范

| 界面分类 / 模块 | 涉及源码文件 | 包含汉化项 |
| :--- | :--- | :--- |
| **色调映射 (Tone Mapping)** | `src/games/wutheringwaves/addon.cpp` | 色调映射器、峰值亮度（尼特）、游戏亮度（尼特）、伽马校正（关闭/2.2/2.4）、色调映射方法（Extended、PsychoV）等 |
| **视频 (Video)** | `src/games/wutheringwaves/addon.cpp` | 视频自动 HDR、视频亮度（尼特）等 |
| **界面 (UI)** | `src/games/wutheringwaves/addon.cpp` | 可见性、切换快捷键录入提示、界面亮度、界面伽马校正、文本不透明度、状态文本不透明度、HUD 不透明度等 |
| **场景调色 (Scene Grading)** | `src/games/wutheringwaves/addon.cpp` | 游戏色调映射器（库洛/原神/死亡搁浅/无）、色调映射强度、LUT 亮度、LUT 强度等 |
| **自定义调色 (Custom Color Grading)** | `src/games/wutheringwaves/addon.cpp` | 曝光、高光、阴影、对比度、饱和度、高光溢出、色相还原、色相偏移、分通道高光溢出、色相参考裁切/肩部值等 |
| **后期处理 (Post-Processing)** | `src/games/wutheringwaves/addon.cpp` | 泛光强度控制、HDR 太阳/天空盒发光增强等 |
| **资源升级 (Resource Upgrades)** | `src/games/wutheringwaves/addon.cpp` | 交换链兼容模式、交换链格式（HDR10/scRGB）、强制无边框窗口、阻止独占全屏、转储 LUT 着色器、重启生效提示等 |
| **通用组件与预设 (Utils/Settings)** | `src/utils/settings.hpp` | 预设选择滑块（预设 #1~#3）、通用布尔开关（开启/关闭）等 |
| **关于与选项 (Options/About)** | `src/games/wutheringwaves/addon.cpp` | 全部重置、原版增强、HDR 风格、更多模组、构建版本信息等 |

---

## 四、本地游戏部署规范

1. **游戏部署目录**：
   ```text
   E:\Wuthering Waves\Wuthering Waves Game\Client\Binaries\Win64\
   ```
2. **部署文件清单**：
   - `renodx-wutheringwaves-CN.addon64`（核心插件，由 ReShade 自动加载）
   - `renodx-wutheringwaves-CN.pdb`（调试符号文件，供调试与分析）
3. **旧文件清理规范**：
   - 覆盖部署时直接覆写目标文件。
   - 彻底删除旧版未汉化文件（如 `renodx-wutheringwaves.addon64`），避免 ReShade 重复挂载两个同名 Addon 导致冲突。
   - 游戏目录内的旧文件不需要备份。

---

## 五、构建与版本发布记录 (Build Log)

> 每次云端构建与部署完成后，在此更新最新版本哈希与构建状态。

| 构建编号 | 构建时间 (UTC+8) | Git 提交 (Commit) | 产物大小 | SHA-256 哈希 | 说明与验收情况 |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Build #4** | 2026-10-24 23:25 | `2f2822c` (Discord 分支构建) | 10,023,424 B | `923CD61F48FA5416A96027714ACE9959F4322B6AB2509E7E9131587D67A1E16C` | **Discord 新架构汉化版 (2026.10.24)**：全量 230 条内嵌字典注入与 LEA 重定位；新增光线追踪分类（Lumen 增强、GT-VBAO 环境光遮蔽、Oren-Nayar 材质模型、光追阴影）、简洁界面模式、去色与转储 LUT 等完整中文，修复 About 页构建版本行，100% 验收通过 |
| **Build #3** | 2026-10-22 10:06 | `0493088` (已合并上游 `b6b32f4`) | 4,068,864 B | `6D4D2A6E089D9AC9658BF70763AFC267505D77D210BBB70B89C25611AD64DF18` | **最新完全体**：全量单层中文折叠栏（彻底消除分裂）、预设滑块中文、开关（开启/关闭）中文、资源升级全量中文，100% 验收通过 |
| **Build #2** | 2026-10-20 19:35 | `525c5c4` / `e7edb18` | 4,068,864 B | `F3E9010AFE6EF4984ED0FF7ADF468D214752050F4F7A7BBFAC7969886E0B4964` | 补全 Resource Upgrades 与折叠栏全量配置 |
| **Build #1** | 2026-10-20 19:20 | `9e7c99f` | 4,072,448 B | `92849787EB2B5F084CBFEFC61DA86F319AC14E46943228A305BE60E95BD50597` | 初次建立 GitHub Actions 云端专属极速构建流水线 |
