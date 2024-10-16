import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'stress_map.dart'; // stress_map 페이지 임포트

class ResultPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedTime =
        DateFormat('MM월 dd일 HH:mm').format(now); // 'MM월 dd일 HH:mm' 형식으로 시간 포맷팅

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[200],
        title: Row(
          children: [
            Expanded(child: Container()),
            Text('임재환 님', style: TextStyle(fontSize: 18)),
          ],
        ),
        centerTitle: false,
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
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formattedTime, // 현재 시간을 표시
                      style: TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '26세 남성',
                      style: TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.blue[100],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4), // 그림자 색상
                        spreadRadius: 3, // 그림자 퍼짐 정도
                        blurRadius: 7, // 그림자 흐림 정도
                        offset: Offset(0, 3), // 그림자의 위치 (x축, y축)
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // 첫 번째 Row (심박수, 산소포화도)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start, // 왼쪽 끝 정렬
                        children: [
                          SizedBox(width: 10),
                          Text('심박수', style: TextStyle(fontSize: 20)),
                          SizedBox(width: 8),
                          Text('90',
                              style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(width: 8),
                          Text('BPM', style: TextStyle(fontSize: 20)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 15),
                          Text('산소포화도', style: TextStyle(fontSize: 20)),
                          SizedBox(width: 8), // 간격 조절
                          Text('90',
                              style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(width: 8),
                          Text('BPM', style: TextStyle(fontSize: 20)),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('체온:  ', style: TextStyle(fontSize: 25)),
                          Text('36.5 ',
                              style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold)),
                          Text('도', style: TextStyle(fontSize: 25)),
                          SizedBox(width: 15),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('혈압:  ', style: TextStyle(fontSize: 25)),
                          Text('118 ',
                              style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold)),
                          Text('mmHg', style: TextStyle(fontSize: 25)),
                          SizedBox(width: 10),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('오늘의 스트레스 상태는',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('보통',
                                      style: TextStyle(
                                          fontSize: 36,
                                          fontWeight: FontWeight.bold)),
                                  Text('  이에요',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text('42',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: 60,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange)),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Center(
                        child: Image.asset(
                          'image/stress_emoji.png',
                          width: 100,
                          height: 100,
                        ),
                      ),
                      Center(
                        child: Text('이런 기분도 나쁘지 않아요.',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StressMapPage()),
                      );
                    },
                    child: Text('캘린더로 이동'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
