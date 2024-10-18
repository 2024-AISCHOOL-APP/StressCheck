import 'package:flutter/material.dart';
import 'package:flutter_application_stresscheck/app_screen/first.dart';
import 'mypage.dart'; // 마이 페이지 임포트
import 'stress_map.dart'; // stress_map 페이지 임포트
import 'result.dart'; // result 페이지 임포트

class PastReslut extends StatelessWidget {
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
            padding: const EdgeInsets.all(16.0), // 화면 전체에 패딩 추가
            child: Center(
              child: Text(
                "",
                style: TextStyle(fontSize: 30),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildCustomBottomAppBar(context),
    );
  }
}

// BottomNavigationBar를 별도의 위젯으로 분리
Widget _buildCustomBottomAppBar(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed, 
      currentIndex: 3, // 기본 선택된 인덱스는 스트레스 측정 페이지
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
          
        } 
        else if (index == 4) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyPage()),
          );
          
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
      // 선택된 아이템과 선택되지 않은 아이템의 폰트 크기 동일하게 설정
  selectedFontSize: 14.0, 
  unselectedFontSize: 14.0,

  // 아이콘 크기도 동일하게 설정
  selectedIconTheme: IconThemeData(size: 24),
  unselectedIconTheme: IconThemeData(size: 24),
      showUnselectedLabels: true,
    );
  }