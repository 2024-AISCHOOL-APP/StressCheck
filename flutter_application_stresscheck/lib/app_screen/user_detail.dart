import 'package:flutter/material.dart';
import 'package:flutter_application_stresscheck/app_screen/auth_provider.dart';
import 'package:provider/provider.dart';  // Provider 사용을 위해 import
import 'package:flutter_application_stresscheck/app_screen/mypage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserDetailPage extends StatefulWidget {
  @override
  _UserDetailPageState createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  String gender = ""; // 성별 정보 저장
  DateTime birthDate = DateTime(2000, 1, 1); // 기본 생년월일 설정
  RangeValues sleepTimeRange = RangeValues(18.0, 42.0); // 18시부터 다음날 18시로 초기 설정
  String selectedJob = ""; // 선택된 직업
  List<String> jobList = ["태초마을 오박사", "지우라고 했지!", "챔피언 레드", "버려진 피죤투", "레드의 거북왕", "레드 친구 그린", "로켓단 간부", "로켓단 마자용", "강가의 잉어킹"]; // 미리 정의된 직업 리스트
  List<String> hobbies = [""]; // 취미 저장 리스트
  final int maxHobbies = 3; // 최대 취미 개수

  Future<void> _saveUserDetails() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final String? userId = authProvider.userId;  // 로그인한 사용자의 userId

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인이 필요합니다.')),
      );
      return; // userId가 없으면 저장 불가
    }

    String genderValue = (gender == "남성") ? "M" : "F"; // 성별 변환
    int sleepDuration = sleepTimeRange.end > sleepTimeRange.start
        ? (sleepTimeRange.end - sleepTimeRange.start).round()
        : (24 - sleepTimeRange.start + sleepTimeRange.end).round(); // 수면시간 계산

    List<Map<String, dynamic>> hobbiesData = [];
    for (int i = 0; i < hobbies.length; i++) {
      if (hobbies[i].isNotEmpty) {
        hobbiesData.add({
          'hobby_idx': i + 1,  // 인덱스는 1부터 시작
          'user_hobby': hobbies[i]
        });
      }
    }

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/auth/user/update'),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
      },
      body: json.encode({
        'user_id': userId,
        'user_gender': genderValue,
        'user_birthdate': '${birthDate.year}-${birthDate.month}-${birthDate.day}',
        'user_job': selectedJob,
        'user_sleep': sleepDuration,
        'hobbies': hobbiesData,  // 취미 데이터를 리스트로 보냄
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('회원 정보가 저장되었습니다.')),
      );
    } else {
      final errorData = json.decode(utf8.decode(response.bodyBytes));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('저장 실패: ${errorData['detail']}')),
      );
      print("Error: ${response.statusCode} - ${errorData['detail']}");
    }
  }

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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GenderSelection(
                      selectedGender: gender,
                      onGenderChanged: (value) {
                        setState(() {
                          gender = value;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    AgeInput(
                      birthDate: birthDate,
                      onBirthDateChanged: (value) {
                        setState(() {
                          birthDate = value;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    HobbiesInput(
                      hobbies: hobbies,
                      maxHobbies: maxHobbies,
                      onHobbyChanged: (index, value) {
                        setState(() {
                          hobbies[index] = value;
                          if (value.isNotEmpty &&
                              index == hobbies.length - 1 &&
                              hobbies.length < maxHobbies) {
                            hobbies.add(""); // 자동으로 새로운 취미 필드 추가
                          }
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    JobSelection(
                      selectedJob: selectedJob,
                      jobList: jobList,
                      onJobChanged: (value) {
                        setState(() {
                          selectedJob = value;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    SleepTimeSlider(
                      sleepTimeRange: sleepTimeRange,
                      onSleepTimeChanged: (value) {
                        setState(() {
                          sleepTimeRange = value;
                        });
                      },
                    ),
                    SizedBox(height: 32),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[50],
                          foregroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                        ),
                        onPressed: _saveUserDetails, // 저장 버튼 눌렀을 때
                        child: Text('저장', style: TextStyle(fontSize: 16)),
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
}

class GenderSelection extends StatelessWidget {
  final String selectedGender;
  final Function(String) onGenderChanged;

  const GenderSelection({
    required this.selectedGender,
    required this.onGenderChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('성별', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        Row(
          children: [
            Radio<String>(
              value: '남성',
              groupValue: selectedGender,
              onChanged: (value) {
                onGenderChanged(value!);
              },
            ),
            Text('남성', style: TextStyle(fontSize: 18)),
            SizedBox(width: 16),
            Radio<String>(
              value: '여성',
              groupValue: selectedGender,
              onChanged: (value) {
                onGenderChanged(value!);
              },
            ),
            Text('여성', style: TextStyle(fontSize: 18)),
          ],
        ),
      ],
    );
  }
}

class AgeInput extends StatelessWidget {
  final DateTime birthDate;
  final Function(DateTime) onBirthDateChanged;

  const AgeInput({
    required this.birthDate,
    required this.onBirthDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('생년월일', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: () async {
              DateTime? selectedDate = await showDatePicker(
                context: context,
                initialDate: birthDate,
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (selectedDate != null) {
                onBirthDateChanged(selectedDate);
              }
            },
            child: AbsorbPointer(
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  labelText: '생년월일 선택',
                  labelStyle: TextStyle(color: Colors.grey),
                ),
                controller: TextEditingController(
                  text: "${birthDate.year}년 ${birthDate.month}월 ${birthDate.day}일",
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class JobSelection extends StatelessWidget {
  final String selectedJob;
  final List<String> jobList;
  final Function(String) onJobChanged;

  const JobSelection({
    required this.selectedJob,
    required this.jobList,
    required this.onJobChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('직업', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        SizedBox(width: 16),
        Expanded(
          child: DropdownButton<String>(
            value: selectedJob.isEmpty ? null : selectedJob,
            isExpanded: true,
            items: jobList.map((String job) {
              return DropdownMenuItem<String>(
                value: job,
                child: Text(job),
              );
            }).toList(),
            onChanged: (value) {
              onJobChanged(value!);
            },
          ),
        ),
      ],
    );
  }
}

class HobbiesInput extends StatelessWidget {
  final List<String> hobbies;
  final int maxHobbies;
  final Function(int, String) onHobbyChanged;

  const HobbiesInput({
    required this.hobbies,
    required this.maxHobbies,
    required this.onHobbyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...List.generate(hobbies.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                Text('취미 ${index + 1}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none, // 테두리 없음
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black), // 선택 시 밑줄 검정색
                      ),
                      labelText: '취미 입력',
                      labelStyle: TextStyle(color: Colors.grey),
                    ),
                    onChanged: (value) {
                      onHobbyChanged(index, value);
                    },
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class SleepTimeSlider extends StatelessWidget {
  final RangeValues sleepTimeRange;
  final Function(RangeValues) onSleepTimeChanged;

  const SleepTimeSlider({
    required this.sleepTimeRange,
    required this.onSleepTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('수면 시간 설정 (시)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        SizedBox(height: 16),
        RangeSlider(
          values: sleepTimeRange,
          min: 18,
          max: 42,
          divisions: 24,
          labels: RangeLabels(
            '${(sleepTimeRange.start % 24).round()}시',
            '${(sleepTimeRange.end % 24).round()}시',
          ),
          activeColor: Colors.blue[50],
          inactiveColor: Colors.blue[50],
          onChanged: (values) {
            onSleepTimeChanged(values);
          },
        ),
        Center(
          child: Text(
            '수면 시간: ${_calculateSleepDuration(sleepTimeRange).round()} 시간',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  double _calculateSleepDuration(RangeValues values) {
    double start = values.start;
    double end = values.end;
    return end > start ? end - start : (24 - start) + end;
  }
}
