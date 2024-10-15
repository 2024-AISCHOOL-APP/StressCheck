from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from database import SessionLocal
from models import MemberModel
from pydantic import BaseModel
from passlib.context import CryptContext

router = APIRouter()
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

class UserRegister(BaseModel):
    member_id: int
    name: str
    email: str
    password: str
    age: int
    gender: str

class UserLogin(BaseModel):
    member_id: int
    password: str

class UserDelete(BaseModel):
    member_id: int
    password: str


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/register")
async def register(user: UserRegister, db: Session = Depends(get_db)):
    if db.query(MemberModel).filter(MemberModel.member_id == user.member_id).first():
        raise HTTPException(status_code=400, detail="사용자가 이미 존재합니다.")
    
    hashed_password = pwd_context.hash(user.password)
    new_user = MemberModel(
        member_id=user.member_id,
        name=user.name,
        email=user.email,
        password=hashed_password,
        age=user.age,
        gender=user.gender
    )
    db.add(new_user)
    db.commit()
    return {"message": "회원가입 성공"}

@router.post("/login")
async def login(user: UserLogin, db: Session = Depends(get_db)):
    db_user = db.query(MemberModel).filter(MemberModel.member_id == user.member_id).first()
    if not db_user or not pwd_context.verify(user.password, db_user.password):
        raise HTTPException(status_code=400, detail="로그인 정보가 잘못되었습니다.")
    return {"message": "로그인 성공"}

@router.delete("/delete")
async def delete_account(user: UserDelete, db: Session = Depends(get_db)):
    db_user = db.query(MemberModel).filter(MemberModel.member_id == user.member_id).first()
    if not db_user or not pwd_context.verify(user.password, db_user.password):
        raise HTTPException(status_code=400, detail="로그인 정보가 잘못되었습니다.")

    db.delete(db_user)
    db.commit()
    return {"message": "회원탈퇴가 완료되었습니다."}