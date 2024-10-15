import 'package:flutter/material.dart';
import 'package:untitled/app%20screen/stress_map.dart';
import 'package:untitled/app%20screen/user_detail.dart';
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
                    border: Border.all(color: Colors.grey , width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3), // 그림자 색상
                        spreadRadius: 3, // 그림자 퍼짐 정도
                        blurRadius: 7, // 그림자 흐림 정도
                        offset: Offset(0, 3), // 그림자의 위치 (x축, y축)
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
                    border: Border.all(color: Colors.grey , width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3), // 그림자 색상
                        spreadRadius: 3, // 그림자 퍼짐 정도
                        blurRadius: 7, // 그림자 흐림 정도
                        offset: Offset(0, 3), // 그림자의 위치 (x축, y축)
                      ),
                    ],
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: ListTile(
                      title: Text('정보 입력', style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold)),
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
      body: Center(
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
                child: Expanded(
                  child: Image.asset(
                    'image/logo.png',
                    width: MediaQuery.of(context).size.width * 1.0,
                    height: MediaQuery.of(context).size.width * 0.9,
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
      // 하단 네비게이션 바 추가
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[100],
        height: 80,// 하단 앱바 배경색 설정
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.blue[200],
                  border: Border.all(color: Colors.white, width: 2), // 테두리 설정
                  borderRadius: BorderRadius.circular(5),
                ),
                child: IconButton(
                  icon: Icon(Icons.calendar_today,color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StressMapPage()),
                    );
                  },
                  tooltip: '캘린더',
                ),
              ),
            ),
            SizedBox(width: 16,),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.blue[200],
                  border: Border.all(color: Colors.white, width: 2), // 테두리 설정
                  borderRadius: BorderRadius.circular(5),
                ),
                child: IconButton(
                  icon: Icon(Icons.history ,color: Colors.white,),
                  onPressed: () {

                  },
                  tooltip: '과거 기록',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
