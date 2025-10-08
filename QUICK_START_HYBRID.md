# 🚀 混合架构 - 快速开始指南

## 🎯 架构特点

✅ **两种模式都支持！**

### 模式 A：公司服务器（默认）
- 用户不需要 OpenAI Key
- 完全免费使用
- 需要部署后端到 AWS

### 模式 B：用户自己的 Key
- 用户输入自己的 OpenAI Key
- 直接调用 OpenAI API
- 不需要服务器，立即可用

### 用户可以随时切换！

---

## 第 1 步：创建 Xcode 项目（5分钟）

### 1.1 创建主 App

1. 打开 **Xcode**
2. **File → New → Project**
3. 选择 **iOS → App**
4. 填写信息：
   ```
   Product Name: SmartKeyboard
   Team: （选择你的）
   Organization Identifier: com.yourname
   Interface: SwiftUI
   Language: Swift
   ```

### 1.2 添加键盘扩展

1. 点击项目 **SmartKeyboard**
2. 点击下方 **+** 按钮
3. 选择 **Keyboard Extension**
4. Product Name: `KeyboardExtension`
5. 点击 **Finish** → **Activate**

---

## 第 2 步：配置项目（5分钟）

### 2.1 配置 App Groups（必须！）

为两个 target 都添加：

1. 选择 **SmartKeyboard** target
2. **Signing & Capabilities** → **+ Capability** → **App Groups**
3. 添加：`group.com.smartkeyboard.shared`

4. 选择 **KeyboardExtension** target
5. 重复上述步骤，添加相同的 App Group

### 2.2 配置键盘权限

1. 打开 `KeyboardExtension/Info.plist`
2. 找到 **NSExtension → NSExtensionAttributes**
3. 添加：
   - Key: `RequestsOpenAccess`
   - Type: Boolean
   - Value: YES

### 2.3 添加 Swift Package

1. **File → Add Package Dependencies**
2. 输入：`https://github.com/MacPaw/OpenAI`
3. 选择 Target:
   - ✅ KeyboardExtension
4. 点击 **Add Package**

### 2.4 允许 HTTP（临时）

在 **SmartKeyboard** target 的 **Info.plist** 中添加：
```xml
Key: App Transport Security Settings
  └─ Allow Arbitrary Loads: YES
```

---

## 第 3 步：添加代码文件（10分钟）

### 3.1 删除自动生成的文件

- 删除 `KeyboardExtension/KeyboardViewController.swift`

### 3.2 添加新文件（混合版本）

#### 共享文件（Shared）

创建 **Group**："Shared"（File → New → Group）

**Settings.swift**
- 右键 Shared → New File → Swift File
- Target: ✅ SmartKeyboard ✅ KeyboardExtension
- 源码：`~/SmartKeyboard/swift-code/Shared/Settings.swift`

**Constants.swift**
- Target: ✅ SmartKeyboard ✅ KeyboardExtension
- 源码：`~/SmartKeyboard/swift-code/Shared/Constants.swift`

#### 主 App 文件

**ContentView.swift**（替换内容）
- 源码：`~/SmartKeyboard/swift-code/MainApp/ContentView_Hybrid.swift`

**KeychainHelper.swift**（新建）
- 右键 SmartKeyboard 文件夹 → New File
- Target: ✅ SmartKeyboard ✅ KeyboardExtension
- 源码：`~/SmartKeyboard/swift-code/MainApp/KeychainHelper.swift`

#### 键盘扩展文件

**KeyboardViewController.swift**（新建）
- Target: ✅ KeyboardExtension
- 源码：`~/SmartKeyboard/swift-code/KeyboardExtension/KeyboardViewController.swift`
  （用原来的，不是 ServerVersion）

**OpenAIService.swift**（新建）
- Target: ✅ KeyboardExtension
- 源码：`~/SmartKeyboard/swift-code/KeyboardExtension/OpenAIService_Hybrid.swift`

---

## 第 4 步：运行测试（5分钟）

### 4.1 运行主 App

1. 选择 scheme: **SmartKeyboard**
2. 点击 **▶️ Run**
3. 你会看到：
   - 顶部：模式选择（公司服务器 / 我的 Key）
   - 中间：配置区域（根据选择的模式）
   - 底部：使用说明

### 4.2 测试两种模式

#### 测试模式 A：用户 Key（立即可用）

1. 选择 **"🔑 我的 OpenAI Key"**
2. 输入你的 OpenAI API Key（从 https://platform.openai.com/api-keys 获取）
3. 点击 "保存 API Key"
4. 点击 "打开键盘设置"
5. 启用 SmartKeyboard + 允许"完全访问"
6. 打开任意 app（备忘录）
7. 切换到 SmartKeyboard
8. 输入"今天天气不错"，点击"生成建议"
9. ✅ **应该能看到 3 个建议！**

#### 测试模式 B：公司服务器（需要部署）

1. 选择 **"🆓 公司服务器"**
2. 输入服务器地址：`http://localhost:8000`（先测试本地）
3. 保存
4. 确保后端在运行：
   ```bash
   cd ~/SmartKeyboard/backend
   source venv/bin/activate
   python main.py
   ```
5. 在键盘中测试
6. ✅ **应该也能看到建议！**

---

## 📋 代码文件清单

| Xcode 位置 | 源代码文件 | Target |
|-----------|-----------|--------|
| Shared/Settings.swift | swift-code/Shared/Settings.swift | 两个 |
| Shared/Constants.swift | swift-code/Shared/Constants.swift | 两个 |
| SmartKeyboard/ContentView.swift | swift-code/MainApp/ContentView_Hybrid.swift | 主 App |
| SmartKeyboard/KeychainHelper.swift | swift-code/MainApp/KeychainHelper.swift | 两个 |
| KeyboardExtension/KeyboardViewController.swift | swift-code/KeyboardExtension/KeyboardViewController.swift | 扩展 |
| KeyboardExtension/OpenAIService.swift | swift-code/KeyboardExtension/OpenAIService_Hybrid.swift | 扩展 |

---

## 🎯 优势总结

### 对用户：
- ✅ 免费用公司服务器
- ✅ 也可以用自己的 key
- ✅ 随时切换，灵活选择

### 对你：
- ✅ 现在就能测试（用自己的 key）
- ✅ 明天 AWS 部署好再切换
- ✅ 两种方式都支持，用户更多

---

## 🚀 明天的任务

1. 给我 AWS 服务器地址
2. 部署后端到 AWS
3. 在 app 中测试公司服务器模式
4. 完成！

---

## ⚠️ 注意事项

### Target Membership 很重要！

添加文件时，确保勾选正确的 Target：
- `Settings.swift`: ✅ 两个
- `KeychainHelper.swift`: ✅ 两个
- `KeyboardViewController.swift`: ✅ 只勾选 KeyboardExtension
- `OpenAIService.swift`: ✅ 只勾选 KeyboardExtension

### App Group 必须一致！

两个 target 的 App Group 必须完全一样：
```
group.com.smartkeyboard.shared
```

---

**Xcode 下载完成后，按这个文档一步步来！现在就能测试，不用等 AWS！** 😄
