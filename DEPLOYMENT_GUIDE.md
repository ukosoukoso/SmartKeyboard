# 部署到公司服务器指南

## 🎯 两个版本对比

### 版本 A：用户自己的 OpenAI Key（原始版本）
- iOS 直接调用 OpenAI API
- 用户需要输入自己的 key
- 使用文件：
  - `ContentView.swift`
  - `KeyboardViewController.swift`
  - `OpenAIService.swift`

### 版本 B：公司服务器（服务器版本）✅ 推荐
- iOS 调用公司服务器 API
- 用户不需要 OpenAI key
- 使用文件：
  - `ContentView_ServerVersion.swift`（重命名为 ContentView.swift）
  - `KeyboardViewController_ServerVersion.swift`（重命名为 KeyboardViewController.swift）
  - `OpenAIService_ServerVersion.swift`（重命名为 OpenAIService.swift）

---

## 🚀 部署后端到公司服务器

### 方式 1：Docker 部署（推荐）

创建 `Dockerfile`:
```dockerfile
FROM python:3.11-slim

WORKDIR /app

COPY backend/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY backend/ .

EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
```

运行：
```bash
# 构建镜像
docker build -t smart-keyboard-backend .

# 运行容器
docker run -d -p 8000:8000 \
  -e OPENAI_API_KEY=你的key \
  --name smart-keyboard \
  smart-keyboard-backend
```

### 方式 2：直接运行

```bash
cd ~/SmartKeyboard/backend
source venv/bin/activate
export OPENAI_API_KEY=你的key
python main.py
```

### 方式 3：使用 systemd（Linux 服务器）

创建 `/etc/systemd/system/smart-keyboard.service`:
```ini
[Unit]
Description=Smart Keyboard Backend
After=network.target

[Service]
Type=simple
User=your-user
WorkingDirectory=/path/to/SmartKeyboard/backend
Environment="OPENAI_API_KEY=你的key"
ExecStart=/path/to/SmartKeyboard/backend/venv/bin/python main.py
Restart=always

[Install]
WantedBy=multi-user.target
```

启动服务：
```bash
sudo systemctl daemon-reload
sudo systemctl start smart-keyboard
sudo systemctl enable smart-keyboard
```

---

## 📱 修改 iOS 代码

### 更新服务器地址

在 `OpenAIService_ServerVersion.swift` 中：

```swift
init(serverURL: String = "http://your-company-server.com:8000") {
    self.serverURL = serverURL
}
```

改成你的服务器地址，比如：
- 内网：`http://192.168.1.100:8000`
- 外网：`http://api.yourcompany.com`

### HTTPS（生产环境必须）

iOS 默认要求 HTTPS。如果用 HTTP 需要配置 `Info.plist`:

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

⚠️ **但强烈建议用 HTTPS！** 可以用 Nginx + Let's Encrypt。

---

## 🧪 测试流程

### 1. 测试后端

```bash
curl -X POST http://your-server:8000/api/generate \
  -H "Content-Type: application/json" \
  -d '{"context": "今天天气不错", "style": "幽默风趣"}'
```

应该返回：
```json
{
  "suggestions": [
    "天气不错，比你更迷人！",
    "...",
    "..."
  ]
}
```

### 2. 在 iOS 上测试

1. 确保手机和服务器在同一网络（或服务器有公网 IP）
2. 运行 app
3. 启用键盘
4. 测试生成建议

---

## 📊 监控和日志

### 查看日志

```bash
# Docker
docker logs -f smart-keyboard

# systemd
sudo journalctl -u smart-keyboard -f

# 直接运行
# 日志会输出到终端
```

### 监控指标

- 请求数量
- 响应时间
- OpenAI API 费用

可以添加到 FastAPI 代码中记录日志。

---

## 💰 成本估算

### 公司服务器版本

假设 2 个用户，每天各用 20 次：

- **服务器成本**: $0（公司提供）
- **OpenAI API**:
  - 每次请求 ~200 tokens
  - GPT-3.5-turbo: $0.0005/请求
  - 每天：2人 × 20次 × $0.0005 = $0.02
  - **每月：~$0.60**

非常便宜！

---

## ⚠️ 安全注意事项

### 1. API 访问控制

添加简单认证（可选）：

```python
# main.py
from fastapi import Header, HTTPException

API_KEY = "your-secret-key"

@app.post("/api/generate")
async def generate(request: GenerateRequest, x_api_key: str = Header(None)):
    if x_api_key != API_KEY:
        raise HTTPException(status_code=401, detail="Unauthorized")
    # ...
```

iOS 代码添加 header：
```swift
request.setValue("your-secret-key", forHTTPHeaderField: "X-API-Key")
```

### 2. 频率限制

避免被滥用：

```python
from slowapi import Limiter
from slowapi.util import get_remote_address

limiter = Limiter(key_func=get_remote_address)

@app.post("/api/generate")
@limiter.limit("10/minute")  # 每分钟最多 10 次
async def generate(...):
    ...
```

---

## 📝 文件清单

**后端（已准备好）**：
- ✅ `backend/main.py`
- ✅ `backend/requirements.txt`
- ✅ `backend/.env`

**iOS（服务器版本）**：
- ✅ `ContentView_ServerVersion.swift`
- ✅ `KeyboardViewController_ServerVersion.swift`
- ✅ `OpenAIService_ServerVersion.swift`

**告诉我公司服务器地址，我帮你改好代码！**
