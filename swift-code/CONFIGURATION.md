# 项目配置说明

## ⚙️ 必须配置的地方

### 1. App Group（共享数据）

主 App 和键盘扩展需要共享 API Key，必须配置 App Group。

#### 步骤：

1. 选择项目 → **SmartKeyboard** target
2. 点击 **Signing & Capabilities**
3. 点击 **+ Capability**
4. 选择 **App Groups**
5. 点击 **+** 添加：`group.com.smartkeyboard.shared`

6. 重复上述步骤为 **KeyboardExtension** target 添加相同的 App Group

---

### 2. 键盘权限配置

#### KeyboardExtension 的 Info.plist：

找到 `NSExtension` → `NSExtensionAttributes`，确保有以下配置：

```xml
<key>NSExtensionAttributes</key>
<dict>
    <key>IsASCIICapable</key>
    <false/>
    <key>PrefersRightToLeft</key>
    <false/>
    <key>PrimaryLanguage</key>
    <string>zh-Hans</string>
    <key>RequestsOpenAccess</key>
    <true/>
</dict>
```

**重要**：`RequestsOpenAccess` 必须为 `true`，这样键盘才能访问网络。

---

### 3. 修改 Bundle Identifier

**主 App**:
- Bundle Identifier: `com.yourname.SmartKeyboard`

**KeyboardExtension**:
- Bundle Identifier: `com.yourname.SmartKeyboard.KeyboardExtension`

**App Group**:
- 也要改成 `group.com.yourname.smartkeyboard.shared`

然后在所有代码里把 `"group.com.smartkeyboard.shared"` 替换成你的。

---

### 4. 添加 Swift Package

File → Add Package Dependencies:

**URL**: `https://github.com/MacPaw/OpenAI`

选择两个 Target:
- ✅ SmartKeyboard
- ✅ KeyboardExtension

---

## 📝 代码文件对应位置

### 主 App (SmartKeyboard target)

- `ContentView.swift` → SmartKeyboard 文件夹
- `KeychainHelper.swift` → SmartKeyboard 文件夹

### 键盘扩展 (KeyboardExtension target)

- `KeyboardViewController.swift` → KeyboardExtension 文件夹（替换自动生成的）
- `OpenAIService.swift` → KeyboardExtension 文件夹
- `KeychainHelper.swift` → **也要添加到这个 target**（共享文件）

### 共享文件

- `Constants.swift` → 添加到两个 target

---

## 🚀 运行测试

### 第 1 步：运行主 App

1. 选择 **SmartKeyboard** scheme
2. 点击 Run
3. 输入你的 OpenAI API Key
4. 点击"打开键盘设置"

### 第 2 步：启用键盘

1. 设置 → 通用 → 键盘 → 键盘
2. 添加新键盘 → SmartKeyboard
3. 允许"完全访问"（必须！）

### 第 3 步：测试键盘

1. 打开任意聊天 app（备忘录、信息等）
2. 长按地球图标，切换到 SmartKeyboard
3. 输入"今天天气不错"
4. 点击"生成建议"
5. 点击任意建议，插入到聊天框

---

## ⚠️ 常见问题

### 1. 键盘无法访问网络

**解决**：
- 确保 `RequestsOpenAccess` 为 `true`
- 确保在设置中开启了"完全访问"

### 2. 读取不到 API Key

**解决**：
- 确保两个 target 都添加了相同的 App Group
- 确保 KeychainHelper.swift 同时添加到两个 target

### 3. OpenAI SDK 找不到

**解决**：
- 确保在 Package Dependencies 中选择了 KeyboardExtension target
- Clean Build Folder (Cmd+Shift+K) 然后重新编译

---

## 📦 文件列表

已准备好的文件：
- ✅ ContentView.swift
- ✅ KeychainHelper.swift
- ✅ KeyboardViewController.swift
- ✅ OpenAIService.swift
- ✅ Constants.swift

Xcode 下载完成后，按照 `iOS_PROJECT_SETUP.md` 创建项目，然后复制这些文件到对应位置即可！
