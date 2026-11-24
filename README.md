# 设备故障台账（iOS）

拍一张设备故障照片 → 自动弹出填写框 → 存进本地台账 → 一键导出 Excel / 图文报告。

- 平台：iOS 15 及以上，iPhone
- 数据：全部存在手机本地，不联网、不登录、不上传
- 安装：产出未签名 IPA，用巨魔（TrollStore）直接装

---

## 一、功能

| 功能 | 说明 |
| --- | --- |
| 拍照即录 | 点右上角相机 → 系统相机 → 拍完自动弹出填写框 |
| 字段 | 设备名称、位置/工位、故障类型、紧急程度、问题描述 |
| 台账 | 列表倒序展示，缩略图 + 状态标签，点一条可编辑 |
| 状态跟进 | 长按一条 → 切换 待处理 / 处理中 / 已修复 |
| 删除 | 左滑删除（照片一并清理） |
| 导出 CSV | 带 BOM，Excel / WPS 打开中文不乱码，可再另存 xlsx |
| 导出图文报告 | 单个 HTML，照片内嵌，发给客户/维修直接看 |

---

## 二、自动打包（GitHub Actions）

仓库里已经配好了 `.github/workflows/build.yml`，往 `main` 分支推代码就会自动编译并打未签名 IPA。

- 产物一：Actions 页面底部 **Artifacts** 下载 `FaultLog-ipa`（需登录）
- 产物二：**Releases** 页面的 `v1.0` 直接下 `FaultLog.ipa`（公开仓库可匿名下载）

macOS 14 runner + XcodeGen，`CODE_SIGNING_ALLOWED=NO` 编译，产出就是未签名包。

---

## 三、用巨魔安装

1. 把 `FaultLog.ipa` 传到手机（微信文件助手 / 隔空投送 / iCloud 文件都行）。
2. 打开 TrollStore → 右上角 `+` → 选择这个 IPA → `Install`。
3. 回桌面看到「故障台账」图标即可。
4. 首次打开点相机时，系统会弹权限，选「允许」。

> TrollStore 需要的是**未签名 IPA**，本工程用 `CODE_SIGNING_ALLOWED=NO` 编译，正好符合。
> 如果装完打开闪退，多半是 iOS 版本低于 15。

---

## 四、有 Mac 的话（更省事）

```bash
brew install xcodegen
xcodegen generate
open FaultLog.xcodeproj
```

Xcode 里选 `Any iOS Device (arm64)` → `Product > Archive` → `Distribute App > Custom > Export`，导出的就是 IPA。

只在自己手机上跑的话，连数据线用 Xcode 直接 Run 也行，不用打包。

---

## 五、改东西的位置

| 想改什么 | 改哪个文件 |
| --- | --- |
| 故障类型、紧急程度的选项 | `Sources/Models/FaultRecord.swift` 里的 `FaultCatalog` |
| 表格导出的列名和顺序 | `Sources/Models/FaultStore.swift` → `exportCSV()` |
| 界面布局、列表样式 | `Sources/Views/ContentView.swift` |
| 填写表单的字段 | `Sources/Views/RecordEditorView.swift` |
| App 名称 | `project.yml` 里的 `CFBundleDisplayName` |
| App 图标 | `Sources/Assets.xcassets/AppIcon.appiconset/AppIcon-1024.png`（1024×1024 不透明 PNG） |
| 包名（多版本共存） | `project.yml` 里的 `PRODUCT_BUNDLE_IDENTIFIER` |

改完重新跑一次 Actions 就出新 IPA。

---

## 六、数据在哪、怎么备份

- 记录存在 App 沙盒 `Documents/fault_records.json`
- 照片存在 `Documents/fault_*.jpg`
- 想整体备份：用「文件」App 进入 App 的文件夹拷出来，或者在 App 里导出 CSV + 图文报告
- **卸载 App 会连同数据一起删除**，重要的东西先导出再卸载

---

## 七、目录结构

```
.
├── project.yml                    # XcodeGen 工程描述
├── .github/workflows/build.yml    # 自动打包未签名 IPA
├── tools/fallback_icon.py         # 图标拉取失败时的备用绘制
├── Support/                       # 生成的 Info.plist 放这里（xcodegen 自动写）
└── Sources/
    ├── FaultLogApp.swift          # App 入口
    ├── Models/
    │   ├── FaultRecord.swift      # 数据模型 + 选项目录
    │   └── FaultStore.swift       # 本地存储 + 照片 + CSV/HTML 导出
    ├── Support/
    │   └── UIImage+Resize.swift   # 图片压缩（最长边 1600）
    ├── Views/
    │   ├── ContentView.swift      # 列表 + 相机入口 + 导出
    │   ├── RecordEditorView.swift # 填写/编辑表单
    │   └── CameraPicker.swift     # 相机 + 分享面板封装
    └── Assets.xcassets/           # App 图标
```
