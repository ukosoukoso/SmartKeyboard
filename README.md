# 🤖 SmartKeyboard - AI 智能键盘

使用 AI 生成聊天回复建议的 iOS 自定义键盘，让聊天更有趣！

![iOS](https://img.shields.io/badge/iOS-15.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)
![Python](https://img.shields.io/badge/Python-3.13-green.svg)

## ✨ 特性

### 🎯 双模式架构
- **模式 A - 用户自己的 Key**: 输入你的 OpenAI API Key，立即使用
- **模式 B - 免费服务器**: 使用公司提供的免费服务器，无需 API Key

### 💬 核心功能
- 在任何聊天 app 中一键生成幽默风趣的回复建议
- 支持微信、LINE、WhatsApp、备忘录等所有文本输入场景
- 点击建议即可插入到聊天框
- Keychain 安全存储，保护你的 API Key

### 🔒 安全性
- API Key 存储在 iOS Keychain，系统级加密
- 支持 App Groups 和 Keychain Sharing
- 遵循 Apple 安全最佳实践

## 🎬 快速开始

### 用户使用指南

1. **下载安装** SmartKeyboard（即将上架 App Store）
2. **打开 App**，选择使用模式：
   - 如果有 OpenAI Key：选择"我的 OpenAI Key"，输入你的 key
   - 如果没有：选择"公司服务器（免费）"
3. **启用键盘**：
   - 设置 → 通用 → 键盘 → 键盘 → 添加新键盘 → SmartKeyboard
   - 打开"允许完全访问"
4. **开始使用**：
   - 在任何 app 中打开键盘
   - 长按地球图标 🌐 切换到 SmartKeyboard
   - 输入你想说的话，点击"生成建议"
   - 选择一个建议插入到聊天框

## 🏗️ 技术架构

### iOS 客户端
- **语言**: Swift 5.9+
- **UI 框架**: SwiftUI
- **架构**: iOS Keyboard Extension
- **依赖**:
  - OpenAI Swift SDK (MacPaw/OpenAI)
  - iOS Keychain
  - App Groups

### 后端服务
- **语言**: Python 3.13
- **框架**: FastAPI
- **AI 模型**: OpenAI GPT-3.5-turbo
- **部署**: AWS EC2 (计划中)

### 项目结构
```
SmartKeyboard/
├── ios-app/                  # iOS Xcode 项目
│   └── SmartKeyboard/
│       ├── SmartKeyboard/    # 主 App
│       ├── KeyboardExtension/# 键盘扩展
│       └── Shared/           # 共享代码
├── backend/                  # Python 后端
│   ├── main.py
│   └── requirements.txt
├── swift-code/               # Swift 源代码模板
└── docs/                     # 文档
```

## 🛠️ 开发者指南

### 环境要求
- **macOS**: 14.0+ (Sonoma)
- **Xcode**: 16.0+
- **Python**: 3.13+
- **iOS 设备**: iOS 15.0+

### 后端开发

```bash
# 克隆项目
git clone https://github.com/rsong/SmartKeyboard.git
cd SmartKeyboard/backend

# 创建虚拟环境
python3 -m venv venv
source venv/bin/activate  # macOS/Linux
# venv\Scripts\activate   # Windows

# 安装依赖
pip install -r requirements.txt

# 配置环境变量
cp .env.example .env
# 编辑 .env，添加你的 OpenAI API Key

# 启动服务器
python main.py
# 服务器运行在 http://localhost:8000
```

### iOS 开发

1. **打开项目**
   ```bash
   cd ios-app/SmartKeyboard
   open SmartKeyboard.xcodeproj
   ```

2. **配置签名**
   - 选择 SmartKeyboard target
   - Signing & Capabilities → Team（选择你的 Apple ID）
   - 对 KeyboardExtension target 重复此步骤

3. **配置能力**
   - App Groups: `group.com.smartkeyboard.shared`
   - Keychain Sharing: 自动配置

4. **运行**
   - 连接真机（键盘扩展无法在模拟器测试）
   - 选择 SmartKeyboard scheme
   - Command + R 运行

### API 文档

**生成建议**
```http
POST /api/generate
Content-Type: application/json

{
  "context": "今天天气不错",
  "style": "幽默风趣"
}
```

**响应**
```json
{
  "suggestions": [
    "是啊，就像你的笑容一样灿烂 ☀️",
    "要不要一起出去走走？",
    "这么好的天气，适合和你聊天 😊"
  ]
}
```

## 📋 开发路线图

- [x] 基础键盘功能
- [x] 混合架构（用户 Key + 服务器）
- [x] iOS UI 设计
- [x] 后端 API 开发
- [ ] 真机测试和调试
- [ ] AWS 部署
- [ ] 多风格支持（正式、可爱、专业等）
- [ ] 多语言支持（英文、日文）
- [ ] App Store 上架
- [ ] 使用统计和分析
- [ ] 用户反馈系统

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

1. Fork 项目
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 提交 Pull Request

## 📄 许可证

[MIT License](LICENSE)

## 👨‍💻 作者

**Richard Song**
- Email: songyuguang@gmail.com
- GitHub: [@rsong](https://github.com/rsong)

## 🙏 致谢

- [OpenAI](https://openai.com/) - 提供强大的 AI 能力
- [MacPaw OpenAI Swift](https://github.com/MacPaw/OpenAI) - 优秀的 Swift SDK
- [FastAPI](https://fastapi.tiangolo.com/) - 现代化的 Python Web 框架

---

⭐ 如果这个项目对你有帮助，请给它一个 Star！

**Built with ❤️ for better chatting**
