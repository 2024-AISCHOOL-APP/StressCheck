import 'package:flutter/material.dart';
import 'package:flutter_application_stresscheck/app_screen/first.dart';
import 'package:flutter_application_stresscheck/app_screen/login.dart';
import 'mypage.dart'; // 마이 페이지 임포트
import 'stress_map.dart'; // stress_map 페이지 임포트
import 'result.dart'; // result 페이지 임포트
import 'package:provider/provider.dart'; // Provider 사용
import 'auth_provider.dart'; // AuthProvider import

// 환경설정
class PastReslut extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 로그인 상태 확인을 위해 AuthProvider 사용
    final authProvider = Provider.of<AuthProvider>(context);
    final bool isLoggedIn = authProvider.isLoggedIn; // 로그인 상태 여부 확인

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
            Center( // 세로 가운데 정렬을 위해 Center 추가
              child: Padding(
                padding: const EdgeInsets.all(16.0), // 화면 전체에 패딩 추가
                child: SingleChildScrollView( // 스크롤 가능하도록 추가
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center, // 세로 가운데 정렬
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7, // 원하는 너비 설정
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
                                    height: MediaQuery.of(context).size.height * 0.8, // 높이를 화면 높이의 60%로 설정
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
                          child: Text('블루투스 연결', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                      SizedBox(height: 32,),
                      // 로그인 상태에 따라 로그인/로그아웃 버튼 동적 생성
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7, // 원하는 너비 설정
                        child: ElevatedButton(
                          onPressed: () {
                            if (isLoggedIn) {
                              authProvider.logout(); // 로그아웃 처리
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => LoginPage()),
                              );
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => LoginPage()),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[50], // 버튼 배경색
                            foregroundColor: Colors.black, // 글씨 색
                            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8), // 패딩 설정
                          ),
                          // 로그인 상태에 따라 버튼 텍스트 변경
                          child: Text(isLoggedIn ? '로그아웃' : '로그인', style: TextStyle(fontSize: 16)),
                        ),
                      ),
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
    currentIndex: 4, // 기본 선택된 인덱스는 환경 설정 페이지
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
        mainAxisAlignment: MainAxisAlignment.center,
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
