import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'auth_provider.dart'; // AuthProvider import
import 'result.dart'; // ResultPage import
import 'signin.dart'; // SignInPage import

class LoginPage extends StatelessWidget {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user_id': _userIdController.text,
          'user_pw': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        // 서버 응답을 디코딩
        final Map<String, dynamic> responseData = json.decode(response.body);

        // 서버에서 받은 모든 정보
        String? userId = responseData['user_id'];
        String? userName = responseData['user_name'];
        String? userGender = responseData['user_gender'];
        String? userBirthdate = responseData['user_birthdate'];
        String? userJob = responseData['user_job'];
        int? userSleep = responseData['user_sleep'];
        List<dynamic>? analysisInfo = responseData['analysis_info']; // 스트레스 정보

        // userId와 userName이 null인 경우 처리
        if (userId == null || userName == null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('로그인 응답에 user_id 또는 user_name이 없습니다.'),
          ));
          return;
        }

        // AuthProvider에 모든 정보 저장
        Provider.of<AuthProvider>(context, listen: false).login(
          userId,
          userName,
          userGender ?? 'N/A',  // null일 경우 기본값 설정
          userBirthdate ?? 'N/A',
          userJob ?? 'N/A',
          userSleep ?? 0,  // null일 경우 기본값 설정
          analysisInfo ?? [], // 스트레스 정보 리스트 null 처리
        );

        // 스트레스 정보 출력 (디버깅 용도)
        print('스트레스 정보: $analysisInfo');
        
        // 로그인 성공 후 ResultPage로 이동
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ResultPage()),
        );
      } else {
        final Map<String, dynamic> errorData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('로그인 실패: ${errorData['detail'] ?? '알 수 없는 오류'}'),
        ));
      }
    } catch (error) {
      // 네트워크 또는 다른 오류 처리
      print('Error during login: $error');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('로그인 중 오류가 발생했습니다.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Image.asset(
              'image/bg.png',
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.cover,
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'image/logo.png',
                      width: MediaQuery.of(context).size.width * 1.0,
                      height: MediaQuery.of(context).size.width * 0.4,
                    ),
                    SizedBox(height: 64),
                    TextField(
                      controller: _userIdController,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        labelText: '아이디',
                        labelStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        labelStyle: TextStyle(color: Colors.grey),
                        labelText: '비밀번호',
                      ),
                    ),
                    SizedBox(height: 64),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 홈으로 버튼 추가
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => ResultPage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[50],
                            foregroundColor: Colors.black,
                            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                          ),
                          child: Text('홈으로'),
                        ),
                        SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () => _login(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[50],
                            foregroundColor: Colors.black,
                            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                          ),
                          child: Text('로그인'),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        // 회원가입 페이지로 이동
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignInPage()),
                        );
                      },
                      child: Text(
                        '회원가입',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey, // 색상을 변경
                          decoration: TextDecoration.underline, // 밑줄 추가
                        ),
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
