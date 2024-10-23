from decimal import Decimal  # Decimal을 올바르게 import
from sqlalchemy import DECIMAL, Column, DateTime, Integer, String, ForeignKey, Date, PrimaryKeyConstraint, TIMESTAMP
from sqlalchemy.orm import relationship
from database import Base
from datetime import datetime


class MemberModel(Base):
    __tablename__ = "tb_member"

    user_id = Column(String(50), primary_key=True, index=True)  # VARCHAR
    user_pw = Column(String(255))  # VARCHAR
    user_name = Column(String(100))  # VARCHAR
    user_email = Column(String(100))  # VARCHAR
    user_birthdate = Column(Date)  # DATE
    user_gender = Column(String(1))  # CHAR (M 또는 F)
    joined_at = Column(TIMESTAMP, default=datetime.utcnow)  # TIMESTAMP
    user_job = Column(String(100))  # VARCHAR
    user_sleep = Column(Integer)  # INT
    user_point = Column(Integer)  # INT

    # 취미와의 관계 설정
    hobbies = relationship("HobbyModel", back_populates="member")

class HobbyModel(Base):
    __tablename__ = "tb_hobby"

    hobby_idx = Column(Integer, index=True)  # 인덱스로만 사용
    user_id = Column(String(50), ForeignKey("tb_member.user_id"))  # tb_member 테이블과 연결
    user_hobby = Column(String(100))  # 취미 이름

    # 복합 기본키 설정 (user_id와 hobby_idx를 복합키로 설정)
    __table_args__ = (
        PrimaryKeyConstraint('user_id', 'hobby_idx'),
    )

    # 관계 설정 (필요 시)
    member = relationship("MemberModel", back_populates="hobbies")
    
class AnalysisModel(Base):
    __tablename__ = "tb_analysis"  # 테이블 이름이 올바르게 설정되었는지 확인

    analysis_idx = Column(Integer, primary_key=True, index=True)
    user_id = Column(String(50), ForeignKey("tb_member.user_id"))  # VARCHAR(50)로 길이 설정
    stress_index = Column(DECIMAL)
    analysis_result = Column(Integer)
    analysis_details = Column(String(255))
    created_at = Column(TIMESTAMP)
