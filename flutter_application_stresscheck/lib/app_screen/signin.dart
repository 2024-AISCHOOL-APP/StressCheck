import 'package:flutter/material.dart';
import 'login.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // 배경 이미지 추가
            Image.asset(
              'image/bg.png', // 배경 이미지 경로
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.cover, // 이미지가 화면을 덮도록 설정
            ),
            SingleChildScrollView( // 스크롤 가능하도록 설정
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 64),
                    Text("이름을 입력해주세요", style: TextStyle(fontSize: 16)),
                    TextField(
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.grey),
                        labelText: '이름',
                      ),
                    ),
                    SizedBox(height: 16),
                    Text("아이디를 입력해주세요", style: TextStyle(fontSize: 16)),
                    TextField(
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.grey),
                        labelText: '아이디',
                      ),
                    ),
                    SizedBox(height: 16),
                    Text("비밀번호를 입력해주세요", style: TextStyle(fontSize: 16)),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.grey),
                        labelText: '비밀번호',
                      ),
                    ),
                    SizedBox(height: 16),
                    Text("비밀번호를 확인해주세요", style: TextStyle(fontSize: 16)),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.grey),
                        labelText: '비밀번호 확인',
                        
                      ),
                    ),
                    SizedBox(height: 64),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[50], // 버튼 배경색
                          foregroundColor: Colors.black, // 글씨 색
                          padding: EdgeInsets.symmetric(
                              horizontal: 32, vertical: 8), // 패딩 설정
                        ),
                        child: Text('회원가입'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
