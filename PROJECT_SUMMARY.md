# SmartKeyboard - AI 智能键盘项目总结

## 📋 项目概述

**项目名称**: SmartKeyboard - AI 泡妞助手
**类型**: iOS 自定义键盘 + Python 后端
**核心功能**: 使用 AI (OpenAI GPT) 在聊天场景中生成幽默风趣的回复建议
**目标用户**: 需要聊天帮助的用户（初期 2-1000 用户）
**平台**: iOS 15.0+, 跨平台支持（微信、LINE、WhatsApp 等所有文本输入场景）

---

## 🎯 产品特性

### 混合架构 - 两种使用模式

**模式 A: 用户自己的 OpenAI Key**
- ✅ 用户输入自己的 OpenAI API Key
- ✅ 直接调用 OpenAI API
- ✅ 无需服务器，立即可用
- ✅ 成本透明：约 $0.0005/次请求
- ✅ Key 安全存储在 iOS Keychain

**模式 B: 公司服务器（免费）**
- ✅ 用户无需 OpenAI Key
- ✅ 完全免费使用
- ✅ 通过公司 AWS 服务器提供服务
- ✅ 无需担心 API Key 泄露

**用户可以随时在 App 中切换模式！**

### 核心功能
1. **AI 建议生成**: 输入上下文，生成 3 个幽默风趣的回复建议
2. **一键插入**: 点击建议即可插入到聊天框
3. **跨平台**: 支持所有 iOS app 的文本输入
4. **安全**: Keychain 安全存储，支持完全访问权限

---

## 🏗️ 技术架构

### iOS 前端

**技术栈**:
- Swift + SwiftUI
- iOS Keyboard Extension
- App Groups（数据共享）
- Keychain Sharing（API Key 共享）
- OpenAI Swift SDK (MacPaw/OpenAI)

**项目结构**:
```
SmartKeyboard/
├── SmartKeyboard/              # 主 App
│   ├── ContentView.swift       # 主界面（模式选择、配置）
│   ├── KeychainHelper.swift    # Keychain 安全存储
│   └── SmartKeyboardApp.swift  # App 入口
├── KeyboardExtension/          # 键盘扩展
│   ├── KeyboardViewController.swift  # 键盘 UI 和逻辑
│   └── OpenAIService.swift     # 混合模式 AI 服务
└── Shared/                     # 共享代码
    ├── Settings.swift          # 配置管理
    └── Constants.swift         # 常量定义
```

**关键配置**:
- Bundle ID: `com.rsong.SmartKeyboard`
- App Group: `group.com.smartkeyboard.shared`
- Keychain Group: `$(AppIdentifierPrefix)com.rsong.SmartKeyboard`
- Deployment Target: iOS 15.0+

### Python 后端

**技术栈**:
- Python 3.13
- FastAPI
- OpenAI API
- uvicorn

**服务器**:
- 本地测试: `http://localhost:8000`
- 生产环境: AWS (待部署)

**API 端点**:
```
POST /api/generate
Request: {
  "context": "今天天气不错",
  "style": "幽默风趣"
}
Response: {
  "suggestions": [
    "建议1",
    "建议2",
    "建议3"
  ]
}
```

**后端文件**:
```
backend/
├── main.py           # FastAPI 服务器
├── requirements.txt  # Python 依赖
├── .env             # OpenAI API Key
└── venv/            # 虚拟环境
```

---

## 📁 项目文件结构

```
/Users/rsong/SmartKeyboard/
├── ios-app/                    # iOS Xcode 项目
│   └── SmartKeyboard/
│       ├── SmartKeyboard.xcodeproj
│       ├── SmartKeyboard/      # 主 App 代码
│       ├── KeyboardExtension/  # 键盘扩展代码
│       └── Shared/             # 共享代码
├── backend/                    # Python 后端
│   ├── main.py
│   ├── requirements.txt
│   ├── .env
│   └── venv/
├── swift-code/                 # Swift 源代码模板
│   ├── MainApp/
│   │   ├── ContentView_Hybrid.swift
│   │   └── KeychainHelper.swift
│   ├── KeyboardExtension/
│   │   ├── KeyboardViewController.swift
│   │   └── OpenAIService_Hybrid.swift
│   └── Shared/
│       ├── Settings.swift
│       └── Constants.swift
├── QUICK_START_HYBRID.md       # 混合版本快速开始指南
├── QUICK_START.md              # 服务器版本快速开始指南
└── PROJECT_SUMMARY.md          # 本文档
```

---

## 🔑 重要配置信息

### OpenAI API Key
```
存储在 backend/.env 文件中（已在 .gitignore 中忽略）
获取地址: https://platform.openai.com/api-keys
```

### Git 配置
```bash
git config user.name "rsong"
git config user.email "songyuguang@gmail.com"
```

### Apple Developer
- Team: Richard Song 的团队
- Organization Identifier: com.rsong

---

## ✅ 已完成的工作

