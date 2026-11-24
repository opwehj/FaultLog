# CI 构建报告

- 时间（UTC）：2026-11-24 08:58:56
- 任务结果：success
- 运行器：macos-15-intel
- IPA 大小（字节）：1085864
- 公开镜像地址：https://tmpfiles.org/dl/wDAJjx4K2eU1/faultlog.ipa
- 最近提交：b98aad8

## 编译日志尾部

```
Command line invocation:
    /Applications/Xcode_16.4.app/Contents/Developer/usr/bin/xcodebuild -project FaultLog.xcodeproj -scheme FaultLog -configuration Release -sdk iphoneos -derivedDataPath build CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO CODE_SIGN_IDENTITY= CODE_SIGN_ENTITLEMENTS= build

Build settings from command line:
    CODE_SIGN_ENTITLEMENTS = 
    CODE_SIGN_IDENTITY = 
    CODE_SIGNING_ALLOWED = NO
    CODE_SIGNING_REQUIRED = NO
    SDKROOT = iphoneos18.5

--- xcodebuild: WARNING: Using the first of multiple matching destinations:
{ platform:iOS, id:dvtdevice-DVTiPhonePlaceholder-iphoneos:placeholder, name:Any iOS Device }
{ platform:iOS Simulator, id:dvtdevice-DVTiOSDeviceSimulatorPlaceholder-iphonesimulator:placeholder, name:Any iOS Simulator Device }
note: Using codesigning identity override: 
ComputePackagePrebuildTargetDependencyGraph

Prepare packages

CreateBuildRequest

SendProjectDescription

CreateBuildOperation

ComputeTargetDependencyGraph
note: Building targets in dependency order
note: Target dependency graph (1 target)
    Target 'FaultLog' in project 'FaultLog' (no dependencies)

GatherProvisioningInputs

CreateBuildDescription

ExecuteExternalTool /Applications/Xcode_16.4.app/Contents/Developer/usr/bin/actool --print-asset-tag-combinations --output-format xml1 /Users/runner/work/FaultLog/FaultLog/Sources/Assets.xcassets

ExecuteExternalTool /Applications/Xcode_16.4.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -v -E -dM -isysroot /Applications/Xcode_16.4.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS18.5.sdk -x c -c /dev/null

ExecuteExternalTool /Applications/Xcode_16.4.app/Contents/Developer/usr/bin/actool --version --output-format xml1

ExecuteExternalTool /Applications/Xcode_16.4.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/swiftc --version

ExecuteExternalTool /Applications/Xcode_16.4.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ld -version_details

Build description signature: fc2e094ce52e75a9cc13a80b7c0a803d
Build description path: /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/XCBuildData/fc2e094ce52e75a9cc13a80b7c0a803d.xcbuilddata
CreateBuildDirectory /Users/runner/work/FaultLog/FaultLog/build/Build/Products
    cd /Users/runner/work/FaultLog/FaultLog/FaultLog.xcodeproj
    builtin-create-build-directory /Users/runner/work/FaultLog/FaultLog/build/Build/Products

ClangStatCache /Applications/Xcode_16.4.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang-stat-cache /Applications/Xcode_16.4.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS18.5.sdk /Users/runner/work/FaultLog/FaultLog/build/SDKStatCaches.noindex/iphoneos18.5-22F76-a529daf784b3616c7c04a36aeb7f5c05.sdkstatcache
    cd /Users/runner/work/FaultLog/FaultLog/FaultLog.xcodeproj
    /Applications/Xcode_16.4.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang-stat-cache /Applications/Xcode_16.4.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS18.5.sdk -o /Users/runner/work/FaultLog/FaultLog/build/SDKStatCaches.noindex/iphoneos18.5-22F76-a529daf784b3616c7c04a36aeb7f5c05.sdkstatcache

CreateBuildDirectory /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex
    cd /Users/runner/work/FaultLog/FaultLog/FaultLog.xcodeproj
    builtin-create-build-directory /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex

WriteAuxiliaryFile /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog-203f269517ffe5b3391783da2b894c19-VFS-iphoneos/all-product-headers.yaml
    cd /Users/runner/work/FaultLog/FaultLog/FaultLog.xcodeproj
    write-file /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog-203f269517ffe5b3391783da2b894c19-VFS-iphoneos/all-product-headers.yaml

CreateBuildDirectory /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos
    cd /Users/runner/work/FaultLog/FaultLog/FaultLog.xcodeproj
    builtin-create-build-directory /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos

CreateBuildDirectory /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/EagerLinkingTBDs/Release-iphoneos
    cd /Users/runner/work/FaultLog/FaultLog/FaultLog.xcodeproj
    builtin-create-build-directory /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/EagerLinkingTBDs/Release-iphoneos

WriteAuxiliaryFile /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/FaultLog.SwiftFileList (in target 'FaultLog' from project 'FaultLog')
    cd /Users/runner/work/FaultLog/FaultLog
    write-file /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/FaultLog.SwiftFileList

WriteAuxiliaryFile /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/FaultLog.SwiftConstValuesFileList (in target 'FaultLog' from project 'FaultLog')
    cd /Users/runner/work/FaultLog/FaultLog
    write-file /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/FaultLog.SwiftConstValuesFileList

WriteAuxiliaryFile /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/FaultLog_const_extract_protocols.json (in target 'FaultLog' from project 'FaultLog')
    cd /Users/runner/work/FaultLog/FaultLog
    write-file /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/FaultLog_const_extract_protocols.json

WriteAuxiliaryFile /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/FaultLog.LinkFileList (in target 'FaultLog' from project 'FaultLog')
    cd /Users/runner/work/FaultLog/FaultLog
    write-file /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/FaultLog.LinkFileList

WriteAuxiliaryFile /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/FaultLog-OutputFileMap.json (in target 'FaultLog' from project 'FaultLog')
    cd /Users/runner/work/FaultLog/FaultLog
    write-file /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/FaultLog-OutputFileMap.json

WriteAuxiliaryFile /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/FaultLog.hmap (in target 'FaultLog' from project 'FaultLog')
    cd /Users/runner/work/FaultLog/FaultLog
    write-file /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/FaultLog.hmap

WriteAuxiliaryFile /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/FaultLog.DependencyStaticMetadataFileList (in target 'FaultLog' from project 'FaultLog')
    cd /Users/runner/work/FaultLog/FaultLog
    write-file /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/FaultLog.DependencyStaticMetadataFileList

WriteAuxiliaryFile /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/FaultLog.DependencyMetadataFileList (in target 'FaultLog' from project 'FaultLog')
    cd /Users/runner/work/FaultLog/FaultLog
    write-file /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/FaultLog.DependencyMetadataFileList

WriteAuxiliaryFile /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/FaultLog-project-headers.hmap (in target 'FaultLog' from project 'FaultLog')
    cd /Users/runner/work/FaultLog/FaultLog
    write-file /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/FaultLog-project-headers.hmap

WriteAuxiliaryFile /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/FaultLog-own-target-headers.hmap (in target 'FaultLog' from project 'FaultLog')
    cd /Users/runner/work/FaultLog/FaultLog
    write-file /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/FaultLog-own-target-headers.hmap

WriteAuxiliaryFile /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/FaultLog-generated-files.hmap (in target 'FaultLog' from project 'FaultLog')
    cd /Users/runner/work/FaultLog/FaultLog
    write-file /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/FaultLog-generated-files.hmap

WriteAuxiliaryFile /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/FaultLog-all-target-headers.hmap (in target 'FaultLog' from project 'FaultLog')
    cd /Users/runner/work/FaultLog/FaultLog
    write-file /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/FaultLog-all-target-headers.hmap

WriteAuxiliaryFile /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/FaultLog-all-non-framework-target-headers.hmap (in target 'FaultLog' from project 'FaultLog')
    cd /Users/runner/work/FaultLog/FaultLog
    write-file /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/FaultLog-all-non-framework-target-headers.hmap

MkDir /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos/FaultLog.app (in target 'FaultLog' from project 'FaultLog')
    cd /Users/runner/work/FaultLog/FaultLog
    /bin/mkdir -p /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos/FaultLog.app

MkDir /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/assetcatalog_output/thinned (in target 'FaultLog' from project 'FaultLog')
    cd /Users/runner/work/FaultLog/FaultLog
    /bin/mkdir -p /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/assetcatalog_output/thinned

MkDir /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/assetcatalog_output/unthinned (in target 'FaultLog' from project 'FaultLog')
    cd /Users/runner/work/FaultLog/FaultLog
    /bin/mkdir -p /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/assetcatalog_output/unthinned

GenerateAssetSymbols /Users/runner/work/FaultLog/FaultLog/Sources/Assets.xcassets (in target 'FaultLog' from project 'FaultLog')
    cd /Users/runner/work/FaultLog/FaultLog
    /Applications/Xcode_16.4.app/Contents/Developer/usr/bin/actool /Users/runner/work/FaultLog/FaultLog/Sources/Assets.xcassets --compile /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos/FaultLog.app --output-format human-readable-text --notices --warnings --export-dependency-info /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/assetcatalog_dependencies --output-partial-info-plist /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/assetcatalog_generated_info.plist --app-icon AppIcon --compress-pngs --enable-on-demand-resources YES --development-region en --target-device iphone --minimum-deployment-target 15.0 --platform iphoneos --bundle-identifier com.doubao.faultlog --generate-swift-asset-symbol-extensions NO --generate-swift-asset-symbols /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/DerivedSources/GeneratedAssetSymbols.swift --generate-objc-asset-symbols /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/DerivedSources/GeneratedAssetSymbols.h --generate-asset-symbol-index /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/DerivedSources/GeneratedAssetSymbols-Index.plist
/* com.apple.actool.compilation-results */
/Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/DerivedSources/GeneratedAssetSymbols-Index.plist
/Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/DerivedSources/GeneratedAssetSymbols.h
/Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/DerivedSources/GeneratedAssetSymbols.swift


CompileAssetCatalogVariant thinned /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos/FaultLog.app /Users/runner/work/FaultLog/FaultLog/Sources/Assets.xcassets (in target 'FaultLog' from project 'FaultLog')
    cd /Users/runner/work/FaultLog/FaultLog
    /Applications/Xcode_16.4.app/Contents/Developer/usr/bin/actool /Users/runner/work/FaultLog/FaultLog/Sources/Assets.xcassets --compile /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/assetcatalog_output/thinned --output-format human-readable-text --notices --warnings --export-dependency-info /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/assetcatalog_dependencies_thinned --output-partial-info-plist /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/assetcatalog_generated_info.plist_thinned --app-icon AppIcon --compress-pngs --enable-on-demand-resources YES --development-region en --target-device iphone --minimum-deployment-target 15.0 --platform iphoneos
/* com.apple.actool.compilation-results */
/Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/assetcatalog_generated_info.plist_thinned
/Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/assetcatalog_output/thinned/AppIcon60x60@2x.png
/Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/assetcatalog_output/thinned/AppIcon76x76@2x~ipad.png
/Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/assetcatalog_output/thinned/Assets.car


SwiftDriver FaultLog normal arm64 com.apple.xcode.tools.swift.compiler (in target 'FaultLog' from project 'FaultLog')
    cd /Users/runner/work/FaultLog/FaultLog
    builtin-SwiftDriver -- /Applications/Xcode_16.4.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/swiftc -module-name FaultLog -O -whole-module-optimization -enforce-exclusivity\=checked @/Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/FaultLog.SwiftFileList -enable-bare-slash-regex -enable-experimental-feature DebugDescriptionMacro -sdk /Applications/Xcode_16.4.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS18.5.sdk -target arm64-apple-ios15.0 -g -module-cache-path /Users/runner/work/FaultLog/FaultLog/build/ModuleCache.noindex -Xfrontend -serialize-debugging-options -swift-version 5 -I /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos -F /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos -c -num-threads 4 -Xcc -ivfsstatcache -Xcc /Users/runner/work/FaultLog/FaultLog/build/SDKStatCaches.noindex/iphoneos18.5-22F76-a529daf784b3616c7c04a36aeb7f5c05.sdkstatcache -output-file-map /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/FaultLog-OutputFileMap.json -use-frontend-parseable-output -save-temps -no-color-diagnostics -serialize-diagnostics -emit-dependencies -emit-module -emit-module-path /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/FaultLog.swiftmodule -validate-clang-modules-once -clang-build-session-file /Users/runner/work/FaultLog/FaultLog/build/ModuleCache.noindex/Session.modulevalidation -Xcc -I/Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/swift-overrides.hmap -emit-const-values -Xfrontend -const-gather-protocols-file -Xfrontend /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/FaultLog_const_extract_protocols.json -Xcc -iquote -Xcc /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/FaultLog-generated-files.hmap -Xcc -I/Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/FaultLog-own-target-headers.hmap -Xcc -I/Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/FaultLog-all-target-headers.hmap -Xcc -iquote -Xcc /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/FaultLog-project-headers.hmap -Xcc -I/Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos/include -Xcc -I/Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/DerivedSources-normal/arm64 -Xcc -I/Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/DerivedSources/arm64 -Xcc -I/Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/DerivedSources -emit-objc-header -emit-objc-header-path /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/FaultLog-Swift.h -working-directory /Users/runner/work/FaultLog/FaultLog -no-emit-module-separately-wmo

SwiftDriver\ Compilation FaultLog normal arm64 com.apple.xcode.tools.swift.compiler (in target 'FaultLog' from project 'FaultLog')
    cd /Users/runner/work/FaultLog/FaultLog
    builtin-Swift-Compilation -- /Applications/Xcode_16.4.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/swiftc -module-name FaultLog -O -whole-module-optimization -enforce-exclusivity\=checked @/Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/FaultLog.SwiftFileList -enable-bare-slash-regex -enable-experimental-feature DebugDescriptionMacro -sdk /Applications/Xcode_16.4.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS18.5.sdk -target arm64-apple-ios15.0 -g -module-cache-path /Users/runner/work/FaultLog/FaultLog/build/ModuleCache.noindex -Xfrontend -serialize-debugging-options -swift-version 5 -I /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos -F /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos -c -num-threads 4 -Xcc -ivfsstatcache -Xcc /Users/runner/work/FaultLog/FaultLog/build/SDKStatCaches.noindex/iphoneos18.5-22F76-a529daf784b3616c7c04a36aeb7f5c05.sdkstatcache -output-file-map /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/FaultLog-OutputFileMap.json -use-frontend-parseable-output -save-temps -no-color-diagnostics -serialize-diagnostics -emit-dependencies -emit-module -emit-module-path /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/FaultLog.swiftmodule -validate-clang-modules-once -clang-build-session-file /Users/runner/work/FaultLog/FaultLog/build/ModuleCache.noindex/Session.modulevalidation -Xcc -I/Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/swift-overrides.hmap -emit-const-values -Xfrontend -const-gather-protocols-file -Xfrontend /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/FaultLog_const_extract_protocols.json -Xcc -iquote -Xcc /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/FaultLog-generated-files.hmap -Xcc -I/Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/FaultLog-own-target-headers.hmap -Xcc -I/Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/FaultLog-all-target-headers.hmap -Xcc -iquote -Xcc /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/FaultLog-project-headers.hmap -Xcc -I/Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos/include -Xcc -I/Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/DerivedSources-normal/arm64 -Xcc -I/Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/DerivedSources/arm64 -Xcc -I/Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/DerivedSources -emit-objc-header -emit-objc-header-path /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/FaultLog-Swift.h -working-directory /Users/runner/work/FaultLog/FaultLog -no-emit-module-separately-wmo

SwiftCompile normal arm64 Compiling\ CameraPicker.swift,\ ContentView.swift,\ FaultLogApp.swift,\ FaultRecord.swift,\ FaultStore.swift,\ RecordEditorView.swift,\ UIImage+Resize.swift,\ GeneratedAssetSymbols.swift /Users/runner/work/FaultLog/FaultLog/Sources/Views/CameraPicker.swift /Users/runner/work/FaultLog/FaultLog/Sources/Views/ContentView.swift /Users/runner/work/FaultLog/FaultLog/Sources/FaultLogApp.swift /Users/runner/work/FaultLog/FaultLog/Sources/Models/FaultRecord.swift /Users/runner/work/FaultLog/FaultLog/Sources/Models/FaultStore.swift /Users/runner/work/FaultLog/FaultLog/Sources/Views/RecordEditorView.swift /Users/runner/work/FaultLog/FaultLog/Sources/Support/UIImage+Resize.swift /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/DerivedSources/GeneratedAssetSymbols.swift (in target 'FaultLog' from project 'FaultLog')

CompileSwift normal arm64 (in target 'FaultLog' from project 'FaultLog')
    cd /Users/runner/work/FaultLog/FaultLog
    

SwiftDriverJobDiscovery normal arm64 Compiling CameraPicker.swift, ContentView.swift, FaultLogApp.swift, FaultRecord.swift, FaultStore.swift, RecordEditorView.swift, UIImage+Resize.swift, GeneratedAssetSymbols.swift (in target 'FaultLog' from project 'FaultLog')

SwiftDriver\ Compilation\ Requirements FaultLog normal arm64 com.apple.xcode.tools.swift.compiler (in target 'FaultLog' from project 'FaultLog')
    cd /Users/runner/work/FaultLog/FaultLog
    builtin-Swift-Compilation-Requirements -- /Applications/Xcode_16.4.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/swiftc -module-name FaultLog -O -whole-module-optimization -enforce-exclusivity\=checked @/Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/FaultLog.SwiftFileList -enable-bare-slash-regex -enable-experimental-feature DebugDescriptionMacro -sdk /Applications/Xcode_16.4.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS18.5.sdk -target arm64-apple-ios15.0 -g -module-cache-path /Users/runner/work/FaultLog/FaultLog/build/ModuleCache.noindex -Xfrontend -serialize-debugging-options -swift-version 5 -I /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos -F /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos -c -num-threads 4 -Xcc -ivfsstatcache -Xcc /Users/runner/work/FaultLog/FaultLog/build/SDKStatCaches.noindex/iphoneos18.5-22F76-a529daf784b3616c7c04a36aeb7f5c05.sdkstatcache -output-file-map /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/FaultLog-OutputFileMap.json -use-frontend-parseable-output -save-temps -no-color-diagnostics -serialize-diagnostics -emit-dependencies -emit-module -emit-module-path /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/FaultLog.swiftmodule -validate-clang-modules-once -clang-build-session-file /Users/runner/work/FaultLog/FaultLog/build/ModuleCache.noindex/Session.modulevalidation -Xcc -I/Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/swift-overrides.hmap -emit-const-values -Xfrontend -const-gather-protocols-file -Xfrontend /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/FaultLog_const_extract_protocols.json -Xcc -iquote -Xcc /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/FaultLog-generated-files.hmap -Xcc -I/Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/FaultLog-own-target-headers.hmap -Xcc -I/Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/FaultLog-all-target-headers.hmap -Xcc -iquote -Xcc /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/FaultLog-project-headers.hmap -Xcc -I/Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos/include -Xcc -I/Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/DerivedSources-normal/arm64 -Xcc -I/Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/DerivedSources/arm64 -Xcc -I/Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/DerivedSources -emit-objc-header -emit-objc-header-path /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/FaultLog-Swift.h -working-directory /Users/runner/work/FaultLog/FaultLog -no-emit-module-separately-wmo

SwiftMergeGeneratedHeaders /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/DerivedSources/FaultLog-Swift.h /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/FaultLog-Swift.h (in target 'FaultLog' from project 'FaultLog')
    cd /Users/runner/work/FaultLog/FaultLog
    builtin-swiftHeaderTool -arch arm64 /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/FaultLog-Swift.h -o /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/DerivedSources/FaultLog-Swift.h

Copy /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos/FaultLog.swiftmodule/arm64-apple-ios.swiftdoc /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/FaultLog.swiftdoc (in target 'FaultLog' from project 'FaultLog')
    cd /Users/runner/work/FaultLog/FaultLog
    builtin-copy -exclude .DS_Store -exclude CVS -exclude .svn -exclude .git -exclude .hg -resolve-src-symlinks -rename /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/FaultLog.swiftdoc /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos/FaultLog.swiftmodule/arm64-apple-ios.swiftdoc

Copy /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos/FaultLog.swiftmodule/arm64-apple-ios.swiftmodule /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/FaultLog.swiftmodule (in target 'FaultLog' from project 'FaultLog')
    cd /Users/runner/work/FaultLog/FaultLog
    builtin-copy -exclude .DS_Store -exclude CVS -exclude .svn -exclude .git -exclude .hg -resolve-src-symlinks -rename /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/FaultLog.swiftmodule /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos/FaultLog.swiftmodule/arm64-apple-ios.swiftmodule

Copy /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos/FaultLog.swiftmodule/arm64-apple-ios.abi.json /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/FaultLog.abi.json (in target 'FaultLog' from project 'FaultLog')
    cd /Users/runner/work/FaultLog/FaultLog
    builtin-copy -exclude .DS_Store -exclude CVS -exclude .svn -exclude .git -exclude .hg -resolve-src-symlinks -rename /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/FaultLog.abi.json /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos/FaultLog.swiftmodule/arm64-apple-ios.abi.json

Copy /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos/FaultLog.swiftmodule/Project/arm64-apple-ios.swiftsourceinfo /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/FaultLog.swiftsourceinfo (in target 'FaultLog' from project 'FaultLog')
    cd /Users/runner/work/FaultLog/FaultLog
    builtin-copy -exclude .DS_Store -exclude CVS -exclude .svn -exclude .git -exclude .hg -resolve-src-symlinks -rename /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/FaultLog.swiftsourceinfo /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos/FaultLog.swiftmodule/Project/arm64-apple-ios.swiftsourceinfo

Ld /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos/FaultLog.app/FaultLog normal (in target 'FaultLog' from project 'FaultLog')
    cd /Users/runner/work/FaultLog/FaultLog
    /Applications/Xcode_16.4.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -Xlinker -reproducible -target arm64-apple-ios15.0 -isysroot /Applications/Xcode_16.4.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS18.5.sdk -Os -L/Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/EagerLinkingTBDs/Release-iphoneos -L/Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos -F/Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/EagerLinkingTBDs/Release-iphoneos -F/Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos -filelist /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/FaultLog.LinkFileList -Xlinker -rpath -Xlinker @executable_path/Frameworks -dead_strip -Xlinker -object_path_lto -Xlinker /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/FaultLog_lto.o -Xlinker -dependency_info -Xlinker /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/FaultLog_dependency_info.dat -fobjc-link-runtime -L/Applications/Xcode_16.4.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos -L/usr/lib/swift -Xlinker -add_ast_path -Xlinker /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/FaultLog.swiftmodule -o /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos/FaultLog.app/FaultLog

LinkAssetCatalog /Users/runner/work/FaultLog/FaultLog/Sources/Assets.xcassets (in target 'FaultLog' from project 'FaultLog')
    cd /Users/runner/work/FaultLog/FaultLog
    builtin-linkAssetCatalog --thinned /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/assetcatalog_output/thinned --thinned-dependencies /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/assetcatalog_dependencies_thinned --thinned-info-plist-content /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/assetcatalog_generated_info.plist_thinned --unthinned /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/assetcatalog_output/unthinned --unthinned-dependencies /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/assetcatalog_dependencies_unthinned --unthinned-info-plist-content /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/assetcatalog_generated_info.plist_unthinned --output /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos/FaultLog.app --plist-output /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/assetcatalog_generated_info.plist
note: Emplaced /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos/FaultLog.app/Assets.car (in target 'FaultLog' from project 'FaultLog')
note: Emplaced /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos/FaultLog.app/AppIcon60x60@2x.png (in target 'FaultLog' from project 'FaultLog')
note: Emplaced /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos/FaultLog.app/AppIcon76x76@2x~ipad.png (in target 'FaultLog' from project 'FaultLog')

ProcessInfoPlistFile /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos/FaultLog.app/Info.plist /Users/runner/work/FaultLog/FaultLog/Support/Info.plist (in target 'FaultLog' from project 'FaultLog')
    cd /Users/runner/work/FaultLog/FaultLog
    builtin-infoPlistUtility /Users/runner/work/FaultLog/FaultLog/Support/Info.plist -producttype com.apple.product-type.application -genpkginfo /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos/FaultLog.app/PkgInfo -expandbuildsettings -format binary -platform iphoneos -additionalcontentfile /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/assetcatalog_generated_info.plist -requiredArchitecture arm64 -o /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos/FaultLog.app/Info.plist

ExtractAppIntentsMetadata (in target 'FaultLog' from project 'FaultLog')
    cd /Users/runner/work/FaultLog/FaultLog
    /Applications/Xcode_16.4.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/appintentsmetadataprocessor --toolchain-dir /Applications/Xcode_16.4.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain --module-name FaultLog --sdk-root /Applications/Xcode_16.4.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS18.5.sdk --xcode-version 16F6 --platform-family iOS --deployment-target 15.0 --bundle-identifier com.doubao.faultlog --output /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos/FaultLog.app --target-triple arm64-apple-ios15.0 --binary-file /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos/FaultLog.app/FaultLog --dependency-file /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/FaultLog_dependency_info.dat --stringsdata-file /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/ExtractedAppShortcutsMetadata.stringsdata --source-file-list /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/FaultLog.SwiftFileList --metadata-file-list /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/FaultLog.DependencyMetadataFileList --static-metadata-file-list /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/FaultLog.DependencyStaticMetadataFileList --swift-const-vals-list /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/FaultLog.SwiftConstValuesFileList --compile-time-extraction --deployment-aware-processing --validate-assistant-intents --no-app-shortcuts-localization
2026-11-24 08:58:44.152 appintentsmetadataprocessor[9631:29236] Starting appintentsmetadataprocessor export
2026-11-24 08:58:44.211 appintentsmetadataprocessor[9631:29236] warning: Metadata extraction skipped. No AppIntents.framework dependency found.

CopySwiftLibs /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos/FaultLog.app (in target 'FaultLog' from project 'FaultLog')
    cd /Users/runner/work/FaultLog/FaultLog
    builtin-swiftStdLibTool --copy --verbose --scan-executable /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos/FaultLog.app/FaultLog --scan-folder /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos/FaultLog.app/Frameworks --scan-folder /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos/FaultLog.app/PlugIns --scan-folder /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos/FaultLog.app/SystemExtensions --scan-folder /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos/FaultLog.app/Extensions --platform iphoneos --toolchain /Applications/Xcode_16.4.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain --destination /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos/FaultLog.app/Frameworks --strip-bitcode --strip-bitcode-tool /Applications/Xcode_16.4.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/bitcode_strip --emit-dependency-info /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/SwiftStdLibToolInputDependencies.dep --filter-for-swift-os
Ignoring --strip-bitcode because --sign was not passed

GenerateDSYMFile /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos/FaultLog.app.dSYM /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos/FaultLog.app/FaultLog (in target 'FaultLog' from project 'FaultLog')
    cd /Users/runner/work/FaultLog/FaultLog
    /Applications/Xcode_16.4.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/dsymutil /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos/FaultLog.app/FaultLog -o /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos/FaultLog.app.dSYM

AppIntentsSSUTraining (in target 'FaultLog' from project 'FaultLog')
    cd /Users/runner/work/FaultLog/FaultLog
    /Applications/Xcode_16.4.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/appintentsnltrainingprocessor --infoplist-path /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos/FaultLog.app/Info.plist --temp-dir-path /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/ssu --bundle-id com.doubao.faultlog --product-path /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos/FaultLog.app --extracted-metadata-path /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos/FaultLog.app/Metadata.appintents --metadata-file-list /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/FaultLog.DependencyMetadataFileList --archive-ssu-assets
2026-11-24 08:58:44.602 appintentsnltrainingprocessor[9634:29245] Parsing options for appintentsnltrainingprocessor
2026-11-24 08:58:44.609 appintentsnltrainingprocessor[9634:29245] No AppShortcuts found - Skipping.

RegisterExecutionPolicyException /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos/FaultLog.app (in target 'FaultLog' from project 'FaultLog')
    cd /Users/runner/work/FaultLog/FaultLog
    builtin-RegisterExecutionPolicyException /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos/FaultLog.app

Validate /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos/FaultLog.app (in target 'FaultLog' from project 'FaultLog')
    cd /Users/runner/work/FaultLog/FaultLog
    builtin-validationUtility /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos/FaultLog.app -infoplist-subpath Info.plist

Touch /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos/FaultLog.app (in target 'FaultLog' from project 'FaultLog')
    cd /Users/runner/work/FaultLog/FaultLog
    /usr/bin/touch -c /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos/FaultLog.app

note: Disabling previews because SWIFT_VERSION is set and SWIFT_OPTIMIZATION_LEVEL=-O, expected -Onone (in target 'FaultLog' from project 'FaultLog')
** BUILD SUCCEEDED **

```
