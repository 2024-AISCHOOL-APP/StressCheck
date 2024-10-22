import 'package:flutter/material.dart';
import 'package:flutter_application_stresscheck/app_screen/first.dart';
import 'package:flutter_application_stresscheck/app_screen/past_reslut.dart';
import 'package:flutter_application_stresscheck/app_screen/result.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'signin.dart'; // 회원가입 페이지

class LoginPage extends StatelessWidget {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // 로그인 메서드
Future<void> _login(BuildContext context) async {
  final response = await http.post(
    Uri.parse('http://10.0.2.2:8000/auth/login'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'user_id': _userIdController.text,
      'user_pw': _passwordController.text,
    }),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = json.decode(response.body);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(responseData['message'] ?? '로그인 성공'),
    ));
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ResultPage()),
    );
  } else {
    final Map<String, dynamic> responseData = json.decode(response.body);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(responseData['detail'] ?? '로그인 실패'),
    ));
  }
}


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
            SingleChildScrollView(
              // 스크롤 가능하도록 설정
              child: Padding(
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
                    SizedBox(height: 64), // 로고 아래에 여백 추가
                    TextField(
                      controller: _userIdController, // 텍스트 필드에 컨트롤러 추가
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black), // 선택 시 밑줄 검정색
                        ),
                        labelText: '아이디',
                        labelStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _passwordController, // 텍스트 필드에 컨트롤러 추가
                      obscureText: true,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black), // 선택 시 밑줄 검정색
                        ),
                        labelStyle: TextStyle(color: Colors.grey),
                        labelText: '비밀번호',
                      ),
                    ),
                    SizedBox(height: 64),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 200, // 원하는 너비 설정
                          child: ElevatedButton(
                            onPressed: () => _login(context), // 로그인 기능 호출
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[50], // 버튼 배경색
                              foregroundColor: Colors.black, // 글씨 색
                              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8), // 패딩 설정
                            ),
                            child: Text(
                              '로그인',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignInPage()), // 회원가입 페이지로 이동
                            );
                          },
                          child: Text(
                            "회원가입을 해주세요",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        )
                      ],
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
