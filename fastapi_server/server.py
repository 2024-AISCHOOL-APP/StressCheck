from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from database import SessionLocal, init_db
from models import MemberModel
from routers import auth

app = FastAPI()

# CORS 설정
origins = [
    "http://localhost",
    "http://127.0.0.1:8000",
    "http://192.168.70.42:8000"  # 여기서 192.168.70.42는 당신의 기기 IP 주소입니다.
]
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 데이터베이스 초기화
init_db()

# DB 세션 의존성 설정
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@app.post("/members/")
def create_tb_member(
    user_id: str,  
    password: str, 
    name: str, 
    email: str, 
    age: int, 
    gender: str,  
    db: Session = Depends(get_db)
):
    if gender not in ('m', 'f', 'o'):
        raise HTTPException(status_code=400, detail="Invalid gender value")

    new_member = MemberModel(
        user_id=user_id,  
        password=password,
        name=name,
        email=email,
        age=age,
        gender=gender
    )

    try:
        db.add(new_member)
        db.commit()
        db.refresh(new_member)
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=str(e))

    return {"message": "회원이 성공적으로 추가되었습니다.", "member_id": new_member.user_id}

@app.get("/members/{user_id}")
def read_member(user_id: str, db: Session = Depends(get_db)):
    member = db.query(MemberModel).filter(MemberModel.user_id == user_id).first()
    if member is None:
        raise HTTPException(status_code=404, detail="회원이 존재하지 않습니다.")

    return {
        "user_id": member.user_id,
        "name": member.name,
        "email": member.email,
        "age": member.age,
        "gender": member.gender,
    }

app.include_router(auth.router, prefix="/auth")
