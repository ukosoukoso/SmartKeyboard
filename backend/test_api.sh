#!/bin/bash

echo "🧪 Testing Smart Keyboard API"
echo ""

# 测试健康检查
echo "1️⃣ Testing health endpoint..."
curl -s http://localhost:8000/health | python3 -m json.tool
echo ""

# 测试生成建议
echo "2️⃣ Testing generate endpoint..."
curl -s -X POST http://localhost:8000/api/generate \
  -H "Content-Type: application/json" \
  -d '{"context": "今天天气不错", "style": "幽默风趣"}' | python3 -m json.tool
echo ""

echo "✅ Tests completed!"
