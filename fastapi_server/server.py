from fastapi import FastAPI, Depends
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from database import SessionLocal, init_db
from models import MemberModel
from routers import auth
from fastapi import HTTPException

app = FastAPI()

# uvicorn server:app --reload


# CORS 설정
origins = ["http://localhost", "http://127.0.0.1:8000","http://10.0.2.2:8000"]

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

@app.get("/")
async def read_root():
    return {"message": "Welcome to the API!"}

@app.get("/favicon.ico")
async def favicon():
    return {"message": "Favicon not found."}

# 홈 경로
@app.get("/home")
async def read_home():
    return {"message": "패스트API에서 서버 응답 완료"}


# 테스트용
# 멤버 데이터 삽입 엔드포인트
@app.post("/members/")
def create_tb_member(
    user_id: str,  
    password: str, 
    name: str, 
    email: str, 
    age: int, 
    gender: str,  # 여전히 문자열로 받습니다
    db: Session = Depends(get_db)
):
    # 유효성 검사: gender가 Enum의 값 중 하나인지 확인
    if gender not in ('m', 'f', 'o'):
        raise HTTPException(status_code=400, detail="Invalid gender value")
    

    # 비밀번호 해싱
    # pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
    # hashed_password = pwd_context.hash(password)

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
        db.refresh(new_member)  # 새로 삽입된 member_id를 가져옵니다
    except Exception as e:
        db.rollback()  # 문제가 있을 경우 롤백
        raise HTTPException(status_code=500, detail=str(e))
    
    




app.include_router(auth.router, prefix="/auth")