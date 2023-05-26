# 代码审核笔记 - 01

## 概要

- 时间: 2023-05-26
- 审核人: yankchina<yankchina@gmail.com>

## 审核要点

代码主要存在如下主要问题

### 代码结构

- 需要将界面封装起来，不要将所有的代码都写在 `ContentView` 中，这样会导致代码过于冗长，不利于阅读；
- 需要将在 `Button` 上的事件操作封装到 `ViewModel` 中，不要将所有的逻辑都写在 `ContentView` 中，这样会导致代码过于冗长，不利于阅读；
- 项目中需要单独做错误处理，而且要给常见错误编号，方便后续的维护；
- 在项目中，如果要用到全局变量，尽可能使用环境变量，比如 `Usermodel` 不要作为 `@EnvironmentObject`传递给每个`View`，而应该将其定义为 `@Environment` 变量，这样所有 `View` 都可以访问，减少代码重复；

### 代码重复

代码中存在大量的重复，这并不符合 Swift 的设计理念，应该尽量避免重复代码的出现。

- SwiftUI 鼓励将常用的 View 封装成组件，这样可以避免重复代码的出现。在原始代码中出现大量的重复，比如 `ArappLoginView` 与 `ArappLoginViewiOS16` 就几乎相同，仅仅在 `NavigationLink` 和一些微小布局上有改动。其代码需要简化；
- 颜色与样式（Color & Style）也是可以封装的，比如在 `Button` 建议使用 `.buttonStyle(PrimaryButtonStyle())`而不要总是`.padding().backgroundcolor()`；


### 代码可读性

- 代码缺少必要的注释，每个文件头都需要做功能，并在 `README.md` 中对文件做必要的说明;
- 需要将部分用来做调试并弃用的代码清除掉，不要影响总体阅读体验;
- 代码格式需要进一步优化;
- 部分代码命名不够规范，需要进一步优化