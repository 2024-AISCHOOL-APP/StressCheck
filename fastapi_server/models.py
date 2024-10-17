from sqlalchemy import Column, Integer, String, Enum, DateTime
from database import Base
from datetime import datetime

class MemberModel(Base):
    __tablename__ = "member"

    member_id = Column(Integer, primary_key=True, index=True)
    password = Column(String(255))
    name = Column(String(100))
    email = Column(String(100))
    age = Column(Integer)
    gender = Column(Enum('male', 'female', 'other'))
    created_at = Column(DateTime, default=datetime.utcnow)