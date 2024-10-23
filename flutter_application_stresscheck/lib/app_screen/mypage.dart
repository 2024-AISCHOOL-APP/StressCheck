import 'package:flutter/material.dart';
import 'package:flutter_application_stresscheck/app_screen/first.dart';
import 'package:flutter_application_stresscheck/app_screen/login.dart';
import 'package:flutter_application_stresscheck/app_screen/past_reslut.dart';
import 'package:flutter_application_stresscheck/app_screen/result.dart';
import 'package:flutter_application_stresscheck/app_screen/stress_map.dart';
import 'package:flutter_application_stresscheck/app_screen/user_detail.dart';
import 'package:provider/provider.dart'; // Provider 사용
import 'auth_provider.dart'; // AuthProvider import
import 'package:intl/intl.dart'; // 날짜 처리를 위한 패키지

class MyPage extends StatelessWidget {
  final String? userId; // 사용자 ID를 받기 위한 필드 추가

  MyPage({this.userId}); // 생성자에서 사용자 ID를 받을 수 있도록 설정

  @override
  Widget build(BuildContext context) {
    // 로그인된 사용자 정보를 가져오기
    final authProvider = Provider.of<AuthProvider>(context);
    final String? userName = authProvider.userName; // 로그인된 사용자의 이름
    final String? userGender = _convertGender(authProvider.userGender); // 로그인된 사용자의 성별을 변환
    final String? userBirthdate = authProvider.userBirthdate; // 로그인된 사용자의 생년월일
    final String? userJob = authProvider.userJob; // 로그인된 사용자의 직업
    final int? userSleep = authProvider.userSleep; // 로그인된 사용자의 수면 시간
    final int? userAge = _calculateAge(userBirthdate); // 생년월일을 나이로 변환

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
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'image/logo.png',
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width * 0.4,
                    ),
                    SizedBox(height: 24),
                    Center(
                      child: Text(
                        userName != null ? "$userName 님" : "",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(height: 36),
                    // 사용자 정보 표시
                    buildInfoRow('성별', userGender ?? ''),
                    SizedBox(height: 16),
                    buildInfoRow('나이', userAge != null ? '$userAge 세' : ''),
                    SizedBox(height: 16),
                    buildInfoRow('직업', userJob ?? ''),
                    SizedBox(height: 16),
                    buildInfoRow('수면시간', userSleep != null ? '$userSleep 시간' : ''),
                    SizedBox(height: 36),
                    // 정보 수정 버튼 추가
                    Center(
                      child: ElevatedButton(
                        onPressed: () => _navigateToUserDetail(context), // 정보 수정 메서드 호출
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                          backgroundColor: Colors.blue[50], // 버튼 배경색 변경
                          foregroundColor: Colors.black, // 글씨 색 변경
                        ),
                        child: Text('정보 수정', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildCustomBottomAppBar(context), // 하단 네비게이션바 추가
    );
  }

  // 성별 변환 메서드 (F -> 여성, M -> 남성)
  String? _convertGender(String? gender) {
    if (gender == 'F') return '여성';
    if (gender == 'M') return '남성';
    return '';
  }

  // 나이 계산 메서드 (생년월일을 나이로 변환)
  int? _calculateAge(String? birthdate) {
    if (birthdate == null) return null;

    try {
      DateTime birthDate = DateFormat('yyyy-MM-dd').parse(birthdate);
      DateTime today = DateTime.now();
      int age = today.year - birthDate.year;

      // 생일이 지나지 않았다면 나이를 1살 줄임
      if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }

      return age;
    } catch (e) {
      print('생년월일 변환 중 오류 발생: $e');
      return null;
    }
  }

  // 반복되는 Row 생성을 위한 메소드
  Widget buildInfoRow(String label, String value) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey, // 밑줄 색상 설정
            width: 1.0, // 밑줄 두께 설정
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  // 정보 수정 페이지로 이동하는 메서드
  void _navigateToUserDetail(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => UserDetailPage()), // 정보 수정 페이지로 이동
    );
  }
}

// Custom bottom navigation bar
Widget _buildCustomBottomAppBar(BuildContext context) {
  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    backgroundColor: Colors.white,
    currentIndex: 3, // 기본 선택된 인덱스는 마이 페이지
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
        // 현재 페이지, 아무 작업도 하지 않음
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
