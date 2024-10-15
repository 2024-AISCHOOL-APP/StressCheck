from fastapi import APIRouter, HTTPException, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy.exc import IntegrityError
from models import Member
from schemas import MemberCreate, MemberLogin, MemberResponse
from database import get_db
from security import hash_password, pwd_context
from fastapi.security import OAuth2PasswordBearer
from jose import JWTError, jwt
import os

# JWT 비밀키를 환경 변수로부터 가져옴
SECRET_KEY = os.getenv("SECRET_KEY", "your-secret-key")

member_router = APIRouter()
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

# 회원가입 엔드포인트
@member_router.post("/register", response_model=MemberResponse)
async def register(member: MemberCreate, db: AsyncSession = Depends(get_db)):
    try:
        existing_member = await db.execute(select(Member).where(Member.email == member.email))
        if existing_member.scalars().first():
            raise HTTPException(status_code=400, detail="이메일이 이미 사용 중입니다.")

        new_member = Member(
            name=member.name,
            email=member.email,
            password=hash_password(member.password),
            age=member.age,
            gender=member.gender
        )
        db.add(new_member)
        await db.commit()
        await db.refresh(new_member)
        return new_member
    except IntegrityError:
        raise HTTPException(status_code=500, detail="Database error occurred.")

# 로그인 엔드포인트
@member_router.post("/login")
async def login(member: MemberLogin, db: AsyncSession = Depends(get_db)):
    existing_member = await db.execute(select(Member).where(Member.email == member.email))
    member_data = existing_member.scalars().first()

    if not member_data or not pwd_context.verify(member.password, member_data.password):
        raise HTTPException(status_code=400, detail="이메일 또는 비밀번호가 잘못되었습니다.")

    # JWT 토큰 생성
    access_token = jwt.encode({"sub": member_data.email}, SECRET_KEY, algorithm="HS256")
    
    return {"message": "로그인 성공", "access_token": access_token, "token_type": "bearer"}
