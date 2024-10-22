import 'package:flutter/material.dart';
import 'package:flutter_application_stresscheck/app_screen/first.dart';
import 'package:flutter_application_stresscheck/app_screen/login.dart';
import 'package:flutter_application_stresscheck/app_screen/past_reslut.dart';
import 'package:flutter_application_stresscheck/app_screen/result.dart';
import 'package:flutter_application_stresscheck/app_screen/stress_map.dart';
import 'package:flutter_application_stresscheck/app_screen/user_detail.dart';
import 'package:provider/provider.dart';  // Provider 사용
import 'auth_provider.dart';  // AuthProvider import

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 로그인된 사용자 정보를 가져오기
    final authProvider = Provider.of<AuthProvider>(context);
    final String? userName = authProvider.userName;  // 로그인된 사용자의 이름

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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                // 스크롤 가능하도록 설정
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'image/logo.png',
                      width: MediaQuery.of(context).size.width * 1.0,
                      height: MediaQuery.of(context).size.width * 0.4,
                    ),
                    SizedBox(height: 24),
                    Center(
                      child: Text(
                        userName != null ? "$userName 님" : "사용자 이름 불러오는 중...",  // 사용자 이름 표시
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 36),
                    buildInfoRow('성별', '남성'),
                    SizedBox(height: 16),
                    buildInfoRow('나이', '26세'),
                    SizedBox(height: 16),
                    buildInfoRow('직업', '백수'),
                    SizedBox(height: 16),
                    buildInfoRow('취미', '운동'),
                    SizedBox(height: 16),
                    buildInfoRow('수면시간', '8 시간'),

                    SizedBox(height: 36),
                    // 정보 수정 버튼 추가
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _imformation(context); // 정보 수정 메서드 호출
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 8,
                            ),
                            backgroundColor: Colors.blue[50], // 버튼 배경색 변경
                            foregroundColor: Colors.black, // 글씨 색 변경
                          ),
                          child: Text(
                            '정보 수정',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        SizedBox(width: 25),
                        ElevatedButton(
                          onPressed: () {
                            _logout(context); // 로그아웃 메서드 호출
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 8,
                            ),
                            backgroundColor: Colors.blue[50], // 버튼 배경색 변경
                            foregroundColor: Colors.black, // 글씨 색 변경
                          ),
                          child: Text(
                            '로그아웃',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildCustomBottomAppBar(context), // 하단 네비게이션바 추가
    );
  }

  // 반복되는 Row 생성을 위한 메소드
  Widget buildInfoRow(String label, String value) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey, // 밑줄 색상 설정
            width: 1.0, // 밑줄 두께 설정
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w600
            ),
          ),
        ],
      ),
    );
  }

  // 로그아웃 메서드
  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => LoginPage()), // 로그아웃 후 로그인 페이지로 이동
    );
  }

  // 정보 수정 페이지로 이동하는 메서드
  void _imformation(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => UserDetailPage()), // 정보 수정 페이지로 이동
    );
  }
}

Widget _buildCustomBottomAppBar(BuildContext context) {
  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    backgroundColor: Colors.white,
    currentIndex: 3, // 기본 선택된 인덱스는 마이 페이지
    onTap: (index) {
      // 각 페이지로 네비게이션
      if (index == 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => First()),
        );
      } else if (index == 1) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => StressMapPage()),
        );
      } else if (index == 2) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ResultPage()),
        );
      } else if (index == 3) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyPage()),
        );
      } else if (index == 4) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PastReslut()),
        );
        // 현재 페이지이므로 아무 작업도 하지 않음
      }
    },
    items: [
      BottomNavigationBarItem(
        icon: Icon(Icons.timelapse_outlined),
        label: '나의 하루들',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.calendar_today_rounded),
        label: '캘린더',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: '홈',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.book),
        label: '마이 페이지',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        label: '환경 설정',
      ),
    ],
    selectedItemColor: Colors.blue[300],
    unselectedItemColor: Colors.grey,
    selectedFontSize: 8.0,
    unselectedFontSize: 8.0,
    selectedIconTheme: IconThemeData(size: 24),
    unselectedIconTheme: IconThemeData(size: 24),
    showUnselectedLabels: true,
  );
}
