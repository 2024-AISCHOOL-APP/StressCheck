import 'package:flutter/material.dart';
import 'package:flutter_application_stresscheck/app_screen/first.dart';
import 'con_blue.dart'; // 필요에 따라 수정하세요
import 'signin.dart'; // 회원가입 페이지

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 배경 이미지 추가
          Image.asset(
            'image/bg.png', // 배경 이미지 경로
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover, // 이미지가 화면을 덮도록 설정
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start, // 위쪽부터 시작
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'image/logo.png',
                  width: MediaQuery.of(context).size.width * 1.0,
                  height: MediaQuery.of(context).size.width * 0.4,
                ),
                SizedBox(height: 32), // 로고 아래에 여백 추가
                TextField(
                  decoration: InputDecoration(
                    labelText: '아이디',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: '비밀번호',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 32),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        print('로그인 버튼 클릭'); // 디버그용 로그 출력
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => First()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[50], // 버튼 배경색
                        foregroundColor: Colors.black, // 글씨 색
                        padding: EdgeInsets.symmetric(
                            horizontal: 32, vertical: 12), // 패딩 설정
                      ),
                      child: Text(
                        '로그인',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignInPage()), // SignUpPage로 이동
    );
  },
  child: Text(
    "회원가입을 해주세요",
    style: TextStyle(fontSize: 8),
  ),
)

                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
