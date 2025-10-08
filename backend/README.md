# Smart Keyboard Backend

智能泡妞键盘后端 API

## 快速开始

### 1. 安装依赖
```bash
cd backend
python3 -m venv venv
source venv/bin/activate  # macOS/Linux
pip install -r requirements.txt
```

### 2. 配置环境变量
```bash
cp .env.example .env
# 编辑 .env 文件，填入你的 OpenAI API Key
```

### 3. 运行
```bash
python main.py
```

API 将运行在 http://localhost:8000

### 4. 测试
```bash
curl -X POST http://localhost:8000/api/generate \
  -H "Content-Type: application/json" \
  -d '{"context": "今天天气不错", "style": "幽默风趣"}'
```

## API 文档

访问 http://localhost:8000/docs 查看 Swagger 文档

## 部署到 Railway

1. 安装 Railway CLI: `npm i -g @railway/cli`
2. 登录: `railway login`
3. 初始化: `railway init`
4. 部署: `railway up`
5. 设置环境变量: `railway variables set OPENAI_API_KEY=your_key`
