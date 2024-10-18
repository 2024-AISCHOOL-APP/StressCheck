from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base

# DATABASE_URL = "mysql+pymysql://username:password@localhost/db_name"

DATABASE_URL = "mysql+pymysql://Insa5_App_final_4:aischool4@project-db-stu3.smhrd.com:3307/Insa5_App_final_4"

# SQLAlchemy 설정
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

# 테이블 생성
def init_db():
    import models  # 모델을 임포트하여 테이블 생성
    Base.metadata.create_all(bind=engine)

