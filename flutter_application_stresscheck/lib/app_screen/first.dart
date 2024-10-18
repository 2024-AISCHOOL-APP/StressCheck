import 'package:flutter/material.dart';
import 'package:flutter_application_stresscheck/app_screen/con_blue.dart';
import 'package:flutter_application_stresscheck/app_screen/past_reslut.dart';
import 'mypage.dart'; // 마이 페이지 임포트
import 'stress_map.dart'; // stress_map 페이지 임포트
import 'result.dart'; // result 페이지 임포트

class First extends StatelessWidget {
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
            child: SingleChildScrollView( // 스크롤 가능하도록 변경
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 16),
                    blue_con(context),
                    SizedBox(height: 16,),
                    graph(context),
                    SizedBox(height: 16,),
                    graph(context),
                    SizedBox(height: 16,),
                    graph(context),
                  ],
                ),
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
      currentIndex: 2, // 기본 선택된 인덱스는 스트레스 측정 페이지
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
          
        } else if (index == 3) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => PastReslut()),
          );
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
      selectedFontSize: 14.0, 
      unselectedFontSize: 14.0,
      selectedIconTheme: IconThemeData(size: 24),
      unselectedIconTheme: IconThemeData(size: 24),
      showUnselectedLabels: true,
    );
  }

Widget blue_con(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20.0),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 2,
          blurRadius: 3,
          offset: Offset(0, 0),
        ),
      ],
    ),
    padding: EdgeInsets.all(16.0),
    child: Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('웨어러블 기기를 연결해 주세요',
              style: TextStyle(fontSize: 16, )),
          
          SizedBox(height: 8),
          Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ConBluePage()), 
                    );
                  },
                  child: Text('블루투스 연결'),
                ),
              ),
          
         
        ],
      ),
    ),
  );
}

Widget graph(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20.0),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 2,
          blurRadius: 3,
          offset: Offset(0, 0),
        ),
      ],
    ),
    padding: EdgeInsets.all(16.0),
    child: Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('주간 기록',
              style: TextStyle(fontSize: 16, )),
          
          SizedBox(height: 2),
          Image.asset(
          'image/chart.png', // 배경 이미지 경로
          width: MediaQuery.of(context).size.width*1,
          height: MediaQuery.of(context).size.height*0.2,
          fit: BoxFit.cover, // 이미지가 화면을 덮도록 설정
        ),
         
        ],
      ),
    ),
  );
}
