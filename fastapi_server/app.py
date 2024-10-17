from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from routers import auth
from database import init_db

app = FastAPI()

origins = ["http://localhost", "http://127.0.0.1:8000"]

# test url = http://127.0.0.1:8000/docs#

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 데이터베이스 초기화
init_db()

@app.get("/home")
async def read_home():
    return {"message": "패스트API에서 서버 응답 완료"}

app.include_router(auth.router, prefix="/auth")