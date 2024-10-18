import 'package:flutter/material.dart';
import 'package:flutter_application_stresscheck/app_screen/past_reslut.dart';
import 'mypage.dart'; // 마이 페이지 임포트
import 'package:intl/intl.dart';
import 'stress_map.dart'; // stress_map 페이지 임포트
import 'first.dart'; // First 페이지 임포트

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
      body: Stack(
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
      bottomNavigationBar: _buildCustomBottomAppBar(context),
    );
  }

  // 하단 네비게이션바 커스터마이징
  Widget _buildCustomBottomAppBar(BuildContext context) {
  return BottomNavigationBar(
    backgroundColor: Colors.white,
    type: BottomNavigationBarType.fixed, // 애니메이션을 제거하여 고정된 스타일 적용
    currentIndex: currentIndex,
    onTap: (index) {
      setState(() {
        currentIndex = index;
      });
      if (index == 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => StressMapPage()),
        );
      } else if (index == 1) {
        // 현재 페이지이므로 아무 작업도 하지 않음
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
      width: MediaQuery.of(context).size.width * 0.45,
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
            mainAxisAlignment: MainAxisAlignment.start,
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 8),
              Text(unit, style: TextStyle(fontSize: 20,color: Colors.grey[400])),
            ],
          ),
        ],
      ),
    );
  }
  Widget oxygen(BuildContext context, String title, String value, String unit) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
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
            mainAxisAlignment: MainAxisAlignment.start,
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 8),
              Text(unit, style: TextStyle(fontSize: 20,color: Colors.grey[400])),
            ],
          ),
        ],
      ),
    );
  }
  Widget temp(BuildContext context, String title, String value, String unit) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
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
            mainAxisAlignment: MainAxisAlignment.start,
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 8),
              Text(unit, style: TextStyle(fontSize: 20,color: Colors.grey[400])),
            ],
          ),
        ],
      ),
    );
  }
  Widget blood(BuildContext context, String title, String value, String unit) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
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
            mainAxisAlignment: MainAxisAlignment.start,
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 8),
              Text(unit, style: TextStyle(fontSize: 20,color: Colors.grey[400])),
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
              style: TextStyle(fontSize: 20, )),
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
                              fontSize: 20, )),
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
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.width * 0.4,
              ),
            ),
          ),
          Center(
            child: Text('이런 기분도 나쁘지 않아요.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
