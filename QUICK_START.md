# 🚀 快速开始指南

## 📝 Xcode 下载完成后，按这个步骤操作

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
   Organization Identifier: com.yourname（改成你的）
   Interface: SwiftUI
   Language: Swift
   ```
5. 保存位置：**Desktop** 或任意位置

### 1.2 添加键盘扩展

1. 在 Xcode 左侧，点击最上面的 **SmartKeyboard** 项目图标
2. 在中间的 TARGETS 列表下方，点击 **+** 按钮
3. 搜索 **"Keyboard"**，选择 **Keyboard Extension**
4. 填写：
   ```
   Product Name: KeyboardExtension
   ```
5. 点击 **Finish**
6. 弹出对话框点击 **Activate**

---

## 第 2 步：配置项目（3分钟）

### 2.1 配置 App Groups

#### 为主 App 配置：
1. 选择项目 → **SmartKeyboard** target
2. 点击 **Signing & Capabilities** 标签
3. 点击 **+ Capability**
4. 搜索并添加 **App Groups**
5. 点击 **+** 添加 group：
   ```
   group.com.smartkeyboard.shared
   ```

#### 为键盘扩展配置（重复上述步骤）：
1. 选择 **KeyboardExtension** target
2. 添加相同的 **App Groups**：
   ```
   group.com.smartkeyboard.shared
   ```

### 2.2 配置键盘权限

1. 在左侧文件列表，找到 **KeyboardExtension** 文件夹
2. 打开 **Info.plist**
3. 找到 **NSExtension → NSExtensionAttributes**
4. 添加一项：
   - 右键点击 **NSExtensionAttributes**
   - 选择 **Add Row**
   - Key: `RequestsOpenAccess`
   - Type: Boolean
   - Value: YES

---

## 第 3 步：添加 Swift 代码（服务器版本）

### 3.1 删除自动生成的文件

1. 删除 `KeyboardExtension/KeyboardViewController.swift`（Xcode 自动生成的）
2. 保留 `SmartKeyboard/ContentView.swift`（待会替换内容）

### 3.2 复制代码文件

#### 主 App 文件：

**ContentView.swift**（替换现有内容）
- 位置：`SmartKeyboard/ContentView.swift`
- 源文件：`~/SmartKeyboard/swift-code/MainApp/ContentView_ServerVersion.swift`
- 操作：打开文件，复制全部内容，粘贴替换

**不需要 KeychainHelper.swift**（服务器版本不需要）

#### 键盘扩展文件：

**KeyboardViewController.swift**（新建）
- 右键点击 `KeyboardExtension` 文件夹
- New File → Swift File
- 名字：`KeyboardViewController`
- Target: 确保勾选 **KeyboardExtension**
- 源文件：`~/SmartKeyboard/swift-code/KeyboardExtension/KeyboardViewController_ServerVersion.swift`

**OpenAIService.swift**（新建）
- 右键点击 `KeyboardExtension` 文件夹
- New File → Swift File
- 名字：`OpenAIService`
- Target: 确保勾选 **KeyboardExtension**
- 源文件：`~/SmartKeyboard/swift-code/KeyboardExtension/OpenAIService_ServerVersion.swift`

---

## 第 4 步：更新服务器地址（明天做）

在 `OpenAIService.swift` 中，找到这一行：
```swift
init(serverURL: String = "http://your-company-server.com:8000") {
```

改成你的 AWS 服务器地址：
```swift
init(serverURL: String = "http://你的AWS地址:8000") {
```

---

## 第 5 步：配置 HTTP 访问（临时，测试用）

因为服务器暂时可能是 HTTP（不是 HTTPS），需要允许：

1. 打开 **SmartKeyboard** target 的 **Info.plist**
2. 右键 → Add Row
3. 添加：
   ```xml
   Key: App Transport Security Settings (Dictionary)
     └─ Allow Arbitrary Loads (Boolean): YES
   ```

⚠️ **上架 App Store 前必须改成 HTTPS！**

---

## 第 6 步：运行主 App（测试）

1. 选择 scheme：**SmartKeyboard**
2. 选择模拟器或真机
3. 点击 **▶️ Run**
4. 应该看到：
   - Logo 和标题
   - 使用说明
   - "免费使用，无需 OpenAI Key"提示
   - "打开键盘设置"按钮

---

## 第 7 步：运行键盘（真机测试）

### ⚠️ 键盘扩展只能在真机上测试！

1. 连接 iPhone
2. 选择 scheme：**KeyboardExtension**
3. 选择你的 iPhone
4. 点击 **▶️ Run**
5. 选择测试 app（比如"备忘录"）
6. 在备忘录中：
   - 长按地球图标 🌐
   - 选择 **SmartKeyboard**
7. 测试：
   - 输入"今天天气不错"
   - 点击"生成建议"
   - （需要后端运行才有结果）

---

## 🎯 检查清单

### 创建项目
- [ ] 主 App 创建完成
- [ ] 键盘扩展添加完成
- [ ] App Groups 配置完成（两个 target）
- [ ] Info.plist 权限配置完成

### 代码文件
- [ ] ContentView.swift（服务器版本）
- [ ] KeyboardViewController.swift（服务器版本）
- [ ] OpenAIService.swift（服务器版本）

### 配置
- [ ] HTTP 访问已允许（临时）
- [ ] 服务器地址已更新（明天）

### 测试
- [ ] 主 App 可以运行
- [ ] 键盘可以在真机上启用
- [ ] （等后端部署）生成建议功能

---

## 📁 文件对照表

| Xcode 项目文件 | 源代码文件 |
|---------------|-----------|
| SmartKeyboard/ContentView.swift | swift-code/MainApp/ContentView_ServerVersion.swift |
| KeyboardExtension/KeyboardViewController.swift | swift-code/KeyboardExtension/KeyboardViewController_ServerVersion.swift |
| KeyboardExtension/OpenAIService.swift | swift-code/KeyboardExtension/OpenAIService_ServerVersion.swift |

---

## ❓ 遇到问题？

### 编译错误
- 确保文件的 Target Membership 正确
- Clean Build Folder (Cmd+Shift+K)

### 键盘不显示
- 确保在设置中启用了"完全访问"
- 重启手机

### 无法访问服务器
- 确保手机和服务器在同一网络
- 或服务器有公网 IP
- 检查防火墙设置

---

**Xcode 下载完成后，按这个文档一步步来！有问题随时问我！** 😄
