import 'package:flutter/material.dart';
import 'package:flutter_application_stresscheck/app_screen/mypage.dart';
import 'package:flutter_application_stresscheck/app_screen/past_reslut.dart';
import 'package:flutter_application_stresscheck/app_screen/result.dart';
import 'package:flutter_application_stresscheck/app_screen/stress_map.dart';
import 'first.dart';



// 주간, 월간 기록 페이지
class First extends StatelessWidget {
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
            Padding(
              padding: const EdgeInsets.all(16.0), // 화면 전체에 패딩 추가
              child: SingleChildScrollView(
                // 스크롤 가능하도록 변경
                child: Center(
                  child: Column(
                    children: [
                      
                      graph(context),
                      SizedBox(height: 16),
                      graph(context),
                      SizedBox(height: 16),
                      graph(context),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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
    currentIndex: 0, // 기본 선택된 인덱스는 스트레스 측정 페이지
    onTap: (index) {
      // 각 페이지로 네비게이션
      if (index == 0) {
        
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
          Text('웨어러블 기기를 연결해 주세요', style: TextStyle(fontSize: 16)),
          SizedBox(height: 8),
          Center(
            child: SizedBox(
              width: 200, // 원하는 너비 설정
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[50], // 버튼 배경색
                  foregroundColor: Colors.black, // 글씨 색
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                ),
                onPressed: () {
                  // 블루투스 페이지를 팝업으로 띄우기
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0), // 모서리 더 둥글게
                        ),
                        backgroundColor: Colors.transparent, // 흰색 배경 제거
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8, // 너비를 화면 너비의 80%로 설정
                          height: MediaQuery.of(context).size.height * 0.6, // 높이를 화면 높이의 60%로 설정
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40.0),
                            color: Colors.white,
                          ),
                          child: ConBluePopup(), // 블루투스 연결 팝업
                        ),
                      );
                    },
                  );
                },
                child: Text('블루투스 연결'),
              ),
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
          Text('주간 기록', style: TextStyle(fontSize: 16)),
          SizedBox(height: 2),
          Image.asset(
            'image/chart.png', // 배경 이미지 경로
            width: MediaQuery.of(context).size.width * 1, // 화면 너비에 맞춤
            height: MediaQuery.of(context).size.height * 0.2, // 높이 비율 조정
            fit: BoxFit.contain, // 이미지 비율 유지하면서 최대 크기로 맞춤
          ),
        ],
      ),
    ),
  );
}

// 블루투스 팝업 구성
class ConBluePopup extends StatefulWidget {
  @override
  _ConBluePopupState createState() => _ConBluePopupState();
}

class _ConBluePopupState extends State<ConBluePopup> {
  bool isConnected = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0), // 모서리 둥글게 설정
        image: DecorationImage(
          image: AssetImage('image/bg.png'), // 배경 이미지 설정
          fit: BoxFit.cover, // 이미지가 팝업 크기를 덮도록 설정
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.bluetooth,
            size: 100,
            color: isConnected ? Colors.blue : Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            isConnected ? '블루투스 연결됨' : '블루투스 연결 필요',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[50], // 버튼 배경색
              foregroundColor: Colors.black, // 글씨 색
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8), // 패딩 설정
            ),
            onPressed: () {
              setState(() {
                isConnected = !isConnected;
              });

              if (isConnected) {
                // 팝업을 닫고 First 페이지로 이동
                Navigator.pop(context); // 팝업 닫기
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => First()), // First 페이지로 이동
                );
              }
            },
            child: Text(isConnected ? '연결 해제' : '블루투스 연결'),
          ),
        ],
      ),
    );
  }
}
