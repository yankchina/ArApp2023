# 代码审核笔记 - 02

## 概要

- 时间: 2023-05-29
- 审核人: yankchina<yankchina@gmail.com>


## 审核记录

### 真正的 `RealityKit` 在哪里？

这个项目中有 16 个文件都 `import RealityKit`，但并不是所有的文件都需要。需要大量的简化操作

- `ContentView.swift` 其只是一个 `SwiftUI` 界面布局，并不需要 `RealityKit` 与 `Combine` 
- `Usermodel.swift` 用户模型，也不需要 `RealityKit`，其中的用户模型还是需要 `Combine` 库支持
- `ArapploginView.swift` 只是登陆界面，而且重复使用了两个界面框架，其 `UIKit` 与 `RealityKit` 都是重复的
- `ARappMaterialView.swift` 也不需要 `RealityKit`
- `ARappmodel.swift` 需要 `Realitykit` 但并不需要 `Combine` 库
- `OnlineTaskAddingView.swift` 不需要 `RealityKit`
- `OnlineTaskView.swift` 不需要 `RealityKit` 和 `Combine` 库
- `OnlineTaskModel.swift` 仅仅需要 `RealityKit` ，而不需要做 `Combine` 库
- `VideoView.swift` 不需要 `RealityKit` 
- `MultiLineChartView.swift` 不需要 `RealityKit`
- `ARScanView.swift` 仅需要 `RealityKit` 
- `ARTipView.swift` 不需要 `RealityKit` 
- `ExtraimageView.swift` 不需要 `RealityKit`
- `ProportionalextraView.swift` 不需要 `RealityKit`
- `SquarewaveextraView.swift` 不需要 `RealityKit` 和 `Combine` 库
- `ARViewContainer_extension.swift` 需要 `Realitykit`，但并不需要 `Foundation` 库 和 `SwiftUI` 库

不要将不用的库引入到 代码中，会对 编译 与 审核带来很多的问题。

Apple 提倡代码简洁高效，对于这样的代码是难于通过其审核的。


> 想法，整个代码中关于 `RealityKit` 的使用是非常集中的，所以我们需要做定向封装，优化代码结构，使得代码更加的简洁高效。

---

