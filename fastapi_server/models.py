from sqlalchemy import Column, Integer, String, ForeignKey, DateTime
from sqlalchemy.orm import relationship
from database import Base
from datetime import datetime

class MemberModel(Base):
    __tablename__ = "tb_member"

    user_id = Column(String(50), primary_key=True, index=True)
    user_pw = Column(String(255))
    user_name = Column(String(100))
    user_gender = Column(String(1))  # 성별 M 또는 F
    user_birthdate = Column(String(10))  # 생년월일 YYYY-MM-DD 형식
    user_job = Column(String(100))  # 직업
    user_sleep = Column(Integer)  # 수면 시간 (시간 단위)
    joined_at = Column(DateTime, default=datetime.utcnow)

    # 취미와의 관계 설정
    hobbies = relationship("HobbyModel", back_populates="member")


class HobbyModel(Base):
    __tablename__ = "tb_hobby"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(String(50), ForeignKey("tb_member.user_id"))  # 회원 테이블과 연결
    hobby_idx = Column(Integer)  # 취미 인덱스 (1, 2, 3)
    user_hobby = Column(String(100))  # 취미 이름

    # 회원과의 관계 설정
    member = relationship("MemberModel", back_populates="hobbies")
