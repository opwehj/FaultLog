# 构建说明

- 本仓库已公开，GitHub Actions 对公开仓库免费，无需担心额度。
- 每次推送到 `main` 自动编译并产出未签名 IPA。
- 构建结果会写回仓库根目录的 `ci-report.md`（含编译日志尾部和公开镜像下载地址）。
- 若 Actions 没有自动跑：仓库的 Actions 页 → `Build Unsigned IPA` → `Run workflow`。
