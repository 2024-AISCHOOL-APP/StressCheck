# import
# pip install fastapi uvicorn

# 실행 방법
# uvicorn server:app --reload

from fastapi import FastAPI  # =Node.js의 express()
from fastapi.middleware.cors import CORSMiddleware  # =Node.js의 cors 

app = FastAPI()  # app 객체를 사용하여, FastAPI를 정의하고 사용

origins = ["http://localhost",
           "http://localhost:8000",   
           "http://192.168.70.45:8000",
           "http://127.0.0.1:8000"
           ]   # cors  허용할 도메인 정의


app.add_middleware(
    CORSMiddleware,
    allow_origins=origins, # 허용할 출저 설정
    allow_credentials=True, # 인증 정보(쿠키, 인증 헤더 등) 허용할지 여부
    allow_methods=["*"],  # 모든 HTTP 메서드 ( GET , POST , PUT 등) 허용
    allow_headers=["*"],  # 모든 HTTP 헤더를 허용  --> 헤더 : 대가리 , 어떤 방법 -> 요청(req) / 응답(res)
)

@app.get("/home")
async def read_home() :
    return {"message" : "패스트API에서 서버 응답 완료"}


