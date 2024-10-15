from pydantic import BaseModel

# 공통 베이스 스키마
class MemberBase(BaseModel):
    name: str
    email: str

# 회원가입 요청 스키마
class MemberCreate(MemberBase):
    password: str  # 비밀번호 필드 추가
    age: int
    gender: str

# 회원 정보 응답 스키마
class MemberResponse(MemberBase):
    id: int
    age: int
    gender: str

    class Config:
        orm_mode = True

# 로그인 요청 스키마
class MemberLogin(BaseModel):
    email: str
    password: str
