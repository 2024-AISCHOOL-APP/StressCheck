import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StressMapPage extends StatefulWidget {
  @override
  _StressMapPageState createState() => _StressMapPageState();
}

class _StressMapPageState extends State<StressMapPage> {
  DateTime _focusedDay = DateTime.now(); // 현재 포커스된 날짜
  DateTime? _selectedDay; // 선택된 날짜
  Map<DateTime, List<String>> _events = {}; // 날짜별 이벤트 저장

  // 현재 달의 모든 날짜 리스트
  List<DateTime> _daysInMonth(DateTime date) {
    final firstDay = DateTime(date.year, date.month, 1);
    final lastDay = DateTime(date.year, date.month + 1, 0);

    // 달의 첫 번째 날의 요일과 마지막 날의 요일로 그리드를 완성
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

  @override
  Widget build(BuildContext context) {
    List<DateTime> daysInMonth = _daysInMonth(_focusedDay); // 현재 달의 날짜 목록

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[200],
        title: Text('스트레스 켈린더', style: TextStyle(fontSize: 18)),
        centerTitle: true,
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
          Column(
            children: [
              _buildHeader(), // 달 이동 버튼
              _buildDaysOfWeek(), // 요일 표시
              _buildCalendarGrid(daysInMonth), // 날짜 그리드 표시
              SizedBox(height: 16), // 캘린더와 선택된 날짜 정보 사이의 간격
              if (_selectedDay != null) _buildSelectedDayInfo(), // 선택된 날짜 정보
            ],
          ),
        ],
      ),
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['월', '화', '수', '목', '금', '토', '일']
                .map((day) => Text(day, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)))
                .toList(),
          ),
          SizedBox(height: MediaQuery.of(context).size.width * 0.03,),
        ],
      ),
    );
  }

  // 달력 그리드
  Widget _buildCalendarGrid(List<DateTime> days) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0), // 양 옆에 패딩 추가
      child: GridView.builder(
        shrinkWrap: true, // 그리드가 화면에서 모든 공간을 차지하지 않도록 설정
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7, // 7일씩 표시
          childAspectRatio: 1.2, // 박스의 너비 대비 높이 비율을 설정
        ),
        itemCount: days.length,
        itemBuilder: (context, index) {
          DateTime day = days[index];

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

  // 선택된 날짜의 정보 표시
  Widget _buildSelectedDayInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0), // 양 옆 간격
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // 왼쪽 정렬
        children: [
          SizedBox(height: MediaQuery.of(context).size.width * 0.1,),
          Text(
            '선택된 날짜: ${_selectedDay!.year}-${_selectedDay!.month}-${_selectedDay!.day}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            _selectedDay != null && _events.containsKey(_selectedDay!)
                ? '스트레스 지수: ${_events[_selectedDay!]!.join(", ")}'
                : '스트레스 지수: 입력된 값이 없습니다.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              _addEventForSelectedDay();
            },
            child: Text('스트레스 데이터 입력'),
          ),
        ],
      ),
    );
  }

  // 스트레스 데이터를 입력할 수 있는 다이얼로그 표시
  void _addEventForSelectedDay() {
    if (_selectedDay != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('스트레스 데이터 입력'),
          content: TextField(
            decoration: InputDecoration(hintText: '스트레스 지수를 입력하세요'),
            onSubmitted: (value) {
              setState(() {
                if (value.isNotEmpty) {
                  if (_events[_selectedDay!] != null) {
                    _events[_selectedDay!]!.add(value);
                  } else {
                    _events[_selectedDay!] = [value];
                  }
                }
              });
              Navigator.of(context).pop();
            },
          ),
        ),
      );
    }
  }
}
