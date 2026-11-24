# CI 构建报告

- 时间（UTC）：2026-11-24 09:17:29
- 任务结果：failure
- 运行器：macos-15-intel
- IPA 大小（字节）：0
- 公开镜像地址：（未获得）

## 编译错误（前 60 条）

```
173:/Users/runner/work/FaultLog/FaultLog/Sources/Views/KanbanView.swift:96:39: error: incorrect argument labels in call (have 'white:alpha:', expected '_:white:opacity:')
177:/Users/runner/work/FaultLog/FaultLog/Sources/Views/KanbanView.swift:96:59: error: cannot convert value of type 'Int' to expected argument type 'Color.RGBColorSpace'
180:/Users/runner/work/FaultLog/FaultLog/Sources/Views/RecordListView.swift:350:47: error: incorrect argument labels in call (have 'white:alpha:', expected '_:white:opacity:')
184:/Users/runner/work/FaultLog/FaultLog/Sources/Views/RecordListView.swift:350:68: error: cannot convert value of type 'Int' to expected argument type 'Color.RGBColorSpace'
187:/Users/runner/work/FaultLog/FaultLog/Sources/Views/RecordListView.swift:379:9: error: generic parameter 'V' could not be inferred
193:/Users/runner/work/FaultLog/FaultLog/Sources/Views/StatsView.swift:90:24: error: incorrect argument labels in call (have 'white:alpha:', expected '_:white:opacity:')
197:/Users/runner/work/FaultLog/FaultLog/Sources/Views/StatsView.swift:90:45: error: cannot convert value of type 'Int' to expected argument type 'Color.RGBColorSpace'
200:/Users/runner/work/FaultLog/FaultLog/Sources/Views/Theme.swift:58:29: error: incorrect argument labels in call (have 'white:alpha:', expected '_:white:opacity:')
204:/Users/runner/work/FaultLog/FaultLog/Sources/Views/Theme.swift:58:50: error: cannot convert value of type 'Int' to expected argument type 'Color.RGBColorSpace'
207:/Users/runner/work/FaultLog/FaultLog/Sources/Views/Theme.swift:31:30: error: incorrect argument labels in call (have 'white:alpha:', expected '_:white:opacity:')
211:/Users/runner/work/FaultLog/FaultLog/Sources/Views/Theme.swift:31:51: error: cannot convert value of type 'Int' to expected argument type 'Color.RGBColorSpace'
214:/Users/runner/work/FaultLog/FaultLog/Sources/Views/Theme.swift:93:36: error: incorrect argument labels in call (have 'white:alpha:', expected '_:white:opacity:')
218:/Users/runner/work/FaultLog/FaultLog/Sources/Views/Theme.swift:93:57: error: cannot convert value of type 'Int' to expected argument type 'Color.RGBColorSpace'
```

## 警告（前 20 条）

```
165:/Users/runner/work/FaultLog/FaultLog/Sources/Support/ImageUtils.swift:50:17: warning: immutable value 'attrs' was never used; consider replacing with '_' or removing it
169:/Users/runner/work/FaultLog/FaultLog/Sources/Support/ImageUtils.swift:75:13: warning: initialization of immutable value 'titleFont' was never used; consider replacing with assignment to '_' or removing it
```

## 日志尾部（400 行）

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

ExecuteExternalTool /Applications/Xcode_16.4.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -v -E -dM -isysroot /Applications/Xcode_16.4.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS18.5.sdk -x c -c /dev/null

ExecuteExternalTool /Applications/Xcode_16.4.app/Contents/Developer/usr/bin/actool --print-asset-tag-combinations --output-format xml1 /Users/runner/work/FaultLog/FaultLog/Sources/Assets.xcassets

ExecuteExternalTool /Applications/Xcode_16.4.app/Contents/Developer/usr/bin/actool --version --output-format xml1

ExecuteExternalTool /Applications/Xcode_16.4.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/swiftc --version

ExecuteExternalTool /Applications/Xcode_16.4.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ld -version_details

