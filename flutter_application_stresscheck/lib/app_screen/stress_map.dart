import 'package:flutter/material.dart';
import 'package:flutter_application_stresscheck/app_screen/past_reslut.dart';
import 'package:intl/intl.dart';
import 'result.dart'; // result.dart 파일 임포트
import 'first.dart'; // first.dart 파일 임포트
import 'mypage.dart'; // mypage.dart 파일 임포트

class StressMapPage extends StatefulWidget {
  @override
  _StressMapPageState createState() => _StressMapPageState();
}

class _StressMapPageState extends State<StressMapPage> {
  DateTime _focusedDay = DateTime.now(); // 현재 포커스된 날짜
  DateTime? _selectedDay; // 선택된 날짜

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
            child: Column(
              children: [
                _buildHeader(), // 달 이동 버튼
                _buildDaysOfWeek(), // 요일 표시
                SizedBox(height: 12,),
                _buildCalendarGrid(), // 날짜 그리드 표시
                if (_selectedDay != null) _buildSelectedDayInfo(), // 선택된 날짜 정보
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildCustomBottomAppBar(context),
      
    );
  }

  // 달력 헤더: 이전/다음 달 이동
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              setState(() {
                _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1, 1);
              });
            },
          ),
          Text(
            DateFormat.yMMMM().format(_focusedDay), // "2024년 10월" 형식
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              setState(() {
                _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 1);
              });
            },
          ),
        ],
      ),
    );
  }

  // 요일 표시
  Widget _buildDaysOfWeek() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: ['월', '화', '수', '목', '금', '토', '일']
            .map((day) => Text(day, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)))
            .toList(),
      ),
    );
  }

  // 달력 그리드
  Widget _buildCalendarGrid() {
    List<DateTime> daysInMonth = _daysInMonth(_focusedDay);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        shrinkWrap: true, // 그리드가 화면에서 모든 공간을 차지하지 않도록 설정
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7, // 7일씩 표시
          childAspectRatio: 1, // 박스의 너비 대비 높이 비율을 설정
        ),
        itemCount: daysInMonth.length,
        itemBuilder: (context, index) {
          DateTime day = daysInMonth[index];

          // 빈 날짜 처리
          if (day.year == 0) {
            return Container();
          }

          // 오늘 날짜 스타일
          bool isToday = day.year == DateTime.now().year &&
              day.month == DateTime.now().month &&
              day.day == DateTime.now().day;

          // 선택된 날짜 스타일
          bool isSelected = _selectedDay != null &&
              day.year == _selectedDay!.year &&
              day.month == _selectedDay!.month &&
              day.day == _selectedDay!.day;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDay = day;
              });
            },
            child: Container(
              margin: const EdgeInsets.all(2.0), // 간격을 줄임
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : (isToday ? Colors.green : Colors.white),
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey),
              ),
              child: Center(
                child: Text(
                  '${day.day}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // 현재 달의 모든 날짜 리스트
  List<DateTime> _daysInMonth(DateTime date) {
    final firstDay = DateTime(date.year, date.month, 1);
    final lastDay = DateTime(date.year, date.month + 1, 0);

    int totalDays = lastDay.day;
    List<DateTime> days = [];
    for (int i = 0; i < firstDay.weekday - 1; i++) {
      days.add(DateTime(0)); // 빈 날짜(전달)로 채움
    }
    for (int i = 1; i <= totalDays; i++) {
      days.add(DateTime(date.year, date.month, i));
    }
    while (days.length % 7 != 0) {
      days.add(DateTime(0)); // 빈 날짜(다음달)로 채움
    }
    return days;
  }

  // 선택된 날짜의 정보 표시
  Widget _buildSelectedDayInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0), // 양 옆 간격
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // 왼쪽 정렬
        children: [
          SizedBox(height: 16),
          Text(
            '선택된 날짜: ${_selectedDay!.year}-${_selectedDay!.month}-${_selectedDay!.day}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

Widget _buildCustomBottomAppBar(BuildContext context) {
  
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed, 
      backgroundColor: Colors.white,
      currentIndex: 0, // 기본 선택된 인덱스는 스트레스 측정 페이지
      onTap: (index) {
        // 각 페이지로 네비게이션
        if (index == 0) {
          
        } else if (index == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ResultPage()),
          );
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
      // 선택된 아이템과 선택되지 않은 아이템의 폰트 크기 동일하게 설정
  selectedFontSize: 14.0, 
  unselectedFontSize: 14.0,

  // 아이콘 크기도 동일하게 설정
  selectedIconTheme: IconThemeData(size: 24),
  unselectedIconTheme: IconThemeData(size: 24),
      showUnselectedLabels: true,
    );
  }
