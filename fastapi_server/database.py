from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import sessionmaker
from models import Base

# MySQL 데이터베이스 URL 설정
DATABASE_URL = "mysql+aiomysql://root:test@localhost:3306/ex"

# 비동기 엔진 생성
engine = create_async_engine(DATABASE_URL, echo=True)

# 비동기 세션 생성
SessionLocal = sessionmaker(
    bind=engine,
    class_=AsyncSession,
    expire_on_commit=False
)

# 데이터베이스 종속성
async def get_db():
    async with SessionLocal() as session:
        yield session
