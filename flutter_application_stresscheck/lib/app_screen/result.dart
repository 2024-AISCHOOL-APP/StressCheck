import 'package:flutter/material.dart';
import 'package:flutter_application_stresscheck/app_screen/past_reslut.dart';
import 'mypage.dart'; // 마이 페이지 임포트
import 'package:intl/intl.dart';
import 'stress_map.dart'; // stress_map 페이지 임포트
import 'first.dart'; // First 페이지 임포트


// 첫페이지
class ResultPage extends StatefulWidget {
  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int currentIndex = 1; // currentIndex 변수 선언 및 초기화

  @override
  void initState() {
    super.initState();
    // AnimationController 초기화
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    // Tween을 사용하여 애니메이션 설정
    _animation = Tween<double>(begin: 0, end: -20).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // 애니메이션 컨트롤러 해제
    super.dispose();
  }

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
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0), // 화면 전체에 패딩 추가
                child: Column(
                  children: [
                    blue_con(context),
                      SizedBox(height: 16),
                    
                    _buildStressStatusContainer(context), 
                    SizedBox(height: 16),
                    _buildMeasurementContainers(context), // 측정 데이터 컨테이너들
                    // 스트레스 상태를 보여주는 컨테이너
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildCustomBottomAppBar(context),
    );
  }

  // 하단 네비게이션바 커스터마이징
  Widget _buildCustomBottomAppBar(BuildContext context) {
  return BottomNavigationBar(
    backgroundColor: Colors.white,
    type: BottomNavigationBarType.fixed, // 애니메이션을 제거하여 고정된 스타일 적용
    currentIndex: 2,
    onTap: (index) {
      setState(() {
        currentIndex = 2;
      });
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

    // 아이콘 크기도 동일하게 설정
    selectedIconTheme: IconThemeData(size: 24),
    unselectedIconTheme: IconThemeData(size: 24),
    showUnselectedLabels: true,
  );
}


  // 측정 데이터 컨테이너를 묶어주는 함수
  Widget _buildMeasurementContainers(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            bpm(context, '심박수', '90', 'BPM'),
            oxygen(context, '산소포화도', '95', '%'),
          ],
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            temp(context, '체온', '36.5', '도'),
            blood(context, '혈압', '118', 'mmHg'),
          ],
        ),
      ],
    );
  }

  // 측정 데이터 컨테이너를 생성하는 함수
  Widget bpm(BuildContext context, String title, String value, String unit) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.43,
      padding: EdgeInsets.all(16.0),
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.favorite_border, color: Colors.red, size: 24.0),
              SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 6),
              Text(unit, style: TextStyle(fontSize: 12,color: Colors.grey[400])),
            ],
          ),
        ],
      ),
    );
  }
  Widget oxygen(BuildContext context, String title, String value, String unit) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.43,
      padding: EdgeInsets.all(16.0),
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.monitor_heart, color: Colors.red, size: 24.0),
              SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 6),
              Text(unit, style: TextStyle(fontSize: 12,color: Colors.grey[400])),
            ],
          ),
        ],
      ),
    );
  }
  Widget temp(BuildContext context, String title, String value, String unit) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.43,
      padding: EdgeInsets.all(16.0),
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.thermostat, color: Colors.red, size: 24.0),
              SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(fontSize: 16, ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 6),
              Text(unit, style: TextStyle(fontSize: 12,color: Colors.grey[400])),
            ],
          ),
        ],
      ),
    );
  }
  Widget blood(BuildContext context, String title, String value, String unit) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.43,
      padding: EdgeInsets.all(16.0),
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.water_drop_outlined, color: Colors.red, size: 24.0),
              SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 6),
              Text(unit, style: TextStyle(fontSize: 12,color: Colors.grey[400])),
            ],
          ),
        ],
      ),
    );
  }

  // 스트레스 상태를 보여주는 컨테이너
  Widget _buildStressStatusContainer(BuildContext context) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('오늘의 스트레스 상태는',
              style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600 )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('보통',
                          style: TextStyle(
                              fontSize: 36, fontWeight: FontWeight.bold)),
                      Text('  이에요',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Text('102',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ),
            ],
          ),
          SizedBox(height: 16),
          Center(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _animation.value),
                  child: child,
                );
              },
              child: Image.asset(
                'image/soso.png',
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.width * 0.5,
              ),
            ),
          ),
          Center(
            child: Text('이런 기분도 나쁘지 않아요.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
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
                child: Text('블루투스 연결'),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}