Build description signature: 5e0866a9b078ef1bdb770bf3c52d3e7b
Build description path: /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/XCBuildData/5e0866a9b078ef1bdb770bf3c52d3e7b.xcbuilddata
ClangStatCache /Applications/Xcode_16.4.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang-stat-cache /Applications/Xcode_16.4.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS18.5.sdk /Users/runner/work/FaultLog/FaultLog/build/SDKStatCaches.noindex/iphoneos18.5-22F76-a529daf784b3616c7c04a36aeb7f5c05.sdkstatcache
    cd /Users/runner/work/FaultLog/FaultLog/FaultLog.xcodeproj
    /Applications/Xcode_16.4.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang-stat-cache /Applications/Xcode_16.4.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS18.5.sdk -o /Users/runner/work/FaultLog/FaultLog/build/SDKStatCaches.noindex/iphoneos18.5-22F76-a529daf784b3616c7c04a36aeb7f5c05.sdkstatcache

CreateBuildDirectory /Users/runner/work/FaultLog/FaultLog/build/Build/Products
    cd /Users/runner/work/FaultLog/FaultLog/FaultLog.xcodeproj
    builtin-create-build-directory /Users/runner/work/FaultLog/FaultLog/build/Build/Products

CreateBuildDirectory /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex
    cd /Users/runner/work/FaultLog/FaultLog/FaultLog.xcodeproj
    builtin-create-build-directory /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex

CreateBuildDirectory /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/EagerLinkingTBDs/Release-iphoneos
    cd /Users/runner/work/FaultLog/FaultLog/FaultLog.xcodeproj
    builtin-create-build-directory /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/EagerLinkingTBDs/Release-iphoneos

WriteAuxiliaryFile /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog-203f269517ffe5b3391783da2b894c19-VFS-iphoneos/all-product-headers.yaml
    cd /Users/runner/work/FaultLog/FaultLog/FaultLog.xcodeproj
    write-file /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog-203f269517ffe5b3391783da2b894c19-VFS-iphoneos/all-product-headers.yaml

CreateBuildDirectory /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos
    cd /Users/runner/work/FaultLog/FaultLog/FaultLog.xcodeproj
    builtin-create-build-directory /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos

WriteAuxiliaryFile /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/FaultLog_const_extract_protocols.json (in target 'FaultLog' from project 'FaultLog')
    cd /Users/runner/work/FaultLog/FaultLog
    write-file /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/FaultLog_const_extract_protocols.json

WriteAuxiliaryFile /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/FaultLog.SwiftFileList (in target 'FaultLog' from project 'FaultLog')
    cd /Users/runner/work/FaultLog/FaultLog
    write-file /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/FaultLog.SwiftFileList

WriteAuxiliaryFile /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/FaultLog.SwiftConstValuesFileList (in target 'FaultLog' from project 'FaultLog')
    cd /Users/runner/work/FaultLog/FaultLog
    write-file /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/FaultLog.SwiftConstValuesFileList

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

MkDir /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/assetcatalog_output/unthinned (in target 'FaultLog' from project 'FaultLog')
    cd /Users/runner/work/FaultLog/FaultLog
    /bin/mkdir -p /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/assetcatalog_output/unthinned

MkDir /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/assetcatalog_output/thinned (in target 'FaultLog' from project 'FaultLog')
    cd /Users/runner/work/FaultLog/FaultLog
    /bin/mkdir -p /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/assetcatalog_output/thinned

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

