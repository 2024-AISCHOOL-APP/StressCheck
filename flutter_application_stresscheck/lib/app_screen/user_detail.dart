import 'package:flutter/material.dart';
import 'package:flutter_application_stresscheck/app_screen/mypage.dart';

class UserDetailPage extends StatefulWidget {
  @override
  _UserDetailPageState createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  String gender = ""; // 성별 정보 저장
  int age = 20; // 기본 나이 설정
  RangeValues sleepTimeRange = RangeValues(18.0, 42.0); // 18시부터 다음날 18시로 초기 설정
  String selectedJob = "학생 1"; // 직업 정보 저장

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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView( // 스크롤 가능하도록 설정
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 성별 선택 (라디오 버튼으로 변경)
                    Text(
                      '성별',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Radio<String>(
                          value: '남성',
                          groupValue: gender,
                          onChanged: (String? value) {
                            setState(() {
                              gender = value!;
                            });
                          },
                        ),
                        Text('남성', style: TextStyle(fontSize: 18)),
                        SizedBox(width: 16),
                        Radio<String>(
                          value: '여성',
                          groupValue: gender,
                          onChanged: (String? value) {
                            setState(() {
                              gender = value!;
                            });
                          },
                        ),
                        Text('여성', style: TextStyle(fontSize: 18)),
                      ],
                    ),
                    SizedBox(height: 16),
                    // 나이 입력
                    Text(
                      '나이',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '나이를 입력하세요',
                      ),
                      onChanged: (value) {
                        setState(() {
                          age = int.tryParse(value) ?? 0;
                        });
                      },
                    ),
                    SizedBox(height: 16),

                    // 직업 선택 (드롭다운)
                    Text(
                      '직업 선택',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    DropdownButton<String>(
                      value: selectedJob,
                      isExpanded: true,
                      items: List.generate(20, (index) => "학생 ${index + 1}")
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedJob = newValue!;
                        });
                      },
                    ),
                    SizedBox(height: 16),

                    // 수면 시간 설정 (Range Slider 사용)
                    Text(
                      '수면 시간 설정 (시)',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    RangeSlider(
                      values: sleepTimeRange,
                      min: 18, // 오후 18시부터 시작
                      max: 42, // 다음날 오후 18시까지
                      divisions: 24,
                      labels: RangeLabels(
                        '${(sleepTimeRange.start % 24).round()}시',
                        '${(sleepTimeRange.end % 24).round()}시',
                      ),
                      onChanged: (RangeValues values) {
                        setState(() {
                          sleepTimeRange = values;
                        });
                      },
                    ),

                    SizedBox(height: 8),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
                        children: [
                          Text(
                            '${(sleepTimeRange.start % 24).round()}시 ~ ${(sleepTimeRange.end % 24).round()}시',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 8),
                    Center(
                      child: Text(
                        '수면 시간: ${_calculateSleepDuration().round()} 시간',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(height: 32),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[50], // 버튼 배경색
                              foregroundColor: Colors.black, // 글씨 색
                              padding: EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 8), // 패딩 설정
                            ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MyPage()), // 저장 후 마이페이지로 이동
                          );
                        },
                        child: Text('저장',style: TextStyle(fontSize: 16),),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 수면 시간 계산 함수
  double _calculateSleepDuration() {
    double start = sleepTimeRange.start;
    double end = sleepTimeRange.end;
    return end > start ? end - start : (24 - start) + end;
  }
}
