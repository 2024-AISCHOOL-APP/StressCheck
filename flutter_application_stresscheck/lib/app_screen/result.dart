import 'package:flutter/material.dart';
import 'package:flutter_application_stresscheck/app_screen/first.dart';
import 'package:flutter_application_stresscheck/app_screen/mypage.dart';
import 'package:flutter_application_stresscheck/app_screen/past_reslut.dart';
import 'package:flutter_application_stresscheck/app_screen/stress_map.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart'; // AuthProvider import

class ResultPage extends StatefulWidget {
  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int currentIndex = 1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: -20).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 로그인된 사용자 정보 가져오기
    final authProvider = Provider.of<AuthProvider>(context);
    final userId = authProvider.userId;
    final userName = authProvider.userName;
    final isLoggedIn = authProvider.isLoggedIn;

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
                  children: [
                    blue_con(context),
                    SizedBox(height: 16),

                    // 로그인 상태에 따른 메시지 표시
                    isLoggedIn
                        ? Text(
                            '$userName 님, 안녕하세요!',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          )
                        : Text(
                            '로그인을 해주세요',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                    
                    SizedBox(height: 16),
                    _buildStressStatusContainer(context),
                    SizedBox(height: 16),
                    _buildMeasurementContainers(context),
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

  // 블루투스 연결 UI 구성
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
                width: 200,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[50],
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                  ),
                  onPressed: () {
                    // 블루투스 연결 팝업 표시
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          backgroundColor: Colors.transparent,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: MediaQuery.of(context).size.height * 0.8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40.0),
                              color: Colors.white,
                            ),
                            child: ConBluePopup(),
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

  // 하단 네비게이션바
   Widget _buildCustomBottomAppBar(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      currentIndex: 2,
      onTap: (index) {
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
      selectedIconTheme: IconThemeData(size: 24),
      unselectedIconTheme: IconThemeData(size: 24),
      showUnselectedLabels: true,
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
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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

  // 측정 데이터 컨테이너
  Widget _buildMeasurementContainers(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _measurementContainer(context, '심박수', '90', 'BPM'),
            _measurementContainer(context, '산소포화도', '95', '%'),
          ],
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _measurementContainer(context, '체온', '36.5', '도'),
            _measurementContainer(context, '혈압', '118', 'mmHg'),
          ],
        ),
      ],
    );
  }

  // 측정 데이터를 보여주는 개별 컨테이너
  Widget _measurementContainer(BuildContext context, String title, String value, String unit) {
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
              Text(unit, style: TextStyle(fontSize: 12, color: Colors.grey[400])),
            ],
          ),
        ],
      ),
    );
  }
}

// 블루투스 팝업
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
        borderRadius: BorderRadius.circular(20.0),
        image: DecorationImage(
          image: AssetImage('image/bg.png'),
          fit: BoxFit.cover,
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
              backgroundColor: Colors.blue[50],
              foregroundColor: Colors.black,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
            ),
            onPressed: () {
              setState(() {
                isConnected = !isConnected;
              });

              if (isConnected) {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => First()),
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