SwiftCompile normal arm64 Compiling\ AIService.swift,\ AppSettings.swift,\ CameraPicker.swift,\ ContentView.swift,\ ExportService.swift,\ FaultLogApp.swift,\ FaultRecord.swift,\ FaultStore.swift,\ ImageUtils.swift,\ KanbanView.swift,\ LocationService.swift,\ NotificationService.swift,\ OCRService.swift,\ PDFReport.swift,\ QRCodeMaker.swift,\ RecordEditorView.swift,\ RecordListView.swift,\ ScannerView.swift,\ SettingsView.swift,\ SpeechInput.swift,\ StatsView.swift,\ Theme.swift,\ UIImage+Resize.swift,\ WebhookService.swift,\ XLSXWriter.swift,\ ZipWriter.swift,\ GeneratedAssetSymbols.swift /Users/runner/work/FaultLog/FaultLog/Sources/Support/AIService.swift /Users/runner/work/FaultLog/FaultLog/Sources/Models/AppSettings.swift /Users/runner/work/FaultLog/FaultLog/Sources/Views/CameraPicker.swift /Users/runner/work/FaultLog/FaultLog/Sources/Views/ContentView.swift /Users/runner/work/FaultLog/FaultLog/Sources/Support/ExportService.swift /Users/runner/work/FaultLog/FaultLog/Sources/FaultLogApp.swift /Users/runner/work/FaultLog/FaultLog/Sources/Models/FaultRecord.swift /Users/runner/work/FaultLog/FaultLog/Sources/Models/FaultStore.swift /Users/runner/work/FaultLog/FaultLog/Sources/Support/ImageUtils.swift /Users/runner/work/FaultLog/FaultLog/Sources/Views/KanbanView.swift /Users/runner/work/FaultLog/FaultLog/Sources/Support/LocationService.swift /Users/runner/work/FaultLog/FaultLog/Sources/Support/NotificationService.swift /Users/runner/work/FaultLog/FaultLog/Sources/Support/OCRService.swift /Users/runner/work/FaultLog/FaultLog/Sources/Support/PDFReport.swift /Users/runner/work/FaultLog/FaultLog/Sources/Support/QRCodeMaker.swift /Users/runner/work/FaultLog/FaultLog/Sources/Views/RecordEditorView.swift /Users/runner/work/FaultLog/FaultLog/Sources/Views/RecordListView.swift /Users/runner/work/FaultLog/FaultLog/Sources/Views/ScannerView.swift /Users/runner/work/FaultLog/FaultLog/Sources/Views/SettingsView.swift /Users/runner/work/FaultLog/FaultLog/Sources/Support/SpeechInput.swift /Users/runner/work/FaultLog/FaultLog/Sources/Views/StatsView.swift /Users/runner/work/FaultLog/FaultLog/Sources/Views/Theme.swift /Users/runner/work/FaultLog/FaultLog/Sources/Support/UIImage+Resize.swift /Users/runner/work/FaultLog/FaultLog/Sources/Support/WebhookService.swift /Users/runner/work/FaultLog/FaultLog/Sources/Support/XLSXWriter.swift /Users/runner/work/FaultLog/FaultLog/Sources/Support/ZipWriter.swift /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/DerivedSources/GeneratedAssetSymbols.swift (in target 'FaultLog' from project 'FaultLog')
CompileSwift normal arm64 (in target 'FaultLog' from project 'FaultLog')
    cd /Users/runner/work/FaultLog/FaultLog
    
