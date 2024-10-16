import 'package:flutter/material.dart';
import 'package:untitled/app_screen/stress_map.dart';
import 'package:untitled/app_screen/user_detail.dart';
import 'con_blue.dart';
import 'result.dart';  // result.dart 파일 임포트
// import 'signin.dart';  // signin.dart 파일 임포트
import 'login.dart';   // login.dart 파일 임포트
import 'mypage.dart';  // 새로운 mypage.dart 파일 임포트

void main() {
  runApp(First());
}

class First extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Heart Measurement',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MeasurementPage(),
    );
  }
}

class MeasurementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[200],
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: Row(
          children: [
            Expanded(child: Container()), // 왼쪽 여백 채우기
            Text('임재환 님', style: TextStyle(fontSize: 18)), // 오른쪽 끝에 배치
          ],
        ),
        centerTitle: false,
      ),
      drawer: Drawer(
        child: Stack(
          children: [
            ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                Container(
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.blue[200],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('임재환 님', style: TextStyle(color: Colors.white, fontSize: 18)),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text('로그 아웃', style: TextStyle(color: Colors.black, fontSize: 18)),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: ListTile(
                      title: Text('마이 페이지', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyPage()),
                        );
                      },
                    ),
                  ),
                ),
                Container(
                  height: 70,
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: ListTile(
                      title: Text('정보 입력', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => UserDetailPage()),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ConBluePage()),
                    );
                  },
                  child: Text('블루투스 연결', style: TextStyle(fontSize: 16)),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // 배경 이미지 추가
          Image.asset(
            'image/bg.png',  // 배경 이미지 경로
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover, // 이미지가 화면을 덮도록 설정
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ResultPage()),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Image.asset(
                      'image/logo.png',
                      width: MediaQuery.of(context).size.width * 1.0,
                      height: MediaQuery.of(context).size.width * 0.9,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 하단 버튼 추가
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 20.0), // 하단에 여백 추가
              child: Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Expanded(
      child: IconButton(
        icon: Icon(Icons.calendar_today, color: Colors.blue),
        iconSize: 50.0,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StressMapPage()),
          );
        },
        tooltip: '캘린더',
      ),
    ),
     // 원하는 간격 유지
    Expanded(
      child: IconButton(
        icon: Icon(Icons.history, color: Colors.blue),
        iconSize: 50.0,
        onPressed: () {
          // 과거 기록 페이지로 이동
        },
        tooltip: '과거 기록',
      ),
    ),
  ],
),

            ),
          ),
        ],
      ),
    );
  }
}
