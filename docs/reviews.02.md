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

### `ARappmodel.swift` 

这个文件比较奇怪，其功能可能是

- 程序当前的状态
- 用不同语言来显示不同的状态（菜单）


这样的写法并不符合 Apple 的惯用法

- 程序的状态是一个 `enum` 类型，但其应该在 `@EnvironmentObject` 中
- 这里的状态切换并不涉及到语言，国际化语言应该用 Internationalization 的方式来实现
- 这里的状态切换应该用 `SwiftUI` 的 `NavigationView` 来实现，而不是做一个 enum。我们可以直接通过 `NavigationView` 的 `NavigationLink` 来实现状态切换，并且可以获得当前的状态


### 文件目录架构


在 `Xcode` 中需要先按照 文件功能类型来分目录，再按照功能模块来分。建议用 

- `views` 都是 `SwiftUI` 视图，如果要再分模块，其中再安排上
- `models` 都是 后台模型


要注意，在 `SwiftUI` 中，建议使用 `MV`模式而非 `MVVM`模式，[Stop using MVVM for SwiftUI](https://developer.apple.com/forums/thread/699003)。

其余还有不少内容可以放在其它文件夹中

- `rcproject` 文件可以单独放在一起，命名为 `realitycomposers` 或者 `rcprojects` 
- 要将 `Ch0` 的图片放在 `assets -> books` 或者 `assets -> lectures` 目录中 