/Users/runner/work/FaultLog/FaultLog/Sources/Support/ImageUtils.swift:50:17: warning: immutable value 'attrs' was never used; consider replacing with '_' or removing it
            let attrs: [NSAttributedString.Key: Any] = [
                ^~~~~
                _
/Users/runner/work/FaultLog/FaultLog/Sources/Support/ImageUtils.swift:75:13: warning: initialization of immutable value 'titleFont' was never used; consider replacing with assignment to '_' or removing it
        let titleFont = UIFont.systemFont(ofSize: 46, weight: .bold)
        ~~~~^~~~~~~~~
        _
/Users/runner/work/FaultLog/FaultLog/Sources/Views/KanbanView.swift:96:39: error: incorrect argument labels in call (have 'white:alpha:', expected '_:white:opacity:')
                .foregroundColor(Color(white: 0.3, alpha: 1))
                                      ^~~~~~~~     ~~~~~
                                                   white
/Users/runner/work/FaultLog/FaultLog/Sources/Views/KanbanView.swift:96:59: error: cannot convert value of type 'Int' to expected argument type 'Color.RGBColorSpace'
                .foregroundColor(Color(white: 0.3, alpha: 1))
                                                          ^
/Users/runner/work/FaultLog/FaultLog/Sources/Views/RecordListView.swift:350:47: error: incorrect argument labels in call (have 'white:alpha:', expected '_:white:opacity:')
                        .foregroundColor(Color(white: 0.25, alpha: 1))
                                              ^~~~~~~~      ~~~~~
                                                            white
/Users/runner/work/FaultLog/FaultLog/Sources/Views/RecordListView.swift:350:68: error: cannot convert value of type 'Int' to expected argument type 'Color.RGBColorSpace'
                        .foregroundColor(Color(white: 0.25, alpha: 1))
                                                                   ^
/Users/runner/work/FaultLog/FaultLog/Sources/Views/RecordListView.swift:379:9: error: generic parameter 'V' could not be inferred
        Group {
        ^
SwiftUI.Group.init:2:8: note: in call to initializer
public init<V>(@TabContentBuilder<V> content: () -> Content) where V == Content.TabValue}
       ^
/Users/runner/work/FaultLog/FaultLog/Sources/Views/StatsView.swift:90:24: error: incorrect argument labels in call (have 'white:alpha:', expected '_:white:opacity:')
            .fill(Color(white: 0.92, alpha: 1))
                       ^~~~~~~~      ~~~~~
                                     white
/Users/runner/work/FaultLog/FaultLog/Sources/Views/StatsView.swift:90:45: error: cannot convert value of type 'Int' to expected argument type 'Color.RGBColorSpace'
            .fill(Color(white: 0.92, alpha: 1))
                                            ^
/Users/runner/work/FaultLog/FaultLog/Sources/Views/Theme.swift:58:29: error: incorrect argument labels in call (have 'white:alpha:', expected '_:white:opacity:')
    var color: Color = Color(white: 0.45, alpha: 1)
                            ^~~~~~~~      ~~~~~
                                          white
/Users/runner/work/FaultLog/FaultLog/Sources/Views/Theme.swift:58:50: error: cannot convert value of type 'Int' to expected argument type 'Color.RGBColorSpace'
    var color: Color = Color(white: 0.45, alpha: 1)
                                                 ^
/Users/runner/work/FaultLog/FaultLog/Sources/Views/Theme.swift:31:30: error: incorrect argument labels in call (have 'white:alpha:', expected '_:white:opacity:')
        default: return Color(white: 0.45, alpha: 1)
                             ^~~~~~~~      ~~~~~
                                           white
/Users/runner/work/FaultLog/FaultLog/Sources/Views/Theme.swift:31:51: error: cannot convert value of type 'Int' to expected argument type 'Color.RGBColorSpace'
        default: return Color(white: 0.45, alpha: 1)
                                                  ^
/Users/runner/work/FaultLog/FaultLog/Sources/Views/Theme.swift:93:36: error: incorrect argument labels in call (have 'white:alpha:', expected '_:white:opacity:')
                        .fill(Color(white: 0.93, alpha: 1))
                                   ^~~~~~~~      ~~~~~
                                                 white
/Users/runner/work/FaultLog/FaultLog/Sources/Views/Theme.swift:93:57: error: cannot convert value of type 'Int' to expected argument type 'Color.RGBColorSpace'
                        .fill(Color(white: 0.93, alpha: 1))
                                                        ^

Failed frontend command:
/Applications/Xcode_16.4.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/swift-frontend -frontend -c /Users/runner/work/FaultLog/FaultLog/Sources/Support/AIService.swift /Users/runner/work/FaultLog/FaultLog/Sources/Models/AppSettings.swift /Users/runner/work/FaultLog/FaultLog/Sources/Views/CameraPicker.swift /Users/runner/work/FaultLog/FaultLog/Sources/Views/ContentView.swift /Users/runner/work/FaultLog/FaultLog/Sources/Support/ExportService.swift /Users/runner/work/FaultLog/FaultLog/Sources/FaultLogApp.swift /Users/runner/work/FaultLog/FaultLog/Sources/Models/FaultRecord.swift /Users/runner/work/FaultLog/FaultLog/Sources/Models/FaultStore.swift /Users/runner/work/FaultLog/FaultLog/Sources/Support/ImageUtils.swift /Users/runner/work/FaultLog/FaultLog/Sources/Views/KanbanView.swift /Users/runner/work/FaultLog/FaultLog/Sources/Support/LocationService.swift /Users/runner/work/FaultLog/FaultLog/Sources/Support/NotificationService.swift /Users/runner/work/FaultLog/FaultLog/Sources/Support/OCRService.swift /Users/runner/work/FaultLog/FaultLog/Sources/Support/PDFReport.swift /Users/runner/work/FaultLog/FaultLog/Sources/Support/QRCodeMaker.swift /Users/runner/work/FaultLog/FaultLog/Sources/Views/RecordEditorView.swift /Users/runner/work/FaultLog/FaultLog/Sources/Views/RecordListView.swift /Users/runner/work/FaultLog/FaultLog/Sources/Views/ScannerView.swift /Users/runner/work/FaultLog/FaultLog/Sources/Views/SettingsView.swift /Users/runner/work/FaultLog/FaultLog/Sources/Support/SpeechInput.swift /Users/runner/work/FaultLog/FaultLog/Sources/Views/StatsView.swift /Users/runner/work/FaultLog/FaultLog/Sources/Views/Theme.swift /Users/runner/work/FaultLog/FaultLog/Sources/Support/UIImage+Resize.swift /Users/runner/work/FaultLog/FaultLog/Sources/Support/WebhookService.swift /Users/runner/work/FaultLog/FaultLog/Sources/Support/XLSXWriter.swift /Users/runner/work/FaultLog/FaultLog/Sources/Support/ZipWriter.swift /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/DerivedSources/GeneratedAssetSymbols.swift -supplementary-output-file-map /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/supplementaryOutputs-1 -target arm64-apple-ios15.0 -Xllvm -aarch64-use-tbi -enable-objc-interop -stack-check -sdk /Applications/Xcode_16.4.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS18.5.sdk -I /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos -F /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos -no-color-diagnostics -g -debug-info-format\=dwarf -dwarf-version\=4 -module-cache-path /Users/runner/work/FaultLog/FaultLog/build/ModuleCache.noindex -swift-version 5 -enforce-exclusivity\=checked -O -serialize-debugging-options -const-gather-protocols-file /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/FaultLog_const_extract_protocols.json -enable-experimental-feature DebugDescriptionMacro -enable-bare-slash-regex -empty-abi-descriptor -validate-clang-modules-once -clang-build-session-file /Users/runner/work/FaultLog/FaultLog/build/ModuleCache.noindex/Session.modulevalidation -Xcc -working-directory -Xcc /Users/runner/work/FaultLog/FaultLog -resource-dir /Applications/Xcode_16.4.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift -file-compilation-dir /Users/runner/work/FaultLog/FaultLog -Xcc -ivfsstatcache -Xcc /Users/runner/work/FaultLog/FaultLog/build/SDKStatCaches.noindex/iphoneos18.5-22F76-a529daf784b3616c7c04a36aeb7f5c05.sdkstatcache -Xcc -I/Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/swift-overrides.hmap -Xcc -iquote -Xcc /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/FaultLog-generated-files.hmap -Xcc -I/Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/FaultLog-own-target-headers.hmap -Xcc -I/Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/FaultLog-all-target-headers.hmap -Xcc -iquote -Xcc /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/FaultLog-project-headers.hmap -Xcc -I/Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos/include -Xcc -I/Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/DerivedSources-normal/arm64 -Xcc -I/Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/DerivedSources/arm64 -Xcc -I/Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/DerivedSources -module-name FaultLog -frontend-parseable-output -disable-clang-spi -target-sdk-version 18.5 -target-sdk-name iphoneos18.5 -external-plugin-path /Applications/Xcode_16.4.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/lib/swift/host/plugins\#/Applications/Xcode_16.4.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/swift-plugin-server -external-plugin-path /Applications/Xcode_16.4.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/local/lib/swift/host/plugins\#/Applications/Xcode_16.4.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/swift-plugin-server -in-process-plugin-server-path /Applications/Xcode_16.4.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/host/libSwiftInProcPluginServer.dylib -plugin-path /Applications/Xcode_16.4.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/host/plugins -plugin-path /Applications/Xcode_16.4.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/local/lib/swift/host/plugins -enable-default-cmo -num-threads 4 -o /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/AIService.o -o /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/AppSettings.o -o /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/CameraPicker.o -o /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/ContentView.o -o /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/ExportService.o -o /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/FaultLogApp.o -o /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/FaultRecord.o -o /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/FaultStore.o -o /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/ImageUtils.o -o /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/KanbanView.o -o /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/LocationService.o -o /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/NotificationService.o -o /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/OCRService.o -o /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/PDFReport.o -o /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/QRCodeMaker.o -o /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/RecordEditorView.o -o /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/RecordListView.o -o /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/ScannerView.o -o /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/SettingsView.o -o /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/SpeechInput.o -o /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/StatsView.o -o /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/Theme.o -o /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/UIImage+Resize.o -o /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/WebhookService.o -o /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/XLSXWriter.o -o /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/ZipWriter.o -o /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/GeneratedAssetSymbols.o -index-unit-output-path /FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/AIService.o -index-unit-output-path /FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/AppSettings.o -index-unit-output-path /FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/CameraPicker.o -index-unit-output-path /FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/ContentView.o -index-unit-output-path /FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/ExportService.o -index-unit-output-path /FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/FaultLogApp.o -index-unit-output-path /FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/FaultRecord.o -index-unit-output-path /FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/FaultStore.o -index-unit-output-path /FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/ImageUtils.o -index-unit-output-path /FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/KanbanView.o -index-unit-output-path /FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/LocationService.o -index-unit-output-path /FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/NotificationService.o -index-unit-output-path /FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/OCRService.o -index-unit-output-path /FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/PDFReport.o -index-unit-output-path /FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/QRCodeMaker.o -index-unit-output-path /FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/RecordEditorView.o -index-unit-output-path /FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/RecordListView.o -index-unit-output-path /FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/ScannerView.o -index-unit-output-path /FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/SettingsView.o -index-unit-output-path /FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/SpeechInput.o -index-unit-output-path /FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/StatsView.o -index-unit-output-path /FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/Theme.o -index-unit-output-path /FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/UIImage+Resize.o -index-unit-output-path /FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/WebhookService.o -index-unit-output-path /FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/XLSXWriter.o -index-unit-output-path /FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/ZipWriter.o -index-unit-output-path /FaultLog.build/Release-iphoneos/FaultLog.build/Objects-normal/arm64/GeneratedAssetSymbols.o
LinkAssetCatalog /Users/runner/work/FaultLog/FaultLog/Sources/Assets.xcassets (in target 'FaultLog' from project 'FaultLog')
    cd /Users/runner/work/FaultLog/FaultLog
    builtin-linkAssetCatalog --thinned /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/assetcatalog_output/thinned --thinned-dependencies /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/assetcatalog_dependencies_thinned --thinned-info-plist-content /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/assetcatalog_generated_info.plist_thinned --unthinned /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/assetcatalog_output/unthinned --unthinned-dependencies /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/assetcatalog_dependencies_unthinned --unthinned-info-plist-content /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/assetcatalog_generated_info.plist_unthinned --output /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos/FaultLog.app --plist-output /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/assetcatalog_generated_info.plist
note: Emplaced /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos/FaultLog.app/Assets.car (in target 'FaultLog' from project 'FaultLog')
note: Emplaced /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos/FaultLog.app/AppIcon60x60@2x.png (in target 'FaultLog' from project 'FaultLog')
note: Emplaced /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos/FaultLog.app/AppIcon76x76@2x~ipad.png (in target 'FaultLog' from project 'FaultLog')

ProcessInfoPlistFile /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos/FaultLog.app/Info.plist /Users/runner/work/FaultLog/FaultLog/Support/Info.plist (in target 'FaultLog' from project 'FaultLog')
    cd /Users/runner/work/FaultLog/FaultLog
    builtin-infoPlistUtility /Users/runner/work/FaultLog/FaultLog/Support/Info.plist -producttype com.apple.product-type.application -genpkginfo /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos/FaultLog.app/PkgInfo -expandbuildsettings -format binary -platform iphoneos -additionalcontentfile /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/assetcatalog_generated_info.plist -requiredArchitecture arm64 -o /Users/runner/work/FaultLog/FaultLog/build/Build/Products/Release-iphoneos/FaultLog.app/Info.plist

note: Disabling previews because SWIFT_VERSION is set and SWIFT_OPTIMIZATION_LEVEL=-O, expected -Onone (in target 'FaultLog' from project 'FaultLog')
** BUILD FAILED **


The following build commands failed:
	CompileSwift normal arm64 (in target 'FaultLog' from project 'FaultLog')
	SwiftCompile normal arm64 Compiling\ AIService.swift,\ AppSettings.swift,\ CameraPicker.swift,\ ContentView.swift,\ ExportService.swift,\ FaultLogApp.swift,\ FaultRecord.swift,\ FaultStore.swift,\ ImageUtils.swift,\ KanbanView.swift,\ LocationService.swift,\ NotificationService.swift,\ OCRService.swift,\ PDFReport.swift,\ QRCodeMaker.swift,\ RecordEditorView.swift,\ RecordListView.swift,\ ScannerView.swift,\ SettingsView.swift,\ SpeechInput.swift,\ StatsView.swift,\ Theme.swift,\ UIImage+Resize.swift,\ WebhookService.swift,\ XLSXWriter.swift,\ ZipWriter.swift,\ GeneratedAssetSymbols.swift /Users/runner/work/FaultLog/FaultLog/Sources/Support/AIService.swift /Users/runner/work/FaultLog/FaultLog/Sources/Models/AppSettings.swift /Users/runner/work/FaultLog/FaultLog/Sources/Views/CameraPicker.swift /Users/runner/work/FaultLog/FaultLog/Sources/Views/ContentView.swift /Users/runner/work/FaultLog/FaultLog/Sources/Support/ExportService.swift /Users/runner/work/FaultLog/FaultLog/Sources/FaultLogApp.swift /Users/runner/work/FaultLog/FaultLog/Sources/Models/FaultRecord.swift /Users/runner/work/FaultLog/FaultLog/Sources/Models/FaultStore.swift /Users/runner/work/FaultLog/FaultLog/Sources/Support/ImageUtils.swift /Users/runner/work/FaultLog/FaultLog/Sources/Views/KanbanView.swift /Users/runner/work/FaultLog/FaultLog/Sources/Support/LocationService.swift /Users/runner/work/FaultLog/FaultLog/Sources/Support/NotificationService.swift /Users/runner/work/FaultLog/FaultLog/Sources/Support/OCRService.swift /Users/runner/work/FaultLog/FaultLog/Sources/Support/PDFReport.swift /Users/runner/work/FaultLog/FaultLog/Sources/Support/QRCodeMaker.swift /Users/runner/work/FaultLog/FaultLog/Sources/Views/RecordEditorView.swift /Users/runner/work/FaultLog/FaultLog/Sources/Views/RecordListView.swift /Users/runner/work/FaultLog/FaultLog/Sources/Views/ScannerView.swift /Users/runner/work/FaultLog/FaultLog/Sources/Views/SettingsView.swift /Users/runner/work/FaultLog/FaultLog/Sources/Support/SpeechInput.swift /Users/runner/work/FaultLog/FaultLog/Sources/Views/StatsView.swift /Users/runner/work/FaultLog/FaultLog/Sources/Views/Theme.swift /Users/runner/work/FaultLog/FaultLog/Sources/Support/UIImage+Resize.swift /Users/runner/work/FaultLog/FaultLog/Sources/Support/WebhookService.swift /Users/runner/work/FaultLog/FaultLog/Sources/Support/XLSXWriter.swift /Users/runner/work/FaultLog/FaultLog/Sources/Support/ZipWriter.swift /Users/runner/work/FaultLog/FaultLog/build/Build/Intermediates.noindex/FaultLog.build/Release-iphoneos/FaultLog.build/DerivedSources/GeneratedAssetSymbols.swift (in target 'FaultLog' from project 'FaultLog')
	Building project FaultLog with scheme FaultLog and configuration Release
(3 failures)
```
