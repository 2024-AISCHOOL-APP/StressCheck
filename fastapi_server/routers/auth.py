from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from database import SessionLocal
from models import MemberModel, HobbyModel
from pydantic import BaseModel
from passlib.context import CryptContext
from fastapi.responses import JSONResponse

router = APIRouter()
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

# 회원가입 모델
class UserRegister(BaseModel):
    user_id: str  
    user_name: str
    user_pw: str

# 로그인 모델
class UserLogin(BaseModel):
    user_id: str  
    user_pw: str

# 회원탈퇴 모델
class UserDelete(BaseModel):
    user_id: str 
    user_pw: str

# 회원 정보 업데이트 모델
class MemberUpdate(BaseModel):
    user_id: str
    user_gender: str  # 성별 M/F
    user_birthdate: str  # 생년월일 (YYYY-MM-DD 형식)
    user_job: str  # 직업
    user_sleep: int  # 수면 시간 (시간 단위)

# 취미 정보 업데이트 모델
class HobbyUpdate(BaseModel):
    user_id: str
    hobby_idx: int  # 취미 인덱스 (1, 2, 3)
    user_hobby: str  # 취미 이름

# DB 세션 생성 함수
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# 로그인 엔드포인트
@router.post("/login")
async def login(user: UserLogin, db: Session = Depends(get_db)):
    db_user = db.query(MemberModel).filter(MemberModel.user_id == user.user_id).first()
    if not db_user:
        return JSONResponse(
            status_code=400,
            content={"detail": "사용자가 존재하지 않습니다."},
            media_type="application/json; charset=utf-8"
        )
    
    if not pwd_context.verify(user.user_pw, db_user.user_pw):
        return JSONResponse(
            status_code=400,
            content={"detail": "로그인 정보가 잘못되었습니다."},
            media_type="application/json; charset=utf-8"
        )

    return JSONResponse(
        content={"message": "로그인 성공", "user_id": db_user.user_id, "user_name": db_user.user_name},
        media_type="application/json; charset=utf-8"
    )

# 회원가입 엔드포인트
@router.post("/register")
async def register(user: UserRegister, db: Session = Depends(get_db)):
    try:
        if db.query(MemberModel).filter(MemberModel.user_id == user.user_id).first():
            raise HTTPException(status_code=400, detail="사용자가 이미 존재합니다.")

        hashed_password = pwd_context.hash(user.user_pw)

        new_user = MemberModel(
            user_id=user.user_id,
            user_name=user.user_name,
            user_pw=hashed_password
        )
        db.add(new_user)
        db.commit()
        
        return JSONResponse(content={"message": "회원가입 성공"}, media_type="application/json; charset=utf-8")
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

# 회원탈퇴 엔드포인트
@router.delete("/delete")
async def delete_account(user: UserDelete, db: Session = Depends(get_db)):
    db_user = db.query(MemberModel).filter(MemberModel.user_id == user.user_id).first()  
    if not db_user or not pwd_context.verify(user.user_pw, db_user.user_pw):
        raise HTTPException(status_code=400, detail="로그인 정보가 잘못되었습니다.")

    db.delete(db_user)
    db.commit()
    return {"message": "회원탈퇴가 완료되었습니다."}

# 회원 정보 업데이트 엔드포인트
@router.post("/user/update")
async def update_user_details(user: MemberUpdate, db: Session = Depends(get_db)):
    try:
        db_user = db.query(MemberModel).filter(MemberModel.user_id == user.user_id).first()
        if not db_user:
            raise HTTPException(status_code=400, detail="사용자를 찾을 수 없습니다.")

        db_user.user_gender = user.user_gender
        db_user.user_birthdate = user.user_birthdate
        db_user.user_job = user.user_job
        db_user.user_sleep = user.user_sleep
        
        db.commit()

        return JSONResponse(content={"message": "회원 정보 업데이트 완료"}, media_type="application/json; charset=utf-8")

    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=str(e))

# 취미 업데이트 엔드포인트
@router.post("/hobby/update")
async def update_hobby(hobby: HobbyUpdate, db: Session = Depends(get_db)):
    try:
        existing_hobby = db.query(HobbyModel).filter(HobbyModel.user_id == hobby.user_id, HobbyModel.hobby_idx == hobby.hobby_idx).first()
        
        if existing_hobby:
            existing_hobby.user_hobby = hobby.user_hobby
        else:
            new_hobby = HobbyModel(
                user_id=hobby.user_id,
                hobby_idx=hobby.hobby_idx,
                user_hobby=hobby.user_hobby
            )
            db.add(new_hobby)

        db.commit()

        return JSONResponse(content={"message": "취미 업데이트 완료"}, media_type="application/json; charset=utf-8")
    
    

    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=str(e))
