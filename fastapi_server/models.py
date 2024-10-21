from sqlalchemy import Column, Integer, String, Enum, DateTime
from database import Base
from datetime import datetime

class MemberModel(Base):
    __tablename__ = "tb_member"  

    user_id = Column(String(50), primary_key=True, index=True)  
    user_pw = Column(String(255))
    user_name = Column(String(100))
    # email = Column(String(100))
    # age = Column(Integer)
    # gender = Column(String(1))
    # created_at = Column(DateTime, default=datetime.utcnow)