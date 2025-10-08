# SmartKeyboard iOS 项目设置指南

## 📋 项目结构

```
SmartKeyboard/
├── SmartKeyboard/              # 主 App（设置界面）
│   ├── ContentView.swift       # 主界面
│   ├── SettingsView.swift      # 设置页面（输入 API Key）
│   └── KeychainHelper.swift    # 安全存储 API Key
│
├── KeyboardExtension/          # 键盘扩展
│   ├── KeyboardViewController.swift   # 键盘主控制器
│   ├── OpenAIService.swift            # OpenAI 集成
│   └── SuggestionView.swift           # 建议显示 UI
│
└── Shared/                     # 共享代码
    └── Constants.swift         # 常量定义
```

---

## 🚀 在 Xcode 中创建项目

### 第 1 步：创建主 App

1. 打开 Xcode
2. File → New → Project
3. 选择 **iOS → App**
4. 填写信息：
   - **Product Name**: `SmartKeyboard`
   - **Organization Identifier**: `com.yourname` (改成你的)
   - **Interface**: SwiftUI
   - **Language**: Swift
5. 保存到：`/Users/rsong/SmartKeyboard/ios-app`

### 第 2 步：添加键盘扩展

1. 在 Xcode 项目中，点击项目名称
2. 点击左下角的 **+** 按钮（Add Target）
3. 选择 **iOS → Keyboard Extension**
4. 填写信息：
   - **Product Name**: `KeyboardExtension`
   - 勾选 **Activate "KeyboardExtension" scheme**
5. 点击 Finish

### 第 3 步：添加 Swift Package（OpenAI SDK）

1. File → Add Package Dependencies
2. 输入 URL: `https://github.com/MacPaw/OpenAI`
3. 点击 Add Package
4. 选择 Target: **KeyboardExtension** 和 **SmartKeyboard**

---

## ⚙️ 配置键盘权限

### 修改 Info.plist（KeyboardExtension）

1. 打开 `KeyboardExtension/Info.plist`
2. 找到 `NSExtension` → `NSExtensionAttributes`
3. 添加：
   ```xml
   <key>RequestsOpenAccess</key>
   <true/>
   ```

这允许键盘访问网络（调用 OpenAI API）。

---

## 📝 下一步

Xcode 下载完成后，按照上面的步骤创建项目。

创建完成后告诉我，我会提供所有的 Swift 代码文件！

---

## 🔑 功能说明

1. **主 App**：
   - 用户输入 OpenAI API Key
   - Key 安全存储在 Keychain
   - 使用说明

2. **键盘扩展**：
   - 捕获用户输入
   - 调用 OpenAI API
   - 显示 3 个建议
   - 点击插入到聊天框
