# 실행방법
# uvicorn main:app --reload

from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import text
from database import engine, Base, get_db
from routers import member_router

app = FastAPI()

# 회원 라우터 포함
app.include_router(member_router, prefix="/members", tags=["members"])

# 데이터베이스 초기화
@app.on_event("startup")
async def startup():
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)

# DB 연결 테스트 엔드포인트
@app.get("/test")
async def test_db_connection(db: AsyncSession = Depends(get_db)):
    try:
        result = await db.execute(text("SELECT 1"))
        return {"status": "DB 연결 성공", "result": result.scalar()}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"DB 연결 실패: {str(e)}")
