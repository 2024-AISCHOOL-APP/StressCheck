import 'package:flutter/material.dart';
import 'package:flutter_application_stresscheck/app_screen/past_reslut.dart';
import 'package:intl/intl.dart';
import 'result.dart';
import 'first.dart';
import 'mypage.dart';
import 'auth_provider.dart'; // AuthProvider import
import 'package:provider/provider.dart'; // Provider import 추가

// 캘린더
class StressMapPage extends StatefulWidget {
  @override
  _StressMapPageState createState() => _StressMapPageState();
}

class _StressMapPageState extends State<StressMapPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<String, String> _diaryEntries = {}; // 날짜별 일기 데이터를 저장하는 Map
  TextEditingController _diaryController = TextEditingController(); // 다이어리 입력 컨트롤러
  Map<String, double> averageStress = {}; // 날짜별 평균 스트레스 지수 저장

  PageController _pageController = PageController(initialPage: 500); // 중앙을 기준으로 설정
  int _currentPageIndex = 500; // 중앙을 기준으로 페이지 인덱스 초기화

  @override
  void initState() {
    super.initState();

    // Provider에서 분석 정보 가져오기
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final analysisInfo = authProvider.analysisInfo; // 분석 정보 가져오기

    // 분석 정보가 null이거나 비어있는지 체크
    if (analysisInfo != null && analysisInfo.isNotEmpty) {
      // 로그 찍기
      print('분석정보: $analysisInfo');

      // 평균 스트레스 지수 계산
      averageStress = calculateDailyAverages(analysisInfo);

      // 평균 스트레스 로그 찍기
      print('일별 평균 스트레스: $averageStress');
    } else {
      print('Analysis Info is null or empty');
    }
  }

  Map<String, double> calculateDailyAverages(List<dynamic> analysisInfo) {
    Map<String, List<double>> stressPerDay = {};

    // 분석 정보에서 각 날짜의 스트레스 지수를 분류
    for (var entry in analysisInfo) {
      DateTime createdAt = DateTime.parse(entry['created_at']);
      String day = DateFormat('yyyy-MM-dd').format(createdAt);

      if (!stressPerDay.containsKey(day)) {
        stressPerDay[day] = [];
      }
      stressPerDay[day]!.add(entry['stress_index']);
    }

    // 날짜별 평균 계산
    Map<String, double> dailyAverages = {};
    stressPerDay.forEach((day, stressList) {
      double avg = stressList.reduce((a, b) => a + b) / stressList.length;
      dailyAverages[day] = avg;
    });

    return dailyAverages;
  }

  @override
  Widget build(BuildContext context) {
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(height: 16),
                  _buildHeader(),
                  _buildDaysOfWeek(),
                  SizedBox(height: 8),
                  _buildPageViewCalendar(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildCustomBottomAppBar(context),
    );
  }

  Widget _buildHeader() {
    DateTime currentMonth = DateTime(
        _focusedDay.year, _focusedDay.month + (_currentPageIndex - 500));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            _pageController.previousPage(
                duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
          },
        ),
        Text(
          DateFormat.yMMMM().format(currentMonth),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: () {
            _pageController.nextPage(
                duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
          },
        ),
      ],
    );
  }

  Widget _buildDaysOfWeek() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: ['월', '화', '수', '목', '금', '토', '일']
          .map((day) => Text(day,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)))
          .toList(),
    );
  }

  Widget _buildPageViewCalendar() {
    return Expanded(
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (pageIndex) {
          setState(() {
            _currentPageIndex = pageIndex;
          });
        },
        itemBuilder: (context, index) {
          DateTime monthToShow = DateTime(
              _focusedDay.year, _focusedDay.month + (index - 500));
          return _buildCalendarGrid(monthToShow);
        },
      ),
    );
  }

  Widget _buildCalendarGrid(DateTime displayMonth) {
    List<DateTime> daysInMonth = _daysInMonth(displayMonth);
    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 0.6,
      ),
      itemCount: daysInMonth.length,
      itemBuilder: (context, index) {
        DateTime day = daysInMonth[index];

        if (day.year == 0) {
          return Container();
        }

        bool isToday = _isSameDay(day, DateTime.now());
        bool isSelected = _selectedDay != null && _isSameDay(day, _selectedDay!);
        String formattedDate = _formatDate(day);
        String imagePath = '';

        // 평균 스트레스 지수에 따라 이미지 선택
        if (averageStress.containsKey(formattedDate)) {
          double avgStress = averageStress[formattedDate]!;
          if (avgStress >= 49 && avgStress <= 53) {
            imagePath = 'image/soso.png';
          } else if (avgStress < 49) {
            imagePath = 'image/happy.png';
          } else {
            imagePath = 'image/angry.png';
          }
        }

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedDay = day;
              _diaryController.text = _diaryEntries[formattedDate] ?? ''; // 선택된 날짜의 다이어리 불러오기
            });
            _showDiaryDialog(); // 날짜를 누르면 다이어리 팝업 표시
          },
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 3,
                  offset: Offset(0, 0),
                ),
              ],
              color: isSelected
                  ? Colors.grey
                  : (isToday ? Colors.blue[100] : Colors.white),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              children: [
                SizedBox(height: 8),
                Text(
                  '${day.day}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.black : Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                imagePath.isNotEmpty
                    ? Image.asset(
                        imagePath,
                        width: MediaQuery.of(context).size.width * 0.15,
                        height: MediaQuery.of(context).size.height * 0.05,
                        fit: BoxFit.contain,
                      )
                    : SizedBox(height: MediaQuery.of(context).size.height * 0.05), // 이미지가 없을 경우 빈 공간으로 설정
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDiaryDialog() {
    showDialog(
      context: context,
      barrierDismissible: true, // 다이어리 팝업 외부 터치 시 닫힘
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              DateFormat.yMMMMd().format(_selectedDay!),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          content: Container(
            decoration: BoxDecoration(
              color: Colors.blue[50], // 배경색 설정 (원하는 색으로 설정 가능)
              borderRadius: BorderRadius.circular(8), // 모서리 둥글게 설정
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 2), // 그림자 위치
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0), // 텍스트와 테두리 사이의 여백
              child: TextField(
                controller: _diaryController,
                maxLines: 4,
                onChanged: (text) {
                  setState(() {
                    _diaryEntries[_formatDate(_selectedDay!)] = text; // 다이어리 내용 저장
                  });
                },
                decoration: InputDecoration(
                  hintText: '오늘은 무슨일이 있었나요?',
                  border: InputBorder.none, // 외곽선 제거
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 팝업 닫기
              },
              child: Text(
                '확인',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  // 날짜를 yyyy-MM-dd 형식으로 변환하는 함수
  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  // 두 날짜가 같은 날인지 확인하는 함수
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  List<DateTime> _daysInMonth(DateTime date) {
    final firstDay = DateTime(date.year, date.month, 1);
    final lastDay = DateTime(date.year, date.month + 1, 0);

    int totalDays = lastDay.day;
    List<DateTime> days = [];
    for (int i = 0; i < firstDay.weekday - 1; i++) {
      days.add(DateTime(0));
    }
    for (int i = 1; i <= totalDays; i++) {
      days.add(DateTime(date.year, date.month, i));
    }
    while (days.length % 7 != 0) {
      days.add(DateTime(0));
    }
    return days;
  }

  Widget _buildCustomBottomAppBar(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      currentIndex: 1,
      onTap: (index) {
        if (index == 0) {
           Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => First()),
          );
        } else if (index == 1) {
         
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
}
