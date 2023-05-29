# 代码审核笔记 - 02

## 概要

- 时间: 2023-05-29
- 审核人: yankchina<yankchina@gmail.com>


## 审核记录

### 真正的 `RealityKit` 在哪里？

这个项目中有 16 个文件都 `import RealityKit`，但并不是所有的文件都需要。需要大量的简化操作

- `ContentView.swift` 