### 后端开发 ✅
1. ✅ 创建 Python FastAPI 服务器
2. ✅ 实现 `/api/generate` API 端点
3. ✅ 集成 OpenAI GPT-3.5-turbo
4. ✅ 本地测试成功（`http://localhost:8000`）
5. ✅ 后端持续运行中

### iOS 开发 ✅
1. ✅ 创建 Xcode 项目
2. ✅ 添加键盘扩展（KeyboardExtension）
3. ✅ 配置 App Groups 和 Keychain Sharing
4. ✅ 添加 OpenAI Swift Package
5. ✅ 实现混合架构代码
6. ✅ 修复所有编译错误
7. ✅ 配置键盘权限（RequestsOpenAccess）
8. ✅ 编译成功（Build Succeeded）
9. ✅ 模拟器测试主 App UI 成功
10. ✅ 安装到真机（iPhone SE 2nd Gen, iOS 18.5）

### 代码修复记录 ✅
1. ✅ 修复 `OpenAIService.swift`: 移除 `maxTokens` 参数
2. ✅ 修复 `OpenAIService.swift`: 修复 `CharacterSet` 和 `String.CompareOptions` 引用
3. ✅ 修复 `OpenAIService.swift`: 移除 `.string` 属性（直接使用 content）
4. ✅ 修复 `ContentView.swift`: 修复 `onChange` API（iOS 17 兼容）
5. ✅ 修复 `ContentView.swift`: 修复中文引号转义问题
6. ✅ 修复 `KeyboardViewController.swift`: 移除 `apiKey` 参数（使用 AppSettings）
7. ✅ 修复 `KeychainHelper.swift`: 移除错误的 Access Group 配置

---

## ⚠️ 当前问题和待解决

### iOS App 崩溃问题 🔧
**状态**: 正在修复

**问题**: App 在真机上启动时崩溃（Thread 1: signal SIGTERM）

**原因**: Keychain Access Group 配置问题

**解决方案**:
1. ✅ 已修复 `KeychainHelper.swift`（移除了错误的 Access Group）
2. ⏳ 需要在 Xcode 中添加 **Keychain Sharing** capability
   - SmartKeyboard target: + Capability → Keychain Sharing
   - KeyboardExtension target: + Capability → Keychain Sharing
3. ⏳ 重新运行到真机测试

### 键盘未显示在系统设置 🔧
**状态**: 等待 App 修复后测试

**可能原因**:
- App 崩溃导致扩展未正确注册
- 需要重启 iPhone

**解决步骤**:
1. 修复 Keychain 问题
2. 重新安装 App
3. 打开主 App 一次
4. 重启 iPhone
5. 设置 → 通用 → 键盘 → 键盘 → 添加 SmartKeyboard

---

## 📝 下一步计划

### 立即执行（今天）

1. **修复 Keychain Sharing 配置**
   - [ ] SmartKeyboard target: 添加 Keychain Sharing capability
   - [ ] KeyboardExtension target: 添加 Keychain Sharing capability
   - [ ] 重新运行到真机
   - [ ] 验证 App 不再崩溃

2. **完成 iOS 测试**
   - [ ] 在真机上打开 SmartKeyboard app
   - [ ] 输入并保存 OpenAI API Key
   - [ ] 在设置中启用键盘
   - [ ] 允许完全访问
   - [ ] 在微信/备忘录中测试键盘功能
   - [ ] 验证 AI 建议生成功能

3. **上传到 GitHub**
   - [ ] 创建 `.gitignore` 文件
   - [ ] 初始化 Git 仓库
   - [ ] 创建 GitHub 仓库
   - [ ] 推送代码

### 短期计划（明天-本周）

4. **部署后端到 AWS**
   - [ ] 获取 AWS 服务器地址
   - [ ] 部署 Python FastAPI 到 AWS EC2
   - [ ] 配置 HTTPS（Let's Encrypt）
   - [ ] 更新 iOS app 中的服务器地址
   - [ ] 测试公司服务器模式

5. **优化和完善**
   - [ ] 添加更多风格选项（幽默、正式、可爱等）
   - [ ] 优化 UI 设计
   - [ ] 添加使用统计
   - [ ] 添加错误处理和用户提示

### 中期计划（下周-下月）

6. **准备 App Store 提交**
   - [ ] 准备 App 图标和截图
   - [ ] 编写 App Store 描述
   - [ ] 配置隐私政策
   - [ ] 注册 Apple Developer Program ($99/年)
   - [ ] 提交审核

7. **功能扩展**
   - [ ] 支持多语言（英文、日文）
   - [ ] 添加历史记录
   - [ ] 支持自定义 prompt
   - [ ] 添加用户反馈机制

---

## 🚀 GitHub 上传计划

### 准备工作

**创建 `.gitignore` 文件**:
```gitignore
# Xcode
*.xcuserstate
*.xcworkspace/xcuserdata/
DerivedData/
.DS_Store

# Swift Package Manager
.swiftpm/
.build/

# Python
venv/
__pycache__/
*.pyc
.env

# Secrets
*.pem
*.key
backend/.env
```

