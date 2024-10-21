from fastapi import FastAPI, APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from database import SessionLocal
from models import MemberModel  # MemberModel을 사용한다고 가정합니다.
from pydantic import BaseModel
from passlib.context import CryptContext
from fastapi.middleware.cors import CORSMiddleware


app = FastAPI()
router = APIRouter()
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
origins = ["http://localhost", "http://127.0.0.1:8000","http://10.0.2.2:8000"]

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # 필요에 따라 변경
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class UserRegister(BaseModel):
    user_id: str  
    user_name: str
    user_pw: str


class UserLogin(BaseModel):
    user_id: str  
    password: str

class UserDelete(BaseModel):
    user_id: str 
    password: str

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/register")
async def register(user: UserRegister, db: Session = Depends(get_db)):
    try:
        if db.query(MemberModel).filter(MemberModel.user_id == user.user_id).first():
            raise HTTPException(status_code=400, detail="사용자가 이미 존재합니다.")

        # hashed_password = pwd_context.hash(user.password)
        new_user = MemberModel(
            user_id=user.user_id,
            user_name=user.user_name,
            user_pw=user.user_pw
        )
        db.add(new_user)
        db.commit()
        return {"message": "회원가입 성공"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/login")
async def login(user: UserLogin, db: Session = Depends(get_db)):
    db_user = db.query(MemberModel).filter(MemberModel.user_id == user.user_id).first()  
    if not db_user or not pwd_context.verify(user.password, db_user.password):
        raise HTTPException(status_code=400, detail="로그인 정보가 잘못되었습니다.")
    return {"message": "로그인 성공"}

@router.delete("/delete")
async def delete_account(user: UserDelete, db: Session = Depends(get_db)):
    db_user = db.query(MemberModel).filter(MemberModel.user_id == user.user_id).first()  
    if not db_user or not pwd_context.verify(user.password, db_user.password):
        raise HTTPException(status_code=400, detail="로그인 정보가 잘못되었습니다.")

    db.delete(db_user)
    db.commit()
    return {"message": "회원탈퇴가 완료되었습니다."}

# 라우터 등록
app.include_router(router)