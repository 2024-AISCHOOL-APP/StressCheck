import 'package:flutter/material.dart';
import 'package:flutter_application_stresscheck/app_screen/first.dart';
import 'package:flutter_application_stresscheck/app_screen/login.dart';
import 'package:flutter_application_stresscheck/app_screen/past_reslut.dart';
import 'package:flutter_application_stresscheck/app_screen/result.dart';
import 'package:flutter_application_stresscheck/app_screen/stress_map.dart';
import 'package:flutter_application_stresscheck/app_screen/user_detail.dart';

class MyPage extends StatelessWidget {
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
            child: SingleChildScrollView( // 스크롤 가능하도록 설정
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'image/logo.png',
                    width: MediaQuery.of(context).size.width * 1.0,
                    height: MediaQuery.of(context).size.width * 0.4,
                  ),
                  
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("임재환 님",style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                      SizedBox(height: 25),
                      buildInfoRow('성별', '남성'),
                      SizedBox(height: 25),
                      buildInfoRow('나이', '26세'),
                      SizedBox(height: 25),
                      buildInfoRow('수면시간', '8 시간'),
                      SizedBox(height: 25),
                      buildInfoRow('직업', '백수'),
                      SizedBox(height: 25),
                      buildInfoRow('취미', '운동'),
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
                              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                              backgroundColor: Colors.blue[50], // 버튼 배경색 변경
                              foregroundColor: Colors.black, // 글씨 색 변경
                            ),
                            
                            child: Text(
                              '정보 수정',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          SizedBox(width: 25),
                      // 로그아웃 버튼 추가
                      ElevatedButton(
                        onPressed: () {
                          _logout(context); // 로그아웃 메서드 호출
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          backgroundColor: Colors.blue[50], // 버튼 배경색 변경
                              foregroundColor: Colors.black, // 글씨 색 변경
                        ),
                        child: Text(
                          '로그아웃',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                        ],
                      ),
                      
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildCustomBottomAppBar(context), // 하단 네비게이션바 추가
    );
  }

  // 반복되는 Row 생성을 위한 메소드
  Widget buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          '   :   ',
          style: TextStyle(fontSize: 16, ),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 16, ),
        ),
      ],
    );
  }

  // 로그아웃 메서드
  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()), // 로그아웃 후 로그인 페이지로 이동
    );
  }

  // 정보 수정 페이지로 이동하는 메서드
  void _imformation(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => UserDetailPage()), // 정보 수정 페이지로 이동
    );
  }
}

Widget _buildCustomBottomAppBar(BuildContext context) {
  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed, 
    backgroundColor: Colors.white,
    currentIndex: 4, // 기본 선택된 인덱스는 마이 페이지
    onTap: (index) {
      // 각 페이지로 네비게이션
      if (index == 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => StressMapPage()),
        );
      } else if (index == 1) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ResultPage()),
        );
      } else if (index == 2) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => First()),
        );
      } else if (index == 3) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PastReslut()),
        );
      } else if (index == 4) {
        // 현재 페이지이므로 아무 작업도 하지 않음
      }
    },
    items: [
      BottomNavigationBarItem(
        icon: Icon(Icons.calendar_today),
        label: '캘린더',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.check_circle),
        label: '투데이',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: '홈',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.timelapse_outlined),
        label: '과거 기록',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        label: '마이 페이지',
      ),
    ],
    selectedItemColor: Colors.blue[300],
    unselectedItemColor: Colors.grey,
    selectedFontSize: 14.0, 
    unselectedFontSize: 14.0,
    selectedIconTheme: IconThemeData(size: 24),
    unselectedIconTheme: IconThemeData(size: 24),
    showUnselectedLabels: true,
  );
}
