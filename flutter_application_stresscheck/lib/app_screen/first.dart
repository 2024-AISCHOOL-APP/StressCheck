import 'package:flutter/material.dart';
import 'package:flutter_application_stresscheck/app_screen/mypage.dart';
import 'package:flutter_application_stresscheck/app_screen/past_reslut.dart';
import 'package:flutter_application_stresscheck/app_screen/result.dart';
import 'package:flutter_application_stresscheck/app_screen/stress_map.dart';
import 'package:fl_chart/fl_chart.dart'; // fl_chart 임포트
import 'package:intl/intl.dart'; // 날짜 포맷 변환 임포트
import 'package:provider/provider.dart';
import 'auth_provider.dart'; // AuthProvider import

class First extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // AuthProvider에서 analysisInfo 가져오기
    final authProvider = Provider.of<AuthProvider>(context);
    final analysisInfo = authProvider.analysisInfo ?? []; // 스트레스 정보를 가져옵니다.

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // 배경 이미지 추가
            Image.asset(
              'image/bg.png',
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(height: 16),
                      hourlyStressGraph(context, analysisInfo), // 1시간 단위 스트레스 그래프 위젯
                      SizedBox(height: 16),
                      stressGraph(context, analysisInfo), // 주간 스트레스 그래프 위젯
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildCustomBottomAppBar(context), // 커스텀 하단 내비게이션 바
    );
  }

  Widget stressGraph(BuildContext context, List<dynamic> analysisInfo) {
    // 최근 7일 데이터의 하루 평균 스트레스 지수 계산
    Map<String, double> dailyAverages = calculateDailyAverages(analysisInfo);

    // 받은 데이터 확인을 위한 프린트 문 추가
    print("받아온 스트레스 정보: $analysisInfo");
    print("일일 평균 스트레스 지수: $dailyAverages");

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0), // 모서리를 둥글게
        color: Colors.white, // 배경색을 흰색으로 설정
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1), // 그림자 색상 설정
            spreadRadius: 2, // 그림자의 퍼짐 정도
            blurRadius: 3, // 그림자의 블러 정도
            offset: Offset(0, 0), // 그림자의 위치 설정
          ),
        ],
      ),
      padding: EdgeInsets.all(16.0), // 전체 패딩 설정
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // 중앙 정렬
        children: [
          // 그래프 제목 설정
          Text('주간 스트레스 지수',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w600)), // 제목 스타일 설정
          SizedBox(height: 8), // 제목과 그래프 사이의 간격 조정
          Container(
            height: 300, // 그래프의 높이를 설정
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true), // 그리드 표시 설정
                borderData: FlBorderData(show: true), // 그래프 테두리 표시 설정
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true, // x축 제목 표시 설정
                      reservedSize: 38, // x축 제목 공간 예약
                      getTitlesWidget: (value, meta) {
                        // x축에 표시할 날짜를 반환하는 함수
                        int intValue = value.round(); // 값 반올림
                        DateTime date = DateTime.now().subtract(
                            Duration(days: 6 - intValue)); // 최근 6일 중 해당하는 날짜 계산
                        String day =
                            DateFormat('MM-dd').format(date); // 날짜 형식 설정
                        return SideTitleWidget(
                          axisSide: meta.axisSide, // 해당 축의 위치
                          child: Text(day,
                              style: TextStyle(fontSize: 12)), // 날짜 텍스트 설정
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true, // y축 제목 표시 설정
                      reservedSize: 40, // y축 제목 공간 예약
                      getTitlesWidget: (value, meta) {
                        // y축에 표시할 스트레스 지수 반환
                        return Text(value.toInt().toString(),
                            style: TextStyle(fontSize: 12)); // y축 값 텍스트 설정
                      },
                    ),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: false, // 선을 곡선으로 표시
                    spots: dailyAverages.entries.map((entry) {
                      // 평균 스트레스 지수를 FlSpot으로 변환하여 그래프에 표시
                      int index = dailyAverages.keys
                          .toList()
                          .indexOf(entry.key); // 날짜에 대한 인덱스 계산
                      return FlSpot(index.toDouble(), entry.value); // FlSpot 생성
                    }).toList(),
                    barWidth: 3, // 선 두께 설정
                    isStrokeCapRound: true, // 선의 끝을 둥글게
                    dotData: FlDotData(show: false), // 점 데이터 표시 여부
                  ),
                ],
                minY: 45, // y축 최소값 설정
                maxY: 60, // y축 최대값 설정
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, double> calculateDailyAverages(List<dynamic> analysisInfo) {
    Map<String, List<double>> stressPerDay = {};
    DateTime now = DateTime.now();

    // 최근 7일치 데이터만 필터링
    for (var entry in analysisInfo) {
      DateTime createdAt = DateTime.parse(entry['created_at']);
      if (now.difference(createdAt).inDays < 7) { // 7일 이내 데이터만 선택
        String day = DateFormat('yyyy-MM-dd').format(createdAt);
        if (!stressPerDay.containsKey(day)) {
          stressPerDay[day] = [];
        }
        stressPerDay[day]!.add(entry['stress_index']);
      }
    }

    // 날짜별 평균 계산
    Map<String, double> dailyAverages = {};
    stressPerDay.forEach((day, stressList) {
      double avg = stressList.reduce((a, b) => a + b) / stressList.length;
      dailyAverages[day] = avg;
    });

    return dailyAverages;
  }

  Widget hourlyStressGraph(BuildContext context, List<dynamic> analysisInfo) {
  // 시간별 스트레스 지수 저장
  Map<int, double?> hourlyData = Map.fromIterable(
    List.generate(24, (index) => index),
    key: (item) => item as int,
    value: (item) => null, // 초기값은 null로 설정
  );

  // 오늘 날짜의 시작 시간을 가져옵니다.
  DateTime today = DateTime.now();
  DateTime todayStart = DateTime(today.year, today.month, today.day);

  // 분석 정보에서 각 시간에 대한 스트레스 지수 추출
  for (var entry in analysisInfo) {
    DateTime createdAt = DateTime.parse(entry['created_at']);
    if (createdAt.isAfter(todayStart)) { // 오늘 날짜의 데이터만 선택
      int hour = createdAt.hour;
      hourlyData[hour] = entry['stress_index']; // 해당 시간의 스트레스 지수 저장
    }
  }

  // 현재 날짜 가져오기
  String formattedDate = DateFormat('yyyy-MM-dd').format(today);

  // 받은 데이터 확인을 위한 프린트 문 추가
  print("받아온 스트레스 정보: $analysisInfo");
  print("1시간 단위 스트레스 지수: $hourlyData");

  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20.0), // 모서리를 둥글게
      color: Colors.white, // 배경색을 흰색으로 설정
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1), // 그림자 색상 설정
          spreadRadius: 2, // 그림자의 퍼짐 정도
          blurRadius: 3, // 그림자의 블러 정도
          offset: Offset(0, 0), // 그림자의 위치 설정
        ),
      ],
    ),
    padding: EdgeInsets.all(16.0), // 전체 패딩 설정
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center, // 중앙 정렬
      children: [
        // 그래프 제목 설정
        Text('하루의 스트레스 지수 ',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)), // 제목 스타일 설정
        SizedBox(height: 8),
        Text('($formattedDate)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)), // 제목과 그래프 사이의 간격 조정
        SizedBox(height: 8), // 제목과 그래프 사이의 간격 조정
        Container(
          height: 300, // 그래프의 높이를 설정
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: true), // 그리드 표시 설정
              borderData: FlBorderData(show: true), // 그래프 테두리 표시 설정
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true, // x축 제목 표시 설정
                    reservedSize: 38, // x축 제목 공간 예약
                    getTitlesWidget: (value, meta) {
                      // x축에 표시할 시간을 반환하는 함수
                      int hour = value.toInt(); // 시간 정수 변환
                      if (hourlyData[hour] != null) { // 해당 시간에 데이터가 있을 경우
                        return SideTitleWidget(
                          axisSide: meta.axisSide, // 해당 축의 위치
                          child: Text('$hour', style: TextStyle(fontSize: 12)), // 시간 텍스트 설정
                        );
                      }
                      return SizedBox.shrink(); // 데이터가 없으면 빈 위젯 반환
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true, // y축 제목 표시 설정
                    reservedSize: 40, // y축 제목 공간 예약
                    getTitlesWidget: (value, meta) {
                      // y축에 표시할 스트레스 지수 반환
                      return Text(value.toInt().toString(), style: TextStyle(fontSize: 12)); // y축 값 텍스트 설정
                    },
                  ),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  isCurved: false, // 선을 곡선으로 표시
                  spots: hourlyData.entries.map((entry) {
                    // 각 시간에 대한 스트레스 지수로 FlSpot 생성
                    if (entry.value != null) {
                      return FlSpot(entry.key.toDouble(), entry.value!); // FlSpot 생성
                    }
                    return null; // 값이 없으면 null 반환
                  }).whereType<FlSpot>().toList(), // null 값 제거
                  barWidth: 3, // 선 두께 설정
                  isStrokeCapRound: true, // 선의 끝을 둥글게
                  dotData: FlDotData(show: false), // 점 데이터 표시 여부
                ),
              ],
              minY: 40, // y축 최소값 설정
              maxY: 60, // y축 최대값 설정
            ),
          ),
        ),
      ],
    ),
  );
}


  Widget _buildCustomBottomAppBar(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      currentIndex: 0,
      onTap: (index) {
        // 각 페이지로 네비게이션
        if (index == 0) {
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
}
