import 'package:flutter/material.dart';
import 'package:flutter_application_stresscheck/app_screen/past_reslut.dart';
import 'login.dart'; // 로그인 페이지로 이동하기 위한 import
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  Future<void> _register() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('비밀번호가 일치하지 않습니다.')));
      return;
    }

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/auth/register'),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
      },
      body: json.encode({
        'user_id': _userIdController.text,
        'user_name': _nameController.text,
        'user_pw': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      // 성공적으로 응답을 받았을 때
      final Map<String, dynamic> responseData =
          json.decode(utf8.decode(response.bodyBytes));
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'])));

      // 로그인 페이지로 이동
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginPage()));
    } else {
      final errorData = json.decode(utf8.decode(response.bodyBytes));
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('회원가입 실패: ${errorData['detail']}')));
      print("Error: ${response.statusCode} - ${errorData['detail']}");
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 64),
                    Text("이름을 입력해주세요", style: TextStyle(fontSize: 16)),
                    TextField(controller: _nameController),
                    SizedBox(height: 16),
                    Text("아이디를 입력해주세요", style: TextStyle(fontSize: 16)),
                    TextField(controller: _userIdController),
                    SizedBox(height: 16),
                    Text("비밀번호를 입력해주세요", style: TextStyle(fontSize: 16)),
                    TextField(
                        obscureText: true, controller: _passwordController),
                    SizedBox(height: 16),
                    Text("비밀번호를 확인해주세요", style: TextStyle(fontSize: 16)),
                    TextField(
                        obscureText: true,
                        controller: _confirmPasswordController),
                    SizedBox(height: 64),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          _register(); // 회원가입 요청
                          // 페이지 이동 추가: 바로 로그인 페이지로 이동하는 코드 추가
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => PastReslut()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[50],
                          foregroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(
                              horizontal: 32, vertical: 8),
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