**项目说明（README.md）**:
```markdown
# SmartKeyboard - AI 智能键盘

🤖 使用 AI 生成聊天回复建议的 iOS 自定义键盘

## 特性
- 🎯 两种使用模式：用户自己的 OpenAI Key / 公司免费服务器
- 💬 支持所有 iOS app 的文本输入
- 🎨 生成幽默风趣的回复建议
- 🔒 Keychain 安全存储

## 技术栈
- iOS: Swift + SwiftUI + Keyboard Extension
- 后端: Python + FastAPI + OpenAI API
- 部署: AWS (计划中)
```

### Git 命令
```bash
cd /Users/rsong/SmartKeyboard

# 初始化 Git
git init

# 添加 .gitignore
cat > .gitignore << 'EOF'
# Xcode
*.xcuserstate
*.xcworkspace/xcuserdata/
DerivedData/
.DS_Store
ios-app/SmartKeyboard/SmartKeyboard.xcodeproj/xcuserdata/
ios-app/SmartKeyboard/SmartKeyboard.xcodeproj/project.xcworkspace/xcuserdata/

# Swift Package Manager
.swiftpm/
.build/

# Python
venv/
__pycache__/
*.pyc

# Secrets - 重要！不要上传 API Key
backend/.env
.env

# IDE
.vscode/
.idea/
EOF

# 配置 Git
git config user.name "rsong"
git config user.email "songyuguang@gmail.com"

# 添加文件
git add .

# 第一次提交
git commit -m "Initial commit: SmartKeyboard - AI 智能键盘

功能:
- iOS 自定义键盘 + Python 后端
- 混合架构：支持用户自己的 OpenAI Key 或公司服务器
- 使用 GPT-3.5-turbo 生成聊天回复建议
- Keychain 安全存储
- 支持所有 iOS app 的文本输入场景

技术栈:
- Frontend: Swift, SwiftUI, iOS Keyboard Extension
- Backend: Python 3.13, FastAPI, OpenAI API
- 依赖: OpenAI Swift SDK, uvicorn

状态: MVP 完成，等待真机测试验证"

# 创建 GitHub 仓库后
# git remote add origin https://github.com/rsong/SmartKeyboard.git
# git branch -M main
# git push -u origin main
```

---

## 📊 项目状态

**开发进度**: 90% 完成

- ✅ 后端开发: 100% 完成
- ✅ iOS UI 开发: 100% 完成
- ✅ iOS 功能开发: 100% 完成
- ✅ 模拟器测试: 100% 完成
- 🔧 真机测试: 80% 完成（修复 Keychain 问题中）
- ⏳ AWS 部署: 0% 完成
- ⏳ App Store: 0% 完成

**预计完成时间**:
- 真机测试: 今天
- GitHub 上传: 今天
- AWS 部署: 明天
- App Store 提交: 1-2 周

---

## 🛠️ 技术决策记录

### 为什么选择混合架构？
1. **灵活性**: 用户可以根据需求选择
2. **快速启动**: 用户自己 Key 模式立即可用，无需等待服务器部署
3. **成本控制**: 公司服务器模式可以控制成本，用户 Key 模式转移成本
4. **商业模式**: 免费模式吸引用户，Pro 用户可以用自己的 key 获得更好的体验

### 为什么选择 Python FastAPI 而不是 Node.js？
1. OpenAI SDK 在 Python 生态更成熟
2. FastAPI 性能足够好（对于 1000 用户规模）
3. 开发速度快，代码简洁
4. 异步支持良好

### 为什么选择 AWS 而不是 Railway？
1. 用户有免费的 AWS 资源
2. AWS 更稳定、可扩展
3. Railway 对于长期运行不如 AWS 成本优势

---

## 📞 联系方式

**开发者**: Richard Song
**Email**: songyuguang@gmail.com
**GitHub**: rsong (待创建)

---

## 📄 许可证

待定（建议 MIT License）

---

**文档创建时间**: 2025-10-07
**最后更新**: 2025-10-07
**版本**: 1.0.0

---

## 🔖 快速命令参考

### 启动后端
```bash
cd ~/SmartKeyboard/backend
source venv/bin/activate
python main.py
```

### 测试后端 API
```bash
curl -X POST "http://localhost:8000/api/generate" \
  -H "Content-Type: application/json" \
  -d '{"context":"今天天气不错","style":"幽默风趣"}'
```

### Xcode 常用操作
- Build: `Cmd + B`
- Run: `Cmd + R`
- Clean: `Cmd + Shift + K`
- Stop: `Cmd + .`

### Git 常用操作
```bash
git status              # 查看状态
git add .              # 添加所有文件
git commit -m "msg"    # 提交
git push               # 推送到远程
git pull               # 从远程拉取
```

---

**祝项目顺利！加油！** 🚀
