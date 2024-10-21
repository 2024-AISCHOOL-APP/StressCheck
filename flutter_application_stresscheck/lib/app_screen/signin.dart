import 'package:flutter/material.dart';
import 'login.dart';
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
      // 비밀번호 확인 실패
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('비밀번호가 일치하지 않습니다.')));
      return;
    }

final response = await http.post(
  Uri.parse('http://10.0.2.2:8000/auth/register'),
  headers: {'Content-Type': 'application/json'},
  body: json.encode({
    'user_id': _userIdController.text,
    'user_name': _nameController.text,
    'user_pw': _passwordController.text,
  }),
);

if (response.statusCode == 200) {
  // 성공적으로 응답을 받았을 때
  final Map<String, dynamic> responseData = json.decode(response.body);
  print(responseData); // 응답 내용 확인
} else {
  print("Error: ${response.statusCode} - ${response.body}");
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
                    TextField(obscureText: true, controller: _passwordController),
                    SizedBox(height: 16),
                    Text("비밀번호를 확인해주세요", style: TextStyle(fontSize: 16)),
                    TextField(obscureText: true, controller: _confirmPasswordController),
                    SizedBox(height: 64),
                    Center(
                      child: ElevatedButton(
                        onPressed: _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[50],
                          foregroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
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
