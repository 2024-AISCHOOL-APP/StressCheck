import 'package:flutter/material.dart';
import 'mypage.dart'; // 마이 페이지 임포트
import 'stress_map.dart'; // stress_map 페이지 임포트
import 'result.dart'; // result 페이지 임포트
import 'first.dart'; // first 페이지 임포트

class CustomBottomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (index) {
        // 각 페이지로 네비게이션
        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StressMapPage()),
          );
        } else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ResultPage()),
          );
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => First()),
          );
        } else if (index == 3) {
          Navigator.push(
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
          label: '스트레스 측정',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: '설정',
        ),
      ],
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
    );
  }
}
