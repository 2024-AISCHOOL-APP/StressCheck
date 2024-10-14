import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class StressMapPage extends StatefulWidget {
  @override
  _StressMapPageState createState() => _StressMapPageState();
}

class _StressMapPageState extends State<StressMapPage> {
  DateTime _focusedDay = DateTime.now(); // 현재 날짜로 초기화
  DateTime? _selectedDay;
  Map<DateTime, List<String>> _events = {}; // 날짜별 이벤트 저장

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[200],
        title: Text('스트레스 켈린더', style: TextStyle(fontSize: 18)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TableCalendar(
              focusedDay: _focusedDay,
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              eventLoader: (day) {
                return _events[day] ?? [];
              },
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                markerDecoration: BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false, // 포맷 변경 버튼 숨김
                titleCentered: true,
                titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16),
            if (_selectedDay != null)
              Column(
                children: [
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

                ],
              ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_selectedDay != null) {
                  _addEventForSelectedDay();
                }
              },
              child: Text('스트레스 데이터 입력'),
            ),
          ],
        ),
      ),
    );
  }

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

