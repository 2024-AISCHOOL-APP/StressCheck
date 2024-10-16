# database.py
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

# DATABASE_URL = "mysql+pymysql://username:password@localhost/db_name"
DATABASE_URL = "mysql+pymysql://Insa5_App_final_4:aischool4@3307/임재환팀"

# SQLAlchemy 설정
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

# 테이블 생성
def init_db():
    import models  # 모델을 임포트하여 테이블 생성
    Base.metadata.create_all(bind=engine)