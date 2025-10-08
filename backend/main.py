from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from openai import OpenAI
import os
from dotenv import load_dotenv

# 加载环境变量
load_dotenv()

app = FastAPI(title="Smart Keyboard API", version="1.0.0")

# CORS 配置（允许 iOS 调用）
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# OpenAI 客户端
client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

# 请求模型
class GenerateRequest(BaseModel):
    context: str
    style: str = "幽默风趣"  # 默认风格

# 响应模型
class GenerateResponse(BaseModel):
    suggestions: list[str]

@app.get("/")
def root():
    return {"message": "Smart Keyboard API is running!", "version": "1.0.0"}

@app.get("/health")
def health():
    return {"status": "healthy"}

@app.post("/api/generate", response_model=GenerateResponse)
async def generate_suggestions(request: GenerateRequest):
    """
    根据用户输入生成泡妞话术建议
    """
    if not request.context or len(request.context.strip()) == 0:
        raise HTTPException(status_code=400, detail="Context cannot be empty")

    try:
        # 调用 OpenAI API
        response = client.chat.completions.create(
            model="gpt-3.5-turbo",
            messages=[
                {
                    "role": "system",
                    "content": f"""你是一个专业的聊天助手，帮助用户生成{request.style}的聊天回复。

规则：
1. 生成3个不同的回复建议
2. 风格要{request.style}
3. 适合追女生的场景
4. 每个建议控制在30字以内
5. 直接返回建议，不要编号，用换行符分隔
6. 要自然、不做作、有趣"""
                },
                {
                    "role": "user",
                    "content": f"我想回复：{request.context}\n\n请生成3个{request.style}的回复建议。"
                }
            ],
            temperature=0.8,
            max_tokens=200
        )

        # 解析响应
        content = response.choices[0].message.content.strip()
        suggestions = [s.strip() for s in content.split('\n') if s.strip()]

        # 确保至少有1个建议
        if not suggestions:
            suggestions = ["嗯嗯，有道理！", "哈哈好啊", "听起来不错"]

        # 最多返回3个
        suggestions = suggestions[:3]

        return GenerateResponse(suggestions=suggestions)

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"OpenAI API error: {str(e)}")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
